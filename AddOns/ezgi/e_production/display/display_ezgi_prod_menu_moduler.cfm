<cfparam name="attributes.sub_plan_id" default="">
<cfparam name="attributes.proc_type" default="2">
<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='3230.Onaylanan Siparişler'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='3215.Personel Takip	'></cfsavecontent>
<cfset f_n_action_list = "prod.popup_display_ezgi_prod_menu_moduler&master_plan_id=#attributes.master_plan_id#&type=1*0*0*#m_dil_1#,prod.popup_display_ezgi_prod_menu_moduler&master_plan_id=#attributes.master_plan_id#&type=4*0*0*#m_dil_4#">
<cfset menu_module_layer = "myhome">
<cfinclude template="module_menu.cfm">
<cfif type eq 1>
	<cfinclude template="display_ezgi_orders_moduler.cfm">
<cfelseif type eq 4>
	<cfinclude template="display_ezgi_personel_moduler.cfm">
</cfif>