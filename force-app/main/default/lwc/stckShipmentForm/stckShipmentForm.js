import { LightningElement, track, api } from 'lwc';

const EXCLUDED_PREFIXES = ['07', '35', '38', '51', '52'];
const EXCLUDED_PROVINCES = new Set(['Illes Balears','Las Palmas','Santa Cruz de Tenerife','Ceuta','Melilla']);

export default class StckShipmentForm extends LightningElement {
  // ===== Props del padre =====
  @api recipientName = '';
  @api recipientEmail = '';

  // Dirección de facturación (para copiar)
  @api billingStreetName;
  @api billingStreetNumber;
  @api billingAddressLine2;
  @api billingPostalCode;
  @api billingCity;
  @api billingProvince;

  // ===== Estado del formulario (envío) =====
  recipientCountry = 'ES'; // fijo
  @track recipientPhone = '';
  @track streetName = '';
  @track streetNumber = '';
  @track addressLine2 = '';
  @track recipientZipCode = '';
  @track recipientCity = '';
  @track recipientState = ''; // provincia
  @track additionalNotes = '';

  @track parcels = 1;
  @track weightKg = 1;
  @track timeWindow = ''; // '1' (mañana) / '2' (tarde)

  // UI
  @track postalError = '';
  @track formError = '';
  infoNote = 'Los datos se guardarán en la solicitud; solo se integrará con MRW tras el pago.';
  @track copyFromBilling = false;

  // ===== Listas =====
  get stateOptions() {
    // Solo provincias peninsulares para ENVÍO
    const list = [
      'Álava','Albacete','Alicante','Almería','Asturias','Ávila','Badajoz','Barcelona','Burgos',
      'Cáceres','Cádiz','Cantabria','Castellón','Ciudad Real','Córdoba','Cuenca','Girona','Granada',
      'Guadalajara','Gipuzkoa','Huelva','Huesca','Jaén','La Coruña','La Rioja','León','Lugo','Madrid',
      'Málaga','Murcia','Navarra','Ourense','Palencia','Pontevedra','Salamanca','Segovia','Sevilla',
      'Soria','Tarragona','Teruel','Toledo','Valencia','Valladolid','Bizkaia','Zamora','Zaragoza'
    ];
    return list.map(v => ({ label: v, value: v }));
  }

  get timeWindowOptions() {
    return [
      { label: 'Mañana (08:00–14:00)', value: '1' },
      { label: 'Tarde (16:00–19:00)', value: '2' }
    ];
  }

  // ===== Handlers =====
  handleInputChange = (event) => {
    const { name, value } = event.target;
    this[name] = value;
    this.formError = '';
    this.dispatchEvent(new CustomEvent('formchange', { detail: { field: name, value } }));
  };

  handlePostalChange = (event) => {
    this.handleInputChange(event);
    const v = this.recipientZipCode || '';
    this.postalError = '';
    if (v.length === 5 && /^\d{5}$/.test(v)) {
      const pref = v.substring(0,2);
      if (EXCLUDED_PREFIXES.includes(pref)) {
        this.postalError = 'Zona excluida: Baleares, Canarias, Ceuta o Melilla.';
      }
    } else if (v) {
      this.postalError = 'Debe tener 5 dígitos.';
    }
  };

  handleProvinceChange = (event) => {
    this.handleInputChange(event);
    if (EXCLUDED_PROVINCES.has(this.recipientState)) {
      this.formError = 'Provincia excluida: solo península.';
    } else {
      this.formError = '';
    }
  };

  handleCopyToggle = (event) => {
    this.copyFromBilling = event.target.checked;
    if (this.copyFromBilling) {
      // Copiar valores desde facturación
      this.streetName = this.billingStreetName || '';
      this.streetNumber = this.billingStreetNumber || '';
      this.addressLine2 = this.billingAddressLine2 || '';
      this.recipientZipCode = this.billingPostalCode || '';
      this.recipientCity = this.billingCity || '';
      this.recipientState = this.billingProvince || '';
      // Disparar validaciones derivadas (CP/provincia)
      if (this.recipientZipCode) {
        this.handlePostalChange({ target: { name: 'recipientZipCode', value: this.recipientZipCode } });
      }
      if (this.recipientState) {
        this.handleProvinceChange({ target: { name: 'recipientState', value: this.recipientState } });
      }
    }
  };

  // ===== API pública =====
  @api
  validateForm() {
    const allValid = [...this.template.querySelectorAll('lightning-input, lightning-combobox, lightning-textarea')]
      .reduce((ok, c) => { c.reportValidity(); return ok && c.checkValidity(); }, true);
    if (!allValid) return false;

    if (this.postalError) return false;
    if (EXCLUDED_PROVINCES.has(this.recipientState)) return false;
    if (!(this.timeWindow === '1' || this.timeWindow === '2')) return false;

    return true;
  }

  @api
  getFormData() {
    return {
      recipientName: this.recipientName,
      recipientEmail: this.recipientEmail,
      recipientPhone: this.recipientPhone,
      // Dirección envío
      streetName: this.streetName,
      streetNumber: this.streetNumber,
      addressLine2: this.addressLine2,
      recipientZipCode: this.recipientZipCode,
      recipientCity: this.recipientCity,
      recipientState: this.recipientState,
      recipientCountry: this.recipientCountry,
      // Servicio
      serviceCode: '0800',
      timeWindow: this.timeWindow,
      // Bultos
      parcels: this.parcels,
      weightKg: this.weightKg,
      // Notas
      additionalNotes: this.additionalNotes,
      // Info de conveniencia
      copiedFromBilling: this.copyFromBilling
    };
  }

  @api
  resetChildForm() {
    this.recipientPhone = '';
    this.streetName = '';
    this.streetNumber = '';
    this.addressLine2 = '';
    this.recipientZipCode = '';
    this.recipientCity = '';
    this.recipientState = '';
    this.additionalNotes = '';
    this.parcels = 1;
    this.weightKg = 1;
    this.timeWindow = '';
    this.postalError = '';
    this.formError = '';
    this.copyFromBilling = false;
  }
}