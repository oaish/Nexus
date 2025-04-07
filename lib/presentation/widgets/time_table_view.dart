import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_media.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';
import 'package:nexus/presentation/cubits/timetable_view_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_view_state.dart';

class TimeTableView extends StatelessWidget {
  const TimeTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeTableViewCubit, TimeTableViewState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return switch (state) {
          TimeTableViewInitial() =>
            const Center(child: CircularProgressIndicator()),
          TimeTableViewLoading() =>
            const Center(child: CircularProgressIndicator()),
          TimeTableViewError() => Center(child: Text(state.message)),
          TimeTableViewLoaded() => _TimeTableContent(
              slots:
                  state.timetable.schedule[weekDays[state.currentDayIndex]] ??
                      [],
              currentIndex: state.currentIndex,
              batchIndex: state.batchIndex,
              groupIndex: state.groupIndex,
            ),
          _ => const Center(child: Text('Unknown state')),
        };
      },
    );
  }
}

class _TimeTableContent extends StatelessWidget {
  final List<TimeTableSlot> slots;
  final int currentIndex;
  final int batchIndex;
  final int groupIndex;

  const _TimeTableContent({
    required this.slots,
    required this.currentIndex,
    required this.batchIndex,
    required this.groupIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return TimeTableContainer(
        onSwipe: null,
        mainContent: Center(
          child: Column(
            spacing: 15,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You're all clear for today!\nEnjoy your time.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'NovaFlat',
                  color: Color(0xFFD1C4E9),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  height: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'More',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        color: Color(0xFFD1C4E9),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomContent: const SizedBox(),
      );
    }

    final TimeTableSlot slot = slots[currentIndex];
    String slotTitle = slot.subject ?? slot.activity ?? '';
    String slotTypeText = '';

    if (slot.type == "PR" || slot.type == "TT") {
      final subSlot = (slot.type == "PR")
          ? slot.subSlots![batchIndex]
          : slot.subSlots![groupIndex];

      slotTitle = subSlot.subject ?? subSlot.activity ?? '';
      slotTypeText = (slot.type == "PR")
          ? 'Batch: ${subSlot.batch ?? 'N/A'}'
          : 'Group: ${subSlot.group ?? 'N/A'}';
    }

    return TimeTableContainer(
      onSwipe: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          context.read<TimeTableViewCubit>().previousSlot();
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          context.read<TimeTableViewCubit>().nextSlot();
        }
      },
      mainContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          // Slot Title
          Row(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slotTitle,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'NovaFlat',
                  color: Colors.deepPurple[100],
                  fontSize: TextStyles.displayMedium.fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  height: 1,
                ),
              ),
              Visibility(
                visible: slot.type == "TH" || slot.type == "PR",
                child: Column(
                  children: [
                    Container(
                      width: 25,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 1),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          slot.type ?? '',
                          style: TextStyle(
                            fontFamily: 'NovaFlat',
                            color: Colors.deepPurple[100],
                            fontSize: TextStyles.labelSmall.fontSize,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              )
            ],
          ),

          // Faculty & Location
          Visibility(
            visible: slot.type != null && slot.type != 'AC',
            child: Row(
              spacing: 5,
              children: [
                Text(
                  slot.teacher ??
                      (slot.type != null && slot.type != 'AC'
                          ? (slot
                              .subSlots![
                                  slot.type == "PR" ? batchIndex : groupIndex]
                              .teacher)!
                          : ''),
                  style: TextStyles.labelLarge.copyWith(
                    color: Colors.deepPurple[100],
                  ),
                ),
                Icon(Icons.circle_rounded,
                    size: 5, color: Colors.deepPurple[100]!),
                Text(
                  slot.location ??
                      (slot.type != null && slot.type != 'AC'
                          ? (slot
                              .subSlots![
                                  slot.type == "PR" ? batchIndex : groupIndex]
                              .location)!
                          : ''),
                  style: TextStyles.labelLarge
                      .copyWith(color: Colors.deepPurple[100]),
                ),
              ],
            ),
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
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2)
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24.0,
                  height: 24.0,
                  color: Colors.deepPurple[100],
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedTime03,
                    color: Colors.black,
                    size: 16.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 4.0),
                  color: Colors.deepPurple[400],
                  height: 24.0,
                  child: Text(
                    '${slot.sTime} - ${slot.eTime}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Orbitron',
                      color: Colors.white60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation Buttons + Batch Changer
          Row(
            spacing: 3,
            children: [
              // Practical Batch Changer
              Visibility(
                visible: slot.type == "PR" || slot.type == "TT",
                child: GestureDetector(
                  onTap: () {
                    if (slot.type == "PR") {
                      context.read<TimeTableViewCubit>().circleBatch();
                    } else if (slot.type == "TT") {
                      context.read<TimeTableViewCubit>().circleGroup();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 3.0, vertical: 2.0),
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[400],
                      border: Border.all(color: Colors.deepPurple[200]!),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      slotTypeText,
                      style: TextStyle(
                        fontFamily:
                            'NovaFlat', // Ensure the font is added in pubspec.yaml
                        color: Colors.deepPurple[100],
                        fontSize: TextStyles.labelMedium.fontSize,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),

              // Navigation Buttons
              AnimatedButton(
                  index: currentIndex,
                  onTap: () =>
                      context.read<TimeTableViewCubit>().previousSlot(),
                  disableLogic: currentIndex == 0,
                  icon: HugeIcons.strokeRoundedSquareArrowLeft01),
              AnimatedButton(
                  index: currentIndex,
                  onTap: () => context.read<TimeTableViewCubit>().nextSlot(),
                  disableLogic: currentIndex == slots.length - 1,
                  icon: HugeIcons.strokeRoundedSquareArrowRight01),
            ],
          ),
        ],
      ),
    );
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
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple[600],
          image: const DecorationImage(
            image: AssetImage(AppMedia.cartographer),
            fit: BoxFit.cover,
          ),
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
        duration: const Duration(milliseconds: 100),
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
