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
export struct DialogBottomView {
  @Prop leftTitle: string = '取消'
  rightTitle: string = '确定'
  leftAction: () => void = () => {
  }
  rightAction: () => void = () => {
  }

  build() {
    RelativeContainer() {
      Button(this.leftTitle, {
        type: ButtonType.Normal,
        stateEffect: true
      })
        .fontWeight(500)
        .fontSize(16)
        .fontColor('#4B586E')
        .borderRadius(8)
        .backgroundColor('#EBF0FF')
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
          left: 16,
          right: 4
        })
        .onClick(this.leftAction)

      Button(this.rightTitle, {
        type: ButtonType.Normal,
        stateEffect: true
      })
        .fontWeight(500)
        .fontSize(16)
        .fontColor(Color.White)
        .borderRadius(8)
        .radialGradient({
          center: ['50%', '50%'],
          radius: 8,
          colors: [['#4951FA', 0], ['#3D58F7', 1]]
        })
        .linearGradient({
          angle: '251deg',
          direction: GradientDirection.Right,
          colors: [['#424FF7', 0], ['#4076FA', 0.91]]
        })
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
          left: 4,
          right: 16
        })
        .onClick(this.rightAction)
    }
    .width('100%')
    .height(52)
    .margin({
      bottom: 10
    })
  }
}