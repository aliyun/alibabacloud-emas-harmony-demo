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

import { HISTORY_INPUT_DOMAIN_LIST_KEY, entryStore } from '../common/DataStore'
import { hostMatch } from '../common/Utils'
import { PageName } from '../common/PageName'
import { promptAction, window } from '@kit.ArkUI'
import { emasInfo } from '../common/EmasInfo'

export interface SearchDomainPageParam {
  inputOnChange?: (value: string) => void
  inputOnSubmit?: (value: string) => void
  onSelectedDomain?: (value: string) => void
}

@Component
export struct SearchDomainPage {
  @Consume('navPathStack') navPathStack: NavPathStack

  @State screenHeight: number = 0

  @State inputText: string = ''

  //域名输入历史
  @State @Watch('didChangeHistoryDomainList') historyInputDomainList: Array<string> = entryStore.getSync(HISTORY_INPUT_DOMAIN_LIST_KEY, []) as Array<string>

  //输入历史匹配域名列表
  @State historyMatchList: string[] = this.historyInputDomainList.slice()

  //控制台域名匹配列表
  @State domainsMatchList: string[] = emasInfo.domains.slice()

  param?: SearchDomainPageParam

  inputMatchClosure: (item: string) => boolean = (item: string) => {
    const reg: RegExp = new RegExp(this.inputText)
    const matchArr = item.match(reg)
    return matchArr !== null && matchArr.length > 0
  }

  didChangeHistoryDomainList() {
    entryStore.put(HISTORY_INPUT_DOMAIN_LIST_KEY, this.historyInputDomainList)
  }

  aboutToAppear(): void {
    window.getLastWindow(getContext(this)).then((win) => {
      //获取键盘高度
      let property = win.getWindowProperties()
      let avoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_KEYBOARD)
      this.screenHeight = px2vp(property.windowRect.height - avoidArea.bottomRect.height)
      //监听键盘弹出、收起
      win.on('avoidAreaChange', async options => {
        if (options.type === window.AvoidAreaType.TYPE_KEYBOARD) {
          this.screenHeight = px2vp(property.windowRect.height - options.area.bottomRect.height)
        }
      })
    })

