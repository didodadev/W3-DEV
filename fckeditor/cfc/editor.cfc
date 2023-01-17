<cfcomponent extends="cfc.queryJSONConverter">

    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" /> 

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>

    <cffunction name="upload_image" access="remote" returntype="string" returnFormat="plain">
            <cffile 
                action="upload"
                destination="#application.systemparam.systemParam().upload_folder#content/"
                filefield="form.FILE_0"
                nameconflict="makeunique"
                accept="image/jpeg, image/png, image/bmp, image/gif, image/pjpeg, image/x-png, image/*"
                result = "e_result"> 
            <cftry>
                <cfset result = '{ "errorMessage": "", "result": [ { "url": "#application.systemparam.systemParam().fusebox.server_machine_list##application.systemparam.systemParam().FILE_WEB_PATH#content/#e_result.SERVERFILE#", "name": "#e_result.SERVERFILE#", "size": "#e_result.FILESIZE#"  } ] }'>
            <cfcatch type="any">
                <cfset result = '{ "errorMessage": "Dosya Yüklenemedi", "result": [ { "url": "", "name": "", "size": "" } ] }'>
            </cfcatch>  
            </cftry>
        <cfreturn result>
    </cffunction>
</cfcomponent>