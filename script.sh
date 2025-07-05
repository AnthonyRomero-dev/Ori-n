#!/data/data/com.termux/files/usr/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Configuración
REPO_URL="https://raw.githubusercontent.com/AnthonyRomero-dev/Ori-on/main"
SCRIPT_NAME="script.sh"

# Función para manejar errores
handle_error() {
    echo -e "${RED}[!] Error en la línea $1: $2${NC}"
    echo -e "${YELLOW}[*] Solución: Verifica tu conexión o reporta el error${NC}"
    exit 1
}

trap 'handle_error $LINENO "$BASH_COMMAND"' ERR

# Verificar conexión a internet
check_internet() {
    echo -e "${CYAN}[*] Verificando conexión a internet...${NC}"
    if ! ping -c 1 google.com &> /dev/null; then
        echo -e "${RED}[!] Error: Sin conexión a internet${NC}"
        echo -e "${YELLOW}[*] Solución: Activa tus datos móviles o Wi-Fi${NC}"
        exit 1
    fi
    echo -e "${GREEN}[+] Conexión a internet confirmada${NC}"
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
    
    echo -e "\n${CYAN}[*] Instalando dependencias básicas...${NC}"
    for package in git python wget curl; do
        echo -e "${YELLOW}[INSTALL] Instalando $package...${NC}"
        pkg install -y $package 2>&1 | while IFS= read -r line; do
            echo -e "${YELLOW}[$package] $line${NC}"
        done
        echo -e "${GREEN}[+] $package instalado${NC}"
    done
    
    # Verificar instalación
    if ! command -v git &> /dev/null; then
        echo -e "${RED}[!] Error: git no se instaló correctamente${NC}"
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

# Función principal
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
    
    # Tu lógica personalizada aquí
    echo -e "\n${CYAN}[*] Ejecutando lógica personalizada...${NC}"
    echo -e "${YELLOW}[+] Hola desde Termux!"
    echo -e "[+] Usuario: $(whoami)"
    echo -e "[+] Directorio: $(pwd)"
    echo -e "[+] Memoria libre: $(free -m | awk '/Mem/{print $4}') MB${NC}"
    
    # Ejemplo: Crear archivo de verificación
    echo "Script ejecutado correctamente el $(date)" > success.txt
    echo -e "${GREEN}[+] Archivo de verificación creado: success.txt${NC}"
    
    echo -e "\n${GREEN}=== Ejecución Completa ===${NC}"
    echo -e "${CYAN}Por favor revisa los mensajes arriba para verificar"
    echo -e "que todo se completó correctamente."
    echo -e "Reporta errores en: ${REPO_URL}${NC}"
}

main
