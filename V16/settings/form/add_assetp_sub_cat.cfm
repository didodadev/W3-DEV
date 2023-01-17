<cf_get_lang_set module_name="settings">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Fiziki Varlık Alt Kategorileri','59283')#" add_href="#request.self#?fuseaction=settings.add_assetp_sub_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_assetp_sub_cat.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="add_assetp_sub_cat" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_assetp_sub_cat">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-GET_ASSET_P_CAT">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<select name="assetp_cat" id="assetp_cat">
									<option value=""><cf_get_lang dictionary_id="57734.Seciniz"></option>
									<cfoutput query="GET_ASSET_P_CAT">
										<option value="#ASSETP_CATID#">#ASSETP_CAT#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-assetp_sub_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61282.Servis Alt Kategorisi'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfinput type="text" name="assetp_sub_cat" id="assetp_sub_cat" value="" maxlength="150" size="60">
							</div>
						</div>
						<div class="form-group" id="item-assetp_detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<textarea name="assetp_detail" id="assetp_detail" value=""></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</cf_box_footer>
			</cfform>
		</div>
		</td>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('assetp_sub_cat').focus();
	function kontrol()
	{
		if(document.getElementById('assetp_cat').value=="")
		{
			alert("<cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'> !");
			document.getElementById('assetp_cat').focus();
			return false;
			}
		if(document.getElementById('assetp_sub_cat').value == "")
		{			
			alert("<cf_get_lang dictionary_id='49552.Alt Kategori'> <cf_get_lang dictionary_id='57734.Seçiniz'> !");
			document.getElementById('assetp_sub_cat').focus();
			return false;
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
