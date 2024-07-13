#!/bin/bash
# Default configurations
OVERWRITE_MOD="yes"  # Change default to yes
OVERWRITE_SOURCES="no"  # Keep default as no
ORIGINAL_FOLDER="original/"
REBUILD="no"
MOD_FOLDER="mod/"
SOURCES_FOLDER="sources/"
DEBUG_SCRIPT="no"
I_KNOW_WHAT_IM_DOING="no" #Not documented because if you are here you probably know what you're doing
RUNNING_ON_PURE_UNIX="no" # may be useful for later? idk do some unix2dos
RUNNING_ON_POSIX="no" # may be useful too?! maybe git bash sheneinigans on windows?!
# List of commands to check
commands=("dos2unix" "unix2dos" "patch" "diff" "git" "find")

# Variable to store non-installed commands
missing_commands=""

# Function to check if a command is available
check_command() {
    command -v "$1" >/dev/null 2>&1 || missing_commands+=" $1"
}

# Check each command
for cmd in "${commands[@]}"; do
    check_command "$cmd"
done

# Check if any commands are missing
if [ -n "$missing_commands" ]; then
    echo "The following commands are not installed:$missing_commands"
    exit 1
fi




# Usage information
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <create|apply|clear> [--no-overwrite-mod] [--overwrite-sources] [--original-folder <path>] [--mod-folder <path>] [--sources-folder <path>] [--rebuild]"
    exit 1
fi



MODE=$1
shift # Move past the mode argument for further processing

echo_debug() {
    if [ "$DEBUG_SCRIPT" = "yes" ]; then
        echo "DEBUG : $1"
    fi
}

# Parse additional arguments
while (( "$#" )); do
  case "$1" in
    --no-overwrite-mod)
      OVERWRITE_MOD="no"
      shift
      ;;
     --yes-do-as-i-say)
      echo "Aight mate i'm removing every protection, don't blame me if i delete something important.."
      I_KNOW_WHAT_IM_DOING="yes"
      OVERWRITE_SOURCES="yes"
      OVERWRITE_MOD="yes"
      shift
      ;;
    --rebuild)
      REBUILD="yes"
      shift
      ;;
    --overwrite-sources)
      OVERWRITE_SOURCES="yes"
      shift
      ;;
    --debug-script)
      DEBUG_SCRIPT="yes"
      echo_debug "Debug enabled !"
      shift
      ;;
    --original-folder)
      ORIGINAL_FOLDER=$2
      shift 2
      ;;
    --sources-folder)
      SOURCES_FOLDER=$2
      shift 2
      ;;
    --mod-folder)
      MOD_FOLDER=$2
      shift 2
      ;;
    *)
      echo "I don't know what is that $1 argument you supplied so i'm ignoring it."
      shift
      ;;
  esac
done



#Check what am i running on
if [  -e /proc/version ]; then
    RUNNING_ON_POSIX="yes"
    if [[ ! $(grep Microsoft /proc/version) ]]; then
        RUNNING_ON_PURE_UNIX="yes"
        echo_debug "Running on pure Unix"
    else
        echo_debug "Running on WSL"
    fi
else
    echo_debug "Running on a non-posix system."
fi

create_patches_and_sources() {
    if [ "$REBUILD" = "yes" ]; then
        if [ "$I_KNOW_WHAT_IM_DOING" = "yes" ]; then
            echo "WARNING WARNING WARNING : Rebuilding: clearing sources folder..."
            find "${SOURCES_FOLDER}" -type f -not -name '.ignoreme' -delete
        else
            echo "Don't do rebuild on create sources unless you know what to do..."
            exit 1
        fi
    fi
    echo "Creating patches and updating sources..."
    find "${MOD_FOLDER}" -type f -not -name ".*" | while read -r mod_file; do
        relative_path="${mod_file#${MOD_FOLDER}}"
        original_file="${ORIGINAL_FOLDER}${relative_path}"
        sources_file="${SOURCES_FOLDER}${relative_path}.patch"
        
        if file "$mod_file" | grep -iq 'text'; then
            # Handle text files (potentially creating patch files)
            if [ -e "$original_file" ]; then
                mkdir -p "$(dirname "$sources_file")"
                temp_original_file=$(mktemp)
                cp "$original_file" "$temp_original_file"
                temp_mod_file=$(mktemp)
                cp "$mod_file" "$temp_mod_file"
                dos2unix "$temp_original_file" &>/dev/null
                dos2unix "$temp_mod_file" &>/dev/null
                echo_debug "Treating file to build patch : $relative_path"
                patch_content=$(diff --minimal "$temp_original_file" "$temp_mod_file")
                
                if [ -n "$patch_content" ]; then
                    if [ "$OVERWRITE_SOURCES" = "yes" ] || [ ! -e "$sources_file" ]; then
                        echo "$patch_content" > "$sources_file"
                        echo_debug "Patch created for: $relative_path"
                    else
                        echo_debug "Skipping existing patch file due to no overwrite setting: $sources_file"
                    fi
                else
                    echo_debug "No differences found, skipping patch creation for: $relative_path"
                fi
                
                rm "$temp_original_file" "$temp_mod_file"
            else
                handle_non_existing_or_different_original "$mod_file" "$relative_path"
            fi
        else
            # Handle binary files (copying if different)
            handle_non_existing_or_different_original "$mod_file" "$relative_path"
        fi
    done
}

