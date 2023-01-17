<cftransaction>

    <cfquery name="UPDATE_REFINERY_TEST" datasource="#dsn#">
        UPDATE REFINERY_TEST
        SET
            TEST_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.testName#">,
            TEST_COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.testComment#">,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_DATE = #now()#,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
        WHERE REFINERY_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.refinery_test_id#">
    </cfquery>

    <cfif attributes.parameterCountSave gt 0>
        <cfloop index="i" from="1" to="#attributes.parameterCountSave#">
            <cfquery name="UPD_PARAMETERS" datasource="#dsn#">
                <cfif len( evaluate("attributes.parameterTestRowId#i#"))>
                    <cfif evaluate("attributes.rowDeleted#i#") eq 0>
                        UPDATE REFINERY_TEST_ROWS
                        SET
                            GROUP_ID = <cfif len(evaluate("attributes.groupId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.groupId#i#")#"><cfelse>NULL</cfif>,
                            PARAMETER_ID = <cfif len(evaluate("attributes.parameterId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.parameterId#i#")#"><cfelse>NULL</cfif>,
                            MIN_LIMIT = <cfif len(evaluate("attributes.minLimit#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.minLimit#i#")#"><cfelse>NULL</cfif>,
                            MAX_LIMIT = <cfif len(evaluate("attributes.maxLimit#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.maxLimit#i#")#"><cfelse>NULL</cfif>,
                            TEST_METHOD_ID = <cfif len(evaluate("attributes.methodId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.methodId#i#")#"><cfelse>NULL</cfif>,
                            UNIT_ID = <cfif len(evaluate("attributes.unitId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.unitId#i#")#"><cfelse>NULL</cfif>
                        WHERE PARAMETER_TEST_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.parameterTestRowId#i#")#">
                    <cfelse>
                        DELETE FROM REFINERY_TEST_ROWS WHERE PARAMETER_TEST_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.parameterTestRowId#i#")#">
                    </cfif>
                <cfelse>
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
                            #attributes.refinery_test_id#,
                            <cfif len(evaluate("attributes.groupId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.groupId#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.parameterId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.parameterId#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.minLimit#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.minLimit#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.maxLimit#i#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.maxLimit#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.methodId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.methodId#i#")#"><cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.unitId#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.unitId#i#")#"><cfelse>NULL</cfif>
                        )
                </cfif>
            </cfquery>
        </cfloop>
    </cfif>

</cftransaction>

<cfset attributes.actionid = attributes.refinery_test_id />