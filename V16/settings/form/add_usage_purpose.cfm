<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Kullanım Amaçları','47998')#" add_href="#request.self#?fuseaction=settings.form_add_usage_purpose" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_usage_purpose.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="assetp_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_usage_purpose_add">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-usage_purpose">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31020.Kullanım Amacı'> *</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='31020.Kullanım Amacı'> </cfsavecontent>
								<cfinput type="Text" name="usage_purpose" value="" maxlength="50" required="Yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<textarea name="detail" id="detail"  value= "" style="width:150px;height:60px;"></textarea>
							</div>
						</div>
						<div class="form-group" id="item-it_asset">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><input type="checkbox" name="assetp_reserve" id="assetp_reserve" value="1"><cf_get_lang dictionary_id='42309.Rezerve Edilir'></label></div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><input type="checkbox" name="it_asset" id="it_asset" value="1" onclick="control2();"><cf_get_lang dictionary_id='42310.IT Varlıkları'></label></div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><input type="checkbox" name="motorized_vehicle" id="motorized_vehicle" value="1" onclick="control();"><cf_get_lang dictionary_id='42311.Motorlu Taşıt'></label></div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
function control()
{
	if (document.assetp_cat.it_asset.checked == true )
	{  
		alert("<cf_get_lang dictionary_id='42813.Aynı Anda İki Kategori Seçemezsiniz'>!");
		document.assetp_cat.it_asset.checked = false;
		document.assetp_cat.motorized_vehicle.checked = false;
		return false;
	}
	
}
function control2()
{
	if (document.assetp_cat.motorized_vehicle.checked == true )
	{  
		alert("<cf_get_lang dictionary_id='42813.Aynı Anda İki Kategori Seçemezsiniz'>!");
		document.assetp_cat.it_asset.checked = false;
		document.assetp_cat.motorized_vehicle.checked = false;
		return false;
	}
	
}
</script>	



