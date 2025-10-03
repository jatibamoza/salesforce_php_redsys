@isTest 
private class FAN_WhatsAppOperationTest {

	@isTest
	private static void testName() {

	/*
		// CREAMOS EL CANAL DE MENSAJERÍA WHATSAPP ASOCIADO A LA COLA Chat
		MessagingChannel   canalMensajeria = new MessagingChannel();

		canalMensajeria.ConsentType='ImplicitOptIn';
		canalMensajeria.DeveloperName='WhatsApp_ES_whatsapp_34618983080';
		canalMensajeria.InitialResponse='Gracias por ponerse en contacto con LaLiga. En breves momentos uno de nuestros agentes le responderá.';
		canalMensajeria.IsActive=true;
		canalMensajeria.IsoCountryCode='ES';
		canalMensajeria.IsRequireDoubleOptIn=false;
		canalMensajeria.IsRestrictedToBusinessHours=false;
		canalMensajeria.IsUserMatchByExternalIdOnly=false;
		canalMensajeria.Language='en_US';
		canalMensajeria.MasterLabel='Whatsapp-+34618983080';
		canalMensajeria.MessageType='WhatsApp';
		canalMensajeria.MessagingPlatformKey='whatsapp:+34618983080';
		canalMensajeria.OptInResponse='Thanks for opting in and allowing us to send you messages.';
		canalMensajeria.TargetQueueId='00G0E000005W4UOUA0';

		canalMensajeria.OptOutResponse='--';
		canalMensajeria.RoutingType='OmniQueue';

		insert canalMensajeria;
		*/
		//CREAMOS EL USUARIOS DE MENSAJERÍA 

		List <MessagingChannel> canalMensajeria = [select Id from MessagingChannel where MessageType='WhatsApp'];
		
		String canalMensajeriaId = canalMensajeria.get(0).Id;

		MessagingEndUser  usuarioMensajeria = new MessagingEndUser();

		usuarioMensajeria.HasInitialResponseSent = false;
		usuarioMensajeria.IsoCountryCode = 'ES';
		usuarioMensajeria.MessageType = 'WhatsApp';
		usuarioMensajeria.MessagingConsentStatus = 'ImplicitlyOptedIn';
		usuarioMensajeria.MessagingPlatformKey = 'whatsapp:+34699887766';
		usuarioMensajeria.Name = 'whatsapp:+34699887766';
		usuarioMensajeria.MessagingChannelId = canalMensajeriaId;

		insert usuarioMensajeria;

		Test.startTest();
		List<MessagingEndUser> usuarios = new List<MessagingEndUser>();
		List<Account> cuentas = new List<Account>();
		usuarios.add(usuarioMensajeria);

		cuentas = FAN_WhatsAppOperation.buscarCuenta(usuarios);

	//	Test.stopTest();


		delete usuarioMensajeria;

		usuarioMensajeria = new MessagingEndUser();

		usuarioMensajeria.HasInitialResponseSent = false;
		usuarioMensajeria.IsoCountryCode = 'ES';
		usuarioMensajeria.MessageType = 'WhatsApp';
		usuarioMensajeria.MessagingConsentStatus = 'ImplicitlyOptedIn';
		usuarioMensajeria.MessagingPlatformKey = 'whatsapp:+1699887766';
		usuarioMensajeria.Name = 'whatsapp:+1699887766';
		usuarioMensajeria.MessagingChannelId = canalMensajeriaId;

		insert usuarioMensajeria;

//		Test.startTest();
		usuarios = new List<MessagingEndUser>();
		cuentas = new List<Account>();
		usuarios.add(usuarioMensajeria);

		cuentas = FAN_WhatsAppOperation.buscarCuenta(usuarios);

		Test.stopTest();
	}
}