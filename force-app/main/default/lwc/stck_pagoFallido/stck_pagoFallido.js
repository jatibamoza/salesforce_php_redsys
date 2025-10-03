// stck_pagoFallido.js
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import verifyRedsysSignature from '@salesforce/apex/STCK_CestaDeComprasController.verifyRedsysSignature';
import markOrderFailed from '@salesforce/apex/STCK_CestaDeComprasController.markOrderFailed';
import getCartForRecovery from '@salesforce/apex/STCK_CestaDeComprasController.getCartForRecovery';

export default class Stck_pagoFallido extends NavigationMixin(LightningElement) {

    async connectedCallback() {
        try {
            // 1) Verificar si en realidad vino autorizado (por si el usuario cayó aquí por error)
            const params = new URLSearchParams(window.location.search);
            const ver  = params.get('Ds_SignatureVersion');
            const pars = params.get('Ds_MerchantParameters');
            const sign = params.get('Ds_Signature');

            if (ver && pars && sign) {
                try {
                    const decoded = JSON.parse(atob(pars));
                    const dsOrder    = decoded?.Ds_Order || '';
                    const dsResponse = decoded?.Ds_Response || '';
                    const authCode   = parseInt(dsResponse, 10);

                    const isValid = await verifyRedsysSignature({
                        dsMerchantParameters: pars,
                        dsSignature: sign,
                        orderNumber: dsOrder,
                        signatureVersion: ver
                    });

                    if (isValid && !isNaN(authCode) && authCode >= 0 && authCode <= 99) {
                        // Está autorizado y firma OK → redirigir a OK
                        window.location.assign('/pago-exitoso');
                        return;
                    }
                } catch (_) {
                    // ignore y seguimos flujo KO
                }
            }

            // 2) UX: marcar como Failed (opcional) si tenemos token
            const token = localStorage.getItem('recoveryToken');
            if (token) {
                // Nota: el estado "oficial" debería actualizarlo el MerchantURL.
                // Esto es opcional por UX.
                markOrderFailed({ recoveryToken: token }).catch(()=>{});
            }

            // 3) Restaurar carrito: si ya existe en localStorage, toast y navegar
            const storedCart = localStorage.getItem('cartItems');
            if (storedCart) {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Carrito Restaurado',
                    message: 'Tu carrito está listo. Redirigiendo a la cesta de compras...',
                    variant: 'info'
                }));
                this.navigateToCart();
                return;
            }

            // 4) Sin carrito local → intentar recuperarlo por token desde servidor
            if (token) {
                try {
                    const w = await getCartForRecovery({ recoveryToken: token });
                    if (w && Array.isArray(w.items)) {
                        const items = w.items.map(it => ({
                            id: it.id, quantity: it.quantity, price: it.price
                        }));
                        localStorage.setItem('cartItems', JSON.stringify(items));
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Carrito Recuperado',
                            message: 'Hemos restaurado tu carrito. Redirigiendo...',
                            variant: 'success'
                        }));
                    }
                } catch (_) {
                    // si falla, seguimos igual, solo navegamos
                }
            }

            // 5) Navegar al carrito
            this.navigateToCart();

        } catch (e) {
            // Pase lo que pase, que el usuario vuelva al carrito
            this.navigateToCart();
        }
    }

    handleReturnToCart() {
        const storedCart = localStorage.getItem('cartItems');
        if (storedCart) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Carrito Restaurado',
                message: 'Redirigiendo...',
                variant: 'info'
            }));
        }
        this.navigateToCart();
    }

    navigateToCart() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: { url: '/latiendadelequipo/s' } // ajusta la ruta real de tu sitio
        });
    }
}