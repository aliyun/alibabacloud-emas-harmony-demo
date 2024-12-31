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

import { emasInfo } from '../common/EmasInfo'
import { PageName } from '../common/PageName'
import { SearchDomainPageParam } from './SearchDomainPage'
import { CustomHostResolveDialog } from './view/CustomHostResolveDialog'
import { DomainSelectInputView, ResolveType } from './view/DomainSelectInputView'
@Preview
@Component
export struct PreparePage {

  @Consume('navPathStack') navPathStack: NavPathStack

  @State inputText: string = ''

  @State @Watch('didChangeResolveType') resolveType: ResolveType = ResolveType.unkown

  @State resolveTypeDesc: string = ''

  startResolveAction: (value: string, type: ResolveType) => void = () => {}

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomHostResolveDialog({
      host: this.inputText,
      confirm: () => {
        this.startResolveAction(this.inputText, this.resolveType)
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
    width: '85%'
  })

  aboutToDisappear() {
    this.dialogController = null
  }

  didChangeResolveType() {
    switch (this.resolveType) {
      case ResolveType.async :
        this.resolveTypeDesc = '使用异步解析接口解析域名，不会阻塞当前线程，解析结果会通过回调的形式返回。'
      break
      case ResolveType.syncNonBlocking:
        this.resolveTypeDesc = '使用同步非阻塞接口解析域名，不会阻塞当前线程，但可能会返回空结果。'
      break
      default:
        this.resolveTypeDesc = ''
    }
  }

  aboutToAppear(): void {
    this.resolveType = ResolveType.async
  }

  build() {
    RelativeContainer() {
      this.setupUI()
    }
    .backgroundColor('rgba(242,243,247,1)')
    .width('100%')
    .height('100%')
  }

  @Builder setupUI() {
    Image($r('app.media.img_homepage_bg'))
      .height(267)
      .objectFit(ImageFit.Fill)
      .alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        top: { anchor: '__container__', align: VerticalAlign.Top }
      })
      .id('headerImage')

    Column() {
      DomainSelectInputView({inputText: this.inputText, resolveType: this.resolveType, clickAction: () => {
        const param: SearchDomainPageParam = {
          inputOnSubmit: (value) => this.inputText = value,
          onSelectedDomain: (value) => this.inputText = value
        }
        this.navPathStack.pushPathByName(PageName.SEARCH_DOMAIN, param)
      }})
        .padding({ left: 16, right: 16 })

      Text(this.resolveTypeDesc)
        .padding({top: 10, left: 16, right: 16})
        .font({size: 14, weight: FontWeight.Normal})
        .fontColor('#A7BCCE')
    }
    .alignRules({
      left: {anchor: '__container__', align: HorizontalAlign.Start},
      right: {anchor: '__container__', align: HorizontalAlign.End},
      top: {anchor: 'headerImage', align: VerticalAlign.Bottom}
    })
    .id('selectInputView')
    .margin({top: 6})

    Column() {
      Button('开始解析', { type: ButtonType.Normal, stateEffect: true })
        .width('100%')
        .height(60)
        .borderRadius(8)
        .backgroundImage((this.inputText.length > 0 && this.resolveType != ResolveType.unkown) ? $r('app.media.img_btn_bg') : $r('app.media.img_btn_disable_bg'))
        .backgroundImageSize(ImageSize.FILL)
        .onClick(() => {
          if (this.inputText.length > 0 && this.resolveType != ResolveType.unkown) {
          } else {
            return
          }

          if (!emasInfo.checkExist(this.inputText)) {
            if (this.dialogController != null) {
              this.dialogController.open()
              return
            }
          }
          this.startResolveAction(this.inputText, this.resolveType)
        })
    }
    .padding({ left: 16, right: 16, bottom: 58 })
    .alignRules({
      left: {anchor: '__container__', align: HorizontalAlign.Start},
      right: {anchor: '__container__', align: HorizontalAlign.End},
      bottom: {anchor: '__container__', align: VerticalAlign.Bottom}
    })
    .id('button')
  }
}