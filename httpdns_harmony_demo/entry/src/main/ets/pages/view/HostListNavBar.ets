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
export struct HostListNavBar {

  @Prop title: string
  backAction: () => void = () => {}
  addAction: () => void = () => {}

  build() {
    Flex({direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween}) {
      Row() {
        Image($r('app.media.ic_back'))
          .width(7)
          .height(12)
          .objectFit(ImageFit.Contain)
          .onClick(this.backAction)

        Text(this.title)
          .font({size: 20, weight: 500})
          .fontColor('#3D3D3D')
          .padding({left: 8})
      }.justifyContent(FlexAlign.Start)

      Image($r('app.media.ic_add_circle'))
        .width(21)
        .height(21)
        .objectFit(ImageFit.Contain)
        .onClick(this.addAction)
    }
  }
}