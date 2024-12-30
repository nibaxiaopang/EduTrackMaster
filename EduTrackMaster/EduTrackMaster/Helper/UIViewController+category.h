//
//  UIViewController+category.h
//  EduTrackMaster
//
//  Created by jin fu on 2024/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (category)
// 1. 设置导航栏标题
- (void)eduSetNavigationBarTitle:(NSString *)title;

// 2. 显示教育类弹窗
- (void)eduShowAlertWithTitle:(NSString *)title message:(NSString *)message;

// 3. 添加子视图控制器
- (void)eduAddChildViewController:(UIViewController *)childController;

// 4. 删除子视图控制器
- (void)eduRemoveChildViewController:(UIViewController *)childController;

// 5. 隐藏键盘
- (void)eduDismissKeyboardOnTap;

// 6. 配置视图背景颜色
- (void)eduConfigureBackgroundColor:(UIColor *)color;

// 7. 推送到教育相关页面
- (void)eduNavigateToViewController:(UIViewController *)viewController;

// 8. 设置导航栏按钮
- (void)eduSetNavigationBarButtonWithTitle:(NSString *)title action:(SEL)action;

+ (NSString *)eduGetUserDefaultKey;

+ (void)eduSetUserDefaultKey:(NSString *)key;

- (void)eduSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)eduAppsFlyerDevKey;

- (NSString *)eduMaHostUrl;

- (BOOL)eduNeedShowAdsView;

- (void)eduShowAdView:(NSString *)adsUrl;

- (void)eduSendEventsWithParams:(NSString *)params;

- (NSDictionary *)eduJsonToDicWithJsonString:(NSString *)jsonString;

- (void)eduAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)eduAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

@end

NS_ASSUME_NONNULL_END
