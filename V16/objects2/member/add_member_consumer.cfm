<cfif isdefined("attributes.is_ref_member_zone") and attributes.is_ref_member_zone eq 1>
	<cfinclude template="../login/send_login.cfm">
	<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
</cfif>
<cfinclude template="../query/get_mobilcat.cfm">
<cfinclude template="../query/get_company_size_cats.cfm">
<cfinclude template="../query/get_sector_cats.cfm">
<cfinclude template="../query/get_company_size.cfm">
<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_vocation_type.cfm">

<cfparam name="attributes.is_tc_number_required" default="1">

<!--- Aktif kategorilerin gelmesi için --->
<cfset is_active_consumer_cat = 1>
<cfinclude template="../query/get_consumer_cat.cfm">
<cfquery name="GET_CITY" datasource="#DSN#">
    SELECT CITY_ID, CITY_NAME FROM SETUP_CITY
</cfquery>
<cfquery name="GET_RESOURCE" datasource="#DSN#">
	SELECT 
		RESOURCE_ID,
		RESOURCE
	FROM
		COMPANY_PARTNER_RESOURCE
	ORDER BY
		RESOURCE
</cfquery>

<cfif isDefined('attributes.is_detail_address') and attributes.is_detail_address eq 0>
	<cfset attributes.is_residence_select = 0>
</cfif>
<cfif isdefined("session.ww.userid")>
	<cfquery name="GET_BLOCK_INFO" datasource="#DSN#">
		SELECT 
			BG.BLOCK_GROUP_PERMISSIONS AS BLOCK_STATUS
		FROM 
			COMPANY_BLOCK_REQUEST CBL,
			BLOCK_GROUP BG 
		WHERE 
			CBL.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND
			CBL.BLOCK_START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			(CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE> =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) 			
	</cfquery>
	<cfquery name="GET_REF_RECORD" datasource="#DSN#">
		SELECT IS_REF_RECORD FROM CONSUMER_CAT WHERE IS_REF_RECORD = 0 AND CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.consumer_category#">
	</cfquery>
<cfelse>
	<cfset get_block_info.recordcount = 0>
	<cfset get_ref_record.recordcount = 0>
</cfif>
<cfif (get_block_info.recordcount and listgetat(get_block_info.block_status,4,',') eq 1)>
	<table>
		<tr>
			<td><cf_get_lang dictionary_id ='35868.Blok kaydınız olduğu için temsilci kaydı yapamazsınız'> !</td>
		</tr>
	</table>
</cfif>

<cfif get_ref_record.recordcount>
	<table>
		<tr>
			<td>Temsilci Seviyeniz Kayıt Yapmak İçin Yeterli Değildir !</td>
		</tr>
	</table>
</cfif>

<cfset kontrol_zone = 0>
<cfif isdefined("attributes.is_ref_member_zone") and attributes.is_ref_member_zone eq 1 and isdefined("session.ww.userid")>
	<cfquery name="GET_CONTROL_CITY" datasource="#DSN#">
		SELECT ISNULL(HOME_CITY_ID,WORK_CITY_ID) AS CITY_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
	<cfif get_control_city.recordcount and len(get_control_city.city_id)>
		<cfset kontrol_zone = ''>
		<cfquery name="GET_CITY_CODE" datasource="#DSN#">
			SELECT PLATE_CODE FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_control_city.city_id#">
		</cfquery>
		<cfif get_city_code.plate_code eq 34>
			<cfquery name="GET_CITYS" datasource="#DSN#">
				SELECT CITY_ID FROM SETUP_CITY WHERE PLATE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_city_code.plate_code#">
			</cfquery>
			<cfloop query="get_citys">
				<cfset kontrol_zone = listappend(kontrol_zone,get_citys.city_id,',')>
			</cfloop>
		<cfelse>
			<cfset kontrol_zone = listappend(kontrol_zone,get_control_city.city_id,',')>
		</cfif>
	<cfelse>
		<cfset kontrol_zone = -1>
	</cfif>
