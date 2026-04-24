#!/usr/bin/env bash
# =============================================================================
# Déploiement du site Les Amis de Hugues Charnallet sur GitHub Pages
#
# Usage :   cd "<dossier du site>" && bash deploy.sh
# Prérequis : git, et SOIT gh (GitHub CLI) SOIT un dépôt déjà créé sur GitHub.
# =============================================================================
set -e

REPO_NAME="huguescharnallet"
GITHUB_USER="pyduan"
DOMAIN="huguescharnallet.org"

cd "$(dirname "$0")"

echo ""
echo "▶  Dossier : $(pwd)"
echo ""

# 1. Nettoyer un éventuel .git laissé par le sandbox
if [ -d ".git" ] && ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "▶  Nettoyage d'un .git orphelin…"
  rm -rf .git
fi

# 2. Initialiser le dépôt si besoin
if [ ! -d ".git" ]; then
  echo "▶  git init"
  git init -b main
fi

# 3. Configurer l'utilisateur si absent (évite une erreur de commit)
if ! git config user.name >/dev/null; then
  git config user.name "${GITHUB_USER}"
fi
if ! git config user.email >/dev/null; then
  git config user.email "${GITHUB_USER}@users.noreply.github.com"
fi

# 4. Commit
git add .
if git diff --cached --quiet; then
  echo "▶  Rien à committer."
else
  echo "▶  Commit…"
  git commit -m "Site huguescharnallet.org"
fi

# 5. Remote + push via gh si possible, sinon instructions manuelles
if command -v gh >/dev/null 2>&1; then
  if ! gh auth status >/dev/null 2>&1; then
    echo "▶  Connexion GitHub (gh auth login) — suivez les instructions."
    gh auth login -p https -w
  fi

  if ! git remote get-url origin >/dev/null 2>&1; then
    echo "▶  Création du dépôt ${GITHUB_USER}/${REPO_NAME} sur GitHub…"
    gh repo create "${GITHUB_USER}/${REPO_NAME}" \
      --public \
      --description "Site de l'association Les Amis de Hugues Charnallet" \
      --source=. \
      --remote=origin \
      --push
  else
    echo "▶  Push…"
    git push -u origin main
  fi

  echo "▶  Activation de GitHub Pages (branche main, racine)…"
  gh api --silent -X POST "repos/${GITHUB_USER}/${REPO_NAME}/pages" \
    -f "source[branch]=main" -f "source[path]=/" 2>/dev/null || \
  gh api --silent -X PUT "repos/${GITHUB_USER}/${REPO_NAME}/pages" \
    -f "source[branch]=main" -f "source[path]=/" 2>/dev/null || \
  echo "   (Pages est peut-être déjà activé — vérifier dans Settings → Pages)"

  echo ""
  echo "✅  Terminé."
  echo "    Repo    : https://github.com/${GITHUB_USER}/${REPO_NAME}"
  echo "    Pages   : https://${GITHUB_USER}.github.io/${REPO_NAME}/  (en attendant le DNS)"
  echo "    Domaine : https://${DOMAIN}/  (après configuration DNS, voir README.md)"
  echo ""
else
  echo ""
  echo "⚠️   gh (GitHub CLI) n'est pas installé."
  echo "    Deux options :"
  echo ""
  echo "    A) Installer gh puis relancer :    brew install gh"
  echo ""
  echo "    B) Créer le dépôt à la main :"
  echo "       1. Aller sur https://github.com/new"
  echo "       2. Repository name : ${REPO_NAME}, Public, ne pas cocher README."
  echo "       3. Revenir dans ce terminal et exécuter :"
  echo "          git remote add origin git@github.com:${GITHUB_USER}/${REPO_NAME}.git"
  echo "          git push -u origin main"
  echo "       4. Sur https://github.com/${GITHUB_USER}/${REPO_NAME}/settings/pages"
  echo "          → Source : Deploy from a branch, Branch : main / (root), Save."
  echo ""
fi
