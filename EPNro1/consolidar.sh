#!/bin/bash

NOMBRE_ARCHIVO=${FILENAME:-"listado"}

RUTA_BASE="$HOME/EPNro1"
CARPETA_IN="$RUTA_BASE/entrada"
CARPETA_OUT="$RUTA_BASE/salida"
CARPETA_PROC="$RUTA_BASE/procesado"

ARCHIVO_FINAL="$CARPETA_OUT/${NOMBRE_ARCHIVO}.txt"
PAUSA=5

unir_archivo() {
    fichero_actual=$1
    echo "" >> "$ARCHIVO_FINAL"
    cat "$CARPETA_IN/$fichero_actual" >> "$ARCHIVO_FINAL"
    mv "$CARPETA_IN/$fichero_actual" "$CARPETA_PROC"
}

while true; do
    # La consigna dice: "Los archivos que ingresan... extensión debe ser txt"
    fichero_actual=$(ls "$CARPETA_IN"/*.txt 2>/dev/null | head -n 1)

    if [ -n "$fichero_actual" ]; then
        unir_archivo $(basename $fichero_actual)
    else
        :
    fi

    sleep $PAUSA
done
