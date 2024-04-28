import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/store/controller/store_controller.dart';
import 'package:number_paginator/number_paginator.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with WidgetsBindingObserver {
  final StoreController controller = Get.put(StoreController());


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  'المتاجر التي نعمل معها',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color.fromRGBO(65, 84, 123, 1),
                    fontWeight: FontWeight.bold,
                  ),
                
                ),
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<StoreController>(
              init: controller,
              builder: (controller) {
                if (controller.submissionState is Submitting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
            
                if (controller.submissionState is SubmissionError) {
                  return Center(
                    child: Text(
                      (controller.submissionState as SubmissionError).exception?.message ?? 'حدث خطأ ما',
                    ),
                  );
                }
            
                if (controller.stores.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد متاجر'),
                  );
                }
            
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 30,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Card(
                      surfaceTintColor: Colors.transparent,
                      elevation: 5,
                      child: Column(
                        children: [
                          BrandImage(
                            logoImage: controller.stores[controller.page]!.elementAt(index).logoImage ?? "",
                            size: MediaQuery.of(context).size.width > 600 
                              ? 200
                              : 100,
                          ),
                          Text(
                            controller.stores[controller.page]!.elementAt(index).logoName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            controller.stores[controller.page]!.elementAt(index).brandDescription,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: controller.stores[controller.page]?.length ?? 0,
                );
              }
            ),
          ),
          GetBuilder<StoreController>(
            init: controller,
            builder: (controller) => Padding(
              padding: const EdgeInsets.all(18.0),
              child: NumberPaginator(
                numberPages: controller.response?.totalPages ?? 1,
                onPageChange: (int index) {
                  controller.page = index + 1;
                  controller.fetchStore();
                },  
              ),
            ),
          )
        ],
      ),
    );
  }
}
