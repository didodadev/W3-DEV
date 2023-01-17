<cf_catalystHeader>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id="38514.Alış Satış Koşulları"></cfsavecontent>
<cfif isnumeric(attributes.order_id)>
    <cfinclude template="../query/get_order_detail.cfm">
<cfelse>
    <cfset get_order_detail.recordcount = 0>
</cfif>
<cfif len(get_order_detail.company_id)>
<cfparam name="attributes.company_id" default="#get_order_detail.company_id#">
<cfinclude template="../../objects/query/get_com_det.cfm">
<cfelse>
<cfparam name="attributes.consumer_id" default="#get_order_detail.consumer_id#">
</cfif>
<div class="row">
    <div class="col col-9">
        <!---Siparis Karşılama Raporu --->
        <div id="siparis_karsilama_raporu"></div>
        <script>
            AjaxPageLoad("<cfoutput>#request.self#?fuseaction=objects.popup_list_order_receive_rate&order_id=#attributes.order_id#&is_purchase=1</cfoutput>",'siparis_karsilama_raporu');
        </script>
        <!---Siparis Stok Raporu --->
        <cfinclude template="../../objects/display/popup_list_order_stock.cfm">
        <!--- bütçe uygunluk kontrolü --->
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='60673.Bütçe Uygunluk Kontrolü'></cfsavecontent>
        <cf_box title="#title#" 
                closable="0" 
                refresh="1"
                box_page="#request.self#?fuseaction=objects.budget_compliance_check&order_id=#attributes.order_id#"
                >
        </cf_box>
    </div>
    <div class="col col-3">
         <!---Belgeler --->
        <cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-12" module_id='12' action_section='ORDER_ID' action_id='#attributes.order_id#' design_id='1'>
        <!---Notlar --->
        <cf_get_workcube_note company_id="#session.ep.company_id#" action_section='ORDER_ID' action_id='#attributes.order_id#' design_id='1'>
        <!---Finansal Özet --->
            <cfif fusebox.use_period>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58085.Finansal Özet'></cfsavecontent>
                <cf_box title="#message#"  closable="0" refresh="1">
                    <cfif len(get_order_detail.company_id)>
                            <cfset attributes.company = get_company.fullname>
                            <cfset member_type = 'partner'>
                    <cfelse>
                        <cfquery name="get_cons" datasource="#DSN#">
                        	SELECT
                            CONSUMER_NAME,
                            CONSUMER_SURNAME
                            FROM
                            CONSUMER
                            WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.consumer_id#">
                        </cfquery>
                        <cfset member_type = 'consumer'>
                        <cfset attributes.company = get_cons.CONSUMER_NAME & " " & get_cons.CONSUMER_SURNAME>
                    </cfif>
                        <cfinclude template="../../objects/display/dsp_extre_summary_popup.cfm">
                </cf_box>
            </cfif>
    </div>
</div>
<script></script>
 