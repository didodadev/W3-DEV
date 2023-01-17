<cfquery name="DELETE_DEBT_CLOSED_DEFINITION" datasource="#dsn2#">
   DELETE ACCOUNT_CLOSED_DEFINITION WHERE CLOSED_TYPE = 0
</cfquery>
<cfloop from="1" to="#attributes.row_count_debt_exit#" index="i">
	<cfdump var="#attributes['row_kontrol_exit#i#']#"/>
	<cfif attributes["row_kontrol_exit#i#"] eq 1>
        <cfquery name="INSERT_DEBT_CLOSED_DEFINITION" datasource="#dsn2#">
            INSERT INTO
            	ACCOUNT_CLOSED_DEFINITION
            	(
                    DEBT_ACCOUNT_CODE,
                    CLOSED_ACCOUNT_CODE,
                    CLOSED_TYPE,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
            	)
            VALUES
            	(
                    <cfqueryparam cfsqltype="cf_sql_varchar" value='#evaluate("attributes.DEBT_ACCOUNT_ID#i#")#'>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value='#evaluate("attributes.DEBT_CLOSED_ACCOUNT_ID#i#")#'>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="0"/>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(Now())#"/>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#"/>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERID#"/>
            	)
        </cfquery>
   	 </cfif>
    </cfloop>
  
<cfloop from="1" to="#attributes.row_count_claim_exit#" index="i">
	<cfif attributes["row_kontrol_exit_claim#i#"] eq 1> 
		<cfquery name="INSERT_CLAIM_CLOSED_DEFINITION" datasource="#dsn2#">
            INSERT INTO
                ACCOUNT_CLOSED_DEFINITION
                (
                    CLAIM_ACCOUNT_CODE,
                    CLOSED_ACCOUNT_CODE,
                    CLOSED_TYPE,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value='#evaluate("attributes.CLAIM_ACCOUNT_ID#i#")#'>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value='#evaluate("attributes.CLAIM_CLOSED_ACCOUNT_ID#i#")#'>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="0"/>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(Now())#"/>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#"/>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERID#"/>
                )
    	</cfquery>
	</cfif>
  </cfloop>
<cflocation url="#request.self#?fuseaction=account.account_closed_definition" addtoken="no"> 



	










