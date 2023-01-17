<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="get_max_km" datasource="#dsn#">
			SELECT MAX(KM_FINISH) MAX_KM FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #attributes.assetp_id#
		</cfquery>
		<cfif (get_max_km.max_km eq attributes.km_last) and (attributes.is_allocate eq 0)>
			<cfquery name="upd_km" datasource="#dsn#">
				UPDATE
					ASSET_P_KM_CONTROL
				SET
					FUEL_ID = #attributes.fuel_num#,
					ASSETP_ID = #attributes.assetp_id#,
					EMPLOYEE_ID = #attributes.employee_id#,
					DEPARTMENT_ID = #attributes.department_id#,
					KM_START = #attributes.pre_km#,
					KM_FINISH = <cfif len(attributes.last_km)>#attributes.last_km#<cfelse>0</cfif>,
					START_DATE =<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
					FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
					DETAIL = '#attributes.detail#',
					IS_OFFTIME = <cfif isdefined("attributes.is_offtime")>1<cfelse>0</cfif>,
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_DATE = #now()#,
					UPDATE_IP = '#cgi.remote_addr#'			
				WHERE
					KM_CONTROL_ID = #attributes.km_control_id#
			</cfquery>
		</cfif>
		<cfquery name="upd_fuel" datasource="#dsn#">
			UPDATE
				ASSET_P_FUEL
			SET
				ASSETP_ID = #attributes.assetp_id#,
				EMPLOYEE_ID = #attributes.employee_id#,
				DEPARTMENT_ID = #attributes.department_id#,
				FUEL_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				FUEL_COMPANY_ID = #attributes.fuel_comp_id#,
				FUEL_TYPE_ID = <cfif len(attributes.fuel_type_id)>#attributes.fuel_type_id#<cfelse>NULL</cfif>,
				FUEL_AMOUNT = <cfif len(attributes.fuel_amount)>#attributes.fuel_amount#<cfelse>NULL</cfif>,
				DOCUMENT_TYPE_ID = <cfif len(attributes.document_type_id)>#attributes.document_type_id#<cfelse>NULL</cfif>,
				DOCUMENT_NUM = <cfif len(attributes.document_num)>'#attributes.document_num#'<cfelse>NULL</cfif>,
				TOTAL_AMOUNT = <cfif len(attributes.total_amount)>#attributes.total_amount#<cfelse>NULL</cfif>,
				TOTAL_CURRENCY = '#attributes.total_currency#',
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				FUEL_ID = #attributes.fuel_num#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload(); 
	window.close();
</script>
