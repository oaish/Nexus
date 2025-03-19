import 'package:bloc/bloc.dart';
import 'package:nexus/domain/entities/sub_slot.dart';

part 'time_slot_state.dart';

class TimeSlotCubit extends Cubit<TimeSlotState> {
  TimeSlotCubit() : super(TimeSlotInitial());

  loadDefaultTimeSlot() {
    emit(const TimeSlotLoaded(
      duration: Duration(),
      type: 'TH',
    ));
  }

  changeType(String type) {
    final current = state as TimeSlotLoaded;
    emit(current.copyWith(type: type));
  }
}
