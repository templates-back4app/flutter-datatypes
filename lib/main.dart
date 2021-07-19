import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = 'YOUR_APP_ID_HERE';
  final keyClientKey = 'YOUR_CLIENT_KEY_HERE';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String objectId = '';

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Parse Data Types"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  child: Image.network(
                      'https://blog.back4app.com/wp-content/uploads/2017/11/logo-b4a-1-768x175-1.png'),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(onPressed: doSaveData, child: Text('Save Data')),
                ElevatedButton(onPressed: doReadData, child: Text('Read Data')),
                ElevatedButton(
                    onPressed: doUpdateData, child: Text('Update Data'))
              ],
            ),
          ),
        ));
  }

  void doSaveData() async {
    var parseObject = ParseObject("DataTypes")
      ..set("stringField", "String")
      ..set("doubleField", 1.5)
      ..set("intField", 2)
      ..set("boolField", true)
      ..set("dateField", DateTime.now())
      ..set("jsonField", {"field1": "value1", "field2": "value2"})
      ..set("listStringField", ["a", "b", "c", "d"])
      ..set("listIntField", [0, 1, 2, 3, 4])
      ..set("listBoolField", [false, true, false])
      ..set("listJsonField", [
        {"field1": "value1", "field2": "value2"},
        {"field1": "value1", "field2": "value2"}
      ]);

    final ParseResponse parseResponse = await parseObject.save();

    if (parseResponse.success) {
      objectId = (parseResponse.results!.first as ParseObject).objectId!;
      showMessage('Object created: $objectId');
    } else {
      showMessage(
          'Object created with failed: ${parseResponse.error.toString()}');
    }
  }

  void doReadData() async {
    if (objectId.isEmpty) {
      showMessage('None objectId. Click button Save Date before.');
      return;
    }

    QueryBuilder<ParseObject> queryUsers =
        QueryBuilder<ParseObject>(ParseObject('DataTypes'))
          ..whereEqualTo('objectId', objectId);
    final ParseResponse parseResponse = await queryUsers.query();
    if (parseResponse.success && parseResponse.results != null) {
      final object = (parseResponse.results!.first) as ParseObject;
      print('stringField: ${object.get<String>('stringField')}');
      print('stringField: ${object.get<String>('stringField')}');
      print('doubleField: ${object.get<double>('doubleField')}');
      print('intField: ${object.get<int>('intField')}');
      print('boolField: ${object.get<bool>('boolField')}');
      print('dateField: ${object.get<DateTime>('dateField')}');
      print('jsonField: ${object.get<Map<String, dynamic>>('jsonField')}');
      print('listStringField: ${object.get<List>('listStringField')}');
      print('listNumberField: ${object.get<List>('listNumberField')}');
      print('listIntField: ${object.get<List>('listIntField')}');
      print('listBoolField: ${object.get<List>('listBoolField')}');
      print('listJsonField: ${object.get<List>('listJsonField')}');
    }
  }

  void doUpdateData() async {
    if (objectId.isEmpty) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text('None objectId. Click Save before.')));
      return;
    }

    final parseObject = ParseObject("DataTypes")
      ..objectId = objectId
      ..set("intField", 3)
      ..set("listStringField", ["a", "b", "c", "d", "e"]);

    final ParseResponse parseResponse = await parseObject.save();

    if (parseResponse.success) {
      showMessage('Object updated: $objectId');
    } else {
      showMessage(
          'Object updated with failed: ${parseResponse.error.toString()}');
    }
  }
}
