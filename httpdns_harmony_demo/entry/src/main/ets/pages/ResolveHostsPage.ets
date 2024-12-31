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

import { entryStore, SETTINGS_PRE_DOMAIN_LIST_KEY } from '../common/DataStore'
import { emasInfo } from '../common/EmasInfo'
import { HostListNavBar } from './view/HostListNavBar'
import { CustomInputDialog } from './view/CustomInputDialog'
import { httpdns, HttpDnsError, IpType } from '@aliyun/httpdns'
import { hostMatch } from '../common/Utils'
import { promptAction } from '@kit.ArkUI'

@Component
export struct ResolveHostsPage {
  @Consume('navPathStack') navPathStack: NavPathStack

  @State @Watch('didChangeHostArray') hostArray: Array<string> = entryStore.getSync(SETTINGS_PRE_DOMAIN_LIST_KEY, emasInfo.domains.slice()) as Array<string>

  @State selectedArray: Array<string> = []

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomInputDialog({
      title: '添加预解析域名',
      placeholder: '',
      inputType: InputType.Normal,
      confirm: (value) => {
        if (!hostMatch(value)) {
          promptAction.showToast({message: '请输入正确的域名', duration: 2000, bottom: 150, showMode: 1})
          return false
        }
        if (!this.hostArray.includes(value)) {
          this.hostArray.unshift(value)
          this.selectedArray.push(value)
        }
        return true
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
    width: '85%'
  })

  aboutToDisappear() {
    this.dialogController = null
  }

  didChangeHostArray() {
    entryStore.put(SETTINGS_PRE_DOMAIN_LIST_KEY, this.hostArray)
  }

  //调用SDK预解析方法
  serviceResolveHosts() {
    httpdns.getService(emasInfo.accountId).then((service) => {
      return service.resolveHosts(this.selectedArray.slice(), IpType.Auto)
    }).then(() => {
      console.log('resolveHosts completed')
      promptAction.showToast({message: '预解析成功', duration: 2000, bottom: 150})
    }).catch((error: HttpDnsError) => {
      console.error(`resolveHosts error: ${error.code} , ${error.message}`)
      promptAction.showToast({message: '预解析失败', duration: 2000, bottom: 150})
    })
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        this.navBarBuilder()
        this.bottomButtonBuilder()
        this.listViewBuilder()
      }
      .width('100%')
      .height('100%')
      .padding({top: 66, left: 16, right: 16})
    }
    .hideTitleBar(true)
  }

  @Builder navBarBuilder() {
    HostListNavBar({title: '预解析域名列表', backAction: () => {
      this.navPathStack.pop()
    }, addAction: () => {
      if (this.dialogController != null) {
        this.dialogController.open()
      }
    }})
      .width('100%')
      .height(24)
      .alignRules({
        left: {anchor: '__container__', align: HorizontalAlign.Start},
        top: {anchor: '__container__', align: VerticalAlign.Top}
      })
      .id('navBar')
  }

  @Builder bottomButtonBuilder() {
    Button('预解析域名', { type: ButtonType.Normal, stateEffect: true })
      .backgroundImage(this.selectedArray.length > 0 ? $r('app.media.img_btn_bg') : $r('app.media.img_btn_disable_bg'))
      .backgroundImageSize(ImageSize.FILL)
      .width('100%')
      .margin({top: 12, bottom: 24})
      .height(60)
      .borderRadius(8)
      .onClick(() => {
        if (this.selectedArray.length == 0) {
          return
        }
        this.serviceResolveHosts()
      })
      .alignRules({
        left: {anchor: '__container__', align: HorizontalAlign.Start},
        bottom: {anchor: '__container__', align: VerticalAlign.Bottom}
      })
      .id('button')
  }

  @Builder listViewBuilder() {
    List({space: 16, initialIndex: 0}) {
      ListItem() {
        Text('预先向HTTPDNS SDK中选择性地注册可能使用的域名，以便SDK提前解析，减少后续域名解析时请求的时延。')
          .font({size: 12, weight: FontWeight.Normal})
          .fontColor('#98A4BA')
          .margin({bottom: 24})
      }
      ForEach(this.hostArray, (item: string) => {
        ListItem() {
          Row() {
            Text(item)
              .font({size: 16, weight: FontWeight.Normal})
              .fontColor('#3D3D3D')
              .height(22)
              .margin({top: 3})

            Image(this.selectedArray.includes(item) ? $r('app.media.ic_checkmark_s') : $r('app.media.ic_checkmark'))
              .width(21)
              .height(21)
              .objectFit(ImageFit.Contain)
              .margin({top: 3, right: 5})
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Top)
          .height(48)
          .width('100%')
          .onClick(() => {
            if (this.selectedArray.includes(item)) {
              const index = this.selectedArray.indexOf(item)
              this.selectedArray.splice(index, 1)
            }else {
              this.selectedArray.push(item)
            }
          })
        }
      }, (item: string) => item)
    }
    .listDirection(Axis.Vertical)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .padding({top: 12})
    .id('list')
    .alignRules({
      left: {anchor: '__container__', align: HorizontalAlign.Start},
      top: {anchor: 'navBar', align: VerticalAlign.Bottom},
      bottom: {anchor: 'button', align: VerticalAlign.Top}
    })
  }
}
