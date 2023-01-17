<cfcomponent extends="cfc.queryJSONConverter">

    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" /> 

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>

    <cffunction name="GET_TEMPLATES" access="public" returntype="query" hint="wo ile ilişkili şablonları listeler">
        <cfargument name="RELATED_WO" required="true" type="string" hint="bağlı wo fuseaction'u">
        <cfargument name="TEMPLATE" defalut="">
        <cfquery name="GET_TEMPLATES" datasource="#dsn#">
            SELECT
                WRK_OUTPUT_TEMPLATE_ID, 
                WRK_OUTPUT_TEMPLATE_NAME,
                OUTPUT_TEMPLATE_DETAIL,
                RELATED_WO,
                OUTPUT_TEMPLATE_PATH,
                IS_ACTIVE
            FROM 
                WRK_OUTPUT_TEMPLATES
            WHERE
                RELATED_WO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%#RELATED_WO#%'>
                <cfif isdefined("TEMPLATE") and len(TEMPLATE)>
                    AND WRK_OUTPUT_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value='#TEMPLATE#'>
                </cfif>
        </cfquery>
        <cfreturn GET_TEMPLATES>
    </cffunction>

    <cffunction name="SHARE" access="remote" returntype="string" returnformat="json">
        <cfargument name="TEMPLATE" required="true" hint="template id">
        <cfargument name="woc_token" defalut="action type action id ilişkili wo bilgisi verir">
        <cftry>
            <cfset send_woc = deserializeJSON(decrypt(arguments.woc_token,'w3woc','CFMX_COMPAT','Hex'))>
            <cfset TEMPLATE = GET_TEMPLATES(RELATED_WO:send_woc.RW, TEMPLATE:TEMPLATE)>
            
            <!--- Klasor Konrolu BEGIN --->       
                <cfdirectory action="list" directory="#application.systemParam.systemParam().INDEX_FOLDER#/src" recurse="false" name="folders">
                <cfquery dbtype="query" name="find_folder">
                    SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = 'reserve_files'
                </cfquery>
                <cfif find_folder.RecordCount neq 1>
                    <cfdirectory action="create" directory="#application.systemParam.INDEX_FOLDER#/src/reserve_files" name="create_folder">
                </cfif>
            <!--- Klasor Konrolu END --->

            <!--- FILE NAME --->
            <cfset doc_name = GET_TEMPLATES.OUTPUT_TEMPLATE_PATH>
            <cfset doc_name = replacelist(lcase(doc_name),"/,*, ,',ğ,ü,ş,ö,ç,ı,İ,:,;,_,.,!,?","-,x,-,-,g,u,s,o,c,i,I,-,-,-,-,-,-")>
            <cfset doc_name = replace("#doc_name#-","--","","all")>
            <cfset doc_name = replace(doc_name,",","-","all")>
            <cfset doc_name = replace(doc_name,"--","-","all")>
            <cfset doc_name = replace(doc_name,"--","-","all")>
            <cfset doc_name = replace(doc_name,"--","","all")>  
            <cfset doc_name = replace("#doc_name#-","--","","all")>
            <cfset doc_name = "#doc_name#-#encrypt("woc",rand(),"CFMX_COMPAT","HEX")#">

            <cfdocument filename="#application.systemParam.INDEX_FOLDER#/src/reserve_files/#doc_name#.pdf" format = "PDF" pagetype="A4" orientation="portrait" marginBottom = "0" marginLeft = "0" marginRight = "0" marginTop = "0">
                <cfparam  name="attributes.action_type" default="#send_woc.AC#">
                <cfparam  name="attributes.action_id" default="#send_woc.AI#">
                <cfinclude  template="/catalyst/#GET_TEMPLATES.OUTPUT_TEMPLATE_PATH#">
            </cfdocument>

            <cfset SEND_MAIL = application.protein_functions.SEND_MAIL()>
            
            <cfdump  var="#TEMPLATE#" abort>
            <cfset result.status = true>
            <cfset result.success_message = "Paylaşım Yapıldı">
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

</cfcomponent>