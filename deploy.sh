gitbook build
gitbook pdf
rm -rf ../sttp-book.github.io/assets/ ../sttp-book.github.io/chapters/ ../sttp-book.github.io/gitbook/ ../sttp-book.github.io/gitbook_to_pdf.sh ../sttp-book.github.io/index.html ../sttp-book.github.io/search_index.json
cp -r _book/* ../sttp-book.github.io/
rm -rf ../sttp-book.github.io/drawio 
rm -rf ../sttp-book.github.io/answers 
rm -rf ../sttp-book.github.io/includes 
rm -rf ../sttp-book.github.io/latex-conf
rm ../sttp-book.github.io/*.sh
cp book.pdf ../sttp-book.github.io/sttp.pdf

