import { router, promptAction } from '@kit.ArkUI';
// 从模型文件导入接口
import { BannerItem, Dish, TabItem, RouterParams } from '../model/FoodModels';
// 从组件文件导入自定义组件
import { DishCard } from '../components/DishCard';
import { SectionHeader } from '../components/SectionHeader';

//通用卡片样式
//菜品卡片已经封装进 DishCard 组件，这里保留给其他卡片备用
@Styles
function cardStyle() {
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(16)
  .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })
}

@Entry
@Component
struct Index {
  //状态变量
  @State currentTab: number = 0; // 当前选中的底部 Tab

  // 登录后从登录页带过来的学生信息，显示在“我的”个人主页
  @State loginName: string = '同学'; // 登录学生姓名
  @State loginStudentId: string = ''; // 登录学号

  // 页面出现时读取登录页传过来的姓名/学号
  aboutToAppear(): void {
    const params = router.getParams() as Record<string, Object>;
    if (params) {
      const name = params['name'] as string;
      const studentId = params['studentId'] as string;
      if (name && name.length > 0) {
        this.loginName = name;
      }
      if (studentId && studentId.length > 0) {
        this.loginStudentId = studentId;
      }
    }
  }

  //对象数组：轮播图数据
  private banners: BannerItem[] = [
    { id: 1, title: '今日特价', subTitle: '红烧肉套餐立减3元', emoji: '🍖', bgColor: '#FFB26B' },
    { id: 2, title: '新品上市', subTitle: '藤椒鸡排饭尝鲜价13元', emoji: '🍗', bgColor: '#7FC8A9' },
    { id: 3, title: '健康套餐', subTitle: '轻食沙拉 + 无糖豆浆', emoji: '🥗', bgColor: '#8FB8E8' }
  ];

  //对象数组：菜品数据
  // 每个 {} 都是一个 Dish 对象，整体是一个 Dish[]
  private dishes: Dish[] = [
    { id: 101, name: '小笼包 + 豆浆', emoji: '🥟', price: 6, desc: '现蒸现卖·皮薄馅大' },
    { id: 102, name: '鸡蛋灌饼', emoji: '🌯', price: 5, desc: '加肠加蛋·管饱' },
    { id: 103, name: '皮蛋瘦肉粥', emoji: '🥣', price: 4, desc: '暖胃清淡' },
    { id: 201, name: '宫保鸡丁饭', emoji: '🍛', price: 12, desc: '微辣·下饭首选' },
    { id: 202, name: '麻辣香锅', emoji: '🌶️', price: 15, desc: '自选配菜·中辣' },
    { id: 203, name: '番茄鸡蛋面', emoji: '🍜', price: 10, desc: '汤浓面劲道' }
  ];

  //对象数组：底部导航数据
  private tabs: TabItem[] = [
    { id: 1, name: '首页', icon: '🏠' },
    { id: 2, name: '我的', icon: '👤' }
  ];

  //页面跳转
  goToDetail(dish: Dish): void {
    promptAction.showToast({
      message: `即将查看：${dish.name}`
    });

    const params: RouterParams = {
      name: dish.name,
      price: dish.price
    };

    router.pushUrl({
      url: 'pages/DishDetail',
      params: params
    });
  }


  // 传入SectionHeader 的 UI
  @Builder
  headerExtra() {
    Button('查看全部')
      .fontSize(12)
      .fontColor('#FF8C42')
      .backgroundColor(Color.Transparent)
      .height(24)
      .padding({ left: 8, right: 0 })
      .onClick(() => {
        promptAction.showToast({
          message: '已经展示全部推荐菜品'
        });
      })
  }


  @Builder
  DishGridItem(dish: Dish) {//第252行，用ForEach渲染Grid
    DishCard({
      dish: dish,
      showDesc: true,
      onSelect: (item: Dish) => {
        this.goToDetail(item);
      },
      priceFormatter: (price: number): string => `￥${price}`
    })
  }

  //顶部标题栏
  @Builder
  HeaderBar() {
    Column() {
      Text('校园食堂')
        .fontSize(24)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)

      Text('今天想吃点什么？')
        .fontSize(13)
        .fontColor('#FFE6D2')
        .margin({ top: 6 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 20, right: 20, top: 28, bottom: 22 })
    .backgroundColor('#FF8C42')
  }

