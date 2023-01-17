<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfinclude template="../form/add_vehicle_allocate_frame.cfm">
		</cf_box>
	</div>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfsavecontent variable="head"><cf_get_lang dictionary_id='47065.Araç Tahsis İşlemleri'></cfsavecontent>
		<cf_box box_page="#request.self#?fuseaction=assetcare.popup_list_allocate" title="#head#"></cf_box>
	</div>
	