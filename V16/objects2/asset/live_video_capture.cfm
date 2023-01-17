<cfif not isdefined("session.ww.userid")>
	<div style="text-align:center; margin-top:150px; margin-bottom:150px;">
<p><cf_get_lang no='177.Canlı yayın yapmak için lütfen giriş yapın'>.</p></div>
<cfelse>
<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
<script type="text/javascript">
AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','330','height','300','src','/images/flashs/LiveVideoCapture','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','flashvars','<cfoutput>streamName=#attributes.stream_name#&serverAddress=#mx_com_server#</cfoutput>','movie','/images/flashs/LiveVideoCapture' ); //end AC code
</script><noscript><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="330" height="300">
  <param name="movie" value="/images/flashs/LiveVideoCapture.swf">
  <param name="FlashVars" value="<cfoutput>streamName=#attributes.stream_name#&serverAddress=#mx_com_server#</cfoutput>" />
  <param name="quality" value="high">
  <embed src="/images/flashs/LiveVideoCapture.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="330" height="300"></embed>
</object>
</noscript>
</cfif>
