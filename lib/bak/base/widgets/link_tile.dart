import 'package:flutter/material.dart';

class LinkTile extends StatelessWidget {
  const LinkTile({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          spacing: 8,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Container(
                    height: 15,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
