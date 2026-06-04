# Plan de tagging iOS

## Tracking de una aplicación webview

En lo que concierne a la navegación en una aplicación de tipo //webview// en iOS (sitio web html/js standard), la URL de apertura debe proporcionar nuestro ID interno para asegurar la continuidad del seguimiento. 
Para recuperar este valor, el soporte técnico del cliente debe usar la función siguiente definida en nuestra SDK:

  * iOS - Swift :
```xml
let euidl = EAnalytics.euidl
```

  * iOS - ObjectiveC :
```xml
NSString *euidl = [EAnalytics euidl];
```

Una vez se añade este valor al parámetro **ea-euidl-bypass**, bloquearemos el sistema de cookies normal para usar el euidl proveniente de la aplicación.

**Ejemplo:**

```xml
http://www.vpg.fr/ios-landing-webview?ea-euidl-bypass=$euidl_de_l_app
```

Si el ea.js detecta este parámetro, lo utilizará y lo guardará durante toda la sesión, para evitar que el sitio lo reenvíe con cada página visitada.
Una vez se pasa este parámetro, el tracking de una aplicación iOS en contexto webview no difiere de los formatos JavaScript que usamos para una web clásica.

La documentación disponible en [esta dirección](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:general) contiene toda la información necesaria para la implementación de nuestros Tags JavaScript.


## Tracking de una aplicación nativa

En el caso de una aplicación nativa, nuestra SDK debe incorporarse al código de la aplicación para poder integrar el tipo de marcador siguiente: 

```xml
let genericTag = EAProperties(path: "generic-page")
genericTag.setEulerianWithPageGroup("my-pagegroup")
genericTag.setEulerianWithUid("123asd")
genericTag.setEulerianWithEmail("test@test.fr")
genericTag.setEulerianWithProfile("visitor")
EAnalytics.track(genericTag)
```

Nuestra **SDK** se ha concebido para facilitar al máximo la integración ofreciendo una estructura simple y una documentación detallada. 
Los parámetros disponibles y las posibilidades son exactamente las mismas. Podrás hacer un seguimiento del rendimiento de tu aplicación como si fuese una web clásica integrando las mismas variables.

