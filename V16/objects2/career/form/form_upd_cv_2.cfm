<!--- Özgeçmişim / Kişisel Bilgilerim (Stage : 2) --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_app = get_components.get_app()>
<cfset get_app_identy = get_components.get_app_identy()>
<cfparam name="attributes.stage" default="2">
<!--- <cfif not isdefined("session.cp.userid")>
  <cflocation url="#request.self#?fuseaction=objects2.popup_form_login" addtoken="no">
</cfif> --->
<cfform name="employe_detail" method="post">
	<input type="hidden" name="stage" id="stage" value="<cfoutput>#attributes.stage#</cfoutput>">
	<div class="row">
		<div class="col-md-12">
			<cfinclude template="../display/add_sol_menu.cfm">
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<p class="font-weight-bold"><cf_get_lang dictionary_id='35124.Özgeçmişim'> \ <cf_get_lang dictionary_id='34518.Kişisel Bilgiler'></p>
		</div>
	</div>	
	<div class="row">
		<div class="col-md-6">			
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="sex" id="sex" value="1" tabindex="1" onClick="change_mil_stat(this.value);"<cfif get_app.sex eq 1 or not len(get_app.sex)>checked</cfif>> <cf_get_lang dictionary_id='58959.Erkek'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="sex" id="sex" value="0" tabindex="2" onClick="change_mil_stat(this.value);" <cfif get_app.sex eq 0>checked</cfif>> <cf_get_lang dictionary_id='58958.Kadın'>					
					</div>
				</div>
			</div>
			<div id="mar1" <cfif get_app_identy.married eq 1> style="display:;"<cfelse> style="display:none;"</cfif>>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34624.Eşinin Adı'></label>
					<div class="col-12 col-md-8 col-lg-6 col-xl-5">
						<input type="text" class="form-control" name="partner_name" id="partner_name" maxlength="150" tabindex="5" value="<cfoutput>#get_app.partner_name#</cfoutput>">
					</div>
				</div>

				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34625.Eşinizin Çalıştığı Şirket'></label>
					<div class="col-12 col-md-8 col-lg-6 col-xl-5">
						<input type="text" class="form-control" name="partner_company" id="partner_company" maxlength="50" tabindex="6" value="<cfoutput>#get_app.partner_company#</cfoutput>">
					</div>
				</div>
			</div>
			<div id="mar2" <cfif get_app_identy.married eq 1> style="display:;"<cfelse> style="display:none;"</cfif>>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34626.Eşinizin Görevi'></label>			
					<div class="col-12 col-md-8 col-lg-6 col-xl-5">
						<input type="text" class="form-control" name="partner_position" id="partner_position" maxlength="50"  tabindex="7" value="<cfoutput>#get_app.partner_position#</cfoutput>">
					</div>	
				</div>
			
			
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34527.Çocuk Sayınız'></label>
					<div class="col-12 col-md-8 col-lg-6 col-xl-5">
						<input type="text" class="form-control" name="child" id="child" maxlength="2" tabindex="8" onKeyup="isNumber(this)" onBlur="isNumber(this)" value="<cfoutput>#get_app.child#</cfoutput>">
					</div>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31667.Sigara Kullanıyor mu'>?</label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="use_cigarette" id="use_cigarette" value="1" tabindex="9" <cfif get_app.use_cigarette eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="use_cigarette" id="use_cigarette" value="0" tabindex="10" <cfif get_app.use_cigarette eq 0 or not len(get_app.use_cigarette)>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35140.Fiziksel Engeliniz Var mı'></label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="defected" id="defected" value="1" tabindex="13" onClick="seviye(1);" <cfif get_app.defected eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="defected" id="defected" value="0" tabindex="14" onClick="seviye(0);" <cfif get_app.defected eq 0 or not len(get_app.defected)>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'>				
					</div>				
					<div class="col-6 col-md-6 col-lg-5 col-xl-3 mt-2">
						<select class="form-control" name="defected_level" id="defected_level" <cfif get_app.defected eq 0 or not len(get_app.defected)>disabled<cfelse>tabindex="15"</cfif>>
							<option value="0" <cfif get_app.defected_level eq 0>selected</cfif>>%0</option>
							<option value="10" <cfif get_app.defected_level eq 10>selected</cfif>>%10</option>
							<option value="20" <cfif get_app.defected_level eq 20>selected</cfif>>%20</option>
							<option value="30" <cfif get_app.defected_level eq 30>selected</cfif>>%30</option>
							<option value="40" <cfif get_app.defected_level eq 40>selected</cfif>>%40</option>
							<option value="50" <cfif get_app.defected_level eq 50>selected</cfif>>%50</option>
							<option value="60" <cfif get_app.defected_level eq 60>selected</cfif>>%60</option>
							<option value="70" <cfif get_app.defected_level eq 70>selected</cfif>>%70</option>
							<option value="80" <cfif get_app.defected_level eq 80>selected</cfif>>%80</option>
							<option value="90" <cfif get_app.defected_level eq 90>selected</cfif>>%90</option>
							<option value="100" <cfif get_app.defected_level eq 100>selected</cfif>>%100</option>
						</select>
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35139.Hiç Yargılandı mı ve/veya Hüküm Giydi  mi'>?</label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="sentenced" id="sentenced" value="1" tabindex="16" <cfif get_app.sentenced eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="sentenced" id="sentenced" value="0" tabindex="17" <cfif get_app.sentenced eq 0 or not len(get_app.sentenced)>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'> 
					</div>
				</div>
			</div>
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34632.Göçmen'></label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="immigrant" id="immigrant" value="1" <cfif get_app.immigrant eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="immigrant" id="immigrant" value="0" <cfif get_app.immigrant eq 0>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'>
					</div>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34634.Kaç yıldır aktif olarak araba kullanıyorsunuz'> ?</label>
				<div class="col-5 col-md-3 col-lg-3 col-xl-2">
					<input type="text" class="form-control" name="driver_licence_actived" id="driver_licence_actived" onKeyUp="isNumber(this);" tabindex="22" value="<cfoutput>#get_app.driver_licence_actived#</cfoutput>" maxlength="2">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='55343.Bir suç zannıyla tutuklandınız mı veya mahkumiyetiniz oldu mu ?'></label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="defected_probability" id="defected_probability" value="1"  <cfif get_app.defected_probability eq 1>checked</cfif>>
						<cf_get_lang dictionary_id='57495.Evet'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="defected_probability" id="defected_probability" value="0" <cfif get_app.defected_probability eq 0>checked</cfif>>
						<cf_get_lang dictionary_id='57496.Hayır'>
					</div>					
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31678.Koğuşturma'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<input type="text" class="form-control" name="investigation" id="investigation" value="<cfoutput>#get_app.investigation#</cfoutput>" maxlength="150">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35143.Devam eden bir rahatsızlığı var mı'>?</label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="illness_probability" id="illness_probability" value="1" tabindex="23" <cfif get_app.illness_probability eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="illness_probability" id="illness_probability" value="0" tabindex="24" <cfif get_app.illness_probability eq 0 or not len(get_app.illness_probability)>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'>					
					</div>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34637.Varsa nedir?'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<textarea class="form-control" name="illness_detail" id="illness_detail" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" tabindex="25" maxlength="50"><cfoutput>#get_app.illness_detail#</cfoutput></textarea>									
				</div>
			</div>

			<div id="mil_stat1" <cfif get_app.sex eq 1 or not len(get_app.sex)>style="display:;"<cfelse>style="display:none;"</cfif>>
				<div class="form-group row">
					<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35141.Askerlik Durumu'></label>
					<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
						<div class="col-xl-4">
							<input type="radio" name="military_status" id="military_status" value="0" tabindex="27" <cfif get_app.military_status eq 0>checked</cfif> onClick="tecilli_fonk(this.value)"> <cf_get_lang dictionary_id='34640.Yapmadı'>
						</div>
						<div class="col-xl-4">
							<input type="radio" name="military_status" id="military_status" value="1" tabindex="28" <cfif get_app.military_status eq 1>checked</cfif> onClick="tecilli_fonk(this.value)"> <cf_get_lang dictionary_id='34641.Yaptı'>
						</div>
						<div class="col-xl-4">
							<input type="radio" name="military_status" id="military_status" value="2" tabindex="29" <cfif get_app.military_status eq 2>checked</cfif> onClick="tecilli_fonk(this.value)"> <cf_get_lang dictionary_id='34642.Muaf'>
						</div>
						<div class="col-xl-4">
							<input type="radio" name="military_status" id="military_status" value="3" tabindex="30" <cfif get_app.military_status eq 3>checked</cfif> onClick="tecilli_fonk(this.value)"> <cf_get_lang dictionary_id='34643.Yabancı'>
						</div>
						<div class="col-xl-4">
							<input type="radio" name="military_status" id="military_status" value="4" tabindex="31" <cfif get_app.military_status eq 4>checked</cfif> onClick="tecilli_fonk(this.value)"> <cf_get_lang dictionary_id='34644.Tecilli'>
						</div>						
					</div>
				</div>			
			</div>


			<div id="mil_stat2" <cfif get_app.sex eq 1 or not len(get_app.sex)>style="display:;"<cfelse>style="display:none;"</cfif>>
				<div <cfif get_app.military_status neq 4>style="display:none"</cfif> id="Tecilli">					
					<div class="form-group row">
						<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34645.Tecil Gerekçeniz'></label>
						<div class="col-12 col-md-8 col-lg-6 col-xl-5">
							<input type="text" class="form-control" name="military_delay_reason" id="military_delay_reason" maxlength="30" value="<cfoutput>#get_app.military_delay_reason#</cfoutput>">									
						</div>
					</div>

					<div class="form-group row">
						<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34646.Tecil Süreniz'></label>
						<div class="col-12 col-md-8 col-lg-6 col-xl-5">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='34649.Tecil Süresi Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" class="form-control" name="military_delay_date" id="military_delay_date" value="#dateformat(get_app.military_delay_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
								<cf_wrk_date_image date_field="military_delay_date">									
						</div>
					</div>				
				</div>

				<div <cfif get_app.military_status neq 2>style="display:none"</cfif> id="Muaf">
					<div class="form-group row">
						<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34648.Muaf Olma Nedeniniz'> *</label>
						<div class="col-12 col-md-8 col-lg-6 col-xl-5">
							<input type="text" class="form-control" name="military_exempt_detail" id="military_exempt_detail" maxlength="100" value="<cfoutput>#get_app.military_exempt_detail#</cfoutput>">									
						</div>
					</div>				
				</div>

				<div <cfif get_app.military_status neq 1>style="display:none"</cfif> id="Yapti">
					<div class="form-group row">
						<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31217.Terhis Tarihi'> *</label>
						<div class="col-12 col-md-8 col-lg-6 col-xl-5">
							<cfinput type="text" class="form-control" name="military_finishdate" id="military_finishdate" value="#dateformat(get_app.military_finishdate,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
							<cf_wrk_date_image date_field="military_finishdate">
						</div>
					</div>
					
					<div class="form-group row">
						<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31219.Süresi (Ay Olarak Giriniz)'> *</label>
						<div class="col-12 col-md-8 col-lg-6 col-xl-5">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='31220.Askerlik Süresi Girmelisiniz'></cfsavecontent>
							<cfinput type="text" class="form-control" name="military_month" id="military_month" value="#get_app.military_month#" validate="integer" maxlength="2" message="#message#">							
						</div>
					</div>

					<div class="form-group row">
						<div class="col-xl-4">
							<input type="radio" name="military_rank" id="military_rank" value="0" <cfif get_app.military_rank eq 0 or not len(get_app.military_rank)>checked</cfif>> <cf_get_lang dictionary_id ='35480.Er'>
							<input type="radio" name="military_rank" id="military_rank" value="1" <cfif get_app.military_rank eq 1>checked</cfif>> <cf_get_lang dictionary_id='35145.Yedek Subay'>
						</div>
					</div>				
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31203.Medeni Durum'></label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="married" id="married" value="0" tabindex="3" onClick="change_married(this.value);"<cfif get_app_identy.married eq 0 or not len(get_app_identy.married)>checked</cfif>> <cf_get_lang dictionary_id='35137.Bekar'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="married" id="married" value="1" tabindex="4" onClick="change_married(this.value);"<cfif get_app_identy.married eq 1>checked</cfif>> <cf_get_lang dictionary_id='34530.Evli'>
					</div>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34628.Şehit Yakını Misiniz'></label>
				<div class="col-md-8 col-xl-8 mt-1 pt-1 pl-0">
					<div class="col-xl-4">
						<input type="radio" name="martyr_relative" id="martyr_relative" value="1" tabindex="11" <cfif get_app.martyr_relative eq 1>checked</cfif>> <cf_get_lang dictionary_id='57495.Evet'>
					</div>
					<div class="col-xl-4">
						<input type="radio" name="martyr_relative" id="martyr_relative" value="0" tabindex="12" <cfif get_app.martyr_relative eq 0 or not len(get_app.martyr_relative)>checked</cfif>> <cf_get_lang dictionary_id='57496.Hayır'>
					</div>
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='31661.Ehliyet Sınıf / Yıl'></label>
				<div class="col-5 col-md-3 col-lg-3 col-xl-2 pr-0">
					<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
						SELECT LICENCECAT_ID, LICENCECAT FROM SETUP_DRIVERLICENCE ORDER BY LICENCECAT
					</cfquery>
					<select class="form-control" name="driver_licence_type" id="driver_licence_type" tabindex="18">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						  <cfoutput query="get_driver_lis">
							<option value="#licencecat_id#" <cfif licencecat_id eq get_app.licencecat_id> selected</cfif>>#licencecat#</option>
						  </cfoutput>
					</select>					
				</div>
				<div class="col-7 col-md-5 col-lg-3 col-xl-3">
					<cfsavecontent variable="message_driver"><cf_get_lang dictionary_id='41814.Tarih değerlerini doğru giriniz'></cfsavecontent>
					<cfinput type="text" class="form-control" name="licence_start_date" id="licence_start_date" value="#DateFormat(get_app.licence_start_date,'dd/mm/yyyy')#" maxlength="10" validate="eurodate" message="#message_driver#" tabindex="19">
					<cf_wrk_date_image date_field="licence_start_date">
				</div>
			</div>

			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='34633.Ehliyet No'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<input type="text" class="form-control" name="driver_licence" id="driver_licence" tabindex="21" value="<cfoutput>#get_app.driver_licence#</cfoutput>" maxlength="40">
				</div>
			</div>	
			<div class="form-group row">
				<label class="col-md-4 col-form-label"><cf_get_lang dictionary_id='35147.Geçirdiğiniz Ameliyat varsa belirtiniz'></label>
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<textarea class="form-control" name="surgical_operation" id="surgical_operation" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" tabindex="26" maxlength="150"><cfoutput>#get_app.surgical_operation#</cfoutput></textarea>
				</div>
			</div>			
		</div>
	</div>
	<div class="row">
		<div class="col-12 d-flex justify-content-start">
			<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='35495.Kaydet ve İlerle'></cfsavecontent>
			<!--- <cf_workcube_buttons is_upd='0' insert_info="#alert#" add_function='kontrol()' is_cancel='0'>	 --->
			<cf_workcube_buttons is_insert='1' insert_info="#alert#" data_action="/V16/objects2/career/cfc/data_career:add_cv_2" next_page="#request.self#" add_function='kontrol()'>
		</div>
	</div>
