enum BusinessCatalogItemType {
  product,
  service,
  medicine,
  food,
  grooming,
  bath,
  breedCut,
  bulkSale,
  closedPackage,
  promotion,
}

BusinessCatalogItemType catalogTypeFromInt(int value) {
  switch (value) {
    case 1:
      return BusinessCatalogItemType.product;
    case 2:
      return BusinessCatalogItemType.service;
    case 3:
      return BusinessCatalogItemType.medicine;
    case 4:
      return BusinessCatalogItemType.food;
    case 5:
      return BusinessCatalogItemType.grooming;
    case 6:
      return BusinessCatalogItemType.bath;
    case 7:
      return BusinessCatalogItemType.breedCut;
    case 8:
      return BusinessCatalogItemType.bulkSale;
    case 9:
      return BusinessCatalogItemType.closedPackage;
    case 10:
      return BusinessCatalogItemType.promotion;
    default:
      return BusinessCatalogItemType.product;
  }
}

String catalogTypeLabel(BusinessCatalogItemType type) {
  switch (type) {
    case BusinessCatalogItemType.product:
      return 'Producto';
    case BusinessCatalogItemType.service:
      return 'Servicio';
    case BusinessCatalogItemType.medicine:
      return 'Medicamento';
    case BusinessCatalogItemType.food:
      return 'Alimento';
    case BusinessCatalogItemType.grooming:
      return 'Grooming';
    case BusinessCatalogItemType.bath:
      return 'Baño';
    case BusinessCatalogItemType.breedCut:
      return 'Corte por raza';
    case BusinessCatalogItemType.bulkSale:
      return 'Venta a granel';
    case BusinessCatalogItemType.closedPackage:
      return 'Paquete cerrado';
    case BusinessCatalogItemType.promotion:
      return 'Promoción';
  }
}
