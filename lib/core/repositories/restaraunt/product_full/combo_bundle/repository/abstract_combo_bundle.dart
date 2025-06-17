import '../combo_bundle.dart';

abstract class AbstractComboBundleRepository {
  Future<List<ComboBundle>> getComboBundleList();
  Future<ComboBundle> getComboBundle(int comboBundleId);
  Future<ComboBundle> postCreateComboBundle(ComboBundleCreateDTO dto);
  Future<ComboBundle> patchComboBundle(
      int comboBundleId, ComboBundlePatchDTO dto);
  Future<void> deleteHardComboBundle(int comboBundleId);
  Future<void> deleteSoftComboBundle(int comboBundleId);
  Future<void> postRestoreComboBundle(int comboBundleId);
}
