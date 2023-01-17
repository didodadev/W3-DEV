<cfset cmp=createObject("component","objects2.video.query.VideoData").init(dsn) />
<cfset get_videos = cmp.GetConsumerVideos(20,"Newest") />
<cfset attributes.video_id = get_videos.asset_id />
<cfset video_title="Güncel Video" />
<cfset xfa.video_detail = "objects2.detail_video" />
<cfset xfa.set_video_rating = "objects2.emptypopup_set_video_rating" />
<cfset xfa.set_comment_rating = "objects2.set_comment_rating" />
<cfset xfa.add_asset_comment = "objects2.add_asset_comment" />
<cfif not isdefined("get_video")>
	<cfset cmp=createObject("component","objects2.video.query.VideoData").init(dsn) />
    <cfset get_video = cmp.getVideo(attributes.video_id) />
    <cfset cmp.IncreaseDownloadCount(attributes.video_id) />
</cfif>
<table border="0" width="1000" align="center">
<tr>
<td valign="top" width="500">
<!-- sol sütun başı -->
<cfinclude template="flvplayer.cfm" />
<cfinclude template="video_options.cfm" />
<!-- sol sütun sonu -->
</td>
<td  valign="top" style="text-align:right;">
<!-- sağ sütun başı -->
<cfinclude template="video_search.cfm" />
<cfinclude template="list_newest_videos.cfm" />
<!-- sağ sütun sonu -->
</td>
</tr>
</table>
