rm -rf public
cd content/images/img 
count=1
for file in *.jpeg ; do
    [ -e "$file" ] || continue
    mv "$file" "$(printf "%d.jpeg" "$count")"
    ((count++))
done
mogrify -verbose -define jpeg:extent=5MB *.jpeg
cd ../../..
hugo --logLevel info --minify
npx wrangler pages deploy public --project-name gallery
