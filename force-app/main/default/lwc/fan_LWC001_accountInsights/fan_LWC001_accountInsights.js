import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import CASE_ACCOUNT from '@salesforce/schema/Case.AccountId';
import OPTY_ACCOUNT from '@salesforce/schema/Opportunity.AccountId';
import ACCOUNT_MINUTOS from '@salesforce/schema/Account.Minutos_consumidos__c';
import ACCOUNT_GASTO_FUTURO from '@salesforce/schema/Account.FAN_GastoFuturoEsperado__c';
import ACCOUNT_CONSUMO_ORDENADOR from '@salesforce/schema/Account.Consumo_Ordenador__c';
import ACCOUNT_CONSUMO_SMART_TV from '@salesforce/schema/Account.Consumo_Smart_TV__c';
import ACCOUNT_CONSUMO_SMART_PHONE from '@salesforce/schema/Account.Consumo_Movil__c';
import ACCOUNT_CONSUMO_TABLETA from '@salesforce/schema/Account.Consumo_Tableta__c';
import FECHA_USO_ORDENADOR from '@salesforce/schema/Account.Fecha_uso_ordenador__c';
import FECHA_USO_SMART_TV from '@salesforce/schema/Account.Fecha_uso_Smart_TV__c';
import FECHA_USO_SMART_PHONE from '@salesforce/schema/Account.Fecha_uso_movil__c';
import FECHA_USO_TABLETA from '@salesforce/schema/Account.Fecha_uso_tableta__c';
import VERSION_APP_ORDENADOR from '@salesforce/schema/Account.Version_App_ordenador__c';
import VERSION_APP_SMART_TV from '@salesforce/schema/Account.Version_App_Smart_TV__c';
import VERSION_APP_SMART_PHONE from '@salesforce/schema/Account.Version_App_movil__c';
import VERSION_APP_TABLETA from '@salesforce/schema/Account.Version_App_tableta__c';

import FAN_RESOURCES from '@salesforce/resourceUrl/FAN_STR001_All';
/*import ACCOUNT_ICONO_SMART_TV from '@salesforce/resourceUrl/smart_tv_icon';
import ACCOUNT_ICONO_SMART_TV_WHITE from '@salesforce/resourceUrl/smart_tv_icon_white';
import ACCOUNT_ICONO_SMART_TV_GREEN from '@salesforce/resourceUrl/smart_tv_icon_green';
import ACCOUNT_ICONO_SMART_TV_GREY from '@salesforce/resourceUrl/smart_tv_icon_grey';
import ACCOUNT_ICONO_ORDENADOR from '@salesforce/resourceUrl/computer_icon';
import ACCOUNT_ICONO_ORDENADOR_WHITE from '@salesforce/resourceUrl/computer_icon_white';
import ACCOUNT_ICONO_ORDENADOR_GREEN from '@salesforce/resourceUrl/computer_icon_green';
import ACCOUNT_ICONO_ORDENADOR_GREY from '@salesforce/resourceUrl/computer_icon_grey';
import ACCOUNT_ICONO_SMARTPHONE from '@salesforce/resourceUrl/smartphone';
import ACCOUNT_ICONO_SMARTPHONE_WHITE from '@salesforce/resourceUrl/smartphone_white';
import ACCOUNT_ICONO_SMARTPHONE_GREEN from '@salesforce/resourceUrl/smartphone_green';
import ACCOUNT_ICONO_SMARTPHONE_GREY from '@salesforce/resourceUrl/smartphone_grey';
import ACCOUNT_ICONO_TABLETA from '@salesforce/resourceUrl/tableta_icon';
import ACCOUNT_ICONO_TABLETA_WHITE from '@salesforce/resourceUrl/tableta_icon_white';
import ACCOUNT_ICONO_TABLETA_GREEN from '@salesforce/resourceUrl/tableta_icon_green';
import ACCOUNT_ICONO_TABLETA_GREY from '@salesforce/resourceUrl/tableta_icon_grey';*/
import TIME_UNIT from '@salesforce/label/c.Minutos';
import CURRENCY from '@salesforce/label/c.Currency';

