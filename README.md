# backup-lab (bash + rsync)

Simple Bash backup lab using `rsync`.

This project demonstrates a small, configurable backup script with logging and dry-run testing. It is designed as a learning and portfolio project for Linux backup automation.

## Features

- Local backup using `rsync`
- Dry-run mode for safe testing
- Timestamped execution logs
- Clean and organized project structure
- Generated files are not tracked by Git (see `.gitignore`)

## Requirements

- Linux or WSL
- bash
- rsync

## Quick start

```bash
git clone <repo_url>
cd backup-lab
bash scripts/backup.sh
```

Dry run (simulation mode, no files written):

```bash
DRY_RUN=1 bash scripts/backup.sh
```

## Project structure

```
backup-lab/
├── scripts/    backup script(s)
├── data/       sample data to back up
├── backups/    output directory (not tracked by Git)
├── logs/       execution logs (not tracked by Git)
└── README.md
```

Portfolio project focused on Bash scripting and backup automation.
