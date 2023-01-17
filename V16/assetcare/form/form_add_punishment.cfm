
<div class="col col-12 col-xs-12">
	<cf_basket_form id="add_punishment">
		<div id="frame_punishment"></div>
		<script>
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=assetcare.popup_add_punishment<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>&assetp_id=#attributes.assetp_id#</cfif></cfoutput>','frame_punishment',1);
		</script>
	</cf_basket_form>
	<cfif isDefined("attributes.assetp_id") and len(attributes.assetp_id)>
		<cf_basket id="add_punishment_bask">
			<cf_box Title="#getlang('','Detay','57771')#" id="frame_punishment_list" box_page="#request.self#?fuseaction=assetcare.popup_list_punishment&style=one#IIf((isdefined('attributes.assetp_id') and len(attributes.assetp_id)),DE("&assetp_id=#attributes.assetp_id#"),DE(""))#"></cf_box>
			<!--- <iframe name="frame_punishment_list" id="frame_punishment_list" frameborder="0" style="position:absolute;" src="<cfoutput>#request.self#?fuseaction=assetcare.popup_list_punishment&style=one<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>&assetp_id=#attributes.assetp_id#</cfif></cfoutput>&iframe=1" width="100%" height="100%"></iframe> --->
		</cf_basket>
	</cfif>
</div>