<cfif isdefined("attributes.type1")><!---Yönetici Onay --->
    <cfquery name="upd_rec" datasource="#dsn#">
        UPDATE
            EMPLOYEES_EXT_WORKTIMES
        SET
            VALID_3 = 1,
            VALID_EMPLOYEE_ID_3 = #session.ep.userid#,
            VALIDDATE_3 =  #now()#
        WHERE
             SPECIAL_CODE = '#attributes.special_code_#'
    </cfquery>
</cfif>
<cfif isdefined("attributes.type2")><!---İk onay --->
    <cfquery name="upd_rec" datasource="#dsn#">
        UPDATE
            EMPLOYEES_EXT_WORKTIMES
        SET
            VALID = 1,
            VALID_EMPLOYEE_ID = #session.ep.userid#,
            VALIDDATE = #now()#
        WHERE
             SPECIAL_CODE = '#attributes.special_code_#'
    </cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=report.extra_worktimes&branch_id=#attributes.branch_id#&sal_mon=#attributes.sal_mon#&is_form_submitted=1" addtoken="no">
