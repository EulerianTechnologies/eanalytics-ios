//
//  EATpView.m
//  EAnalytics
//
//  Ported from eanalytics-android.
//

#import "EATpView.h"

static NSString *const KEY_TYPE = @"type";
static NSString *const TYPE_VALUE = @"EATpView";

static NSString *const KEY_DYNTPVIEW = @"dyntpview";
static NSString *const KEY_TPVIEWPRD = @"tpviewprd";

@interface EATpView ()

@property (nonatomic, copy) NSString *siteName;
@property (nonatomic, copy) NSString *campaignName;
@property (nonatomic, copy) NSString *placement;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *media;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) NSMutableArray<NSArray *> *tpviewProducts;

@end

@implementation EATpView

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
        _tpviewProducts = [NSMutableArray array];
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

- (void)addProductWithRef:(NSString *)ref position:(NSNumber *)position
{
    NSMutableArray *prod = [NSMutableArray array];
    [prod addObject:(ref ?: @"")];
    if (position) {
        [prod addObject:position];
    }
    [_tpviewProducts addObject:prod];
    [self syncDictionary];
}

- (void)syncDictionary
{
    NSArray *dyntpview = @[
        _siteName ?: @"",
        _campaignName ?: @"",
        _placement ?: @"",
        _publisher ?: @"",
        _media ?: @"",
        _category ?: @"",
        _url ?: @""
    ];
    [self.dictionary setObject:dyntpview forKey:KEY_DYNTPVIEW];
    [self.dictionary setObject:_tpviewProducts forKey:KEY_TPVIEWPRD];
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

    for (NSUInteger i = 0; i < _tpviewProducts.count; i++) {
        NSArray *prod = _tpviewProducts[i];
        NSString *ref = prod.count > 0 ? [prod[0] description] : @"";
        id pos = prod.count > 1 ? prod[1] : nil;

        [query appendFormat:@"evprdr%lu=%@&", (unsigned long)i, [self encode:ref]];
        if (pos) {
            [query appendFormat:@"evprdpos%lu=%@&", (unsigned long)i, [pos description]];
        }
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
