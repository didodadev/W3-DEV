<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='58513.Sales Bonuses by Levels'></cfsavecontent>
	<cf_box title="#head#">
		<cfform name="add_sales_premium" action="#request.self#?fuseaction=settings.emptypopup_add_multilevel_sales_premium" method="post">
			<cf_box_elements vertical="1">
				<div class="col col-3 col-md-3 col-sm-4 col-xs-12">
					<div class="form-group">
						<label><cf_get_lang_main no='68.Başlık'>*</label>
						<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık Giriniz'></cfsavecontent>
						<cfinput name="multilevel_premium_name" message="#message#" required="yes">
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='243.Başlama'>*</label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput value="" type="text" maxlength="10" name="start_date" required="yes" message="#message#" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
					<div class="form-group">
						<label><cf_get_lang_main no='288.Bitiş'>*</label>
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
							<cfinput value="" type="text" maxlength="10" name="finish_date" required="yes" message="#message#" 
							validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
					<div class="form-group"><label><cf_get_lang_main no='164.Çalışan'></label><cfinput name="sales_employee_multilevel_premium" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang_main no='1099.Takım'></label><cfinput name="sales_team_multilevel_premium" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang_main no='580.Bölge'></label><cfinput name="sales_zone_multilevel_premium" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>		
				</div>
				<div class="col col-2 col-md-2 col-sm-4 col-xs-12">
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>1 %</label><cfinput name="multilevel_premium_1" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>2 %</label><cfinput name="multilevel_premium_2" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>3 %</label><cfinput name="multilevel_premium_3" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>4 %</label><cfinput name="multilevel_premium_4" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>5 %</label><cfinput name="multilevel_premium_5" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>		
				</div>
				<div class="col col-2 col-md-2 col-sm-4 col-xs-12">
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>6 %</label><cfinput name="multilevel_premium_6" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>7 %</label><cfinput name="multilevel_premium_7" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>8 %</label><cfinput name="multilevel_premium_8" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>9 %</label><cfinput name="multilevel_premium_9" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
					<div class="form-group"><label><cf_get_lang dictionary_id='58710.Kademe'>10 %</label><cfinput name="multilevel_premium_10" class="box" onkeyup="return(FormatCurrency(this,event,4));" value="0"></div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' is_cancel='0' add_function="unformat_fields()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function unformat_fields()
	{
		add_sales_premium.multilevel_premium_1.value = filterNum(add_sales_premium.multilevel_premium_1.value,4);
		add_sales_premium.multilevel_premium_2.value = filterNum(add_sales_premium.multilevel_premium_2.value,4);
		add_sales_premium.multilevel_premium_3.value = filterNum(add_sales_premium.multilevel_premium_3.value,4);
		add_sales_premium.multilevel_premium_4.value = filterNum(add_sales_premium.multilevel_premium_4.value,4);
		add_sales_premium.multilevel_premium_5.value = filterNum(add_sales_premium.multilevel_premium_5.value,4);
		add_sales_premium.multilevel_premium_6.value = filterNum(add_sales_premium.multilevel_premium_6.value,4);
		add_sales_premium.multilevel_premium_7.value = filterNum(add_sales_premium.multilevel_premium_7.value,4);
		add_sales_premium.multilevel_premium_8.value = filterNum(add_sales_premium.multilevel_premium_8.value,4);
		add_sales_premium.multilevel_premium_9.value = filterNum(add_sales_premium.multilevel_premium_9.value,4);
		add_sales_premium.multilevel_premium_10.value = filterNum(add_sales_premium.multilevel_premium_10.value,4);
		add_sales_premium.sales_employee_multilevel_premium.value = filterNum(add_sales_premium.sales_employee_multilevel_premium.value,4);
		add_sales_premium.sales_team_multilevel_premium.value = filterNum(add_sales_premium.sales_team_multilevel_premium.value,4);
		add_sales_premium.sales_zone_multilevel_premium.value = filterNum(add_sales_premium.sales_zone_multilevel_premium.value,4);
	}
</script>

