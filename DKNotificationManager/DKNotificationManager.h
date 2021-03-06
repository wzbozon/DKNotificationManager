//
//  DKNotificationManager.h
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

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString *const NotificationKey;


@interface DKNotificationManager : NSObject

@property(nonatomic) NSCalendarUnit repeatInterval;      // 0 means don't repeat

// Shared instance, singleton
+ (DKNotificationManager*)sharedManager;

// Sets a local notification with a week interval. AlertBody is a text, that user sees when notification comes. UserInfo is used to identify different notifications. You can send ID of a citation for example that will be in the notification.
- (void)setLocalNotificationWithAlertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo;

// Removes local notifcation with a particular userInfo.
- (void)removeLocalNotificationWithUserInfo:(NSDictionary *)userInfo;

// Removes all local notifications.
- (void)removeAllLocalNotifications;

// Used to switch notifications on and off. 
- (void)switchNotifications:(id)sender;

// Sends device token to your server 
- (void)addDeviceTokenToServerDb:(NSData *)token onComplete:(void (^)(NSString* error))completionBlock;

// Register for local notifications (user gives permission)
- (void)registerForLocalNotifications:(UIApplication *)application;

// Register for push notifications
- (void)registerForPushNotifications;

@end
