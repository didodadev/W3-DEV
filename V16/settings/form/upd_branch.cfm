<cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
<cfset get_api_key = googleapi.get_api_key()>
<cf_get_lang_set module_name="settings">
<cfinclude template="../query/get_branch_dep_count.cfm">
<cfset active_dep = 0>
<cfquery name="CATEGORY" datasource="#DSN#">
	SELECT 
    	* 
    FROM 
	    BRANCH 
    WHERE 
    	BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
<cfquery name="get_dep" datasource="#dsn#">
	SELECT DEPARTMENT_STATUS FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND DEPARTMENT_STATUS = 1
</cfquery>
<cfif get_dep.recordcount>
	<cfset active_dep = 1>
</cfif>
<cfquery name="GET_BRANCH_CAT" datasource="#DSN#">
	SELECT 
		BRANCH_CAT_ID,
		#dsn#.Get_Dynamic_Language(BRANCH_CAT_ID,'#session.ep.language#','SETUP_BRANCH_CAT','BRANCH_CAT',NULL,NULL,BRANCH_CAT) AS BRANCH_CAT
		FROM SETUP_BRANCH_CAT ORDER BY BRANCH_CAT
</cfquery>
<cfset attributes.head="">
<cfif not(isdefined("attributes.isAjax") and len(attributes.isAjax))>
	<cf_catalystHeader>
