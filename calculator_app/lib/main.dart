import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = '0';
  String result = '';
  double equationFontSize = 38.0;
  double resultFontSize = 38.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        equation = '0';
        result = '';
      } else if (buttonText == 'AC') {
        if (equation.length > 1) {
          equation = equation.substring(0, equation.length - 1);
        } else {
          equation = '0';
        }
      } else if (buttonText == '=') {
        String expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        if (equation == '0') {
          equation = buttonText;
        } else {
          equation += buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '$equation',
                    style: TextStyle(
                      fontSize: equationFontSize,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '$result',
                    style: TextStyle(
                      fontSize: resultFontSize,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(

              children: <Widget>[
                buildButtonRow(['7', '8', '9', '÷'], 1),
                buildButtonRow(['4', '5', '6', '×'], 1),
                buildButtonRow(['1', '2', '3', '-'], 1),
                buildButtonRow(['.', '0', 'AC', '+'], 1),
                buildButtonRow(['C', '='], 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons, double buttonHeight) {
    List<Widget> rowButtons = [];
    for (String button in buttons) {
      rowButtons.add(
        Expanded(
          child: buildButton(button, buttonHeight, Colors.grey),
        ),
      );
    }
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rowButtons,
      ),
    );
  }
}
