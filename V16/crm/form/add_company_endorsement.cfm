<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Tahmini Ciro Talebi','51584')#">
		<cfform name="add_note" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_company_endorsement">
			<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
			<cfif isdefined("attributes.is_normal_form")><input type="hidden" name="is_normal_form" id="is_normal_form" value="1"></cfif>
			<input type="text" name="is_endors_example" id="is_endors_example" value="" style="display:none;">
			<cf_box_elements>	
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-md-4 col-sm-4 -col-xs-12">&nbsp</label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<label><input type="checkbox" value="1" name="is_active" id="is_active" checked><cf_get_lang dictionary_id='57493.Aktif'></label>
						</div>
					</div>
					<div class="form-group" id="item-consumer_id">
						<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'><cf_get_lang dictionary_id='58527.ID'></label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" readonly name="cust_n" id="cust_n" value="#attributes.consumer_id#">
						</div>
					</div>
					<div class="form-group" id="item-fullname">
						<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52057.Eczane Adı'></label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="fullname" id="fullname" value="#get_par_info(attributes.consumer_id,1,1,0)#">
						</div>
					</div>
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<cf_workcube_process is_upd='0'	process_cat_width='193' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-endorsement_total">
						<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='51565.Yeni Tahmini Ciro'>*</label>
						<div class="col col-4 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="endorsement_total" id="endorsement_total" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
								<span class="input-group-addon width">
									<select name="money_type" id="money_type">
										<cfoutput query="get_money_rate">
											<option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_seperator title="#getLang('','Eczane Bilgi Detayları','52326')#" id="eczane_bilgi_detaylari_">
			<div id="eczane_bilgi_detaylari_">
				<cfinclude template="../display/display_customer_info.cfm">
				<cf_box_elements>
					<div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><textarea style="height:80px;" name="detail" id="detail" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea></div>
						</div>
					</div>
				</cf_box_elements>
			</div>
			<div class="col col-12">
				<cf_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_box_footer>
			</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_note.endorsement_total.value == "")
		{
			alert("<cf_get_lang dictionary_id='51566.Lütfen Tahmini Ciro Değeri Giriniz'>!");
			return false;
		}
		if(document.add_note.detail.value == "")
		{
			alert("<cf_get_lang dictionary_id='52066.Lütfen Açıklama Giriniz'>!");
			return false;
		}
		if(process_cat_control())
		{
			document.add_note.endorsement_total.value = filterNum(document.add_note.endorsement_total.value);
			return true;
		}
		else
			return false;
	}
</script>
