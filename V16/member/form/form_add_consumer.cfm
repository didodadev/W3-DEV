<cf_xml_page_edit fuseact="member.form_add_consumer" is_multi_page="1">
<cf_get_lang_set module_name="member">
<cfinclude template="../query/get_im.cfm">
<cfinclude template="../query/get_company_size_cats.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_consumer_value.cfm">
<cfinclude template="../query/get_societies.cfm">
<cfinclude template="../query/get_edu_level.cfm">
<cfinclude template="../query/get_identycard_cat.cfm">
<cfinclude template="../query/get_mobilcat.cfm">
<!--- Sadece aktif kategorilerin gelmesi için --->
<cfset attributes.is_active_consumer_cat = 1>
<cfquery name="SZ" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1>
	<cfquery name="GET_ZONE_KONTROL" datasource="#DSN#">
		SELECT
			SZ.CITY_ID
		FROM
			SALES_ZONES S,
			SALES_ZONE_GROUP SG,
			SALES_ZONES_TEAM SZ,
			SALES_ZONES_TEAM_ROLES SZR
		WHERE
			S.SZ_ID = SG.SZ_ID AND
			S.SZ_ID = SZ.SALES_ZONES AND
			SZ.TEAM_ID = SZR.TEAM_ID AND
			(SZ.LEADER_POSITION_CODE = #session.ep.position_code# OR SZR.POSITION_CODE = #session.ep.position_code# OR SG.POSITION_CODE = #session.ep.position_code#) AND
			SZ.CITY_ID IS NOT NULL
	</cfquery>
	<cfif get_zone_kontrol.recordcount>
		<cfset kontrol_zone = ''>
		<cfoutput query="get_zone_kontrol">
			<cfquery name="GET_CITY_CODE" datasource="#DSN#">
				SELECT PLATE_CODE FROM SETUP_CITY WHERE CITY_ID = #get_zone_kontrol.city_id#
			</cfquery>
			<cfif get_city_code.plate_code eq 34>
				<cfquery name="GET_CITYS" datasource="#DSN#">
					SELECT CITY_ID FROM SETUP_CITY WHERE PLATE_CODE = '#get_city_code.plate_code#'
				</cfquery>
				<cfloop query="get_citys">
					<cfset kontrol_zone = listappend(kontrol_zone,get_citys.city_id,',')>
				</cfloop>
			<cfelse>
				<cfset kontrol_zone = listappend(kontrol_zone,get_zone_kontrol.city_id,',')>
			</cfif>
		</cfoutput>
	<cfelse>
		<cfset kontrol_zone = -1>
	</cfif>
</cfif>
<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="47163.Bireysel Hesaplar"> <cf_get_lang dictionary_id="44630.Ekle"></cfsavecontent>
		<cf_box title="#message#">
			<cfform name="add_consumer" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_consumer">
				<cfif (isdefined("is_fast_add_display") and is_fast_add_display eq 0) or not isdefined("is_fast_add_display")>
				<input type="hidden" name="x_name_surname_write_standart" id="x_name_surname_write_standart" value="<cfoutput>#x_name_surname_write_standart#</cfoutput>" />
				<cfif isdefined('xml_consumer_contract_id') and len(xml_consumer_contract_id)>
					<input type="hidden" name="xml_consumer_contract_id" id="xml_consumer_contract_id" value="<cfoutput>#xml_consumer_contract_id#</cfoutput>">
				</cfif>
				<cf_box_elements>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="form_ul_ispotential" extra_checkbox="is_related_consumer"  height="20">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<cfif is_dsp_potantial_check eq 1>
									<input type="checkbox" id="ispotential" name="ispotential" value="1" style="margin-left:-3px;"><cf_get_lang dictionary_id='57577.Potansiyel'>
								</cfif>
							</label>
						</div>
						<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="form_ul_ispotential" extra_checkbox="is_related_consumer"  height="20">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<cfif is_dsp_related_consumer_check eq 1>
									<input type="checkbox" id="is_related_consumer" name="is_related_consumer"><cf_get_lang dictionary_id='30559.Bağlı Üye'>
								</cfif>
							</label>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="form_ul_consumer_code">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57558.Üye No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" id="consumer_code" name="consumer_code" value="<cfif isdefined("attributes.consumer_code")><cfoutput>#attributes.consumer_code#</cfoutput></cfif>" maxlength="50" tabindex="1">
							</div>									
						</div>
						<div class="form-group" id="form_ul_consumer_name" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.consumer_name")>
									<cfinput type="text" name="consumer_name" id="consumer_name" tabindex="1" required="yes"  maxlength="50" value="#Left(attributes.consumer_name,50)#">
								<cfelse>
									<cfinput type="text" name="consumer_name" id="consumer_name" tabindex="1" required="yes" maxlength="50" value="">		  
								</cfif>
							</div>
						</div>
						<div class="form-group" id="form_ul_consumer_surname" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.consumer_surname")>
									<cfinput type="text" name="consumer_surname" id="consumer_surname" tabindex="1" required="yes" maxlength="50" value="#Left(attributes.consumer_surname,50)#">
								<cfelse>
									<cfinput type="text" name="consumer_surname" id="consumer_surname" tabindex="1" required="yes"  maxlength="50" value="">				  
								</cfif>
							</div>
						</div>
						<div class="form-group" id="form_ul_consumer_username" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
							<div class="col col-8 col-xs-12"><cfinput type="text" name="consumer_username" id="consumer_username" maxlength="50" tabindex="1"></div>
						</div>
						<div class="form-group" id="form_ul_consumer_password" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
							<div class="col col-8 col-xs-12"><cfinput type="Password" id="consumer_password" name="consumer_password" maxlength="10" tabindex="1"></div>
						</div>
						<div class="form-group" id="form_ul_startdate" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30448.Uyelik Baslama Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30448.Üyelik Başlama Tarihi'></cfsavecontent>
								<cfinput type="text" name="startdate" id="startdate" validate="#validate_style#" maxlength="10" message="#message#" tabindex="1">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="form_ul_ref_pos_code_name" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58636.Referans Üye'><cfif is_req_reference_member eq 1>*</cfif></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="ref_pos_code" id="ref_pos_code" value="">
									<input name="ref_pos_code_name" type="text" id="ref_pos_code_name" onfocus="AutoComplete_Create('ref_pos_code_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','2,0,0,0','CONSUMER_ID,CONSUMER_ID,CONSUMER_REFERENCE_CODE','ref_pos_code,dsp_reference_code,reference_code','add_consumer','3','250');" value="" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=add_consumer.ref_pos_code&field_consumer=add_consumer.dsp_reference_code&field_name=add_consumer.ref_pos_code_name&field_cons_ref_code=add_consumer.reference_code<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>)" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="form_ul_dsp_reference_code" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30593.Referans Kod'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="reference_code" id="reference_code" value="">
								<input type="text" name="dsp_reference_code" id="dsp_reference_code" value="" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="form_ul_proposer_cons_name" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30720.Öneren Üye'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="proposer_cons_id" id="proposer_cons_id" value="">
									<input name="proposer_cons_name" type="text" id="proposer_cons_name" onfocus="AutoComplete_Create('proposer_cons_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','2,0,0,0','CONSUMER_ID','proposer_cons_id','add_consumer','3','250');" value="" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=add_consumer.proposer_cons_id&field_name=add_consumer.proposer_cons_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>)" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="form_ul_ozel_kod" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Ozel Kod'></label>
							<div class="col col-8 col-xs-12"><input type="text" name="ozel_kod" id="ozel_kod" value="<cfif isdefined("attributes.ozel_kod")><cfoutput>#attributes.ozel_kod#</cfoutput></cfif>" maxlength="50" tabindex="2"></div>
						</div>
						<div class="form-group" id="item-cf_wrk_add_info">
							<label class="col col-4"><cf_get_lang dictionary_id="57810.Ek Bilgi"></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_add_info info_type_id="-2" upd_page = "0" colspan="9">
							</div>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="form_ul_efatura_date" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29872.E-Fatura'>*</label>
							<div class="col col-8 col-xs-12">										
								<div class="input-group">
								<span class="input-group-addon"><input type="checkbox" name="use_efatura" id="use_efatura" <cfif xml_use_efatura>disabled="disabled"</cfif>/></span>
								<cfif xml_use_efatura>
									<cfinput type="text" name="efatura_date" value="" readonly="readonly" validate="#validate_style#" maxlength="10" style="width:114px;">
								<cfelse>
									<cfinput type="text" name="efatura_date" value="" validate="#validate_style#" maxlength="10" style="width:114px;">                    
									<span class="input-group-addon"><cf_wrk_date_image date_field="efatura_date"></span>
								</cfif>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-process_stage" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
							<div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
						</div>
						<div class="form-group" id="form_ul_consumer_cat_id" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'>*</label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_MemberCat
									name="consumer_cat_id"
									is_active="1"
									comp_cons="0">
							</div>
						</div>
						<div class="form-group" id="form_ul_resource" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58830.İlişki Şekli'> <cfif isdefined("is_resource_info") and is_resource_info eq 1>*</cfif></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_combo 
									name="resource"
									query_name="GET_PARTNER_RESOURCE"
									option_name="resource"
									option_value="resource_id"
									width="150">
							</div>
						</div>
						<div class="form-group" id="form_ul_customer_value" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
							<div class="col col-8 col-xs-12">
								<select name="customer_value" id="customer_value" tabindex="1">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_customer_value">
										<option value="#customer_value_id#">#customer_value#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="form_ul_member_add_option_id" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30200.Üye Özel Tanımı'></label>
							<div class="col col-8 col-xs-12">
								<cf_wrk_combo 
									name="member_add_option_id"
									query_name="GET_MEMBER_ADD_OPTIONS"
									option_name="member_add_option_name"
									option_value="member_add_option_id"
									width="150">
							</div>
						</div>
						<div class="form-group" id="form_ul_consumer_email" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57428.E-mail'> ! </cfsavecontent>
								<cfif isdefined("attributes.consumer_email")>
									<cfinput type="text" id="consumer_email" name="consumer_email" maxlength="100" validate="email" tabindex="2" message="#message#" value="#attributes.consumer_email#">
								<cfelse>
									<cfinput type="text" id="consumer_email" name="consumer_email" maxlength="100" validate="email" tabindex="2" message="#message#" value="">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="form_ul_consumer_email" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59876.Kep Adresi'></label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.consumer_kep_address")>
									<cfinput type="text" id="consumer_kep_address" name="consumer_kep_address" maxlength="100" validate="email" tabindex="2" value="#attributes.consumer_kep_address#">
								<cfelse>
									<cfinput type="text" id="consumer_kep_address" name="consumer_kep_address" maxlength="100" validate="email" tabindex="2" value="">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="form_ul_mobilcat_id" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'> <cfif xml_mobile_tel_required eq 1> * </cfif></label>
							<cfif xml_mobile_tel_required eq 1>
								<cfif isdefined("attributes.mobiltel")>
									<div class="col col-2 col-xs-2">
										<cfinput type="text" name="mobilcat_id" id="mobilcat_id" maxlength="7"  tabindex="2" onKeyUp="isNumber(this);" style="width:47px;" required="yes" value="">
									</div>
									<div class="col col-6 col-xs-10">
										<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20"  tabindex="2" onKeyUp="isNumber(this);" style="width:87px;" required="yes" value="#attributes.mobiltel#">
									</div>
								<cfelse>
									<div class="col col-2 col-xs-2">
										<cfinput type="text" name="mobilcat_id" id="mobilcat_id" maxlength="7"  tabindex="2" onKeyUp="isNumber(this);" style="width:47px;" required="yes" value="">
									</div>
									<div class="col col-6 col-xs-10">	
										<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20" tabindex="2" style="width:87px;" required="yes" onKeyUp="isNumber(this);" value="">
									</div>
								</cfif>	
							<cfelse>
								<cfif isdefined("attributes.mobiltel")>
									<div class="col col-2 col-xs-2">
										<cfinput type="text" name="mobilcat_id" id="mobilcat_id" maxlength="7"  tabindex="2" onKeyUp="isNumber(this);" style="width:47px;" value="">
									</div>
									<div class="col col-6 col-xs-10">	
										<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20" tabindex="2" onKeyUp="isNumber(this);" style="width:87px;" value="#attributes.mobiltel#">
									</div>
								<cfelse>
									<div class="col col-2 col-xs-2">	
										<cfinput type="text" name="mobilcat_id" id="mobilcat_id" maxlength="7"  tabindex="2" onKeyUp="isNumber(this);" style="width:47px;" value="">
									</div>
									<div class="col col-6 col-xs-10">	
										<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20" tabindex="2" style="width:87px;" onKeyUp="isNumber(this);" value="">
									</div>
								</cfif>	
							</cfif>
						</div>
						<div class="form-group" id="form_ul_mobilcat_id_2" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'> 2</label>	
							<div class="col col-2 col-xs-2">								
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='30223.Kod/ Mobil Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="mobilcat_id_2" id="mobilcat_id_2" maxlength="7"  tabindex="2" onKeyUp="isNumber(this);" style="width:47px;"  value="">
							</div>
							<div class="col col-6 col-xs-10">
								<cfinput type="text" name="mobiltel_2" id="mobiltel_2" maxlength="10" validate="integer" message="#message#" tabindex="10" style="width:87px;" onKeyUp="isNumber(this);" value="">
							</div>
						</div>
						<div class="form-group" id="form_ul_homepage" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30179.İnternet'></label>
							<div class="col col-8 col-xs-12"><input type="text" id="homepage" name="homepage" maxlength="50" tabindex="2"></div>
						</div>
						<div class="form-group" id="form_ul_imcat_id" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30380.im cat / im'></label>
							<div class="col col-4 col-xs-12">
								<select name="imcat_id" id="imcat_id" tabindex="2">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_im">
									<option value="#imcat_id#">#imcat#</option>
								</cfoutput>
								</select>
							</div>
							<div class="col col-4 col-xs-12">
								<input type="text" maxlength="50" name="im" id="im" tabindex="2">
							</div>
						</div>
					</div>
				</cf_box_elements>

				<cfsavecontent variable="message"><cf_get_lang dictionary_id="30236.Kişisel Bilgiler"></cfsavecontent>
				<cf_seperator name="#message#" id="kisisel_bilgiler" title="#message#">
					<cf_box_elements id="kisisel_bilgiler">
						<div class="col col-6 col-md-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="form_ul_education_level" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30237.Eğitim Durumu'></label>
								<div class="col col-8 col-xs-12">
									<select name="education_level" id="education_level" tabindex="5">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_edu_level">
											<option value="#edu_level_id#">#education_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_identycard_no" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30239.Kimlik Kart / No'></label>
								<div class="col col-4 col-xs-12">
									<cf_wrk_combo 
										query_name="GET_IDENTYCARD" 
										name="identycard_cat" 
										option_value="identycat_id" 
										option_name="identycat"
										width=90>
								</div>
								<div class="col col-4 col-xs-12">
									<input type="text" name="identycard_no" id="identycard_no" maxlength="40" tabindex="5">
								</div>
							</div>
							<div class="form-group" id="form_ul_sex" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
								<div class="col col-8 col-xs-12">
									<select name="sex" id="sex" tabindex="5">
										<option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
										<option value="0"><cf_get_lang dictionary_id='58958.Kadın'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_birthplace" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="birthplace" id="birthplace" maxlength="30" tabindex="5"></div>
							</div>
							<div class="form-group" id="form_ul_birthdate">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'><cfif is_birthday eq 1 or is_tc_number eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi!'></cfsavecontent>
										<cfinput type="text" name="birthdate" id="birthdate" maxlength="10" validate="#validate_style#" message="#message#" tabindex="5">
										<span class="input-group-addon"><cf_wrk_date_image date_field="birthdate"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_married" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30513.Medeni Durumu'></label>
								<div class="col col-4 col-xs-12">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<input type="radio" id="married" name="married" value="1" tabindex="5" onclick="goruntule(this);"><cf_get_lang dictionary_id='30501.Evli'>
									</label>
								</div>
								<div class="col col-4 col-xs-12">
									<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<input type="radio" id="single" name="single" value="0" tabindex="5" onclick="goruntule(this);"><cf_get_lang dictionary_id='30694.Bekar'>
									</label>
								</div>
							</div>
							<div class="form-group" id="form_ul_married_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29911.Evlilik Tarihi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='29911.Evlilik Tarihi'>!</cfsavecontent>
										<cfinput type="text" name="married_date" maxlength="10" validate="#validate_style#" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="married_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_nationality" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30502.Uyruğu'></label>
								<div class="col col-8 col-xs-12">
									<select name="nationality" id="nationality" tabindex="7">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_country">
											<option value="#country_id#" <cfif is_default eq 1>selected</cfif>>#country_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_child" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30391.Çocuk Sayısı'></label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"> <cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30391.Çocuk Sayısı !'></cfsavecontent>
									<cfinput type="text" name="child" id="child" validate="integer" message="#message#" maxlength="2" tabindex="8" onKeyUp="isNumber(this);">
								</div>
							</div>
							<div class="form-group" id="form_ul_picture" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30243.Fotoğraf'></label>
								<div class="col col-8 col-xs-12"><input type="file" id="picture" name="picture" tabindex="5"></div>
							</div>
							<div class="form-group" id="form_ul_tc_identity_no" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'><cfif is_tc_number eq 1> *</cfif></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined('attributes.tc_identy_no') and len(attributes.tc_identy_no)>
										<cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_required="#is_tc_number#" tc_identity_number='#attributes.tc_identy_no#' width_info='150' is_verify='1' consumer_name='consumer_name' consumer_surname='consumer_surname' birth_date='birthdate' use_gib="1">
									<cfelse>    
										<cf_wrkTcNumber fieldId="tc_identity_no" tc_identity_required="#is_tc_number#" width_info='150' is_verify='1' consumer_name='consumer_name' consumer_surname='consumer_surname' birth_date='birthdate' use_gib="1">
									</cfif>
									<cfinclude template="/WEX/gib/internalapi.cfm" runOnce="true">
								
								</div>
							</div>
							<div class="form-group" id="form_ul_father">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58033.Baba Adı'></label>
								<div class="col col-8 col-xs-12"><input type="text" id="father" maxlength="50" name="father"></div>
							</div>
							<div class="form-group" id="form_ul_mother">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58440.Ana Adı'></label>
								<div class="col col-8 col-xs-12"><input type="text" maxlength="50" id="mother" name="mother"></div>
							</div>
							<div class="form-group" id="form_ul_BLOOD_TYPE" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58441.Kan Grubu'></label>
								<div class="col col-8 col-xs-12">
									<select name="BLOOD_TYPE" id="BLOOD_TYPE" tabindex="5">
										<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
										<option value="0">0 Rh+</option>
										<option value="1">0 Rh-</option>
										<option value="2">A Rh+</option>
										<option value="3">A Rh-</option>
										<option value="4">B Rh+</option>
										<option value="5">B Rh-</option>
										<option value="6">AB Rh+</option>
										<option value="7">AB Rh-</option>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-xs-12" type="column" index="5" sort="true">
							<div class="form-group" id="form_ul_home_telcode" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30384.Kod/Ev Telefonu'><cfif is_home_telephone eq 1>*</cfif></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='51606.Geçerli Bir Telefon Kodu Giriniz'> !</cfsavecontent>
								<cfif isdefined("attributes.home_telcode")>
									<div class="col col-2 col-xs-4">
										<cfinput text="text" name="home_telcode" id="home_telcode" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this);" style="width:60px;" value="#attributes.home_telcode#" tabindex="6">
									</div>
								<cfelse>
									<div class="col col-2 col-xs-4">
										<cfinput text="text" name="home_telcode" id="home_telcode" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this);" style="width:60px;" value="" tabindex="6">
									</div>
								</cfif>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57499.telefon'>!</cfsavecontent>	
								<cfif isdefined("attributes.home_tel")>			  
									<div class="col col-6 col-xs-8">
										<cfinput type="text" name="home_tel" id="home_tel" validate="integer" message="#message#" maxlength="7" onKeyUp="isNumber(this);" style="width:87px;" value="#attributes.home_tel#" tabindex="6">
									</div>
								<cfelse>
									<div class="col col-6 col-xs-8">
										<cfinput type="text" name="home_tel" id="home_tel" validate="integer" message="#message#" maxlength="7" onKeyUp="isNumber(this);" style="width:87px;" value="" tabindex="6">
									</div>
								</cfif>
							</div>
							<div class="form-group" id="form_ul_home_address">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("attributes.home_address")><cfset home_address_ = attributes.home_address><cfelse><cfset home_address_ = ""></cfif>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısıss'></cfsavecontent>
									<textarea name="home_address" id="home_address" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:150px;height:65px;"  maxlength="750" tabindex="6"><cfoutput>#home_address_#</cfoutput></textarea>
								</div>
							</div>
							<div class="form-group" id="form_ul_home_postcode">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="home_postcode" id="home_postcode" maxlength="15" tabindex="6" onkeyup="isNumber(this);"></div>
							</div>
							<div class="form-group" id="form_ul_home_country">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
								<div class="col col-8 col-xs-12">
									<select name="home_country" id="home_country" onblur="LoadCity(this.value,'home_city_id','home_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'home_district_id'</cfif>)" tabindex="6">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_country">
											<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_home_city_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
										<cfquery name="GET_CITY" datasource="#DSN#">
											SELECT 	
												CITY_ID,
												CASE
													WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
													ELSE CITY_NAME
												END AS CITY_NAME
											FROM 
												SETUP_CITY
												LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_CITY.CITY_ID
												AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="CITY_NAME">
												AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_CITY">
												AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
										</cfquery>
										<select name="home_city_id" id="home_city_id" onchange="LoadCounty(this.value,'home_county_id','home_telcode'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'home_district_id'</cfif>)">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="GET_CITY">
												<option value="#city_id#" <cfif city_id eq attributes.city_id>selected</cfif>>#city_name#</option>
											</cfoutput>
										</select>
									<cfelse>
										<select name="home_city_id" id="home_city_id" onchange="LoadCounty(this.value,'home_county_id','home_telcode'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'home_district_id'</cfif>)">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										</select>
									</cfif>
								</div>
							</div>     
							<div class="form-group" id="form_ul_home_county_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
								<div class="col col-8 col-xs-12">
									<cfif is_adres_detail eq 1 and is_residence_select eq 1>
									<select name="home_county_id" id="home_county_id" onChange="LoadDistrict(this.value,'home_district_id');">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfif isdefined('attributes.county_id') and len(attributes.county_id)>
											<cfquery name="GET_COUNTY" datasource="#DSN#">
												SELECT 
													COUNTY_ID,
													CITY,
													CASE
														WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
														ELSE COUNTY_NAME
													END AS COUNTY_NAME
												FROM 
													SETUP_COUNTY
													LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COUNTY.COUNTY_ID
													AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COUNTY_NAME">
													AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COUNTY">
													AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
													WHERE 1 = 1 <cfif isDefined("attributes.city_id") and len(attributes.city_id)>AND CITY = #attributes.city_id# ORDER BY COUNTY_NAME</cfif>
											</cfquery>
										
											<cfoutput query="get_county">
												<option value="#county_id#" <cfif attributes.county_id eq get_county.county_id>selected</cfif>>#county_name#</option>
											</cfoutput>
											
										</cfif>
									</select>
								<cfelse>
									
									<select name="home_county_id" id="home_county_id" >
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									</select>
								</cfif>
								</div>
								
								</div>
							
							<div class="form-group" id="form_ul_home_semt" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="home_semt" id="home_semt" value="<cfif isdefined("attributes.home_semt")><cfoutput>#attributes.home_semt#</cfoutput></cfif>" maxlength="30" tabindex="6"></div>
							</div>
							<!--- Burası incelenecek --->
							<div class="form-group" id="form_ul_home_district" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
								<div class="col col-8 col-xs-12">
									<cfif is_residence_select eq 0>
										<input type="text" name="home_district" id="home_district" value="">
									<cfelse>
										<select name="home_district_id" id="home_district_id" onchange="get_ims_code(1);">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										</select>
									</cfif>
								</div>
							</div>
							<!--- Burası incelenecek --->
							<div class="form-group" id="form_ul_home_main_street" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30629.Cadde'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="home_main_street" id="home_main_street" maxlength="50"></div>
							</div>
							<div class="form-group" id="form_ul_home_street" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30630.Sokak'></label>
								<div class="col col-8 col-xs-12"><input type="text" id="home_street" name="home_street" maxlength="50"></div>
							</div>
							<div class="form-group" id="form_ul_home_door_no" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30215.Adres Detay'></label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
									<textarea name="home_door_no" id="home_door_no" style="width:150px;" message="<cfoutput>#message#</cfoutput>" maxlength="250" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"></textarea>
								</div>
							</div>
						</div>
					</cf_box_elements>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="30244.İş Bilgileri"></cfsavecontent>
				<cf_seperator name="#message#" title="#message#" id="is_bilgileri">
					<cf_box_elements id="is_bilgileri">
						<div class="col col-6 col-md-6 col-xs-12" type="column" index="6" sort="true">
							<div class="form-group" id="form_ul_company" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
								<div class="col col-8 col-xs-12"><input type="text" id="company" name="company" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" maxlength="100" tabindex="3"></div>
							</div>
							<div class="form-group" id="form_ul_title" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
								<div class="col col-8 col-xs-12"><input type="text" id="title" name="title" maxlength="50" tabindex="3"></div>
							</div>
							<div class="form-group" id="form_ul_mission" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57573.Görev'></label>
								<div class="col col-8 col-xs-12">
									<select name="mission" id="mission" tabindex="3">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_partner_positions">
											<option value="#partner_position_id#">#partner_position#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_department" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
								<div class="col col-8 col-xs-12">
									<select name="department" id="department" tabindex="3">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_partner_departments">
											<option value="#partner_department_id#">#partner_department#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<!--- <cfsavecontent variable="header_"><cf_get_lang_main no='1315.Doğum Tarihi'></cfsavecontent>
							<div class="form-group" id="form_ul_birthdate" >
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1315.Doğum Tarihi'><cfif is_birthday eq 1 or is_tc_number eq 1>*</cfif></div>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='1315.Doğum Tarihi!'></cfsavecontent>
									<cfinput type="text" name="birthdate" id="birthdate" maxlength="10" validate="#validate_style#" message="#message#" tabindex="5">
									<cf_wrk_date_image date_field="birthdate">
								</div>
							</div> --->
							<div class="form-group" id="form_ul_sector_cat_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_selectlang
										name="sector_cat_id"
										width="150"
										tabindex="3"
										option_name="sector_cat"
										option_value="sector_cat_id"
										table_name="SETUP_SECTOR_CATS"
										sort_type="sector_cat">
								</div>
							</div>
							<div class="form-group" id="form_ul_income_level" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30503.Gelir Düzeyi'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_combo 
										name="income_level"
										query_name="GET_INCOME_LEVEL"
										option_name="income_level"
										option_value="income_level_id"
										width="150">
								</div>
							</div>
							<div class="form-group" id="form_ul_company_size_cat_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30170.Şirket Büyüklüğü'></label>
								<div class="col col-8 col-xs-12">
									<select name="company_size_cat_id" id="company_size_cat_id" tabindex="3">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_company_size_cats">
											<option value="#company_size_cat_id#">#company_size_cat#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_social_society_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30489.Sosyal Güvenlik Kurumu'></label>
								<div class="col col-8 col-xs-12">
									<select name="social_society_id" id="social_society_id" tabindex="3">
										<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
										<cfoutput query="get_societies">
											<option value="#society_id#">#society#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_social_security_no" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30307.Sosyal Güvenlik No'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="social_security_no" id="social_security_no"  maxlength="50" tabindex="3" onkeyup="isNumber(this);"></div>
							</div>
							<div class="form-group" id="form_ul_vocation_type" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30500.meslek Tipi'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_combo 
										name="vocation_type"
										query_name="GET_VOCATION_TYPE"
										option_name="vocation_type"
										option_value="vocation_type_id"
										width="150">
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-xs-12" type="column" index="7" sort="true">
							<div class="form-group" id="form_ul_work_telcode" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30382.Kod/İş Telefonu'></label>
								<div class="col col-2 col-xs-4">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30382.Kod/İş Telefonu !'></cfsavecontent>
									<cfinput type="text" name="work_telcode" id="work_telcode" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this);" style="width:60px;" tabindex="4">
								</div>
								<div class="col col-6 col-xs-8">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='57499.telefon'></cfsavecontent>
									<cfinput type="text" name="work_tel" id="work_tel" validate="integer" message="#message#" maxlength="7" onKeyUp="isNumber(this);" style="width:87px;" tabindex="4">
								</div>
							</div>
							<div class="form-group" id="form_ul_work_tel_ext" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30259.Dahili'></label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30259.dahili !'></cfsavecontent>
									<cfinput type="text" name="work_tel_ext" id="work_tel_ext" validate="integer" message="#message#" maxlength="5" onKeyUp="isNumber(this);" tabindex="4">
								</div>
							</div>
							<div class="form-group" id="form_ul_work_faxcode" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30245.Fax Kod / Fax'></label>									
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='30245.Fax/Fax kodu!'></cfsavecontent>
								<cfif isdefined("attributes.work_faxcode")>
									<div class="col col-2 col-xs-4">
										<cfinput type="text" name="work_faxcode" id="work_faxcode" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this);" style="width:60px;" value="#attributes.work_faxcode#" tabindex="4">
									</div>
								<cfelse>
									<div class="col col-2 col-xs-4">
										<cfinput type="text" name="work_faxcode" id="work_faxcode" validate="integer" message="#message#" maxlength="3" onKeyUp="isNumber(this);" style="width:60px;" value="" tabindex="4">
									</div>
								</cfif>
								<cfif isdefined("attributes.work_fax")>			  
									<div class="col col-6 col-xs-8">
										<cfinput type="text" name="work_fax" id="work_fax" validate="integer" message="#message#" maxlength="7" onKeyUp="isNumber(this);" style="width:87px;" value="#attributes.work_fax#" tabindex="4">
									</div>
								<cfelse>
									<div class="col col-6 col-xs-8">
										<cfinput type="text" name="work_fax" id="work_fax" validate="integer" message="#message#" maxlength="7" onKeyUp="isNumber(this);" style="width:87px;" value="" tabindex="4">
									</div>
								</cfif>
							</div>
							<div class="form-group" id="form_ul_work_address" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısıss'></cfsavecontent>
								<div class="col col-8 col-xs-12"><textarea name="work_address" id="work_address" onkeyup="return ismaxlength(this)" maxlength="750" onblur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:150px;height:65px;" tabindex="4"></textarea></div>
							</div>
							<div class="form-group" id="form_ul_work_postcode" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="work_postcode" id="work_postcode" maxlength="5" tabindex="4" onkeyup="isNumber(this);"></div>
							</div>
							<div class="form-group" id="form_ul_work_country" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
								<div class="col col-8 col-xs-12">
									<select name="work_country" id="work_country" tabindex="4" onchange="LoadCity(this.value,'work_city_id','work_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'work_district_id'</cfif>)">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_country">
											<cfset is_load_country = 1>
											<option value="#country_id#" <cfif is_default eq 1>selected</cfif>>#country_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_work_city_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
								<div class="col col-8 col-xs-12">
									<select name="work_city_id" id="work_city_id"  onchange="LoadCounty(this.value,'work_county_id','work_telcode'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'work_district_id'</cfif>)">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_work_county_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
								<div class="col col-8 col-xs-12">
									<select name="work_county_id" id="work_county_id" <cfif is_adres_detail eq 1 and is_residence_select eq 1>onChange="LoadDistrict(this.value,'work_district_id');"</cfif>>
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_work_semt" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="work_semt" id="work_semt" value="" maxlength="30" tabindex="4"> </div>
							</div>
							<div class="form-group" id="form_ul_work_district" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
								<div class="col col-8 col-xs-12">
									<cfif is_residence_select eq 0>
										<input type="text" name="work_district" id="work_district" value="">
									<cfelse>
											<select name="work_district_id" id="work_district_id" onchange="get_ims_code(2);">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										</select>
									</cfif>
								</div>
							</div>
							<div class="form-group" id="form_ul_work_main_street" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30629.Cadde'></label>
								<div class="col col-8 col-xs-12"><input type="text" id="work_main_street" name="work_main_street" maxlength="50"></div>
							</div>
							<div class="form-group" id="form_ul_work_street" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30630.Sokak'></label>
								<div class="col col-8 col-xs-12"><input type="text" name="work_street" id="work_street" maxlength="50"></div>
							</div>
							<div class="form-group" id="form_ul_work_door_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30215.Adres Detay'></label>
								<div class="col col-8 col-xs-12"><textarea name="work_door_no" id="work_door_no" maxlength="200"></textarea></div>
							</div>
						</div>
					</cf_box_elements>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="30248.Satış Bilgileri"></cfsavecontent>
				<cf_seperator name="#message#" title="#message#" id="satis_bilgileri">
					<cf_box_elements id="satis_bilgileri">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="8" sort="true">
							<div class="form-group col col-2 col-md-1 col-sm-6 col-xs-12" id="form_ul_is_cari" >
								<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> <cf_get_lang dictionary_id='30392.Çalışabilir'>
								<input type="checkbox" name="is_cari" id="is_cari" value="1" tabindex="7" style="margin-left:-3px;"></label>
							</div>
							<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="form_ul_is_taxpayer" >
								<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='30655.Vergi Mükellefi'>
								<input type="checkbox" name="is_taxpayer" id="is_taxpayer" value="1" tabindex="6" style="margin-left:-3px;">
							</label>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-xs-12" type="column" index="9" sort="true">
							<div class="form-group" id="form_ul_sales_county" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'><cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_saleszone
											name="sales_county"
											width="150"
											tabindex="7">
								</div>
							</div>
							<div class="form-group" id="form_ul_pos_code_text" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57908.Temsilci'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="pos_code" id="pos_code" value="<cfif x_agent_default_session eq 1><cfoutput>#session.ep.position_code#</cfoutput></cfif>">
										<input readonly type="text" name="pos_code_text" id="pos_code_text" value="<cfif x_agent_default_session eq 1><cfoutput>#get_emp_info(session.ep.position_code,1,0)#</cfoutput></cfif>">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_consumer.pos_code&field_name=add_consumer.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1');return false" tabindex="7" ></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_hierarchy_company" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30171.Üst Şirket'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="hierarchy_id" id="hierarchy_id" value="">
										<input type="text" name="hierarchy_company" id="hierarchy_company" readonly>
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_consumer.hierarchy_id&field_comp_name=add_consumer.hierarchy_company<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2');return false" tabindex="7" ></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_ims_code_name" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58134.Micro Bölge Kodu'><cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="ims_code_id" id="ims_code_id">
										<cfinput type="text" name="ims_code_name" id="ims_code_name">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=add_consumer.ims_code_name&field_id=add_consumer.ims_code_id','','ui-draggable-box-small');" tabindex="7"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_camp_name" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfoutput>
											<input type="hidden" name="camp_id" id="camp_id" value="">
											<input type="text" name="camp_name" id="camp_name" value="">
											<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_consumer.camp_id&field_name=add_consumer.camp_name');"></span>
										</cfoutput>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-xs-12" type="column" index="10" sort="true">
							<div class="form-group" id="form_ul_tax_office">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12"><input type="text" name="tax_office" id="tax_office" maxlength="50" tabindex="8"></div>
							</div>
							<div class="form-group" id="form_ul_tax_no" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57752.Vergi No!'></cfsavecontent>
									<cfif isdefined("attributes.tax_no")>
										<cfinput type="text" name="tax_no" id="tax_no" validate="integer" message="#message#" tabindex="8" maxlength="10" onKeyUp="isNumber(this);" value="#attributes.tax_no#">
									<cfelse>
										<cfinput type="text" name="tax_no" id="tax_no" validate="integer" message="#message#" tabindex="8" maxlength="10" onKeyUp="isNumber(this);" value="">
									</cfif>
								</div>
							</div>
							<div class="form-group" id="form_ul_tax_address">
								<cfif isdefined("attributes.home_address")><cfset home_address_ = attributes.home_address><cfelse><cfset home_address_ = ""></cfif>
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30261.Fatura Adresi'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısıss'></cfsavecontent>
								<div class="col col-8 col-xs-12"><textarea name="tax_address" id="tax_address" onkeyup="return ismaxlength(this)" maxlength="750" onblur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" tabindex="8" style="width:150px;height:65px;"><cfoutput>#home_address_#</cfoutput></textarea></div>
							</div>
							<div class="form-group" id="form_ul_tax_postcode" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12"><input type="text" name="tax_postcode" id="tax_postcode" tabindex="8" value="<cfif isdefined("attributes.home_postcode")><cfoutput>#attributes.home_postcode#</cfoutput></cfif>" maxlength="15" onkeyup="isNumber(this);"></div>
							</div>
							<div class="form-group" id="form_ul_tax_country" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12">
									<select name="tax_country" id="tax_country" tabindex="8" onchange="LoadCity(this.value,'tax_city_id','tax_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif><cfif is_adres_detail eq 1 and is_residence_select eq 1>,'tax_district_id'</cfif>)">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_country">
											<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_tax_city_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
										<cfquery name="GET_CITY" datasource="#DSN#">
											SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
										</cfquery>
										<select name="tax_city_id" id="tax_city_id" onchange="LoadCounty(this.value,'tax_county_id'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'tax_district_id'</cfif>)">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfoutput query="GET_CITY">
												<option value="#city_id#" <cfif city_id eq attributes.city_id>selected</cfif>>#city_name#</option>
											</cfoutput>
										</select>
									<cfelse>
										<select name="tax_city_id" id="tax_city_id" onchange="LoadCounty(this.value,'tax_county_id'<cfif is_adres_detail eq 1 and is_residence_select eq 1>,'tax_district_id'</cfif>)">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										</select>
									</cfif>
								</div>
							</div>
							
							<div class="form-group" id="form_ul_tax_county_id" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12">
									<cfif is_adres_detail eq 1 and is_residence_select eq 1>
										<select name="tax_county_id" id="tax_county_id" onChange="LoadDistrict(this.value,'home_district_id');">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfif isdefined('attributes.county_id') and len(attributes.county_id)>
												<cfquery name="GET_COUNTY" datasource="#DSN#">
													SELECT 
														COUNTY_ID,
														CITY,
														CASE
															WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
															ELSE COUNTY_NAME
														END AS COUNTY_NAME
													FROM 
														SETUP_COUNTY
														LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COUNTY.COUNTY_ID
														AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COUNTY_NAME">
														AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COUNTY">
														AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
														WHERE 1 = 1 <cfif isDefined("attributes.city_id") and len(attributes.city_id)>AND CITY = #attributes.city_id# ORDER BY COUNTY_NAME</cfif>
												</cfquery>
												<cfoutput query="get_county">
													<option value="#county_id#" <cfif attributes.county_id eq get_county.county_id>selected</cfif>>#county_name#</option>
												</cfoutput>
												
											</cfif>
										</select>
									<cfelse>
										<select name="tax_county_id" id="tax_county_id" >
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										</select>
									</cfif>
								</div>
							</div>
							<div class="form-group" id="form_ul_tax_semt" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12"><input type="text" name="tax_semt" id="tax_semt" tabindex="8" value="<cfif isdefined("attributes.home_semt")><cfoutput>#attributes.home_semt#</cfoutput></cfif>" maxlength="30"></div>
							</div>
							<div class="form-group" id="form_ul_tax_district" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12">
									<cfif is_residence_select eq 0>
										<input type="text" name="tax_district" id="tax_district" value="">
									<cfelse>
										<select name="tax_district_id" id="tax_district_id" onchange="get_ims_code(3);">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										</select>
									</cfif>
								</div>
							</div>
							<div class="form-group" id="form_ul_tax_main_street" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30629.Cadde'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12"><input type="text" name="tax_main_street" id="tax_main_street"></div>
							</div>
							<div class="form-group" id="form_ul_tax_street" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30630.Sokak'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12"><input type="text" name="tax_street" id="tax_street"></div>
							</div>
							<div class="form-group" id="form_ul_tax_door_no" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30215.Adres Detay'><cfif is_invoice_info_detail eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12"><textarea name="tax_door_no" id="tax_door_no" maxlength="200"></textarea></div>
							</div>
							<div class="form-group" id="form_ul_coordinate_1" >
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58549.Koordinatlar'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<span class="input-group-addon bold"><cf_get_lang dictionary_id='58553.E'></span>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='59875.Lütfen enlem değerini -90 ile 90 arasında giriniz'></cfsavecontent>
										<cfinput type="text" maxlength="10" range="-90,90" message="#message#" value="" name="coordinate_1" id="coordinate_1" style="width:64px;"> 
										<span class="input-group-addon bold"><cf_get_lang dictionary_id='58591.B'></span>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='59894.Lütfen boylam değerini -180 ile 180 arasında giriniz'></cfsavecontent>
										<cfinput type="text" maxlength="10" range="-180,180" message="#message#" value="" name="coordinate_2" id="coordinate_2" style="width:63px;">
									</div>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol()">
					</cf_box_footer>	
				<cfelse>
					<cfinclude template="form_add_fast_consumer.cfm">
				</cfif>
			</cfform>
		</cf_box>
	</div>
