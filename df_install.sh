#!/bin/bash

DF_URL="https://www.bay12games.com/dwarves/df_47_04_linux.tar.bz2"
DF_TAR=/tmp/df.tar.bz2
DF_HOME="$HOME/.local/opt/dwarf-fortress"
ICON_URL="https://mthec.files.wordpress.com/2009/08/dwarf.png"
ICON_TMP=/tmp/df.png
ICON_FINAL="$DF_HOME/icon.png"
APPLICATIONS_FOLDER="$HOME/.local/share/applications"
DESKTOP_FILE="$APPLICATIONS_FOLDER/dwarf-fortress.desktop"

download() {
    # Abstract CURL and WGET so we can work on any distro.
    echo "Downloading $1..."
    if hash curl 2> /dev/null; then
        curl -L "$1" > $2
    else
        wget -O $2 "$1"
    fi
}

download $DF_URL $DF_TAR
download $ICON_URL $ICON_TMP

mkdir -p $DF_HOME

tar -xjf $DF_TAR -C $DF_HOME --strip-components=1
mv $ICON_TMP $ICON_FINAL

# HACK: delete shipped libstdc++ that is incompatible with system
# in modern linux distros
rm $DF_HOME/libs/libstdc++.so.6

mkdir -p $APPLICATIONS_FOLDER
cat <<EOF > $DESKTOP_FILE
[Desktop Entry]
Name=Dwarf Fortress
Comment=dwarf fortress
Exec=$DF_HOME/df
Icon=$ICON_FINAL
Terminal=false
Type=Application
Categories=Game;
StartupWMClass=Dwarf_Fortress
EOF

echo "Done"
echo "You now need to ensure you have the necessary dependencies"\
echo "For fedora, run:"
echo "       sudo dnf install SDL SDL_ttf SDL_sound SDL_mixer SDL_image mesa-libGLU openal-soft"

