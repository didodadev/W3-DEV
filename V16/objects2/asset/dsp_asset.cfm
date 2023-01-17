<cfquery name="GET_ASSET_" datasource="#DSN#" maxrows="1">
	SELECT 
		ASSET.ASSETCAT_ID,
		ASSET.ASSET_FILE_NAME,
		ASSET.ASSET_FILE_SERVER_ID,
		ASSET_CAT.ASSETCAT_PATH,
		ASSET_SITE_DOMAIN.SITE_DOMAIN 
	FROM 
		ASSET,
		ASSET_CAT,
		ASSET_SITE_DOMAIN
	WHERE
		ASSET.IS_INTERNET = 1 AND
		ASSET_SITE_DOMAIN.ASSET_ID = ASSET.ASSET_ID AND
		ASSET_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
		<cfif isdefined("attributes.asset_catid") and len(attributes.asset_catid)>
			 AND ASSET.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_catid#"> AND
		</cfif>
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
			 AND ASSET.ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
		</cfif>
</cfquery>
<cfif isdefined("attributes.asset_height") and len(attributes.asset_height)>
	<cfset attrributes.asset_height = attributes.asset_height>
<cfelse>
	<cfset attrributes.asset_height= "">
</cfif>
<cfif isdefined("attributes.asset_width") and len(attributes.asset_width)>
	<cfset attrributes.asset_width = attributes.asset_width>
<cfelse>
	<cfset attrributes.asset_width= "">
</cfif>
<cfset file_add_ = "asset/">
<cfif get_asset_.assetcat_id gte 0>
	<cfset file_add_ = "asset/">
<cfelse>
	<cfset file_add_ = "">
</cfif>
<cfif get_asset_.recordcount>
	<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
		<tr>
			<td align="center">			
				<cfoutput query="get_asset_">
					<cfif len(assetcat_path)>
						<cfif find(".swf",asset_file_name)>
							<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" <cfif isdefined("attrributes.asset_height")>height="#attrributes.asset_height#"</cfif> <cfif isdefined("attrributes.asset_width")>width="#attrributes.asset_width#"</cfif> codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=6,0,29,0">
						  	<param name="movie" value='<cf_get_server_file output_file="#file_add_##get_asset_.assetcat_path#/#get_asset_.asset_file_name#" output_server="#get_asset_.asset_file_server_id#" output_type="4" alt="#getLang('objects2',1655)#" title="#getLang('objects2',1655)#">'>
						  	<param name="wmode" value="transparent">
						  	<param name="quality" value="high">
						  	<embed src='<cf_get_server_file output_file="#file_add_##get_asset_.assetcat_path#/#get_asset_.asset_file_name#" output_server="#get_asset_.asset_file_server_id#" output_type="4" alt="#getLang('objects2',1655)#" title="#getLang('objects2',1655)#">' quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" wmode=transparent></EMBED>
							</OBJECT>
			  	    <cfelseif find(".flv",asset_file_name)>
							<cfset video="/documents/#file_add_##assetcat_path#/#asset_file_name#">
							<form name="frmflvplayer" method="get" action="" onsubmit="return false;">
							<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,19,0" <cfif isdefined("attrributes.asset_height")>height="#attrributes.asset_height#"</cfif> <cfif isdefined("attrributes.asset_width")>width="#attrributes.asset_width#"</cfif>>
								<param name="movie" value="/images/interajansplayer.swf" />
								<param name="quality" value="high" />
								<param name="FlashVars" value="contentPath=<cfoutput>#video#</cfoutput>" />
								<embed src="/images/interajansplayer.swf" width="500" height="650" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" FlashVars="contentPath=<cfoutput>#video#</cfoutput>"></embed>
							</object>
							</form>
					  	<cfelse>
						<!--- <cfif isdefined("attributes.asset_url") and len(attributes.asset_url)>
							<a href="javascript://" onClick="windowopen('#attributes.asset_url#','large');">
								<cf_get_server_file output_file="#file_add_##get_asset_.assetcat_path#/#get_asset_.asset_file_name#" output_server="#get_asset_.ASSET_FILE_SERVER_ID#" image_height="#asset_height#" image_width="#asset_width#" output_type="0">
							</a>
						<cfelse>
							<cf_get_server_file output_file="#file_add_##get_asset_.assetcat_path#/#get_asset_.asset_file_name#" output_server="#get_asset_.ASSET_FILE_SERVER_ID#" image_height="#asset_height#" image_width="#asset_width#" output_type="0">
						 </cfif>--->
						</cfif>
					</cfif>
				</cfoutput>
			</td>
		</tr>
	</table>
</cfif>