Las llamadas generadas por estos marcadores se acercan también a las del colector clásico, y han sido concebidas para ser lo más ligeras posible para no perturbar la aplicación. 
Algunos parámetros de nuestro colector son específicos al tracking de una aplicación móvil. Para saber más acerca de esto puedes consultar  [esta documentación](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

Nota: Nuestra SDK también puede recoger un número ilimitado de interacciones offline y enviarlas una vez el usuario se conecta. Este procedimiento nos permite hacer un seguimiento del usuario incluso si éste usa la aplicación sin conexión. La navegación queda registrada y se reatribuye posteriormente a través de nuestro parámetro ereplay-time.


### Regla de afectación de tráfico

En un sitio web clásico, nuestro sistema identifica y afecta el tráfico en función de la **URL** sobre la que se llama al marcador. Todavía no tenemos acceso a esta información en el contexto de una aplicación

Para definir la regla de atribución del tráfico, nos basamos en el subdominio de tracking utilizado y pasado en parámetro con el método **initialize** de nuestra SDK:
```xml
EAnalytics.logDebug(true)
EAnalytics.initialize(DOMAINE_DE_TRACKING)
```

Nota: Esto significa también que si usas el mismo subdominio de tracking para varias de tus aplicaciones, tendremos que distinguirlos añadiendo el parámetro [from](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list) en nuestros marcadores. Así será automáticamente para una aplicación hibrida que comparte páginas en común con tu sitio web.

Igualmente cabe señalar que la ausencia de URL significa también la ausencia de un nombre de página por defecto. El parámetro [path](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list) no es opcional sino __obligatorio__ en el seguimiento de una aplicación.

El tráfico generado por tu aplicación se puede rastrear en un sitio de Eulerian dedicado o fusionarse con el de otro sitio web existente. Como se ha indicado anteriormente, si tu aplicación pasa a modo webview para algunas páginas es obligatorio añadir el parámetro [from](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list) para que podamos redirigir el tráfico correctamente a nuestros sistemas.

## Configuración de descargas y actualizaciones 

Descripción de parámetros asociados: 
  * **ea-appname**: NOM_APPLICATION, corresponde al nombre de la aplicación. Este último no debe cambiar 
  * **ea-appversion**: VERSION_APPLICATION, corresponde a la versión de la aplicación 
  * **ea-appinstalled**: 1, Este parámetro indica que no deben contarse nuevas instalaciones para este dispositivo.
Se utiliza para gestionar la inicialización de los usuarios que ya tenían la aplicación antes de la implementación con Eulerian.

Este parámetro puede ser proporcionado en cualquier momento, en paralelo del appversion y appname, siempre y cuando la aplicación considere que ya ha sido lanzada previamente en este dispositivo/usuario.

La presencia del parámetro **ea-appname** inicia un tratamiento a nivel de sistema.

El sistema abastecerá el valor **descarga** si:
  * El usuario no ha estado jamás expuesto al valor del parámetro **ea-appname** al momento de apertura de la aplicación y el parámetro **ea-appinstalled** no está presente en la llamada

El sistema abastecerá el valor **Actualización** si:
  * El usuario ha estado expuesto al parámetro **ea-appname** y su valor se indica tras la última apertura de la aplicación. En cambio, el valor del parámetro **ea-appversion** es distinto. 

![download_upgrade.png](https://bitbucket.org/repo/kA6LdM/images/3930826066-download_upgrade.png)

# Lista de páginas #

  * Página genérica
  * Página de producto
  * Página de categoría 
  * Página de motor de búsqueda 
  * Página de error 
  * Página de presupuesto  
  * Página de cesta
  * Página de pedido
  
# Página genérica

El marcador a continuación es genérico y debe implementarse en todas las páginas del sitio web excepto en la de la ficha de producto, pedido, presupuesto y cesta iniciada. Esto incluye principalmente la página de inicio y las páginas del túnel de conversión entre la cesta y la confirmación del pedido.

Te permite subir todo el tráfico site-centric, las páginas vistas y las visitas, así como su origen a través de los canales naturales como el acceso directo, la indexación y los referentes.

Nosotros controlamos de forma descentralizada todas las acciones que se implementarán más tarde. De este modo, no necesitamos cambiar el código de la página de tu sitio web para disfrutar de funcionalidades adicionales.

Para tener informes más completos puedes añadir los parámetros a continuación al formato genérico o al conjunto de marcadores colectores descritos en esta documentación.

## Lista de parámetros

  * __**path:**__ (NOM_PAGE) Este parámetro permite nombrar la página para identificarla más tarde en los informes. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**uid:**__ (UID)Este parámetro debe completarse con tu ID interna cuando el internauta está conectado para consolidar los datos del historial provenientes de diferentes dispositivos. Puedes reconciliar un clic con la descarga de la aplicación. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

## Implementación

El objeto **EAProperties** es la categoría que contiene todos los parámetros internos o modificables de nuestro colector de tags. 

Para añadir un nuevo parámetro, usa el método **setEulerian(LLAVE, "VALOR")** o **setEulerian("VALOR", forKey: "LLAVE")** en el caso de un parámetro personalizado.

__**Ejemplo .swift:**__

```xml
let genericTag = EAProperties(path: String!)
genericTag.setEulerianWithPageGroup(value: String!)
genericTag.setEulerianWithUid(value: String!)
genericTag.setEulerianWithEmail(value: String!)
genericTag.setEulerianWithProfile(value: String!)
EAnalytics.track(genericTag)
```

__**Con valores:**__

```xml
let genericTag = EAProperties(path: "generic-page")
genericTag.setEulerianWithPageGroup("my-pagegroup")
genericTag.setEulerianWithUid("123asd")
genericTag.setEulerianWithEmail("test@test.fr")
genericTag.setEulerianWithProfile("visitor")
EAnalytics.track(genericTag)
```

# Página de producto

Este marcador permite recuperar las páginas vistas y las visitas a productos de tu catálogo. Sirve principalmente para abastecer los informes disponibles en la siguiente dirección:

  * Site-centric > Productos > **Adquisición & rendimiento de producto **

También puedes pasar una o varias categorías de producto.

**Nota: Se considera una página de producto todo marcador que contenga solamente una referencia de producto sin los parámetros __scart__ __estimate__ __ref__ y __amount__.**

En general, nuestro sistema no reconocerá como marcador de página de producto un marcador colector que contenga uno de los parámetros citados más arriba o varias referencias de producto.

## Lista de parámetros

  * __**path:**__ (NOM_PAGE) Este parámetro permite nombrar la página para identificarla más tarde en los informes. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**uid:**__ (UID) Este parámetro debe completarse con tu ID interna cuando el internauta está conectado para consolidar los datos del historial provenientes de diferentes dispositivos. Puedes reconciliar un clic con la descarga de la aplicación. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdref:**__ (ID_PRODUIT) Ce paramètre doit être valorisé avec la référence du produit consulté par l'internaute. Pour plus d'informations, veuillez consulter [l'article suivant](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdname :**__ (NOM_PRODUIT) Este parámetro debe valorarse con la referencia de producto consultada por el internauta. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdparam-xxxxx:**__ (VALEUR_PARAM, NOM_PARAM) Este parámetro permite asociar una categoría a la referencia del producto. Debes precisar el nombre de la categoría tras el prefijo **prdparam-**. Por ejemplo, prdparam-universo, prdparam-talla, etc. También puedes añadir tantas categorías como quieras. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

## Implementación

El objeto **EAProducts** es la categoría dedicada al tracking de páginas de producto.

El producto debe ser creado a través del objeto **EAOProduct** que se convierte en parámetro obligatorio. 
Para añadir parámetro de productos debemos creas un objeto **Params** independiente del objeto **EAOProduct**.

Una vez se ha iniciado y completado el **EAOProduct**, integra el objeto EAProducts a través del método **setEulerian()**. 

__**Ejemplo:**__

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

__**Con valores:**__

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

# Página de categoría

Este marcador permite enviar a tus partners las 3 primeras referencias de producto que se muestran en la página de resultados para optimizar el retargeting de internautas en tu página.
Su uso se limita principalmente a nuestro producto Eulerian Tag Master y no produce ningún efecto en los informes de adquisición&rendimiento en la DDP de Eulerian.

**Nota: Se considera una página de resultado todo marcador que contenga varias referencias de producto sin los parámetros __scart__ __estimate__ __ref__ y __amount__.**


En caso de que tu página de resultado solo tenga una referencia de producto, y por tanto un solo parámetro **prdref**, nuestro sistema reconocerá el marcador como página de producto y no como página de resultado.

## Lista de parámetros

  * __**prdref :**__ (ID_PRODUIT) Este parámetro debe valorarse con la referencia de producto consultada por el internauta. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**path :**__ (NOM_PAGE) Este parámetro permite nombrar la página para identificarla más tarde en los informes. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**uid :**__ (UID) Este parámetro debe completarse con tu ID interna cuando el internauta está conectado para consolidar los datos del historial provenientes de diferentes dispositivos. Puedes reconciliar un clic con la descarga de la aplicación. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

## Implementación

Del mismo modo el objeto **EAProducts** se usa para el tracking de páginas de resultado.

El producto debe ser creado a través del objeto **EAOProduct** que se convierte en parámetro obligatorio. 

__**Ejemplo:**__

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

__**Con valores:**__

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

# Página de motor de búsqueda

El marcador de motor de búsqueda interna permite abastecer la interfaz con información sobre consultas de los internautas y un número ilimitado de parámetros adicionales. Toda la información se compara con las ventas generadas y los canales de adquisición activados durante la sesión.

**Nota: Se considera una página motor de búsqueda interna todo marcador que contenga el parámetro  __isearchengine__.**

Debe tenerse en cuenta que el marcador de motor de búsqueda no es exclusivo. Si añades una referencia de producto con el parámetro **prdref** por ejemplo, nuestro sistema considerará el marcador como página de producto.

## Lista de parámetros

  * __**path:**__ (NOM_PAGE) Este parámetro permite nombrar la página para identificarla más tarde en los informes. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**uid:**__ (UID) Este parámetro debe completarse con tu ID interna cuando el internauta está conectado para consolidar los datos del historial provenientes de diferentes dispositivos. Puedes reconciliar un clic con la descarga de la aplicación. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**isearchengine:**__ (NOM_MOTEUR_INTERNE) Este parámetro permite nombre el motor de búsqueda interna y distinguirlo de los otros campos de búsqueda si hay varios en tu página. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**isearchresults:**__ (NOMBRE_DE_RESULTATS) Este parámetro debe contener el número de resultados de búsqueda generados por el internauta. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**isearchkey :**__ (CLE_DU_PARAMETRE_RECHERCHE) Este parámetro debe completarse con la llave del campo adicional que deseas integrar en tu marcador de búsqueda interna. Para saber más puedes consultar [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**isearchdata :**__ (VALEUR_DU_PARAMETRE_RECHERCHE) Este parámetro debe contener el valor del campo isearchkey citado más arriba. A cada campo de búsqueda suplementaria deben añadirse los parámetros  isearchkey y isearchdata. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

## Implementación

El objeto **EASearch** es la categoría dedicada al tracking del motor de búsqueda interna

Crea un objeto **Params** y usa el método **setEulerian** para los parámetros **isearchkey**, **isearchdata**.

__**Ejemplo:**__

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

__**Con valores:**__

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

# Página de error 404

El marcador **error** indica que la aplicación de la página ha generado un error 404. Esto sirve para abastecer los informes disponibles en la página siguiente:

  * Site-centric > Análisis de audiencia > Por página > **Página de error**

Este tag permite recuperar todas las URLs que han generado una página 404 y te da la posibilidad de hacer las correcciones necesarias para redirigir tu tráfico.

Puedes usarlo para estar al tanto de problemas recurrentes en una etapa concreta del túnel de conversión.

## Lista de parámetros

  * __**error:**__ (Obligatorio) Este parámetro es siempre **1** y puede añadirse a todos los tipos de marcador. Su presencia contabiliza una página vista en el informe más arriba. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**path:**__ (Obligatorio) Este parámetro permite nombrar la página para identificarla más tarde en los informes. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

## Implementación

Utiliza el método **set** con la clave de **__error__** para indicar la página de error.  

__**Ejemplo:**__

```xml
let errorTag = EAProperties(path: "error-page")
errorTag.setEulerianWithValue(1, forKey: "error")
EAnalytics.track(errorTag)
```

# Página de presupuesto

Este marcador contabiliza los presupuestos y el conjunto de informaciones asociadas a este tipo de conversión: 
  * Los productos que lo componen 
  * El tipo de presupuesto
  * El total global
  * Informaciones contextuales 

Cada nuevo presupuesto se detalla con todos los canales del historial de navegación que han conducido a su generación. 

**Nota: Se eliminarán los dobles de todos los presupuestos en función de la referencia proporcionada con el marcador.**


Si usas 2 veces la misma referencia para 2 presupuestos diferentes, se ignorará la segunda llamada en virtud del principio de unicidad de conversión.

**Nota: Se considera una página de presupuestos todo marcador que contenga los parámetros __ref__ y __estimate__.**



## Lista de parámetros

  * __**path :**__ (NOM_PAGE) Este parámetro permite nombrar la página para identificarla más tarde en los informes. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**uid :**__ (UID) Este parámetro debe completarse con tu ID interna cuando el internauta está conectado para consolidar los datos del historial provenientes de diferentes dispositivos. Puedes reconciliar un clic con la descarga de la aplicación. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**ref :**__ (REFERENCE_DEVIS) Se trata de una referencia única del presupuesto que permite identificarlo y encontrarlo el nuestro sistema. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**amount :**__ (MONTANT_DEVIS) Este parámetro debe contener el total del presupuesto, IVA incluido. Los decimales se separán por un punto. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**type :**__ (TYPE_DE_DEVIS) Este parámetro permite categorizar el presupuesto según tu propio sistema de referencia. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdref :**__ (ID_PRODUIT) Este parámetro debe completarse con la referencia de producto asociada al presupuesto y repetida en cada valor diferente. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdamount :**__ (MONTANT_PRODUIT) Este parámetro permite especificar el total unitario de cada producto asociado al presupuesto. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdquantity :**__ (QUANTITE_PRODUIT) Este parámetro permite especificar las cantidades de cada producto asociado al presupuesto. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

__**Ejemplo:**__

## Implementación

El objeto **EAEstimate** es la categoría dedicada al tracking de páginas de presupuesto.

Un presupuesto puede contener uno o varios productos. Cada producto que constituye el presupuesto debe crearse a través del objeto **EAOProduct** que se convierte en parámetro obligatorio. 
Cada objeto **EAOProduct** debe iniciarse y completarse con los parámetros elegidos antes de ser integrado al objeto **EAEstimate** a través del método setEulerian. 

**Ejemplo:**

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

**Con valores:**

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

# Página de cesta

Este marcador contabiliza las cestas iniciadas y permita calcular la tasa de conversión y de abandono con respecto al marcador de venta.

También puedes pasar los productos y categorías de productos asociados a la cesta del visitante especificando los totales y las cantidades respectivas. Estos parámetros permiten abastecer los informes de productos disponibles en la dirección siguiente:

  * Site-centric > Productos > **Adquisición & rendimiento de producto**

La duración de vida de una cesta es de 30 minutos durante la sesión del internauta, según [[fr:glossary|nuestra definición]].

## Lista de parámetros

  * __**scartcumul :**__ (Obligatorio) El valor de este parámetro indica el modo de contabilización de los productos en la cesta. Cuando es igual a 0, nuestro sistema interpreta los productos pasados por el marcador como constituyentes de la integridad de la cesta. Cuando es igual a 1, los productos pasados por el marcador se añaden a cada llamada sucesiva. Para saber más puedes consultar [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**path:**__ (Obligatorio) Este parámetro permite nombrar la página para identificarla más tarde en los informes. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**uid :**__ (Opcional) Este parámetro debe completarse con tu ID interna cuando el internauta está conectado para consolidar los datos del historial provenientes de diferentes dispositivos Puedes reconciliar un clic con la descarga de la aplicación. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdref :**__ (Obligatoire) Este parámetro debe completarse con la referencia del producto incluido por el internauta en la cesta y repetido para cada producto diferente. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdamount :**__ (Obligatorio) Este parámetro permite especificar el total unitario de cada producto asociado al presupuesto. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdquantity :**__ (Obligatorio) Este parámetro permite especificar las cantidades de cada producto asociado al presupuesto. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

## Implementación

El objeto **EACart** es la categoría dedicada al tracking de la página de cesta iniciada.

Una cesta puede contener uno o varios productos. Cada producto que constituye la cesta debe crease a través del objeto **EAOProduct** que se convierte en parámetro obligatorio. 
Cada objeto **EAOProduct** debe iniciarse y completarse con los parámetros deseados antes de ser integrado en el objeto **EACart** a través del método addEulerian. 

__**Ejemplo:**__

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

__**Con valores:**__

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

# Página de pedido

Este marcador contabiliza las conversiones y permite el cálculo del ROI para el conjunto de canales marketing. Además del total global del pedido, puedes pasar productos asociados, el modo de pago, la divisa o el tipo de venta. Estas prioridades proporcionarán más detalles a tus análisis y podrán explotarse en nuestra suite. Cada nueva conversión aparece detallada con los canales y el historial de navegación. 

**Nota: Se eliminarán los dobles de todos los pedidos en función de la referencia proporcionada en el marcador de venta.**


Si usas 2 veces la misma referencia para 2 pedidos diferentes, se ignorará la segunda llamada en virtud del principio de unicidad de conversión.


La DDP de Eulerian te permite anular los pedidos para medir el rendimiento real de tus campañas. Por tanto, se aconseja implementar el marcador de pedido lo antes posible en el proceso de compra si las informaciones para configurar su llamada están disponibles (referencia, total, tipo de pago, etc.).


De hecho, si la plataforma de pago no obliga al internauta a pasar de nuevo por la página de compra para validar su pedido, no siempre se llamará al marcador tras la plataforma de pago.

**Nota: Fuera del status del pedido (pendiente, válido o inválido), se puede definir el contenido de un pedido tras haber sido registrado. No podemos añadir o quitar un producto pero sí modificar el total global del pedido.**



**Nota: Se considera una página de confirmación todo marcador que contenga los parámetros __ref__ y __amount__ y que no contenga __scart__ ni __estimate__.**



## Lista de parámetros

  * __**path:**__ (NOM_PAGE) Este parámetro permite nombrar la página para identificarla más tarde en los informes. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**uid :**__ (UID) Este parámetro debe completarse con tu ID interna cuando el internauta está conectado para consolidar los datos del historial provenientes de diferentes dispositivos. Puedes reconciliar un clic con la descarga de la aplicación. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**ref :**__ (REFERENCE_VENTE) Se trata de una referencia única del presupuesto que permite identificarlo y encontrarlo el nuestro sistema. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**amount :**__ (MONTANT_VENTE) Este parámetro debe contener el total del presupuesto, IVA incluido. Los decimales se separan por un punto. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**payment :**__ (MOYEN_DE_PAIEMENT) Este parámetro permite identificar el tipo de pago usado por el internauta. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**type :**__ (TYPE_DE_VENTE) Este parámetro permite categorizar el presupuesto según tu propio sistema de referencia. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**currency :**__ (DEVISE_DU_MONTANT) Este parámetro permite convertir el total indicado en el parámetro amount si este tiene una divisa diferente a la configurada en la interfaz. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**newcustomer :**__ (0_OU_1) Este parámetro se suele usar en el marcador de pedido para diferenciar los nuevos compradores de los clientes asiduos. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdref :**__ (ID_PRODUIT) Este parámetro debe completarse con la referencia de producto asociada al presupuesto y repetida en cada valor diferente. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdamount :**__ (MONTANT_PRODUIT) Este parámetro permite especificar el total unitario de cada producto asociado al presupuesto. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).
  * __**prdquantity :**__ (QUANTITE_PRODUIT) Este parámetro permite especificar las cantidades de cada producto asociado al presupuesto. Para saber más puedes consultar el [artículo siguiente](https://eulerian.wiki/doku.php?id=es:collect:technical_implementation:parameters_list).

## Implementación

El objeto **EAOrder** es la categoría dedicada al tracking de la página de confirmación de pedido.

Una venta puede contener uno o varios productos. Cada producto que constituye el presupuesto debe crearse a través del objeto **EAOProduct** que se convierte en parámetro obligatorio. 
Cada objeto **EAOProduct** debe iniciarse y completarse con los parámetros elegidos antes de ser integrado al objeto **EAOrder** ** a través del método **addProduct**.  

__**Ejemplo:**__

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

__**Con valores:**__

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

El objeto EAOSiteCentricCFlag es la clase dedicada a los Context Flag.

Puedes crear una o más Context Flag a través del objeto EAOSiteCentricCFlag y con la función "**setEulerianWithValue("VALUE", forKey: "CLE")**" que toma el valor (uno o más) y la clave. El número máximo de valores posibles es 10.
__**Exemple:**__

```xml

let cFlag = EAOSiteCentricCFlag()
cFlag.setEulerianWithValues(["val1", "val2","val3"], forKey: "key1")
cFlag.setEulerianWithValues(["valA"], forKey: "keyA")

let genericTag = EAProperties(path: "NOM_PAGE")
genericPage.setEulerianWith(cFlag)
EAnalytics.track(genericTag)
```
