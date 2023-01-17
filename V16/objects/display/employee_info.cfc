<cfcomponent displayname="get_emp_info">
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_g_service" access="remote" returntype="void" output="yes">
		<cfargument name="employee_id" type="numeric" required="yes">
		<cfargument name="process_date" type="date" required="no">
		<cfquery name="GET_G_SERVICE" datasource="#dsn#">
		SELECT
			G_SERVICE.SERVICE_HEAD, 
			G_SERVICE.START_DATE,
			G_SERVICE.APPLY_DATE
		FROM 
			PRO_WORKS, 
			G_SERVICE, 
			EMPLOYEES	
		WHERE 
			G_SERVICE.SERVICE_ID = PRO_WORKS.SERVICE_ID AND 
			EMPLOYEES.EMPLOYEE_ID = PRO_WORKS.PROJECT_EMP_ID AND
			EMPLOYEES.EMPLOYEE_ID = #arguments.employee_id#
			<cfif isdefined('arguments.process_date')>
				AND G_SERVICE.START_DATE <= #CreateODBCDateTime(DATEADD('d',1,arguments.process_date))# AND G_SERVICE.START_DATE >= #CreateODBCDateTime(arguments.process_date)#
			</cfif>
		ORDER BY
			G_SERVICE.START_DATE,
			G_SERVICE.APPLY_DATE
		</cfquery>
		<table cellpadding="2" cellspacing="1" class="color-header">
			<tr class="color-list">
				<td height="25" colspan="4" class="txtboldblue"></td>
			</tr>
			<tr class="color-list">
				<td valign="top"><cf_get_lang dictionary_id='40816.Başvuru'></td>
				<td valign="top"><cf_get_lang dictionary_id='55434.Başvuru Tarihi'></td>
				<td valign="top"><cf_get_lang dictionary_id='49293.Kabul Tarihi'></td>
			</tr>
			<cfoutput query="GET_G_SERVICE">
			<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#SERVICE_HEAD#</td>
				<td>#APPLY_DATE#</td>
				<td>#START_DATE#</td>
			</tr>
			</cfoutput>
		</table>
	</cffunction>
	
	<cffunction name="get_work" access="public" returntype="string" output="yes">
		<cfargument name="employee_id" type="numeric" required="yes">
		<cfargument name="process_date" type="date" required="no">
		<cfquery name="GET_G_SERVICE" datasource="#dsn#">
		SELECT
			G_SERVICE.SERVICE_HEAD, 
			G_SERVICE.START_DATE,
			G_SERVICE.APPLY_DATE
		FROM 
			PRO_WORKS, 
			G_SERVICE, 
			EMPLOYEES	
		WHERE 
			G_SERVICE.SERVICE_ID = PRO_WORKS.SERVICE_ID AND 
			EMPLOYEES.EMPLOYEE_ID = PRO_WORKS.PROJECT_EMP_ID AND
			EMPLOYEES.EMPLOYEE_ID = #arguments.employee_id#
			<cfif isdefined('arguments.process_date')>
				AND G_SERVICE.START_DATE <= #CreateODBCDateTime(DATEADD('d',1,arguments.process_date))# AND G_SERVICE.START_DATE >= #CreateODBCDateTime(arguments.process_date)#
			</cfif>
		ORDER BY
			G_SERVICE.START_DATE,
			G_SERVICE.APPLY_DATE
		</cfquery>
		<table align="left">
			<tr class="color-row">
				<td valign="top" width="280">
					aaaa
				</td>
			</tr>
		</table>
		<cfreturn true>
	</cffunction>
</cfcomponent>
