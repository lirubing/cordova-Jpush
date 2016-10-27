/********* Jpush.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "JPUSHService.h"


@interface Jpush : CDVPlugin

//设置本地通知
/*
 参数说明：
 
 fireDate 本地推送触发的时间
 alertBody 本地推送需要显示的内容
 badge 角标的数字。如果不需要改变角标传-1
 alertAction 弹框的按钮显示的内容（iOS 8默认为"打开",其他默认为"启动"）
 notificationKey 本地推送标示符
 userInfo 自定义参数，可以用来标识推送和增加附加信息
 soundName 本地通知声音名称设置，空为默认声音
 
 */

@property(nonatomic,strong)NSDate *fireDate;
@property(nonatomic,strong)NSString *alertBody;
@property(nonatomic,strong)NSString *badge;
@property(nonatomic,strong)NSString *alertAction;
@property(nonatomic,strong)NSString *notificationKey;
@property(nonatomic,strong)NSDictionary *userInfo;
@property(nonatomic,strong)NSString *soundName;



- (void)coolMethod:(CDVInvokedUrlCommand*)command;


@end

@implementation Jpush

-(void)pluginInitialize{
    
    CDVViewController *viewController = (CDVViewController *)self.viewController;
    
    self.fireDate = [viewController.settings objectForKey:@"fireDate"];
    self.alertBody = [viewController.settings objectForKey:@"alertBody"];
    self.badge = [viewController.settings objectForKey:@"badge"];
    self.alertAction = [viewController.settings objectForKey:@"alertAction"];
    self.notificationKey = [viewController.settings objectForKey:@"notificationKey"];
    self.userInfo = [viewController.settings objectForKey:@"userInfo"];
    self.soundName = [viewController.settings objectForKey:@"soundName"];
    
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    
    [self setNotification];
    
}


//设置本地通知
- (UILocalNotification *)setNotification
{
    
    UILocalNotification *_notification;
    
    int bagge = [self.badge intValue];
    
    _notification = [JPUSHService setLocalNotification:self.fireDate alertBody:self.alertBody badge:bagge alertAction:self.alertAction identifierKey:self.notificationKey userInfo:self.userInfo soundName:self.soundName];
    
    if (_notification) {
        NSLog(@"设置本地通知成功！");
    }else{
        
        NSLog(@"设置本地通知失败！");
    }
    
    return _notification;
}

//获取设备标识符
- (NSString *)getRegistrationID{
    
    return [JPUSHService registrationID];
}

//设置别名和标签
//- (void)setTagsAndAlias:(CDVInvokedUrlCommand*)command{
//
//    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
//
//    NSLog(@"%@",self.alertBody);
//    if (![self.tag isEqualToString:@""] && self.tag) {
//
//        [tags addObject:self.tag];
//
//    }

// [JPUSHService setTags:tags alias:self.alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];

//NSLog(@"设置tag和alias已发送");
//}

//设置标签和别名之后的回调方法，可以回调结果是否设置成功。
//- (void)tagsAliasCallback:(int)iResCode
//                     tags:(NSSet *)tags
//                    alias:(NSString *)alias {
//
//    NSString *callbackString =
//    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
//     tags, alias];
//
//    NSLog(@"TagsAlias回调:%@", callbackString);
//}

@end

