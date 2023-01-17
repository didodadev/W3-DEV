<!--- 
    
    File        :   WMO/middlewares/wexauth.cfm
    Author      :   Halit Yurttaş<halityurttas@workcube.com>,
                    Uğur Hamurpet<ugurhamurpet@workcube.com>
    Date        :   21/08/2019
    Description :   Application onRequest'te middleware katmanı olarak include olur.
                    domain/wex.cfm isteğinden isteğin bir wex olduğunu algılar,
                    domain/wex.cfm/wexname isteğinden wex'in adını alır ve wrk_wex tablosundan doğrular,
                    eğer wex public ise sonucu direkt döner, private ise wrk_wex_authorization tablosundan şifreye göre yetkiye bakar.

    Notes       :   Wex'in wrk_wex tablosundan filePath'ini çeker, eğer cfm ya da json dosya ise include eder, 
                    cfc ise componenti kurar ve isteği yapılan metodun çalıştırılmasını sağlar.
                    
---->
<cfif find( "wex.cfm", lcase( cgi.SCRIPT_NAME ) ) gt 0>
    <cfif len( cgi.PATH_INFO ) and cgi.PATH_INFO neq "/" and listLen( mid( cgi.PATH_INFO, 2, len( cgi.PATH_INFO ) - 1 ), '/' ) gt 0>
        
        <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset download_folder = application.systemParam.systemParam().download_folder>
        <cfset wexpath =  mid( cgi.PATH_INFO, 2, len( cgi.PATH_INFO ) - 1 )>
        <cfset restname = listGetAt(wexpath, 1, '/')>

        <cfquery name="query_wex" datasource="#dsn#">
            SELECT * FROM WRK_WEX WHERE [STATUS] = 'Deployment' AND IS_ACTIVE = 1 AND REST_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#restname#'>
        </cfquery>
        <cfif query_wex.recordCount eq 0>

            <cfheader statuscode="404" statustext="Wex not found or not registered!">
            <cfabort>

        <cfelse>
            <cfif query_wex.AUTHENTICATION eq 2>
                <cfquery name="query_wex_auth" datasource="#dsn#">
                    SELECT * FROM WRK_WEX_AUTHORIZATION WHERE WEX_ID = #query_wex.WEX_ID#
                </cfquery>
                <cfif query_wex_auth.recordCount eq 0>
                    
                    <cfheader statuscode="401" statustext="Unauthorized wex request!">
                    <cfabort>

                <cfelse>
                    <cfif 
                    <!--- ( len( query_wex_auth.DOMAIN ) and find( lcase( query_wex_auth.DOMAIN ), lcase(cgi.REMOTE_HOST) ) eq 0 ) 
                    //or ( len( query_wex_auth.IP ) and query_wex_auth.IP neq cgi.REMOTE_ADDR )
                    or --->
                    ( len( query_wex_auth.PASSWORD ) eq 0 or query_wex_auth.PASSWORD neq url.password )
                    >

                        <cfheader statuscode="401" statustext="Unauthorized wex request!">
                        <cfabort>
                        
                    </cfif>
                </cfif>
            </cfif>
        </cfif>
        <cfif find( ".cfm", query_wex.FILE_PATH ) gt 0>
            <cfset attributes = structNew()>
            <cfset structAppend( attributes, url )>
            <cfset structAppend( attributes, form )>
            <cfinclude template="../../#query_wex.FILE_PATH#">
        <cfelseif find( ".json", query_wex.FILE_PATH ) gt 0>
            <cffile action = "read" file = "#download_folder##replace(query_wex.FILE_PATH, "/", "\", "all")#" variable = "content" charset = "utf-8">
        <cfelse>
            <cfscript>
                dottedpath = query_wex.FILE_PATH;
                if ( mid( dottedpath, 1, 1 ) eq "/" ) {
                    dottedpath = mid( dottedpath, 2, len( dottedpath ) - 1  );
                }
                dottedpath = replace( dottedpath, ".cfc", "" );
                dottedpath = replace( dottedpath, "/", ".", "all" );
            </cfscript>

            <cfobject name="wexed_object" type="component" component="#dottedpath#">

            <cfif isDefined("wexed_object.init")>
                <cfset wexed_object.init()>
            </cfif>
            <cfset wexed_func_name = listGetAt( wexpath, 2, "/" )>
            <cfset wexed_func = wexed_object[wexed_func_name]>
            <cfif isDefined("wexed_func")>
                <cfif findNoCase("application/json", cgi.content_type) gt 0>
                    <cfscript>
                        requestcontent = getHttpRequestData().content;
                        requestContentStruct = deserializeJSON(requestcontent);
                        wex_result = evaluate("wexed_object.#wexed_func_name#(requestContentStruct)");
                    </cfscript>
                <cfelse>
                    <cfif len(query_wex.DATA_CONVERTER) and arrayLen( deserializeJSON( query_wex.DATA_CONVERTER ) ) and structCount(url)>
                        <cfset dataConverter = deserializeJSON( query_wex.DATA_CONVERTER ) />
                        <cfloop collection="#url#" item="key">
                            <cfscript>
                                converted = arrayFilter( dataConverter, function( item ){ return key eq item.convert_parameter; } );
                                if( arrayLen( converted ) ){
                                    url[converted[1]['name']] = len( url[key] ) ? url[key] : converted[1]['convert_default_value'];
                                    if( key neq converted[1]['name'] ) structDelete( url, key );
                                }
                            </cfscript>
                        </cfloop>
                    </cfif>
                    <cfscript>
                        wex_result = evaluate("wexed_object.#wexed_func_name#(argumentCollection=url)");
                    </cfscript>
                </cfif>
                <cfif isQuery(wex_result)>
                    <cfheader name="Content-Type" value="application/json; charset=utf-8" />
                    <cfset wex_result = Replace(serializeJson(createObject("component","cfc.queryJSONConverter").returnData(Replace(serializeJson(wex_result),"//",""))),"//","")>
                <cfelseif isStruct(wex_result) Or isArray(wex_result)>
                    <cfheader name="Content-Type" value="application/json; charset=utf-8" />
                    <cfset wex_result = Replace(serializeJson(wex_result),"//","")>
                </cfif>
                <cfoutput>#wex_result#</cfoutput>
                <cfabort>
            <cfelse>
            
                <cfheader statuscode="404" statustext="Wex method not found!">
                <cfabort>
            
            </cfif>
        </cfif>
    <cfelse>

        <cfheader statuscode="404" statustext="Wex not specified!">
        <cfabort>

    </cfif>
</cfif>