<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<div class="col col-9">
		<cf_box 
			id="get_calendar" 
			title="#getLang('','Aylık Zaman Harcaması','31156')#"
			box_page="#request.self#?fuseaction=myhome.popup_time_cost_calendar">
		</cf_box>
	</div>
	<div class="col col-3">
		<cf_box 
			id="get_totals"
			title="#getLang('','Aylara Göre Zaman Harcaması','63946')#"
			box_page="#request.self#?fuseaction=myhome.popup_time_cost_total">
		</cf_box>
	</div>
</div>