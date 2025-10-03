@isTest 
private class FAN_RecuperarDeportes_Test {

    @isTest
    private static void testName() {

        List <RecordType> personAccount = [select Id, Name, DeveloperName from RecordType where DeveloperName = 'FAN_PersonAccount'];
        
        String personAccountId = personAccount.get(0).Id;
         
        Account cuenta = new Account();

        cuenta.FirstName = 'Prueba Cuenta';
        cuenta.LastName = 'test';
        cuenta.RecordTypeId  = personAccountId;
        cuenta.Deportes_favoritos_declarados__pc = 'Athletics;Basketball;Badminton;Boxing;Cycling';
        cuenta.FAN_DeporteFavoritoInferidos__pc = 'Athletics;Basketball;Badminton;Boxing;Cycling';

        insert cuenta;

        Test.startTest();

        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Favoritos');
        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Inferidos');

        cuenta.Deportes_favoritos_declarados__pc = 'eSports;Football;Gymnastics;Hockey;Karate;Motor cycling;Paddle tennis;Petanque;Sport Dance;Swimming;Triathlon;WaterPolo';
        cuenta.FAN_DeporteFavoritoInferidos__pc = 'eSports;Football;Gymnastics;Hockey;Karate;Motor cycling;Paddle tennis;Petanque;Sport Dance;Swimming;Triathlon;WaterPolo';

        update cuenta;

        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Favoritos');
        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Inferidos');

        cuenta.Deportes_favoritos_declarados__pc = 'eSports;Football;Gymnastics;Hockey';
        cuenta.FAN_DeporteFavoritoInferidos__pc = 'eSports;Football;Gymnastics;Hockey';

        update cuenta;

        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Favoritos');
        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Inferidos');


        cuenta.Deportes_favoritos_declarados__pc = 'Karate;Motor cycling;Paddle tennis;Petanque';
        cuenta.FAN_DeporteFavoritoInferidos__pc = 'Karate;Motor cycling;Paddle tennis;Petanque';

        update cuenta;

        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Favoritos');
        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Inferidos');

        cuenta.Deportes_favoritos_declarados__pc = 'Sport Dance;Swimming;Triathlon;WaterPolo';
        cuenta.FAN_DeporteFavoritoInferidos__pc = 'Sport Dance;Swimming;Triathlon;WaterPolo';

        update cuenta;

        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Favoritos');
        FAN_RecuperarDeportes.getDeportesFavoritos(cuenta.Id, 'Inferidos');

        Test.stopTest();
        
    }
}