const accfields = [
	ACCOUNT_NAME, ACCOUNT_MINUTOS, ACCOUNT_GASTO_FUTURO, ACCOUNT_CONSUMO_ORDENADOR, ACCOUNT_CONSUMO_SMART_TV, ACCOUNT_CONSUMO_SMART_PHONE, ACCOUNT_CONSUMO_TABLETA,
	FECHA_USO_ORDENADOR, FECHA_USO_SMART_TV, FECHA_USO_SMART_PHONE, FECHA_USO_TABLETA, VERSION_APP_ORDENADOR, VERSION_APP_SMART_TV, VERSION_APP_SMART_PHONE, VERSION_APP_TABLETA
]

const caseFields = [
	CASE_ACCOUNT
]

const optyFields = [
	OPTY_ACCOUNT
]

export default class Fan_LWC001_accountInsights extends LightningElement {

	account_icono_smart_tv_green = FAN_RESOURCES + '/images/smart_tv_icon_green.png';
	account_icono_smart_tv_grey = FAN_RESOURCES + '/images/smart_tv_icon_grey.png';
	account_icono_ordenador_green = FAN_RESOURCES + '/images/computer_icon_green.png';
	account_icono_ordenador_grey = FAN_RESOURCES + '/images/computer_icon_grey.png';
	account_icono_smartphone_green = FAN_RESOURCES + '/images/smartphone_green.png';
	account_icono_smartphone_grey = FAN_RESOURCES + '/images/smartphone_grey.png';
	account_icono_tableta_green = FAN_RESOURCES + '/images/tableta_icon_green.png';
	account_icono_tableta_grey = FAN_RESOURCES + '/images/tableta_icon_grey.png';

    @api recordId;
	@api object;
	@track label = {TIME_UNIT, CURRENCY};
	@track accId;
	@track casId;
	@track optyId;
	@track iconoSmartTV;
	@track iconoOrdenador;
	@track iconoSmartPhone;
	@track iconoTablet;
	@track cuenta;
    @wire(getRecord, { recordId: '$accId', fields: accfields })

	getAccountRecord({ data, error }) {
        console.log('accountRecord => ', data, error);
        if(data) {
            this.cuenta = data;
            this.initIcons();
        } else if (error) {
            console.error('ERROR => ', JSON.stringify(error));
        }
    }
	@wire(getRecord, { recordId: '$casId', fields: caseFields }) caso;
	@wire(getRecord, { recordId: '$optyId', fields: optyFields }) oportunidad;

	get accountName() {
        return this.cuenta ? this.cuenta.fields.Name.value : null;
	}

	get accountMinutos() {
        return this.cuenta ? this.cuenta.fields.Minutos_consumidos__c.value : null;
	}

	get accountGastofututo() {
        return this.cuenta ? this.cuenta.fields.FAN_GastoFuturoEsperado__c.value : null;
	}

	get accountConsumoSmartTV() {
		return this.cuenta ? this.cuenta.fields.Consumo_Smart_TV__c.value : null;
	}

	get accountConsumoOrdenador() {
		return this.cuenta ? this.cuenta.fields.Consumo_Ordenador__c.value : null;
	}
	
	get accountConsumoSmartPhone() {
		return this.cuenta ? this.cuenta.fields.Consumo_Movil__c.value : null;
	}

	get accountConsumoTableta() {
		return this.cuenta ? this.cuenta.fields.Consumo_Tableta__c.value : null;
	}

	get accountFechaSmartTV() {
		var dt = this.cuenta ? new Date(this.cuenta.fields.Fecha_uso_Smart_TV__c.value) : new Date();
		return dt.getDate() + "/" + (dt.getMonth() + 1) + "/" + dt.getFullYear();
	}

	get accountFechaOrdenador() {
		var dt = this.cuenta ? new Date(this.cuenta.fields.Fecha_uso_ordenador__c.value) : new Date();
		return dt.getDate() + "/" + (dt.getMonth() + 1) + "/" + dt.getFullYear();
	}

	get accountFechaSmartPhone() {
		var dt = this.cuenta ? new Date(this.cuenta.fields.Fecha_uso_movil__c.value) : new Date();
		return dt.getDate() + "/" + (dt.getMonth() + 1) + "/" + dt.getFullYear();
	}

