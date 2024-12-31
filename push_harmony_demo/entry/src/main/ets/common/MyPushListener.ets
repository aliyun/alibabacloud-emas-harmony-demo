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
  aliyunPush,
  IPushListener,
  PushError,
  PushMessage,
  PushNotification
} from '@aliyun/push';
import { notificationManager } from '@kit.NotificationKit';
import { printObject } from './MyLogger';

/**
 * 自定义的推送回调接口实现
 */
export class MyPushListener implements IPushListener {

  onReceiveNotification(data: PushNotification): boolean {
    console.log(`onReceiveNotification ${data.msgId}`);
    printObject(`PushNotification`, data);

    // 处理推送通知
    let isCustom = LocalStorage.getShared().get<boolean>('CustomNotification') ?? false
    if (!isCustom) {
      // 返回false 表示不定制通知。返回true，表示定制通知。
      console.log(`onReceiveNotification ${data.msgId} 返回false`);
      return false;
    }

    // 定制通知示例
    aliyunPush.getPushHelper().createNotificationRequest(data).then((request) => {
      if (request.content.normal) {
        request.content.normal.title = `应用定制 ${request.content.normal.title}`
      } else if (request.content.multiLine) {
        request.content.multiLine.title = `应用定制 ${request.content.multiLine.title}`
        request.content.multiLine.longTitle = `应用定制 ${request.content.multiLine.longTitle}`
      }
      if (data.badgeSetNum !== undefined) {
        // 自己处理通知，也需要自己处理角标
        notificationManager.setBadgeNumber(data.badgeSetNum);
      }
      return notificationManager.publish(request);
    }).catch((e: PushError) => {
      console.log(`onReceiveNotification 创建通知失败 ${e}`);
    })

    console.log(`onReceiveNotification ${data.msgId} 返回true`);
    return true;
  }

  onShowNotification(data: PushNotification): void {
    // 处理通知展示事件
    console.log(`onShowNotification ${data.msgId}`);
    printObject(`PushNotification`, data);
  }

  onReceiveMessage(data: PushMessage): void {
    // 处理推送消息
    console.log(`onReceiveMessage 收到推送数据 ${data.msgId}`);
    printObject(`PushMessage`, data);
    LocalStorage.getShared().setOrCreate<string>('pushMessage', JSON.stringify(data));
  }
}
