import 'package:flutter/cupertino.dart';
import 'package:btzs_sandbox/utils/prefs_service.dart';

class FilterManagerPage extends StatefulWidget {
  const FilterManagerPage({super.key});

  @override
  State<FilterManagerPage> createState() => _FilterManagerPageState();
}

class _FilterManagerPageState extends State<FilterManagerPage> {
  List<String> _filters = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final filters = await PrefsService.getFilterList();
    setState(() => _filters = List.from(filters));
  }

  Future<void> _saveFilters() async {
    await PrefsService.saveFilterList(_filters);
  }

  void _addFilter(String filter) {
    if (filter.isNotEmpty && !_filters.contains(filter)) {
      setState(() {
        _filters.add(filter);
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
              padding: const EdgeInsets.all(12),
              child: CupertinoTextField(
                controller: _controller,
                placeholder: "Add filter name",
                suffix: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.add),
                  onPressed: () {
                    _addFilter(_controller.text.trim());
                    _controller.clear();
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filters.length,
                itemBuilder: (_, index) {
                  final filter = _filters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: CupertinoColors.systemGrey, width: 0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(filter, style: CupertinoTheme.of(context).textTheme.textStyle),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.delete),
                            onPressed: () => _removeFilter(filter),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
