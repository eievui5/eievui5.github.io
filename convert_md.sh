echo "Converting blog/"
cd blog/
evblog . -p meta/prologue.html -e meta/epilogue_comments.html -i meta/index.toml
echo "Reformatting blog/index.html"
evblog index.md -p meta/prologue.html -e meta/epilogue_plain.html