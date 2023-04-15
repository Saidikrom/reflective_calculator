import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'widgets/buttons.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController title = TextEditingController();
  String result = '';
  double num1 = 0.0;
  double num2 = 0.0;
  String operator = '';
  bool isTrue = false;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        result = '';
        num1 = 0.0;
        num2 = 0.0;
        operator = '';
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '*' ||
          buttonText == '/') {
        num1 = double.parse(result);
        operator = buttonText;
        result = '';
      } else if (buttonText == '=') {
        num2 = double.parse(result);
        if (operator == '+') {
          result = (num1 + num2).toString();
        } else if (operator == '-') {
          result = (num1 - num2).toString();
        } else if (operator == '*') {
          result = (num1 * num2).toString();
        } else if (operator == '/') {
          result = (num1 / num2).toString();
        }
        num1 = 0.0;
        num2 = 0.0;
        operator = '';
      } else {
        result += buttonText;
        title.text = result.toString();
      }
    });
  }

  String checker(String value) {
    List n = value.split("");
    var m = '';
    for (var i = 0; i < 5; i++) {
      m = "${m}${n[i]}";
    }
    return m;
  }

  void delete(String value) {
    List n = value.split("");
    var m = '';
    n.removeLast();
    for (var i = 0; i < 5; i++) {
      m = "${m}${n[i]}";
    }
    result = m;
  }

  CameraController? cameraController;

  int cameraIndex = 0;

  _startCamera() {
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint('[Camera] Access Denied');
            break;
          default:
            debugPrint('[Camera] ${e.code}');
            break;
        }
      }
    });
  }

  _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController?.dispose();
    }

    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    cameraController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController!.value.hasError) {
        debugPrint(
          '[Camera] Error: ${cameraController?.value.errorDescription}',
        );
      }
    });
    try {
      await cameraController!.initialize();
    } on CameraException catch (e) {
      debugPrint('[Camera] ${e.code}');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    if (cameras.length > 1) {
      cameraIndex = kIsWeb ? 1 : 0;
    }

    cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _startCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    final CameraController? controller = cameraController;

    if (controller == null && !controller!.value.isInitialized) {
      return;
    }

    if (lifecycleState == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (lifecycleState == AppLifecycleState.resumed) {
      _onNewCameraSelected(controller.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: cameraController != null && cameraController!.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(cameraController!),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 21, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(
                                Icons.format_list_bulleted,
                                color: Colors.white,
                                size: 35,
                              ),
                              Icon(
                                Icons.history,
                                color: Colors.white,
                                size: 35,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            result,
                            style: const TextStyle(
                              fontSize: 37,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            result.isEmpty || result.length < 5
                                ? result
                                : checker(result),
                            style: const TextStyle(
                              fontSize: 106,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Stacks()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }

  Stack Stacks() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {});
                buttonPressed("C");
              },
              child: Buttons(
                sizew: 170,
                title: "C",
              ),
            ),
            GestureDetector(
              onTap: () {
                buttonPressed("/");
              },
              child: Buttons(
                title: "/",
              ),
            ),
            GestureDetector(
              onTap: () {
                buttonPressed("*");
              },
              child: Buttons(
                title: "*",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("7");
              },
              child: Buttons(
                title: "7",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("8");
              },
              child: Buttons(
                title: "8",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("9");
              },
              child: Buttons(
                title: "9",
              ),
            ),
            GestureDetector(
              onTap: () {
                buttonPressed("-");
              },
              child: Buttons(
                title: "-",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("4");
              },
              child: Buttons(
                title: "4",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("5");
              },
              child: Buttons(
                title: "5",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("6");
              },
              child: Buttons(
                title: "6",
              ),
            ),
            GestureDetector(
              onTap: () {
                buttonPressed("+");
                // list.add(title.text);
                // title.clear();
              },
              child: Buttons(
                title: "+",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("1");
              },
              child: Buttons(
                title: "1",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("2");
              },
              child: Buttons(
                title: "2",
              ),
            ),
            GestureDetector(
              onTap: () {
                result.length > 4 ? null : buttonPressed("3");
                title.text += 3.toString();
              },
              child: Buttons(
                title: "3",
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {});
                buttonPressed("=");
              },
              child: Buttons(
                // color: const Color(0xff58BEF6),
                color: const Color(0xff56CB95).withOpacity(.8),
                sizeh: 170,
                title: "=",
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              GestureDetector(
                onTap: () {
                  result.length > 4 ? null : buttonPressed("0");
                },
                child: Buttons(
                  sizew: 170,
                  title: "0",
                ),
              ),
              GestureDetector(
                onTap: () {
                  buttonPressed(".");
                },
                child: Buttons(
                  title: ".",
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
