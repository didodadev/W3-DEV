<cfif isDefined("session_base")>
    
    <cffunction name="templateInclude" returnType="void">
        <cfif isDefined("application.objects")><!--- wo bulunuyorsa --->
            <cfset woInfo = application.objects[attributes.wo] />
        
            <cfset controllerFilePath = replace("/workcube/#woInfo.CONTROLLER_FILE_PATH#", '\', '/', 'all') />
            <cfset filePath = replace("/workcube/#woInfo.FILE_PATH#", '\', '/', 'all') />
            <cfset filePathV = replace("/V16/#woInfo.FILE_PATH#", '\', '/', 'all') />

            <cfset expandControllerFilePath = replace(ExpandPath(controllerFilePath), '\', '/', 'all') />
            <cfset expandFilePath = replace(ExpandPath(filePath), '\', '/', 'all') />
            <cfset expandFilePathV = replace(ExpandPath(filePathV), '\', '/', 'all') />

            <cfif len( woInfo.CONTROLLER_FILE_PATH ) and fileExists(expandControllerFilePath)>
                <cfinclude  template="controllerEngine.cfm">
            <cfelseif len(woInfo.FILE_PATH) and fileExists(expandFilePath)>
                <cfinclude  template="#filePath#">
            <cfelseif len(woInfo.FILE_PATH) and fileExists(expandFilePathV)>
                <cfinclude  template="#filePathV#">
            <cfelse>
                File Not Found
            </cfif>
        <cfelse>
            Module not found!
        </cfif>
    </cffunction>
    
    <cfif not isdefined("attributes.isAjax") and not isdefined("attributes.ajax")>
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html dir="<cfoutput>#session_base.language is 'arb' ? 'RTL' : ''#</cfoutput>" xmlns="http://www.w3.org/1999/xhtml" lang="<cfoutput>#session_base.language#</cfoutput>">
            <head><cfinclude  template="../template/head.cfm"></head>
            <body>
                <header><cfinclude  template="../template/header.cfm"></header>
                <article>
                    <div class="container-fluid">
                        <cfset templateInclude() />
                    </div>
                </article>
            </body>
        </html>
    <cfelse>
        <cfif listFirst(attributes.wo,'.') is 'objects2'>
            <cfinclude template="fbx_switch.cfm">
            <cfabort>
        <cfelse>
            <cfset templateInclude() />
        </cfif>
    </cfif>
<cfelse>
    <cfinclude  template="../view/login.cfm">
</cfif>