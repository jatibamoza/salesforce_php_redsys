public without sharing class STCK_VF004_EntregaLogisticaController {
    public String solicitudId { get; set; }
    public STCK_SolicitudLogistica__c solicitud { get; set; }
    public WrapperDatos wrapper { get; set; }
    
    public Boolean mostrarConfirmacion { get; private set; }
    public String avisoEstado { get; private set; }

    public STCK_VF004_EntregaLogisticaController() {
        wrapper = new WrapperDatos();
        solicitudId = ApexPages.currentPage().getParameters().get('solicitudId');
        
        if (!String.isBlank(solicitudId)) {
            solicitud = obtenerSolicitud(solicitudId);
            if (solicitud == null) {
                mostrarConfirmacion = false;
                avisoEstado = 'La solicitud no está disponible para visualización. Ésta se encuentra en proceso de aprobación o ya ha sido entregada.';
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 'No se encontró la solicitud con el ID proporcionado.'
                ));
            } else {
                if (solicitud.Estado__c == 'En progreso' && solicitud.EstadodeEntrega__c == 'Pendiente') {
                    mostrarConfirmacion = true;
                } else {
                    mostrarConfirmacion = false;
                    if (solicitud.Estado__c != 'En progreso') {
                        avisoEstado = 'La Solicitud está en proceso de Aprobación.';
                    } else if (solicitud.EstadodeEntrega__c != 'Pendiente') {
                        avisoEstado = 'La Solicitud ya fue entregada.';
                    }
                }
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, 'No se proporcionó el ID de la solicitud.'
            ));
        }
    }

    private STCK_SolicitudLogistica__c obtenerSolicitud(String solicitudId) {
        List<STCK_SolicitudLogistica__c> solicitudes = [
            SELECT Id, Name, PersonaSolicitante__c, Direccion__c, Area__c, Estado__c, EstadodeEntrega__c
            FROM STCK_SolicitudLogistica__c
            WHERE Id = :solicitudId
            LIMIT 1
        ];
        return solicitudes.isEmpty() ? null : solicitudes[0];
    }

    public PageReference confirmarEntrega() {
        if (solicitud == null) {
            if (ApexPages.getMessages().isEmpty()) { // Evitar mensajes duplicados
                ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR, 'Error: No hay un registro de solicitud válido para procesar.'
                ));
            }
            return null;
        }

        try {
            solicitud.NombreQuienRecibe__c = wrapper.nombreRecibido;
            solicitud.FechaHoraRecibido__c = DateTime.now();
            solicitud.EstadodeEntrega__c = 'Entregado';
            solicitud.Estado__c = 'Aprobada';
            update solicitud;

            mostrarConfirmacion = false;

            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.CONFIRM, 'La entrega ha sido confirmada exitosamente y el estado de la solicitud se actualizó a "Aprobada".'
            ));
            return null;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, 'Error al confirmar la entrega: ' + e.getMessage()
            ));
            return null;
        }
    }

    public class WrapperDatos {
        public String nombreRecibido { get; set; }
    }
}