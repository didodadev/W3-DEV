<cfsetting showdebugoutput="no">
<cfif len(attributes.main_prop)>
    <cfquery name="GET_SUB_PROPERTIES" datasource="#DSN1#">
        SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.main_prop#">
    </cfquery>
    <cfif GET_SUB_PROPERTIES.recordcount>
        <select name="main_dt_properties" id="main_dt_properties" style="width:170px;">
            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_sub_properties">
                <option value="#property_detail_id#">#property_detail#</option>
            </cfoutput>    
        </select>
    </cfif>
<cfelse>
    <select name="main_dt_properties" id="main_dt_properties" style="width:170px;">
        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>   
    </select>
</cfif>
