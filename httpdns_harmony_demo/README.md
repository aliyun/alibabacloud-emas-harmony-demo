# EMAS HTTPDNS Demo

基于鸿蒙 5.0.0（API 12）创建。
IDE版本 5.0.3.401。

请参考[阿里云HTTPDNS HarmonyOS SDK接入开发文档](https://help.aliyun.com/document_detail/2766013.html?spm=a2c4g.11186623.help-menu-434086.d_4_2.4b61693flqL4SW)

## HTTPDNS SDK 依赖
请参考[HarmonyOS SDK发布说明](https://help.aliyun.com/document_detail/2766014.html?spm=a2c4g.11186623.0.i0)，查看使用最新的版本，并在Demo工程oh-package.json5文件中设置版本号。
```json5
{
  "dependencies": {
    "@aliyun/httpdns": "1.1.0", //Demo以1.1.0版本示例，请在阿里云官方文档查看使用最新版本
  }
}
```

## EMAS平台创建鸿蒙应用
请参考[Native应用开发流程](https://help.aliyun.com/document_detail/436513.html?spm=a2c4g.11186623.0.0.5b024289WDnZS7#8371e42060qas)创建鸿蒙应用

## 配置APP信息
### 1.配置 accountId、secretKey
请了解[产品使用流程](https://help.aliyun.com/document_detail/435229.html?spm=a2c4g.11186623.0.0.335172c8cXN2d5)，获取Account ID，并根据业务需要选择是否开启鉴权功能。

在Demo工程./entry/src/main/resources/rawfile/aliyun-emas-services.json5文件中替换为对应的值。

**在EMAS平台下载的Demo，aliyun-emas-services.json5文件中已配置应用的accountId和secretKey，可以不再进行以下配置**

```json5
{
  "config": {
  "httpdns.accountId":"请填入阿里云HTTPDNS控制台的Account ID",
  "httpdns.secretKey":"请填入阿里云HTTPDNS控制台的secretKey"
  }
}
```

### 2.配置需要解析的域名列表
请参考[域名管理](https://help.aliyun.com/document_detail/435233.html?spm=a2c4g.11186623.0.0.5e0b693fRtToSF#topic-1994313)，进入EMAS后台域名列表添加要解析的域名


## 应用签名和运行

### 应用签名

* 针对[应用/服务的签名](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-signing-V5)，DevEco Studio为开发者提供了自动签名方案，帮助开发者高效进行调试。也可选择手动签名对应用/服务进行签名。

### 应用运行

* [使用本地真机运行应用/服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-run-device-V5)


* [使用模拟器运行应用/服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-run-emulator-V5)