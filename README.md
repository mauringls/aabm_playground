# Ising AABM

Il s'agit d'expérimentations d'Argumentative Agent Based Models (AABM) votant par rapport à une problématique (pour/contre) dont l'évolution des optinions individuelles est continue et modélisée par un modèle d'Ising.

Les "ingrédients" à implémenter sont les suivantes:

- **espace** : un graphe de relations. Nœuds = Individus / Arêtes = Connections. Peut-être pondérer les arêtes pour modéliser une force d'influence, à voir si ça peut s'intégrer au modèle.
- **agents** : essentiellement une polarisation ($\in [-1,1]$). Peut-être essayer d'étoffer dans un second temps.
- **évoution** : modèle d'Ising.