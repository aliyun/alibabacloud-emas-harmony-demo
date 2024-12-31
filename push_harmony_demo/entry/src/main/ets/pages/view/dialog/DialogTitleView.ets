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

@Component
export struct DialogTitleView {
  @Prop title: string
  closeAction: () => void = () => {
  }

  build() {
    RelativeContainer() {
      Text(this.title)
        .font({
          size: 18,
          weight: 500
        })
        .fontColor('#4B4D52')
        .alignRules({
          top: {
            anchor: "__container__",
            align: VerticalAlign.Top
          },
          middle: {
            anchor: "__container__",
            align: HorizontalAlign.Center
          }
        })
        .id('title')

      Image($r('app.media.ic_close'))
        .objectFit(ImageFit.Contain)
        .width(18)
        .height(18)
        .alignRules({
          center: {
            anchor: "title",
            align: VerticalAlign.Center
          },
          right: {
            anchor: "__container__",
            align: HorizontalAlign.End
          }
        })
        .onClick(this.closeAction)
    }
    .width('100%')
    .height(56)
    .padding({
      left: 16,
      right: 16,
      top: 20,
      bottom: 14
    })
  }
}