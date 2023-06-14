import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        secondaryHeaderColor: Colors.redAccent,
        fontFamily: 'Inter',
      ),
      title: "Unit Converter",
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _measures = [
    "Metres",
    "Kilometres",
    "Grams",
    "Kilograms",
    "Feet",
    "Miles",
    "Pounds",
    "Ounces"
  ];

  double _value = 0;
  String fromMeasure = "Metres";
  String toMeasure = "Kilometres";
  String result = "";

  final Map<String, int> _measuresMap = {
    "Metres": 0,
    "Kilometres": 1,
    "Grams": 2,
    "Kilograms": 3,
    "Feet": 4,
    "Miles": 5,
    "Pounds": 6,
    "Ounces": 7
  };

  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: const Text(
          "Unit Converter",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter the value",
                label: Text(
                  "Value",
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).secondaryHeaderColor,
              onChanged: (value) {
                try {
                  _value = double.parse(value);
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text(
                              "Error",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              "Please enter a number.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                              ),
                            ],
                          ));
                }
              },
            ),
            const SizedBox(
              height: 25,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                hintText: "Choose an unit",
                label: Text(
                  "From",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              items: _measures
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  fromMeasure = value.toString();
                });
              },
              value: fromMeasure,
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_downward,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: convert,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                hintText: "Choose an unit",
                label: Text(
                  "To",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              items: _measures
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  toMeasure = value.toString();
                });
              },
              value: toMeasure,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              result,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void convert() {
    if (_value != 0 && fromMeasure.isNotEmpty && toMeasure.isNotEmpty) {
      int? from = _measuresMap[fromMeasure];
      int? to = _measuresMap[toMeasure];

      var multiplier = _formulas[from.toString()][to];

      setState(() {
        result = "$_value $fromMeasure  = ${_value * multiplier} $toMeasure";
      });
    } else {
      setState(() {
        result = "Enter a non-zero value.";
      });
    }
  }
}
