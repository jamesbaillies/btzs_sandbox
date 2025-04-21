import 'package:flutter/cupertino.dart';
import '../../utils/session.dart';

class DOFPage extends StatelessWidget {
  final Session session;

  const DOFPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(CupertinoIcons.viewfinder, size: 64, color: CupertinoColors.systemGrey),
              SizedBox(height: 16),
              Text(
                'DOF Calculator Coming Soon',
                style: TextStyle(fontSize: 18, color: CupertinoColors.inactiveGray),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
