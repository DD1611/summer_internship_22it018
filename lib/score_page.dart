import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {
  final int maxOvers;
  final String battingFirst;
  final String teamA;
  final String teamB;

  ScorePage({required this.maxOvers, required this.battingFirst, required this.teamA, required this.teamB});

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  int teamAScore = 0;
  int teamBScore = 0;
  int teamAWickets = 0;
  int teamBWickets = 0;
  int teamAOvers = 0;
  int teamBOvers = 0;
  int teamABalls = 0;
  int teamBBalls = 0;
  bool isMatchOver = false;
  bool isFirstInnings = true;
  String matchResult = '';
  String currentBattingTeam = '';
  int target = 0;
  List<String> currentOverEvents = [];

  // For Undo Feature
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    currentBattingTeam = widget.battingFirst;
  }

  void _addRun(int runs) {
    if (isMatchOver) return;

    setState(() {
      _recordAction();
      if (currentBattingTeam == widget.teamA) {
        teamAScore += runs;
        currentOverEvents.add('$runs');
        _incrementBalls(true);
      } else {
        teamBScore += runs;
        currentOverEvents.add('$runs');
        _incrementBalls(false);
        _checkMatchWin();
      }
      _checkInningsEnd();
    });
  }

  void _addWicket() {
    if (isMatchOver) return;

    setState(() {
      _recordAction();
      if (currentBattingTeam == widget.teamA) {
        if (teamAWickets < 10) {
          teamAWickets += 1;
          currentOverEvents.add('W');
          _incrementBalls(true);
        }
      } else {
        if (teamBWickets < 10) {
          teamBWickets += 1;
          currentOverEvents.add('W');
          _incrementBalls(false);
        }
      }
      _checkInningsEnd();
    });
  }

  void _addWide(int runs) {
    if (isMatchOver) return;

    setState(() {
      _recordAction();
      if (currentBattingTeam == widget.teamA) {
        teamAScore += 1 + runs;
        currentOverEvents.add('Wd+${runs}');
      } else {
        teamBScore += 1 + runs;
        currentOverEvents.add('Wd+${runs}');
        _checkMatchWin();
      }
    });
  }

  void _addNoBall(int runs) {
    if (isMatchOver) return;

    setState(() {
      _recordAction();
      if (currentBattingTeam == widget.teamA) {
        teamAScore += 1 + runs;
        currentOverEvents.add('NB+${runs}');
      } else {
        teamBScore += 1 + runs;
        currentOverEvents.add('NB+${runs}');
        _checkMatchWin();
      }
    });
  }

  void _addBye(int runs) {
    if (isMatchOver) return;

    setState(() {
      _recordAction();
      if (currentBattingTeam == widget.teamA) {
        teamAScore += runs;
        currentOverEvents.add('$runs B');
      } else {
        teamBScore += runs;
        currentOverEvents.add('$runs B');
        _checkMatchWin();
      }
      _incrementBalls(currentBattingTeam == widget.teamA);
      _checkInningsEnd();
    });
  }

  void _addLegBye(int runs) {
    if (isMatchOver) return;

    setState(() {
      _recordAction();
      if (currentBattingTeam == widget.teamA) {
        teamAScore += runs;
        currentOverEvents.add('$runs LB');
      } else {
        teamBScore += runs;
        currentOverEvents.add('$runs LB');
        _checkMatchWin();
      }
      _incrementBalls(currentBattingTeam == widget.teamA);
      _checkInningsEnd();
    });
  }

  void _incrementBalls(bool isTeamA) {
    if (isMatchOver) return;

    setState(() {
      if (isTeamA) {
        teamABalls += 1;
        if (teamABalls == 6) {
          teamABalls = 0;
          teamAOvers += 1;
          currentOverEvents.clear();
        }
      } else {
        teamBBalls += 1;
        if (teamBBalls == 6) {
          teamBBalls = 0;
          teamBOvers += 1;
          currentOverEvents.clear();
        }
      }
    });
  }

  void _recordAction() {
    Map<String, dynamic> action = {
      'teamAScore': teamAScore,
      'teamBScore': teamBScore,
      'teamAWickets': teamAWickets,
      'teamBWickets': teamBWickets,
      'teamAOvers': teamAOvers,
      'teamBOvers': teamBOvers,
      'teamABalls': teamABalls,
      'teamBBalls': teamBBalls,
      'currentBattingTeam': currentBattingTeam,
      'isFirstInnings': isFirstInnings,
      'isMatchOver': isMatchOver,
      'matchResult': matchResult,
      'target': target,
      'currentOverEvents': List.from(currentOverEvents),
    };
    history.add(action);
  }

  void _undoAction() {
    if (history.isEmpty) return;

    setState(() {
      Map<String, dynamic> lastAction = history.removeLast();
      teamAScore = lastAction['teamAScore'];
      teamBScore = lastAction['teamBScore'];
      teamAWickets = lastAction['teamAWickets'];
      teamBWickets = lastAction['teamBWickets'];
      teamAOvers = lastAction['teamAOvers'];
      teamBOvers = lastAction['teamBOvers'];
      teamABalls = lastAction['teamABalls'];
      teamBBalls = lastAction['teamBBalls'];
      currentBattingTeam = lastAction['currentBattingTeam'];
      isFirstInnings = lastAction['isFirstInnings'];
      isMatchOver = lastAction['isMatchOver'];
      matchResult = lastAction['matchResult'];
      target = lastAction['target'];
      currentOverEvents = List.from(lastAction['currentOverEvents']);
    });
  }

  void _endInning() {
    if (isFirstInnings) {
      setState(() {
        isFirstInnings = false;
        target = currentBattingTeam == widget.teamA ? teamAScore + 1 : teamBScore + 1;
        currentBattingTeam = widget.teamA == currentBattingTeam ? widget.teamB : widget.teamA;
        currentOverEvents.clear();
      });
    } else {
      setState(() {
        _checkMatchWin();
        isMatchOver = true;
      });
    }
  }

  void _resetScores() {
    setState(() {
      teamAScore = 0;
      teamBScore = 0;
      teamAWickets = 0;
      teamBWickets = 0;
      teamAOvers = 0;
      teamBOvers = 0;
      teamABalls = 0;
      teamBBalls = 0;
      isFirstInnings = true;
      isMatchOver = false;
      matchResult = '';
      currentBattingTeam = widget.battingFirst;
      target = 0;
      history.clear();
      currentOverEvents.clear();
    });
  }

  void _checkInningsEnd() {
    if (isFirstInnings) {
      if (currentBattingTeam == widget.teamA) {
        if ((teamAOvers == widget.maxOvers && teamABalls == 0) || teamAWickets == 10) {
          _endInning();
        }
      } else {
        if ((teamBOvers == widget.maxOvers && teamBBalls == 0) || teamBWickets == 10) {
          _endInning();
        }
      }
    } else {
      if (currentBattingTeam == widget.teamA) {
        if ((teamAOvers == widget.maxOvers && teamABalls == 0) || teamAWickets == 10) {
          _checkMatchWin();
          isMatchOver = true;
        }
      } else {
        if ((teamBOvers == widget.maxOvers && teamBBalls == 0) || teamBWickets == 10) {
          _checkMatchWin();
          isMatchOver = true;
        }
      }
    }
  }

  void _checkMatchWin() {
    if (!isFirstInnings) {
      if (currentBattingTeam == widget.teamA) {
        if (teamAScore >= target) {
          isMatchOver = true;
          matchResult = '${widget.teamA} wins the match!';
        } else if ((teamAOvers == widget.maxOvers && teamABalls == 0) || teamAWickets == 10) {
          isMatchOver = true;
          matchResult = '${widget.teamB} wins the match!';
        }
      } else {
        if (teamBScore >= target) {
          isMatchOver = true;
          matchResult = '${widget.teamB} wins the match!';
        } else if ((teamBOvers == widget.maxOvers && teamBBalls == 0) || teamBWickets == 10) {
          isMatchOver = true;
          matchResult = '${widget.teamA} wins the match!';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int runsNeeded;
    int ballsRemaining;

    if (currentBattingTeam == widget.teamA) {
      ballsRemaining = (widget.maxOvers * 6) - (teamAOvers * 6 + teamABalls);
      runsNeeded = target - teamAScore;
    } else {
      ballsRemaining = (widget.maxOvers * 6) - (teamBOvers * 6 + teamBBalls);
      runsNeeded = target - teamBScore;
    }

    if (runsNeeded == 1 && isMatchOver) {
      matchResult = 'Match Tied';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cricket Scoring App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTeamScore(widget.teamA, teamAScore, teamAWickets, teamAOvers, teamABalls),
              SizedBox(height: 16),
              _buildTeamScore(widget.teamB, teamBScore, teamBWickets, teamBOvers, teamBBalls),
              SizedBox(height: 16),
              if (!isFirstInnings)
                Text(
                  'Target: $target',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              if (!isFirstInnings)
                Text(
                  'Runs needed: $runsNeeded',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              if (!isFirstInnings)
                Text(
                  'Balls remaining: $ballsRemaining',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 16),
              Text(
                'Current Over: ${currentOverEvents.join(', ')}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Current Batting: $currentBattingTeam',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildScoreButton('0', () => _addRun(0)),
                    _buildScoreButton('1', () => _addRun(1)),
                    _buildScoreButton('2', () => _addRun(2)),
                    _buildScoreButton('3', () => _addRun(3)),
                    _buildScoreButton('4', () => _addRun(4)),
                    _buildScoreButton('5', () => _addRun(5)),
                    _buildScoreButton('6', () => _addRun(6)),
                    _buildScoreButton('Wd', () => _addWide(0)),
                    _buildScoreButton('Wd+1', () => _addWide(1)),
                    _buildScoreButton('Wd+2', () => _addWide(2)),
                    _buildScoreButton('Wd+3', () => _addWide(3)),
                    _buildScoreButton('Wd+4', () => _addWide(4)),
                    _buildScoreButton('NB', () => _addNoBall(0)),
                    _buildScoreButton('NB+1', () => _addNoBall(1)),
                    _buildScoreButton('NB+2', () => _addNoBall(2)),
                    _buildScoreButton('NB+3', () => _addNoBall(3)),
                    _buildScoreButton('NB+4', () => _addNoBall(4)),
                    _buildScoreButton('NB+6', () => _addNoBall(6)),
                    _buildScoreButton('Bye', () => _addBye(1)),
                    _buildScoreButton('2B', () => _addBye(2)),
                    _buildScoreButton('3B', () => _addBye(3)),
                    _buildScoreButton('4B', () => _addBye(4)),
                    _buildScoreButton('LB', () => _addLegBye(1)),
                    _buildScoreButton('2LB', () => _addLegBye(2)),
                    _buildScoreButton('3LB', () => _addLegBye(3)),
                    _buildScoreButton('4LB', () => _addLegBye(4)),
                    _buildScoreButton('Wicket', _addWicket),
                    _buildScoreButton('Undo', _undoAction),
                    _buildScoreButton('End Inning', _endInning),
                  ],
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _resetScores,
                child: Text('Reset Scores'),
              ),
              SizedBox(height: 16),
              if (isMatchOver)
                Text(
                  matchResult,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamScore(String teamName, int score, int wickets, int overs, int balls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$teamName',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          'Score: $score/$wickets',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'Overs: $overs.$balls',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildScoreButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
