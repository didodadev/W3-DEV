<cfsetting showdebugoutput="no">

<cfif isdefined('session.ep.userid') or isdefined('session.pp.userid') or isdefined('session.ww.userid')>
	<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
	<cfif isdefined('session.ep')>
		<cfset userTypeID = 0>
		<cfset workcubeID = session.ep.workcube_id>
		<cfset lang_ = session.ep.language>
		<cfset realname = '#session.ep.name# #session.ep.surname#'>
	<cfelseif isdefined('session.pp.userid')>
		<cfset userTypeID = 1>
		<cfset workcubeID = session.pp.workcube_id>
		<cfset lang_ = session.pp.language>
		<cfset realname = '#session.pp.name# #session.pp.surname#'>
	<cfelseif isdefined('session.ww.userid')>
		<cfset userTypeID = 2>
		<cfset workcubeID = session.ww.workcube_id>
		<cfset lang_ = session.ww.language>
		<cfset realname = '#session.ww.name# #session.ww.surname#'>
	</cfif>
	<cfif not isdefined('session.ep')>
		<cfif isDefined("attributes.room_id") and len(attributes.room_id)><cfset roomID = attributes.room_id><cfelse><cfset roomID = workcubeID></cfif>
    <cfelseif isdefined('session.ep') and isDefined("attributes.room_id") and len(attributes.room_id)>
    	<cfif isDefined("attributes.room_id") and len(attributes.room_id)><cfset roomID = attributes.room_id><cfelse><cfset roomID = workcubeID></cfif>
	<cfelse>
		<cfset roomID = "">
	</cfif>
	<cfset flashvars = "userTypeID=#userTypeID#&workcubeID=#workcubeID#&realname=#realname#&serverAddress=#cgi.HTTP_HOST#&fmsServerAddress=#fms_server_address#&language=#lang_#&roomID=#roomID#">
	<cfif isdefined('attributes.targetUserID')><cfset flashvars = "#flashvars#&targetUserID=#attributes.targetUserID#"></cfif>
	    
	<script type="text/javascript">	
		window.onbeforeunload = function()
		{	
			return exitVideoConference();
		}
		
		function exitVideoConference()
		{
			window.onbeforeunload = null;
			
			var flashObj = window["video_conference"];
			if (flashObj == null) flashObj = document["video_conference"];
			if (flashObj == null) flashObj = document.getElementById("video_conference");
			if (flashObj != null)
			{
				flashObj.exitVideoConference();
				return "";
			} else {
				return true;
			}
		}
	
		AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','id','video_conference','name','video_conference','width','740','height','610','src','/COM_MX/video_conference/video_conference','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','flashvars','<cfoutput>#flashvars#</cfoutput>','movie','/COM_MX/video_conference/video_conference' ); //end AC code
	</script>
	<noscript>
	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="740" height="610" id="video_conference" name="video_conference">
	  <param name="movie" value="/COM_MX/video_conference/video_conference.swf">
	  <param name="FlashVars" value="<cfoutput>#flashvars#</cfoutput>" />
	  <param name="quality" value="high">
	  <embed src="/COM_MX/video_conference/video_conference.swf" id="video_conference" name="video_conference" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="740" height="610" flashvars="<cfoutput>#flashvars#</cfoutput>"></embed>
	</object>
	</noscript>
</cfif>
