# iOS SDK — Eulerian Analytics

Guía completa de instalación y etiquetado para el SDK iOS de Eulerian Analytics.

---

## Índice

- [Instalación](#instalación)
- [Inicialización](#inicialización)
- [Tipos de etiquetas](#tipos-de-etiquetas)
  - [Página genérica](#página-genérica) — `EAProperties`
  - [Página de producto](#página-de-producto) — `EAProducts` (1 producto)
  - [Página de categoría](#página-de-categoría) — `EAProducts` (N productos)
  - [Página de motor de búsqueda](#página-de-motor-de-búsqueda) — `EASearch`
  - [Página de error 404](#página-de-error-404) — `EAProperties`
  - [Página de presupuesto](#página-de-presupuesto) — `EAEstimate`
  - [Página de carrito](#página-de-carrito) — `EACart`
  - [Página de pedido](#página-de-pedido) — `EAOrder`
  - [Tracking de merchandising](#tracking-de-merchandising) — `EATpView` / `EATpClick`
  - [Acciones](#acciones) — `EAOAction`
  - [Context Flag (CFLAG)](#context-flag-cflag) — `EAOSiteCentricCFlag`
- [Tracking de WebView](#tracking-de-webview)
- [Métricas de aplicación](#métricas-de-aplicación)
- [Consentimiento (RGPD / GDPR)](#consentimiento-rgpd--gdpr)
- [Privacidad (iOS 14+)](#privacidad-ios-14)

---

## Instalación

### CocoaPods

Si aún no tienes CocoaPods, instálalo:

```bash
sudo gem install cocoapods
```

Si tu proyecto no tiene todavía un Podfile, inicializa uno en la raíz del proyecto:

```bash
pod init
```

Añade la dependencia en tu `Podfile`:

```ruby
pod 'EAnalytics'
```

Después ejecuta:

```bash
pod install
```

> Abre tu proyecto usando el archivo `.xcworkspace` generado por CocoaPods (no el `.xcodeproj`).

### Swift Package Manager

En Xcode, ve a **File → Add Package Dependencies** e introduce la URL del repositorio GitHub de Eulerian iOS. O añádelo directamente en `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/EulerianTechnologies/eulerian-sdk-ios", from: "1.5.0")
]
```

**Plataformas compatibles:** iOS 9.0+ (CocoaPods) / iOS 11.0+ (SPM) · tvOS 9.0+

---

## Inicialización

Inicializa el SDK una sola vez en `application(_:didFinishLaunchingWithOptions:)`. El SDK es un singleton — una segunda llamada a `initWithHost` se ignora silenciosamente.

**Swift**

```swift
import EAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Reemplaza con tu subdominio de tracking
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

> El segundo parámetro activa (`true`) o desactiva (`false`) los logs de depuración en la consola de Xcode.

> **Subdominio de tracking:** el valor a pasar lo proporciona tu equipo de Eulerian. Tiene el formato `example.demo.com` — no incluyas `https://` ni `/`. El SDK rechaza los hosts que contienen `.eulerian.com`.

> **Atribución del tráfico en Eulerian:** una aplicación nativa no tiene URL. El SDK utiliza automáticamente el nombre de la aplicación (`ea-appname`) como identificador interno y el subdominio pasado a `initWithHost` para atribuir el tráfico al sitio correcto en la interfaz de Eulerian.

> Si varias aplicaciones comparten el mismo subdominio de tracking, usa el parámetro `from` mediante `setEulerianWithValue(_:forKey:)` para distinguirlas.

> **EUIDL:** el SDK genera y persiste automáticamente un identificador único por instalación (`euidl`). Se almacena en `NSUserDefaults` y sobrevive a las actualizaciones de la app. Accesible mediante `EAnalytics.euidl()`.

> **Offline y reintento:** si el dispositivo no tiene conexión en el momento de llamar a `track`, la etiqueta se serializa localmente y se reenvía automáticamente en la próxima llamada a `track` o en el próximo lanzamiento de la aplicación. La marca de tiempo real de la interacción se conserva (`ereplay-time`).

---

## Tipos de etiquetas

> **`path` (nombre de página) es obligatorio en cada etiqueta.** Nunca se recupera automáticamente — a diferencia de la web donde la URL identifica la página. Usa una convención jerárquica con `|` como separador, por ejemplo `"home|inicio"`, `"catalogo|zapatos|hombre"`, `"embudo|pago|confirmacion"`. El valor es libre pero debe ser estable y significativo para el reporting.

> **Método genérico `setEulerianWithValue(_:forKey:)`**: disponible en todas las etiquetas, permite añadir cualquier parámetro personalizado no cubierto por los métodos dedicados. Ejemplo: `setEulerianWithValue("mensual", forKey: "suscripcion")`.

---

### Página genérica — `EAProperties`

Úsala en todas las páginas que no sean fichas de producto, carrito, pedido o presupuesto (incluida la página de inicio y los pasos intermedios del embudo de conversión). Registra el tráfico site-centric, las páginas vistas, las visitas y las fuentes orgánicas.

**Métodos:**

- `initWithPath(_ path: String)` — nombre de página **(obligatorio)**
- `setEulerianWithUid(_ value: String)` — ID interno del usuario conectado; consolida el historial multidispositivo
- `setEulerianWithEmail(_ value: String)` — correo electrónico del usuario
- `setEulerianWithProfile(_ value: String)` — perfil del usuario (p. ej. `visitor`, `buyer`, `looker`)
- `setEulerianWithPageGroup(_ value: String)` — grupo de páginas para el reporting
- `setEulerianWithValue(_ value: Any, forKey key: String)` — parámetro personalizado libre
- `setEulerianWithCFlag(_ value: EAOSiteCentricCFlag)` — adjunta uno o varios context flags (ver [Context Flag](#context-flag-cflag))

**Swift**

```swift
let props = EAProperties(path: "home|inicio")
props.setEulerianWithUid("123asd")
props.setEulerianWithEmail("test@test.es")
props.setEulerianWithProfile("visitor")
props.setEulerianWithPageGroup("MI-GRUPO-PAGINA")
props.setEulerianWithValue("valor", forKey: "CLAVE-PARAM-CUSTOM")
EAnalytics.track(props)
```

**Objective-C**

```objc
EAProperties *props = [[EAProperties alloc] initWithPath:@"home|inicio"];
[props setEulerianWithUid:@"123asd"];
[props setEulerianWithEmail:@"test@test.es"];
[props setEulerianWithProfile:@"visitor"];
[props setEulerianWithPageGroup:@"MI-GRUPO-PAGINA"];
[props setEulerianWithValue:@"valor" forKey:@"CLAVE-PARAM-CUSTOM"];
[EAnalytics track:props];
```

---

### Página de producto — `EAProducts` (1 producto)

Registra las páginas vistas de producto y alimenta el informe «Adquisición & Rendimiento de producto». Una etiqueta se considera página de producto cuando contiene **exactamente un** producto y ninguno de los parámetros `scart`, `estimate`, `ref`, `amount`.

**Métodos:**

- `initWithPath(_ path: String)` — nombre de página **(obligatorio)**
- `setEulerianWithProducts(_ products: [EAOProduct])` — array con el producto **(obligatorio)**
- `setEulerianWithUid(_ value: String)` — ID interno del usuario
- `setEulerianWithEmail(_ value: String)` — correo electrónico del usuario
- `setEulerianWithProfile(_ value: String)` — perfil del usuario
- `setEulerianWithPageGroup(_ value: String)` — grupo de páginas
- `setEulerianWithValue(_ value: Any, forKey key: String)` — parámetro personalizado libre

**Construcción de un `EAOProduct`:**

- `initWithRef(_ ref: String)` — referencia de producto **(obligatoria)**
- `setEulerianWithName(_ value: String)` — nombre legible del producto para el reporting
- `setEulerianWithGroup(_ value: String)` — grupo de margen (`A` o `B`)
- `setEulerianWithParams(_ value: EAOParams)` — categorías de producto (p. ej. `prdparam-category`, `prdparam-brand`)

**Construcción de un `EAOParams`:**

- `setEulerianWithStringValue(_ value: String, forKey key: String)` — categoría de producto; la clave es el sufijo tras `prdparam-`
- `setEulerianWithIntValue(_ value: Int32, forKey key: String)` — valor entero

**Swift**

```swift
let params = EAOParams()
params.setEulerianWithStringValue("ropa", forKey: "category")  // prdparam-category
params.setEulerianWithStringValue("nike", forKey: "brand")     // prdparam-brand

let product = EAOProduct(ref: "ref-producto")
product.setEulerianWithName("nombre-producto")
product.setEulerianWithGroup("A")
product.setEulerianWithParams(params)

let page = EAProducts(path: "producto|ficha")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.es")
page.setEulerianWithProfile("looker")
page.setEulerianWithProducts([product])
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOParams *params = [[EAOParams alloc] init];
[params setEulerianWithStringValue:@"ropa" forKey:@"category"];
[params setEulerianWithStringValue:@"nike" forKey:@"brand"];

EAOProduct *product = [[EAOProduct alloc] initWithRef:@"ref-producto"];
[product setEulerianWithName:@"nombre-producto"];
[product setEulerianWithGroup:@"A"];
[product setEulerianWithParams:params];

EAProducts *page = [[EAProducts alloc] initWithPath:@"producto|ficha"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.es"];
[page setEulerianWithProfile:@"looker"];
[page setEulerianWithProducts:@[product]];
[EAnalytics track:page];
```

---

### Página de categoría — `EAProducts` (N productos)

Envía las N primeras referencias de producto mostradas en una página de resultados o categoría. Una etiqueta se considera página de categoría cuando contiene **más de un** producto y ninguno de los parámetros `scart`, `estimate`, `ref`, `amount`.

Usa la misma clase `EAProducts`, pasando un array con varios productos.

**Swift**

```swift
let product1 = EAOProduct(ref: "ref-producto1")
let product2 = EAOProduct(ref: "ref-producto2")
let product3 = EAOProduct(ref: "ref-producto3")

let page = EAProducts(path: "categoria|zapatos")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.es")
page.setEulerianWithPageGroup("mi-grupo-pagina")
page.setEulerianWithProducts([product1, product2, product3])
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOProduct *product1 = [[EAOProduct alloc] initWithRef:@"ref-producto1"];
EAOProduct *product2 = [[EAOProduct alloc] initWithRef:@"ref-producto2"];
EAOProduct *product3 = [[EAOProduct alloc] initWithRef:@"ref-producto3"];

EAProducts *page = [[EAProducts alloc] initWithPath:@"categoria|zapatos"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.es"];
[page setEulerianWithPageGroup:@"mi-grupo-pagina"];
[page setEulerianWithProducts:@[product1, product2, product3]];
[EAnalytics track:page];
```

---

### Página de motor de búsqueda — `EASearch`

Registra las consultas del motor de búsqueda interno, el número de resultados y los parámetros de búsqueda. Una etiqueta se considera página de motor cuando contiene `isearchengine`. No es exclusiva: puede combinarse con un producto en la misma etiqueta.

**Métodos:**

- `initWithPath(_ path: String, withName name: String)` — nombre de página + nombre del motor **(obligatorio)**
- `setEulerianWithResults(_ value: Int32)` — número de resultados devueltos
- `setEulerianWithParams(_ value: EAOParams)` — parámetros de búsqueda (pares clave/valor que corresponden a `isearchkey`/`isearchdata`)
- `setEulerianWithUid(_ value: String)` — ID interno del usuario
- `setEulerianWithValue(_ value: Any, forKey key: String)` — parámetro personalizado libre

**Swift**

```swift
let searchParams = EAOParams()
searchParams.setEulerianWithStringValue("chaqueta", forKey: "palabra_clave")
searchParams.setEulerianWithStringValue("100.00", forKey: "precio_min")
searchParams.setEulerianWithStringValue("400.00", forKey: "precio_max")

let page = EASearch(path: "busqueda_interna|chaqueta", withName: "busqueda_interna")
page.setEulerianWithUid("34678")
page.setEulerianWithResults(150)
page.setEulerianWithParams(searchParams)
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOParams *searchParams = [[EAOParams alloc] init];
[searchParams setEulerianWithStringValue:@"chaqueta" forKey:@"palabra_clave"];
[searchParams setEulerianWithStringValue:@"100.00" forKey:@"precio_min"];
[searchParams setEulerianWithStringValue:@"400.00" forKey:@"precio_max"];

EASearch *page = [[EASearch alloc] initWithPath:@"busqueda_interna|chaqueta" withName:@"busqueda_interna"];
[page setEulerianWithUid:@"34678"];
[page setEulerianWithResults:150];
[page setEulerianWithParams:searchParams];
[EAnalytics track:page];
```

---

### Página de error 404 — `EAProperties`

Señala una página de error 404 añadiendo `setEulerianWithValue("1", forKey: "error")` a una etiqueta `EAProperties`. Alimenta el informe «Páginas con error».

**Swift**

```swift
let props = EAProperties(path: "error|404")
props.setEulerianWithValue("1", forKey: "error")
EAnalytics.track(props)
```

**Objective-C**

```objc
EAProperties *props = [[EAProperties alloc] initWithPath:@"error|404"];
[props setEulerianWithValue:@"1" forKey:@"error"];
[EAnalytics track:props];
```

---

### Página de presupuesto — `EAEstimate`

Registra los presupuestos y sus productos asociados. Los presupuestos se deduplicados por referencia: una segunda llamada con la misma referencia se ignora.

**Métodos:**

- `initWithPath(_ path: String, withRef ref: String)` — nombre de página + referencia única del presupuesto **(obligatorio)**
- `setEulerianWithAmount(_ value: Double)` — importe total con IVA (separador decimal: punto)
- `setEulerianWithType(_ value: String)` — tipo de presupuesto según tu propia taxonomía
- `setEulerianWithCurrency(_ value: String)` — divisa si es diferente a la configurada en la interfaz
- `addEulerian(_ product: EAOProduct, amount: Double, quantity: Int32)` — añade un producto con su importe unitario y cantidad
- `setEulerianWithUid(_ value: String)` — ID interno del usuario
- `setEulerianWithEmail(_ value: String)` — correo electrónico del usuario
- `setEulerianWithValue(_ value: Any, forKey key: String)` — parámetro personalizado libre

**Swift**

```swift
let product = EAOProduct(ref: "505")

let page = EAEstimate(path: "credito|presupuesto", withRef: "C4536567")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.es")
page.setEulerianWithAmount(5000.00)
page.setEulerianWithType("credito_48meses")
page.setEulerianWithCurrency("EUR")
page.setEulerianWithValue("valor-custom", forKey: "clave-param-custom")
page.addEulerian(product, amount: 5000.00, quantity: 1)
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOProduct *product = [[EAOProduct alloc] initWithRef:@"505"];

EAEstimate *page = [[EAEstimate alloc] initWithPath:@"credito|presupuesto" withRef:@"C4536567"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.es"];
[page setEulerianWithAmount:5000.00];
[page setEulerianWithType:@"credito_48meses"];
[page setEulerianWithCurrency:@"EUR"];
[page setEulerianWithValue:@"valor-custom" forKey:@"clave-param-custom"];
[page addEulerian:product amount:5000.00 quantity:1];
[EAnalytics track:page];
```

---

### Página de carrito — `EACart`

Registra los carritos iniciados y permite calcular las tasas de conversión y abandono. Una etiqueta se considera página de carrito cuando contiene el parámetro `scart`, definido automáticamente por la clase `EACart`. Duración de vida de un carrito: 30 minutos continuos.

**Métodos:**

- `initWithPath(_ path: String)` — nombre de página **(obligatorio)**
- `setEulerianWithCumul(_ value: Bool)` — `false`: los productos de la etiqueta representan la totalidad del carrito (snapshot); `true`: los productos se acumulan en cada llamada sucesiva
- `addEulerian(_ product: EAOProduct, amount: Double, quantity: Int32)` — añade un producto con su importe unitario y cantidad
- `setEulerianWithUid(_ value: String)` — ID interno del usuario
- `setEulerianWithEmail(_ value: String)` — correo electrónico del usuario
- `setEulerianWithProfile(_ value: String)` — perfil del usuario
- `setEulerianWithPageGroup(_ value: String)` — grupo de páginas
- `setEulerianWithValue(_ value: Any, forKey key: String)` — parámetro personalizado libre

**Swift**

```swift
let params = EAOParams()
params.setEulerianWithStringValue("Camiseta", forKey: "category")
params.setEulerianWithStringValue("Nike", forKey: "brand")

let product = EAOProduct(ref: "producto-123")
product.setEulerianWithName("nombre-producto")
product.setEulerianWithParams(params)

let page = EACart(path: "carrito")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.es")
page.setEulerianWithProfile("shopper")
page.setEulerianWithPageGroup("mi-grupo-pagina")
page.setEulerianWithCumul(false)
page.addEulerian(product, amount: 50.30, quantity: 2)
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOParams *params = [[EAOParams alloc] init];
[params setEulerianWithStringValue:@"Camiseta" forKey:@"category"];
[params setEulerianWithStringValue:@"Nike" forKey:@"brand"];

EAOProduct *product = [[EAOProduct alloc] initWithRef:@"producto-123"];
[product setEulerianWithName:@"nombre-producto"];
[product setEulerianWithParams:params];

EACart *page = [[EACart alloc] initWithPath:@"carrito"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.es"];
[page setEulerianWithProfile:@"shopper"];
[page setEulerianWithPageGroup:@"mi-grupo-pagina"];
[page setEulerianWithCumul:NO];
[page addEulerian:product amount:50.30 quantity:2];
[EAnalytics track:page];
```

---

### Página de pedido — `EAOrder`

Registra las conversiones y el ROI. Los pedidos se deduplicados por referencia. Implementa esta etiqueta lo antes posible en el embudo de pago para no perderla si el usuario no regresa a la app tras la plataforma de pago.

**Métodos:**

- `initWithPath(_ path: String, withRef ref: String)` — nombre de página + referencia única del pedido **(obligatorio)**
- `setEulerianWithAmount(_ value: Double)` — importe total con IVA sin gastos de envío **(obligatorio)**
- `setEulerianWithPayment(_ value: String)` — método de pago utilizado (p. ej. `credit card`, `paypal`)
- `setEulerianWithType(_ value: String)` — tipo de venta según tu propia taxonomía
- `setEulerianWithCurrency(_ value: String)` — divisa si es diferente a la configurada en la interfaz
- `setEulerianWithNewCustomer(_ value: Bool)` — `true`: nuevo comprador; `false`: cliente recurrente
- `setEulerianWithEstimateRef(_ value: String)` — referencia del presupuesto asociado a este pedido (opcional)
- `addEulerian(_ product: EAOProduct, amount: Double, quantity: Int32)` — añade un producto con su importe unitario y cantidad
- `setEulerianWithUid(_ value: String)` — ID interno del usuario
- `setEulerianWithEmail(_ value: String)` — correo electrónico del usuario
- `setEulerianWithProfile(_ value: String)` — perfil del usuario
- `setEulerianWithValue(_ value: Any, forKey key: String)` — parámetro personalizado libre

**Swift**

```swift
let params = EAOParams()
params.setEulerianWithStringValue("Camiseta", forKey: "category")
params.setEulerianWithStringValue("Nike", forKey: "brand")

let product = EAOProduct(ref: "producto-123")
product.setEulerianWithName("nombre-producto")
product.setEulerianWithParams(params)

let page = EAOrder(path: "embudo|confirmacion", withRef: "F654335671")
page.setEulerianWithUid("123asd")
page.setEulerianWithEmail("test@test.es")
page.setEulerianWithProfile("buyer")
page.setEulerianWithNewCustomer(true)
page.setEulerianWithAmount(50.30)
page.setEulerianWithType("online")
page.setEulerianWithPayment("credit card")
page.setEulerianWithCurrency("EUR")
page.setEulerianWithEstimateRef("asd123qwe")
page.setEulerianWithValue("valor-custom", forKey: "clave-param-custom")
page.addEulerian(product, amount: 25.15, quantity: 2)
EAnalytics.track(page)
```

**Objective-C**

```objc
EAOParams *params = [[EAOParams alloc] init];
[params setEulerianWithStringValue:@"Camiseta" forKey:@"category"];
[params setEulerianWithStringValue:@"Nike" forKey:@"brand"];

EAOProduct *product = [[EAOProduct alloc] initWithRef:@"producto-123"];
[product setEulerianWithName:@"nombre-producto"];
[product setEulerianWithParams:params];

EAOrder *page = [[EAOrder alloc] initWithPath:@"embudo|confirmacion" withRef:@"F654335671"];
[page setEulerianWithUid:@"123asd"];
[page setEulerianWithEmail:@"test@test.es"];
[page setEulerianWithProfile:@"buyer"];
[page setEulerianWithNewCustomer:YES];
[page setEulerianWithAmount:50.30];
[page setEulerianWithType:@"online"];
[page setEulerianWithPayment:@"credit card"];
[page setEulerianWithCurrency:@"EUR"];
[page setEulerianWithEstimateRef:@"asd123qwe"];
[page setEulerianWithValue:@"valor-custom" forKey:@"clave-param-custom"];
[page addEulerian:product amount:25.15 quantity:2];
[EAnalytics track:page];
```

---

### Tracking de merchandising — `EATpView` / `EATpClick`

Registra las impresiones y clics en bloques de merchandising (listas de recomendación, banners, etc.). Se envían como solicitudes **GET** a `/tpview/` y `/tpclick/` — a diferencia de las demás etiquetas que se envían por POST. Admite el mismo mecanismo de reintento offline que el resto del SDK.

**Métodos de `EATpView` (impresión):**

- `initWithPath(_ path: String)` — página de referencia **(obligatorio)**
- `setSiteName(_ value: String)` — nombre del sitio comercial
- `setCampaign(_ value: String)` — nombre de la campaña
- `setPlacement(_ value: String)` — posición del bloque en la página
- `addProductWithRef(_ ref: String, position: NSNumber)` — referencia de producto y su posición en el bloque; repite para cada producto mostrado
- `setUrl(_ value: String)` — URL de contexto
- `setPublisher(_ value: String)` — editor (opcional)
- `setMedia(_ value: String)` — tipo de medio (opcional)
- `setCategory(_ value: String)` — categoría del bloque (opcional)

**Métodos de `EATpClick` (clic):**

- `initWithPath(_ path: String)` — página de referencia **(obligatorio)**
- `setSiteName(_ value: String)` — nombre del sitio comercial
- `setCampaign(_ value: String)` — nombre de la campaña
- `setPlacement(_ value: String)` — posición del bloque en la página
- `setProductWithRef(_ ref: String, position: Int)` — referencia y posición del producto clicado **(obligatorio)**
- `setProductWithRef(_ ref: String, position: Int, totalProducts: NSNumber)` — variante con el número total de productos en el bloque
- `setUrl(_ value: String)` — URL de contexto
- `setPublisher(_ value: String)` — editor (opcional)
- `setMedia(_ value: String)` — tipo de medio (opcional)
- `setCategory(_ value: String)` — categoría del bloque (opcional)

**Swift**

```swift
// Impresión en un bloque de merchandising
let view = EATpView(path: "homepage")
view.setSiteName("mi-sitio")
view.setCampaign("rebajas_verano")
view.setPlacement("banner_superior")
view.addProductWithRef("PROD_001", position: NSNumber(value: 0))
view.addProductWithRef("PROD_002", position: NSNumber(value: 1))
view.setUrl("https://www.ejemplo.com")
EAnalytics.track(view)

// Clic en un producto del bloque
let click = EATpClick(path: "homepage")
click.setSiteName("mi-sitio")
click.setCampaign("rebajas_verano")
click.setPlacement("banner_superior")
click.setProductWithRef("PROD_001", position: 0)
click.setUrl("https://www.ejemplo.com")
EAnalytics.track(click)
```

**Objective-C**

```objc
// Impresión
EATpView *view = [[EATpView alloc] initWithPath:@"homepage"];
[view setSiteName:@"mi-sitio"];
[view setCampaign:@"rebajas_verano"];
[view setPlacement:@"banner_superior"];
[view addProductWithRef:@"PROD_001" position:@(0)];
[view addProductWithRef:@"PROD_002" position:@(1)];
[view setUrl:@"https://www.ejemplo.com"];
[EAnalytics track:view];

// Clic
EATpClick *click = [[EATpClick alloc] initWithPath:@"homepage"];
[click setSiteName:@"mi-sitio"];
[click setCampaign:@"rebajas_verano"];
[click setPlacement:@"banner_superior"];
[click setProductWithRef:@"PROD_001" position:2];
[click setUrl:@"https://www.ejemplo.com"];
[EAnalytics track:click];
```

---

### Acciones — `EAOAction`

Las acciones permiten registrar interacciones del usuario (embudo de suscripción, cuestionario, navegación entre secciones, etc.) fuera de las páginas vistas clásicas. Una acción puede adjuntarse a cualquier etiqueta mediante `setEulerianWithAction:` (reemplaza cualquier acción anterior) o `addEulerianWithAction:` (acumula varias acciones en la misma etiqueta).

Para enviar una acción sin página vista asociada, llama a `setEulerianStandalone()` en la etiqueta — el hit no contará como página vista en Eulerian.

**Métodos de `EAOAction`:**

- `setEulerianWithName(_ value: String)` — nombre de la acción **(obligatorio)**
- `setEulerianWithMode(_ value: String)` — dirección de la acción: `"in"` (entrada) o `"out"` (salida)
- `setEulerianWithLabel(_ value: String)` — etiqueta(s) de la acción, separadas por comas
- `setEulerianWithRef(_ value: String)` — referencia que identifica la acción en tus sistemas (opcional)
- `setEulerianWithParams(_ value: EAOParams)` — parámetros adicionales clave/valor

**Swift — acción en una página vista**

```swift
let action1 = EAOAction()
action1.setEulerianWithName("suscripcion-paso1")
action1.setEulerianWithMode("in")
action1.setEulerianWithLabel("oferta-premium")

let action2 = EAOAction()
action2.setEulerianWithName("suscripcion-paso1")
action2.setEulerianWithMode("out")
action2.setEulerianWithLabel("abandono")

let props = EAProperties(path: "suscripcion|paso1")
props.setEulerianWithUid("123asd")
props.addEulerianWithAction(action1)
props.addEulerianWithAction(action2)
EAnalytics.track(props)
```

**Swift — acción standalone (sin página vista)**

```swift
let action = EAOAction()
action.setEulerianWithName("clic-cta")
action.setEulerianWithMode("in")
action.setEulerianWithLabel("hero-banner")

let params = EAOParams()
params.setEulerianWithStringValue("martinica", forKey: "origen")
action.setEulerianWithParams(params)

let props = EAProperties(path: "homepage")
props.setEulerianStandalone()   // no cuenta como página vista
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
[params setEulerianWithStringValue:@"martinica" forKey:@"origen"];
[action setEulerianWithParams:params];

EAProperties *props = [[EAProperties alloc] initWithPath:@"homepage"];
[props setEulerianStandalone];
[props setEulerianWithUid:@"123asd"];
[props addEulerianWithAction:action];
[EAnalytics track:props];
```

---

### Context Flag (CFLAG) — `EAOSiteCentricCFlag`

Adjunta uno o varios context flags a cualquier etiqueta para enriquecer tus informes con dimensiones contextuales. Cada flag admite varios valores.

**Métodos de `EAOSiteCentricCFlag`:**

- `setEulerianWithValues(_ values: [String], forKey key: String)` — define una dimensión contextual con uno o varios valores

**Adjuntar a una etiqueta mediante:**

- `setEulerianWithCFlag(_ value: EAOSiteCentricCFlag)` — disponible en todos los tipos de etiquetas

**Swift**

```swift
let cflag = EAOSiteCentricCFlag()
cflag.setEulerianWithValues(["rolandgarros", "wimbledon"], forKey: "categoria_1")
cflag.setEulerianWithValues(["tenis"], forKey: "categoria_2")
cflag.setEulerianWithValues(["usopen"], forKey: "categoria_3")

let props = EAProperties(path: "home|inicio")
props.setEulerianWithUid("123asd")
props.setEulerianWithEmail("email@test.es")
props.setEulerianWithCFlag(cflag)
EAnalytics.track(props)
```

**Objective-C**

```objc
EAOSiteCentricCFlag *cflag = [[EAOSiteCentricCFlag alloc] init];
[cflag setEulerianWithValues:@[@"rolandgarros", @"wimbledon"] forKey:@"categoria_1"];
[cflag setEulerianWithValues:@[@"tenis"] forKey:@"categoria_2"];
[cflag setEulerianWithValues:@[@"usopen"] forKey:@"categoria_3"];

EAProperties *props = [[EAProperties alloc] initWithPath:@"home|inicio"];
[props setEulerianWithUid:@"123asd"];
[props setEulerianWithEmail:@"email@test.es"];
[props setEulerianWithCFlag:cflag];
[EAnalytics track:props];
```

---

## Tracking de WebView

Para las aplicaciones híbridas que abren una WebView, pasa el identificador interno del SDK en la URL de apertura para garantizar la continuidad del tracking entre la app nativa y la sesión web. Añade también el parámetro `edev` para calificar el tráfico como nativo.

**Swift**

```swift
let euidl = EAnalytics.euidl()

// Construir la URL con los parámetros obligatorios
var components = URLComponents(string: "https://www.ejemplo.com/landing")!
components.queryItems = [
    URLQueryItem(name: "ea-euidl-bypass", value: euidl),
    URLQueryItem(name: "edev", value: "AppNativeIOSphone")
]
let webViewURL = components.url!

// Cargar en la WebView
webView.load(URLRequest(url: webViewURL))
```

**Objective-C**

```objc
NSString *euidl = [EAnalytics euidl];

NSURLComponents *components = [NSURLComponents componentsWithString:@"https://www.ejemplo.com/landing"];
components.queryItems = @[
    [NSURLQueryItem queryItemWithName:@"ea-euidl-bypass" value:euidl],
    [NSURLQueryItem queryItemWithName:@"edev" value:@"AppNativeIOSphone"]
];
[webView loadRequest:[NSURLRequest requestWithURL:components.URL]];
```

Valores aceptados para `edev`:

| Valor | Dispositivo |
|-------|-------------|
| `AppNativeIOSphone` | iPhone |
| `AppNativeIOStablet` | iPad |
| `AppNativeAndroidphone` | Teléfono Android |
| `AppNativeAndroidtablet` | Tablet Android |

> `ea-euidl-bypass` debe estar presente en **cada cambio de URL** dentro de la WebView; de lo contrario, el vínculo entre la navegación de la app y la web se pierde.

---

## Métricas de aplicación

Registra descargas y actualizaciones incluyendo estos parámetros en la primera etiqueta enviada al lanzar la aplicación.

| Parámetro | Valor | Descripción |
|-----------|-------|-------------|
| `ea-appname` | Nombre de la app | Identificador de la app — **nunca debe cambiar** — recogido automáticamente por el SDK |
| `ea-appversion` | Cadena de versión | Versión actual — recogida automáticamente por el SDK |
| `ea-appinstalled` | `1` | Debe pasarse manualmente si la app existía antes de la integración de Eulerian |

Estos parámetros se recogen **automáticamente** por el SDK en cada hit. Solo necesitas pasar `ea-appinstalled` durante una migración.

**Lógica del sistema:**
- La métrica **Descarga** se incrementa cuando `ea-appname` se ve por primera vez para este usuario (sin `ea-appinstalled`).
- La métrica **Actualización** se incrementa cuando `ea-appname` no cambia pero `ea-appversion` tiene un nuevo valor respecto al último lanzamiento.

**Migración (app que existía antes de Eulerian):**

```swift
let props = EAProperties(path: "home|inicio")
props.setEulerianWithValue("1", forKey: "ea-appinstalled")
EAnalytics.track(props)
```

---

## Consentimiento (RGPD / GDPR)

> Los dos modos que se indican a continuación son **mutuamente excluyentes**. Elige uno y nunca los uses juntos en la misma aplicación.

### Modo 1 — TCF v2 (`gdpr_consent`)

Transmite la TCString generada por tu CMP una sola vez por visitante, en el momento en que el usuario expresa su opt-in o opt-out.

**Swift**

```swift
let props = EAProperties(path: "universo|seccion|pagina")
props.setEulerianWithUid("5434742")
props.setEulerianWithValue("mensual", forKey: "suscripcion")
props.setEulerianWithValue("EADURF214345", forKey: "gdpr_consent") // tu TCString
EAnalytics.track(props)
```

### Modo 2 — Categorías (`pmcat`)

Pasa los IDs de Eulerian de las categorías **rechazadas**, separados por `-`. Envía `-` solo si el usuario acepta todas las categorías.

**Swift**

```swift
let props = EAProperties(path: "universo|seccion|pagina")
props.setEulerianWithUid("5434742")
props.setEulerianWithValue("mensual", forKey: "suscripcion")
props.setEulerianWithValue("1-10", forKey: "pmcat") // IDs de categorías rechazadas
EAnalytics.track(props)
```

Ejemplo de mapeo de categorías:

| Categoría | ID Eulerian |
|-----------|-------------|
| analítica | 1 |
| publicidad | 10 |
| funcional | 19 |

*Ejemplo: el usuario rechaza analítica + publicidad → `pmcat` = `1-10`*

### URL de opt-out general

Proporciona esta URL en tu página «Privacidad / RGPD» o en tu CMP para una retirada total e incondicional:

```
https://<tu-dominio-de-colecta>/optout.html?url=<tu-dominio>
```

### Resumen

| | Modo TCF v2 | Modo Categorías |
|---|---|---|
| **Parámetro** | `gdpr_consent` | `pmcat` |
| **Cuándo** | En el opt-in/out | En el opt-in/out |
| **Contenido** | TCString | IDs rechazados o `-` |
| **Compatibilidad CMP** | CMP TCF v2 | CMP propio / no TCF |

---

## Privacidad (iOS 14+)

### Privacy Manifest

El SDK incluye un archivo `PrivacyInfo.xcprivacy` que declara los datos recogidos y las API del sistema utilizadas. Este archivo es obligatorio en el App Store desde la primavera de 2024 para los SDKs de terceros.

**Datos declarados en el manifest:**

| Tipo de dato | Uso |
|--------------|-----|
| Email address | Linking |
| User ID | Linking + Tracking |
| Device ID / IDFV | Linking |
| Purchase history | Linking |
| Product interaction | Linking |
| Other usage data | Linking |

**API del sistema declarada:** `NSUserDefaults` (motivo: CA92.1 — almacenamiento de la cola offline).

### Dominio de tracking (NSPrivacyTrackingDomains)

Si tu aplicación activa el seguimiento publicitario (IDFA), añade tu dominio de colecta en `Info.plist`:

```xml
<key>NSPrivacyTrackingDomains</key>
<array>
    <string>example.demo.com</string>
</array>
```

### IDFA (App Tracking Transparency)

El SDK recoge automáticamente el IDFA si el framework `AdSupport` está enlazado **y** el usuario ha concedido el permiso mediante `ATTrackingManager`. No se requiere ninguna configuración adicional en el SDK.
