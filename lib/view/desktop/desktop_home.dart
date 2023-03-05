import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/appointment_service.dart';
import 'package:medstar_appointment/services/customer_service.dart';
import 'package:medstar_appointment/services/desktop_home_view_service.dart';
import 'package:medstar_appointment/services/services_service.dart';
import 'package:medstar_appointment/view/desktop/appointment/base_card.dart';
import 'package:medstar_appointment/view/desktop/components/hnavbar.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/customer/base_card.dart';
import 'package:medstar_appointment/view/desktop/services/base_card.dart';
import 'package:provider/provider.dart';

class DesktopMainPage extends StatefulWidget {
  const DesktopMainPage({super.key});

  @override
  State<DesktopMainPage> createState() => _DesktopMainPageState();
}

class _DesktopMainPageState extends State<DesktopMainPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DesktopHomeScreenService>(
      create: (context) => DesktopHomeScreenService(),
      child: Scaffold(
        body: Row(
          children: [
            const DesktopVNavbar(),
            Consumer<DesktopHomeScreenService>(builder: (_, provider, __) {
              return Column(
                children: [
                  const DesktopHNavbar(),
                  Visibility(
                    visible: provider.currentIndex ==
                        NavbarConstants.appointmentIndex,
                    child: Expanded(
                      child: ChangeNotifierProvider<AppointmentService>(
                        create: (context) {
                          final service = AppointmentService();
                          service.getAll();
                          return service;
                        },
                        child: const DesktopAppointmentCard(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        provider.currentIndex == NavbarConstants.customerIndex,
                    child: Expanded(
                      child: ChangeNotifierProvider<CustomerService>(
                        create: (context) {
                          final service = CustomerService();
                          service.getAll();
                          return service;
                        },
                        child: const DesktopCustomerCard(),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        provider.currentIndex == NavbarConstants.serviceIndex,
                    child: Expanded(
                      child: ChangeNotifierProvider<ServiceService>(
                        create: (context) {
                          final service = ServiceService();
                          service.getAll();
                          return service;
                        },
                        child: const DesktopServiceCard(),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
