import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/view/desktop/components/vnavbar.dart';
import 'package:medstar_appointment/view/desktop/login.dart';
import 'package:provider/provider.dart';

class DesktopHNavbar extends StatelessWidget {
  const DesktopHNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 80,
      width: size.width - NavbarConstants.navbarWidth,
      padding: const EdgeInsets.fromLTRB(35, 0, 20, 0),
      child: Consumer<UserManagement>(
        builder: (_, provider, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Welcome ${provider.name ?? ''}',
                style: const TextStyle(fontSize: 20),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      insetPadding: const EdgeInsets.all(0),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  );
                  String? resp = await provider.logout();
                  if (resp != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(resp)),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
