import '../modifier_group.dart';

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
