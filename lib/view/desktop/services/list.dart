import 'package:flutter/material.dart';
import 'package:medstar_appointment/model/service.dart';
import 'package:medstar_appointment/services/services_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/searchbar.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/services/home.dart';
import 'package:provider/provider.dart';

class DesktopListServices extends StatefulWidget {
  const DesktopListServices({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopListServices> createState() => _DesktopListServicesState();
}

class _DesktopListServicesState extends State<DesktopListServices> {
  @override
  Widget build(BuildContext context) {
    final double tableWidth = MediaQuery.of(context).size.width -
        NavbarConstants.navbarWidth -
        (Constants.cardLeftMargin + Constants.cardRightMargin);
    return Consumer<ServiceService>(
      builder: (_, provider, __) => Column(
        children: [
          DesktopSearchbar(
            keyword: 'Service',
            serviceInstance: provider,
            goToPage: widget.goToPage,
            goToPageIndex: DesktopServicePageConstants.addPage,
          ),
          const CustomDivider(),
          _ServiceTableHeading(tableWidth: tableWidth),
          Stack(
            children: [
              const Divider(
                height: 2.5,
                thickness: 1,
                color: Colors.black54,
              ),
              if (provider.isSearchingAll)
                const LinearProgressIndicator(minHeight: 2.5),
            ],
          ),
          Expanded(
            child: _ServiceTableData(
              provider: provider,
              tableWidth: tableWidth,
              goToPage: widget.goToPage,
            ),
          )
        ],
      ),
    );
  }
}

class _ServiceTableHeading extends StatelessWidget {
  const _ServiceTableHeading({required this.tableWidth});

  final double tableWidth;

  @override
  Widget build(BuildContext context) {
    final double boxWidth = tableWidth / 5;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Title',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Duration',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Fee',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth + 100,
            child: const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth - 100,
            child: const Text(
              'Color',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTableData extends StatelessWidget {
  const _ServiceTableData({
    required this.provider,
    required this.tableWidth,
    required this.goToPage,
  });

  final ServiceService provider;
  final double tableWidth;
  final Function goToPage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: provider.services.length,
        itemBuilder: (context, index) {
          final service = provider.services[index];
          return _ServiceListItem(
            service: service,
            tableWidth: tableWidth,
            goToPage: goToPage,
          );
        });
  }
}

class _ServiceListItem extends StatefulWidget {
  const _ServiceListItem({
    Key? key,
    required this.service,
    required this.tableWidth,
    required this.goToPage,
  }) : super(key: key);

  final ServiceModel service;
  final double tableWidth;
  final Function goToPage;

  @override
  State<_ServiceListItem> createState() => _ServiceListItemState();
}

class _ServiceListItemState extends State<_ServiceListItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final double boxWidth = widget.tableWidth / 5;
    return StatefulBuilder(builder: (context, itemSetState) {
      return MouseRegion(
        cursor:
            _isHovering ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (event) => itemSetState(() {
          _isHovering = true;
        }),
        onExit: (event) => itemSetState(() {
          _isHovering = false;
        }),
        child: Consumer<ServiceService>(builder: (_, provider, __) {
          return GestureDetector(
            onTap: () {
              provider.setViewService(widget.service);
              widget.goToPage(DesktopServicePageConstants.viewPage);
            },
            child: Column(
              children: [
                Container(
                  color: _isHovering ? Colors.grey.shade200 : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth,
                        child: Text('${widget.service.title}'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth,
                        child: Text(widget.service.duration != null
                            ? '${widget.service.duration} minutes'
                            : ''),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth,
                        child: Text(widget.service.fee != null
                            ? '\$ ${widget.service.fee}'
                            : ''),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth + 100,
                        child: Text('${widget.service.description}'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth - 100,
                        child: Row(
                          children: [
                            if (widget.service.color != null)
                              Container(
                                width: 50,
                                height: 17,
                                decoration: BoxDecoration(
                                  color: getHexColor(widget.service.color!),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   padding: const EdgeInsets.only(left: 5),
                      //   width: 40,
                      //   child: const Icon(
                      //     Icons.remove_red_eye,
                      //     size: 20,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const CustomDivider(color: Colors.grey),
              ],
            ),
          );
        }),
      );
    });
  }

  Color getHexColor(String color) {
    color = color.toUpperCase().replaceAll('#', '');
    color = 'FF$color';
    int intColor = int.tryParse(color, radix: 16) ?? 0xFF000000;
    return Color(intColor);
  }
}
