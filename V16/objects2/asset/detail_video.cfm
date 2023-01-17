<cfset xfa.video_detail = "objects2.detail_video" />
<cfset xfa.set_video_rating = "objects2.emptypopup_set_asset_rating" />
<cfset xfa.set_comment_rating = "objects2.set_comment_rating" />
<cfset xfa.add_asset_comment = "objects2.add_asset_comment" />
<cfset attributes.asset_id = attributes.video_id />
<table border="0" align="center">
	<tr>
		<td style="vertical-align:top;">
			<!-- sol sütun başı -->
			<cfparam name="video_title" default="Video" />
			<cf_box title="#video_title#" closable="0" collapsable="0">
				<cfinclude template="flvplayer.cfm" />
			</cf_box>
			<div class="myportal_frame" style="padding:5px;">
				<cfoutput><strong>#get_video.asset_name#</strong><br/>
				<cf_get_lang_main no='359.Detay'>: #get_video.asset_detail#</cfoutput>
			</div>
			<cfinclude template="video_options.cfm" />
			<cfinclude template="list_comments.cfm" />
			<!-- sol sütun sonu -->
		</td>
	</tr>
</table>
