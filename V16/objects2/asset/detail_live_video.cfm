<cfset xfa.video_detail = "objects2.detail_live_video" />
<cfset xfa.set_video_rating = "objects2.emptypopup_set_asset_rating" />
<cfset xfa.set_comment_rating = "objects2.set_comment_rating" />
<cfset xfa.add_asset_comment = "objects2.add_live_asset_comment" />
<cfset attributes.asset_id = attributes.video_id />
<table border="0" width="1000" align="center">
<tr>
<td valign="top" width="500">
<!-- sol sütun başı -->
<cfif isdefined("session.ww.userid")>
	<cfset userid = session.ww.userid />
    <cfset username = session.ww.username />
    <cfset usertype="consumer" />
<cfelseif isdefined("session.ep.userid")>
	<cfset userid = session.ep.userid />
    <cfset username = session.ep.username />
    <cfset usertype="employee" />
<cfelseif isdefined("session.pp.userid")>
	<cfset userid = session.pp.userid />
    <cfset username = session.pp.username />
    <cfset usertype="partner" />
</cfif>
<cfinclude template="live_video_player2.cfm" />
<cfinclude template="video_options.cfm" />
<cfinclude template="list_comments.cfm" />
<!-- sol sütun sonu -->
</td>
<td valign="top" style="text-align:right;">
<!-- sağ sütun başı -->
<cfinclude template="video_search.cfm" />
<cfinclude template="video_sender.cfm" />
<cfinclude template="video_info.cfm" />
<cfinclude template="list_profile_videos.cfm" />
<cfinclude template="list_related_videos.cfm" />
<!-- sağ sütun sonu -->
</td>
</tr>
</table>
