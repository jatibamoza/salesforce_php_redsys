// stck_productCatalog.js
import { LightningElement, wire, track } from 'lwc';
import getProductCategories from '@salesforce/apex/STCK_ProductCatalogController.getProductCategories';
import getProducts from '@salesforce/apex/STCK_ProductCatalogController.getProducts';

// URL de una imagen genérica para productos que no tengan una
const DEFAULT_IMAGE_URL = '/sfsites/c/resource/SLDS_Illustrations/illustrations/empty-state-tasks.svg';

export default class Stck_ProductCatalog extends LightningElement {
	// Propiedades para los filtros
	searchKey = '';
	selectedCategory = '';
	
	// Propiedades para los datos
	@track products = [];
	@track groupedProducts = [];
	categoryOptions = [];

	// Propiedades para gestionar el estado de la UI
	isLoading = true;
	error;
	searchTimeout;

	// Obtiene las categorías de producto usando @wire
	@wire(getProductCategories)
	wiredCategories({ error, data }) {
		if (data) {
			// Mapeamos los datos para el formato que necesita lightning-combobox
			this.categoryOptions = [{ label: 'Todas las categorías', value: '' }];
			data.forEach(category => {
				this.categoryOptions.push({ label: category, value: category });
			});
		} else if (error) {
			this.error = error;
		}
	}

	// Se ejecuta cuando el componente se carga en la página
	connectedCallback() {
		this.loadProducts();
	}

	// Gestiona el cambio en el campo de búsqueda de texto
	handleSearchKeyChange(event) {
		this.searchKey = event.target.value;
		// Debounce: Espera 300ms después de que el usuario deja de escribir antes de buscar
		clearTimeout(this.searchTimeout);
		this.searchTimeout = setTimeout(() => {
			this.loadProducts();
		}, 300);
	}
	
	// Gestiona el cambio en el combobox de categoría
	handleCategoryChange(event) {
		this.selectedCategory = event.detail.value;
		this.loadProducts();
	}

	// Llama al método Apex para obtener los productos
	async loadProducts() {
		this.isLoading = true;
		try {
			const result = await getProducts({ 
				searchKey: this.searchKey, 
				category: this.selectedCategory 
			});
			this.products = result;
			this.error = undefined;

			this.groupProducts(result);
		} catch (error) {
			this.error = error;
			this.products = [];
			console.error('Error al cargar productos:', this.error);
		} finally {
			this.isLoading = false;
		}
	}

	// Getter para saber si no hay resultados que mostrar
	get isNoResults() {
		return !this.isLoading && this.products.length === 0;
	}

	// Función para manejar errores al cargar imágenes de producto
	handleImageError(event) {
		event.target.src = DEFAULT_IMAGE_URL;
		event.target.classList.add('image-error'); // Opcional: añade una clase para estilizar la imagen por defecto
	}

	// --- NUEVA FUNCIÓN DE AGRUPACIÓN EN JAVASCRIPT ---
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
				variantName: variantName.split(' ')[1] + ' ',
				price: pbe.UnitPrice,
				fullName: originalName
			});
		});
		// Convertimos el mapa a un array, que es lo que el HTML necesita para el bucle
		this.groupedProducts = Array.from(productMap.values());
	}
}