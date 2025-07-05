#!/data/data/com.termux/files/usr/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Configuraci?n del repositorio
REPO_OWNER="AnthonyRomero-dev"
REPO_NAME="Ori-on"
BRANCH="main"  # Cambia a 'master' si es necesario
SCRIPT_NAME="script.sh"

# URL de verificaci?n
RAW_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/$SCRIPT_NAME"
GITHUB_URL="https://github.com/$REPO_OWNER/$REPO_NAME"

# Funci?n para verificar la existencia del script
verify_script_existence() {
    echo -e "${CYAN}[*] Verificando disponibilidad del script...${NC}"
    
    # Intento 1: Verificar con GitHub API
    if curl -s -I "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents/$SCRIPT_NAME" | grep -q "200 OK"; then
        echo -e "${GREEN}[+] Script encontrado v?a API GitHub${NC}"
        return 0
    fi
    
    # Intento 2: Verificaci?n directa
    if curl -s -I "$RAW_URL" | grep -q "200 OK"; then
        echo -e "${GREEN}[+] Script encontrado en URL cruda${NC}"
        return 0
    fi
    
    # Intento 3: Verificar rama alternativa
    echo -e "${YELLOW}[!] Probando con rama 'master'...${NC}"
    if curl -s -I "https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/master/$SCRIPT_NAME" | grep -q "200 OK"; then
        echo -e "${GREEN}[+] Script encontrado en rama 'master'${NC}"
        BRANCH="master"
        RAW_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH/$SCRIPT_NAME"
        return 0
    fi
    
    echo -e "${RED}[!] ERROR: Script no encontrado${NC}"
    echo -e "${YELLOW}Posibles soluciones:"
    echo "1. Verifica que '$SCRIPT_NAME' exista en la rama $BRANCH"
    echo "2. Revisa may?sculas/min?sculas del nombre"
    echo "3. Si est? en subcarpeta, agrega la ruta completa"
    echo "4. Prueba esta URL en navegador:"
    echo "   $RAW_URL"
    echo "5. Visita el repositorio: $GITHUB_URL"
    echo "6. Si es privado, hazlo p?blico o usa token de acceso${NC}"
    exit 1
}

# Verificar conexi?n a internet
check_internet() {
    echo -e "${CYAN}[*] Verificando conexi?n a internet...${NC}"
    if ! ping -c 1 google.com &> /dev/null; then
        echo -e "${RED}[!] Error: Sin conexi?n a internet${NC}"
        echo -e "${YELLOW}[*] Soluci?n: Activa tus datos m?viles o Wi-Fi${NC}"
        exit 1
    fi
    echo -e "${GREEN}[+] Conexi?n a internet confirmada${NC}"
}

# Instalar dependencias con progreso visible
install_dependencies() {
    echo -e "\n${CYAN}[*] Actualizando paquetes Termux...${NC}"
    echo -e "${YELLOW}(Esto puede tomar 2-5 minutos. Por favor espera)${NC}"
    
    pkg update -y && echo -e "${GREEN}[+] Paquetes actualizados exitosamente${NC}"
    
    echo -e "\n${CYAN}[*] Instalando dependencias b?sicas...${NC}"
    for package in git python wget curl; do
        echo -e "${YELLOW}[INSTALL] Instalando $package...${NC}"
        pkg install -y $package
        echo -e "${GREEN}[+] $package instalado${NC}"
    done
    
    echo -e "${GREEN}[+] Todas las dependencias instaladas${NC}"
}

# Funci?n principal
main() {
    clear
    echo -e "${GREEN}"
    echo "  ___  ____  ___  _   _ "
    echo " / _ \|  _ \|_ _|| \ | |"
    echo "| | | | |_) || | |  \| |"
    echo "| |_| |  _ < | | | |\  |"
    echo " \___/|_| \_\___||_| \_|"
    echo -e "${NC}"
    echo -e "${GREEN}=== Script Iniciado ===${NC}"
    echo -e "${YELLOW}Hora: $(date)${NC}\n"
    
    check_internet
    verify_script_existence
    install_dependencies
    
    # Descargar y ejecutar el script principal
    echo -e "\n${CYAN}[*] Descargando script principal...${NC}"
    if curl -sL -o "main_script.sh" "$RAW_URL"; then
        echo -e "${GREEN}[+] Descarga exitosa${NC}"
        chmod +x main_script.sh
        ./main_script.sh
    else
        echo -e "${RED}[!] Error al descargar el script${NC}"
        echo -e "${YELLOW}Intenta manualmente:"
        echo "curl -O $RAW_URL"
        echo "chmod +x $SCRIPT_NAME"
        echo "./$SCRIPT_NAME"
        exit 1
    fi
}

main#