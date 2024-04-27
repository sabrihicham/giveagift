import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giveagift/view/widgets/gift_card.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverStack(
          children: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/home_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (0.1),
                        vertical: MediaQuery.of(context).size.height * (0.1),
                      ),
                      child: FittedBox(
                        child: Container(
                          height: 200,
                          width: 300,
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          decoration: const BoxDecoration(
                            color:  Color.fromRGBO(182, 32, 38, 0.75),
                            shape: BoxShape.rectangle,
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Give Choice Give A Gift',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "When Gifting Becomes Persona",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          "- Choose What Suits You -",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GiftCard(
                          frontBackgroundImage: 'https://giveagift.com.sa/images/home2.png',
                          backBackgroundImage: "https://i.ibb.co/jJRT8qW/back.png",
                         color: Colors.grey.shade200, 
                        ),
                        // Gift Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Gift Cards",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Choose a gift card from our wide collection
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Text(
                            "Choose a gift card from our wide collection",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const GiftCard(
                          frontBackgroundImage: 'https://i.ibb.co/64djgNY/home2.webp',
                          backBackgroundImage: "https://i.ibb.co/4Rd3jz2/home1-back.png"
                        ),
                        // Custom Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Custom Cards",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Create a custom gift card for your loved ones
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Text(
                            "Create a custom gift card for your loved ones",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ),
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              // stretch: true,
              // forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                // stretchModes: [StretchMode.zoomBackground],
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // floating: true,
              // forceElevated: false,
              // snap: true,
              actions: [
                Badge(
                  label: const Text('1'),
                  isLabelVisible: true,
                  backgroundColor: Colors.redAccent,
                  offset: const Offset(-5, 5),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shopping_bag_rounded,
                      size: 30,
                    ),
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).padding.bottom,
          ),
        )
      ],
    );
  }
}