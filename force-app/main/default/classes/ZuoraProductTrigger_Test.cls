@isTest 
private class ZuoraProductTrigger_Test {
  /*@isTest
  private static void testOne() {
    String respJSON = '{"access_token":"T0k3n"}';
    
    FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
    Test.setMock(HttpCalloutMock.class, okResponse);

    Test.startTest();
      
    Zuora__Product__c producto = new Zuora__Product__c( Zuora__Description__c = 'Producto La Liga',
                                                    Zuora__EffectiveEndDate__c = date.newInstance(2023,10,31),
                                                    Zuora__EntityID__c = '8adcd9eb75258ddc01752ad6877b29ad',
                                                    Zuora__External_Id__c = '8adc9dee75257f0a017540ffa6ca1095',
                                                    Name = 'Producto La Liga Previo',
                                                    Zuora__SKU__c = 'SKU-00000056');
    insert producto;
    producto.Zuora__Description__c = 'Producto La Liga 2';
    update producto;
    Test.stopTest();
    System.assert(producto!=null,'Producto creado.');
  }

  @isTest
  private static void testBulk075() {
    String respJSON = '{"access_token":"T0k3n"}';
    
    FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
    Test.setMock(HttpCalloutMock.class, okResponse);

    Test.startTest();
      
    List<Zuora__Product__c> productoList = new List<Zuora__Product__c>();
    for(Integer i=0;i<75;i++) {
      Zuora__Product__c producto = new Zuora__Product__c( Zuora__Description__c = 'Producto La Liga',
                                                      Zuora__EffectiveEndDate__c = date.newInstance(2023,10,31),
                                                      Zuora__EntityID__c = '8adcd9eb75258ddc01752ad6877b29ad',
                                                      Zuora__External_Id__c = '8adc9dee75257f0a017540ffa6ca1095' + i,
                                                      Name = 'Producto La Liga Previo ' + i,
                                                      Zuora__SKU__c = 'SKU-00000056');
      productoList.add(producto);
      }
    insert productoList;
    Test.stopTest();
    System.assert(productoList!=null,'Producto creado.');
  }
  
  @isTest
  private static void testBulk125() {
    String respJSON = '{"access_token":"T0k3n"}';
    
    FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
    Test.setMock(HttpCalloutMock.class, okResponse);

    Test.startTest();
      
    List<Zuora__Product__c> productoList = new List<Zuora__Product__c>();
    for(Integer i=0;i<125;i++) {
      Zuora__Product__c producto = new Zuora__Product__c( Zuora__Description__c = 'Producto La Liga',
                                                      Zuora__EffectiveEndDate__c = date.newInstance(2023,10,31),
                                                      Zuora__EntityID__c = '8adcd9eb75258ddc01752ad6877b29ad',
                                                      Zuora__External_Id__c = '8adc9dee75257f0a017540ffa6ca1095' + i,
                                                      Name = 'Producto La Liga Previo ' + i,
                                                      Zuora__SKU__c = 'SKU-00000056');
      productoList.add(producto);
      }
    insert productoList;
    Test.stopTest();
    System.assert(productoList!=null,'Producto creado.');
  }

  @isTest
  private static void testBulk200() {
    String respJSON = '{"access_token":"T0k3n"}';
    
    FAN_MockResponseComunicarDSP okResponse = new FAN_MockResponseComunicarDSP(200, '', respJSON, null);
    Test.setMock(HttpCalloutMock.class, okResponse);

    Test.startTest();
      
    List<Zuora__Product__c> productoList = new List<Zuora__Product__c>();
    for(Integer i=0;i<200;i++) {
      Zuora__Product__c producto = new Zuora__Product__c( Zuora__Description__c = 'Producto La Liga',
                                                      Zuora__EffectiveEndDate__c = date.newInstance(2023,10,31),
                                                      Zuora__EntityID__c = '8adcd9eb75258ddc01752ad6877b29ad',
                                                      Zuora__External_Id__c = '8adc9dee75257f0a017540ffa6ca1095' + i,
                                                      Name = 'Producto La Liga Previo ' + i,
                                                      Zuora__SKU__c = 'SKU-00000056');
      productoList.add(producto);
      }
    insert productoList;
    Test.stopTest();
    System.assert(productoList!=null,'Producto creado.');
  }*/
}