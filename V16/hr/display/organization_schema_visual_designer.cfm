<div class="color-list" id="color_list"></div>
<div class="color-border" id="color_border"></div>
<script src="/js/jquery-1_7_1_min.js" type="text/javascript"></script>
<script type="text/javascript">
    function getCSSColors()
    {
		try
		{
			var bg_color = $("#color_list").length != null ? rgbToHex($("#color_list").css("background-color")): "";
			var border_color = $("#color_border").length != null ? rgbToHex($("#color_border").css("background-color")): "";
			var flashObj = document.organization_schema ? document.organization_schema: document.getElementById("organization_schema");
			if (flashObj) flashObj.applyCSS(bg_color, border_color);
		} catch (e) { }
    }
	
	function rgbToHex(value)
	{
		if (value.search("rgb") == -1)
            return value;
        else {
            value = value.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
            function hex(x) {
                return ("0" + parseInt(x).toString(16)).slice(-2);
            }
            return "#" + hex(value[1]) + hex(value[2]) + hex(value[3]);
        }
	}
</script>
<table width="98%" height="98%" align="center">
	<tr>
		<td>
        	<div style="position:absolute; top:80px; left:50px; right:0px; bottom:0px;">
				<cfset flash_variables = "serverAddress=#cgi.HTTP_HOST#&recordEmpID=#session.ep.userid#&language=#session.ep.language#">
                <script src="/js/AC_RunActiveContent.js" type="text/javascript"></script>
                <script type="text/javascript">
                AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0','width','100%','height','100%', 'id', 'organization_schema', 'name', 'organization_schema', 'src','/V16/com_mx/organization_schema','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','movie','/V16/com_mx/organization_schema','flashvars','<cfoutput>#flash_variables#</cfoutput>', 'allowScriptAccess', 'always','wmode','opaque'); //end AC code
                </script>
                <noscript>
                <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,159,0" width="100%" height="100%" id="organization_schema">
                    <param name="movie" value="/V16/com_mx/organization_schema.swf" />
                    <param name="wmode" value="opaque">
                    <param name="quality" value="high" />
                    <param name="flashvars" value="<cfoutput>#flash_variables#</cfoutput>"/>
                    <param name="allowScriptAccess" value="always"/>
                    <embed id="organization_schema" src="/V16/com_mx/organization_schema.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="100%"></embed>
                </object>
                </noscript>
			</div>
    	</td>
    </tr>
</table>
