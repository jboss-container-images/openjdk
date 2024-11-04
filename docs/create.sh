if [ -d docs ]; then
    cd docs
fi

prefix=https://rh-openjdk.github.io/redhat-openjdk-containers/

while read path; do
    d="$(dirname $path)"
    mkdir -p "$d"
    uri="$prefix/$path"

    sed "s!DESTINATION!$uri!g" \
        moved.html \
        > "$path"

done < uris_to_create
