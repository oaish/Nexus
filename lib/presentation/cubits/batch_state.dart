part of 'batch_cubit.dart';

@immutable
sealed class BatchState {}

final class BatchInitial extends BatchState {}

final class BatchLoaded extends BatchState {
  final int batchIndex;
  final int groupIndex;

  BatchLoaded copyWith({int? batchIndex, int? groupIndex}) {
    return BatchLoaded(
      batchIndex: batchIndex ?? this.batchIndex,
      groupIndex: groupIndex ?? this.groupIndex,
    );
  }

  BatchLoaded({required this.batchIndex, required this.groupIndex});
}
