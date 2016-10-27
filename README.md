<<<<<<< HEAD
###Jpush使用说明
### 下载说明
* 下载插件源代码

* 下载fami-plugin-lists用于集成插件 git clone git@github.com:fami2u/fami-plugin-lists.git

* 以上两个目录平级

* cd fami-plugin-lists

* 查看当前安装的插件 cordova plugin list

* 删除插件 cordova plugin remove com.fami2u.plugin.

* 安装插件 cordova-plugin- 使用命令 cordova plugin add ../

* 重新编译插件 cordova build android||ios

### 调用说明
> IOS部分

####- 首先你需要到极光推送官网上注册账号。登录账号之后创建应用并上传APNs证书。（如果对证书不太了解，可参考 IOS证书设置指南<http://docs.jpush.io/client/ios_tutorials/#ios_1>）
####- 项目中需要手动添加一个依赖libz.tbd。其他依赖插件中已添加。
####- 如果使用的xcode是7.0以上的，需要在plist文件中添加支持HTTP协议。

    <key>NSAppTransportSecurity</key> 
      <dict> 
    <key>NSAllowsArbitraryLoads</key> 
        <true/> 
      </dict> 
      

####- 以下 ３ 个事件监听与调用 JPush SDK API 都是必须的。请直接复制如下代码块里，到你的应用程序代理类(AppDelegate.m)里相应的监听方法里。

          - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //1.启动推送SDK
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        //可以添加自定义
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }else{
        
        //categiories 必须为nil   ios 8 以前
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions appKey:appKEY channel:@"引导" apsForProduction:FALSE];
    
    
    //如果app未启动,本地通知获取
    NSDictionary *localNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
    NSLog(@"本地通知内容:%@",localNotification);
    
    return YES;
}


    //2.监听系统事件，相应地调用 JPush SDK 提供的 API 来实现功能。以下几个事件监听与调用 JPush SDK API 都是必须的。

	
	- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:( NSData *)deviceToken{
	    
	   [JPUSHService registerDeviceToken:deviceToken];

    NSLog(@"token-----%@",deviceToken);
     }
	
	
	//处理收到的 APNs 消息
	- (void)application:(UIApplication *)application didReceiveRemoteNotification:( NSDictionary *)userInfo{
	    
	    [JPUSHService handleRemoteNotification:userInfo];
	    
	}


	- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
	    
	    [JPUSHService handleRemoteNotification:userInfo];
	    NSLog(@"收到通知:%@",[self logDic:userInfo]);
	    
	    completionHandler(UIBackgroundFetchResultNewData);
	    
	}
	
	
	//如果APP在前台或者是后台正在运行，那么收到通知的时候会执行此方法,默认App在前台运行时不会进行弹窗，在程序接收通知调用此接口可实现指定的推送弹窗
	- (void)application:(UIApplication *)application
	didReceiveLocalNotification:(UILocalNotification *)notification {
	    
	    //[JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
	    NSLog(@"本地通知为:%@",notification);
	    
	}
	
	
	- (void)application:(UIApplication *)application
	didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
	}
	
	
	//进入前台之后将角标数字置为0并取消通知
	- (void)applicationWillEnterForeground:(UIApplication *)application {
	
	    [application setApplicationIconBadgeNumber:0];
	    
	    [application cancelAllLocalNotifications];
	    
	    
	}
	
	
	// log NSSet with UTF8
	// if not ,log will be \Uxxx
	
	- (NSString *)logDic:(NSDictionary *)dic {
	    if (![dic count]) {
	        return nil;
	    }
	    NSString *tempStr1 =
	    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
	                                                 withString:@"\\U"];
	    NSString *tempStr2 =
	    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	    NSString *tempStr3 =
	    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
	    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
	    NSString *str =
	    [NSPropertyListSerialization propertyListFromData:tempData
	                                     mutabilityOption:NSPropertyListImmutable
	                                               format:NULL
	                                     errorDescription:NULL];
	    return str;
	}



####- 插件中留了三个方法的接口，setNotification 设置本地通知，需要的一些参数在插件中有详细说明。getRegistrationID 返回设备的唯一标识符。调用如下：
Jpush.setNotification();

Jpush.getRegistrationID();

Jpush.setTagsAndAlias();

#### 参数说明：
 
 - fireDate     本地推送触发的时间
 - alertBody    本地推送需要显示的内容
 - badge        角标的数字。如果不需要改变角标传-1
 - alertAction  弹框的按钮显示的内容（iOS 8默认为"打开",其他默认为"启动"）
 - notificationKey 本地推送标示符
 - userInfo 自定义参数，可以用来标识推送和增加附加信息(字典类型)
 - soundName 本地通知声音名称设置，空为默认声音
 
 
 
#### 请在plugin.xml 中传递参数，例
      <preference name="fireDate" value= "$fireDate"/>
#####更多插件请点击：[fami2u](https://github.com/fami2u)
#####关于我们：[FAMI](http://fami2u.com)
=======
# cordova-Jpush
cordova-Jpush
>>>>>>> 630ade4558b9b1faed04f5d973a4d5274252b00e
