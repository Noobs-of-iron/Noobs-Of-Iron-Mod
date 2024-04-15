# Noobs Of Iron Mod
When the noobs get too much time on their hands, this is the result.  

This mod was brought to you by the Linux Gang.

## About the mod

The Noobs Of Iron Mod for Hearts of Iron IV initially aimed to enforce game rules. However, it now includes balance changes, additional events, focus tree alterations, and occasional game fixes (we're looking at you, supply in Spain).

### Mod Versions

This mod is available in two versions, mirroring the two branches of this repository:

- **NOIM (Regular):** Similar to the main branch, this version is the "Game ready" mod that aims to be balanced and stable. It is safe for general use.
- **NOIM_staging:** Similar to staging branches, this version serves as the "Work in Progress/Testing Ground" mod. It incorporates the latest changes but may lack balance and stability. It is not recommended for multiplayer games beyond testing purposes.

## Repository Information

The script uses bash and requires the `diff`, `dos2unix` and `patch` programs. On Windows, use WSL.

### File Structure

- `original`: An empty folder where you should place original HOI4 files if you don't want to use the `--original-folder` argument.
- `mod`: This folder contains modded files. An `.ignoreme` file ensures that Git creates the necessary empty directories. If you wish to add a patch or a new file, you don't have to recreate everything each time (only for directories not currently in use).
- `sources`: This directory houses the mod. We utilize `.patch` files (also known as diff files) created using `diff` for overriding the base game. This setup facilitates easy re-patching of the game with each new Paradox release. It's used if we wish to remove vanilla events, such as the ability for the Soviet Union to deny Finnish White Peace.

The script structure should match the game files. For example, for `Finland.txt`, located in `events/` in the base game, the patch is located at `source/events/Finland.txt.patch` and will be placed in `mod/events/Finland.txt`.

### Script Usage

`script <create|apply|clear> [--no-overwrite-mod] [--overwrite-sources] [--original-folder <path>] [--mod-folder <path>] [--sources-folder <path>]`

- I recommand you to use `--original-folder` to specify your HOI4 location; in WSL, it's likely something like `"/mnt/c/Program Files/Steam/SteamApps/common/Hearts of Iron IV"`.
- Use `--mod-folder` if possible; (`"~/.local/share/Paradox Interactive/Hearts of Iron IV/mod/noi/"` on Linux and `"/mnt/c/Users/yourusername/Documents/Paradox Interactive/Hearts of Iron IV/mod/noi/"` on WSL).
- `--sources-folder` is useful for debugging. By default, source patches and files are not overwritten.

### Building the Mod

1. Place the events, common folder (or any other necessary files) in the 'original' folder (or use `--original-folder` in the command below).
2. Run `./apply_patches apply`.
3. Retrieve the files from the 'mod' folder and place them in the destination mod folder.

### Creating Patches from Modified Files

1. Place the game files in 'original' (or use `--original-folder`), then place your modified files in 'mod' (or use `--mod-folder`).
2. Run `./apply_patches create`. This will create patches for existing files and copy non-existing ones.
3. Optional: Run `./apply_patches clear` (please don't commit modded files if you didn't use `--mod-folder`).
4. Commit the changes.

