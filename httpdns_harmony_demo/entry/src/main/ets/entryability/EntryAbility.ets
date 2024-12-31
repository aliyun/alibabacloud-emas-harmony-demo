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
import { httpdns } from '@aliyun/httpdns'
import { Config, CONFIG_STORAGE_KEY } from '../common/Config';
import { emasInfo } from '../common/EmasInfo';
import { BusinessError } from '@kit.BasicServicesKit';
import { entryStore } from '../common/DataStore';
import { JSON } from '@kit.ArkTS';
import { ttlCustomizer } from '../common/TtlCustomizer';

export default class EntryAbility extends UIAbility {
  storage: LocalStorage = new LocalStorage()

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    //读取rawfile文件夹中emas内容
    emasInfo.getEmasInfoSync(this.context)
    //初始化preferences对象
    entryStore.initPreferences(this.context)
    //获取本地持久化的config，如本地无则返回 new Config()
    let config: Config = entryStore.getConfigSync()
    //config存入LocalStorage
    this.storage.setOrCreate(CONFIG_STORAGE_KEY, config)

    console.log(`emasInfo: ${JSON.stringify(emasInfo)}`)
    console.log(`config: ${JSON.stringify(config)}`)

    //开启HttpDns内部的HiLog输出
    if (config.enableHiLog) {
      httpdns.enableHiLog()
    }

    // 配置HttpDns实例，必须在getService之前调用，才能在初始化使用配置
    httpdns.configService(emasInfo.accountId, {
      //请务必配置harmony上下文
      context: this.context,
      //加签密钥
      // secretKey: emasInfo.secretKey,
      //是否使用https请求
      useHttps: config.useHttps,
      //是否允许使用过期IP
      enableExpiredIp: config.enableExpiredIp,
      //是否开启本地缓存
      enableDiskCache: config.enableDiskCache,
      //是否开启网络变化自动解析
      reResolveCachedHostsAfterNetworkChanged: config.reResolveCachedHostsAfterNetworkChanged,
      //超时配置
      timeoutInMs: config.timeoutInMs,
      //地区配置
      region: config.region,
      //自定义缓存接口
      ttlCustomizer: ttlCustomizer
    })
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
