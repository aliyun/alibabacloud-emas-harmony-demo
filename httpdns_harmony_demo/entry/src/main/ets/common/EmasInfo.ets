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

import { common } from '@kit.AbilityKit'
import { util } from '@kit.ArkTS'

// aliyun-emas-services.json5文件中获取accountId、secretKey信息
const EMAS_FILE_NAME = 'aliyun-emas-services.json5'
// httpdns-domains.json5文件中获取domian信息
const DOMAINS_FILE_NAME = 'httpdns-domains.json5'

class EmasInfo {
  accountId: string = ''
  secretKey: string = ''
  domains: Array<string> = []

  getEmasInfoSync(context: common.UIAbilityContext) {
    try {
      const infoContent = context.resourceManager.getRawFileContentSync(EMAS_FILE_NAME)
      const textDecoder = util.TextDecoder.create('utf-8')
      const infoString = textDecoder.decodeWithStream(infoContent, {stream: false})
      const infoObject = JSON.parse(infoString) as object
      const config = infoObject['config'] as object
      this.accountId = config['httpdns.accountId'] as string
      this.secretKey = config['httpdns.secretKey'] as string

      const domainContent = context.resourceManager.getRawFileContentSync(DOMAINS_FILE_NAME)
      const domainString = textDecoder.decodeWithStream(domainContent, {stream: false})
      const domainObject = JSON.parse(domainString) as object
      this.domains = domainObject['domains'] as string[]
    } catch (error) {
      console.error('Failed to getEmasInfoSync')
    }
  }

  checkExist(host: string): boolean {
    return this.domains.includes(host)
  }
}

export const emasInfo = new EmasInfo()