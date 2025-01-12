import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';


import '../../../../common/settings/presentation/pages/settings_page.dart';
import '../blocs/blocs.dart';
import 'derivation_result_page.dart';

class DynamicFractalDerivationLevelPage extends StatefulWidget {
  static const routeName = 'dynamic_fractal_derivation_level';

  const DynamicFractalDerivationLevelPage({super.key});

  @override
  State<DynamicFractalDerivationLevelPage> createState() {
    return _DynamicFractalDerivationLevelPageState();
  }
}

class _DynamicFractalDerivationLevelPageState
    extends State<DynamicFractalDerivationLevelPage> {
  final Offset exponent = const Offset(2.0, 0.0);
  FragmentShader? _shader; // Nullable until initialized
  double _zoom = 2.00000000;
  Offset _offset = const Offset(0.00000000, 0.00000000);
  Offset _selectedPosition = const Offset(0.00000000, 0.00000000);
  final double _gridSize = 0.00001;

  final int _maxIterations = 100; // todo: max iterations

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadShader();
    });
    super.initState();
    _offset = _offset - const Offset(1.0, 1.0);
  }

  void _loadShader() async {
    try {
      final program =
          await FragmentProgram.fromAsset('shaders/burningShipShader.frag');
      setState(() {
        _shader = program.fragmentShader(); // Initialize the shader
      });
    } catch (e) {
      print('Failed to load shader: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.derivationLevelPageTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<GreatWallBloc>().add(GreatWallReset());
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.go('/${SettingsPage.routeName}');
              },
            ),
          ],
        ),
        body: Center(
          child:  BlocBuilder<GreatWallBloc, GreatWallState>(
              builder: (context, state) {
                if (state is GreatWallDeriveInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GreatWallDeriveStepSuccess) {
           return _shader == null
            ? const Center(
                child: CircularProgressIndicator()) // Show a loading indicator
            : Listener(
                onPointerSignal: (PointerSignalEvent event) {
                  // this just changes the zoom, do not change offset here
                  if (event is PointerScrollEvent) {
                    setState(() {
                      // Adjust zoom level based on scroll delta
                      var zoomFactor = event.scrollDelta.dy > 0 ? 1.1 : 0.9;

                      var zoomDelta = zoomFactor *
                          zoomFactor *
                          (event.scrollDelta.dy > 0 ? 1 : -1);
                      _zoom *= zoomFactor;
                      print("position ${event.position}");

                      print(_zoom);
                    });
                  }
                },
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      var aspectRatio = MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height;
                      var mouseX = details.localPosition.dx /
                          MediaQuery.of(context).size.width;
                      var mouseY = details.localPosition.dy /
                          MediaQuery.of(context).size.height;
                      var posX = mouseX * _zoom * aspectRatio +
                          _offset.dx +
                          0.5 * _gridSize;
                      var posY = mouseY * _zoom + _offset.dy + 0.5 * _gridSize;
                      posX = double.parse(posX.toStringAsFixed(5)) -
                          0.5 * _gridSize;
                      posY = double.parse(posY.toStringAsFixed(5)) -
                          0.5 * _gridSize;
                      posX = double.parse(posX.toStringAsFixed(6));
                      posY = double.parse(posY.toStringAsFixed(6));
                      print(details.localPosition);
                      _selectedPosition = Offset(posX, posY);
                      print('${_selectedPosition.dx}, ${_selectedPosition.dy}');
                    });
                  },
                  onScaleUpdate: (details) {
                    setState(() {
                      // this changes the zoom and offset

                      if (details.scale != 1.0) {
                        var zoomFactor = details.scale < 1.0 ? 1.01 : 0.99;
                        //
                        _zoom *= zoomFactor * details.scale;
                        print("scale ${details.scale.clamp(0.9999, 1.0001)}");
                        print("zoom $_zoom");
                      }
                      // handle pan

                      _offset =
                          _offset - details.focalPointDelta * _zoom * 0.001;
                    });
                  },
                  child: Scaffold(
                    body: CustomPaint(
                      painter: _BurningShipAdvFractalPainter(
                        shader: _shader!,
                        zoom: _zoom,
                        offset: _offset,
                        maxIterations: _maxIterations,
                        gridSize: _gridSize,
                        selectedPosition: _selectedPosition,
                        exponent: exponent,
                      ),
                      size: Size.infinite,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Future.delayed(
                          const Duration(seconds: 1),
                              () {
                            if (!context.mounted) return;
                            if (state.currentLevel < state.treeDepth) {
                              print("x: ${_selectedPosition.dx}, y: ${_selectedPosition.dy} submitted");
                              context
                                  .read<GreatWallBloc>()
                                  .add(GreatWallDerivationStepMade("x: ${_selectedPosition.dx}, y: ${_selectedPosition.dy}"));
                              context.go('/${DynamicFractalDerivationLevelPage.routeName}');
                            } else {
                              print("process completed");
                              context
                                  .read<GreatWallBloc>()
                                  .add(GreatWallDerivationFinished());
                              context.go(
                                '/${DerivationResultPage.routeName}',
                              );
                            }
                          },
                        );

                        // widget.onSubmit(_selectedPosition);
                      },
                      child: const Icon(Icons.check),
                    ),
                  ),
                )
           );
  } else {
  return Center(
  child: Text(AppLocalizations.of(context)!.noLevel),
  );
  }
  }
        ),
        ),
    );
  }
}

class _BurningShipAdvFractalPainter extends CustomPainter {
  final FragmentShader shader;
  final double zoom;
  final Offset offset;
  final int maxIterations;
  final double gridSize;
  Offset selectedPosition;
  Offset exponent;

  _BurningShipAdvFractalPainter({
    required this.shader,
    required this.zoom,
    required this.offset,
    required this.maxIterations,
    required this.gridSize,
    required this.selectedPosition,
    required this.exponent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, offset.dx);
    shader.setFloat(3, offset.dy);
    shader.setFloat(4, zoom);
    shader.setFloat(5, maxIterations.toDouble());
    shader.setFloat(6, gridSize);
    shader.setFloat(7, selectedPosition.dx);
    shader.setFloat(8, selectedPosition.dy);
    shader.setFloat(9, exponent.dx);
    shader.setFloat(10, exponent.dy);

    final paint = Paint()..shader = shader;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
