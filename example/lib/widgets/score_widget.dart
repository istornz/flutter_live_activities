import 'package:flutter/material.dart';

class ScoreWidget extends StatelessWidget {
  final String teamName;
  final int score;
  final Function(int) onScoreChanged;
  const ScoreWidget({
    Key? key,
    required this.teamName,
    required this.score,
    required this.onScoreChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          teamName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              width: 35,
              height: 35,
              child: IconButton(
                iconSize: 18,
                icon: const Icon(
                  Icons.remove_rounded,
                  color: Colors.white,
                ),
                onPressed: () => onScoreChanged(score - 1),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              score.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              width: 35,
              height: 35,
              child: IconButton(
                iconSize: 16,
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                ),
                onPressed: () => onScoreChanged(score + 1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
