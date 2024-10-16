rm -rf public
cd originals

files_are_identical() {
    cmp -s "$1" "$2"
}

for file in *.jpeg; do
    [ -e "$file" ] || continue
    
    hash=$(md5sum "$file" | awk '{print $1}')
    
    new_name="${hash}.jpeg"
    
    if [ -e "$new_name" ] && [ "$file" != "$new_name" ]; then
        if files_are_identical "$file" "$new_name"; then
            echo "Identical file already exists. Deleting $file"
            rm "$file"
        fi
    elif [ "$file" != "$new_name" ]; then
        mv "$file" "$new_name"
        echo "Renamed $file to $new_name"
    else
        echo "File $file already has the correct name"
    fi
done
cd ..
rclone sync -v originals r2:data/originals
rm -rf content/images/img/
mkdir content/images/img/
cp originals/*.jpeg content/images/img/
cd content/images/img
mogrify -verbose -define jpeg:extent=5MB *.jpeg
cd ../../..
hugo --logLevel info --minify --ignoreCache
npx wrangler pages deploy public --project-name gallery
