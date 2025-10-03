import { LightningElement, api, track } from 'lwc';
import redsysBannerUrl from '@salesforce/resourceUrl/redsys_pago_seguro_logo';

export default class Stck_formularioPago extends LightningElement {
  @api totalAmount = 0;
  @api subtotal = 0;
  @api discountAmount = 0;
  @api taxAmount = 0;
  @api vatRate = 0;
  @api redsysParams;

  // >>> necesarios para mostrar pill + botón borrar
  @api isPromoApplied = false;
  @api promoCode = '';

  @track promoInput = '';
  redsysLogoUrl = redsysBannerUrl;

  get isApplyDisabled() {
    return this.isPromoApplied || !this.promoInput;
  }

  handlePromoChange(event) {
    this.promoInput = (event.target.value || '').trim();
  }

  handleApplyPromo() {
    this.dispatchEvent(new CustomEvent('applypromo', {
      detail: { promoCode: this.promoInput }
    }));
  }

  handleClearPromo() {
    this.dispatchEvent(new CustomEvent('clearpromo'));
    this.promoInput = '';
    const input = this.template.querySelector('lightning-input');
    if (input) input.value = null;
  }

  handleSubmit() {
    this.dispatchEvent(new CustomEvent('finalsubmit', {
      detail: { promoCode: this.promoCode } // el aplicado
    }));
  }

  @api resetForm() {
    this.promoInput = '';
    const input = this.template.querySelector('lightning-input');
    if (input) input.value = null;
  }
}