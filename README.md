# Mob短信验证码SDK集成文档

由Nihility-Ming提供的来自Mob的免费短信验证码SDK。最新版本`v 1.2.0`

## CocoaPods

```
pod 'SMS-For-iOS'
```

## 集成
### 第一步 获取短信SDK

（注：iOS SDK1.1.1之后集成文档，请看最下面**v1.1.1之后版本更新说明**）

下载最新版SDK，解压后得到以下文件结构：

![image](http://wiki.mob.com/wp-content/uploads/2014/09/Screen-Shot-2015-02-05-at-11.05.15-AM.png)


1. SMS_SDK：短信验证码SDK，包括静态库和本地化文件。使用时直接将这个文件夹拖入工程。
1. SMS_SDKDemo：示例Demo 。

### 第二步 导入SDK

将SMS_SDK这个文件夹拖入工程。步骤如下：
![image](http://wiki.mob.com/wp-content/uploads/2014/09/SMS_SKD-drag.png)

### 第三步 添加依赖库文件

必要：

- libicucore.dylib
- libz.dylib
- MessageUI.framework
- javascriptcore.framework
- libstdc++.dylib

可选：

- AddressBook.framework （通讯录功能需要）
- AddressBookUI.framework（通讯录功能需要）

![image](http://wiki.mob.com/wp-content/uploads/2014/09/SMSSDKAddFramework.png)

### 第四步 添加初始化代码

1、在appDelegate 添加

```Objective-c
#import <SMS_SDK/SMS_SDK.h>
```

2 、在

```Objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```

添加

```Objective-c
[SMS_SDK registerApp:appKey withSecret:appSecret];
```

appKey 和 appSecret的获取：

（1）到[Mob官网](http://mob.com/)注册成为Mob开发者；

（2）到[应用管理后台](http://dashboard.mob.com/index.php/Sms#/)新建应用。

## 第五步 使用SDK提供的API

![SMS_SDKList](http://wiki.mob.com/wp-content/uploads/2014/09/SMS_SDKList.png)

SMS_SDK.h文件为SMSSDK的核心类。这个类的所有方法以类方法提供，根据需要直接使用相应的方法。

短信UI部分是以Demo形式开源的，具体参考Demo。以下是Demo中部分UI模块的说明：

1、弹出注册页面

```Objective-c
-(IBAction)registerUser:(id)sender {
   RegViewController* reg=[[RegViewController alloc] init];
   [self presentViewController:reg animated:YES completion:^{
 
   }];
}
```

注册界面RegViewController，进入该界面后，可选择国家和地区和输入手机号码进行短信注册验证；

选择国家和地区的选项进入SectionsViewController，在该控制器会从服务端获取所支持的国家和地区；

用户在注册页面输入手机号码之后，点击下一步，界面跳转到短信验证界面同时服务端会发送短信验证码到手机；

短信验证界面对应的控制器为VerifyViewController 主要处理短信的验证功能。

2、弹出通讯录好友界面

```Objective-C
-(IBAction)getAddressBookFriends:(id)sender {
   NSLog(@"show my friends");
   [_testView setNumber:0];
 
   SectionsViewControllerFriends* friends=[[SectionsViewControllerFriends alloc] init];
   _friendsController=friends;
 
   [_friendsController setMyBlock:_friendsBlock];
 
   [SMS_MBProgressHUD showMessag:@"正在加载中..." toView:self.view];
 
   [SMS_SDK getAppContactFriends:1 result:^(enum SMS_ResponseState state, NSArray *array) {
       if (1==state)
       {
           NSLog(@"block 获取好友列表成功");
 
           [_friendsController setMyData:array];
           [self presentViewController:_friendsController animated:YES completion:^{
                           ;
                       }];
               }
       else if(0==state)
       {
           NSLog(@"block 获取好友列表失败");
       }
  }];
}
```

通讯录好友界面SectionsViewControllerFriends，在事件响应中弹出该好友控制器即可；进入该界面后 会把通讯录的好友分为两类：

已加入的用户：可以点击添加按钮，直接添加已加入该app的通讯录好友。
待邀请的用户：可以点击邀请按钮发送短信邀请好友加入该app。

## v1.1.1之后版本更新说明
1.增加的库：

新的sdk中引入了公共库：**MOBFoundation.framework**

另外也增加来其他的依赖库

- **javascriptcore.framework**
- **libstdc++.dylib**

2.新版本中还可以继续调用旧版本中获取验证码等方法，旧版本中的方法都在`SMSSDK+DeprecatedMethods.h`这个类文件里

3.新版本中在SMSSDK.h类中增加了2个方法，获取验证码（发送短信获取验证码和语言获取验证码的方法可以直接调用同一个，只要改变里面的参数即可另外还增加了一个自定义短信模版标识，可以通过这个参数来修改获取到的验证码的内容,不过这个参数目前客户端暂时不支持，只支持http-api自定义短信模版）以及提交验证码的方法（增加了几个参数，可以同时传获取得到的验证码的手机号码以及区号），这2个方法与之前旧版本里的方法相比，更加方便，严谨些：

如下是获取验证码的方法
```Objective-C
#import <SMS_SDK/SMSSDK.h> //导入的头文件替换成这个

[SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS 
//这个参数可以选择是通过发送验证码还是语言来获取验证码 
                          phoneNumber:@"188****9331" 
                                 zone:@"86" 
                     customIdentifier:nil //自定义短信模板标识
                               result:^(NSError *error) 
{

                if (!error)
                {
                   NSLog(@"block 获取验证码成功");

                }
                else
                {

                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                    message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                          otherButtonTitles:nil, nil];
                    [alert show];

                }

            }];
```

如下是提交验证码的方法


```Objective-C
[SMSSDK commitVerificationCode:self.verifyCodeField.text 
//传获取到的区号 
                    phoneNumber:@"188****9331" 
                           zone:@"86" 
                         result:^(NSError *error)
 {
 
            if (!error)
            {
                NSLog(@"验证成功");
 
            }
            else
            {
 
                NSLog(@"验证失败");
            }
 
        }];
```

