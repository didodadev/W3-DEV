<cf_get_lang_set module_name="member">
<cfinclude template="../query/get_partner.cfm">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY_ID, 
		FULLNAME,
		MOBIL_CODE,
		MOBILTEL,
        TAXNO
	FROM 
		COMPANY
	WHERE 
		COMPANY_ID = #url.cpid#
</cfquery>
<cfscript>
	einvoice_control= createObject("component","V16.e_government.cfc.einvoice");
	einvoice_control.dsn = dsn;
	get_einvoice = einvoice_control.get_einvoice_fnc();
</cfscript>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="30191.Adres/Şube Ekle"></cfsavecontent>
<cfset pageHead = #message# & #get_company.fullname#>
<cf_catalystHeader>
<cfform name="add_company_branch" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_branch">
<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_company.company_id#</cfoutput>">
<div class="row">
    <div class="col col-12 uniqueRow">
        <div class="row formContent">
            <div class="row" type="row">
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                	<div class="form-group" id="item-compbranch_status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="compbranch_status" id="compbranch_status" value="1">
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch__name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29532.Şube Adı'> *</label>
                        <div class="col col-8 col-xs-12">
                			<cfinput type="text" name="compbranch__name" maxlength="50" required="yes" style="width:160px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59005.Şube Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="compbranch_code" id="compbranch_code" maxlength="30" style="width:160px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_alias">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30221.Şube Alias Tanımı'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                    			<input type="text" name="compbranch_alias" id="compbranch_alias" value="" style="width:160px;" readonly="readonly">
                            	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branch_alias&field_alias=add_company_branch.compbranch_alias&company_id=#get_company.company_id#</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_telcode">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30174.Kod/ Telefon'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
	                    		<cfinput type="text" name="compbranch_telcode" required="yes" maxlength="5" style="width:60px;">
                            	<span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="compbranch_tel1" maxlength="10" required="yes" style="width:97px;">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_tel2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="compbranch_tel2" id="compbranch_tel2" maxlength="10">
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_tel3">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="compbranch_tel3" id="compbranch_tel3" value="" maxlength="10" style="width:97px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_fax">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="compbranch_fax" id="compbranch_fax" maxlength="10" style="width:97px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-mobilcat_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                    			<cfinput type="text" name="mobilcat_id" id="mobilcat_id" value="#get_company.mobil_code#" maxlength="7" validate="integer" tabindex="2" onKeyUp="isNumber(this)" style="width:60px;">
                            	<span class="input-group-addon no-bg"></span>
                                <cfinput type="text" name="mobiltel" id="mobiltel" value="#get_company.mobiltel#" maxlength="10" validate="integer" onKeyUp="isNumber(this)" tabindex="2" style="width:97px;">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_email">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="compbranch_email" id="compbranch_email" maxlength="100" style="width:160px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-homepage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30179.İnternet'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="homepage" id="homepage" value="http://" maxlength="50" style="width:160px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch__nickname">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="compbranch__nickname" id="compbranch__nickname" style="width:160px;height:70px;"></textarea>
                        </div>
                    </div>
				</div>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                	<div class="form-group" id="item-is_ship_address">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30516.Sevk Adresi'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_ship_address" id="is_ship_address" value="1">
                        </div>
                    </div>
                    <div class="form-group" id="item-is_invoice_address">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30261.Fatura Adresi'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_invoice_address" id="is_invoice_address" value="1">
                        </div>
                    </div>
                    <div class="form-group" id="item-manager">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30367.Yonetici '></label>
                        <div class="col col-8 col-xs-12">
                            <select name="manager" id="manager" style="width:160px;">
		                    	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		                    <cfoutput query="get_partner"> 
		                    	<option value="#partner_id#">#company_partner_name# #company_partner_surname#</option>
		                    </cfoutput> 
		                  	</select>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57908.Temsilci'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<input type="hidden" name="pos_code" id="pos_code" value="">
                    			<input name="pos_code_text" type="text" id="pos_code_text"  style="width:160px;" onfocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','pos_code','','3','135');" value="" maxlength="255" autocomplete="off">
                            	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_company_branch.pos_code&field_name=add_company_branch.pos_code_text&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.add_company_branch.pos_code_text.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-country">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="country"  id="country" style="width:160px;" onblur="LoadCity(this.value,'city_id','county_id')">
		                    	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
		                        <option value="#get_country.country_id#" <cfif country_id eq 1>selected</cfif>>#get_country.country_name#</option>
		                    </cfoutput>
		                    </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-city_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'><cfif get_einvoice.recordcount>*</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <cfif isdefined('attributes.city_id') and len(attributes.city_id)>
		                        <cfquery name="GET_CITY" datasource="#DSN#">
		                            SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
		                        </cfquery>
		                        <select name="city_id" id="city_id" style="width:160px;" onchange="LoadCounty(this.value,'county_id','compbranch_telcode')">
		                        	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="GET_CITY">
		                            <option value="#city_id#" <cfif city_id eq attributes.city_id>selected</cfif>>#city_name#</option>
		                        </cfoutput>
		                        </select>
		                    <cfelse>
		                        <select name="city_id" id="city_id" style="width:160px;" onchange="LoadCounty(this.value,'county_id','compbranch_telcode')">
		                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		                        </select>
		                    </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-county_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.ilçe'><cfif get_einvoice.recordcount>*</cfif></label>
                        <div class="col col-8 col-xs-12">
                            <select name="county_id" id="county_id" style="width:160px;">
		                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>						
								<cfif isdefined('attributes.county_id') and len(attributes.county_id)>
		                            <cfquery name="GET_COUNTY" datasource="#DSN#">
		                                SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY
		                            </cfquery>
		                        <cfoutput query="get_county">
		                            <option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
		                        </cfoutput>
		                    </cfif>
		                    </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-semt">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="semt" id="semt" value="" maxlength="50" style="width:160px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_postcode">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="compbranch_postcode" id="compbranch_postcode" maxlength="5" style="width:160px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-sales_zone_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfquery name="GET_SALES_ZONES" datasource="#dsn#">
		                        SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE = 1 ORDER BY SZ_NAME
		                    </cfquery>
		                    <select name="sales_zone_id" id="sales_zone_id" style="width:160px;">
		                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		                        <cfoutput query="get_sales_zones">
		                            <option value="#sz_id#">#sz_name#</option>
		                        </cfoutput>
		                    </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-coordinate_1">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58549.Koordinatlar'></label>
                        <div class="col col-8 col-xs-12">
	                        <div class="input-group">
	                        	<span class="input-group-addon">
	                            	<cf_get_lang dictionary_id='58553.E'> 
								</span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="59875.Lütfen enlem değerini -90 ile 90 arasında giriniz"></cfsavecontent>
	                            <cfinput type="text" maxlength="10" range="-90,90" message="#message#" value="" name="coordinate_1" style="width:68px;">
	                            <span class="input-group-addon">
			                    	<cf_get_lang dictionary_id='58591.B'>
								</span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="59894.Lütfen boylam değerini -180 ile 180 arasında giriniz"></cfsavecontent>
			                    <cfinput type="text" maxlength="10" range="-180,180" message="#message#" value="" name="coordinate_2" style="width:68px;">
	                    	</div>
                        </div>
                    </div>
                    <div class="form-group" id="item-compbranch_address">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="compbranch_address" id="compbranch_address" style="width:160px;height:70px;"></textarea>
                        </div>
                    </div>
				</div>
			</div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </div>
		</div>
	</div>
