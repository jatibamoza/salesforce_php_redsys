// stck_cestaDeComprasScroll.js
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// Apex
import createOrderAndGetRedsysParams from '@salesforce/apex/STCK_CestaDeComprasController.createOrderAndGetRedsysParams';
import createOrderAndGetBridgeParams from '@salesforce/apex/STCK_CestaDeComprasController.createOrderAndGetBridgeParams';
import verifyRedsysSignature from '@salesforce/apex/STCK_CestaDeComprasController.verifyRedsysSignature';
import checkIfStoreIsOpen from '@salesforce/apex/STCK_CestaDeComprasController.checkIfStoreIsOpen';
import getStoreConfiguration from '@salesforce/apex/STCK_CestaDeComprasController.getStoreConfiguration';
import validatePromoCode from '@salesforce/apex/STCK_CestaDeComprasController.validatePromoCode';
import getCartForRecovery from '@salesforce/apex/STCK_CestaDeComprasController.getCartForRecovery';

async function sha256HexFromString(str) {
	const enc = new TextEncoder();
	const digest = await crypto.subtle.digest('SHA-256', enc.encode(str));
	return [...new Uint8Array(digest)].map(x => x.toString(16).padStart(2,'0')).join('');
}

async function sha256HexFromBase64(urlSafeB64) {
	let std = (urlSafeB64 || '').replace(/-/g, '+').replace(/_/g, '/');
	while (std.length % 4) std += '=';
	const bin = Uint8Array.from(atob(std), c => c.charCodeAt(0));
	const digest = await crypto.subtle.digest('SHA-256', bin);
	return [...new Uint8Array(digest)].map(x => x.toString(16).padStart(2,'0')).join('');
}
// === Helpers Base64URL/JSON ===
function base64UrlToStd(b64url) {
  if (!b64url || typeof b64url !== 'string') return '';
  let std = b64url.replace(/-/g, '+').replace(/_/g, '/');
  // padding a múltiplo de 4
  while (std.length % 4) std += '=';
  return std;
}

