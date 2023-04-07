part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductEvent extends ProductEvent {}

class UpdateProductEvent extends ProductEvent {
  final List<ProductModel> products;

  UpdateProductEvent(this.products);

  @override
  List<Object?> get props => [products];
}



// @immutable
// abstract class CrudEvent {}

// class LoadProductEvent extends CrudEvent {}

// class UpdateProductEvent extends CrudEvent {
//   final List<ProductModel> products;
//   UpdateProductEvent({required this.products});
//   List<Object?> get props => [products];
// }
