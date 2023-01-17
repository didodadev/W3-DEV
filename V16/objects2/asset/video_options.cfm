<div id="bbb">
<cfform name="ratingForm" action="" method="post">
<table style="width:100%;">
	<tr>
		<td class="tableyazi">
			<input type="hidden" name="video_id" id="video_id" value="<cfoutput>#attributes.video_id#</cfoutput>" />
			<cfif get_video.rating eq "">
				<cfset rtng = 0>
			<cfelse>
				<cfset rtng=Round(get_video.rating)>
			</cfif>
			<cf_rating name="rating" emptyimage="/images/cube_vote_yellow.gif" fullimage="/images/cube_vote_red.gif" selectedIndex="#rtng#" onChange="ratingChange(this)" redonly="true"/><br />
			<cf_get_lang no='174.Oylamak için yıldızlara tıklayın'>.<br /><br />
			<b><cf_get_lang no='176.Toplam Oylama'>:</b> <cfoutput><span id="rating_count">#get_video.rating_count#</span>&nbsp;&nbsp;
			<b><cf_get_lang no='170.İzlenme'>:</b> #get_video.download_count#</cfoutput>
		</td>
	</tr>
</table>
</cfform>
</div>
<div id="my_rating_count"></div>
<script type="text/javascript">
	function ratingChange()
	{
		my_rating_ = document.ratingForm.rating.value;
		my_video_id_ = document.ratingForm.video_id.value;
		var my_video_rating = '<cfoutput>#request.self#?fuseaction=objects2.emptypopup_set_asset_rating</cfoutput>&my_rating='+my_rating_+'&video_id='+my_video_id_;
		AjaxPageLoad(my_video_rating,'my_rating_count');
		//AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_video_info&video_id=#attributes.video_id#</cfoutput>','bbb','1');
	}
</script>

