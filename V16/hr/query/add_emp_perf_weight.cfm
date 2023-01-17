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

<cfquery name="add_perform" datasource="#DSN#">
    INSERT INTO
        EMPLOYEE_PERFORMANCE_DEFINITION
    (
        EMPLOYEE_PERFORM_WEIGHT,
        COMP_TARGET_WEIGHT,
        YEAR,
        TITLE_ID,
        FUNC_ID,
        EMPLOYEE_WEIGHT,
        CONSULTANT_WEIGHT,
        UPPER_POSITION_WEIGHT,
        MUTUAL_ASSESSMENT_WEIGHT,
        UPPER_POSITION2_WEIGHT,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        COMP_PERFORM_RESULT,
        IS_ACTIVE,
        IS_STAGE,
        IS_EMPLOYEE,
        IS_CONSULTANT,
        IS_UPPER_POSITION,
        IS_MUTUAL_ASSESSMENT,
        IS_UPPER_POSITION2
    )
    VALUES
    (
        #attributes.emp_perf_weight#,
        #attributes.comp_targ_weight#,
        #attributes.emp_perf_year#,
        <cfif isdefined('attributes.title_id') and len(attributes.title_id)>'#attributes.title_id#'<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.unit_id') and len(attributes.unit_id)>'#attributes.unit_id#'<cfelse>NULL</cfif>,
        <cfif len(attributes.employee_weight)>#attributes.employee_weight#<cfelse>NULL</cfif>,
        <cfif len(attributes.consultant_weight)>#attributes.consultant_weight#<cfelse>NULL</cfif>,
        <cfif len(attributes.upper_position_weight)>#attributes.upper_position_weight#<cfelse>NULL</cfif>,
        <cfif len(attributes.mutual_assessment_weight)>#attributes.mutual_assessment_weight#<cfelse>NULL</cfif>,
        <cfif len(attributes.upper_position2_weight)>#attributes.upper_position2_weight#<cfelse>NULL</cfif>,
        #now()#,
        #session.ep.userid#,
        '#cgi.remote_addr#',
        <cfif isdefined('attributes.comp_perf_result') and len(attributes.comp_perf_result)>#attributes.comp_perf_result#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
        <cfif isdefined('attributes.is_stage')>1<cfelse>0</cfif>,
        <cfif isdefined('attributes.is_employee')>1<cfelse>0</cfif>,
        <cfif isdefined('attributes.is_consultant')>1<cfelse>0</cfif>,
        <cfif isdefined('attributes.is_upper_position')>1<cfelse>0</cfif>,
        <cfif isdefined('attributes.is_mutual_assessment')>1<cfelse>0</cfif>,
        <cfif isdefined('attributes.is_upper_position2')>1<cfelse>0</cfif>
    )
</cfquery>
<script>
    location.href="<cfoutput>#request.self#?fuseaction=hr.emp_perf_definition</cfoutput>"
</script>
