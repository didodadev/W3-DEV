<!---
    File: WEX\dataservices\cfc\control_watalogyCategories.cfc
    Author: Workcube-Emine yılmaz
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis
    get_watalogyCategories Wex Control
--->
<cfcomponent extends="dataservices_functions">
    <cfset dsn = application.systemParam.systemParam().dsn>    
    <cfset dsn1 = application.systemParam.systemParam().dsn&"_product">
    <!--- Watalogy Categori Wex Control--->
    <cffunction  name="control_watalogyCategories" access="remote"  returntype="string" returnFormat="json">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date"  default="">
        <cftry>
            <cfquery name="get_watalogyCategories" datasource="#dsn1#">
                SELECT 
                    *
                FROM
                    WATALOGY_GOOGLE_PRODUCT_CAT
            </cfquery>

            <cfset this.initialize(   
                type: "add", 
                tableName: "WATALOGY_GOOGLE_PRODUCT_CAT",
                whereColumn: "GOOGLE_PRODUCT_CAT_ID", 
                identityColumn : "WATALOGY_PRODUCT_CAT_ID", 
                whereColumnParamtype: "integer"
            )/>

            <cfset this.returnResult( 
                status: true, 
                dataservices_name: 'watalogyCategories', 
                message: "success", 
                errorMessage: "",
                data: get_watalogyCategories
            ) />
        <cfcatch type="any">
            <cfset this.returnResult( 
                status: false, 
                dataservices_name: 'watalogyCategories', 
                message: "", 
                errorMessage: cfcatch
            ) />
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>