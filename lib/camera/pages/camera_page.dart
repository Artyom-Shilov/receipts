import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    final cameraCubit = BlocProvider.of<BaseCameraCubit>(context);
    print(cameraCubit.state.status);
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        child: Stack(children: [
          SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(cameraCubit.state.cameraController!)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: IconButton(
                icon: Icon(Icons.add_a_photo_sharp),
                onPressed: () async {
                  final photoFuture =
                      cameraCubit.state.cameraController!.takePicture();
                  /*await BlocProvider.of<BaseRecipeInfoCubit>(context)
                      .saveUserRecipePhoto(photoFuture);*/
                },
              ),
            ),
          )
        ]),
      ),
    );
  }
}
