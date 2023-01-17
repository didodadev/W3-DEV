<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.hedef_kodu" default="">
<cfparam name="attributes.cp_name" default="">
<cfparam name="attributes.cp_surname" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.ekip" default="">
<cfparam name="attributes.vergi_no" default="">
<cfparam name="attributes.customer_type" default="">
<cfparam name="attributes.customer_type_id" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.citycode" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.home_country" default="">
<cfparam name="attributes.branch_state" default="3">
<cfparam name="attributes.pro_rows" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_active" default="1">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfinclude template="../query/get_country.cfm">
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_PRO_TYPEROWS" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.popup_add_law_request%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.is_submitted")>
	<cfscript>
		if (len(attributes.fullname))
		{
			fullname_1 = replacelist(attributes.fullname,"ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö","u,g,i,s,c,o,U,G,I,S,C,O");
			fullname_2 = replacelist(attributes.fullname,"u,g,i,s,c,o,U,G,I,S,C,O","ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö");
		}
	</cfscript>
  	<cfquery name="get_company" datasource="#dsn#">
		SELECT
			C.COMPANY_ID COMPANY_ID,
			C.FULLNAME FULLNAME,
			C.CITY CITY,
			C.COUNTY COUNTY,
			C.COUNTRY COUNTRY,
			C.COMPANY_TELCODE COMPANY_TELCODE,
			C.COMPANY_TEL1 COMPANY_TEL1, 
			C.TAXNO TAXNO,
			C.ISPOTANTIAL ISPOTANTIAL,
			CLR.LAW_REQUEST_ID LAW_REQUEST_ID,
			CLR.PROCESS_CAT PROCESS_CAT,
			CLR.BRANCH_ID BRANCH_ID,
			CLR.RECORD_DATE RECORD_DATE,
			CP.PARTNER_ID PARTNER_ID, 
			CP.COMPANY_PARTNER_NAME COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME COMPANY_PARTNER_SURNAME,
			SIC.IMS_CODE IMS_CODE, 
			SIC.IMS_CODE_NAME IMS_CODE_NAME
		FROM 
			COMPANY C, 
			COMPANY_PARTNER CP, 
			SETUP_IMS_CODE SIC,
			COMPANY_LAW_REQUEST CLR
		WHERE 
			C.COMPANY_ID = CP.COMPANY_ID AND
			C.COMPANY_ID = CLR.COMPANY_ID AND
			C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND
			SIC.IMS_CODE_ID = C.IMS_CODE_ID 
			<cfif len(attributes.fullname)>AND ( C.FULLNAME LIKE '#attributes.fullname#%' OR C.FULLNAME LIKE '#fullname_1#%' OR C.FULLNAME LIKE '#fullname_2#%' )</cfif>
			<cfif len(attributes.hedef_kodu) and isnumeric(attributes.hedef_kodu)>AND C.COMPANY_ID = #attributes.hedef_kodu#</cfif>
			<cfif len(attributes.cp_name)>AND CP.COMPANY_PARTNER_NAME LIKE '#attributes.cp_name#%'</cfif>
			<cfif len(attributes.cp_surname)>AND CP.COMPANY_PARTNER_SURNAME LIKE '#attributes.cp_surname#%'</cfif>
			<cfif len(attributes.is_active)>AND CLR.IS_ACTIVE = #attributes.is_active#</cfif>
			<cfif len(attributes.vergi_no)>AND C.TAXNO = '#attributes.vergi_no#'</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND C.IMS_CODE_ID = #attributes.ims_code_id#</cfif>
			<cfif len(attributes.city)>AND C.CITY = #attributes.city#</cfif>
			<cfif len(attributes.county_id)>AND C.COUNTY = #attributes.county_id#</cfif>
			<cfif len(attributes.home_country)>AND C.COUNTRY = #attributes.home_country#</cfif>
			<cfif len(attributes.branch_id)>
				AND CLR.BRANCH_ID = #attributes.branch_id#
			<cfelse>
				<cfif get_branch.recordcount>
					AND CLR.BRANCH_ID IN (#valuelist(get_branch.branch_id,',')#)
				</cfif>
			</cfif>
			<cfif len(attributes.pro_rows)>AND CLR.PROCESS_CAT = #attributes.pro_rows#</cfif>
			<cfif len(attributes.start_date)>AND CLR.RECORD_DATE >= #attributes.start_date#</cfif>
			<cfif len(attributes.finish_date)>AND CLR.RECORD_DATE < #DATEADD('d',1,attributes.finish_date)#</cfif>
		ORDER BY
			C.FULLNAME,
			CLR.RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_company.recordcount = 0>
</cfif>

<cfparam name='attributes.totalrecords' default='#get_company.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="search_company" method="post" action="#request.self#?fuseaction=crm.list_law_request">
			<input type="hidden" name="is_submitted" id="is_submitted" value="">
			<input type="hidden" name="click_count" id="click_count" value="0">
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<input type="text" name="fullname" placeholder="<cf_get_lang dictionary_id='57750.İşyeri Adı'>" value="#attributes.fullname#" maxlength="255">
					</div>
					<div class="form-group">
						<input type="text" name="hedef_kodu" value="#attributes.hedef_kodu#" placeholder="<cf_get_lang dictionary_id='52115.Hedef Kodu'>"  onKeyup="isNumber(this);" maxlength="8">
					</div>
					<div class="form-group">
						<input type="text" placeholder="<cf_get_lang dictionary_id='57631.Ad'>" name="cp_name" value="#attributes.cp_name#" maxlength="255">
					</div>
					<div class="form-group">
						<input type="text" name="cp_surname" placeholder="<cf_get_lang dictionary_id='58726.Soyad'>" value="#attributes.cp_surname#" maxlength="255">
					</div>
					<div class="form-group">
						<input type="text" name="vergi_no" placeholder="<cf_get_lang dictionary_id='57752.Vergi No'>" value="#attributes.vergi_no#">
					</div>
					<div class="form-group">
						<select name="is_active" id="is_active">
							<option value="" <cfif attributes.is_active eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						</select>
					</div>
					<div class="form-group small">
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Filtre',57537)#" maxlength="3">
                    </div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cfoutput>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-8 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='58054.Süreç - Aşama'></label>
						<div class="col col-12">
							<select name="pro_rows" id="pro_rows">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_pro_typerows">
									<option value="#process_row_id#" <cfif attributes.pro_rows eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='51554.Yetkili Şubeler'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_branch">
									<option value="#branch_id#" <cfif branch_id eq attributes.branch_id>selected</cfif>>#branch_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div  class="col col-3 col-md-8 col-sm-12" type="column" index="2" sort="true">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
								<cfinput type="text" name="ims_code_name" value="#attributes.ims_code_name#">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac();"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-12">
							<select name="home_country" id="home_country" tabindex="21" onChange="LoadCity(this.value,'city','county_id',0)">
								<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif attributes.home_country eq country_id>selected</cfif>>#get_country.country_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-8 col-sm-12" type="column" index="3" sort="true">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='58608.İl'></label>
						<div class="col col-12">
							<select name="city" id="city" onchange="LoadCounty(this.value,'county_id');">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif isdefined('attributes.home_country') and len(attributes.home_country)>
									<cfquery name="get_city" datasource="#dsn#">
										SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID, PLATE_CODE FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.home_country#"> ORDER BY CITY_NAME 
									</cfquery>
									<cfoutput query="get_city">
										<option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='63898.İlçe'></label>
						<div class="col col-12">
							<select name="county_id" id="county_id">
								<option value=""><cf_get_lang dictionary_id='58638.Ilçe'></option>
								<cfif isdefined('attributes.city') and len(attributes.city)>
									<cfquery name="get_county" datasource="#DSN#">
										SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"> ORDER BY COUNTY_NAME
									</cfquery>
									<cfoutput query="get_county">
										<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-8 col-sm-12" type="column" index="4" sort="true">
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
								<cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
							<cfinput required="Yes" message="#message#" type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box  title="#getLang('','Avukata Verme Talebi',52002)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th  width="20"><cf_get_lang dictionary_id='55657.Sıra No'></th>
					<th><cf_get_lang dictionary_id='57750.İşyeri Adı'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></th>
					<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
					<th><cf_get_lang dictionary_id='58219.Ülke'></th>
					<th><cf_get_lang dictionary_id='58608.İl'></th>
					<th><cf_get_lang dictionary_id='63898.İlçe'></th>
					<th><cf_get_lang dictionary_id='63896.Telefon'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="20"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_add_law_request&is_page=1</cfoutput>','longpage','popup_add_law_request')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_company.recordcount>
					<cfset county_list = ''>
					<cfset city_list = ''>
					<cfset country_list=''>
					<cfset process_list = ''>
					<cfset branch_list = ''>
					<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(county) and not listfind(county_list,county)>
							<cfset county_list=listappend(county_list,county)>
						</cfif>
						<cfif len(city) and not listfind(city_list,city)>
							<cfset city_list=listappend(city_list,city)>
						</cfif>
						<cfif len(country) and not listfind(country_list,country)>
							<cfset country_list=listappend(country_list,country)>
						</cfif>
						<cfif len(process_cat) and not listfind(process_list,process_cat)>
							<cfset process_list=listappend(process_list,process_cat)>
						</cfif>
						<cfif len(branch_id) and not listfind(branch_list,branch_id)>
							<cfset branch_list=listappend(branch_list,branch_id)>
						</cfif>
					</cfoutput>
					<cfif len(county_list)>
						<cfquery name="get_county" datasource="#dsn#">
							SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
						</cfquery>
						<cfset county_list = listsort(listdeleteduplicates(valuelist(get_county.county_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(city_list)>
						<cfquery name="get_city" datasource="#dsn#">
							SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
						</cfquery>
						<cfset city_list = listsort(listdeleteduplicates(valuelist(get_city.city_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(country_list)>
						<cfquery name="GET_COUNTRY" datasource="#DSN#">
							SELECT
								COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_NAME
						</cfquery>
						<cfset country_list = listsort(listdeleteduplicates(valuelist(get_country.country_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(process_list)>
						<cfquery name="get_process" datasource="#dsn#">
							SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset process_list = listsort(listdeleteduplicates(valuelist(get_process.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(branch_list)>
						<cfquery name="get_branch" datasource="#dsn#">
							SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_list#) ORDER BY BRANCH_ID
						</cfquery>
						<cfset branch_list = listsort(listdeleteduplicates(valuelist(get_branch.branch_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td width="20">#currentrow#</td>
						<td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#&is_search=1" class="tableyazi"><cfif ispotantial eq 0>#fullname#<cfelse>#fullname# - <cf_get_lang dictionary_id='57577.Potansiyel'></cfif></a></td>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium');" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
						<td title="#ims_code_name#">#ims_code#</td>
						<td>#taxno#</td>
						<td>#get_country.country_name[listfind(country_list,country,',')]#</td>
						<td>#get_city.city_name[listfind(city_list,city,',')]#</td>
						<td>#get_county.county_name[listfind(county_list,county,',')]#</td>
						<td>#company_telcode# #company_tel1#</td>		
						<td>#get_branch.branch_name[listfind(branch_list,branch_id,',')]#</td>
						<td>#get_process.stage[listfind(process_list,process_cat,',')]#</td>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_law_request&law_request_id=#law_request_id#','longpage','popup_upd_law_request')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" border="0"></i></a></td>
					</tr>
					</cfoutput>
				  <cfelse>
					<tr>
						<td colspan="30"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				  </cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "&is_submitted=#attributes.is_submitted#">
			<cfif len(attributes.branch_state)>
				<cfset url_str = "#url_str#&branch_state=#attributes.branch_state#">
			</cfif>
			<cfif len(attributes.fullname)>
				<cfset url_str = "#url_str#&fullname=#attributes.fullname#">
			</cfif>
			<cfif len(attributes.hedef_kodu)>
				<cfset url_str = "#url_str#&hedef_kodu=#attributes.hedef_kodu#">
			</cfif>
			<cfif len(attributes.pro_rows)>
				<cfset url_str = "#url_str#&pro_rows=#attributes.pro_rows#">
			</cfif>
			<cfif len(attributes.cp_name)>
				<cfset url_str = "#url_str#&cp_name=#attributes.cp_name#">
			</cfif>
			<cfif len(attributes.cp_surname)>
				<cfset url_str = "#url_str#&cp_surname=#attributes.cp_surname#">
			</cfif>
			<cfif len(attributes.ims_code_id)>
				<cfset url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#">
			</cfif>
			<cfif len(attributes.ims_code_name)>
				<cfset url_str = "#url_str#&ims_code_name=#attributes.ims_code_name#">
			</cfif>
			<cfif len(attributes.ekip)>
				<cfset url_str = "#url_str#&ekip=#attributes.ekip#">
			</cfif>
			<cfif len(attributes.vergi_no)>
				<cfset url_str = "#url_str#&vergi_no=#attributes.vergi_no#">
			</cfif>
			<cfif len(attributes.customer_type)>
				<cfset url_str = "#url_str#&customer_type=#attributes.customer_type#">
			</cfif>
			<cfif len(attributes.customer_type_id)>
				<cfset url_str = "#url_str#&customer_type_id=#attributes.customer_type_id#">
			</cfif>
			<cfif len(attributes.city)>
				<cfset url_str = "#url_str#&city=#attributes.city#">
			</cfif>
			<cfif len(attributes.citycode)>
				<cfset url_str = "#url_str#&citycode=#attributes.citycode#">
			</cfif>
			<cfif len(attributes.county)>
				<cfset url_str = "#url_str#&county=#attributes.county#">
			</cfif>
			<cfif len(attributes.county_id)>
				<cfset url_str = "#url_str#&county_id=#attributes.county_id#">
			</cfif>
			<cfif len(attributes.home_country)>
				<cfset url_str = "#url_str#&country_id=#attributes.home_country#">
			</cfif>
			<cfif len(attributes.branch_id)>
				<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif len(attributes.is_active)>
				<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="crm.list_law_request#url_str#">
		</cfif>
	</cf_box>
</div>

<!-- sil -->
<script type="text/javascript">
document.search_company.fullname.focus();
function remove_field(field_option_name)
{
	field_option_name_value = eval('document.search_company.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
		{
			field_option_name_value.options.remove(i);
		}	
	}
}
function county_id_clear()
{	
	document.search_company.county.value = '';
	document.search_company.county_id.value = '';
	document.search_company.ims_code_id.value = '';
	document.search_company.ims_code_name.value = '';
}
function pencere_ac(selfield)
{	
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_company.ims_code_name&field_id=search_company.ims_code_id&is_submitted=1&il_id=' +document.search_company.city.value,'list');
}
function pencere_ac2(no)
{
	x = document.search_company.city.selectedIndex;
	if (document.search_company.city[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='57257.İlk Olarak İl Seçiniz'> !");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=search_company.county_id&field_name=search_company.county&city_id=' + document.search_company.city.value,'small');
	}
}
/* BK 20070608 120 gune siline
function pencere_ac_companycat()
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_partner_cats&field_name=search_company.customer_type&customer_type=' + document.search_company.company_type.value,'small');
}
*/
function select_all(selected_field)
{
	var m = eval("document.search_company."+selected_field+".length");
	for(i=0;i<m;i++)
	{
		eval("document.search_company."+selected_field+"["+i+"].selected=true")
	}
}
</script>
