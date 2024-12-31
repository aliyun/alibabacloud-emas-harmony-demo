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

import { Config, CONFIG_STORAGE_KEY } from '../common/Config'
import { emasInfo } from '../common/EmasInfo'
import { common, Want } from '@kit.AbilityKit'
import { entryStore } from '../common/DataStore'
import { getRegion, getRegionName, regionArray } from '../common/Region'
import { CustomInputDialog } from './view/CustomInputDialog'
import { httpdns, HttpDnsError, REGION_MAINLAND } from '@aliyun/httpdns'
import { PageName } from '../common/PageName'
import { promptAction } from '@kit.ArkUI'

interface SwitchCellParam {
  title: string
  subtitle: string
  isOn: boolean
  onChange: (isOn: boolean) => void
}

@Component
export struct SettingsPage {
  private scroller: Scroller = new Scroller()

  private context = getContext(this) as common.UIAbilityContext;

  @LocalStorageLink(CONFIG_STORAGE_KEY) @Watch('didChangeConfig') config: Config = new Config()

  @State regionDesc: string = getRegionName(this.config.region)

  @State regionIndex: number = regionArray.indexOf(this.config.region)

  @State timeoutDesc: string = `${this.config.timeoutInMs} ms`

  @Consume('navPathStack') navPathStack: NavPathStack

  //超时时间点击的弹窗
  timeoutDialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomInputDialog({
      title: '设置解析超时时间',
      placeholder: '',
      inputType: InputType.Number,
      confirm: (value) => {
        if (value.length == 0 || Number(value) < 1000) {
          promptAction.showToast({message: '超时时间最小设置1000ms', duration: 2000, bottom: 150, showMode: 1})
          return false
        }
        this.config.timeoutInMs = Number(value)
        this.timeoutDesc = value + ' ms'
        return true
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
    width: '85%'
  })

  aboutToDisappear() {
    this.timeoutDialogController = null
  }

  didChangeConfig(name: string) {
  //本地持久化存储config
    entryStore.putConfig(this.config)
  }

  //动态切换region
  changeRegion() {
    httpdns.getService(emasInfo.accountId).then((service) => {
      service.changeRegion(this.config.region)
    }).catch((error: HttpDnsError) => {
      console.error(`ChangeRegion error: ${error.code} ${error.message}`)
    })
  }

  //恢复默认设置
  resetConfig() {
    this.config = new Config()
    this.changeRegion()
    this.regionDesc = getRegionName(REGION_MAINLAND)
    this.timeoutDesc = `${this.config.timeoutInMs} ms`
  }

  //跳转到系统浏览器打开帮助文档
  openHelpCenter() {
    try {
      let want: Want = {
        'action': 'ohos.want.action.viewData',
        'entities': ['entity.system.browsable'],
        'uri': 'https://help.aliyun.com/document_detail/2766017.html?spm=a2c4g.2766013.0.i0',
        'type': 'text/plain'
      }
      this.context.startAbility(want)
    } catch (error) {
      console.error(`start ability failed with ${error.code}`)
    }
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          this.setupUI()
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .padding({top: 66, left: 16, right: 16})
      }
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .backgroundColor('#FFFFFF')
  }

  @Builder setupUI() {
    this.generalSettingsBuilder()
    this.advancedSettingBuilder()
    this.moreSettingsBuilder()
  }

  @Builder generalSettingsBuilder() {
    Text('通用')
      .font({size: 20, weight: 500})
      .fontColor('#3D3D3D')
    Text('通用配置更改后，需要重启App以使更改生效')
      .font({size: 12, weight: FontWeight.Normal})
      .fontColor('#98A4BA')
      .padding({top: 8, bottom: 25})


    this.switchCellBuilder({title: '允许过期IP', subtitle: '允许使用过期 IP', isOn: this.config.enableExpiredIp, onChange: (isOn) => {
      this.config.enableExpiredIp = isOn
    }})

    this.switchCellBuilder({title: '开启持久化缓存IP', subtitle: '域名解析结果，存储到本地数据库', isOn: this.config.enableDiskCache, onChange: (isOn) => {
      this.config.enableDiskCache = isOn
    }})

    this.switchCellBuilder({title: '允许 HTTPS', subtitle: '使用HTTPS协议解析', isOn: this.config.useHttps, onChange: (isOn) => {
      this.config.useHttps = isOn
    }})

    this.switchCellBuilder({title: '网络切换自动刷新', subtitle: '网络切换后自动刷新解析结果缓存', isOn: this.config.reResolveCachedHostsAfterNetworkChanged, onChange: (isOn) => {
      this.config.reResolveCachedHostsAfterNetworkChanged = isOn
    }})

    this.switchCellBuilder({title: '允许SDK打印日志', subtitle: '开启SDK打印日志', isOn: this.config.enableHiLog, onChange: (isOn) => {
      this.config.enableHiLog = isOn
    }})

    this.timeoutCellBuilder()
  }

