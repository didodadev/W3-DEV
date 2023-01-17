<cfif isDefined('attributes.display_mode') and attributes.display_mode is '1'>
	<cfset user_has_authorization = 0>
<cfelse>
	<cfset user_has_authorization = 1>
</cfif>
<div id="flash_container" style="position:absolute; top:70px; left:50px; right:0px; bottom:0px;">
	<cfset flash_variables = "serverAddress=#cgi.HTTP_HOST#&mainProcessID=#attributes.main_process_id#&recordEmpID=#session.ep.userid#&userHasAuthorization=#user_has_authorization#&companyID=#session.ep.company_id#&language=#session.ep.language#">
    <script src="/js/AC_RunActiveContent.js" type="text/javascript"></script>
    <script type="text/javascript">
    AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','width','100%','height','95%', 'id', 'bpm_general_process_designer', 'name', 'gp_visual_designer', 'src','/V16/com_mx/bpm_general_process_designer','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','/V16/com_mx/bpm_general_process_designer','flashvars','<cfoutput>#flash_variables#</cfoutput>', 'allowScriptAccess', 'always','wmode','opaque'); //end AC code
    </script>
    <noscript>
    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="95%" id="bpm_general_process_designer">
        <param name="movie" value="/V16/com_mx/bpm_general_process_designer.swf" />
        <param name="wmode" value="opaque">
        <param name="quality" value="high" />
        <param name="flashvars" value="<cfoutput>#flash_variables#</cfoutput>"/>
        <param name="allowScriptAccess" value="always"/>
        <embed id="gp_visual_designer" src="/V16/com_mx/bpm_general_process_designer.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="95%"></embed>
    </object>
    </noscript>
</div>
