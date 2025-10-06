import 'dart:math' as math;

import 'package:block_demo/screens/draggable_screen.dart';
import 'package:block_demo/screens/isolate_screen.dart';
import 'package:block_demo/screens/video_player_screen.dart';
import 'package:block_demo/widget/hero_layout_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart' hide ImageInfo;
import 'package:flutter/material.dart' hide ImageInfo;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:home_widget/home_widget.dart';

import 'widget/reusable_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyApp());
}

Future<void> backgroundCallback(Uri? uri) async {
  // Called when the widget fires an intent configured to call back to Dart.
  // parse uri and perform action
  print("backgroundCallback uri : ${uri}");
  if (uri?.host == 'headlineClicked') {
    // For example: open the app, or log analytics
    debugPrint("Widget headline clicked!");
    // You could also store state or send a notification
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return CupertinoApp(
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hides the debug banner
      // theme: CupertinoThemeData(brightness: Brightness.light),
      // theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

enum SingingCharacter { one, two, three }

enum Emotion { exited, happy, sad, shocked }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _initTweenAnimation();
    super.initState();
  }

  @override
  void dispose() {
    controllerCarousel.dispose();
    _controllerAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;

    // return CupertinoPageScaffold(
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: CupertinoColors.white,
        body: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(largeTitle: Text("Cupertino")),
            SliverList(
              delegate: SliverChildListDelegate([
                _linearGradient(),
                _rawMagnifier(),
                _flutterAnimate(),
                _draggable(),
                _homeWidget(),
                _flChart(),
                _overlayPortal(),
                _dropdownMenu(),
                _segmentedButton(),
                _isolate(),
                _tween(),
                _listGenerate(),
                _videoPlayer(),
                _searchAnchor(),
                _searchBar(),
                _carouselView(height),
                _cupertinoSwitch(),
                _cupertinoCheckBox(),
                _cupertinoSlidingSegment(),
                _cupertinoSheetRoute(),
                _cupertinoRadio(),
                SizedBox(height: 56),
              ]),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavigation(),
      ),
    );
  }

  /// ---------- LinearGradient ---------- ///

  Widget _linearGradient() {
    return ReusableContainer(
      title: "Linear Gradient",
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      CupertinoColors.activeBlue,
                      CupertinoColors.systemTeal,
                      CupertinoColors.systemPurple,
                      CupertinoColors.destructiveRed,
                      CupertinoColors.activeOrange,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(math.pi / 2)
                )
            ),
          ),
          SizedBox(height: 12,),
          ShaderMask(shaderCallback: (bounds) =>
              LinearGradient(colors: [
                CupertinoColors.activeBlue,
                CupertinoColors.systemTeal,
                CupertinoColors.systemPurple,
                CupertinoColors.destructiveRed,
                CupertinoColors.activeOrange,
              ]).createShader(bounds),
            child:  Text("Hello Flutter!!",
              style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 22, fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }

  /// ---------- Bottom Navigation ---------- ///

  Widget _bottomNavigation(){

     var currentPageIndex = 0;

    return NavigationBar(
      animationDuration: const Duration(milliseconds: 1000),
      destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.explore), label: 'Explore'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      selectedIndex: currentPageIndex,
    );
   }

  /// ---------- RawMagnifier ---------- ///

  static const double magnifierRadius = 50.0;
  Offset dragGesturePosition = const Offset(100, 100);

  Widget _rawMagnifier() {
    return ReusableContainer(
      title: "RawMagnifier",
      widget: Stack(
        children: <Widget>[
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) => setState(() {
              dragGesturePosition = details.localPosition;
            }),
            onPanDown: (DragDownDetails details) => setState(() {
              dragGesturePosition = details.localPosition;
            }),
            child: RawMagnifier(
              size: Size(150, 150),
              decoration: MagnifierDecoration(),
              focalPointOffset: Offset.zero,
              magnificationScale: 1,
              child: Text("sgadjgkafkadfvkajhfdvajhsdvjh"),
            ),
          ),
          Positioned(
            left: dragGesturePosition.dx - magnifierRadius,
            top: dragGesturePosition.dy - magnifierRadius,
            child: const RawMagnifier(
              decoration: MagnifierDecoration(
                shape: CircleBorder(
                  side: BorderSide(color: Colors.pink, width: 3),
                ),
              ),
              size: Size(magnifierRadius * 2, magnifierRadius * 2),
              magnificationScale: 2,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- Flutter Animate ---------- ///

  Widget _flutterAnimate() {
    return ReusableContainer(
      title: "Flutter Animate",
      widget: Animate(
        // effects: [FadeEffect(),SlideEffect()],
        child: Text("Flutter Animate", style: TextStyle(fontSize: 18))
            .animate()
            .fade(duration: 2000.ms)
            // .fade()
            .tint(color: CupertinoColors.activeOrange)
            .slide(curve: Curves.easeIn)
            .then()
            .shake(duration: 750.ms),
      ),
    );
  }

  /// ---------- Draggable ---------- ///

  Widget _draggable() {
    return ReusableContainer(
      title: "Draggable",
      widget: CupertinoButton.filled(
        child: Text("Draggable Screen"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const DraggableScreen(),
            ),
          );
        },
      ),
    );
  }

  /// ---------- home_widget ---------- ///
  /// https://chatgpt.com/share/68df91c6-36cc-8007-8654-d97d1a64e76e
  /*
  Create the native widget boilerplate
    Open the Android module in Android Studio (right-click android/ → Open in Android Studio).
    Then: Right click app → New → Widget → App Widget. Fill the dialog (e.g. Class name NewsWidget, min width 3 cells, min height 3 cells). Android Studio will create:

    -> res/layout/news_widget.xml (the widget UI),
    -> res/xml/news_widget_info.xml (the appwidget-provider metadata),
    -> a Kotlin (or Java) NewsWidget.kt (extends AppWidgetProvider),
    -> and a <receiver> entry added to AndroidManifest.xml.
   */

  String androidWidgetName =
      'NewsWidget'; // must match your AppWidgetProvider class name

  void updateHeadline(String title, String description) async {
    await HomeWidget.saveWidgetData<String>('headline_title', title);
    await HomeWidget.saveWidgetData<String>(
      'headline_description',
      description,
    );
    await HomeWidget.updateWidget(androidName: androidWidgetName);
  }

  Widget _homeWidget() {
    // https://chatgpt.com/share/68df91c6-36cc-8007-8654-d97d1a64e76e
    return ReusableContainer(
      title: "home_widget",
      widget: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: CupertinoButton.filled(
          child: Text("Home Widget Data Change"),
          onPressed: () {
            updateHeadline("Headline Title", "Headline Description");
          },
        ),
      ),
    );
  }

  /// ---------- fl_chart ---------- ///

  Widget _flChart() {
    return ReusableContainer(
      title: "fl chart",
      widget: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 10,
                      title: "Internet",
                      titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                      showTitle: true,
                      radius: 50,
                      color: CupertinoColors.activeBlue,
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: "Food",
                      titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                      showTitle: true,
                      radius: 50,
                      color: CupertinoColors.activeGreen,
                    ),
                    PieChartSectionData(
                      value: 10,
                      title: "Fun",
                      titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                      showTitle: true,
                      radius: 50,
                      color: CupertinoColors.activeOrange,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              height: 200,
              width: 250,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxX: 80,
                  minX: 0,
                  maxY: 80,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 10),
                        FlSpot(10, 5),
                        FlSpot(15, 25),
                        FlSpot(20, 40),
                        FlSpot(25, 50),
                      ],
                      color: CupertinoColors.activeGreen,
                      barWidth: 2,
                      isCurved: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- Overlay Portal ---------- ///

  final _overlayPortalController = OverlayPortalController();

  Widget _overlayPortal() {
    return ReusableContainer(
      title: "Overlay Portal",
      widget: CupertinoButton.filled(
        child: OverlayPortal(
          controller: _overlayPortalController,
          overlayChildBuilder: (BuildContext context) {
            return Positioned(
              top: 56,
              right: 20,
              child: Text(
                "I'm overlay!!",
                style: TextStyle(fontSize: 20, color: CupertinoColors.black),
              ),
            );
          },
          child: Text("Press Click"),
        ),
        onPressed: () {
          _overlayPortalController.toggle();
        },
      ),
    );
  }

  /// ---------- Dropdown Menu ---------- ///

  Widget _dropdownMenu() {
    return ReusableContainer(
      title: "Dropdown Menu",
      widget: DropdownMenu(
        width: double.infinity,
        enableFilter: true,
        requestFocusOnTap: true,
        helperText: "Choose Color",
        label: Text("Select Color"),
        dropdownMenuEntries: <DropdownMenuEntry<Color>>[
          DropdownMenuEntry(value: Colors.red, label: "Red"),
          DropdownMenuEntry(value: Colors.green, label: "Green"),
          DropdownMenuEntry(value: Colors.blue, label: "Blue"),
          DropdownMenuEntry(value: Colors.yellow, label: "Yellow"),
          DropdownMenuEntry(value: Colors.purple, label: "Purple"),
        ],
        onSelected: (color) {
          if (color != null) {}
        },
      ),
    );
  }

  /// ---------- Segmented Button ---------- ///

  Set<String> _selectedSegment = {'Part A'};

  void updateSegmentSelection(Set<String> newSelection) {
    setState(() {
      _selectedSegment = newSelection;
    });
  }

  Widget _segmentedButton() {
    return ReusableContainer(
      title: "Segmented Button",
      widget: SizedBox(
        width: double.infinity,
        child: SegmentedButton(
          selected: _selectedSegment,
          onSelectionChanged: updateSegmentSelection,
          multiSelectionEnabled: false,
          style: SegmentedButton.styleFrom(
            backgroundColor: CupertinoColors.white,
            foregroundColor: CupertinoColors.black,
            selectedForegroundColor: CupertinoColors.activeBlue,
            selectedBackgroundColor: CupertinoColors.systemTeal.withValues(
              alpha: 0.3,
            ),
            side: BorderSide(color: CupertinoColors.activeBlue),
          ),
          segments: <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: 'Part A',
              label: Text('Part A'),
              icon: Icon(CupertinoIcons.circle_grid_hex),
            ),
            ButtonSegment<String>(
              value: 'Part B',
              label: Text('Part B'),
              icon: Icon(CupertinoIcons.circle_grid_3x3),
            ),
            ButtonSegment<String>(
              value: 'Part C',
              label: Text('Part C'),
              icon: Icon(CupertinoIcons.square_grid_2x2),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- Isolate ---------- ///

  Widget _isolate() {
    return ReusableContainer(
      title: "Isolate",
      widget: CupertinoButton.filled(
        child: Text("Isolate Screen"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const IsolateScreen(),
            ),
          );
        },
      ),
    );
  }

  /// ---------- Tween ---------- ///

  late AnimationController _controllerAnimation;
  late Animation<double> textSizeAnimation;

  void _initTweenAnimation() {
    _controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    textSizeAnimation = Tween<double>(begin: 12.0, end: 16.0).animate(
      CurvedAnimation(parent: _controllerAnimation, curve: Curves.linear),
    );

    // Start the animation (optional)
    _controllerAnimation.repeat(reverse: true);
  }

  Widget _tween() {
    return AnimatedBuilder(
      animation: textSizeAnimation,
      builder: (BuildContext context, Widget? child) {
        return ReusableContainer(
          title: "Tween",
          widget: Text(
            "Tween",
            style: TextStyle(fontSize: textSizeAnimation.value),
          ),
        );
      },
    );
  }

  /// ---------- List Generate ---------- ///

  Widget _listGenerate() {
    return ReusableContainer(
      title: "List Generate",
      widget: Row(
        children: [
          ...List.generate(5, (int index) => Icon(CupertinoIcons.star)),
        ],
      ),
    );
  }

  /// ---------- Video Player ---------- ///

  Widget _videoPlayer() {
    return ReusableContainer(
      title: "Video Player Screen",
      widget: CupertinoButton.filled(
        child: Text("Video Player"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const VideoPlayerScreen(),
            ),
          );
        },
      ),
    );
  }

  /// ---------- Search Anchor ---------- ///

  void searchForProduct(Product product) {
    debugPrint("Searching for: ${product.label}");
  }

  Widget _searchAnchor() {
    return ReusableContainer(
      title: "Search Anchor",
      widget: SearchAnchor.bar(
        barBackgroundColor: WidgetStateProperty.all(CupertinoColors.white),

        // barOverlayColor: WidgetStateProperty.all(CupertinoColors.white),
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
              final String input = controller.value.text.toLowerCase();

              // Filter products based on search input
              final results = Product.values
                  .where(
                    (product) => product.label.toLowerCase().contains(input),
                  )
                  .toList();

              // Return list of ItemTiles
              return results.map((product) {
                return ItemTile(
                  product: product,
                  onTap: () {
                    controller.closeView(product.label);
                    searchForProduct(product);
                  },
                );
              });
            },
      ),
    );
  }

  /// ---------- Search Bar ---------- ///
  Widget _searchBar() {
    return ReusableContainer(
      title: "Search Bar",
      widget: SearchBar(
        leading: Icon(CupertinoIcons.search),
        hintText: "Search",
        backgroundColor: WidgetStateProperty.all(CupertinoColors.white),
      ),
    );
  }

  /// ---------- Carousel View ---------- ///
  final CarouselController controllerCarousel = CarouselController(
    initialItem: 1,
  );

  Widget _carouselView(double height) {
    return ReusableContainer(
      title: "Carousel View",
      widget: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height / 2.6),
        child: CarouselView.weighted(
          controller: controllerCarousel,
          backgroundColor: CupertinoColors.opaqueSeparator,
          itemSnapping: true,
          flexWeights: const <int>[1, 7, 1],
          children: ImageInfo.values.map((ImageInfo image) {
            return HeroLayoutCard(imageInfo: image);
          }).toList(),
        ),
      ),
    );
  }

  /// ---------- Switch ---------- ///
  bool _isSwitch = false;

  Widget _cupertinoSwitch() {
    return ReusableContainer(
      title: "Switch",
      widget: CupertinoSwitch(
        activeTrackColor: CupertinoColors.activeGreen,
        inactiveTrackColor: CupertinoColors.destructiveRed,
        thumbColor: CupertinoColors.white,
        inactiveThumbColor: CupertinoColors.activeBlue.withValues(alpha: 0.1),
        value: _isSwitch,
        onChanged: (bool? value) => setState(() {
          _isSwitch = value!;
        }),
      ),
    );
  }

  /// ---------- CheckBox ---------- ///

  bool _isChecked = false;

  Widget _cupertinoCheckBox() {
    return ReusableContainer(
      title: "CheckBox",
      widget: GestureDetector(
        onTap: () {
          setState(() {
            _isChecked = !_isChecked;
          });
        },
        child: Row(
          children: [
            CupertinoCheckbox(
              value: _isChecked,
              side: BorderSide(color: CupertinoColors.activeBlue, width: 2),
              checkColor: CupertinoColors.white,
              activeColor: CupertinoColors.activeGreen,
              onChanged: (bool? value) => setState(() {
                _isChecked = value!;
              }),
            ),
            Text("Check"),
          ],
        ),
      ),
    );
  }

  /// ---------- Sliding Segment ---------- ///

  Emotion _selectedEmotion = Emotion.happy;

  Widget exitedWidget() {
    return Column(
      children: [
        SizedBox(height: 6),
        Text("Exited", style: TextStyle(fontSize: 14)),
        SizedBox(height: 6),
        Text("😃"),
        SizedBox(height: 6),
      ],
    );
  }

  Widget happyWidget() {
    return Column(
      children: [
        SizedBox(height: 6),
        Text("Happy", style: TextStyle(fontSize: 14)),
        SizedBox(height: 6),
        Text("😊"),
        SizedBox(height: 6),
      ],
    );
  }

  Widget sadWidget() {
    return Column(
      children: [
        SizedBox(height: 6),
        Text("Sad", style: TextStyle(fontSize: 14)),
        SizedBox(height: 6),
        Text("☹️"),
        SizedBox(height: 6),
      ],
    );
  }

  Widget shockedWidget() {
    return Column(
      children: [
        SizedBox(height: 6),
        Text("Shocked", style: TextStyle(fontSize: 14)),
        SizedBox(height: 6),
        Text("🤯"),
        SizedBox(height: 6),
      ],
    );
  }

  late final Map<Emotion, Widget> segmentMap = <Emotion, Widget>{
    Emotion.exited: exitedWidget(),
    Emotion.happy: happyWidget(),
    Emotion.sad: sadWidget(),
    Emotion.shocked: shockedWidget(),
  };

  Widget _cupertinoSlidingSegment() {
    return ReusableContainer(
      title: 'Sliding Segment',
      widget: SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl<Emotion>(
          groupValue: _selectedEmotion,
          padding: EdgeInsets.all(12),
          disabledChildren: {Emotion.shocked},
          // thumbColor: Colors.grey.withValues(alpha: 1),
          children: segmentMap,
          onValueChanged: (newValue) {
            setState(() {
              _selectedEmotion = newValue!;
            });
          },
        ),
      ),
    );
  }

  /// ---------- Sheet Route ---------- ///

  Widget _cupertinoSheetRoute() {
    return ReusableContainer(
      title: 'Sheet Route',
      widget: CupertinoButton.filled(
        // color: Colors.black12,
        onPressed: () {
          showCupertinoSheet(
            context: context,
            builder: (context) {
              return CupertinoPageScaffold(
                backgroundColor: Colors.white,
                navigationBar: CupertinoNavigationBar(
                  middle: Text("1) Cupertino Sheet"),
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Icon(CupertinoIcons.back),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      CupertinoButton.filled(
                        onPressed: () {
                          showCupertinoSheet(
                            context: context,
                            useNestedNavigation: false,
                            builder: (context) {
                              return CupertinoPageScaffold(
                                backgroundColor: Colors.white,
                                navigationBar: CupertinoNavigationBar(
                                  middle: Text("2) Cupertino Sheet"),
                                  leading: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Icon(CupertinoIcons.back),
                                  ),
                                ),
                                child: SafeArea(
                                  child: Column(
                                    children: [
                                      CupertinoButton(
                                        color: Colors.black12,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Back to previous page"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text("Go to next page 2"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Text("Click"),
      ),
    );
  }

  SingingCharacter? _character = SingingCharacter.one;

  /// ---------- Radio Selection ---------- ///

  void changeRadioSelection(SingingCharacter value) {
    setState(() {
      _character = value;
    });
  }

  Widget _cupertinoRadio() {
    return ReusableContainer(
      title: 'Radio',
      widget: RadioGroup<SingingCharacter>(
        groupValue: _character,
        onChanged: (value) {
          changeRadioSelection(value!);
        },
        child: CupertinoListSection(
          backgroundColor: Colors.white,
          margin: EdgeInsets.zero,
          children: <Widget>[
            CupertinoListTile(
              title: const Text('Lafayette'),
              leading: const CupertinoRadio<SingingCharacter>(
                value: SingingCharacter.one,
              ),
              onTap: () {
                changeRadioSelection(SingingCharacter.one);
              },
            ),
            CupertinoListTile(
              title: Text('Thomas Jefferson'),
              leading: CupertinoRadio<SingingCharacter>(
                value: SingingCharacter.two,
              ),
              onTap: () {
                changeRadioSelection(SingingCharacter.two);
              },
            ),
            CupertinoListTile(
              title: Text('Thomas Jefferson Te'),
              leading: CupertinoRadio<SingingCharacter>(
                value: SingingCharacter.three,
              ),
              onTap: () {
                changeRadioSelection(SingingCharacter.three);
              },
            ),
          ],
        ),
      ),
    );
  }
}
