#!/usr/bin/env bash
set -euo pipefail

USER_HOME="/home/programmer"
QUEST_DIR="$USER_HOME/quest"
STORY_FILE="/opt/quest/STORY.txt"

setup_world() {
  mkdir -p "$QUEST_DIR"
  # Árbol de “zonas”
  mkdir -p \
    "$QUEST_DIR/forest/.hidden" \
    "$QUEST_DIR/river" \
    "$QUEST_DIR/castle/treasure" \
    "$QUEST_DIR/.cave/..secrets"

  # Historia / instrucciones iniciales
  cat > "$QUEST_DIR/0_README.txt" <<'EOF'
🧙 HISTORIA — El Camino del Programador Feliz

En el Reino del Código, un joven programador busca “El Camino de la Felicidad”.
Para lograrlo, debe superar pruebas sencillas pero esenciales: moverse con precisión,
ver lo que otros no ven, leer señales del sistema y entender permisos.

⚑ REGLAS:
1) Mueve tu aventura dentro de ~/quest
2) Lee TODO. Algunas pistas están OCULTAS.
3) Cuando veas una pista, síguela al pie de la letra.
4) Si te atoras, recuerda: `man`, `--help`, y tus apuntes.

🎯 MISIÓN FINAL:
Encontrar el COFRE en el CASTILLO y poder leer su contenido.
Para leerlo, primero tendrás que “ajustar permisos”.

Al final verás números raros. Parece un “Código encriptado”...
Tal vez sea. Intenta decodificarlo.

¡Que la Terminal te acompañe!
EOF

  # Pistas repartidas
  echo "Pista 1: Lista también lo que no se ve (¿tal vez 'ls -la'?)" > "$QUEST_DIR/forest/.hidden/clue1.txt"
  echo "Pista 2: Busca un 'mapa' desde ~/quest (usa 'find . -name \"mapa*\"')" > "$QUEST_DIR/river/clue2.txt"
  echo "No mires atrás. Copia el mapa al castillo (cp <origen> ~/quest/castle/)" > "$QUEST_DIR/forest/mapa-del-reino.txt"
  echo "Pista 3: El cofre existe, pero no lo puedes leer aún. Revisa y cambia permisos (chmod)." > "$QUEST_DIR/castle/pista3.txt"

  # El cofre con el mensaje ASCII (inicialmente sin permisos de lectura)
  echo "76 79 83 32 81 85 73 69 82 79 32 77 85 67 72 79 44 32 77 73 83 32 80 79 76 76 73 84 79 83" \
    > "$QUEST_DIR/castle/treasure/cofre.txt"
  chmod 000 "$QUEST_DIR/castle/treasure/cofre.txt"

  # Bonus: zona muy escondida
  echo "Si llegaste aquí, dominas bien 'cd' y entiendes rutas raras. ¡Sigue así!" \
    > "$QUEST_DIR/.cave/..secrets/note.txt"

  # Guía rápida de comandos útiles
  cat > "$QUEST_DIR/COMANDOS_UTILES.txt" <<'EOF'
Comandos que seguro te servirán:
  pwd                 # Muestra en dónde estás
  ls -la              # Lista archivos (incluye los ocultos)
  cd <dir>            # Entra a un directorio
  tree                # Muestra el árbol de carpetas
  cat/less            # Lee archivos
  find . -name "patrón"    # Busca por nombre
  grep -R "texto" .        # Busca texto dentro de archivos, recursivo
  mkdir/touch/mv/cp/rm     # Crea/mueve/copias/borra cosas
  chmod +r archivo         # Da permiso de lectura al propietario
  chmod 400 archivo        # Solo lectura para el propietario
EOF
}

first_boot_stamp="$QUEST_DIR/.initialized"

if [[ ! -f "$first_boot_stamp" ]]; then
  setup_world
  touch "$first_boot_stamp"
fi

# Mostrar historia al iniciar
if [[ -f "$STORY_FILE" ]]; then
  echo
  cat "$STORY_FILE"
  echo
fi

echo -e "\n📍 Estás en: $(pwd)"
echo "📂 Tu misión está en: $QUEST_DIR"
echo "👉 Sugerencia: lee '0_README.txt' y 'COMANDOS_UTILES.txt'"
echo
exec bash
