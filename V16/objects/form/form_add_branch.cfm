<cfif not isDefined("url.brid")>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
        	CP.COMPANY_PARTNER_NAME, 
            CP.COMPANY_PARTNER_SURNAME, 
            CP.PARTNER_ID,
            C.MOBIL_CODE
        FROM 
        	COMPANY_PARTNER CP, 
            COMPANY C 
        WHERE 
		<cfif isDefined("url.cpid")>
			CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#"> AND 
			CP.COMPANY_ID = C.COMPANY_ID
		<cfelse>
			CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.pid#"> AND
			CP.COMPANY_ID = C.COMPANY_ID
		</cfif>
		ORDER BY 
			CP.COMPANY_PARTNER_NAME
	</cfquery>
<cfelse>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
        	COMPANY_PARTNER_NAME, 
        	COMPANY_PARTNER_SURNAME, 
            PARTNER_ID 
       	FROM 
        	COMPANY_PARTNER 
       	WHERE 
        	COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.brid#">
	</cfquery>
</cfif>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID, COUNTRY_NAME, IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT COMPANY_ID,FULLNAME,TAXNO FROM COMPANY C, COMPANY_CAT CC WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#"> AND C.COMPANYCAT_ID = CC.COMPANYCAT_ID
</cfquery>
<cfscript>
	einvoice_control= createObject("component","V16.e_government.cfc.einvoice");
	einvoice_control.dsn = dsn;
	get_einvoice = einvoice_control.get_einvoice_fnc();
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58247.Ticari Alacaklar'></cfsavecontent>
    <cf_box title="#message#: #get_company.fullname#">
        <cfform name="add_company_branch" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_branch">
            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_company.company_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12" type="column" sort="true" index="1">
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-compbranch_status">			
                        <label class="col col-12 col-xs-12" style="text-align:left;">
                            <cf_get_lang dictionary_id='57493.Aktif'>
                            <input type="checkbox" name="compbranch_status" id="compbranch_status" value="1">
                        </label>
                    </div>
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-shipment_address_status">			
                        <label class="col col-12 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='34252.Sevk Adresi'>
                            <input type="checkbox" name="shipment_address_status" id="shipment_address_status" value="1">
                        </label>
                    </div>           
                    <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-invoice_address_status">			
                        <label class="col col-12 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='34253.Fatura Adresi'>
                            <input type="checkbox" name="invoice_address_status" id="invoice_address_status" value="1">
                        </label>
                    </div> 
                </div>
                <div class="col col-6 col-md-8 col-sm-12" type="column" sort="true" index="2">
                        <div class="form-group" id="item-compbranch__name">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='29532.Şube Adı'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube adı'>!</cfsavecontent>
                                <cfinput type="text" name="compbranch__name" maxlength="50" required="yes" message="#message#" style="width:160px;">
                            </div>
                        </div>
                        <div class="form-group" id="item-compbranch_code">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='59005.Şube Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="compbranch_code" id="compbranch_code" maxlength="10" style="width:160px;">
                            </div>
                        </div>      
                        <div class="form-group" id="item-compbranch_alias">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='30221.Şube Alias Tanımı'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="compbranch_alias" id="compbranch_alias" value="" style="width:160px;" readonly="readonly">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branch_alias&company_id=#get_company.company_id#&field_alias=add_company_branch.compbranch_alias<cfif len(get_company.taxno)>&taxno=#get_company.taxno#</cfif></cfoutput>','list');"></span>
                                </div>
                            </div>
                        </div>    
                        <div class="form-group" id="">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='32851.Kod/ Telefon'>*</label>
                            <div class="col col-4 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='33053.Geçerli Bir Telefon Kodu Giriniz !'></cfsavecontent>
                                    <cfinput type="text" name="compbranch_telcode" required="yes" maxlength="5" message="#message#" style="width:60px;">
                            </div>    
                                <div class="col col-4 col-xs-12">       
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57499.Telefon '></cfsavecontent> 
                                    <cfinput type="text" name="compbranch_tel1" maxlength="10" required="yes" message="#message#" style="width:97px;"> 
                                </div>
                            </div>   
                        <div class="form-group" id="item-compbranch_tel2">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57499.Telefon'>2</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="compbranch_tel2" id="compbranch_tel2" maxlength="10" style="width:97px;">
                            </div>
                        </div>   
                        <div class="form-group" id="item-compbranch_tel3">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57499.Telefon'>3</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="compbranch_tel3" id="compbranch_tel3" value="" maxlength="10" style="width:97px;">
                            </div>
                        </div>    
                        <div class="form-group" id="item-compbranch_fax">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57488.Fax'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="compbranch_fax" id="compbranch_fax" maxlength="10" style="width:97px;">
                            </div>
                        </div>    
                        <div class="form-group" id="">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='30254.Kod/Mobil'></label>
                            <div class="col col-4 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30254.Kod/ Mobil tel'></cfsavecontent>
                                    <cfinput type="text" name="mobilcat_id" id="mobilcat_id" value="" maxlength="7" validate="integer" tabindex="2" onKeyUp="isNumber(this)" style="width:60px;">
                            </div>    
                                <div class="col col-4 col-xs-12">    
                                    <cfinput type="text" name="mobiltel" id="mobiltel" value="" maxlength="10" validate="integer" message="#message#" onKeyUp="isNumber(this)" tabindex="2" style="width:97px;">
                                </div>
                            </div>
                        <div class="form-group" id="item-compbranch_email">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57428.E-mail'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="compbranch_email" id="compbranch_email" maxlength="100" style="width:160px;">
                            </div>
                        </div>    
                        <div class="form-group" id="item-homepage">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='58079.İnternet'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="homepage" id="homepage" value="http://" maxlength="50" style="width:160px;">
                            </div>
                        </div>    
                        <div class="form-group" id="item-compbranch__nickname">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="compbranch__nickname" id="compbranch__nickname" style="width:160px;height:70px;"></textarea>
                            </div>
                        </div>    
                </div>   
                <div class="col col-6 col-md-8 col-sm-12" type="column" sort="true" index="3">
                        <div class="form-group" id="item-manager">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='29511.Yönetici'></label>
                            <div class="col col-8 col-xs-12">   
                                <select name="manager" id="manager" style="width:150px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_partner"> 
                                        <option value="#partner_id#">#company_partner_name# #company_partner_surname#</option>
                                    </cfoutput> 
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-pos_code">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57908.Temsilci'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="pos_code" id="pos_code">
                                    <input type="text" name="pos_code_text" id="pos_code_text" readonly style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_company_branch.pos_code&field_name=add_company_branch.pos_code_text&select_list=1','list');return false"></span>
                                </div>
                            </div>
                        </div>        
                        <div class="form-group" id="item-manager">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='58219.Ülke'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="country" id="country" onchange="remove_adress('1');" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_country">
                                <option value="#get_country.country_id#" <cfif get_country.country_id eq 1>selected</cfif>>#get_country.country_name#</option>
                                </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-city_id">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57971.Şehir'><cfif get_einvoice.recordcount>*</cfif></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="city_id" id="city_id" value="">          
                                    <input type="text" name="city" id="city" value="" readonly style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_city();"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-county_id">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='58638.ilçe'><cfif get_einvoice.recordcount>*</cfif></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group"> 
                                    <input type="hidden" name="county_id" id="county_id" readonly="">
                                    <input type="text" name="county" id="county" value="" maxlength="30" style="width:150px;" readonly tabindex="12">
                                    <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac();"></span>
                                </div>
                            </div>
                        </div>    
                        <div class="form-group" id="item-compbranch_postcode">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="text" name="compbranch_postcode" id="compbranch_postcode" maxlength="5" style="width:150px;">
                            </div>
                        </div>    
                        <div class="form-group" id="item-semt">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='58132.Semt'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="semt" id="semt" value="" maxlength="50" style="width:150px;">
                            </div>
                        </div>    
                        <div class="form-group" id="item-compbranch_address">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='58723.Adres'></label>
                            <div class="col col-8 col-xs-12"> 
                                <textarea name="compbranch_address" id="compbranch_address" style="width:150px;height:70px;"></textarea>
                            </div>
                        </div>    
                        <div class="form-group" id="item-sales_zone_id">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                            <div class="col col-8 col-xs-12"> 
                                <cfquery name="GET_SALES_ZONES" datasource="#DSN#">
                                    SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE = 1 ORDER BY SZ_NAME
                                </cfquery>
                                <select name="sales_zone_id" id="sales_zone_id" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_sales_zones">
                                    <option value="#sz_id#">#sz_name#</option>
                                </cfoutput>
                                </select>   
                            </div>
                        </div>
                        <div class="form-group" id="">			
                            <label class="col col-4 col-xs-12" style="text-align:left;"><cf_get_lang dictionary_id='58549.Koordinatlar'></label>
                            <div class="col col-4 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='59875.Lütfen enlem değerini -90 ile 90 arasında giriniz'>!</cfsavecontent>
                                    <cfinput type="text" maxlength="10" range="-90,90" message="#message#" value="" name="coordinate_1" placeholder="#getLang('main',1141,'E')#"> 
                            </div>    
                            <div class="col col-4 col-xs-12">    
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='59894.Lütfen boylam değerini -180 ile 180 arasında giriniz'></cfsavecontent>
                                <cfinput type="text" maxlength="10" range="-180,180" message="#message#" value="" name="coordinate_2" placeholder="#getLang('main',1179,'B')#">
                            </div>
                        </div>
                </div>    
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
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
		alert("<cf_get_lang dictionary_id='33069.İlk Olarak Ülke Seçiniz'>!");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_company_branch.city_id&field_name=add_company_branch.city&field_phone_code=add_company_branch.compbranch_telcode&country_id=' + document.add_company_branch.country.value,'small');
	}
	return remove_adress('2');
}

function pencere_ac(no)
{
	x = document.add_company_branch.country.selectedIndex;
	if (document.add_company_branch.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='33069.İlk Olarak Ülke Seçiniz'>!");
	}	
	else if(document.add_company_branch.city_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='33176.İl Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_company_branch.county_id&field_name=add_company_branch.county&city_id=' + document.add_company_branch.city_id.value,'small');
		return remove_adress();
	}
}

function kontrol()
{
	<cfif get_einvoice.recordcount eq 1>
		if(document.getElementById('city_id').value.length < 1)
		{
			alert("<cf_get_lang dictionary_id='32876.Lütfen Şehir Seçiniz'>!");
			return false;
		}
		
		if(document.getElementById('county_id').value.length < 1)
		{
			alert("<cf_get_lang dictionary_id='52665.Lütfen İlçe Seçiniz'>!");
			return false;
		}
	</cfif>
		
	z = (250 - document.add_company_branch.compbranch_address.value.length);
	if ( z < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * z));
		return false;
	}
	z = (50 - document.add_company_branch.compbranch__nickname.value.length);
	if ( z < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * z) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'> !");
		return false;
	}
	return true;
}
</script>
