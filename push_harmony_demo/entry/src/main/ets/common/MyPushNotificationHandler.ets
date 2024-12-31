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

import {
  BasePushData,
  Channel,
  PushNotification,
  PushNotificationHandler
} from '@aliyun/push';
import { printObject } from './MyLogger';

/**
 * 自定义推送数据的处理类
 */
export class MyPushNotificationHandler implements PushNotificationHandler {

  onClickNotification(data: PushNotification | BasePushData, from: Channel): void {
    // 由用户点击通知拉起的页面，获取推送数据，处理业务逻辑

    console.log(`onClickNotification 收到推送数据 ${data.msgId} from ${from === Channel.Aliyun ? 'Aliyun' :
      'HarmonyOS'}`);
    printObject(`onClickNotification`, data);
  }

  noPushData(): void {
    // 不是由用户点击通知拉的页面
  }
}
