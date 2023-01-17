<cfif isdefined('session.ep')>
	<cfset userTypeID = 0>
	<cfset workcubeID = session.ep.workcube_id>
	<cfset realname = '#session.ep.name# #session.ep.surname#'>
	<cfset username = #session.ep.username#>
	<cfset lang = #session.ep.language#>
<cfelseif isdefined('session.pp')>
	<cfset userTypeID = 1>
	<cfset workcubeID = session.pp.workcube_id>
	<cfset realname = '#session.pp.name# #session.pp.surname#'>
	<cfset username = '#session.pp.username#_partner'>
	<cfset lang = #session.pp.language#>
<cfelseif isdefined('session.ww')>
	<cfset userTypeID = 2>
	<cfset workcubeID = session.ww.workcube_id>
	<cfset realname = '#session.ww.name# #session.ww.surname#'>
	<cfset username = '#session.ww.username#_consumer'>
	<cfset lang = #session.ww.language#>
</cfif>
<cfif isdefined('workcubeID')>
	<cfset flashvars = "userTypeID=#userTypeID#&workcubeID=#workcubeID#&realname=#realname#&serverAddress=#cgi.HTTP_HOST#&classID=#attributes.class_id#&fmsServerAddress=#fms_server_address#&language=#lang#">
	<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
	<div style="position:absolute; width:100%; height:100%">
		<script type="text/javascript">
			AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','id','white_board','name','white_board','width','100%','height','100%','src','/COM_MX/white_board/white_board','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','flashvars','<cfoutput>#flashvars#</cfoutput>','movie','/COM_MX/white_board/white_board', 'wmode', 'opaque' ); //end AC code
		</script>
		<noscript>
		<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="100%" id="white_board" name="white_board">
			<param name="movie" value="/COM_MX/white_board/white_board.swf">
			<param name="FlashVars" value="<cfoutput>#flashvars#</cfoutput>" />
			<param name="wmode" value="opaque" />
			<param name="quality" value="high">
			<embed src="/COM_MX/white_board/white_board.swf" wmode="opaque" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="100%" id="white_board" name="white_board"></embed>
		</object>
		</noscript>
	</div>
</cfif>
