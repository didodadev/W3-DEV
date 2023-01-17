<!--- <properties>
	<property name="id" />
	<property name="SortExpression" /> Newest | MostViewed | MostDiscussed | MostFavorites | MostRated
	<property name="VideoCount" />
	<property name="ColumnCount" />
	<property name="Category" />
</properties> --->
<cfparam name="attributes.page" default="1" />
<cfparam name="attributes.maxrows" default="5" />
<cfparam name="attributes.startrow" default="1" />
<cfparam name="attributes.SortExpression" default="Newest" />
<cfparam name="attributes.VideoCount" default="10" type="numeric" />
<cfparam name="attributes.ColumnCount" default="5" type="numeric" />
<cfif not isdefined("thumbnailCFC")>
	<cfset thumbnailCFC = createObject("component", "cfc.thumbnail").init(upload_folder, dir_seperator, dsn) />
</cfif>
<cfset videoData = createObject("component", "objects2.asset.query.AssetData").init(dsn,2) />
<cfset videolar = videoData.GetProductAssets(attributes.VideoCount, attributes.SortExpression,attributes.product_id) />
<cfset attributes.VideoCount = videolar.RecordCount />
<cfif videolar.recordcount>
<cf_box title="Videolar">
<cfoutput query="videolar">
<cfset url_ = "asset">
    <div class="NormalItem" align="left" style="padding:5px;">
        <div class="ItemImage" align="left" style="float:left">
			<a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects2.popup_flvplayer&video_id=#videolar.ASSET_ID#','video');">
				<cf_get_server_file output_file="#url_#/#videolar.asset_file_name#" output_server="#videolar.asset_file_server_id#" output_type="2" image_link="0" image_width="80" image_height="60" small_image="documents/#thumbnailCFC.GetThumbnailUrl(url_, videolar.ASSET_FILE_NAME)#">
			</a>
        </div>
        <h3 class="ItemTitle" style="font-size:13px;padding:0px;margin:0px">
		<a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects2.popup_flvplayer&video_id=#videolar.ASSET_ID#','video');">#videolar.asset_name#</a></h3>
        <div class="ItemSummary">#videolar.duration#<br />
           <cf_get_lang no='170.İzlenme'>:#videolar.download_count#<br />
           <cfif videolar.RATING eq ""><cfset rtng = 0 /><cfelse><cfset rtng=Round(videolar.RATING)/></cfif>
			<cf_rating name="rating#videolar.ASSET_ID#" size="small" selectedIndex="#rtng#" readonly="true" />
      </div>
    </div><br clear="left" /><hr size="1" noshade="noshade" />
</cfoutput>
</cf_box>
</cfif>

