rm -rf public
cd originals
for file in *.jpeg; do
    [ -e "$file" ] || continue
    hash=$(md5sum "$file" | awk '{print $1}')
    new_name="${hash}.jpeg"
    if [ ! -e "$new_name" ]; then
        mv "$file" "$new_name"
        echo "Renamed $file to $new_name"
    else
        echo "Skipped $file, $new_name already exists"
        rm "$file"
        echo "Deleted $file"
    fi
done
cd ..
rclone sync -v originals r2:data/originals
cd ..
rm -rf content/images/img/*
cp originals/*.jpeg content/images/img/
cd content/images/img
mogrify -verbose -define jpeg:extent=5MB *.jpeg
cd ../../..
hugo --logLevel info --minify
npx wrangler pages deploy public --project-name gallery