</cfif>
<cfform method="post" name="branch" enctype="multipart/form-data" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_branch_upd">
    <input type="hidden" id="fuse" value="<cfoutput>#fusebox.circuit#</cfoutput>" name="fuse">
    <cfoutput>
        <input type="hidden" name="branch_id" id="branch_id" value="#attributes.id#">
		<input type="hidden" name="id" id="id" value="#attributes.id#">
		<input type="hidden" name="head" id="head" value="#category.branch_name#">
		<cfif isdefined("attributes.isAjax") and len(attributes.isAjax)>
			<input type="hidden" name="callAjaxBranch" id="callAjaxBranch" value="1">  
			<input type="hidden" name="comp_id" id="callAjaxBranch" value="#attributes.comp_id#">  			      
		</cfif>
    </cfoutput>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id = "29434.Şubeler"></cfsavecontent>
	<cfif isDefined("attributes.isAjax") and attributes.isAjax eq 1><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
		<cf_box title="#title#" closable="0">
	</cfif>
	
				<div class="formContent margin-0">
					<cf_box_elements>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-status">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='344.durum'></label>
								<div class="col col-9 col-xs-12"> 
									<label><input type="checkbox" name="branch_status" id="branch_status" <cfif category.branch_status> checked</cfif> value="1"><cf_get_lang_main no='81.aktif'> </label>
									<label><input type="checkbox" name="is_internet" id="is_internet" <cfif category.is_internet eq 1> checked</cfif> value="1"><cf_get_lang no='113.internet'> </label>
									<label><input type="checkbox" name="is_organization" id="is_organization" <cfif category.is_organization eq 1> checked</cfif> value="1"><cf_get_lang no='953.Org Şemada Göster'> </label>
									<label><input type="checkbox" name="is_production" id="is_production" <cfif category.IS_PRODUCTION eq 1> checked</cfif>><cf_get_lang no='75.Üretim Yapılıyor'></label>
								</div>
							</div>
							<div class="form-group" id="item-ZONES">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='580.Bölge'></label>
								<div class="col col-9 col-xs-12"> 
									<cfquery name="ZONES" datasource="#DSN#">
										SELECT ZONE_NAME, ZONE_ID, ZONE_STATUS FROM ZONE ORDER BY ZONE_NAME
									</cfquery>
									<select name="zone_ID" id="zone_ID" style="width:200px;">
										<cfif category.recordcount gte 1>
											<cfoutput query="zones">
												<option value="#zone_id#" <cfif category.zone_id eq zones.zone_id> selected</cfif>>#zone_name#<cfif not zones.zone_status>- (Pasif)</cfif>
											</cfoutput>
										</cfif>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-branch_fullname">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1735.Şube Adı'> *</label>
								<div class="col col-9 col-xs-12"> 
									<cfsavecontent variable="message"><cf_get_lang no='488.Şube Adı Girmelisiniz !'></cfsavecontent>
									<cfinput type="text" name="branch_fullname" id="branch_fullname" value="#category.branch_fullname#" maxlength="250" required="Yes" message="#message#" style="width:200px;">
								</div>
							</div>
							<div class="form-group" id="item-branch_name">
								<label class="col col-3 col-xs-12"><cf_get_lang no='689.Şube Kısa Adı'> *</label>
								<div class="col col-9 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang no='703.Şube Kısa Adı girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="branch_name" id="branch_name" value="#category.branch_name#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
								</div>
							</div>
							<div class="form-group" id="item-admin1_position">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1714.Yönetici'> 1</label>
								<div class="col col-9 col-xs-12"> 
									<div class="input-group">
										<input type="hidden" name="admin1_position_code" id="admin1_position_code" value="<cfoutput>#category.admin1_position_code#</cfoutput>">
										<cfif len(category.admin1_position_code)>
											<cfset attributes.employee_id = "">
											<cfset attributes.position_code = category.admin1_position_code>
											<cfinclude template="../query/get_position.cfm">
											<input type="text" name="admin1_position" id="admin1_position" style="width:200px;"  value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>">
										<cfelse>
											<input type="text" name="admin1_position" id="admin1_position" style="width:200px;"  value="" readonly>
										</cfif>
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=branch.admin1_position_code&field_name=branch.admin1_position','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-admin2_position">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1714.Yönetici'> 2</label>
								<div class="col col-9 col-xs-12"> 
									<div class="input-group">
										<input type="hidden" name="admin2_position_code" id="admin2_position_code" value="<cfoutput>#category.admin2_position_code#</cfoutput>">
										<cfif len(category.admin2_position_code)>
											<cfset attributes.employee_id = "">
											<cfset attributes.position_code = category.admin2_position_code>
											<cfinclude template="../query/get_position.cfm">
											<input type="text" name="admin2_position" id="admin2_position" style="width:200px;" value="<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>">
										<cfelse>
											<input type="text" name="admin2_position" id="admin2_position" style="width:200px;" value="" readonly>
										</cfif>
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen ('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=branch.admin2_position_code&field_name=branch.admin2_position','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-hierarchy">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='349.Hiyerarşi'> 1 / <cf_get_lang_main no='349.Hiyerarşi'>2</label>
								<div class="col col-9 col-xs-12"> 								
									<div class="input-group">
										<cfinput type="text" name="HIERARCHY" id="HIERARCHY" value="#category.hierarchy#" maxlength="75" style="width:98px;">
										<span class="input-group-addon no-bg"></span>
										<cfinput type="text" name="HIERARCHY2" id="HIERARCHY2" value="#category.hierarchy2#" maxlength="75" style="width:99px;">
									</div>
								</div>
							</div>
							<div class="form-group" id="item-branch_country">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='807.Ülke'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="Text" name="branch_Country" id="branch_Country" style="width:200px;" value="<cfoutput>#category.branch_country#</cfoutput>" maxlength="20">
								</div>
							</div>
							<div class="form-group" id="item-branch_City">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
								<div class="col col-9 col-xs-12"> 
									<cfoutput><input type="Text" name="branch_City" id="branch_City" style="width:200px;" value="#category.branch_city#" maxlength="20"></cfoutput>
								</div>
							</div>
							<div class="form-group" id="item-branch_county">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1226.İlçe'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="text" name="branch_county" id="branch_county" style="width:200px;" value="<cfoutput>#category.branch_county#</cfoutput>" maxlength="20">
								</div>
							</div>
							<div class="form-group" id="item-branch_postcode">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="Text" name="branch_postcode" id="branch_postcode" style="width:200px;" value="<cfoutput>#category.branch_postcode#</cfoutput>" onKeyUp="isNumber(this);" maxlength="5">
								</div>
							</div>
							<div class="form-group" id="item-related_company">
								<label class="col col-3 col-xs-12"><cf_get_lang no='1320.İlgili Şirket'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="text" name="related_company" id="related_company" style="width:200px;" value="<cfoutput>#category.RELATED_COMPANY#</cfoutput>" maxlength="130">
								</div>
							</div>
							<div class="form-group" id="item-ozel_kod">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="text" name="ozel_kod" id="ozel_kod" style="width:200px;" value="<cfoutput>#category.ozel_kod#</cfoutput>" maxlength="50">
								</div>
							</div>
							<div class="form-group" id="item-related_branch_name">
								<label class="col col-3 col-xs-12"><cf_get_lang no ='1730.İlişkili Şube'></label>
								<div class="col col-9 col-xs-12"> 
									<div class="input-group">
										<cfif len(category.related_branch_id)>
											<cfquery name="get_related_branch" datasource="#DSN#">
												SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #category.related_branch_id#
											</cfquery>
										</cfif>
										<input type="hidden" name="related_branch_id" id="related_branch_id" value="<cfoutput>#category.related_branch_id#</cfoutput>">
										<input type="text" name="related_branch_name" id="related_branch_name" value="<cfif len(category.related_branch_id)><cfoutput>#get_related_branch.branch_name#</cfoutput></cfif>" maxlength="50" style="width:200px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen ('<cfoutput>#request.self#?fuseaction=objects.popup_list_related_branches&branch_id=branch.related_branch_id&branch_name=branch.related_branch_name</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-COMPANY_ID">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='162.Şirket'></label>
								<div class="col col-9 col-xs-12"> 
									<cfinclude template="../query/get_our_companies.cfm">
									<select name="company_id" id="company_id" style="width:500px;">
										<cfif our_company.recordcount>
											<cfoutput query="our_company">
												<option value="#comp_id#" <cfif category.company_id eq our_company.comp_id> selected</cfif>>#company_name#</option>
											</cfoutput>
										</cfif>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-branch_tel1">
								<label class="col col-3 col-xs-12"><cf_get_lang no='381.Tel Kod - Tel'>1</label>
								<cfsavecontent variable="message"><cf_get_lang no='669.Tel Kod - Tel girmelisiniz'></cfsavecontent>
								<div class="col col-2 col-xs-3"> 
									<cfinput type="text" name="branch_telcode" id="branch_telcode" value="#category.branch_telcode#" validate="integer" onKeyUp="isNumber(this);" message="#message#" style="width:50px;">
								</div>
								<div class="col col-7 col-xs-9">
									<cfinput type="text" name="branch_tel1" id="branch_tel1" value="#category.branch_tel1#" maxlength="10" validate="integer" onKeyUp="isNumber(this);"  message="#message#" style="width:97px;">
								</div>
							</div>
							<div class="form-group" id="item-branch_tel2">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='87.Telefon'> 2</label>
								<div class="col col-9 col-xs-12"> 
									<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="branch_tel2" id="branch_tel2" style="width:150px;" value="#category.branch_tel2#" maxlength="10" validate="integer" onKeyUp="isNumber(this);" message="#message#" >
								</div>
							</div>
							<div class="form-group" id="item-branch_tel3">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='87.Telefon'> 3</label>
								<div class="col col-9 col-xs-12"> 
									<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="branch_tel3" id="branch_tel3" value="#category.branch_tel3#" maxlength="10" validate="integer"  message="#message#" onKeyUp="isNumber(this);" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-branch_fax">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='76.Faks'></label>
								<div class="col col-9 col-xs-12"> 
									<cfsavecontent variable="message"><cf_get_lang no='706.Fax girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="branch_fax" id="branch_fax" value="#category.branch_fax#" maxlength="10" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-branch_email">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='16.E-mail'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="text" name="branch_email" id="branch_email" value="<cfoutput>#category.branch_email#</cfoutput>" maxlength="50" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-tax_office">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1350.Vergi Dairesi'></label>
								<div class="col col-9 col-xs-12"> 
									<cfinput type="text" name="tax_office" id="HIERARCHY2" value="#category.branch_tax_office#" maxlength="50" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-tax_no">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='340.Vergi No'></label>
								<div class="col col-9 col-xs-12"> 
									<cfsavecontent variable="message"><cf_get_lang no='712.Vergi No girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="tax_no" id="tax_no" value="#category.branch_tax_no#" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-ASSET1">
								<label class="col col-3 col-xs-12"><cf_get_lang no='383.Dış Görünüm'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="file" name="ASSET1" id="ASSET1" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-">
								<label class="col col-3 col-xs-12"><cf_get_lang no='384.Kroki'></label>
								<div class="col col-9 col-xs-12"> 
									<input type="file" name="ASSET2" id="ASSET2" style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-branch_address">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1311.Adres'></label>
								<div class="col col-9 col-xs-12"> 
									<textarea name="branch_address" id="branch_address" style="width:150px;height:70px;"><cfoutput>#category.branch_address#</cfoutput></textarea>
								</div>
							</div>
							<div class="form-group" id="item-branch_address">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30253.Kullanıcı Dostu URL'></label>
								<div class="col col-9 col-xs-12"> 
									<cf_publishing_settings fuseaction="hr.list_branches" event="det" action_type="BRANCH_ID" action_id="#attributes.id#">
								</div>
							</div>
							<div class="form-group" id="item-coordinates">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='1137.Koordinatlar'></label>
								<div class="col col-9 col-xs-12"> 
									<div class="input-group">
										<cfinput type="text" maxlength="10" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="#category.coordinate_1#" name="coordinate_1" style="width:65px;">
										<span class="input-group-addon"><cfoutput>#getLang('settings',670)#</cfoutput></span>
										<span class="input-group-addon no-bg"></span>
										<cfinput type="text" maxlength="10" range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="#category.coordinate_2#" name="coordinate_2" style="width:65px;">
										<span class="input-group-addon"><cfoutput>#getLang('hr',650)#</cfoutput></span>
										<!--- <cfif len(category.coordinate_1) and len(category.coordinate_2)>
											<span class="input-group-addon no-bg"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#category.coordinate_1#&coordinate_2=#category.coordinate_2#&title=#category.branch_name#','list')"><img src="/images/branch.gif" border="0" alt="Haritada Göster" align="absmiddle"></a></cfoutput></span>
										</cfif> --->
										<cfif len(get_api_key.GOOGLE_API_KEY) gt 10>
                                            <span class="input-group-addon no-bg"></span>
                                            <span class="input-group-addon"><cfoutput><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.list_branches&type=upd&event=googleMap&address=#category.branch_address#&coords=#category.coordinate_1#,#category.coordinate_2#','medium')"><i class="fa fa-map-marker"></i></a></cfoutput></span>
                                        </cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-branch_cat">
								<label class="col col-3 col-xs-12"><cf_get_lang no='1261.Sube Tipi'></label>
								<div class="col col-9 col-xs-12"> 
									<select name="branch_cat" id="branch_cat" style="width:153px;">
										<option value=""><cf_get_lang_main no='322.Seciniz'></option>
										<cfoutput query="get_branch_cat">
											<option value="#branch_cat_id#" <cfif category.branch_cat_id eq branch_cat_id> selected</cfif>>#branch_cat#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<cfif len(category.asset_file_name1)>
								<div class="form-group" id="item-del_asset1">
									<label class="col col-3 col-xs-12"><cf_get_lang no='606.Dış Görünüm Sil'></label>
									<div class="col col-9 col-xs-12"> 
										<cf_get_server_file output_file="settings/#category.asset_file_name1#" output_server="#CATEGORY.asset_file_name1_server_id#" output_type="2" small_image="/images/branch_plus.gif" image_link="1">
										<input type="checkbox" name="del_asset1" id="del_asset1" value="1">
									</div>
								</div>
							</cfif>
							<cfif len(category.asset_file_name2)>
								<div class="form-group" id="item-del_asset2">
									<label class="col col-3 col-xs-12"><cf_get_lang no='607.Kroki Sil'></label>
									<div class="col col-9 col-xs-12"> 
										<cf_get_server_file output_file="settings/#category.asset_file_name2#" output_server="#CATEGORY.asset_file_name2_server_id#" output_type="2" small_image="/images/branch_black.gif" image_link="1">
										<input name="del_asset2" id="del_asset2" type="checkbox" value="1">
									</div>
								</div>
							</cfif>
						</div>
					</cf_box_elements>
					<div class="ui-form-list-btn">	
						<div class="col col-6"><cf_record_info query_name="category"></div>
						<div class="col col-6">
							<cfif get_branch_dep_count.recordcount>
								<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
							<cfelse>
								<cfif fusebox.circuit eq 'hr'>						
									<cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function='kontrol()'>
								<cfelse>
									<cf_workcube_buttons type_format="1" is_upd='1' is_delete='1'add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_branch_del&branch_id=#URL.ID#&head=#category.branch_fullname#'>
								</cfif>
							</cfif>
						</div> 
					</div>
				</div>
</cfform>
<script type="text/javascript">
function kontrol()
{
	if((document.getElementById('coordinate_1').value.length != "" && document.getElementById('coordinate_2').value.length == "") || (document.getElementById('coordinate_1').value.length == "" && document.getElementById('coordinate_2').value.length != ""))
	{
		alert ("Lütfen koordinat değerlerini eksiksiz giriniz!");
		return false;
	}
	active_dep = <cfoutput>#active_dep#</cfoutput>;
	if(active_dep==1&&document.getElementById('branch_status').checked==false)
	{
		alert ("Bu şubeye ait aktif depolar ve departmanlar bulunmaktadır!");
		return false;	
	}
	return true;
}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
