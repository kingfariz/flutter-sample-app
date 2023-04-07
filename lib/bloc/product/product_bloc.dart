// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
// import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';
import 'package:sample_project/helpers/functions/system_log.dart';
import 'package:sample_project/models/product_model.dart';
import 'package:sample_project/services/repositories/ecommerce_repositories/product_repository.dart';
// import '../../services/dio_setting.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository repository})
      : _productRepository = repository,
        super(ProductLoading()) {
    on<LoadProductEvent>((event, emit) async {
      List<ProductModel> products = [];
      try {
        QuerySnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('products').get();

        for (var doc in snapshot.docs) {
          ProductModel productModel = ProductModel.fromMap(doc.data());
          products.add(productModel);
        }

        emit(ProductLoaded(data: products));
      } catch (e) {
        systemLog(e.toString());
      }
    });
    // on<UpdateProductEvent>((event, emit) async {
    //   try {
    //     emit(ProductLoaded(data: event.products));
    //   } catch (e) {
    //     systemLog(e.toString());
    //   }
    // });
  }
}
