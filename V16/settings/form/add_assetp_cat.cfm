<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='58021.ÖTV'></cfsavecontent>
	<cf_box title="#getLang('','Fiziki Varlık Kategorileri','42235')#" add_href="#request.self#?fuseaction=settings.add_assetp_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_assetp_cat.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="assetp_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_assetp_cat">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-assetp_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='33281.Kategori Girmelisiniz'></cfsavecontent>
								<cfinput type="Text" name="assetp_cat" size="60" value="" maxlength="50" required="Yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-assetp_reserve">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42309.Rezerve Edilir'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<input type="checkbox" name="assetp_reserve" id="assetp_reserve" value="1">
							</div>
						</div>
						<div class="form-group" id="item-it_asset">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31848.IT Varlıkları'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<input type="checkbox" name="it_asset" id="it_asset" value="1" onclick="kontrol2();">
							</div>
						</div>
						<div class="form-group" id="item-motorized_vehicle">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42311.Motorlu Taşıt'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
								<input type="checkbox" name="motorized_vehicle" id="motorized_vehicle" value="1" onclick="kontrol();">
							</div>
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
function kontrol()
{
	if (document.assetp_cat.it_asset.checked == true )
	{  
		alert("<cf_get_lang dictionary_id='42813.Aynı Anda İki Kategori Seçemezsiniz'>!");
		document.assetp_cat.it_asset.checked = false;
		document.assetp_cat.motorized_vehicle.checked = false;
		return false;
	}
	
}
function kontrol2()
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
