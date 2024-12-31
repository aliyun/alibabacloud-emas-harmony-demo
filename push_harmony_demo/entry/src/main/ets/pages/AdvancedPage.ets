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

import { aliyunPush, TAG_TARGET, PushError } from '@aliyun/push'
import { CustomToast } from './view/dialog/CustomToast'
import { TagInfo, TagsType } from '../common/TagInfo'
import { DataPreferences } from '../common/DataPreferences'
import { common } from '@kit.AbilityKit'
import { RdbStore } from '../common/RdbStore'
import { AdvancedView } from './view/AdvancedView'

@Component
export struct AdvancedPage {
  private context = getContext(this) as common.UIAbilityContext
  private preferences: DataPreferences = new DataPreferences(this.context)
  private store: RdbStore = new RdbStore(this.context)
  @Link @Watch('didChangeCurrentIndex') currentIndex: number
  @LocalStorageProp('deviceId') deviceId: string = ''
  @State deviceTags: TagInfo[] = []
  @State alias: TagInfo[] = []
  @State aliasTags: TagInfo[] = []
  @State account: string = ''
  @State accountTags: TagInfo[] = []
  @State phoneNum: string = ''

  didChangeCurrentIndex() {
    if (this.currentIndex == 1 && this.deviceId.length > 0) {
      this.loadData()
    }
  }

  build() {
    AdvancedView({
      deviceTags: this.deviceTags,
      alias: this.alias,
      aliasTags: this.aliasTags,
      account: this.account,
      accountTags: this.accountTags,
      phoneNum: this.phoneNum,
      actions: {
        addItemCallback: (item) => {
          switch (item.type) {
            case TagsType.deviceTags:
              this.bindDeviceTag(item)
              break
            case TagsType.aliasTags:
              this.bindAliasTag(item)
              break
            case TagsType.accountTags:
              this.bindAccountTag(item)
              break
            default:
              this.addAlias(item)
              break
          }
        },
        deleteItemCallback: (item) => {
          switch (item.type) {
            case TagsType.deviceTags:
              this.unbindDeviceTag(item)
              break
            case TagsType.aliasTags:
              this.unbindAliasTag(item)
              break
            case TagsType.accountTags:
              this.unbindAccountTag(item)
              break
            default:
              this.removeAlias(item)
              break
          }
        },
        bindAccountCallback: (account) => {
          this.bindAccount(account)
        },
        unbindAccountCallback: () => {
          this.unbindAccount()
        },
        bindPhoneNumberCallback: (phoneNum) => {
          this.bindPhoneNumber(phoneNum)
        },
        unbindPhoneNumberCallback: () => {
          this.unbindPhoneNumber()
        }
      }
    })
  }

  loadData() {
    //从SDK查询
    this.listAliases()
    this.listDeviceTags()

    //从本地缓存查询
    this.account = this.preferences.getSync('account', '') as string
    this.phoneNum = this.preferences.getSync('phoneNum', '') as string

    if (this.account.length > 0) {
      this.store.queryTag(TagsType.accountTags, (tags) => {
        this.accountTags = tags.slice()
      }, this.account)
    }

    this.store.queryTag(TagsType.aliasTags, (tags) => {
      this.aliasTags = tags.slice()
    })
  }

  addAlias(item: TagInfo) {
    const idx = this.alias.findIndex((value) => {
      return value.name === item.name
    })

    if (idx > -1) {
      this.printLog('已存在别名')
      return
    }

    aliyunPush.addAlias(item.name, (err) => {
      if (err) {
        this.printLog('别名添加失败', err)
        return
      }
      this.alias.unshift(item)
      this.printLog('别名添加成功')
    })
  }

  removeAlias(item: TagInfo) {
    aliyunPush.removeAlias(item.name, (err) => {
      if (err) {
        this.printLog('别名删除失败', err)
        return
      }

      const idx = this.alias.findIndex((value) => {
        return value.name === item.name
      })

      this.alias.splice(idx, 1)
      this.printLog('别名删除成功')
    })
  }

  listAliases() {
    aliyunPush.listAliases((err, aliases) => {
      if (err) {
        console.error(`查询别名失败: ${err}`);
        return;
      }

      console.info(`查询别名成功 ${aliases?.join(',')}`)
      const arr = aliases ?? []
      this.alias = arr.map<TagInfo>((value) => {
        return {
          name: value,
          type: TagsType.alias
        }
      })
    })
  }

  listDeviceTags() {
    aliyunPush.listTags((err, tags) => {
      if (err) {
        console.error(`查询设备标签失败: ${err}`)
        return
      }

      console.info(`查询设备标签成功 ${tags?.join(',')}`)
      const arr = tags ?? []
      this.deviceTags = arr.map<TagInfo>((value) => {
        return {
          name: value,
          type: TagsType.deviceTags
        }
      })
    })
  }

