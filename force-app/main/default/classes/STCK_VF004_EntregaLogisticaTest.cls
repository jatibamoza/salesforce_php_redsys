@isTest
public class STCK_VF004_EntregaLogisticaTest {
    @testSetup
    static void setupTestData() {
        // Solicitud aprobada y pendiente
        STCK_SolicitudLogistica__c solicitudValida = new STCK_SolicitudLogistica__c(
            PersonaSolicitante__c = 'Persona Test',
            Direccion__c = 'ACTIVACIÓN MARCA',
            Area__c = 'Estrategia Digital',
            Estado__c = 'En progreso', // Valor válido
            EstadodeEntrega__c = 'Pendiente'
        );
        insert solicitudValida;

        // Solicitud no aprobada
        STCK_SolicitudLogistica__c solicitudNoAprobada = new STCK_SolicitudLogistica__c(
            PersonaSolicitante__c = 'Persona Test',
            Direccion__c = 'ACTIVACIÓN MARCA',
            Area__c = 'Estrategia Digital',
            Estado__c = 'En progreso', // Valor válido
            EstadodeEntrega__c = 'Pendiente'
        );
        insert solicitudNoAprobada;

        // Solicitud ya entregada
        STCK_SolicitudLogistica__c solicitudEntregada = new STCK_SolicitudLogistica__c(
            PersonaSolicitante__c = 'Persona Test',
            Direccion__c = 'ACTIVACIÓN MARCA',
            Area__c = 'Estrategia Digital',
            Estado__c = 'En progreso', // Valor válido
            EstadodeEntrega__c = 'Entregado'
        );
        insert solicitudEntregada;
    }

    @isTest
    static void testConstructorWithValidSolicitudId() {
        STCK_SolicitudLogistica__c solicitud = [SELECT Id FROM STCK_SolicitudLogistica__c WHERE Estado__c = 'En progreso' AND EstadodeEntrega__c = 'Pendiente' LIMIT 1];

        Test.setCurrentPageReference(new PageReference('/apex/EntregaLogisticaPage'));
        ApexPages.currentPage().getParameters().put('solicitudId', solicitud.Id);

        STCK_VF004_EntregaLogisticaController controller = new STCK_VF004_EntregaLogisticaController();

        System.assert(controller.solicitud != null, 'La solicitud debería ser válida.');
        System.assert(controller.mostrarConfirmacion, 'Debería mostrarse la confirmación para una solicitud En progreso y pendiente.');
    }

@isTest
static void testConstructorWithInvalidSolicitudId() {
    Test.setCurrentPageReference(new PageReference('/apex/EntregaLogisticaPage'));
    ApexPages.currentPage().getParameters().put('solicitudId', 'invalidId');

    // Instanciar el controlador
    STCK_VF004_EntregaLogisticaController controller = new STCK_VF004_EntregaLogisticaController();

    // Verificar que no se encontró una solicitud
    System.assert(controller.solicitud == null, 'La solicitud debería ser null para un ID inválido.');

    // Verificar que se generó un mensaje de error
    List<ApexPages.Message> messages = ApexPages.getMessages();
    System.assert(messages.size() > 0, 'Debería haber al menos un mensaje de error para un ID inválido.');
    System.assertEquals('No se encontró la solicitud con el ID proporcionado.', messages[0].getSummary(),
        'El mensaje de error debería coincidir con el esperado.');
}

    @isTest
    static void testConstructorWithoutSolicitudId() {
        Test.setCurrentPageReference(new PageReference('/apex/EntregaLogisticaPage'));

        STCK_VF004_EntregaLogisticaController controller = new STCK_VF004_EntregaLogisticaController();

        System.assert(controller.solicitud == null, 'La solicitud debería ser null si no se proporciona un ID.');
        List<ApexPages.Message> messages = ApexPages.getMessages();
        System.assert(messages.size() > 0, 'Debería haber un mensaje de error si no se proporciona un ID.');
        System.assertEquals('No se proporcionó el ID de la solicitud.', messages[0].getSummary());
    }

    @isTest
    static void testConfirmarEntrega() {
        STCK_SolicitudLogistica__c solicitud = [SELECT Id FROM STCK_SolicitudLogistica__c WHERE Estado__c = 'En progreso' AND EstadodeEntrega__c = 'Pendiente' LIMIT 1];

        Test.setCurrentPageReference(new PageReference('/apex/EntregaLogisticaPage'));
        ApexPages.currentPage().getParameters().put('solicitudId', solicitud.Id);

        STCK_VF004_EntregaLogisticaController controller = new STCK_VF004_EntregaLogisticaController();
        controller.wrapper.nombreRecibido = 'Test User';

        controller.confirmarEntrega();

        solicitud = [SELECT EstadodeEntrega__c FROM STCK_SolicitudLogistica__c WHERE Id = :solicitud.Id];
        System.assertEquals('Entregado', solicitud.EstadodeEntrega__c, 'La solicitud debería estar marcada como entregada.');
    }

    @isTest
    static void testConfirmarEntregaWithNullSolicitud() {
        Test.setCurrentPageReference(new PageReference('/apex/EntregaLogisticaPage'));
        ApexPages.currentPage().getParameters().put('solicitudId', '');

        STCK_VF004_EntregaLogisticaController controller = new STCK_VF004_EntregaLogisticaController();
        controller.confirmarEntrega();

        List<ApexPages.Message> messages = ApexPages.getMessages();
        System.assert(messages.size() > 0, 'Debería haber al menos un mensaje de error.');
        System.assertEquals('No se proporcionó el ID de la solicitud.', messages[0].getSummary());
    }
}