<script type="text/javascript">
	<cfif isdefined("is_adres_detail")>
		var is_adres_detail = '<cfoutput>#is_adres_detail#</cfoutput>';
	<cfelse>
		var is_adres_detail = 0;
	</cfif>
	<cfif isdefined("is_residence_select")>
		var is_residence_select = '<cfoutput>#is_residence_select#</cfoutput>';
	<cfelse>
		var is_residence_select = 0;
	</cfif>
	<cfif isdefined("is_req_reference_member")>
		var is_req_reference_member = '<cfoutput>#is_req_reference_member#</cfoutput>';
	<cfelse>
		var is_req_reference_member = 0;
	</cfif>
	<cfif isdefined("is_dsp_reference_member")>
		var is_dsp_reference_member = '<cfoutput>#is_dsp_reference_member#</cfoutput>';
	<cfelse>
		var is_dsp_reference_member = 0;
	</cfif>
	<cfif isdefined("is_dsp_category")>
		var is_dsp_category = '<cfoutput>#is_dsp_category#</cfoutput>';
	<cfelse>
		var is_dsp_category = 0;
	</cfif>
	<cfif isdefined("is_dsp_personal_info")>
		var is_dsp_personal_info = '<cfoutput>#is_dsp_personal_info#</cfoutput>';
	<cfelse>
		var is_dsp_personal_info = 0;
	</cfif>
	<cfif isdefined("is_dsp_homeaddress_info")>
		var is_dsp_homeaddress_info = '<cfoutput>#is_dsp_homeaddress_info#</cfoutput>';
	<cfelse>
		var is_dsp_homeaddress_info = 0;
	</cfif>
	<cfif isdefined("is_dsp_workaddress_info")>
		var is_dsp_workaddress_info = '<cfoutput>#is_dsp_workaddress_info#</cfoutput>';
	<cfelse>
		var is_dsp_workaddress_info = 0;
	</cfif>
	<cfif isdefined("is_fast_add_display")>
		var is_fast_add_display = '<cfoutput>#is_fast_add_display#</cfoutput>';
	<cfelse>
		var is_fast_add_display = 0;
	</cfif>
	<cfif isdefined("is_invoice_info_detail")>
		var is_invoice_info_detail = '<cfoutput>#is_invoice_info_detail#</cfoutput>';
	<cfelse>
		var is_invoice_info_detail = 0;
	</cfif>
	<cfif isdefined("is_birthday")>
		var is_birthday = '<cfoutput>#is_birthday#</cfoutput>';
	<cfelse>
		var is_birthday = 0;
	</cfif>
	<cfif isdefined("is_home_telephone")>
		var is_home_telephone = '<cfoutput>#is_home_telephone#</cfoutput>';
	<cfelse>
		var is_home_telephone = 0;
	</cfif>
	<cfif isdefined("is_dsp_photo")>
		var is_dsp_photo = '<cfoutput>#is_dsp_photo#</cfoutput>';
	<cfelse>
		var is_dsp_photo = 0;
	</cfif>
	<cfif isdefined("is_resource_info")>
		var is_resource_info = '<cfoutput>#is_resource_info#</cfoutput>';
	<cfelse>
		var is_resource_info = 0;
	</cfif>
	<cfif isdefined("is_cari_working")>
		var is_cari_working = '<cfoutput>#is_cari_working#</cfoutput>';
	<cfelse>
		var is_cari_working = 0;
	</cfif>
	if(is_dsp_workaddress_info == 1)
	{
		var work_country_ = document.add_consumer.work_country.value;
		if(work_country_.length)
			LoadCity(work_country_,'work_city_id','work_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>);
	}
	<cfif not isdefined('attributes.city_id')>
		if(is_dsp_homeaddress_info == 1)
		{
			var home_country_ = document.add_consumer.home_country.value;
			if(home_country_.length)
				{
				LoadCity(home_country_,'home_city_id','home_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>);
				}
		}
	
	if(is_fast_add_display == 0)
	{
		var tax_country_ = document.add_consumer.tax_country.value;
		if(tax_country_.length)
			LoadCity(tax_country_,'tax_city_id','tax_county_id',<cfif isdefined("is_sales_zone_kontrol") and is_sales_zone_kontrol eq 1><cfoutput>'#kontrol_zone#'</cfoutput><cfelse>0</cfif>);
	}	
	</cfif>
	function kontrol()
	{
		
	if(is_fast_add_display == 0)
		{
			if(document.getElementById("use_efatura").checked == true && document.getElementById("efatura_date").value == "")
			{
				alert("<cf_get_lang dictionary_id='57943.Tarih Seçiniz'>!");
				return false;
			}
			if(document.getElementById("use_efatura").checked == false && document.getElementById("efatura_date").value != "")
			{
				alert("<cf_get_lang dictionary_id='30110.E-fatura tarihi girilmiş ancak E-fatura checkboxı seçili değildir, Lütfen kontrol ediniz'>");
				return false;
			}
		}
		if(document.getElementById('consumer_name').value=='')
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57631.Ad'>");
			return false;
		}
		if(document.getElementById('consumer_surname').value=='')
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58726.Soyad'>");
			return false;
		}
		// uye kategorisi gorunsun mu
		if(is_dsp_category == 1 && document.add_consumer.consumer_cat_id != undefined)
		{
			x = document.add_consumer.consumer_cat_id.selectedIndex;
			if (document.add_consumer.consumer_cat_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58609.Üye Kategorisi'>!");
				return false;
			}
		}
		<cfif xml_mobile_tel_required eq 1>
			//mobil tel zorunlu ise
			if(document.getElementById('mobiltel').value=='')
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30181.Mobil Telefon'>");
				return false;
			}
		</cfif>
		<cfif isdefined('is_fast_add_member_option') and is_fast_add_member_option eq 2> 
			if(document.add_consumer.member_add_option_id.value == '')
			{
				alert("<cf_get_lang dictionary_id='30294.Lütfen üye özel tanımı seçiniz!'>");
				return false;
			}
		</cfif>
		if((document.add_consumer.coordinate_1 != undefined && document.add_consumer.coordinate_1.value.length != "" && document.add_consumer.coordinate_2 != undefined && document.add_consumer.coordinate_2.value.length == "") || (document.add_consumer.coordinate_1 != undefined && document.add_consumer.coordinate_1.value.length == "" && document.add_consumer.coordinate_2 != undefined && document.add_consumer.coordinate_2.value.length != ""))
		{
			alert ("<cf_get_lang dictionary_id='30292.Lütfen koordinat değerlerini eksiksiz giriniz!'>");
			return false;
		}
		
		/*if(is_dsp_personal_info == 1 || is_fast_add_display == 1)
		{
			if(is_tc_number == 1)
			{
				if(!isTCNUMBER(document.add_consumer.tc_identity_no)) return false;
			}			
		}*/
		
		<cfif is_tc_number eq 1>
			if(document.getElementById('is_verify') != undefined )
			{
				if(document.getElementById('is_verify').value == 0)
				{
					alert("<cf_get_lang dictionary_id='59877.TC Kimlik No Değerini Kontrol Ediniz'> !");
					return false;
				}
			}
		</cfif>

		//referans uye gosterilsin mi // zorunlu olsun mu
		if(is_dsp_reference_member == 1 && is_req_reference_member == 1 && document.add_consumer.ref_pos_code_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58636.Referans Üye'>!");
			document.getElementById('ref_pos_code_name').focus();
			return false;
		}
		//fatura bilgileri zorunlu olsun mu
		if(is_invoice_info_detail == 1)
		{
			if(document.add_consumer.tax_office != undefined  && document.add_consumer.tax_office.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58762.vergi dairesi'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
				document.getElementById('tax_office').focus();
				return false;
			}
			if(document.add_consumer.tax_no != undefined  && document.add_consumer.tax_no.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57752.vergi no'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
				document.getElementById('tax_no').focus();
				return false;
			}
			if(document.add_consumer.tax_postcode != undefined  && document.add_consumer.tax_postcode.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57472.posta kodu'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
				document.getElementById('tax_postcode').focus();
				return false;
			}
			if(document.add_consumer.tax_country != undefined  && document.add_consumer.tax_country.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58219.ülke'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
				return false;
			}
			if(document.add_consumer.tax_city_id != undefined  && document.add_consumer.tax_city_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57971.şehir'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
				return false;
			}
			if(document.add_consumer.tax_county_id != undefined  && document.add_consumer.tax_county_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58638.ilçe'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
				return false;
			}
			if(document.add_consumer.tax_semt != undefined  && document.add_consumer.tax_semt.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58132.semt'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
				document.getElementById('tax_semt').focus();				
				return false;
			}
			if(is_adres_detail == 0)
			{
				if(document.add_consumer.tax_address != undefined  && document.add_consumer.tax_address.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30261.fatura adresi'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_address').focus();
					return false;
				}
			}
			else if(is_adres_detail == 1)
			{
				if(document.add_consumer.tax_district_id != undefined  && ((is_residence_select == 0 && document.add_consumer.tax_district.value == "") || (is_residence_select == 1 && document.add_consumer.tax_district_id.value == "")))
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58735.mahalle'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
					if(is_residence_select == 0)
					{
						document.getElementById('tax_district').focus();
					}
					return false;
				}
				if(document.add_consumer.tax_main_street != undefined  && document.add_consumer.tax_main_street.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30629.cadde'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_main_street').focus();
					return false;
				}
				if(document.add_consumer.tax_street != undefined  && document.add_consumer.tax_street.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30630.sokak'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_street').focus();					
					return false;
				}
				if(document.add_consumer.tax_door_no != undefined  && document.add_consumer.tax_door_no.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57487.no'> (<cf_get_lang dictionary_id ='30659.Fatura Bilgileri İçin'>)!");
					document.getElementById('tax_door_no').focus();					
					return false;
				}
			}
		}

		//dogum tarihi zorunlu olsun mu (kisisel bilgiler yada hizli ekleme varsa)
		if((is_dsp_personal_info == 1 || is_fast_add_display == 1) && is_birthday == 1 && document.add_consumer.birthdate.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58727.Doğum Tarihi!'>!");
			document.getElementById('birthdate').focus();			
			return false;
		}
		
		if((is_dsp_personal_info == 1 || is_fast_add_display == 1) && (document.add_consumer.married.checked == false && document.add_consumer.married_date.value != ''))
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30513.Medeni Durumu'>!");
			document.getElementById('married_date').focus();			
			return false;
		}
		
		//ev telefonu zorunlu olsun mu (kisisel bilgiler yada hizli ekleme varsa)
		if((is_dsp_homeaddress_info == 1 || is_fast_add_display == 1) && is_home_telephone == 1)
		{
			if(document.add_consumer.home_telcode.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30316.Telefon Kodu'>!");
				document.getElementById('home_telcode').focus();				
				return false;
			}
			if(document.add_consumer.home_tel.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='58814.Ev Telefonu'>!");
				document.getElementById('home_tel').focus();
				return false;
			}
		}
		
		if(document.add_consumer.work_address != undefined)
		{
			x = (200 - document.add_consumer.work_address.value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang dictionary_id='30607.İş Adresi'><cf_get_lang dictionary_id='58210.Alanındaki Fazla Karakter Sayısı'>"+ ((-1) * x));
				return false;
			}	
		}

		if(document.add_consumer.home_address != undefined)
		{	
			x = (200 - document.add_consumer.home_address.value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang dictionary_id='30606.Ev Adresi'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayısı'>"+ ((-1) * x));
				return false;
			}
		}
		if(document.add_consumer.tax_address != undefined)
		{	
			x = (750 - document.add_consumer.tax_address.value.length);
			if ( x < 0 )
			{ 
				alert ("<cf_get_lang dictionary_id='30261.Fatura Adresi'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayısı'>:"+ ((-1) * x));
				return false;
			}
		}
		if(document.add_consumer.consumer_password != undefined)
		{
			x = (document.add_consumer.consumer_password.value.length);
			if ((document.add_consumer.consumer_password.value != '')  && ( x < 4 ))
			{ 
				alert ("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='30334.Şifre-En Az Dört Karakter'>");
				return false;
			}		
		}
		if(is_resource_info == 1)
		{
			if(document.add_consumer.resource.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58830.İlişki Şekli'> !");
				return false;
			}
		}
		
		if(is_cari_working == 1)
		{
			if(document.add_consumer.is_cari.checked == false)
			{
				alert("<cf_get_lang dictionary_id='30299.Çalışılabilir Alanı Seçili Olmalıdır!'>");
				return false;
			}
		}	
		
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>	
			if(document.add_consumer.sales_county!=undefined)
			{
			x = document.add_consumer.sales_county.selectedIndex;
			if (document.add_consumer.sales_county[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57659.Satış Bölgesi '>!");
				return false;
			}
			if(document.add_consumer.ims_code_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58134.Micro Bölge Kodu'> !");
				return false;
			}	
			}		
		</cfif>	
		if(is_dsp_photo == 1)
		{
			var obj =  document.add_consumer.picture.value;
			if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png')))
			{
				alert("<cf_get_lang dictionary_id='30335.Lütfen bir resim dosyasıgif jpg veya png giriniz'>!!");        
				return false;
			}
		}
		<cfif xml_check_cell_phone eq 1>
			if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "")
			{
				
				var listParam = document.getElementById('mobilcat_id').value + "*" + document.getElementById('mobiltel').value;
				var get_results = wrk_safe_query('mr_add_cell_phone',"dsn",0,listParam);
				if(get_results.recordcount>0)
				{
					  alert("<cf_get_lang dictionary_id='30295.Girdiğiniz Cep Telefonuna Kayıtlı Başka Temsilci Bulunmaktadır!'>");
					  document.getElementById('mobiltel').focus();
					  return false;
				}              
			}
		</cfif>
		<cfif isdefined('xml_consumer_contract_id') and len(xml_consumer_contract_id)>
			if(document.getElementById('contract_rules').checked!=true)
			{
				alert ("<cf_get_lang dictionary_id='30234.Temsilci sözleşmesini kabul ediyorum seçeneğini seçmelisiniz!'>");
				return false;
			}
		</cfif>
		/*if(document.getElementById('consumer_email').value.search('@') == -1)
		{
			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'> ! ");
			return false;
		}  */
		// e-mail zorunlulugu kaldirildi work_id: 72456
		/*var aaa = document.getElementById('consumer_email').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
		{ 
			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='16.E-mail'> !");
			document.getElementById('consumer_email').focus();
			return false;
		}
		*/
		if(process_cat_control())
			if(confirm("<cf_get_lang dictionary_id='30313.Girdiğiniz Bilgileri Kaydetmek Üzeresiniz Lütfen Değişiklikleri Onaylayın'>")) {pre_records();return false;} else return false;
		else
			return false;
	}
	
	function pre_records()
	{
		<cfif session.ep.isBranchAuthorization>	
			if(add_consumer.tax_no != undefined)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&is_store_module=1&consumer_name=' + encodeURIComponent(document.getElementById('consumer_name').value) + '&consumer_surname=' + encodeURIComponent(document.getElementById('consumer_surname').value) + '&tax_no=' + add_consumer.tax_no.value ,'project');
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&is_store_module=1&consumer_name=' + encodeURIComponent(document.getElementById('consumer_name').value) + '&consumer_surname=' + encodeURIComponent(document.getElemetnById('consumer_surname').value) + '&tax_no=0' ,'project');
		<cfelse>
			if(add_consumer.tax_no != undefined)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&consumer_name=' + encodeURIComponent(document.getElementById('consumer_name').value) + '&consumer_surname=' + encodeURIComponent(document.getElementById('consumer_surname').value) + '&tax_no=' + document.getElementById('tax_no').value ,'project');
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_consumer_prerecords&consumer_name=' + encodeURIComponent(document.getElementById('consumer_name').value) + '&consumer_surname=' + encodeURIComponent(document.getElementById('consumer_surname').value)+'&tax_no=0' ,'project');
		</cfif>
		return false;
	}
	
	function get_ims_code(type)
	{
		if(type == 1)
		{
			get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('home_district_id').value);
			get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('home_district_id').value);
			if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
			{		
				document.getElementById('home_semt').value=get_ims_code_.PART_NAME;
				document.getElementById('home_postcode').value=get_ims_code_.POST_CODE;
			}
			else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
			{
				document.getElementById('home_semt').value = get_district_.PART_NAME;
				document.getElementById('home_postcode').value = get_district_.POST_CODE;
			}
			else
			{
				document.getElementById('home_semt').value = '';
				document.getElementById('home_postcode').value = '';
			}
		}
		else if(type == 2)
		{
			get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('work_district_id').value);
			get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('work_district_id').value);
			if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
			{		
				document.getElementById('work_semt').value=get_ims_code_.PART_NAME;
				document.getElementById('work_postcode').value=get_ims_code_.POST_CODE;
			}
			else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
			{
				document.getElementById('work_semt').value = get_district_.PART_NAME;
				document.getElementById('work_postcode').value = get_district_.POST_CODE;
			}
			else
			{
				document.getElementById('work_semt').value = '';
				document.getElementById('work_postcode').value = '';
			}
		}
		else
		{
			get_ims_code_ = wrk_safe_query("mr_get_ims_code","dsn",0,document.getElementById('tax_district_id').value);
			get_district_ = wrk_safe_query("mr_get_district","dsn",0,document.getElementById('tax_district_id').value);
			if(get_ims_code_.IMS_CODE !=undefined && get_ims_code_.PART_NAME!=undefined)
			{		
				document.getElementById('tax_semt').value=get_ims_code_.PART_NAME;
				document.getElementById('tax_postcode').value=get_ims_code_.POST_CODE;
			}
			else if (get_district_.PART_NAME != undefined || get_district_.POST_CODE != undefined)
			{
				document.getElementById('tax_semt').value = get_district_.PART_NAME;
				document.getElementById('tax_postcode').value = get_district_.POST_CODE;
			}
			else
			{
				document.getElementById('tax_semt').value = '';
				document.getElementById('tax_postcode').value = '';
			}
		}
	}
	function goruntule(obj)
	{
		if(obj.value == 1)
			goster(form_ul_married_date);
		else
			gizle(form_ul_married_date);
	}