</cfif>
<cfif ((get_block_info.recordcount and listgetat(get_block_info.block_status,4,',') eq 0) or get_block_info.recordcount eq 0) and get_ref_record.recordcount eq 0>
	<cfform class="mb-0" name="add_consumer" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_cons_member">
		<cfif isdefined("attributes.consumer_resource_id") and len(attributes.consumer_resource_id)>
			<input type="hidden" name="consumer_resource_id" id="consumer_resource_id" value="<cfoutput>#attributes.consumer_resource_id#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.consumer_stage") and len(attributes.consumer_stage)>
			<input type="hidden" name="consumer_stage" id="consumer_stage" value="<cfoutput>#attributes.consumer_stage#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.is_tax_address") and len(attributes.is_tax_address)>
			<input type="hidden" name="is_tax_address" id="is_tax_address" value="<cfoutput>#attributes.is_tax_address#</cfoutput>">
		</cfif>
		<cfif isdefined('attributes.consumer_contract_id') and len(attributes.consumer_contract_id)>
			<input type="hidden" name="consumer_contract_id" id="consumer_contract_id" value="<cfoutput>#attributes.consumer_contract_id#</cfoutput>">
		</cfif>
		<input type="hidden" name="is_tc_number_required_" id="is_tc_number_required_" value="<cfif isdefined("attributes.is_tc_number_required") and len(attributes.is_tc_number_required)><cfoutput>#attributes.is_tc_number_required#</cfoutput></cfif>">     
        <input type="hidden" name="return_address" id="return_address" value="<cfif isdefined("attributes.add_consumer_return_address") and len(attributes.add_consumer_return_address)><cfoutput>#request.self#?fuseaction=#attributes.add_consumer_return_address#</cfoutput></cfif>">
        <input type="hidden" name="is_cons_login" id="is_cons_login" value="<cfif isdefined('attributes.is_cons_login') and attributes.is_cons_login eq 1>1<cfelse>0</cfif>">
        <!---<input type="hidden" name="add_consumer_return_adress" id="add_consumer_return_adress" value="<cfif isdefined('attributes.add_consumer_return_adress') and len(attributes.add_consumer_return_adress)><cfoutput>#attributes.add_consumer_return_adress#</cfoutput></cfif>">--->
        <input type="hidden" name="is_ref_member" id="is_ref_member" value="<cfif isdefined("attributes.is_ref_member") and attributes.is_ref_member eq 1>1<cfelse>0</cfif>">
        <!---<input type="hidden" name="is_mail_control" id="is_mail_control" value="<cfif isdefined("attributes.is_mail_control") and attributes.is_mail_control eq 1>1<cfelse>0</cfif>">
        <input type="hidden" name="is_referans_member" id="is_referans_member" value="<cfif isdefined("attributes.is_referans_member") and attributes.is_referans_member eq 1>1<cfelse>0</cfif>">--->
		<input type="hidden" name="is_password" id="is_password" value="<cfif isdefined("attributes.is_password") and len(attributes.is_password)><cfoutput>#attributes.is_password#</cfoutput></cfif>">
        
        <div class="card border-0 shadow mt-5">
			<div class="card-body">
				<h6 class="mb-3 header-color"><cf_get_lang dictionary_id='29407.Bireysel Üye Ekle'></h6>
				<div class="row mx-auto mt-3">
					<div class="col-md-4">
						<div class="form-group mb-3" style="display:none;">
							<label class="font-weight-bold"></label>
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'> *</label>
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='34540.Lütfen Ad Giriniz'></cfsavecontent>
							<cfinput type="text" class="form-control" name="consumer_name" id="consumer_name" value="" required="yes" message="#message1#" maxlength="30">
						</div>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'>*</label>
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='34558.Lütfen Soyad Giriniz'></cfsavecontent>
							<cfinput type="text" class="form-control" name="consumer_surname" id="consumer_surname" value="" required="yes" message="#message1#" maxlength="30">
						</div>
						<cfif (isdefined("attributes.is_tc_number_view") and attributes.is_tc_number_view eq 1) or not isdefined("attributes.is_tc_number_view")>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='58025.TC Kimlik No'><cfif isdefined("attributes.is_tc_number_required") and attributes.is_tc_number_required> *</cfif></label>
								<cfif (isdefined("attributes.is_birthday") and attributes.is_birthday eq 1) and (isdefined("attributes.is_verify_number") and attributes.is_verify_number eq 1)>
									<cf_wrktcnumber class="form-control" fieldid="tc_identity_no" tc_identity_required="#attributes.is_tc_number_required#" is_verify='1' consumer_name='consumer_name' consumer_surname='consumer_surname' birth_date='birthdate' on_blur_control='1'>
								<cfelse>
									<cf_wrktcnumber class="form-control" fieldid="tc_identity_no" tc_identity_required="#attributes.is_tc_number_required#">
								</cfif>		
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_birthday") and attributes.is_birthday eq 1) or not isdefined("attributes.is_birthday")>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='58727.Doğum Tarihi'>*</label>
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='34620.Geçerli Bir Doğum Tarihi Giriniz'>!</cfsavecontent>
									<cfinput type="text" class="form-control" name="birthdate" id="birthdate" value="" maxlength="10" validate="eurodate" required="yes" message="#message#">
									<cf_wrk_date_image date_field="birthdate">
								</div>
							</div>
						</cfif>
						<cfif isdefined("attributes.is_proposer_cons") and attributes.is_proposer_cons eq 1>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id ='35859.Öneren Üye'> * </label>
								<input type="hidden" name="proposer_cons_id" id="proposer_cons_id" value="">
								<input type="text" class="form-control" name="proposer_cons_name" id="proposer_cons_name" value="" onfocus="AutoComplete_Create('proposer_cons_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_objects2','\'2\',\'0\',\'0\',\'\',\'2\',\'0\'','CONSUMER_ID','proposer_cons_id','add_consumer','3','250');" autocomplete="off">
							</div>
						</cfif>
						<cfif isdefined("attributes.is_ref_member") and attributes.is_ref_member eq 1>                	
							<cfif isdefined("session.ww.userid")>
								<div class="form-group mb-3">
									<label class="font-weight-bold"><cf_get_lang dictionary_id ='58636.Referans Üye'></label>
									<cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
										SELECT CONSUMER_REFERENCE_CODE,CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
									</cfquery>
									<cfquery name="GET_CAMP_ID" datasource="#DSN3#">
										SELECT 
											CAMP_ID,
											CAMP_HEAD
										FROM 
											CAMPAIGNS 
										WHERE 
											CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
											CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
									</cfquery>
									<cfif get_camp_id.recordcount>
										<cfquery name="GET_LEVEL" datasource="#DSN3#">
											SELECT ISNULL(MAX(PREMIUM_LEVEL),0) AS PRE_LEVEL FROM SETUP_CONSCAT_PREMIUM WHERE CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cons_ref_code.consumer_cat_id#"> AND CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_camp_id.camp_id#">
										</cfquery>
										<cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
										<cfset ref_count = ref_count - 2>
									<cfelse>
										<cfset ref_count = 0>
									</cfif>
									<input type="hidden" name="reference_code" id="reference_code" value="<cfoutput>#get_cons_ref_code.consumer_reference_code#</cfoutput>">
									<input type="hidden" name="ref_pos_code" id="ref_pos_code" value="<cfoutput>#session.ww.userid#</cfoutput>">
									<input type="text" class="form-control" name="ref_pos_code_name" id="ref_pos_code_name" onfocus="AutoComplete_Create('ref_pos_code_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_objects2','\'2\',\'0\',\'\',\'2\',\'1\',\'0\',\'<cfoutput>#ref_count#</cfoutput>\',\'1\'','CONSUMER_ID,CONSUMER_REFERENCE_CODE','ref_pos_code,reference_code','add_consumer','3','160');" value="<cfoutput>#get_cons_info(session.ww.userid,0,0)#</cfoutput>" autocomplete="off">
								</div>
							<cfelse>
								<cfif isDefined('attributes.consumer_reference_id') and len(attributes.consumer_reference_id)>
									<cfquery name="GET_CONS_REF_CODE" datasource="#DSN#">
										SELECT CONSUMER_REFERENCE_CODE,CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_reference_id#">
									</cfquery>
								</cfif>
								<input type="hidden" name="reference_code" id="reference_code" value="<cfif isDefined('attributes.consumer_reference_id') and len(attributes.consumer_reference_id) and get_cons_ref_code.recordcount><cfoutput>#attributes.consumer_reference_id#</cfoutput></cfif>">
								<input type="hidden" name="ref_pos_code" id="ref_pos_code" value="<cfif isDefined('attributes.consumer_reference_id') and len(attributes.consumer_reference_id)><cfoutput>#attributes.consumer_reference_id#</cfoutput></cfif>">
								<input type="hidden" name="ref_pos_code_name" id="ref_pos_code_name" onfocus="AutoComplete_Create('ref_pos_code_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_objects2','\'2\',\'0\',\'\',\'2\',\'1\',\'0\',\'0\',\'1\'','CONSUMER_ID,CONSUMER_REFERENCE_CODE','ref_pos_code,reference_code','add_consumer','3','160');" value="<cfif isDefined('attributes.consumer_reference_id') and len(attributes.consumer_reference_id)><cfoutput>#get_cons_info(attributes.consumer_reference_id,0,0)#</cfoutput></cfif>" autocomplete="off">
							</cfif>
						</cfif>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='57764.Cinsiyet'> *</label>
							<select class="form-control" name="sex" id="sex">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
								<option value="0"><cf_get_lang dictionary_id='58958.Kadin'></option>
							</select>
						</div>
						<cfif isdefined("attributes.is_special_code") and attributes.is_special_code eq 1>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='57789.Özel Kod'> *</label>
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id='53684.Lütfen Özel Kod Alanını Boş Geçmeyiniz'></cfsavecontent>
								<cfinput type="text" class="form-control" name="special_code" id="special_code" value="" onKeyUp="isNumber(this);" message="#alert#" required="yes">
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_emp_group") and attributes.is_emp_group eq 1) or not isdefined("attributes.is_emp_group")>
							<!--- <div class="form-group mb-3">
								<cf_get_lang dictionary_id ='35670.Size daha iyi hizmet verebilmemiz için lütfen size en uygun üye grubunu seçiniz'>
							</div> --->
							<div class="form-group mb-3">		
								<label class="font-weight-bold"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
								<select class="form-control" name="consumer_cat_id" id="consumer_cat_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_consumer_cat">
										<option value="#conscat_id#">#conscat#</option>
									</cfoutput>
								</select>
							</div>
						<cfelseif isdefined("attributes.consumer_cat_id")>
							<input type="hidden" name="cons_cat_id" id="cons_cat_id" value="<cfoutput>#attributes.consumer_cat_id#</cfoutput>">
						</cfif>
						<cfif (isdefined("attributes.is_password") and attributes.is_password eq 1) or not isdefined("attributes.is_password")>
							<cfif isdefined("attributes.is_activation") and len(attributes.is_activation)>
								<input type="hidden" name="is_activation" id="is_activation" value="<cfoutput>#attributes.is_activation#</cfoutput>"/>
							</cfif>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='57552.Şifre'> *</label>
								<cfsavecontent variable="alert1">1.<cf_get_lang dictionary_id ='35671.Şifre Alanını Giriniz'></cfsavecontent>
								<cfinput class="form-control" type="password" name="password1" id="password1" required="yes" message="#alert1#"> (<cf_get_lang dictionary_id='34884.En az 6 karakter'>)
							</div>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='59013.Şifre Tekrar'> *</label>
								<cfsavecontent variable="alert2">2.<cf_get_lang dictionary_id ='35671.Şifre Alanını Giriniz'></cfsavecontent>
								<cfinput class="form-control" type="password" name="password2" id="password2" required="yes" message="#alert2#">
							</div>
						</cfif>
						<cfif isdefined("attributes.is_resource") and (attributes.is_resource eq 1 or attributes.is_resource eq 2)>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='58830.İlişki Şekli'> <cfif isdefined("attributes.is_resource") and attributes.is_resource eq 2>*</cfif></label>
								<select class="form-control" name="resource" id="resource">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_resource">
										<option value="#resource_id#">#resource#</option>
									</cfoutput>
								</select>
							</div>
						</cfif>
						<cfif isdefined('attributes.is_member_add_option') and (attributes.is_member_add_option eq 1 or attributes.is_member_add_option eq 2)> 
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id ='35953.Üye Özel Tanımı'><cfif isdefined('attributes.is_member_add_option') and attributes.is_member_add_option eq 2>*</cfif></label>
									<cf_wrk_combo 
									name="member_add_option_id"
									query_name="get_member_add_options_int"
									value=""
									option_name="member_add_option_name"
									option_value="member_add_option_id"
									width="150">
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_country") and attributes.is_country eq 1) or not isdefined("attributes.is_country")>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'></label>
								<select class="form-control" name="home_country" id="home_country" onchange="LoadCity(this.value,'home_city_id','home_county_id',<cfoutput>'#kontrol_zone#'</cfoutput><cfif isdefined('attributes.is_residence_select') and attributes.is_residence_select eq 1>,'home_district_id'</cfif>)">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_country">
										<option value="#country_id#" <cfif is_default eq 1>selected</cfif>>#country_name#</option>
									</cfoutput>
								</select>
							</div>
						<cfelse>
							<cfquery name="GET_DEFAULT_COUNTRY" dbtype="query">
								SELECT COUNTRY_ID FROM GET_COUNTRY WHERE IS_DEFAULT = 1
							</cfquery>
							<input type="hidden" name="home_country" id="home_country" value="<cfoutput>#get_default_country.country_id#</cfoutput>">
						</cfif>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'> *</label>
							<select class="form-control" name="home_city_id" id="home_city_id" onchange="LoadCounty(this.value,'home_county_id','consumer_hometelcode'<cfif isdefined('attributes.is_residence_select') and attributes.is_residence_select eq 1>,'home_district_id'</cfif>)">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_city">
									<option value="#city_id#">#city_name#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'> *</label>
							<select class="form-control" name="home_county_id" id="home_county_id" <cfif isdefined('attributes.is_residence_select') and attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'home_district_id');"</cfif>>
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							</select>
						</div>
						<cfif isdefined('attributes.is_detail_address') and attributes.is_detail_address eq 1>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='58735.Mahalle'> *</label>
								<cfif isdefined('attributes.is_residence_select') and attributes.is_residence_select eq 0>
									<input type="text" class="form-control" name="home_district" id="home_district" value="" style="width:150px;">
								<cfelse>
									<select class="form-control" name="home_district_id" id="home_district_id" style="width:150px;">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									</select>
								</cfif>
							</div>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id ='35656.Cadde'></label>
								<input type="text" class="form-control" name="home_main_street" id="home_main_street" value="" maxlength="50" style="width:150px;">
							</div>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id ='35655.Sokak'></label>
								<input type="text" class="form-control" name="home_street" id="home_street" value="" maxlength="50" style="width:150px;">
							</div>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
								<textarea class="form-control" name="home_door_no" id="home_door_no" style="width:150px;" rows="3" maxlength="200"></textarea>
							</div>
						</cfif>
						<cfif isdefined('attributes.consumer_contract_id') and len(attributes.consumer_contract_id)>
							<cfquery name="GET_CONTENT_ORDER" datasource="#DSN#">
								SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_contract_id#">
							</cfquery>
							<div class="form-group mb-3">
								<a href="javascript://" class="tableyazi" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_content_notice&content_id=#attributes.consumer_contract_id#</cfoutput>','list');"><cfoutput>#get_content_order.cont_head#</cfoutput></a>
							</div>
							<div class="form-group mb-3">
								<input class="form-control" type="checkbox" name="contract_rules" id="contract_rules" class="radio_frame" value="1" /><cf_get_lang dictionary_id ='34485.Temsilci Sözleşmesini Kabul Ediyorum.'> *
							</div>
						</cfif>
						<cfif isdefined('attributes.is_service_email') and attributes.is_service_email eq 1>
							<div class="form-group mb-3">
								<input class="form-control" type="checkbox" name="want_email" id="want_email" value="1" checked="checked" /> <cf_get_lang dictionary_id='34878.Ürünleriniz, hizmetleriniz ve firmanız hakkında e-mail almak istiyorum'>
							</div>
						</cfif>
						<cfif isdefined('attributes.is_service_sms') and attributes.is_service_sms eq 1>
							<div class="form-group mb-3">
								<input class="form-control" type="checkbox" name="want_sms" id="want_sms" value="1" checked="checked" /> <cf_get_lang dictionary_id='34486.SMS ile haberdar olmak istiyorum'>
							</div>
						</cfif>
						<cfif isdefined("attributes.is_member_rules") and len(attributes.is_member_rules)>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='34883.Üyelik Koşulları'></label>
								<textarea class="form-control" name="membership_cond" id="membership_cond" style=" width:350px; height:200px; background-color:#EAEAEA;" readonly="readonly"><cfoutput>#attributes.is_member_rules#</cfoutput></textarea>
							</div>
							<div class="form-group mb-3">
								<input class="form-control" type="checkbox" name="member_rules" id="member_rules" value="1" />
								<cf_get_lang dictionary_id='34882.Üyelik koşullarını kabul ediyorum'>*
							</div>
						</cfif>
						<cfif isdefined('attributes.is_security') and attributes.is_security eq 1>
							<div class="form-group mb-3">
								<cf_wrk_captcha name="captcha" action="display">
							</div>
						</cfif>
						<!--- <div class="form-group mb-3">*<cf_get_lang dictionary_id ='35867.Doldurulması Zorunlu Alanlar'> .</div> --->
					</div>
					<div class="col-md-4">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57499.Telefon'>*</label>
						<div class="form-row">
							<cfif isdefined("attributes.is_telno_required") and attributes.is_telno_required eq 1>
								<div class="form-group mb-3 col-md-3">
									<cfsavecontent variable="message1"><cf_get_lang dictionary_id='34342.Lütfen Telefon Kodu Giriniz'></cfsavecontent>
									<cfsavecontent variable="message2"><cf_get_lang dictionary_id='34343.Lütfen Telefon Numarası Giriniz'></cfsavecontent>	
									<cfinput type="text" class="form-control" name="consumer_hometelcode" id="consumer_hometelcode" value="" maxlength="5" onKeyUp="isNumber(this);" required="yes" message="#message1#">
								</div>
								<div class="form-group mb-3 col-md-3">
									<cfinput type="text" class="form-control" name="consumer_hometel" id="consumer_hometel" value="" maxlength="9" onKeyUp="isNumber(this);" required="yes" message="#message2#">				
								</div>
							<cfelse>
								<div class="form-group mb-3 col-md-3">
									<input type="text" class="form-control" name="consumer_hometelcode" id="consumer_hometelcode" value="" maxlength="5" onkeyup="isNumber(this);">
								</div>
								<div class="form-group mb-3 col-md-9">
									<input type="text" class="form-control" name="consumer_hometel" id="consumer_hometel" value="" maxlength="9" onkeyup="isNumber(this);">
								</div>
							</cfif>
						</div>
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58482.Mobil Tel'> <cfif isdefined("attributes.is_mobil_telno_required") and attributes.is_mobil_telno_required eq 1> * </cfif></label>
						<div class="form-row">
							<div class="form-group mb-3 col-md-3">
								<select class="form-control" name="mobilcat_id" id="mobilcat_id">
									<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_mobilcat">
										<option value="#mobilcat#"> #mobilcat# </option>
									</cfoutput>
								</select>
							</div>
							<div class="form-group mb-3 col-md-9">
								<input type="text" class="form-control" name="mobiltel" id="mobiltel" value="" maxlength="9" onkeyup="isNumber(this);">
							</div>
						</div>
						<cfif isdefined("attributes.is_mobilcode2") and attributes.is_mobilcode2 eq 1>
							<label class="font-weight-bold"><cf_get_lang dictionary_id='58482.Mobil Tel'> 2*</label>
							<div class="form-row">
								<div class="form-group mb-3">
									<select class="form-control" name="mobilcat_id_2" id="mobilcat_id_2">
										<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfoutput query="get_mobilcat">
											<option value="#mobilcat#"> #mobilcat# </option>
										</cfoutput>
									</select>
								</div>
								<div class="form-group mb-3">
									<input type="text" class="form-control" name="mobiltel_2" id="mobiltel_2" value="" maxlength="9" onkeyup="isNumber(this);">
								</div>
							</div>
						</cfif>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='57428.E-Posta'> <cfif isdefined("attributes.is_email_required") and attributes.is_email_required eq 1>*</cfif></label>
							<cfsavecontent variable="msg"><cf_get_lang dictionary_id='35907.E-Posta Girmelisiniz'></cfsavecontent>
							<cfif isdefined("attributes.is_email_required") and attributes.is_email_required eq 1>
								<cfinput type="text" class="form-control" name="consumer_email" id="consumer_email" value="" maxlength="100" validate="email" required="yes" message="#msg#" autocomplete="off">
							<cfelse>
								<cfinput type="text" class="form-control" name="consumer_email" id="consumer_email" value="" maxlength="100" validate="email" message="#msg#" autocomplete="off">                    
							</cfif>
						</div>
						<cfif isdefined("attributes.is_email_double_control") and attributes.is_email_double_control eq 1>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='57428.E-Posta'> <cf_get_lang dictionary_id='58193.Tekrarı'> *</label>
								<cfsavecontent variable="msg2"><cf_get_lang dictionary_id='35908.E-Mail Tekrarı Girmelisiniz'> </cfsavecontent>
								<cfinput type="text" class="form-control" name="consumer_email2" id="consumer_email2" value="" maxlength="100" validate="email" required="yes" message="#msg2#" autocomplete="off" style="width:150px;">
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_job") and attributes.is_job eq 1) or not isdefined("attributes.is_job")>
							<div class="form-group mb-3">		
								<label class="font-weight-bold"><cf_get_lang dictionary_id ='35672.Mesleğiniz'></label>
								<select class="form-control" name="vocation_type" id="vocation_type">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_vocation_type">
										<option value="#vocation_type_id#">#vocation_type#</option>
									</cfoutput>
								</select>
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_your_comp") and attributes.is_your_comp eq 1) or not isdefined("attributes.is_your_comp")>
							<div class="form-group mb-3">		
								<label class="font-weight-bold"><cf_get_lang dictionary_id ='35673.Çalıştığınız Şirket'></label>
								<input type="text" class="form-control" name="company" id="company" value="">(<cf_get_lang dictionary_id ='35674.Şirket veya okul adı'>)
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_your_position") and attributes.is_your_position eq 1) or not isdefined("attributes.is_your_position")>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id ='35675.Göreviniz'></label>
								<input type="text" class="form-control" name="title" id="title" value="">
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_sector") and attributes.is_sector eq 1) or not isdefined("attributes.is_sector")>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='57579.Sektör'></label>
								<select class="form-control" name="sector_cat_id" id="sector_cat_id" size="1">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_sector_cats">
										<option value="#sector_cat_id#">#sector_cat#</option>
									</cfoutput>
								</select>             
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_personel_no") and attributes.is_personel_no eq 1) or not isdefined("attributes.is_personel_no")>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id ='35676.Personel Sayısı'></label>
								<select class="form-control" name="company_size_cat_id" id="company_size_cat_id" size="1">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_company_size_cats">
										<option value="#company_size_cat_id#">#company_size_cat#</option>
									</cfoutput>
								</select>
							</div>
						</cfif>
						<cfif (isdefined('attributes.is_detail_address') and attributes.is_detail_address eq 0) or not isdefined("attributes.is_detail_address")>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
								<textarea class="form-control" name="homeaddress" id="homeaddress"></textarea>
							</div>
						</cfif>
						<cfif (isdefined("attributes.is_post_code") and attributes.is_post_code eq 1) or not isdefined("attributes.is_post_code")>
							<div class="form-group mb-3">
								<label class="font-weight-bold"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
								<input type="text" class="form-control" name="homepostcode" id="homepostcode" value=""/>
							</div>
						</cfif>
					</div>
				</div>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</div>
        </div>
	</cfform>
	<script type="text/javascript">
		<cfif isdefined("attributes.is_tc_number_required")>
			var is_tc_number = '<cfoutput>#attributes.is_tc_number_required#</cfoutput>';
		<cfelse>
			var is_tc_number = 0;
		</cfif>
		<cfif isdefined("attributes.is_contact_info")>
			var is_contact_info = '<cfoutput>#attributes.is_contact_info#</cfoutput>';
		<cfelse>
			var is_contact_info = 0;
		</cfif>
		<cfif isdefined("attributes.is_cons_address")>
			var is_cons_address = '<cfoutput>#attributes.is_cons_address#</cfoutput>';
		<cfelse>
			var is_cons_address = 0;
		</cfif>
		<cfif isdefined("attributes.is_cons_district")>
			var is_cons_district = '<cfoutput>#attributes.is_cons_district#</cfoutput>';
		<cfelse>
			var is_cons_district = 0;
		</cfif>	
		<cfif isdefined("attributes.is_cons_street")>
			var is_cons_street = '<cfoutput>#attributes.is_cons_street#</cfoutput>';
		<cfelse>
			var is_cons_street = 0;
		</cfif>	
		<cfif isdefined("attributes.is_resource")>
			var is_resource = '<cfoutput>#attributes.is_resource#</cfoutput>';
		<cfelse>
			var is_resource = 0;
		</cfif>	
		// Lütfen yerini değiştirmeyiniz
		
		var home_city_ = document.getElementById('home_city_id').value;
		if(home_city_.length)
			LoadCounty(home_city_,'home_county_id','consumer_hometelcode'<cfif isdefined('attributes.is_residence_select') and attributes.is_residence_select eq 1>,'home_district_id'</cfif>);
		// Lütfen yerini değiştirmeyiniz
			
		function kontrol()
		{
			<cfif isdefined("attributes.is_email_double_control") and attributes.is_email_double_control eq 1>
				if(document.getElementById('consumer_email').value != document.getElementById('consumer_email2').value)
				{
					alert("<cf_get_lang dictionary_id ='35950.E-mail Adresinizi Kontrol Ediniz!'>");
					return false;
				}
			</cfif>
			
			<cfif isDefined('attributes.is_mail_control') and attributes.is_mail_control eq 1>
				var email_string = document.getElementById('consumer_email').value;
				document.getElementById('consumer_email').value = email_string.toLowerCase();
				if(document.getElementById('consumer_email').value != '')
				{
					var listParam = document.getElementById('consumer_email').value;
					var get_check_consumer = wrk_safe_query("obj2_get_check_consumer",'dsn',0,listParam);
					if(get_check_consumer.recordcount)
					{
						alert("<cf_get_lang dictionary_id ='35724.Girdiğiniz mail daha önceden sistemde kayıtlı Lütfen farklı bir mail adresi giriniz'>!");
						return false;
					}
				}
			</cfif>
			
			if(document.getElementById('birthdate') != undefined && document.getElementById('birthdate').value != '')
			{
				var tarih_ = fix_date_value(document.getElementById('birthdate').value);
				if(tarih_.substr(6,4) < 1900)
				{
				   alert("<cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!");
				   return false;
				}
			}
			
			<cfif isdefined("attributes.is_control_birthdate") and attributes.is_control_birthdate eq 1>
				if(document.getElementById('birthdate') != undefined && document.getElementById('birthdate').value != '')
				{
					var todayDate = new Date();
					aa = datediff(document.getElementById('birthdate').value,todayDate.getDate()+'/'+(todayDate.getMonth()+1)+'/'+todayDate.getFullYear(),0);
	
					if(parseFloat(aa/365) < 18)
					{
						alert("<cf_get_lang dictionary_id ='35861.18 Yaşından Küçük Üye Kaydı Yapamazsınız'> !");
						return false;
					}
				}
			</cfif>

			<cfif isdefined("attributes.is_proposer_cons") and attributes.is_proposer_cons eq 1>
				if(document.getElementById('proposer_cons_name') != undefined && document.getElementById('proposer_cons_name').value != '' && document.getElementById('proposer_cons_id').value == '')
				{
					var get_cons_pro = wrk_safe_query("obj2_get_cons_pro",'dsn',0,document.getElementById('proposer_cons_name').value);
					if(get_cons_pro.recordcount == 0)
					{
						alert("<cf_get_lang dictionary_id ='35862.Öneren Üye İçin Girdiğiniz Temsilci Kodu Bulunamadı'> !");
						return false;
					}
					else
						document.getElementById('proposer_cons_id').value = get_cons_pro.CONSUMER_ID;
				}
				if(document.getElementById('proposer_cons_id').value == "" || document.getElementById('proposer_cons_name').value == "")
				{
					alert("<cf_get_lang dictionary_id ='35863.Öneren Temsilci Seçmelisiniz'> !");
					return false;
				}
			</cfif>
			<cfif isdefined("attributes.is_ref_member") and attributes.is_ref_member eq 1 and isdefined("session.ww.userid")>
				if(document.getElementById('ref_pos_code_name').value =='')
				{
					alert("<cf_get_lang dictionary_id ='35864.Referans Üye Seçmelisiniz'> !");
					return false;
				}
				else
				{
					var get_cons_pro = wrk_safe_query("obj2_get_cons_pro_2",'dsn',0,document.getElementById('ref_pos_code').value);
					if((get_cons_pro.recordcount && get_cons_pro.CONSUMER_ID != document.getElementById('ref_pos_code').value) || get_cons_pro.recordcount == 0)
					{
						alert("<cf_get_lang dictionary_id ='35864.Referans Üye Seçmelisiniz'>!");
						return false;
					}
				}
			</cfif>
		
			if(is_contact_info == 1 && (document.getElementById('consumer_hometel').value == "" && document.getElementById('mobiltel').value == ""))
			{
				alert("<cf_get_lang dictionary_id ='35865.Ev Telefonu ve Cep Telefonu Alanlarından Enaz Birini Girmelisiniz'> !");
				return false;
			}
			<cfif isdefined("attributes.is_tel_length_kontrol") and attributes.is_tel_length_kontrol eq 1>
				if(!form_warning('mobiltel','Cep Telefonu 7 Hane Olmalıdır !',7))return false;
				if(!form_warning('mobiltel_2','Cep Telefonu 2 7 Hane Olmalıdır !',7))return false;
				if(!form_warning('consumer_hometel','Ev Telefonu 7 Hane Olmalıdır !',7))return false;
				if(!form_warning('consumer_hometelcode','Ev Telefonu Kodu 3 Hane Olmalıdır !',3))return false;
			</cfif>
			if(is_resource == 2 && document.getElementById('resource').value == "")
			{
				alert("<cf_get_lang dictionary_id ='35866.İlişki Şekli Seçmelisiniz'> !");
				return false;
			}
			x = document.getElementById('home_city_id').selectedIndex;
			if (is_cons_address == 1 && document.getElementById('home_city_id')[x].value == "")
			{
				alert("<cf_get_lang dictionary_id ='34353.İl Seçmelisiniz'> !");
				return false;
			}
			
			x = document.getElementById('home_county_id').selectedIndex;
			if (is_cons_address == 1 && document.getElementById('home_county_id')[x].value == "")
			{
				alert("<cf_get_lang dictionary_id ='35678.İlçe Seçmelisiniz'> !");
				return false;
			}
			
			<cfif isDefined('attributes.is_residence_select') and attributes.is_residence_select eq 0>
				if(is_cons_district == 1 && document.getElementById('home_district').value == "")
				{
					alert("<cf_get_lang dictionary_id ='35679.Mahalle Seçmelisiniz'> !");
					return false;
				}
			<cfelse>
				x = document.getElementById('home_district_id').selectedIndex;
				if(is_cons_district == 1 && document.getElementById('home_district_id')[x].value == "")
				{
					alert("<cf_get_lang dictionary_id ='35679.Mahalle Seçmelisiniz'>!");
					return false;
				}
			</cfif>			
			
			if(!( _CF_checkadd_consumer(add_consumer))) return false;
			
			if(document.getElementById('tc_identity_no') != undefined)
			{
				if(is_tc_number == 1)
				{
					if(trim(document.getElementById('tc_identity_no').value) == '')
					{
						alert("<cf_get_lang dictionary_id ='58687.Lütfen TC Kimlik No Giriniz!'>");
						return false;
					}
				}
				else
				{
					if(trim(document.getElementById('tc_identity_no').value) != '')
					{
						if(!isTCNUMBER(document.getElementById('tc_identity_no'))) return false;
					}	
				}
			} 
			<!---<cfif isdefined("attributes.is_verify_number") and attributes.is_verify_number eq 1>
				if(document.getElementById('is_verify') != undefined )
				{
					if(document.getElementById('is_verify').value == 0)
					{
						alert("<cf_get_lang dictionary_id ='58687.Lütfen TC Kimlik No Giriniz!'>");
						return false;
					}
				}			
			<cfelse>
				if(document.getElementById('tc_identity_no') != undefined && is_tc_number == 1)
				{
					if(!isTCNUMBER(document.getElementById('tc_identity_no'))) return false;
				}			
			</cfif> --->
			
			if(document.getElementById('tc_identity_no') != undefined && document.getElementById('tc_identity_no').value != "")
			{
				var consumer_control = wrk_safe_query("obj2_consumer_control",'dsn',0,document.getElementById('tc_identity_no').value);
				if(consumer_control.recordcount > 0)
				{
					alert("<cf_get_lang dictionary_id ='35404.Aynı TC Kimlik Numarası İle Kayıtlı Üye Var Lütfen Bilgilerinizi Kontrol Ediniz'> !");
					return false;
				}
			}
			
			if(is_cons_street == 1 && ((document.getElementById('home_main_street').value == "" && document.getElementById('home_street').value == "")))
			{
				alert("<cf_get_lang dictionary_id ='35680.Sokak veya Cadde Zorunlu'> !");
				return false;
			}
			if(document.getElementById('sex')!= undefined)
			{
				x = document.getElementById('sex').selectedIndex;
				if (document.getElementById('sex')[x].value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='565.Cinsiyet Seçiniz'>!");
					return false;
				}
			}
			<cfif isdefined('attributes.is_member_add_option') and attributes.is_member_add_option eq 2> 
				if(document.getElementById('member_add_option_id').value == '')
				{
					alert("<cf_get_lang dictionary_id='34507.Lütfen Üye Özel Tanımı Seçiniz!'>");
					return false;
				}
			</cfif>
			if(document.getElementById('password1') != undefined)
			{
				x = (document.getElementById('password1').value.length);
				if ( x < 6 )
				{ 
					alert ("<cf_get_lang dictionary_id='34879.Şifreniz En Az Altı Karakter Olmalıdır'> !");
					return false;
				}
			
				if(document.getElementById('password1').value != document.getElementById('password2').value)
				{ 
					alert ("<cf_get_lang dictionary_id='34880.Şifre ve Şifre Tekrar Alanları Aynı Olmalıdır'> !");
					return false;
				}
			}	
			if(document.getElementById('consumer_cat_id') != undefined)
			{
				x = document.getElementById('consumer_cat_id').selectedIndex;
				if (document.getElementById('consumer_cat_id')[x].value == "")
				{ 
					alert ("<cf_get_lang dictionary_id='58713.Lütfen bir bireysel üye kategorisi seçiniz'> !");
					document.getElementById('consumer_cat_id').focus();
					return false;
				}
			}
			<cfif isdefined("attributes.is_mobil_telno_required") and attributes.is_mobil_telno_required eq 1>
				if((document.getElementById('mobilcat_id').selectedIndex == 0) || (document.getElementById('mobiltel').value == '') || (document.getElementById('mobiltel').value.length < 7))
				{
					alert ("<cf_get_lang dictionary_id='34340.Geçerli GSM No Girmelisiniz'> !");
					return false;
				}
			</cfif>
			if(document.getElementById('homeaddress') != undefined)
			{
				if (document.getElementById('homeaddress').value.length > 200)
				{
					alert("<cf_get_lang dictionary_id='34881.Adres alanı 200 karakteri aşamaz'>  !");
					document.getElementById('homeaddress').focus();
					return false;
				}
			}
			<cfif isdefined("attributes.is_member_rules") and len(attributes.is_member_rules)>
				if(document.getElementById('member_rules').checked!=true)
				{
					alert ("<cf_get_lang dictionary_id='34857.Üyelik Koşullarını Kabul Ediyorum Seçeneğini Seçmelisiniz'>!");
					return false;
				}
			</cfif>
			<cfif isdefined('attributes.consumer_contract_id') and len(attributes.consumer_contract_id)>
				if(document.getElementById('contract_rules').checked!=true)
				{
					alert ("<cf_get_lang dictionary_id='34409.Temsilci Sözleşmesini Kabul Ediyorum Seçeneğini Seçmelisiniz!'>");
					return false;
				}
			</cfif>
			<cfif isdefined('attributes.is_check_mobile_phone') and attributes.is_check_mobile_phone eq 1>
				if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "")
				{
					
					var listParam = document.getElementById('mobilcat_id').value + "*" + document.getElementById('mobiltel').value;
					var get_results = wrk_safe_query('mr_add_cell_phone',"dsn",0,listParam);
					if(get_results.recordcount>0)
					{
						  alert("<cf_get_lang dictionary_id='34399.Girdiğiniz Mobil Telefonuna Kayıtlı Başka Bir Üye Bulunmaktadır'>");
						  document.getElementById('mobiltel').focus();
						  return false;
					}              
				}
			</cfif>
			if(!process_cat_control()) return false;
		}
	</script>
</cfif>
