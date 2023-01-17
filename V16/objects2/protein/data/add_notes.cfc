<!--- 
    Author: Melek KOCABEY
    Date:   13/11/2021
    Desc:   NOTLAR widgettı cfc dosyasıdır ve session da ki kullanıcı ya göre kontrol...
--->
<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn=application.systemParam.systemParam().dsn>
<cffunction name="add_notes" access="remote" returntype="string" returnargumentsat="json">
        <cfset result = StructNew()>
        <cftry>       
            <cfquery name="add_notes" datasource="#DSN#" result="MAX_ID">
                INSERT INTO 
                    VISITING_NOTES
                        (
                            NOTE_GIVEN,
                            NOTE_TAKEN_TYPE,
                            NOTE_TAKEN_ID,
                            DETAIL,
                            TEL,
                            EMAIL,
                            RECORD_EMP,
                            RECORD_PAR,
                            RECORD_CON,
                            RECORD_DATE,
                            RECORD_IP,
                            IS_HOMEPAGE,
                            IS_INTERNET
                        )
                    VALUES
                        (
                            <cfif isdefined("arguments.member") and len(arguments.member)>'#arguments.member#',<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.member_visited_type") and len(arguments.member_visited_type)>#arguments.member_visited_type#,<cfelse>NULL,</cfif>
                            <cfif isdefined("arguments.member_visited_id") and len(arguments.member_visited_id)>#arguments.member_visited_id#,<cfelse>NULL,</cfif>
                            <cfif len(arguments.detail)>'#arguments.detail#',<cfelse>NULL,</cfif>
                            '#arguments.tel#',
                            '#arguments.email#',
                            <cfif isdefined("session.ep.userid") and len(session.ep.userid)>#session.ep.userid#,<cfelse>null,</cfif>
                            <cfif isdefined("session.pp.userid") and len(session.pp.userid)>#session.pp.userid#,<cfelse>null,</cfif>
                            <cfif isdefined("session.ww.userid") and len(session.ww.userid)>#session.ww.userid#,<cfelse>null,</cfif>
                            #now()#,
                            '#cgi.remote_addr#',
                            1,
                            1
                        )
            </cfquery>            
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <cfset result.identity = arguments.iid>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
                <cfdump var ="#result.error#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>