<cfquery name="GET_BRANCH" datasource="#dsn#">
    SELECT 
		COMPBRANCH__NAME,
		COMPBRANCH_ID,
		COMPBRANCH_TELCODE,
		COMPBRANCH_TEL1,
		COMPBRANCH_EMAIL
	FROM 
		COMPANY_BRANCH 	C 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	ORDER BY
		COMPBRANCH__NAME
</cfquery>
<cf_flat_list>
	<cfif get_branch.recordcount>
        <cfoutput query="get_branch">
			<tr>
				<td>#compbranch__name#</td>
			</tr>
        </cfoutput>
	<cfelse>
		<tr>
			<td><cf_get_lang dictionary_id="57484.Kayıt Yok"></td>
		</tr>
	</cfif>
</cf_flat_list>

