for COURSE in $( ls -d */ ); do
  if [[ "template/" == $COURSE ]]; then
    continue
  fi
  open "${COURSE%?}.pdf"
done
