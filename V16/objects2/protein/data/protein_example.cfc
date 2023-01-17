<!--- 
    Author: Semih Akartuna
    Date:   17/06/2022
    Desc:   Form ve request test işlemlerinde kullanılıyor.
--->
<cfcomponent extends="cfc.queryJSONConverter">
<cfset dsn=application.systemParam.systemParam().dsn>

<cffunction name="CONTROL_FORM" access="remote" returntype="string" returnargumentsat="json">
        <cfset upload_file_folder = "C:\W3Catalyst\Dev\PROD\documents\">
        <cfset result = StructNew()>
        <cftry>
            <!--- Klasor Konrolu BEGIN --->       
                <cfdirectory action="list" directory="#upload_file_folder#" recurse="false" name="folders">
                <cfquery dbtype="query" name="find_folder">
                    SELECT Name FROM folders WHERE TYPE='Dir' AND NAME = 'example_protein'
                </cfquery>                
                <cfif find_folder.RecordCount neq 1>
                    <cfdirectory action="create" directory="#upload_file_folder#/example_protein" name="create_folder">
                </cfif>
            <!--- Klasor Konrolu END --->  
            <cffile action="upload" filefield="form.file_example_input" destination="#upload_file_folder#/example_protein" nameconflict="Overwrite" result = "upload_result">	
            
            <cfset result.status = true>
            <cfset result.upload_file_folder = upload_file_folder>
            <cfset result.file = "#upload_file_folder##upload_result.SERVERFILE#">
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <cfset result.identity = 1>
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

