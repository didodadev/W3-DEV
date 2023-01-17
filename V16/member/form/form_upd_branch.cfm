<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../query/get_branch_partner.cfm">
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		CB.*,
		C.FULLNAME,
		C.SEMT,
		C.MANAGER_PARTNER_ID,
        C.TAXNO
	FROM
		COMPANY C,
		COMPANY_CAT CC,
		COMPANY_BRANCH CB
	WHERE 
		C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
		CB.COMPANY_ID = C.COMPANY_ID AND
		CB.COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.brid#">
</cfquery>
<cfquery name="GET_PARTNER_BRANCH" datasource="#DSN#">
	SELECT
		CP.PARTNER_ID,
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME
	FROM
		COMPANY_PARTNER AS CP,
		COMPANY AS C
	WHERE
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cpid#"> AND
		CP.COMPANY_ID = C.COMPANY_ID
	ORDER BY
		CP.COMPANY_PARTNER_NAME
</cfquery>
<cfscript>
	einvoice_control= createObject("component","V16.e_government.cfc.einvoice");
	einvoice_control.dsn = dsn;
	get_einvoice = einvoice_control.get_einvoice_fnc();
</cfscript>
        <cf_catalystHeader>
        <cfform name="upd_company_branch" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_branch">
        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#url.cpid#</cfoutput>">
        <input type="hidden" name="compbranch_id" id="compbranch_id" value="<cfoutput>#url.brid#</cfoutput>">
        <div class="row">
			<div class="col col-9 col-xs-12 uniqueRow">
			    <div class="row formContent">
                	<div class="row" type="row">
                    	<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-compbranch_status">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="checkbox" name="compbranch_status" id="compbranch_status" <cfif get_company.compbranch_status eq 1>checked</cfif>>
                            	</div>
                            </div>
                            <div class="form-group" id="item-compbranch__name">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29532.Şube Adı'> *</label>
                                <div class="col col-8 col-xs-12">
                            		<cfinput type="text" name="compbranch__name" value="#get_company.compbranch__name#" required="yes" maxlength="50" style="width:151px;">
                            	</div>
                            </div>
                            <div class="form-group" id="item-compbranch_code">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59005.Şube Kodu'></label>
                                <div class="col col-8 col-xs-12">
                            		<input type="text" name="compbranch_code" id="compbranch_code" value="<cfoutput>#get_company.compbranch_code#</cfoutput>" maxlength="30" style="width:151px;">
                            	</div>
                            </div>
                            <div class="form-group" id="item-compbranch_alias">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30221.Şube Alias Tanımı'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
                                    	<input type="text" name="compbranch_alias" id="compbranch_alias" value="<cfoutput>#get_company.compbranch_alias#</cfoutput>" style="width:152px;" readonly="readonly">
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branch_alias&field_alias=upd_company_branch.compbranch_alias&company_id=#get_company.company_id#</cfoutput>','list');"></span>
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-compbranch_telcode">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30174.Kod/ Telefon'> 1 *</label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
			                            <cfinput type="text" name="compbranch_telcode" value="#get_company.compbranch_telcode#" required="yes" maxlength="5" style="width:60px;">
                                    	<span class="input-group-addon no-bg"></span>
			                            <cfinput type="text" name="compbranch_tel1" value="#get_company.compbranch_tel1#" required="yes" maxlength="10" style="width:90px;">
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-compbranch_tel2">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" name="compbranch_tel2" id="compbranch_tel2" value="<cfoutput>#get_company.compbranch_tel2#</cfoutput>" maxlength="10" >
                            	</div>
                            </div>
                            <div class="form-group" id="item-compbranch_tel3">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" name="compbranch_tel3" id="compbranch_tel3" value="<cfoutput>#get_company.compbranch_tel3#</cfoutput>" maxlength="10" >
                            	</div>
                            </div>
                            <div class="form-group" id="item-compbranch_fax">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" name="compbranch_fax" id="compbranch_fax" value="<cfoutput>#get_company.compbranch_fax#</cfoutput>" maxlength="10" style="width:90px;">
                            	</div>
                            </div>
                            <div class="form-group" id="item-mobilcat_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30254.Kod / Mobil'></label>
                                <div class="col col-8 col-xs-12">
	                                <div class="input-group">
			                            <cfinput type="text" name="mobilcat_id" id="mobilcat_id" value="#get_company.compbranch_mobil_code#" onKeyUp="isNumber(this)" maxlength="7" validate="integer" tabindex="2" style="width:60px;">
	                                    <span class="input-group-addon no-bg"></span>
			                            <cfinput type="text" name="mobiltel" id="mobiltel" value="#get_company.compbranch_mobiltel#" maxlength="10" onKeyUp="isNumber(this)" validate="integer" tabindex="2" style="width:90px;">
	                            	</div>
                                </div>
                            </div>
                            <div class="form-group" id="item-compbranch_email">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
	                            <div class="col col-8 col-xs-12">
	                                <input type="text" name="compbranch_email" id="compbranch_email" value="<cfoutput>#get_company.compbranch_email#</cfoutput>" maxlength="100" >
                            	</div>
                        	</div>
                            <div class="form-group" id="item-homepage">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30179.Internet'></label>
	                            <div class="col col-8 col-xs-12">
	                                <input type="text" name="homepage" id="homepage" value="<cfoutput>#get_company.homepage#</cfoutput>" maxlength="50">
                            	</div>
                        	</div>
                            <div class="form-group" id="item-compbranch__nickname">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
	                            <div class="col col-8 col-xs-12">
                                    <textarea name="compbranch__nickname" id="compbranch__nickname" style="width:153px;height:70px;"><cfoutput>#get_company.compbranch__nickname#</cfoutput></textarea>
                            	</div>
                        	</div>
        				</div>
                        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        	<div class="form-group" id="item-is_ship_address">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30516.Sevk Adresi'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="checkbox" name="is_ship_address" id="is_ship_address" value="1" <cfif get_company.is_ship_address eq 1>checked</cfif>>
                            	</div>
                            </div>
                            <div class="form-group" id="item-is_invoice_address">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30261.Fatura Adresi'></label>
                                <div class="col col-8 col-xs-12">
                                	 <input type="checkbox" name="is_invoice_address" id="is_invoice_address" value="1" <cfif get_company.is_invoice_address eq 1>checked</cfif>>
                            	</div>
                            </div>
                            <div class="form-group" id="item-manager_partner_id">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30367.Yonetici'></label>
	                            <div class="col col-8 col-xs-12">
	                                <select name="manager_partner_id" id="manager_partner_id" style="width:150px;">
		                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
									<cfoutput query="get_partner_branch"> 
		                                <option value="#partner_id#" <cfif get_partner_branch.partner_id eq get_company.manager_partner_id>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
		                            </cfoutput> 
		                            </select>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-pos_code_text">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57908.Temsilci'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
                                    	<cfif len(get_company.pos_code)>
			                                <input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#get_company.pos_code#</cfoutput>">
			                                <input type="text" name="pos_code_text" id="pos_code_text" value="<cfoutput>#get_emp_info(get_company.pos_code,1,0)#</cfoutput>" style="width:150px;">
			                            <cfelse>
			                                <input type="hidden" name="pos_code" id="pos_code" value="">
			                                <input type="text" name="pos_code_text" id="pos_code_text" value="" style="width:150px;">
			                            </cfif>
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_company_branch.pos_code&field_name=upd_company_branch.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1','list','popup_list_positions');return false"></span>
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-country">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="country" id="country" onChange="LoadCity(this.value,'city_id','county_id')">
		                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		                            <cfoutput query="get_country">
		                                <option value="#get_country.country_id#" <cfif get_company.country_id eq get_country.country_id>selected</cfif>>#get_country.country_name#</option>
		                            </cfoutput>
		                            </select>
                            	</div>
                            </div>
                            <div class="form-group" id="item-city_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'><cfif get_einvoice.recordcount> *</cfif></label>
                                <div class="col col-8 col-xs-12">
                                	<cfif len(get_company.city_id)>
		                                <cfquery name="GET_CITY" datasource="#DSN#">
		                                	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.country_id#">
		                                </cfquery>
		                                <select name="city_id" id="city_id" style="width:150px;" onchange="LoadCounty(this.value,'county_id','compbranch_telcode')">
		                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		                              	<cfoutput query="get_city">
		                                    <option value="#city_id#" <cfif city_id eq get_company.city_id>selected</cfif>>#city_name#</option>
		                              	</cfoutput>
		                              	</select>
		                            <cfelse>
		                                <select name="city_id" id="city_id" style="width:150px;" onchange="LoadCounty(this.value,'county_id','compbranch_telcode')">
		                                	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		                        		</select>
		                            </cfif>
                            	</div>
                            </div>
                            <div class="form-group" id="item-county_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.Ilce'><cfif get_einvoice.recordcount> *</cfif></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="county_id" id="county_id" style="width:150px;">
		                            	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>						
									<cfif isdefined('get_company.county_id') and len(get_company.county_id)>
		                                <cfquery name="GET_COUNTY" datasource="#DSN#">
		                                    SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.city_id#">
		                                </cfquery>
		                           	<cfoutput query="get_county">
		                                <option value="#county_id#" <cfif get_company.county_id eq county_id>selected</cfif>>#county_name#</option>
		                            </cfoutput>
		                            </cfif>
		                            </select>
                            	</div>
                            </div>
                            <div class="form-group" id="item-semt">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
                                <div class="col col-8 col-xs-12">
                                	<cfinput type="text" name="semt" value="#get_company.semt#" maxlength="50">
                            	</div>
                            </div>
                            <div class="form-group" id="item-compbranch_postcode">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" name="compbranch_postcode" id="compbranch_postcode" value="<cfoutput>#get_company.compbranch_postcode#</cfoutput>" maxlength="5">
                            	</div>
                            </div>
                            <div class="form-group" id="item-sales_zone_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                                <div class="col col-8 col-xs-12">
                                	<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
		                                SELECT 
		                                    SZ_ID,
		                                    SZ_NAME 
		                                FROM 
		                                    SALES_ZONES 
		                                WHERE 
		                                    IS_ACTIVE = 1 
		                                UNION
		                                SELECT
		                                    CB.SZ_ID SZ_ID,
		                                    SALES_ZONES.SZ_NAME SZ_NAME
		                                FROM
		                                    COMPANY_BRANCH CB,
		                                    SALES_ZONES
		                                WHERE
		                                    SALES_ZONES.SZ_ID = CB.SZ_ID AND
		                                    CB.COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.brid#">
		                            </cfquery>
		                            <select name="sales_zone_id" id="sales_zone_id" style="width:150px;">
		                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		                            <cfoutput query="get_sales_zones">
		                                <option value="#sz_id#" <cfif sz_id eq get_company.sz_id>selected</cfif>>#sz_name#</option>
		                            </cfoutput>
		                            </select>
                            	</div>
                            </div>
                            <div class="form-group" id="item-coordinate_1">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58549.Koordinatlar'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
										<span class="input-group-addon bold"><cf_get_lang dictionary_id='58553.E'></span>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='59875.Lütfen enlem değerini -90 ile 90 arasında giriniz'></cfsavecontent>
                                    	<cfinput type="text" maxlength="10" range="-90,90" message="#message#" value="#get_company.coordinate_1#" name="coordinate_1" style="width:62px;"> 
										<span class="input-group-addon bold"><cf_get_lang dictionary_id='58591.B'></span>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='59894.Lütfen boylam değerini -180 ile 180 arasında giriniz'></cfsavecontent>	
                                        <cfinput type="text" maxlength="10" range="-180,180" message="#message#" value="#get_company.coordinate_2#" name="coordinate_2" style="width:62px;">
                                        <cfif len(get_company.coordinate_1) and len(get_company.coordinate_2)>
	                                        <span class="input-group-addon">
	                                        	<cfoutput><a href="javascript://" ><img src="/images/branch.gif" border="0" title="<cf_get_lang dictionary_id='58849.Haritada Göster'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#get_company.coordinate_1#&coordinate_2=#get_company.coordinate_2#&title=#get_company.compbranch__name#</cfoutput>','list','popup_view_map')" align="absmiddle"></a></cfoutput> 				
	                            			</span>
                                    	</cfif>
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-compbranch_address">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
                                <div class="col col-8 col-xs-12">
                                	<textarea name="compbranch_address" id="compbranch_address" style="width:150px;height:70px;"><cfoutput>#get_company.compbranch_address#</cfoutput></textarea>
                            	</div>
                            </div>
        				</div>
        			</div>
                    <div class="row formContentFooter">
	                    <div class="col col-6 col-xs-12">
	                        <cf_record_info query_name="get_company" record_emp="record_member" update_emp="update_member">
	                    </div>
                        <div class="col col-6 col-xs-12">
                        	<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()' type_format="1">
                        </div>
                	</div>
        		</div>
        	</div>
        
        </cfform>
        <div class="col col-3 col-xs-12 uniqueRow">
        	<div class="row">
				<!--- Sube Uyeleri --->
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='30195.Şube Çalışanları'></cfsavecontent>
		        <cf_box title="#message#" closable="0"
		            box_page="#request.self#?fuseaction=#fusebox.circuit#.employees_branch_ajax&BRID=#url.brid#">
		        </cf_box>
		           <cf_get_workcube_note action_section='COMPANY_BRANCH_ID' action_id='#url.brid#'>
   			</div>
   		</div>
   </div>


