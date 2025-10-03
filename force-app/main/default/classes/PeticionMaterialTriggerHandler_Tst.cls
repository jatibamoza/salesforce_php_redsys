@isTest 
private class PeticionMaterialTriggerHandler_Tst {
    @TestSetup
    static void makeData(){
        Product2 producto = new Product2( Name = 'Producto de prueba',
										 Description = 'Descripción producto de prueba',
										 Family = 'Textil',
										 IsActive=true,
										 Uso_Empleado__c = true,
										 Catalogo__c=true);

		insert producto;

        Schema.Location almacen = new Schema.Location();
		almacen.Name = 'Torrelaguna';
		almacen.LocationType = 'Almacén';

		insert almacen;

        Schema.Location almacenVirtual = new Schema.Location();
		almacenVirtual.Name = 'Audiovisual';
		almacenVirtual.LocationType = 'Virtual';

		insert almacenVirtual;

        ArticuloProducto__c articulo = new ArticuloProducto__c();
		articulo.Name = 'Producto de prueba';
		articulo.Producto__c = producto.Id;
		articulo.Almacen__c = almacen.Id;
		articulo.Cantidad__c = 10;

		insert articulo;

		ArticuloProducto__c articuloDireccion = new ArticuloProducto__c();
		articuloDireccion.Name = 'Producto de prueba Direccion';
		articuloDireccion.Producto__c = producto.Id;
		articuloDireccion.Almacen__c = almacenVirtual.Id;
		articuloDireccion.Cantidad__c = 10;

		insert articuloDireccion;

        PeticionMaterial__c solicitud = new PeticionMaterial__c(
            Direccion__c = 'Audiovisual',
            PersonaSolicitante__c = 'Persona solicitante',
            CorreoElectronico__c = 'alfonso.rodriguez@mad.vass.es',
            Telefono__c = '1234',
            Observaciones__c = 'Test',
            TiendaEmpleados__c = true
        );
        insert solicitud;

        LineaPeticionMaterial__c productoSolicitud = new LineaPeticionMaterial__c(
            PeticionMaterial__c = solicitud.Id,
            Product_Empleado__c = producto.Id,
            Cantidad__c = 3,
            Estado__c = 'En trámite'
        );
        insert productoSolicitud;

        PeticionMaterial__c solicitud2 = new PeticionMaterial__c(
            Direccion__c = 'Audiovisual',
            PersonaSolicitante__c = 'Persona solicitante',
            CorreoElectronico__c = 'alfonso.rodriguez@mad.vass.es',
            Telefono__c = '1234',
            Observaciones__c = 'Test',
            TiendaEmpleados__c = true
        );
        insert solicitud2;

        LineaPeticionMaterial__c productoSolicitud2 = new LineaPeticionMaterial__c(
            PeticionMaterial__c = solicitud2.Id,
            Product_Empleado__c = producto.Id,
            Cantidad__c = 3,
            Estado__c = 'En trámite'
        );
        insert productoSolicitud2;
        
    }

    @isTest
    static void updateSolicitud(){
        List<PeticionMaterial__c> solicitudes = [SELECT Id, Estado__c FROM PeticionMaterial__c];
        /* solicitudes[0].Estado__c = 'Cancelada';
        solicitudes[0].Motivo_de_cancelacion__c = 'Artículo defectuoso'; */
        solicitudes[1].Estado__c = 'Aprobada';
        update solicitudes;
    }
}