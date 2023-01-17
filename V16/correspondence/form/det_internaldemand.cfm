<cfif listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand'>
        <cfset is_demand = 1>
    <cfelse>
        <cfset is_demand = 0>
    </cfif>
    <cfif isdefined("attributes.id") and len(attributes.id)>
        <cfif not isnumeric(attributes.id)><cfset attributes.id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.id,accountKey:'wrk')></cfif>
        <cfscript>
            get_demand_list_action = CreateObject("component","V16.correspondence.cfc.get_demand");
            get_demand_list_action.dsn = dsn3;
            get_internaldemand = get_demand_list_action.get_demand_list_fnc(
            is_demand:is_demand,
            id:attributes.id
            );
        </cfscript>
    <cfelse>
        <cfset get_internaldemand.recordcount=0>
    </cfif>
<cfquery name="get_offer" datasource="#DSN3#">
    SELECT OFFER_ID FROM OFFER WHERE INTERNALDEMAND_ID = #attributes.id# AND PURCHASE_SALES = 0
</cfquery> 
<cfif not get_internaldemand.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
    <cfset hata  = 11>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cf_catalystHeader>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='60673.Bütçe Uygunluk Kontrolü'></cfsavecontent>
    <div class="col col-9">
        <cf_box title="#title#" 
                closable="0" 
                refresh="1"
                box_page="#request.self#?fuseaction=objects.budget_compliance_check&internaldemand_id=#attributes.id#"
                >
        </cf_box>
        <cfset title = "#getlang('','',45445)#">
        <cf_box title="#title#" 
        closable="0" 
        refresh="1"
        box_page="#request.self#?fuseaction=objects.popup_list_internaldemand_relation&internaldemand_id=#attributes.id#"
        ></cf_box>
    </div>
    <div class="col col-3">
        <cf_get_workcube_note company_id="#session.ep.company_id#" action_section='INTERNAL_ID' action_id='#attributes.id#' design_id='1' style="1">
    </div>
</cfif>