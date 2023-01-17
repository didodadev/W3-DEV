<cfif IsDefined('attributes.title_id') and len(attributes.title_id)>
    <cfset list = attributes.title_id>
    <cfloop index = "t_id" list = #attributes.title_id#> 
        <cfquery name="ctrl_perform" datasource="#DSN#">
            SELECT
                ID
            FROM
                EMPLOYEE_PERFORMANCE_DEFINITION
            WHERE
                YEAR = #attributes.emp_perf_year#
                AND (TITLE_ID LIKE '%,#t_id#' OR TITLE_ID LIKE '#t_id#,%' OR TITLE_ID LIKE '%,#t_id#,%' OR TITLE_ID LIKE '#t_id#')
                <cfif isdefined('attributes.weight_id') and len(attributes.weight_id)>
                    AND ID <> #attributes.weight_id#
                </cfif>
                AND IS_ACTIVE = 1
        </cfquery>
        <cfif ctrl_perform.recordcount>
            <script type="text/javascript">
                alert('Bir dönem içerisinde bir ünvana birden fazla ağırlık tanımlanamaz!');
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfloop>
</cfif>

<cfif IsDefined('attributes.unit_id') and len(attributes.unit_id)>
    <cfloop index = "u_id" list = #attributes.unit_id#> 
        <cfquery name="ctrl_perform_unit" datasource="#DSN#">
            SELECT
                ID
            FROM
                EMPLOYEE_PERFORMANCE_DEFINITION
            WHERE
                YEAR = #attributes.emp_perf_year#
                AND (FUNC_ID LIKE '%,#u_id#' OR FUNC_ID LIKE '#u_id#,%' OR FUNC_ID LIKE '%,#u_id#,%' OR FUNC_ID LIKE '#u_id#')
                <cfif isdefined('attributes.weight_id') and len(attributes.weight_id)>
                    AND ID <> #attributes.weight_id#
                </cfif>
                AND IS_ACTIVE = 1
        </cfquery>
        <cfif ctrl_perform_unit.recordcount>
            <script type="text/javascript">
                alert('Bir dönem içerisinde bir fonksiyona birden fazla ağırlık tanımlanamaz!');
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfloop>
</cfif>

<cfquery name="upd_perform" datasource="#DSN#">
    UPDATE
        EMPLOYEE_PERFORMANCE_DEFINITION
    SET
        EMPLOYEE_PERFORM_WEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.emp_perf_weight#">,
        EMPLOYEE_WEIGHT = <cfif len(attributes.employee_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.employee_weight#"><cfelse>NULL</cfif>,
        CONSULTANT_WEIGHT = <cfif len(attributes.consultant_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.consultant_weight#"><cfelse>NULL</cfif>,
        COMP_TARGET_WEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.comp_targ_weight#">,
        UPPER_POSITION_WEIGHT = <cfif len(attributes.upper_position_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.upper_position_weight#"><cfelse>NULL</cfif>,
        MUTUAL_ASSESSMENT_WEIGHT = <cfif len(attributes.mutual_assessment_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.mutual_assessment_weight#"><cfelse>NULL</cfif>,
        UPPER_POSITION2_WEIGHT = <cfif len(attributes.upper_position2_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.upper_position2_weight#"><cfelse>NULL</cfif>,
        YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_perf_year#">,
        IS_ACTIVE = <cfif isdefined('attributes.is_active')><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
        IS_STAGE = <cfif isdefined('attributes.is_stage')><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
        IS_EMPLOYEE = <cfif isdefined('attributes.is_employee')><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
        IS_CONSULTANT = <cfif isdefined('attributes.is_consultant')><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
        IS_UPPER_POSITION = <cfif isdefined('attributes.is_upper_position')><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
        IS_MUTUAL_ASSESSMENT = <cfif isdefined('attributes.is_mutual_assessment')><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
        IS_UPPER_POSITION2 = <cfif isdefined('attributes.is_upper_position2')><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
        TITLE_ID = <cfif IsDefined('attributes.title_id') and len(attributes.title_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.title_id#"><cfelse>NULL</cfif>,
        FUNC_ID = <cfif IsDefined('attributes.unit_id') and len(attributes.unit_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.unit_id#"><cfelse>NULL</cfif>,
        <cfif IsDefined('attributes.comp_perf_result') and len(attributes.comp_perf_result)>COMP_PERFORM_RESULT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.comp_perf_result#">,</cfif>
        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
    WHERE
        ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.weight_id#">
</cfquery>
<script>
    location.href = document.referrer;
</script>