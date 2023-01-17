
<!---
    File: WEX\dataservices\cfc\data_services.cfc
    Author: Workcube-Esma Uysal <esmauysal@workcube.com>
    Date: 05.05.2021
    Description: Google Api WEX Servisidir. 
    Not: Google API Key Şirket Akış parametrelerinden tanımlanır.
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction  name="get_api_key" access="public">

        <cfquery name = "get_api_key" datasource="#dsn#">
            SELECT GOOGLE_API_KEY,GOOGLE_LANGUAGE, GOOGLE_CLIENT_SECRET, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.COMPANY_ID#">
        </cfquery>

        <cfreturn get_api_key>
    </cffunction>
    
    <cffunction  name="google_control" access="public">
        <cfargument name="data">

        <cfset get_api_key = this.get_api_key()>
        <cfset get_language = get_api_key.GOOGLE_LANGUAGE>
        <cfset get_language = get_language.split("/")>
        <cfset api_lang = get_language[1]>
        <cfset lang_type = get_language[2]>
        
        <cfset data = {
            "audioConfig": {
                "audioEncoding": "LINEAR16",
                "pitch": 0,
                "speakingRate": 1
            },
            "input": {
                "text": arguments.data.input.text
            },
            "voice": {
                "languageCode": "#api_lang#",
                "name": "#lang_type#"
            }
        }>

        <cfhttp url="https://texttospeech.googleapis.com/v1beta1/text:synthesize?key=#get_api_key.GOOGLE_API_KEY#" method="post" result="httpResponse">
            <cfhttpparam type="header" name="content-type" value="text/plain">
            <cfhttpparam type="xml" name="data" value='#replace(serializeJSON(arguments.data), "//", "")#'>
        </cfhttp>

        <cfreturn replace(serializeJSON(httpResponse.filecontent), "//", "")>
    </cffunction>

    <cffunction  name="get_voices" access="public">
        <cfargument name="data">
        <cfif isdefined("arguments.data.key_val") and len(arguments.data.key_val)>
            <cfset get_api_key_ = arguments.data.key_val>
        <cfelse>
            <cfset get_api_key = this.get_api_key()>
            <cfset get_api_key_ = get_api_key.GOOGLE_API_KEY>
        </cfif>
        <cftry>
            <cfhttp url="https://texttospeech.googleapis.com/v1/voices?key=#get_api_key_#" method="get" result="httpResponse">
                <cfhttpparam type="header" name="content-type" value="text/plain">
            </cfhttp>
    
            <cfreturn httpResponse.filecontent>
        <cfcatch type="any">
            <cfreturn catch.message>
        </cfcatch>
        </cftry>
        
    </cffunction>
    
</cfcomponent>