<script type="text/javascript">
var country_= document.getElementById('country').value;
<cfif not len(get_company.city_id)>
	if(country_.length)
		LoadCity(country_,'city_id','county_id')
</cfif>

var city_= document.getElementById('city_id').value;
<cfif not len(get_company.county_id)>
	if(city_.length)
		LoadCounty(city_,'county_id')
</cfif>

function remove_adress(parametre)
{
	if(parametre==1)
	{
		document.upd_company_branch.city_id.value = '';
		document.upd_company_branch.city.value = '';
		document.upd_company_branch.county_id.value = '';
		document.upd_company_branch.county.value = '';
		document.upd_company_branch.compbranch_telcode.value = '';
	}
	else
	{
		document.upd_company_branch.county_id.value = '';
		document.upd_company_branch.county.value = '';
	}	
}

function pencere_ac_city()
{
	x = document.upd_company_branch.country.selectedIndex;
	if (document.upd_company_branch.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='30498.İlk Olarak Ülke Seçiniz.'>");
	}	
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_company_branch.city_id&field_name=upd_company_branch.city&field_phone_code=upd_company_branch.compbranch_telcode&country_id=' + document.upd_company_branch.country.value,'small','popup_dsp_city');
	}
	return remove_adress('2');
}

function pencere_ac(no)
{
	x = document.upd_company_branch.country.selectedIndex;
	if (document.upd_company_branch.country[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='30498.İlk Olarak Ülke Seçiniz.'>");
	}	
	else if(document.upd_company_branch.city_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='30499.Lütfen Şehir Seçiniz!'>");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_company_branch.county_id&field_name=upd_company_branch.county&city_id=' + document.upd_company_branch.city_id.value,'small','popup_dsp_county');
		return remove_adress();
	}
}
function kontrol()
{
	if(!$("#compbranch__name").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'></cfoutput>"})    
			return false;
		}
		
	if(!$("#compbranch_telcode").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='30316.Telefon Kodu'></cfoutput>"})    
			return false;
		}
	if(!$("#compbranch_tel1").val().length)
	{
		alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57499.Telefon'></cfoutput>"})    
		return false;
	}
	<cfif get_einvoice.recordcount>
		if(document.getElementById('city_id').value.length < 1)
		{
			alert("<cf_get_lang dictionary_id='30499.Lütfen Şehir Seçiniz'>!");
			return false;
		}
		
		if(document.getElementById('county_id').value.length < 1)
		{
			alert("<cf_get_lang dictionary_id='30538.Lütfen İlçe Seçiniz'>!");
			return false;
		}
	</cfif>
	
	x = (250 - document.upd_company_branch.compbranch_address.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='58723.Adres'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayisi'>"+ ((-1) * x));
		return false;
	}
	x = (100 - document.upd_company_branch.compbranch__nickname.value.length);
	if ( x < 0 )
	{ 
		alert ("<cf_get_lang dictionary_id='57453.Sube'><cf_get_lang dictionary_id='57629.Aciklama'><cf_get_lang dictionary_id='58210.Alanindaki Fazla Karakter Sayısı'>"+ ((-1) * x));
		return false;
	}
	if((document.upd_company_branch.coordinate_1.value.length != "" && document.upd_company_branch.coordinate_2.value.length == "") || (document.upd_company_branch.coordinate_1.value.length == "" && document.upd_company_branch.coordinate_2.value.length != ""))
	{
		alert ("<cf_get_lang dictionary_id='30292.Lütfen koordinat değerlerini giriniz!'>");
		return false;
	}
	return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
  
