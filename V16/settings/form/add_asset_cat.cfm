<cf_xml_page_edit fuseact="settings.asset_cat">
<cfset popup = "">
<cfif attributes.fuseaction contains 'popup'><cfset popup = "&popup=1"></cfif>
<!--- <cfif not isdefined('attributes.chooseCat')>
<div class="row">
	<div class="col col-12">
		<h4 class="wrkPageHeader"><cf_get_lang no='251.Elektronik Varlık Kategorisi Ekle' module_name='settings'></h4>
	</div>
</div>
</cfif> --->
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='42234.Add Digital Asset Category'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#head#"  add_href="#request.self#?fuseaction=objects.popup_add_asset_cat">
		<div class="col <cfif not isdefined('attributes.chooseCat')> col-4 col-md-4 <cfelse> col-12 </cfif> col-xs-12" id="cat-bar">
			<cfinclude template="../../objects/display/ajax_get_asset_cat.cfm">
			<script>
				$(function(){
					$("#cat-bar").css({"margin-top":"0px"}).show();
				});
				<cfif not isdefined('attributes.chooseCat')>
					function chooseCat(catid){
						<cfif attributes.fuseaction contains 'popup'> 
							document.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_upd_asset_cat&ID='+catid;
						<cfelse>
							document.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_upd_asset_cat&ID='+catid;
						</cfif>
					}
				<cfelse>
					function chooseCat(catid,catname){
						window.opener.<cfoutput>#attributes.form_name#</cfoutput>.<cfoutput>#attributes.field_id#</cfoutput>.value = catid;
						window.opener.<cfoutput>#attributes.form_name#</cfoutput>.<cfoutput>#attributes.field_name#</cfoutput>.value = catname;
						window.close();
					}
				</cfif>
			</script>
		</div>
		<cfif not isdefined('attributes.chooseCat')>
			<div class="col col-8 col-md-8 col-xs-12">
				<cfform name="asset_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_asset_cat_add#popup#">	
					<cf_box_elements vertical="1">
						<div class="col col-12 col-md-12 col-xs-12">
							<div class="form-group" id="item-top_cat">
								<label><cf_get_lang dictionary_id='52581'></label>
									<!---
									<cf_wrk_selectlang
										name="assetcat_id"
										option_name="assetcat"
										option_value="assetcat_id"
										table_name="ASSET_CAT"
										value="#iif(isdefined('attributes.mainCat') and len(attributes.mainCat),"attributes.mainCat",DE(''))#"
										condition=""
										sort_type="assetcat">
									--->
								<div class="input-group">
									<input type="hidden" name="assetcat_id" id="assetcat_id" <cfif isdefined('attributes.mainCat') and len(attributes.mainCat)> value="<cfoutput>#attributes.mainCat#</cfoutput>"</cfif>>
									<input type="text" name="assetcat_name" id="assetcat_name" value="<cfif isdefined('attributes.mainCatName') and len(attributes.mainCatName)><cfoutput>#attributes.mainCatName#</cfoutput></cfif>" onfocus="AutoComplete_Create('assetcat_name','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assetcat_id','','3','130');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=asset_cat&field_id=assetcat_id&field_name=assetcat_name','list');"></span>			
								</div>	
								<label><cf_get_lang dictionary_id='48526'></label>
							</div>
							<div class="form-group" id="item-assetCat">
								<label><cf_get_lang no='316.Varlık Adı' module_name='settings'> *</label>
								<cfsavecontent variable="message"><cf_get_lang no='727.Varlık Adı girmelisiniz' module_name='settings'></cfsavecontent>
								<cfinput type="Text" name="assetCat" size="60" value="" maxlength="50" required="Yes" message="#message#">
							</div>
							<div class="form-group" id="item-assetCat_Path">
								<label><cf_get_lang no='317.Klasör' module_name='settings'> *</label>
								<cfsavecontent variable="message"><cf_get_lang no='721.Klasör girmelisiniz' module_name='settings'></cfsavecontent>
								<cfinput type="Text" name="assetCat_Path" size="30" value="" maxlength="25" required="Yes" onkeyup="textClear(this)" message="#message#">
							</div>
							<div class="form-group" id="item-assetCat_Detail">
								<label><cf_get_lang_main no='217.Açıklama' ></label>
								<input type="Text" name="assetCat_Detail" id="assetCat_Detail" size="60" value="" style="width:150px;" maxlength="50" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 50">
							</div>
							<cfif isdefined("x_show_by_digital_asset_group") and x_show_by_digital_asset_group eq 1>
								<div class="form-group" id="item-assetCat_Detail">
									<label><cf_get_lang dictionary_id="47693"></label>
									<cf_multiselect_check
										table_name="DIGITAL_ASSET_GROUP"
										name="digital_asset_group_id"
										width="150" 
										height="100"
										option_value="GROUP_ID"
										option_name="GROUP_NAME">	
								</div>
							</cfif>
							
							<div class="form-group" id="item-show_Area">
								<label class="col col-6 col-md-6 col-xs-6">										
									<input type="checkbox" name="is_internet" id="is_internet" value="1">
									<cf_get_lang_main no='667.İnternet'>
								</label>
								<label class="col col-6 col-md-6 col-xs-6">
									<input type="checkbox" name="is_extranet" id="is_extranet" value="1">
									<cf_get_lang_main no='607.Extranet'>
								</label>
							</div>
						</div>
						<!---
						<div class="col col-4 col-md-12 col-xs-12">
							<cfsavecontent variable="txt_1"><cf_get_lang no='700.Yetkili Pozisyonlar'></cfsavecontent>
							<cf_workcube_to_cc is_update="0" to_dsp_name="#txt_1#" form_name="asset_cat" str_list_param="1">	
						</div>
						--->
					</cf_box_elements>
					<cf_box_footer>
						<div class="pull-right">
							<cf_workcube_buttons is_upd='0'>
						</div>
					</cf_box_footer>
				</cfform>
			</div>
		</cfif>
	</cf_box>
</div>
<script>
	function textClear(textInput){
		textInput.value = textInput.value.replace(/[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/gi, '');
	}
</script>