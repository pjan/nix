{ stdenv, writeShellScriptBin, pkgs }:

writeShellScriptBin "mm-merge" ''

  main () {
    for dir in /Volumes/ARGON/video/03_Pending/*/; do \
      PATH="$(realpath d)"
      FILE="$(find $PATH -type f -name ".mp4")"
      NAME="$(${pkgs.coreutils}/bin/ffmpeg ''${f} .mp4)"
      SUBS="$(find $PATH -type f -name "*.srt" | sort | head -n 1)"
      TMP=''${PATH}/''${NAME}.tmp

      ${pkgs.mkvtoolnix-cli}/bin/mkvmerge -d 0 -A -S -o ''${PATH}/''${NAME}.tmp ''${FILE}
      ${pkgs.ffmpeg}/bin/ffmpeg \
        $@ \
        -i "$TMP" \
        -i "$FILE" \
        -i "$SUBS" \
        -map 1 \
        -map 0 \
        -map -0:v:0 \
        -map -1:v:1 \
        -map_metadata 0 \
        -c copy \
        -tag:v:0 hvc1 \
        -movflags +faststart \
        -f mp4 \
        -c:s mov_text \
        -metadata:s:s:0 language=eng \
        /Volumes/ARGON/video/04_Merged/"$NAME".mp4; done

  }

  main $*

''
