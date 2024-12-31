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

@CustomDialog
@Component
export struct CustomInputDialog {
  title: string = ''
  placeholder: string = ''
  inputValue: string = ''
  inputType: InputType = InputType.Normal
  controller: CustomDialogController = new CustomDialogController({builder: CustomInputDialog()})
  confirm: (value: string) => boolean = () => { return true}

  build() {
    Column() {
      Text(this.title)
        .font({size: 16, weight: 500})
        .fontColor('#1F2024')
        .margin({ top: 26, bottom: 24})

      TextInput({ placeholder: this.placeholder, text: this.inputValue})
        .height(35)
        .width('85%')
        .type(this.inputType)
        .fontWeight(FontWeight.Normal)
        .fontColor('#3E3D46')
        .fontSize(14)
        .borderRadius(4)
        .onChange((value: string) => {
          this.inputValue = value
        })

      Divider()
        .width('100%')
        .strokeWidth(0.5)
        .margin({top: 24})

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消', {type: ButtonType.Normal})
          .width('50%')
          .height(44)
          .backgroundColor('#00FFFFFF')
          .fontColor('#384153')
          .fontSize(16)
          .fontWeight(FontWeight.Normal)
          .borderRadius(2)
          .onClick(() => {
            this.controller.close()
          })

        Divider()
          .vertical(true)
          .strokeWidth(0.5)
          .height(44)

        Button('确定', {type: ButtonType.Normal})
          .width('50%')
          .height(44)
          .backgroundColor('#00FFFFFF')
          .fontColor('#1B58F4')
          .fontSize(16)
          .fontWeight(500)
          .borderRadius(2)
          .onClick(() => {
            if (this.confirm(this.inputValue)) {
              this.controller.close()
            }
          })
      }
    }
    .borderRadius(10)
  }
}
