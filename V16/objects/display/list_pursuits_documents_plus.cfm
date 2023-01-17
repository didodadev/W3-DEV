<!--- siparisler, faturalar ve servis basvurularindan objectse tasindi, her sayfada ayri calisiyordu tek sayfada toplandi FBS 20080723 --->
<cfinclude template="../query/get_pursuits_documents_plus.cfm">
<cfif len(get_pursuit.partner_id)>
  <cfset contact_id = get_pursuit.partner_id>
  <cfset contact_type = "p">
<cfelseif len(get_pursuit.company_id)>
  <cfset contact_id = get_pursuit.company_id>
  <cfset contact_type = "comp">
<cfelseif len(get_pursuit.consumer_id)>
  <cfset contact_id = get_pursuit.consumer_id>
  <cfset contact_type = "c">
</cfif>
<cfinclude template="../query/get_account_simple.cfm">
<form name="detail_order" id="detail_order">
	<input type="hidden" value="<cfif isdefined("get_pursuit.order_head")><cfoutput>#get_pursuit.order_head#</cfoutput></cfif>" name="order_head" id="order_head">
	<input type="hidden" name="pursuit_type" id="pursuit_type" value="<cfif isdefined("attributes.pursuit_type")>#attributes.pursuit_type#</cfif>">
</form>
<cfsavecontent variable="right_1">
	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_add_pursuits_documents_plus&action_id=#attributes.action_id#&header=detail_order.order_head&contact_mail=#get_account_simple.email#&contact_person=#get_account_simple.name# #get_account_simple.surname#&pursuit_type=#attributes.pursuit_type#</cfoutput>','list');"><img src="/images/plus1.gif" border="0" title="<cf_get_lang_main no='170.Ekle'>"></a>
</cfsavecontent>
<div class="col col-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33688.Takip'></cfsavecontent>
    <cf_box title="#message#" add_href="#request.self#?fuseaction=objects.popup_add_pursuits_documents_plus&action_id=#attributes.action_id#&header=detail_order.order_head&contact_mail=#get_account_simple.email#&contact_person=#get_account_simple.name# #get_account_simple.surname#&pursuit_type=#attributes.pursuit_type#" closable="0">
        <cf_ajax_list>
            <cfif get_pursuit_plus.recordcount>
                <cfoutput query="get_pursuit_plus">
                    <thead>
                        <tr>
                            <th colspan="2"><cfif len(plus_subject)>#plus_subject#<cfelse><cf_get_lang dictionary_id='57480.Başlık'></cfif></th>
                            <th width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_pursuits_documents_plus&action_plus_id=#action_plus_name#&pursuit_type=#attributes.pursuit_type#','medium');"><img src="/images/update_list.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="120"><b><cf_get_lang dictionary_id='57742.Tarih'>:</b> #dateformat(plus_date,dateformat_style)#</td>
                            <td><cfif len(employee_id)><b><cf_get_lang dictionary_id='57569.Görevli'>:</b> #get_emp_info(employee_id,0,0)#</cfif></td>
                            <td><cfif len(commethod_id)>
                                    <b><cf_get_lang dictionary_id='58143.İletişim'>:</b> 
                                    <cfquery name="get_commethod" datasource="#dsn#">
                                        SELECT * FROM SETUP_COMMETHOD WHERE COMMETHOD_ID = #commethod_id#
                                    </cfquery>
                                    #get_commethod.commethod#
                                </cfif>
                            </td>
                        </tr>
                        <tr class="nohover">
                            <td colspan="3">#plus_content#</td>
                        </tr>
                        </tbody>
                </cfoutput>
            <cfelse>
                <tbody>
                    <tr> 
                        <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </tbody>
            </cfif>
        </cf_ajax_list>
    </cf_box>   
</div>
<div class="col col-12 col-xs-12">
    <cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_order">
        <cfset my_module_id = 11>
        <cfset my_asset_cat_id = -12>
    <cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_invoice">
        <cfset my_module_id = 20>
        <cfset my_asset_cat_id = -22>
    </cfif>

    <cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_invoice">
        <cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="#my_asset_cat_id#" module_id='#my_module_id#' action_section='#main_column_name#' action_id='#attributes.action_id#' period_id='#session.ep.period_id#'>
    <cfelse>
        <cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="#my_asset_cat_id#" module_name_info="SALES" module_id='#my_module_id#' action_section='#main_column_name#' action_id='#attributes.action_id#'>
    </cfif>
    <cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_order">
        <cf_get_related_rows action_id='#attributes.action_id#' action_type="ORDERS" is_popup="1">
    </cfif>
</div>
<div class="col col-12 col-xs-12">
	<cf_get_workcube_form_generator design='3' action_type='13' related_type='13' action_type_id='#attributes.action_id#'>
</div>

