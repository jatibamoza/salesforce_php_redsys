import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMaterialRequestDetails from '@salesforce/apex/STCK_DevolucionController.getMaterialRequestDetails';
import getReturnMethods from '@salesforce/apex/STCK_DevolucionController.getReturnMethods';
import processLineItemReturns from '@salesforce/apex/STCK_DevolucionController.processLineItemReturns';

export default class Stck_formularioDevolucion extends LightningElement {
    @track currentStep = 'search'; // Posibles pasos: search, review, alreadyReturned, success
    @track requestCode = '';
    @track email = '';
    @track orderDetails;
    @track existingReturnDetails; // Para guardar los datos de la devolución existente
    @track returnMethodOptions = [];
    @track selectedMethod = '';
    @track selectedLineIds = [];
    isLoading = false;

    columns = [
        { label: 'Producto', fieldName: 'ProductName', type: 'text', wrapText: true },
        { label: 'Cantidad', fieldName: 'Quantity', type: 'number', initialWidth: 100 },
        { label: 'Precio Unitario', fieldName: 'UnitPrice', type: 'currency', typeAttributes: { currencyCode: 'EUR' } },
        { label: 'Precio Total', fieldName: 'TotalPrice', type: 'currency', typeAttributes: { currencyCode: 'EUR' } }
    ];

    @wire(getReturnMethods)
    wiredMethods({ error, data }) {
        if (data) {
            this.returnMethodOptions = data;
        }
    }

    get isSearchStep() { return this.currentStep === 'search'; }
    get isReviewStep() { return this.currentStep === 'review'; }
    get isAlreadyReturnedStep() { return this.currentStep === 'alreadyReturned'; }
    get isSuccessStep() { return this.currentStep === 'success'; }

    get orderLines() {
        if (this.orderDetails && this.orderDetails.Lineas_Peticion_Material__r) {
            return this.orderDetails.Lineas_Peticion_Material__r.map(line => ({
                Id: line.Id,
                ProductName: line.Producto__r.Name,
                Quantity: line.Cantidad__c,
                UnitPrice: line.PrecioUnidad__c,
                TotalPrice: line.PrecioLinea__c
            }));
        }
        return [];
    }

    handleCodeChange(event) { this.requestCode = event.target.value; }
    handleEmailChange(event) { this.email = event.target.value; }
    handleMethodChange(event) { this.selectedMethod = event.target.value; }
    handleRowSelection(event) {
        this.selectedLineIds = event.detail.selectedRows.map(row => row.Id);
    }

    handleFindRequest() {
        if (!this.requestCode || !this.email) {
            this.showToast('Error', 'Por favor, introduce el código de solicitud y el correo electrónico.', 'error');
            return;
        }
        this.isLoading = true;
        getMaterialRequestDetails({ requestCode: this.requestCode, email: this.email })
            .then(result => {
                // --- LÓGICA CLAVE ---
                // Se comprueba si la respuesta de Apex contiene una devolución existente.
                if (result && result.existingReturn) {
                    // Si existe, se guardan los datos y se cambia a la pantalla de advertencia.
                    this.existingReturnDetails = result.existingReturn;
                    this.orderDetails = result.materialRequest; // Guardamos también los datos del pedido original
                    this.currentStep = 'alreadyReturned';
                } else if (result && result.materialRequest) {
                    // Si no, se continúa al paso de revisión normal.
                    this.orderDetails = result.materialRequest;
                    this.currentStep = 'review';
                } else {
                    // Caso inesperado
                    throw new Error('La respuesta del servidor no es válida.');
                }
            })
            .catch(error => { 
                this.showToast('Error', error.body ? error.body.message : error.message, 'error'); 
            })
            .finally(() => { this.isLoading = false; });
    }

    handleConfirmReturn() {
        if (this.selectedLineIds.length === 0 || !this.selectedMethod) {
            this.showToast('Error', 'Debes seleccionar al menos un artículo y un método de devolución.', 'error');
            return;
        }
        this.isLoading = true;
        processLineItemReturns({ 
            lineItemIds: this.selectedLineIds, 
            returnMethod: this.selectedMethod
        })
            .then(() => {
                this.currentStep = 'success';
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleNewReturn() {
        this.currentStep = 'search';
        this.requestCode = '';
        this.email = '';
        this.orderDetails = null;
        this.existingReturnDetails = null;
        this.selectedMethod = '';
        this.selectedLineIds = [];
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}