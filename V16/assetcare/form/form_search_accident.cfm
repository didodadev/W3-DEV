
<cf_box  title="#getlang('','Kaza Arama','48046')#" id="search_accident">
	<cfinclude template="search_accident.cfm">
</cf_box>

<cf_basket id="search_accident_bask">
	<iframe name="frame_accident_search" id="frame_accident_search" frameborder="0" style="position:absolute;" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_accident_search</cfoutput>&iframe=1" width="100%" height="100%"></iframe>
</cf_basket>

<!--- <cf_box name="frame_accident_search" id="frame_accident_search" box_page="#request.self#?fuseaction=assetcare.popup_list_accident_search&iframe=1">
</cf_box> --->
