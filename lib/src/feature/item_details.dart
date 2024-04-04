import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart';
import 'item.dart';

class ItemDetails extends StatefulWidget {
  final Item item;
  const ItemDetails({super.key, required this.item});
  static const routeName = '/item';
  @override
  State<ItemDetails> createState() => _ItemDetailsCfg();
}

class _ItemDetailsCfg extends State<ItemDetails> {
  late final Item _item;
  _ItemDetailsCfg();

  @override
  void initState() {
    super.initState();
    _item = widget.item; // 获取传递的item对象
    // 初始化时尝试从文件加载配置
    _loadConfig();
  }

  bool isShine = false; // 用于判断是否显示屏闪输入框
  int isExpand = -1; // 用于互斥展开折叠

  Future<void> _loadConfig() async {
    // 从本地存储或其他持久化位置加载配置
    // final savedConfig = await loadFromFileSystem();
    // setState(() {
    //   _configuration = savedConfig ?? UserConfiguration.defaultConfig();
    // });
  }

  // ...其他方法，如保存配置到文件系统
  Future<void> _saveConfig() async {
    // 将_configuration保存到指定目录下
    // await saveToFileSystem(_configuration);
  }

  // 触发方式决策
  // ignore: non_constant_identifier_names
  Widget _IsClick(Item item) {
    return CupertinoSlidingSegmentedControl(
        //子标签
        children: const <bool, Widget>{
          true: Row(children: [Icon(Icons.ads_click_rounded), Text("点击触发")]),
          false:
              Row(children: [Icon(Icons.autofps_select_rounded), Text("无条件触发")])
        },
        //当前选中的索引
        groupValue: item.isClick,
        //点击回调
        onValueChanged: (bool? index) {
          setState(() {
            item.isClick = index!;
          });
        });
  }

  // 串并行决策
  // ignore: non_constant_identifier_names
  Widget _CtlStream(Item item) {
    return CupertinoSlidingSegmentedControl(
        //子标签
        children: const <bool, Widget>{
          false: Row(children: [Icon(Icons.line_axis_rounded), Text("并行")]),
          true: Row(children: [Icon(Icons.linear_scale_rounded), Text("串行")])
        },
        //当前选中的索引
        groupValue: item.ctlStream,
        //点击回调
        onValueChanged: (bool? index) {
          setState(() {
            item.ctlStream = index!;
          });
        });
  }

  // 标志选择
  // ignore: non_constant_identifier_names
  Widget _TagSelected(Item item) {
    List<Tuple2<String, Widget>> tags = const [
      Tuple2("文本", Icon(Icons.text_snippet_outlined)),
      Tuple2("镜头", Icon(Icons.camera_indoor_outlined)),
      Tuple2("滤镜", Icon(Icons.screenshot_monitor_rounded)),
      Tuple2("立绘", Icon(Icons.person_pin)),
      Tuple2("图片", Icon(Icons.image)),
      Tuple2("UI", Icon(Icons.app_registration_rounded)),
      Tuple2("背景", Icon(Icons.imagesearch_roller_outlined)),
      Tuple2("BGM", Icon(Icons.music_note_rounded)),
      Tuple2("SE", Icon(Icons.library_music_outlined)),
      Tuple2("程序", Icon(Icons.code_rounded)),
      Tuple2("特殊", Icon(Icons.new_releases_outlined)),
    ];

    return SizedBox(
        height: 400, // 限定高度
        child: ListView(
          shrinkWrap: true, // 防止超出屏幕高度
          children: tags.map((option) {
            return RadioListTile<String>(
              title: Row(children: [option.item2, Text(option.item1)]),
              value: option.item1,
              groupValue: item.tag,
              onChanged: (value) {
                setState(() {
                  item.tag = value!;
                });
              },
            );
          }).toList(),
        ));
  }

