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

import { DialogTitleView } from './DialogTitleView'
import { DialogBottomView } from './DialogBottomView'
import hilog from '@ohos.hilog';

@CustomDialog
@Component
export struct CustomLogLevelDialog {
  @State level: CustomLogLevel = CustomLogLevel.unknown
  controller?: CustomDialogController
  confirm: (value: CustomLogLevel) => void = (value) => {
  }
  @State flag: Visibility = Visibility.Visible

  build() {
    Column() {
      DialogTitleView({
        title: '设置日志等级', closeAction: () => {
          this.cancel()
        }
      })

      this.cellBuilder({
        title: 'Error',
        select: this.level == CustomLogLevel.error,
        onChange: () => {
          this.level = CustomLogLevel.error
        }
      })

      this.cellBuilder({
        title: 'Info',
        select: this.level == CustomLogLevel.info,
        onChange: () => {
          this.level = CustomLogLevel.info
        }
      })

      this.cellBuilder({
        title: 'Debug',
        select: this.level == CustomLogLevel.debug,
        onChange: () => {
          this.level = CustomLogLevel.debug
        }
      })

      this.cellBuilder({
        title: '关闭日志',
        select: this.level == CustomLogLevel.close,
        onChange: () => {
          this.level = CustomLogLevel.close
        },
        hideLine: true
      })

      DialogBottomView({
        leftAction: () => {
          this.cancel()
        },
        rightAction: () => {
          this.confirm(this.level)
          this.cancel()
        }
      })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .padding({
      bottom: 20
    })
    .borderRadius({
      topLeft: 12,
      topRight: 12
    })
    .visibility(this.flag)
    .transition(TransitionEffect.OPACITY.animation({
      duration: 300
    })
      .combine(TransitionEffect.translate({
        y: 500
      })))
  }

  cancel() {
    this.flag = Visibility.Hidden
    setTimeout(() => {
      this.controller?.close()
    }, 300)
  }

  @Builder
  cellBuilder($$: cellParam) {
    Column() {
      Row() {
        Image($$.select ? $r('app.media.ic_checkbox_s') : $r('app.media.ic_checkbox'))
          .objectFit(ImageFit.Contain)
          .width(14)
          .height(14)

        Text($$.title)
          .font({
            size: 16,
            weight: 400
          })
          .fontColor('#4B4D52')
          .margin({
            left: 12
          })
      }
      .width('100%')
      .onClick($$.onChange)

      if (!$$.hideLine) {
        Divider()
          .vertical(false)
          .strokeWidth(0.5)
          .color('#E6E8EB')
          .margin({
            top: 16
          })
      }
    }
    .width('100%')
    .height(52)
    .padding({
      left: 16,
      right: 16
    })
  }
}

export enum CustomLogLevel {
  unknown = -1,
  close = 0,
  error = hilog.LogLevel.ERROR,
  info = hilog.LogLevel.INFO,
  debug = hilog.LogLevel.DEBUG,
}

interface cellParam {
  select: boolean
  onChange: () => void
  title: string
  hideLine?: boolean
}