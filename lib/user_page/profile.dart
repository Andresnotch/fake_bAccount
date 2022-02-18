import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/picture_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "Compartir pantalla",
            onPressed: () {
              // TODO
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BlocConsumer<PictureBloc, PictureState>(
                listener: (context, state) {
                  if (state is PictureErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${state.errorMsg}")),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PictureSelectedState) {
                    return CircleAvatar(
                      backgroundImage: FileImage(state.picture!),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 122, 113, 113),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Text(
                "Bienvenido",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: 8),
              Text("Usuario${UniqueKey()}"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularButton(
                    textAction: "Ver tarjeta",
                    iconData: Icons.credit_card,
                    bgColor: Color(0xff123b5e),
                    action: null,
                  ),
                  CircularButton(
                    textAction: "Cambiar foto",
                    iconData: Icons.camera_alt,
                    bgColor: Colors.orange,
                    action: () {
                      BlocProvider.of<PictureBloc>(context).add(
                        ChangeImageEvent(),
                      );
                    },
                  ),
                  CircularButton(
                    textAction: "Ver tutorial",
                    iconData: Icons.play_arrow,
                    bgColor: Colors.green,
                    action: null,
                  ),
                ],
              ),
              SizedBox(height: 48),
              CuentaItem(),
              CuentaItem(),
              CuentaItem(),
            ],
          ),
        ),
      ),
    );
  }
}
