# simsize

![simsize demonstration](<assets/CleanShot 2026-11-07 at 12.03.14 PM.gif>)

**Change Dynamic Type text sizes in running iOS simulators, right from Terminal.**

`simsize` is a small, menu-driven Bash script for testing how an app responds to different text sizes. See the current size on each running simulator, then change one simulator or all of them at once.

No third-party packages are required.

## What you need

- A Mac with Xcode installed and its initial setup completed.
- An iOS simulator installed through Xcode.
- The `simsize.sh` file from this repository.

This script uses Xcode’s `xcrun simctl` tool. It changes the simulator’s Dynamic Type setting; how your app responds depends on its support for Dynamic Type.

## Install once, then run from anywhere

These instructions install the script as `simsize` in a personal commands folder. After setup, you can open Terminal and type `simsize` from any folder.

### 1. Download the script

On this repository’s GitHub page:

1. Click the green **Code** button.
2. Choose **Download ZIP**.
3. Open the downloaded ZIP file to extract it.
4. Find `simsize.sh` in the extracted folder.

### 2. Open Terminal

Press **Command–Space**, type **Terminal**, and press **Return**.

In the commands below, copy only the contents of each code block. Press **Return** after entering each command.

### 3. Create a folder for your personal commands

Run:

```sh
mkdir -p "$HOME/.local/bin"
```

`$HOME` means your home folder. This creates a folder named `bin` inside `.local`; it is fine if the folder already exists. Folders whose names begin with a dot are normally hidden in Finder.

### 4. Copy the script into that folder

To avoid typing the full path to the downloaded file:

1. Type `cp` followed by a space in Terminal. **Do not press Return yet.**
2. Drag `simsize.sh` from Finder into the Terminal window. Terminal will insert its path.
3. Add a space, then type `"$HOME/.local/bin/simsize"`.
4. Press **Return**.

Your command will look something like this, with your own downloaded file’s path in the middle:

```sh
cp /path/to/downloaded/simsize.sh "$HOME/.local/bin/simsize"
```

**The `/path/to/downloaded/simsize.sh` part is an example, not a path to copy literally.** Dragging the file into Terminal supplies the correct path, including any necessary handling of spaces.

The installed copy is named `simsize`, without `.sh`, so that is the command you will type to run it. If you already installed `simsize` here, this replaces that installed copy.

### 5. Make the script executable

Run:

```sh
chmod +x "$HOME/.local/bin/simsize"
```

This gives the file permission to run as a program. It is normal for this command to finish without displaying a message.

### 6. Add the folder to your PATH

Your **PATH** is the list of folders Terminal searches when you type a command. Adding your personal commands folder lets Terminal find `simsize` without needing its full path.

Check which shell you use:

```sh
echo "$SHELL"
```

**If the result ends in `/zsh`**, run these commands once:

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
source "$HOME/.zshrc"
```

**If the result ends in `/bash`**, run these commands once instead:

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bash_profile"
source "$HOME/.bash_profile"
```

Use only the pair that matches your shell. The first command saves the setting for future Terminal sessions. The second applies it to the current session.

If you use a different shell, add `$HOME/.local/bin` to its PATH using that shell’s configuration instructions.

### 7. Check your installation

Run:

```sh
command -v simsize
```

You should see a path like:

```text
/Users/yourname/.local/bin/simsize
```

You are ready to go!

## Use simsize

1. Open **Simulator** and start an iOS simulator, or run your app in a simulator from Xcode.
2. Open Terminal and run:

   ```sh
   simsize
   ```

3. Type a device’s number and press **Return**, or type `a` to select all running simulators.
4. Type a text size’s number and press **Return** to apply it.

The script returns to the device menu so you can keep testing.

### Menu controls

| Menu | Input | Action |
| --- | --- | --- |
| Devices | Device number | Choose one running simulator |
| Devices | `a` | Choose all running simulators |
| Devices | `r` or Return | Refresh the device list and current sizes |
| Devices | `q` | Quit |
| Sizes | Size number | Apply that text size |
| Sizes | `b` or Return | Return to the device menu |

You can also press **Control–C** to stop the script.

### Available text sizes

The size menu includes all 12 options supported by this script:

| Number | Size |
| --- | --- |
| 1 | `extra-small` |
| 2 | `small` |
| 3 | `medium` |
| 4 | `large` |
| 5 | `extra-large` |
| 6 | `extra-extra-large` |
| 7 | `extra-extra-extra-large` |
| 8 | `accessibility-medium` |
| 9 | `accessibility-large` |
| 10 | `accessibility-extra-large` |
| 11 | `accessibility-extra-extra-large` |
| 12 | `accessibility-extra-extra-extra-large` |

**Quitting does not restore the previous text size.** To put a simulator back the way it was, select its earlier size before quitting or run `simsize` again later.

## Troubleshooting

### “command not found: simsize”

Check that the installed file exists:

```sh
ls -l "$HOME/.local/bin/simsize"
```

If it does not exist, repeat the copy step. If it does exist, repeat the PATH setup for your shell, then open a new Terminal window and try again.

You can also run the script directly, without using PATH:

```sh
"$HOME/.local/bin/simsize"
```

### “Permission denied”

Make the installed copy executable, then try again:

```sh
chmod +x "$HOME/.local/bin/simsize"
```

### “No booted simulators”

Start an iOS device in Simulator or run your app in a simulator from Xcode. Back in `simsize`, type `r` and press **Return**.

The script lists only simulators that are currently running. It does not start simulators or control physical iPhones or iPads.

### An error mentions `xcrun`, `simctl`, or the developer directory

Open Xcode and finish any first-launch setup it requests. In **Xcode → Settings → Locations**, select your Xcode installation in the **Command Line Tools** menu.

Then check whether Terminal can list your simulators:

```sh
xcrun simctl list devices booted
```

Once that works, run `simsize` again.

## Update

Download the new `simsize.sh` and repeat the **copy** and **make executable** steps above. You do not need to add the folder to PATH again.

## Uninstall

Remove the installed script:

```sh
rm "$HOME/.local/bin/simsize"
```

You can leave the personal commands folder and PATH setting in place for other tools.
