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

import { TagInfo, TagsType } from "../../common/TagInfo"
import { AllTagsPageParam } from "../AllTagsPage"
import { AliasSection } from "./AliasSection"
import { CustomAddTagDialog } from "./dialog/CustomAddTagDialog"
import { CustomInputDialog, CustomInputDialogParam } from "./dialog/CustomInputDialog"
import { CustomTagInfoDialog } from "./dialog/CustomTagInfoDialog"
import { TagsSection } from "./TagsSection"

@Component
export struct AdvancedView {
  @Consume('navPathStack') navPathStack: NavPathStack
  scroller: Scroller = new Scroller()
  @Link deviceTags: TagInfo[]
  @Link alias: TagInfo[]
  @Link aliasTags: TagInfo[]
  @Link @Watch('didChangeAccount') account: string
  @Link accountTags: TagInfo[]
  @Link @Watch('didChangePhoneNum') phoneNum: string
  explainDialog: CustomDialogController = new CustomDialogController({
    builder: CustomTagInfoDialog(),
    alignment: DialogAlignment.Bottom,
    width: '100%',
    customStyle: true,
    autoCancel: false
  })
  @State inputDialogParam: CustomInputDialogParam = {
    title: '',
    tips: '',
    placeholder: '',
    inputValue: '',
    inputType: InputType.Normal,
    confirm: () => {
    },
    leftBtnTitle: '',
    leftBtnOnClick: () => {
      return false
    },
    textInputEnabled: true
  }
  inputDialog: CustomDialogController = new CustomDialogController({
    builder: CustomInputDialog({
      param: this.inputDialogParam,
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    autoCancel: false,
    width: '100%'
  })
  addTagDialog: CustomDialogController = new CustomDialogController({
    builder: CustomAddTagDialog({
      param: {
        aliasArray: this.alias.map((item) => item.name),
        account: this.account,
        confirm: (item) => {
          this.actions.addItemCallback(item)
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
  actions: AdvancedActions = {
    addItemCallback: () => {
    },
    deleteItemCallback: () => {
    },
    bindAccountCallback: () => {
    },
    unbindAccountCallback: () => {
    },
    bindPhoneNumberCallback: () => {
    },
    unbindPhoneNumberCallback: () => {
    }
  }

  configAliasInputDialogParam() {
    this.inputDialogParam = {
      title: '添加别名',
      tips: '单个别名最大长度不超过128字节',
      placeholder: '请输入别名名称',
      confirm: (value) => {
        const item: TagInfo = {
          name: value,
          type: TagsType.alias
        }
        this.actions.addItemCallback(item)
      }
    }
  }

  configAccountInputDialogParam() {
    this.inputDialogParam = {
      title: '绑定账号',
      placeholder: '请输入账号',
      inputValue: this.account,
      textInputEnabled: this.account.length == 0,
      leftBtnTitle: this.account.length > 0 ? '解除绑定' : '取消',
      leftBtnOnClick: () => {
        if (this.account.length > 0) {
          this.actions.unbindAccountCallback()
          return true
        }
        return false
      },
      confirm: (value) => {
        this.actions.bindAccountCallback(value)
      }
    }
  }

  configPhoneNumInputDialogParam() {
    this.inputDialogParam = {
      title: '短信通知',
      placeholder: '请输入手机号',
      inputValue: this.phoneNum,
      inputType: InputType.Number,
      textInputEnabled: this.phoneNum.length == 0,
      maxLength: 11,
      leftBtnTitle: this.phoneNum.length > 0 ? '解除绑定' : '取消',
      leftBtnOnClick: () => {
        if (this.phoneNum.length > 0) {
          this.actions.unbindPhoneNumberCallback()
          return true
        }
        return false
      },
      confirm: (value) => {
        this.actions.bindPhoneNumberCallback(value)
      }
    }
  }

  didChangeAccount() {
    if (this.account.length == 0) {
      this.configAccountInputDialogParam()
    }
  }

  didChangePhoneNum() {
    if (this.phoneNum.length == 0) {
      this.configPhoneNumInputDialogParam()
    }
  }

  build() {
    Scroll(this.scroller) {
      this.setupUI()
    }
    .edgeEffect(EdgeEffect.Fade)
    .scrollBar(BarState.Off)
    .align(Alignment.Top)
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F8')
  }

  @Builder
  setupUI() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Image($r('app.media.img_advanced_header_bg'))
          .objectFit(ImageFit.Cover)

        Image($r('app.media.img_advanced_header'))
          .objectFit(ImageFit.Cover)
      }
      .width('100%')

      Column() {
        Row() {
          Image($r('app.media.ic_advanced_info'))
            .objectFit(ImageFit.Contain)
            .width(14)
            .height(14)

          Text('设备标签和别名数量限制说明')
            .font({
              size: 14,
              weight: 400
            })
            .fontColor('#315CFC')
            .margin({
              left: 3
            })
        }
        .margin({
          bottom: 10
        })
        .onClick(() => {
          this.explainDialog.open()
        })

        Column() {
          this.tagsSettingBuilder()
        }
        .width('100%')
        .backgroundColor(Color.White)
        .border({
          color: '#E6E8EB',
          width: 1,
          radius: 8
        })
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)

        Column() {
          this.aliasSettingBuilder()
        }
        .width('100%')
        .backgroundColor(Color.White)
        .border({
          color: '#E6E8EB',
          width: 1,
          radius: 8
        })
        .margin({
          top: 8
        })
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)

        this.accountSettingBuilder()
        this.phoneNumberSettingBuilder()
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 16,
        right: 16
      })
    }
  }

  @Builder
  tagsSettingBuilder() {
    if (this.deviceTags.length > 0 ||
      this.aliasTags.length > 0 ||
      this.accountTags.length > 0) {
      Row() {
        Text('标签')
          .font({
            size: 16,
            weight: 500
          })
          .fontColor('#31383E')

        Row() {
          Text('添加标签')
            .font({
              size: 14,
              weight: 400
            })
            .fontColor('#315CFC')

          Image($r('app.media.ic_add_blue'))
            .width(8)
            .height(8)
            .objectFit(ImageFit.Contain)
            .margin({ left: 3 })
        }
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          this.addTagDialog.open()
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({
        left: 16,
        right: 16,
        top: 16,
        bottom: 8
      })

      if (this.deviceTags.length > 0) {
        this.deviceTagsBuilder()
      }

      if (this.aliasTags.length > 0) {
        this.aliasTagsSettingBuilder()
      }

      if (this.accountTags.length > 0) {
        this.accountTagsSettingBuilder()
      }
    } else {
      Text('标签设置')
        .font({
          size: 16,
          weight: 500
        })
        .fontColor('#31383E')
        .padding({
          left: 16,
          top: 16
        })

      this.addItemBuilder('添加标签', () => {
        this.addTagDialog.open()
      })
    }
  }

  @Builder
  addItemBuilder(title: string, onClick: () => void) {
    Row() {
      Text(title)
        .font({
          size: 14,
          weight: 400
        })
        .fontColor('#4B4D52')

      Image($r('app.media.ic_add'))
        .width(16)
        .height(16)
        .objectFit(ImageFit.Contain)
    }
    .borderRadius(4)
    .backgroundColor('#EFF1F6')
    .width(96)
    .height(36)
    .onClick(() => {
      onClick()
    })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .margin({
      left: 16,
      top: 16,
      bottom: 20
    })
  }

  @Builder
  deviceTagsBuilder() {
    TagsSection({
      title: '设备标签',
      dataSources: this.deviceTags,
      onClickShowAll: () => {
        const param: AllTagsPageParam = {
          account: this.account,
          aliasArray: this.alias.map((value) => value.name),
          dataSource: this.deviceTags,
          title: '设备标签',
          type: TagsType.deviceTags,
          didAddItem: (item) => {
            this.actions.addItemCallback(item)
          },
          didDeleteItem: (item) => {
            this.actions.deleteItemCallback(item)
          }
        }
        this.navPathStack.pushPathByName('AllTagsPage', param)
      },
      onClickDeleteItem: (item) => {
        this.actions.deleteItemCallback(item)
      }
    })
  }

  @Builder
  aliasTagsSettingBuilder() {
    Divider()
      .vertical(false)
      .strokeWidth(0.5)
      .color('#E6E8EB')
      .margin({
        left: 16,
        right: 16
      })

    TagsSection({
      title: '别名标签',
      dataSources: this.aliasTags,
      onClickShowAll: () => {
        const param: AllTagsPageParam = {
          account: this.account,
          aliasArray: this.alias.map((value) => value.name),
          dataSource: this.aliasTags,
          title: '别名标签',
          type: TagsType.aliasTags,
          didAddItem: (item) => {
            this.actions.addItemCallback(item)
          },
          didDeleteItem: (item) => {
            this.actions.deleteItemCallback(item)
          }
        }
        this.navPathStack.pushPathByName('AllTagsPage', param)
      },
      onClickDeleteItem: (item) => {
        this.actions.deleteItemCallback(item)
      }
    })
  }

  @Builder
  accountTagsSettingBuilder() {
    Divider()
      .vertical(false)
      .strokeWidth(0.5)
      .color('#E6E8EB')
      .margin({
        left: 16,
        right: 16
      })

    TagsSection({
      title: '账号标签',
      dataSources: this.accountTags,
      onClickShowAll: () => {
        const param: AllTagsPageParam = {
          account: this.account,
          aliasArray: this.alias.map((value) => value.name),
          dataSource: this.accountTags,
          title: '账号标签',
          type: TagsType.accountTags,
          didAddItem: (item) => {
            this.actions.addItemCallback(item)
          },
          didDeleteItem: (item) => {
            this.actions.deleteItemCallback(item)
          }
        }
        this.navPathStack.pushPathByName('AllTagsPage', param)
      },
      onClickDeleteItem: (item) => {
        this.actions.deleteItemCallback(item)
      }
    })
  }

  @Builder
  aliasSettingBuilder() {
    if (this.alias.length > 0) {
      AliasSection({
        title: '别名设置',
        dataSources: this.alias,
        onClickShowAll: () => {
          const param: AllTagsPageParam = {
            account: this.account,
            aliasArray: this.alias.map((value) => value.name),
            dataSource: this.alias,
            title: '别名',
            type: TagsType.alias,
            didAddItem: (item) => {
              this.actions.addItemCallback(item)
            },
            didDeleteItem: (item) => {
              this.actions.deleteItemCallback(item)
            }
          }
          this.navPathStack.pushPathByName('AllTagsPage', param)
        },
        onClickAddItem: () => {
          this.configAliasInputDialogParam()
          this.inputDialog.open()
        },
        onClickDeleteItem: (alias) => {
          this.actions.deleteItemCallback(alias)
        }
      })
    } else {
      Text('别名设置')
        .font({
          size: 16,
          weight: 500
        })
        .fontColor('#31383E')
        .padding({
          left: 16,
          top: 16
        })

      this.addItemBuilder('添加别名', () => {
        this.configAliasInputDialogParam()
        this.inputDialog.open()
      })
    }
  }

  @Builder
  accountSettingBuilder() {
    Column() {
      this.arrowCellBuilder({
        title: '账号',
        value: this.account.length > 0 ? this.account : '未绑定账号',
        onClick: () => {
          this.configAccountInputDialogParam()
          this.inputDialog.open()
        }
      })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .border({
      color: '#E6E8EB',
      width: 1,
      radius: 8
    })
    .margin({
      top: 8
    })
  }

  @Builder
  phoneNumberSettingBuilder() {
    Column() {
      this.arrowCellBuilder({
        title: '短信通知',
        value: this.phoneNum.length > 0 ? this.phoneNum : '未绑定手机号',
        onClick: () => {
          this.configPhoneNumInputDialogParam()
          this.inputDialog.open()
        }
      })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .border({
      color: '#E6E8EB',
      width: 1,
      radius: 8
    })
    .margin({
      top: 8,
      bottom: 16
    })
  }

  @Builder
  arrowCellBuilder($$: ArrowCellParams) {
    Row() {
      Text($$.title)
        .font({
          size: 16,
          weight: 500
        })
        .fontColor('#1F2024')

      Row() {
        Text($$.value)
          .font({
            size: 16,
            weight: 400
          })
          .fontColor('#999CA3')
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .constraintSize({
            maxWidth: 180
          })

        Image($r('app.media.ic_arrow_right'))
          .width(19)
          .height(19)
          .objectFit(ImageFit.Contain)
      }
      .alignItems(VerticalAlign.Center)
      .onClick($$.onClick)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .padding(16)
  }
}

interface ArrowCellParams {
  title: string
  value: string
  onClick: () => void
}

export interface AdvancedActions {
  addItemCallback: (item: TagInfo) => void
  deleteItemCallback: (item: TagInfo) => void
  bindAccountCallback: (value: string) => void
  unbindAccountCallback: () => void
  bindPhoneNumberCallback: (value: string) => void
  unbindPhoneNumberCallback: () => void
}