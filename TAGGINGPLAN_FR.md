# Plan de taggage iOS

## Tracking d'une application webview

En ce qui concerne la navigation dans le contexte d'une application de type //webview// sur IOS (site web html/js standard), notre identifiant interne doit être fourni dans l'url d'ouverture afin d'assurer la continuité du tracking. 
Pour récupérer cette valeur, la technique du client doit utiliser la fonction suivante définie dans notre SDK:

  * iOS - Swift :
```xml
let euidl = EAnalytics.euidl
```

  * iOS - ObjectiveC :
```xml
NSString *euidl = [EAnalytics euidl];
```

Une fois cette valeur fournie dans le paramètre **ea-euidl-bypass**, on débraye le système de cookie usuel pour utiliser l'euidl en provenance de l'application.

**Exemple:**

```xml
http://www.vpg.fr/ios-landing-webview?ea-euidl-bypass=$euidl_de_l_app
```

Si le ea.js détecte ce paramètre alors il l'utilise et le stocke en interne tout le long de la session, ceci afin d'éviter que le site ne le repasse a chaque page visitée. 
Une fois ce passage de paramètre effectué, le tracking d'une application IOS en contexte webview ne diffère pas des formats Javascript que nous utilisons pour un site web classique.

La documentation disponible à [cette adresse](https://eulerian.wiki/doku.php?id=fr:modules:collect:onsite_collection:taggingplan_web&s[]=webview#tab__mobiles) contient toutes les informations nécessaires à l'implémentation de nos Tags Javascript.


## Tracking d'une application native

Dans le cas d'une application native, notre SDK doit être incorporé au code source de l'application pour pouvoir intégrer le type de marqueur suivant: 

```xml
let genericTag = EAProperties(path: "|univers|rubrique|page")
genericTag.setEulerianWithUid("5434742")
genericTag.setEulerianWithEmail("test@test.fr")
genericTag.setEulerianWithProfile("visitor")
genericTag.setEulerianWithPageGroup("pagegroup")
genericTag.setEulerianWithValue("mensuel", forKey: "abonnement")
EAnalytics.track(genericTag)
```

Notre **SDK** a été conçu pour faciliter au maximum l'intégration en offrant une structure objet simple à utiliser et une documentation détaillée. 
Les paramètres disponibles et les possibilités sont exactement les mêmes. Vous pourrez donc suivre les performances de votre application comme si il s'agissait d'un site web classique en intégrant les mêmes variables.

Les appels générés par ces marqueurs sont également très proches de l'appel collector classique et ont été conçus pour être le plus léger possible afin de ne pas perturber l'application. 
Certains paramètres de notre collector sont spécifiques au tracking d'une application mobile. Pour plus d'informations à ce sujet consultez [cette documentation](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

Note : Notre SDK est également capable de collecter un nombre illimité d'interactions offline et de les envoyer une fois l'utilisateur connecté. Ce procédé nous permet de continuer à tracker l'internaute même si ce dernier interagit avec votre application hors connection. La navigation est enregistrée et réattribuée à posteriori via notre paramètre ereplay-time.


### Règle d'affectation de trafic

Sur un site web classique, notre système identifie et affecte le trafic en fonction de l'**URL** sur lequel le marqueur est appelé. Nous n'avons cependant pas accès à cette information dans le contexte d'une application.

Pour définir la règle d'attribution de traffic, nous nous basons donc sur le sous domaine de tracking utilisé et passé en paramètre de la méthode **initialize** de notre SDK:

```xml
EAnalytics.logDebug(true)
EAnalytics.initialize(DOMAINE_DE_TRACKING)
```

Note : Ça signifie aussi que si vous utilisez le même sous domaine de tracking pour plusieurs de vos applications, nous devrons les distinguer en ajoutant le paramètre [from](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list) dans les marqueurs. Ce sera automatiquement le cas pour une application hybride qui partage certaines pages en commun avec votre site web.

A noter également que l'absence d'URL signifie aussi l'absence d'un nom de page par défaut. Le paramètre [path](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list) n'est pas optionnel mais __obligatoire__ dans le tracking d'une application.

Le trafic généré par votre application peut remonter sur un site Eulerian dédié ou être fusionné avec celui d'un autre site web existant. Comme indiqué plus haut, si votre application passe en mode webview pour certaines pages l'ajout du paramètre [from](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list) est obligatoire pour nous permettre de rediriger le trafic correctement dans nos systèmes. 

## Métriques téléchargement et mise à jour

Déscription des paramètres associés : 
  * **ea-appname** : NOM_APPLICATION , correspond au nom de l’application. Ce dernier ne doit pas changer
  * **ea-appversion** : VERSION_APPLICATION , correspond à la version de l’application
  * **ea-appinstalled** : 1 ,  Ce parametre signale qu'il ne faut pas compter de nouvelle installation pour cet appel.
Il sert à gérer l'initialisation des users ayant déjà l'application avant l'intégration d'Eulerian.
Ce parametre peut être fourni en permanence, en parallele de appversion et appname, dès lors que l'application considére qu'elle avait déjà été lancée précédemment sur ce device/user.

La présence du paramètre **ea-appname** déclenche un traitement au niveau du système. 

Le système va alimenter la métrique **téléchargement** si :
  * Le user n’a jamais été exposé à la valeur du paramètre **ea-appname** au moment de l’ouverture de l’application et le paramètre **ea-appinstalled** n’est pas présent dans l’appel

Le système va alimenter la métrique **Mise à jour** si :
  * Le user a déjà été exposé au paramètre **ea-appname** et sa valeur est identique à celle présente lors de la dernière ouverture de l’application. Par contre, la valeur du paramètre **ea-appversion** est différente.

![download_upgrade.png](https://bitbucket.org/repo/kA6LdM/images/3930826066-download_upgrade.png)

# Liste des pages #

  * Page générique
  * Page produit
  * Page catégorie
  * Page moteur de recherche
  * Page erreur
  * Page devis
  * Page panier
  * Page commande
  
# Page générique

Le marqueur ci-dessous est générique et doit être implémenté sur toutes les pages du site hors fiche produit, commande, devis et panier commencé. Ça inclut notamment la homepage et les pages du tunnel de conversion entre le panier et la confirmation de commande.

Il vous permet de remonter tout le traffic site-centric, les pages vues et visites ainsi que la provenance via les leviers naturels comme l'accès direct, le référencement naturel ou les référents.

Nous gérons ensuite l’intégralité des actions à mettre en place en délocalisé. Ainsi, vous n'avez pas besoin de changer le code de la page sur votre site pour bénéficier de fonctionnalités supplémentaires.

Vous pouvez ajouter les paramètres ci-après au format générique ou à l'ensemble des marqueurs collector décrits dans cette documentation afin d'enrichir vos rapports.
## Liste des paramètres

  * __**path :**__ (Obligatoire) Ce paramètre permet de donner un nom à la page afin de l'identifier dans les rapports. Pour en savoir plus veuillez vous reporter à [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**uid :**__ (Optionnel) Ce paramètre doit être valorisé avec votre ID interne quand l'internaute est loggé afin de consolider l'historique accumulée sur les différents devices utilisés. Vous pouvez ainsi réconciler un clic avec le téléchargement de l'application. Pour en savoir plus, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

## Implémentation

L'objet **EAProperties** est la classe mère qui contient tous les paramètres internes ou modifiables de notre Tag collector. 

Pour ajouter un nouveau paramètre, utilisez la méthode **setEulerianWithValue("VALEUR", forKey: "CLE")** dans le cas d'un paramètre personnalisé.

__**Exemple .swift:**__

```xml
let genericTag = EAProperties(path: String!)
genericTag.setEulerianWithPageGroup(value: String!)
genericTag.setEulerianWithUid(value: String!)
genericTag.setEulerianWithEmail(value: String!)
genericTag.setEulerianWithProfile(value: String!)
EAnalytics.track(genericTag)
```

__**Avec valeurs:**__

```xml
let genericTag = EAProperties(path: "generic-page")
genericTag.setEulerianWithPageGroup("my-pagegroup")
genericTag.setEulerianWithUid("123asd")
genericTag.setEulerianWithEmail("test@test.fr")
genericTag.setEulerianWithProfile("visitor")
EAnalytics.track(genericTag)
```

# Page produit

Ce marqueur permet de récupérer les pages vue et visites des produits de votre catalogue. Il sert notamment à alimenter les rapports disponibles à l'adresse suivante :

  * Site-centric > Produits > **Acquisitions & Performance produit**

Vous pouvez également passer une ou plusieurs catégories de produit.

**Note : Est considéré comme une page produit tout marqueur contenant une et une seule référence produit sans les paramètres __scart__ __estimate__ __ref__ et __amount__.**

En clair, un marqueur collector qui contient un des paramètres cités ci-dessus ou plusieurs références produit ne sera pas interprété par notre système comme un marqueur de page produit.


## Liste des paramètres

  * __**path :**__ (NOM_PAGE) Ce paramètre permet de donner un nom à la page afin de l'identifier dans les rapports. Il n'est pas recuperé automatiquement s'il n'est pas peuplé (comme pour la partie web) donc il doit etre parametré en function de votre usage. Pour en savoir plus veuillez vous reporter à [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**uid :**__ (UID) Ce paramètre doit être valorisé avec votre ID interne quand l'internaute est loggé afin de consolider l'historique accumulée sur les différents devices utilisés. Vous pouvez ainsi réconciler un clic avec le téléchargement de l'application. Pour en savoir plus, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdref :**__ (ID_PRODUIT) Ce paramètre doit être valorisé avec la référence du produit consulté par l'internaute. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdname :**__ (NOM_PRODUIT) Vous pouvez associer à une référence produit un nom plus lisible pour faciliter votre reporting. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdparam-xxxxx :**__ (VALEUR_PARAM, NOM_PARAM) Ce paramètre permet d'associer une catégorie à la référence du produit. Vous devez préciser le nom de la catégorisation après le préfixe **prdparam-**. Exemples : prdparam-univers, prdparam-taille etc. Vous pouvez ajouter autant de catégorisations que souhaité. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

## Implémentation

L'objet **EAProducts** est la classe dédiée au tracking des pages produit.

Le produit en lui même doit être créé via l'objet **EAOProduct** qui prend la référence en paramètre obligatoire. 
L'ajout de paramètres produits nécessite la création d'un objet **Params** indépendant de l'objet **EAOProduct**.

Une fois **EAOProduct** initialisé et complété, intégrez le à l'objet EAProducts via la méthode **setEulerianWithValue("VALEUR", forKey: "CLE")**. 

__**Exemple:**__

```xml
//create object product
let product1 = EAOProduct(ref: String)
product1.setEulerianWithName(value: String)
product1.setEulerianWithGroup(value: String)

//product parameter
let param1 = EAOParams()
param1.setEulerianWithStringValue(value: String!, forKey: String!)
param1.setEulerianWithStringValue(value: String!, forKey: String!)

//link param1 to product1
product1.setEulerianWith(params: param1)
       
//product page
let productPage = EAProducts(path: String!)
productPage.setEulerianWithPageGroup(value: String!)
productPage.setEulerianWithUid(value: String!)
productPage.setEulerianWithEmail(value: String!)
productPage.setEulerianWithProfile(value: String!)

//link product1 to the product page
productPage.setEulerianWith(eaoproducts: Any!)
EAnalytics.track(productPage)
```

__**Avec valeurs:**__

```xml
//create object product
let product1 = EAOProduct(ref: "PH774356")
product1.setEulerianWithName("T-shirt")
product1.setEulerianWithGroup("product-group")

//product parameter
let param1 = EAOParams()
param1.setEulerianWithStringValue("clothes", forKey: "category")
param1.setEulerianWithStringValue("sportswear", forKey: "sub-category")

//link param1 to product1
product1.setEulerianWith(param1)
       
//product page
let productPage = EAProducts(path: "product-page")
productPage.setEulerianWithPageGroup("my-pagegroup")
productPage.setEulerianWithUid("123asd")
productPage.setEulerianWithEmail("test@test.fr")
productPage.setEulerianWithProfile("looker")

//link product1 to the product page
productPage.setEulerianWith(product1)
EAnalytics.track(productPage)
```

# Page catégorie

Ce marqueur permet d'envoyer à vos partenaires les 3 premières références produit listées dans la page de résultat pour optimiser le retargeting des internautes sur votre site. 
Son utilisation se limite principalement à notre produit Eulerian Tag Master et n'impacte pas le rapport acquisition&performance produit dans Eulerian DDP.

**Note : Est considéré comme une page de résultat tout marqueur contenant plusieurs références produit sans les paramètres __scart__ __estimate__ __ref__ et __amount__.**


Dans le cas ou votre page de résultat ne contiendrait qu'une seule référence produit et donc un seul paramètre **prdref**, le marqueur sera interprété comme une page produit et non une page de résultat.

## Liste des paramètres

  * __**prdref :**__ (ID_PRODUIT) Ce paramètre doit être valorisé avec la référence du produit consulté par l'internaute. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**path :**__ (NOM_PAGE) Ce paramètre permet de donner un nom à la page afin de l'identifier dans les rapports. Il n'est pas recuperé automatiquement s'il n'est pas peuplé (comme pour la partie web) donc il doit etre parametré en function de votre usage. Pour en savoir plus veuillez vous reporter à [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**uid :**__ (UID) Ce paramètre doit être valorisé avec votre ID interne quand l'internaute est loggé afin de consolider l'historique accumulée sur les différents devices utilisés. Vous pouvez ainsi réconciler un clic avec le téléchargement de l'application. Pour en savoir plus, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

## Implémentation

L'objet **EAProducts** est également utilisé pour le tracking des pages de résultat.

Chaque produit doit être créé via l'objet **EAOProduct** qui prend la référence en paramètre obligatoire. 

__**Exemple:**__

```xml
let product1 = EAOProduct(ref: String)
let product2 = EAOProduct(ref: String)
let product3 = EAOProduct(ref: String)
 
let categoryPage = EAProducts(path: String!)
categoryPage.setEulerianWithPageGroup(value: String!)
categoryPage.setEulerianWithUid(value: String!)
categoryPage.setEulerianWithEmail(value: String!)
categoryPage.setEulerianWith(product1)
categoryPage.setEulerianWith(product2)
categoryPage.setEulerianWith(product3)

EAnalytics.track(categoryPage)
```

__**Avec valeurs:**__

```xml
let product1 = EAOProduct(ref: "CH32452")
let product2 = EAOProduct(ref: "C654322")
let product3 = EAOProduct(ref: "V643536")

let categoryPage = EAProducts(path: "Category-page")
categoryPage.setEulerianWithPageGroup("my-pagegroup")
categoryPage.setEulerianWithUid("123asd")
categoryPage.setEulerianWithEmail("test@test.fr")
categoryPage.setEulerianWith(product1)
categoryPage.setEulerianWith(product2)
categoryPage.setEulerianWith(product3)

EAnalytics.track(categoryPage)
```

# Page moteur de recherche

Le marqueur de moteur de recherche interne permet de remonter dans l'interface les requêtes tapées par les internautes ainsi qu'un nombre illimité de paramètres additionnels. Toutes ces informations sont croisées avec les ventes générées et les leviers d'acquisition activés pendant la session.

**Note : Est considéré comme une page de moteur de recherche interne tout marqueur contenant le paramètre __isearchengine__.**



A noter que le marqueur de moteur interne n'est pas exclusif. Si vous ajoutez une référence produit avec le paramètre **prdref** par exemple, le marqueur sera également considéré comme une page produit.

## Liste des paramètres

  * __**path :**__ (NOM_PAGE) Ce paramètre permet de donner un nom à la page afin de l'identifier dans les rapports. Il n'est pas recuperé automatiquement s'il n'est pas peuplé (comme pour la partie web) donc il doit etre parametré en function de votre usage. Pour en savoir plus veuillez vous reporter à [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**uid :**__ (UID) Ce paramètre doit être valorisé avec votre ID interne quand l'internaute est loggé afin de consolider l'historique accumulée sur les différents devices utilisés. Vous pouvez ainsi réconciler un clic avec le téléchargement de l'application. Pour en savoir plus, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**isearchengine :**__ (NOM_MOTEUR_INTERNE) Ce paramètre désigne le nom du moteur interne et permet de le distinguer des autres champs de recherche si vous en avez plusieurs sur votre site. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**isearchresults :**__ (NOMBRE_DE_RESULTATS) Ce paramètre doit contenir le nombre de résultats de recherche générés par l'internaute. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**isearchkey :**__ (CLE_DU_PARAMETRE_RECHERCHE) Ce paramètre doit être valorisé avec la clé du champ additionnel que vous souhaitez intégrer à votre marqueur de recherche interne. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**isearchdata :**__ (VALEUR_DU_PARAMETRE_RECHERCHE) Ce paramètre doit contenir la valeur du champ isearchkey cité plus haut. Chaque champ de recherche supplémentaire nécessite l'ajout d'un nouveau couple de paramètres isearchkey et isearchdata. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

## Implémentation

L'objet **EASearch** est la classe dédiée au tracking du moteur de recherche interne.

Créez un objet **Params** et utilisez la méthode **setEulerianWithStringValue("VALEUR", forKey: "CLE")** pour chaque couple de paramètres **isearchkey**, **isearchdata**.

__**Exemple :**__

```xml
let params = EAOParams()
params.setEulerianWithStringValue(value: String!, forKey: String!)
params.setEulerianWithStringValue(value: String!, forKey: String!)
params.setEulerianWithStringValue(value: String!, forKey: String!)
 
let search = EASearch(path: String!, withName: String!)
searchPage.setEulerianWithPageGroup(value: String!)
searchPage.setEulerianWithUid(value: String!)
searchPage.setEulerianWithEmail(value: String!)
searchPage.setEulerianWithResults(Int32!)
searchPage.setEulerianWith(EAOParams!)
EAnalytics.track(searchPage)
```

__**Avec valeurs:**__

```xml
let params = EAOParams()
params.setEulerianWithStringValue("t-shirt", forKey: "my-search-bar")
params.setEulerianWithStringValue("100.00", forKey:"prix_min")
params.setEulerianWithStringValue("400.00", forKey:"prix_max")

let searchPage = EASearch(path: "search-engine-page", name: "name-internal-search-engine")
searchPage.setEulerianWithPageGroup("my-pagegroup")
searchPage.setEulerianWithUid("123asd")
searchPage.setEulerianWithEmail("test@test.fr")
searchPage.setEulerianWithResults(20)
searchPage.setEulerianWith(params)
EAnalytics.track(searchPage)
```

# Page d'erreur 404

Le marqueur **error** indique que l’applicatif du site pour cette page a généré une erreur 404. Il sert notamment à alimenter les rapports disponibles à l'adresse suivante :

  * Site-centric > Analyse d'audience > Par page > **Page en erreur**

Ce tag permet de récupérer toutes les URLs qui ont généré une page 404 et vous donne la possibilité de faire les corrections nécessaires pour rediriger votre trafic en conséquence.

Vous pouvez notamment l'utiliser pour être alerté en cas de problème récurrent sur une étape particulière de votre tunnel de conversion.


## Liste des paramètres

  * __**error :**__ (Obligatoire) Ce paramètre vaut toujours **1** et peut être ajouté sur tous les types de marqueur. Sa présence dans le marqueur comptabilise une page vue dans le rapport cité ci-dessus. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**path :**__ (Obligatoire) Ce paramètre permet de donner un nom à la page afin de l'identifier dans les rapports.Pour en savoir plus veuillez vous reporter à [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

## Implémentation

Utilisez la méthode set avec la clé error pour flagger la page en erreur. 

__**Exemple:**__

```xml
let errorTag = EAProperties(path: String!)
errorTag.setEulerianWithValue(1, forKey: String!)
EAnalytics.track(errorTag)
```

__**Avec valeurs:**__

```xml
let errorTag = EAProperties(path: "error-page")
errorTag.setEulerianWithValue(1, forKey: "error")
EAnalytics.track(errorTag)
```


# Page de devis

Ce marqueur comptabilise les devis et l'ensemble des informations associées à ce type de conversion : 
  * Les produits qui le composent. 
  * Le type de devis.
  * Le montant global
  * Des informations contextuelles 

Chaque nouveau devis est ainsi détaillé avec tous les leviers et l'historique de navigation qui a conduit à sa génération. 

**Note : Les devis sont dédoublonnés en fonction de la référence fournie dans le marqueur.**


Si vous utilisez 2 fois la même référence pour 2 devis différents, le second appel est ignoré en vertu du principe d'unicité de la conversion.

Eulerian Analytics vous permet d'annuler ou de valider des devis pour mesurer la performance réelle de vos campagnes dans le temps. 

**Note : Est considéré comme une page de devis tout marqueur contenant les paramètres __ref__ et __estimate__.**



## Liste des paramètres

  * __**path :**__ (NOM_PAGE) Ce paramètre permet de donner un nom à la page afin de l'identifier dans les rapports. Il n'est pas recuperé automatiquement s'il n'est pas peuplé (comme pour la partie web) donc il doit etre parametré en function de votre usage. Pour en savoir plus veuillez vous reporter à [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**uid :**__ (UID) Ce paramètre doit être valorisé avec votre ID interne quand l'internaute est loggé afin de consolider l'historique accumulée sur les différents devices utilisés. Vous pouvez ainsi réconciler un clic avec le téléchargement de l'application. Pour en savoir plus, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**ref :**__ (REFERENCE_DEVIS) Il s'agit de la référence unique du devis permettant d'identifier et de retrouver ce dernier dans notre système. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**amount :**__ (MONTANT_DEVIS) Ce paramètre doit contenir le montant total TTC du devis. Les décimales doivent être séparées par un point. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**type :**__ (TYPE_DE_DEVIS) Ce paramètre permet de catégoriser le devis selon votre propre référentiel. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdref :**__ (ID_PRODUIT) Ce paramètre doit être valorisé avec la référence du produit associé au devis et répété pour chaque valeur différente. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdamount :**__ (MONTANT_PRODUIT) Ce paramètre permet de spécifier le montant unitaire de chaque produit associé au devis. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdquantity :**__ (QUANTITE_PRODUIT) Ce paramètre permet de spécifier les quantités de chaque produit associé au devis. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

__**Exemple:**__

## Implémentation

L'objet **EAEstimate** est la classe dédiée au tracking de la page devis.

Un devis peut contenir un ou plusieurs produits. Chaque produit constituant le devis doit être créé via l'objet **EAOProduct** qui prend sa référence en paramètre obligatoire.
Chaque objet **EAOProduct** doit être initialisé et complété avec les paramètres souhaités avant d'être intégré à l'objet **EAEstimate** via la méthode setEulerianWith***. 

**Exemple:**

```xml
let product1 = EAOProduct(ref: String!)
let product2 = EAOProduct(ref: String!)
         
let estimatePage = EAEstimate(path: String!, withRef: String!)
estimatePage.setEulerianWithPageGroup(value: String!)
estimatePage.setEulerianWithUid(value: String!)
estimatePage.setEulerianWithEmail(value: String!)
estimatePage.setEulerianWithType(value: String!)
estimatePage.setEulerianWithAmount(value: Double!)
estimatePage.setEulerianWithCurrency(value: String!)

//custom parameter
estimatePage.setEulerianWithValue(value: Any!, forKey: String!)
estimatePage.setEulerianWithValue(value: Any!, forKey: String!)

estimatePage.addEulerian(product: EAOProduct!, amount: Double, quantity: Int32)
estimatePage.addEulerian(product: EAOProduct!, amount: Double, quantity: Int32)
EAnalytics.track(estimatePage)
```

**Avec valeurs:**
```xml
let product1 = EAOProduct(ref: "product1")
let product2 = EAOProduct(ref: "product2")
         
let estimatePage = EAEstimate(path: "page-devis", withRef: "ref-devis-123")
estimatePage.setEulerianWithPageGroup("my-pagegroup")
estimatePage.setEulerianWithUid("123asd")
estimatePage.setEulerianWithEmail("test@test.fr")
estimatePage.setEulerianWithType("my-estimate-type")
estimatePage.setEulerianWithAmount(12.34)
estimatePage.setEulerianWithCurrency("EUR")

//custom parameter
estimatePage.setEulerianWithValue("VALUE1", forKey: "MY_KEY1")
estimatePage.setEulerianWithValue("VALUE2", forKey: "MY_KEY2")

estimatePage.addEulerian(product1, amount: 11.34, quantity: 1)
estimatePage.addEulerian(product2, amount: 1, quantity: 1)
EAnalytics.track(estimatePage)
```

# Page panier

Ce marqueur comptabilise les paniers commencés et permet le calcul du taux de conversion et d'abandon par rapport au marqueur de vente.

Vous pouvez également passer les produits et catégories de produits associées au panier du visiteur en spécifiant les montants et quantités respectives. Ces paramètres permettent d'alimenter les rapports produits disponibles à l'adresse suivante :

  * Site-centric > Produits > **Acquisitions & Performance produit**

La durée de vie d'un panier est de 30 minutes glissantes soit la session de l'internaute selon [[fr:glossary|notre définition]]. 

## Liste des paramètres

  * __**scartcumul :**__ (Obligatoire) La valeur de ce paramètre indique le mode de comptabilisation des produits dans le panier. Lorsqu'il est égal à 0 notre système interprète les produits passés dans le marqueur comme constituant l'intégralité du panier. Lorsqu'il est égal à 1 les produits passés dans le marqueur s'additionneront à chaque appel successif. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**path :**__ (NOM_PAGE) Ce paramètre permet de donner un nom à la page afin de l'identifier dans les rapports. Il n'est pas recuperé automatiquement s'il n'est pas peuplé (comme pour la partie web) donc il doit etre parametré en function de votre usage. Pour en savoir plus veuillez vous reporter à [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**uid :**__ (Optionnel) Ce paramètre doit être valorisé avec votre ID interne quand l'internaute est loggé afin de consolider l'historique accumulée sur les différents devices utilisés. Vous pouvez ainsi réconciler un clic avec le téléchargement de l'application. Pour en savoir plus, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdref :**__ (Obligatoire) Ce paramètre doit être valorisé avec la référence du produit mis en panier par l'internaute et répété pour chaque produit différent. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdamount :**__ (Obligatoire) Ce paramètre permet de spécifier le montant unitaire de chaque produit différent dans le panier. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdquantity :**__ (Obligatoire) Ce paramètre permet de spécifier les quantités de chacun des produits listés dans le panier. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

## Implémentation

L'objet **EACart** est la classe dédiée au tracking de la page panier commencé.

Un panier peut contenir un ou plusieurs produits. Chaque produit constituant le panier doit être créé via l'objet **EAOProduct** qui prend sa référence en paramètre obligatoire. 
Chaque objet **EAOProduct** doit être initialisé et complété avec les paramètres souhaités avant d'être intégré à l'objet **EACart** via la méthode addEulerian. 

__**Exemple:**__

```xml
let product1 = EAOProduct(ref: String!)
let product2 = EAOProduct(ref: String!)
        
//product parameter
let param1 = EAOParams()
param1.setEulerianWithStringValue(value: String!, forKey: String!)
let param2 = EAOParams()
param2.setEulerianWithStringValue(value: String!, forKey: String!)
       
//link parameters to products
product1.setEulerianWith(value: EAOParams!)
product2.setEulerianWith(value: EAOParams!)

//tag
let cartPage = EACart(path: String!#>)
cartPage.setEulerianWithPageGroup(value: String!)

//user information
cartPage.setEulerianWithUid(value: String!)
cartPage.setEulerianWithEmail(value: String!)
cartPage.setEulerianWithProfile(value: String!)

//set scartcumul
cartPage.setEulerianWithCumul(value: Bool!)

//custom parameter
cartPage.setEulerianWithValue(value: Any!, forKey: String!)
cartPage.setEulerianWithValue(value: Any!, forKey: String!)

//add products tu cart
cartPage.addEulerian(product: EAOProduct!, amount: Double!, quantity: Int32)
cartPage.addEulerian(product: EAOProduct!, amount: Double!, quantity: Int32)
EAnalytics.track(cartPage)
```

__**Avec valeurs:**__

```xml
let product1 = EAOProduct(ref: "ref_product_1")
let product2 = EAOProduct(ref: "ref_product_2")
        
//product parameter
let param1 = EAOParams()
param1.setEulerianWithStringValue("red", forKey: "color")
let param2 = EAOParams()
param2.setEulerianWithStringValue("large", forKey: "dimension")
        
//link parameters to products
product1.setEulerianWith(product1)
product2.setEulerianWith(product2)


//tag
let cartPage = EACart(path: "cart-page")
cartPage.setEulerianWithPageGroup("my-pagegroup")

//user information
cartPage.setEulerianWithUid("123asd")
cartPage.setEulerianWithEmail("test@test.fr")
cartPage.setEulerianWithProfile("shopper")

//set scartcumul
cartPage.setEulerianWithCumul(false)

//custom parameter
cartPage.setEulerianWithValue("VALUE1", forKey: "MY_KEY1")
cartPage.setEulerianWithValue("VALUE2", forKey: "MY_KEY2")

//add products tu cart
//repeat for every product
cartPage.addEulerian(product1, amount: 5.5, quantity: 1)
cartPage.addEulerian(product2, amount: 3.2, quantity: 3)
EAnalytics.track(cartPage)
```

# Page de commande

Ce marqueur comptabilise les conversions et permet le calcul du ROI pour l'ensemble de vos leviers marketing. En plus du montant global de la commande, vous pouvez passer les produits associés, le mode de paiement, la devise ou le type de vente. Ces propriétés enrichissent le niveau de détail disponible dans vos reportings et peuvent être exploités dans toute notre suite produit. Chaque nouvelle conversion est ainsi détaillée avec tous les leviers et l'historique de navigation. 

**Note : Les commande sont dédoublonnées en fonction de la référence fournie dans le marqueur de vente.**


Si vous utilisez 2 fois la même référence pour 2 commandes différentes, le second appel est ignoré en vertu du principe d'unicité de la commande.

Eulerian DDP vous permet d'annuler des commandes pour mesurer la performance réelle de vos campagnes. Il est par conséquent conseillé d'implémenter le marqueur de commande le plus tôt possible dans le processus d'achat si les informations nécessaires pour l'appeler sont disponibles (référence, montant, type de paiement, etc).

En effet, si la plateforme de paiement ne force pas l'internaute à repasser par le site marchand pour valider sa commande, un marqueur positionné après la plateforme de paiement ne sera pas toujours appelé.

**Note : En dehors du statut de la commande (pending, valid ou invalid), il est impossible de redéfinir le contenu d'une commande à posteriori de son enregistrement. On ne peut pas ajouter ou retirer un produit mais il est possible par contre de modifier le montant global de la commande.**



**Note : Est considéré comme une page de confirmation de commande tout marqueur contenant les paramètres __ref__ et __amount__ et ne contenant ni __scart__ ni __estimate__.**



## Liste des paramètres

  * __**path :**__ (NOM_PAGE) Ce paramètre permet de donner un nom à la page afin de l'identifier dans les rapports. Il n'est pas recuperé automatiquement s'il n'est pas peuplé (comme pour la partie web) donc il doit etre parametré en function de votre usage. Pour en savoir plus veuillez vous reporter à [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**uid :**__ (UID) Ce paramètre doit être valorisé avec votre ID interne quand l'internaute est loggé afin de consolider l'historique accumulée sur les différents devices utilisés. Vous pouvez ainsi réconciler un clic avec le téléchargement de l'application. Pour en savoir plus, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**ref :**__ (REFERENCE_VENTE) Il s'agit de la référence unique de la commande permettant d'identifier et de retrouver cette dernière dans notre système. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**amount :**__ (MONTANT_VENTE) Ce paramètre doit contenir le montant total de la commande TTC hors frais de ports. Les décimales doivent être séparées par un point. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**payment :**__ (MOYEN_DE_PAIEMENT) Ce paramètre permet de remonter le type de paiement utilisé par l'internaute. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**type :**__ (TYPE_DE_VENTE) Ce paramètre permet de catégoriser la vente sur votre propre référentiel. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**currency :**__ (DEVISE_DU_MONTANT) Ce paramètre permet de convertir le montant indiqué dans le paramètre amount si celui-ci est dans une devise différente de celle qui est configurée dans votre interface. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**newcustomer :**__ (0_OU_1) Ce paramètre est utilisé sur le marqueur de commande pour différencier les nouveaux acheteurs des clients fidèles. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdref :**__ (ID_PRODUIT) Ce paramètre doit être valorisé avec la référence du produit commandé par l'internaute et répété pour chaque produit différent acheté. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdamount :**__ (MONTANT_PRODUIT) Ce paramètre permet de spécifier le montant unitaire de chaque produit différent dans la commande. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).
  * __**prdquantity :**__ (QUANTITE_PRODUIT) Ce paramètre permet de spécifier les quantités de chacun des produits achetés. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=fr:collect:technical_implementation:parameters_list).

## Implémentation

L'objet **EAOrder** est la classe dédiée au tracking de la page de confirmation de commande.

Une vente peut contenir un ou plusieurs produits. Chaque produit constituant la vente doit être créé via l'objet **EAOProduct** qui prend sa référence en paramètre obligatoire.  
Chaque objet **EAOProduct** doit être initialisé et complété avec les paramètres souhaités avant d'être intégré à l'objet **EAOrder** via la méthode **addProduct**. 

__**Exemple:**__

```xml
let product1 = EAOProduct(ref: String!)
let product2 = EAOProduct(ref: String!)
        
//product parameter
let param1 = EAOParams()
param1.setEulerianWithStringValue(value: String!, forKey: String!)
let param2 = EAOParams()
param2.setEulerianWithStringValue(value: String!, forKey: String!)
       
//link parameters to products
product1.setEulerianWith(value: EAOParams!)
product2.setEulerianWith(value: EAOParams!)

//tag 
let orderPage = EAOrder(path: String!, withRef: String!)
orderPage.setEulerianWithPageGroup(value: String!)
        
//user information
orderPage.setEulerianWithUid(value: String!)
orderPage.setEulerianWithEmail(value: String!)
orderPage.setEulerianWithProfile(value: String!)
orderPage.setEulerianWithNewCustomer(value: Bool!)
        
//order page parameters
orderPage.setEulerianWithAmount(value: Double!)
orderPage.setEulerianWithType(value: String!)
orderPage.setEulerianWithPayment(value: String!)
orderPage.setEulerianWithCurrency(value: String!)

//custom parameter
orderPage.setEulerianWithValue(value: Any!, forKey: String!)
orderPage.setEulerianWithValue(value: Any!, forKey: String!)
        
//repeat for every product
orderPage.addEulerian(product: EAOProduct!, amount: Double!, quantity: Int32)
orderPage.addEulerian(product: EAOProduct!, amount: Double!, quantity: Int32)

//trigger
EAnalytics.track(orderPage)
```

__**Avec valeurs:**__

```xml
let product1 = EAOProduct(ref: "ref_product_1")
let product2 = EAOProduct(ref: "ref_product_2")
        
//product parameter
let param1 = EAOParams()
param1.setEulerianWithStringValue("red", forKey: "color")
let param2 = EAOParams()
param2.setEulerianWithStringValue("large", forKey: "dimension")
        
//link parameters to products
product1.setEulerianWith(param1)
product2.setEulerianWith(param2)
         
let orderPage = EAOrder(path: "sale-page", withRef: "random-ref")
orderPage.setEulerianWithPageGroup("my-pagegroup")
        
//user information
orderPage.setEulerianWithUid("123345")
orderPage.setEulerianWithEmail("test@test.fr")
orderPage.setEulerianWithProfile("buyer")
orderPage.setEulerianWithNewCustomer(true)
        
//order page parameters
orderPage.setEulerianWithAmount(10.50)
orderPage.setEulerianWithType("ecommerce")
orderPage.setEulerianWithPayment("CB")
orderPage.setEulerianWithCurrency("EUR")
        
//CRM parameter
orderPage.setEulerianWithValue("Andrea", forKey: "name")
orderPage.setEulerianWithValue("Rome", forKey: "city")

//custom parameter
orderPage.setEulerianWithValue("italy", forKey: "delivery")
orderPage.setEulerianWithValue("my-promocode", forKey: "promo-code")
        
//link product tu sale
//repeat for every product
orderPage.addEulerian(product1, amount: 2, quantity: 2)
orderPage.addEulerian(product2, amount: 6.50, quantity: 1)
        
//trigger
EAnalytics.track(orderPage)
```

# Context Flag (CFLAG)

L'objet EAOSiteCentricCFlag est la classe dédiée au context flag.

Vous pouvez donc creer un ou plusieurs context flag via l'objet EAOSiteCentricCFlag et avec la function "**setEulerianWithValue("VALEUR", forKey: "CLE")**" qui prend la valeur (une ou plusieurs) et la clé du context flag. Le nombre maximum de values possibles est de 10.

__**Exemple:**__

```xml

let cFlag = EAOSiteCentricCFlag()
cFlag.setEulerianWithValues(["val1", "val2","val3"], forKey: "key1")
cFlag.setEulerianWithValues(["valA"], forKey: "keyA")

let genericTag = EAProperties(path: "NOM_PAGE")
genericPage.setEulerianWith(cFlag)
EAnalytics.track(genericTag)
```

