# backup-lab (Bash + rsync)

Petit labo de sauvegarde automatisée en Bash utilisant `rsync`.
Objectif : démontrer une structure propre de projet, un script paramétrable via fichier de configuration, des logs, et un mode DRY_RUN.

## Fonctionnalités
- Sauvegarde locale (rsync)
- Mode `DRY_RUN=1` (simulation sans écriture)
- Logs horodatés
- Structure de projet claire (scripts, data, docs, logs, backups)
- Fichiers générés ignorés par Git (`.gitignore`)

## Prérequis
- Linux / WSL
- `rsync` installé

## Installation
```bash
git clone <url_du_repo>
cd backup-lab
