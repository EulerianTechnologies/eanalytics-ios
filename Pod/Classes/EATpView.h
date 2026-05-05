//
//  EATpView.h
//  EAnalytics
//
//  Ported from eanalytics-android.
//

#import <Foundation/Foundation.h>
#import "EAProperties.h"

@interface EATpView : EAProperties

- (instancetype)initWithPath:(NSString *)path;

- (void)setSiteName:(NSString *)value;
- (void)setCampaign:(NSString *)value;
- (void)setPlacement:(NSString *)value;
- (void)setPublisher:(NSString *)value;
- (void)setMedia:(NSString *)value;
- (void)setCategory:(NSString *)value;
- (void)setUrl:(NSString *)value;

- (void)addProductWithRef:(NSString *)ref position:(NSNumber *)position;

- (NSString *)toQueryString;

@end
