<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='30.finans'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='107.cari hesap'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='108.kasa'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='109.banka'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang_main no='110.cek-senet'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang_main no='86.Masraf Yönetimi'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang_main no='113.Senaryolar'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang_main no='115.Talepler'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang_main no='116.Emirler'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang_main no='264.Teminatlar'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang_main no='277.Risk'></cfsavecontent>
<cfsavecontent variable="m_dil_12"><cf_get_lang_main no='117.Tanimlar'></cfsavecontent>

<cfif get_module_user(23)>
	<cfset add_adm_ = "ch.list_caris*3*0*#m_dil_2#">
<cfelse>
	<cfset add_adm_ = "">
</cfif>

<cfif get_module_user(18)>
	<cfset add_adm1_ = "cash.list_cash_actions*3*0*#m_dil_3#">
<cfelse>
	<cfset add_adm1_ = "">
</cfif>

<cfif get_module_user(19)>
	<cfset add_adm2_ = "bank.list_bank_actions*3*0*#m_dil_4#">
<cfelse>
	<cfset add_adm2_ = "">
</cfif>

<cfif get_module_user(21)>
	<cfset add_adm3_ = "cheque.list_cheques*3*0*#m_dil_5#">
<cfelse>
	<cfset add_adm3_ = "">
</cfif>

<cfif get_module_user(49)>
	<cfset add_adm4_ = "cost.list_expense_income*3*0*#m_dil_6#">
<cfelse>
	<cfset add_adm4_ = "">
</cfif>

<cfif get_module_power_user(16)>
	<cfset add_adm5_ = "finance.list_currencies*3*0*#m_dil_12#">
<cfelse>
	<cfset add_adm5_ = "">
</cfif>

<cfif get_module_user(16)>
	<cfset add_adm6_ = "finance.scenario*0*0*#m_dil_7#">
<cfelse>
	<cfset add_adm6_ = "">
</cfif>

<cfif get_module_user(16)>
	<cfset add_adm7_ = "finance.list_payment_actions&act_type=2*3*0*#m_dil_8#">
<cfelse>
	<cfset add_adm7_ = "">
</cfif>

<cfif get_module_user(16)>
	<cfset add_adm8_ = "finance.list_payment_actions&act_type=3*3*0*#m_dil_9#">
<cfelse>
	<cfset add_adm8_ = "">
</cfif>

<cfif get_module_user(16)>
	<cfset add_adm9_ = "finance.list_securefund*0*0*#m_dil_10#">
<cfelse>
	<cfset add_adm9_ = "">
</cfif>

<cfif get_module_user(16)>
	<cfset add_adm10_ = "finance.list_credits*0*0*#m_dil_11#">
<cfelse>
	<cfset add_adm10_ = "">
</cfif>

<cfset f_n_action_list = "finance.welcome*3*0*#m_dil_1#,#add_adm_#,#add_adm1_#,#add_adm2_#,#add_adm3_#,#add_adm4_#,#add_adm6_#,#add_adm7_#,#add_adm8_#,#add_adm9_#,#add_adm10_#,#add_adm5_#">
<cfset menu_module_layer = "#fusebox.circuit#">
<cfinclude template="../../design/module_menu.cfm">
