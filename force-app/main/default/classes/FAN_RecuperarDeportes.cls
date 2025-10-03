public class FAN_RecuperarDeportes  {

	@AuraEnabled(cacheable=true)
	public static deportesWrapper getDeportesFavoritos(String idCuenta, String Campo){
		String[] deportesFavoritos;
		String FieldValue = '';
		if(Campo == 'Favoritos'){
			List <Contact> contacto = [SELECT Id, Deportes_favoritos_declarados__c FROM Contact WHERE AccountId = :idCuenta LIMIT 1];
			deportesFavoritos = contacto.get(0).Deportes_favoritos_declarados__c.split(';');
		}
		else{ //Inferidos
			List <Contact> contacto = [SELECT Id, FAN_DeporteFavoritoInferidos__c FROM Contact WHERE AccountId = :idCuenta];
			deportesFavoritos = contacto.get(0).FAN_DeporteFavoritoInferidos__c.split(';');
		}
		
		List<String> deportesAuxLst = new List<String>(); //Lista temporal
		Integer deportesCant = deportesFavoritos.size();
		Integer iIndex = deportesCant > 4 ? 4 : deportesCant; //Si hay más de cuatro deportes, cogemos 4, si no, los que haya

		for(Integer j = 0; j < iIndex; j++){
			String sDeporte = deportesFavoritos[j];
			String sOut;
			//Insertamos un par de valores donde el primero corresponde al deporte y el segundo al nombre de la imagen dentro del recurso estático "Canales"
			switch on sDeporte{
				when 'Athletics' {	
					sOut = sDeporte + ';/Athletics.png';
				}	
				when 'Badminton' {		// when block 2
					sOut = sDeporte + ';/Badminton.png';
				}
				when 'Boxing' {		// when block 3
					sOut = sDeporte + ';/Boxing.png';
				}
				when 'Cycling', 'Cycling BMX Freestyle', 'Cycling BMX Racing', 'Cycling Mountain Bike', 
						'Cycling Road', 'Cycling Track'{
					sOut = sDeporte + ';/Cycling.png';
				}
				when 'eSports' {		// when block 1
					sOut = sDeporte + ';/eSports.png';
				}	
				when 'Football' {		// when block 2
					sOut = sDeporte + ';/Football.png';
				}
				when 'Gymnastics' {		// when block 3
					sOut = sDeporte + ';/Gymnastics.png';
				}
				when 'Hockey'{
					sOut = sDeporte + ';/Hockey.png';
				}				
				when 'Karate' {		// when block 1
					sOut = sDeporte + ';/Karate.png';
				}	
				when 'Motor cycling', 'Motor racing', 'Nautical Motorcycle' {		// when block 2
					sOut = sDeporte + ';/Motor.png';
				}
				when 'Paddle tennis' {		// when block 3
					sOut = sDeporte + ';/Padel.png';
				}
				when 'Petanque'{
					sOut = sDeporte + ';/Petanque.png';
				}	
				when 'Sport Dance' {		// when block 1
					sOut = sDeporte + ';/SportDance.png';
				}	
				when 'Swimming' {		// when block 2
					sOut = sDeporte + ';/Swimming.png';
				}
				when 'Triathlon' {		// when block 3
					sOut = sDeporte + ';/Triathlon.png';
				}
				when 'WaterPolo'{
					sOut = sDeporte + ';/WaterPolo.png';
				}
				when else { //Others
					sOut = sDeporte + ';/Others.png';
				}
			} //End Switch
			deportesAuxLst.add(sOut);
		} //End For
		deportesWrapper deportesWrapper = new deportesWrapper();
		//Si no hay valor lo mandamos vacío para que no falle en el JS
		deportesWrapper.deporte1 = deportesCant > 0 ? deportesAuxLst.get(0) : '';
		deportesWrapper.deporte2 = deportesCant > 1 ? deportesAuxLst.get(1) : '';
		deportesWrapper.deporte3 = deportesCant > 2 ? deportesAuxLst.get(2) : '';
		deportesWrapper.deporte4 = deportesCant > 3 ? deportesAuxLst.get(3) : '';
		
		System.debug('##RAO. deportesWrapper: ' + deportesWrapper);
		return deportesWrapper;
		
	}
/*
	public static deportesWrapper getDeportesInferidos(String idCuenta){
		List <Contact> contacto = [SELECT Id, Deporte_favorito_inferidos__c FROM Contact WHERE AccountId = :idCuenta];

		String[] deportesFavoritos = contacto.get(0).Deporte_favorito_inferidos__c.split(';');
		
		Integer deportesCant = deportesFavoritos.size();

		deportesWrapper deportesWrapper = new deportesWrapper();

		deportesWrapper.deporte1 = deportesCant > 0 ? deportesFavoritos[0] : null;
		deportesWrapper.deporte2 = deportesCant > 1 ? deportesFavoritos[1] : null;
		deportesWrapper.deporte3 = deportesCant > 2 ? deportesFavoritos[2] : null;
		deportesWrapper.deporte4 = deportesCant > 3 ? deportesFavoritos[3] : null;

		return deportesWrapper;
	}
*/
	public class deportesWrapper {
		 @AuraEnabled public string	deporte1;
		 @AuraEnabled public string	deporte2;
		 @AuraEnabled public string	deporte3;
		 @AuraEnabled public string	deporte4;
	}

}