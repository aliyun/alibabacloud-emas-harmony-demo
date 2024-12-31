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

import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean> | Uint8Array | object | bigint

export class DataPreferences {
  dataPreferences: preferences.Preferences

  constructor(context: common.UIAbilityContext) {
    this.dataPreferences = preferences.getPreferencesSync(context, { name: 'aliyunPushDemoStore' });
  }

  putSync(key: string, value: ValueType) {
    this.dataPreferences.putSync(key, value)
    this.flush()
  }

  getSync(key: string, defValue: ValueType): ValueType {
    return this.dataPreferences.getSync(key, defValue) ?? defValue
  }

  flush() {
    this.dataPreferences.flush((err: BusinessError) => {
      if (err) {
        console.error(`Failed to flush. Code:${err.code}, message:${err.message}`)
        return
      }
      console.info('Succeeded in flushing.')
    })
  }
}