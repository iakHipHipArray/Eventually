import 'package:EVENTually/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text('EVENTually'),
              ],
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(filled: true, labelText: 'Title'),
            ),
            SizedBox(
              height: 30.0,
            ),
            TextField(
              controller: _summaryController,
              decoration:
                  InputDecoration(filled: true, labelText: 'Description'),
            ),
            SizedBox(
              height: 30.0,
            ),
            MultiSelect(
              autovalidate: false,
              titleText: 'Add Friends',
              validator: (value) {
                if (value == null) {
                  return 'Please select one or more friends(s)';
                }
              },
              errorText: 'Please select one or more friends(s)',
              dataSource: [
                {
                  "display": "Ryan",
                  "value": 1,
                },
                {
                  "display": "Robin",
                  "value": 2,
                },
                {
                  "display": "Narae",
                  "value": 3,
                },
                {
                  "display": "Inshirah",
                  "value": 4,
                }
              ],
              textField: 'display',
              valueField: 'value',
              filterable: true,
              required: true,
              value: null,
            ),
            SizedBox(
              height: 15.0,
            ),
            MaterialButton(
                color: Colors.deepOrangeAccent,
                onPressed: () async {
                  final List<DateTime> picked =
                      await DateRangePicker.showDatePicker(
                          context: context,
                          // initialFirstDate: new DateTime.now(),
                          // initialLastDate:
                          //     (new DateTime.now()).add(new Duration(days: 7)),
                          firstDate: new DateTime(2015),
                          lastDate: new DateTime(2020));
                  if (picked != null && picked.length == 2) {
                    print(picked);
                  }
                },
                child: new Text("Pick date range")),
            // Text(
            //     _dateTime == null ? 'No dates selected' : _dateTime.toString()),
            // RaisedButton(
            //   child: Text('Pick a date'),
            //   onPressed: () {
            //     DateRangePicker.showDatePicker(
            //             context: context,
            //             initialFirstDate: DateTime.now(),
            //             firstDate: DateTime(2020),
            //             lastDate: DateTime(2030))
            //         .then((date) {
            //       setState(() {
            //         _dateTime = date;
            //       });
            //     });
            //   },
            // ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _titleController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('CREATE'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MyHomePage();
                    }));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
