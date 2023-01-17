<cfsetting showdebugoutput="no">
<script type="text/javascript"><!--- sayfayı CNTRL+N ile yeni bir sayfada açmak isteyenlerde browser nedeniyle bazı parametreleri kaybediyordu,oyüzden bu blok eklendi --->
	if(window.opener == undefined)
	{
		alert("İzinsiz Giriş Yaptınız!");
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.list_dashboard';
	}
</script>
<cfset url.id = Decrypt(url.id,'trainingSCO','CFMX_COMPAT','hex')>
<cfinclude template="vars.cfm">

<cfif isDefined("url.id") and len(url.id)>
    <cfquery name="course_info" datasource="#APPLICATION_DB#">
        SELECT * FROM #TABLE_SCO# WHERE SCO_ID = #url.id#
    </cfquery>
</cfif>

<cfif isDefined("course_info") and isDefined("url.jump") and url.jump is "true">
	<!-- Load manifest file -->
	<cfset xmlFile = xmlParse(course_info.MANIFEST_FILE)>
    <!-- Get target info -->
    <cfquery name="get_target_info" datasource="#APPLICATION_DB#">
    	SELECT VAR_VALUE FROM SCO_DATA WHERE SCO_ID = #url.id# AND VAR_NAME = 'adl.nav.request'
    </cfquery>
    
    <cfif get_target_info.recordCount>
    	<!-- Get target tag -->
        <cfset targetTag = replace(get_target_info.VAR_VALUE, '{target=', '')>
        <cfset targetTag = replace(targetTag, '}jump', '')>
    
    	<!-- Loop organization items and match target tag -->
    	<cfset count = 1>
        <cfloop condition="count neq -1 and count lt 500">
            <cftry>
                <cfset itemNode = xmlFile.manifest.organizations.organization.item[count]>
                <cfif itemNode.xmlAttributes.identifier is targetTag>
                	<cfset targetTagHref = itemNode.xmlAttributes.identifierref>
                    <cfbreak>
                <cfelse>
                	<cfset count = count + 1>
                </cfif>
                
                <cfcatch><cfbreak></cfcatch>
            </cftry>
        </cfloop>
        
        <!-- Loop resources and match href of the target tag -->
        <cfif isDefined("targetTagHref")>
        	<cfset count = 1>
            <cfloop condition="count neq -1 and count lt 500">
                <cftry>
                    <cfset resNode = xmlFile.manifest.resources.resource[count]>
                    <cfif resNode.xmlAttributes.identifier is targetTagHref>
                        <cfset targetPage = "#course_info.SCO_DIR#\#resNode.xmlAttributes.href#">
                        <cfbreak>
                    <cfelse>
						<cfset count = count + 1>
					</cfif>
                    
                    <cfcatch><cfbreak></cfcatch>
                </cftry>
            </cfloop>
        </cfif>
    </cfif>
</cfif>

<!-- Set start file as default target if there is no target -->
<cfset targetPage = course_info.START_FILE>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Eğitim</title>
        
        <script>		
            window.onload = function()
            {
				window.API = API;
				window.API_1484_11 = API;
				<cfif isDefined("course_info")>document.getElementById("courseContent").src = "<cfoutput>#replaceList(targetPage, '\', '/')#</cfoutput>";</cfif>
            }
        </script>
    </head>
    <body>
	    <cfif isDefined("course_info")>
        	<div style="position:absolute; top:0px; left:0px; right:0px; bottom:0px; width:100%; height:auto">
	            <iframe frameborder="0" scrolling="no" id="API" name="API" src="<cfoutput>#PAGE_API#</cfoutput>scoID=<cfoutput>#url.id#</cfoutput>" style="width:100%; height:1px; visibility:hidden"></iframe><br />
    	        <iframe frameborder="0" id="courseContent" name="courseContent" style="overflow:auto; width:100%; height:100%; <cfif isDefined("course_info") and course_info.WIDTH gt 0>min-width:<cfoutput>#course_info.WIDTH#</cfoutput>px;</cfif> min-height:<cfif isDefined("course_info") and course_info.HEIGHT gt 0><cfoutput>#course_info.HEIGHT#</cfoutput>px<cfelse>500px</cfif>"></iframe>
			</div>
		</cfif>
    </body>
</html>
