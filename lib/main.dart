import 'dart:ffi';

import 'package:block_demo/screens/video_player_screen.dart';
import 'package:block_demo/widget/hero_layout_card.dart';
import 'package:flutter/cupertino.dart' hide ImageInfo;
import 'package:flutter/material.dart' hide ImageInfo;

import 'widget/reusable_container.dart';

void main() {
  runApp(const MyApp());
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

class _HomeScreenState extends State<HomeScreen>  with SingleTickerProviderStateMixin {

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
                SizedBox(height: 56,)
              ]),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- Tween ---------- ///

  late AnimationController _controllerAnimation;
  late Animation<double> textSizeAnimation;

  void _initTweenAnimation(){
    _controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    textSizeAnimation = Tween<double>(
      begin: 12.0,
      end: 16.0,
    ).animate(
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
          widget: Text("Tween",style: TextStyle(fontSize: textSizeAnimation.value),),
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
      title: "Video Player",
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
