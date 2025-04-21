import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class FilterManagerPage extends StatefulWidget {
  const FilterManagerPage({super.key});

  @override
  State<FilterManagerPage> createState() => _FilterManagerPageState();
}

class _FilterManagerPageState extends State<FilterManagerPage> {
  List<String> _filters = [];
  final TextEditingController _newFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final filters = await PrefsService.loadFilterList();
    if (!mounted) return;
    setState(() {
      _filters = filters;
    });
  }

  Future<void> _saveFilters() async {
    await PrefsService.saveFilterList(_filters);
  }

  void _addFilter() {
    final newFilter = _newFilterController.text.trim();
    if (newFilter.isNotEmpty && !_filters.contains(newFilter)) {
      setState(() {
        _filters.add(newFilter);
        _newFilterController.clear();
      });
      _saveFilters();
    }
  }

  void _removeFilter(String filter) {
    setState(() {
      _filters.remove(filter);
    });
    _saveFilters();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Manage Filters'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _newFilterController,
                      placeholder: 'Add new filter',
                      onSubmitted: (_) => _addFilter(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const Text('Add'),
                    onPressed: _addFilter,
                  )
                ],
              ),
            ),
            Container(
              height: 1,
              color: CupertinoColors.separator,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  return Dismissible(
                    key: ValueKey(filter),
                    direction: DismissDirection.endToStart,
                    background: Container(color: CupertinoColors.systemRed),
                    onDismissed: (_) => _removeFilter(filter),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(filter, style: CupertinoTheme.of(context).textTheme.textStyle),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
