# MMPOS Apool Miner Auto-Update Script

This project contains a script that automatically checks for the latest version of the **apool** miner from GitHub and updates the local miner on **MMPOS** if a new version is available. The script is designed to be scheduled via cron and must be executed from the most recent `/opt/mmp/miners/custom-XXXXX` directory, which corresponds to **apool**.

## Features

- Automatically fetches the latest **apool** miner version from GitHub.
- Skips GitHub checks if the local version was already updated today.
- Downloads the latest version, extracts it, and replaces existing files.
- Restarts the **MMPOS** rig (`agent-restart`) after a successful update.
- Can be scheduled to run via cron every Wednesday from noon GMT, every 30 minutes until the first successful download.

## Usage

### Requirements

- **MMPOS**: The script uses `agent-restart` to restart the rig.
- **cron**: To schedule the script for automatic execution.
- **curl**: For fetching content from GitHub.
- **tar**: For extracting the miner archive.

### Script Setup

1. Clone the repository or download the script:
   ```bash
   git clone https://github.com/nejib1/Apool-MMPOS-AutoUpdate.git
   cd Apool-MMPOS-AutoUpdate
   ```

2. Move to the most recent `custom-XXXXX` directory for **apool** in **MMPOS**. This is necessary because the script operates within this directory:

   ```bash
    cd $(ls -td /opt/mmp/miners/custom-* | head -1)
   ```

3. Copy the script to this directory and make it executable:

   ```bash
   cp /path/to/update_apool.sh .
   chmod +x update_apool.sh
   ```

4. Ensure the script runs with the necessary permissions.

### Cron Setup
To automatically run the script every Wednesday from noon GMT every 30 minutes until the first successful download, follow these steps:

Open the cron configuration:

```bash
crontab -e
```

Add the following cron job:

```bash
*/30 12-23 * * 3 cd /opt/mmp/miners/$(ls -td /opt/mmp/miners/custom-* | head -1) && ./update_apool.sh
```

- `*/30`: Runs every 30 minutes.
- `12-23`: Runs between noon (12:00 PM) and 11:59 PM GMT.
- `* * 3`: Restricts the run to Wednesdays.

The cron job first changes the directory to the most recent `/opt/mmp/miners/custom-XXXXX` folder, then runs the script.

### How It Works
1. **Check for the latest apool version**: The script pulls the latest release version of **apool** from the GitHub repository by scraping the `<h1>` tag from the release page.

2. **Skip if already up-to-date**: If the `last_version.txt` file contains the version number from today, the script does nothing.

3. **Download and extract**: If a new version is found, the script downloads the appropriate `.tar.gz` file from GitHub, extracts its contents directly into the current directory (`/opt/mmp/miners/custom-XXXXX`), and replaces the existing files.

4. **Restart the rig**: After extracting the files, the script runs `agent-restart` to restart the **MMPOS** rig with the new version of **apool**.

### Example Output

Here is an example of what you might see when the script runs:

```bash
Downloading https://github.com/ddobreff/mmpos/releases/download/v2.1.0/apoolminer-v2.1.0.tar.gz...
Files extracted, archive removed, restarting rig...
```

### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
