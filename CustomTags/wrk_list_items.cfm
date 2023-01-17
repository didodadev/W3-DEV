<link href="../../JS/temp/scroll/jquery.mCustomScrollbar.css" rel="stylesheet" />
<script src="../../JS/temp/scroll/jquery.mCustomScrollbar.concat.min.js"></script>
<cfparam name="attributes.width" default="130">
<cfparam name="attributes.table_name" default="">
<cfparam name="attributes.wrk_list_object_id" default="">
<cfparam name="attributes.wrk_list_object_name" default="">
<cfparam name="attributes.sub_header_name" default="">
<cfparam name="attributes.header_name" default="">
<cfparam name="attributes.selected" default="">
<cfparam name="attributes.comp" default=""><!--- 0 gelirse bütün markalari listeler 1 gelirse sirket ile iliskili markalari getirir EY 20130827 --->
<cfparam name="attributes.datasource" default="#caller.dsn#">
<cfif isdefined('caller.#attributes.wrk_list_object_name#') and len(Evaluate('caller.#attributes.wrk_list_object_name#'))> <!--- Çağrıldığı sayfadaki input değerini bir listeye atıp gittiği sayfada o listedeki checkbox'ların checked gelmesi için eklendi. EY 20132012 --->
	<cfset attributes.selected = Evaluate('caller.#attributes.wrk_list_object_name#')>
</cfif>
<cfset url_adres ='&wrk_list_object_id=#attributes.wrk_list_object_id#&wrk_list_object_name=#attributes.wrk_list_object_name#&table_name=#attributes.table_name#&width=#attributes.width#&datasource=#attributes.datasource#&sub_header_name=#attributes.sub_header_name#&header_name=#attributes.header_name#&selected=#attributes.selected#&comp=#attributes.comp#'>  
<cfoutput>
<table border="0" align="left" cellpadding="0" cellspacing="0">
	<div class="col col-12 col-xs-12">
		<div class="input-group">
        	<input type="hidden" name="#attributes.wrk_list_object_id#" id="#attributes.wrk_list_object_id#" value="<cfif isdefined('caller.#attributes.wrk_list_object_id#') and len(Evaluate('caller.#attributes.wrk_list_object_id#'))>#Evaluate('caller.#attributes.wrk_list_object_id#')#</cfif>">
			<input type="text" name="#attributes.wrk_list_object_name#" id="#attributes.wrk_list_object_name#" value="<cfif isdefined('caller.#attributes.wrk_list_object_name#') and len(Evaluate('caller.#attributes.wrk_list_object_name#'))>#Evaluate('caller.#attributes.wrk_list_object_name#')#</cfif>" style="width:#attributes.width#px;">
			<span class="input-group-addon btnPointer icon-ellipsis" title="#attributes.header_name#" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ajax_list_items#url_adres#');"></span>
		</div>
	</div>
</table>
</cfoutput>
