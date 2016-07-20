# iOS SDK for Eulerian Analytics #

## Instalación ##

El pod EAnalytics se integra directamente en Cocoapods. Para instalarlo, basta con añadir la siguiente línea en el archivo Podfile presente en el archivo:

```ruby
pod "EAnalytics"
```

## Utilización ##

### Ejemplo ###

```objective-c
// Import EAnalytics into the class that wants to make use of the library
#import "EAnalytics/EAnalytics.h"

// Initialize The Eulerian Analytics once, in app launch delegate for instance
[EAnalytics initWithHost:@"your.host.net" andWithDebugLogs:YES];

// Create Eulerian Properties
EAProperties *prop = [[EAProperties alloc] initWithPath:@"my_prop_path"];
[prop setEulerianWithEmail:@"readme@mail.com"];
[prop setEulerianWithLatitude:48.872731 longitude:2.356003];
[prop setEulerianWithValue:@"custom_value" forKey:@"custom_key"];

// And track
[EAnalytics track:myProperties];
```

### Inicio ###

Inicia el SDK con un dominio válido proporcionado por Eulerian.

```objective-c
[EAnalytics initWithHost:@"your.host.net" andWithDebugLogs:YES];
```

### Crear propiedades ###

Para crear propiedades, se debe respetar el siguiente formato:

```objective-c
EAProperties *prop = [[EAProperties alloc] initWithPath:@"my_prop_path"];
[prop setEulerianWithEmail:@"readme@mail.com"];
[prop setEulerianWithLatitude:48.872731 longitude:2.356003];
```

Para añadir valores personalizados a tus propiedades, el formato es el siguiente:

```objective-c
[prop setEulerianWithValue:@"custom_value" forKey:@"custom_key"];
```

Puedes adaptar las búsquedas siguientes en función del tipo de página:

* EACart : para la cesta
* EAOrder : para el pedido
* EAProducts : para el producto/categoría
* EAEstimate : para el presupuesto/inscripción
* EASearch : para los resultados de búsqueda

### Seguimiento de las propiedades ###

Para hacer un seguimiento de las propiedades, el formato de la búsqueda es el siguiente:

```objective-c
[EAnalytics track:myProperties];
```

### También te interesará saber ###

El SDK te permite acceder a dos tipos de propiedades : EUIDL y la versión actual del SDK :

```objective-c
[EAnalytics euidl];
[EAnalytics version];
```

Si el SDK no consigue enviar las propiedades (p. ej.: no hay red), se realizará una nueva búsqueda en la próxima llamada de track, o cuando se inicie la aplicación.

## Author ##

Eulerian Technologies

## License ##

EAnalytics is available under the MIT license.

# Tagging plan

Link to [iOS tagging plan](https://github.com/EulerianTechnologies/eanalytics-ios/blob/master/TAGGINGPLAN_ES.md)
