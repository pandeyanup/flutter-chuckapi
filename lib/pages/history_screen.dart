import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:chuckapi/models/data_model.dart';
import 'package:chuckapi/theme/theme.dart';

const String dataBoxName = "jokedata";

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static const routeName = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Box<DataModel> dataBox;
  int maxLines = 3;
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    dataBox = Hive.box<DataModel>(dataBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: MyTheme.isDark
                ? darkDynamic?.background
                : lightDynamic?.background ?? Colors.teal,
            title: const Text('Saved Jokes'),
          ),
          backgroundColor: MyTheme.isDark
              ? darkDynamic?.background
              : lightDynamic?.background ?? Theme.of(context).canvasColor,
          body: ValueListenableBuilder(
            valueListenable: dataBox.listenable(),
            builder: ((context, Box<DataModel> items, _) {
              List<int> keys;
              keys = items.keys.cast<int>().toList();
              return keys.isEmpty
                  ? const Center(
                      child: Text('No Data Available.'),
                    )
                  : ListView.separated(
                      separatorBuilder: (_, index) => const Divider(
                        thickness: 0,
                        height: 0,
                      ),
                      itemCount: keys.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        final int key = keys[index];
                        final DataModel data = items.get(key)!;
                        return Dismissible(
                          key: ValueKey(index),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) => showDialog(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  backgroundColor: MyTheme.isDark
                                      ? darkDynamic?.background
                                      : lightDynamic?.background ??
                                          Theme.of(context).canvasColor,
                                  content: const Text(
                                      'Are you sure you want to delete this Joke?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('No')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Delete'))
                                  ],
                                )),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              dataBox.delete(key);
                            });
                          },
                          child: GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                data.joke,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: data.isExpanded
                                    ? data.joke.length
                                    : maxLines,
                              ),
                            ),
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: data.joke));
                              if (!mounted) return;
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Joke Copied!!"),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: MyTheme.isDark
                                      ? darkDynamic?.primary
                                      : lightDynamic?.primary ??
                                          Colors.lightBlueAccent,
                                ),
                              );
                            },
                            onLongPress: () {
                              DataModel updatedData = data.isExpanded
                                  ? DataModel(
                                      joke: data.joke,
                                      isExpanded: false,
                                    )
                                  : DataModel(
                                      joke: data.joke,
                                      isExpanded: true,
                                    );
                              dataBox.put(key, updatedData);
                            },
                          ),
                        );
                      },
                    );
            }),
          ),
        );
      });
    });
  }
}
