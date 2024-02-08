import 'package:e_commarce_app_demo/core/utiles/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utiles/custom_appbar.dart';
import '../../../core/utiles/responsive.dart';
import '../../../core/utiles/responsive_constant.dart';
import '../../../routes/app_routes.dart';
import 'controller/home_page_controller.dart';
import 'models/item_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomePageController controller = Get.find<HomePageController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GetBuilder<HomePageController>(
          builder: (HomePageController controller) {
            return CommonAppBar(
            title: AppText.HOME_TITLE,
            onCartTap: () {
              Get.toNamed(AppRoutes.cartPage);
            },
            cartItemCount: controller.cartItems.length,
          );},

        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final screenWidth = constraints.maxWidth;
        return SingleChildScrollView(
          child: _buildShopItemListing(screenWidth),
        );
      },
    );
  }


  Widget _buildShopItemListing(double screenWidth) {
    return GetBuilder<HomePageController>(
      init: controller,
      builder: (_) => controller.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ShopItemListing(
              items: controller.items ?? [],
              screenWidth: screenWidth,
            ),
    );
  }
}

class ShopItemListing extends StatelessWidget {
  final List<ShopItemModel> items;
  final double screenWidth;

  const ShopItemListing(
      {super.key, required this.items, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils responsiveUtils = ResponsiveUtils(screenWidth);
    final crossAxisCount = responsiveUtils.isBigDevice ? 4 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ItemView(
          item: items[index],
        );
      },
      itemCount: items.length,
    );
  }
}

class ItemView extends StatelessWidget {
  final ShopItemModel item;

  const ItemView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double itemWidth = constraints.maxWidth;
        double itemHeight = constraints.maxHeight;

        return Padding(
          padding: EdgeInsets.all(
            ResponsiveUtils.calculateResponsivePadding(
                itemWidth, ResponsiveConstants.paddingRatio),
          ),
          child: InkResponse(
            onTap: () {
              Get.toNamed(AppRoutes.productDetailsPage,
                  arguments: {"itemId": item.id});
            },
            child: Container(
              width: itemWidth,
              height: itemHeight,
              padding: EdgeInsets.all(
                ResponsiveUtils.calculateResponsivePadding(
                    itemWidth, ResponsiveConstants.paddingRatio),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8.0)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: ResponsiveUtils.calculateResponsiveHeight(
                        itemHeight, ResponsiveConstants.imageHeightRatio),
                    child: Padding(
                      padding: EdgeInsets.all(
                        ResponsiveUtils.calculateResponsivePadding(
                            itemWidth, ResponsiveConstants.paddingRatio),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Image.asset(
                                item.image ?? '',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveUtils.calculateResponsiveHeight(
                        itemHeight, ResponsiveConstants.sizedBoxHeightRatio),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ResponsiveUtils.calculateResponsivePadding(
                          itemWidth, ResponsiveConstants.paddingRatio),
                    ),
                    child: Text(
                      item.name ?? 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveUtils.calculateResponsiveFontSize(
                            itemHeight, ResponsiveConstants.firstFontSizeRatio),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: ResponsiveUtils.calculateResponsivePadding(
                          itemWidth, ResponsiveConstants.paddingRatio),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            right: ResponsiveUtils.calculateResponsivePadding(
                                itemWidth, ResponsiveConstants.paddingRatio),
                          ),
                          child: Text(
                            "\$${item.price.toString() ?? '0.0'}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  ResponsiveUtils.calculateResponsiveFontSize(
                                      itemHeight,
                                      ResponsiveConstants.secondFontSizeRatio),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