  @Builder timeoutCellBuilder() {
    Row() {
      Column() {
        Text('超时时间')
          .fontColor('#3D3D3D')
          .font({size: 16, weight: FontWeight.Normal})
          .padding({top: 5, bottom: 5})
        Text('设置解析超时时间')
          .fontColor('#98A4BA')
          .font({size: 12, weight: FontWeight.Normal})
      }
      .alignItems(HorizontalAlign.Start)

      Row() {
        Text(this.timeoutDesc)
          .fontColor('#3D3D3D')
          .font({size: 16, weight: FontWeight.Normal})

        Image($r('app.media.ic_edit_filled'))
          .width(22)
          .height(22)
          .objectFit(ImageFit.Contain)
          .margin({left: 4, right: 4})
      }
      .onClick(() => {
        if (this.timeoutDialogController != null) {
          this.timeoutDialogController.open()
        }
      })
    }
    .width('100%')
    .padding({bottom: 20})
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder advancedSettingBuilder() {
    Text('高级配置')
      .font({size: 20, weight: 500})
      .fontColor('#3D3D3D')
      .padding({top: 25, bottom: 25})

    this.regionCellBuilder()

    this.arrowCellBuilder('预解析域名列表', '配置需要预解析的域名列表', () => {
      this.navPathStack.pushPathByName(PageName.RESOLVE_HOSTS, '')
    })

    this.arrowCellBuilder('清空指定域名缓存', '配置需要清空缓存的域名列表', () => {
      this.navPathStack.pushPathByName(PageName.CLEAN_HOST_CACHE, '')
    })
  }

  @Builder regionCellBuilder() {
    Row() {
      Column() {
        Text('Region')
          .fontColor('#3D3D3D')
          .font({size: 16, weight: FontWeight.Normal})
          .padding({top: 5, bottom: 5})
        Text('设置Region')
          .fontColor('#98A4BA')
          .font({size: 12, weight: FontWeight.Normal})
      }
      .alignItems(HorizontalAlign.Start)

      Select([{value: getRegionName(regionArray[0])}, {value: getRegionName(regionArray[1])}, {value: getRegionName(regionArray[2])}])
        .value(this.regionDesc)
        .font({size: 16, weight: FontWeight.Normal})
        .fontColor('#474A52')
        .backgroundColor('#FFFFFF')
        .optionFont({size: 16, weight: FontWeight.Normal})
        .optionFontColor('#474A52')
        .optionBgColor('#FFFFFF')
        .selected(this.regionIndex)
        .selectedOptionBgColor('#F4F7FC')
        .selectedOptionFont({size: 16, weight: FontWeight.Normal})
        .selectedOptionFontColor('#474A52')
        .onSelect((index: number, name: string) => {
          this.regionDesc = name
          this.regionIndex = regionArray.indexOf(getRegion(name))
          this.config.region = getRegion(name)
          this.changeRegion()
        })
    }
    .width('100%')
    .padding({bottom: 20})
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder switchCellBuilder($$: SwitchCellParam) {
    Row() {
      Column() {
        Text($$.title)
          .fontColor('#3D3D3D')
          .font({size: 16, weight: FontWeight.Normal})
          .padding({top: 5, bottom: 5})
        Text($$.subtitle)
          .fontColor('#98A4BA')
          .font({size: 12, weight: FontWeight.Normal})
      }
      .alignItems(HorizontalAlign.Start)

      Toggle({type: ToggleType.Switch, isOn: $$.isOn})
        .onChange($$.onChange)
        .size({width: 48, height: 24})
        .switchStyle({
          pointRadius: 10.5,
          unselectedColor: 'rgba(234,235,239,1)',
        })
        .switchPointColor(Color.White)
        .selectedColor('#424FF7')
    }
    .width('100%')
    .padding({bottom: 20})
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder arrowCellBuilder(title: string, subtitle: string, onClick: () => void) {
    Row() {
      Column() {
        Text(title)
          .fontColor('#3D3D3D')
          .font({size: 16, weight: FontWeight.Normal})
          .padding({top: 5, bottom: 5})
        Text(subtitle)
          .fontColor('#98A4BA')
          .font({size: 12, weight: FontWeight.Normal})
      }
      .alignItems(HorizontalAlign.Start)

      Image($r('app.media.ic_arrow_right'))
        .width(7)
        .height(12)
        .objectFit(ImageFit.Contain)
        .margin({right: 13})
    }
    .width('100%')
    .padding({bottom: 20})
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .onClick(onClick)
  }

  @Builder moreSettingsBuilder() {
    Row() {
      Text('帮助中心')
        .fontColor('#3D3D3D')
        .font({size: 20, weight: 500})
        .padding({top: 3})
      Image($r('app.media.ic_arrow_oblique'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
        .margin({right: 6})
    }
    .margin({top: 34, bottom: 23})
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.openHelpCenter()
    })

    Row() {
      Text('关于我们')
        .fontColor('#3D3D3D')
        .font({size: 20, weight: 500})
        .padding({top: 3})
      Image($r('app.media.ic_arrow_right'))
        .width(7)
        .height(12)
        .objectFit(ImageFit.Contain)
        .margin({right: 13})
    }
    .width('100%')
    .margin({bottom: 23})
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.navPathStack.pushPathByName(PageName.ABOUT_US, '')
    })

    Row() {
      Text('恢复默认设置')
        .fontColor('#424FF7')
        .font({size: 20, weight: 500})
        .padding({top: 3})
    }
    .width('100%')
    .margin({bottom: 23})
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.resetConfig()
    })
  }
}
