import 'package:carea/app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  String roadAddress = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => openKpostalView());
  }

  void openKpostalView() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KpostalView(
          useLocalServer: true,
          localPort: 1024,
          callback: (Kpostal result) {
            Navigator.pop(context, {
              'roadAddress': result.address,
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text('road_address',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('result: $roadAddress'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
