<!---
    File: V16\hr\query\add_iam.cfm
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 23.09.2021
    Description: Add iam
--->
<!---
    File: WEX\dataservices\cfc\control_worktips.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 18.03.2021
    Description: WEX'te tanımlı data servis
    Worktipsler Wex Control
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction  name="add_iam" access="public"  returntype="any">
        
        <cfargument name="username" type="any" default="" hint="Iam User Username">
        <cfargument name="member_name" type="any" default="" hint="Iam User Member Name">
        <cfargument name="member_sname" type="any" default="" hint="Iam User Member Surname">
        <cfargument name="password" type="any" default="" hint="Iam User Password">
        <cfargument name="pr_mail" type="any" default="" hint="Iam User First Email">
        <cfargument name="sec_mail" type="any" default="" hint="Iam User Second Email">
        <cfargument name="mobile_code" type="any" default="" hint="Iam User Mobil Phone Code">
        <cfargument name="mobile_no" type="any" default="" hint="Iam User Mobil Phone">
        <cfargument name="is_add" type="any" default="1" hint="is add page">

        <cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />
        <cfif arguments.is_add eq 1>
            <cfhttp url="https://networg.workcube.com/wex.cfm/iam/ADD_IAM_REMOTE" result="result" charset="utf-8">
                <cfhttpparam name="iam_active" type="formfield" value="1">
                <cfhttpparam name="username" type="formfield" value="#arguments.username#">
                <cfhttpparam name="member_name" type="formfield" value="#arguments.member_name#">
                <cfhttpparam name="member_sname" type="formfield" value="#arguments.member_sname#">
                <cfhttpparam name="password" type="formfield" value="#arguments.password#">
                <cfhttpparam name="pr_mail" type="formfield" value="#arguments.pr_mail#">
                <cfhttpparam name="sec_mail" type="formfield" value="#arguments.sec_mail#">
                <cfhttpparam name="mobile_code" type="formfield" value="#arguments.mobile_code#">
                <cfhttpparam name="mobile_no" type="formfield" value="#arguments.mobile_no#">
                <cfhttpparam name="domain_" type="formfield" value="#cgi.HTTP_HOST#">
                <cfhttpparam name="company_id_" type="formfield" value="#session.ep.company_id#">
                <cfhttpparam name="comp_id_" type="formfield" value="#workcube_license.WORKCUBE_PARTNER_COMPANY_ID#">
                <cfhttpparam name="user_comp_name_" type="formfield" value="#session.ep.company#">
                <cfhttpparam name="subscription_no_" type="formfield" value="#workcube_license.WORKCUBE_ID#">
            </cfhttp>
        <cfelse>
            <cfhttp url="https://networg.workcube.com/wex.cfm/iam/GET_IAM_REMOTE" result="result" charset="utf-8">
                <cfhttpparam name="username" type="formfield" value="#arguments.username#">
                <cfhttpparam name="member_name" type="formfield" value="#arguments.member_name#">
                <cfhttpparam name="member_sname" type="formfield" value="#arguments.member_sname#">
            </cfhttp>

            <cfset result_data = deserializeJSON(result.filecontent)>

            <cfif arrayLen(result_data) eq 0>
                <cfhttp url="https://networg.workcube.com/wex.cfm/iam/ADD_IAM_REMOTE" result="result" charset="utf-8">
                    <cfhttpparam name="iam_active" type="formfield" value="1">
                    <cfhttpparam name="username" type="formfield" value="#arguments.username#">
                    <cfhttpparam name="member_name" type="formfield" value="#arguments.member_name#">
                    <cfhttpparam name="member_sname" type="formfield" value="#arguments.member_sname#">
                    <cfhttpparam name="password" type="formfield" value="#arguments.password#">
                    <cfhttpparam name="pr_mail" type="formfield" value="#arguments.pr_mail#">
                    <cfhttpparam name="sec_mail" type="formfield" value="#arguments.sec_mail#">
                    <cfhttpparam name="mobile_code" type="formfield" value="#arguments.mobile_code#">
                    <cfhttpparam name="mobile_no" type="formfield" value="#arguments.mobile_no#">
                    <cfhttpparam name="domain_" type="formfield" value="#cgi.HTTP_HOST#">
                    <cfhttpparam name="company_id_" type="formfield" value="#session.ep.company_id#">
                    <cfhttpparam name="comp_id_" type="formfield" value="#workcube_license.WORKCUBE_PARTNER_COMPANY_ID#">
                    <cfhttpparam name="user_comp_name_" type="formfield" value="#session.ep.company#">
                    <cfhttpparam name="subscription_no_" type="formfield" value="#workcube_license.WORKCUBE_ID#">
                </cfhttp>
            <cfelse>
                <cfhttp url="https://networg.workcube.com/wex.cfm/iam/UPD_IAM" result="result" charset="utf-8">
                    <cfhttpparam name="iam_active" type="formfield" value="1">
                    <cfhttpparam name="username" type="formfield" value="#arguments.username#">
                    <cfhttpparam name="member_name" type="formfield" value="#arguments.member_name#">
                    <cfhttpparam name="member_sname" type="formfield" value="#arguments.member_sname#">
                    <cfhttpparam name="password" type="formfield" value="#arguments.password#">
                    <cfhttpparam name="pr_mail" type="formfield" value="#arguments.pr_mail#">
                    <cfhttpparam name="sec_mail" type="formfield" value="#arguments.sec_mail#">
                    <cfhttpparam name="mobile_code" type="formfield" value="#arguments.mobile_code#">
                    <cfhttpparam name="mobile_no" type="formfield" value="#arguments.mobile_no#">
                    <cfhttpparam name="domain_" type="formfield" value="#cgi.HTTP_HOST#">
                    <cfhttpparam name="company_id_" type="formfield" value="#session.ep.company_id#">
                    <cfhttpparam name="comp_id_" type="formfield" value="#workcube_license.WORKCUBE_PARTNER_COMPANY_ID#">
                    <cfhttpparam name="user_comp_name_" type="formfield" value="#session.ep.company#">
                    <cfhttpparam name="subscription_no_" type="formfield" value="#workcube_license.WORKCUBE_ID#">
                    <cfhttpparam name="iam_id" type="formfield" value="#result_data[1].IAM_ID#">
                    <cfhttpparam name="is_employee_record" type="formfield" value="1">
                </cfhttp>
            </cfif>
        </cfif>
        <cfreturn 1>
    </cffunction>

    <cffunction  name="GET_EMP_INFO_" access="public"  returntype="any">
        <cfargument name="userid" type="any" default="" hint="Iam User Username">
        <cfquery name="GET_EMP_INFO" datasource="#dsn#" result="result">
            SELECT
                E.EMPLOYEE_EMAIL,
                ED.EMAIL_SPC,
                MOBILCODE_SPC,
                MOBILTEL_SPC,
                MOBILCODE,
                MOBILTEL,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
            FROM
                EMPLOYEES E
                LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
            WHERE
                E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
        </cfquery>
        <cfreturn GET_EMP_INFO>
    </cffunction>
</cfcomponent>