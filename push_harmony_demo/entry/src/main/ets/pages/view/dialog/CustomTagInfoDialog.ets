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

@CustomDialog
@Component
export struct CustomTagInfoDialog {
  controller?: CustomDialogController
  @State flag: Visibility = Visibility.Visible

  build() {
    Column() {
      DialogTitleView({
        title: '限制说明', closeAction: () => {
          this.cancel()
        }
      })

      Text('标签（tag）')
        .font({
          size: 16,
          weight: 500
        })
        .fontColor('#4B4D52')
        .margin({
          left: 16,
          top: 25,
          bottom: 12
        })

      this.cellBuilder('App最多支持定义1万个标签，单个标签支持的最大长度为128字符。')

      this.cellBuilder('不建议在单个标签上绑定超过十万级设备，' +
        '否则，发起对该标签的推送可能需要较长的处理时间，' +
        '无法保障响应速度。此种情况下，建议您采用全推方式，' +
        '或将设备集合拆分到更细粒度的标签，' +
        '多次调用推送接口分别推送给这些标签来避免此问题。')

      Text('别名（alias）')
        .font({
          size: 16,
          weight: 500
        })
        .fontColor('#4B4D52')
        .margin({
          left: 16,
          top: 25,
          bottom: 12
        })

      this.cellBuilder('单个设备最多添加128个别名，' +
        '同一个别名最多可被添加到128个设备。')

      this.cellBuilder('别名支持的最大长度为128字节。')
    }
    .padding({
      bottom: 20
    })
    .width('100%')
    .backgroundColor(Color.White)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .visibility(this.flag)
    .transition(TransitionEffect.OPACITY.animation({
      duration: 300
    })
      .combine(TransitionEffect.translate({
        y: 500
      })))
    .borderRadius({
      topLeft: 12,
      topRight: 12
    })
  }

  cancel() {
    this.flag = Visibility.Hidden
    setTimeout(() => {
      this.controller?.close()
    }, 300)
  }

  @Builder
  cellBuilder(text: string) {
    Row() {
      Image($r('app.media.ic_dot'))
        .objectFit(ImageFit.Contain)
        .width(6)
        .height(6)
        .margin({
          top: 6
        })

      Text(text)
        .font({
          size: 14,
          weight: 400
        })
        .fontColor('#4B4D52')
        .margin({
          left: 8
        })
        .lineHeight(22)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Top)
    .padding({
      left: 24,
      right: 24,
      bottom: 8
    })
  }
}