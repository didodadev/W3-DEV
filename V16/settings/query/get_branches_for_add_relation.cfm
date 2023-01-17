<cfsetting showdebugoutput="no">
<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
        COMPANY_ID, 
        BRANCH_ID, 
        BRANCH_NAME
    FROM 
    	BRANCH 
    WHERE 
	    COMPANY_ID = #attributes.company_id# 
    ORDER BY 
    	BRANCH_NAME
</cfquery>
<cfif get_branches.recordcount>
		<cfset mystr = '<select name="our_branch_id" style="width:180px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option>'>
		<cfloop query="get_branches">
			<cfset mystr = mystr & '<option value=#BRANCH_ID#'>
				<cfif isDefined('attributes.branch_id')>
					<cfif attributes.branch_id eq #get_branches.BRANCH_ID#>
						<cfset mystr = mystr & ' selected'>
					</cfif>
				</cfif>
			<cfset mystr = mystr & '>#BRANCH_NAME#</option>'>
		</cfloop>
		<cfset mystr = mystr & '</select>'>
<cfelse>
		<cfset mystr='<select name="our_branch_id" style="width:180px;"><option value=""><cf_get_lang_main no="322.Seçiniz"></option></select>'>
</cfif>
<cfoutput>#mystr#</cfoutput>
