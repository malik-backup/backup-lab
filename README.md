# backup-lab — Linux backup automation (Bash + rsync)

Professional Bash project demonstrating automated Linux backup workflows with logging, compression, and basic system administration tasks.

This repository simulates real-world maintenance operations performed by Linux administrators.

---

## Features

* Automated local backup using **rsync**
* Dry-run mode for safe testing
* Timestamped execution logs
* Archive compression using **tar.gz**
* Disk usage monitoring and quick space checks
* Log inspection and service troubleshooting with **journalctl**
* Basic system service management (**systemctl**)
* Clean and organized project structure

---

## Tech stack

* Linux / WSL
* Bash
* rsync
* tar
* systemctl / journalctl

---

## Quick start

```bash
git clone <repo_url>
cd backup-lab
bash scripts/backup.sh
```

Dry-run (simulation mode, no files written):

```bash
DRY_RUN=1 bash scripts/backup.sh
```

---

## Project structure

```
backup-lab/
├── scripts/    # backup automation scripts
├── data/       # sample data to back up
├── backups/    # generated archives (ignored by Git)
├── logs/       # execution logs (ignored by Git)
└── README.md
```

---

## Skills demonstrated

This project showcases practical Linux administration skills:

* Backup automation scripting
* Archive compression workflows
* Disk space monitoring
* Log analysis and troubleshooting
* Service management with systemctl
* Clean project structuring and documentation

---

## Author

Linux backup & automation specialist
Portfolio project focused on Bash scripting and system administration.
