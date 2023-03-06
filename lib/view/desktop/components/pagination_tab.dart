import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/base_service.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:provider/provider.dart';

class CustomPaginationConstants {
  static const double height = 40;
}

class CustomPagination<T extends BaseService> extends StatefulWidget {
  const CustomPagination({super.key});

  @override
  State<CustomPagination<T>> createState() => _CustomPaginationState();
}

class _CustomPaginationState<T extends BaseService>
    extends State<CustomPagination<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomDivider(),
        SizedBox(
          height: CustomPaginationConstants.height - 1,
          child: Consumer<T>(builder: (_, provider, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap:
                      provider.currentPage == 1 ? null : provider.onFirstPage,
                  child: Icon(
                    Icons.keyboard_double_arrow_left,
                    color:
                        provider.currentPage == 1 ? Colors.grey : Colors.black,
                  ),
                ),
                InkWell(
                  onTap: provider.currentPage == 1
                      ? null
                      : provider.onPreviousPage,
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color:
                        provider.currentPage == 1 ? Colors.grey : Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    'Page ${provider.currentPage} of ${provider.totalPage ?? '-'}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                InkWell(
                  onTap: provider.currentPage == provider.totalPage
                      ? null
                      : provider.onNextPage,
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: provider.currentPage == provider.totalPage
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                InkWell(
                  onTap: provider.currentPage == provider.totalPage
                      ? null
                      : provider.onLastPage,
                  child: Icon(
                    Icons.keyboard_double_arrow_right,
                    color: provider.currentPage == provider.totalPage
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            );
          }),
        ),
      ],
    );
  }
}
