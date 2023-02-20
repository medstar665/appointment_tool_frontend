import 'package:flutter/material.dart';
import 'package:medstar_appointment/model/customer.dart';
import 'package:medstar_appointment/services/customer_service.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/components/divider.dart';
import 'package:medstar_appointment/view/desktop/components/searchbar.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/customer/home.dart';
import 'package:provider/provider.dart';

class DesktopListCustomer extends StatefulWidget {
  const DesktopListCustomer({super.key, required this.goToPage});
  final Function goToPage;

  @override
  State<DesktopListCustomer> createState() => _DesktopListCustomerState();
}

class _DesktopListCustomerState extends State<DesktopListCustomer> {
  @override
  Widget build(BuildContext context) {
    final double tableWidth = MediaQuery.of(context).size.width -
        NavbarConstants.navbarWidth -
        (Constants.cardLeftMargin + Constants.cardRightMargin);
    return Consumer<CustomerService>(
      builder: (_, provider, __) => Column(
        children: [
          DesktopSearchbar(
            keyword: 'Customer',
            serviceInstance: provider,
            goToPage: widget.goToPage,
            goToPageIndex: DesktopCustomerPageConstants.addPage,
          ),
          const CustomDivider(),
          _CustomerTableHeading(tableWidth: tableWidth),
          const CustomDivider(),
          Expanded(
            child: _CustomerTableData(
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

class _CustomerTableHeading extends StatelessWidget {
  const _CustomerTableHeading({required this.tableWidth});

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
              'Full Name',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Phone',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Email',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Age',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            width: boxWidth,
            child: const Text(
              'Note',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerTableData extends StatelessWidget {
  const _CustomerTableData({
    required this.provider,
    required this.tableWidth,
    required this.goToPage,
  });

  final CustomerService provider;
  final double tableWidth;
  final Function goToPage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: provider.customers.length,
        itemBuilder: (context, index) {
          final customer = provider.customers[index];
          if (index == 0) {
            return Stack(
              children: [
                _CustomerListItem(
                    customer: customer,
                    tableWidth: tableWidth,
                    goToPage: goToPage),
                if (provider.isSearchingAll)
                  const LinearProgressIndicator(minHeight: 2.5),
              ],
            );
          }
          return _CustomerListItem(
              customer: customer, tableWidth: tableWidth, goToPage: goToPage);
        });
  }
}

class _CustomerListItem extends StatefulWidget {
  const _CustomerListItem({
    Key? key,
    required this.customer,
    required this.tableWidth,
    required this.goToPage,
  }) : super(key: key);

  final CustomerModel customer;
  final double tableWidth;
  final Function goToPage;

  @override
  State<_CustomerListItem> createState() => _CustomerListItemState();
}

class _CustomerListItemState extends State<_CustomerListItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final double boxWidth = widget.tableWidth / 5;
    DateTime today = DateTime.now();
    DateTime dob = DateTime.tryParse('${widget.customer.dob}')!;
    int years = today.year - dob.year;
    if ((today.month - dob.month) < 0) {
      years--;
    } else if ((today.month - dob.month) == 0) {
      if ((today.day - dob.day) <= 0) {
        years--;
      }
    }
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
        child: Consumer<CustomerService>(builder: (_, provider, __) {
          return GestureDetector(
            onTap: () {
              provider.setViewCustomer(widget.customer);
              widget.goToPage(DesktopCustomerPageConstants.viewPage);
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
                        child: Text(
                            '${widget.customer.firstName} ${widget.customer.lastName}'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth,
                        child: Text('${widget.customer.phone}'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth,
                        child: Text('${widget.customer.email}'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth,
                        child: Text('$years Years'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        width: boxWidth,
                        child: Text(
                          '${widget.customer.note}',
                          overflow: TextOverflow.clip,
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
}
