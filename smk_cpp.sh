#!/bin/bash

set -e  # Stoppe le script si une commande échoue
set -o pipefail
LOG="install_cpp.log"

# 🧩 Liste des paquets à installer
PAQUETS=(
    build-essential
    cmake
    g++
    clang
    libboost-all-dev
    libssl-dev
    libsfml-dev
)

echo "📜 Journal d'installation → $LOG"
echo "🔎 Mise à jour des paquets..."
sudo apt update | tee -a "$LOG"

# 🔁 Fonction d’installation avec vérification
installer_paquet() {
    if dpkg -s "$1" &>/dev/null; then
        echo "✅ $1 déjà installé"
    else
        echo "📦 Installation de $1..."
        sudo apt install -y "$1" | tee -a "$LOG"
    fi
}

# 🎯 Boucle sur la liste des paquets
for paquet in "${PAQUETS[@]}"; do
    installer_paquet "$paquet"
done

# 📍 Affiche les versions installées
echo -e "\n🧪 Vérification des outils installés :"
echo "g++ → $(g++ --version | head -n 1)"
echo "clang → $(clang --version | head -n 1)"
echo "cmake → $(cmake --version | head -n 1)"
echo "Boost → $(dpkg -s libboost-dev | grep Version || echo 'Non trouvé')"
echo "OpenSSL → $(openssl version)"
echo "SFML → $(dpkg -s libsfml-dev | grep Version || echo 'Non trouvé')"

echo -e "\n🚀 Installation terminée. Tu es prêt pour coder du lourd 💻🔥"
