# Le Compte est Bon

Projet implémentant le jeu **« Le compte est bon »** en OCaml, avec :
- un mode jeu classique,
- un mode création d’instance,
- un solveur automatique.

Le projet privilégie des structures simples afin de mettre en avant le raisonnement algorithmique.

---
## Mode jeu classique

### Choix d’implémentation

- Une **liste de 6 entiers**
- Un **entier objectif**

Aucun type complexe n’est utilisé : le jeu fonctionne uniquement opération par opération.

### Principe du jeu

1. L’utilisateur reçoit une liste de valeurs et un objectif.
2. Il saisit une opération sous forme de chaîne de caractères.
3. La chaîne est découpée selon les espaces.
4. Si l’opération est valide :
   - les valeurs utilisées sont retirées de la liste,
   - le résultat est ajouté à la liste.

Le jeu se termine lorsque l’objectif est atteint ou qu’aucun coup valide n’est possible.

### Fonctions principales et complexité

- `afficher_jeu` : affiche la liste des valeurs — `O(|l|)`
- `update_liste` : retire une occurrence d’un élément — `O(|l|)`
- `nb_elt_l` : compte les occurrences d’un élément — `O(|l|)`
- `jouer_coup` : joue un coup si possible — `O(|str| + |l|)`
- `jouer` : boucle principale du jeu — `O(|l|²)`

---

## Mode création d’instance

Ce mode génère :
- une liste de 6 valeurs,
- un objectif.

### Complexité

- Génération de la liste : `O(n)`
- Génération de l’objectif : `O(1)`

---

## Solveur automatique

### Choix techniques

Le type `option` est utilisé pour éviter :
- la division par zéro,
- les divisions non entières.

### Méthode algorithmique

Le solveur utilise une **approche naïve exhaustive** :

- `6!` permutations de la liste
- `4⁶` combinaisons d’opérations par permutation

Soit **2 949 120 tests** au total.

### Fonctionnement

1. Génération de toutes les permutations de la liste.
2. Pour chaque permutation :
   - test de toutes les combinaisons d’opérations,
   - retour d’une solution si l’objectif est atteint.
3. Le solveur s’arrête dès qu’une solution est trouvée.

### Fonctions principales et complexité

- `vtoop` : valeur associée à un opérateur — `O(1)`
- `pfmd` : applique une opération (+, −, ×, ÷) — `O(1)`
- `testcombinaison` : cherche une solution — `O(4^{|l|})`
- `inselt` : insertion d’un élément à toutes les positions
- `permute` : génère toutes les permutations — `O(|l|!)`
- `rvl` : inverse une liste — `O(|l|)`
- `affichersolution` : affiche une solution — `O(|l|)`
- `sdlm` (*solveur de la mort*) : teste toutes les permutations

---

## Compilation et exécution

```bash
make
./comptebon