  //轮播图
  @Builder
  BannerArea() {
    Swiper() {
      // 【要求4】ForEach 遍历对象数组 banners
      // 第一个参数：对象数组
      // 第二个参数：每一项怎么渲染
      // 第三个参数：key 生成函数，用 id 保证唯一
      ForEach(this.banners, (item: BannerItem) => {
        Row() {
          Column() {
            Text(item.title)
              .fontSize(20)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)

            Text(item.subTitle)
              .fontSize(13)
              .fontColor(Color.White)
              .opacity(0.9)
              .margin({ top: 8 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text(item.emoji)
            .fontSize(46)
        }
        .width('100%')
        .height('100%')
        .padding({ left: 20, right: 20 })
        .backgroundColor(item.bgColor) // 每个对象自己的背景色
        .borderRadius(16)
      }, (item: BannerItem) => item.id.toString())
    }
    .autoPlay(true)   // 自动播放
    .interval(3000)   // 间隔 3 秒
    .loop(true)       // 循环
    .height(140)
    .margin({ left: 16, right: 16, top: 16 })
    .clip(true)       // clip 防止圆角被里面的内容覆盖
  }

  // 底部 Tab 按钮模板
  @Builder
  TabBuilder(index: number) {
    Column() {
      // 三元表达式：选中时全亮，未选中时半透明
      Text(this.tabs[index].icon)
        .fontSize(22)
        .opacity(this.currentTab === index ? 1 : 0.4)

      Text(this.tabs[index].name)
        .fontSize(12)
        .fontColor(this.currentTab === index ? '#FF8C42' : '#999999')
        .margin({ top: 4 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  // “我的”页面列表项模板
  @Builder
  SettingItem(icon: string, text: string) {
    Row() {
      Text(icon)
        .fontSize(22)
        .margin({ right: 16 })

      Text(text)
        .fontSize(16)
        .fontColor('#333')
        .fontWeight(FontWeight.Medium)

      Blank()

      Text('>')
        .fontSize(16)
        .fontColor('#CCCCCC')
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .padding({ top: 18, bottom: 18, left: 20, right: 20 })
    .onClick(() => {
      promptAction.showToast({
        message: `点击了 ${text}`
      });
    })
  }

  // ================== 页面主体 ==================
  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentTab }) {

      // -------------------- 首页 --------------------
      TabContent() {
        Scroll() {
          Column() {
            this.HeaderBar()
            this.BannerArea()

            SectionHeader({
              title: '今日推荐',
              count: this.dishes.length,   // 成员变量 count 由外部覆盖
              countUnit: '道',             // 成员变量 countUnit 由外部覆盖
              extraBuilder: this.headerExtra // @BuilderParam 由外部覆盖，Index第89行
            })

            // 实验要求：Grid 布局
            Grid() {
              // ForEach 遍历对象数组 dishes
              ForEach(this.dishes, (dish: Dish) => {
                GridItem() {
                  //调用自定义组件 DishCard，并覆盖它的成员变量
                  this.DishGridItem(dish)
                }
              }, (dish: Dish) => dish.id.toString())
            }
            .columnsTemplate('1fr 1fr') // 两列等宽
            .columnsGap(12)
            .rowsGap(12)
            .padding({ left: 16, right: 16 })
            .width('100%')
          }
          .width('100%')
          .padding({ bottom: 20 })
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)          // 隐藏右侧滚动条
        .edgeEffect(EdgeEffect.Spring)    // 回弹感
      }
      .tabBar(this.TabBuilder(0)) // 绑定底部第一个图标

      // -------------------- 我的 --------------------
      TabContent() {
        Scroll() {
          Column() {
            Stack({ alignContent: Alignment.Bottom }) {
              // 1. 底部的背景图
              Column()
                .width('100%')
                .height(220)
                .backgroundColor('#FF8C42') // 使用主题橙色
                .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
                .borderRadius({ bottomLeft: 24, bottomRight: 24 })
                .width('100%')
                .height(220)

                .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
                .borderRadius({ bottomLeft: 24, bottomRight: 24 }) // 底部带一点圆角更柔和

              // 2. 头像和文字内容
              Row() {
                Text('👤')
                  .fontSize(50)
                  .width(80)
                  .height(80)
                  .textAlign(TextAlign.Center)
                  .backgroundColor(Color.White)
                  .borderRadius(40)
                  .shadow({ radius: 10, color: '#40000000', offsetX: 0, offsetY: 4 })

                Column() {
                  Text(this.loginName)
                    .fontSize(22)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.White)
                    .textShadow({ radius: 4, color: '#80000000', offsetX: 1, offsetY: 1 })

                  Text(`学号：${this.loginStudentId}`)
                    .fontSize(13)
                    .fontColor('#FFFFFF')
                    .margin({ top: 4 })
                    .opacity(0.9)

                  Text('干饭人，干饭魂')
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                    .margin({ top: 6 })
                    .textShadow({ radius: 4, color: '#80000000', offsetX: 1, offsetY: 1 })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 20 })
              }
              .width('100%')
              .padding({ bottom: 40, left: 24, right: 24 }) // 调整底部边距
            }
            .width('100%')
            .height(220) // Stack 的整体高度

            // 列表部分
            Column() {
              this.SettingItem('📦', '我的订单')
              Divider().color('#F5F5F5').margin({ left: 58, right: 20 }) // 分割线

              this.SettingItem('⭐', '我的收藏')
              Divider().color('#F5F5F5').margin({ left: 58, right: 20 })

              this.SettingItem('📍', '收货地址')
              Divider().color('#F5F5F5').margin({ left: 58, right: 20 })

              this.SettingItem('⚙️', '系统设置')
            }
            .width('92%')
            .backgroundColor(Color.White)
            .borderRadius(20)
            .margin({ top: -30 }) // 向上浮动，盖住部分图片区域
            .shadow({ radius: 20, color: '#1A000000', offsetX: 0, offsetY: 8 })

            // 退出登录：回到登录页，重新登录
            Button('退出登录')
              .width('92%')
              .height(46)
              .margin({ top: 20 })
              .backgroundColor('#FFEEEE')
              .fontColor('#FF6B00')
              .fontWeight(FontWeight.Medium)
              .borderRadius(12)
              .onClick(() => {
                router.replaceUrl({ url: 'pages/Login' });
              })

            Text('校园食堂 v1.0.0')
              .fontSize(12)
              .fontColor('#CCCCCC')
              .margin({ top: 30, bottom: 20 })
              .width('100%')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#F7F7F7')
        }
        .width('100%')
        .height('100%')
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Off)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
      }
      .tabBar(this.TabBuilder(1))
    }
    .onChange((index: number) => {
      this.currentTab = index; // 滑动或点击切换页面时，更新状态变量
    })
    .backgroundColor('#F7F7F7')
  }
}