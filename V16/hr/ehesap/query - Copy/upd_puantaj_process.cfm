<cfquery name="upd_puantaj" datasource="#dsn#">
	UPDATE
		EMPLOYEES_PUANTAJ
	SET
		STAGE_ROW_ID = #attributes.process_stage#
	WHERE
		PUANTAJ_ID = #attributes.PUANTAJ_ID#
</cfquery>
<cfsavecontent variable = "description_">
	<cf_get_lang dictionary_id = "60761.Puantaj Aşama Güncelle">
</cfsavecontent>
<cf_workcube_process
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='EMPLOYEE_PUANTAJ'
	action_column='PUANTAJ_ID'
	action_id='#attributes.PUANTAJ_ID#' 
	action_page='#request.self#?fuseaction=ehesap.list_puantaj' 
	warning_description='#description_# : #attributes.PUANTAJ_ID#'>
<script type="text/javascript">
	alert("Aşama Güncellendi !");
/* 	adres_menu_1 = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_sube&puantaj_id=#attributes.PUANTAJ_ID#&x_select_process=1&x_payment_day=#attributes.x_payment_day#</cfoutput>';
	AjaxPageLoad(adres_menu_1,'menu_puantaj_1','1','Puantaj Menüsü Yükleniyor');
	
	adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_view_puantaj&puantaj_id=#attributes.PUANTAJ_ID#&branch_or_user_=1</cfoutput>';
	AjaxPageLoad(adres_,'puantaj_list_layer','1','Puantaj Listeleniyor'); */
</script>
