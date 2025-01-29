import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/base/app_styles.dart';
import 'package:nexus/base/utils/time_table_manager.dart';

class TimeTableView extends StatefulWidget {
  const TimeTableView({super.key});

  @override
  State<TimeTableView> createState() => _TimeTableViewState();
}

class _TimeTableViewState extends State<TimeTableView> {
  int index = manager.getCurrentTimeSlotIndex();
  final day = manager.getCurrentDay();

  @override
  Widget build(BuildContext context) {
    final TimeTableSlot slot = day[index];
    final colorScheme = Theme.of(context).colorScheme;
    final type = (slot.type == "PR") ? slot.slots![0].batch! : slot.type ?? '';

    return TimeTableContainer(
      onSwipe: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          decrementIndex();
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          incrementIndex();
        }
      },
      mainContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  slot.subject ?? slot.activity ?? slot.slots?[1].subject ?? '',
                  style: GoogleFonts.novaFlat(
                    color: Colors.deepPurple[100],
                    fontSize: TextStyles.displayMedium.fontSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Visibility(
                visible: slot.type == "TH" || slot.type == "PR",
                child: Column(
                  children: [
                    Container(
                      width: 25,
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 1),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      bottomContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time Slots
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24.0,
                  height: 24.0,
                  color: Colors.deepPurple[100],
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedTime03,
                    color: Colors.black,
                    size: 16.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                  color: Colors.deepPurple[400],
                  height: 24.0,
                  child: Text(
                    '${slot.sTime} - ${slot.eTime}',
                    style: GoogleFonts.orbitron(
                      color: Colors.white60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Buttons
          Row(
            spacing: 3,
            children: [
              AnimatedButton(
                  index: index,
                  onTap: decrementIndex,
                  disableLogic: index == 0,
                  icon: HugeIcons.strokeRoundedSquareArrowLeft01),
              AnimatedButton(
                  index: index,
                  onTap: incrementIndex,
                  disableLogic: index == day.length - 1,
                  icon: HugeIcons.strokeRoundedSquareArrowRight01),
            ],
          ),
        ],
      ),
    );
  }

  void incrementIndex() {
    if (index == day.length - 1) {
      return;
    }
    setState(() {
      index += 1;
    });
  }

  void decrementIndex() {
    if (index == 0) {
      return;
    }
    setState(() {
      index -= 1;
    });
  }
}

class TimeTableContainer extends StatelessWidget {
  const TimeTableContainer(
      {super.key,
      required this.mainContent,
      required this.bottomContent,
      this.onSwipe});

  final Widget mainContent;
  final Widget bottomContent;
  final Function(DragEndDetails)? onSwipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: onSwipe,
      child: Container(
        height: 140,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: mainContent,
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: bottomContent,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  const AnimatedButton(
      {super.key,
      this.onTap,
      required this.index,
      required this.icon,
      required this.disableLogic});

  final Function()? onTap;
  final int index;
  final bool disableLogic;
  final IconData icon;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  void _onTapDown() {
    if (widget.disableLogic) return;
    setState(() {
      _scale = 0.9; // Scale down
    });
  }

  void _onTapUp() {
    if (widget.disableLogic) return;
    setState(() {
      _scale = 1.0; // Back to normal
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapUp(),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 100),
        child: HugeIcon(
          icon: widget.icon,
          color: widget.disableLogic
              ? Colors.deepPurple[300]!
              : Colors.deepPurple[100]!,
          size: 32.0,
        ),
      ),
    );
  }
}
