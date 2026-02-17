# Ising AABM

## Présentation

Il s'agit d'expérimentations d'Argumentative Agent Based Models (AABM) votant par rapport à une problématique (pour/contre) dont l'évolution des optinions individuelles est continue et modélisée par un modèle d'Ising.

Un modèle d'Ising est habituellement donné par son Hamiltonien :
$H(\sigma)=-\sum_{\langle i,j \rangle} J_{i,j} \sigma_i \sigma_j - h \sum_j \sigma_j$

Où $J_{i,j}$ défunit une interaction entre deux sites (agents), $\sigma_j$ le spin d'un site (agent) j, et $h_j$ un champ extérieur.

La version simplifiée de ce modèle néglige le champ ($h_j=0 \forall j$), et prend une interaction unique pour k voisins d'un agent ($J_{i,j}=1$ si $d(i,j) \leq k$, $0$ sinon).

Le modèle évolue ensuite traditionellement grâce à des changements de spins aléatoires effectués avec la méthode de Monte-Carlo Metropolis.

## Notre modèle

L'idée ici est de transformer le modèle d'Ising pour un cas plus propice aux évolutions d'opinions. En particulier, les spins ne valent plus -1 ou 1 mais une valeur continue entre les deux bornes.

Le Hamiltonien continu est par ailleurs donné par :

$H(\sigma)=-\sum_{\langle i,j \rangle} J_{i,j} \phi(\sigma_i, \sigma_j) - h \sum_j \sigma_j$

Le champ h est réintroduit pour signifier une influence extérieure existante lors d'un débat.

La fonction d'interaction J est à complexifier pour indiquer l'influence d'un individu sur un autre. On peut par exemple imaginer qu'un individu avec plus de connections est plus influent, par exemple.

Enfin, le changement de spin à opérer ne correspond plus à une inversion mais à une influence d'attraction ou de rotation due au spin avec lequel l'interaction se produit. Une fonction pertinente est à trouver, mais nos premiers tests se feront sur la suivante :

$\phi_\kappa(\sigma_i,\sigma_j) = \frac{1}{2} tanh(\kappa-|b-a|) b|b-a|$