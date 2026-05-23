import '../../domain/entities/item.dart';
import '../models/item_dto.dart';

/// Converts between [ItemDto] and domain [Item].
class ItemMapper {
  ItemMapper._();

  static Item toEntity(ItemDto dto) {
    return Item(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      category: dto.category,
      ownerId: dto.ownerId,
      ownerName: dto.ownerName,
      distance: dto.distance,
      rating: dto.rating,
      status: dto.status,
      imagePath: dto.imagePath,
    );
  }

  static List<Item> toEntityList(List<ItemDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
