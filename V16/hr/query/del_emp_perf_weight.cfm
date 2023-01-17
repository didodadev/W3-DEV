<cfif isdefined('attributes.weight_id')>
    <cfquery name="del_EMPLOYEE_PERFORMANCE_DEFINITION" datasource="#dsn#">
        DELETE FROM
            EMPLOYEE_PERFORMANCE_DEFINITION
        WHERE
            ID = #attributes.weight_id#
    </cfquery>	
</cfif>
<cflocation url="#request.self#?fuseaction=hr.emp_perf_definition" addtoken="no">