function decodeBase64UrlToJson(b64url) {
  try {
	const std = base64UrlToStd(b64url);
	return JSON.parse(atob(std));
  } catch (e) {
	console.warn('decodeBase64UrlToJson() fallo:', e);
	return null;
  }
}
export default class Stck_cestaDeComprasScroll extends LightningElement {
	// Estado de la cesta / usuario / totales
	@track cartItems = [];
	@track userInfo = {};
	@track appliedDiscount = null; // { type: 'PERCENTAGE'|'FIXED', value: Decimal }
	@track promoCode = '';
	// Configuración de tienda
	@track vatRate = 0;
	@track subtotal = 0;
	@track discountAmount = 0;
	@track taxAmount = 0;
	@track finalTotal = 0;
	// UI / flujo (carga inicial + acciones)
	@track isLoading = true;        // legacy (no usar durante pago)
	@track isStoreOpen = false;
	@track initialCheckDone = false;
	@track loadingMessage = 'Comprobando el estado de la tienda...';
	// ✅ Para cuadrar con tu HTML actual:
	@track isInitializing = true;   // usado por el HTML (spinner inicial)
	@track isBusy = false;          // overlay para acciones (si lo quieres usar luego)
	// RedSys (debug/inspección)
	@track redsysParams = null;
	// ---- guard anti-doble envío ----
	_submitting = false;
	// Ciclo de vida
	connectedCallback() {
		try {
			const savedUser = localStorage.getItem('userInfo');
			if (savedUser) this.userInfo = JSON.parse(savedUser);

			const cartItems = localStorage.getItem('cartItems');
			if (cartItems) {
				this.cartItems = JSON.parse(cartItems);
				this.initStore();
				return;
			}

			const token = localStorage.getItem('recoveryToken');
			if (token) {
			getCartForRecovery({ recoveryToken: token })
				.then(w => {
				if (w && w.items) {
					this.cartItems = w.items.map(it => ({
					id: it.id,
					quantity: it.quantity,
					price: it.price
					}));
					this.userInfo = {
					...this.userInfo,
					name: w.nombre,
					email: w.email,
					billingAddress: w.billingAddress,
					postalCode: w.postalCode,
					dni: w.dni
					};
					localStorage.setItem('cartItems', JSON.stringify(this.cartItems));
					localStorage.setItem('userInfo', JSON.stringify(this.userInfo));
					// 👇 importante recalcular
					this.recalculateTotals();
				}
				})
				.catch(() => this.showToast('Aviso', 'No fue posible recuperar el carrito automáticamente.', 'warning'))
				.finally(() => this.initStore());
			return;
			}


			this.initStore();
		} catch (e) {
			this.isLoading = false;
			this.initialCheckDone = true;
			this.isInitializing = false;
			this.showToast('Error', 'Se produjo un error inicializando la cesta.', 'error');
		}
	}
	// ---- Limpieza ----
	disconnectedCallback() {
		// se dispara cuando el componente se desmonta
		this._submitting = false;
	}
	// ---- Configuración inicial ----
	initStore() {
		checkIfStoreIsOpen()
			.then(isOpen => {
				this.isStoreOpen = isOpen;
				if (isOpen) {
					this.loadConfiguration();
				} else {
					this.isLoading = false;
					this.initialCheckDone = true;
					this.isInitializing = false;
				}
			})
			.catch(() => {
				this.showToast('Error', 'No se pudo verificar el horario de la tienda.', 'error');
				this.isLoading = false;
				this.initialCheckDone = true;
				this.isInitializing = false; 
			});
	}
	// ---- Carga de configuración inicial ----
	loadConfiguration() {
	getStoreConfiguration()
		.then(config => {
		this.vatRate = config.Porcentaje_IVA__c;
		// 👇 recalcula ahora que ya tienes el IVA
		this.recalculateTotals();

		this.isLoading = false;
		this.initialCheckDone = true;
		this.isInitializing = false;
		})
		.catch(() => {
		this.showToast('Error', 'No se pudo cargar la configuración de la tienda.', 'error');
		this.isLoading = false;
		this.initialCheckDone = true;
		this.isInitializing = false;
		});
	}
	
	get showStoreContent() { return this.initialCheckDone && this.isStoreOpen; }
	get showClosedMessage() { return this.initialCheckDone && !this.isStoreOpen; }
	// ---- Agrega al Carrito ----
	handleAddToCart(event) {
		const product = event.detail;
		const existingItem = this.cartItems.find(item => item.id === product.id);
		if (existingItem) existingItem.quantity++;
		else this.cartItems.push({ ...product, quantity: 1 });

		this.cartItems = [...this.cartItems];
		localStorage.setItem('cartItems', JSON.stringify(this.cartItems));
		this.recalculateTotals();
	}
	// ---- Actualiza carrito ----
	handleUpdateCart(event) {
		this.cartItems = event.detail.items;
		localStorage.setItem('cartItems', JSON.stringify(this.cartItems));
		this.recalculateTotals();
	}
	// ---- Actualiza Formulario envío ----
	handleFormUpdate(event) {
		this.userInfo = { ...this.userInfo, ...event.detail.formData };
		localStorage.setItem('userInfo', JSON.stringify(this.userInfo));
	}
	// ---- Promociones ----
	get hasVoucher() { return !!this.appliedDiscount; }
	get hasPromoApplied() { return !!(this.appliedDiscount && this.appliedDiscount.value > 0); }

