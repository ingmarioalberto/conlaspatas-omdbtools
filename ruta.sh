#!/bin/bash

get_relative_path() {
    from="$1"
    to="$2"

    # Normalizar las rutas eliminando las barras diagonales finales
    from="${from%/}"
    to="${to%/}"

    # Dividir las rutas en componentes
    IFS="/" read -ra from_parts <<< "$from"
    IFS="/" read -ra to_parts <<< "$to"

    # Eliminar partes comunes entre las rutas
    while [[ "${from_parts[0]}" == "${to_parts[0]}" ]]; do
        from_parts=("${from_parts[@]:1}")
        to_parts=("${to_parts[@]:1}")
    done

    # Calcular el nivel de directorios ascendentes necesarios para llegar desde la ruta de origen a la raíz
    up_levels="${#from_parts[@]}"
    up_dirs=$(printf "../%.0s" $(seq 1 "$up_levels"))

    # Construir la ruta relativa agregando niveles ascendentes y la ruta restante
    IFS="/" relative_path="$up_dirs${to_parts[*]}"

    echo "$relative_path"
}

# Ejemplo de uso
relative_path=$(get_relative_path "$1" "$2")
echo "Ruta relativa: $relative_path"