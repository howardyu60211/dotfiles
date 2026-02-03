# --- 0. basic variable and help function setup ---
DOTFILES_DIR="$HOME/dotfiles"
REPO_DIR="https://github.com/howardyu60211/dotfiles.git"
FLATPAK_LIST="$DOTFILES_DIR/flatpak_list.txt"
PKG_LIST="$DOTFILES_DIR/pkglist.txt"
LOG_FILE="install.log"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_msg() { echo -e "${BLUE}[INFO]${NC} $1" }

print_success() { echo -e "${GREEN}[OK]${NC} $1" }

set -e

# --- 1. system and basic app setup ---
print_msg "Updating system..."
sudo pacman -Syu --noconfirm

print_msg "Installing git & stow..."
sudo pacman -S --needed --noconfirm git stow base-devel

if [ -d "$DOTFILES_DIR" ]; then
    print_msg "Dotfiles dir exist, pulling newest version..."
    cd "$DOTFILES_DIR" && git pull
else
    print_msg "Clone Dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

if ! command -v yay &> /dev/null; then
    print_msg "Installing yay..."

    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay

    makepkg -si --noconfirm

    cd -
    rm -rf /tmp/yay

    print_success "Done!"
else
    print_msg "Yay has been installed."
fi

if [ -f "$PKG_LIST" ]; then
    print_msg "Installing pkglist.txt using yay..."

    yay -S --needed --noconfirm $(grep -vE "^\s*#" "$PKG_LIST" | tr "\n" " ")

    print_success "Done！"
else
    print_msg "Can't find pkglist.txt, skip..."
fi

if [ -f "$FLATPAK_LIST" ]; then
    print_msg "Installing Flatpak applications..."

    if ! command -v flatpak &> /dev/null; then
        print_msg "Flatpak not found, Installing flatpak..."
        sudo pacman -S --needed --noconfirm flatpak
    fi

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    print_msg "reading flatpak_list.txt and installing..."

    FLATPAK_APPS=$(grep -vE "^\s*#" "$FLATPAK_LIST" | tr "\n" " ")

    if [ -n "$FLATPAK_APPS" ]; then
        flatpak install -y --noninteractive flathub $FLATPAK_APPS
        print_success "Flatpak applications installed！"
    else
        print_msg "Flatpak list are empty. Done."
    fi

else
    print_msg "flatpak_list.txt not found, skipping"
fi


# --- 2. setup stow ---
print_msg "linking config (Stow)..."
cd "$DOTFILES_DIR"

IGNORE_DIRS=(".git" "scripts" "assets" "wallpapers")

for folder in */; do
    folder=${folder%/}

    if [[ " ${IGNORE_DIRS[*]} " =~ " ${folder} " ]]; then
        print_msg "Skipping: $folder"
        continue
    fi

    if [ -d "$HOME/.config/$folder" ] && [ ! -L "$HOME/.config/$folder" ]; then
        print_msg "$folder exist. Backing..."
        mv "$HOME/.config/$folder" "$HOME/.config/${folder}.backup.$(date +%s)"
    fi

    stow -R "$folder"
    print_success "$folder linked."
done
