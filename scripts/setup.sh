# --- 0. basic variable and help function setup ---
DOTFILES_DIR="$HOME/dotfiles"

DEFAULT_WAL="$HOME/dotfiles/wallpapers/sushi_colors.jpg"
FLATPAK_LIST="$DOTFILES_DIR/scripts/flatpakList.txt"
PKG_LIST="$DOTFILES_DIR/scripts/pkgList.txt"
LOG_FILE="$DOTFILES_DIR/install.log"

REPO_URL="https://github.com/howardyu60211/dotfiles.git"

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

# installing yay
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

# rog g14 / nvidia system setup
print_msg "installing G14 source..."
sudo pacman-key --recv-keys 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35
sudo pacman-key --lsign-key 8F654886F17D497FEFE3DB448B15A6B0E9A3FA35

if ! grep -q "\[g14\]" /etc/pacman.conf; then
    print_msg "Add g14 repo to /etc/pacman.conf..."
    echo -e "\n[g14]\nServer = https://arch.asus-linux.org" | sudo tee -a /etc/pacman.conf

    sudo pacman -Sy
else
    print_msg "G14 repo exist in pacman settings."
fi

# install package using yay
if [ -f "$PKG_LIST" ]; then
    print_msg "Installing pkglist.txt using yay..."

    yay -S --needed --noconfirm $(grep -vE "^\s*#" "$PKG_LIST" | tr "\n" " ")

    print_success "Done！"
else
    print_msg "Can't find pkglist.txt, skip..."
fi

# install package using flatpak
if [ -f "$FLATPAK_LIST" ]; then
    print_msg "Installing Flatpak applications..."

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

print_msg "Installing Vencord..."
sh -c "$(curl -sS https://raw.githubusercontent.com/Vencord/Installer/main/install.sh)" -- -i -b stable -l flatpak
print_success "Vencord installed!"

# enable ROG system service
sudo systemctl enable --now power-profiles-daemon.service
sudo systemctl enable --now supergfxd.service
sudo systemctl enable --now asusd.service

# enable bluetooth service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now NetworkManager.service

# enable user to userr supergfx without sudo
sudo usermod -aG users $USER

# switch to zsh
chsh -s $(which zsh)

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

print_msg "Make scripts runable..."
chmod +x ~/dotfiles/scripts/*.sh
print_success "Done!"

print_success "system installation done!"
print_msg 'There are a few settings requires changing manually:'

print_msg '1) add "nvidia-drm.modeset=1 nvidia_drm.fbdev=1" in GRUB_CMDLINE_LINUX_DEFAULT for grub'
print_msg " or add it in /boot/loader/entries/ if using systemd-boot"
print_msg '2) change sddm theme in /etc/sddm.conf'
print_msg " [Theme]"
print_msg " Current=sddm-astronaut-theme"
print_msg " and change theme in /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop"
print_msg " ConfigFile=Themes/astronaut.conf"
read -p "Press [ENTER] to continue"

if [ -d "$DEFAULT_WAL" ]; then
    print_msg "Setup default wallpaper & themes"

    if command -v wallust &> /dev/null; then
        wallust run "$DEFAULT_WAL"
        print_success "Color scheme generated!"
    else
        print_msg "Wallust command not found. Skipping color generation."
    fi

    mkdir -p ~/.cache/current_wallpaper
    echo "$DEFAULT_WAL" > "$HOME/.cache/current_wallpaper"
else
    print_msg "Wallpaper not found: $DEFAULT_WAL"
fi
