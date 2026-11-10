import { promptAction, router } from '@kit.ArkUI';

//数据模型
interface Dish {
  id: number;     // 编号（用于ForEach循环时区分每一项）
  name: string;   // 菜名
  emoji: string;  // 菜的图标
  price: number;  // 价格
  desc: string;   // 描述
}

interface BannerItem {
  id: number;
  title: string;
  subTitle: string;
  emoji: string;
  bgColor: string;
}

interface TabItem {
  id: number;
  name: string;
  icon: string;
}
//页面跳转时传过去的数据格式
interface RouterParams {
  name: string;
  price: number;
}

//@Styles 抽取通用属性
@Styles function cardStyle() {
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius(16)
  .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })
}

// ================= @Extend 扩展组件 =================
@Extend(Text) function dishNameText() {
  .fontSize(16)
  .fontWeight(FontWeight.Medium)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
}

@Entry
@Component
struct Index {
  // 状态变量
  @State currentTab: number = 0;
  // 登录后从登录页带过来的学生信息，显示在“我的”个人主页
  @State loginName: string = '同学';       // 登录学生姓名
  @State loginStudentId: string = '';      // 登录学号

  // 页面出现时读取登录页传过来的姓名/学号
  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params['name'] && params['name'].length > 0) {
      this.loginName = params['name'];
    }
    if (params && params['studentId'] && params['studentId'].length > 0) {
      this.loginStudentId = params['studentId'];
    }
  }
  // 轮播图数据
  private banners: BannerItem[] = [
    { id: 1, title: '今日特价', subTitle: '红烧肉套餐立减 3 元', emoji: '🍖', bgColor: '#FFB26B' },
    { id: 2, title: '新品上市', subTitle: '藤椒鸡排饭 尝鲜价 13 元', emoji: '🍗', bgColor: '#7FC8A9' },
    { id: 3, title: '健康套餐', subTitle: '轻食沙拉 + 无糖豆浆', emoji: '🥗', bgColor: '#8FB8E8' }
  ];
  // 菜品数据
  private dishes: Dish[] = [
    { id: 101, name: '小笼包 + 豆浆', emoji: '🥟', price: 6,  desc: '现蒸现卖 · 皮薄馅大' },
    { id: 102, name: '鸡蛋灌饼',      emoji: '🌯', price: 5,  desc: '加肠加蛋 · 管饱' },
    { id: 103, name: '皮蛋瘦肉粥',    emoji: '🥣', price: 4,  desc: '暖胃清淡' },
    { id: 201, name: '宫保鸡丁饭',    emoji: '🍗', price: 12, desc: '微辣 · 下饭首选' },
    { id: 202, name: '麻辣香锅',      emoji: '🌶️', price: 15, desc: '自选配菜 · 中辣' },
    { id: 203, name: '番茄鸡蛋面',    emoji: '🍜', price: 10, desc: '汤浓面劲道' }
  ];
  // 底部导航数据
  private tabs: TabItem[] = [
    { id: 1, name: '首页', icon: '🏠' },
    { id: 3, name: '我的', icon: '👤' }
  ];
  //页面跳转
  goToDetail(dish: Dish) {
    promptAction.showToast({ message: `即将查看：${dish.name}` });
    const params: RouterParams = { name: dish.name, price: dish.price };
    router.pushUrl({
      url: 'pages/DishDetail',
      params: params
    });
  }
  //菜品卡片
  @Builder
  DishGridItem(dish: Dish) {
    Column() {
      Column() {
        Text(dish.emoji).fontSize(40)
      }
      .width('100%').height(90)
      .justifyContent(FlexAlign.Center)// 让里面的 Emoji 居中
      .backgroundColor('#FFF3E6')
      .borderRadius({ topLeft: 16, topRight: 16 })

      Column() {
        Text(dish.name).dishNameText().margin({ top: 8 })// 使用了 @Extend 定义样式
        Text(dish.desc)
          .fontSize(12).fontColor('#999999').margin({ top: 4 })
          .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })

        Blank()// 弹簧组件，让价格永远在底部

        Row() {
          Text(`¥${dish.price}`)
            .fontSize(16).fontColor('#FF6B00').fontWeight(FontWeight.Bold)
        }.width('100%').margin({ top: 6 })
      }
      .width('100%')
      .layoutWeight(1)// 占据下半部分剩余的所有高度
      .padding(10)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(170)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({ radius: 8, color: '#10000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      this.goToDetail(dish);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentTab }) {

      // 首页
      TabContent() {
        Scroll() {
          Column() {
            this.HeaderBar()
            this.BannerArea()

            Row() {
              Text('今日推荐').fontSize(17).fontWeight(FontWeight.Bold)
              Blank()
              Text(`共 ${this.dishes.length} 道`).fontSize(12).fontColor('#999999')
            }.width('100%').padding({ left: 16, right: 16, top: 20, bottom: 10 })
            // 实验要求：Grid布局
            Grid() {
              ForEach(this.dishes, (dish: Dish) => {
                GridItem() {
                  this.DishGridItem(dish)// 调用上面的 @Builder 卡片
                }
              }, (dish: Dish) => dish.id.toString())
            }
            .columnsTemplate('1fr 1fr')
            .columnsGap(12)
            .rowsGap(12)
            .padding({ left: 16, right: 16 })

          }.width('100%').padding({ bottom: 20 })
        }
        .width('100%').height('100%')
        .scrollBar(BarState.Off)// 隐藏右侧滚动条
        .edgeEffect(EdgeEffect.Spring)// 回弹感
      }
      .tabBar(this.TabBuilder(0))// 绑定底部第一个图标

      // 我的
      TabContent() {
        Scroll() {
          Column() {
            Stack({ alignContent: Alignment.Bottom }) {
              // 1. 底部的背景图
              Image($r('app.media.header_bg'))
                .width('100%')
                .height(260)
                .objectFit(ImageFit.Cover)
                // 让图片向上扩展，覆盖状态栏区域（消除白边）
                .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
                .borderRadius({ bottomLeft: 24, bottomRight: 24 }) // 底部带一点圆角更柔和

              // 2. 头像和文字内容
              Row() {
                Text('👨‍🎓').fontSize(50).width(80).height(80).textAlign(TextAlign.Center)
                  .backgroundColor(Color.White).borderRadius(40)
                  .shadow({ radius: 10, color: '#40000000', offsetX: 0, offsetY: 4 })

                Column() {

                  Text(this.loginName).fontSize(22).fontWeight(FontWeight.Bold).fontColor(Color.White)
                    .textShadow({ radius: 4, color: '#80000000', offsetX: 1, offsetY: 1 })
                  Text('学号：' + this.loginStudentId).fontSize(13).fontColor('#FFFFFF').margin({ top: 4 })
                    .opacity(0.9)
                  Text('干饭人，干饭魂').fontSize(14).fontColor('#FFFFFF').margin({ top: 6 })
                    .textShadow({ radius: 4, color: '#80000000', offsetX: 1, offsetY: 1 })
                }.alignItems(HorizontalAlign.Start).margin({ left: 20 })
              }
              .width('100%')
              .padding({ bottom: 40, left: 24, right: 24 }) // 调整底部边距
            }
            .width('100%')
            .height(220) // Stack 的整体高度

            // 列表部分
            Column() {
              this.SettingItem('📦', '我的订单')
              Divider().color('#F5F5F5').margin({ left: 58, right: 20 })// 分割线
              this.SettingItem('❤️', '我的收藏')
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

          }.width('100%')
        }
        .width('100%').height('100%').backgroundColor('#F7F7F7')
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Off)
        // 让整个滚动页面向上扩展
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
      }
      .tabBar(this.TabBuilder(1))

    }
    .onChange((index: number) => {
      this.currentTab = index;// 滑动或点击切换页面时，更新状态变量
    })
    .backgroundColor('#F7F7F7')
  }

  // 顶部标题栏
  @Builder
  HeaderBar() {
    Column() {
      Text('校园食堂').fontSize(24).fontColor(Color.White).fontWeight(FontWeight.Bold)
      Text('今天想吃点什么？').fontSize(13).fontColor('#FFE6D2').margin({ top: 6 })
    }
    .width('100%').alignItems(HorizontalAlign.Start)
    .padding({ left: 20, right: 20, top: 28, bottom: 22 })
    .backgroundColor('#FF8C42')
  }
  // 轮播图
  @Builder
  BannerArea() {
    Swiper() {
      ForEach(this.banners, (item: BannerItem) => {
        Row() {
          Column() {
            Text(item.title).fontSize(20).fontColor(Color.White).fontWeight(FontWeight.Bold)
            Text(item.subTitle).fontSize(13).fontColor(Color.White).opacity(0.9).margin({ top: 8 })
          }.alignItems(HorizontalAlign.Start).layoutWeight(1)
          Text(item.emoji).fontSize(46)
        }
        .width('100%').height('100%').padding({ left: 20, right: 20 })
        .backgroundColor(item.bgColor).borderRadius(16)
      }, (item: BannerItem) => item.id.toString())
    }
    .autoPlay(true).interval(3000).loop(true).height(140)// 自动播放、间隔3秒、循环
    .margin({ left: 16, right: 16, top: 16 }).clip(true)// clip 防止圆角被里面的内容覆盖
  }
  // 底部 Tab 按钮模板
  @Builder
  TabBuilder(index: number) {
    Column() {
      // 三元表达式
      Text(this.tabs[index].icon).fontSize(22).opacity(this.currentTab === index ? 1 : 0.4)
      Text(this.tabs[index].name).fontSize(12)
        .fontColor(this.currentTab === index ? '#FF8C42' : '#999999').margin({ top: 4 })
    }
    .width('100%').height(50).justifyContent(FlexAlign.Center)
  }
  // “我的”页面里的列表项模板
  @Builder
  SettingItem(icon: string, text: string) {
    Row() {
      Text(icon).fontSize(22).margin({ right: 16 })
      Text(text).fontSize(16).fontColor('#333').fontWeight(FontWeight.Medium)
      Blank()
      Text('>').fontSize(16).fontColor('#CCCCCC').fontWeight(FontWeight.Bold)
    }
    .width('100%').padding({ top: 18, bottom: 18, left: 20, right: 20 })
    .onClick(() => promptAction.showToast({ message: `点击了 ${text}` }))
  }
}