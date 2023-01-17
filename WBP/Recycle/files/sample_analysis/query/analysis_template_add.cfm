<cftransaction>

    <cfquery name="INSERT_REFINERY_TEST" datasource="#dsn#" result="result">
        INSERT INTO
            REFINERY_TEST
            (
                TEST_NAME,
                TEST_COMMENT,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP,
                OUR_COMPANY_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.testName#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.testComment#">,
                #session.ep.userid#,
                #now()#,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            )
    </cfquery>

    <cfif attributes.parameterCountSave gt 0>
        <cfloop index="i" from="1" to="#attributes.parameterCountSave#">
            <cfif evaluate("attributes.rowDeleted#i#") eq 0>
                <cfquery name="UPD_PARAMETERS" datasource="#dsn#">
                    INSERT INTO
                        REFINERY_TEST_ROWS
                        (
                            PARAMETER_TEST_ID,
                            GROUP_ID,
                            PARAMETER_ID,
                            MIN_LIMIT,
                            MAX_LIMIT,
                            TEST_METHOD_ID,
                            UNIT_ID
                        )
                        VALUES
                        (
                            #result.identitycol#,
                            <cfif len(evaluate("attributes.groupId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.groupId#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.parameterId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.parameterId#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.minLimit#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.minLimit#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.maxLimit#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.maxLimit#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.methodId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.methodId#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.unitId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.unitId#i#")#"><cfelse>NULL</cfif>
                        )
                </cfquery>
            </cfif>
        </cfloop>
    </cfif>

</cftransaction>

<cfset attributes.actionid = result.identitycol />