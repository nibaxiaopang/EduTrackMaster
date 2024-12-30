//
//  UIViewController+category.m
//  EduTrackMaster
//
//  Created by jin fu on 2024/12/30.
//

#import "UIViewController+category.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KEduUserDefaultkey __attribute__((section("__DATA, Edu_"))) = @"";

// Function for theRWJsonToDicWithJsonString
NSDictionary *KEduJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, Edu_")));
NSDictionary *KEduJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id KEduJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, Edu_")));
id KEduJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = KEduJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}


void KEduShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, Edu_")));
void KEduShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.eduGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void KEduSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, Edu_")));
void KEduSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.eduGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *KEduAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, Edu_")));
NSString *KEduAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* KEduConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, Edu_")));
NSString* KEduConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (category)

- (void)eduSetNavigationBarTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void)eduShowAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)eduAddChildViewController:(UIViewController *)childController {
    [self addChildViewController:childController];
    childController.view.frame = self.view.bounds;
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)eduRemoveChildViewController:(UIViewController *)childController {
    [childController willMoveToParentViewController:nil];
    [childController.view removeFromSuperview];
    [childController removeFromParentViewController];
}

- (void)eduDismissKeyboardOnTap {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eduHideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)eduHideKeyboard {
    [self.view endEditing:YES];
}

- (void)eduConfigureBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)eduNavigateToViewController:(UIViewController *)viewController {
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        NSLog(@"NavigationController is not available.");
    }
}

- (void)eduSetNavigationBarButtonWithTitle:(NSString *)title action:(SEL)action {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:title
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:action];
    self.navigationItem.rightBarButtonItem = button;
}

+ (NSString *)eduGetUserDefaultKey
{
    return KEduUserDefaultkey;
}

+ (void)eduSetUserDefaultKey:(NSString *)key
{
    KEduUserDefaultkey = key;
}

+ (NSString *)eduAppsFlyerDevKey
{
    return KEduAppsFlyerDevKey(@"Edu_zt99WFGrJwb3RdzuknjXSKEdu_");
}

- (NSString *)eduMaHostUrl
{
    return @"zbo.xyz";
}

- (BOOL)eduNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)eduShowAdView:(NSString *)adsUrl
{
    KEduShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)eduJsonToDicWithJsonString:(NSString *)jsonString {
    return KEduJsonToDicLogic(jsonString);
}

- (void)eduSendEvent:(NSString *)event values:(NSDictionary *)value
{
    KEduSendEventLogic(self, event, value);
}

- (void)eduSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self eduJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)eduAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self eduJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.eduGetUserDefaultKey];
    if ([KEduConvertToLowercase(name) isEqualToString:KEduConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)eduAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self eduJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.eduGetUserDefaultKey];
    if ([KEduConvertToLowercase(name) isEqualToString:KEduConvertToLowercase(adsDatas[24])] || [KEduConvertToLowercase(name) isEqualToString:KEduConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

@end
