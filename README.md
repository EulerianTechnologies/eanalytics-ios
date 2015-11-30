# Eulerian Analytics #

## Installation ##

EAnalytics is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EAnalytics"
```

## Usage ##

### Example ###

```
#!objective-c
// Import EAnalytics into the class that wants to make use of the library.
#import "EAnalytics/EAnalytics.h"

// Initialize The Eulerian Analytics once, in app launch delegate for instance.
[EAnalytics initWithHost:@"your.host.net" andWithDebugLogs:YES];

// Create Eulerian Properties
EAProperties *prop = [[EAProperties alloc] initWithPath:@"my_prop_path"];
[prop setEulerianWithEmail:@"readme@mail.com"];
[prop setEulerianWithLatitude:48.872731 longitude:2.356003];
[prop setEulerianWithValue:@"custom_value" forKey:@"custom_key"];

// And track
[EAnalytics track:myProperties];
```

### Initialization ###

Initialize the SDK with an valid host provided by Eulerian Technologies.

```
#!objective-c
[EAnalytics initWithHost:@"your.host.net" andWithDebugLogs:YES];
```

### Create properties ###

Create any properties using:
```
#!objective-c
EAProperties *prop = [[EAProperties alloc] initWithPath:@"my_prop_path"];
[prop setEulerianWithEmail:@"readme@mail.com"];
[prop setEulerianWithLatitude:48.872731 longitude:2.356003];
```

Add custom key to your properties:
```
#!objective-c
[prop setEulerianWithValue:@"custom_value" forKey:@"custom_key"];
```

You can use the set of convenient objects to track specific EA properties :

* EACart
* EAOrder
* EAProducts
* EACart
* EAEstimate
* EASearch

### Track properties ###

Track properties using:

```
#!objective-c
[EAnalytics track:myProperties];
```

### Good to know ###

The SDK lets you access two of its property : the EUIDL and the current SDK version :

```
#!objective-c
[EAnalytics euidl];
[EAnalytics version];
```

If the SDK failed to send properties (no network), the SDK will try again in the next calls of 'track' or/and when the app gets launched.

## Author ##

Eulerian Technologies

## License ##

EAnalytics is available under the *Eulerian Technologies* license.