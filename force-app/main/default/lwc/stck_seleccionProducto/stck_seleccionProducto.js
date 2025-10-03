import { LightningElement, track } from 'lwc';
import getProducts from '@salesforce/apex/STCK_CestaDeComprasController.getProducts';

export default class Stck_seleccionProducto extends LightningElement {
    searchKey = '';
    delayTimeout;
    isLoading = true;

    @track groupedProducts = [];
    @track products = [];
    
    connectedCallback() {
        this.loadProducts();
    }

    loadProducts() {
        this.isLoading = true;

        getProducts({ searchKey: this.searchKey })
            .then(data => {
                if (data) {
                    this.products = data;
                    this.groupProducts(data);
                }
            })
            .catch(error => {
                console.error('Error al cargar productos: ', error);
                this.products = []; // Limpiar productos en caso de error
                this.groupedProducts = []; // Limpiar groupedProducts
                // Opcional: Mostrar error al usuario (puedes agregar un toast aquí)
            })
            .finally(() => {
                this.isLoading = false; // Asegurar que se desactive el spinner
            });
    }

    get isLoading() {
        return !this.products && !this.products.error;
    }

    get hasResults() {
        return this.products && this.products.length > 0;
    }
    
    handleSearchKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
            this.loadProducts(); // Llamar a loadProducts con el nuevo searchKey
        }, 300);
    }

    handleAddToCartClick(event) {
        const { id, name, price } = event.target.dataset;
        this.dispatchEvent(new CustomEvent('addtocart', {
            detail: { id: id, name: name, price: parseFloat(price) }
        }));
    }

    // Lógica del Modal (vuelve a funcionar)
    isModalOpen = false;
    selectedProduct = {};

    handleProductClick(event) {
        event.preventDefault(); 
        const productId = event.currentTarget.dataset.id;
        // Busca el producto en la lista simple por su ID de PriceBookEntry
        this.selectedProduct = this.products.find(p => p.Id === productId);
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
        this.selectedProduct = {};
    }

    groupProducts(productList) {
        const productMap = new Map();
        productList.forEach(pbe => {
            const originalName = pbe.Product2.Name;
            if (!originalName) return;
            const nameParts = originalName.split(',');
            const baseName = nameParts[0].trim();
            const variantName = nameParts.length > 1 ? nameParts[1].trim() : 'Talla única';
            // Si el producto base no está en el mapa, lo creamos
            if (!productMap.has(baseName)) {
                productMap.set(baseName, {
                    baseName: baseName,
                    description: pbe.Product2.Description,
                    family: pbe.Product2.Family,
                    mainImageUrl: pbe.Product2.Imagen__c,
                    variants: []
                });
            }
            // Añadimos la variante al producto base correspondiente
            productMap.get(baseName).variants.push({
                productId: pbe.Product2.Id,
                variantName: variantName,
                price: pbe.UnitPrice,
                fullName: originalName
            });
        });
        // Convertimos el mapa a un array, que es lo que el HTML necesita para el bucle
        this.groupedProducts = Array.from(productMap.values());
    }
}