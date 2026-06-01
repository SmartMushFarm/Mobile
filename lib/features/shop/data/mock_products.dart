import 'package:smartmush_farmer/features/shop/models/product.dart';

const _iotKitImage =
    'https://www.figma.com/api/mcp/asset/7388d8e0-6ae6-49fd-a240-da1c8355236a';
const _oysterSpawnImage =
    'https://www.figma.com/api/mcp/asset/4f9ea895-0839-42d7-9eb1-bbedebb172f8';
const _ledLightImage =
    'https://www.figma.com/api/mcp/asset/ac070f7c-928b-46ef-9ede-d389227be3b8';
const _mistControllerImage =
    'https://www.figma.com/api/mcp/asset/9ed84b63-f782-4d0f-96d1-a54758d657f2';

const mockProducts = [
  Product(
    id: 'iot-kit',
    name: 'IoT Mushroom Starter Kit',
    description: 'Wi-Fi enabled growing system',
    price: '1.490.000đ',
    imageUrl: _iotKitImage,
    category: ProductCategory.kits,
    rating: 4.9,
    isBestSeller: true,
  ),
  Product(
    id: 'golden-oyster-spawn',
    name: 'Golden Oyster Spawn',
    description: 'Premium spawn, 3lbs',
    price: '590.000đ',
    imageUrl: _oysterSpawnImage,
    category: ProductCategory.spawn,
    rating: 4.7,
  ),
  Product(
    id: 'smart-led-grow-light',
    name: 'Smart LED Full Spectrum Grow Light',
    description: 'Wi-Fi enabled lighting with automated daylight cycle',
    price: '2.150.000đ',
    imageUrl: _ledLightImage,
    category: ProductCategory.devices,
    rating: 4.8,
    isProDevice: true,
    isWideCard: true,
  ),
  Product(
    id: 'auto-mist-controller',
    name: 'Auto Mist Controller V2',
    description: 'Automated misting system',
    price: '990.000đ',
    imageUrl: _mistControllerImage,
    category: ProductCategory.devices,
    rating: 4.8,
  ),
];

List<Product> productsByCategory(ProductCategory category) {
  if (category == ProductCategory.all) return mockProducts;
  return mockProducts.where((p) => p.category == category).toList();
}
