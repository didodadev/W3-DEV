<CFLOCK timeout="20">
	<cfset department_list = "">
	<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
		<cfset department_list=listappend(department_list,'#attributes.department_id#')>
	</cfif>
  <cfquery name="ADD_AUTHORITY" datasource="#DSN#" result="MAX_ID">
     INSERT INTO EMPLOYEE_AUTHORITY 
	 (
	  AUTHORITY_HEAD,
	  AUTHORITY_DETAIL,
	  STATUS,
	  DEPARTMENT_ID,
	  RECORD_MEMBER,
	  RECORD_DATE,
	  RECORD_IP
	 )
	 VALUES
	 (
	  '#CONTENT_HEAD#',
	 '#CONTENT_DETAIL#',
	 <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
	<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#department_list#">,
	 #session.ep.userid#,
	 #now()#,
	 '#cgi.remote_addr#'
	 )
  
  </cfquery>
</CFLOCK>
<cfif isdefined("attributes.position_cat") and len(attributes.position_cat)>
	<cfloop list="#position_cat#" index="i">
	  <cfquery name="add_position_cat_content" datasource="#DSN#">
	  
		INSERT INTO EMPLOYEE_POSITIONS_AUTHORITY 
		(
		  AUTHORITY_ID,
		  POSITION_CAT_ID,
		  POSITION_ID
		)
		VALUES
		(
		 #MAX_ID.IDENTITYCOL#,
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">,
		 <cfif isDefined("position_name_id") and len(position_name_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#position_name_id#"><cfelse>NULL</cfif>
		)
	  </cfquery>
	</cfloop>
<cfelse>
	<cfquery name="add_position_cat_content" datasource="#DSN#">
		INSERT INTO EMPLOYEE_POSITIONS_AUTHORITY 
		(
		  AUTHORITY_ID,
		  POSITION_CAT_ID,
		  POSITION_ID
		)
		VALUES
		(
		 #MAX_ID.IDENTITYCOL#,
		 NULL,
		 <cfif isDefined("position_name_id") and len(position_name_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#position_name_id#"><cfelse>NULL</cfif>
		)
	  </cfquery>
</cfif>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_contents&event=upd&authority_id=<cfoutput>#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>