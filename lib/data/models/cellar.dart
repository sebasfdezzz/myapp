import '../entities/wine.dart';
import '../../logs.dart';

class Cellar {
  final List<Wine> wines;

  Cellar({this.wines = const []});

  // Get wines by type (Red, White, Sparkling, etc.)
  List<Wine> getWinesByType(String type) {
    return wines.where((wine) => wine.type.toLowerCase() == type.toLowerCase()).toList();
  }

  // Get wines by region
  List<Wine> getWinesByRegion(String region) {
    return wines.where((wine) => wine.region.toLowerCase().contains(region.toLowerCase())).toList();
  }

  // Get wines by country
  List<Wine> getWinesByCountry(String country) {
    return wines.where((wine) => wine.country.toLowerCase() == country.toLowerCase()).toList();
  }

  // Get wines by producer
  List<Wine> getWinesByProducer(String producer) {
    return wines.where((wine) => wine.producer.toLowerCase().contains(producer.toLowerCase())).toList();
  }

  // Get wines by grape variety
  List<Wine> getWinesByGrapeVariety(String grapeVariety) {
    return wines.where((wine) => 
      wine.grapeVariety.any((grape) => grape.toLowerCase().contains(grapeVariety.toLowerCase()))
    ).toList();
  }

  // Get wines in stock
  List<Wine> getWinesInStock() {
    return wines.where((wine) => wine.status == 'IN_STOCK' && wine.availableItems > 0).toList();
  }

  // Get wines by price range
  List<Wine> getWinesByPriceRange(int minPrice, int maxPrice) {
    return wines.where((wine) => wine.price >= minPrice && wine.price <= maxPrice).toList();
  }

  // Search wines by name or description
  List<Wine> searchWines(String query) {
    String lowerQuery = query.toLowerCase();
    return wines.where((wine) => 
      wine.name.toLowerCase().contains(lowerQuery) ||
      wine.description.toLowerCase().contains(lowerQuery) ||
      wine.tasting.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  factory Cellar.fromJson(Map<String, dynamic> json) {
    try {
      return Cellar(
        wines: (json['wines'] as List?)
            ?.map((w) => Wine.fromJson(w))
            .where((w) => w != null)
            .cast<Wine>()
            .toList() ?? [],
      );
    } catch (error) {
      traceError('default', 'Error parsing Cellar from JSON: $error');
      traceError('default', 'Offending JSON: $json');
      return Cellar();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'wines': wines.map((w) => w.toJson()).toList(),
    };
  }

  // Helper method to add a wine
  Cellar addWine(Wine wine) {
    return Cellar(wines: [...wines, wine]);
  }

  // Helper method to remove a wine
  Cellar removeWine(String wineId) {
    return Cellar(wines: wines.where((wine) => wine.wineId != wineId).toList());
  }

  // Helper method to update a wine
  Cellar updateWine(Wine updatedWine) {
    return Cellar(wines: wines.map((wine) => 
      wine.wineId == updatedWine.wineId ? updatedWine : wine
    ).toList());
  }
}