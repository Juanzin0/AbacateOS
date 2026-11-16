# 🥑 AbacateOS 1.0

Distribuição Linux baseada em **Debian 13 (trixie)**, 64 bits, em duas edições com visual inspirado no Windows 11
(barra de tarefas com ícones centralizados, botão Iniciar no centro, tema escuro Fluent).

| | **AbacateOS Lite** | **AbacateOS Normal** |
|---|---|---|
| RAM | mínimo **1 GB** (ideal 2 GB) | **4 GB ou mais** |
| Desktop | XFCE + Whisker Menu + Docklike | KDE Plasma 6 |
| Barra | painel 46 px, ícones centralizados | painel flutuante 48 px, ícones centralizados |
| Tema | Fluent (reserva: Arc-Dark) | Fluent KDE (reserva: Breeze Dark) |
| Ícones | Fluent (reserva: Papirus-Dark) | Fluent (reserva: Papirus-Dark) |
| Apps extras | Mousepad, Ristretto, Atril | LibreOffice, VLC, Okular, Gwenview, Kate |
| Otimização | zram 60%, swappiness 100, `preload`, sem compositor, I/O por tipo de disco | zram 25%, swappiness 60, indexador (Baloo) desligado |

Ambas incluem Firefox ESR, instalador gráfico Calamares, `earlyoom`, zram e journald só na RAM.

## Gerar as ISOs

Em uma máquina **Debian/Ubuntu** (pode ser VM) com ~20 GB livres e internet:

```bash
sudo ./build.sh lite      # AbacateOS Lite
sudo ./build.sh normal    # AbacateOS Normal
sudo ./build.sh all       # as duas
```

As ISOs saem em `out/`. Teste em VM (VirtualBox/QEMU) antes de gravar no pendrive com Balena Etcher.

## Uso

- Usuário do live: `abacate` · senha: `live`
- Instalar no disco: **Calamares** no menu Iniciar
- `abacate-info` → mostra RAM, zram e processos mais pesados
- `sudo abacate-lite` → libera cache e para serviços extras

## Como funciona o visual Windows 11

- Durante o build, os temas **Fluent** (vinceliuice no GitHub) são baixados. Se a rede falhar, o sistema usa os temas de
  reserva automaticamente, então a ISO sempre gera.
- **Lite:** `xfce4-panel.xml` coloca separadores expansíveis dos dois lados do Iniciar + Docklike, o que centraliza os
  ícones; bandeja, volume, bateria e relógio ficam à direita. Botões de janela à direita (`|HMC`).
- **Normal:** no primeiro login, `abacate-plasma-setup` aplica `plasma-layout.js` (painel flutuante, espaçadores,
  Kickoff, ícones das tarefas, bandeja e relógio) e o papel de parede.
- O ícone do Iniciar é um abacate próprio (`abacateos-start.svg`), não o logo do Windows.

## Estrutura

```
auto/                       config/build/clean do live-build (edição via ABACATE_EDITION)
common/                     tudo que as duas edições compartilham
editions/lite/              pacotes, painel XFCE e tema do Lite
editions/normal/            pacotes, layout Plasma e tema do Normal
build.sh                    monta common + edição e gera a ISO
```

## Observações

- **Não testado de ponta a ponta:** os scripts, XMLs e hooks foram validados, mas o build completo da ISO precisa
  de internet e de um host Debian/Ubuntu. Se algum pacote mudar de nome no repositório, o `lb build` avisa qual.
- O menu Iniciar do XFCE (Whisker) e o do Plasma (Kickoff) abrem perto do botão. Não são flutuantes como no Windows 11.
- **PCs de 32 bits:** o Debian 13 não tem mais kernel i386.
- **Mais velocidade no Lite:** adicione `mitigations=off` em `--bootappend-live` no `auto/config` (reduz proteções
  contra Spectre/Meltdown; só para PCs sem dados sensíveis).

## Gerar a ISO sem ter Linux (GitHub Actions)

1. Crie um repositório no GitHub e envie o conteúdo desta pasta (incluindo `.github/`).
2. Aba **Actions → Gerar ISO do AbacateOS → Run workflow**, escolha `lite` ou `normal`.
3. Quando terminar (30–90 min), baixe a ISO em **Artifacts** na página da execução (fica 7 dias).

## Instalador e verificações (revisão)

- O menu de aplicativos contém **Instalar AbacateOS**, que inicia o Calamares via `pkexec`.
- O instalador deve ser testado em máquina virtual antes de instalar em disco real.
- Firmware Broadcom/AMD e driver Radeon legado foram adicionados às listas de pacotes.
- A identidade Debian em `/etc/os-release` é preservada para compatibilidade com ferramentas.
- O build falha se não encontrar a ISO e o GitHub Actions gera SHA256SUMS.
- O pacote fornecido é **código-fonte**, não ISO compilada. Requer internet e `live-build` em Debian/Ubuntu.
- A disponibilidade dos nomes dos pacotes no Debian 13 e o funcionamento do Calamares **ainda precisam ser verificados no build real**.
