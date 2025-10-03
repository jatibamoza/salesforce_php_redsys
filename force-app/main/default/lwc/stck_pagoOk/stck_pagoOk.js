// stck_pagoOK.js
import { LightningElement, track } from 'lwc';
import verifyRedsysSignature from '@salesforce/apex/STCK_CestaDeComprasController.verifyRedsysSignature';
import getCartForRecovery from '@salesforce/apex/STCK_CestaDeComprasController.getCartForRecovery';

export default class Stck_pagoOK extends LightningElement {
    @track isLoading = true;
    @track loadedOk = false;
    @track hasError = false;
    @track loadingMessage = 'Validando la transacción...';

    @track nombreSolicitud; // Name (SM-xxxxxxx)
    @track orderNumber;     // OrderNumber__c (12 dígitos)
    @track orderFound = false;

    connectedCallback() {
        (async () => {
            try {
                // 1) Tomar params de Redsys del query string
                const params = new URLSearchParams(window.location.search);
                const ver  = params.get('Ds_SignatureVersion');
                const pars = params.get('Ds_MerchantParameters'); // Base64 estándar
                const sign = params.get('Ds_Signature');          // Base64URL

                if (!ver || !pars || !sign) {
                    // Si no nos llegan, mejor no confiar: manda a KO
                    this.redirectKO();
                    return;
                }

                // 2) Decodificar Ds_MerchantParameters y extraer Ds_Order / Ds_Response
                let decodedJson;
                try {
                    decodedJson = JSON.parse(atob(pars)); // Base64 estándar
                } catch (e) {
                    this.redirectKO();
                    return;
                }
                const dsOrder    = decodedJson?.Ds_Order || '';
                const dsResponse = decodedJson?.Ds_Response || '';
                const authCode   = parseInt(dsResponse, 10);

                // 3) Verificar firma en Apex
                const isValid = await verifyRedsysSignature({
                    dsMerchantParameters: pars,
                    dsSignature: sign,
                    orderNumber: dsOrder,
                    signatureVersion: ver
                });

                if (!isValid || isNaN(authCode) || authCode < 0 || authCode > 99) {
                    // Firma incorrecta o respuesta no autorizada
                    this.redirectKO();
                    return;
                }

                // 4) Firma correcta y respuesta autorizada → mostramos info
                //    Usamos el token para recuperar Name y OrderNumber si está disponible:
                const token = localStorage.getItem('recoveryToken');
                if (token) {
                    try {
                        const w = await getCartForRecovery({ recoveryToken: token });
                        if (w) {
                            this.nombreSolicitud = w.nombreSolicitud || '';
                            this.orderNumber     = w.orderName || dsOrder;
                            this.orderFound      = !!(this.nombreSolicitud || this.orderNumber);
                        } else {
                            // fallback: al menos mostrar Ds_Order
                            this.orderNumber = dsOrder;
                        }
                    } catch (_) {
                        this.orderNumber = dsOrder;
                    }
                } else {
                    // Sin token: al menos muestra Ds_Order
                    this.orderNumber = dsOrder;
                }

                this.loadedOk = true;
                this.hasError = false;
            } catch (e) {
                this.hasError = true;
                this.loadedOk = false;
            } finally {
                this.isLoading = false;
            }
        })();
    }

    redirectKO() {
        // Ajusta a tu ruta pública real
        window.location.assign('/pago-fallido');
    }

    goToStore() {
        // Ajusta a la ruta de tu storefront
        window.location.assign('/latiendadelequipo/s/');
    }
}