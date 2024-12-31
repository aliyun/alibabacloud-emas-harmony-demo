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

import { httpdns, HttpDnsError } from '@aliyun/httpdns'
import { emasInfo } from '../common/EmasInfo'
import { IpType } from '@aliyun/httpdns'
import { HttpDnsResult } from '@aliyun/httpdns'
import { PreparePage } from './PreparePage'
import { DomainSelectInputView, ResolveType } from './view/DomainSelectInputView'
import { SearchDomainPageParam } from './SearchDomainPage'
import { PageName } from '../common/PageName'
import { ttlCustomizer } from '../common/TtlCustomizer'

@Component
export struct BasicPage {
  @State isShowResultPage: boolean = false

  private timestamp: number = 0

  @Consume('navPathStack') navPathStack: NavPathStack

  @State @Watch('didChangeSelectedDomain') selectedDomain: string = ''

  @State @Watch('didChangeResolveType') resolveType: ResolveType = ResolveType.unkown

  @State domainDesc: string = ''

  @State ipv4Desc: string = ''

  @State ipv6Desc: string = ''

  @State isResultNull: boolean = false

  @State @Watch('didChangeIsNeedNewResolve') isNeedNewResolve: boolean = false

  didChangeIsNeedNewResolve() {
    if (this.isNeedNewResolve) {
      this.domainDesc = ''
      this.ipv4Desc = ''
      this.ipv6Desc = ''
      this.isResultNull = false
    }
  }

  didChangeSelectedDomain() {
    this.isNeedNewResolve = true
  }

  didChangeResolveType() {
    this.isNeedNewResolve = true
  }

  //解析域名，同步方法，没有缓存时，返回空
  getHttpDnsResultSyncNonBlocking() {
    this.timestamp = new Date().getTime()
    httpdns.getService(emasInfo.accountId).then((service) => {
      console.log(`getHttpDnsResultSyncNonBlocking host:${this.selectedDomain} IpType:Auto`)
      const result = service.getHttpDnsResultSyncNonBlocking(this.selectedDomain, IpType.Auto);
      this.httpDnsResultHandle(result);
    }).catch((error: HttpDnsError) => {
      this.httpDnsResultErrorHandle(error)
    });
  }

  //解析域名，异步方法，没有缓存时，请求网络，返回结果，有缓存时，使用缓存
  getHttpDnsResultAsync() {
    this.timestamp = new Date().getTime()
    httpdns.getService(emasInfo.accountId).then((service) => {
      console.log(`getHttpDnsResultAsync host:${this.selectedDomain} IpType:Auto`)
      return service.getHttpDnsResultAsync(this.selectedDomain, IpType.Auto);
    }).then((result: HttpDnsResult) => {
      this.httpDnsResultHandle(result)
    }).catch((error: HttpDnsError) => {
      this.httpDnsResultErrorHandle(error)
    });
  }

  httpDnsResultHandle(result: HttpDnsResult) {
    console.log(`getHttpDnsResult host:${result.host} ipv4:${result.ipv4s} ipv6:${result.ipv6s}`)
    const duration = new Date().getTime() - this.timestamp
    let ttl = 60
    if (ttlCustomizer.tempHost === result.host) {
      ttl = ttlCustomizer.tempTtl
    }
    this.domainDesc = result.host + `（${duration}ms）` + '\n' + `TTL：${ttl}s`
    this.ipv4Desc = result.ipv4s?.join(',') ?? ''
    this.ipv6Desc = result.ipv6s?.join(',') ?? ''
    if (this.ipv4Desc.length == 0 && this.ipv6Desc.length == 0) {
      this.isResultNull = true
    }else {
      this.isResultNull = false
    }
  }

  httpDnsResultErrorHandle(e: HttpDnsError) {
    console.error(`getHttpDnsResult error: ${e.code} ${e.message}`);
    this.isResultNull = true
  }

  //预解析域名
  serviceResolveHosts() {
    httpdns.getService(emasInfo.accountId).then((service) => {
      return service.resolveHosts([this.selectedDomain], IpType.Auto)
    }).then(() => {
      console.log('resolveHosts completed')
    }).catch((error: HttpDnsError) => {
      console.error(`resolveHosts error: ${error.code} , ${error.message}`)
    })
  }

  //清空域名缓存
  cleanHostCache() {
    httpdns.getService(emasInfo.accountId).then((service) => {
      return service.cleanHostCache([this.selectedDomain])
    }).then(() => {
      console.log('cleanHostCache completed')
    }).catch((error: HttpDnsError) => {
      console.error(`cleanHostCache error: ${error.code} , ${error.message}`)
    })
  }

  build() {
    if (this.isShowResultPage) {
      this.setupUI()
    }else {
      PreparePage({startResolveAction: (value, type) => {
        this.isShowResultPage = true
        this.resolveType = type
        this.selectedDomain = value
        this.isNeedNewResolve = false
        if (this.resolveType == ResolveType.async) {
          this.getHttpDnsResultAsync()
        } else {
          this.getHttpDnsResultSyncNonBlocking()
        }
      }}).width('100%').height('100%')
    }
  }

