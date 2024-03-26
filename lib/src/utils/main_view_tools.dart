import 'package:flutter/material.dart';
import 'dart:math';

import '../feature/item.dart';
import '../feature/item_details_view.dart';

// 创建一个 “+” 按钮，点击后会向列表中插入一项
Widget buildAddBtn(List<Item> items, int counter, globalKey) {
  return Positioned(
    bottom: 30,
    left: 0,
    right: 0,
    child: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        items.add(
          Item(++counter, "这个声音是，铃……小姐？", "粉_B01_A01_心弥_平常.png", ['文本']),
        );
        // 告诉列表项有新添加的列表项
        globalKey.currentState!.insertItem(items.length - 1);
      },
    ),
  );
}

// 列表项内容的构建实现
Widget buildItem(context, index, List<Item> items, globalKey) {
  final item = items[index];
  return ListTile(
    key: ValueKey(index),
    title: Text(
      item.text,
      style: const TextStyle(fontSize: 20),
    ),
    subtitle: colorTag(item.tagLst),
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
      onPressed: () => onDelete(context, index, items, globalKey), // 点击时删除
    ),
  );
}

// 彩色标签内容
Widget colorTag(List<String> tagLst) {
  final random = Random(100);
  return Wrap(
    spacing: 4.0, // 间距
    children: tagLst.map((tag) {
      return SizedBox(
        width: 60.0, // 自定义宽度
        height: 30.0, // 自定义高度
        child: Chip(
          label: Text(tag),
          backgroundColor: Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1,
          ),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    }).toList(),
  );
}

//删除列表项
void onDelete(context, index, List<Item> items, globalKey) {
  globalKey.currentState!.removeItem(
    index,
    (context, animation) {
      // 删除过程执行的是反向动画，animation.value 会从1变为0
      var item = buildItem(context, index, items, globalKey);
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
