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

import { TagInfo, TagsType } from '../common/TagInfo'
import { CustomAddTagDialog } from './view/dialog/CustomAddTagDialog'
import { CustomInputDialog, CustomInputDialogParam } from './view/dialog/CustomInputDialog'

@Component
export struct AllTagsPage {
  @Consume('navPathStack') navPathStack: NavPathStack
  private itemHeight = 36
  private itemGap = 8
  @State param: AllTagsPageParam = {
    title: '',
    type: TagsType.deviceTags,
    dataSource: [],
    account: '',
    aliasArray: [],
    didAddItem: () => {
    },
    didDeleteItem: () => {
    }
  }
  @State dataSource: TagInfo[] = []
  @State inputDialogParam: CustomInputDialogParam = {
    title: `添加别名`,
    tips: '单个别名最大长度不超过128字节',
    placeholder: '请输入别名',
    confirm: (value) => {
      if (this.param.didAddItem != undefined) {
        const item: TagInfo = {
          name: value,
          type: this.param.type
        }
        this.param.didAddItem(item)
      }
    }
  }
  addAliasDialog: CustomDialogController = new CustomDialogController({
    builder: CustomInputDialog({
      param: this.inputDialogParam
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false,
    width: '100%'
  })
  addTagDialog: CustomDialogController = new CustomDialogController({
    builder: CustomAddTagDialog({
      param: {
        entryType: this.param.type,
        selectType: this.param.type,
        aliasArray: this.param.aliasArray,
        account: this.param.account,
        confirm: (item) => {
          if (this.param.didAddItem != undefined) {
            this.param.didAddItem(item)
          }
        }
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false,
    width: '100%',
    height: '95%',
    keyboardAvoidMode: KeyboardAvoidMode.NONE
  })

  aboutToAppear(): void {
    let params = this.navPathStack.getParamByName('AllTagsPage') as AllTagsPageParam[]
    if (params.length > 0) {
      this.param = params[0]
      this.dataSource = this.param.dataSource
    }
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        this.navBarBuilder()
        this.gridBuilder()
        this.addIconBuilder()
      }
      .backgroundColor(Color.White)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }

  @Builder
  gridBuilder() {
    Grid() {
      ForEach(this.dataSource, (item: TagInfo) => {
        GridItem() {
          Row() {
            Text(item.name)
              .font({
                size: 14,
                weight: 400
              })
              .fontColor('#424FF7')
              .maxLines(1)
              .textOverflow({
                overflow: TextOverflow.Ellipsis
              })
              .constraintSize({
                maxWidth: '85%'
              })

            Image($r('app.media.ic_delete'))
              .width(12)
              .height(12)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.param.didDeleteItem != undefined) {
                  this.param.didDeleteItem(item)
                }
              })
          }
          .borderRadius(4)
          .backgroundColor('#F0F1FE')
          .width('100%')
          .height(this.itemHeight)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: 8,
            right: 8
          })
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(this.itemGap)
    .rowsGap(this.itemGap)
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(BarState.Off)
    .alignRules({
      top: {
        anchor: "navBar",
        align: VerticalAlign.Bottom
      },
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
    .margin({
      left: 16,
      right: 16
    })
  }

  @Builder
  addIconBuilder() {
    Text(this.param.type == TagsType.alias ? '添加别名' : '添加标签')
      .font({
        size: 16,
        weight: 400
      })
      .fontColor('#315CFC')
      .alignRules({
        top: {
          anchor: "navBar",
          align: VerticalAlign.Top
        },
        right: {
          anchor: "__container__",
          align: HorizontalAlign.End
        }
      })
      .margin({
        top: 20,
        right: 16
      })
      .onClick(() => {
        if (this.param.type == TagsType.alias) {
          this.addAliasDialog.open()
        } else {
          this.addTagDialog.open()
        }
      })
  }

  @Builder
  navBarBuilder() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          this.navPathStack.pop()
        })

      Text(this.param.title)
        .font({
          size: 20,
          weight: 500
        })
        .fontColor('#293138')
    }
    .justifyContent(FlexAlign.Start)
    .id('navBar')
    .alignRules({
      top: {
        anchor: "__container__",
        align: VerticalAlign.Top
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
    .height(60)
    .margin({
      top: 44,
      left: 8
    })
  }
}

export interface AllTagsPageParam {
  title: string
  type: TagsType
  dataSource: TagInfo[]
  account: string
  aliasArray: string[]
  didAddItem?: (item: TagInfo) => void
  didDeleteItem?: (item: TagInfo) => void
}