	handleClearPromo() {
		if (!this.hasPromoApplied && !this.promoCode) return;

		this.appliedDiscount = null;
		this.promoCode = '';
		this.recalculateTotals();

		// Resetea el input del hijo
		const pagoCmp = this.template.querySelector('c-stck_formulario-pago');
		if (pagoCmp && typeof pagoCmp.resetForm === 'function') {
			try { pagoCmp.resetForm(); } catch (_) {}
		}
		this.showToast('Listo', 'Se borró el voucher. Ahora puedes ingresar uno nuevo.', 'success');
	}
	// ---- Aplica promción ----
	handleApplyPromo(event) {
		const incomingRaw = (event.detail?.promoCode || '').trim();
		const incoming = incomingRaw.toUpperCase();

		const currentAppliedCode = this.appliedDiscount ? (this.promoCode || '').trim().toUpperCase() : '';
		this.promoCode = incoming;

		if (this.appliedDiscount && incoming && incoming !== currentAppliedCode) {
			this.showToast('Atención', `Ya tienes aplicado el voucher "${currentAppliedCode}". Elimínalo antes de probar otro.`, 'warning');
			return;
		}
		if (this.appliedDiscount && incoming === currentAppliedCode) {
			this.showToast('Info', `El voucher "${incoming}" ya está aplicado.`, 'info');
			return;
		}
		if (!incoming) {
			this.appliedDiscount = null;
			this.recalculateTotals();
			this.showToast('Info', 'No hay código para aplicar.', 'info');
			return;
		}

		const email = (this.userInfo?.email || '').trim().toLowerCase();
		if (!email) {
			this.showToast('Error', 'Introduce tu correo electrónico antes de aplicar el voucher.', 'error');
			return;
		}
		const baseAmount = this.subtotal;

		validatePromoCode({ promoCode: incoming, baseAmount, email })
			.then(result => {
				if (result.isValid) {
					this.appliedDiscount = { type: result.discountType, value: result.discountValue };
					this.showToast('Éxito', result.message, 'success');
				} else {
					this.appliedDiscount = null;
					this.promoCode = '';
					this.showToast('Voucher no aplicable', result.message, 'warning');
				}
				this.recalculateTotals();
			})
			.catch(error => {
				this.appliedDiscount = null;
				this.recalculateTotals();
				const msg = (error && error.body && error.body.message) || error?.message || 'Error inesperado validando el voucher.';
				this.showToast('Error', msg, 'error');
			});
	}
	// ---- Pago RedSys ----
	handleFinalSubmit() {
		if (!this.isFormValid()) return;
		if (this._submitting) return;

		// Mantén totales actualizados
		this.recalculateTotals();

		// Persistencia local (opcional)
		localStorage.setItem('cartItems', JSON.stringify(this.cartItems));
		localStorage.setItem('userInfo', JSON.stringify(this.userInfo));

		const wrapper = this.createRequestWrapper();

		createOrderAndGetBridgeParams({ wrapper })//createOrderAndGetRedsysParams({ wrapper })
			.then((params) => {
				if (!params || !params.redsysUrl) {
					throw new Error('Parámetros de RedSys vacíos o incompletos.');
				}

				if (params.recoveryToken) {
					localStorage.setItem('recoveryToken', params.recoveryToken);
				}

				this.redsysParams = params;

				// (Logs opcionales para diagnóstico)
				try {
					// eslint-disable-next-line no-console
					console.log('Params de RedSys (Apex): ', params);
				} catch (_e) {}

				// Enviar al TPV
				/*requestAnimationFrame(() => {
					setTimeout(() => this.submitToRedsys(params), 0);
					});
				})
				.catch((error) => {
					this._submitting = false;
					const msg =
					(error && error.body && error.body.message) ||
					(error && error.message) ||
					'No se pudo iniciar el proceso de pago.';
					this.showToast('Error', msg, 'error');
				});*/

				requestAnimationFrame(() => {
					setTimeout(() => this.submitToBridge(params), 0);
					});
				})
				.catch((error) => {
					this._submitting = false;
					const msg =
					(error && error.body && error.body.message) ||
					(error && error.message) ||
					'No se pudo iniciar el proceso de pago.';
					this.showToast('Error', msg, 'error');
				});
	}
	// --- Envio de Formulario de pago a RedSys ---
	async submitToRedsys(params) {
		if (this._submitting) return;
		this._submitting = true;

		try {
			// Documento top (fuera del shadow)
			const doc = (window.top && window.top.document) ? window.top.document : document;
			const host = (doc && doc.body) ? doc.body : null;
			if (!host) {
				this._submitting = false;
				this.showToast('Error', 'No se encontró <body> para crear el formulario de pago.', 'error');
				return;
			}

			// Construcción del form POST (x-www-form-urlencoded)
			const form = doc.createElement('form');
			form.action = params.redsysUrl;              // p.ej. https://sis-t.redsys.es:25443/sis/realizarPago
			form.method = 'POST';
			form.target = '_self';
			form.style.display = 'none';
			form.setAttribute('accept-charset', 'UTF-8');

			const addHidden = (name, value) => {
				const input = doc.createElement('input');
				input.type = 'hidden';
				input.name = name;                         // Nombres EXACTOS
				input.value = (value != null) ? String(value) : '';
				form.appendChild(input);
			};

			// ⚠️ Enviar tal cual lo entregó el servidor (Apex)
			addHidden('Ds_SignatureVersion', params.dsSignatureVersion); // 'HMAC_SHA512_V2'
			addHidden('Ds_MerchantParameters', params.dsMerchantParameters); // Base64URL sin '='
			addHidden('Ds_Signature', params.dsSignature); // Base64URL sin '='

			host.appendChild(form);

			// Logs finales (opcionales)
			try {
				// eslint-disable-next-line no-console
				console.log('--- POST que va a RedSys ---');
				// eslint-disable-next-line no-console
				[...form.elements].forEach(i => console.log(i.name, '=', i.value));
			} catch (_e) {}

			// Submit
			setTimeout(() => {
				try {
					form.submit();
				} catch (err) {
					this._submitting = false;
					this.showToast('Error', 'No se pudo enviar el formulario a RedSys: ' + (err && err.message ? err.message : err), 'error');
				}
			}, 0);

		} catch (e) {
			this._submitting = false;
			this.showToast('Error', 'No se pudo redirigir a la pasarela de pago: ' + (e && e.message ? e.message : e), 'error');
		}
	}
	// ---- Totales ----
	recalculateTotals() {
		this.subtotal = this.cartItems.reduce((total, item) => total + (item.price * item.quantity), 0);

		if (this.appliedDiscount && this.appliedDiscount.value > 0) {
			if (this.appliedDiscount.type === 'PERCENTAGE') {
				this.discountAmount = (this.subtotal * this.appliedDiscount.value) / 100;
			} else if (this.appliedDiscount.type === 'FIXED') {
				this.discountAmount = this.appliedDiscount.value;
			}
		} else {
			this.discountAmount = 0;
		}

		const baseImponible = Math.max(0, this.subtotal - this.discountAmount);
		this.taxAmount = (baseImponible * this.vatRate) / 100;
		this.finalTotal = baseImponible + this.taxAmount;
	}
	// ---- Validaciones ----
	isFormValid() {
		if (this.cartItems.length === 0) {
			this.showToast('Error', 'Tu cesta está vacía.', 'error');
			return false;
		}
		const requiredFields = {
			name: 'Nombre Completo',
			email: 'Correo Electrónico',
			billingAddress: 'Dirección de Facturación',
			postalCode: 'Código Postal',
			dni: 'DNI / NIF'
		};
		for (const field in requiredFields) {
			if (!this.userInfo[field]) {
				this.showToast('Error', `Por favor, completa el campo: ${requiredFields[field]}.`, 'error');
				return false;
			}
		}
		const email = (this.userInfo.email || '').toLowerCase();
		const allowedEmails = ['victoria.lozano@globant.com'];
		const allowedDomain = '@laliga.es';
		if (!email.endsWith(allowedDomain) && !allowedEmails.includes(email)) {
			this.showToast('Error', 'El correo electrónico no es válido.', 'error');
			return false;
		}
		return true;
	}
	// ---- Wrapper para Apex ----
	createRequestWrapper() {
		return {
			nombre: this.userInfo.name,
			email: this.userInfo.email,
			opcionEnvio: this.userInfo.deliveryOption,
			billingAddress: this.userInfo.billingAddress,
			postalCode: this.userInfo.postalCode,
			dni: this.userInfo.dni,
			promoCode: this.appliedDiscount ? this.promoCode : null,
			siteUrl: window.location.origin,
			items: this.cartItems.map(item => ({
				id: item.id,
				quantity: item.quantity,
				price: item.price
			})),
			taxAmount: this.taxAmount,
			discountAmount: this.discountAmount,
			finalTotal: this.finalTotal
		};
	}
	// ---- Utilidad ----
	showToast(title, message, variant) {
		this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
	}
	// ---- Llama a Bridge de PHP ----
	async submitToBridge(params) {
		if (this._submitting) return;
		this._submitting = true;

		try {

			const doc = window.top.document;
			const host = doc && doc.body ? doc.body : null;
			if (!host) {
				this._submitting = false;
				this.showToast('Error', 'No se encontró <body> para crear el formulario de pago.', 'error');
				return;
			}
			// Validación mínima
			const bridgeUrl = params.bridgeUrl;
			if (!bridgeUrl || !/^https?:\/\//i.test(bridgeUrl)) {
				this._submitting = false;
				this.showToast('Error', 'URL del Bridge inválida.', 'error');
				return;
			}

			const form = doc.createElement('form');
			form.action = bridgeUrl;              // ⬅️ tu bridge_redsys.php (p.ej. https://tu-dominio/bridge_redsys.php)
			form.method = 'POST';
			form.target = '_self';
			form.style.display = 'none';
			form.setAttribute('accept-charset', 'UTF-8');

			const addHidden = (name, value) => {
				const input = doc.createElement('input');
				input.type = 'hidden';
				input.name = name;
				input.value = value != null ? String(value) : '';
				form.appendChild(input);
			};

			// ⬇️ Campos EXACTOS que espera el bridge
			addHidden('DS_MERCHANT_AMOUNT',          params.DS_MERCHANT_AMOUNT);
			addHidden('DS_MERCHANT_ORDER',           params.DS_MERCHANT_ORDER);
			addHidden('DS_MERCHANT_MERCHANTCODE',    params.DS_MERCHANT_MERCHANTCODE);
			addHidden('DS_MERCHANT_CURRENCY',        params.DS_MERCHANT_CURRENCY);
			addHidden('DS_MERCHANT_TRANSACTIONTYPE', params.DS_MERCHANT_TRANSACTIONTYPE);
			addHidden('DS_MERCHANT_TERMINAL',        params.DS_MERCHANT_TERMINAL);
			addHidden('DS_MERCHANT_MERCHANTURL',     params.DS_MERCHANT_MERCHANTURL);
			addHidden('DS_MERCHANT_URLOK',           params.DS_MERCHANT_URLOK);
			addHidden('DS_MERCHANT_URLKO',           params.DS_MERCHANT_URLKO);

			host.appendChild(form);

			try {
				console.log('--- POST que va al Bridge ---');
				[...form.elements].forEach(i => console.log(i.name, '=', i.value));
			} catch (e) {
				console.warn('No se pudo loguear el formulario antes del submit:', e);
			}

			setTimeout(() => {
				try { 
					form.submit(); 
				} catch (err) {
					this._submitting = false;
					this.showToast('Error', 'No se pudo enviar el formulario al Bridge: ' + (err?.message || err), 'error');
				}
			}, 0);

		} catch (e) {
			this._submitting = false;
			this.showToast('Error', 'No se pudo redirigir al Bridge: ' + (e?.message || e), 'error');
		}
	}
}