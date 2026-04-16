
{
  pkgs
  , color ? "-Light"
  , subcolor ? "-Teal"
  , colorTweak ? ""
}:

assert pkgs.lib.elem color [ "-Dark" "-Light" "" ];
assert pkgs.lib.elem subcolor [ "-Orange" "-Pink" "-Purple" "-Red" "-Teal" "-Yellow" "-Blue" "-Green" "-Grey"];
assert pkgs.lib.elem colorTweak [ "-Soft" "-Medium" "" ];

let
  thumbnailColor = if color == "-Light" then "" else "-Dark";
  themeName = "Muted${color}${subcolor}${colorTweak}";
in

pkgs.stdenvNoCC.mkDerivation {
  pname = "Muted-GTK";
  version = "0.1";

  src = ./.;

  nativeBuildInputs = [
    pkgs.sassc
  ];
  buildInputs = [ pkgs.gnome-themes-extra ];
  

  buildPhase = ''
    runHook preBuild
    
    mkdir -p build/gtk-3.0 build/gtk-4.0
    
    
    # Index Theme File
    echo "Type=X-GNOME-Metatheme" >> build/index.theme
    echo "[Desktop Entry]" >> build/index.theme
    echo "Name=${themeName}" >> build/index.theme
    echo "Comment=Gtk+ design for that paper-like look" >> build/index.theme
    echo "Encoding=UTF-8" >> build/index.theme
    echo "" >> build/index.theme
    echo "[X-GNOME-Metatheme]" >> build/index.theme
    echo "GtkTheme=${themeName}" >> build/index.theme
    echo "MetacityTheme=${themeName}" >> build/index.theme
    echo "IconTheme=Tela-circle${color}" >> build/index.theme
    echo "CursorTheme=Muted-cursors" >> build/index.theme
    echo "ButtonLayout=close,minimize,maximize:menu" >> build/index.theme
    
    # GTK 3.0
    cp -r themes/src/assets/gtk/assets${subcolor}${colorTweak} build/gtk-3.0/assets
    cp -r themes/src/assets/gtk/scalable build/gtk-3.0/assets
    cp -r themes/src/assets/gtk/thumbnails/thumbnail${subcolor}${colorTweak}${thumbnailColor}.png build/gtk-3.0/thumbnail.png
    sassc themes/src/main/gtk-3.0/gtk${color}.scss build/gtk-3.0/gtk.css
    sassc themes/src/main/gtk-3.0/gtk-Dark.scss build/gtk-3.0/gtk-dark.css
    
    # GTK 4.0
    cp -r themes/src/assets/gtk/scalable build/gtk-4.0/assets
    cp -r themes/src/assets/gtk/thumbnails/thumbnail${subcolor}${colorTweak}${thumbnailColor}.png build/gtk-4.0/thumbnail.png
    sassc themes/src/main/gtk-4.0/gtk${color}.scss build/gtk-4.0/gtk.css
    sassc themes/src/main/gtk-4.0/gtk-Dark.scss build/gtk-4.0/gtk-dark.css
    runHook postBuild
  '';


  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/themes/${themeName}/gtk-3.0" "$out/share/themes/${themeName}/gtk-4.0"
    
    cp -r build/gtk-4.0/* "$out/share/themes/${themeName}/gtk-4.0/"
    cp -r build/gtk-3.0/* "$out/share/themes/${themeName}/gtk-3.0/"
    cp build/index.theme "$out/share/themes/${themeName}/index.theme"
    
    runHook postInstall
  '';
}
