<cfquery name="get_asset" datasource="#dsn#">
    SELECT
        ASSET.ASSET_ID,
        ASSET.ASSETCAT_ID,
        ASSET.ASSET_NAME,
        ASSET.RECORD_DATE,
        ASSET_CAT.ASSETCAT
    FROM
        ASSET,
        ASSET_CAT
    WHERE
        ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID AND
        ASSET.ASSET_FILE_NAME = '#listlast(attributes.video,'/')#'
</cfquery>
<cfif get_asset.recordcount and isdefined('session.ep')>
	<cfset link_ = 'asset.form_upd_asset&asset_id=#get_asset.asset_id#&assetcat_id=#get_asset.assetcat_id#'>
	<cfquery name="get_page_lock" datasource="#dsn#">
		SELECT
			*
		FROM
			DENIED_PAGES_LOCK
		WHERE
			DENIED_PAGE = '#trim(link_)#'
	</cfquery>
	
	<cfquery name="get_my_izinliler" dbtype="query">
		SELECT DISTINCT DENIED_PAGE FROM get_page_lock WHERE POSITION_CODE = #session.ep.position_code# AND DENIED_TYPE = 1
	</cfquery>
	<cfif not get_my_izinliler.recordcount>
		<cfquery name="get_my_yasak_1" dbtype="query">
			SELECT DISTINCT DENIED_PAGE FROM get_page_lock WHERE DENIED_TYPE = 1
		</cfquery>
		<cfif get_my_yasak_1.recordcount>
			<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='60039.Bu Dosyayı Görüntülemek İzinli Değilsiniz'>!");
			window.close();
			</script>
			<cfabort>
		<cfelse>
			<cfquery name="get_my_yasak_2" dbtype="query">
				SELECT DISTINCT DENIED_PAGE FROM get_page_lock WHERE POSITION_CODE = #session.ep.position_code# AND DENIED_TYPE = 0
			</cfquery>
			<cfif get_my_yasak_2.recordcount>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='60039.Bu Dosyayı Görüntülemek İzinli Değilsiniz'>!");
					window.close();
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<cfif not isdefined("attributes.ext")>
	<cfset attributes.ext = listlast(attributes.video,'.')>
	<cfset attributes.content_id = #get_asset.asset_id#>
<cfelseif not isdefined("attributes.content_id")>
	<cfset attributes.content_id = attributes.video_id>
</cfif>
<cfsavecontent variable="video_info">
	<cfoutput>
    	#get_asset.ASSET_NAME#\n\n<cf_get_lang dictionary_id='57486.Kategori'>: #get_asset.ASSETCAT#\n<cf_get_lang dictionary_id='57627.Kayıt tarihi'>: #dateformat(get_asset.RECORD_DATE, 'dd.mm.yyyy')#
    </cfoutput>
</cfsavecontent>
<script type="text/javascript" src="JS/swfobject.js"></script>
<br/>
<table align="center" width="99%">
	<form name="frmflvplayer" method="get" action="#" onsubmit="return false;">
	<tr>
		<td width="75" colspan="2" class="txtbold">
		<div id="flashcontent">
		  <cf_get_lang dictionary_id='52557.You must install Adobe Flash Player 9 or above to play the movie.'>
		</div>
		<script type="text/javascript">
			<cfif attributes.ext eq "flv">
				var so = new SWFObject("/com_mx/FLVPlayer.swf", "FLVPlayer", "482", "420", "9", "#666666");
			<cfelse>
				var so = new SWFObject("/com_mx/swf_player.swf", "SWFPlayer", "482", "420", "9", "#666666");
			</cfif>
			so.addParam("wmode", "opaque");
			so.addParam("allowFullScreen", "true");
			so.addParam("allowScriptAccess","sameDomain");
			so.addVariable("contentPath", getQueryParamValue("video"));
			so.addVariable("contentID",'<cfoutput>#attributes.content_id#</cfoutput>');
			so.addVariable("serverAddress",'<cfoutput>#cgi.HTTP_HOST#</cfoutput>');
			so.addVariable("fmsServerAddress",'<cfoutput>#fms_server_address#</cfoutput>');
			so.addVariable("currentURL",window.location);
			so.addVariable("shareButtonVisible", "false");
			so.addVariable("info", '<cfoutput>#replace(video_info,"'","\'","all")#</cfoutput>');
			so.write("flashcontent");
		</script>
		</td>
	</tr>
	</form>
</table>
