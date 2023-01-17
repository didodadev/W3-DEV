<cfcomponent>
    <cfset dsn = dsn_alias = application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cfset dsn1 = dsn1_alias = "#dsn#_product">
    <cffunction name="getProductsCount" access="remote" returntype="string" returnFormat="json">
        <cfargument name="brand_id" default="">
        <cfargument name="cat" default="">
        <cfargument name="category_name" default="">
        <cfargument name="company_id" default="">
        <cfargument name="company" default="">
        <cfset result = StructNew()>    
        <cftry>   
            <cfscript>
                get_product_list_action = createObject("component", "V16.product.cfc.get_product");
                get_product_list_action.dsn3 = dsn3;
                get_product_list_action.dsn1 = dsn1;
                get_product_list_action.dsn1_alias = dsn1_alias;
                get_product_list_action.dsn_alias = dsn_alias;            
                get_product = get_product_list_action.get_product2_
                (
                    brand_id : '#iif(isdefined("arguments.brand_id"),"arguments.brand_id",DE(""))#',
                    brand_name : '#iif(isdefined("arguments.brand_name"),"arguments.brand_name",DE(""))#',
                    cat : '#iif(isdefined("arguments.cat"),"arguments.cat",DE(""))#',
                    category_name : '#iif(isdefined("arguments.category_name"),"arguments.category_name",DE(""))#',
                    company_id : '#iif(isdefined("arguments.company_id"),"arguments.company_id",DE(""))#',
                    company : '#iif(isdefined("arguments.company"),"arguments.company",DE(""))#',
                    product_status : 1,
                    is_promotion : 1,
                    product_id: '#iif(isdefined("arguments.product_id"),"arguments.product_id",DE(""))#',
                    product_name: '#iif(isdefined("arguments.product_name"),"arguments.product_name",DE(""))#'
                );
            </cfscript>
            <cfquery name="total_product" dbtype="query">
                SELECT COUNT(PRODUCT_ID) PRODUCT_COUNT FROM get_product
            </cfquery>
            <cfquery name="total_supplier" dbtype="query">
                SELECT COUNT(DISTINCT COMPANY_ID) SUPPLIER_COUNT FROM get_product
            </cfquery>
            <cfquery name="total_brand" dbtype="query">
                SELECT COUNT(DISTINCT BRAND_ID) BRAND_COUNT FROM get_product
            </cfquery>
            <cfquery name="total_cat" dbtype="query">
                SELECT COUNT(DISTINCT PRODUCT_CODE) PRODUCTCAT_COUNT FROM get_product
            </cfquery>
            <cfset result.status = true>
            <cfset result.success_message = "Ürün sayımı yapıldı...">
            <cfset result.identity = len(total_product.PRODUCT_COUNT) ? total_product.PRODUCT_COUNT : 0>
            <cfset result.supplier_count = len(total_supplier.SUPPLIER_COUNT) ? total_supplier.SUPPLIER_COUNT : 0>
            <cfset result.productcat_count = len(total_cat.PRODUCTCAT_COUNT) ? total_cat.PRODUCTCAT_COUNT : 0>
            <cfset result.brand_count = len(total_brand.BRAND_COUNT) ? total_brand.BRAND_COUNT : 0>
            
            <cfset result.prod_id_list = valuelist(get_product.product_id,',')>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
                <cfdump var ="#result.error#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>