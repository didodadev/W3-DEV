<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Şirketin Sendgrid bilgileri --->
    <cffunction name="getSendGridInformations" returntype="query" access="public">
        <cfquery name="getSendGridInformations" datasource="#dsn#">
            SELECT IS_SENDGRID_INTEGRATED, MAIL_API_KEY, SENDER_MAIL, SENDGRID_GROUP_ID FROM OUR_COMPANY_INFO WHERE OUR_COMPANY_INFO.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
        </cfquery>
        <cfreturn getSendGridInformations>
    </cffunction>
    <cfset getSendgridInformations = getSendGridInformations()>
    <cffunction name="report" returntype="any" access="public">
        <cfargument name="end_date" type="any" default="2021-04-17">
        <cfargument name="start_date" type="any" default="2021-03-17">
        <cfargument name="aggregated_by" type="any" default="month">
        <cfhttp result="result" method="GET" charset="utf-8" url="https://api.sendgrid.com/v3/stats?end_date=#arguments.end_date#&start_date=#arguments.start_date#&aggregated_by=#arguments.aggregated_by#">
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <cffunction name="templates" returntype="any" access="public">
        <cfhttp result="result" method="GET" charset="utf-8" url="https://api.sendgrid.com/v3/templates?generations=legacy%2Cdynamic">              
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <cffunction name="create_template" returntype="any" access="public">
        <cfargument name="data" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/templates">           
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam type="xml" name="message" value="#replace(serializeJSON(arguments.data), "//", "")#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <cffunction name="versions" returntype="any" access="public">
        <cfargument name="template_id" type="any" default="">
        <cfargument name="data" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/templates/#arguments.template_id#/versions">              
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam type="xml" name="message" value="#replace(serializeJSON(arguments.data), "//", "")#">    
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <cffunction name="create_list" returntype="any" access="public">
        <cfargument name="name" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/contactdb/lists">
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam name="name" type="formfield" value="#arguments.name#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <cffunction name="recipients" returntype="any" access="public">
        <cfargument name="data" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/contactdb/recipients">
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#"><cfhttpparam name="data" type="formfield" value="#arguments.data#">
            <cfhttpparam type="xml" name="message" value="#replace(serializeJSON(arguments.data), "//", "")#">          
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <cffunction name="lists" returntype="any" access="public">
        <cfargument name="list_id" type="any" default="">
        <cfargument name="recipient_list" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/contactdb/lists/#arguments.list_id#/recipients">
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam type="xml" name="message" value="#replace(serializeJSON(arguments.recipient_list), "//", "")#">    
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <cffunction name="campaigns" returntype="any" access="public">
        <cfargument name="data" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/campaigns">
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam name="name" type="formfield" value="#arguments.data#">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Kampanyayı listeye gönder --->
    <cffunction name="send_camp" returntype="any" access="public">
        <cfargument name="campaign_id" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/campaigns/#arguments.campaign_id#/schedules/now">
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam name="data" type="formfield" value="">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!---  Kampanyayı sil --->
    <cffunction name="del_camp" returntype="any" access="public">
        <cfargument name="campaign_id" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/campaigns/#arguments.campaign_id#">
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam name="data" type="formfield" value="">
        </cfhttp> 
        <cfreturn result.Filecontent>
    </cffunction>
    <!--- Göndericileri listeler --->
    <cffunction name="senders" returntype="any" access="public">
        <cfargument name="key" type="any" default="">
        <cfhttp result="result" method="GET" charset="utf-8" url="https://api.sendgrid.com/v3/senders">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #arguments.key#">
        </cfhttp> 
        <cfreturn result>
    </cffunction>
    <cffunction name="send_mail" returntype="any" access="public">
        <cfargument name="data" type="any" default="">
        <cfhttp result="result" method="POST" charset="utf-8" url="https://api.sendgrid.com/v3/marketing/test/send_email">
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam type="xml" name="message" value="#replace(serializeJSON(arguments.data), "//", "")#">    
        </cfhttp> 
        <cfreturn replace(serializeJSON(result), "//", "")>
    </cffunction>
    <cffunction name="send_mail_content" returntype="any" access="public" >
        <cfargument name="data" type="any" default="">
        <cfhttp result="result" method="post" charset="utf-8" url="https://api.sendgrid.com/v3/mail/send" >
            <cfhttpparam type="HEADER" name="Content-Type" value="application/json; charset=utf-8">
            <cfhttpparam name="authorization" type="HEADER" value="Bearer #getSendgridInformations.MAIL_API_KEY#">
            <cfhttpparam type="xml" name="message" value="#replace(serializeJSON(arguments.data), "//", "")#">          
        </cfhttp> 
        <cfreturn replace(serializeJSON(result), "//", "")>
    </cffunction>
</cfcomponent>
