<cfquery name="del_acc_refl_def" datasource="#dsn2#">
    DELETE FROM    	
        ACCOUNT_CLOSED_DEFINITION
    WHERE
        CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">        
</cfquery>
<cfloop from="1" to="#attributes.rowCount1#" index="i">
	<cfif isdefined("attributes.acc_code1_closed_#i#") and len(evaluate('attributes.acc_code1_closed_#i#'))>
        <cfquery name="ins_acc_refl_def" datasource="#dsn2#">
            INSERT INTO
                ACCOUNT_CLOSED_DEFINITION
                (
                    CLOSED_ACCOUNT_CODE,
                    DEBT_ACCOUNT_CODE,
                    CLAIM_ACCOUNT_CODE,
                    CLOSED_TYPE,
                    UPDATE_DATE,
                    UPDATE_IP,
                    UPDATE_EMP,
                    INCOME
                )
            VALUES
                (
                    <cfif len(#evaluate('attributes.acc_code1_closed_#i#')#)><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.acc_code1_closed_#i#')#"><cfelse>NULL</cfif>,
                    <cfif len(#evaluate('attributes.acc_code1_debt_#i#')#)><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.acc_code1_debt_#i#')#"><cfelse>NULL</cfif>,
                    <cfif len(#evaluate('attributes.acc_code1_claim_#i#')#)><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.acc_code1_claim_#i#')#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                )    
        </cfquery>
    </cfif>
</cfloop>
<cfloop from="1" to="#attributes.rowCount2#" index="j">
	<cfif isdefined("attributes.acc_code2_claim_#j#") and len(evaluate('attributes.acc_code2_claim_#j#'))>
        <cfquery name="ins_acc_closed_def" datasource="#dsn2#">
            INSERT INTO
                ACCOUNT_CLOSED_DEFINITION
                (
                    CLOSED_ACCOUNT_CODE,
                    DEBT_ACCOUNT_CODE,
                    CLAIM_ACCOUNT_CODE,
                    CLOSED_TYPE,
                    UPDATE_DATE,
                    UPDATE_IP,
                    UPDATE_EMP,
                    INCOME
                )
            VALUES
                (
					NULL,
                    <cfif len(#evaluate('attributes.acc_code2_debt_#j#')#)><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.acc_code2_debt_#j#')#"><cfelse>NULL</cfif>,
                    <cfif len(#evaluate('attributes.acc_code2_claim_#j#')#)><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.acc_code2_claim_#j#')#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                )    
        </cfquery>
    </cfif>
</cfloop>

<cfloop from="1" to="#attributes.rowCount3#" index="j">
	<cfif isdefined("attributes.acc_code3_claim_#j#") and len(evaluate('attributes.acc_code3_claim_#j#'))>
        <cfquery name="ins_acc_closed_def_new" datasource="#dsn2#">
            INSERT INTO
                ACCOUNT_CLOSED_DEFINITION
                (
                    CLOSED_ACCOUNT_CODE,
                    DEBT_ACCOUNT_CODE,
                    CLAIM_ACCOUNT_CODE,
                    CLOSED_TYPE,
                    UPDATE_DATE,
                    UPDATE_IP,
                    UPDATE_EMP,
                    INCOME
                )
            VALUES
                (
					NULL,
                    <cfif len(#evaluate('attributes.acc_code3_debt_#j#')#)><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.acc_code3_debt_#j#')#"><cfelse>NULL</cfif>,
                    <cfif len(#evaluate('attributes.acc_code3_claim_#j#')#)><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.acc_code3_claim_#j#')#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                )    
        </cfquery>
    </cfif>
</cfloop>
<cflocation url="#request.self#?fuseaction=account.form_add_reflecting_acc_def" addtoken="no">

