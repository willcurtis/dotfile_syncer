📁 Dotfile Syncer

Automatically monitor and sync your personal dotfiles to this GitHub repository.

This project uses a background watcher to detect changes to important configuration files and directories, automatically commit them, and push updates to GitHub.

⸻

✨ What it Syncs

The following files and directories are monitored:
	•	~/.zshrc
	•	~/.cloginrc
	•	~/.gitconfig
	•	~/.bash_profile
	•	~/.ssh/

Whenever any of these change, they are automatically copied into this repository and committed.

⸻

⚙️ How It Works
	•	fswatch monitors files and directories for changes.
	•	When changes are detected:
	•	Files/directories are copied into the repository.
	•	Changes are committed with a timestamped message.
	•	Commits are pushed to GitHub over SSH (no password prompts).

The watcher is designed to:
	•	Only sync when actual content changes (not just file modification times).
	•	Support syncing both files and entire directories (like .ssh).

⸻

🛠 Setup Instructions
	1.	Install dependencies (if not already installed):

```bash
brew install fswatch
brew install rsync
```

	2.	Ensure SSH authentication with GitHub is configured:
		•	Add your SSH key to GitHub.
		•	Use the SSH remote URL (git@github.com:yourusername/dotfiles.git).
	
	3.	Clone this repository to your machine:

```bash
git clone git@github.com:yourusername/dotfiles.git ~/Documents/GitHub/dotfiles
```

	4.	Start the sync script manually for testing:

```bash
bash ~/Documents/GitHub/dotfiles/dotfile_syncer.sh
```

🚀 LaunchAgent Setup (macOS)

To run automatically at login:
	1.	Create a LaunchAgent plist at ~/Library/LaunchAgents/com.user.dotfilewatcher.plist:

```bash
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.dotfilewatcher</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/yourusername/Documents/GitHub/dotfiles/dotfile_syncer.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/dotfile_syncer.out</string>
    <key>StandardErrorPath</key>
    <string>/tmp/dotfile_syncer.err</string>
</dict>
</plist>
```

	2.	Load it:

```bash
launchctl load ~/Library/LaunchAgents/com.user.dotfilewatcher.plist
```

📄 Log File

Sync events and any errors are logged to:

```bash
~/Documents/GitHub/dotfiles/dotfile_syncer.log
```


✅ Status
	•	Sync files automatically
	•	Sync directories automatically
	•	Only push actual content changes
	•	Zero password prompts (SSH authentication)
	•	macOS compatible (tested on latest versions)

⸻

📜 License

This project is licensed for personal use.
Feel free to adapt it for your own setup.	
