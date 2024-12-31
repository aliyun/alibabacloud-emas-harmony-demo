/**
 MIT License

 Copyright (c) 2024 Alibaba Cloud

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import { httpdns, HttpDnsError, HttpDnsResult, IpType } from '@aliyun/httpdns';

@Component
export struct CasePage {

  @Link @Watch('didChangeTabSelectedIndex') tabSelectedIndex: number

  @State resultLabel: string = ''

  //示例accountId，真实使用场景中，需要替换为阿里云HTTPDNS控制台的Account ID
  private accountId: string = '请填入阿里云HTTPDNS控制台的Account ID'

  //示例域名，真实使用场景中，需要使用阿里云HTTPDNS控制台添加的域名，并自定义解析函数
  private host: string = 'ams-sdk-public-assets.oss-cn-hangzhou.aliyuncs.com'

  //示例SDNS请求的参数，以key、value键值对组成的对象。SDNS的自定义解析函数消费
  private params: Record<string, string> = { 'keyA': 'valueA'}

  //示例SDNS请求的缓存标识，SDK使用，相同cacheKey的缓存结果会放到一个缓存中
  private cacheKey: string = 'cacheKey1'

  //示例SDNS请求的公共参数
  private globalParams: Record<string, string> = {'globalKeyA': 'globalValueA', 'globalKeyB': 'globalValueB'}


  didChangeTabSelectedIndex() {
    if (this.tabSelectedIndex == 1) {
      this.resultLabel = ''
      this.getSDnsResultAsync()
    }
  }

  //带参数的dns解析。根据参数不同，可以返回不同的结果。
  getSDnsResultAsync() {
    httpdns.getService(this.accountId).then((service) => {
      return service.getSDnsResultAsync(this.host, this.params, this.cacheKey, IpType.Auto);
    }).then((result: HttpDnsResult) => {
      this.SDnsResultHandle(result)
    }).catch((e: HttpDnsError) => {
      console.error(`getSDnsResultAsync error: ${e.code} ${e.message}`);
      this.SDnsErrorHandle(e)
    });
  }

  //同步 sdns解析
  getSDnsResultSyncNonBlocking() {
    httpdns.getService(this.accountId).then((service) => {
      const result = service.getSDnsResultSyncNonBlocking(this.host, this.params, this.cacheKey, IpType.Auto);
      this.SDnsResultHandle(result)
    }).catch((e: HttpDnsError) => {
      console.error(`getSDnsResultSyncNonBlocking error: ${e.code} ${e.message}`);
      this.SDnsErrorHandle(e)
    });
  }

  SDnsResultHandle(result: HttpDnsResult) {
    let label = `解析的域名 ${result.host}`
    if (result.ipv4s != undefined && result.ipv4s.length > 0) {
      label += `\n解析的ipv4地址 ${result.ipv4s?.join(',')}`
    }
    if (result.ipv6s != undefined && result.ipv6s.length > 0) {
      label += `\n解析的ipv6地址 ${result.ipv6s?.join(',')}`
    }
    if (result.extraStr != undefined) {
      label += `\nSDNS额外参数（字符串格式） ${result.extraStr}`
    }
    this.resultLabel = label
  }

  SDnsErrorHandle(e: HttpDnsError) {
    this.resultLabel = `error: ${e.code} ${e.message}`
  }

  // 添加公共参数
  setSDnsGlobalParams() {
    httpdns.getService(this.accountId).then((service) => {
      service.setSDnsGlobalParams(this.globalParams);
    }).catch((e: HttpDnsError) => {
      console.error(`setSDnsGlobalParams error: ${e.code} ${e.message}`);
    });
  }

  // 清空公共参数
  clearSDnsGlobalParams() {
    httpdns.getService(this.accountId).then((service) => {
      service.clearSDnsGlobalParams();
    }).catch((e: HttpDnsError) => {
      console.error(`clearSDnsGlobalParams error: ${e.code} ${e.message}`);
    });
  }


  build() {
    Column() {
      this.setupUI()
    }
    .padding({left: 16, right: 16, top: 60, bottom: 16})
    .backgroundColor('rgba(242,243,247,1)')
    .width('100%')
    .height('100%')
  }

  @Builder setupUI() {
    RelativeContainer() {
      Row() {
        Text('解析结果')
          .font({size: 16, weight: 500})
          .fontColor('#1F2024')
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({left: 20, bottom: 18, top: 18})
      .alignRules({
        top: {anchor: "__container__", align: VerticalAlign.Top},
        left: {anchor: "__container__", align: HorizontalAlign.Start},
      })
      .id('resultText')

      Scroll() {
        Column() {
          Text('HTTPDNS SDNS 最佳实践')
            .font({size: 12, weight: 500})
            .fontColor('#A7BCCE')

          Text(this.resultLabel)
            .font({size: 12})
            .fontColor('#3D3D3D')
            .lineHeight(24)
            .margin({top: 10})
            .align(Alignment.Start)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .backgroundColor('#F8F9FB')
        .borderRadius(8)
        .padding({left: 20, right: 13, top: 12, bottom: 8})
      }
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .alignRules({
        top: {anchor: "resultText", align: VerticalAlign.Bottom},
        left: {anchor: "__container__", align: HorizontalAlign.Start},
        bottom: {anchor: "__container__", align: VerticalAlign.Bottom}
      })
      .backgroundColor('#F8F9FB')
      .align(Alignment.Top)
      .id('Scroll')
      .borderRadius(8)
    }
    .padding(4)
    .backgroundColor('#FFFFFF')
    .width('100%')
    .height('100%')
    .borderRadius(8)
  }
}