<!--- <table n width="99%" align="center">
	<tr height="35">
		<td class="detailhead"><a href="javascript:gizle_goster_ikili('driving_licence','driving_licence_bask');">&raquo;</a><cf_get_lang no='178.Ehliyet Bilgisi Arama'></td>
	</tr>
</table> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box  id="driving_licence" title="#getLang('','Ehliyet Bilgisi Arama',48049)#">


	<cfinclude template="search_driving_licence.cfm">
</cf_box>

<!--- <cf_box name="frame_search_driving_licence" id="driving_licence_bask" uidrop="1" box_page="#request.self#?fuseaction=assetcare.popup_list_driving_licence&iframe=1" >
</cf_box> --->

<cf_basket id="driving_licence_bask">
	<iframe name="frame_search_driving_licence" id="frame_search_driving_licence" frameborder="0" style="position:absolute;" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_driving_licence</cfoutput>&iframe=1" width="100%" height="100%"></iframe>
</cf_basket>
</div>