	get accountFechaTableta() {
		var dt = this.cuenta ? new Date(this.cuenta.fields.Fecha_uso_tableta__c.value) : new Date();
		return dt.getDate() + "/" + (dt.getMonth() + 1) + "/" + dt.getFullYear();
	}

	get accountVersionSmartTV() {
		return this.cuenta ? this.cuenta.fields.Version_App_Smart_TV__c.value : null;
	}

	get accountVersionOrdenador() {
		return this.cuenta ? this.cuenta.fields.Version_App_ordenador__c.value : null;
	}

	get accountVersionSmartPhone() {
		return this.cuenta ? this.cuenta.fields.Version_App_movil__c.value : null;
	}

	get accountVersionTableta() {
		return this.cuenta ? this.cuenta.fields.Version_App_tableta__c.value : null;
	}

	get caseAccId() {
		return getFieldValue(this.caso.data, CASE_ACCOUNT);
	}

	get optyAccId() {
		return getFieldValue(this.oportunidad.data, OPTY_ACCOUNT);
	}

	connectedCallback() {
		console.log('-- Fan_LWC001_accountInsights --');
		console.log('this.object = ' + this.object);
		switch(this.object) {
			case 'Account': {
				this.accId = this.recordId;
				break;
			}
			case 'Case': {
				this.casId = this.recordId;
				break;
			}
			case 'Opportunity': {
				this.optyId = this.recordId;
				break;
			}
			default: {
				console.log('Object must be Account or Case');
			}
		}
	}

	renderedCallback() {
		if(this.hasRendered) return;
		console.log('render lwc until wire retrievement');
		console.log('this.object = ' + this.object);
		switch(this.object) {
			case 'Account': {
				if(this.accountName) {
					this.hasRendered = true;
					this.initIcons();
					this.appendCSSoutShadowDom();
				}
				break;
			}
			case 'Case': {
				if(this.caseAccId) {
					this.accId = this.caseAccId;
					if(this.accountName) {
						this.hasRendered = true;
						this.initIcons();
						this.appendCSSoutShadowDom();
					}
				}
				break;
			}
			case 'Opportunity': {
				if(this.optyAccId) {
					this.accId = this.optyAccId;
					if(this.accountName) {
						this.hasRendered = true;
						this.initIcons();
						this.appendCSSoutShadowDom();
					}
				}
				break;
			}
			default: {
				console.log('Object must be Account or Case');
			}
		}
	}

	initIcons() {
		this.iconoSmartTV		= "https://laliga--dev.lightning.force.com";
		this.iconoOrdenador		= "https://laliga--dev.lightning.force.com";
		this.iconoSmartPhone	= "https://laliga--dev.lightning.force.com";
		this.iconoTablet		= "https://laliga--dev.lightning.force.com";
		console.log('render lwc until wire retrievement');
		this.iconoSmartTV		+= this.accountConsumoSmartTV > 0		? this.account_icono_smart_tv_green : this.account_icono_smart_tv_grey;
		this.iconoOrdenador		+= this.accountConsumoOrdenador > 0		? this.account_icono_ordenador_green : this.account_icono_ordenador_grey;
		this.iconoSmartPhone	+= this.accountConsumoSmartPhone > 0	? this.account_icono_smartphone_green : this.account_icono_smartphone_grey;
		this.iconoTablet		+= this.accountConsumoTableta > 0		? this.account_icono_tableta_green : this.account_icono_tableta_grey;

		console.log('this.iconoSmartTV = ' + this.iconoSmartTV);
		console.log('this.iconoOrdenador = ' + this.iconoOrdenador);
		console.log('this.iconoSmartPhone = ' + this.iconoSmartPhone);
		console.log('this.iconoTablet = ' + this.iconoTablet);
	}

	appendCSSoutShadowDom() {
		const style = document.createElement('style');
		style.innerText = 'lightning-card.my-card article header {' +
								'background: rgb(243, 242, 242); padding-bottom: 10px !important; font-weight: bold !important;' +
							'}' +
							'lightning-card.my-card article header div div h2 span {' +
								'font-size: 14px !important;' +
							'}' +
							'lightning-icon.buttonContent lightning-primitive-icon svg {' +
								'fill: rgb(27, 82, 151);' +
							'}';
		this.template.querySelector('.my-card').appendChild(style);
	}
}