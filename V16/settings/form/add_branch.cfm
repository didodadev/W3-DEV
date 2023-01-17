<cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
<cfset get_api_key = googleapi.get_api_key()>
<cf_get_lang_set module_name="settings">
<cfquery name="GET_BRANCH_CAT" datasource="#DSN#">
	SELECT 
		BRANCH_CAT_ID,
		#dsn#.Get_Dynamic_Language(BRANCH_CAT_ID,'#session.ep.language#','SETUP_BRANCH_CAT','BRANCH_CAT',NULL,NULL,BRANCH_CAT) AS BRANCH_CAT
		FROM SETUP_BRANCH_CAT ORDER BY BRANCH_CAT
</cfquery>
<cfif not (isdefined("attributes.isAjax") and attributes.isAjax eq 1)>
	<cf_catalystHeader>
</cfif>

<cfform name="branch" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_branch_add" method="post" enctype="multipart/form-data">
	<cfif isdefined("attributes.isAjax") and attributes.isAjax eq 1><!--- Organizasyon Yönetimi sayfasıdan ajax ile çağırıldıysa 20190912ERU --->
		<input type="hidden" name="callAjaxBranch" id="callAjaxBranch" value="1">		
	</cfif>
	<input type="hidden" name="fuse" id="fuse" value="<cfoutput>#fusebox.circuit#</cfoutput>">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id = "29434.Şubeler"> : <cf_get_lang dictionary_id = "45697.Yeni Kayıt"></cfsavecontent>
 	<cfif isDefined("attributes.isAjax") and attributes.isAjax eq 1><!--- Organizasyon Yönetimi sayfasından Ajax ile yüklendiyse --->
		<cf_box title="#title#" closable="0">
	</cfif>
	<div class="formContent margin-0">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-status">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='344.durum'></label>
					<div class="col col-9 col-xs-12 padding-0">
						<div class="col col-6 col-xs-12"> 
							<label><input type="checkbox" value="1" name="branch_status" id="branch_status" checked><cf_get_lang_main no='81.Aktif'> </label>
						</div>
						<div class="col col-6 col-xs-12"> 
							<label><input type="checkbox" value="1" name="is_internet" id="is_internet"><cf_get_lang no='113.internet'> </label>
						</div>
						<div class="col col-6 col-xs-12"> 
							<label><input type="checkbox" value="1" name="is_organization" id="is_organization" checked><cf_get_lang no='953.Org Şemada Göster'> </label>
						</div>
						<div class="col col-6 col-xs-12"> 
							<label><input type="checkbox" value="1" name="is_production" id="is_production"><cf_get_lang no ='75.Üretim Yapılıyor'></label>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-ZONES">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='580.Bölge'></label>
					<div class="col col-9 col-xs-12"> 
						<cfquery name="ZONES" datasource="#DSN#">
							SELECT ZONE_NAME, ZONE_ID, ZONE_STATUS FROM ZONE ORDER BY ZONE_NAME
						</cfquery>
						<select name="zone_ID" id="zone_ID" style="width:200px;">
							<cfif zones.recordcount>
							<cfoutput query="zones">
								<option value="#zone_id#">#zone_name# <cfif not zone_status>(Pasif)</cfif>
							</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-branch_fullname">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='1735.Şube Adı'> *</label>
					<div class="col col-9 col-xs-12"> 
						<cfsavecontent variable="message"><cf_get_lang no='488.Şube Adı girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="branch_fullname" id="branch_fullname" value="" maxlength="250" required="yes" message="#message#" style="width:200px;">
					</div>
				</div>
				<div class="form-group" id="item-branch_name">
					<label class="col col-3 col-xs-12"><cf_get_lang no='689.Şube Kısa Adı'> *</label>
					<div class="col col-9 col-xs-12"> 
						<cfsavecontent variable="message"><cf_get_lang no='703.Şube Kısa Adı girmelisiniz'></cfsavecontent>
						<cfinput name="branch_name" id="branch_name" style="width:200px;" value="" maxlength="50" required="Yes" message="#message#">
					</div>
				</div>
				<div class="form-group" id="item-admin1_position">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='1714.Yönetici'> 1</label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<input type="hidden" name="admin1_position_code" id="admin1_position_code" value="">
							<input type="text" name="admin1_position" id="admin1_position" value="" readonly >
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=branch.admin1_position_code&field_name=branch.admin1_position','list');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-admin2_position">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='1714.Yönetici'> 2</label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<input type="hidden" name="admin2_position_code" id="admin2_position_code" value="">
							<input type="text" name="admin2_position" id="admin2_position" value="" readonly style="width:200px;">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=branch.admin2_position_code&field_name=branch.admin2_position','list');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-hierarchy">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='349.Hiyerarşi'> 1 / <cf_get_lang_main no='349.Hiyerarşi'>2</label>
					<div class="col col-9 col-xs-12"> 								
						<div class="input-group">
							<cfinput type="text" name="hierarchy" id="hierarchy" value="" maxlength="75" style="width:98px;">
							<cfif not(isdefined("attributes.isAjax") and len(attributes.isAjax))><span class="input-group-addon no-bg"></span ></cfif>
							<cfinput type="text" name="hierarchy2" id="hierarchy2" value="" maxlength="75" style="width:99px;">
						</div>
					</div>
				</div>
				<div class="form-group" id="item-branch_country">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='807.Ülke'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="text" name="branch_country" id="branch_country" style="width:200px;" value="" maxlength="20">
					</div>
				</div>
				<div class="form-group" id="item-branch_City">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='559.Şehir'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="text" name="branch_City" id="branch_City" style="width:200px;" value="" maxlength="20">
					</div>
				</div>
				<div class="form-group" id="item-branch_county">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='1226.İlçe'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="text" name="branch_county" id="branch_county" value="" maxlength="20" style="width:200px;">
					</div>
				</div>
				<div class="form-group" id="item-branch_postcode">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='60.Posta Kodu'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="Text" name="branch_postcode" id="branch_postcode" style="width:200px;" onKeyUp="isNumber(this);" value="" maxlength="5">
					</div>
				</div>
				<div class="form-group" id="item-related_company">
					<label class="col col-3 col-xs-12"><cf_get_lang no='1320.İlgili Şirket'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="Text" name="related_company" id="related_company" style="width:200px;" value="" maxlength="130">
					</div>
				</div>
				<div class="form-group" id="item-ozel_kod">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="Text" name="ozel_kod" id="ozel_kod" style="width:200px;" value="" maxlength="50">
					</div>
				</div>
				<div class="form-group" id="item-related_branch_name">
					<label class="col col-3 col-xs-12"><cf_get_lang no ='1730.İlişkili Şube'></label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<input type="hidden" name="related_branch_id" id="related_branch_id" value="">
							<input type="text" name="related_branch_name" id="related_branch_name" value="" maxlength="50" style="width:200px;">
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
						<select name="COMPANY_ID" id="COMPANY_ID" style="width:505px;">
							<option value=""><cf_get_lang_main no='162.Şirket'></option>
							<cfif our_company.recordcount>
							<cfoutput query="our_company">
								<option value="#comp_id#" <cfif isDefined("attributes.comp_id") and attributes.comp_id eq comp_id>selected<cfelseif currentrow is 1></cfif>>#company_name#</option>
							</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-branch_tel1">
					<label class="col col-3 col-xs-12"><cf_get_lang no='381.Tel Kod - Tel'>1</label>
					<cfsavecontent variable="message"><cf_get_lang no='669.Tel Kod - Tel girmelisiniz'></cfsavecontent>
					<div class="col col-2 col-xs-3"> 
						<input type="text" name="branch_telcode" id="branch_telcode" value="" maxlength="10" onkeyup="isNumber(this);" style="width:50px;">
					</div>
					<div class="col col-7 col-xs-9">
						<cfinput type="text" name="branch_tel1" value="" maxlength="10" validate="integer"  message="#message#" onkeyup="isNumber(this);" style="width:97px;">
					</div>
				</div>
				<div class="form-group" id="item-branch_tel2">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='87.Telefon'> 2</label>
					<div class="col col-9 col-xs-12"> 
						<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
						<cfinput type="Text" name="branch_tel2" id="branch_tel2" value="" maxlength="10" validate="integer"  message="#message#" onkeyup="isNumber(this);" style="width:150px;">
					</div>
				</div>
				<div class="form-group" id="item-branch_tel3">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='87.Telefon'> 3</label>
					<div class="col col-9 col-xs-12"> 
						<cfsavecontent variable="message"><cf_get_lang no='707.Telefon girmelisiniz'></cfsavecontent>
						<cfinput type="Text" name="branch_tel3" id="branch_tel3" style="width:150px;" validate="integer"  message="#message#" onkeyup="isNumber(this);"  value="" maxlength="10">
					</div>
				</div>
				<div class="form-group" id="item-branch_fax">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='76.Faks'></label>
					<div class="col col-9 col-xs-12"> 
						<cfsavecontent variable="message"><cf_get_lang no='706.Faks girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="branch_fax" id="branch_fax" style="width:150px;" value="" maxlength="10" validate="integer" onkeyup="isNumber(this);"  message="#message#">
					</div>
				</div>
				<div class="form-group" id="item-branch_email">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='16.E-mail'></label>
					<div class="col col-9 col-xs-12"> 
						<input type="text" name="branch_email" id="branch_email" style="width:150px;" value="" maxlength="50">
					</div>
				</div>
				<div class="form-group" id="item-tax_office">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='1350.Vergi Dairesi'></label>
					<div class="col col-9 col-xs-12"> 
						<cfinput type="text" name="tax_office" id="tax_office" value="" maxlength="50" style="width:150px;">
					</div>
				</div>
				<div class="form-group" id="item-tax_no">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='340.Vergi No'></label>
					<div class="col col-9 col-xs-12"> 
						<cfsavecontent variable="message"><cf_get_lang no='712.Vergi No girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="tax_no" id="tax_no" value="" validate="integer" message="#message#" onKeyUp="isNumber(this);" style="width:150px;">
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
						<textarea name="branch_address" id="branch_address" style="width:150px;height:70px;"></textarea>
					</div>
				</div>
				<div class="form-group" id="item-coordinates">
					<label class="col col-3 col-xs-12"><cf_get_lang_main no='1137.Koordinatlar'></label>
					<div class="col col-9 col-xs-12"> 
						<div class="input-group">
							<cfinput type="text" maxlength="10" range="-90,90" message="Lütfen enlem değerini -90 ile 90 arasında giriniz!" value="" name="coordinate_1" id="coordinate_1" style="width:65px;">
							<span class="input-group-addon"><cfoutput>#getLang('settings',670)#</cfoutput></span>
							<span class="input-group-addon no-bg"></span>
							<cfinput type="text" maxlength="10"  range="-180,180" message="Lütfen boylam değerini -180 ile 180 arasında giriniz!" value="" name="coordinate_2" id="coordinate_2" style="width:65px;">
							<span class="input-group-addon"><cfoutput>#getLang('hr',650)#</cfoutput></span>
							<cfif len(get_api_key.GOOGLE_API_KEY) gt 10><span class="input-group-addon no-bg"></span><span class="input-group-addon"><cfoutput><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=hr.list_branches&event=googleMap&type=add','medium')"><i class="fa fa-map-marker"></i></a></cfoutput></span></cfif>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-branch_cat">
					<label class="col col-3 col-xs-12"><cf_get_lang no='1261.Sube Tipi'></label>
					<div class="col col-9 col-xs-12"> 
						<select name="branch_cat" id="branch_cat" style="width:153px;">
							<option value=""><cf_get_lang_main no='322.Seciniz'></option>
							<cfoutput query="get_branch_cat">
								<option value="#branch_cat_id#">#branch_cat#</option>
							</cfoutput>
						</select>
					</div>
				</div>						
			</div>
		</cf_box_elements>	
		<div class="ui-form-list-btn">	
			<cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()'>
		</div>
	</div>					
</cfform>

<script type="text/javascript">
function kontrol()
{
	if (document.getElementById('COMPANY_ID').options[document.getElementById('COMPANY_ID').selectedIndex].value == '')
	{
		alert("<cf_get_lang no='1449.Lütfen Şirket Seçiniz'>. <cf_get_lang no='1450.Eğer Kayıtlı Bir Şirket Yoksa Önce Şirket Tanımlayınız'>.");
	  	return false;
	} 
	if((document.getElementById('coordinate_1').value.length != "" && document.getElementById('coordinate_2').value.length == "") || (document.getElementById('coordinate_1').value.length == "" && document.getElementById('coordinate_2').value.length != ""))
	{
		alert ("Lütfen koordinat değerlerini eksiksiz giriniz!");
		return false;
	}
	return true;
}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
