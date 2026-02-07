# backup-lab (Bash + rsync)

A clean and structured Bash automation project demonstrating a configurable backup workflow using **rsync**.

This repository showcases practical scripting skills including error handling, logging, dry-run testing, and organized project structure — designed as a portfolio project for Linux backup and automation workflows.

---

## 🚀 Features

* Automated local backups using `rsync`
* DRY_RUN mode for safe testing (simulation without writing changes)
* Timestamped logs for traceability
* External configuration support
* Clean project structure
* Sensitive files excluded via `.gitignore`

---

## 🧠 Project Architecture

```
backup-lab/
├── scripts/      # Backup scripts
├── data/         # Example data to back up
├── logs/         # Generated logs
├── backups/      # Backup output directory
└── README.md
```

The structure separates scripts, data, and generated files to maintain clarity and reproducibility.

---

## ⚙️ Requirements

* Linux or WSL
* Bash
* `rsync` installed

---

## 📦 Installation

```bash
git clone <repository_url>
cd backup-lab
```

Edit the configuration file to match your environment if needed.

---

## ▶️ Usage

Run the backup script:

```bash
bash scripts/backup.sh
```

Test without writing changes:

```bash
DRY_RUN=1 bash scripts/backup.sh
```

---

## 🔒 Security & Best Practices

* Local configuration and generated files are ignored via `.gitignore`
* The repository avoids publishing sensitive environment data
* Logs provide visibility into backup operations

---

## 💼 Practical Use Cases

This script can be adapted for:

* Small server or workstation backups
* Automated maintenance tasks
* Learning Bash automation workflows
* Lightweight backup solutions for small infrastructures

---

## 🎯 Purpose

This repository is a learning and demonstration project focused on Bash automation and backup workflows. It is designed to showcase scripting practices, organization, and safe testing techniques.

---

## 📄 License

Educational and portfolio use.
