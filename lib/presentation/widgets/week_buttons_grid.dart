import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/presentation/cubits/week_cubit.dart';

class WeekButtonsGrid extends StatelessWidget {
  const WeekButtonsGrid({super.key, required this.weekLength});

  final int weekLength;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeekCubit, WeekState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(weekLength, (i) {
              return WeekButton(weekDays[i]);
            }),
          ),
        );
      },
    );
  }
}

class WeekButton extends StatelessWidget {
  final String day;
  const WeekButton(this.day, {super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDay = context.select((WeekCubit cubit) => cubit.state.selectedDay);
    final bool isActive = selectedDay == day;

    return GestureDetector(
      onTap: () {
        context.read<WeekCubit>().selectDay(day);
      },
      child: Container(
        width: 45,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            day.substring(0, 3),
            style: TextStyle(
              fontFamily: 'NovaFlat',
              color: isActive ? Theme.of(context).colorScheme.onPrimary : Colors.grey[400],
              fontSize: TextStyles.labelMedium.fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
