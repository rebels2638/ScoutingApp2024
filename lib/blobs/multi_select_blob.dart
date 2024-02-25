import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class MultiSelectBlob<T> extends StatelessWidget {
  final Map<String, T> items;
  final bool wrap;
  final Icon checkedIndicator;
  final void Function(List<T> selected) onSelected;

  const MultiSelectBlob(
      {super.key,
      Icon? checkedIndicator,
      required this.items,
      required this.onSelected,
      this.wrap = true})
      : checkedIndicator =
            checkedIndicator ?? const Icon(Icons.check_rounded);

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown<T>(
      onOptionSelected: (List<ValueItem<T>> selected) {
        onSelected.call(
            selected.map((ValueItem<T> e) => e.value!).toList());
      },
      options: items.entries
          .map((MapEntry<String, T> e) =>
              ValueItem<T>(label: e.key, value: e.value))
          .toList(),
      selectionType: SelectionType.multi,
      chipConfig: wrap
          ? const ChipConfig(wrapType: WrapType.wrap)
          : const ChipConfig(wrapType: WrapType.scroll),
      selectedOptionIcon: checkedIndicator,
    );
  }
}
