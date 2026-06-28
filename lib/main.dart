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
      title: "VangtiChai",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class AppSizes {
  static const double padding = 16.0;
  static const double fontSize = 18.0;
  static const double buttonSize = 60.0;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // Current entered amount
  int amount = 0;


  // Available notes
  final List<int> notes = [500, 100, 50, 20, 10, 5, 2, 1];


  // Stores answer
  Map<int, int> change = {};


  // Add pressed digit
  void addDigit(int digit) {
    setState(() {
      if (amount < 1000000) {
        amount = (amount * 10) + digit;
        calculateChange();
      }
    });
  }


  // Remove last digit
  void backspace() {
    setState(() {
      amount = amount ~/ 10;
      calculateChange();
    });
  }


  // Clear everything
  void clearAmount() {
    setState(() {
      amount = 0;
      change.clear();
    });
  }


  // Calculate notes
  void calculateChange() {
    change.clear();
    int remaining = amount;
    for (int note in notes) {
      change[note] = remaining ~/ note;
      remaining = remaining % note;
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenHeight / (isPortrait ? 12 : 9);

    return Scaffold(
      appBar: AppBar(
        title: const Text("VangtiChai"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              // ---------------- PORTRAIT ----------------
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const Text(
                          "Taka : ",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          amount.toString(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: buildChangeTable(isPortrait),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: buildKeypad(buttonHeight),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            // ---------------- LANDSCAPE ----------------
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Text(
                              "Taka : ",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              amount.toString(),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: buildChangeTable(isPortrait),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: buildKeypad(buttonHeight),
                ),
              ],
            );
          },
        ),
      ),
    );
  }


  Widget buildChangeTable(bool isPortrait) {
    if (isPortrait) {
      return buildSingleTable(notes);
    } else {
      return Row(
        children: [
          Expanded(
            child: buildSingleTable(notes.sublist(0, 4)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: buildSingleTable(notes.sublist(4)),
          ),
        ],
      );
    }
  }

  Widget buildSingleTable(List<int> noteList) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade400,
      ),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
          ),
          children: const [
            Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                "Note",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                "Count",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        for (int note in noteList)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "$note",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "${change[note] ?? 0}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }


  // keypad
  Widget buildKeypad(double buttonHeight) {
    List<Widget> rows = [];
    List<List<String>> keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['0', 'CLEAR']
    ];

    for (var row in keys) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: row.map((key) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () {
                if (key == 'CLEAR') {
                  clearAmount();
                } else {
                  addDigit(int.parse(key));
                }
              },
              style: key == 'CLEAR'
                  ? ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 80),
                    )
                  : ElevatedButton.styleFrom(
                      minimumSize: Size(AppSizes.buttonSize, buttonHeight),
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
              child: Text(
                key,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: key == 'CLEAR' ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
  }
}
