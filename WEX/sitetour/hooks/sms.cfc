<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- Şİrketin entegrasyon bilgilerini getirir ve operatöre göre cfc'ye yönlendirir. --->
    <cffunction name="send_sms" access="public">
        <cfargument name="data">
        <cfquery name="getSmsInformations" datasource="#dsn#">
            SELECT IS_SMS, SMS_COMPANY FROM OUR_COMPANY_INFO WHERE OUR_COMPANY_INFO.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value='#iif(isdefined("arguments.data.comp_id"),"arguments.data.comp_id","session.ep.company_id")#'>
        </cfquery>
        <cfif len(getSmsInformations.SMS_COMPANY) and getSmsInformations.SMS_COMPANY eq 5 and getSmsInformations.IS_SMS eq 1>
            <cfobject type="component" name="datalayer" component="WEX.cti.cfc.verimor">
            <cfset uuid = datalayer.send_sms(iif(isdefined('arguments.data.comp_id'),'arguments.data.comp_id','session.ep.company_id'), arguments.data.tel, arguments.data.message, iif(isdefined('arguments.data.send_at'),'arguments.data.send_at',DE('')), iif(isdefined('arguments.data.valid_for'),'arguments.data.valid_for',DE('')), iif(isdefined('arguments.data.source_addr'),'arguments.data.source_addr',DE('')), iif(isdefined('arguments.data.custom_id'),'arguments.data.custom_id',DE('')))>
            <cfreturn uuid>
        </cfif>
        <cfreturn "No">
    </cffunction>
</cfcomponent>