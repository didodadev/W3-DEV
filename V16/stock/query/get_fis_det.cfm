 <cfquery name="GET_FIS_DET" datasource="#DSN2#">
	SELECT 
		STOCK_FIS.*,
		STOCK_FIS_ROW.* 
	FROM 
		STOCK_FIS,
		STOCK_FIS_ROW
	WHERE 
		STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
		STOCK_FIS.FIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#">
		<cfif session.ep.isBranchAuthorization>
            AND 
            (
                STOCK_FIS.DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">) OR
                STOCK_FIS.DEPARTMENT_OUT IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
            )		
        </cfif>				
</cfquery>

