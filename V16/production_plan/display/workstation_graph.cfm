<div style="position:absolute; top:80px; left:50px; right:0px; bottom:0px;">
	<cfset flash_variables = "serverAddress=#cgi.HTTP_HOST#&companyID=#session.ep.company_id#&language=#session.ep.language#&userID=#session.ep.userid#">
    <script src="/js/AC_RunActiveContent.js" type="text/javascript"></script>
    <script type="text/javascript">
    AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0', 'id', 'production_station_graph', 'width','100%','height','100%','src','/V16/com_mx/production_station_graph','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','/V16/com_mx/production_station_graph','flashvars','<cfoutput>#flash_variables#</cfoutput>', 'allowScriptAccess', 'always','wmode','opaque'); //end AC code
    </script>
    <noscript>
        <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="100%" id="production_station_graph">
          <param name="movie" value="/V16/com_mx/production_station_graph.swf" />
          <param name="wmode" value="opaque">
          <param name="quality" value="high" />
          <param name="flashvars" value="<cfoutput>#flash_variables#</cfoutput>"/>
          <param name="allowScriptAccess" value="always"/>
          <embed src="/V16/com_mx/production_station_graph.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="100%"></embed>
        </object>
    </noscript>
</div>
