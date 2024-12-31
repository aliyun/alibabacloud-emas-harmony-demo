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

import { Logger } from '@aliyun/push'
import hilog from '@ohos.hilog';
import { CustomLogLevel } from '../pages/view/dialog/CustomLogLevelDialog';

/**
 * 自定义的日志输出接口
 * 日志接口的使用建议如下：
 * 1.线上环境默认仅采集hilog.LogLevel.ERROR及以上等级的日志
 * 2.线上环境可以考虑使用配置下发的方式动态采集指定设备hilog.LogLevel.INFO及以上等级的日志
 */
export class MyLogger implements Logger {
  print(domain: number, tag: string, level: hilog.LogLevel, msg: string): void {
    //自定义日志等级
    const customLevel = LocalStorage.getShared().get('customLogLevel') as CustomLogLevel
    switch (customLevel) {
      case CustomLogLevel.unknown:
        break
      case CustomLogLevel.close:
        return
      default:
        if (level.valueOf() < customLevel.valueOf()) {
          return
        }
    }

    //这里以输出到Hilog为例，具体实现需参考应用使用的日志采集系统
    switch (level) {
      case hilog.LogLevel.DEBUG:
        hilog.debug(domain, tag, '%{public}s', msg)
        break;
      case hilog.LogLevel.INFO:
        hilog.info(domain, tag, '%{public}s', msg)
        break;
      case hilog.LogLevel.WARN:
        hilog.warn(domain, tag, '%{public}s', msg)
        break;
      case hilog.LogLevel.ERROR:
        hilog.error(domain, tag, '%{public}s', msg)
        break;
      case hilog.LogLevel.FATAL:
        hilog.fatal(domain, tag, '%{public}s', msg)
        break;
      default:
        hilog.info(domain, tag, '%{public}s', msg)
        break;
    }
  }
}


export function printObject(tag: string, object: object) {
  if (object === undefined) {
    console.info(`${tag} is undefined`);
    return;
  }
  if (object === null) {
    console.info(`${tag} is null`);
    return;
  }
  console.info(`${tag} is ${typeof object}`);
  if (typeof object === 'boolean') {
    console.info(`${tag} is ${object}`);
    return;
  }
  if (typeof object === 'number') {
    console.info(`${tag} is ${object}`);
    return;
  }
  if (typeof object === 'string') {
    console.info(`${tag} is ${object}`);
    return;
  }
  if (typeof object === 'function') {
    return;
  }
  if (typeof object === 'object') {
    if (object instanceof Map) {
      console.info(`${tag} is ${mapToStr(object)}`);
      return;
    }
    const keys = Object.getOwnPropertyNames(object);
    keys.forEach((key) => {
      printObject(`${tag} ${key}`, object[key]);
    })
    return;
  }
}

export function mapToStr(object: Map<string, string | number | boolean>) {
  const keys = Array.from(object.keys() as IterableIterator<string>);
  return keys.map((key) => `${key}:${object.get(key)}`).join(',');
}