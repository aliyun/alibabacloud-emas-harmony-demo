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
import { window } from '@kit.ArkUI'
import { CustomToast } from './CustomToast'

@CustomDialog
@Component
export struct CustomInputDialog {
  @Link param: CustomInputDialogParam
  controller?: CustomDialogController
  @State flag: Visibility = Visibility.Visible
  @State keyboardH: number = 0

  aboutToAppear() {
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', height => {
        this.keyboardH = height
      })
    })
  }

  aboutToDisappear(): void {
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.off('keyboardHeightChange')
    })
  }

  build() {
    Column() {
      DialogTitleView({
        title: this.param.title, closeAction: () => {
          this.cancel()
        }
      })

      Column() {
        TextInput({
          placeholder: this.param.placeholder ?? '',
          text: this.param.inputValue ?? ''
        })
          .inputStyle()
          .type(this.param.inputType ?? InputType.Normal)
          .onChange((value: string) => {
            this.param.inputValue = value
          })
          .backgroundColor((this.param.textInputEnabled ?? true) ? Color.White : '#E6E8EB')
          .maxLength(this.param.maxLength ?? Number.MAX_SAFE_INTEGER)
          .enabled(this.param.textInputEnabled ?? true)

        if (this.param.tips?.length ?? 0 > 0) {
          Text(this.param.tips)
            .font({
              size: 14,
              weight: 400
            })
            .fontColor('#999CA3')
            .margin({
              top: 8
            })
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 16,
        right: 16
      })
      .margin({
        top: 10,
        bottom: 90
      })

      DialogBottomView({
        leftTitle: this.param.leftBtnTitle ?? '取消',
        leftAction: () => {
          if (this.param.leftBtnOnClick != undefined
            && this.param.leftBtnOnClick()) {
            return
          }
          this.cancel()
        },
        rightAction: () => {
          if (this.param.inputValue == undefined ||
            this.param.inputValue.length == 0) {
            this.showToast(this.param.placeholder ?? '请输入内容')
            return
          }

          if (this.param.confirm != undefined) {
            this.param.confirm(this.param.inputValue ?? '')
          }

          this.cancel()
        }
      })
    }
    .padding({
      bottom: this.keyboardH > 0 ? 16 : 32
    })
    .margin({
      bottom: -16
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
    .width('100%')
    .backgroundColor(Color.White)
  }

  cancel() {
    this.flag = Visibility.Hidden
    setTimeout(() => {
      this.controller?.close()
    }, 300)
  }

  showToast(msg: string) {
    const toast = new CustomDialogController({
      builder: CustomToast({
        param: {
          msg: msg,
          successFlag: false
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

@Extend(TextInput)
function inputStyle() {
  .height(56)
  .width('100%')
  .fontWeight(400)
  .fontSize(16)
  .fontColor('#4B4D52')
  .border({
    width: 1,
    color: '#E6E8EB',
    radius: 8
  })
  .placeholderColor('#999CA3')
}

export interface CustomInputDialogParam {
  title: string
  tips?: string
  placeholder?: string
  inputValue?: string
  inputType?: InputType
  confirm?: (value: string) => void
  leftBtnTitle?: string
  leftBtnOnClick?: () => boolean
  textInputEnabled?: boolean
  maxLength?: number
}