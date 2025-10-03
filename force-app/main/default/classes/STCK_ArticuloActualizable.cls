public class STCK_ArticuloActualizable  {

	@AuraEnabled
	@InvocableVariable 
	public Id key; //Map key

	@AuraEnabled
	@InvocableVariable 
	public double value; //Map value

	@AuraEnabled
	@InvocableVariable 
	public Id peticionMaterialId; //Map value
//	public STCK_ArticuloActualizable(){}

}