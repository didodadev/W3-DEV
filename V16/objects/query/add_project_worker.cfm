<cfif isdefined('attributes.station_id')>
	<cfquery name="get_stat_name" datasource="#dsn3#">
		SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = #attributes.STATION_ID#
	</cfquery>
<cfelse>
	<cfquery name="GET_PRO_NAME" datasource="#DSN#">
		SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.PROJECT_ID#
	</cfquery>
</cfif>
<cfquery name="CONTROL" datasource="#DSN#">
	SELECT WORKGROUP_ID FROM WORK_GROUP WHERE <cfif isdefined('attributes.station_id')>STATION_ID = #attributes.station_id#<cfelse>PROJECT_ID = #attributes.PROJECT_ID#</cfif>
</cfquery>

<cfif control.recordcount eq 0>
	<cfif isdefined('attributes.station_id')>
		<cfquery name="INS_WORKGROUP" datasource="#DSN#">
			INSERT INTO
				WORK_GROUP
			(
				WORKGROUP_NAME,
				STATION_ID
			)
			VALUES
			(
				'#get_stat_name.station_name#',
				#attributes.station_id#
			)
		</cfquery>
   	<cfelse>
		<cfquery name="INS_WORKGROUP" datasource="#DSN#">
			INSERT INTO
				WORK_GROUP
			(
				WORKGROUP_NAME,
				PROJECT_ID
			)
			VALUES
			(
				'#get_pro_name.project_head#',
				#attributes.project_id#
			)
		</cfquery>
   	</cfif>
</cfif>

<cfquery name="GET_ID" datasource="#DSN#">
	SELECT WORKGROUP_ID FROM WORK_GROUP WHERE <cfif isdefined('attributes.station_id')>STATION_ID= #attributes.station_id#<cfelse>PROJECT_ID = #attributes.PROJECT_ID#</cfif>
</cfquery>

<cfloop index="i" from="1" to="10">  
	<cfif len(evaluate("form.get_rol#i#"))>
    	<cfset role=evaluate("form.get_rol#i#")>
   	</cfif>
   
   	<cfif len(evaluate("form.position_code#i#")) and (evaluate("form.position_code#i#") neq 0)>
		<cfset position_code=evaluate("form.position_code#i#")>
	    <cfif len(evaluate("form.get_rol#i#")) eq 0>
	    	<script type="text/javascript">
	       		alert("Lütfen Rol Seçiniz!");
	       		history.back();
	      	</script>
	      	<cfexit>
	   	</cfif>
	   
		<cfquery name="add_worker_emp" datasource="#DSN#">
			INSERT INTO 
				WORKGROUP_EMP_PAR
			(
				WORKGROUP_ID,
				<cfif isdefined('attributes.station_id')>STATION_ID<cfelse>PROJECT_ID</cfif>,
				POSITION_CODE,
				ROLE_ID,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				#GET_ID.WORKGROUP_ID#,
				<cfif isdefined('attributes.station_id')>#attributes.station_id#<cfelse>#attributes.PROJECT_ID#</cfif>,
				#position_code#,
				<cfif len(evaluate("form.get_rol#i#"))>#role#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>
	 
	 <cfelseif len(evaluate("form.partner_id#i#")) and (evaluate("form.partner_id#i#") neq 0)>

	   	<cfset partner_id=evaluate("form.partner_id#i#")>
	    <cfif len(evaluate("form.get_rol#i#")) eq 0>
	    	<script type="text/javascript">
	       		alert("Lütfen Rol Seçiniz!");
	       		history.back();
	      	</script>
	      	<cfexit>
	   	</cfif>
	   
	   	<cfquery name="ADD_WORKER_PAR" datasource="#DSN#">
			INSERT INTO 
				WORKGROUP_EMP_PAR
			(
				WORKGROUP_ID,
				<cfif isdefined('attributes.station_id')>STATION_ID<cfelse>PROJECT_ID</cfif>,
				PARTNER_ID
				<cfif len(evaluate("form.get_rol#i#"))>
				,ROLE_ID 
				</cfif> 
			)
			VALUES
			(
				#GET_ID.WORKGROUP_ID#,
				<cfif isdefined('attributes.station_id')>#attributes.station_id#<cfelse>#attributes.PROJECT_ID#</cfif>,
				#partner_id#
				<cfif len(evaluate("form.get_rol#i#"))>
				,#ROLE# 
				</cfif>  
			)
     	</cfquery>
	</cfif>
</cfloop>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
