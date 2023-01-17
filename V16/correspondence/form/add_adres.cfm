<cfinclude template="../query/get_company_sector.cfm">
<cfquery name="get_country" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfsavecontent variable="right_">
	<cfsavecontent variable="add_message"><cf_get_lang dictionary_id='51249.Yaptığınız Değişiklikleri Kaybedeceksiniz Emin misiniz?'></cfsavecontent>
	<!---ST 20131030 kaldirildi <a href="##" onClick="javascript:if (confirm('<cfoutput>#add_message#</cfoutput>')) history.go(-1); else return;"><img src="/images/back.gif" alt="Geri" border="0"></a> --->
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#getLang('','Adres defteri',57429)#" popup_box="1">
	<cfform method="post" name="add_address" id="add_address" action="#request.self#?fuseaction=correspondence.emptypopup_rec_act">
		<cf_box_elements vertical="1">
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
				<cf_duxi name="ab_name" type="text" value=""  hint="Ad" label="57631" > 
				<cf_duxi name="ab_surname" type="text" value=""  hint="Soyad" label="58726" >
				<cf_duxi name="ab_web" type="text" value=""  hint=" webAdresi" label="51251" >
				<cf_duxi name="ab_address" type="textarea" value=""  hint="Adres"  label="58723">
				<cf_duxi name="ab_company" type="text" value=""  hint="Şirket"  label="57574">
				<div class="form-group" id="item-ab_sector_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="ab_sector_id" id="ab_sector_id" >
							<option value=""><cf_get_lang dictionary_id='30560.Sektör Seçiniz'></option> 
							<cfoutput query="get_company_sector">
								<option value="#sector_cat_id#">#sector_cat#</option> 
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
				<cf_duxi name="ab_title" type="text" value=""  hint="Ünvan"  label="57571">
				<div class="form-group" id="item-ab_email">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32508.E-mail'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfsavecontent variable="message_"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='32508.E-mail'></cfsavecontent>
						<cfif isdefined("attributes.sender") and len(attributes.sender)>
							<cfinput type="text" name="ab_email" id="ab_email" maxlength="100"  validate="email" message="message_" value="#attributes.sender#">
						<cfelse>
							<cfinput type="text" name="ab_email" id="ab_email" maxlength="100"  validate="email" message="message_">
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-ab_tel1">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49272.Tel'>1</label>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<cfinput type="text" name="ab_telcode" id="ab_telcode" maxlength="8" size="3" >
					</div>
					<div class="col col-5 col-md-5 col-sm-5 col-xs-12">	
						<cfinput type="text" name="ab_tel1" id="ab_tel1" maxlength="10" size="10" >
					</div>
				</div>
				<div class="form-group" id="item-ab_tel2">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49272.Tel'>2</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="ab_tel2" id="ab_tel2" maxlength="10" size="10" alt="<cf_get_lang dictionary_id='49272.Tel'>" >
					</div>
				</div>
				<div class="form-group" id="item-ab_web">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<cfinput type="text" name="ab_mobilcode" id="ab_mobilcode" maxlength="8" size="3" >
					</div>
					<div class="col col-5 col-md-5 col-sm-5 col-xs-12">	
						<cfinput type="text" name="ab_mobil" id="ab_mobil" maxlength="10" size="10" >
					</div>
				</div>
				<div class="form-group" id="item-ab_fax">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="ab_fax" id="ab_fax" maxlength="10" size="10" >
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-country_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="country_id" id="country_id" onChange="remove_adress('1');" >
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif get_country.is_default eq 1>selected</cfif>>#get_country.country_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-city">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="city_id" id="city_id" value="">          
							<input type="text" name="city" id="city" value="" readonly >
							<span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="pencere_ac_city();"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-county_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="county_id" id="county_id" readonly="">
							<input type="text" name="county" id="county" value="" maxlength="30"  readonly tabindex="12">
							<span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="pencere_ac();"></span>
						</div>
					</div>
				</div>
				<cf_duxi name="ab_semt" type="text" value=""  hint="Semt"  label="58132">
				<cf_duxi name="ab_postcode" type="text" value=""  hint="Posta Kodu"  label="57472">
				<cf_duxi name="ab_info" type="textarea" value=""  hint="Not"  label="57467">
				<cf_duxi name="special_emp" type="checkbox"   value="1" label="51256">
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
	</cfform>
</cf_box>
</div>
<script type="text/javascript">
function pencere_ac(no)
{
	x = document.getElementById("country_id").selectedIndex;
	if (document.getElementById("country_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.Uyarı'>:<cf_get_lang dictionary_id='57485.Öncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>");
	}	
	else if(document.getElementById("city_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.Uyarı'>:<cf_get_lang dictionary_id='57485.Öncelik'>-<cf_get_lang dictionary_id='58608.İl'> !");
	}
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_address.county_id&field_name=add_address.county&city_id=' + document.getElementById("city_id").value);
		return remove_adress();
	}
}
function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.getElementById("city_id").value = '';
		document.getElementById("city").value = '';
		document.getElementById("county_id").value = '';
		document.getElementById("county").value = '';
	}
	else if(parametre==2)
	{
		document.getElementById("county_id").value = '';
		document.getElementById("county").value = '';
	}	
}
function pencere_ac_city()
{
	if (document.getElementById("country_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.Uyarı'>:<cf_get_lang dictionary_id='57485.Öncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>");
	}	
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_address.city_id&field_name=add_address.city&country_id=' + document.getElementById("country_id").value);
		return remove_adress('2');
	}
}
function kontrol()
{
	x = (250 - document.getElementById("ab_address").value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='51260.Adres çok uzun'>: "+ ((-1) * x));
		return false;
	}
	x = (250 - document.getElementById("ab_info").value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='51261.Not çok uzun'>: "+ ((-1) * x));
		return false;
	}
	if(ab_name.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='57631.Ad'>"});
            return false;
        }
		

		if(ab_surname.value == '')
        {
            alertObject({message: "<cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58726.Soyad'>"});
            return false;
        }
		if (document.add_address.ab_web.value.length > 100) 
	  {
			
			alert("<cf_get_lang dictionary_id='51521.web adresi'>:<cf_get_lang dictionary_id='35601.100 karakterden fazla giremezsiniz'>"); 
				return false;
	   }
	   if (document.add_address.ab_company.value.length > 100) 
	  {
			
			alert("<cf_get_lang dictionary_id='57574.şirket'>:<cf_get_lang dictionary_id='35601.100 karakterden fazla giremezsiniz'>"); 
				return false;
	   }
	   if (document.add_address.ab_title.value.length > 100) 
	  {
			
			alert("<cf_get_lang dictionary_id='57571.Ünvan'>:<cf_get_lang dictionary_id='35601.100 karakterden fazla giremezsiniz'>"); 
				return false;
	   }
	   if (document.add_address.ab_semt.value.length > 45) 
	  {
			
			alert("<cf_get_lang dictionary_id='58132.semt'>:<cf_get_lang dictionary_id='58210.Alanındaki Fazla Karakter Sayısı'><cf_get_lang dictionary_id='51893.Hatası'>"); 
				return false;
	   }
	   if (document.add_address.ab_postcode.value.length > 15) 
	  {
			
			alert("<cf_get_lang dictionary_id='57472.Posta Kodu'>: 15 <cf_get_lang dictionary_id='58997.Karakterden Fazla Yazmayınız'>"); 
				return false;
	   }
	
	return true;
}
</script>
