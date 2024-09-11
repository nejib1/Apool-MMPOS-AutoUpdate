# (Qubic Mining) MMPOS Apool Miner Auto-Update Script

The script is designed to automatically update the apool miner on MMPOS by checking GitHub for the latest version, ensuring miners in the Qubic mining network are always running the most up-to-date and optimized software..
The script is designed to be scheduled via cron and must be executed from the most recent `/opt/mmp/miners/custom-XXXXX` directory, which corresponds to **apool**.

## Features

- Automatically fetches the latest **apool** miner version from GitHub.
- Skips GitHub checks if the local version was already updated today.
- Downloads the latest version, extracts it, and replaces existing files.
- Can be scheduled to run via cron every Wednesday from noon GMT, every 30 minutes until the first successful download.

## Usage

### Requirements

- **cron**: To schedule the script for automatic execution.
- **curl**: For fetching content from GitHub.
- **tar**: For extracting the miner archive.

### Script Setup

#### Important Note

The script must be run as **root** because it requires permission to modify system directories. You can run the script with `sudo`:


1. Clone the repository or download the script:
   ```bash
   git clone https://github.com/nejib1/Apool-MMPOS-AutoUpdate.git
   cd Apool-MMPOS-AutoUpdate
   ```

2. Copy the script to this directory and make it executable:

   ```bash
   cp update_apool.sh $(ls -td /opt/mmp/miners/custom-*/ | head -1)      
   ```

3. Move to the most recent `custom-XXXXX` directory for **apool** in **MMPOS**. This is necessary because the script operates within this directory:

   ```bash
    cd $(ls -td /opt/mmp/miners/custom-*/ | head -1)
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
*/30 12-23 * * 3 cd $(ls -td /opt/mmp/miners/custom-*/ | head -1) && ./update_apool.sh
```

- `*/30`: Runs every 30 minutes.
- `12-23`: Runs between noon (12:00 PM) and 11:59 PM GMT.
- `* * 3`: Restricts the run to Wednesdays.

The cron job first changes the directory to the most recent `/opt/mmp/miners/custom-XXXXX` folder, then runs the script.

### How It Works
1. **Check for the latest apool version**: The script pulls the latest release version of **apool** from the GitHub repository by scraping the `<h1>` tag from the release page.

2. **Skip if already up-to-date**: If the `last_version.txt` file contains the version number from today, the script does nothing.

3. **Download and extract**: If a new version is found, the script downloads the appropriate `.tar.gz` file from GitHub, extracts its contents directly into the current directory (`/opt/mmp/miners/custom-XXXXX`), and replaces the existing files.

### Author

[Nejib BEN AHMED](https://github.com/nejib1)