    let params = this.navPathStack.getParamByName(PageName.SEARCH_DOMAIN) as SearchDomainPageParam[]
    if (params.length > 0) {
      this.param = params[0]
    }
  }


  build() {
    NavDestination() {
      RelativeContainer() {
        this.searchBarBuilder()
        this.retrievalContentBuilder()
      }
      .width('100%')
      .height(this.screenHeight)
      .padding({left: 16, right: 16})
    }
    .hideTitleBar(true)
  }

  @Builder searchBarBuilder() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(7)
        .height(12)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          this.navPathStack.pop()
        })

      Column() {
        TextInput({ placeholder: '选择或输入需要解析的域名', text: $$this.inputText})
          .fontWeight(FontWeight.Normal)
          .placeholderColor('#B6C1D3')
          .placeholderFont({size: 14})
          .fontColor('#3E3D46')
          .fontSize(14)
          .backgroundColor('#F4F5F9')
          .enterKeyType(EnterKeyType.Done)
          .cancelButton({style: CancelButtonStyle.INPUT, icon: {src: $r('app.media.ic_input_text_cancel'), size: 21}})
          .onChange((value) => {
            if (value.length > 0) {
              this.historyMatchList = this.historyInputDomainList.filter((item) => this.inputMatchClosure(item))
              this.domainsMatchList = emasInfo.domains.filter((item) => this.inputMatchClosure(item))
            }else {
              this.historyMatchList = this.historyInputDomainList.slice()
              this.domainsMatchList = emasInfo.domains.slice()
            }

            if (this.param?.inputOnChange != undefined) {
              this.param.inputOnChange(value)
            }
          })
          .onSubmit(() => {
            if (!hostMatch(this.inputText)) {
              promptAction.showToast({message: '请输入正确的域名', duration: 2000, bottom: 150, showMode: 1})
              return
            }
            //加入输入历史列表
            if (this.historyInputDomainList.includes(this.inputText)) {
              const index = this.historyInputDomainList.indexOf(this.inputText)
              this.historyInputDomainList.splice(index, 1)
            }
            this.historyInputDomainList.unshift(this.inputText)

            if (this.param?.inputOnSubmit != undefined) {
              this.param.inputOnSubmit(this.inputText)
            }

            this.navPathStack.pop()
          })
      }
      .margin({left: 16})
      .padding({left: 20, right: 10, top: 10, bottom: 10})
      .backgroundColor('#F4F5F9')
      .borderRadius(8)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .margin({top: 60})
    .id('searchBar')
    .alignRules({
      left: {anchor: '__container__', align: HorizontalAlign.Start},
      top: {anchor: '__container__', align: VerticalAlign.Top},
    })
  }

  @Builder retrievalContentBuilder() {
    Scroll() {
      Column() {
        if (this.historyMatchList.length > 0) {
          this.historyMatchListViewBuilder()
        }
        if (this.domainsMatchList.length > 0) {
          this.domainsMatchListViewBuilder()
        }
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .width('100%')
    }
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(BarState.Off)
    .margin({top: 16, bottom: 16})
    .alignRules({
      left: {anchor: '__container__', align: HorizontalAlign.Start},
      top: {anchor: 'searchBar', align: VerticalAlign.Bottom},
      bottom: {anchor: '__container__', align: VerticalAlign.Bottom}
    })
    .id('scroll')
    .align(Alignment.Top)
  }

  @Builder historyMatchListViewBuilder() {
    Row() {
      Text('输入历史')
        .font({size: 16, weight: 500})
        .fontColor('#1F2024')

      Text('清空全部')
        .font({size: 16, weight: FontWeight.Normal})
        .fontColor('#B6C1D3')
        .onClick(() => {
          this.historyInputDomainList.splice(0, this.historyInputDomainList.length)
          this.historyMatchList.splice(0, this.historyMatchList.length)
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({top: 10, bottom: 10})

    ForEach(this.historyMatchList, (item: string) => {
      Row() {
        Text(item)
          .font({size: 16, weight: FontWeight.Normal})
          .fontColor('#384153')

        Image( $r('app.media.ic_host_delete'))
          .width(10).height(10)
          .objectFit(ImageFit.Contain)
          .margin({ right: 12})
          .onClick(() => {
            const index = this.historyMatchList.indexOf(item)
            this.historyMatchList.splice(index, 1)

            if (this.historyInputDomainList.includes(item)) {
              const idx = this.historyInputDomainList.indexOf(item)
              this.historyInputDomainList.splice(idx, 1)
            }
          })
      }
      .width('100%')
      .padding({top: 10, bottom: 10})
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        this.inputText = item
        if (this.param?.onSelectedDomain != undefined) {
          this.param?.onSelectedDomain(item)
        }
        this.navPathStack.pop()
      })
    }, (item: string) => item)
  }

  @Builder domainsMatchListViewBuilder() {
    Divider()
      .strokeWidth(0.5)
      .vertical(false)
      .margin({top: 8, bottom: 8})

    Row() {
      Text('控制台域名列表')
        .font({size: 16, weight: 500})
        .fontColor('#1F2024')
    }
    .width('100%')
    .padding({top: 10, bottom: 10})
    .justifyContent(FlexAlign.Start)

    ForEach(this.domainsMatchList, (item: string) => {
      Row() {
        Text(item)
          .font({size: 16, weight: FontWeight.Normal})
          .fontColor('#384153')
      }
      .width('100%')
      .padding({top: 10, bottom: 10})
      .justifyContent(FlexAlign.Start)
      .onClick(() => {
        this.inputText = item
        if (this.param?.onSelectedDomain != undefined) {
          this.param?.onSelectedDomain(item)
        }
        this.navPathStack.pop()
      })
    }, (item: string) => item)
  }
}