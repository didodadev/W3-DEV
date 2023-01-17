<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='239.Anlaşma'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='25.anlasmalar'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang no='115.Fark ve Prim Kontrol'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang no='337.Sözleşmeler'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang no='344.Hakedişler'></cfsavecontent>

<cfif get_module_user(20) eq 1>
	<cfset add_invoice_ = "invoice.list_conract_comparison*0*0*#m_dil_3#">
<cfelse>
	<cfset add_invoice_ = "">
</cfif>

<cfset f_n_action_list = "contract.list_contracts*0*0*#m_dil_1#,contract.list_contracts*0*0*#m_dil_2#,#add_invoice_#,contract.list_related_contracts*0*0*#m_dil_4#,contract.list_progress*0*0*#m_dil_5#">
<cfset menu_module_layer = "contract">
<cfinclude template="../../design/module_menu.cfm">
