import '../category.dart';

abstract class AbstractCategoriesRepository {
  Future<List<Category>> getCategoriesList();
  Future<Category> getCategory(int categoryId);
  Future<Category> postCreateCategory(CategoryCreateDTO dto);
  Future<Category> patchCategory(int categoryId, CategoryPatchDTO dto);
  Future<void> deleteHardCategory(int categoryId);
  Future<void> deleteSoftCategory(int categoryId);
  Future<void> postRestoreCategory(int categoryId);
}
