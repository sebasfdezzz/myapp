var example_json = {
  "pk": "CLIENT-1234",
  "sk": "WINE-W200-WINESALE-WS500",
  "amount": 1,
  "entity_type": "WineSale",
  "sale_date": "2025-08-15T18:45:00Z"
};

class WineSaleEntity {
    String pk;
    String sk;
    String clientId;
    String wineId;
    String wineSaleId;
    int amount;
    String entityType;
    String saleDate;

    WineSaleEntity({
        required this.clientId,
        required this.wineId,
        required this.amount,
    }) :  wineSaleId = UUID().v4(),
          sk = 'WINE-${wineId}-WINESALE-${wineSaleId}', 
          pk = 'CLIENT-${clientId}',
          entityType = 'WineSale',
          saleDate = DateTime.now().toIso8601String();

    static WineSale? fromJson(Map<String, dynamic> json) {
        try {
        return WineSale(
            pk: json['pk'],
            sk: json['sk'],
            clientId: json['pk'].split("-")[1],
            wineId: json['sk'].split("-")[1],
            wineSaleId: json['sk'].split("-")[3],
            amount: json['amount'],
            entityType: json['entityType'],
            saleDate: json['saleDate'],
        );
        } catch (error) {
        traceError('default', 'Error parsing WineSale from JSON: $error');
        traceError('default', 'Offending JSON: $json');
        return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'pk': pk,
            'sk': sk,
            'clientId': clientId,
            'wineId': wineId,
            'wineSaleId': wineSaleId,
            'amount': amount,
            'entityType': entityType,
            'saleDate': saleDate,
        };
    }
}