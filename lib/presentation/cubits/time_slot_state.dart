part of 'time_slot_cubit.dart';

sealed class TimeSlotState {
  const TimeSlotState();
}

final class TimeSlotInitial extends TimeSlotState {}

final class TimeSlotLoaded extends TimeSlotState {
  final String? type;
  final String? subject;
  final String? teacher;
  final String? location;
  final String? activity;
  final Duration? duration;
  final List<SubSlot>? subSlots;
  const TimeSlotLoaded({
    this.type,
    this.subject,
    this.teacher,
    this.location,
    this.duration,
    this.activity,
    this.subSlots,
  });

  TimeSlotLoaded copyWith({
    String? type,
    String? subject,
    String? teacher,
    String? location,
    String? activity,
    Duration? duration,
    List<SubSlot>? subSlots,
  }) {
    return TimeSlotLoaded(
      type: type ?? this.type,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      location: location ?? this.location,
      activity: activity ?? this.activity,
      duration: duration ?? this.duration,
      subSlots: subSlots ?? this.subSlots,
    );
  }
}
