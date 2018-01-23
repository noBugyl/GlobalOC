//
//  AppDelegate.m
//  OCGlobal
//
//  Created by Eddie on 2018/1/12.
//  Copyright © 2018年 yl. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "NavViewController.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self registerLocalNotification];
//    [application registerForRemoteNotifications];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[NavViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerLocalNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.badge = @1;
        content.title = @"10以上的本地推送";
        content.body = @"sdfasdfjkl";
        content.categoryIdentifier = @"cate";
        content.sound = [UNNotificationSound defaultSound];
        NSDateComponents *pon = [NSDateComponents new];
        pon.second = 10;
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:pon repeats:true];
        UNNotificationRequest *local = [UNNotificationRequest requestWithIdentifier:@"local" content:content  trigger:trigger];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center addNotificationRequest:local withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }else {
        UIMutableUserNotificationCategory *category = [UIMutableUserNotificationCategory new];
        // 设置标识符，注意与发送通知设置的category标识符一致~！
        category.identifier = @"category";
        // 设置按钮，注意使用可变子类UIMutableUserNotificationAction
        // 设置前台按钮，点击后能使程序回到前台的叫做前台按钮
        UIMutableUserNotificationAction *action1 = [UIMutableUserNotificationAction new];
        action1.identifier = @"qiantai";
        action1.activationMode = UIUserNotificationActivationModeForeground;
        // 设置按钮的标题，即按钮显示的文字
        action1.title = @"呵呵";
        
        // 设置后台按钮，点击后程序还在后台执行，如QQ的消息
        UIMutableUserNotificationAction *action2 = [UIMutableUserNotificationAction new];
        action2.identifier = @"houtai";
        action2.activationMode = UIUserNotificationActivationModeBackground;
        // 设置按钮的标题，即按钮显示的文字
        action1.title = @"后台呵呵";
        // 给分类设置按钮
        [category setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
        
        // 注册，请求授权的时候将分类设置给授权，注意是 NSSet 集合
        NSSet *categorySet = [NSSet setWithObject:category];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:categorySet];
        // 注册通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        UILocalNotification *local = [UILocalNotification new];
//        [[UIApplication sharedApplication] scheduleLocalNotification:local];
//        local.fireDate = [NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]];
//        local.alertBody = @"我是一个本地推送";
//        local.soundName = UILocalNotificationDefaultSoundName;
//        local.timeZone = [NSTimeZone systemTimeZone];
//        local.applicationIconBadgeNumber = 1;
//        local.alertAction = @"滑动来点开本地的这个推送";
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//}
//
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    NSLog(@"收到本地推送");
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
