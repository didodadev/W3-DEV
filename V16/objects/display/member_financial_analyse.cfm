<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','üye','57658')# : #get_par_info(attributes.company_id,1,1,0)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cfinclude template="member_financial_summary.cfm">
			</div>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cfinclude template="member_invoice_tl.cfm">
			</div>
	</cf_box_elements>
	</cf_box>
</div>
