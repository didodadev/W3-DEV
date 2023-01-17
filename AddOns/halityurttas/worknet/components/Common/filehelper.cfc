<cfcomponent>
    <cfproperty name="processedfile" type="any" setter="false" getter="true">

    <cffunction name="save_uploaded_file" access="public" returntype="any">
        <cfargument name="filefield" type="string">
        <cfargument name="upload_folder" type="string">
        <cffile action="UPLOAD"
            filefield="#filefield#"
            destination="#upload_folder#"
            mode="777"
            nameconflict="MAKEUNIQUE"
            accept="image/*">
        <cfset file_name = createUUID()>
        <cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
        <cfset this.processedfile = cffile>
        <cfset assetTypeName = listlast(cffile.serverfile, ".")>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList, assetTypeName, ",")>
            <cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
            <cfthrow message="\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!">
        </cfif>
        <cfset result = '#file_name#.#cffile.serverfileext#'>
        <cfreturn result>
    </cffunction>

    <cffunction name="remove_exceed_file" access="public">
        <cfargument name="limit" type="numeric">
        <cfargument name="path" type="string">
        <cfset long_file_limit = int(limit) * 1024 * 1024>
        <cfif processedfile.filesize gt long_file_limit>
            <cfif fileExists(path)>
                <cffile action="delete" file="#path#">
                <cfreturn 1>
            <cfelse>
                <cfreturn 0>
            </cfif>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>
</cfcomponent>