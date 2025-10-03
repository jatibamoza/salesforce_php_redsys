import { LightningElement, api, track } from 'lwc';

export default class Stck_formularioEnvio extends LightningElement {
  // Opciones de entrega (actualizado)
  deliveryOptions = [
    { label: 'Oficina Torrelaguna', value: 'Oficina Torrelaguna' },
    { label: 'Envío a domicilio (MRW)', value: 'MRW' }
  ];

  // Provincias ES para facturación (facturación puede ser cualquier provincia)
  get billingProvinceOptions() {
    const all = [
      'Álava','Albacete','Alicante','Almería','Asturias','Ávila','Badajoz','Barcelona','Burgos',
      'Cáceres','Cádiz','Cantabria','Castellón','Ciudad Real','Córdoba','Cuenca','Girona','Granada',
      'Guadalajara','Gipuzkoa','Huelva','Huesca','Jaén','La Coruña','La Rioja','León','Lugo','Madrid',
      'Málaga','Murcia','Navarra','Ourense','Palencia','Pontevedra','Salamanca','Segovia','Sevilla',
      'Soria','Tarragona','Teruel','Toledo','Valencia','Valladolid','Bizkaia','Zamora','Zaragoza',
      'Illes Balears','Las Palmas','Santa Cruz de Tenerife','Ceuta','Melilla'
    ];
    return all.map(v => ({ label: v, value: v }));
  }

  // Estado del formulario padre
  @track formData = {
    name: null,
    email: null,
    // Facturación estructurada
    billingStreetName: null,
    billingStreetNumber: null,
    billingAddressLine2: null,
    billingPostalCode: null,
    billingCity: null,
    billingProvince: null,
    // Identificación fiscal
    dni: null
  };

  @track deliverySelection = 'Oficina Torrelaguna';
  @track selectedMRW = false;

  handleFieldChange = (event) => {
    const { name, value } = event.target;
    this.formData = { ...this.formData, [name]: value };

    // Opcional: notificar a contenedor superior
    this.dispatchEvent(new CustomEvent('formupdate', {
      detail: { formData: { [name]: value } }
    }));
  };

  handleDeliveryChange = (event) => {
    this.deliverySelection = event.detail.value;
    this.selectedMRW = (this.deliverySelection === 'MRW');
  };

  // ===== NUEVO: validación integral (solicitante + facturación + MRW si aplica) =====
  @api
  async validateAll() {
    const errors = [];

    // 1) Hacer que los inputs muestren validación en UI
    const inputs = this.template.querySelectorAll('lightning-input, lightning-textarea, lightning-combobox, lightning-radio-group');
    inputs.forEach(c => c.reportValidity());

    // 2) Validación "nativa" de todos los controles visibles
    const nativeValid = [...inputs].every(c => c.checkValidity());

    // 3) Reglas adicionales (formato CP facturación)
    const cp = this.formData.billingPostalCode || '';
    if (cp && !/^\d{5}$/.test(cp)) {
      errors.push('El Código Postal de facturación debe tener 5 dígitos.');
    }

    // 4) Si es MRW, pedimos validación al hijo
    if (this.selectedMRW) {
      const child = this.template.querySelector('c-stck-shipment-form');
      if (!child) {
        errors.push('El formulario de envío MRW no está disponible.');
      } else {
        const ok = await child.validateForm();
        if (!ok) errors.push('Revisa los datos de envío MRW.');
      }
    }

    return { valid: nativeValid && errors.length === 0, errors };
  }

  // Devuelve todo el formulario combinado (por si lo necesitas)
  @api
  async getAllFormData() {
    const result = {
      applicant: { name: this.formData.name, email: this.formData.email, dni: this.formData.dni },
      billingAddress: {
        streetName: this.formData.billingStreetName,
        streetNumber: this.formData.billingStreetNumber,
        addressLine2: this.formData.billingAddressLine2,
        postalCode: this.formData.billingPostalCode,
        city: this.formData.billingCity,
        province: this.formData.billingProvince
      },
      deliveryOption: this.deliverySelection
    };
    if (this.selectedMRW) {
      const child = this.template.querySelector('c-stck-shipment-form');
      result.shippingMRW = child && typeof child.getFormData === 'function' ? await child.getFormData() : null;
    }
    return result;
  }

  // Reset opcional
  @api
  resetForm() {
    this.template.querySelectorAll('lightning-input, lightning-textarea, lightning-combobox')
      .forEach(input => { if (input.type !== 'radio') input.value = null; });

    this.formData = {
      name: null, email: null,
      billingStreetName: null, billingStreetNumber: null, billingAddressLine2: null,
      billingPostalCode: null, billingCity: null, billingProvince: null,
      dni: null
    };
    this.deliverySelection = 'Oficina Torrelaguna';
    this.selectedMRW = false;

    const child = this.template.querySelector('c-stck-shipment-form');
    if (child && typeof child.resetChildForm === 'function') {
      try { child.resetChildForm(); } catch (e) {}
    }
  }
}