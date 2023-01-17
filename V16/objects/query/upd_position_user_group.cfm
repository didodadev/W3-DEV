<cfquery name="GET_POS" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_ID=#attributes.position_id# 
</cfquery>
<cfquery name="GET_MODULE_ID" datasource="#dsn#">
	SELECT MAX(MODULE_ID) AS MODULE_ID FROM MODULES ORDER BY MODULE_ID 
</cfquery>
<cfscript>
	e_id=get_pos.EMPLOYEE_ID;
	status=1;
	old_level=GET_POS.LEVEL_ID;
	old_group=GET_POS.USER_GROUP_ID;
	
	attributes.LEVEL_ID = "";
	for (loop_level=1; loop_level lte GET_MODULE_ID.MODULE_ID; loop_level=loop_level+1)
		if (IsDefined("attributes.LEVEL_ID_#loop_level#"))
			attributes.LEVEL_ID = ListAppend(attributes.LEVEL_ID,Evaluate("attributes.LEVEL_ID_#loop_level#"));
		else
			attributes.LEVEL_ID = ListAppend(attributes.LEVEL_ID,0);
</cfscript>
<cfif get_pos.employee_id eq attributes.employee_id>
	<cfif session.ep.ehesap>
		<cfquery name="UPD_POSITION" datasource="#dsn#">
				UPDATE
					EMPLOYEE_POSITIONS
				SET
					<cfif len(attributes.GROUP_ID)>	
						USER_GROUP_ID=#attributes.GROUP_ID#,
						LEVEL_ID=NULL
					<cfelse>
						LEVEL_ID = '#attributes.LEVEL_ID#',
						USER_GROUP_ID = NULL
					</cfif>
				WHERE 
					POSITION_ID = #attributes.position_id#
		</cfquery>
	</cfif>
	<!--- kullanıcı yetki seviyesi değişti ise kullanıcıyı sistemden at --->
	<cfif get_workcube_app_user(e_id, 0).recordcount and ((attributes.LEVEL_ID neq old_level) or (attributes.GROUP_ID neq old_group))>
		<cfquery name="del_wrk_app" datasource="#dsn#">
			DELETE FROM WRK_SESSION WHERE USERID = #e_id# AND USER_TYPE = 0
		</cfquery>
	</cfif>
	<cflocation url="#cgi.http_referer#" addtoken="No">
</cfif>
<cfif get_workcube_app_user(e_id, 0).recordcount and ((attributes.LEVEL_ID neq old_level) or (attributes.GROUP_ID neq old_group))>
	<cfquery name="del_wrk_app" datasource="#dsn#">
		DELETE FROM WRK_SESSION WHERE USERID = #e_id# AND USER_TYPE = 0
	</cfquery>
</cfif>
<cflocation url="#cgi.http_referer#" addtoken="No">
