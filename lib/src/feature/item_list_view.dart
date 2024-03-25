import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'item.dart';
import 'item_details_view.dart';

/// 创建动态列表类实现itemList的展示
class AnimatedListRoute extends StatefulWidget {
  const AnimatedListRoute({super.key});
  static const routeName = '/';
  @override
  // ignore: library_private_types_in_public_api
  _AnimatedListRouteState createState() => _AnimatedListRouteState();
}

class _AnimatedListRouteState extends State<AnimatedListRoute> {
  final globalKey = GlobalKey<AnimatedListState>();

  final List<Item> items = [
    const Item(1, "啊——麦克风测试，麦克风测试！", "粉_B02_A01_铃羽_微笑.png"),
    const Item(2, "这个声音是，铃……小姐？", "粉_B01_A01_心弥_平常.png"),
    const Item(
        3, "线路接上了，把竹内绚音的数据转移出来需要3分钟，你们的通话时间也只有这么长。", "粉_B01_A01_心弥_平常.png")
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
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
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
              child: buildItem(context, index), //构建列表项
            );
          },
        ),
        floatingActionButton: buildAddBtn() //添加item
        );
  }

  // 创建一个 “+” 按钮，点击后会向列表中插入一项
  Widget buildAddBtn() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          items.add(
            Item(++counter, "这个声音是，铃……小姐？", "粉_B01_A01_心弥_平常.png"),
          );
          // 告诉列表项有新添加的列表项
          globalKey.currentState!.insertItem(items.length - 1);
        },
      ),
    );
  }

  // 列表项内容的构建实现
  Widget buildItem(context, index) {
    final item = items[index];
    return ListTile(
      key: ValueKey(index),
      title: Text(item.text),
      leading: CircleAvatar(
        // 文本头像
        foregroundImage: AssetImage('assets/images/${item.icon}'),
      ),
      onTap: () {
        Navigator.restorablePushNamed(
          context,
          ItemDetailsView.routeName,
        );
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete(context, index), // 点击时删除
      ),
    );
  }

  void onDelete(context, index) {
    globalKey.currentState!.removeItem(
      index,
      (context, animation) {
        // 删除过程执行的是反向动画，animation.value 会从1变为0
        var item = buildItem(context, index);
        items.removeAt(index);
        // 删除动画是一个合成动画：渐隐 + 收缩列表项
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            //让透明度变化的更快一些
            curve: const Interval(0.5, 1.0),
          ),
          // 不断缩小列表项的高度
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0.0,
            child: item,
          ),
        );
      },
      duration: const Duration(milliseconds: 200), // 动画时间为 200 ms
    );
  }
}
