<cfquery name="GET_ASSET_URL" datasource="#DSN#" maxrows="1">
	SELECT 
        ASSET.ASSET_NAME,
        ASSET.ASSET_FILE_NAME,
        ASSET_CAT.ASSETCAT_PATH,
        ASSET_CAT.ASSETCAT_ID
	FROM 
		ASSET,
		ASSET_CAT
	WHERE
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
        ASSET.ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.my_podcast_id#">
</cfquery>
<cfif get_asset_url.assetcat_id gte 0>
	<cfset folder="asset/#get_asset_url.assetcat_path#">
<cfelse>
    <cfset folder="#get_asset_url.assetcat_path#">
</cfif>
<cfset streamUrl = 'http://#cgi.HTTP_HOST#/documents/#folder#/#get_asset_url.asset_file_name#'>
<cfif attributes.my_podcast_value eq 1>
	<cfset autoStart = 'true'>
<cfelse>
	<cfset autoStart = 'false'>
</cfif>

<table align="center" cellpadding="0" cellspacing="5" border="0" style="width:98%; height:100%;">
    <tr>
        <cfif attributes.my_podcast_name eq 1><td class="tableyazi"><cfoutput>#get_asset_url.asset_name#</cfoutput></td></cfif>
        <td style="width:50px;">
            <script src="/JS/AC_RunActiveContent.js" type="text/javascript"></script>
            <script type="text/javascript">
                AC_FL_RunContent( 'codebase','http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0','width','100%','height','40','src','../../COM_MX/podcast_player','quality','high','pluginspage','http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash','flashvars','<cfoutput>streamUrl=#streamUrl#&autoStart=#autoStart#</cfoutput>','movie','../../COM_MX/podcast_player' ); //end AC code
            </script>
            <noscript>
            <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="100%" height="40">
              <param name="movie" value="../../COM_MX/podcast_player.swf">
              <param name="FlashVars" value="streamUrl=#streamUrl#&autoStart=#autoStart#" />
              <param name="quality" value="high">
              <embed src="../../COM_MX/podcast_player.swf" quality="high" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100%" height="40"></embed>
            </object>
            </noscript>
        </td>
    </tr>
</table>
