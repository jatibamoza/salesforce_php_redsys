@isTest 
private class LineaSolicitudMaterialHandler_Tst {
    @TestSetup
    static void makeData(){
        Product2 producto = new Product2( Name = 'Producto de prueba',
										 Description = 'Descripción producto de prueba',
										 Family = 'Textil',
										 IsActive=true,
										 Uso_Empleado__c = true,
										 Catalogo__c=true);

		insert producto;

        PeticionMaterial__c solicitud = new PeticionMaterial__c(
            Direccion__c = 'Audiovisual',
            PersonaSolicitante__c = 'Persona solicitante',
            CorreoElectronico__c = 'alfonso.rodriguez@mad.vass.es',
            Telefono__c = '1234',
            Observaciones__c = 'Test',
            TiendaEmpleados__c = true
        );
        insert solicitud;
    }

    @isTest
    static void insertProducto(){
        Product2 producto = [SELECT Id FROM Product2 LIMIT 1];
        PeticionMaterial__c solicitud = [SELECT Id FROM PeticionMaterial__c LIMIT 1];
        LineaPeticionMaterial__c productoSolicitud = new LineaPeticionMaterial__c(
            PeticionMaterial__c = solicitud.Id,
            Product_Empleado__c = producto.Id,
            Cantidad__c = 3,
            Estado__c = 'En trámite'
        );
        insert productoSolicitud; 
        productoSolicitud.Cantidad__c = 5;
        update productoSolicitud;
        delete productoSolicitud;
    }
}