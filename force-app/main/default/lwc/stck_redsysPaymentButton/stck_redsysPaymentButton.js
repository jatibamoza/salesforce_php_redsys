// stck_redsysPaymentButton.js
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Stck_redsysPaymentButton extends LightningElement {
    @api redsysParams; // Ahora es un string (JSON)
    isLoading = false;
    error;

    handlePaymentClick() {
        this.isLoading = true;
        this.error = undefined;

        // Parsear el JSON stringificado
        let parsedParams;
        try {
            parsedParams = JSON.parse(this.redsysParams);
        } catch (e) {
            this.error = 'Error al parsear los parámetros de Redsys: ' + e.message;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error al iniciar el pago',
                    message: this.error,
                    variant: 'error'
                })
            );
            this.isLoading = false;
            return;
        }

        if (!parsedParams || !parsedParams.redsysUrl || !parsedParams.dsMerchantParameters || !parsedParams.dsSignature || !parsedParams.dsSignatureVersion) {
            this.error = 'Parámetros de Redsys incompletos o inválidos.';
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error al iniciar el pago',
                    message: this.error,
                    variant: 'error'
                })
            );
            this.isLoading = false;
            return;
        }

        try {
            this.submitToRedsys(
                parsedParams.redsysUrl,
                parsedParams.dsMerchantParameters,
                parsedParams.dsSignature,
                parsedParams.dsSignatureVersion
            );
        } catch (error) {
            this.error = error.message || 'Error desconocido al iniciar el pago.';
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error al iniciar el pago',
                    message: this.error,
                    variant: 'error'
                })
            );
            this.isLoading = false;
        }
    }

    submitToRedsys(url, params, signature, signatureVersion) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = url;
        form.style.display = 'none';

        const fields = {
            Ds_SignatureVersion: signatureVersion,
            Ds_MerchantParameters: params,
            Ds_Signature: signature
        };

        for (const key in fields) {
            const hiddenField = document.createElement('input');
            hiddenField.type = 'hidden';
            hiddenField.name = key;
            hiddenField.value = fields[key];
            form.appendChild(hiddenField);
        }

        this.template.appendChild(form);
        form.submit();
    }
}