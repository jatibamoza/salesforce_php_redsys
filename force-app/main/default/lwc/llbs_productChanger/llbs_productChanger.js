import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import getOpportunityProducts from '@salesforce/apex/LLBS_OpportunityProductController.getOpportunityProducts';
import searchProducts from '@salesforce/apex/LLBS_OpportunityProductController.searchProducts';
import replaceProduct from '@salesforce/apex/LLBS_OpportunityProductController.replaceProduct';

// Utility function to extract error messages
const reduceErrors = (errors) => {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    return (
        errors
            .filter((error) => !!error)
            .map((error) => {
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                } else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                } else if (typeof error.message === 'string') {
                    return error.message;
                }
                return error.statusText;
            })
            .reduce((prev, curr) => prev.concat(curr), [])
            .filter((message) => !!message)
    );
};

const COLUMNS = [
    { label: 'Nombre del Producto', fieldName: 'ProductName', type: 'text' },
    { label: 'Código de Producto', fieldName: 'ProductCode', type: 'text' },
    { label: 'Cantidad', fieldName: 'Quantity', type: 'number' },
    { label: 'Precio Unitario', fieldName: 'UnitPrice', type: 'currency' },
];

export default class LlBS_ProductChanger extends LightningElement {
    @api recordId;
    @track opportunityProducts;
    @track columns = COLUMNS;
    @track selectedLineItemId;
    @track products;
    @track newPricebookEntryId;
    @track quantity;
    @track pricebookId;
    searchTerm = '';
    delayTimeout;

    @wire(getOpportunityProducts, { opportunityId: '$recordId' })
    wiredOppProducts({ error, data }) {
        if (data) {
            this.opportunityProducts = data.map(item => ({
                ...item,
                ProductName: item.Product2.Name,
                ProductCode: item.Product2.ProductCode
            }));
            if (data.length > 0 && data[0].PricebookEntry) {
              this.pricebookId = data[0].PricebookEntry.Pricebook2Id;
            }
        } else if (error) {
            // **MANEJO DE ERROR MEJORADO**
            const errorMessage = reduceErrors(error).join(', ');
            this.showToast('Error al cargar productos', errorMessage, 'error');
        }
    }

    @wire(searchProducts, { searchTerm: '$searchTerm', pricebookId: '$pricebookId' })
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data;
        } else if (error) {
            // **MANEJO DE ERROR MEJORADO**
            const errorMessage = reduceErrors(error).join(', ');
            this.showToast('Error en la búsqueda', errorMessage, 'error');
        }
    }

    get productOptions() {
        if (!this.products) return [];
        return this.products.map(prod => ({
            label: `${prod.Product2.Name} (${prod.Product2.ProductCode || 'N/A'})`,
            value: prod.Id
        }));
    }

    get isChangeReady() {
        return this.newPricebookEntryId && this.quantity > 0;
    }

    get isConfirmButtonDisabled() {
        return !this.isChangeReady;
    }

    handleRowSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedLineItemId = selectedRows.length > 0 ? selectedRows[0].Id : null;
        if (this.selectedLineItemId) {
            this.quantity = selectedRows[0].Quantity;
        }
    }

    handleSearch(event) {
        window.clearTimeout(this.delayTimeout);
        const searchTerm = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchTerm = searchTerm;
        }, 300);
    }

    handleProductSelection(event) {
        this.newPricebookEntryId = event.detail.value;
    }

    confirmChange() {
        replaceProduct({ oldOppLineItemId: this.selectedLineItemId, newPricebookEntryId: this.newPricebookEntryId, quantity: this.quantity })
            .then(() => {
                this.showToast('Éxito', 'El producto se ha cambiado correctamente.', 'success');
                this.closeAction();
                // Esta línea puede fallar si se ejecuta fuera de un entorno Aura.
                // Es mejor usar un método más moderno si es posible, pero lo dejamos por ahora.
                try {
                    eval("$A.get('e.force:refreshView').fire();");
                } catch(e) {
                    console.error('Could not refresh view:', e);
                }
            })
            .catch(error => {
                // **MANEJO DE ERROR MEJORADO**
                const errorMessage = reduceErrors(error).join(', ');
                this.showToast('Error al reemplazar el producto', errorMessage, 'error');
            });
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(event);
    }
}