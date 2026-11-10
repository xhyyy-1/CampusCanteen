// ==================== LoginPage.ets ====================
// 学生登录页：输入姓名、学号、密码，登录后进入首页（Index），
// 并把姓名、学号通过路由参数带给首页，显示在“我的”个人主页。
import { promptAction, router } from '@kit.ArkUI';

// 登录成功后传给首页的参数格式
interface LoginParams {
  name: string;       // 学生姓名
  studentId: string; // 学号
}

@Entry
@Component
struct LoginPage {
  // 三个输入框内容
  @State userName: string = '';
  @State studentId: string = '';
  @State password: string = '';

  // 登录按钮：简单非空校验，通过后跳首页并带姓名/学号
  private doLogin() {
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
      studentId: this.studentId.trim()//不加 `trim()`：字符串 的 length 是大于 0，校验会**误判为填写成功**，允许登录
      //防止用户只输入空格绕过非空校验
    };
    // replaceUrl：替换当前页，避免登录页残留在返回栈里
    router.replaceUrl({ url: 'pages/Index', params: params });
  }

  build() {
    Column() {
      // ---------- 顶部橙色品牌区 ----------
      Column() {
        Text('🍽️').fontSize(56)
        Text('校园食堂')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .margin({ top: 12 })
        Text('学生登录后开始点餐')
          .fontSize(13)
          .fontColor('#FFE6D2')
          .margin({ top: 6 })
      }
      .width('100%')
      .height(220)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#FF8C42')

      // ---------- 登录卡片 ----------
      Column() {
        Text('学生登录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ bottom: 20 })

        // 姓名
        TextInput({ placeholder: '请输入姓名', text: this.userName })
          .type(InputType.Normal)
          .height(50)
          .backgroundColor('#F7F7F7')
          .borderRadius(12)
          .margin({ bottom: 14 })
          .onChange((v: string) => { this.userName = v; })

        // 学号
        TextInput({ placeholder: '请输入学号', text: this.studentId })
          .type(InputType.Number)
          .height(50)
          .backgroundColor('#F7F7F7')
          .borderRadius(12)
          .margin({ bottom: 14 })
          .onChange((v: string) => { this.studentId = v; })

        // 密码
        TextInput({ placeholder: '请输入密码', text: this.password })
          .type(InputType.Password)
          .height(50)
          .backgroundColor('#F7F7F7')
          .borderRadius(12)
          .margin({ bottom: 24 })
          .onChange((v: string) => { this.password = v; })

        // 登录按钮
        Button('登录')
          .width('100%')
          .height(50)
          .backgroundColor('#FF8C42')
          .borderRadius(25)
          .fontSize(17)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .onClick(() => this.doLogin())
      }
      .width('90%')
      .padding(24)
      .backgroundColor(Color.White)
      .borderRadius(20)
      .margin({ top: -40 })
      .shadow({ radius: 16, color: '#20000000', offsetX: 0, offsetY: 4 })

      Blank()
      Text('校园食堂 v1.0.0').fontSize(12).fontColor('#CCCCCC').margin({ bottom: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F7F7')
  }
}
