<!--- ekleme popup'na giden &is_page=1 parametresi üye secilecegi anlamina geliyor--->
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
<cfparam name="attributes.country_id" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.citycode" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.branch_state" default="3">
<cfparam name="attributes.pro_rows" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.is_valid" default="">
<cfparam name="attributes.is_valid_date" default="0">

<cfinclude template="../query/get_city.cfm">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
</cfif>
<cfquery name="GET_BRANCH" datasource="#DSN#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.popup_add_company_risk%">
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
			C.FULLNAME,
			C.CITY,
			C.COUNTY,
			C.COMPANY_TELCODE,
			C.COMPANY_TEL1, 
			C.TAXNO,
			C.ISPOTANTIAL,
			C.COMPANY_ID,
			CP.PARTNER_ID, 
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			CBR.BRANCH_ID,
			CRR.PROCESS_CAT,
			CRR.RISK_TOTAL,
			CRR.REQUEST_ID,
			CRR.RISK_MONEY_CURRENCY,
			CRR.VALID_DATE,
			CRR.RECORD_DATE,
			SIC.IMS_CODE, 
			SIC.IMS_CODE_NAME
		FROM
			COMPANY C, 
			COMPANY_PARTNER CP, 
			COMPANY_BRANCH_RELATED CBR,
			COMPANY_RISK_REQUEST CRR,
			SETUP_IMS_CODE SIC
		WHERE 
			CBR.MUSTERIDURUM IS NOT NULL AND
			C.COMPANY_ID = CP.COMPANY_ID AND
			C.COMPANY_ID = CBR.COMPANY_ID AND
			C.COMPANY_ID = CRR.COMPANY_ID AND
			C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND
			CRR.BRANCH_ID = CBR.BRANCH_ID AND
			SIC.IMS_CODE_ID = C.IMS_CODE_ID 
			<cfif len(attributes.fullname)>AND ( C.FULLNAME LIKE '#attributes.fullname#%' OR C.FULLNAME LIKE '#fullname_1#%' OR C.FULLNAME LIKE '#fullname_2#%' )</cfif>
			<cfif len(attributes.hedef_kodu) and isnumeric(attributes.hedef_kodu)>AND C.COMPANY_ID = #attributes.hedef_kodu#</cfif>
			<cfif len(attributes.cp_name)>AND CP.COMPANY_PARTNER_NAME LIKE '#attributes.cp_name#%'</cfif>
			<cfif len(attributes.cp_surname)>AND CP.COMPANY_PARTNER_SURNAME LIKE '#attributes.cp_surname#%'</cfif>
			<cfif len(attributes.is_active)>AND CRR.IS_ACTIVE = #attributes.is_active#</cfif>
			<cfif len(attributes.is_valid)>
				<cfif attributes.is_valid eq 1>
					AND CRR.VALID_DATE IS NOT NULL
				<cfelse>
					AND CRR.VALID_DATE IS NULL
				</cfif>
			</cfif>
			<cfif len(attributes.vergi_no)>AND C.TAXNO = '#attributes.vergi_no#'</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND C.IMS_CODE_ID = #attributes.ims_code_id#</cfif>
			<cfif len(attributes.country_id)>AND C.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#"></cfif>
			<cfif len(attributes.city_id)>AND C.CITY = #attributes.city_id#</cfif>
			<cfif len(attributes.county_id)>AND C.COUNTY = #attributes.county_id#</cfif>
			<cfif len(attributes.branch_id)>
				AND CBR.BRANCH_ID = #attributes.branch_id#
			<cfelse>
				<cfif get_branch.recordcount>
					AND CBR.BRANCH_ID IN (#valuelist(get_branch.branch_id,',')#)
				</cfif>
			</cfif>
			<cfif len(attributes.pro_rows)>AND CRR.PROCESS_CAT = #attributes.pro_rows#</cfif>
			<cfif isdefined("attributes.is_valid_date") and attributes.is_valid_date eq 1>
				<cfif len(attributes.start_date)>AND CRR.VALID_DATE >= #attributes.start_date#</cfif>
				<cfif len(attributes.finish_date)>AND CRR.VALID_DATE < #DATEADD('d',1,attributes.finish_date)#</cfif>
			<cfelse>
				<cfif len(attributes.start_date)>AND CRR.RECORD_DATE >= #attributes.start_date#</cfif>
				<cfif len(attributes.finish_date)>AND CRR.RECORD_DATE < #DATEADD('d',1,attributes.finish_date)#</cfif>
			</cfif>
		GROUP BY 
			C.FULLNAME,
			C.CITY,
			C.COUNTY,
			C.COMPANY_TELCODE,
			C.COMPANY_TEL1, 
			C.TAXNO,
			C.ISPOTANTIAL,
			C.COMPANY_ID,
			CP.PARTNER_ID, 
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			CBR.BRANCH_ID,
			CRR.PROCESS_CAT,
			CRR.RISK_TOTAL,
			CRR.REQUEST_ID,
			CRR.RISK_MONEY_CURRENCY,
			CRR.VALID_DATE,
			CRR.RECORD_DATE,
			SIC.IMS_CODE, 
			SIC.IMS_CODE_NAME
		ORDER BY
			C.FULLNAME,
			CRR.RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_company.recordcount = 0>
</cfif>
<cfset company_cmp = CreateObject("component","V16.member.cfc.member_company")>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfparam name='attributes.totalrecords' default='#get_company.recordcount#'>
		<cfparam name="attributes.page" default='1'>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfform name="search_company" method="post" action="#request.self#?fuseaction=crm.list_risk_request">
			<cf_box_search>
				<input type="hidden" name="is_submitted" id="is_submitted" value="">
				<input type="hidden" name="click_count" id="click_count" value="0">
				<div class="form-group">
					<cfinput type="text" name="fullname" value="#attributes.fullname#" maxlength="255" placeholder="#getLang('','İşyeri Adı','57750')#">
				</div>
				<div class="form-group">
					<cfinput type="text" name="hedef_kodu" value="#attributes.hedef_kodu#" onKeyup="isNumber(this);" maxlength="8" placeholder="#getLang('','Hedef Kodu','52115')#">
				</div>
				<div class="form-group">
					<cfinput type="text" name="cp_name" value="#attributes.cp_name#" maxlength="255" placeholder="#getLang('','Ad','57631')#">
				</div>
				<div class="form-group">
					<cfinput type="text" name="cp_surname" value="#attributes.cp_surname#" maxlength="255" placeholder="#getLang('','Soyad','58726')#">
				</div>
				<div class="form-group">
					<cfinput type="text" name="vergi_no" value="#attributes.vergi_no#" placeholder="#getLang('','Vergi No','57752')#">
				</div>
				<div class="form-group">
					<select name="is_active" id="is_active">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_valid">
						<label class="col col-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
						<div class="col col-12">
							<select name="is_valid" id="is_valid">
								<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
								<option value="1" <cfif attributes.is_valid eq 1>selected</cfif>><cf_get_lang dictionary_id='52289.G.Tarihi Olanlar'></option>
								<option value="0" <cfif attributes.is_valid eq 0>selected</cfif>><cf_get_lang dictionary_id='52290.G.Tarihi Olmayanlar'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-ims_code_name">
						<label class="col col-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
								<cfinput type="text" name="ims_code_name" value="#attributes.ims_code_name#">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-is_valid_date">
						<label class="col col-12"><input type="checkbox" name="is_valid_date" id="is_valid_date" value="1" <cfif attributes.is_valid_date is 1>checked</cfif>><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></label>
					</div>
				</div>
				
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6">
						<div class="form-group" id="item-start_date">
							<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfinput required="yes" message="#message#" type="text" name="start_date" maxlength="10"  validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-6">
						<div class="form-group" id="item-finish_date">
							<label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfinput required="yes" message="#message#" type="text" maxlength="10" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-country_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-12">
							<select name="country_id" id="country_id" onchange="LoadCity(this.value,'city_id','county_id',0);">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfset GET_COUNTRY = company_cmp.GET_COUNTRY()>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif attributes.country_id eq country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-branch_id">
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
					<div class="form-group" id="item-city_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<div class="col col-12">
							<select name="city_id" id="city_id" onchange="LoadCounty(this.value,'county_id');">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif isdefined('attributes.country_id') and len(attributes.country_id)>
									<cfset GET_CITY = company_cmp.GET_CITY(country_id:attributes.country_id)>
									<cfoutput query="get_city">
										<option value="#city_id#" <cfif attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-pro_rows">
						<label class="col col-12">&nbsp</label>
						<div class="col col-12">
							<select name="pro_rows" id="pro_rows">
								<option value=""><cf_get_lang dictionary_id='58054.Süreç - Aşama'></option>
								<cfoutput query="get_pro_typerows">
									<option value="#process_row_id#" <cfif attributes.pro_rows eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-county_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-12">
							<select name="county_id" id="county_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
									<cfset get_county = company_cmp.GET_COUNTY(city_id:attributes.city_id)>
									<cfoutput query="get_county">
										<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Risk Yönetimi','51994')#" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57750.İşyeri Adı'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></th>
					<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
					<th><cf_get_lang dictionary_id='58638.İlçe'></th>
					<th><cf_get_lang dictionary_id='58608.İl'></th>
					<th><cf_get_lang dictionary_id='57499.Telefon'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></th>
					<th><cf_get_lang dictionary_id='57689.Risk'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th class="text-center"><a href="<cfoutput>#request.self#?fuseaction=crm.list_risk_request&event=add&is_page=1</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_company.recordcount>
					<cfset county_list = ''>
					<cfset city_list = ''>
					<cfset process_list = ''>
					<cfset branch_list = ''>
					<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(county) and not listfind(county_list,county)>
							<cfset county_list=listappend(county_list,county)>
						</cfif>
						<cfif len(city) and not listfind(city_list,city)>
							<cfset city_list=listappend(city_list,city)>
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
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#&is_search=1" class="tableyazi"><cfif ispotantial eq 0>#fullname#<cfelse>#fullname# - <cf_get_lang dictionary_id='57577.Potansiyel'></cfif></a></td>
							<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#')">#company_partner_name# #company_partner_surname#</a></td>
							<td title="#ims_code_name#">#ims_code#</td>
							<td>#taxno#</td>
							<td>#get_county.county_name[listfind(county_list,county,',')]#</td>
							<td>#get_city.city_name[listfind(city_list,city,',')]#</td>
							<td>#company_telcode# #company_tel1#</td>
							<td>#get_branch.branch_name[listfind(branch_list,branch_id,',')]#</td>
							<td>#get_process.stage[listfind(process_list,process_cat,',')]#</td>
							<td align="center">#DateFormat(get_company.valid_date,dateformat_style)#</td>
							<td  style="text-align:right;">#tlformat(risk_total)# #risk_money_currency#</td>
							<td align="center">#dateformat(record_date,dateformat_style)#</td>
							<td><a href="#request.self#?fuseaction=crm.list_risk_request&event=upd&request_id=#request_id#" target="blank_"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif get_company.recordcount eq 0>
			<div class="ui-info-bottom">
				<p><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
			</div>
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "&is_submitted=#attributes.is_submitted#&is_valid_date=#attributes.is_valid_date#">
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
			<cfif len(attributes.ims_code_name)>
				<cfset url_str = "#url_str#&ims_code_name=#attributes.ims_code_name#&ims_code_id=#attributes.ims_code_id#">
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
			<cfif len(attributes.country_id)>
				<cfset url_str = "#url_str#&country_id=#attributes.country_id#">
			</cfif>
			<cfif len(attributes.county)>
				<cfset url_str = "#url_str#&county_id=#attributes.county_id#&county=#attributes.county#">
			</cfif>
			<cfif len(attributes.branch_id)>
				<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif len(attributes.is_active)>
				<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
			</cfif>
			<cfif len(attributes.is_valid)>
				<cfset url_str = "#url_str#&is_valid=#attributes.is_valid#">
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
				adres="crm.list_risk_request#url_str#">
		</cfif>
	</cf_box>
</div>

<script type="text/javascript">
document.search_company.fullname.focus();
function pencere_ac(selfield)
{	
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_company.ims_code_name&field_id=search_company.ims_code_id&is_submitted=1&il_id=' +document.search_company.city_id.value);
}
</script>
