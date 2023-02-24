public with sharing class ProductController {
    
    @AuraEnabled(cacheable=true)
    public static Object getProducts(string searchKey){
        
        string whereClause = '';
        string key = '';

        try {
            if(searchKey != null){
                if(!string.isEmpty(searchKey)){
                    key = '%' + searchKey + '%';
                    whereClause = 'WHERE Name LIKE :key';
                }

            }

            Object[] products = Database.query(
                'SELECT Id, Name, MSRP__c, Picture_URL__c FROM Product2 ' + 
                whereClause +
                '  WITH SECURITY_ENFORCED ' +
                ' ORDER BY Name'
            );
            return products;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}