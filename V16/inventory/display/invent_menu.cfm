<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='57531.sabit kiymetler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang dictionary_id='57919.Hareketler'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='58176.Alış'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='57448.Satış'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='56995.Stok Fişi'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang dictionary_id='56903.Stok İade Fişi'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='56992.Değerleme'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang dictionary_id='56956.Demirbaş Devir'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang dictionary_id='58602.Demirbas'><cf_get_lang dictionary_id='57464.Guncelle'></cfsavecontent>
<cfif get_module_user(31)>
	<cfset add_add_ = "invent.list_actions*0*0*#m_dil_3#">
<cfelse>
	<cfset add_add_ = "">
</cfif>
<cfif get_module_user(31)>
	<cfset add_add1_ = "invent.add_invent_sale*0*0*#m_dil_5#">
<cfelse>
	<cfset add_add1_ = "">
</cfif>
<cfif get_module_user(31)>
	<cfset add_add2_ = "invent.add_invent_stock_fis*0*0*#m_dil_6#">
<cfelse>
	<cfset add_add2_ = "">
</cfif>
<cfif get_module_user(31)>
	<cfset add_add2_1 = "invent.add_invent_stock_fis_return*0*0*#m_dil_9#">
<cfelse>
	<cfset add_add2_1 = "">
</cfif>
<cfif get_module_user(31)>
	<cfset add_add3_ = "invent.list_invent_amortization*0*0*#m_dil_7#">
<cfelse>
	<cfset add_add3_ = "">
</cfif>
<cfif get_module_user(31)>
	<cfset add_add4_ = "invent.add_collacted_inventory*0*0*#m_dil_8#">
<cfelse>
	<cfset add_add4_ = "">
</cfif>
<cfif get_module_power_user(31) and structkeyexists(fusebox.circuits,'invent')><!--- sadece power user olan kullanicilar/demirbas guncelleme --->
	<cfset add_add5_ = "invent.upd_collacted_inventory*0*0*#m_dil_10#">
<cfelse>
	<cfset add_add5_ = "">
</cfif>

<cfset f_n_action_list = "invent.list_inventory*0*0*#m_dil_1#,invent.list_inventory*0*0*#m_dil_1#,#add_add_#,invent.add_invent_purchase*0*0*#m_dil_4#,#add_add1_#,#add_add2_#,#add_add2_1#,#add_add3_#,#add_add4_#,#add_add5_#">

<cfset menu_module_layer = "inventory">
<cfinclude template="../../design/module_menu.cfm">