  // 文本设置
  Widget textSetting(Item item) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 使两端对齐
        children: [
          Column(
            children: [
              Text(
                item.icon,
                style: const TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              const SizedBox(height: 15),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/${item.icon}'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(4), // 可选，添加圆角
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final selectedAvatar = await showAvatarPickerDialog(context);
                  if (selectedAvatar != null) {
                    setState(() {
                      item.icon = selectedAvatar;
                    });
                  }
                },
                child: const Text('更换头像'),
              ),
            ],
          ),
          const SizedBox(width: 100), // 添加间距
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("文本框样式"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: // 为了让DropdownButtonFormField自动调整宽度
                          DropdownButton<String>(
                        value: item.textStyle,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            item.textStyle = value!;
                          });
                        },
                        items: const ['旁白', '台词', '头像']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(), // 下拉菜单项
                      ),
                    ),
                    const SizedBox(width: 100),
                    const Text("角色名"),
                    const SizedBox(width: 20),
                    Expanded(
                        child: TextFormField(
                      initialValue: item.textRole,
                      onChanged: (textRole) {
                        setState(() {
                          item.textRole = textRole;
                        });
                      },
                      // enabled: false, // 若为只读文本框，禁用编辑
                    )),
                  ],
                ),
                const SizedBox(height: 60),
                Row(children: [
                  Expanded(
                      child: Column(children: [
                    TextField(
                      maxLines: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*$'))
                      ], // 仅允许数字输入
                      keyboardType: TextInputType.number, // 显示数字键盘
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '每秒弹出的字数 (限整数)',
                        labelText: '弹字速度',
                      ),
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: '${item.textSpeed}',
                              selection: TextSelection.collapsed(
                                  offset: '${item.textSpeed}'.length))),
                      onChanged: (value) {
                        setState(() {
                          item.textSpeed = int.tryParse(value)!;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    TextField(
                        maxLines: 1, // 设置最小行数
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*$'))
                        ], // 仅允许数字输入
                        keyboardType: TextInputType.number, // 显示数字键盘
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '文本字号大小(1-100)',
                          labelText: '字号大小',
                        ),
                        controller: TextEditingController.fromValue(
                            TextEditingValue(
                                text: '${item.textFontSize}',
                                selection: TextSelection.collapsed(
                                    offset: '${item.textFontSize}'.length))),
                        onChanged: (value) {
                          setState(() {
                            item.textFontSize = int.tryParse(value)!;
                          });
                        }),
                  ])),
                  const SizedBox(width: 30),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSliderRow(item.textP, 0, '初始不透明度', 0, 1.0),
                      const SizedBox(height: 3),
                      _buildSliderRow(item.textP, 1, '结束不透明度', 0, 1.0),
                      const SizedBox(height: 3),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("变化时间 (秒)"),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                initialValue: '${item.textTime}',
                                onChanged: (textTime) {
                                  setState(() {
                                    item.textTime = double.parse(textTime);
                                  });
                                },
                              ),
                            )
                          ])
                    ],
                  )),
                ])
              ],
            ),
          )
        ],
      ),
      const SizedBox(height: 18),
      TextField(
        maxLines: 4, // 自动适应多行
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: '键入文本内容',
          labelText: '输入文本',
        ),
        controller: TextEditingController.fromValue(TextEditingValue(
            text: item.text,
            selection: TextSelection.collapsed(offset: item.text.length))),
        onChanged: (value) {
          setState(() {
            item.text = value;
          });
        },
      ),
    ]);
  }

  // 头像预览弹窗
  Future<String?> showAvatarPickerDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('选择头像'),
          children: [
            "粉_B01_A01_心弥_平常.png",
            "粉_B02_A01_铃羽_微笑.png",
            "flutter_logo.png"
          ].map((avatarName) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, avatarName),
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/$avatarName'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(4), // 可选，添加圆角使其看起来更美观
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // 透明度变化条
  Widget _buildSliderRow(
      List<double> values, int key, String label, double min, double max) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Expanded(
          child: Slider(
            value: values[key],
            min: min,
            max: max,
            onChanged: (newValue) {
              setState(() {
                values[key] = newValue;
                // 特殊要求: 若只调节A，则 B=A
                if (key == 0) values[key + 1] = newValue;
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),
        ),
        Text(values[key].toStringAsFixed(2)),
      ],
    );
  }

  // 镜头设置
  Widget cameraSetting(Item item) {
    List<String> cama = [
      "镜头抖动",
      "镜头持续抖动",
      "恢复正常",
      "花屏",
      "屏幕闪白",
      "闪白恢复",
      "闭眼效果",
      "睁眼效果"
    ];
    if (item.camera == "屏幕闪白" || item.camera == "闪白恢复") {
      isShine = true;
    } else {
      isShine = false;
    }
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Column(children: [
              SizedBox(
                  height: 300, // 让SizedBox尽可能扩展高度
                  child: ListView(
                    shrinkWrap: true, // 防止超出屏幕高度
                    // physics: const NeverScrollableScrollPhysics(), // 防止与Column产生滚动冲突
                    children: cama.map((option) {
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: item.camera,
                        onChanged: (value) {
                          setState(() {
                            item.camera = value!;
                            if (item.camera == "屏幕闪白" ||
                                item.camera == "闪白恢复") {
                              isShine = true;
                            } else {
                              isShine = false;
                            }
                          });
                        },
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 10),
              Visibility(
                visible: isShine,
                child: TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: '${item.camera}持续时间',
                  ),
                  controller: TextEditingController(text: '${item.shine}'),
                  onChanged: (value) {
                    setState(() {
                      item.shine = double.tryParse(value)!;
                    });
                  },
                ),
              )
            ])),
        const SizedBox(width: 60),
        Expanded(
            flex: 4,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 图片部分
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const Image(
                        image: AssetImage('assets/images/章节过渡.png'),
                        fit: BoxFit.cover,
                        height: 300,
                      ),
                    ),
                    // 标题部分
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                      child: Text(
                        '预览效果',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 描述部分
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                      child: Text(
                        item.camera,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  // 滤镜设置
  Widget filterSetting(Item item) {
    List<String> fit = [
      "无滤镜",
      "回忆滤镜",
      "条纹滤镜",
      "灰色雪花屏",
      "冷色调花屏",
    ];
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Column(children: [
              SizedBox(
                  height: 300, // 让SizedBox尽可能扩展高度
                  child: ListView(
                    shrinkWrap: true, // 防止超出屏幕高度
                    // physics: const NeverScrollableScrollPhysics(), // 防止与Column产生滚动冲突
                    children: fit.map((option) {
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: item.filter,
                        onChanged: (value) {
                          setState(() {
                            item.filter = value!;
                          });
                        },
                      );
                    }).toList(),
                  )),
            ])),
        const SizedBox(width: 60),
        Expanded(
            flex: 4,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 图片部分
                    Stack(alignment: Alignment.center, children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3.0),
                        child: const Image(
                          image: AssetImage('assets/images/公园里的五十岚心弥.png'),
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.maxFinite,
                        ),
                      ),
                      Opacity(
                        opacity: 0.4, // 控制滤镜图片的透明度
                        child: Image(
                          image: AssetImage('assets/images/${item.filter}.png'),
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.maxFinite,
                        ),
                      ),
                    ]),
                    // 标题部分
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                      child: Text(
                        '预览效果',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // 描述部分
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                      child: Text(
                        item.filter,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  // 立绘设置
  Widget liveSetting(Item item) {
    List<Widget> expansionLst = [
      ExpansionTile(
        leading: const Icon(Icons.change_circle_rounded),
        title: const Text('名字空间'),
        initiallyExpanded: true, // 初始状态是否展开
        onExpansionChanged: (expanded) {},
        children: item.liveCache.map((live) {
          return Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0), // 在每一行之间添加底部间距
              child: Row(children: [
                const Icon(Icons.boy_sharp),
                const SizedBox(width: 20),
                Expanded(
                    flex: 1,
                    child: TextField(
                      maxLines: 1,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '为名字空间编写简记名称',
                        labelText: '简记名称',
                      ),
                      controller: TextEditingController(text: live['nike']),
                      onChanged: (value) {
                        setState(() {
                          live['nike'] = value;
                        });
                      },
                    )),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: Text(live['path']!)),
                const SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: const Text("选中"),
                      onPressed: () {
                        setState(() {
                          item.livePath = live['path']!;
                          item.liveName = live['nike']!;
                          item.liveState = "选中图片";
                        });
                      },
                    )),
                const SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: const Text("换图"),
                      onPressed: () {
                        // 弹窗切换选择。待实现
                      },
                    )),
              ]));
        }).toList(),
      ),
      ExpansionTile(
        leading: const Icon(Icons.scale_outlined),
        title: const Text('缩放选项'),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {},
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("缩放时间 (秒)"),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                initialValue: '${item.liveScaleTime}',
                onChanged: (liveScaleTime) {
                  setState(() {
                    item.liveScaleTime = double.parse(liveScaleTime);
                  });
                },
              ),
            )
          ]),
          const SizedBox(height: 3),
          _buildSliderRow(item.liveScale, 0, '初始缩放', 0, 3.0),
          const SizedBox(height: 3),
          _buildSliderRow(item.liveScale, 1, '结束缩放', 0, 3.0),
          const SizedBox(height: 5),
        ],
      ),
      ExpansionTile(
        leading: const Icon(Icons.move_up_outlined),
        title: const Text('移动选项'),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {},
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("移动时间 (秒)"),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                initialValue: '${item.liveMoveTime}',
                onChanged: (liveMoveTime) {
                  setState(() {
                    item.liveMoveTime = double.parse(liveMoveTime);
                  });
                },
              ),
            )
          ]),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("起始坐标：    ("),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveMove[0]}',
                onChanged: (value) {
                  setState(() {
                    item.liveMove[0] = double.parse(value);
                  });
                },
              ),
            ),
            const Text(", "),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveMove[1]}',
                onChanged: (value) {
                  setState(() {
                    item.liveMove[1] = double.parse(value);
                  });
                },
              ),
            ),
            const Text(")"),
            const SizedBox(width: 40),
            const Text("结束坐标：    ("),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveMove[2]}',
                onChanged: (value) {
                  setState(() {
                    item.liveMove[2] = double.parse(value);
                  });
                },
              ),
            ),
            const Text(", "),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveMove[3]}',
                onChanged: (value) {
                  setState(() {
                    item.liveMove[3] = double.parse(value);
                  });
                },
              ),
            ),
            const Text(")"),
          ]),
          const SizedBox(height: 40),
        ],
      ),
      ExpansionTile(
        leading: const Icon(Icons.preview_outlined),
        title: const Text('透明度变化'),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {},
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("变化时间 (秒)"),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                initialValue: '${item.textTime}',
                onChanged: (textTime) {
                  setState(() {
                    item.textTime = double.parse(textTime);
                  });
                },
              ),
            )
          ]),
          const SizedBox(height: 3),
          _buildSliderRow(item.textP, 0, '初始不透明度', 0, 1.0),
          const SizedBox(height: 3),
          _buildSliderRow(item.textP, 1, '结束不透明度', 0, 1.0),
          const SizedBox(height: 5),
        ],
      ),
      ExpansionTile(
        leading: const Icon(Icons.image_aspect_ratio_sharp),
        title: const Text('正片叠底'),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {},
        children: [
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("R："),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveRGB[0]}',
                onChanged: (value) {
                  setState(() {
                    item.liveRGB[0] = double.parse(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 40),
            const Text("G："),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveRGB[1]}',
                onChanged: (value) {
                  setState(() {
                    item.liveRGB[1] = double.parse(value);
                  });
                },
              ),
            ),
            const SizedBox(width: 40),
            const Text("B："),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveRGB[2]}',
                onChanged: (value) {
                  setState(() {
                    item.liveRGB[2] = double.parse(value);
                  });
                },
              ),
            ),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    ];

    return Row(
      children: [
        Flexible(
            flex: 1,
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CupertinoSlidingSegmentedControl(
                      //子标签
                      children: const <int, Widget>{
                        0: Text("无动作"),
                        1: Text("轻微抖动"),
                        2: Text("剧烈抖动"),
                      },
                      //当前选中的索引
                      groupValue: item.liveRock,
                      //点击回调
                      onValueChanged: (int? index) {
                        setState(() {
                          item.liveRock = index!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: Image(
                        image: AssetImage('assets/images/${item.livePath}'),
                        fit: BoxFit.cover,
                        height: 350,
                        // width: double.maxFinite,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                      child: Text(
                        item.livePath,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            child: IconButton(
                          onPressed: () async {
                            final selectedAvatar =
                                await showAvatarPickerDialog(context);
                            if (selectedAvatar != null) {
                              setState(() {
                                item.livePath = selectedAvatar;
                              });
                            }
                          },
                          icon: const Icon(Icons.add_box_outlined),
                        )),
                        Flexible(
                            child: IconButton(
                          onPressed: () async {
                            final selectedAvatar =
                                await showAvatarPickerDialog(context);
                            if (selectedAvatar != null) {
                              setState(() {
                                item.livePath = selectedAvatar;
                              });
                            }
                          },
                          icon: const Icon(Icons.delete),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(width: 60),
        Flexible(
            flex: 2,
            child: SizedBox(
                height: 400,
                child: CustomScrollView(slivers: [
                  SliverList(delegate: SliverChildListDelegate(expansionLst))
                ])))
      ],
    );
  }

  // 图片设置
  Widget picSetting(Item item) {
    List<Widget> expansionLst = [
      ExpansionTile(
        leading: const Icon(Icons.change_circle_rounded),
        title: const Text('名字空间'),
        initiallyExpanded: true, // 初始状态是否展开
        onExpansionChanged: (expanded) {},
        children: item.liveCache.map((live) {
          return Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0), // 在每一行之间添加底部间距
              child: Row(children: [
                const Icon(Icons.boy_sharp),
                const SizedBox(width: 20),
                Expanded(
                    flex: 1,
                    child: TextField(
                      maxLines: 1,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '为名字空间编写简记名称',
                        labelText: '简记名称',
                      ),
                      controller: TextEditingController(text: live['nike']),
                      onChanged: (value) {
                        setState(() {
                          live['nike'] = value;
                        });
                      },
                    )),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: Text(live['path']!)),
                const SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: const Text("选中"),
                      onPressed: () {
                        setState(() {
                          item.livePath = live['path']!;
                          item.liveName = live['nike']!;
                          item.liveState = "选中图片";
                        });
                      },
                    )),
                const SizedBox(width: 10),
                Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: const Text("换图"),
                      onPressed: () {
                        // 弹窗切换选择。待实现
                      },
                    )),
              ]));
        }).toList(),
      ),
      ExpansionTile(
        leading: const Icon(Icons.scale_outlined),
        title: const Text('缩放选项'),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {},
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("缩放时间 (秒)"),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                initialValue: '${item.liveScaleTime}',
                onChanged: (liveScaleTime) {
                  setState(() {
                    item.liveScaleTime = double.parse(liveScaleTime);
                  });
                },
              ),
            )
          ]),
          const SizedBox(height: 3),
          _buildSliderRow(item.liveScale, 0, '初始缩放', 0, 3.0),
          const SizedBox(height: 3),
          _buildSliderRow(item.liveScale, 1, '结束缩放', 0, 3.0),
          const SizedBox(height: 5),
        ],
      ),
      ExpansionTile(
        leading: const Icon(Icons.move_up_outlined),
        title: const Text('移动选项'),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {},
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("移动时间 (秒)"),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                initialValue: '${item.liveMoveTime}',
                onChanged: (liveMoveTime) {
                  setState(() {
                    item.liveMoveTime = double.parse(liveMoveTime);
                  });
                },
              ),
            )
          ]),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("起始坐标：    ("),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveMove[0]}',
                onChanged: (value) {
                  setState(() {
                    item.liveMove[0] = double.parse(value);
                  });
                },
              ),
            ),
            const Text(", "),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveMove[1]}',
                onChanged: (value) {
                  setState(() {
                    item.liveMove[1] = double.parse(value);
                  });
                },
              ),
            ),
            const Text(")"),
            const SizedBox(width: 40),
            const Text("结束坐标：    ("),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveMove[2]}',
                onChanged: (value) {
                  setState(() {
                    item.liveMove[2] = double.parse(value);
                  });
                },
              ),
            ),
            const Text(", "),
            Expanded(
              flex: 1,
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: '${item.liveMove[3]}',
                onChanged: (value) {
                  setState(() {
                    item.liveMove[3] = double.parse(value);
                  });
                },
              ),
            ),
            const Text(")"),
          ]),
          const SizedBox(height: 40),
        ],
      ),
      ExpansionTile(
        leading: const Icon(Icons.preview_outlined),
        title: const Text('透明度变化'),
        initiallyExpanded: false,
        onExpansionChanged: (expanded) {},
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("变化时间 (秒)"),
            const SizedBox(width: 20),
            Expanded(
              child: TextFormField(
                initialValue: '${item.textTime}',
                onChanged: (textTime) {
                  setState(() {
                    item.textTime = double.parse(textTime);
                  });
                },
              ),
            )
          ]),
          const SizedBox(height: 3),
          _buildSliderRow(item.textP, 0, '初始不透明度', 0, 1.0),
          const SizedBox(height: 3),
          _buildSliderRow(item.textP, 1, '结束不透明度', 0, 1.0),
          const SizedBox(height: 5),
        ],
      ),
    ];

    return Row(
      children: [
        Flexible(
            flex: 1,
            child: SizedBox(
                height: 400,
                child: CustomScrollView(slivers: [
                  SliverList(delegate: SliverChildListDelegate(expansionLst))
                ]))),
        const SizedBox(width: 60),
        Flexible(
            flex: 1,
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.change_circle_rounded),
                        SizedBox(width: 20),
                        Text('名字空间'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: item.liveCache.map((live) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10.0), // 在每一行之间添加底部间距
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                ListTile(
                                  title: Text(item.liveName),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(3.0),
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/公园里的五十岚心弥.png'),
                                      fit: BoxFit.cover,
                                      height: 200,
                                      // width: double.maxFinite,
                                    ),
                                  ),
                                  onTap: () {},
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => {}, // 点击时删除
                                  ),
                                ),
                              ],
                            ));
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            child: IconButton(
                          onPressed: () async {
                            final selectedAvatar =
                                await showAvatarPickerDialog(context);
                            if (selectedAvatar != null) {
                              setState(() {
                                item.livePath = selectedAvatar;
                              });
                            }
                          },
                          icon: const Icon(Icons.add_box_outlined),
                        )),
                        Flexible(
                            child: IconButton(
                          onPressed: () async {
                            final selectedAvatar =
                                await showAvatarPickerDialog(context);
                            if (selectedAvatar != null) {
                              setState(() {
                                item.livePath = selectedAvatar;
                              });
                            }
                          },
                          icon: const Icon(Icons.web),
                        )),
                        Flexible(
                            child: IconButton(
                          onPressed: () async {
                            final selectedAvatar =
                                await showAvatarPickerDialog(context);
                            if (selectedAvatar != null) {
                              setState(() {
                                item.livePath = selectedAvatar;
                              });
                            }
                          },
                          icon: const Icon(Icons.play_circle),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  // 总界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('本行详情'),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 左侧全局设置
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Flexible(
                          child: Column(children: [
                        _TagSelected(_item),
                        const SizedBox(height: 10),
                        _CtlStream(_item),
                        const SizedBox(height: 10),
                        _IsClick(_item),
                      ]))),
                ),
              ),

              // 右侧详细配置
              Expanded(
                flex: 3, // 按照1:3的比例分配宽度
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: switchPage(_item), //Text("???"), //
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25), // 添加间距

          // 代码段显示
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                maxLines: null, // 自动适应多行
                readOnly: true,
                showCursor: false, // 隐藏光标
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Sample code snippet',
                  labelText: 'Line Code Preview',
                ),
                controller: TextEditingController(text: _item.code),
              ),
            ),
          ),

          // 音乐预览，这里仅作示意，实际可能需要使用audio_service等包来处理音频播放
          // RaisedButton(
          //   onPressed: () {
          //     // playMusic(_configuration.musicUrl);
          //   },
          //   child: const Text('播放音乐'),
          // ),
          // 其他设置项...
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveConfig,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget switchPage(Item item) {
    switch (item.tag) {
      case "文本":
        return textSetting(item);
      case "镜头":
        return cameraSetting(item);
      case "滤镜":
        return filterSetting(item);
      case "立绘":
        return liveSetting(item);
      case "图片":
        return picSetting(item);
      default:
        return textSetting(item);
    }
  }
}
