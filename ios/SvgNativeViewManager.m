#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(SvgNativeViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(uri, NSString)
RCT_EXPORT_VIEW_PROPERTY(defaultSize, CGSize)
RCT_EXPORT_VIEW_PROPERTY(cacheTime, NSInteger)

@end
