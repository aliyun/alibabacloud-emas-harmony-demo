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

import { AdvancedPage } from './AdvancedPage'
import { BasicPage } from './BasicPage'
import { InfoPage } from './InfoPage'
import { AllTagsPage } from './AllTagsPage'
import { CustomMessageDialog } from './view/dialog/CustomMessageDialog'
import { CustomToast } from './view/dialog/CustomToast'

let storage = LocalStorage.getShared()

@Entry(storage)
@Component
struct Index {
  @State currentIndex: number = 0
  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()
  @LocalStorageProp('pushMessage') @Watch('onReceivePushMessage') pushMessage: string = ''
  messageDialog: CustomDialogController = new CustomDialogController({
    builder: CustomMessageDialog({
      title: '下发消息内容',
      content: this.pushMessage.toString()
    }),
    alignment: DialogAlignment.Center,
    offset: {
      dx: 0,
      dy: -20
    },
    gridCount: 4,
    cornerRadius: 12,
    width: '80%'
  })
  @State registered: boolean = false

  onReceivePushMessage() {
    this.messageDialog.open()
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        Tabs({
          barPosition: BarPosition.End
        }) {
          TabContent() {
            BasicPage({
              registered: this.registered
            })
          }
          .tabBar(this.tabBuilder({
            title: '基础功能',
            targetIndex: 0,
            normalImg: $r('app.media.ic_tab_basic'),
            selectedImg: $r('app.media.ic_tab_basic_s')
          }))

          TabContent() {
            AdvancedPage({
              currentIndex: this.currentIndex
            })
          }
          .tabBar(this.tabBuilder({
            title: '高级功能',
            targetIndex: 1,
            normalImg: $r('app.media.ic_tab_ad'),
            selectedImg: $r('app.media.ic_tab_ad_s')
          }))

          TabContent() {
            InfoPage()
          }
          .tabBar(this.tabBuilder({
            title: '信息',
            targetIndex: 2,
            normalImg: $r('app.media.ic_tab_info'),
            selectedImg: $r('app.media.ic_tab_info_s')
          }))
        }
        .backgroundColor(Color.White)
        .scrollable(false)
        .animationDuration(0)
        .barMode(BarMode.Fixed)
        .barHeight(80)
        .onChange((index: number) => {
          this.currentIndex = index
        })
        .onContentWillChange(() => {
          if (this.registered) {
            return true
          }

          const toast = new CustomDialogController({
            builder: CustomToast({
              param: {
                msg: '未注册',
                successFlag: false
              }
            }),
            alignment: DialogAlignment.Center,
            customStyle: true,
            autoCancel: false,
            isModal: false
          })
          toast.open()
          setTimeout(() => {
            toast.close()
          }, 2000)
          return false
        })
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .hideTitleBar(true)
    .navBarWidth('100%')
    .navDestination(this.pageMap)
    .mode(NavigationMode.Stack)
    .hideBackButton(true)
  }

  @Builder
  tabBuilder(param: TabItemParam) {
    Column() {
      Image(this.currentIndex === param.targetIndex ? param.selectedImg : param.normalImg)
        .size({
          width: 24,
          height: 24
        })

      Text(param.title)
        .font({
          size: 12,
          weight: 500
        })
        .fontColor(this.currentIndex == param.targetIndex ? '#1B58F4' : '#ADC1D1')
        .margin({
          top: 8
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .padding({
      top: 12
    })
  }

  @Builder
  pageMap(name: string) {
    if (name == 'AllTagsPage') {
      AllTagsPage()
    }
  }
}

interface TabItemParam {
  title: string
  targetIndex: number
  normalImg: ResourceStr
  selectedImg: ResourceStr
}