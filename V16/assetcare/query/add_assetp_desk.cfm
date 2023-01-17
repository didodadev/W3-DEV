	<cfquery name="ADD_ASSETP" datasource="#DSN#" result="MAX_ID">
		INSERT INTO 
			ASSET_P_DESKS_GROUP
		(		
			ASSET_P_SPACE_ID,
			ASSETP_CATID,
			DEPARTMENT_ID,
			EMPLOYEE_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			<cfif len(attributes.asset_p_space_id)><cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.asset_p_space_id#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.assetp_catid") and len(attributes.assetp_catid)><cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.assetp_catid#"><cfelse>NULL</cfif>,
			<cfif len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.department_id#"><cfelse>NULL</cfif>,
			<cfif len(attributes.emp_id)>'#attributes.emp_id#'<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
	</cfquery>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#") neq 0>		
			<cfquery name="ADD_DESK" datasource="#DSN#">
				INSERT INTO 
					ASSET_P
				(		
					ASSETP,
					ASSETP_CATID,
					DEPARTMENT_ID,
					DEPARTMENT_ID2,
					EMPLOYEE_ID,
					STATUS,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					ASSET_P_SPACE_ID,
					RELATION_DESKS_ASSETP_ID,
					DESK_NO,
					DESK_CHAIR,
					BARCODE   
				)
				VALUES
				(
					'#getlang('','Masa','31313')#',
					<cfif isdefined("attributes.assetp_catid") and len(attributes.assetp_catid)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_catid#"><cfelse>NULL</cfif>,
					<cfif len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL</cfif>,
					<cfif len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL</cfif>,
					<cfif len(attributes.emp_id)>'#attributes.emp_id#'<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					#now()#,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfif isdefined("attributes.assetp_space_id") and len(attributes.assetp_space_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_space_id#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
					<cfif isdefined("attributes.desk_no#i#") and len(evaluate('attributes.desk_no#i#'))>#evaluate('attributes.desk_no#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.chair_count#i#") and len(evaluate('attributes.chair_count#i#'))>#evaluate('attributes.chair_count#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.qr_code#i#") and len(evaluate('attributes.qr_code#i#'))>#evaluate('attributes.qr_code#i#')#<cfelse>NULL</cfif>
				)
			</cfquery>
		</cfif>
	</cfloop>
<script>
	closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
</script>