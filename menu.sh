#!/bin/bash

NOMBRE_ARCHIVO=${FILENAME:-"listado"}

RUTA_BASE="$HOME/EPNro1"
CARPETA_IN="$RUTA_BASE/entrada"
CARPETA_OUT="$RUTA_BASE/salida"
CARPETA_PROC="$RUTA_BASE/procesado"

ARCHIVO_FINAL="$CARPETA_OUT/${NOMBRE_ARCHIVO}.txt"

armar_directorios() {
    echo "Creando directorio EPNro1 en el home..."
    mkdir -p $CARPETA_IN $CARPETA_OUT $CARPETA_PROC
    
    if [ -f "./EPNro1/consolidar.sh" ]; then
        cp ./EPNro1/consolidar.sh $RUTA_BASE/
        chmod +x $RUTA_BASE/consolidar.sh
    fi
    
    echo "Entorno creado correctamente."
}

lanzar_script_fondo() {
    echo "Corriendo proceso en background..."
    bash $RUTA_BASE/consolidar.sh &
    echo "Proceso consolidar.sh iniciado."
    echo ""
}

ver_todos_los_alumnos() {
    if [ -f "$ARCHIVO_FINAL" ]; then
        echo "Listado de alumnos ordenados por número de padrón:"
        grep -v '^$' "$ARCHIVO_FINAL" | sort -t $'\t' -k1,1n
    else
        echo "No se encontró el archivo ${NOMBRE_ARCHIVO}.txt en la carpeta salida"
    fi
}

ver_top_diez() {
    if [ -f "$ARCHIVO_FINAL" ]; then
        echo "Las 10 notas más altas del listado:"
        grep -v '^$' "$ARCHIVO_FINAL" | sort -t $'\t' -k4,4nr | head -n 10
    else
        echo "No se encontró el archivo ${NOMBRE_ARCHIVO}.txt en la carpeta salida"
    fi
}

buscar_un_padron() {
    read -p "Ingresar nro de padrón: " num_padron
    if [ -f "$ARCHIVO_FINAL" ]; then
        echo "Datos del padrón $num_padron:"
        grep "^$num_padron" "$ARCHIVO_FINAL"
    else
        echo "No se encontró el archivo ${NOMBRE_ARCHIVO}.txt en la carpeta salida"
    fi
}

borrar_todo() {
    echo "Borrando entorno EPNro1 y matando procesos..."
    rm -rf $RUTA_BASE
    pkill -f "consolidar.sh"
    echo "Entorno y procesos eliminados."
}

if [ "$1" == "-d" ]; then
    borrar_todo
    exit 0
fi

while true; do
    echo "----------------------------------------"
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Mostrar alumnos ordenados por padrón"
    echo "4) Mostrar las 10 notas más altas"
    echo "5) Mostrar datos de un padrón"
    echo "6) Salir"
    echo "----------------------------------------"

    read -p "Elegir opción: " eleccion
    echo ""

    case $eleccion in
        1) armar_directorios ;;
        2) lanzar_script_fondo ;;
        3) ver_todos_los_alumnos ;;
        4) ver_top_diez ;;
        5) buscar_un_padron ;;
        6) 
            echo "Saliendo..."
            exit 0 
            ;;
        *) echo "Opción incorrecta" ;;
    esac
done

