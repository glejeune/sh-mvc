trim() { echo $1; }

log() {
   echo "[`date '+%Y-%m-%d %H:%M:%S'`] $1" | head -1
}

