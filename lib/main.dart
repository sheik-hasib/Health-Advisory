import 'package:flutter/material.dart';

void main() {
  runApp(HealthAdvisoryApp());
}

class HealthAdvisoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogoScreen(),
    );
  }
}

class LogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 198, 8),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BMICalculator()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/medical_logo.png', width: 150, height: 150),
              SizedBox(height: 20),
              Text("Health Advisory", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
              Text("Tap to Start", style: TextStyle(fontSize: 16, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String gender = "Male";
  double bmi = 0.0;
  double bmr = 0.0;
  String result = "CALCULATE BMI";
  String advice = "";

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    if (height > 0 && weight > 0) {
      double heightInMeters = height / 100;
      setState(() {
        bmi = weight / (heightInMeters * heightInMeters);
        if (bmi < 18.5) {
          result = "অপর্যাপ্ত ওজন";
          advice = "আপনার ওজন কম, তাই পুষ্টিকর খাবার খান এবং ব্যায়াম করুন।";
        } else if (bmi >= 18.5 && bmi < 24.9) {
          result = "স্বাভাবিক ওজন";
          advice = "আপনার ওজন স্বাভাবিক, স্বাস্থ্যকর খাবার গ্রহণ করুন এবং ব্যায়াম করুন।";
        } else if (bmi >= 25 && bmi < 29.9) {
          result = "বেশি ওজন";
          advice = "আপনার ওজন বেশি, স্বাস্থ্যকর খাবার গ্রহণ করুন এবং ব্যায়াম বাড়ান।";
        } else {
          result = "স্থূলতা";
          advice = "আপনার ওজন অত্যধিক, পুষ্টিবিদের পরামর্শ নিন এবং ব্যায়াম করুন।";
        }
      });
    }
  }

  void calculateBMR() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;
    int age = int.tryParse(ageController.text) ?? 0;
    if (height > 0 && weight > 0 && age > 0) {
      setState(() {
        if (gender == "Male") {
          bmr = 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age);
        } else {
          bmr = 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age);
        }
      });
    }
  }

  void resetFields() {
    setState(() {
      heightController.clear();
      weightController.clear();
      ageController.clear();
      bmi = 0.0;
      bmr = 0.0;
      result = "CALCULATE BMI";
      advice = "";
      gender = "Male";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BMI & BMR Calculator")),
      backgroundColor: const Color.fromARGB(255, 203, 226, 111),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: gender,
              dropdownColor: const Color.fromRGBO(137, 28, 73, 1),
              style: TextStyle(color: const Color.fromARGB(255, 27, 26, 26)),
              items: ["Male", "Female"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  gender = newValue!;
                });
              },
            ),
            TextField(controller: heightController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Height (cm)", filled: true, fillColor: Colors.white)),
            TextField(controller: weightController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Weight (kg)", filled: true, fillColor: Colors.white)),
            TextField(controller: ageController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Age", filled: true, fillColor: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () { calculateBMI(); calculateBMR(); }, child: Text("Calculate")),
                ElevatedButton(onPressed: resetFields, child: Text("Reset")),
              ],
            ),
            Text("BMI: ${bmi.toStringAsFixed(2)}", style: TextStyle(fontSize: 22, color: Colors.white)),
            Text(result, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(advice, style: TextStyle(fontSize: 16, color: Colors.white)),
            Text("BMR: ${bmr.toStringAsFixed(2)} kcal/day", style: TextStyle(fontSize: 22, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
