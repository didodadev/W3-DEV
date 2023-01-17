<cfsetting showdebugoutput="no">
<cfquery name="get_branches" datasource="#DSN#">
	SELECT
		RELATED_COMPANY,
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE 
		<cfif len(attributes.b_status)>BRANCH_STATUS = #attributes.b_status# AND</cfif>
		BRANCH_ID IS NOT NULL
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #SESSION.EP.POSITION_CODE#
					)
	</cfif>
	ORDER BY
		RELATED_COMPANY,
		BRANCH_NAME
</cfquery>
<cfif get_branches.recordcount>
		<cfset mystr = '<select name="branch_id"><option value="">Şube Seçiniz</option>'>
		<cfoutput query="get_branches" group="RELATED_COMPANY">
			<cfset mystr = mystr & '<optgroup label="#RELATED_COMPANY#"></optgroup>'>
				<cfoutput>
					<cfset mystr = mystr & '<option value=#BRANCH_ID#>#BRANCH_NAME#</option>'>
				</cfoutput>
		</cfoutput>
		<cfset mystr = mystr & '</select>'>
<cfelse>
		<cfset mystr='<select name="branch_id"><option value="">Şube Seçiniz</option></select>'>
</cfif>
<cfoutput>#mystr#</cfoutput>
