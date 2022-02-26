import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/tarjetas/tarjetas.dart';
import 'package:money_track/user_page/bloc/accounts_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'bloc/picture_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScreenshotController screenshotController = ScreenshotController();
  Future _captureAndShare() async {
    String _tempDirectory = (await getTemporaryDirectory()).path;
    var fn = DateTime.now().microsecondsSinceEpoch.toString() + '.png';
    String? _imgDir = await screenshotController.captureAndSave(_tempDirectory,
        fileName: fn, delay: Duration(milliseconds: 10));

    Share.shareFiles([_imgDir!], text: 'Compartir cuentas');
  }

  final List<String> _tutorialNames = [
    'share_screen_id',
    'see_card_id',
    'change_photo_id',
    'see_tutorial_ids'
  ];

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AccountsBloc>(context).add(
      UpdateAccountsEvent(),
    );
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DescribedFeatureOverlay(
              featureId: _tutorialNames[0],
              tapTarget: const Icon(Icons.share),
              title: Text('Compartir captura'),
              description: Text('Haz click para compartir esta pantalla'),
              child: IconButton(
                tooltip: "Compartir pantalla",
                onPressed: () async {
                  await _captureAndShare();
                },
                icon: Icon(Icons.share),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  DescribedFeatureOverlay(
                    featureId: _tutorialNames[1],
                    tapTarget: const Icon(Icons.credit_card),
                    title: Text('Ver tarjeta'),
                    description:
                        Text('Haz click para ver tus tarjetas de credito'),
                    backgroundColor: Color(0xff123b5e),
                    overflowMode: OverflowMode.extendBackground,
                    child: CircularButton(
                      textAction: "Ver tarjeta",
                      iconData: Icons.credit_card,
                      bgColor: Color(0xff123b5e),
                      action: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Tarjetas()),
                        );
                      },
                    ),
                  ),
                  DescribedFeatureOverlay(
                    featureId: _tutorialNames[2],
                    tapTarget: const Icon(Icons.camera_alt),
                    title: Text('Cambiar foto'),
                    description: Text('Haz click para cambiar tu foto'),
                    backgroundColor: Colors.orange,
                    child: CircularButton(
                      textAction: "Cambiar foto",
                      iconData: Icons.camera_alt,
                      bgColor: Colors.orange,
                      action: () {
                        BlocProvider.of<PictureBloc>(context).add(
                          ChangeImageEvent(),
                        );
                      },
                    ),
                  ),
                  DescribedFeatureOverlay(
                    featureId: _tutorialNames[3],
                    tapTarget: const Icon(Icons.play_arrow),
                    title: Text('Ver tutorial'),
                    description: Text('Haz click para repetir este tutorial'),
                    backgroundColor: Colors.green,
                    child: CircularButton(
                      textAction: "Ver tutorial",
                      iconData: Icons.play_arrow,
                      bgColor: Colors.green,
                      action: () {
                        FeatureDiscovery.clearPreferences(
                            context, _tutorialNames);
                        FeatureDiscovery.discoverFeatures(
                          context,
                          _tutorialNames,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48),
              BlocConsumer<AccountsBloc, AccountsState>(
                  builder: (context, state) {
                    if (state is AccountsUpdatedState) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: state.decodedResult['users']!.length,
                          itemBuilder: (context, index) {
                            return CuentaItem(
                              tipoCuenta: state.decodedResult['users'][index]
                                  ['nombre'],
                              saldoDisponible: state.decodedResult['users']
                                      [index]['dinero']
                                  .toString(),
                              terminacion: (state.decodedResult['users'][index]
                                      ['tarjeta'] as int)
                                  .toString(),
                            );
                          },
                        ),
                      );
                    } else if (state is AccountsLoadingState) {
                      return CircularProgressIndicator();
                    } else if (state is AccountsNoDataState) {
                      return Text('No hay datos disponibles');
                    }
                    return Text('Error');
                    setState(() {});
                  },
                  listener: (context, state) {}),
            ],
          ),
        ),
      ),
    );
  }
}
