import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _editingController = TextEditingController();
  bool isSuccess = false;
  String valueFromPlatform = '';

  final MethodChannel platformChannel = MethodChannel('dlg');

  void fetchDataFromNative() async {
    try {
      final String result = await platformChannel.invokeMethod('dlg_method', {'text': _editingController.text});
      setState(() {
        isSuccess = true;
        valueFromPlatform = result;
      });
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Integrations of Flutter'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _editingController,
                        style: TextStyle(
                            color: Colors.purple
                        ),
                        decoration: InputDecoration(
                            isDense: true,
                            labelStyle: TextStyle(
                                color: Colors.purple
                            ),
                            hintText: 'Введите значение',
                            suffixIcon: Icon(Icons.search),
                            suffixIconColor: Colors.purple,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.purple,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.purple,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          fetchDataFromNative();
                        },
                        child: Text('Отправить'),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                ),
                (isSuccess) ?
                  Text('Ответ от Platform: ${valueFromPlatform}')
                    :
                    Text('')
              ],
            ),
          )
        ),
      )
    );
  }
}
