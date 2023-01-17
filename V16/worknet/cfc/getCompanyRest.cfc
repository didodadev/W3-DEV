component rest = "true" restpath = "getCompany" {

    dsn = 'workcube_devcatalyst';

    remote function getCompany(
        required numeric company_id restargsource = "query"
    )
    httpmethod = "get"
    restpath = "getCompany"
    returntype = "string"
    produces = "application/json" {
        try {
            returnStruct = structNew();
            returnStruct.data = structNew();
            
            companyQuery = new Query();
            companyQuery.setDatasource(dsn);
            companyQuery.addParam(name = "company_id", value = company_id, cfsqltype="cf_sql_numeric");
            companyQuery.setSQL("
            DECLARE @comp_id INT = (:company_id);
            SELECT
            *
            FROM
            COMPANY CMP
            WHERE
            COMPANY_ID = @comp_id
            ");
            companyResult = companyQuery.execute().getResult();
            returnStruct.data.companyList = companyResult;
            
            returnStruct.code = 200;
            returnStruct.status = 'Success';
            returnStruct.description = 'Get Company.';
        
        }
        catch (any e) {
            returnStruct.code = 500;
            returnStruct.status = 'Internal Server Error.';
            returnStruct.description = e.Message;
            returnStruct.data.error = serializeJSON(e);
        }
        finally {
            result = serializeJSON(returnStruct);
            /*if(left(result,2) eq '//')
            result = replace(result,'//','');*/
            return result;
        }
    }
}