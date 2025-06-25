part of 'admin_entities_bloc.dart';

abstract class AdminEntitiesEvent extends Equatable {
  const AdminEntitiesEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllEntities extends AdminEntitiesEvent {}

// Категории
class CreateCategory extends AdminEntitiesEvent {
  final String name;
  final int sortOrder;
  const CreateCategory({required this.name, required this.sortOrder});
  @override
  List<Object?> get props => [name, sortOrder];
}

class UpdateCategory extends AdminEntitiesEvent {
  final int id;
  final String? name;
  final int? sortOrder;
  const UpdateCategory({required this.id, this.name, this.sortOrder});
  @override
  List<Object?> get props => [id, name, sortOrder];
}

class DeleteCategory extends AdminEntitiesEvent {
  final int id;
  final bool hard;
  const DeleteCategory({required this.id, this.hard = false});
  @override
  List<Object?> get props => [id, hard];
}

class RestoreCategory extends AdminEntitiesEvent {
  final int id;
  const RestoreCategory({required this.id});
  @override
  List<Object?> get props => [id];
}

// Продукты
class CreateProduct extends AdminEntitiesEvent {
  final int categoryId;
  final String name;
  final String? description;
  final int sortOrder;
  final String imageUrl;
  const CreateProduct({
    required this.categoryId,
    required this.name,
    this.description,
    required this.sortOrder,
    required this.imageUrl,
  });
  @override
  List<Object?> get props =>
      [categoryId, name, description, sortOrder, imageUrl];
}

class UpdateProduct extends AdminEntitiesEvent {
  final int id;
  final int? categoryId;
  final String? name;
  final String? description;
  final int? sortOrder;
  final String? imageUrl;
  const UpdateProduct({
    required this.id,
    this.categoryId,
    this.name,
    this.description,
    this.sortOrder,
    this.imageUrl,
  });
  @override
  List<Object?> get props =>
      [id, categoryId, name, description, sortOrder, imageUrl];
}

class DeleteProduct extends AdminEntitiesEvent {
  final int id;
  final bool hard;
  const DeleteProduct({required this.id, this.hard = false});
  @override
  List<Object?> get props => [id, hard];
}

class RestoreProduct extends AdminEntitiesEvent {
  final int id;
  const RestoreProduct({required this.id});
  @override
  List<Object?> get props => [id];
}

// Варианты
class CreateVariant extends AdminEntitiesEvent {
  final int productId;
  final String name;
  final int price;
  final String? imageUrl;
  const CreateVariant(
      {required this.productId,
      required this.name,
      required this.price,
      this.imageUrl});
  @override
  List<Object?> get props => [productId, name, price, imageUrl];
}

class UpdateVariant extends AdminEntitiesEvent {
  final int id;
  final String? name;
  final int? price;
  final String? imageUrl;
  const UpdateVariant({required this.id, this.name, this.price, this.imageUrl});
  @override
  List<Object?> get props => [id, name, price, imageUrl];
}

class DeleteVariant extends AdminEntitiesEvent {
  final int id;
  final bool hard;
  const DeleteVariant({required this.id, this.hard = false});
  @override
  List<Object?> get props => [id, hard];
}

class RestoreVariant extends AdminEntitiesEvent {
  final int id;
  const RestoreVariant({required this.id});
  @override
  List<Object?> get props => [id];
}

// Модификаторы
class CreateModifier extends AdminEntitiesEvent {
  final String name;
  final int price;
  final int groupId;
  const CreateModifier(
      {required this.name, required this.price, required this.groupId});
  @override
  List<Object?> get props => [name, price, groupId];
}

class UpdateModifier extends AdminEntitiesEvent {
  final int id;
  final String? name;
  final int? price;
  final int groupId;
  const UpdateModifier(
      {required this.id, this.name, this.price, required this.groupId});
  @override
  List<Object?> get props => [id, name, price, groupId];
}

class DeleteModifier extends AdminEntitiesEvent {
  final int id;
  final bool hard;
  const DeleteModifier({required this.id, this.hard = false});
  @override
  List<Object?> get props => [id, hard];
}

class RestoreModifier extends AdminEntitiesEvent {
  final int id;
  const RestoreModifier({required this.id});
  @override
  List<Object?> get props => [id];
}

// Группы модификаторов
class CreateModifierGroup extends AdminEntitiesEvent {
  final String name;
  final String description;
  const CreateModifierGroup({required this.name, required this.description});
  @override
  List<Object?> get props => [name, description];
}

class UpdateModifierGroup extends AdminEntitiesEvent {
  final int id;
  final String? name;
  final String? description;
  const UpdateModifierGroup({required this.id, this.name, this.description});
  @override
  List<Object?> get props => [id, name, description];
}

class DeleteModifierGroup extends AdminEntitiesEvent {
  final int id;
  final bool hard;
  const DeleteModifierGroup({required this.id, this.hard = false});
  @override
  List<Object?> get props => [id, hard];
}

class RestoreModifierGroup extends AdminEntitiesEvent {
  final int id;
  const RestoreModifierGroup({required this.id});
  @override
  List<Object?> get props => [id];
}

// Ассоциации
class LinkGroupToVariant extends AdminEntitiesEvent {
  final int variantId;
  final int groupId;
  const LinkGroupToVariant({required this.variantId, required this.groupId});
  @override
  List<Object?> get props => [variantId, groupId];
}

class UnlinkGroupFromVariant extends AdminEntitiesEvent {
  final int variantId;
  final int groupId;
  const UnlinkGroupFromVariant(
      {required this.variantId, required this.groupId});
  @override
  List<Object?> get props => [variantId, groupId];
}
