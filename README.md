# Backup Lab — Bash + rsync automation

Professional Bash backup script demonstrating safe, automated Linux backups using **rsync**, logging, dry-run testing, and rotation.

This project simulates real-world system administration tasks used in freelance Linux backup automation.

---

## Features

* Local automated backups using `rsync`
* Dry-run mode for safe testing
* Timestamped execution logs
* Automatic backup rotation
* Safety checks to prevent overwrite
* External configuration file
* Structured project layout

---

## Use case (real world)

This script can be adapted for:

* server backups
* workstation backup automation
* scheduled cron backups
* simple disaster recovery workflows

---

## Requirements

* Linux (VM or server recommended)
* bash
* rsync

---

## Quick start

```bash
git clone <repo_url>
cd backup-lab
bash scripts/backup.sh
```

Dry run mode:

```bash
DRY_RUN=1 bash scripts/backup.sh
```

---

## Mini demo

Example run:

```
bash scripts/backup.sh
```

Output:

```
[INFO] Starting backup...
[OK] Backup completed: backups/2026-02-09_21-30-12
[OK] Log written to logs/backup.log
```

## Configuration

Edit:

```
scripts/backup.conf
```

Key variables:

* source directory
* destination directory
* log directory
* rotation settings

---

## Project structure

```
backup-lab/
├── scripts/     backup script(s)
├── data/        sample data
├── backups/     generated backups (ignored by Git)
├── logs/        execution logs (ignored by Git)
└── README.md
```

---

## Backup workflow

data → backup.sh → backups/ + logs/

The script reads configuration, copies data safely with rsync,
creates timestamped backups and writes execution logs.

## Notes

This repository is a learning and portfolio project focused on:

* Bash scripting
* backup automation
* safe system administration practices
* logging and error handling

WSL is used for learning. Real deployments are intended for Linux VMs or servers.

---

## Author

Linux backup automation portfolio project.
