

#import "AppDelegate.h"
#import "ViewController.h"
#pragma mark - 使用md5加密需要导入
#import<CommonCrypto/CommonDigest.h>
#pragma mark - 微信支付需要导入
#import <WechatOpenSDK/WXApi.h>
#pragma mark - 为福报支付需要导入
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
//支付宝签名
#import "RSADataSigner.h"

//微信代理
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}


#pragma mark - 微信总结

#pragma mark - 集成准备
/*
 微信开放平台注册账号 填写管理员信息 开发者资质认证（审核费用：中国大陆地区：300元，非中国大陆地区：120美元）；认证后就可以获取微信登录、智能接口、第三方平台开发等高级能力 认证有效期：一年，有效期最后三个月可申请年审即可续期
 -> 管理中心创建应用（最多10个应用；应用创建完成后就有了AppID和AppSecret（可以重置；重置后将影响微信登录，之前安卓的同事重置了 我这边用不了）
 -> 开通微信支付能力：1.资料审核：填写联系信息、APP应用信息、经营信息、商户信息、结算信息，收款账号就是在这里设置；2.账户验证：使用商户号登陆商户平台得到商户号mch_id，正确填写结算账户收到的确认金数目，以验证账户；3.协议签署；4.使用邮箱得到的账号密码登录商户平台设置api密钥
 */

#pragma mark - 集成
/*
 微信开放平台 资源中心 移动应用 微信支付功能 iOS开发手册 微信APP支付iOS开发文档（https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1 ）
 -> 1.SDK与demo下载 IOS头文件和库下载 iOS开发工具包（1.8.0版本，包含支付功能）通过CocoaPods集成接入流程：pod 'WechatOpenSDK' https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN
 -> 2. APP端开发步骤:https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5
    1.项目设置APPID:urlTypes:设置获取到的APPID；
    2.注册APPID：didFinishLaunchingWithOptions添加注册代码：[WXApi registerApp：@"wxd930ea5d5a258f4f" withDescription：@"demo 2.0"];
 -> 3.订单提交界面返回订单id：客户端将商户数量价格备注地址等信息提交到app后台，后台返回Orderid；客户端需要注意事项：保证停留在当前页面多次点击提交按钮只生成一个订单（保证唯一流水号）
 -> 4.客户端根据订单id获取支付预订单id；客户端向app后台发起申请获取支付预订单号；后端调用统一下单接口返回prepayid；统一下单接口:https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1
 -> 5.客户端根据预订单号；发起支付；发起支付用到的签名应该放到app服务器；
 -> 6.支付结果回调：onResp函数：支付完成后，微信APP会返回到商户APP并回调onResp函数，开发者需要   该函数中接收通知，判断返回错误码，如果支付成功则去后台查询支付结果再展示用户实际支付结果；比如跳转到订单列表界面
    签名细节：https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
 */


#pragma mark - 支付宝总结
#pragma mark - 集成准备
/*
 蚂蚁金服开放平台免费入驻注册登录实名认证 获取pid商户id -> 账户管理：银行账户 管理银行账户 -> 点击右上角开放平台 进入 -> 应用 -> 创建应用获取APPID -> 点击应用开通app支付能力:需要填写公司相关信息 并上传3张公司照片 默认开通登录和支付 登录只能获取到授权id 不能获取用户信息 -> 设置应用公钥：使用签名工具生成密钥和公钥 
 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
 将生成的公钥上传至应用后台
 url type中添加url schemes用于处理app之间的跳转
 App支付iOS集成流程：https://docs.open.alipay.com/204/105295/
 SDK与demo下载地址：https://docs.open.alipay.com/54/104509
 */
#pragma mark - 集成
/*
 导入支付宝AlipaySDK.bundle AlipaySDK.framework 添加相关依赖库 导入头文件import <AlipaySDK/AlipaySDK.h>
 
 错误修改：1.关于base64的错误：导入imageIO;并在相关位置导入uikit和foundation框架
        2.openssl/asn1.h not found: build setting -> header search path 加入$(SRCROOT)/CzyWeiXinAlipaySummarsize/支付宝SDK
 */

#pragma mark - 演示微信支付签名放在客户端 实际从app服务器签名后返回
#pragma mark - 微信发起支付发起支付
/*
- (void)jumpToPayWithWx:(TFButton *)sender
{
    [[TFNetWorkTool shareWithTFNetWorkTools] request:POST URLString:tongYiXiaDanUrl parameters:dic loadAnimation:HUD success:^(id result) {
        
        // 成功
        if ([result[@"ResCode"] integerValue] == 000000) {
            
            // 发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            
            // 应用ID appid 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录
            request.openID = WXAPPID;
            
            // 商户号	mch_id
            request.partnerId = @"14402681xxx";
            // 扩展字段	package
            request.package = @"Sign=WXPay";
            
            // 随机字符串	noncestr
            request.nonceStr= [self generateTradeNO];
            
            // 预支付交易会话ID	prepayid
            request.prepayId = result[@"PrepayId"];
            
            // 将当前时间转化成时间戳
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            UInt32 timeStamp =[timeSp intValue];
            request.timeStamp = timeStamp;
            
            // 签名加密
            request.sign=[self createMD5SingForPay:request.openID
                                         partnerid:request.partnerId
                                          prepayid:request.prepayId
                                           package:request.package
                                          noncestr:request.nonceStr
                                         timestamp:request.timeStamp];
            
            // 调用微信
            [WXApi sendReq:request];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
*/


