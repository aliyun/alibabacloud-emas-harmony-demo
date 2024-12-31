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

@CustomDialog
@Component
export struct CustomMessageDialog {
  title: string = '消息'
  content: string = ''
  controller?: CustomDialogController

  build() {
    Column() {
      Column() {
        Text(this.title)
          .font({
            size: 16,
            weight: 500
          })
          .fontColor('#1F2024')

        Text(this.content)
          .font({
            size: 14,
            weight: 400
          })
          .fontColor('#384153')
          .margin({
            top: 16
          })
      }
      .margin(24)
      .alignItems(HorizontalAlign.Center)

      Divider()
        .vertical(false)
        .strokeWidth(0.5)
        .color('#E6E8EB')

      Button('知道了', {
        type: ButtonType.Normal
      })
        .width('100%')
        .height(44)
        .backgroundColor('#00000000')
        .fontColor('#1B58F4')
        .fontSize(16)
        .fontWeight(500)
        .onClick(() => {
          if (this.controller != undefined) {
            this.controller.close()
          }
        })
    }
    .width('100%')
    .backgroundColor(Color.White)
  }
}
