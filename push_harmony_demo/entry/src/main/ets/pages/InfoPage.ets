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

import { common } from '@kit.AbilityKit'
import { AppKey, AppSecret } from '../common/Constants'
import { aliyunPush } from '@aliyun/push'
import { pasteboard } from '@kit.BasicServicesKit'
import { CustomToast } from './view/dialog/CustomToast'

@Component
export struct InfoPage {
  private context = getContext(this) as common.UIAbilityContext
  @LocalStorageProp('deviceId') deviceId: string = ''
  @LocalStorageProp('token') token: string = ''

  build() {
    Scroll() {
      Column() {
        this.setupUI()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .align(Alignment.Top)
    .edgeEffect(EdgeEffect.Fade)
    .scrollBar(BarState.Off)
  }

  @Builder
  setupUI() {
    Stack({
      alignContent: Alignment.TopStart
    }) {
      this.headerViewBuilder()

      Column() {
        this.cellBuilder({
          title: 'AppKey',
          value: AppKey
        })

        this.cellBuilder({
          title: 'AppSecret',
          value: AppSecret
        })

        this.cellBuilder({
          title: '设备ID',
          value: this.deviceId.length > 0 ? this.deviceId : '-',
          isCanCopy: this.deviceId.length > 0
        })


        this.cellBuilder({
          title: '推送SDK版本号',
          value: `v${aliyunPush.getSDKVersion()}`
        })

        Divider()
          .vertical(false)
          .strokeWidth(0.5)
          .color('#E6E8EB')
          .margin({
            bottom: 20
          })

        this.cellBuilder({
          title: 'Token',
          value: this.token.length > 0 ? this.token : '-',
          isCanCopy: this.token.length > 0
        })
      }
      .width('100%')
      .borderRadius({
        topLeft: 20,
        topRight: 20
      })
      .padding({
        top: 21,
        left: 16,
        right: 16
      })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .margin({
        top: 152
      })
      .backgroundColor(Color.White)
    }
    .width('100%')
  }

  @Builder
  cellBuilder($$: cellParam) {
    Column() {
      Text($$.title)
        .font({
          size: 16,
          weight: 500
        })
        .fontColor('#4B4D52')
        .height(24)

      Row() {
        Text($$.value)
          .font({
            size: 16,
            weight: 400
          })
          .fontColor('#999CA3')
          .constraintSize({ maxWidth: '95%' })

        if ($$.isCanCopy === true) {
          Image($r('app.media.ic_copy'))
            .width(16)
            .height(16)
            .margin({
              left: 4
            })
            .onClick(() => {
              const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, $$.value)
              pasteboard.getSystemPasteboard().setData(pasteData, (err) => {
                if (err) {
                  this.showToast('复制失败')
                  console.error(`pasteboard setData error: ${err}`)
                  return;
                }
                this.showToast('已复制')
              })
            })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .margin({
        top: 8
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .margin({
      bottom: 23
    })
  }

  @Builder
  headerViewBuilder() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.img_info_bg'))
        .width('100%')
        .height(240)
        .objectFit(ImageFit.Fill)

      Row() {
        Image($r('app.media.ic_emas_logo'))
          .width(45)
          .height(45)
          .objectFit(ImageFit.Contain)

        Column() {
          Text('阿里云推送Demo')
            .font({
              size: 20,
              weight: 500
            })
            .fontColor('#1F2024')

          Text(this.context.abilityInfo.bundleName)
            .font({
              size: 16,
              weight: 400
            })
            .fontColor('#999CA3')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: 12
        })
      }
      .margin({
        top: 78,
        left: 16
      })
    }
  }

  showToast(msg: string) {
    const toast = new CustomDialogController({
      builder: CustomToast({
        param: {
          msg: msg,
          successFlag: true
        }
      }),
      alignment: DialogAlignment.Center,
      customStyle: true,
      autoCancel: false,
      isModal: false
    })

    toast.open()

    setTimeout(() => {
      toast.close()
    }, 2000)
  }
}

interface cellParam {
  title: string
  value: string
  isCanCopy?: boolean
}