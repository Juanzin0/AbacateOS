// Layout estilo Windows 11 para o KDE Plasma: icones centralizados na barra inferior.
// Aplicado uma vez no primeiro login por /usr/local/bin/abacate-plasma-setup.

// remove paineis existentes
var old = panels();
for (var i = 0; i < old.length; i++) { old[i].remove(); }

var panel = new Panel();
panel.location = "bottom";
panel.height = 48;
try { panel.floating = true; } catch (e) {}

// espacador esquerdo -> empurra o miolo para o centro
panel.addWidget("org.kde.plasma.panelspacer");

// botao Iniciar (icone do abacate)
var start = panel.addWidget("org.kde.plasma.kickoff");
try {
    start.currentConfigGroup = ["General"];
    start.writeConfig("icon", "abacateos-start");
} catch (e) {}

// apps fixados / abertos, somente icones
var tasks = panel.addWidget("org.kde.plasma.icontasks");
try {
    tasks.currentConfigGroup = ["General"];
    tasks.writeConfig("launchers", [
        "applications:firefox-esr.desktop",
        "applications:org.kde.dolphin.desktop",
        "applications:org.kde.konsole.desktop",
        "applications:org.kde.kate.desktop"
    ]);
    tasks.writeConfig("iconSpacing", 2);
} catch (e) {}

// espacador direito
panel.addWidget("org.kde.plasma.panelspacer");

// bandeja + relogio a direita
panel.addWidget("org.kde.plasma.systemtray");
var clock = panel.addWidget("org.kde.plasma.digitalclock");
try {
    clock.currentConfigGroup = ["Appearance"];
    clock.writeConfig("showDate", true);
    clock.writeConfig("dateFormat", "shortDate");
} catch (e) {}

// papel de parede
var ds = desktops();
for (var j = 0; j < ds.length; j++) {
    var d = ds[j];
    d.wallpaperPlugin = "org.kde.image";
    d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    d.writeConfig("Image", "file:///usr/share/backgrounds/abacateos/bloom.svg");
}
