gitbook build
gitbook pdf
mv book.pdf
fp -r _book/* ../sttp-book.github.io/
rm -rf ../sttp-book.github.io/drawio 
rm -rf ../sttp-book.github.io/answers 
rm -rf ../sttp-book.github.io/includes 
rm ../sttp-book.github.io/*.md
cp book.pdf ../sttp-book.github.io/sttp.pdf

