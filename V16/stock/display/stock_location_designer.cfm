<table width="98%" height="98%"align="center">
	<tr>
		<td>
        	<div style="position:absolute; top:60px; left:0px; right:0px; bottom:0px;">
				<cfset flash_variables = "serverAddress=#cgi.HTTP_HOST#&userID=#session.ep.userid#&language=#session.ep.language#">
                <script src="/js/AC_RunActiveContent.js" type="text/javascript"></script>
                <script type="text/javascript">
                AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0', 'id', 'stock_location_designer', 'width','100%','height','95%','src','/com_mx/stock_location_designer','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','/com_mx/stock_location_designer','flashvars','<cfoutput>#flash_variables#</cfoutput>', 'allowScriptAccess', 'always','wmode','opaque'); //end AC code
                </script>
                <noscript>
                    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="95%" id="stock_location_designer">
                      <param name="movie" value="/com_mx/stock_location_designer.swf" />
                      <param name="wmode" value="opaque">
                      <param name="quality" value="high" />
                      <param name="flashvars" value="<cfoutput>#flash_variables#</cfoutput>"/>
                      <param name="allowScriptAccess" value="always"/>
                      <embed src="/com_mx/stock_location_designer.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="95%"></embed>
                    </object>
                </noscript>
			</div>
    	</td>
    </tr>
</table>
