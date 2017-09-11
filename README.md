```
#pragma mark - 微信总结

#pragma mark - 集成准备
/*
 微信开放平台注册账号 填写管理员信息 开发者资质认证（审核费用：中国大陆地区：300元，非中国大陆地区：120美元）；
 认证后就可以获取微信登录、智能接口、第三方平台开发等高级能力 认证有效期：一年，有效期最后三个月可申请年审即可续期
 -> 管理中心创建应用（最多10个应用；应用创建完成后就有了AppID和AppSecret（可以重置；重置后将影响微信登录，之前安卓的同事重置了 我这边用不了）
 -> 开通微信支付能力：1.资料审核：填写联系信息、APP应用信息、经营信息、商户信息、结算信息，收款账号就是在这里设置；
                    2.账户验证：使用商户号登陆商户平台得到商户号mch_id，正确填写结算账户收到的确认金数目，以验证账户；
                    3.协议签署；
                    4.使用邮箱得到的账号密码登录商户平台设置api密钥
 */

#pragma mark - 集成
/*
 微信开放平台 资源中心 移动应用 微信支付功能 iOS开发手册 微信APP支付iOS开发文档（https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1 ）
 -> 1.SDK与demo下载 IOS头文件和库下载 iOS开发工具包（1.8.0版本，包含支付功能）通过CocoaPods集成接入流程：
      ![pod 'WechatOpenSDK'](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN)
 -> 2.![APP端开发步骤](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5)
     1.项目设置APPID:urlTypes:设置获取到的APPID；
     2.注册APPID：didFinishLaunchingWithOptions添加注册代码：[WXApi registerApp：@"wxd930ea5d5a258f4f" withDescription：@"demo 2.0"];
 -> 3.订单提交界面返回订单id：客户端将商户数量价格备注地址等信息提交到app后台，后台返回Orderid
      ；客户端需要注意事项：保证停留在当前页面多次点击提交按钮只生成一个订单（保证唯一流水号）
 -> 4.客户端根据订单id获取支付预订单id；客户端向app后台发起申请获取支付预订单号；
      后端调用统一下单接口返回prepayid；![统一下单接口](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1)
 -> 5.客户端根据预订单号；发起支付；发起支付用到的签名应该放到app服务器；
 -> 6.支付结果回调：onResp函数：支付完成后，微信APP会返回到商户APP并回调onResp函数，
      开发者需要在该函数中接收通知，判断返回错误码，如果支付成功则去后台查询支付结果再展示用户实际支付结果；比如跳转到订单列表界面
      ![签名细节](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3)
 */


#pragma mark - 支付宝总结
#pragma mark - 集成准备
/*
 蚂蚁金服开放平台免费入驻注册登录实名认证 获取pid商户id -> 账户管理：银行账户 管理银行账户
 -> 点击右上角开放平台 进入 -> 应用 -> 创建应用获取APPID
 -> 点击应用开通app支付能力:需要填写公司相关信息 并上传3张公司照片 默认开通登录和支付 登录只能获取到授权id 不能获取用户信息
 -> 设置应用公钥：使用签名工具生成密钥和公钥 
 ![工具地址](https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1)
 将生成的公钥上传至应用后台
 url type中添加url schemes用于处理app之间的跳转
 ![App支付iOS集成流程](https://docs.open.alipay.com/204/105295/)
 ![SDK与demo下载地址](https://docs.open.alipay.com/54/104509)
 */
#pragma mark - 集成
/*
 导入支付宝AlipaySDK.bundle AlipaySDK.framework 添加相关依赖库 导入头文件import <AlipaySDK/AlipaySDK.h>
 
 错误修改：1.关于base64的错误：导入imageIO;并在相关位置导入uikit和foundation框架
        2.openssl/asn1.h not found: build setting -> header search path 加入$(SRCROOT)/CzyWeiXinAlipaySummarsize/支付宝SDK
 */
 ```
