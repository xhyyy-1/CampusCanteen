import { router, promptAction } from '@kit.ArkUI';
// 【第五次·要求3】按需导入登录参数接口
import { LoginParams } from '../model/FoodModels';

@Entry
@Component
struct Login {
  // 三个输入框内容
  @State userName: string = '';
  @State studentId: string = '';
  @State password: string = '';

  // 登录按钮：简单非空校验，通过后跳首页并带姓名/学号（第四次实验已有）
  private doLogin(): void {
    if (this.userName.trim().length === 0) {
      promptAction.showToast({ message: '请输入姓名' });
      return;
    }
    if (this.studentId.trim().length === 0) {
      promptAction.showToast({ message: '请输入学号' });
      return;
    }
    if (this.password.trim().length === 0) {
      promptAction.showToast({ message: '请输入密码' });
      return;
    }

    const params: LoginParams = {
      name: this.userName.trim(),
      // 不加 trim()：字符串 length 大于 0，校验会误判为填写成功，允许登录
      // 加了 trim()：防止用户只输入空格绕过非空校验
      studentId: this.studentId.trim()
    };

    // replaceUrl：替换当前页，避免登录页残留在返回栈里
    router.replaceUrl({
      url: 'pages/Index',
      params: params
    });
  }

  build() {
    Column() {
      // 品牌标题
      Text('校园食堂')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FF8C42')
        .margin({ top: 80 })

      Text('登录后开始点餐')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 8, bottom: 40 })

      // 登录表单卡片
      Column() {
        // 姓名输入框
        TextInput({ placeholder: '请输入姓名', text: this.userName })
          .height(50)
          .backgroundColor('#F7F7F7')
          .borderRadius(12)
          .margin({ bottom: 16 })
          .onChange((v: string) => {
            this.userName = v;
          })

        // 学号输入框
        TextInput({ placeholder: '请输入学号', text: this.studentId })
          .height(50)
          .backgroundColor('#F7F7F7')
          .borderRadius(12)
          .margin({ bottom: 16 })
          .onChange((v: string) => {
            this.studentId = v;
          })

        // 密码输入框
        TextInput({ placeholder: '请输入密码', text: this.password })
          .type(InputType.Password)
          .height(50)
          .backgroundColor('#F7F7F7')
          .borderRadius(12)
          .margin({ bottom: 24 })
          .onChange((v: string) => {
            this.password = v;
          })

        // 登录按钮
        Button('登录')
          .width('100%')
          .height(50)
          .backgroundColor('#FF8C42')
          .borderRadius(25)
          .fontSize(17)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.doLogin();
          })
      }
      .width('90%')
      .padding(24)
      .backgroundColor(Color.White)
      .borderRadius(20)
      .margin({ top: -40 })
      .shadow({ radius: 16, color: '#20000000', offsetX: 0, offsetY: 4 })

      Blank()

      Text('校园食堂 v1.0.0')
        .fontSize(12)
        .fontColor('#CCCCCC')
        .margin({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F7')
  }
}