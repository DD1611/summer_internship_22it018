import 'package:flutter/material.dart';
import 'score_page.dart'; // Assuming ScorePage is defined in score_page.dart

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  TextEditingController teamAController = TextEditingController();
  TextEditingController teamBController = TextEditingController();
  String tossWinner = '';
  String battingFirst = '';
  int maxOvers = 0;

  void _simulateToss() {
    setState(() {
      if (DateTime.now().microsecondsSinceEpoch % 2 == 0) {
        tossWinner = teamAController.text;
      } else {
        tossWinner = teamBController.text;
      }
    });
  }

  void _startMatch() {
    if (tossWinner.isNotEmpty && (battingFirst == 'Batting' || battingFirst == 'Bowling') && maxOvers > 0) {
      String teamBattingFirst;
      String teamBowlingFirst;
      if (battingFirst == 'Batting') {
        teamBattingFirst = tossWinner;
        teamBowlingFirst = tossWinner == teamAController.text ? teamBController.text : teamAController.text;
      } else {
        teamBowlingFirst = tossWinner;
        teamBattingFirst = tossWinner == teamAController.text ? teamBController.text : teamAController.text;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScorePage(
            maxOvers: maxOvers,
            battingFirst: teamBattingFirst,
            teamA: teamAController.text,
            teamB: teamBController.text,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Setup'),
            content: Text('Please complete the toss and selection process and enter valid overs.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Match'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Cricket Scoring App',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: teamAController,
              decoration: InputDecoration(
                labelText: 'Team A',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: teamBController,
              decoration: InputDecoration(
                labelText: 'Team B',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simulateToss,
              child: Text('Simulate Toss'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
              ),
            ),
            SizedBox(height: 16),
            if (tossWinner.isNotEmpty)
              Text(
                'Toss Winner: $tossWinner',
                style: TextStyle(fontSize: 20, color: Colors.lightBlue),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 16),
            Text(
              'Choose Batting or Bowling First:',
              style: TextStyle(fontSize: 20,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      battingFirst = 'Batting';
                    });
                  },
                  child: Text('Batting First'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: battingFirst == 'Batting' ? Colors.orange : Colors.lightBlue,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      battingFirst = 'Bowling';
                    });
                  },
                  child: Text('Bowling First'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: battingFirst == 'Bowling' ? Colors.orange : Colors.lightBlue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                maxOvers = int.tryParse(value) ?? 0;
              },
              decoration: InputDecoration(
                labelText: 'Maximum Overs per Team',
                hintText: 'Enter maximum overs',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startMatch,
              child: Text('Start Match'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
