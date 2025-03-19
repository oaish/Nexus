import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/presentation/cubits/shad_auto_complete_cubit.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ShadAutoComplete extends StatelessWidget {
  const ShadAutoComplete({
    super.key,
    required this.suggestions,
    required this.controller,
    required this.placeholder,
  });

  final String placeholder;
  final List<String> suggestions;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShadAutoCompleteCubit(suggestions),
      child: Builder(
        builder: (context) {
          final cubit = context.read<ShadAutoCompleteCubit>();

          return BlocBuilder<ShadAutoCompleteCubit, List<String>>(
            builder: (context, currentSuggestions) {
              return AutoComplete(
                controller: controller,
                suggestions: currentSuggestions,
                placeholder: Text(placeholder),
                style: TextStyles.labelLarge.copyWith(
                  fontFamily: 'NovaFlat',
                ),
                trailing: Visibility(
                  visible: controller.text.isNotEmpty,
                  child: IconButton.text(
                    icon: const Icon(Icons.close),
                    density: ButtonDensity.compact,
                    onPressed: () {
                      controller.clear();
                      cubit.clearSuggestions();
                    },
                  ),
                ),
                onAcceptSuggestion: (index) {
                  controller.text = currentSuggestions[index];
                  cubit.clearSuggestions();
                },
                onChanged: cubit.updateSuggestions,
              );
            },
          );
        },
      ),
    );
  }
}
