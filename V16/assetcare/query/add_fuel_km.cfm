<!--- <cfabort> --->
<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="add_fuel" datasource="#dsn#"> 
			INSERT INTO 
				ASSET_P_FUEL
			(
				ASSETP_ID,
				EMPLOYEE_ID,
				DEPARTMENT_ID,
				FUEL_DATE,
				FUEL_COMPANY_ID, 
				FUEL_TYPE_ID,
				FUEL_AMOUNT,
				DOCUMENT_TYPE_ID,
				DOCUMENT_NUM,
				TOTAL_AMOUNT,
				TOTAL_CURRENCY,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			) 
			VALUES 
			(
				#attributes.assetp_id#,
				#attributes.employee_id#,
				#attributes.department_id#,
				#attributes.finish_date#,
				<cfif len(attributes.fuel_comp_id)>#attributes.fuel_comp_id#<cfelse>NULL</cfif>,
				#attributes.fuel_type_id#,
				<cfif len(attributes.fuel_amount)>#filterNum(attributes.fuel_amount)#<cfelse>NULL</cfif>,
				#attributes.document_type_id#,
				<cfif len(attributes.document_num)>'#attributes.document_num#'<cfelse>NULL</cfif>,
				<cfif len(attributes.total_amount)>#filterNum(attributes.total_amount)#<cfelse>NULL</cfif>,
				<cfif len(attributes.total_currency)>'#attributes.total_currency#'<cfelse>NULL</cfif>,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>
		<cfquery name="get_max_fuel" datasource="#dsn#">
			SELECT MAX(FUEL_ID) MAX_FUEL_ID FROM ASSET_P_FUEL
		</cfquery>
		
		<cfquery name="add_km" datasource="#dsn#"> 
			INSERT INTO 
				ASSET_P_KM_CONTROL
			(
				FUEL_ID,
				ASSETP_ID,
				EMPLOYEE_ID,
				DEPARTMENT_ID,
				KM_START,
				KM_FINISH,
				START_DATE,
				FINISH_DATE,
				DETAIL,
				IS_OFFTIME,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			) 
			VALUES 
			(	
				#get_max_fuel.max_fuel_id#,
				#attributes.assetp_id#,
				#attributes.employee_id#,
				#department_id#,
				<cfif len(attributes.pre_km)>#attributes.pre_km#<cfelse>0</cfif>,
				<cfif len(attributes.last_km)>#attributes.last_km#<cfelse>0</cfif>,
				<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.is_offtime")>1<cfelse>0</cfif>,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload(); 
	window.close();
</script>