  @Builder setupUI() {
    RelativeContainer() {
      DomainSelectInputView({inputText: this.selectedDomain, resolveType: this.resolveType, clickAction: () => {
        const param: SearchDomainPageParam = {
          inputOnSubmit: (value) => {
            this.selectedDomain = value
            this.isNeedNewResolve = true
          },
          onSelectedDomain: (value) => {
            this.selectedDomain = value
            this.isNeedNewResolve = true
          }
        }
        this.navPathStack.pushPathByName(PageName.SEARCH_DOMAIN, param)
      }})
        .alignRules({
          top: {anchor: "__container__", align: VerticalAlign.Top},
          left: {anchor: "__container__", align: HorizontalAlign.Start}
        })
        .id('inputView')

      this.bottomViewBuilder()

      this.resultContentViewBuilder()
    }
    .padding({left: 16, right: 16, top: 60, bottom: 12})
    .backgroundColor('rgba(242,243,247,1)')
    .width('100%')
    .height('100%')
  }

  @Builder resultContentViewBuilder() {
    Column() {
      RelativeContainer() {
        Row() {
          Text('解析结果')
            .font({size: 16, weight: 500})
            .fontColor('#1F2024')
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .padding({left: 20, bottom: 18})
        .alignRules({
          top: {anchor: "__container__", align: VerticalAlign.Top},
          left: {anchor: "__container__", align: HorizontalAlign.Start},
        })
        .id('resultText')

        Scroll() {
          Column() {
            if (this.isResultNull) {
              this.resultIsNullBuilder()
            } else {
              this.resultDescBuilder()
            }
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
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .padding({top: 16, right: 4, left: 4, bottom: 4})
    .margin({top: 16, bottom: 16})
    .alignRules({
      top: {anchor: "inputView", align: VerticalAlign.Bottom},
      left: {anchor: "__container__", align: HorizontalAlign.Start},
      bottom: {anchor: "bottomView", align: VerticalAlign.Top}
    })
    .id('resultContentView')
  }

  @Builder bottomViewBuilder() {
    Column() {
      Button(this.isNeedNewResolve ? '开始解析' : '重新解析', { type: ButtonType.Normal, stateEffect: true })
        .width('100%')
        .height(48)
        .borderRadius(8)
        .backgroundImage($r('app.media.img_btn_bg'))
        .backgroundImageSize(ImageSize.FILL)
        .onClick(() => {
          this.isNeedNewResolve = false
          if (this.resolveType == ResolveType.async) {
            this.getHttpDnsResultAsync()
          } else {
            this.getHttpDnsResultSyncNonBlocking()
          }
        })

      RelativeContainer() {
        Button('预解析域名', { type: ButtonType.Normal, stateEffect: true })
          .width('50%')
          .height(48)
          .borderRadius(8)
          .backgroundColor('#EBF0FF')
          .fontColor('#4B586E')
          .onClick(() => {
            this.serviceResolveHosts()
          })
          .alignRules({
            top: {anchor: "__container__", align: VerticalAlign.Top},
            left: {anchor: "__container__", align: HorizontalAlign.Start}
          })
          .id('leftButton')

        Button('清空域名缓存', { type: ButtonType.Normal, stateEffect: true })
          .height(48)
          .borderRadius(8)
          .backgroundColor('#EBF0FF')
          .fontColor('#4B586E')
          .onClick(() => {
            this.cleanHostCache()
          })
          .alignRules({
            top: {anchor: "__container__", align: VerticalAlign.Top},
            left: {anchor: "leftButton", align: HorizontalAlign.End},
            right: {anchor: "__container__", align: HorizontalAlign.End}
          })
          .id('rightButton')
          .margin({left: 4})
      }
      .width('100%')
      .padding({top: 4})
    }
    .height(110)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .padding({top: 6, right: 4, left: 4, bottom: 4})
    .alignRules({
      bottom: {anchor: "__container__", align: VerticalAlign.Bottom},
      left: {anchor: "__container__", align: HorizontalAlign.Start}
    })
    .id('bottomView')
  }

  @Builder resultIsNullBuilder() {
    Text(`该域名返回解析结果为空。

可能原因
1.该域名不在“域名列表”中。请将该域名添加到阿里云控制台HTTPDNS的“域名列表”。

2.该域名返回解析结果为空。
         `)
      .font({size: 13, weight: 400})
      .fontColor('#98A4BA')
      .lineHeight(26)
  }

  @Builder resultDescBuilder() {
    Text(this.domainDesc)
      .font({size: 12})
      .fontColor('#3D3D3D')
      .lineHeight(24)

    if (this.ipv4Desc.length > 0) {
      Text('IPV4')
        .font({size: 12, weight: 500})
        .fontColor('#1B58F4')
        .lineHeight(24)
        .margin({top: 30, bottom: 2})

      Text(this.ipv4Desc)
        .font({size: 12})
        .fontColor('#3D3D3D')
        .lineHeight(24)
    }

    if (this.ipv6Desc.length > 0) {
      Text('IPV6')
        .font({size: 12, weight: 500})
        .fontColor('#1B58F4')
        .lineHeight(24)
        .margin({top: 60, bottom: 2})

      Text(this.ipv6Desc)
        .font({size: 12})
        .fontColor('#3D3D3D')
        .lineHeight(24)
    }
  }
}
