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

import { aliyunPush, PushError } from '@aliyun/push'
import { pushService } from '@kit.PushKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { notificationManager } from '@kit.NotificationKit'
import { CustomLogLevelDialog, CustomLogLevel } from './view/dialog/CustomLogLevelDialog'
import { CustomToast } from './view/dialog/CustomToast'

@Component
export struct BasicPage {
  @LocalStorageLink('customLogLevel') logLevel: CustomLogLevel = CustomLogLevel.unknown
  logLevelDialog: CustomDialogController = new CustomDialogController({
    builder: CustomLogLevelDialog({
      level: this.logLevel,
      confirm: (level) => {
        this.logLevel = level
        this.printLog('设置日志等级成功')
      }
    }),
    alignment: DialogAlignment.Bottom,
    width: '100%',
    customStyle: true,
    autoCancel: false,
  })
  @State pushChannelStatus: boolean = false
  @Link registered: boolean

  build() {
    Scroll() {
      Column() {
        this.setupUI()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F8')
    .align(Alignment.Top)
    .edgeEffect(EdgeEffect.Fade)
    .scrollBar(BarState.Off)
  }

  @Builder
  setupUI() {
    Image($r('app.media.img_basic_header'))
      .width('100%')
      .objectFit(ImageFit.Cover)

    Column() {
      Button(this.registered ? '注册并接收推送成功' : '注册并接收推送', {
        type: ButtonType.Normal,
        stateEffect: true
      })
        .fontWeight(500)
        .fontSize(16)
        .width('100%')
        .height(56)
        .borderRadius(8)
        .radialGradient({
          center: ['50%', '50%'],
          radius: 8,
          colors: [['#4951FA', 0], ['#3D58F7', 1]]
        })
        .linearGradient({
          angle: '260deg',
          direction: GradientDirection.Right,
          colors: [['#424FF7', 0], ['#4076FA', 0.9]]
        })
        .opacity(this.registered ? 0.6 : 1)
        .onClick(() => {
          if (!this.registered) {
            this.registerPush()
          }
        })

      this.switchCellBuilder({
        title: '打开推送通道',
        subtitle: '对自有通道、厂商通道生效',
        icon: $r('app.media.ic_open'),
        isOn: this.pushChannelStatus,
        toggleOnClick: () => {
          this.pushChannelStatus = !this.pushChannelStatus
          if (this.pushChannelStatus) {
            this.turnOnPushChannel()
          }else {
            this.turnOffPushChannel()
          }
        }
      })

      RelativeContainer() {
        Button('设置日志等级', {
          type: ButtonType.Normal,
          stateEffect: true
        })
          .fontWeight(400)
          .fontSize(16)
          .fontColor('#4B4D52')
          .border({
            color: '#E6E8EB',
            width: 1,
            radius: 8
          })
          .backgroundColor(Color.White)
          .alignRules({
            top: {
              anchor: "__container__",
              align: VerticalAlign.Top
            },
            bottom: {
              anchor: "__container__",
              align: VerticalAlign.Bottom
            },
            left: {
              anchor: "__container__",
              align: HorizontalAlign.Start
            },
            right: {
              anchor: "__container__",
              align: HorizontalAlign.Center
            }
          })
          .margin({
            right: 4
          })
          .onClick(() => {
            this.logLevelDialog.open()
          })

        Button('清除自有通道通知', {
          type: ButtonType.Normal,
          stateEffect: true
        })
          .fontWeight(400)
          .fontSize(16)
          .fontColor('#4B4D52')
          .border({
            color: '#E6E8EB',
            width: 1,
            radius: 8
          })
          .backgroundColor(Color.White)
          .alignRules({
            top: {
              anchor: "__container__",
              align: VerticalAlign.Top
            },
            bottom: {
              anchor: "__container__",
              align: VerticalAlign.Bottom
            },
            left: {
              anchor: "__container__",
              align: HorizontalAlign.Center
            },
            right: {
              anchor: "__container__",
              align: HorizontalAlign.End
            }
          })
          .margin({
            left: 4
          })
          .onClick(() => {
            notificationManager.cancelAll().then(() => {
              this.printLog('清除成功')
            })
          })
      }
      .margin({
        top: 8
      })
      .width('100%')
      .height(56)
    }
    .padding({
      left: 16,
      right: 16
    })
  }

  @Builder
  switchCellBuilder($$: SwitchCellParam) {
    Column() {
      Row() {
        Row() {
          Image($$.icon)
            .width(20)
            .height(20)
            .objectFit(ImageFit.Contain)
            .margin({
              left: 16
            })

          Text($$.title)
            .fontColor('#4B4D52')
            .font({
              size: 16,
              weight: 400
            })
            .margin({
              left: 8
            })
        }

        Toggle({
          type: ToggleType.Switch,
          isOn: $$.isOn
        })
          .onClick($$.toggleOnClick)
          .size({
            width: 48,
            height: 22
          })
          .switchStyle({
            pointRadius: 11,
            unselectedColor: '#E9E9E9',
          })
          .switchPointColor($$.isOn ? '#424FF7' : '#BABCC2')
          .selectedColor('#E9E9E9')
          .margin({
            right: 16
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Text($$.subtitle)
        .font({
          size: 14,
          weight: 400
        })
        .fontColor('#A1ABB3')
        .margin({
          top: 4,
          left: 44
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .margin({
      top: 8
    })
    .padding({
      top: 16,
      bottom: 20
    })
    .backgroundColor(Color.White)
    .border({
      color: '#E6E8EB',
      width: 1,
      radius: 8
    })
  }

  registerPush() {
    //注册设备
    aliyunPush.register((error) => {
      if (error) {
        this.printLog('注册设备失败', error)
        return
      }
      const deviceId = aliyunPush.getDeviceId()
      LocalStorage.getShared().setOrCreate('deviceId', deviceId)

      console.log(`注册设备成功，设备ID：${deviceId}`)

      this.printLog('已注册')
      this.registered = true

      //注册鸿蒙系统Push token
      this.registerThirdToken()

      //检查推送通道状态
      this.checkPushChannelStatus()
    })
  }

  registerThirdToken() {
    //获取鸿蒙Push Token
    pushService.getToken().then((token) => {
      console.log(`获取鸿蒙Push Token成功，token： ${token}`)
      //注册鸿蒙系统Push token
      aliyunPush.registerThirdToken(token, (error) => {
        if (error) {
          this.printLog('注册鸿蒙Push Token失败', error)
          return;
        }
        console.log(`注册鸿蒙Push Token成功`)

        LocalStorage.getShared().setOrCreate('token', token)
      })
    }).catch((error: BusinessError) => {
      this.printLog('获取鸿蒙Push Token失败', error)
    })
  }

  checkPushChannelStatus() {
    //检查推送通道状态
    aliyunPush.checkPushChannelStatus().then((status) => {
      this.pushChannelStatus = status
    })
  }

  turnOnPushChannel() {
    aliyunPush.turnOnPushChannel((error) => {
      if (error) {
        this.pushChannelStatus = false
        this.printLog('打开推送通道失败', error)
        return
      }
      this.pushChannelStatus = true
      this.printLog('打开推送通道成功')
    })
  }

  turnOffPushChannel() {
    aliyunPush.turnOffPushChannel((error) => {
      if (error) {
        this.pushChannelStatus = true
        this.printLog('关闭推送通道失败', error)
        return
      }
      this.pushChannelStatus = false
      this.printLog('关闭推送通道成功')
    })
  }

  printLog(msg: string, err?: BusinessError | PushError) {
    if (err != undefined) {
      console.error(`${msg}: ${err}`)
    } else {
      console.log(msg)
    }

    this.showToast(msg, err == undefined)
  }

  showToast(msg: string, flag: boolean) {
    const toast = new CustomDialogController({
      builder: CustomToast({
        param: {
          msg: msg,
          successFlag: flag
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

interface SwitchCellParam {
  icon: ResourceStr
  title: string
  subtitle: string
  isOn: boolean
  toggleOnClick: () => void
}