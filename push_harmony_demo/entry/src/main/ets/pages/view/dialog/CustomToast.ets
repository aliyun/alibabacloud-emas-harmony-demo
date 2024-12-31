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
export struct CustomToast {
  @State param: CustomToastParam = {
    msg: '',
    successFlag: true
  }
  controller?: CustomDialogController

  build() {
    Row() {
      Image(this.param.successFlag ? $r('app.media.ic_succeed') : $r('app.media.ic_fail'))
        .objectFit(ImageFit.Contain)
        .width(16)
        .height(16)
        .margin({
          right: 8
        })

      Text(this.param.msg)
        .font({
          size: 14,
          weight: 500
        })
        .fontColor('#1F2024')
    }
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Top)
    .borderRadius(8)
    .padding(16)
    .shadow({
      radius: 8,
      color: 'rgba(65, 73, 86, 0.1)',
      offsetY: 4,
      offsetX: 4,
    })
  }
}

export interface CustomToastParam {
  msg: string
  successFlag: boolean
}
