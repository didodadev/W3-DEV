<cfinclude template="../query/get_know_levels.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_EDU_LEVEL" datasource="#DSN#">
	SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL ORDER BY EDU_LEVEL_ID
</cfquery>
<cfquery name="GET_CV_STATUS" datasource="#DSN#">
	SELECT STATUS_ID,ICON_NAME,STATUS FROM SETUP_CV_STATUS
</cfquery>
<cfquery name="GET_COMPUTER_INFO" datasource="#DSN#">
	SELECT COMPUTER_INFO_ID,COMPUTER_INFO_NAME FROM SETUP_COMPUTER_INFO WHERE COMPUTER_INFO_STATUS = 1
</cfquery>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT BRANCHES_ID,BRANCHES_NAME FROM SETUP_APP_BRANCHES WHERE BRANCHES_STATUS = 1 ORDER BY BRANCHES_ROW_LINE 
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="employe_detail" method="post" action="#request.self#?fuseaction=hr.search_app&event=searchlist">
			<cf_seperator id="basvuru_kriter" title="#getLang('','Başvuru Kriterleri',56188)#"><!---Başvuru Kriterleri--->
			<div id="basvuru_kriter">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
						
						<div class="form-group" id="item-search_app_pos">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='56187.Başvurulardan Ara'></label></div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<label><input type="checkbox" name="search_app_pos" id="search_app_pos" value="1"></label>
							</div>
						</div>
						<div class="form-group" id="item-status_app_pos">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<select name="status_app_pos" id="status_app_pos" style="width:75px;">
										<option value=""><cf_get_lang dictionary_id='57708.Tümü'>	
										<option value="1" selected><cf_get_lang dictionary_id='57493.Aktif'>
										<option value="0"><cf_get_lang dictionary_id='57494.Pasif'>			                        
									</select>
									<span class="input-group-addon no-bg"></span>
									<select name="in_status" id="in_status" style="width:72px;">
										<option value="" <cfif isdefined("attributes.in_status") and attributes.in_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>	
										<option value="1" <cfif isdefined("attributes.in_status") and attributes.in_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='58561.İç'>
										<option value="0" <cfif isdefined("attributes.in_status") and attributes.in_status eq 0>selected</cfif>><cf_get_lang dictionary_id ='58562.Dış'>		                        
									</select>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-date_status">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='34074.Kriter'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="date_status" id="date_status" style="width:150px;">
									<option value="1" <cfif isdefined("attributes.date_status") and  attributes.date_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='57926.Azalan Tarih'>
									<option value="2" <cfif isdefined("attributes.date_status") and attributes.date_status eq 2>selected</cfif>><cf_get_lang dictionary_id ='57925.Artan Tarih'>
									<option value="3" <cfif isdefined("attributes.date_status") and attributes.date_status eq 3>selected</cfif>><cf_get_lang dictionary_id ='56506.Azalan Kayıt No'>
									<option value="4" <cfif isdefined("attributes.date_status") and attributes.date_status eq 4>selected</cfif>><cf_get_lang dictionary_id ='56507.Artan Kayıt No'>
									<option value="5" <cfif isdefined("attributes.date_status") and attributes.date_status eq 5>selected</cfif>><cf_get_lang dictionary_id ='56508.Alfabetik Azalan'>
									<option value="6" <cfif isdefined("attributes.date_status") and attributes.date_status eq 6>selected</cfif>><cf_get_lang dictionary_id ='56509.Alfabetik Artan'>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-position_cat">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="Hidden" name="position_cat_id" id="position_cat_id" value="">
									<cfinput type="text" name="position_cat" style="width:150px;" value="">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=employe_detail.position_cat_id&field_cat=employe_detail.position_cat','list','popup_list_position_cats');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-app_position">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="Hidden" name="position_id" id="position_id" value="" maxlength="50">
									<input type="text" name="app_position" id="app_position"  style="width:150px;" value="">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=employe_detail.position_id&field_pos_name=employe_detail.app_position&show_empty_pos=1','list','popup_list_positions');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-notice_head">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='40088.ilan'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="notice_id" id="notice_id" value="">
									<input type="text" name="notice_head" id="notice_head" value="" style="width:150px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=employe_detail.notice_id&field_name=employe_detail.notice_head');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-company">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" value="" name="company_id" id="company_id">
									<input type="text" name="company" id="company" value="" style="width:150px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=employe_detail.company_id&field_comp_name=employe_detail.company&select_list=7','list','popup_list_all_pars');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-department">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'>/<cf_get_lang dictionary_id='41.Şube'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="our_company_id" id="our_company_id" value="">	
									<input type="hidden" name="department_id" id="department_id" value="">
									<input type="text" name="department" id="department" value="" >
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="branch_id" id="branch_id" value="">
									<input type="text" name="branch" id="branch" value="">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=employe_detail.department_id&field_name=employe_detail.department&field_branch_name=employe_detail.branch&field_branch_id=employe_detail.branch_id&field_our_company_id=employe_detail.our_company_id</cfoutput>','list','popup_list_departments');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-app_date1">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55434.Başvuru Tarihi'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="app_date1" validate="#validate_style#" value="" >
									<span class="input-group-addon"><cf_wrk_date_image date_field="app_date1"></span>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="app_date2" validate="#validate_style#" value="" >
									<span class="input-group-addon"><cf_wrk_date_image date_field="app_date2"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-prefered_city">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55329.Çalışmak İstediği Yer'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="prefered_city" id="prefered_city" style="width:150px; height:65px;" multiple="multiple">
									<option value=""><cf_get_lang dictionary_id ='56175.Tüm Türkiye'></option>			
									<cfoutput query="get_city">
										<option value="#city_id#">#city_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>

						<!--- <div class="input-group">
							<input type="text" name="cargo_price" id="cargo_price" value="" onKeyup='return(FormatCurrency(this,event));' class="moneybox" style="width:90px" value="">
							<span class="input-group-addon width">
								<select name="money_type" id="money_type" style="width:57px">
								<cfoutput query="get_money">
									<option value="#MONEY_ID#">#MONEY#</option> 
								</cfoutput>
								</select>
							</span>
						</div> --->


						<div class="form-group" id="item-salary_wanted1">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55740.İstenen Ücret'></label>
							<div class="col col-3 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='55740.İstenen Ücret'></cfsavecontent>
									<cfinput type="text" name="salary_wanted1" style="width:130px;text-align:right;" validate="float" message="#message#" onkeyup="return(FormatCurrency(this,event));">
								</div>
							</div>
							<div class="col col-5 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="salary_wanted2"  validate="float" class="moneybox" message="#message#" onkeyup="return(FormatCurrency(this,event));">
									<span class="input-group-addon width">
									<select name="salary_wanted_money" id="salary_wanted_money" style="width:50px;">
										<cfoutput query="get_moneys">
											<option value="#money#" <cfif money eq session.ep.money> selected</cfif>>#money#</option> 
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
			</div>
			
			<cf_seperator id="ozgecmis_kriterleri" title="#getLang('','',56190)#"><!---Özgeçmiş Kriterleri--->
			<div id="ozgecmis_kriterleri">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-search_app">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='56189.Özgeçmişlerden Ara'></label></div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<label><input type="checkbox" name="search_app" id="search_app" value="1"></label>
							</div>
						</div>
						<div class="form-group" id="item-status_app">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.durum'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="status_app" id="status_app">
									<option value=""><cf_get_lang dictionary_id='57708.Tümü'>	
									<option value="1" selected><cf_get_lang dictionary_id='57493.Aktif'>
									<option value="0"><cf_get_lang dictionary_id='57494.Pasif'>			                        
									</select>
							</div>
						</div>
						<div class="form-group" id="item-cv_status_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56511.Cv Durumu'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="cv_status_id" id="cv_status_id" style="width:155px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_cv_status">
										<option value="#status_id#">#status#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-header">
							<label class="col col-12 bold"><cf_get_lang dictionary_id='55127.Kimlik Bilgileri'></label>	
						</div>
						<div class="form-group" id="item-app_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="app_name" id="app_name" value="" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-app_surname">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="app_surname" id="app_surname" value="" style="width:150px;">
							</div>
						</div>
						<div class="form-group" id="item-birth_date1">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55745.Yaş'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='55741.Yaş rakamla girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="birth_date1" value="" validate="integer" range="1," maxlength="2" message="#message#" style="width:70px;">
									<span class="input-group-addon no-bg"></span>
									<cfinput type="text" name="birth_date2" value="" validate="integer" range="1," maxlength="2" message="#message#" style="width:70px;">
								</div>
							</div>
						</div>
						<div class="form-group" id="item-birth_place">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" style="width:150px;" name="birth_place" maxlength="100" value="">
							</div>
						</div>
						<div class="form-group" id="item-married">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='55654.Medeni Durum'></label></div>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="checkbox" name="married" id="married" value="0"><cf_get_lang dictionary_id='55744.Bekar'></label>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="checkbox" name="married" id="married" value="1"><cf_get_lang dictionary_id='55743.Evli'></label>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-city">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55641.Nüfusa Kayıtlı Olduğu'> <cf_get_lang dictionary_id='58608.İl'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="city" maxlength="100" value="" style="width:150px;">
							</div>
						</div>
					</div>
				</cf_box_elements>
			</div>
			<cf_seperator id="kisisel" title="#getLang('','',52614)#"><!---Kişisel Bilgiler'--->
			<div id="kisisel">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-sex">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="checkbox" name="sex" id="sex" value="1"><cf_get_lang dictionary_id='58959.Erkek'></label>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="checkbox" name="sex" id="sex" value="0"><cf_get_lang dictionary_id='58958.Kadın'></label>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-martyr_relative">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56139.Şehit Yakını Misiniz'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<label><input type="checkbox" name="martyr_relative" id="martyr_relative" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
							</div>
						</div>
						<div class="form-group" id="item-is_trip">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55328.Seyahat Edebilir mi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<label><input type="checkbox" name="is_trip" id="is_trip" value="1"></label>
							</div>
						</div>
						<div class="form-group" id="item-driver_licence">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55255.Ehliyeti Var mı'>?</label>
							<div class="col col-8 col-md-8 col-sm-4 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<input type="checkbox" name="driver_licence" id="driver_licence" value="1"><cf_get_lang dictionary_id='32335.Ehliyet Sınıf'>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
										SELECT
											LICENCECAT_ID,
											LICENCECAT
										FROM
											SETUP_DRIVERLICENCE
										ORDER BY
											LICENCECAT
									</cfquery>
										<select name="driver_licence_type" id="driver_licence_type" style="width:60px;">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_driver_lis">
											<option value="#licencecat_id#">#licencecat#</option>
										</cfoutput>
										</select>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-defected">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='55614.Özürlü mü'></label></div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="radio" name="defected" id="defected" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
									<label><input type="radio" name="defected" id="defected" value="0"><cf_get_lang dictionary_id='57496.Hayır'></label>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<select name="defected_level" id="defected_level">
										<option value="0">%0</option>
										<option value="10">%10</option>
										<option value="20">%20</option>
										<option value="30">%30</option>
										<option value="40">%40</option>
										<option value="50">%50</option>
										<option value="60">%60</option>
										<option value="70">%70</option>
										<option value="80">%80</option>
										<option value="90">%90</option>
										<option value="100">%100</option>
									</select>
								</div>
							</div>
						</div>
					
						<div class="form-group" id="item-sentenced">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='31670.Hüküm Giydi mi'></label></div>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="radio" name="sentenced" id="sentenced" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
								</div>
								<div class="col col-6 col-md-6 col-sm-6  col-xs-12">
									<label><input type="radio" name="sentenced" id="sentenced" value="0"><cf_get_lang dictionary_id='57496.Hayır'></label>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-military_status">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55619.Askerlik'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="checkbox" name="military_status" id="military_status" value="0"><cf_get_lang dictionary_id='55624.Yapmadı'></label>
									<label><input type="checkbox" name="military_status" id="military_status" value="1"><cf_get_lang dictionary_id='55625.Yaptı'></label>
									<label><input type="checkbox" name="military_status" id="military_status" value="2"><cf_get_lang dictionary_id='55626.Muaf'></label>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="checkbox" name="military_status" id="military_status" value="3"><cf_get_lang dictionary_id='55627.Yabancı'></label>
									<label><input type="checkbox" name="military_status" id="military_status" value="4"><cf_get_lang dictionary_id='55340.Tecilli'></label>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-homecity">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56191.Yaşadığı Yer'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<select name="homecity" id="homecity" multiple onChange="get_county(this.value)">
									<option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
									<cfoutput query="get_city">
										<option value="#city_id#">#city_name#</option>
									</cfoutput>		                        
									</select>
									<span class="input-group-addon no-bg"></span>
									<select name="home_county" id="home_county" multiple>
										<option value="0"><cf_get_lang dictionary_id='58638.İlçe'></option>
									</select>
								</div>
							</div>
						</div>
						<!--- <div class="form-group" id="item-homecity">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56191.Yaşadığı Yer'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<span class="input-group-addon no-bg"></span>
									<select name="home_county" id="home_county" multiple>
										<option value="0"><cf_get_lang dictionary_id='58638.İlçe'></option>
									</select>
								</div>
							</div>
						</div>	 --->
						<div class="form-group">
							<label class="col col-12 bold"><cf_get_lang dictionary_id ='56512.İletişim Bilgileri'></label>
						</div>
						<div class="form-group" id="item-email">	
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-posta'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="email" style="width:150px;" maxlength="100" validate="email" message="E-mail adresinizi kontrol ediniz!">
							</div>
						</div>
					</div>
				</cf_box_elements>
			</div>
				
			<cf_seperator id="egitim" title="#getLang('','Eğitim Bilgileri',30644)#"><!---Eğitim ve Deneyim Bilgileri--->
			<div id="egitim">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-training_level">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55337.Eğitim Seviyesi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<select name="training_level" id="training_level">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<cfoutput query="GET_EDU_LEVEL">
											<option value="#GET_EDU_LEVEL.EDU_LEVEL_ID#">#GET_EDU_LEVEL.EDUCATION_NAME#</option>
										</cfoutput>
									</select>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<cfinput type="text" name="edu_finish" style="width:40px;" maxlength="4" placeholder="#getLang('','bitiş',57502)#">
								</div>
							</div>
						</div>
						<div class="form-group" id="item-exp_year_s1">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56615.Deneyim'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='55256.Deneyimi rakamla giriniz'></cfsavecontent>
									<cfinput name="exp_year_s1" style="width:70px;" value="" validate="integer" range="0,99" maxlength="2" message="#alert#">
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<cfinput name="exp_year_s2" style="width:70px;" value="" validate="integer" range="0,99" maxlength="2" message="#alert#" placeholder="#getLang('','',58455)#">
								</div>
							</div>
						</div>
						<cfquery name="get_lang" datasource="#dsn#">
							SELECT LANGUAGE_ID, LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
						</cfquery>
						<div class="form-group" id="item-get_lang">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="multiselect-z2">
									<cf_multiselect_check
										query_name="get_lang"
										name="lang"
										width="150"
										option_value="LANGUAGE_ID"
										option_name="LANGUAGE_SET"
										option_text="#getLang('','',57734)#">
								</div>
							</div>
						</div>
						<div class="form-group" id="item-lang_level">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56192.Seviye'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12 multiselect-z1">
								<cf_multiselect_check
									query_name="know_levels"
									name="lang_level"
									width="150"
									option_value="KNOWLEVEL_ID"
									option_name="KNOWLEVEL"
									option_text="#getLang('','',57734)#">
							</div>
						</div>
						<div class="form-group" id="item-lang_par">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56193.Dil Arama Kriteri'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='57989.VE'> <input type="radio" name="lang_par" id="lang_par" value="AND" checked></label> 
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='57998.VEYA'> <input type="radio" name="lang_par" id="lang_par" value="OR"></label>
							</div>
						</div>
						<div class="form-group" id="item-is_student">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56363.Öğrenci'> ?</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_student" id="is_student" value="1">
							</div>
						</div>
						<div class="form-group" id="item-is_cont_work">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56513.İş Durumu'>?</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="is_cont_work" id="is_cont_work" style="width:85px;">
									<option value="2"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1"><cf_get_lang dictionary_id ='55755.Çalışıyor'></option>
									<option value="0"><cf_get_lang dictionary_id ='56365.Çalışmıyor'></option>			                        
								</select>
							</div>
						</div>
						<div class="form-group" id="item-internship">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56514.Staj'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="internship" id="internship" style="width:85px;">
									<option value="1"><cf_get_lang dictionary_id ='56213.Aday'></option>
									<option value="2"><cf_get_lang dictionary_id ='56015.Asıl'></option>
									<option value="0" selected><cf_get_lang dictionary_id='57708.Tümü'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-is_formation">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58563.Formasyon'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="is_formation" id="is_formation" style="width:85px; margin-left:2px;" onchange="goster_();">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1"><cf_get_lang dictionary_id ='58564.Var'></option>
									<option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>			                        
								</select>		
							</div>
						</div>
						<div class="form-group" id="formation_type" style="display:none">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="formation_typee" id="formation_typee" multiple style="width:110px; height:62.5px;">
									<option value="1"><cf_get_lang dictionary_id ='56515.Anaokul'></option>
									<option value="2"><cf_get_lang dictionary_id ='56516.İlköğretim'></option>
									<option value="3"><cf_get_lang dictionary_id ='55680.Lise'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-edu3">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56517.Lise Adı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="edu3" style="width:176px;" maxlength="75">
							</div>
						</div>
						<div class="form-group" id="item-high_school">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56517.Lise Adı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="edu3" style="width:176px;" maxlength="75">
							</div>
						</div>
						<div class="form-group" id="item-edu3_part">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56154.Lise Bölümleri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="text"><cf_get_lang dictionary_id='58139.Bölümler'></cfsavecontent>
								<cf_wrk_combo
									name="edu3_part"
									query_name="GET_HIGH_SCHOOL"
									option_value="high_part_id"
									option_name="high_part_name"
									width="175"
									multiple="1"
									option_text="#text#">
							</div>
						</div>
						<cfquery name="get_edu4_name" datasource="#dsn#">
							SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
						</cfquery>
						<div class="form-group" id="item-edu4_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56518.Üniversite Adı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="edu4_id" id="edu4_id" multiple="multiple" style="width:175px;">
								<option value="" selected><cf_get_lang dictionary_id='56196.Tüm Üniversiteler'></option>
								<cfloop query="get_edu4_name">
									<option value="<cfoutput>#get_edu4_name.school_id#</cfoutput>"><cfoutput>#get_edu4_name.school_name#</cfoutput></option>
								</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-edu4_part_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56527.Üniversite Bölümleri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="text"><cf_get_lang dictionary_id='56197.Tüm Bölümler'></cfsavecontent>
								<cf_wrk_combo
									name="edu4_part_id"
									query_name="GET_SCHOOL_PART"
									multiple="1"
									option_name="part_name"
									option_value="part_id"
									width="175"
									option_text="#text#">
							</div>
						</div>
						<cfquery name="GET_EDU4" datasource="#DSN#">
							SELECT DISTINCT
								EDU_NAME
							FROM
								EMPLOYEES_APP_EDU_INFO
							WHERE
								EDU_NAME <> '' AND
								EDU_ID = -1 AND
								EDU_TYPE IN (4,5)
							ORDER BY EDU_NAME
						</cfquery>
						<cfquery name="GET_EDU4_PART" datasource="#DSN#">
							SELECT DISTINCT
								EDU_PART_NAME
							FROM
								EMPLOYEES_APP_EDU_INFO
							WHERE
								EDU_PART_NAME <> '' AND
								EDU_PART_ID = -1 AND
								EDU_TYPE IN (4,5)
							ORDER BY EDU_PART_NAME
						</cfquery>
						<div class="form-group" id="item-edu_university">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56157.Diğer Üniversiteler'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="edu4" id="edu4" multiple style="width:175px; height:62.5px;">
								<option value="" selected><cf_get_lang dictionary_id='56196.Tüm Üniversiteler'></option>
								<cfloop query="GET_EDU4">
									<option value="<cfoutput>#EDU_NAME#</cfoutput>"><cfoutput>#GET_EDU4.EDU_NAME#</cfoutput></option>
								</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-edu_other_parts">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56184.Diğer Bölümler'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="edu4_part" id="edu4_part" multiple style="width:175px; height:62.5px;">
								<option value="" selected><cf_get_lang dictionary_id='56197.Tüm Bölümler'></option>
								<cfloop query="GET_EDU4_PART">
									<option value="<cfoutput>#EDU_PART_NAME#</cfoutput>"><cfoutput>#GET_EDU4_PART.EDU_PART_NAME#</cfoutput></option>
								</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-branches_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58565.Branş'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="branches_id" id="branches_id" style="width:175px;" onchange="goster_opy();">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_branches">
										<option value="#branches_id#">#branches_name#</option>
									</cfoutput>                       
								</select>
							</div>
						</div>
						<div class="form-group" id="branches_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="37007.Alt Branş"></label>
							<cfoutput query="get_branches">
								<cfquery name="get_branches_rows" datasource="#dsn#">
									SELECT 
										BRANCHES_ROW_ID, 
										BRANCHES_ID, 
										BRANCHES_NAME_ROW, 
										BRANCHES_DETAIL_ROW, 
										BRANCHES_STATUS_ROW, 
										RECORD_DATE, 
										RECORD_EMP, 
										RECORD_IP, 
										UPDATE_DATE, 
										UPDATE_EMP, 
										UPDATE_IP 
									FROM 
										SETUP_APP_BRANCHES_ROWS 
									WHERE 
										BRANCHES_ID = #branches_id# AND BRANCHES_STATUS_ROW = 1
								</cfquery>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="diger_#get_branches.branches_id#" style="display:none">
									<select name="emp_app_info" id="emp_app_info" style="width:175px; height:58px;" multiple>
										<cfloop query="get_branches_rows">
											<option value="#branches_row_id#">#get_branches_rows.branches_name_row#</option>
										</cfloop>
									</select>
								</div>
							</cfoutput>
						</div>
					</div>
				</cf_box_elements>	
			</div>
			<cf_seperator id="birimler" title="#getLang('','Çalışılmak İstenen Birimler',56172)#">
			<div id="birimler">
				<cf_box_elements>
					<div class="col col-6 col-xs-12" type="column" index="5" sort="true">
						<cfquery name="get_cv_unit" datasource="#DSN#">
							SELECT 
								UNIT_ID, 
								IS_VIEW, 
								UNIT_NAME, 
								UNIT_DETAIL, 
								RECORD_DATE, 
								RECORD_EMP, 
								RECORD_IP, 
								UPDATE_DATE, 
								UPDATE_EMP, 
								UPDATE_IP, 
								HIERARCHY, 
								IS_ACTIVE 
							FROM 
								SETUP_CV_UNIT
							WHERE
								IS_VIEW=1
						</cfquery>
						<cfif get_cv_unit.recordcount>
							<cfoutput query="get_cv_unit">
								<div class="form-group" id="item-units_#currentrow#">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12">#get_cv_unit.unit_name#</label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<input type="checkbox" name="unit_id" id="unit_id" value="#get_cv_unit.unit_id#">
									</div>
									<!--- <label class="col col-4 col-md-4 col-sm-4 col-xs-12 hide"></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfinput type="text" name="unit_row" value="" validate="integer" maxlength="1" style="width:30px;">
									</div> !--->
								</div>
							</cfoutput>
						<cfelse>
							<div class="form-group" id="item-warnings">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56174.Sisteme kayıtlı birim yok'></label>
							</div>
						</cfif>
					</div>
				</cf_box_elements>	
			</div>
			
			<cf_seperator id="subeler" title="#getLang('','Çalışmak İstediği Şube',56519)#">
			<div id="subeler">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="6" sort="true">
						<div class="form-group" id="item-preference_branch">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12 hide"><cf_get_lang dictionary_id="56519.Çalışmak İstediği Şube"></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfquery name="get_branch" datasource="#dsn#">
									SELECT 
										BRANCH_ID,
										BRANCH_NAME,
										BRANCH_CITY
									FROM 
										BRANCH
									WHERE
										IS_INTERNET = 1
								</cfquery>
								<select name="preference_branch" id="preference_branch" style="width:220px; height:100px;" multiple>
									<cfoutput query="get_branch">
									<option value="#branch_id#">#branch_name# - #branch_city#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
			</cf_box_elements>	
			</div>
			
			<cf_seperator id="calisma_durumu" title="#getLang('','Çalışma Durumu',55539)#">
			<div id="calisma_durumu">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="7" sort="true">
						<div class="form-group" id="item-work_started">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55548.Çalışmaya başladı mı">?</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="work_started" id="work_started">
									<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
									<option value="1"><cf_get_lang dictionary_id="57495.Evet"></option>
									<option value="0"><cf_get_lang dictionary_id="57496.Hayır"></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-work_finished">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="55551.Çalışmayı bıraktı mı">?</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="work_finished" id="work_finished">
									<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
									<option value="1"><cf_get_lang dictionary_id="57495.Evet"></option>
									<option value="0"><cf_get_lang dictionary_id="57496.Hayır"></option>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
			</div>
				
			<cf_seperator id="referans" title="#getLang('','Referans Bilgileri',44321)#"><!---Referans Bilgileri--->
			<div id="referans">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="12" sort="true">
						<div class="form-group" id="item-referance">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="referance" id="referance" value="" style="width:195px;">
							</div>
						</div>
					</div>
				</cf_box_elements>	
			</div>
				
			<cf_seperator id="araclar" title="#getLang('','Kullanılabilen Araçlar ve Sertifikalar',35256)#"><!---Kullanılabilen Araçlar ve Sertifikalar--->
			<div id="araclar">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="13" sort="true">
						<div class="form-group" id="item-program-labek">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12"></div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><label>(<cf_get_lang dictionary_id='56198.Program isimlerini virgülle ayırarak giriniz'>.)</label></div>
						</div>
						<div class="form-group" id="item-tool">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55957.Bilgisayar Bilgisi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<textarea name="tool" id="tool" style="width:200px;height:62.5px;"></textarea>
									<span class="input-group-addon no-bg"></span>
									<select name="computer_education" id="computer_education" style="width:175px; height:63px;" multiple>
										<option value=""><cf_get_lang dictionary_id ='55957.Bilgisayar Bilgisi'></option>
										<cfoutput query="get_computer_info">
											<option value="#computer_info_id#">#computer_info_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-kurs">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35215.Sertifika'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="kurs" id="kurs" style="height:80px;"></textarea>
							</div>
						</div>
						<div class="form-group" id="item-other">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56199.Aranacak Kelimeler'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="other" id="other" style="width:380px;height:40px;"></textarea>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="radio" name="other_if" id="other_if" value="0" checked><cf_get_lang dictionary_id='56202.Geçen'></label>
								</div>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<label><input type="radio" name="other_if" id="other_if" value="1"><cf_get_lang dictionary_id='56200.Geçmeyen'></label>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-report_dsp_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='56520.Listelenecek Alanlar'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="report_dsp_type" id="report_dsp_type" style="width:195px;height:65px;" multiple="multiple">
									<option value="1"><cf_get_lang dictionary_id='58565.Branş'></option>
									<option value="2"><cf_get_lang dictionary_id ='56521.Staj Bilgileri'></option>
									<option value="3"><cf_get_lang dictionary_id ='58563.Formasyon'></option>
									<option value="4"><cf_get_lang dictionary_id ='55337.Eğitim Seviyesi'></option>
									<option value="5"><cf_get_lang dictionary_id ='56522.Yaşadığı İlçe'></option>
									<option value="6"><cf_get_lang dictionary_id='58814.Ev Telefonu'></option>
									<option value="7"><cf_get_lang dictionary_id='58813.Cep Telefonu'></option>
									<option value="8"><cf_get_lang dictionary_id='57764.Cinsiyet'></option>
									<option value="9"><cf_get_lang dictionary_id ='56525.Medeni Hali'></option>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>	
			</div>
			
			<cf_seperator id="ekbilgi" title="#getLang('','Ek Bilgiler',30219)#">
			<div id="ekbilgi">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="14" sort="true">
						<cfquery name="get_infoplus" datasource="#dsn#">
							SELECT 
								<cfloop from="1" to="20" index="m">
								PROPERTY#m#_NAME,
								PROPERTY#m#_TYPE,
								</cfloop>
								INFO_ID
							FROM 
								SETUP_INFOPLUS_NAMES 
							WHERE 
								OWNER_TYPE_ID = -23
						</cfquery>
						<cfif get_infoplus.recordcount>
							<cfquery name="get_values" datasource="#dsn#">
								SELECT SELECT_VALUE,PROPERTY_NO FROM SETUP_INFOPLUS_VALUES WHERE INFO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_infoplus.info_id#">
							</cfquery>
							<cfoutput>
								<cfset display_mode=false>
								<cfloop from="1" to="20" index="n">
									<cfif len(evaluate('get_infoplus.PROPERTY#n#_NAME'))>
										<cfset display_mode=true>
										<div class="form-group" id="item-property_select_value_#n#">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12">#evaluate('get_infoplus.PROPERTY#n#_NAME')#</label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<cfif evaluate('get_infoplus.PROPERTY#n#_type') eq 'select'>
													<cfquery name="get_info_values" dbtype="query">
														SELECT * FROM get_values WHERE PROPERTY_NO = #n#
													</cfquery>
													<cfif get_info_values.recordcount>
														<select name="property_select_value_#n#">
															<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
															<cfloop query="get_info_values">
																<option value="#select_value#">#select_value#</option>
															</cfloop>
														</select>
													</cfif>
												<cfelse>
													<input type="text" style="width:200px;" name="property_select_value_#n#" value="">
												</cfif>
											</div>
										</div>
									</cfif>
								</cfloop>
								<cfif not display_mode>
									<div class="form-group" id="item-document">
										<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57484.Kayıt Yok'></label>
									</div>
								</cfif>
							</cfoutput>
						<cfelse>
							<div class="form-group" id="item-warning2">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57484.Kayıt Yok'></label>
							</div>
						</cfif>
					</div>
				</cf_box_elements>
			</div>
			<cf_box_footer>
				<div class="col col-12 text-right">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57565.Ara'></cfsavecontent>
					<cf_wrk_search_button button_type="2" button_name="#message#" search_function='kontrol()'>
				</div>
			</cf_box_footer>
					
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if ( (employe_detail.search_app.checked != 1) && (employe_detail.search_app_pos.checked != 1) )
	{
		alert("<cf_get_lang dictionary_id ='56526.Arama Yapılması İçin Özgeçmiş veya Başvuruları Seçmelisiniz'>!");
		return false;
	}
	employe_detail.salary_wanted1.value = filterNum(employe_detail.salary_wanted1.value);
	employe_detail.salary_wanted2.value = filterNum(employe_detail.salary_wanted2.value);
	return true;
}
function get_county(city_id)
{
	document.employe_detail.home_county.options.length = 0;
	var home_county_id = document.employe_detail.homecity.options.length;	
	var home_county = '';
	for(i=0;i<home_county_id;i++)
	{
		if(document.employe_detail.homecity.options[i].selected && home_county.length==0)
			home_county = home_county + document.employe_detail.homecity.options[i].value;
		else if(document.employe_detail.homecity.options[i].selected)
			home_county = home_county + ',' + document.employe_detail.homecity.options[i].value;
	}
	var get_ilce = wrk_safe_query('hr_get_ilce','dsn',0,home_county);
	document.employe_detail.home_county.options[0]=new Option('İlçe','0')
	for(var xx=0;xx<get_ilce.recordcount;xx++)
	{
		document.employe_detail.home_county.options[xx+1]=new Option(get_ilce.COUNTY_NAME[xx]);
		document.employe_detail.home_county.options[xx+1].value=get_ilce.COUNTY_ID[xx];
	}
}
function goster_opy()
{
	var get_branches = wrk_safe_query('hr_get_branches','dsn');
	if(document.employe_detail.branches_id.value=="")
	{
		branches_name.style.display='none';
		for(var xx=0;xx<get_branches.recordcount;xx++)
			eval('diger_'+get_branches.BRANCHES_ID[xx]).style.display='none';
	}
	else
	{
		eval('diger_'+document.employe_detail.branches_id.value).style.display='';
		branches_name.style.display='';
		for(var xx=0;xx<get_branches.recordcount;xx++)
			if(get_branches.BRANCHES_ID[xx] != document.employe_detail.branches_id.value)
			 eval('diger_'+get_branches.BRANCHES_ID[xx]).style.display='none';
	}
}
function goster_()
{
	if(document.employe_detail.is_formation.options[1].selected == true)
	{
		formation_type.style.display = '';
		formation_type2.style.display = 'none';
	}
	if(document.employe_detail.is_formation.options[2].selected == true)
	{
		formation_type.style.display = 'none';
		formation_type2.style.display = '';
		document.employe_detail.formation_typee.value = '';
	}
}
</script>