import '/core/hive/models/product_full/product/product.dart';
import '../modifier_group.dart';

abstract class AbstractProductsRepository {
  Future<List<Product>> getProductsList();
  Future<Product> getProduct(int productId);
}

abstract class AbstractModifierGroupRepository {
  Future<List<ModifierGroup>> getModifierGroupList();
  Future<ModifierGroup> getModifierGroup(int modifierGroupId);
  Future<ModifierGroup> postCreateModifierGroup(ModifierGroupCreateDTO dto);
  Future<ModifierGroup> patchModifierGroup(
      int modifierGroupId, ModifierGroupPatchDTO dto);
  Future<void> deleteHardModifierGroup(int modifierGroupId);
  Future<void> deleteSoftModifierGroup(int modifierGroupId);
  Future<void> postRestoreModifierGroup(int modifierGroupId);
}
