# iOS SDK for Eulerian Analytics #

## Installation ##

EAnalytics is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EAnalytics"
```

## Privacy permissions ##

Make sure you provide your tracking domain in the **NSPrivacyTrackingDomains** entry of the Privacy manifest.

## Usage ##

### Example ###

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

### Initialization ###

Initialize the SDK with an valid host provided by Eulerian Technologies.

```objective-c
[EAnalytics initWithHost:@"your.host.net" andWithDebugLogs:YES];
```

### Create properties ###

Create any properties using:

```objective-c
EAProperties *prop = [[EAProperties alloc] initWithPath:@"my_prop_path"];
[prop setEulerianWithEmail:@"readme@mail.com"];
[prop setEulerianWithLatitude:48.872731 longitude:2.356003];
```

Add custom key to your properties:

```objective-c
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

```objective-c
[EAnalytics track:myProperties];
```

### Good to know ###

The SDK lets you access two of its property : the EUIDL and the current SDK version :

```objective-c
[EAnalytics euidl];
[EAnalytics version];
```

If the SDK failed to send properties (no network), the SDK will try again in the next calls of 'track' or/and when the app gets launched.

## Merchandise tracking (EATpView / EATpClick)

A dedicated **merchandise** tracking flow has been added to send impressions and clicks on product showcases, recommendation lists and similar surfaces. See PR [#14](https://github.com/EulerianTechnologies/eanalytics-ios/pull/14).

Two new trackable properties, modeled as subclasses of `EAProperties`:

- **EATpView** — impression events, sent on `GET /tpview/`
- **EATpClick** — click events, sent on `GET /tpclick/`

Unlike the existing events (`EACart`, `EAOrder`, `EAEstimate`, `EASearch`, `EAProducts`), which are POSTed to the standard tracking endpoint, merchandise events are sent as **GET** requests on the two new dedicated paths. They share the same offline retry mechanism as the rest of the SDK: if the request fails, the payload is stored locally and replayed on the next tracking call or on the next app launch.

### What's new

- New `EATpView` and `EATpClick` classes (subclasses of `EAProperties`) sending merchandise events as GET requests on `/tpview/` and `/tpclick/`.
- `EAOAction`: new `name` / `mode` / `label` / `params` API. The legacy `in` / `out` properties are **kept as deprecated** for backward compatibility.
- `EAProperties`: new `addEulerianWithAction:` method (multiple actions on the same property) and `setEulerianStandalone`.
- `EAnalytics`: per-type event routing and startup replay of pending events using a `type` discriminator persisted with each entry.
- Objective-C demo app: dedicated buttons for the new flow.

### Example

```objective-c
// Impression on a merchandise block — sent on GET /tpview/
EATpView *view = [[EATpView alloc] initWithPath:@"homepage"];
[view setSiteName:@"my-site"];
[view setCampaign:@"summer_sale"];
[view setPlacement:@"banner_top"];
[view addProductWithRef:@"PROD_001" position:@(0)];
[view addProductWithRef:@"PROD_002" position:@(1)];
[view setUrl:@"http://eulerian.net"];
[EAnalytics track:view];

// Click on a product inside that block — sent on GET /tpclick/
EATpClick *click = [[EATpClick alloc] initWithPath:@"homepage"];
[click setSiteName:@"my-site"];
[click setCampaign:@"summer_sale"];
[click setPlacement:@"banner_top"];
[click setProductWithRef:@"PROD_001" position:2];
[click setUrl:@"http://eulerian.net"];
[EAnalytics track:click];
```

## Author ##

Eulerian Technologies

## License ##

EAnalytics is available under the MIT license.

# Tagging plan

Link to [iOS tagging plan](https://github.com/EulerianTechnologies/eanalytics-ios/blob/master/TAGGINGPLAN.md)