document.getElementById('consumer_name').focus();

	function mukellefSorgula() {
		$("#working_div_main").show();
		let tckn = $("#tc_identity_no").val();
		$.ajax("/wex.cfm/customerinfo/mukellefsorgulama",{ 
			method: "POST",
			contentType: "application/json",
			data: JSON.stringify({ mukkelleftip: "sahis", tckn: tckn })
		}).done(function (d) {
			let jd = JSON.parse(d);
			console.log(jd);
			$("#working_div_main").hide();
			if (jd.status == 0) {
				$('.ui-cfmodal__alert .required_list li').remove();
				$('.ui-cfmodal__alert .required_list').append('<li class="required"><i class="fa fa-terminal"></i>'+jd.message+'</li>');
				$('.ui-cfmodal__alert').fadeIn();
			} else {
				$("#consumer_name").val(jd.result.ADI);
				$("#consumer_surname").val(jd.result.SOYADI);
				$("#title").val(jd.result.ADI + " " + jd.result.SOYADI);
				$("#father").val(jd.result.BABAADI);

				$("#home_country").find("option:contains(Türkiye)")[0].selected = true;
				$("#home_country").change();
				setTimeout(() => {
					let city = $("#home_city_id").find("option:contains("+jd.result.IKAMETGAHADRESI.ILADI+")");
					if (city.length > 0) {
						$(city)[0].selected = true;
						$("#home_city_id").change();
						setTimeout(() => {
							let county = $("#home_county_id").find("option:contains("+jd.result.IKAMETGAHADRESI.ILCEADI+")");
							if (county.length > 0) {
								$(county)[0].selected = true;
								$("#home_county_id").change();
							}
						}, 1000);
					}	
				}, 1000);
				$("#home_district").val(jd.result.IKAMETGAHADRESI.MAHALLESEMT);
				$("#home_semt").val(jd.result.IKAMETGAHADRESI.MAHALLESEMT);
				$("#home_main_street").val(jd.result.IKAMETGAHADRESI.CADDESOKAK);
				$("#home_street").val(jd.result.IKAMETGAHADRESI.CADDESOKAK);
				$("#home_door_no").val( (typeof jd.result.IKAMETGAHADRESI.KAPINO == "undefined" ? "" : jd.result.IKAMETGAHADRESI.KAPINO) + " " + (typeof jd.result.IKAMETGAHADRESI.DAIRENO == "undefined" ? "" : jd.result.IKAMETGAHADRESI.DAIRENO) );
				if ( typeof jd.result.ISADRESI != "undefined" ) {
					$("#work_country").find("option:contains(Türkiye)")[0].selected = true;
					$("#work_country").change();
					setTimeout(() => {
						let city = $("#work_city_id").find("option:contains("+jd.result.ISADRESI.ILADI+")");
						if (city.length > 0) {
							$(city)[0].selected = true;
							$("#work_city_id").change();
							setTimeout(() => {
								let county = $("#work_county_id").find("option:contains("+jd.result.ISADRESI.ILCEADI+")");
								if (county.length > 0) {
									$(county)[0].selected = true;
									$("#work_county_id").change();
								}
							}, 1000);
						}	
					}, 1000);
					$("#work_district").val(jd.result.ISADRESI.MAHALLESEMT);
					$("#work_semt").val(jd.result.ISADRESI.MAHALLESEMT);
					$("#work_main_street").val(jd.result.ISADRESI.CADDESOKAK);
					$("#work_street").val(jd.result.ISADRESI.CADDESOKAK);
					$("#work_door_no").val( (typeof jd.result.ISADRESI.KAPINO == "undefined" ? "" : jd.result.ISADRESI.KAPINO) + " " + (typeof jd.result.ISADRESI.DAIRENO == "undefined" ? "" : jd.result.ISADRESI.DAIRENO) );

					$("#tax_country").find("option:contains(Türkiye)")[0].selected = true;
					$("#tax_country").change();
					setTimeout(() => {
						let city = $("#tax_city_id").find("option:contains("+jd.result.ISADRESI.ILADI+")");
						if (city.length > 0) {
							$(city)[0].selected = true;
							$("#tax_city_id").change();
							setTimeout(() => {
								let county = $("#tax_county_id").find("option:contains("+jd.result.ISADRESI.ILCEADI+")");
								if (county.length > 0) {
									$(county)[0].selected = true;
									$("#tax_county_id").change();
								}
							}, 1000);
						}	
					}, 1000);
					$("#tax_district").val(jd.result.ISADRESI.MAHALLESEMT);
					$("#tax_semt").val(jd.result.ISADRESI.MAHALLESEMT);
					$("#tax_main_street").val(jd.result.ISADRESI.CADDESOKAK);
					$("#tax_street").val(jd.result.ISADRESI.CADDESOKAK);
					$("#tax_door_no").val( (typeof jd.result.ISADRESI.KAPINO == "undefined" ? "" : jd.result.ISADRESI.KAPINO) + " " + (typeof jd.result.ISADRESI.DAIRENO == "undefined" ? "" : jd.result.ISADRESI.DAIRENO) );
					if (typeof jd.result.VERGIDAIRESIADI != "undefined") {
						$("#tax_office").val(jd.result.VERGIDAIRESIADI);
					}
					if (typeof jd.result.VKN != "undefined") {
						$("#tax_no").val(jd.result.VKN);
					}
					$("#tax_address").val(jd.result.ISADRESI.ILADI + " " + jd.result.ISADRESI.ILCEADI + " " + jd.result.ISADRESI.MAHALLESEMT + " " + jd.result.ISADRESI.CADDESOKAK + " NO:" + (typeof jd.result.ISADRESI.KAPINO == "undefined" ? "" : jd.result.ISADRESI.KAPINO) + " " + (typeof jd.result.ISADRESI.DAIRENO == "undefined" ? "" : jd.result.ISADRESI.DAIRENO));
				}
			}
		})
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
