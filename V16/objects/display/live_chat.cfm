<script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>

<cfset flashvars = "serverAddress=#cgi.HTTP_HOST#&fmsServerAddress=#fms_server_address#">

<cfif isDefined("attributes.userID") and isDefined("attributes.userInfo") and isDefined("attributes.relatedID") and isDefined("attributes.relatedInfo") and isDefined("attributes.roomID")>
	<cfset flashvars = "#flashvars#&userID=#urlDecode(attributes.userID)#&userInfo=#urlDecode(attributes.userInfo)#&relatedID=#urlDecode(attributes.relatedID)#&relatedInfo=#urlDecode(attributes.relatedInfo)#&roomID=#urlDecode(attributes.roomID)#">
</cfif>

<cfif isdefined('attributes.lang') and len(attributes.lang)>
    <cfset flashvars = "#flashvars#&language=#attributes.lang#">
<cfelseif isDefined("session.ep")>
    <cfset flashvars = "#flashvars#&language=#session.ep.language#">
<cfelseif isDefined("session.ep")>
    <cfset flashvars = "#flashvars#&language=#session.ww.language#">
</cfif>

<div style="position:absolute; width:100%; height:100%; top:0px; left:0px">
	<script type="text/javascript">
        window.onbeforeunload = function()
        {
            window.onbeforeunload = null;
            document.getElementById("live_chat").exit();
            return false;
        }
    
        AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','id','live_chat','name','live_chat','width','100%','height','100%','src','/COM_MX/live_chat/live_chat','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','flashvars','<cfoutput>#flashvars#</cfoutput>','movie','/COM_MX/live_chat/live_chat' ); //end AC code
    </script>
    <noscript>
    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,0,0" width="100%" height="100%" id="live_chat" name="live_chat">
      <param name="movie" value="/COM_MX/live_chat/live_chat.swf">
      <param name="FlashVars" value="<cfoutput>#flashvars#</cfoutput>" />
      <param name="quality" value="high">
      <embed src="/COM_MX/live_chat/live_chat.swf" id="live_chat" name="live_chat" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="100%" flashvars="<cfoutput>#flashvars#</cfoutput>"></embed>
    </object>
    </noscript>

</div>
