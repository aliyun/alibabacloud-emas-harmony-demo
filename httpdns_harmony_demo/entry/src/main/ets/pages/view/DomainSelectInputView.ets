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


export enum ResolveType { unkown, syncNonBlocking, async }

@Component
export struct DomainSelectInputView {

  @Link inputText: string

  @Link resolveType: ResolveType

  clickAction: () => void = () => {}

  build() {
    Column() {
      Row() {
        Text(this.inputText.length > 0 ? this.inputText : '选择或输入需要解析的域名')
          .width('85%')
          .fontWeight(FontWeight.Normal)
          .fontColor(this.inputText.length > 0 ? '#2A313D' : '#B6C1D3')
          .fontSize(14)
          .borderRadius(4)
          .backgroundColor('#00000000')

        Image($r('app.media.ic_search'))
          .width(19)
          .height(19)
          .objectFit(ImageFit.Contain)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .border({radius: 8})
      .backgroundColor('#FFFFFF')
      .padding(20)
      .onClick(this.clickAction)

      Row() {
        SelectButton({title: '异步解析', isSelected: this.resolveType == ResolveType.async, clickAction: () => {
          this.resolveType = ResolveType.async
        }})
          .width(85)
          .height(44)

        SelectButton({title: '同步非阻塞解析', isSelected: this.resolveType == ResolveType.syncNonBlocking, clickAction: () => {
          this.resolveType = ResolveType.syncNonBlocking
        }})
          .margin({left: 10})
          .width(122)
          .height(44)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({top: 10})
    }
  }
}


@Component
struct SelectButton {

  @Prop isSelected: boolean

  title: string = ''

  clickAction: () => void = () => {}

  build() {
    Stack({alignContent: Alignment.BottomEnd}) {
      Text(this.title)
        .textAlign(TextAlign.Center)
        .width('100%')
        .height('100%')
        .font({size: 14, weight: 500})
        .fontColor( this.isSelected ? '#1B58F4' : '#A7BCCE')
        .border({radius: 8, color: this.isSelected ? '#1B58F4': '#E6E8EB', width: 1})
        .backgroundColor('#FFFFFF')
        .onClick(() => {
          this.clickAction()
        })

      if (this.isSelected) {
        Image($r('app.media.ic_checkmark_s'))
          .width(18)
          .height(18)
          .objectFit(ImageFit.Contain)
          .margin({bottom: 2, right: 2})
      }
    }
  }
}