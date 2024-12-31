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

export const CONFIG_STORAGE_KEY = 'configStorageKey'

export class Config {
  //地区配置，区分 大陆 新加坡sg 香港hk 等
  region: string = ''

  //是否使用https请求解析域名
  useHttps: boolean = false

  //是否允许返回过期IP
  enableExpiredIp: boolean = false

  //是否开启本地缓存
  enableDiskCache: boolean = false

  //是否网络环境切换后自动解析域名
  reResolveCachedHostsAfterNetworkChanged: boolean = false

  //域名解析请求的超时配置
  timeoutInMs: number = 3000

  //是否开启HttpDns内部的HiLog输出
  enableHiLog: boolean = false
}