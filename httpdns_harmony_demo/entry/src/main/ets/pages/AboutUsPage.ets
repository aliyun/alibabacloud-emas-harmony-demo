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
export struct AboutUsPage {
  @Consume('navPathStack') navPathStack: NavPathStack

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Row() {
            Image($r('app.media.ic_back'))
              .width(7)
              .height(12)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.navPathStack.pop()
              })

            Text('关于我们')
              .font({size: 20, weight: 500})
              .fontColor('#3D3D3D')
              .padding({left: 8})
          }
          .padding({left: 16, top: 66})
          .justifyContent(FlexAlign.Start)
          .width('100%')

          Row() {
            Text(' 阿里云（软件）有限公司版权所有\nCopyright @ 2009一2017 AIiyun.com\nAII Rights Reserved.')
              .font({size: 12, weight: FontWeight.Normal})
              .fontColor('#98A4BA')
              .height(96)
              .textAlign(TextAlign.Center)
          }
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Image($r('app.media.img_aboutus'))
            .width(187.5)
            .height(187.5)
            .objectFit(ImageFit.Contain)
          Text('【阿里云HTTPDNS】 Demo程序')
            .font({size: 16, weight: 500})
            .fontColor('#5F6E87')
            .margin({top: 8})
        }
        .margin({top: 203})
      }
      .width('100%')
      .height('100%')
      .alignContent(Alignment.Top)
    }
    .hideTitleBar(true)
  }
}