  bindDeviceTag(item: TagInfo) {
    const idx = this.deviceTags.findIndex((value) => {
      return value.name === item.name
    })

    if (idx > -1) {
      this.printLog('已存在设备标签')
      return
    }

    aliyunPush.bindTag({
      target: TAG_TARGET.DEVICE,
      tags: [item.name]
    }, (err) => {
      if (err) {
        this.printLog('设备标签添加失败', err)
        return
      }
      this.deviceTags.unshift(item)
      this.printLog('设备标签添加成功')
    })
  }

  unbindDeviceTag(item: TagInfo) {
    aliyunPush.unbindTag({
      target: TAG_TARGET.DEVICE,
      tags: [item.name]
    }, (err) => {
      if (err) {
        this.printLog('设备标签删除失败', err)
        return;
      }

      const idx = this.deviceTags.findIndex((value) => {
        return value.name === item.name
      })
      this.deviceTags.splice(idx, 1)
      this.printLog('设备标签删除成功')
    })
  }

  bindAccountTag(item: TagInfo) {
    const idx = this.accountTags.findIndex((value) => {
      return value.name === item.name
    })

    if (idx > -1) {
      this.printLog('已存在账号标签')
      return
    }

    aliyunPush.bindTag({
      target: TAG_TARGET.ACCOUNT,
      tags: [item.name]
    }, (err) => {
      if (err) {
        this.printLog('账号标签添加失败', err)
        return
      }
      this.accountTags.unshift(item)
      this.store.insertTag(item, this.account)
      this.printLog('账号标签添加成功')
    })
  }

  unbindAccountTag(item: TagInfo) {
    aliyunPush.unbindTag({
      target: TAG_TARGET.ACCOUNT,
      tags: [item.name]
    }, (err) => {
      if (err) {
        this.printLog('账号标签删除失败', err)
        return;
      }

      const idx = this.accountTags.findIndex((value) => {
        return value.name === item.name
      })
      this.accountTags.splice(idx, 1)
      this.store.deleteTag(item, this.account)
      this.printLog('账号标签删除成功')
    })
  }

  bindAliasTag(item: TagInfo) {
    const idx = this.aliasTags.findIndex((value) => {
      return value.name === item.name &&
        value.alias === item.alias
    })

    if (idx > -1) {
      this.printLog('已存在别名标签')
      return
    }

    aliyunPush.bindTag({
      target: TAG_TARGET.ALIAS,
      tags: [item.name],
      alias: item.alias ?? ''
    }, (err) => {
      if (err) {
        this.printLog('别名标签添加失败', err)
        return
      }

      this.aliasTags.unshift(item)
      this.store.insertTag(item)
      this.printLog('别名标签添加成功')
    })
  }

  unbindAliasTag(item: TagInfo) {
    aliyunPush.unbindTag({
      target: TAG_TARGET.ALIAS,
      tags: [item.name],
      alias: item.alias ?? ''
    }, (err) => {
      if (err) {
        this.printLog('别名标签删除失败', err)
        return;
      }

      const idx = this.aliasTags.findIndex((value) => {
        return value.name === item.name &&
          value.alias === item.alias
      })

      this.aliasTags.splice(idx, 1)
      this.store.deleteTag(item)
      this.printLog('别名标签删除成功')
    })
  }

  bindAccount(account: string) {
    if (this.account === account) {
      return
    }

    aliyunPush.bindAccount(account, (err) => {
      if (err) {
        this.printLog('账号绑定失败', err)
        return
      }

      this.account = account
      this.preferences.putSync('account', account)
      this.accountTags = []
      this.printLog('账号绑定成功')
    })
  }

  unbindAccount() {
    aliyunPush.unbindAccount((err) => {
      if (err) {
        this.printLog('解除绑定失败', err)
        return
      }

      this.account = ''
      this.preferences.putSync('account', '')
      this.accountTags = []
      this.printLog('解除绑定成功')
    })
  }

  bindPhoneNumber(phone: string) {
    if (this.phoneNum === phone) {
      return
    }

    aliyunPush.bindPhoneNumber(phone, (err) => {
      if (err) {
        this.printLog('手机号绑定失败', err)
        return;
      }

      this.phoneNum = phone
      this.preferences.putSync('phoneNum', phone)
      this.printLog('手机号绑定成功')
    })
  }

  unbindPhoneNumber() {
    aliyunPush.unbindPhoneNumber((err) => {
      if (err) {
        this.printLog('解除绑定失败', err)
        return;
      }

      this.phoneNum = ''
      this.preferences.putSync('phoneNum', '')
      this.printLog('解除绑定成功')
    })
  }

  printLog(msg: string, err?: PushError) {
    if (err != undefined) {
      console.error(`${msg}: ${err}`)
    } else {
      console.log(msg)
    }

    this.showToast(msg, err == undefined)
  }

  showToast(msg: string, flag: boolean) {
    const toast = new CustomDialogController({
      builder: CustomToast({
        param: {
          msg: msg,
          successFlag: flag
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