handle_non_existing_or_different_original() {
    mod_file=$1
    relative_path=$2
    original_file="${ORIGINAL_FOLDER}${relative_path}"
    new_sources_file_path="${SOURCES_FOLDER}${relative_path}"

    # Proceed if no original file exists or if they are different (for binary files)
    if [ ! -e "$original_file" ] || ! cmp -s "$mod_file" "$original_file"; then
        if [ "$OVERWRITE_SOURCES" = "yes" ] || [ ! -e "$new_sources_file_path" ]; then
            mkdir -p "$(dirname "$new_sources_file_path")"
            cp "$mod_file" "$new_sources_file_path"
            echo_debug "File copied to sources (binary or no original file): $relative_path"
        else
            echo_debug "Skipping copying file to sources due to no overwrite setting: $relative_path"
        fi
    else
        echo_debug "File unchanged, not copying to sources: $relative_path"
    fi
}
apply_patches_and_update_mod() {
    if [ "$REBUILD" = "yes" ]; then
        if [ "$OVERWRITE_MOD" = "yes" ]; then
            echo "Rebuilding: clearing mod folder..."
            find "${MOD_FOLDER}" -type f -not -name '.ignoreme' -delete
        else
            echo "ERROR: --rebuild option requires --no-overwrite-mod not to be set for apply mode."
            exit 1
        fi
    fi
    echo "Applying patches and updating mod from sources..."
    find "${SOURCES_FOLDER}" -type f -not -name ".*" | while read -r sources_file; do
        relative_path="${sources_file#${SOURCES_FOLDER}}"
        relative_path_no_patch="${relative_path%.patch}"
        mod_file="${MOD_FOLDER}/${relative_path_no_patch}"

        # Determine if the current file is a patch or a direct copy
        if [[ "$sources_file" == *.patch ]]; then
            # It's a patch file, prepare to apply it
            original_file="${ORIGINAL_FOLDER}/${relative_path_no_patch}"

            # Check if the original file exists
            if [ ! -e "$original_file" ]; then
                echo "WARNING : Original file missing for patch, cannot apply: ${relative_path_no_patch}"
                continue
            fi

            # Make a temporary copy of the original file for dos2unix conversion
            temp_original_file=$(mktemp)
            cp "$original_file" "$temp_original_file"
            dos2unix "$temp_original_file" &>/dev/null

            if [ -e "$mod_file" ] && [ "$OVERWRITE_MOD" != "yes" ]; then
                echo_debug "Mod file $mod_file exists and will not be overwritten. Skipping patch application."
                rm "$temp_original_file"  # Clean up the temporary file
                continue
            fi

            mkdir -p "$(dirname "$mod_file")"
            # Apply the patch using the temporary converted original file
            patch -o "$mod_file" "$temp_original_file" "$sources_file" > /dev/null
            echo_debug "Applied patch to create: $mod_file"
            # Paradox must have a custom csv parser that doesnt like unix format even on linux @#!
            if [[ "$mod_file" == *.csv ]]; then
                unix2dos -q "$mod_file"
                echo_debug "Converted $mod_file to DOS format."
            fi
            #Patch seems to generate non-bom uft-8 loc files and hoi doesn't like that
            if [[ "$mod_file" == *.yml ]]; then
                mv "$mod_file" "$mod_file.tmp"
                printf '\xEF\xBB\xBF' > "$mod_file"
                cat "$mod_file.tmp" >> "$mod_file"
                rm "$mod_file.tmp"
                echo_debug "Converted $mod_file to UTF-8 BOM format."
            fi

            rm "$temp_original_file"  # Clean up the temporary file
        else
            # It's a direct copy file
            if [ -e "${ORIGINAL_FOLDER}${relative_path}" ]; then
                # Check if the original file is a text file
                isfile=$(file "$original_file" | grep -q 'text')
                if [ $isfile ]; then
                    echo "ERROR: A file with the same name as the non-patch file $relative_path exists in the original folder. Use a patch file instead of a whole file."
                    exit 1
                else
                    echo_debug "Overriding binary file $relative_path from sources"
                fi
            fi
            if [ -e "$mod_file" ] && [ "$OVERWRITE_MOD" != "yes" ]; then
                echo_debug "Mod file $mod_file exists and will not be overwritten. Skipping copy."
                continue
            fi

            mkdir -p "$(dirname "$mod_file")"
            cp "$sources_file" "$mod_file"
            echo_debug "Copied file to mod: $mod_file"
        fi
    done
}


clear_mod_folder() {
    if [ "$MOD_FOLDER" != "mod/" ];then
        if [ "$I_KNOW_WHAT_IM_DOING" != "yes" ];then
        echo "ERROR : You should keep the clear command inside the repo, not in your own mod folder"
        exit 1
        fi
    fi
        
    echo "Clearing mod folder..."
    # Remove all files except for .ignoreme, then find all empty directories to add .ignoreme
    find "${MOD_FOLDER}" -type f ! -name '.ignoreme' -delete
    # After cleanup, some directories might become empty, ensure .ignoreme is placed
    find "${MOD_FOLDER}" -type d -empty -exec touch {}/.ignoreme \;
    
    echo "INFO : Mod folder cleared, and .ignoreme files added in empty directories."
}



# Main operation
case "$MODE" in
    create)
        create_patches_and_sources
        ;;
    apply)
        apply_patches_and_update_mod
        ;;
    clear)
        clear_mod_folder
        ;;
    *)
        echo "Invalid mode '$MODE'. Use 'create' to generate patches and update sources, 'apply' to apply patches and update mod, or 'clear' to prepare mod folder for commit."
        exit 1
        ;;
esac
