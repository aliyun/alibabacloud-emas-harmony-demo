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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { notificationManager } from '@kit.NotificationKit';
import { AppKey, AppSecret } from '../common/Constants';
import { MyPushListener } from '../common/MyPushListener';
import { MyPushNotificationHandler } from '../common/MyPushNotificationHandler';
import { aliyunPush, aliyunPushLog } from '@aliyun/push';
import { MyLogger } from '../common/MyLogger';

export default class EntryAbility extends UIAbility {

  storage: LocalStorage = new LocalStorage();

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    //申请通知权限
    notificationManager.isNotificationEnabled().then((data: boolean) => {
      console.info("isNotificationEnabled success, data: " + JSON.stringify(data));
      if (!data) {
        notificationManager.requestEnableNotification().then(() => {
          console.info(`[ANS] requestEnableNotification success`);
        }).catch((err: BusinessError) => {
          if (1600004 == err.code) {
            console.info(`[ANS] requestEnableNotification refused`);
          } else {
            console.error(`[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
          }
        });
      }
    }).catch((err: BusinessError) => {
      console.error(`isNotificationEnabled fail: ${JSON.stringify(err)}`);
    });

    //SDK提供 HiLog日志输出 和 接口日志输出 两种方式打印日志
    //HiLog日志输出，此方法建议在SDK初始化配置之前调用，建议仅在开发测试版本中使用。
    //aliyunPushLog.enableHiLogLogger()

    //接口日志输出，添加自定义日志输出接口
    aliyunPushLog.addLogger(new MyLogger())

    //初始化SDK
    aliyunPush.init({
      appKey: AppKey,
      appSecret: AppSecret,
      context: this.context,
    })

    //设置推送回调接口
    aliyunPush.setPushListener(new MyPushListener())

    //调用推送通知点击处理接口
    aliyunPush.handleClickNotification(want, new MyPushNotificationHandler())
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    //调用推送通知点击处理接口
    aliyunPush.handleClickNotification(want, new MyPushNotificationHandler())
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    let windowClass: window.Window | null = null;
    //获取当前界面window
    windowStage.getMainWindow().then((data: window.Window) => {
      windowClass = data
      //设置当前界面全屏
      windowClass.setWindowLayoutFullScreen(true, (err: BusinessError) => {
        let errCode: number = err.code;
        if (errCode) {
          console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in setting the window layout to full-screen mode.');
      });

      //设置状态栏文字颜色
      let sysBarProps: window.SystemBarProperties = {
        statusBarContentColor: '#000000'
      };
      windowClass.setWindowSystemBarProperties(sysBarProps, (err: BusinessError) => {
        let errCode: number = err.code;
        if (errCode) {
          console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in setting the system bar properties.');
      });
    })

    windowStage.loadContent('pages/Index', this.storage, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
