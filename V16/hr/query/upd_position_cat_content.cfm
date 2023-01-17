<cfquery name="del_positions" datasource="#DSN#">
	DELETE FROM 
		EMPLOYEE_POSITIONS_AUTHORITY 
	WHERE 
		AUTHORITY_ID = #attributes.AUTHORITY_ID# 
</cfquery>

<cfif isdefined("position_cat") and len(position_cat)>
	<cfloop list="#position_cat#" index="i">
		<cfquery name="ADD_position_cat_content" datasource="#DSN#">
			INSERT INTO EMPLOYEE_POSITIONS_AUTHORITY 
				(
				AUTHORITY_ID,
				POSITION_CAT_ID,
				POSITION_ID
				)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AUTHORITY_ID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
		 		<cfif isDefined("position_name_id") and len(position_name_id) and len(attributes.position_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#position_name_id#"><cfelse>NULL</cfif>
				)
		</cfquery>
	</cfloop>
<cfelse>
	<cfquery name="ADD_position_cat_content" datasource="#DSN#">
		INSERT INTO EMPLOYEE_POSITIONS_AUTHORITY 
			(
			AUTHORITY_ID,
			POSITION_CAT_ID,
			POSITION_ID
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.AUTHORITY_ID#">,
			NULL,
			 <cfif isDefined("position_name_id") and len(position_name_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#position_name_id#"><cfelse>NULL</cfif>
			)
	</cfquery>
</cfif>
<cfset department_list = "">
<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
	<cfset department_list=listappend(department_list,'#attributes.department_id#')>
</cfif>
<cfquery name="upd_AUTHORITY" datasource="#DSN#">
UPDATE 
	EMPLOYEE_AUTHORITY 
SET
	AUTHORITY_HEAD = '#CONTENT_HEAD#',
	AUTHORITY_DETAIL = '#CONTENT_DETAIL#',
	STATUS = <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
	DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#department_list#">,
	UPDATE_MEMBER = #session.ep.userid#,
	UPDATE_DATE = #now()#,
	UPDATE_IP = '#cgi.remote_addr#'
WHERE
	AUTHORITY_ID = #attributes.AUTHORITY_ID#
</cfquery>

<cfif isdefined("form.popup")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_contents&event=upd&authority_id=<cfoutput>#authority_id#</cfoutput>';
	</script>
</cfif>
