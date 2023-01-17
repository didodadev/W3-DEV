<cf_date tarih='attributes.request_date'>
<cfquery name="UPD_ROWS" datasource="#DSN#">
	UPDATE ASSET_P_REQUEST_ROWS
	SET
		ASSETP_CATID = #attributes.new_assetp_catid#,
		USAGE_PURPOSE_ID = #attributes.new_usage_purpose_id#,
		BRAND_TYPE_ID = #attributes.new_brand_type_id#,
		MAKE_YEAR = #attributes.new_make_year#,
		ASSETP_ID = #attributes.old_assetp_id#,
		OLD_BRAND_TYPE_ID = #attributes.old_brand_type_id#,
		OLD_MAKE_YEAR = #attributes.old_make_year#,
		REQUEST_DATE = #attributes.request_date#,
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		BRANCH_ID = #attributes.branch_id#,
		EMPLOYEE_ID = #attributes.employee_id#,
		REQUEST_STATE = #attributes.process_stage#,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#' 
	WHERE 
		REQUEST_ROW_ID = #attributes.request_row_id#
</cfquery>
<cfif Len(attributes.detail)>
	<!--- Notlara Ekleniyor --->
	<cfquery name="Add_Notes" datasource="#dsn#">
		INSERT INTO 
			NOTES
		(
			ACTION_SECTION,
			ACTION_ID,
			NOTE_HEAD,
			NOTE_BODY,
			IS_SPECIAL,
			IS_WARNING,
			COMPANY_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
			'EXCHANGE_REQUEST_ID',
			 #attributes.request_row_id#,
			'#left(attributes.detail,75)#',
			'#attributes.detail#',
			 0,
			 0,
			 #session.ep.company_id#,
			 #session.ep.userid#,
			 #now()#,
			'#cgi.remote_addr#'
		)
	</cfquery>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='ASSET_P_REQUEST_ROWS'
	action_column='REQUEST_ROW_ID'
	action_id='#attributes.request_row_id#' 
	action_page='#request.self#?fuseaction=assetcare.upd_vehicle_exchange_request&request_row_id=#attributes.request_row_id#&request_id=#attributes.request_id#' 
	warning_description='Değiştirme Talebi : #attributes.request_row_id# Güncelleme : #dateformat(now(),dateformat_style)# Şube : #attributes.branch# Talep Eden : #attributes.employee#'>
<cflocation url="#cgi.http_referer#" addtoken="no">
