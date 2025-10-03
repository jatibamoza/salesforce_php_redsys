import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
//import CANALES_DEPORTIVOS from '@salesforce/resourceUrl/Canales_Deportivos';
import FAN_RESOURCES from '@salesforce/resourceUrl/FAN_STR001_All';

import getDeportesFavoritos from '@salesforce/apex/FAN_RecuperarDeportes.getDeportesFavoritos';

const accfields = [	ACCOUNT_NAME];

export default class Fan_LWC003_accountDeportesInferidos extends LightningElement {
    @api recordId;	
	@api object;
	@api deporte1;
	@api deporte2;
	@api deporte3;
	@api deporte4;
	@track url;
	@track cuenta;
	@track canalAtletismo;
	@track canaleSports;
	@track canalFutbol;
	@track canalKarate;
	@track outDeportes;

	@wire(getRecord, { recordId: '$recordId', fields: accfields }) cuenta;
	//@wire(getDeportesFavoritos,{idCuenta:'$recordId'}) deportesFavoritos;

	get nombre() {
		return getFieldValue(this.cuenta.data, ACCOUNT_NAME);
	}

	renderedCallback() {
		if(this.hasRendered) return;
		console.log('||RAO. Invocando renderedCallback');
		this.initIcons();
		this.hasRendered = true;
	}

	initIcons()
	{
		//var deportesFavoritos;
		getDeportesFavoritos({idCuenta:this.recordId, Campo:"Inferidos"})
			.then((result) => {
				console.log('||RAO. result: ' + JSON.stringify(result));
				if (result.deporte1.length > 0){
					let aux1 = result.deporte1.split(";")
					this.deporte1 = aux1[0];
					this.canal1 =FAN_RESOURCES +'/images' + aux1[1];
					console.log('|| URL' + this.canal1);
				}
				if (result.deporte2.length > 0){
					let aux2 = result.deporte2.split(";")
					this.deporte2 = aux2[0];
					this.canal2 =FAN_RESOURCES + '/images' + aux2[1];
				}
				if (result.deporte3.length > 0){
					let aux3 = result.deporte3.split(";")
					this.deporte3 = aux3[0];
					this.canal3 =FAN_RESOURCES + '/images' + aux3[1];
				}
				if (result.deporte4.length > 0){
					let aux4 = result.deporte4.split(";")
					this.deporte4 = aux4[0];
					this.canal4 =FAN_RESOURCES + '/images' + aux4[1];
				}
            })
			.catch((error) => {
                console.log('||RAO. error: ' + JSON.stringify(error));
            });
			
		
	
	}

}