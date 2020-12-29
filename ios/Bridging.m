#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(CCTVPOC, NSObject)

RCT_EXTERN_METHOD(openCCTVPOC:(NSString *)accessToken appKey:(NSString *)appKey serialNumber:(NSString *)serialNumber verificationCode:(NSString *)verificationCode apiServerURL:(NSString *)apiServerURL authServer:(NSString *)authServer cameraName:(NSString *)cameraName)

@end
