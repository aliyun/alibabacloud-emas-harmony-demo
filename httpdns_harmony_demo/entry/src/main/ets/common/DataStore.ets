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

import { preferences } from '@kit.ArkData'
import { common } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { Config, CONFIG_STORAGE_KEY } from './Config'

export type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean> | Uint8Array | object | bigint;

//设置页本地缓存的预解析域名列表，包含控制台添加的domains（httpdns-domains.json5文件中读取）和设置页手动添加的域名
export const SETTINGS_PRE_DOMAIN_LIST_KEY = 'settingsPreResolveDomainListKey'

//设置页本地缓存的清空指定域名列表，包含控制台添加的domains（httpdns-domains.json5文件中读取）和设置页手动添加的域名
export const SETTINGS_CLEAN_DOMAIN_LIST_KEY = 'settingsCleanDomainListKey'

//搜索页输入历史域名列表
export const HISTORY_INPUT_DOMAIN_LIST_KEY = 'historyDomainListKey'

//本地持久化preferences名称
export const PREFERENCES_NAME = 'httpDnsDemoStore'

export class DataStore {
  preferences: preferences.Preferences | null = null

  initPreferences(context: common.UIAbilityContext) {
    this.preferences = preferences.getPreferencesSync(context, {name: PREFERENCES_NAME})
  }

  getConfigSync(): Config {
    if (this.preferences === null) {
      return new Config()
    }
    return this.preferences.getSync(CONFIG_STORAGE_KEY, new Config()) as Config
  }

  putConfig(value: Config) {
    this.put(CONFIG_STORAGE_KEY, value)
  }

  getSync(key: string, defValue: ValueType): ValueType {
    if (this.preferences === null) {
      return defValue
    }
    return this.preferences.getSync(key, defValue)
  }

  putSync(key: string, value: ValueType) {
    if (this.preferences === null) {
      return
    }
    this.preferences.putSync(key, value)
    this.flush()
  }

  put(key: string, value: ValueType) {
    if (this.preferences === null) {
      return
    }
    this.preferences.put(key, value).then(() => {
      this.flush()
    })
  }

  flush() {
    if (this.preferences === null) {
      return
    }
    this.preferences.flush((err: BusinessError) => {
      if (err) {
        console.error(`Failed to flush. Code:${err.code}, message:${err.message}`)
        return
      }
      console.info('Succeeded in flushing.')
    })
  }
}

export const entryStore: DataStore = new DataStore()
