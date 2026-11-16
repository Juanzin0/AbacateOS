#!/bin/sh
# Gera as ISOs do AbacateOS.
#   sudo ./build.sh lite      -> AbacateOS Lite   (minimo 1 GB de RAM)
#   sudo ./build.sh normal    -> AbacateOS Normal (recomendado 4 GB ou mais)
#   sudo ./build.sh all       -> as duas
set -e

EDITION="${1:-}"
case "$EDITION" in
	lite|normal) LIST="$EDITION" ;;
	all)         LIST="lite normal" ;;
	*) echo "Uso: sudo ./build.sh [lite|normal|all]"; exit 1 ;;
esac

if [ "$(id -u)" -ne 0 ]; then
	echo "Execute como root: sudo ./build.sh $EDITION"
	exit 1
fi

ROOT="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$ROOT/out"

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y live-build debootstrap debian-archive-keyring squashfs-tools xorriso isolinux syslinux-common \
	grub-pc-bin grub-efi-amd64-bin mtools dosfstools

for ED in $LIST; do
	echo "==================== Montando edicao: $ED ===================="
	WORK="$ROOT/build/$ED"
	rm -rf "$WORK"
	mkdir -p "$WORK/config"
	cp -a "$ROOT/auto" "$WORK/auto"
	# camada comum + camada da edicao (a edicao sobrescreve o comum)
	cp -a "$ROOT/common/." "$WORK/config/"
	cp -a "$ROOT/editions/$ED/." "$WORK/config/"
	chmod +x "$WORK"/auto/* "$WORK"/config/hooks/live/*.hook.chroot

	cd "$WORK"
	export ABACATE_EDITION="$ED"
	lb clean --purge 2>/dev/null || true
	lb config
	lb build
	set -- ./*.iso
	if [ ! -f "$1" ]; then
		echo "ERRO: o live-build terminou sem gerar ISO para $ED" >&2
		exit 1
	fi
	mv -- ./*.iso "$ROOT/out/"
	cd "$ROOT"
done

echo
ls -lh "$ROOT"/out/*.iso
echo "Pronto! Grave a ISO em um pendrive com o Balena Etcher ou com 'dd'."
