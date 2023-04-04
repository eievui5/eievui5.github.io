echo "Converting blog/"
cd blog/
evblog . -p prologue.html -e epilogue.html -i index.toml
