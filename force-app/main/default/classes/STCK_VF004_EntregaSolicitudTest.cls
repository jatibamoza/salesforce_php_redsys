@isTest
public class STCK_VF004_EntregaSolicitudTest {
    @testSetup
    static void setupTestData() {
        // Crear un registro de prueba con condiciones válidas
        PeticionMaterial__c solicitudValida = new PeticionMaterial__c(
            PersonaSolicitante__c = 'Persona Test',
            Direccion__c = 'ACTIVACIÓN MARCA',
            Area__c = 'Estrategia Digital',
            LugarEntrega__c = 'Oficina Torrelaguna',
            STCK_HTMLProducts__c = '<p>Producto de prueba</p>',
            Estado__c = 'En progreso', // Valor válido del picklist
            EstadodeEntrega__c = 'Pendiente' // Supongo que este campo no es restringido
        );
        insert solicitudValida;

        // Crear un registro de prueba con estado Nueva
        PeticionMaterial__c solicitudNoAprobada = new PeticionMaterial__c(
            PersonaSolicitante__c = 'Persona Test',
            Direccion__c = 'ACTIVACIÓN MARCA',
            Area__c = 'Estrategia Digital',
            LugarEntrega__c = 'Oficina Torrelaguna',
            STCK_HTMLProducts__c = '<p>Producto de prueba</p>',
            Estado__c = 'Nueva', // Valor válido del picklist
            EstadodeEntrega__c = 'Pendiente' // Supongo que este campo no es restringido
        );
        insert solicitudNoAprobada;

        // Crear un registro de prueba ya entregado
        PeticionMaterial__c solicitudEntregada = new PeticionMaterial__c(
            PersonaSolicitante__c = 'Persona Test',
            Direccion__c = 'ACTIVACIÓN MARCA',
            Area__c = 'Estrategia Digital',
            LugarEntrega__c = 'Oficina Torrelaguna',
            STCK_HTMLProducts__c = '<p>Producto de prueba</p>',
            Estado__c = 'Aprobada', // Valor válido del picklist
            EstadodeEntrega__c = 'Entregado' // Supongo que este campo no es restringido
        );
        insert solicitudEntregada;
    }

    @isTest
    static void testConstructorWithValidSolicitudId() {
        PeticionMaterial__c solicitud = [SELECT Id FROM PeticionMaterial__c WHERE Estado__c = 'En progreso' LIMIT 1];
        Test.setCurrentPageReference(new PageReference('/apex/EntregaSolicitudPage'));
        ApexPages.currentPage().getParameters().put('solicitudId', solicitud.Id);

        STCK_VF004_EntregaSolicitudController controller = new STCK_VF004_EntregaSolicitudController();
        System.assert(controller.solicitud != null, 'La solicitud debería ser válida.');
        System.assert(controller.mostrarConfirmacion, 'Debería mostrarse la confirmación para una solicitud En progreso y pendiente.');
    }

    @isTest
    static void testConstructorWithInvalidSolicitudId() {
        Test.setCurrentPageReference(new PageReference('/apex/EntregaSolicitudPage'));
        ApexPages.currentPage().getParameters().put('solicitudId', 'invalidId');

        STCK_VF004_EntregaSolicitudController controller = new STCK_VF004_EntregaSolicitudController();

        System.assert(controller.solicitud == null, 'La solicitud debería ser null para un ID inválido.');
        List<ApexPages.Message> messages = ApexPages.getMessages();
        System.assert(messages.size() > 0, 'Debería haber al menos un mensaje de error para un ID inválido.');
        System.assertEquals('No se encontró la solicitud con el ID proporcionado.', messages[0].getSummary());
    }

    @isTest
    static void testConstructorWithSolicitudNotApproved() {
        PeticionMaterial__c solicitud = [SELECT Id FROM PeticionMaterial__c WHERE Estado__c = 'Nueva' LIMIT 1];
        Test.setCurrentPageReference(new PageReference('/apex/EntregaSolicitudPage'));
        ApexPages.currentPage().getParameters().put('solicitudId', solicitud.Id);

        STCK_VF004_EntregaSolicitudController controller = new STCK_VF004_EntregaSolicitudController();
        System.assert(controller.solicitud != null, 'La solicitud debería existir.');
        System.assert(!controller.mostrarConfirmacion, 'No debería mostrarse la confirmación para una solicitud en estado Nueva.');
        System.assertEquals('La Solicitud está en proceso de Aprobación.', controller.avisoEstado);
    }

    @isTest
    static void testConfirmarEntrega() {
        PeticionMaterial__c solicitud = [SELECT Id FROM PeticionMaterial__c WHERE Estado__c = 'En progreso' AND EstadodeEntrega__c = 'Pendiente' LIMIT 1];
        Test.setCurrentPageReference(new PageReference('/apex/EntregaSolicitudPage'));
        ApexPages.currentPage().getParameters().put('solicitudId', solicitud.Id);

        STCK_VF004_EntregaSolicitudController controller = new STCK_VF004_EntregaSolicitudController();
        controller.wrapper.nombreRecibido = 'Test User';

        controller.confirmarEntrega();

        solicitud = [SELECT EstadodeEntrega__c, Estado__c, NombreQuienRecibe__c, FechaHoraRecibido__c FROM PeticionMaterial__c WHERE Id = :solicitud.Id];
        System.assertEquals('Entregado', solicitud.EstadodeEntrega__c, 'La solicitud debería estar marcada como entregada.');
        System.assertEquals('Aprobada', solicitud.Estado__c, 'La solicitud debería estar en estado Aprobada.');
        System.assertEquals('Test User', solicitud.NombreQuienRecibe__c, 'El nombre del receptor debería estar actualizado.');
        System.assertNotEquals(null, solicitud.FechaHoraRecibido__c, 'La fecha de recepción no debería ser nula.');
    }

    @isTest
    static void testConfirmarEntregaWithNullSolicitud() {
        Test.setCurrentPageReference(new PageReference('/apex/EntregaSolicitudPage'));
        ApexPages.currentPage().getParameters().put('solicitudId', '');

        STCK_VF004_EntregaSolicitudController controller = new STCK_VF004_EntregaSolicitudController();
        controller.confirmarEntrega();

        List<ApexPages.Message> messages = ApexPages.getMessages();
        System.assert(messages.size() > 0, 'Debería haber al menos un mensaje de error.');
        System.assertEquals('No se proporcionó el ID de la solicitud.', messages[0].getSummary());
    }
}