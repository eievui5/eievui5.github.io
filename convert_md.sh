echo "Converting ./"
evblog . -p meta/prologue_root.html -e meta/epilogue.html

echo "Converting resources/"
evblog resources/ -p meta/prologue_sub.html -e meta/epilogue.html

echo "Converting archive/"
evblog archive/ -p meta/prologue_sub.html -e meta/epilogue.html

echo "Converting my-stuff/"
evblog my-stuff/ -p meta/prologue_sub.html -e meta/epilogue.html

echo "Converting blog/"
cd blog/
evblog . -p meta/prologue.html -e meta/epilogue_comments.html -i meta/index.toml

echo "Reformatting blog/index.html"
evblog index.md -p meta/prologue.html -e meta/epilogue_plain.html
cd ../
