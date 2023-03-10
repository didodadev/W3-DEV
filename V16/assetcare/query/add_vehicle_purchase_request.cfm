<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cf_date tarih='attributes.request_date'>
		<cfquery name="add_request" datasource="#dsn#">
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
					1,
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
			<cfquery name="get_request_id" datasource="#dsn#" maxrows="1">
				SELECT REQUEST_ID FROM ASSET_P_REQUEST ORDER BY REQUEST_ID DESC
			</cfquery>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_assetp_catid = evaluate("attributes.assetp_catid#i#");
						//form_assetp_group = evaluate("attributes.assetp_group#i#");
						form_usage_purpose_id = evaluate("attributes.usage_purpose_id#i#");
						form_make_year = evaluate("attributes.make_year#i#");
						form_brand_type_id = evaluate("attributes.brand_type_id#i#");
						form_assetp_id = evaluate("attributes.assetp_id#i#");
						form_assetp = evaluate("attributes.assetp#i#");
					</cfscript>
					<cfquery name="add_request_rows" datasource="#dsn#" result="MAX_ID">
						INSERT INTO
								ASSET_P_REQUEST_ROWS
						(
								REQUEST_ID,
								REQUEST_TYPE_ID,
								ASSETP_CATID,
								BRAND_TYPE_ID,
								MAKE_YEAR,
								PERT_ID,
								USAGE_PURPOSE_ID,
								BRANCH_ID,
								EMPLOYEE_ID,
								REQUEST_DATE,
								DETAIL,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE,
								REQUEST_STATE,
								IS_APPROVED
						)
						VALUES
						(
								#get_request_id.request_id#,
								1,
								#form_assetp_catid#,
								#form_brand_type_id#,
								#form_make_year#,
								<cfif len(form_assetp)>#form_assetp_id#<cfelse>NULL</cfif>, 
								#form_usage_purpose_id#,
								#attributes.branch_id#,
								#attributes.employee_id#,
								#attributes.request_date#,
								<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
								#session.ep.userid#,
								'#cgi.remote_addr#',
								#now()#,
								#attributes.process_stage#,
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
						action_page='#request.self#?fuseaction=assetcare.upd_vehicle_purchase_request&request_row_id=#MAX_ID.IDENTITYCOL#&request_id=#get_request_id.request_id#' 
						warning_description='Al???? Talebi : #MAX_ID.IDENTITYCOL# Talep Tarihi : #dateformat(attributes.request_date,dateformat_style)# ??ube : #attributes.branch# Talep Eden : #attributes.employee#'>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script>
	location.href = '<cfoutput>#request.self#?fuseaction=assetcare.upd_vehicle_purchase_request&event=upd&request_id=#get_request_id.request_id#&request_row_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
