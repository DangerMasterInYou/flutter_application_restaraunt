import '../modifier.dart';

abstract class AbstractModifierRepository {
  Future<List<Modifier>> getModifierList();
  Future<Modifier> getModifier(int modifierId);
  Future<Modifier> postCreateModifier(int groupId, ModifierCreateDTO dto);
  Future<Modifier> patchModifier(int modifierId, ModifierPatchDTO dto);
  Future<void> deleteHardModifier(int modifierId);
  Future<void> deleteSoftModifier(int modifierId);
  Future<void> postRestoreModifier(int modifierId);
}
