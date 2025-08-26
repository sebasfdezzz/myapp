class PairingController {
    static Future<bool> createSinglePairing(String dishId) async {
        String clientId = GlobalData.client.clientId;
        // call API POST pairings/{clientId}/{dishId}
=    }

    static Future<bool> createMultiplePairings(List<String> dishIds) async {
        String clientId = GlobalData.client.clientId;
        // call API POST pairings/{clientId} with body { dishIds }
=
    }

    static Future<bool> createAllPairings() async {
        String clientId = GlobalData.client.clientId;
        // call API POST pairings/{clientId} with body { allDishIds }
        return await PairingsApi.createPairings(clientId);
    }
}