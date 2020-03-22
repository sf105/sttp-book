gitbook build
gitbook pdf
cp -r _book/* ../sttp-book.github.io/
rm -rf ../sttp-book.github.io/drawio 
rm -rf ../sttp-book.github.io/answers 
rm -rf ../sttp-book.github.io/includes 
rm ../sttp-book.github.io/*.sh
cp book.pdf ../sttp-book.github.io/sttp.pdf

