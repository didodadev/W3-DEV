<cf_box title="#getLang('','Kurumsal Üye Çalışanları','30431')#" scroll="1" collapsable="0" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfset flash_variables = "serverAddress=#cgi.HTTP_HOST#&companyID=#attributes.cpid#&language=#session.ep.language#">
    <script src="/js/AC_RunActiveContent.js" type="text/javascript"></script>
    <script type="text/javascript">
    AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','width','100%','height','100%', 'id', 'partner_members_schema','src','V16/com_mx/partner_members_schema','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','V16/com_mx/partner_members_schema','flashvars','<cfoutput>#flash_variables#</cfoutput>', 'allowScriptAccess', 'always','wmode','opaque'); //end AC code
    </script>
    <noscript>
    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="100%" id="partner_members_schema">
        <param name="movie" value="V16/com_mx/partner_members_schema.swf" />
        <param name="wmode" value="opaque">
        <param name="quality" value="high" />
        <param name="flashvars" value="<cfoutput>#flash_variables#</cfoutput>"/>
        <param name="allowScriptAccess" value="always"/>
        <embed src="V16/com_mx/partner_members_schema.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="100%"></embed>
    </object>
    </noscript>
</cf_box>
