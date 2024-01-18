import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  @override
  _CalculadoraScreenState createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String displayText = "";
  double num1 = 0.0;
  double num2 = 0.0;
  String operator = "OP";
  bool shouldClearDisplay = false;
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12.0),
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        num1.toString(),
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        operator,
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        num2.toString(),
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: Text(
                        "=",
                        style: TextStyle(fontSize: 24.0, color: Colors.lightBlue),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        result,
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buildRow(["7", "8", "9"]),
                    buildRow(["4", "5", "6"]),
                    buildRow(["1", "2", "3"]),
                    buildRow(["0", ".", "C"]),
                  ]
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buildButton("+"),
                    buildButton("-"),
                    buildButton("*"),
                    buildButton("/"),
                    buildButton("="),
                  ],
                ),
              ]

            ),
          ),
        ],
      ),
    );
  }


  Widget buildColumn(List<String> buttons) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return buildButton(button);
      }).toList(),
    );
  }
  Widget buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        return buildButton(button);
      }).toList(),
    );
  }

  Widget buildButton(String buttonText) {
    double buttonHeight = isNumber(buttonText) ? 10.0 : 1.0; // Ajusta la altura solo para los números
    double buttonFontSize = isSymbol(buttonText) ? 24.0 : 30.0; // Ajusta el tamaño de fuente según tus necesidades
    Color? buttonColor = isSymbol(buttonText) ? Colors.lightBlue : null;
    Color symbolTextColor = isSymbol(buttonText) ? Colors.black : Colors.lightBlue;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 130.0 * buttonHeight, // Ajusta la altura según tus preferencias
        ),
        child: TextButton(
          onPressed: () {
            onButtonPressed(buttonText);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            backgroundColor: buttonColor,
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: buttonFontSize, color: symbolTextColor),
          ),
        ),
      ),
    );
  }


  bool isNumber(String buttonText) {
    return buttonText == "0" || buttonText == "1" || buttonText == "2" || buttonText == "3" ||
        buttonText == "4" || buttonText == "5" || buttonText == "6" || buttonText == "7" ||
        buttonText == "8" || buttonText == "9" || buttonText == ".";
  }

  bool isSymbol(String buttonText) {
    return buttonText == "+" || buttonText == "-" || buttonText == "*" || buttonText == "/" || buttonText == "=";
  }

  void onButtonPressed(String buttonText) {
    if (buttonText == "=") {
      calculateResult();
    } else if (buttonText == "C") {
      clearDisplay();
    } else {
      updateDisplay(buttonText);
    }
  }

  void updateDisplay(String text) {
    if (shouldClearDisplay) {
      displayText = text;
      shouldClearDisplay = false;
    } else {
      displayText += text;
    }
    setState(() {
      updateTopDisplay();
    });
  }

  void updateTopDisplay() {
    if (displayText.contains(RegExp(r'[+\-*/]'))) {
      List<String> parts = displayText.split(RegExp(r'[+\-*/]'));

      num1 = double.tryParse(parts[0]) ?? 0.0;

      final operatorMatch = RegExp(r'[+\-*/]').firstMatch(displayText);
      if (operatorMatch != null) {
        operator = operatorMatch.group(0)!;
        num2 = double.tryParse(parts[1]) ?? 0.0;
      } else {
        operator = "";
        num2 = 0.0;
      }
    } else {
      operator = "";
      num2 = 0.0;
      num1 = double.tryParse(displayText) ?? 0.0;
    }
  }

  void clearDisplay() {
    displayText = "";
    num1 = 0.0;
    num2 = 0.0;
    result = "";
    operator = "";
    shouldClearDisplay = false;
    setState(() {
      updateTopDisplay();
    });
  }

  void calculateResult() {
    List<String> parts = displayText.split(RegExp(r'[+\-*/]'));

    if (parts.length == 2) {
      num1 = double.tryParse(parts[0]) ?? 0.0;
      num2 = double.tryParse(parts[1]) ?? 0.0;

      switch (operator) {
        case "+":
          result = (num1 + num2).toStringAsFixed(2);
          break;
        case "-":
          result = (num1 - num2).toStringAsFixed(2);
          break;
        case "*":
          result = (num1 * num2).toStringAsFixed(2);
          break;
        case "/":
          if (num2 != 0) {
            result = (num1 / num2).toStringAsFixed(2);
          } else {
            result = "Error";
          }
          break;
      }

      shouldClearDisplay = true;
      setState(() {
        updateTopDisplay();
      });
    }
  }
}

