<!--- Web Servis Hata Kayıtlarını WEB_SERVICE_ERROR_LOG Tablosuna Kayıt Atan Fonksiyon EE 20151103
action_name     : Web Servis İşlem Adı(Geliştirici Kendi Belirler.) - Zorunlu Değil
action_id       : Web Servis İşlem id'si - Zorunlu Değil
error_text      : Web Servisden Dönen Hata Mesajı - Zorunlu
web_service_url : Kullanılan Web Servis Url'i(Adresi) - Zorunlu
record_emp      : Kaydeden Workcube Kullanıcı Id - Zorunlu Değil--->
<cfcomponent>
	<cffunction name="add_ws_errorlog" access="public">
    	<cfargument name="action_name" type="string" required="no" default="">
        <cfargument name="action_id" type="numeric" required="no" default="">
        <cfargument name="error_text" type="string" required="yes" default="">
        <cfargument name="web_service_url" type="string" required="yes">
        <cfargument name="record_emp" type="numeric" required="no">

        <cftry>
			<cfif isdefined("arguments.record_emp")>
                <cfset userid = arguments.record_emp>
            <cfelseif isdefined("session.ep.userid")>
                <cfset userid = session.ep.userid>
            </cfif>
            <cfquery name="add_error_log" datasource="#this.dsn#">
                INSERT INTO 
                	WEB_SERVICE_ERROR_LOG 
                (
                	ACTION_NAME,
                    ACTION_ID, 
                    ERROR_TEXT,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    WEB_SERVICE_URL
                 )
                VALUES 
                (
                	<cfif isdefined("arguments.action_name")>'#arguments.action_name#'<cfelse>NULL</cfif>,
                	<cfif isdefined("arguments.action_id")>#arguments.action_id#<cfelse>NULL</cfif>,
                	'#arguments.error_text#',
                	#now()#,
                	#userid#,
                	'#cgi.remote_addr#',
                	'#arguments.web_service_url#'
               	)
            </cfquery>
        <cfcatch type="any">
    		<cfoutput>Web Servis Hata Kaydı Yapılamadı.Lütfen Fonksiyon Parametrelerinizi Kontrol Ediniz!</cfoutput>
		</cfcatch>   
        </cftry>
    </cffunction>
</cfcomponent>
