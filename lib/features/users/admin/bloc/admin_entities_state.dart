part of 'admin_entities_bloc.dart';

abstract class AdminEntitiesState {}

class AdminEntitiesInitial extends AdminEntitiesState {}

class AdminEntitiesLoading extends AdminEntitiesState {}

class AdminEntitiesLoaded extends AdminEntitiesState {
  final List categories;
  final List products;
  final List variants;
  final List modifiers;
  final List modifierGroups;
  AdminEntitiesLoaded({
    required this.categories,
    required this.products,
    required this.variants,
    required this.modifiers,
    required this.modifierGroups,
  });
}

class AdminEntitiesError extends AdminEntitiesState {
  final String message;
  AdminEntitiesError(this.message);
}

// CRUD/Ассоциации
class AdminEntityOperationLoading extends AdminEntitiesState {}

class AdminEntityOperationSuccess extends AdminEntitiesState {}

class AdminEntityOperationError extends AdminEntitiesState {
  final String message;
  AdminEntityOperationError(this.message);
}
