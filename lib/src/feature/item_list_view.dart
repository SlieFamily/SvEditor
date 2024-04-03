import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

import '../settings/settings_view.dart';
import '../utils/main_view_tools.dart';
import 'item.dart';
// import 'item_details_view.dart';

/// 创建动态列表类实现itemList的展示
class AnimatedListRoute extends StatefulWidget {
  const AnimatedListRoute({super.key});
  static const routeName = '/';
  @override
  State<AnimatedListRoute> createState() => _AnimatedListRouteState();
}

class _AnimatedListRouteState extends State<AnimatedListRoute> {
  final globalKey = GlobalKey<AnimatedListState>();

  final List<Item> items = [
    Item.withParam(
        id: 1, text: "啊——麦克风测试，麦克风测试！", icon: "粉_B02_A01_铃羽_微笑.png", tag: '程序'),
    Item.withParam(
        id: 2, text: "这个声音是，铃……小姐？", icon: "粉_B01_A01_心弥_平常.png", tag: '文本'),
    Item.withParam(
        id: 3,
        text: "线路接上了，把竹内绚音的数据转移出来需要3分钟，你们的通话时间也只有这么长。",
        icon: "粉_B01_A01_心弥_平常.png",
        tag: '文本')
  ];

  int counter = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('sv_11_01'), // 小节标题
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // 受理并载入设置界面
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: AnimatedList(
          key: globalKey,
          initialItemCount: items.length,
          itemBuilder: (
            BuildContext context,
            int index,
            Animation<double> animation,
          ) {
            return FadeTransition(
              opacity: animation, //添加列表项时会执行渐显动画
              child: buildItem(context, index, items, globalKey), //构建列表项
            );
          },
        ),
        floatingActionButton: buildAddBtn(items, counter, globalKey) //添加item的按钮
        );
  }
}
