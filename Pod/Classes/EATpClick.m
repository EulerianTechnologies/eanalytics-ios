//
//  EATpClick.m
//  EAnalytics
//
//  Ported from eanalytics-android.
//

#import "EATpClick.h"

static NSString *const KEY_TYPE = @"type";
static NSString *const TYPE_VALUE = @"EATpClick";

static NSString *const KEY_DYNTPCLICK = @"dyntpclick";
static NSString *const KEY_TPCLICKPRODUCT = @"tpclickproduct";

static NSString *const KEY_PRODUCT_REF = @"ecprdr";
static NSString *const KEY_PRODUCT_POS = @"ecpos";
static NSString *const KEY_TOTAL_PRODUCT = @"ecnbr";

@interface EATpClick ()

@property (nonatomic, copy) NSString *siteName;
@property (nonatomic, copy) NSString *campaignName;
@property (nonatomic, copy) NSString *placement;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *media;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *productRef;
@property (nonatomic, assign) NSInteger productPosition;
@property (nonatomic, strong) NSNumber *productTotal;

@end

@implementation EATpClick

- (instancetype)initWithPath:(NSString *)path
{
    self = [super initWithPath:path];
    if (self) {
        _siteName = @"";
        _campaignName = @"";
        _placement = @"";
        _publisher = @"";
        _media = @"";
        _category = @"";
        _url = @"";
        _productRef = @"";
        _productPosition = 0;
        _productTotal = nil;
        [self.dictionary setObject:TYPE_VALUE forKey:KEY_TYPE];
        [self syncDictionary];
    }
    return self;
}

- (void)setSiteName:(NSString *)value     { _siteName     = [value copy]; [self syncDictionary]; }
- (void)setCampaign:(NSString *)value     { _campaignName = [value copy]; [self syncDictionary]; }
- (void)setPlacement:(NSString *)value    { _placement    = [value copy]; [self syncDictionary]; }
- (void)setPublisher:(NSString *)value    { _publisher    = [value copy]; [self syncDictionary]; }
- (void)setMedia:(NSString *)value        { _media        = [value copy]; [self syncDictionary]; }
- (void)setCategory:(NSString *)value     { _category     = [value copy]; [self syncDictionary]; }
- (void)setUrl:(NSString *)value          { _url          = [value copy]; [self syncDictionary]; }

- (void)setProductWithRef:(NSString *)ref position:(NSInteger)position
{
    [self setProductWithRef:ref position:position totalProducts:nil];
}

- (void)setProductWithRef:(NSString *)ref position:(NSInteger)position totalProducts:(NSNumber *)totalProducts
{
    _productRef = [ref copy];
    _productPosition = position;
    _productTotal = totalProducts;
    [self syncDictionary];
}

- (void)syncDictionary
{
    NSMutableDictionary *product = [NSMutableDictionary dictionary];
    [product setObject:(_productRef ?: @"") forKey:@"ref"];
    [product setObject:@(_productPosition) forKey:@"position"];
    if (_productTotal) {
        [product setObject:_productTotal forKey:@"totalProducts"];
    }

    NSArray *dyntpclick = @[
        _siteName ?: @"",
        _campaignName ?: @"",
        _placement ?: @"",
        _publisher ?: @"",
        _media ?: @"",
        _category ?: @"",
        product
    ];
    [self.dictionary setObject:dyntpclick forKey:KEY_DYNTPCLICK];
    [self.dictionary setObject:product forKey:KEY_TPCLICKPRODUCT];
}

- (NSString *)toQueryString
{
    uint32_t randomNum = arc4random_uniform(1000000000);

    NSMutableString *query = [NSMutableString string];
    [query appendFormat:@"%@/%@/%@/%@/generic/%u?",
        [self encode:_siteName],
        [self encode:_campaignName],
        [self encode:_placement],
        [self encode:_siteName],
        randomNum];

    [query appendFormat:@"%@=%@&", KEY_PRODUCT_REF, [self encode:_productRef]];
    [query appendFormat:@"%@=%@&", KEY_PRODUCT_POS, [self encode:[@(_productPosition) stringValue]]];

    if (_productTotal) {
        [query appendFormat:@"%@=%@&", KEY_TOTAL_PRODUCT, [self encode:[_productTotal stringValue]]];
    }

    if (_url.length > 0) {
        [query appendFormat:@"url=%@&", [self encode:_url]];
    }

    return [query copy];
}

- (NSString *)encode:(NSString *)value
{
    if (value == nil) {
        return @"";
    }
    NSCharacterSet *allowed = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [value stringByAddingPercentEncodingWithAllowedCharacters:allowed] ?: @"";
}

@end
