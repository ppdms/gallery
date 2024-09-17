cd content/images
mogrify -verbose -define jpeg:extent=5MB *.jpeg
cd ../..
hugo --logLevel info --minify
npx wrangler pages publish public --project-name gallery
