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
export struct CustomHostResolveDialog {
  host: string = ''
  controller: CustomDialogController = new CustomDialogController({builder: CustomHostResolveDialog()})

  confirm: () => void = () => {}

  build() {
    Column() {
      Text('域名解析提醒')
        .font({size: 16, weight: 500})
        .fontColor('#1F2024')
        .margin({ top: 26})

      Column() {
        Text('在开始解析前，请将下方域名添加到阿里云控制台HTTPDNS的“域名列表”；否则无法返回解析结果。')
          .font({size: 13, weight: 400})
          .margin({top: 20})
          .lineHeight(24)
          .fontColor('#384153')

        Text(this.host)
          .font({size: 13, weight: 500})
          .margin({top: 40, bottom: 40})
          .fontColor('#3E3D46')

        Text('若已添加，则忽略此消息')
          .font({size: 13, weight: 400})
          .margin({bottom: 25})
          .fontColor('#384153')
      }
      .padding({left: 24, right: 24})
      .alignItems(HorizontalAlign.Start)

      Divider()
        .vertical(false)
        .strokeWidth(0.5)

      Button('知道了', {type: ButtonType.Normal})
        .width('100%')
        .height(44)
        .backgroundColor('#00FFFFFF')
        .fontColor('#1B58F4')
        .fontSize(16)
        .fontWeight(500)
        .onClick(() => {
          this.confirm()
          this.controller.close()
        })
    }
    .borderRadius(12)
  }
}