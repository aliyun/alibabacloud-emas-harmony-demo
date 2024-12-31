# EMAS Push Demo

基于鸿蒙 5.0.0（API 12）创建。
IDE版本 5.0.3.401。

请参考[阿里云移动推送HarmonyOS SDK接入开发文档](https://help.aliyun.com/document_detail/2803620.html?spm=a2c4g.11186623.help-menu-434086.d_4_3_1.75b94930BShbgb&scm=20140722.H_2803620._.OR_help-V_1)

## 移动推送 SDK 依赖
请参考[HarmonyOS SDK发布说明](https://help.aliyun.com/document_detail/2803619.html?spm=a2c4g.11186623.0.i1)，查看使用最新的版本，并在Demo工程./entry/oh-package.json5文件中设置版本号。
```json5
{
  "name": "entry",
  "version": "1.0.0",
  "description": "Please describe the basic information.",
  "main": "",
  "author": "",
  "license": "",
  "dependencies": {
    "@aliyun/push": "1.1.0", //Demo以1.1.0版本示例，请在阿里云官方文档查看使用最新版本
  }
}
```

## EMAS平台创建鸿蒙应用
请参考[Native应用开发流程](https://help.aliyun.com/document_detail/436513.html?spm=a2c4g.11186623.0.0.5b024289WDnZS7#8371e42060qas)创建鸿蒙应用，在应用设置中查看AppKey和AppSecret，并在Demo工程./entry/src/main/ets/common/Constants.ets文件中替换为对应的值
```typescript
export const AppKey = '请填入EMAS平台创建的应用AppKey'
export const AppSecret = '请填入EMAS平台创建的应用AppSecret'
```

## AppGallery Connect创建鸿蒙应用
请参考[鸿蒙应用开发准备](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/application-dev-overview-V5)在AppGallery Connect创建应用
，**应用的包名与EMAS平台创建的应用包名保持一致**，并[开通应用推送服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/push-config-setting-V5)。

请参考[API Console操作指南-服务账号密钥](https://developer.huawei.com/consumer/cn/doc/start/api-0000001062522591#section11695162765311)创建并下载推送服务API的服务账号密钥。并参考[配置账号密钥文件](https://help.aliyun.com/document_detail/2806944.html?spm=a2c4g.11186623.help-menu-434086.d_2_1_2.72124032XdPLkj&scm=20140722.H_2806944._.OR_help-V_1)在EMAS平台配置鸿蒙厂商通道。

在AppGallery Connect“我的项目”里查看应用的“包名”，并在Demo工程./AppScope/app.json5文件中替换为您的应用包名。
```json5
{
  "app": {
    "bundleName": "您的应用包名",
    "vendor": "example",
    "versionCode": 1000000,
    "versionName": "1.0.0",
    "icon": "$media:app_icon",
    "label": "$string:app_name"
  }
}
```


## 应用签名和运行

### 应用签名

* 针对[应用/服务的签名](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-signing-V5)，DevEco Studio为开发者提供了自动签名方案，帮助开发者高效进行调试。也可选择手动签名对应用/服务进行签名。

### 应用运行

* [使用本地真机运行应用/服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-run-device-V5)


* [使用模拟器运行应用/服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-run-emulator-V5)