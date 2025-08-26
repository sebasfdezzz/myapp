import 'entities/client.dart';
import 'models/cellar.dart';
import 'models/menu.dart';

class GlobalData {
    static Client client = Client(
        clientName: '',
        cognitoId: '',
        address: '',
        city: '',
        country: '',
        latitude: '',
        longitude: '',
        neighborhood: '',
        zipCode: '',
        planType: '',
    );
    static Cellar cellar = Cellar();
    static Menu menu = Menu(categories: []);
}