import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:theme_provider/theme_provider.dart';

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
      : checkedIndicator = checkedIndicator ??
            const Icon(Icons.check_circle_rounded);

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown<T>(
      onOptionSelected: (List<ValueItem<T>> selected) => onSelected
          .call(selected.map((ValueItem<T> e) => e.value!).toList()),
      options: items.entries
          .map((MapEntry<String, T> e) =>
              ValueItem<T>(label: e.key, value: e.value))
          .toList(),
      selectionType: SelectionType.multi,
      dropdownHeight: 200,
      selectedOptionIcon: checkedIndicator,
      chipConfig: ChipConfig(
          wrapType: wrap ? WrapType.wrap : WrapType.scroll,
          labelColor:
              ThemeProvider.themeOf(context).data.iconTheme.color!,
          radius: 16),
      hintStyle: TextStyle(
          color:
              ThemeProvider.themeOf(context).data.iconTheme.color!),
      hintColor: ThemeProvider.themeOf(context).data.iconTheme.color,
      selectedOptionTextColor:
          ThemeProvider.themeOf(context).data.iconTheme.color,
      fieldBackgroundColor: ThemeProvider.themeOf(context)
          .data
          .colorScheme
          .surfaceVariant,
      borderColor: Colors.transparent,
      singleSelectItemStyle: TextStyle(
          color: ThemeProvider.themeOf(context).data.iconTheme.color!,
          fontWeight: FontWeight.bold),
      dropdownBackgroundColor: ThemeProvider.themeOf(context)
          .data
          .colorScheme
          .surfaceVariant,
      dropdownBorderRadius: 8,
      borderRadius: 8,
      optionsBackgroundColor: ThemeProvider.themeOf(context)
          .data
          .colorScheme
          .surfaceVariant,
      searchBackgroundColor: ThemeProvider.themeOf(context)
          .data
          .colorScheme
          .surfaceVariant,
      selectedOptionBackgroundColor:
          ThemeProvider.themeOf(context).data.colorScheme.primary,
    );
  }
}

class SingleSelectBlob<T> extends StatelessWidget {
  final Map<String, T> items;
  final bool wrap;
  final Icon checkedIndicator;
  final void Function(T selected) onSelected;
  final String initialSelected;

  const SingleSelectBlob(
      {super.key,
      Icon? checkedIndicator,
      required this.items,
      required this.initialSelected,
      required this.onSelected,
      this.wrap = true})
      : checkedIndicator =
            checkedIndicator ?? const Icon(Icons.check_rounded);

  @override
  Widget build(BuildContext context) {
    assert(items.containsKey(initialSelected),
        'initialSelected must be a key in items for $initialSelected not in ${items.keys.toString()}'); // for when im stupid
    return DropdownMenu<T>(
      requestFocusOnTap:
          false, // makes it so that the dropdown doesn't show the keyboard lmao
      initialSelection: items.entries.first.value,
      dropdownMenuEntries: <DropdownMenuEntry<T>>[
        for (MapEntry<String, T> e in items.entries)
          DropdownMenuEntry<T>(
            value: e.value,
            label: e.key,
          )
      ],
      onSelected: (T? value) {
        if (value != null) {
          onSelected.call(value);
        }
      },
      enableSearch: false,
    );
  }
}
