#!/bin/bash
# simsize.sh - menu-driven viewer/changer of the Dynamic Type size on booted iOS simulators.
#
# Usage: Scripts/simsize.sh
# Lists every booted simulator with its current text size. Pick a device (or "a" for all),
# then pick a size. Repeat until you press q.

SIZES=(
  extra-small small medium large extra-large extra-extra-large extra-extra-extra-large
  accessibility-medium accessibility-large accessibility-extra-large
  accessibility-extra-extra-large accessibility-extra-extra-extra-large
)

# Fills the arrays UDIDS and NAMES from `simctl list`.
load_devices() {
  UDIDS=(); NAMES=()
  local line udid name
  while IFS= read -r line; do
    udid=$(grep -oE '[0-9A-Fa-f]{8}-([0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}' <<<"$line")
    [ -z "$udid" ] && continue
    name=$(sed -E 's/^[[:space:]]+//; s/ \([0-9A-Fa-f-]{36}\).*$//' <<<"$line")
    UDIDS+=("$udid"); NAMES+=("$name")
  done < <(xcrun simctl list devices booted | grep -E '\(Booted\)')
}

current_size() { xcrun simctl ui "$1" content_size 2>/dev/null || echo "unknown"; }

show_devices() {
  echo
  echo "Booted simulators"
  echo "-----------------"
  local i
  for i in "${!UDIDS[@]}"; do
    printf "  %d) %-28s %s\n" "$((i + 1))" "${NAMES[$i]}" "$(current_size "${UDIDS[$i]}")"
  done
  echo "  a) All devices"
  echo "  r) Refresh"
  echo "  q) Quit"
}

choose_size() {
  echo
  echo "Sizes"
  echo "-----"
  local i
  for i in "${!SIZES[@]}"; do printf "  %2d) %s\n" "$((i + 1))" "${SIZES[$i]}"; done
  echo "   b) Back"
  read -r -p "Size: " pick
  [[ "$pick" == "b" || -z "$pick" ]] && return 1
  if [[ "$pick" =~ ^[0-9]+$ ]] && (( pick >= 1 && pick <= ${#SIZES[@]} )); then
    CHOSEN_SIZE="${SIZES[$((pick - 1))]}"
    return 0
  fi
  echo "Not a valid choice."
  return 1
}

while true; do
  load_devices
  if [ ${#UDIDS[@]} -eq 0 ]; then
    echo "No booted simulators. Boot one in Xcode or Simulator, then choose r."
  fi
  show_devices
  read -r -p "Choose a device: " choice || exit 0
  case "$choice" in
    q|Q) exit 0 ;;
    r|R|"") continue ;;
    a|A)
      choose_size || continue
      for i in "${!UDIDS[@]}"; do
        xcrun simctl ui "${UDIDS[$i]}" content_size "$CHOSEN_SIZE" && echo "Set ${NAMES[$i]} to $CHOSEN_SIZE"
      done
      ;;
    *)
      if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#UDIDS[@]} )); then
        i=$((choice - 1))
        choose_size || continue
        xcrun simctl ui "${UDIDS[$i]}" content_size "$CHOSEN_SIZE" && echo "Set ${NAMES[$i]} to $CHOSEN_SIZE"
      else
        echo "Not a valid choice."
      fi
      ;;
  esac
done
