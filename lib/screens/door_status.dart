import 'package:flutter/material.dart';

class DoorStatus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DoorStatusState();
}

class _DoorStatusState extends State<DoorStatus> {
  @override
  Widget build(BuildContext context) {
    // Obtiene el tamaño de la pantalla
    var screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: screenSize.width / (screenSize.height / 3),
            children: List.generate(12, (index) {
              return Center(
                child: Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
