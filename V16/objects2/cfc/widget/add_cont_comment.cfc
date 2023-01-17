<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cffunction name="add_comment" access="remote" returntype="string" returnargumentsat="json">
        <cftry>       
            <cfquery name="ADD_COMMENT" datasource="#DSN#" result="MAX_ID">

                INSERT INTO CONTENT_COMMENT 
                (
                    CONTENT_ID,
                    CONTENT_COMMENT,
                    CONTENT_COMMENT_POINT,
                    PARTNER_ID,
                    CONSUMER_ID,
                    GUEST,
                    NAME,
                    SURNAME,
                    STAGE_ID,
                    MAIL_ADDRESS,		
                    RECORD_DATE,
                    RECORD_IP
                )
            VALUES
                (
                    #arguments.content_id#,
                    '#arguments.content_comment#',
                    <cfif isdefined('arguments.content_comment_point') and len(arguments.content_comment_point)>#arguments.content_comment_point#,<cfelse>5,</cfif>
                    <cfif isdefined('arguments.member_type') and arguments.member_type eq 2>
                        #arguments.member_id#,
                    <cfelseif isdefined('session.pp.userid')>
                        #session.pp.userid#,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif isdefined('arguments.member_type') and arguments.member_type eq 1>
                        #arguments.member_id#,
                    <cfelseif isdefined('session.ww.userid')>
                        #session.ww.userid#,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif not isdefined('member_type') or not isdefined("session.ww.userid")>1,<cfelse>0,</cfif>					
                    '#arguments.name#',
                    '#arguments.surname#',
                    -2,				
                    <cfif isDefined('arguments.mail_address') and len(arguments.mail_address)>'#arguments.mail_address#'<cfelse>NULL</cfif>,				
                    #NOW()#,
                    '#CGI.REMOTE_ADDR#'
                )


            </cfquery>            
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">            
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>


   
</cfcomponent>