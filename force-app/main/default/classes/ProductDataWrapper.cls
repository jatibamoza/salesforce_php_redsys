public class ProductDataWrapper {

    @AuraEnabled
    public String productName {get; set;}

    @AuraEnabled
    public String productDescription {get; set;}
    
    @AuraEnabled
    public String productCategory {get; set;}

    @AuraEnabled
    public Decimal productPrice {get; set;}

    @AuraEnabled
    public String productImageUrl {get; set;}

}