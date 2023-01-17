<cfif isDefined('attributes.action_id')>
    <cfset attributes.ship_id = attributes.action_id>
</cfif>
<cfquery name="GET_UPD_PURCHASE" datasource="#dsn2#">
	SELECT 
    	DISPATCH_SHIP_ID, 
        SHIP_METHOD, 
        PROCESS_STAGE, 
        SHIP_DATE, 
        DELIVER_DATE, 
        LOCATION_OUT, 
        DEPARTMENT_OUT, 
        DELIVER_EMP, 
        DEPARTMENT_IN, 
        LOCATION_IN, 
        MONEY, 
        RATE1, 
        RATE2, 
        DISCOUNTTOTAL, 
        GROSSTOTAL, 
        NETTOTAL, 
        TAXTOTAL, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_DATE ,
        PAPER_NO
    FROM 
    	SHIP_INTERNAL 
    WHERE 
    	DISPATCH_SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
</cfquery>
<cfquery name="GET_SHIP" datasource="#DSN2#">
    SELECT SHIP_ID,SHIP_NUMBER FROM SHIP WHERE DISPATCH_SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
</cfquery>
<cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
	SELECT
		SHIP_METHOD_ID,		
		SHIP_METHOD
	FROM
		SHIP_METHOD
	WHERE
    1=1 
    <cfif isDefined('GET_UPD_PURCHASE.SHIP_METHOD') and len(GET_UPD_PURCHASE.SHIP_METHOD)>
	 	AND SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_UPD_PURCHASE.SHIP_METHOD#">
    </cfif>
</cfquery>
<cfquery name="Get_Ship_Row" datasource="#dsn2#">
	SELECT 
		PRODUCT_ID,
        NAME_PRODUCT,
        AMOUNT,
        UNIT,
        PRICE,
        DISCOUNT,
        TAX
	FROM 
        SHIP_INTERNAL_ROW
	WHERE 
        DISPATCH_SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
	ORDER BY
		SHIP_ROW_ID
</cfquery>

<cfif not GET_UPD_PURCHASE.recordcount>
    <cfset hata  = 10>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfoutput query="GET_UPD_PURCHASE">
        <cf_woc_header>
        <cf_woc_elements>
            <cf_wuxi id="ship_internal_number" data="#paper_no#" label="57880" type="cell">
            <cf_wuxi id="department_in" data="#get_location_info(get_upd_purchase.department_in,get_upd_purchase.location_in)#" label="56969" type="cell">
            <cf_wuxi id="travel-id" data="#get_location_info(get_upd_purchase.department_out,get_upd_purchase.location_out)#" label="29428" type="cell">
            <cf_wuxi id="travel-id" data="#dateformat(ship_date,dateformat_style)#" label="48282" type="cell">
            <cf_wuxi id="travel-id" data="#dateformat(deliver_date,dateformat_style)#" label="57009" type="cell">
            <cf_wuxi id="travel-id" data="#GET_SHIP_METHOD.SHIP_METHOD#" label="29500" type="cell">
        </cf_woc_elements>
        <cf_woc_elements>
            <cf_woc_list id="prod_list">
                <thead>
                    <tr>
                        <cf_wuxi label="58800" type="cell" is_row="0" id="wuxi_58800"> 
                        <cf_wuxi label="57657" type="cell" is_row="0" id="wuxi_57657"> 
                        <cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
                        <cf_wuxi label="57636" type="cell" is_row="0" id="wuxi_57636"> 
                    </tr>
                </thead>
                <tbody>
                    <cfset Row_Start = 1>
                    <cfset Row_End = 30>
                    <cfloop from="#Row_Start#" to="#Row_End#" index="i">
                        <cfif i lte Get_Ship_Row.RecordCount>
                            <cfscript>
                                if(len(Get_Ship_Row.Discount[i]))indirim = Get_Ship_Row.Discount[i]; else indirim = 0;
                                adim_1 = Get_Ship_Row.Amount[i] * Get_Ship_Row.Price[i];
                                adim_2 = (adim_1/100)*(100-indirim);
                                adim_3 = adim_2*(Get_Ship_Row.Tax[i]/100);
                                adim_4 = adim_2+adim_3;
                            </cfscript>
                            <cfquery name="Get_Product" datasource="#dsn3#">
                                SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Ship_Row.product_id[i]#">
                            </cfquery>
                            <tr>
                                <td>#Get_Product.Product_Code#</td>
                                <td>#left(Get_Ship_Row.Name_Product[i],53)#</td>
                                <td style="text-align:right;">#Get_Ship_Row.Amount[i]#</td>
                                <td>#Get_Ship_Row.Unit[i]#</td>
                            </tr>
                        </cfif>
                    </cfloop>
                </tbody>
            </cf_woc_list> 
        </cf_woc_elements>
        <cf_woc_footer>
    </cfoutput>
</cfif>