</cfform>



<script type="text/javascript">
	function change_mil_stat(chd)
	{
		if (chd == 1)
		{
			goster(mil_stat1);
			goster(mil_stat2);
		}
		else
		{
			gizle(mil_stat1);
			gizle(mil_stat2);		
		}
	}

	function change_married(chm)
	{
		if (chm == 1)
		{
			goster(mar1);
			goster(mar2);
			goster(mar3);
		}
		else
		{
			gizle(mar1);
			gizle(mar2);	
			gizle(mar3);	
		}
	}
	
	function kontrol()
	{
		/*if(document.employe_detail.married[1].checked && document.employe_detail.partner_name.value.length==0)
			{
				alert("<cf_get_lang no='827.Eşinizin Adını Girmelisiniz'>!");
				document.employe_detail.partner_name.focus();
				return false;
			}
		if(document.employe_detail.illness_probability[0].checked && document.employe_detail.illness_detail.value.length==0)
			{
				alert("<cf_get_lang no='828.Devam eden bir hastalık veya bedeni sorununuzu yazmalısınız'>!");
				document.employe_detail.illness_detail.focus();
				return false;
			}
		else if(document.employe_detail.illness_probability[0].checked==false)
			{
				document.employe_detail.illness_detail.value='';
			}
		//askerilk seçeneine göre kontroller
		if(document.employe_detail.military_status[1].checked)
			{
			
				if(document.employe_detail.military_finishdate.value.length==0)
				{
					alert("<cf_get_lang no='829.Askerik Terhis Tarihini Girmelisiniz'>!");
					document.employe_detail.military_finishdate.focus();
					return false;
				}
				if(document.employe_detail.military_month.value.length==0)
				{
					alert("<cf_get_lang no='830.Askerik Süresini Ay Olarak Girmelisiniz'>!");
					document.employe_detail.military_month.focus();
					return false;
				}
			}
		else if(document.employe_detail.military_status[2].checked)
			{
				if(document.employe_detail.military_exempt_detail.value.length==0)
				{
					alert("<cf_get_lang no='833.Muaf Olma Nedeninizi Girmelisiniz!'>");
					document.employe_detail.military_exempt_detail.focus();
					return false;
				}
			}
		else if(document.employe_detail.military_status[4].checked)
			{
				if(document.employe_detail.military_delay_reason.value.length==0)
				{
					alert("<cf_get_lang no='831.Tecil Nedenini Girmelisiniz'>!");
					document.employe_detail.military_delay_reason.focus();
					return false;
				}
				if(document.employe_detail.military_delay_date.value.length==0)
				{
					alert("<cf_get_lang no='832.Tecil Bitiş Tarihini Girmelisiniz'>!");
					document.employe_detail.military_delay_date.focus();
					return false;
				}
			}
		return true;*/
	}
	<!---özürlü seviyesi select pasif aktif yapma--->
	function seviye(i)
	{	
		if(i==1)
		{
			document.employe_detail.defected_level.disabled=false;
		}else{
			document.employe_detail.defected_level.disabled=true;
		}
		<!---if(document.employe_detail.defected_level.disabled==true)
		{document.employe_detail.defected_level.disabled=false;}
		else
		{document.employe_detail.defected_level.disabled=true;}--->
	}
	function tecilli_fonk(gelen)
	{
		if (gelen == 4)
		{
			Tecilli.style.display='';
			Yapti.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 1)
		{
			Yapti.style.display='';
			Tecilli.style.display='none';
			Muaf.style.display='none';
		}
		else if(gelen == 2)
		{
			Muaf.style.display='';
			Tecilli.style.display='none';
			Yapti.style.display='none';
		}
		else
		{
			Tecilli.style.display='none';
			Yapti.style.display='none';
			Muaf.style.display='none';
		}
	}
</script>

