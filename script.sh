#!/data/data/com.termux/files/usr/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Configuraci��n
REPO_URL="https://raw.githubusercontent.com/AnthonyRomero-dev/Ori-on/main"
SCRIPT_NAME="script.sh"

# Funci��n para manejar errores
handle_error() {
    echo -e "${RED}[!] Error en la l��nea $1: $2${NC}"
    echo -e "${YELLOW}[*] Soluci��n: Verifica tu conexi��n o reporta el error${NC}"
    exit 1
}

trap 'handle_error $LINENO "$BASH_COMMAND"' ERR

# Verificar conexi��n a internet
check_internet() {
    echo -e "${CYAN}[*] Verificando conexi��n a internet...${NC}"
    if ! ping -c 1 google.com &> /dev/null; then
        echo -e "${RED}[!] Error: Sin conexi��n a internet${NC}"
        echo -e "${YELLOW}[*] Soluci��n: Activa tus datos m��viles o Wi-Fi${NC}"
        exit 1
    fi
    echo -e "${GREEN}[+] Conexi��n a internet confirmada${NC}"
}

# Instalar dependencias con progreso visible
install_dependencies() {
    echo -e "\n${CYAN}[*] Actualizando paquetes Termux...${NC}"
    echo -e "${YELLOW}(Esto puede tomar 2-5 minutos. Por favor espera)${NC}"
    
    # Mostrar progreso en tiempo real
    pkg update -y | while IFS= read -r line; do
        echo -e "${YELLOW}[UPDATE] $line${NC}"
    done
    
    echo -e "${GREEN}[+] Paquetes actualizados exitosamente${NC}"
    
    echo -e "\n${CYAN}[*] Instalando dependencias b��sicas...${NC}"
    for package in git python wget curl; do
        echo -e "${YELLOW}[INSTALL] Instalando $package...${NC}"
        pkg install -y $package 2>&1 | while IFS= read -r line; do
            echo -e "${YELLOW}[$package] $line${NC}"
        done
        echo -e "${GREEN}[+] $package instalado${NC}"
    done
    
    # Verificar instalaci��n
    if ! command -v git &> /dev/null; then
        echo -e "${RED}[!] Error: git no se instal�� correctamente${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[+] Todas las dependencias instaladas${NC}"
    
    # Instalar dependencias Python si existen
    if [ -f "requirements.txt" ]; then
        echo -e "\n${CYAN}[*] Instalando paquetes Python...${NC}"
        pip install -r requirements.txt | while IFS= read -r line; do
            echo -e "${YELLOW}[PIP] $line${NC}"
        done
        echo -e "${GREEN}[+] Paquetes Python instalados${NC}"
    fi
}

# Funci��n principal
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
    install_dependencies
    
    # Tu l��gica personalizada aqu��
    echo -e "\n${CYAN}[*] Ejecutando l��gica personalizada...${NC}"
    echo -e "${YELLOW}[+] Hola desde Termux!"
    echo -e "[+] Usuario: $(whoami)"
    echo -e "[+] Directorio: $(pwd)"
    echo -e "[+] Memoria libre: $(free -m | awk '/Mem/{print $4}') MB${NC}"
    
    # Ejemplo: Crear archivo de verificaci��n
    echo "Script ejecutado correctamente el $(date)" > success.txt
    echo -e "${GREEN}[+] Archivo de verificaci��n creado: success.txt${NC}"
    
    echo -e "\n${GREEN}=== Ejecuci��n Completa ===${NC}"
    echo -e "${CYAN}Por favor revisa los mensajes arriba para verificar"
    echo -e "que todo se complet�� correctamente."
    echo -e "Reporta errores en: ${REPO_URL}${NC}"
}

main#