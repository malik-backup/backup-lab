# Backup Lab — Sauvegarde Linux automatisée en Bash

Système de sauvegarde Linux scripté en Bash, conçu pour être fiable, monitoré et exploitable en production. Ce projet illustre l'approche que j'applique pour sécuriser les données critiques sur serveurs Linux.

---

## Voir le code

- [scripts/backup.sh](scripts/backup.sh) — script principal de sauvegarde
- [scripts/backup.conf.example](scripts/backup.conf.example) — modèle de configuration

---

## Fonctionnalités

- Sauvegarde locale automatisée via `rsync`
- Mode `dry-run` pour tests sans risque
- Logs horodatés avec niveaux (INFO / ERROR)
- Rotation automatique des sauvegardes (rétention configurable)
- Vérifications de sécurité (pas d'écrasement accidentel)
- Configuration externalisée (`.conf`)
- Gestion d'erreurs robuste (`set -Eeuo pipefail`, trap ERR)

---

## Cas d'usage

Ce système est conçu pour être adapté à :

- la sauvegarde de serveurs Linux (VPS, serveurs dédiés)
- l'automatisation des sauvegardes via cron
- les workflows de continuité d'activité pour PME et agences web
- les environnements où la fiabilité prime sur la complexité

---

## Prérequis

- Linux (Debian, Ubuntu, AlmaLinux ou équivalent)
- Bash 4+
- rsync

---

## Installation rapide

```bash
git clone https://github.com/malik-backup/backup-lab.git
cd backup-lab
cp scripts/backup.conf.example scripts/backup.conf
# Éditer scripts/backup.conf selon votre environnement
bash scripts/backup.sh
```

Mode test sans modification :

```bash
DRY_RUN=1 bash scripts/backup.sh
```

---

## Configuration

Le fichier `scripts/backup.conf` centralise tous les paramètres :

```bash
SRC=/chemin/source        # Données à sauvegarder
DEST=/chemin/destination  # Emplacement des sauvegardes
LOGDIR=/chemin/logs       # Logs horodatés
KEEP=7                    # Nombre de sauvegardes conservées
```

Cette séparation permet de réutiliser le même script sur plusieurs serveurs avec des configurations différentes.

---

## Exemple d'exécution

```
2026-04-22 08:30:01 [INFO] RUN started
2026-04-22 08:30:01 [INFO] Loading config: scripts/backup.conf
2026-04-22 08:30:02 [INFO] rsync started
2026-04-22 08:30:14 [INFO] rsync succeeded
2026-04-22 08:30:14 [INFO] Rotation: kept 7 most recent backups
2026-04-22 08:30:14 [INFO] RUN finished successfully
```

---

## Structure du projet

```
backup-lab/
├── scripts/
│   ├── backup.sh              # Script principal
│   ├── backup.conf.example    # Modèle de configuration
├── data/                      # Données de test
├── backups/                   # Sauvegardes (ignoré par Git)
├── logs/                      # Logs (ignoré par Git)
└── README.md
```

---

## Workflow

```
data/ → backup.sh → backups/<timestamp>/
→ logs/backup-<date>.log
```

Le script lit la configuration, copie les données via rsync, crée une sauvegarde horodatée, écrit les logs, et applique la rotation.

---

## Bonnes pratiques appliquées

- Gestion stricte des erreurs (`set -Eeuo pipefail`)
- Vérification du fichier de configuration avant exécution
- Trap ERR pour capturer la ligne exacte d'une erreur
- Wrapper DRY_RUN pour tester sans modifier le système
- Logs structurés horodatés à chaque étape

---

## Roadmap

Fonctionnalités prévues dans les prochaines versions :

- [ ] Sauvegarde distante via SSH / rsync over SSH
- [ ] Test de restauration automatisé (vérification de l'intégrité des sauvegardes)
- [ ] Alertes par email en cas d'échec
- [ ] Support de la sauvegarde incrémentale

---

## À propos

Je suis Abdelmalik OUYALIZE, freelance spécialisé dans la sécurisation des sauvegardes Linux pour PME et agences web.

Mon approche : pas de matériel cher, juste une vraie méthode — sauvegardes automatisées, monitorées, et dont la restauration est testée.

LinkedIn : [Abdelmalik OUYALIZE](https://www.linkedin.com/in/abdelmalik-ouyalize-2914413b1/)

Disponible pour des missions Backup Audit & Setup (Paris & remote)

---

## Licence

Projet personnel. Code disponible publiquement à titre de démonstration.