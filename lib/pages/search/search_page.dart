import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  String? _city;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void _submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      Navigator.of(context).pop(_city!.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Form(
            key: _formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              children: [
                const SizedBox(height: 60.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    initialValue: 'beijing',
                    autofocus: true,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: const InputDecoration(
                      labelText: '城市名称',
                      hintText: '请输入城市名称',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? input) {
                      if (input == null || input.trim().length < 2) {
                        return '城市名称不能少于两个字符';
                      }
                      return null;
                    },
                    onSaved: (String? input) {
                      _city = input;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text(
                    "查找天气",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ],
            )));
  }
}