</div>

       
        
     

</cfform>

<script type="text/javascript">
<cfif not isdefined("attributes.city_id")>
	var country_ = document.getElementById('country').value;
	if(country_.length)
		LoadCity(country_,'city_id','county_id');	
</cfif>

function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.add_company_branch.city_id.value = '';
		document.add_company_branch.city.value = '';
		document.add_company_branch.county_id.value = '';
		document.add_company_branch.county.value = '';
		document.add_company_branch.compbranch_telcode.value = '';
	}
	else
	{
		document.add_company_branch.county_id.value = '';
		document.add_company_branch.county.value = '';
	}	
}
function pencere_ac_city()
{
	x = document.add_company_branch.country.selectedIndex;
	if (document.add_company_branch.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.öncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_company_branch.city_id&field_name=add_company_branch.city&field_phone_code=add_company_branch.compbranch_telcode&country_id=' + document.add_company_branch.country.value,'small','popup_dsp_city');
	}
	return remove_adress('2');
}
function pencere_ac(no)
{
	x = document.add_company_branch.country.selectedIndex;
	if (document.add_company_branch.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57485.öncelik'>-<cf_get_lang dictionary_id='58219.Ülke'>");
	}	
	else if(document.add_company_branch.city_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='58608.il'>!");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_company_branch.county_id&field_name=add_company_branch.county&city_id=' + document.add_company_branch.city_id.value,'small','popup_dsp_county');
		return remove_adress();
	}
}
function kontrol()
{
	if(!$("#compbranch_tel1").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57499.Telefon '></cfoutput>"})    
			return false;
		}
	if(!$("#compbranch_telcode").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='51606.Geçerli Bir Telefon Kodu Giriniz !'></cfoutput>"})    
			return false;
		}
		
	if(!$("#compbranch__name").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube adı !'></cfoutput>"})    
			return false;
		}
		
	<cfif get_einvoice.recordcount eq 1>
		if(document.getElementById('city_id').value.length < 1)
		{
			alert("<cf_get_lang dictionary_id='32876.Lütfen Şehir Seçiniz'>!");
			return false;
		}
		
		if(document.getElementById('county_id').value.length < 1)
		{
			alert("<cf_get_lang dictionary_id='30538.Lütfen İlçe Seçiniz'>!");
			return false;
		}
	</cfif>	
	
	x = (250 - document.add_company_branch.compbranch_address.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
		return false;
	}
	
	y = (50 - document.add_company_branch.compbranch__nickname.value.length);
	if ( y < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id ='57629.Açıklama'>"+ ((-1) * y) +" <cf_get_lang dictionary_id='29538.Karakter Uzun '>!");
		return false;
	}
	if((document.add_company_branch.coordinate_1.value.length != "" && document.add_company_branch.coordinate_2.value.length == "") || (document.add_company_branch.coordinate_1.value.length == "" && document.add_company_branch.coordinate_2.value.length != ""))
	{
		alert ("<cf_get_lang dictionary_id='30292.Lütfen koordinat değerlerini eksiksiz giriniz!'>");
		return false;
	}
	return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
