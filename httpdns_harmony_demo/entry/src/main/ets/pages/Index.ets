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

import { CleanHostCachePage } from './CleanHostCachePage'
import { BasicPage } from './BasicPage'
import { CasePage } from './CasePage'
import { SettingsPage } from './SettingsPage'
import { ResolveHostsPage } from './ResolveHostsPage'
import { AboutUsPage } from './AboutUsPage'
import { SearchDomainPage } from './SearchDomainPage'
import { PageName } from '../common/PageName'

let storage = LocalStorage.getShared()

@Entry(storage)
@Component
struct Index {
  @State currentIndex:number = 0

  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  build() {
    Navigation(this.navPathStack) {
      Column() {
        Tabs({barPosition:BarPosition.End}) {
          TabContent(){
            BasicPage()
          }
          .tabBar(this.tabBuilder(0, $r('app.media.ic_tab_basic'), $r('app.media.ic_tab_basic_s')))

          TabContent(){
            CasePage({tabSelectedIndex: this.currentIndex})
          }
          .tabBar(this.tabBuilder(1, $r('app.media.ic_tab_case'), $r('app.media.ic_tab_case_s')))

          TabContent(){
            SettingsPage()
          }
          .tabBar(this.tabBuilder(2, $r('app.media.ic_tab_setting'), $r('app.media.ic_tab_setting_s')))
        }
        .backgroundColor('#FFFFFF')
        .scrollable(false)
        .animationDuration(0)
        .barMode(BarMode.Fixed)
        .barHeight(80)
        .onChange((index:number) => {
          this.currentIndex = index
        })
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .hideTitleBar(true)
    .navBarWidth('100%')
    .navDestination(this.pageMap)
    .mode(NavigationMode.Stack)
    .hideBackButton(true)
  }


  @Builder tabBuilder(targetIndex: number, normalImg: ResourceStr, selectedImg: ResourceStr) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 41 })
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .padding({top: 12})
  }

  @Builder pageMap(name: string, param: object) {
    if (name === PageName.CLEAN_HOST_CACHE) {
      CleanHostCachePage()
    } else if (name === PageName.RESOLVE_HOSTS) {
      ResolveHostsPage()
    } else if (name === PageName.ABOUT_US) {
      AboutUsPage()
    } else if (name === PageName.SEARCH_DOMAIN) {
      SearchDomainPage()
    }
  }
}
