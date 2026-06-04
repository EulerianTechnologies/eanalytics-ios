# iOS SDK — Eulerian Analytics

Guide complet d'installation et de taggage pour le SDK iOS Eulerian Analytics.

---

## Sommaire

- [Installation](#installation)
- [Initialisation](#initialisation)
- [Types de tags](#types-de-tags)
  - [Page générique](#page-générique) — `EAProperties`
  - [Page produit](#page-produit) — `EAProducts` (1 produit)
  - [Page catégorie](#page-catégorie) — `EAProducts` (N produits)
  - [Page moteur de recherche](#page-moteur-de-recherche) — `EASearch`
  - [Page d'erreur 404](#page-derreur-404) — `EAProperties`
  - [Page devis](#page-devis) — `EAEstimate`
  - [Page panier](#page-panier) — `EACart`
  - [Page commande](#page-commande) — `EAOrder`
  - [Tracking marchandisage](#tracking-marchandisage) — `EATpView` / `EATpClick`
  - [Actions](#actions) — `EAOAction`
  - [Context Flag (CFLAG)](#context-flag-cflag) — `EAOSiteCentricCFlag`
- [Tracking WebView](#tracking-webview)
- [Métriques application](#métriques-application)
- [Consentement (GDPR / RGPD)](#consentement-gdpr--rgpd)
- [Privacy (iOS 14+)](#privacy-ios-14)

---

## Installation

### CocoaPods

Si vous n'avez pas encore CocoaPods, installez-le :

```bash
sudo gem install cocoapods
```

Si votre projet n'a pas encore de Podfile, initialisez-en un à la racine du projet :

```bash
pod init
```

Ajoutez la dépendance dans votre `Podfile` :

```ruby
pod 'EAnalytics'
```

Puis exécutez :

```bash
pod install
```

> Ouvrez ensuite votre projet via le fichier `.xcworkspace` généré par CocoaPods (et non le `.xcodeproj`).

### Swift Package Manager

Dans Xcode, **File → Add Package Dependencies**, entrez l'URL du dépôt GitHub Eulerian iOS. Ou ajoutez directement dans `Package.swift` :

```swift
dependencies: [
    .package(url: "https://github.com/EulerianTechnologies/eulerian-sdk-ios", from: "1.5.0")
]
```

**Plateformes supportées :** iOS 9.0+ (CocoaPods) / iOS 11.0+ (SPM) · tvOS 9.0+

---

## Initialisation

Initialisez le SDK une seule fois dans `application(_:didFinishLaunchingWithOptions:)`. Le SDK est un singleton — un second appel à `initWithHost` est ignoré.

**Swift**

```swift
import EAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Remplacez par votre sous-domaine de tracking
        EAnalytics.initWithHost("example.demo.com", andWithDebugLogs: false)
        return true
    }
}
```

**Objective-C**

```objc
#import <EAnalytics/EAnalytics.h>

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [EAnalytics initWithHost:@"example.demo.com" andWithDebugLogs:NO];
    return YES;
}
```

> Le second paramètre active (`true`) ou désactive (`false`) les logs de debug dans la console Xcode.

> **Sous-domaine de tracking :** la valeur à passer est fournie par votre équipe Eulerian. Elle ressemble à `example.demo.com` — ne pas inclure `https://` ni `/`. Le SDK refuse les hôtes contenant `.eulerian.com`.

> **Attribution du trafic dans Eulerian :** une application native n'a pas d'URL. Le SDK utilise automatiquement le nom de l'application (`ea-appname`) comme identifiant interne et le sous-domaine passé à `initWithHost` pour attribuer le trafic au bon site dans l'interface Eulerian.

> Si plusieurs applications partagent le même sous-domaine de tracking, utilisez le paramètre `from` via `setEulerianWithValue(_:forKey:)` pour les distinguer.

> **EUIDL :** le SDK génère et persiste automatiquement un identifiant unique par installation (`euidl`). Il est stocké dans `NSUserDefaults` et survit aux mises à jour de l'app. Accessible via `EAnalytics.euidl()`.

> **Offline & retry :** si le device n'a pas de connexion au moment de l'appel à `track`, le tag est sérialisé localement et renvoyé automatiquement au prochain appel `track` ou au prochain lancement de l'application. Le timestamp réel de l'interaction est conservé (`ereplay-time`).

---

## Types de tags

> **`path` (nom de page) est obligatoire sur chaque tag.** Il n'est jamais récupéré automatiquement — contrairement au web où l'URL identifie la page. Utilisez une convention hiérarchique avec `|` comme séparateur, par exemple `"home|accueil"`, `"catalogue|chaussures|homme"`, `"tunnel|paiement|confirmation"`. La valeur est libre mais doit être stable et significative pour le reporting.

> **Méthode générique `setEulerianWithValue(_:forKey:)`** : disponible sur tous les tags, elle permet d'ajouter n'importe quel paramètre personnalisé non couvert par les méthodes dédiées. Exemple : `setEulerianWithValue("mensuel", forKey: "abonnement")`.

---

### Page générique — `EAProperties`

À utiliser sur toutes les pages qui ne sont pas des fiches produit, panier, commande ou devis (y compris la homepage et les étapes intermédiaires du tunnel). Remonte le trafic site-centric, les pages vues, les visites et les sources naturelles.

**Méthodes :**

- `initWithPath(_ path: String)` — nom de la page **(obligatoire)**
- `setEulerianWithUid(_ value: String)` — ID interne de l'utilisateur connecté ; consolide l'historique multi-device
- `setEulerianWithEmail(_ value: String)` — email de l'utilisateur
- `setEulerianWithProfile(_ value: String)` — profil de l'utilisateur (ex. `visitor`, `buyer`, `looker`)
- `setEulerianWithPageGroup(_ value: String)` — groupe de pages pour le reporting
- `setEulerianWithValue(_ value: Any, forKey key: String)` — paramètre personnalisé libre
- `setEulerianWithCFlag(_ value: EAOSiteCentricCFlag)` — attache un ou plusieurs context flags (voir [Context Flag](#context-flag-cflag))

**Swift**

```swift
let props = EAProperties(path: "home|accueil")
props.setEulerianWithUid("123asd")
props.setEulerianWithEmail("test@test.fr")
props.setEulerianWithProfile("visitor")
props.setEulerianWithPageGroup("MY-PAGEGROUP")
props.setEulerianWithValue("value", forKey: "KEY-CUSTOM-PARAM")
EAnalytics.track(props)
```

**Objective-C**

```objc
EAProperties *props = [[EAProperties alloc] initWithPath:@"home|accueil"];
[props setEulerianWithUid:@"123asd"];
[props setEulerianWithEmail:@"test@test.fr"];
[props setEulerianWithProfile:@"visitor"];
[props setEulerianWithPageGroup:@"MY-PAGEGROUP"];
[props setEulerianWithValue:@"value" forKey:@"KEY-CUSTOM-PARAM"];
[EAnalytics track:props];
```

---

### Page produit — `EAProducts` (1 produit)

Suit les pages vues produit et alimente le rapport « Acquisition & Performance produit ». Un tag est considéré comme page produit quand il contient **exactement un** produit et aucun des paramètres `scart`, `estimate`, `ref`, `amount`.

**Méthodes :**

- `initWithPath(_ path: String)` — nom de la page **(obligatoire)**
- `setEulerianWithProducts(_ products: [EAOProduct])` — tableau contenant le produit **(obligatoire)**
- `setEulerianWithUid(_ value: String)` — ID interne de l'utilisateur
- `setEulerianWithEmail(_ value: String)` — email de l'utilisateur
- `setEulerianWithProfile(_ value: String)` — profil de l'utilisateur
- `setEulerianWithPageGroup(_ value: String)` — groupe de pages
- `setEulerianWithValue(_ value: Any, forKey key: String)` — paramètre personnalisé libre

**Construction d'un `EAOProduct` :**

- `initWithRef(_ ref: String)` — référence produit **(obligatoire)**
- `setEulerianWithName(_ value: String)` — nom lisible du produit pour le reporting
- `setEulerianWithGroup(_ value: String)` — groupe de marge (`A` ou `B`)
- `setEulerianWithParams(_ value: EAOParams)` — catégories produit (ex. `prdparam-category`, `prdparam-brand`)

**Construction d'un `EAOParams` :**

- `setEulerianWithStringValue(_ value: String, forKey key: String)` — catégorie produit ; la clé correspond au suffixe après `prdparam-`
- `setEulerianWithIntValue(_ value: Int32, forKey key: String)` — valeur entière

**Swift**

```swift
let params = EAOParams()
params.setEulerianWithStringValue("clothes", forKey: "category") // prdparam-category
params.setEulerianWithStringValue("nike", forKey: "brand")       // prdparam-brand

let product = EAOProduct(ref: "ref-product")
product.setEulerianWithName("name-product")
product.setEulerianWithGroup("A")
product.setEulerianWithParams(params)

let page = EAProducts(path: "produit|fiche")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.fr")
page.setEulerianWithProfile("looker")
page.setEulerianWithProducts([product])
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOParams *params = [[EAOParams alloc] init];
[params setEulerianWithStringValue:@"clothes" forKey:@"category"];
[params setEulerianWithStringValue:@"nike" forKey:@"brand"];

EAOProduct *product = [[EAOProduct alloc] initWithRef:@"ref-product"];
[product setEulerianWithName:@"name-product"];
[product setEulerianWithGroup:@"A"];
[product setEulerianWithParams:params];

EAProducts *page = [[EAProducts alloc] initWithPath:@"produit|fiche"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.fr"];
[page setEulerianWithProfile:@"looker"];
[page setEulerianWithProducts:@[product]];
[EAnalytics track:page];
```

---

### Page catégorie — `EAProducts` (N produits)

Envoie les N premières références produit affichées sur une page de résultats ou de catégorie. Un tag est considéré comme page catégorie quand il contient **plus d'un** produit et aucun des paramètres `scart`, `estimate`, `ref`, `amount`.

Utilisez la même classe `EAProducts`, en passant un tableau avec plusieurs produits.

**Swift**

```swift
let product1 = EAOProduct(ref: "ref-product1")
let product2 = EAOProduct(ref: "ref-product2")
let product3 = EAOProduct(ref: "ref-product3")

let page = EAProducts(path: "categorie|chaussures")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.fr")
page.setEulerianWithPageGroup("my-pagegroup")
page.setEulerianWithProducts([product1, product2, product3])
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOProduct *product1 = [[EAOProduct alloc] initWithRef:@"ref-product1"];
EAOProduct *product2 = [[EAOProduct alloc] initWithRef:@"ref-product2"];
EAOProduct *product3 = [[EAOProduct alloc] initWithRef:@"ref-product3"];

EAProducts *page = [[EAProducts alloc] initWithPath:@"categorie|chaussures"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.fr"];
[page setEulerianWithPageGroup:@"my-pagegroup"];
[page setEulerianWithProducts:@[product1, product2, product3]];
[EAnalytics track:page];
```

---

### Page moteur de recherche — `EASearch`

Suit les requêtes du moteur de recherche interne, le nombre de résultats et les paramètres de recherche. Un tag est considéré comme page moteur quand il contient `isearchengine`. Non exclusif : peut être combiné avec un produit sur le même tag.

**Méthodes :**

- `initWithPath(_ path: String, withName name: String)` — nom de page + nom du moteur **(obligatoire)**
- `setEulerianWithResults(_ value: Int32)` — nombre de résultats retournés
- `setEulerianWithParams(_ value: EAOParams)` — paramètres de recherche (couples clé/valeur correspondant à `isearchkey`/`isearchdata`)
- `setEulerianWithUid(_ value: String)` — ID interne de l'utilisateur
- `setEulerianWithValue(_ value: Any, forKey key: String)` — paramètre personnalisé libre

**Swift**

```swift
let searchParams = EAOParams()
searchParams.setEulerianWithStringValue("veste", forKey: "motcle")
searchParams.setEulerianWithStringValue("100.00", forKey: "montant_min")
searchParams.setEulerianWithStringValue("400.00", forKey: "montant_max")

let page = EASearch(path: "moteur_interne|veste", withName: "moteur_interne")
page.setEulerianWithUid("34678")
page.setEulerianWithResults(150)
page.setEulerianWithParams(searchParams)
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOParams *searchParams = [[EAOParams alloc] init];
[searchParams setEulerianWithStringValue:@"veste" forKey:@"motcle"];
[searchParams setEulerianWithStringValue:@"100.00" forKey:@"montant_min"];
[searchParams setEulerianWithStringValue:@"400.00" forKey:@"montant_max"];

EASearch *page = [[EASearch alloc] initWithPath:@"moteur_interne|veste" withName:@"moteur_interne"];
[page setEulerianWithUid:@"34678"];
[page setEulerianWithResults:150];
[page setEulerianWithParams:searchParams];
[EAnalytics track:page];
```

---

### Page d'erreur 404 — `EAProperties`

Signalez une page d'erreur 404 en ajoutant `setEulerianWithValue("1", forKey: "error")` à un tag `EAProperties`. Alimente le rapport « Pages en erreur ».

**Swift**

```swift
let props = EAProperties(path: "erreur|404")
props.setEulerianWithValue("1", forKey: "error")
EAnalytics.track(props)
```

**Objective-C**

```objc
EAProperties *props = [[EAProperties alloc] initWithPath:@"erreur|404"];
[props setEulerianWithValue:@"1" forKey:@"error"];
[EAnalytics track:props];
```

---

### Page devis — `EAEstimate`

Suit les devis et les produits associés. Les devis sont dédoublonnés par référence : un second appel avec la même référence est ignoré.

**Méthodes :**

- `initWithPath(_ path: String, withRef ref: String)` — nom de page + référence unique du devis **(obligatoire)**
- `setEulerianWithAmount(_ value: Double)` — montant total TTC du devis (décimales séparées par un point)
- `setEulerianWithType(_ value: String)` — type de devis selon votre propre référentiel
- `setEulerianWithCurrency(_ value: String)` — devise si différente de celle configurée dans l'interface
- `addEulerian(_ product: EAOProduct, amount: Double, quantity: Int32)` — ajoute un produit avec son montant unitaire et sa quantité
- `setEulerianWithUid(_ value: String)` — ID interne de l'utilisateur
- `setEulerianWithEmail(_ value: String)` — email de l'utilisateur
- `setEulerianWithValue(_ value: Any, forKey key: String)` — paramètre personnalisé libre

**Swift**

```swift
let product = EAOProduct(ref: "505")

let page = EAEstimate(path: "credit|devis", withRef: "C4536567")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.fr")
page.setEulerianWithAmount(5000.00)
page.setEulerianWithType("credit_48mois")
page.setEulerianWithCurrency("EUR")
page.setEulerianWithValue("custom-value", forKey: "custom-param-key")
page.addEulerian(product, amount: 5000.00, quantity: 1)
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOProduct *product = [[EAOProduct alloc] initWithRef:@"505"];

EAEstimate *page = [[EAEstimate alloc] initWithPath:@"credit|devis" withRef:@"C4536567"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.fr"];
[page setEulerianWithAmount:5000.00];
[page setEulerianWithType:@"credit_48mois"];
[page setEulerianWithCurrency:@"EUR"];
[page setEulerianWithValue:@"custom-value" forKey:@"custom-param-key"];
[page addEulerian:product amount:5000.00 quantity:1];
[EAnalytics track:page];
```

---

### Page panier — `EACart`

Suit les paniers commencés et permet le calcul des taux de conversion et d'abandon. Un tag est considéré comme page panier quand il contient le paramètre `scart`, défini automatiquement par la classe `EACart`. Durée de vie d'un panier : 30 minutes glissantes.

**Méthodes :**

- `initWithPath(_ path: String)` — nom de la page **(obligatoire)**
- `setEulerianWithCumul(_ value: Bool)` — `false` : les produits du tag représentent l'intégralité du panier (snapshot) ; `true` : les produits s'accumulent à chaque appel successif
- `addEulerian(_ product: EAOProduct, amount: Double, quantity: Int32)` — ajoute un produit avec son montant unitaire et sa quantité
- `setEulerianWithUid(_ value: String)` — ID interne de l'utilisateur
- `setEulerianWithEmail(_ value: String)` — email de l'utilisateur
- `setEulerianWithProfile(_ value: String)` — profil de l'utilisateur
- `setEulerianWithPageGroup(_ value: String)` — groupe de pages
- `setEulerianWithValue(_ value: Any, forKey key: String)` — paramètre personnalisé libre

**Swift**

```swift
let params = EAOParams()
params.setEulerianWithStringValue("T-Shirt", forKey: "category")
params.setEulerianWithStringValue("Nike", forKey: "brand")

let product = EAOProduct(ref: "product-123")
product.setEulerianWithName("product-name")
product.setEulerianWithParams(params)

let page = EACart(path: "panier")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.fr")
page.setEulerianWithProfile("shopper")
page.setEulerianWithPageGroup("my-page-group")
page.setEulerianWithCumul(false)
page.addEulerian(product, amount: 50.30, quantity: 2)
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOParams *params = [[EAOParams alloc] init];
[params setEulerianWithStringValue:@"T-Shirt" forKey:@"category"];
[params setEulerianWithStringValue:@"Nike" forKey:@"brand"];

EAOProduct *product = [[EAOProduct alloc] initWithRef:@"product-123"];
[product setEulerianWithName:@"product-name"];
[product setEulerianWithParams:params];

EACart *page = [[EACart alloc] initWithPath:@"panier"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.fr"];
[page setEulerianWithProfile:@"shopper"];
[page setEulerianWithPageGroup:@"my-page-group"];
[page setEulerianWithCumul:NO];
[page addEulerian:product amount:50.30 quantity:2];
[EAnalytics track:page];
```

---

### Page commande — `EAOrder`

Suit les conversions et le ROI. Les commandes sont dédoublonnées par référence. Implémentez ce tag le plus tôt possible dans le tunnel de paiement pour ne pas le manquer si l'utilisateur ne revient pas sur l'app après la plateforme de paiement.

**Méthodes :**

- `initWithPath(_ path: String, withRef ref: String)` — nom de page + référence unique de la commande **(obligatoire)**
- `setEulerianWithAmount(_ value: Double)` — montant total TTC hors frais de port **(obligatoire)**
- `setEulerianWithPayment(_ value: String)` — moyen de paiement utilisé (ex. `credit card`, `paypal`)
- `setEulerianWithType(_ value: String)` — type de vente selon votre propre référentiel
- `setEulerianWithCurrency(_ value: String)` — devise si différente de celle configurée dans l'interface
- `setEulerianWithNewCustomer(_ value: Bool)` — `true` : nouvel acheteur ; `false` : client fidèle
- `setEulerianWithEstimateRef(_ value: String)` — référence du devis associé à cette commande (optionnel)
- `addEulerian(_ product: EAOProduct, amount: Double, quantity: Int32)` — ajoute un produit avec son montant unitaire et sa quantité
- `setEulerianWithUid(_ value: String)` — ID interne de l'utilisateur
- `setEulerianWithEmail(_ value: String)` — email de l'utilisateur
- `setEulerianWithProfile(_ value: String)` — profil de l'utilisateur
- `setEulerianWithValue(_ value: Any, forKey key: String)` — paramètre personnalisé libre

**Swift**

```swift
let params = EAOParams()
params.setEulerianWithStringValue("T-Shirt", forKey: "category")
params.setEulerianWithStringValue("Nike", forKey: "brand")

let product = EAOProduct(ref: "product-123")
product.setEulerianWithName("product-name")
product.setEulerianWithParams(params)

let page = EAOrder(path: "tunnel|confirmation", withRef: "F654335671")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.fr")
page.setEulerianWithProfile("buyer")
page.setEulerianWithNewCustomer(true)
page.setEulerianWithAmount(50.30)
page.setEulerianWithType("online")
page.setEulerianWithPayment("credit card")
page.setEulerianWithCurrency("EUR")
page.setEulerianWithEstimateRef("asd123qwe")
page.setEulerianWithValue("custom-value", forKey: "custom-param-key")
page.addEulerian(product, amount: 25.15, quantity: 2)
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOParams *params = [[EAOParams alloc] init];
[params setEulerianWithStringValue:@"T-Shirt" forKey:@"category"];
[params setEulerianWithStringValue:@"Nike" forKey:@"brand"];

EAOProduct *product = [[EAOProduct alloc] initWithRef:@"product-123"];
[product setEulerianWithName:@"product-name"];
[product setEulerianWithParams:params];

EAOrder *page = [[EAOrder alloc] initWithPath:@"tunnel|confirmation" withRef:@"F654335671"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.fr"];
[page setEulerianWithProfile:@"buyer"];
[page setEulerianWithNewCustomer:YES];
[page setEulerianWithAmount:50.30];
[page setEulerianWithType:@"online"];
[page setEulerianWithPayment:@"credit card"];
[page setEulerianWithCurrency:@"EUR"];
[page setEulerianWithEstimateRef:@"asd123qwe"];
[page setEulerianWithValue:@"custom-value" forKey:@"custom-param-key"];
[page addEulerian:product amount:25.15 quantity:2];
[EAnalytics track:page];
```

---

### Tracking marchandisage — `EATpView` / `EATpClick`

Suit les impressions et clics sur les blocs de marchandisage (listes de recommandation, bannières, etc.). Envoyés en **GET** sur `/tpview/` et `/tpclick/` — contrairement aux autres tags envoyés en POST. Supporte le même mécanisme de retry offline que le reste du SDK.

**Méthodes `EATpView` (impression) :**

- `initWithPath(_ path: String)` — page de référence **(obligatoire)**
- `setSiteName(_ value: String)` — nom du site marchand
- `setCampaign(_ value: String)` — nom de la campagne
- `setPlacement(_ value: String)` — emplacement du bloc dans la page
- `addProductWithRef(_ ref: String, position: NSNumber)` — référence produit et sa position dans le bloc ; répétez pour chaque produit affiché
- `setUrl(_ value: String)` — URL de contexte
- `setPublisher(_ value: String)` — éditeur (optionnel)
- `setMedia(_ value: String)` — type de média (optionnel)
- `setCategory(_ value: String)` — catégorie du bloc (optionnel)

**Méthodes `EATpClick` (clic) :**

- `initWithPath(_ path: String)` — page de référence **(obligatoire)**
- `setSiteName(_ value: String)` — nom du site marchand
- `setCampaign(_ value: String)` — nom de la campagne
- `setPlacement(_ value: String)` — emplacement du bloc dans la page
- `setProductWithRef(_ ref: String, position: Int)` — référence et position du produit cliqué **(obligatoire)**
- `setProductWithRef(_ ref: String, position: Int, totalProducts: NSNumber)` — variante avec le nombre total de produits dans le bloc
- `setUrl(_ value: String)` — URL de contexte
- `setPublisher(_ value: String)` — éditeur (optionnel)
- `setMedia(_ value: String)` — type de média (optionnel)
- `setCategory(_ value: String)` — catégorie du bloc (optionnel)

**Swift**

```swift
// Impression sur un bloc marchandisage
let view = EATpView(path: "homepage")
view.setSiteName("my-site")
view.setCampaign("summer_sale")
view.setPlacement("banner_top")
view.addProductWithRef("PROD_001", position: NSNumber(value: 0))
view.addProductWithRef("PROD_002", position: NSNumber(value: 1))
view.setUrl("https://www.example.com")
EAnalytics.track(view)

// Clic sur un produit du bloc
let click = EATpClick(path: "homepage")
click.setSiteName("my-site")
click.setCampaign("summer_sale")
click.setPlacement("banner_top")
click.setProductWithRef("PROD_001", position: 0)
click.setUrl("https://www.example.com")
EAnalytics.track(click)
```

**Objective-C**

```objc
// Impression
EATpView *view = [[EATpView alloc] initWithPath:@"homepage"];
[view setSiteName:@"my-site"];
[view setCampaign:@"summer_sale"];
[view setPlacement:@"banner_top"];
[view addProductWithRef:@"PROD_001" position:@(0)];
[view addProductWithRef:@"PROD_002" position:@(1)];
[view setUrl:@"https://www.example.com"];
[EAnalytics track:view];

// Clic
EATpClick *click = [[EATpClick alloc] initWithPath:@"homepage"];
[click setSiteName:@"my-site"];
[click setCampaign:@"summer_sale"];
[click setPlacement:@"banner_top"];
[click setProductWithRef:@"PROD_001" position:2];
[click setUrl:@"https://www.example.com"];
[EAnalytics track:click];
```

---

### Actions — `EAOAction`

Les actions permettent de tracker des interactions utilisateur (tunnel de souscription, questionnaire, navigation inter-sections, etc.) en dehors des pages vues classiques. Une action peut être attachée à n'importe quel tag via `setEulerianWithAction:` (remplace toute action précédente) ou `addEulerianWithAction:` (accumule plusieurs actions sur le même tag).

Pour envoyer une action sans page vue associée, appelez `setEulerianStandalone()` sur le tag — le hit ne comptera pas comme page vue dans Eulerian.

**Méthodes `EAOAction` :**

- `setEulerianWithName(_ value: String)` — nom de l'action **(obligatoire)**
- `setEulerianWithMode(_ value: String)` — sens de l'action : `"in"` (entrée) ou `"out"` (sortie)
- `setEulerianWithLabel(_ value: String)` — label(s) de l'action, séparés par des virgules
- `setEulerianWithRef(_ value: String)` — référence identifiant l'action dans vos systèmes (optionnel)
- `setEulerianWithParams(_ value: EAOParams)` — paramètres supplémentaires clé/valeur

**Swift — action sur une page vue**

```swift
let action1 = EAOAction()
action1.setEulerianWithName("souscription-etape1")
action1.setEulerianWithMode("in")
action1.setEulerianWithLabel("offre-premium")

let action2 = EAOAction()
action2.setEulerianWithName("souscription-etape1")
action2.setEulerianWithMode("out")
action2.setEulerianWithLabel("abandon")

let props = EAProperties(path: "souscription|etape1")
props.setEulerianWithUid("123asd")
props.addEulerianWithAction(action1)
props.addEulerianWithAction(action2)
EAnalytics.track(props)
```

**Swift — action standalone (sans page vue)**

```swift
let action = EAOAction()
action.setEulerianWithName("clic-cta")
action.setEulerianWithMode("in")
action.setEulerianWithLabel("hero-banner")

let params = EAOParams()
params.setEulerianWithStringValue("martinique", forKey: "provenance")
action.setEulerianWithParams(params)

let props = EAProperties(path: "homepage")
props.setEulerianStandalone()   // ne compte pas comme page vue
props.setEulerianWithUid("123asd")
props.addEulerianWithAction(action)
EAnalytics.track(props)
```

**Objective-C**

```objc
EAOAction *action = [[EAOAction alloc] init];
[action setEulerianWithName:@"clic-cta"];
[action setEulerianWithMode:@"in"];
[action setEulerianWithLabel:@"hero-banner"];

EAOParams *params = [[EAOParams alloc] init];
[params setEulerianWithStringValue:@"martinique" forKey:@"provenance"];
[action setEulerianWithParams:params];

EAProperties *props = [[EAProperties alloc] initWithPath:@"homepage"];
[props setEulerianStandalone];
[props setEulerianWithUid:@"123asd"];
[props addEulerianWithAction:action];
[EAnalytics track:props];
```

---

### Context Flag (CFLAG) — `EAOSiteCentricCFlag`

Associez un ou plusieurs context flags à n'importe quel tag pour enrichir vos rapports de dimensions contextuelles. Chaque flag accepte plusieurs valeurs.

**Méthodes `EAOSiteCentricCFlag` :**

- `setEulerianWithValues(_ values: [String], forKey key: String)` — définit une dimension contextuelle avec une ou plusieurs valeurs

**Ajout sur un tag via :**

- `setEulerianWithCFlag(_ value: EAOSiteCentricCFlag)` — disponible sur tous les types de tags

**Swift**

```swift
let cflag = EAOSiteCentricCFlag()
cflag.setEulerianWithValues(["rolandgarros", "wimbledon"], forKey: "categorie_1")
cflag.setEulerianWithValues(["tennis"], forKey: "categorie_2")
cflag.setEulerianWithValues(["usopen"], forKey: "categorie_3")

let props = EAProperties(path: "home|accueil")
props.setEulerianWithUid("123asd")
props.setEulerianWithEmail("email@test.fr")
props.setEulerianWithCFlag(cflag)
EAnalytics.track(props)
```

**Objective-C**

```objc
EAOSiteCentricCFlag *cflag = [[EAOSiteCentricCFlag alloc] init];
[cflag setEulerianWithValues:@[@"rolandgarros", @"wimbledon"] forKey:@"categorie_1"];
[cflag setEulerianWithValues:@[@"tennis"] forKey:@"categorie_2"];
[cflag setEulerianWithValues:@[@"usopen"] forKey:@"categorie_3"];

EAProperties *props = [[EAProperties alloc] initWithPath:@"home|accueil"];
[props setEulerianWithUid:@"123asd"];
[props setEulerianWithEmail:@"email@test.fr"];
[props setEulerianWithCFlag:cflag];
[EAnalytics track:props];
```

---

## Tracking WebView

Pour les applications hybrides ouvrant une WebView, passez l'identifiant interne du SDK dans l'URL d'ouverture pour assurer la continuité du tracking entre l'app native et la session web. Ajoutez aussi le paramètre `edev` pour qualifier le trafic comme natif.

**Swift**

```swift
let euidl = EAnalytics.euidl()

// Construire l'URL avec les paramètres obligatoires
var components = URLComponents(string: "https://www.example.com/landing")!
components.queryItems = [
    URLQueryItem(name: "ea-euidl-bypass", value: euidl),
    URLQueryItem(name: "edev", value: "AppNativeIOSphone")
]
let webViewURL = components.url!

// Charger dans la WebView
webView.load(URLRequest(url: webViewURL))
```

**Objective-C**

```objc
NSString *euidl = [EAnalytics euidl];

NSURLComponents *components = [NSURLComponents componentsWithString:@"https://www.example.com/landing"];
components.queryItems = @[
    [NSURLQueryItem queryItemWithName:@"ea-euidl-bypass" value:euidl],
    [NSURLQueryItem queryItemWithName:@"edev" value:@"AppNativeIOSphone"]
];
[webView loadRequest:[NSURLRequest requestWithURL:components.URL]];
```

Valeurs acceptées pour `edev` :

| Valeur | Appareil |
|--------|----------|
| `AppNativeIOSphone` | iPhone |
| `AppNativeIOStablet` | iPad |
| `AppNativeAndroidphone` | Téléphone Android |
| `AppNativeAndroidtablet` | Tablette Android |

> `ea-euidl-bypass` doit être présent à **chaque changement d'URL** dans la WebView, sinon le lien entre navigation app et web est perdu.

---

## Métriques application

Suivez les téléchargements et mises à jour en incluant ces paramètres dans le premier tag envoyé au lancement de l'application.

| Paramètre | Valeur | Description |
|-----------|--------|-------------|
| `ea-appname` | Nom de l'app | Identifiant app — **ne doit jamais changer** — collecté automatiquement par le SDK |
| `ea-appversion` | Chaîne de version | Version courante — collectée automatiquement par le SDK |
| `ea-appinstalled` | `1` | À passer manuellement si l'app existait avant l'intégration Eulerian |

Ces paramètres sont collectés **automatiquement** par le SDK à chaque hit. Vous n'avez rien à faire sauf passer `ea-appinstalled` lors d'une migration.

**Logique système :**
- La métrique **Téléchargement** est incrémentée quand `ea-appname` est vu pour la première fois pour cet utilisateur (sans `ea-appinstalled`).
- La métrique **Mise à jour** est incrémentée quand `ea-appname` est inchangé mais `ea-appversion` a une nouvelle valeur par rapport au dernier lancement.

**Migration (app existante avant Eulerian) :**

```swift
let props = EAProperties(path: "home|accueil")
props.setEulerianWithValue("1", forKey: "ea-appinstalled")
EAnalytics.track(props)
```

---

## Consentement (GDPR / RGPD)

> Les deux modes ci-dessous sont **mutuellement exclusifs**. Choisissez-en un et ne les utilisez jamais ensemble dans la même application.

### Mode 1 — TCF v2 (`gdpr_consent`)

Transmettez la TCString générée par votre CMP une seule fois par visiteur, au moment où l'utilisateur exprime son opt-in ou opt-out.

**Swift**

```swift
let props = EAProperties(path: "univers|rubrique|page")
props.setEulerianWithUid("5434742")
props.setEulerianWithValue("mensuel", forKey: "abonnement")
props.setEulerianWithValue("EADURF214345", forKey: "gdpr_consent") // votre TCString
EAnalytics.track(props)
```

### Mode 2 — Catégories (`pmcat`)

Passez les IDs Eulerian des catégories **refusées**, séparés par `-`. Envoyez `-` seul si l'utilisateur accepte toutes les catégories.

**Swift**

```swift
let props = EAProperties(path: "univers|rubrique|page")
props.setEulerianWithUid("5434742")
props.setEulerianWithValue("mensuel", forKey: "abonnement")
props.setEulerianWithValue("1-10", forKey: "pmcat") // IDs des catégories refusées
EAnalytics.track(props)
```

Exemple de mapping des catégories :

| Catégorie | ID Eulerian |
|-----------|-------------|
| analytics | 1 |
| publicité | 10 |
| fonctionnel | 19 |

*Exemple : l'utilisateur refuse analytics + publicité → `pmcat` = `1-10`*

### URL d'opt-out général

Fournissez cette URL sur votre page « Vie privée / RGPD » ou dans votre CMP pour un retrait total inconditionnel :

```
https://<votre-domaine-de-collecte>/optout.html?url=<votre-domaine>
```

### Récapitulatif

| | Mode TCF v2 | Mode Catégories |
|---|---|---|
| **Paramètre** | `gdpr_consent` | `pmcat` |
| **Quand** | Lors de l'opt-in/out | Lors de l'opt-in/out |
| **Contenu** | TCString | IDs refusés ou `-` |
| **Compatibilité CMP** | CMP TCF v2 | CMP maison / non-TCF |

---

## Privacy (iOS 14+)

### Privacy Manifest

Le SDK inclut un fichier `PrivacyInfo.xcprivacy` déclarant les données collectées et les API système utilisées. Ce fichier est requis par l'App Store depuis le printemps 2024 pour les SDKs tiers.

**Données déclarées dans le manifest :**

| Type de donnée | Usage |
|---------------|-------|
| Email address | Linking |
| User ID | Linking + Tracking |
| Device ID / IDFV | Linking |
| Purchase history | Linking |
| Product interaction | Linking |
| Other usage data | Linking |

**API système déclarée :** `NSUserDefaults` (reason: CA92.1 — stockage de la queue offline).

### Domaine de tracking (NSPrivacyTrackingDomains)

Si votre application active le suivi publicitaire (IDFA), ajoutez votre domaine de collecte dans `Info.plist` :

```xml
<key>NSPrivacyTrackingDomains</key>
<array>
    <string>example.demo.com</string>
</array>
```

### IDFA (App Tracking Transparency)

Le SDK collecte automatiquement l'IDFA si le framework `AdSupport` est lié **et** que l'utilisateur a accordé l'autorisation via `ATTrackingManager`. Aucune configuration supplémentaire n'est requise côté SDK.
