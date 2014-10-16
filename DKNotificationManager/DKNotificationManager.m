//
//  DKNotificationManager.m
//
//  Created by Denis Kutlubaev on 17.09.14.
//
//  This code is distributed under the terms and conditions of the MIT license.
//  Copyright (c) 2014 Dennis Kutlubaev (kutlubaev.denis@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DKNotificationManager.h"
/*#import <AFNetworking/AFNetworking.h>
#import <BlockAlertsAnd-ActionSheets/BlockAlertView.h>*/


NSString *const NotificationKey = @"NotificationKey";


@interface DKNotificationManager()
{
    //AFHTTPRequestOperationManager *_manager;
}

@end


@implementation DKNotificationManager


+ (DKNotificationManager *)sharedManager
{
    static DKNotificationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DKNotificationManager alloc] init];
        
        // By default repeat interval is 1 week
        sharedManager.repeatInterval = NSWeekCalendarUnit;
    });
    
    return sharedManager;
}


- (void)setLocalNotificationWithAlertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *nowDateComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:nowDate];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:[nowDateComponents day]];
    [dateComponents setMonth:[nowDateComponents month]];
    [dateComponents setYear:[nowDateComponents year]];
    [dateComponents setHour:[nowDateComponents hour]];
    [dateComponents setMinute:[nowDateComponents minute]];
    [dateComponents setSecond:[nowDateComponents second] + 10];
    
    NSDate *notificationDate = [gregorian dateFromComponents:dateComponents];
    NSString *dateString = [dateFormatter stringFromDate:notificationDate];
    NSLog(@"Fire date:%@", dateString);
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    
    localNotification.repeatInterval = self.repeatInterval;
    localNotification.fireDate = notificationDate;
    
    localNotification.alertBody = alertBody;
    [localNotification setUserInfo:userInfo];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


- (void)removeLocalNotificationWithUserInfo:(NSDictionary *)userInfo
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *notification in notifications) {

        BOOL isSame = YES;
        NSArray *allKeys = notification.userInfo.allKeys;
        for (NSString *key in allKeys) {
            if (! [userInfo[key] isEqualToString:notification.userInfo[key]]) {
                // Если хотя бы одно значение не совпадает, выходим из цикла
                isSame = NO;
                break;
            }
        }
        
        if (isSame) {
            // Если одинаковые ключи и значения, то удаляем это уведомление
            NSLog(@"Deleting local notification: %@", userInfo);
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}


- (void)removeAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


- (void)switchNotifications:(id)sender
{
    //This is an example, how this method can be realised. When user switches off notifications, I ask him, if he really wants to do that. Then I save the state of switch to the NSUserDefaults and remove all notifications. I use a pod 'BlockAlertsAnd-ActionSheets' to show dialog box.
    
    /*UISwitch *switcher = (UISwitch*)sender;
    BOOL notifications = switcher.on;
    if (! notifications) {
        
        BlockAlertView *alert = [[BlockAlertView alloc]  initWithTitle:@"Вы уверены?" message:@"При выключении данной опции все ранее запланированные напоминания удаляются."];
        [alert setDestructiveButtonWithTitle:@"Выключить" block:^{
            
            [[NSUserDefaults standardUserDefaults] setBool:notifications forKey:UDKeyLocalNotifications];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[DKNotificationManager sharedManager] removeAllLocalNotifications];
            
            [SVProgressHUD showSuccessWithStatus:@"Выполнено!"];
            
        }];
        [alert setCancelButtonWithTitle:@"Отмена" block:^{
            
            switcher.on = YES;
            
        }];
        [alert show];
        
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:notifications forKey:UDKeyLocalNotifications];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }*/
}


- (void)addDeviceTokenToServerDb:(NSData *)token onComplete:(void (^)(NSString* error))completionBlock
{
    /*NSString *newToken = [token description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/", ServerApiURL, ServerMethodAddToken];
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    
    NSLog(@"urlString:%@", urlString);
    NSLog(@"Token:%@", newToken);
    NSLog(@"Bundle:%@", bundleId);
    
    [_manager POST:urlString parameters:@{@"token": newToken, @"bundle":bundleId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject: %@", responseObject);
        completionBlock(nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@", error);
        completionBlock([error description]);
        
    }];*/
}


- (void)registerForLocalNotifications:(UIApplication *)application
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}


- (void)registerForPushNotifications
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}


@end
