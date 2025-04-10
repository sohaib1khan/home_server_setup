#!/bin/bash

print_tree() {
    local dir="${1:-.}"
    local prefix="${2}"
    local last="${3}"
    
    # Get directory name
    local name=$(basename "$dir")
    
    # Print current directory with appropriate prefix
    if [ "$last" = "true" ]; then
        echo "${prefix}└── $name"
        prefix="${prefix}    "
    elif [ -n "$prefix" ]; then
        echo "${prefix}├── $name"
        prefix="${prefix}│   "
    else
        echo "$name"
    fi
    
    # Get list of files and directories, sorted
    local entries=()
    while IFS= read -r -d $'\0' entry; do
        entries+=("$entry")
    done < <(find "$dir" -mindepth 1 -maxdepth 1 -print0 | sort -z)
    
    # Count entries for determining last item
    local count=${#entries[@]}
    local index=0
    
    # Process each entry
    for entry in "${entries[@]}"; do
        ((index++))
        
        # Skip hidden files/directories if desired
        # [[ $(basename "$entry") == .* ]] && continue
        
        # Check if this is the last entry
        [ "$index" -eq "$count" ] && local is_last="true" || local is_last="false"
        
        # If it's a directory, recursively call print_tree
        if [ -d "$entry" ]; then
            print_tree "$entry" "$prefix" "$is_last"
        else
            # It's a file, just print it
            if [ "$is_last" = "true" ]; then
                echo "${prefix}└── $(basename "$entry")"
            else
                echo "${prefix}├── $(basename "$entry")"
            fi
        fi
    done
}

# Call the function with the specified directory or current directory
print_tree "${1:-.}"
