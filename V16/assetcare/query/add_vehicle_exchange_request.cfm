<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cf_date tarih='attributes.request_date'>
		<cfquery name="ADD_REQUEST" datasource="#DSN#">
			INSERT INTO
				ASSET_P_REQUEST
			(
				REQUEST_TYPE_ID,
				BRANCH_ID,
				EMPLOYEE_ID,
				REQUEST_DATE,
				DETAIL,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				3,
				#attributes.branch_id#,
				#attributes.employee_id#,
				#attributes.request_date#,
				<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfif len(attributes.record_num)>
		<cfquery name="GET_REQUEST_ID" datasource="#DSN#" maxrows="1">
			SELECT REQUEST_ID FROM ASSET_P_REQUEST ORDER BY REQUEST_ID DESC
		</cfquery>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_old_assetp_id = evaluate("attributes.old_assetp_id#i#");
						form_old_brand_type_id = evaluate("attributes.old_brand_type_id#i#");
						form_old_brand_name = evaluate("attributes.old_brand_name#i#");
						form_old_make_year = evaluate("attributes.old_make_year#i#");
						form_new_assetp_catid = evaluate("attributes.new_assetp_catid#i#");
						form_new_usage_purpose_id = evaluate("attributes.new_usage_purpose_id#i#");
						form_new_brand_type_id = evaluate("attributes.new_brand_type_id#i#");
						form_new_make_year = evaluate("attributes.new_make_year#i#");
					</cfscript>
					<cfquery name="ADD_REQUEST_ROWS" datasource="#DSN#" result="MAX_ID">
						INSERT INTO
							ASSET_P_REQUEST_ROWS
						(
							REQUEST_ID,
							REQUEST_TYPE_ID,
							OLD_BRAND_TYPE_ID,
							OLD_MAKE_YEAR,
							ASSETP_ID,
							MAKE_YEAR,
							ASSETP_CATID,
							USAGE_PURPOSE_ID,
							BRAND_TYPE_ID,
							BRANCH_ID,
							EMPLOYEE_ID,
							REQUEST_DATE,
							DETAIL,
							REQUEST_STATE,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							IS_APPROVED
						)
						VALUES
						(
							#get_request_id.request_id#,
							3,
							#form_old_brand_type_id#,
							#form_old_make_year#,
							#form_old_assetp_id#,
							#form_new_make_year#,
							#form_new_assetp_catid#,
							#form_new_usage_purpose_id#,
							#form_new_brand_type_id#,
							#attributes.branch_id#,
							#attributes.employee_id#,
							#attributes.request_date#,
							<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
							#attributes.process_stage#,
							#session.ep.userid#,
							'#cgi.remote_addr#',
							#now()#,
							0
						)
					</cfquery>
					<cf_workcube_process 
						is_upd='1' 
						old_process_line='0'
						process_stage='#attributes.process_stage#' 
						record_member='#session.ep.userid#' 
						record_date='#now()#' 
						action_table='ASSET_P_REQUEST_ROWS'
						action_column='REQUEST_ROW_ID'
						action_id='#MAX_ID.IDENTITYCOL#'
						action_page='#request.self#?fuseaction=assetcare.upd_vehicle_exchange_request&request_row_id=#MAX_ID.IDENTITYCOL#&request_id=#get_request_id.request_id#' 
						warning_description='Değiştirme Talebi : #MAX_ID.IDENTITYCOL# Talep Tarihi : #dateformat(attributes.request_date,dateformat_style)# Şube : #attributes.branch# Talep Eden : #attributes.employee#'>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script>
	location.href = '<cfoutput>#request.self#?fuseaction=assetcare.add_vehicle_exchange_request&event=upd&request_id=#get_request_id.request_id#&request_row_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
