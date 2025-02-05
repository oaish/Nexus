import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/presentation/bloc/week_bloc/week_bloc.dart';

class WeekButtonsGrid extends StatelessWidget {
  const WeekButtonsGrid({super.key, required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeekBloc, WeekState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
                spreadRadius: 3,
              )
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WeekButton('Mon', accentColor),
              WeekButton('Tue', accentColor),
              WeekButton('Wed', accentColor),
              WeekButton('Thu', accentColor),
              WeekButton('Fri', accentColor),
              WeekButton('Sat', accentColor),
              WeekButton('Sun', accentColor),
            ],
          ),
        );
      },
    );
  }
}

class WeekButton extends StatelessWidget {
  final String data;
  final Color accentColor;
  const WeekButton(this.data, this.accentColor, {super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDay =
        context.select((WeekBloc bloc) => bloc.state.selectedDay);
    final bool isActive = selectedDay == data;

    return GestureDetector(
      onTap: () {
        context.read<WeekBloc>().add(SelectDayEvent(data));
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? accentColor : Colors.grey[700]!,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
              color: isActive ? Colors.white : Colors.transparent, width: 2),
        ),
        child: Center(
          child: Text(
            data,
            style: TextStyle(
              fontFamily: 'NovaFlat',
              color: isActive ? Colors.white : Colors.grey[400],
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
