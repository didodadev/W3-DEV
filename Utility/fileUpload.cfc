<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal		
Analys Date : 19/05/2016			Dev Date	: 23/05/2016		
Description :
	Bu utility dosya seçip yüklediğimiz sayfalarda kullanılır applicationStart methodunda create edilir.
	
Patameters :
								
		 değerlerini alır.

Used : getSpecialDefinition.get(specialDefinitionType:1);
----------------------------------------------------------------------->

<cfcomponent>

	<cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <!--- dosya yükle --->
	<cffunction name="fileUpload" access="public" returntype="string">
    	<cfargument required="yes" name="file_name" hint="Belge" type="string">
        <cfargument required="no" name="warningFormat" default="#application.langArrayAll['ITEM_#session.ep.language#'][59128]#" hint="Dosya Uyarısı" type="string">
        <cfargument required="no" name="warning" default="#application.langArrayAll['ITEM_#session.ep.language#'][57455]#" hint="Upload sorunu" type="string">
        <cfargument required="yes" name="moduleName" hint="Gidilecek Modul Adı" type="string">
        <cftry>
			<cffile action = "upload" 
            	file="#arguments.file_name#"
			  destination = "#upload_folder##arguments.moduleName##dir_seperator#" 
			  nameConflict = "MakeUnique" 
			  mode="777">
            <cfset file_name = createUUID() & '.' & cffile.serverfileext>
            <cffile action="rename" source="#upload_folder##arguments.moduleName##dir_seperator##cffile.serverfile#" destination="#upload_folder##arguments.moduleName##dir_seperator##file_name#">
			<!---Script dosyalarını engelle  02092010 FA-ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##arguments.moduleName##dir_seperator##file_name#">
				<script type="text/javascript">
					alertObject({message: '<cfoutput>#warningFormat#</cfoutput>!!'});
				</script>
				<cfabort>
			</cfif>
            <cfreturn file_name>
            <cfcatch type="Any">
                <script type="text/javascript">
                    alertObject({message: "<cfoutput>#warning#</cfoutput>!!"});
                </script>
                <cfreturn ''>
                <cfabort>
            </cfcatch>  
        </cftry>
	</cffunction>        
</cfcomponent>