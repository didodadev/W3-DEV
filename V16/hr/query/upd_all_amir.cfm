<cfloop from="1" to="#attributes.loop_count#" index="ccm">
	<!--- pozisyona atama yapilmamissa --->
	<cfif not len(evaluate("attributes.chief1_code_#ccm#")) and  
			not len(evaluate("attributes.chief2_code_#ccm#")) and
			not len(evaluate("attributes.chief3_code_#ccm#")) and
			not len(evaluate("attributes.chief1_emp_#ccm#")) and
			not len(evaluate("attributes.chief2_emp_#ccm#")) and
			not len(evaluate("attributes.chief3_emp_#ccm#")) and
			not len(evaluate("attributes.chief1_name_#ccm#")) and
			not len(evaluate("attributes.chief2_name_#ccm#")) and
			not len(evaluate("attributes.chief3_name_#ccm#"))
			>
		<cfquery name="add_standby" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_POSITIONS_STANDBY
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.position_code_#ccm#')#">
		</cfquery>
		<cfquery name="add_1" datasource="#dsn#">
			UPDATE
				EMPLOYEE_POSITIONS
			SET
				UPPER_POSITION_CODE = NULL,
				UPPER_POSITION_CODE2 = NULL
			WHERE 
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.position_code_#ccm#')#">
		</cfquery>	
	<cfelse>
		<cfquery name="get_code_info" datasource="#dsn#">
			SELECT CHIEF1_CODE FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.position_code_#ccm#')#">
		</cfquery>
		<cfif get_code_info.recordcount>
			<cfquery name="add_standby" datasource="#dsn#">
				UPDATE 
					EMPLOYEE_POSITIONS_STANDBY 
				SET 
					CHIEF1_CODE = <cfif len(evaluate("attributes.chief1_code_#ccm#")) and len(evaluate("attributes.chief1_emp_#ccm#")) and len(evaluate("attributes.chief1_name_#ccm#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.chief1_code_#ccm#')#">,<cfelse>NULL,</cfif>
					CHIEF2_CODE = <cfif len(evaluate("attributes.chief2_code_#ccm#")) and len(evaluate("attributes.chief2_emp_#ccm#")) and len(evaluate("attributes.chief2_name_#ccm#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.chief2_code_#ccm#')#">,<cfelse>NULL,</cfif>
					CHIEF3_CODE = <cfif len(evaluate("attributes.chief3_code_#ccm#")) and len(evaluate("attributes.chief3_emp_#ccm#")) and len(evaluate("attributes.chief3_name_#ccm#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.chief3_code_#ccm#')#">,<cfelse>NULL,</cfif>
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_KEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userkey#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				WHERE
					POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.position_code_#ccm#')#">
			</cfquery>
		<cfelse>
			<cfquery name="add_standby" datasource="#dsn#">
				INSERT INTO
					EMPLOYEE_POSITIONS_STANDBY 
					(
					POSITION_CODE,
					CHIEF1_CODE,
					CHIEF2_CODE,
					CHIEF3_CODE,
					UPDATE_DATE,
					UPDATE_KEY,
					UPDATE_IP,
					RECORD_DATE,
					RECORD_KEY,
					RECORD_IP
					)
					VALUES
					(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.position_code_#ccm#')#">,
					<cfif len(evaluate("attributes.chief1_code_#ccm#")) and len(evaluate("attributes.chief1_emp_#ccm#")) and len(evaluate("attributes.chief1_name_#ccm#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.chief1_code_#ccm#')#">,<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.chief2_code_#ccm#")) and len(evaluate("attributes.chief2_emp_#ccm#")) and len(evaluate("attributes.chief2_name_#ccm#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.chief2_code_#ccm#')#">,<cfelse>NULL,</cfif>
					<cfif len(evaluate("attributes.chief3_code_#ccm#")) and len(evaluate("attributes.chief3_emp_#ccm#")) and len(evaluate("attributes.chief3_name_#ccm#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.chief3_code_#ccm#')#">,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userkey#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userkey#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
			</cfquery>
		</cfif>
		<cfquery name="add_1" datasource="#dsn#">
			UPDATE
				EMPLOYEE_POSITIONS
			SET
				UPPER_POSITION_CODE = <cfif len(evaluate("attributes.chief1_code_#ccm#")) and len(evaluate("attributes.chief1_emp_#ccm#")) and len(evaluate("attributes.chief1_name_#ccm#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.chief1_code_#ccm#')#">,<cfelse>NULL,</cfif>
				UPPER_POSITION_CODE2 = <cfif len(evaluate("attributes.chief2_code_#ccm#")) and len(evaluate("attributes.chief2_emp_#ccm#")) and len(evaluate("attributes.chief2_name_#ccm#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.chief2_code_#ccm#')#"><cfelse>NULL</cfif>
			WHERE 
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.position_code_#ccm#')#">
		</cfquery>
	</cfif>		
</cfloop>
<cfscript>
	url_str = '&is_form_submitted=1';
	if(isdefined('attributes.branchid') and len(attributes.branchid))
		url_str = url_str&'&branch_id=#attributes.branchid#';
	if(isdefined('attributes.departmentid') and len(attributes.departmentid))
		url_str = url_str&'&department=#attributes.departmentid#';
	if(isdefined('attributes.positioncatid') and len(attributes.positioncatid))
		url_str = url_str&'&position_cat_id=#attributes.positioncatid#';
</cfscript>
<cflocation addtoken="no" url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_all_amir#url_str#">
