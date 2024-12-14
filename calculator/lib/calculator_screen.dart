import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String userInput = "";
  String result = "0";
  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    '←', // Back arrow button
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff373a40), // Dark gray background
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    userInput,
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xffeeeeee), // Light gray for user input
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: TextStyle(
                      fontSize: 48,
                      color: Color(0xffeeeeee), // Bright text for results
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade700), // Subtle divider line
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: buttonList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CustomButton(buttonList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomButton(String text) {
    return InkWell(
      splashColor: Colors.white.withOpacity(0.3), // Subtle splash
      onTap: () {
        setState(() {
          handleButtons(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getButtonColor(text), // Assign colors based on the text
          borderRadius: BorderRadius.circular(12), // Rounded edges
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 6), // Shadow for button elevation
            ),
          ],
        ),
        child: Center(
          child: text == '←'
              ? Icon(Icons.arrow_back, color: Colors.black, size: 28) // Back arrow
              : Text(
            text,
            style: TextStyle(
              color: getTextColor(text),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color getTextColor(String text) {
    if (text == "=" || text == "AC") {
      return Colors.white; // White for special buttons
    }
    return Color(0xffeeeeee); // Light gray text for other buttons
  }

  Color getButtonColor(String text) {
    if (text == "AC") {
      return Color(0xffdc5f00); // Bold orange for AC button
    }
    if (text == "=") {
      return Color(0xffdc5f00); // Same bold orange for Equals button
    }
    if (text == "/" || text == "*" || text == "+" || text == "-" || text == "(" || text == ")") {
      return Color(0xff686d76); // Mid-gray for operators
    }
    if (text == "←") {
      return Colors.red; // Mid-gray for back arrow
    }
    return Color(0xff373a40); // Darker gray for numeric buttons
  }

  handleButtons(String text) {
    if (text == "AC") {
      userInput = "";
      result = "0";
      return;
    }
    if (text == "←") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1); // Remove last character
        return;
      }
    }
    if (text == "=") {
      result = calculate();
      userInput = result;
      if (result.endsWith(".0")) {
        userInput = userInput.replaceAll(".0", "");
        result = result.replaceAll(".0", "");
      }
      return;
    }
    userInput += text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "Error";
    }
  }
}
