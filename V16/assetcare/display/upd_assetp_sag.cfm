<!---<cfsavecontent variable="title"><cf_get_lang no='235.Araç KM Son Durum'></cfsavecontent>
<cf_box 
    id="get_vehicle_km_info" 
    title="#title#" 
    closable="0" 
    unload_body="1" 
    box_page="#request.self#?fuseaction=assetcare.vehicle_km&assetp_id=#attributes.assetp_id#">
</cf_box>--->
<cfif len(get_assetp.INVENTORY_ID)>
<!--- Sabit Kıymet fatura ilişkili belge ve notlar --->
<cfquery name="get_related_invoice" datasource="#DSN2#">
    SELECT
        INVOICE_ID
    FROM
        INVOICE_ROW
    WHERE
        INVENTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_assetp.INVENTORY_ID#">
</cfquery>
<cfset related_id=get_related_invoice.INVOICE_ID>
<cfelse>
<cfset related_id="">
</cfif>
<cf_get_workcube_note action_section='ASSETP_ID' related_id='#related_id#' related_section='INVOICE_ID' action_id='#attributes.assetp_id#'>
<cf_get_workcube_asset asset_cat_id="-23" module_id='1' related_id='#related_id#' related_section='INVOICE_ID' action_section='ASSETP_ID' action_id='#attributes.assetp_id#'>    
<cfsavecontent variable="title"><cf_get_lang dictionary_id='47888.Bakım Anlaşmaları'></cfsavecontent>
<cf_box 
    id="ASSET_TAKE_SUPPORT_CAT" 
    title="#title#" 
    closable="0" 
    unload_body="1" 
    add_href="#request.self#?fuseaction=assetcare.popup_add_asset_contract&asset_id=#attributes.assetp_id#"
    box_page="#request.self#?fuseaction=assetcare.list_asset_care_contract&assetp_id=#attributes.assetp_id#">
</cf_box>
<!---<cfinclude template="../display/list_asset_care_contract.cfm">--->

