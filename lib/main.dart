import 'dart:async';
import 'dart:convert';

import 'package:chuckapi/widgets/about.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:chuckapi/theme/theme_data.dart';
import 'package:chuckapi/config.dart';
import 'package:chuckapi/models/data_model.dart';
import 'package:chuckapi/pages/history_screen.dart';
import 'package:chuckapi/theme/theme.dart';
import 'package:chuckapi/models/joke_model.dart';

const String dataBoxName = "jokedata";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<DataModel>(dataBoxName);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  MyTheme.isDark = (prefs.getBool('isDark') ?? false);
  runApp(const MyHomePage());
}

Future<Joke> fetchJoke() async {
  final response = await http.get(
    Uri.parse('https://api.chucknorris.io/jokes/random'),
  );

  if (response.statusCode == 200) {
    return Joke.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Joke> futureAlbum;
  late Box<DataModel> dataBox;
  late String responseJoke = '';
  int pressedSaved = 0;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchJoke();
    currentTheme.addListener(() {
      setState(() {});
    });
    dataBox = Hive.box<DataModel>(dataBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChuckAPI',
        darkTheme: darkTheme(), // dark theme
        theme: lightTheme(), // light theme
        themeMode: currentTheme.currentTheme(),
        routes: {
          HistoryScreen.routeName: (context) => const HistoryScreen(),
        },
        home: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: MyTheme.isDark
                ? darkDynamic?.background
                : lightDynamic?.background ?? Colors.amber,
            appBar: AppBar(
              elevation: 2,
              backgroundColor: MyTheme.isDark
                  ? darkDynamic?.background
                  : lightDynamic?.background ?? Colors.teal,
              title: const Text('ChuckAPI'),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () {
                      aboutTab(
                        context,
                        lightDynamic,
                        darkDynamic,
                      );
                    },
                    icon: const Icon(Icons.info_outline_rounded),
                    tooltip: 'About',
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    currentTheme.switchTheme(prefs);
                  },
                  icon: const Icon(Icons.dark_mode),
                  tooltip: 'Dark Mode',
                ),
              ],
            ),
            body: SafeArea(
              child: Column(children: [
                const Expanded(
                  child: SizedBox(),
                ),
                FutureBuilder<Joke>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      responseJoke = snapshot.data!.value;
                      return Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: GestureDetector(
                          child: Text(snapshot.data!.value),
                          onTap: () async {
                            await Clipboard.setData(
                                ClipboardData(text: snapshot.data!.value));
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Chuck is sleeping.. 😴');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 12.0,
                    ),
                    TextButton.icon(
                      label: Text(
                        'Saved Jokes',
                        style: TextStyle(
                            color: lightDynamic?.primary ?? Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(HistoryScreen.routeName);
                      },
                      icon: Icon(
                        Icons.save_alt_rounded,
                        color: lightDynamic?.primary ?? Colors.blue,
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    TextButton.icon(
                      label: Text(
                        'Save this Joke',
                        style: TextStyle(
                            color: lightDynamic?.primary ?? Colors.blue),
                      ),
                      onPressed: pressedSaved == 0
                          ? (() {
                              setState(() {
                                pressedSaved = 1;
                              });
                              DataModel data = DataModel(
                                joke: responseJoke,
                                isExpanded: false,
                              );
                              dataBox.add(data);
                            })
                          : null,
                      icon: Icon(
                        Icons.save_rounded,
                        color: lightDynamic?.primary ?? Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14.0,
                ),
              ]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                setState(() {
                  futureAlbum = fetchJoke();
                  pressedSaved = 0;
                });
              },
              tooltip: 'Next Joke',
              backgroundColor:
                  lightDynamic?.primary ?? ThemeData().primaryColor,
              child: const Icon(Icons.refresh_outlined),
            ),
          );
        }),
      );
    });
  }
}
