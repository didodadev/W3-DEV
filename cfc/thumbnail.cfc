<cfcomponent>
	<cffunction name="init" access="public" returntype="thumbnail">
    	<cfargument name="uploadFolder" type="string" required="yes">
        <cfargument name="dirSeperator" type="string" required="yes" />
        <cfargument name="dsn" type="string" required="yes" />
        <cfset var FORMAT = 0 />
        <cfset variables.uploadFolder = arguments.uploadFolder />
        <cfset variables.dirSeperator = arguments.dirSeperator />
        
        <cfquery name="FORMAT" datasource="#dsn#">
        	SELECT * FROM SETUP_FILE_FORMAT
        </cfquery>
        <cfset variables.extensionList = valueList(format.FORMAT_SYMBOL) />
        <cfset variables.imageList = valueList(format.icon_name) />
        <cfreturn this />
    </cffunction>
    
	<cffunction name="GetThumbnailUrl" access="public" returntype="string">
    	<cfargument name="assetFilePath" type="string" required="yes">
		<cfargument name="assetFileName" type="string" required="yes">
        <cfargument name="width" type="numeric" required="no" default="50" />
        <cfargument name="height" type="numeric" required="no" default="50" />
        <cfset var fileExtension = "" />
        <cfset var fileName = "" />
        <cfset var thumbFile = "" />
        
        <cfif listLen(assetFileName,'.') eq 2>			
			<cfset fileExtension = ucase(listLast(assetFileName,'.'))>
			<cfset fileName = listFirst(assetFileName,'.')>
		<cfelse>
		   <cfset fileExtension = 'incorrect'>	
           <cfset fileName = assetFileName>	
        </cfif>
        
		<cfif fileExtension neq "incorrect" and FileExists('#uploadFolder#thumbnails#dirSeperator##fileName#.jpg')>
        	<cfset thumbFile = 'thumbnails#dirSeperator##fileName#.jpg' />
        <cfelse>
            <cfset thumbFile = CreateThumbnail(assetFilePath,assetFileName) />
        </cfif>
		<cfreturn thumbFile>
	</cffunction>
    
 	<cffunction name="CreateThumbnail" access="private" returntype="string">
    	<cfargument name="assetFilePath" type="string" required="yes">
    	<cfargument name="assetFileName" type="string" required="yes">
       
        <cfset var fileExtension = "" />
        <cfset var fileName = "" />
        <cfset var thumbFile = "" />
        <cfif listLen(assetFileName,'.') eq 2>			
			<cfset fileExtension = ucase(listLast(assetFileName,'.'))>
			<cfset fileName = listFirst(assetFileName,'.')>
		<cfelse>
		   <cfset fileExtension = 'incorrect'>	
           <cfset fileName = assetFileName>	
        </cfif>
        
        <cfif not isdefined("variables.myImage")>
        	<cfset variables.myImage = CreateObject("Component", "iedit") />
        </cfif>
        
        <cfif listFindNoCase('JPG,PNG,GIF,JPEG',fileExtension)> <!--- if asset is an image --->
            <cftry>
                <cffile action="copy" destination="#uploadFolder##dirSeperator#thumbnails" source="#assetFilePath##assetFileName#">
                <cfset myImage.SelectImage("#uploadFolder#thumbnails#dirSeperator##assetFileName#")>
                <cfset myImage.scale(50,50)>
                <cfset myImage.output("#uploadFolder#thumbnails#dirSeperator##fileName#.jpg", "jpg",100)>
                <cfif extension neq "JPG">
                	<cffile action="delete" file="#uploadFolder#thumbnails#dirSeperator##assetFileName#">
                </cfif>
                <cfset thumbFile = "thumbnails/#fileName#.jpg">
            <cfcatch type="any">
                <cfset thumbFile = "thumbnails/undefined.jpg">
            </cfcatch>
            </cftry>
       <cfelseif fileExtension eq 'FLV'> <!--- if asset is a flash video --->
       		<cftry>
                <cfmodule template="../myportal/query/convert_video.cfm" action="CreateThumb" inputfile="#assetFilePath##assetFileName#" outputfile="#uploadFolder#thumbnails#dirSeperator##fileName#.jpg">
                <cfset thumbFile = "thumbnails/#fileName#.jpg">
            <cfcatch type="any">
                <cfset thumbFile = "thumbnails/undefined.jpg">
            </cfcatch>
            </cftry>
       <cfelseif listFindNoCase(extensionList, fileExtension)> <!--- if asset is a known file --->
			<cfset thumbFile = "settings/#listgetat(imageList,listFindNoCase(extensionList,'#fileExtension#'))#">
       <cfelse>
       		<cfset thumbFile = "thumbnails/undefined.jpg">
       </cfif>
       <cfreturn thumbFile />
</cffunction>
</cfcomponent>
