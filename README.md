# huguescharnallet.org

Site statique de l'association **Les Amis de Hugues Charnallet** — `huguescharnallet.org`.

## Éditer

Tout le texte est dans les fichiers HTML. Chaque passage traduit suit ce patron :

```html
<span data-lang="fr">Texte en français</span>
<span data-lang="en">English text</span>
```

Pour les blocs longs (paragraphes multiples), même logique sur un `<div>` :

```html
<div data-lang="fr"><p>…</p></div>
<div data-lang="en"><p>…</p></div>
```

Header, footer et nav sont dupliqués dans chaque page (volontaire : pas de build). Quand on modifie la navigation, penser à le faire dans les 6 fichiers.

Couleur de marque : variable `--red` dans `assets/css/style.css`.

## Tester en local

```bash
python3 -m http.server 8000
# ouvrir http://localhost:8000
```
