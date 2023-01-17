<cfparam name="attributes.announce_id" default="">
<cfform name="add_announce">
	<cf_form_box title="#getLang('main',2203)#">

		<div class="row">
			<div class="col col-12 col-xs-12 uniqueRow">
				<div class="row formContent">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<div class="col col-12 col-xs-12">
							<div class="form-group" id="item-announce_head">
								<label class="col col-2 col-xs-12"><cf_get_lang_main no='1408.Başlık'> *</label>
								<div class="col col-7 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
									<cfinput type="text" name="announce_head" style="width:500px" id="announce_head" required="yes" message="#message#" value="" maxlength="125">
								</div>
							</div>
						</div>
						<div class="col col-12 col-xs-12">
							<div class="form-group" id="item-start_date">
								<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='58053. Başlangıç Tarihi'> * </label>
								<div class="col col-7 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58053. Başlangıç Tarihi'></cfsavecontent>
										<cfinput validate="#validate_style#" required="yes" message="#message#" type="text" name="start_date" id="start_date" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									</div>
								</div>
							</div>
						</div>

						<div class="col col-12 col-xs-12">
							<div class="form-group" id="item-start_date">
								<label class="col col-2 col-xs-12"><cf_get_lang_main dictionary_id='57700.Bitis tarihi'> *  </label>
								<div class="col col-7 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang_main dictionary_id='57700.Bitis tarihi'></cfsavecontent>
										<cfinput validate="#validate_style#" required="yes" message="#message#" type="text" name="finish_date" id="finish_date" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
							</div>
						</div>

						<div class="col col-12 col-xs-12">
							<div class="form-group">
								<label class="col col-2 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
								<div class="col col-7 col-xs-12 paddingNone">
									<cfmodule
										template="/fckeditor/fckeditor.cfm"
										toolbarSet="WRKContent"
										basePath="/fckeditor/"
										instanceName="detail"
										valign="top"
										value=""
										width="400"
										height="300"
									>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<cf_form_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'></cf_form_box_footer>
	</cf_form_box>
</cfform>

<script type="text/javascript">
	function kontrol()
	{
		
		if(document.add_announce.start_date.value != '' && document.add_announce.finish_date.value != '' )
		{
			return date_check(add_announce.start_date,add_announce.finish_date,"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !");
		}
		return OnFormSubmit();
	}
	
</script>
