<!---
    File :          AddOns\Yazilimsa\Protein\cfc\siteMethods.cfc
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          01.07.2022
    Description :   Protein Kode Editör
--->
<cfcomponent extends="cfc.queryJSONConverter">

    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" /> 

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>

    <cffunction name="getFile" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfset orginal_file= decrypt(file,'protein_3d','CFMX_COMPAT','Hex')>
            <cffile action="read" file="#orginal_file#" variable="readFile">
            <cfset result.status = true>
            <cfset result.file = file>
            <cfset result.orginal_file = orginal_file>
            <cfset result.file_content = readFile>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="getINFO" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfset protein_folder = #replace(application.systemParam.INDEX_FOLDER,"v16","")#>
            <cfset protein_folder = #replace(protein_folder,"V16","")#> 
            <cffile action="read" file="#protein_folder#AddOns/Yazilimsa/Protein/view/code_editor/readme.md" variable="readme">
            <cfset result.status = true>
            <cfset result.info = readme>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="setFile" access="remote" returntype="string" returnFormat="json">
        <cftry>
            <cfset orginal_file= decrypt(file,'protein_3d','CFMX_COMPAT','Hex')>
            <cffile action="write" file="#orginal_file#" output="#replace(file_content, "InvalidTag", "script", "ALL")#" addnewline="false" charset="utf-8">
            <cfset result.file_content = file_content>
            <cfset result.status = true>
            <cfset result.file = file>
            <cfset result.orginal_file = orginal_file>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.error = cfcatch.message >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
    
     
</cfcomponent>