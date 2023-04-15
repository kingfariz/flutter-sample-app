// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_project/helpers/functions/system_log.dart';
import 'package:sample_project/models/product_model.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductLoading()) {
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
  }
}
