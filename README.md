#DKNotificationManager

DKNotificationManager - a helper class which deals with NSLocalNotifications. With it you can easily create notifications and delete a particular notification.

##How to use

There is a sample project of a universal app for iPhone and iPad.

```
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
```

##Supported iOS Versions 
It supports iOS 6.0 and higher. 