<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='57441.fatura'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang dictionary_id='58917.Faturalar'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='116.emirler'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='57056.Fark ve Prim Kontrol'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='57016.Satis Faturasi Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='57015.Alis Faturasi Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='57819.Hal Faturası'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang dictionary_id='30067.Diger alis ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang dictionary_id='57765.Perakende Satış Faturası'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang dictionary_id='57274.Toplu Fatura'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang dictionary_id='57529.tanimlar'></cfsavecontent>
<cfsavecontent variable="m_dil_12"><cf_get_lang dictionary_id="30509.Hobim"></cfsavecontent>
<cfsavecontent variable="m_dil_13"><cf_get_lang dictionary_id='47112.Gelen E-fatura'></cfsavecontent>

<cfif (SESSION.EP.OUR_COMPANY_INFO.WORKCUBE_SECTOR is "per")>
	<cfset add_adm_ = "invoice.marketplace_commands*0*0*#m_dil_7#">
<cfelse>
	<cfset add_adm_ = "">
</cfif>
<cfif session.ep.our_company_info.subscription_contract eq 1>
	<cfset add_adm1_ = "invoice.list_sale_multi*0*0*#m_dil_10#">
    <cfset add_adm3_ = "invoice.list_hobim_file*0*0*#m_dil_12#">
<cfelse>
	<cfset add_adm1_ = "">
    <cfset add_adm3_ = "">
</cfif>
<cfif get_module_power_user(20)>
	<cfset add_adm2_ = "invoice.definition*0*0*#m_dil_11#">
<cfelse>
	<cfset add_adm2_ = "">
</cfif>
<cfif session.ep.our_company_info.is_efatura>
	<cfset add_adm4_ = "invoice.received_einvoices*0*0*#m_dil_13#">
<cfelse>
	<cfset add_adm4_ = "">
</cfif>
<cfset f_n_action_list = "invoice.list_bill*0*0*#m_dil_1#,invoice.list_bill*0*0*#m_dil_2#,invoice.list_purchase*0*0*#m_dil_3#,invoice.list_conract_comparison*0*0*#m_dil_4#,invoice.form_add_bill*0*0*#m_dil_5#,invoice.form_add_bill_purchase*0*0*#m_dil_6#,#add_adm_#,invoice.form_add_bill_other*0*0*#m_dil_8#,invoice.add_bill_retail*0*0*#m_dil_9#,#add_adm1_#,#add_adm3_#,#add_adm4_#,#add_adm2_#">
<cfset menu_module_layer = "invoice">
<cfinclude template="../../design/module_menu.cfm">
