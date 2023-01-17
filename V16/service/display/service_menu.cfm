<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='244.servis'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='774.Basvurular'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang no='3.Başvuru Ekle'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='225.serino'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang no ='38.Ürün Servis İşlemleri'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang no ='306.Servis İrsaliyesi'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang no ='183.Garantiler'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang no='19.Bakım Planı'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang_main no='2208.Bakım Takvimi'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang no='35.Bakım Sonuçları'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang no ='307.Yardım Masası'></cfsavecontent>
<cfsavecontent variable="m_dil_12"><cf_get_lang_main no="2021.İş Grupları"></cfsavecontent>
<!--- Şirket Akış Parametrelerine Bagli Olarak Linkleri Getirir --->
<cfquery name="get_our_comp_info" datasource="#dsn#">
	SELECT IS_SUBSCRIPTION_CONTRACT,IS_GUARANTY_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif  get_our_comp_info.recordcount and get_our_comp_info.is_guaranty_followup eq 1>
	<cfset add_add_ = "service.list_guaranty*0*0*#m_dil_7#">
	<cfset add_add2_ = "objects.serial_no&event=det*1*wide*#m_dil_4#">
<cfelse>
	<cfset add_add_ = "">
	<cfset add_add2_ = "">
</cfif>
<cfset f_n_action_list = "service.list_service*0*0*#m_dil_1#,service.list_service*0*0*#m_dil_2#,service.add_service*0*0*#m_dil_3#,#add_add2_#,service.product_return*0*0*#m_dil_5#,service.service_ship*0*0*#m_dil_6#,#add_add_#,service.list_care*0*0*#m_dil_8#,service.dsp_service_calender*0*0*#m_dil_9#,service.list_service_report*0*0*#m_dil_10#,call.helpdesk*0*0*#m_dil_11#,service.list_workgroup*0*0*#m_dil_12#">
<cfset menu_module_layer = "service">
<cfinclude template="../../design/module_menu.cfm">



