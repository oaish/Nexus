import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'batch_state.dart';

class BatchCubit extends Cubit<BatchState> {
  BatchCubit() : super(BatchLoaded(batchIndex: 0, groupIndex: 0));

  void circleBatch() {
    if (state is BatchLoaded) {
      final currentState = state as BatchLoaded;
      const batchCount = 3;
      final newBatchIndex = (currentState.batchIndex + 1) % batchCount;
      emit(currentState.copyWith(batchIndex: newBatchIndex));
    }
  }

  void circleGroup() {
    if (state is BatchLoaded) {
      final currentState = state as BatchLoaded;
      const groupCount = 2;
      final newGroupIndex = (currentState.groupIndex + 1) % groupCount;
      emit(currentState.copyWith(groupIndex: newGroupIndex));
    }
  }
}
