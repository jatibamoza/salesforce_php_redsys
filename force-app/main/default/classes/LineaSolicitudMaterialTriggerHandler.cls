public class LineaSolicitudMaterialTriggerHandler {
    public static void modificacionPedido(List<LineaPeticionMaterial__c> material, String accion){
        List<Id> idPeticion = new List<Id>();
        for(LineaPeticionMaterial__c mat : material){
            if(!idPeticion.contains(mat.PeticionMaterial__c) && mat.Estado__c != 'Nueva'){
                idPeticion.add(mat.PeticionMaterial__c);
            }
        }
        List<LineaPeticionMaterial__c> productosSolicitud = new List<LineaPeticionMaterial__c>();
        if(accion == 'delete'){
            productosSolicitud = [SELECT Id, Product_Empleado__r.Name, Cantidad__c,PrecioUnidad__c,PrecioLinea__c, PeticionMaterial__r.Productos_Actualizados__c, PeticionMaterial__c,PeticionMaterial__r.PersonaSolicitante__c,PeticionMaterial__r.Direccion__c,
            PeticionMaterial__r.CorreoElectronico__c, PeticionMaterial__r.Name, PeticionMaterial__r.NIF_DNI__c,Producto__c
            FROM LineaPeticionMaterial__c WHERE PeticionMaterial__c IN: idPeticion AND PeticionMaterial__r.TiendaEmpleados__c = true AND Id NOT IN: Trigger.oldMap.keySet()];
        }else{
            productosSolicitud = [SELECT Id, Product_Empleado__r.Name, Cantidad__c,PrecioUnidad__c,PrecioLinea__c,PeticionMaterial__r.Productos_Actualizados__c, PeticionMaterial__c,PeticionMaterial__r.PersonaSolicitante__c,PeticionMaterial__r.Direccion__c,
            PeticionMaterial__r.CorreoElectronico__c, PeticionMaterial__r.Name, PeticionMaterial__r.NIF_DNI__c,Producto__c
            FROM LineaPeticionMaterial__c WHERE PeticionMaterial__c IN: idPeticion AND PeticionMaterial__r.TiendaEmpleados__c = true];
        }
        if(productosSolicitud.size() > 0){
            sendEmailEquipoProduccionYFinanciero(productosSolicitud);
            List<Id> actProdPeticion = new List<Id>();
            for(LineaPeticionMaterial__c productos: productosSolicitud){
                actProdPeticion.add(productos.PeticionMaterial__c);
            }
            List<PeticionMaterial__c> solicitudMat = [SELECT Id, Productos_Actualizados__c FROM PeticionMaterial__c WHERE Id IN: actProdPeticion];
            for(PeticionMaterial__c peticion: solicitudMat){
                peticion.Productos_Actualizados__c = true;
            }
            update solicitudMat;
        }
    }

    public static void actualizarPedido(List<LineaPeticionMaterial__c> material, Map<Id,LineaPeticionMaterial__c> materialOld){
        List<Id> idPeticion = new List<Id>();
        for(LineaPeticionMaterial__c mat : material){
            if(!idPeticion.contains(mat.PeticionMaterial__c) && mat.Estado__c == materialOld.get(mat.Id).Estado__c){
                idPeticion.add(mat.PeticionMaterial__c);
            }
        }
        List<LineaPeticionMaterial__c> productosSolicitud = new List<LineaPeticionMaterial__c>();
        productosSolicitud = [SELECT Id, Product_Empleado__r.Name, Cantidad__c,PrecioUnidad__c,PrecioLinea__c,PeticionMaterial__r.Productos_Actualizados__c, PeticionMaterial__c,PeticionMaterial__r.PersonaSolicitante__c,PeticionMaterial__r.Direccion__c,
        PeticionMaterial__r.CorreoElectronico__c, PeticionMaterial__r.Name, PeticionMaterial__r.NIF_DNI__c,Producto__c
        FROM LineaPeticionMaterial__c WHERE PeticionMaterial__c IN: idPeticion AND PeticionMaterial__r.TiendaEmpleados__c = true];
        
        if(productosSolicitud.size() > 0){
            sendEmailEquipoProduccionYFinanciero(productosSolicitud);
            List<Id> actProdPeticion = new List<Id>();
            for(LineaPeticionMaterial__c productos: productosSolicitud){
                actProdPeticion.add(productos.PeticionMaterial__c);
            }
            List<PeticionMaterial__c> solicitudMat = [SELECT Id, Productos_Actualizados__c FROM PeticionMaterial__c WHERE Id IN: actProdPeticion];
            for(PeticionMaterial__c peticion: solicitudMat){
                peticion.Productos_Actualizados__c = true;
            }
            update solicitudMat;
        }
    }

    public static PageReference sendEmailEquipoProduccionYFinanciero(List<LineaPeticionMaterial__c> productosSolicitud) {

        String subject = 'Modificación de pedido en tienda de empleados… ' + productosSolicitud[0].PeticionMaterial__r.Name;
        String body = '<!DOCTYPE  html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+
        '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>'+
        '<style type="text/css"> '+
        '* {margin:0; padding:0; text-indent:0; }'+
        'h1 { color: black; font-family:Arial, sans-serif; font-style: normal; font-weight: bold; text-decoration: none; font-size: 18pt; }'+
        '.s1 { color: #5B5B5B; font-family:Arial, sans-serif; font-style: normal; font-weight: normal; text-decoration: none; font-size: 9pt; }'+
        '.s2 { color: black; font-family:Arial, sans-serif; font-style: normal; font-weight: normal; text-decoration: none; font-size: 10pt; }'+
        'h2 { color: black; font-family:Arial, sans-serif; font-style: normal; font-weight: bold; text-decoration: none; font-size: 10pt; }'+
        '.s3 { color: black; font-family:Arial, sans-serif; font-style: normal; font-weight: bold; text-decoration: none; font-size: 9pt; }'+
        '.s4 { color: black; font-family:Arial, sans-serif; font-style: normal; font-weight: normal; text-decoration: none; font-size: 10pt; }'+
        '.s5 { color: black; font-family:Arial, sans-serif; font-style: normal; font-weight: normal; text-decoration: none; font-size: 9pt; }'+
        'p { color: black; font-family:Arial, sans-serif; font-style: normal; font-weight: normal; text-decoration: none; font-size: 8pt; margin:0pt; }'+
        'table, tbody {vertical-align: top; overflow: visible; }'+
        '</style></head><body>'+
        '<p style="text-indent: 0pt;text-align: left;"><br/></p><p style="padding-left: 21pt;text-indent: 0pt;text-align: left;"><span><table border="0" cellspacing="0" cellpadding="0"><tr><td></td></tr></table></span></p><p style="text-indent: 0pt;text-align: left;"><br/></p><h1 style="padding-top: 16pt;padding-left: 22pt;text-indent: 0pt;text-align: left;">MODIFICACIÓN DE PEDIDO: FACTURA PROFORMA</h1><p class="s1" style="padding-top: 3pt;padding-left: 69pt;text-indent: 0pt;line-height: 10pt;text-align: right;">LALIGA GROUP INTERNATIONAL, S.L.</p><p class="s1" style="text-indent: 0pt;line-height: 10pt;text-align: right;">C/ Torrelaguna, 60</p><p class="s1" style="text-indent: 0pt;line-height: 10pt;text-align: right;">28043 Madrid</p><p class="s1" style="text-indent: 0pt;line-height: 10pt;text-align: right;">[+34] 91 205 50 00</p><p style="text-indent: 0pt;text-align: left;"><br/></p><h2 style="padding-left: 21pt;text-indent: 0pt;text-align: left;">Sr/Sra</h2>'+
        '<h2 style="padding-left: 22pt;text-indent: 0pt;line-height: 90%;text-align: left;">Nombre y Apellidos: '+productosSolicitud[0].PeticionMaterial__r.PersonaSolicitante__c+' </h2>'+
        '<h2 style="padding-left: 22pt;text-indent: 0pt;line-height: 90%;text-align: left;">Dirección completa: '+productosSolicitud[0].PeticionMaterial__r.Direccion__c+'  </h2>'+
        '<h2 style="padding-left: 22pt;text-indent: 0pt;line-height: 90%;text-align: left;">Correo electrónico: '+productosSolicitud[0].PeticionMaterial__r.CorreoElectronico__c+'  </h2>'+
        '<h2 style="padding-left: 22pt;text-indent: 0pt;line-height: 90%;text-align: left;">Numero de documento: '+productosSolicitud[0].PeticionMaterial__r.Name+' </h2>'+
        '<h2 style="padding-left: 22pt;text-indent: 0pt;line-height: 90%;text-align: left;">Fecha: '+System.now()+'  </h2>'+
        '<p style="text-indent: 0pt;text-align: left;"><h2 style="padding-left: 22pt;text-indent: 0pt;line-height: 90%;text-align: left;">NIF/DNI: ' +productosSolicitud[0].PeticionMaterial__r.NIF_DNI__c + ' </h2>'+
        '<p style="text-indent: 0pt;text-align: left;"><br/></p><table style="border-collapse:collapse;margin-left:5.813pt" cellspacing="0"><tr style="height:25pt"><td style="width:156pt;border-top-style:solid;border-top-width:1pt;border-top-color:#5B5B5B;border-left-style:solid;border-left-width:1pt;border-bottom-style:solid;border-bottom-width:1pt" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 6pt;padding-left: 2pt;text-indent: 0pt;text-align: left;">Descripción</p></td><td style="width:157pt;border-top-style:solid;border-top-width:1pt;border-top-color:#5B5B5B;border-bottom-style:solid;border-bottom-width:1pt" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 6pt;padding-left: 102pt;text-indent: 0pt;text-align: left;">Cantidad</p></td><td style="width:72pt;border-top-style:solid;border-top-width:1pt;border-top-color:#5B5B5B;border-bottom-style:solid;border-bottom-width:1pt" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 6pt;padding-left: 16pt;text-indent: 0pt;text-align: left;">Precio</p></td><td style="width:83pt;border-top-style:solid;border-top-width:1pt;border-top-color:#5B5B5B;border-bottom-style:solid;border-bottom-width:1pt;border-right-style:solid;border-right-width:1pt" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 5pt;padding-right: 20pt;text-indent: 0pt;text-align: right;">Importe</p></td></tr>';
        
        Decimal precioTotal = 0;
        Set<Id> productosPedidos = new Set<Id>();
        for(LineaPeticionMaterial__c prod: productosSolicitud){
            productosPedidos.add(prod.Producto__c);
        }
        
        Map<Id,Product2> productosPMap = new Map<Id,Product2>([SELECT Id, Name FROM Product2 WHERE Id IN: productosPedidos]);

        

        for(LineaPeticionMaterial__c prod: productosSolicitud){
            String nombre = !Test.isRunningTest() ? productosPMap.get(prod.Producto__c).Name : 'TEST';
            System.debug('prodTest: ' + prod);
            body = body + 
            '<tr style="height:20pt"><td style="width:156pt"><p class="s4" style="padding-top: 8pt;padding-left: 2pt;text-indent: 0pt;line-height: 11pt;text-align: left;"> '+ nombre +' </p></td><p style="text-indent: 0pt;text-align: left;"><br/></p>'+
            '<p class="s5" style="padding-right: 41pt;text-indent: 0pt;line-height: 9pt;text-align: right;"> '+ prod.Cantidad__c +' </p></td><td style="width:72pt"><p style="text-indent: 0pt;text-align: left;"><br/></p>'+
            '<p class="s5" style="padding-left: 3pt;text-indent: 0pt;line-height: 10pt;text-align: left;"> '+prod.PrecioUnidad__c+' EUR</p></td><td style="width:83pt"><p style="text-indent: 0pt;text-align: left;"><br/></p>'+
            '<p class="s5" style="padding-right: 20pt;text-indent: 0pt;line-height: 10pt;text-align: right;"> ' +prod.PrecioLinea__c+' EUR</p></td></tr>';
            precioTotal = precioTotal + prod.PrecioLinea__c;
        }
        
        body = body + '</table><p style="text-indent: 0pt;text-align: left;"><br/></p><table style="border-collapse:collapse;margin-left:5.693pt" cellspacing="0"><tr style="height:23pt"><td style="width:477pt;border-top-style:solid;border-top-width:1pt;border-left-style:solid;border-left-width:1pt;border-bottom-style:solid;border-bottom-width:1pt;border-right-style:solid;border-right-width:1pt;" colspan="7" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 5pt;padding-left: 200pt;padding-right: 198pt;text-indent: 0pt;text-align: center;">Resumen Factura</p></td></tr><tr style="height:23pt"><td style="width:477pt;border-top-style:solid;border-top-width:1pt" colspan="7"><p style="text-indent: 0pt;text-align: left;"><br/></p></td></tr><tr style="height:23pt"><td style="width:122pt;border-top-style:solid;border-top-width:1pt;border-left-style:solid;border-left-width:1pt;border-bottom-style:solid;border-bottom-width:1pt;border-right-style:solid;border-right-width:1pt" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 6pt;padding-left: 26pt;padding-right: 26pt;text-indent: 0pt;text-align: center;">Base imponible</p></td><td style="width:18pt;border-left-style:solid;border-left-width:1pt;border-right-style:solid;border-right-width:1pt"><p style="text-indent: 0pt;text-align: left;"><br/></p></td><td style="width:56pt;border-top-style:solid;border-top-width:1pt;border-left-style:solid;border-left-width:1pt;border-bottom-style:solid;border-bottom-width:1pt;border-right-style:solid;border-right-width:1pt" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 4pt;padding-left: 15pt;text-indent: 0pt;text-align: left;">% IVA</p></td><td style="width:18pt;border-left-style:solid;border-left-width:1pt;border-right-style:solid;border-right-width:1pt"><p style="text-indent: 0pt;text-align: left;"><br/></p></td><td style="width:123pt;border-top-style:solid;border-top-width:1pt;border-left-style:solid;border-left-width:1pt;border-bottom-style:solid;border-bottom-width:1pt;border-right-style:solid;border-right-width:1pt" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 4pt;padding-right: 37pt;text-indent: 0pt;text-align: right;">Importe IVA</p></td><td style="width:18pt;border-left-style:solid;border-left-width:1pt;border-right-style:solid;border-right-width:1pt"><p style="text-indent: 0pt;text-align: left;"><br/></p></td><td style="width:122pt;border-top-style:solid;border-top-width:1pt;border-left-style:solid;border-left-width:1pt;border-bottom-style:solid;border-bottom-width:1pt;border-right-style:solid;border-right-width:1pt" bgcolor="#F1F1F1"><p class="s3" style="padding-top: 4pt;padding-left: 31pt;text-indent: 0pt;text-align: left;">Total Factura</p></td></tr><tr style="height:15pt"><td style="width:122pt;border-top-style:solid;border-top-width:1pt">';
        
        Decimal baseImponible = precioTotal - ((21 * precioTotal) / 100);
        Decimal importeIva = ((21 * precioTotal) / 100);

        body = body + '<p class="s4" style="padding-left: 36pt;padding-right: 34pt;text-indent: 0pt;text-align: center;">'+ baseImponible.setScale(2) +'</p></td><td style="width:18pt"><p style="text-indent: 0pt;text-align: left;"><br/></p></td><td style="width:56pt;border-top-style:solid;border-top-width:1pt"><p class="s4" style="padding-left: 18pt;text-indent: 0pt;text-align: left;">21,00</p></td><td style="width:18pt"><p style="text-indent: 0pt;text-align: left;"><br/></p></td><td style="width:123pt;border-top-style:solid;border-top-width:1pt">'+
        '<p class="s4" style="padding-top: 1pt;padding-right: 50pt;text-indent: 0pt;text-align: right;">'+ importeIva.setScale(2) +'</p></td><td style="width:18pt"><p style="text-indent: 0pt;text-align: left;"><br/></p></td><td style="width:122pt;border-top-style:solid;border-top-width:1pt">'+
        '<p class="s4" style="padding-top: 2pt;padding-left: 55pt;text-indent: 0pt;line-height: 11pt;text-align: left;">'+ precioTotal +'</p></td></tr></table></br>'+
        '</br></h2><h2 style="padding-left: 22pt;padding-top: 60pt;text-indent: 0pt;line-height: 90%;text-align: left;"><span>IMPORTANTE:</span> La forma de pago se realizará mediante TPV, a la recogida del producto.</h2>';

        List<STCK_Notificacion_Correo__mdt> notificaraList = [SELECT Notificar__c FROM STCK_Notificacion_Correo__mdt WHERE DeveloperName  = 'Equipo_Financiero'];
        
        String[] toAddresses = new String[notificaraList.size()];
        Integer i = 0;
        for (STCK_Notificacion_Correo__mdt notificara: notificaraList ){
            toAddresses[i] = notificara.Notificar__c;
            i++;
        }
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = toAddresses;
        
        message.setSubject( subject );
        message.setHtmlBody( body );
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        return null;
    }
}