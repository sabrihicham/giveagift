import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/widgets/ready_card.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ReadyToUsePage extends StatelessWidget {
  const ReadyToUsePage({
    super.key,
    required this.controller,
  });

  final CardsController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardsController>(
      init: controller,
      id: CardType.readyToUse.name,
      builder: (controller) => Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 100,
            child: Center(
              child: Text(
                'بطاقات جاهزة لك',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Filter by price in range
                      showModalBottomSheet(
                        context: context, 
                        isDismissible: false,
                        builder: (context) {
                          return ReadyCardFilter(
                            controller: controller,
                          );
                        }
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          'filter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.filter_alt_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '${'cards'.tr} ${controller.readyCardsSourceRepository.length}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Add line
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 0),
            width: double.infinity,
            color: Colors.grey[400],
          ),
          Flexible(
            child: LoadingMoreList(
              ListConfig<CardData>(
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ReadyCard(
                      card: item,
                    ),
                  );
                },
                addAutomaticKeepAlives: true,
                sourceList: controller.readyCardsSourceRepository,
                lastChildLayoutType: LastChildLayoutType.fullCrossAxisExtent,
                cacheExtent: 280,
                indicatorBuilder: (context, status) {
                  if(status == IndicatorStatus.none) {
                    return const SizedBox.shrink();
                  } else if(status == IndicatorStatus.loadingMoreBusying) {
                    return Center(
                      child: Column(
                        children: [
                          const CircularProgressIndicator.adaptive(),
                          Text(
                            'Loading more',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    );

                  } else if (status == IndicatorStatus.fullScreenBusying) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator.adaptive(),
                          const SizedBox(height: 10),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    );

                  } else if (status == IndicatorStatus.error) {
                    return const Center(
                      child: Text('Error loading data'),
                    );

                  } else if (status == IndicatorStatus.fullScreenError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error loading data',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 10),
                          CupertinoButton(
                            // color: Color.fromRGBO(65, 84, 123, 1),
                            // color: Theme.of(context).primaryColor,
                            onPressed: () {
                              controller.readyCardsSourceRepository.refresh();
                            },
                            child: Text(
                              'Retry',
                              style: Theme.of(context).textTheme.bodyLarge
                            ),
                          ),
                        ],
                      ),
                    );

                  } else if (status == IndicatorStatus.noMoreLoad) {
                    return const Center(
                      child: Text('No more data'),
                    );

                  } else {
                    return const SizedBox.shrink();
                  }
                },
                padding: EdgeInsets.symmetric(
                  horizontal: ((MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width > 600 ? 400 : 300)) / 2) / (MediaQuery.of(context).size.width > 600 ? 3 : 1),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                  mainAxisExtent: 280,
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}

class ReadyCardFilter extends StatefulWidget {
  const ReadyCardFilter({
    super.key,
    required this.controller,
  });

  final CardsController controller;

  @override
  State<ReadyCardFilter> createState() => _ReadyCardFilterState();
}

class _ReadyCardFilterState extends State<ReadyCardFilter> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Text(
            'Filter by price',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Price',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              RangeSlider(
                values: widget.controller.priceRange, 
                min: 100,
                max: 500,
                onChanged: (RangeValues values) {
                  setState(() {
                    widget.controller.priceRange = values;
                  });
                },
                divisions: 4,
                activeColor: Theme.of(context).primaryColor,
                labels: RangeLabels(
                  widget.controller.priceRange.start.toString(),
                  widget.controller.priceRange.end.toString(),
                )
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Stores',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Wrap(
                children: widget.controller.brands.map((brand) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: FilterChip(
                      label: Text(brand),
                      selected: widget.controller.selectedBrands.contains(brand),
                      onSelected: (selected) {
                        setState(() {
                          if(selected) {
                            widget.controller.selectedBrands.add(brand);
                          } else {
                            widget.controller.selectedBrands.remove(brand);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ]
          ),
          const Spacer(),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                  ? Colors.grey[800]
                  : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: InkWell(
                onTap: () {
                  widget.controller.readyCardsSourceRepository.refresh();
                  Navigator.pop(context);
                },
                child: Text(
                  'Apply',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}