-(NSString *)TYcreateMD5SingForPayOrderId:(NSString *)OrderId
                          mch_idRequestNo:(NSString *)RequestNo
                     nonce_strAccessToken:(NSString *)accessToken
                                  version:(NSString *)version
                                timestamp:(NSString *)timestamp
{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    
    [signParams setObject:OrderId forKey:@"OrderId"];
    [signParams setObject:RequestNo forKey:@"RequestNo"];
    [signParams setObject:version forKey:@"version"];
    [signParams setObject:timestamp forKey:@"timestamp"];
    [signParams setObject:accessToken forKey:@"accessToken"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    
    //根据keys按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //去掉value = nil || @"sign" || @"keys" 然后拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    
    //拼接商户平台api密钥
    [contentString appendFormat:@"key=%@", @"hhgkhenghanggaoke2017tkfxxxxxx"];
    
    //示例： 8B68 328D B594 311E 8517 21C0 5ED1 8C53
    NSString *result = [self md5:contentString];
    
    return result;
}

#pragma mark - 产生随机字符串
/**
 ------------------------------
 产生随机字符串
 ------------------------------
 1.生成随机数算法 ,随机字符串，不长于32位
 2.微信支付API接口协议中包含字段nonce_str，主要保证签名不可预测。
 3.我们推荐生成随机数算法如下：调用随机数函数生成，将得到的值转换为字符串。
 */
- (NSString *)generateTradeNO
{
    static int kNumber = 32;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    //  srand函数是初始化随机数的种子，为接下来的rand函数调用做准备。
    //  time(0)函数返回某一特定时间的小数值。
    //  这条语句的意思就是初始化随机数种子，time函数是为了提高随机的质量（也就是减少重复）而使用的。
    
    //　srand(time(0)) 就是给这个算法一个启动种子，也就是算法的随机种子数，有这个数以后才可以产生随机数,用1970.1.1至今的秒数，初始化随机数种子。
    //　Srand是种下随机种子数，你每回种下的种子不一样，用Rand得到的随机数就不一样。为了每回种下一个不一样的种子，所以就选用Time(0)，Time(0)是得到当前时时间值（因为每时每刻时间是不一样的了）。
    srand((unsigned)time(0));
    
    for (int i = 0; i < kNumber; i++) {
        
        unsigned index = rand() % [sourceStr length];
        
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


#pragma mark - MD5加密算法
-(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，微信要求返回32位大写
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma mark - 支付宝支付模拟 客户端最好是直接调用app服务器返回的orderString
- (void)doAlipayPay
{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}


#pragma mark - 支付回调 
#pragma mark - 微信支付回调WXApiDelegate
-(void)onResp:(BaseResp*)resp{
    
    static BOOL payResultNotification;
    
    if ([resp isKindOfClass:[PayResp class]]){
        
        PayResp*response=(PayResp*)resp;
        
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                
                payResultNotification = YES;
                
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                
                payResultNotification = NO;
                
                break;
        }
        
        // >!支付结果通知
        //NSDictionary *payResultNotificationDic = @{@"payResultNotification":@(payResultNotification)};
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RSULT_NOTIFY object:nil userInfo:payResultNotificationDic];
        
    }
}

#pragma mark - app跳转的回调处理
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
   return [self haddleCompletionWithUrl:url];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [self haddleCompletionWithUrl:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self haddleCompletionWithUrl:url];
}

- (BOOL)haddleCompletionWithUrl:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        
        // >!支付跳转支付宝 处理支付宝支付结果的回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            [self alipayNotification:resultDic];
            
            // >!发送支付宝支付结果通知
            //[[NSNotificationCenter defaultCenter] postNotificationName:ALIPAY_RESULT_NOTIFY object:nil userInfo:resultDic];
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@",resultDic);
            
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    else if ([url.host isEqualToString:@"pay"]){
        
        // >!微信方式发起支付 处理微信支付结果
        //NSLog(@"host = %@, url = %@", url.host, url);
        
        // >!微信
        return [WXApi handleOpenURL:url delegate:self];
        
    }else{
        
        // >!其他回调 比如友盟登录
        //BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
        
        // >!发送友盟登录成功通知
        //[[NSNotificationCenter defaultCenter] postNotificationName:UM_LOGIN_RESULT_NOTIFY object:nil userInfo:@{@"loginResultByUM":@(result)}];
        
        //return result;
        
        return YES;
    }
    
    return YES;
}

#pragma mark - 支付宝支付结果通知与处理
- (void)alipayNotification:(NSDictionary *)dict {
    
    static BOOL payResultNotification;
    NSInteger resultStatus = [dict[@"resultStatus"] integerValue];
    if (resultStatus == 9000) {
        NSLog(@"支付成功");
        payResultNotification = YES;
    } else {
        payResultNotification = NO;
    }
    
    // >!支付结果通知
    NSDictionary *payResultNotificationDic = @{@"payResultNotification":@(payResultNotification)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"payResultNotification" object:nil userInfo:payResultNotificationDic];
    
}
@end



