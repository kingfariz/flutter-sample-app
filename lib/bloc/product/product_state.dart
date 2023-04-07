part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> data;

  ProductLoaded({this.data = const <ProductModel>[]});

  @override
  List<Object> get props => [data];
}



// @immutable
// abstract class ProductState {}

// class ProductLoading extends ProductState {}

// class ProductError extends ProductState {}

// class ProductLoaded extends ProductState {
//   final List<ProductModel> data;
//   ProductLoaded({this.data = const <ProductModel>[]});
//   List<Object?> get props => [data];
// }
