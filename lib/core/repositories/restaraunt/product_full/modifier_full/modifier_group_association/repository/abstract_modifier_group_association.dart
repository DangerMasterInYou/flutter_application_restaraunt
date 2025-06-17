import '../modifier_group_association.dart';

abstract class AbstractModifierGroupAssociationRepository {
  Future<List<ModifierGroupAssociation>> getModifierGroupAssociationList();
  Future<ModifierGroupAssociation> getModifierGroupAssociation(
      int modifierGroupAssociationId);
  Future<ModifierGroupAssociation> postCreateModifierGroupAssociation(
      ModifierGroupAssociationCreateDTO dto);
  Future<ModifierGroupAssociation> patchModifierGroupAssociation(
      int modifierGroupAssociationId, ModifierGroupAssociationPatchDTO dto);
  Future<void> deleteHardModifierGroupAssociation(
      int modifierGroupAssociationId);
  Future<void> deleteSoftModifierGroupAssociation(
      int modifierGroupAssociationId);
  Future<void> postRestoreModifierGroupAssociation(
      int modifierGroupAssociationId);
}
