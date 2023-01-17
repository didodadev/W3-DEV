<cfset tools = "">

<cfloop from="1" to="12" index="i">
	<cfif len(Evaluate("attributes.tool"&i))>
		<cfset tools = tools & ";" & Evaluate("attributes.tool"&i) & ";" & Evaluate("attributes.tool"&i&"_level")>
	</cfif>
</cfloop>

<cfif ListLen(tools)>
	<cfset attributes.tools = right(tools,len(tools)-1)>
</cfif>

<cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_DETAIL_ID
	FROM 
		EMPLOYEES_DETAIL 
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>

<cfif detail_exists.recordcount>

	<cfquery name="UPd_tools" datasource="#dsn#">
		UPDATE
			EMPLOYEES_DETAIL
		SET
			TOOLS = '#TOOLS#',
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			EMPLOYEE_DETAIL_ID = #DETAIL_EXISTS.EMPLOYEE_DETAIL_ID#
	</cfquery>

<cfelse>

	<cfquery name="add_tools" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_DETAIL
			(
			EMPLOYEE_ID,
			TOOLS,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
			)
		VALUES
			(
			#EMPLOYEE_ID#,
			'#TOOLS#',
			#now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#
			)
	</cfquery>
</cfif>
<script type="text/javascript">
/*wrk_opener_reload();*/
<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>
