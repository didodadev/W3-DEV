<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
        <cfquery name="del_company_partner" datasource="#dsn#">
            DELETE FROM COMPANY_PARTNER WHERE COMPANY_ID = #attributes.cpid#
        </cfquery>
    
        <cfloop from="1" to="#attributes.record#" index="i">
            <cfquery name="add_workgroup_emp_par" datasource="#DSN#">
              INSERT INTO COMPANY_PARTNER
                 (
                    COMPANY_ID,
                    COMPANY_PARTNER_NAME,
                    COMPANY_PARTNER_SURNAME,
                    TITLE,
                    <!---MISSION,--->
                    DEPARTMENT,
                    SEX,
                    TC_IDENTITY,
                    MOBIL_CODE,
                    MOBILTEL,
                    COMPANY_PARTNER_EMAIL,
                    RECORD_DATE,
                    RECORD_MEMBER,
                    RECORD_IP
                 )
                 VALUES
                 (
                    <cfif len(attributes.cpid)>#attributes.cpid#</cfif>,
                    <cfif isdefined('attributes.name#i#') and len(evaluate("attributes.name#i#"))>'#wrk_eval("attributes.name#i#")#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.surname#i#') and len(evaluate("attributes.surname#i#"))>'#wrk_eval("attributes.surname#i#")#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.title#i#') and len(evaluate("attributes.title#i#"))>'#wrk_eval("attributes.title#i#")#'<cfelse>NULL</cfif>,
                    <!---<cfif isdefined('attributes.mission#i#') and len(evaluate("attributes.mission#i#"))>#evaluate("attributes.mission#i#")#<cfelse>NULL</cfif>,--->
                    <cfif isdefined('attributes.department#i#') and len(evaluate("attributes.department#i#"))>#evaluate("attributes.department#i#")#<cfelse>NULL</cfif>,
                    #evaluate("attributes.sex#i#")#,
                    <cfif isdefined('attributes.identity_no#i#') and len(evaluate("attributes.identity_no#i#"))>#evaluate("attributes.identity_no#i#")#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.mobilcat_id_partner#i#') and len(evaluate("attributes.mobilcat_id_partner#i#"))>#evaluate("attributes.mobilcat_id_partner#i#")#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.mobiltel_partner#i#') and len(evaluate("attributes.mobiltel_partner#i#"))>#evaluate("attributes.mobiltel_partner#i#")#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.email#i#') and len(evaluate("attributes.email#i#"))>'#wrk_eval("attributes.email#i#")#'<cfelse>NULL</cfif>,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#'
                 )
            </cfquery> 
        </cfloop>
    </cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#attributes.cpid#" addtoken="no">
