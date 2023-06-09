import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sample_project/helpers/functions/string_formatter.dart';
import 'package:sample_project/features/ecommerce/models/product_model.dart';
import '../../../helpers/themes.dart';
import '../bloc/product_bloc.dart';

class EcommercePage extends StatefulWidget {
  const EcommercePage({super.key});

  @override
  State<EcommercePage> createState() => _EcommercePageState();
}

class _EcommercePageState extends State<EcommercePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const SpinKitChasingDots(
              size: 50,
              color: primaryColor,
            );
          }
          if (state is ProductLoaded) {
            return CustomScrollView(
              shrinkWrap: true,
              // primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.625,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (
                        BuildContext context,
                        int index,
                      ) {
                        return _buildRecomendedProductCard(index, state.data);
                      },
                      childCount: state.data.length,
                      // childCount: 8,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text("Something Error");
          }
        },
      ),
    );
  }

  Widget _buildRecomendedProductCard(index, List<ProductModel> productModel) {
    final double boxImageSize =
        ((MediaQuery.of(context).size.width) - 24) / 2 - 12;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      color: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.network(
                // "https://images.tokopedia.net/img/cache/900/VqbcmM/2023/1/11/89e42c0c-aa44-4447-b5b1-154dc05aad98.png",
                "https://images.tokopedia.net/img/cache/900/VqbcmM/2023/1/11/89e42c0c-aa44-4447-b5b1-154dc05aad98.png",
                fit: BoxFit.fill,
                height: boxImageSize,
                width: boxImageSize,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productModel[index].name.toString(),
                    // "DELL Gaming G15 Ryzen 7 5800H RTX 3050TI",
                    style: productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Rp. ${StringFormatter().removeDecimalZeroFormat(
                              productModel[index].price == null
                                  ? 0.0
                                  : double.parse(productModel[index].price!),
                              // 13849000.0,
                            )}',
                            style: productPrice),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: softGreyColor, size: 12),
                        // Text(' ' + recomendedProductData[index].location,
                        Text('INDONESIA', style: productSale)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
