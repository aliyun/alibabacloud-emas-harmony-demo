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

import { ICacheTtlCustomizer, IpType } from '@aliyun/httpdns'

class TtlCustomizer implements ICacheTtlCustomizer {
  private host: string = ''
  private ttl: number = 60

  tempHost: string = ''
  tempTtl: number = 60

  setCustom(host: string, ttlInSec: number) {
    this.host = host
    this.ttl = ttlInSec
  }

  getCacheTtlInSec(host: string, type: IpType, serverTtlInSec: number): number {
    this.tempHost = host
    this.tempTtl = serverTtlInSec
    if (host === this.host) {
      return this.ttl
    }
    return serverTtlInSec
  }
}

export const ttlCustomizer = new TtlCustomizer()