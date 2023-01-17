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
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = ""><!--- wrk_get_today() --->
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = ""><!--- date_add('d',1,attributes.start_date) --->
</cfif>

<cfinclude template="../query/get_city.cfm">

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
<cfquery name="Get_Pro_TypeRows" datasource="#DSN#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.popup_add_securefund%">
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
			C.FULLNAME FULLNAME,
			C.TAXNO TAXNO,
            C.COMPANY_ID COMPANY_ID,
			C.COUNTY COUNTY,
			C.CITY CITY,
			CBR.BRANCH_ID BRANCH_ID,
			CP.COMPANY_PARTNER_NAME COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME COMPANY_PARTNER_SURNAME,
			CS.SECUREFUND_ID SECUREFUND_ID, 
			CS.COMPANY_ID COMPANY_ID,
			CS.GIVE_TAKE GIVE_TAKE,
			CS.SECUREFUND_TOTAL SECUREFUND_TOTAL,
			CS.MONEY_CAT MONEY_CAT,
			CS.PROCESS_CAT,
			CS.RECORD_EMP RECORD_EMP,
			CS.RECORD_DATE RECORD_DATE,
			CS.FINISH_DATE FINISH_DATE,
			SIC.IMS_CODE IMS_CODE,
			SIC.IMS_CODE_NAME IMS_CODE_NAME,
			SS.SECUREFUND_CAT SECUREFUND_CAT
		FROM 
			COMPANY_SECUREFUND CS, 
			SETUP_SECUREFUND SS,
			COMPANY_BRANCH_RELATED CBR,
			COMPANY C,
			COMPANY_PARTNER CP,
			SETUP_IMS_CODE SIC
		WHERE 
			IS_CRM = 1 AND
			CBR.MUSTERIDURUM IS NOT NULL AND
			CS.SECUREFUND_CAT_ID  = SS.SECUREFUND_CAT_ID AND
			CS.BRANCH_ID = CBR.RELATED_ID AND
			C.COMPANY_ID = CS.COMPANY_ID AND
			SIC.IMS_CODE_ID = C.IMS_CODE_ID AND
			CP.PARTNER_ID = C.MANAGER_PARTNER_ID
			<cfif len(attributes.fullname)>AND ( C.FULLNAME LIKE '#attributes.fullname#%' OR C.FULLNAME LIKE '#fullname_1#%' OR C.FULLNAME LIKE '#fullname_2#%' )</cfif>
			<cfif len(attributes.hedef_kodu) and isnumeric(attributes.hedef_kodu)>AND C.COMPANY_ID = #attributes.hedef_kodu#</cfif>
			<cfif len(attributes.cp_name)>AND CP.COMPANY_PARTNER_NAME LIKE '#attributes.cp_name#%'</cfif>
			<cfif len(attributes.cp_surname)>AND CP.COMPANY_PARTNER_SURNAME LIKE '#attributes.cp_surname#%'</cfif>
			<cfif len(attributes.is_active)>AND CS.SECUREFUND_STATUS = #attributes.is_active#</cfif>
			<cfif len(attributes.vergi_no)>AND C.TAXNO = '#attributes.vergi_no#'</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND C.IMS_CODE_ID = #attributes.ims_code_id#</cfif>
			<cfif len(attributes.country_id)>AND C.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#"></cfif>
			<cfif len(attributes.city_id)>AND C.CITY = #attributes.city_id#</cfif>
			<cfif len(attributes.county_id)>AND C.COUNTY = #attributes.county_id#</cfif>
			<cfif len(attributes.branch_id)>
				AND CBR.BRANCH_ID = #attributes.branch_id#
			<cfelse>
				AND CBR.BRANCH_ID IN <cfif get_branch.recordcount>(#valuelist(get_branch.branch_id,',')#)<cfelse>(0)</cfif>
			</cfif>
			<cfif len(attributes.pro_rows)>
				AND CS.PROCESS_CAT = #attributes.pro_rows#
			<cfelseif ListLen(Get_Pro_TypeRows.Process_Row_Id)>
				AND CS.PROCESS_CAT IN (#ListDeleteDuplicates(ValueList(Get_Pro_TypeRows.Process_Row_Id,','))#)
			<cfelse>
				AND CS.PROCESS_CAT IS NULL
			</cfif>
			<cfif len(attributes.start_date)>AND CS.RECORD_DATE >= #attributes.start_date#</cfif>
			<cfif len(attributes.finish_date)>AND CS.RECORD_DATE < #DATEADD('d',1,attributes.finish_date)#</cfif>
		ORDER BY 
			CS.SECUREFUND_CAT_ID,
			CS.SECUREFUND_TOTAL,
			CS.FINISH_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_company.recordcount = 0>
</cfif>
<cfparam name='attributes.totalrecords' default='#get_company.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset company_cmp = CreateObject("component","V16.member.cfc.member_company")>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_company" method="post" action="#request.self#?fuseaction=crm.list_company_securefund">
			<input type="hidden" name="is_submitted" id="is_submitted" value="">
			<input type="hidden" name="click_count" id="click_count" value="0">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="fullname" placeholder="#getLang('','İşyeri Adı','57750')#" value="#attributes.fullname#" maxlength="255">
				</div>
				<div class="form-group">
					<cfinput type="text" name="hedef_kodu" placeholder="#getLang('','Hedef Kodu','52115')#" value="#attributes.hedef_kodu#" onKeyup="isNumber(this);" maxlength="8">
				</div>
				<div class="form-group">
					<cfinput type="text" name="cp_name" placeholder="#getLang('','Ad','57631')#" value="#attributes.cp_name#" maxlength="255">
				</div>
				<div class="form-group">
					<cfinput type="text" name="cp_surname" placeholder="#getLang('','Soyad','58726')#" value="#attributes.cp_surname#" maxlength="255">
				</div>
				<div class="form-group">
					<cfinput type="text" name="vergi_no" value="#attributes.vergi_no#" placeholder="#getLang('','Vergi No','57752')#">
				</div>
				<div class="form-group">
					<select name="is_active" id="is_active">
						<option value="" <cfif attributes.is_active eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
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
					<div class="form-group" id="item-process_row_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58054.Süreç - Aşama'></label>
						<div class="col col-12">
							<select name="pro_rows" id="pro_rows">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="Get_Pro_TypeRows">
								  <option value="#process_row_id#" <cfif attributes.pro_rows eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
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
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
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
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-ims_code_name">
						<label class="col col-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
								<cfinput type="text" name="ims_code_name" value="#attributes.ims_code_name#">
								<span class="input-group-addon icon-ellipsis" onClick="pencere_ac();"></span>
							</div>
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
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="col col-6">
						<div class="form-group" id="item-start_date">
							<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'> !</cfsavecontent>
									<cfinput message="#message#" type="text" name="start_date"  validate="#validate_style#" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#">
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
									<cfinput message="#message#" type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10"  validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box> 
	<cf_box title="#getLang('','Teminat Yönetimi','51999')#" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="70"><cf_get_lang dictionary_id='52115.Hedef Kodu'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='52048.Eczacı'></th>
					<th><cf_get_lang dictionary_id='58763.Depo'></th>
					<th width="100"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></th>
					<th width="60"><cf_get_lang dictionary_id='57752.Vergi No'></th>
					<th width="70"><cf_get_lang dictionary_id='58638.İlçe'></th>
					<th width="75"><cf_get_lang dictionary_id='58608.İl'></th>
					<th width="70"><cf_get_lang dictionary_id='57756.Durum'></th>
					<th width="50"><cf_get_lang dictionary_id='57630.Tip'></th>
					<th width="100"><cf_get_lang dictionary_id='58689.Teminat'></th>
					<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th width="75"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th width="55"><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th  class="text-center" width="30"><a href="<cfoutput>#request.self#?fuseaction=crm.list_company_securefund&event=add&is_page=1</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
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
						<tr>
							<td>#currentrow#</td>
							<td>#company_id#</td>
							<td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#&is_search=1" class="tableyazi">#left(fullname,50)#</a></td>
							<td>#company_partner_name# #company_partner_surname#</td>
							<td>#get_branch.branch_name[listfind(branch_list,branch_id,',')]#</td>
							<td title="#ims_code_name#">#ims_code#</td>
							<td>#taxno#</td>
							<td>#get_county.county_name[listfind(county_list,county,',')]#</td>
							<td>#get_city.city_name[listfind(city_list,city,',')]#</td>
							<td>#get_process.stage[listfind(process_list,process_cat,',')]#</td>
							<td><cfif give_take eq 0>Alınan<cfelse>Verilen</cfif></td>
							<td>#securefund_cat#</td>
							<td style="text-align:right;">#tlformat(securefund_total)# #money_cat#</td>
							<td>#dateformat(finish_date,dateformat_style)#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil -->
							<td width="15"><a href="#request.self#?fuseaction=crm.list_company_securefund&event=upd&securefund_id=#securefund_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
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
	</cf_box> 
</div>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "&is_submitted=#attributes.is_submitted#">
	<cfif len(attributes.branch_state)>
		<cfset url_str = "#url_str#&branch_state=#attributes.branch_state#">
	</cfif>
	<cfif len(attributes.fullname)>
		<cfset url_str = "#url_str#&fullname=#attributes.fullname#">
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
	<cfif len(attributes.country_id)>
		<cfset url_str = "#url_str#&country_id=#attributes.country_id#">
	</cfif>
	<cfif len(attributes.county_id)>
		<cfset url_str = "#url_str#&county_id=#attributes.county_id#">
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
	<cf_paging page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="crm.list_company_securefund#url_str#">
</cfif>
<script type="text/javascript">
document.search_company.fullname.focus();

function pencere_ac(selfield)
{	
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_company.ims_code_name&field_id=search_company.ims_code_id&is_submitted=1&il_id=' +document.search_company.city.value);
}

function pencere_ac2(no)
{
	x = document.search_company.city.selectedIndex;
	if (document.search_company.city[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='51730.İl Girmelisiniz'> !");
	}
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=search_company.county_id&field_name=search_company.county&city_id=' + document.search_company.city.value);
	}
}

</script>
