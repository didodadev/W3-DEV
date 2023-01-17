<cfquery name="GET_ASSET" datasource="#dsn#">
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
		<cfif isdefined("attributes.video_id")>
			ASSET.ASSET_ID=#attributes.video_id# AND
		<cfelse>
			 ASSET.ASSET_FILE_NAME = '#listlast(attributes.video,'/')#' AND
		</cfif>
        ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID AND
        ASSET.ASSET_FILE_NAME = '#listlast(attributes.video,'/')#'
</cfquery>
<cfif get_asset.recordcount>
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
			alert("<cf_get_lang dictionary_id='60039.Bu Dosyayı Görüntülemeye İzinli Değilsiniz'>!");
			window.close();
			</script>
			<cfabort>
		<cfelse>
			<cfquery name="get_my_yasak_2" dbtype="query">
				SELECT DISTINCT DENIED_PAGE FROM get_page_lock WHERE POSITION_CODE = #session.ep.position_code# AND DENIED_TYPE = 0
			</cfquery>
			<cfif get_my_yasak_2.recordcount>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='60039.Bu Dosyayı Görüntülemeye İzinli Değilsiniz'>!");
					window.close();
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<cfif not isdefined("attributes.ext")>
	<cfset attributes.ext = listlast(attributes.video,'.')>
</cfif>
<cfsavecontent variable="audio_info"><cfoutput>#get_asset.ASSET_NAME#<br /><br /><cf_get_lang dictionary_id='57486.Kategori'>: #get_asset.ASSETCAT#<br /><cf_get_lang dictionary_id='57627.Kayıt tarihi'>: #dateformat(get_asset.RECORD_DATE, 'dd.mm.yyyy')#</cfoutput></cfsavecontent>

<cfif isdefined("attributes.ajax")>
		<cfquery name="get_my_asset_mp3_listen" datasource="#dsn#">
			SELECT * FROM CUBETV_MY_ASSET WHERE ASSET_ID=#get_asset.ASSET_ID# AND EMPLOYEE_ID=#session.ep.userid#
		</cfquery>
		<cfif get_my_asset_mp3_listen.recordcount>
			<cfquery name="upd_my_asset_mp3" datasource="#dsn#">
				UPDATE CUBETV_MY_ASSET SET LAST_VIEW_DATE = #now()# WHERE ASSET_ID=#get_my_asset_mp3_listen.ASSET_ID#
			</cfquery>
		<cfelse>
			<cfquery name="add_my_asset_mp3" datasource="#dsn#">
				INSERT INTO CUBETV_MY_ASSET
				(
					ASSET_ID,
					EMPLOYEE_ID,
					LAST_VIEW_DATE
				)
				VALUES
				(
					#get_asset.ASSET_ID#,
					#session.ep.userid#,
					#now()#
				)
			</cfquery>
		</cfif>
	<cfoutput>
	<table align="center" width="99%" bgcolor="999999">
	<tr>
	<td>
	<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
	   codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=7,0,0,0"
	   width="480" height="140" id="FLVPlayer" align="middle">
		<param name="allowScriptAccess" value="sameDomain" />
		<param name="movie" value="/com_mx/audio_player.swf?contentPath=#attributes.video#" />
		<param name="quality" value="high"/>
		<param name="bgcolor" value="##999999" />
		<param name="FlashVars" value="info=#audio_info#" />
		<embed src="/com_mx/audio_player.swf?contentPath=#attributes.video#" quality="high" bgcolor="##ffffff" width="480"
		   height="140" name="FLVPlayer" align="middle" allowScriptAccess="sameDomain"
		   type="application/x-shockwave-flash" pluginspage="http://www.adobe.com/go/getflashplayer" />
	</object>
	</cfoutput>
	</td>
	</tr>
</table>
<cfelse>
	<script type="text/javascript" src="/JS/swfobject.js"></script>
	<table align="center" width="99%" height="140" bgcolor="999999">
		<form name="frmflvplayer" method="get" action="#" onsubmit="return false;">
		<tr>
			<td width="75" colspan="2" class="txtbold">
			<div id="flashcontent">
			  <cf_get_lang dictionary_id='60169.You must install Adobe Flash Player 10 or above to play the movie.'>
			</div>
		<script type="text/javascript">
			var so = new SWFObject("/com_mx/audio_player.swf", "FLVPlayer", "480", "140", "10", "#999999");
			so.addParam("wmode", "opaque");
			so.addParam("allowFullScreen", "true");
			so.addParam("allowScriptAccess","sameDomain");
			so.addVariable("contentPath", getQueryParamValue("video"));
			so.addVariable("info", "<cfoutput>#audio_info#</cfoutput>");
			so.write("flashcontent");
		</script>
			</td>
		</tr>
		</form>
	</table>
</cfif>
