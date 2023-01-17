<script type="text/javascript">
	function getAuthID()
	{
		return "<cfoutput>#fms_auth_id#</cfoutput>";
	}
</script>
<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
<cfset realname = '#session.ep.name# #session.ep.surname#'>
<script type="text/javascript">
	AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','id','video_conference','name','video_conference','width','740','height','610','src','/COM_MX/video_conference/video_conference','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','flashvars','<cfoutput>username=#session.ep.username#&realname=#realname#&serverAddress=#cgi.HTTP_HOST#&fmsServerAddress=#fms_server_address#&language=#session.ep.language#&event_id=#attributes.event_id#</cfoutput>','movie','/COM_MX/video_conference/video_conference' ); //end AC code
</script>
<table align="center" cellpadding="0" cellspacing="0" border="0" width="740" height="610">
	<tr>
		<td width="50"></td>
		<td>
			<noscript>
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="740" height="610" id="video_conference" name="video_conference">
			  <param name="movie" value="/COM_MX/video_conference/video_conference.swf">
			  <param name="FlashVars" value="<cfoutput>username=#session.ep.username#&realname=#realname#&serverAddress=#cgi.HTTP_HOST#&fmsServerAddress=#fms_server_address#&language=#session.ep.language#&event_id=#attributes.event_id#</cfoutput>" />
			  <param name="quality" value="high">
			  <embed src="/COM_MX/video_conference/video_conference.swf" id="video_conference" name="video_conference" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="740" height="610"></embed>
			</object>
			</noscript>
		</td>
	</tr>
</table>
