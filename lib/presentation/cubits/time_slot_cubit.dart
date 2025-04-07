import 'package:bloc/bloc.dart';
import 'package:nexus/domain/entities/sub_slot.dart';

part 'time_slot_state.dart';

class TimeSlotCubit extends Cubit<TimeSlotState> {
  TimeSlotCubit() : super(TimeSlotInitial());

  loadDefaultTimeSlot([Map<String, dynamic>? existingSlot]) {
    if (existingSlot != null) {
      // Parse the duration from the existing slot
      final sTime = existingSlot['sTime'] as String;
      final eTime = existingSlot['eTime'] as String;

      // Calculate duration in minutes
      final sParts = sTime.split(':');
      final eParts = eTime.split(':');

      final sMinutes = int.parse(sParts[0]) * 60 + int.parse(sParts[1]);
      final eMinutes = int.parse(eParts[0]) * 60 + int.parse(eParts[1]);

      final durationMinutes = eMinutes - sMinutes;

      emit(TimeSlotLoaded(
        duration: Duration(minutes: durationMinutes),
        type: existingSlot['type'] as String,
      ));
    } else {
      emit(const TimeSlotLoaded(
        duration: Duration(),
        type: 'TH',
      ));
    }
  }

  changeType(String type) {
    final current = state as TimeSlotLoaded;
    emit(current.copyWith(type: type));
  }
}
