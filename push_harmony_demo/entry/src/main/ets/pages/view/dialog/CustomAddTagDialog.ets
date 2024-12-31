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

import { TagInfo, TagsType } from "../../../common/TagInfo"
import { AliasListView } from "../AliasListView"
import { CustomToast } from "./CustomToast"
import { DialogBottomView } from "./DialogBottomView"

@CustomDialog
@Component
export struct CustomAddTagDialog {
  controller?: CustomDialogController
  @State flag: Visibility = Visibility.Visible
  navPathStack: NavPathStack = new NavPathStack()
  @State param: CustomAddTagDialogParam = {
    inputValue: '',
    entryType: TagsType.deviceTags,
    selectType: TagsType.deviceTags,
    account: '',
    aliasArray: [],
    selectAlias: '',
    confirm: () => {
    }
  }

  build() {
    Navigation(this.navPathStack) {
      RelativeContainer() {
        this.navBarBuilder()
        this.bottomBuilder()
        this.setupUI()
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height('100%')
      .borderRadius({
        topLeft: 12,
        topRight: 12
      })
      .visibility(this.flag)
      .transition(TransitionEffect.OPACITY.animation({
        duration: 300
      })
        .combine(TransitionEffect.translate({
          y: 1000
        })))
      .padding({
        bottom: 20
      })
    }
    .width('100%')
    .height('95%')
    .hideTitleBar(true)
    .navBarWidth('100%')
    .navDestination(this.pageMap)
    .mode(NavigationMode.Stack)
    .hideBackButton(true)
  }

  cancel() {
    this.flag = Visibility.Hidden
    setTimeout(() => {
      this.controller?.close()
    }, 300)
  }

  @Builder
  setupUI() {
    Column() {
      this.inputBuilder()
      this.optionBuilder()
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .alignRules({
      left: {
        anchor: "__container__",
        align: HorizontalAlign.Start
      },
      right: {
        anchor: "__container__",
        align: HorizontalAlign.End
      },
      top: {
        anchor: "title",
        align: VerticalAlign.Bottom
      },
      bottom: {
        anchor: "bottomView",
        align: VerticalAlign.Top
      },
    })
    .padding({
      left: 16,
      right: 16
    })
  }

  @Builder
  navBarBuilder() {
    Text('添加标签')
      .font({
        size: 18,
        weight: 600
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
        },
      })
      .id('title')
      .height(25)
      .margin({
        top: 20
      })

    Image($r('app.media.ic_back'))
      .width(24)
      .height(24)
      .objectFit(ImageFit.Contain)
      .onClick(() => {
        this.cancel()
      })
      .alignRules({
        center: {
          anchor: "title",
          align: VerticalAlign.Center
        },
        left: {
          anchor: "__container__",
          align: HorizontalAlign.Start
        },
      })
      .id('backImage')
      .margin({
        left: 8
      })
  }

  @Builder
  inputBuilder() {
    Text('标签名称')
      .font({
        size: 18,
        weight: 500
      })
      .fontColor('#1F2024')
      .margin({
        top: 32
      })

    TextInput({
      placeholder: '请输入标签名称'
    })
      .height(56)
      .width('100%')
      .fontWeight(400)
      .fontSize(16)
      .fontColor('#1F2024')
      .border({
        radius: 8
      })
      .placeholderColor('#999CA3')
      .backgroundColor('#F0F2F7')
      .onChange((value: string) => {
        this.param.inputValue = value
      })
      .margin({
        top: 16
      })

    Text('单个标签最大长度不超过128字符')
      .font({
        size: 14,
        weight: 400
      })
      .fontColor('#999CA3')
      .margin({
        top: 8
      })
  }

  @Builder
  cellBuilder($$: cellParam) {
    Column() {
      Row() {
        Row() {
          Image($$.select ? $r('app.media.ic_checkbox_s') :
            ($$.isEnable ? $r('app.media.ic_checkbox') : $r('app.media.ic_checkbox_dis')))
            .objectFit(ImageFit.Contain)
            .width(14)
            .height(14)

          Text($$.title)
            .font({
              size: 16,
              weight: 400
            })
            .fontColor($$.isEnable ? '#4B4D52' : '#B8BBC2')
            .margin({
              left: 12
            })
        }

        Row() {
          if ($$.subtitle != undefined) {
            Text($$.subtitle)
              .font({
                size: 14,
                weight: 400
              })
              .fontColor('#999CA3')
              .margin({
                right: 4
              })
              .maxLines(1)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .constraintSize({
                maxWidth: ($$.arrow != undefined && $$.arrow == true) ? 180 : 196
              })
          }

          if ($$.arrow != undefined &&
            $$.arrow == true) {
            Image($r('app.media.ic_arrow_right'))
              .objectFit(ImageFit.Contain)
              .width(16)
              .height(16)
          }
        }
      }
      .width('100%')
      .onClick($$.isEnable ? $$.onClick : null)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Divider()
        .vertical(false)
        .strokeWidth(0.5)
        .color('#E6E8EB')
        .margin({
          top: 16
        })
    }
    .width('100%')
    .height(52)
  }

  @Builder
  optionBuilder() {
    Text('添加至 ')
      .font({
        size: 18,
        weight: 500
      })
      .fontColor('#1F2024')
      .margin({
        top: 32,
        bottom: 32
      })

    this.cellBuilder({
      title: '设备标签',
      select: this.param.selectType == TagsType.deviceTags,
      arrow: false,
      onClick: () => {
        this.param.selectType = TagsType.deviceTags
      },
      isEnable: this.deviceTagsCellEnable()
    })

    this.cellBuilder({
      title: '别名标签',
      subtitle: this.aliasTagCellSubtitle(),
      select: this.aliasTagCellSelect(),
      arrow: true,
      onClick: () => {
        this.param.selectType = TagsType.aliasTags
        this.navPathStack.pushPathByName('AliasListView', '')
      },
      isEnable: this.aliasTagCellEnable()
    })

    this.cellBuilder({
      title: '账号标签',
      select: this.param.selectType == TagsType.accountTags,
      subtitle: this.param.account,
      onClick: () => {
        this.param.selectType = TagsType.accountTags
      },
      isEnable: this.accountTagsCellEnable()
    })
  }

  deviceTagsCellEnable(): boolean {
    if (this.param.entryType == undefined) {
      return true
    }
    return this.param.entryType == TagsType.deviceTags
  }

  aliasTagCellSubtitle(): string | undefined {
    if (this.param.entryType == undefined) {
      return this.param.selectAlias
    }

    if (this.param.entryType == TagsType.aliasTags) {
      if (this.param.selectAlias == undefined ||
        this.param.selectAlias.length == 0) {
        return '未选择别名'
      }
    }
    return this.param.selectAlias
  }

  aliasTagCellSelect(): boolean {
    if (this.param.entryType == undefined) {
      return this.param.selectType == TagsType.aliasTags &&
        (this.param.selectAlias?.length ?? 0) > 0
    }
    return this.param.selectType == TagsType.aliasTags
  }

  aliasTagCellEnable(): boolean {
    if (this.param.entryType == undefined) {
      return this.param.aliasArray.length > 0
    }
    return this.param.entryType == TagsType.aliasTags
  }

  accountTagsCellEnable(): boolean {
    if (this.param.entryType == undefined) {
      return this.param.account.length > 0
    }
    return this.param.entryType == TagsType.accountTags
  }

  checkParam(): string | undefined {
    if (this.param.inputValue == undefined ||
      this.param.inputValue.length == 0) {
      return '请输入标签名称'
    }

    if (this.param.selectType == undefined) {
      return '请选择标签类型'
    }

    if (this.param.selectType == TagsType.aliasTags) {
      if (this.param.selectAlias == undefined ||
        this.param.selectAlias.length == 0) {
        return '请选择别名'
      }
    }
    return undefined
  }

  @Builder
  bottomBuilder() {
    DialogBottomView({
      leftAction: () => {
        this.cancel()
      },
      rightAction: () => {
        const msg = this.checkParam()
        if (msg != undefined) {
          this.showToast(msg)
          return
        }

        if (this.param.confirm != undefined) {
          const item: TagInfo = {
            name: this.param.inputValue ?? '',
            type: this.param.selectType ?? TagsType.deviceTags,
            alias: this.param.selectAlias
          }
          this.param.confirm(item)
        }

        this.cancel()
      }
    })
      .id('bottomView')
      .alignRules({
        left: {
          anchor: "__container__",
          align: HorizontalAlign.Start
        },
        right: {
          anchor: "__container__",
          align: HorizontalAlign.End
        },
        bottom: {
          anchor: "__container__",
          align: VerticalAlign.Bottom
        }
      })
  }

  @Builder
  pageMap(name: string) {
    if (name == 'AliasListView') {
      AliasListView({
        aliasArray: this.param.aliasArray, onSelect: (value) => {
          this.param.selectAlias = value
        }
      })
    }
  }

  showToast(msg: string) {
    const toast = new CustomDialogController({
      builder: CustomToast({
        param: {
          msg: msg,
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
  }
}

export interface CustomAddTagDialogParam {
  inputValue?: string
  entryType?: TagsType
  selectType?: TagsType
  account: string
  aliasArray: string[]
  selectAlias?: string
  confirm?: (item: TagInfo) => void
}

interface cellParam {
  select: boolean
  onClick: () => void
  title: string
  subtitle?: string
  arrow?: boolean
  isEnable: boolean
}