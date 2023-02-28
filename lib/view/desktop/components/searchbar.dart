// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/utility/constants.dart';

class DesktopSearchbar extends StatefulWidget {
  const DesktopSearchbar({
    super.key,
    required this.keyword,
    required this.serviceInstance,
    required this.goToPage,
    required this.goToPageIndex,
  });
  final String keyword;
  final BaseService serviceInstance;
  final Function goToPage;
  final int goToPageIndex;

  @override
  State<DesktopSearchbar> createState() => _DesktopSearchbarState();
}

class _DesktopSearchbarState extends State<DesktopSearchbar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.keyword}s',
            style: const TextStyle(fontSize: 20),
          ),
          const Spacer(),
          SizedBox(
            width: size.width * 0.25,
            height: 40,
            child: TextField(
              controller: _searchController,
              decoration: Constants.textDecoration.copyWith(
                prefixIcon: const Icon(
                  Icons.search,
                ),
                labelText: 'Search',
              ),
              onSubmitted: (String? val) {
                widget.serviceInstance.getAll(search: val);
              },
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: widget.serviceInstance.isSearchingAll
                ? null
                : () => widget.serviceInstance
                    .getAll(search: _searchController.text),
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 20),
          SizedBox(
            height: 35,
            child: ElevatedButton(
              onPressed: () => widget.goToPage(widget.goToPageIndex),
              style: ElevatedButton.styleFrom(elevation: 4),
              child: Text('Add ${widget.keyword}'),
            ),
          ),
        ],
      ),
    );
  }
}
