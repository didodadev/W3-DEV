<cfset xfa.detail_photo = "objects2.detail_photo" />
<cfset xfa.set_asset_rating = "objects2.emptypopup_set_asset_rating" />
<cfset xfa.set_comment_rating = "objects2.set_comment_rating" />
<cfset xfa.add_asset_comment = "objects2.add_asset_comment" />
<table border="0" width="1000" align="center">
<tr>
<td valign="top" width="600">
<!-- sol sütun başı -->
<cfinclude template="photo_display.cfm" />
<cfinclude template="photo_options.cfm" />
<cfinclude template="list_comments.cfm" />
<!-- sol sütun sonu -->
</td>
<td valign="top" style="text-align:right;">
<!-- sağ sütun başı -->
<cfinclude template="photo_sender.cfm" />
<!--- <cfinclude template="photo_search.cfm" /> --->
<cfinclude template="photo_info.cfm" />
<cfinclude template="list_profile_photos.cfm" />
<cfinclude template="list_related_photos.cfm" />
<!-- sağ sütun sonu -->
</td>
</tr>
</table>
