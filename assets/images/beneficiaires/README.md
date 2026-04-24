# Photos des bénéficiaires

Placer ici les 13 photos prises dans les hôpitaux partenaires, nommées :

```
image1.jpg
image2.jpg
image3.jpg
...
image13.jpg
```

Si un fichier manque, la page "Nos actions" affiche un petit placeholder à sa place (pas d'erreur visible côté utilisateur).

## Recommandations

- **Format** : JPEG, largeur 800–1200 px, qualité 80–85 %.
- **Orientation** : portrait privilégié (le gabarit utilise un ratio 3:4).
- **Poids cible** : moins de 250 Ko par photo.
- **Consentement** : seules les photos pour lesquelles la famille et l'hôpital partenaire ont donné leur accord de publication peuvent être utilisées.

## Outils rapides pour redimensionner

macOS (en lot) :
```bash
mogrify -resize 1000x1000 -quality 82 *.jpg   # nécessite ImageMagick
```

En ligne : [squoosh.app](https://squoosh.app).
