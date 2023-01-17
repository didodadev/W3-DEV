<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.country_id" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.comp_cat" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_partner" default="">
<cfparam name="attributes.mem_code" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.search_potential" default="">
<cfparam name="attributes.search_status" default="1">
<cfparam name="attributes.period_id" default="">
<cfparam name="attributes.cpid" default="">
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.record_name" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.company_status" default="">
<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
	SELECT SZ_ID,#dsn#.Get_Dynamic_Language(SZ_ID,'#session.ep.language#','SALES_ZONES','SZ_NAME',null,null,SZ_NAME) AS SZ_NAME ,SZ_HIERARCHY+'_' SZ_HIERARCHY FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		SETUP_PERIOD.PERIOD_ID,
		SETUP_PERIOD.PERIOD
	FROM
		SETUP_PERIOD WITH (NOLOCK),
		OUR_COMPANY WITH (NOLOCK),
		EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK)
	WHERE 
		EPP.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
		EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid# AND IS_MASTER = 1) AND
		SETUP_PERIOD.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
	ORDER BY 
		OUR_COMPANY.COMPANY_NAME,
		SETUP_PERIOD.PERIOD_YEAR
</cfquery>
<cfquery name="GET_COMP" dbtype="query">
	SELECT DISTINCT COMP_ID,COMPANY_NAME FROM GET_PERIOD ORDER BY COMPANY_NAME
</cfquery>
<cfinclude template="../query/get_consumer_value.cfm">
<cfquery name="GET_COMPANY_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
		PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
		PROCESS_TYPE PT WITH (NOLOCK)
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_list_company%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
 <cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_company_cat.cfm">
	<cfset company_cat_list = valuelist(get_companycat.companycat_id,',')>
	<cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
		SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfif isdefined("attributes.cpid") and len(attributes.cpid)>
		<cfscript>
				get_company_list_action = CreateObject("component","V16.member.cfc.get_company");
				get_company_list_action.dsn = dsn;
				get_company = get_company_list_action.get_company_list_fnc(
					cpid : '#iif(isdefined("attributes.cpid"),"attributes.cpid",DE(""))#',
					is_store_followup :'#iif(isdefined("get_ourcmp_info.is_store_followup"),"get_ourcmp_info.is_store_followup",DE(""))#' ,
					get_hierarchies_recordcount : '#iif(isdefined("get_hierarchies.recordcount"),"get_hierarchies.recordcount",DE(""))#' ,
					company_cat_list : '#iif(isdefined("company_cat_list"),"company_cat_list",DE(""))#' ,
					row_block : '#iif((session.ep.our_company_info.sales_zone_followup eq 1),"500",DE(""))#'
				);
		</cfscript>
	<cfelse>
		<cfscript>
				get_company_list_action = CreateObject("component","V16.member.cfc.get_company");
				get_company_list_action.dsn = dsn;
				get_company = get_company_list_action.get_company_list_fnc2(
					cpid : '#iif(isdefined("attributes.cpid"),"attributes.cpid",DE(""))#',
					is_store_followup :'#iif(isdefined("get_ourcmp_info.is_store_followup"),"get_ourcmp_info.is_store_followup",DE(""))#' ,
					get_hierarchies_recordcount : '#iif(isdefined("get_hierarchies.recordcount"),"get_hierarchies.recordcount",DE(""))#' ,
					row_block : '#iif((session.ep.our_company_info.sales_zone_followup eq 1),"500",DE(""))#',
					period_id : '#iif(isdefined("attributes.period_id"),"attributes.period_id",DE(""))#' ,
					responsible_branch_id : '#iif(isdefined("attributes.responsible_branch_id"),"attributes.responsible_branch_id",DE(""))#' ,
					blacklist_status : '#iif(isdefined("attributes.blacklist_status"),"attributes.blacklist_status",DE(""))#' ,
					get_companycat_recordcount : '#iif(isdefined("get_companycat.recordcount"),"get_companycat.recordcount",DE(""))#' ,
					process_stage_type : '#iif(isdefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#' ,
					record_emp : '#iif(isdefined("attributes.record_emp"),"attributes.record_emp",DE(""))#' ,
					record_name : '#iif(isdefined("attributes.record_name"),"attributes.record_name",DE(""))#' ,
					city :'#iif(isdefined("attributes.city"),"attributes.city",DE(""))#' ,
					sales_zones :'#iif(isdefined("attributes.sales_zones"),"attributes.sales_zones",DE(""))#' ,
					sector_cat_id : '#iif(isdefined("attributes.sector_cat_id"),"attributes.sector_cat_id",DE(""))#' ,
					pos_code: '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#' ,
					search_potential: '#iif(isdefined("attributes.search_potential"),"attributes.search_potential",DE(""))#' ,
					is_related_company: '#iif(isdefined("attributes.is_related_company"),"attributes.is_related_company",DE(""))#' ,
					comp_cat: '#iif(isdefined("attributes.comp_cat"),"attributes.comp_cat",DE(""))#' ,
					search_status: '#iif(isdefined("attributes.search_status"),"attributes.search_status",DE(""))#' ,
					customer_value: '#iif(isdefined("attributes.customer_value"),"attributes.customer_value",DE(""))#' ,
					country_id: '#iif(isdefined("attributes.country_id"),"attributes.country_id",DE(""))#' ,
					city_id: '#iif(isdefined("attributes.city_id"),"attributes.city_id",DE(""))#' ,
					county_id: '#iif(isdefined("attributes.county_id"),"attributes.county_id",DE(""))#' ,
					keyword: '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#' ,
					is_sale_purchase: '#iif(isdefined("attributes.is_sale_purchase"),"attributes.is_sale_purchase",DE(""))#' ,
					keyword_partner: '#iif(isdefined("attributes.keyword_partner"),"attributes.keyword_partner",DE(""))#' ,
					database_type: '#iif(isdefined("database_type"),"database_type",DE(""))#',
					get_companycat_companycat_id : '#iif(isdefined("get_companycat.recordcount"),"valuelist(get_companycat.companycat_id,',')",DE(""))#',
					startrow: '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#' ,
					maxrows: '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
					is_fulltext_search: '#iif(isdefined("is_fulltext_search"),"is_fulltext_search",DE(""))#'  
				);
		</cfscript>
	</cfif>
<cfelse>
	<cfset get_company.query_count = 0 >
    <cfset get_company.recordcount = 0 >
</cfif>
<cfparam name="attributes.totalrecords" default='#get_company.query_count#'>

<cfform name="form_list_company" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="29408.Kurumsal Üyeler"></cfsavecontent>
	<cf_big_list_search title="#message#"> 
		<cf_big_list_search_area>
			<table>
				<tr>
					<td><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='57574.Şirket'></td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" style="width:100px;"></td>
					<td><cf_get_lang dictionary_id='30368.Çalışan'>-<cf_get_lang dictionary_id='57571.Ünvan'></td>
					<td><cfinput type="text" name="keyword_partner" value="#attributes.keyword_partner#" maxlength="50" style="width:100px;"></td>
					<td>
						<select name="search_type" id="search_type" style="width:80px;">
							<option value="0" <cfif isDefined('attributes.search_type') and attributes.search_type is 0>selected</cfif>><cf_get_lang dictionary_id='29531.Şirketler'></option>
							<option value="1" <cfif isDefined('attributes.search_type') and attributes.search_type is 1>selected</cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						</select>
						<select name="search_status" id="search_status">
							<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							<option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						</select>
					</td>
					<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
                    <!--- Durgan kapattı.
					<td>
						<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_view_map&allmap=1&search_status=#attributes.search_status#','white_board','popup_view_map')"><img src="/images/gmaps.gif" title="<cf_get_lang_main no='1437.Haritada Göster'>"></a></cfoutput>
					</td>
					--->
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</tr>
			</table>
	</cf_big_list_search_area>
	<cf_big_list_search_detail_area>
		<table> 
			<tr>
				<td>
				<div style="text-align:right;">
					<cf_get_lang dictionary_id ='57899.kaydeden'>
					<input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#attributes.record_emp#</cfoutput>">
					<input type="text" name="record_name" id="record_name" value="<cfoutput>#attributes.record_name#</cfoutput>" style="width:100px;" onFocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp','','3','125');" autocomplete="off">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_list_company.record_emp&field_name=form_list_company.record_name&select_list=1&branch_related','list','popup_list_positions')"><img src="/images/plus_thin.gif"></a>
					<cf_get_lang dictionary_id='57908.Temsilci'>
					<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
					<input name="pos_code_text" type="text" id="pos_code_text" style="width:120px;" onFocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','form_list_company','3','120');" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>" autocomplete="off"><!---onKeyUp="get_emp_pos_1();" tabindex="29"---><!---<cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput>--->
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_list_company.pos_code&field_name=form_list_company.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1','list','popup_list_positions2');return false"><img src="/images/plus_thin.gif"></a>
					<select name="customer_value" id="customer_value" style="width:120px;">
						<option value=""><cf_get_lang dictionary_id='58552.Müşteri Değeri'></option>
						<cfoutput query="get_customer_value">
							<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value>selected</cfif>>#customer_value#</option>
						</cfoutput>
					</select>
					<select name="sales_zones" id="sales_zones" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
						<cfoutput query="get_sales_zones">
							<option value="#sz_hierarchy#" <cfif sz_hierarchy eq attributes.sales_zones> selected</cfif>><cfif ListLen(sz_hierarchy,'.') gt 2>&nbsp;&nbsp;&nbsp;</cfif>#sz_name#</option>
						</cfoutput>
					</select>
					<select name="period_id" id="period_id" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id ='58472.Dönem'></option>
						<cfset totalvalue = 0>
						<cfoutput query="get_comp">
							<cfset totalvalue = totalvalue + 1>
							<cfquery name="GET_PERIODID" dbtype="query">
								SELECT COMP_ID,PERIOD_ID,PERIOD FROM GET_PERIOD WHERE COMP_ID = #comp_id#
							</cfquery>
							<option value="#totalvalue#,0,#comp_id#,0" <cfif len(attributes.period_id) and  listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>#company_name#</option>
							<cfloop query="get_periodid">
								<cfset totalvalue = totalvalue + 1>
								<option value="#totalvalue#,1,#comp_id#,#period_id#" <cfif len(attributes.period_id) and listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>&nbsp;&nbsp;&nbsp;#period#</option>
							</cfloop>
						</cfoutput>
				 	</select>
					<select name="search_potential" id="search_potential" style="width:80px;">
						<option value="" <cfif not len(attributes.search_potential)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.search_potential is 1>selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>
						<option value="0" <cfif attributes.search_potential is 0>selected</cfif>><cf_get_lang dictionary_id='58061.Cari'></option>                
				  	</select>
				</div>
			 	</td>
		  	</tr>
			<tr>
				<td><cf_get_lang dictionary_id='30649.Kara Liste Üyeleri'><input type="checkbox" name="blacklist_status" id="blacklist_status" value="1" <cfif isdefined("attributes.blacklist_status")>checked</cfif>>		
					<select name="country_id" id="country_id" style="width:150px;" onChange="LoadCity(this.value,'city_id','county_id',0);">
						<option value=""><cf_get_lang dictionary_id='58219.Ülke'></option>
						<cfquery name="GET_COUNTRY" datasource="#DSN#">
							SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY 
						</cfquery>
						<cfoutput query="get_country">
							<option value="#country_id#" <cfif attributes.country_id eq country_id>selected</cfif>>#country_name#</option>
						</cfoutput>
					</select>
					<select name="city_id" id="city_id" style="width:132px;" onChange="LoadCounty(this.value,'county_id');">
						<option value=""><cf_get_lang dictionary_id='57971.Şehir'></option>
						<cfif isdefined('attributes.country_id') and len(attributes.country_id)>
							<cfquery name="GET_CITY" datasource="#dsn#">
								SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = #attributes.country_id# ORDER BY CITY_NAME 
							</cfquery>
							<cfoutput query="get_city">
								<option value="#city_id#" <cfif attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
							</cfoutput>
						</cfif>
					</select>
					<select name="county_id" id="county_id" style="width:150px;">
					<option value=""><cf_get_lang dictionary_id='58638.İlçe'></option>
						<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
							<cfquery name="get_county" datasource="#DSN#">
								SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = #attributes.city_id# ORDER BY COUNTY_NAME
							</cfquery>
							<cfoutput query="get_county">
								<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
							</cfoutput>
						</cfif>
					</select>
					<select name="process_stage_type" id="process_stage_type" style="width:120px;">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_company_stage">
							<option value="#process_row_id#" <cfif attributes.process_stage_type eq get_company_stage.process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
				  	</select>
					<cfsavecontent variable="text"><cf_get_lang dictionary_id='30560.Sektör Seçiniz'></cfsavecontent>
					<cf_wrk_selectlang
						 name="sector_cat_id"
						 table_name="SETUP_SECTOR_CATS"
						 option_name="SECTOR_CAT"
						 option_text="#text#"
						 option_value="SECTOR_CAT_ID"
						 value="#attributes.sector_cat_id#"
						 sort_type="SECTOR_CAT"
						 width="150">
					<cfsavecontent variable="text2"><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></cfsavecontent>
					 <cf_wrk_MemberCat
									name="comp_cat"
									option_text="#text2#"
									value="#attributes.comp_cat#"
									comp_cons=1>
				  	<select name="is_sale_purchase" id="is_sale_purchase" style="width:80px;">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 1>selected</cfif>><cf_get_lang dictionary_id='58733.Alıcı'></option>
						<option value="2" <cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 2>selected</cfif>><cf_get_lang dictionary_id='58873.Satıcı'></option>
				  	</select>
				</td>
			</tr>
		</table>
</cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
<thead>
	<tr>
    	<th><cf_get_lang dictionary_id="58577.Sıra"></th>
		<th nowrap="nowrap"><cf_get_lang dictionary_id='57558.Üye No'></th>
		<th nowrap="nowrap"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
		<th><cf_get_lang dictionary_id='57574.Şirket'></th>
		<th width="120"><cf_get_lang dictionary_id='57486.Kategori'></th>
		<th width="120"><cf_get_lang dictionary_id='29511.Yönetici'></th>
		<!---<th width="120"><cf_get_lang_main no='487.Kaydeden'></th>--->
		<th width="120"><cf_get_lang dictionary_id ='57971.Şehir'></th>
		<th width="120"><cf_get_lang dictionary_id='57908.Temsilci'></th>
		<th width="65"><cf_get_lang dictionary_id='57577.Potansiyel'></th>
		<!---<th class="header_icn_text" nowrap="nowrap"><cf_get_lang_main no ='163.Üye Bilgileri'></th>
		<th class="header_icn_text"><cf_get_lang_main no='41.Şube'></th>
		<th class="header_icn_text"><cf_get_lang_main no='2034.Kişi'></th>--->
		<!--- finans module kullanılıyorsa ve kullanıcının finance modulunde yetkisi varsa cari hesap görülebilir--->
		<!---<cfif get_module_user(16)>
			<th style="text-align:right;"><cf_get_lang_main no='177.Bakiye'></th>
		</cfif>--->
	</tr>
	</thead>
	<tbody>
		<cfif get_company.recordcount>
			<cfset partner_id_list = ''>
			<cfset company_id_list = ''>
			<cfset company_cat_id_list = ''>
			<cfset pos_code_list = ''>
			<cfset city_list = ''>
			<cfset company_status_list=''>
			<!---<cfset record_emp_list =''>--->
			<cfoutput query="get_company">
				<cfif len(manager_partner_id) and manager_partner_id neq 0>
					<cfset partner_id_list = listappend(partner_id_list,manager_partner_id)>
				</cfif>
				<!---<cfif len(record_emp) and not listfind(record_emp_list,record_emp)>
					<cfset record_emp_list =listappend(record_emp_list,record_emp)>
				<cfelseif len(record_par) and not listfind (partner_id_list,record_par)>
					<cfset partner_id_list = listappend(partner_id_list,record_par)>
				</cfif>--->
				<cfif not listfind(company_id_list,company_id)>
					<cfset company_id_list = listappend(company_id_list,company_id)>
				</cfif>
				<cfif not listfind(company_cat_id_list,companycat_id)>
					<cfset company_cat_id_list = listappend(company_cat_id_list,companycat_id)>
				</cfif>
				<cfif len(position_code) and not listfind(pos_code_list,position_code)>
					<cfset pos_code_list = listappend(pos_code_list,position_code)>
				</cfif>
				<cfif len(company_status) and not listfind(company_status_list,company_status)>
					<cfset company_status_list = listappend(company_status_list,company_status)>
				</cfif>
				<cfif len(city) and not listfind(city_list,city)>
					<cfset city_list = listappend(city_list,city)>
				</cfif>
			</cfoutput>
			<cfif listlen(partner_id_list)>
				<cfquery name="GET_PARTNER" datasource="#DSN#">
					SELECT
						COMPANY_PARTNER.COMPANY_PARTNER_NAME,
						COMPANY_PARTNER.PARTNER_ID,
						COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
						COMPANY.NICKNAME,
						COMPANY.COMPANY_ID
					FROM
						COMPANY_PARTNER,
						COMPANY
					WHERE
						COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
						COMPANY_PARTNER.PARTNER_ID IN (#partner_id_list#)
					ORDER BY
						COMPANY_PARTNER.PARTNER_ID
				</cfquery>
				<cfset partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<!---<cfif get_module_user(16) and len(company_id_list)>
				<cfquery name="GET_BAKIYE" datasource="#DSN2#">
					SELECT
						BAKIYE,
						COMPANY_ID
					FROM
						COMPANY_REMAINDER
					WHERE
						COMPANY_ID IN (#company_id_list#)
						ORDER BY COMPANY_ID
				</cfquery>
				<cfset company_id_list=listsort(valuelist(get_bakiye.company_id,','),"numeric","ASC",",")>
			</cfif>
			<cfif len(record_emp_list)>
				<cfset record_emp_list=listsort(record_emp_list,"numeric","ASC",",")>
				<cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
					SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				 <cfset record_emp_list=listsort(valuelist(get_emp_detail.employee_id,','),"numeric","ASC",",")> 
			</cfif>--->
			<cfif len(pos_code_list)>
				<cfset pos_code_list=listsort(pos_code_list,"numeric","ASC",",")>			
				<cfquery name="GET_POS_CODE" datasource="#DSN#">
					SELECT
						POSITION_CODE,
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME,
						EMPLOYEE_ID
					FROM
						EMPLOYEE_POSITIONS
					WHERE
						POSITION_STATUS = 1 AND
						POSITION_CODE IN (#pos_code_list#)
					ORDER BY
						POSITION_CODE
				</cfquery>
				<cfset pos_code_list=listsort(valuelist(get_pos_code.position_code,','),"numeric","ASC",",")>
			</cfif>
			<cfif len(company_cat_id_list)>
				<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
					SELECT
						COMPANYCAT_ID,
						COMPANYCAT
					FROM
						COMPANY_CAT
					WHERE
						COMPANYCAT_ID IN (#company_cat_id_list#)
					ORDER BY
						COMPANYCAT_ID
				</cfquery>
				<cfset company_cat_id_list=listsort(valuelist(get_company_cat.companycat_id,','),"numeric","ASC",",")>
			</cfif>
			<cfif len(city_list)>
				<cfquery name="GET_COMPANY_CITY" datasource="#DSN#">
					SELECT
						CITY_ID,
						CITY_NAME
					FROM
						SETUP_CITY
					WHERE
						CITY_ID IN (#city_list#)
					ORDER BY
						CITY_ID
				</cfquery>
				<cfset city_list=listsort(valuelist(get_company_city.city_id,','),"numeric","ASC",",")>
			</cfif>
		  <cfoutput query="get_company">
			<tr>
            	<td>#currentrow#</td>
				<td width="50">#member_code#</td>
				<td>#ozel_kod#</td>
				<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
				<td>#get_company_cat.companycat[listfind(company_cat_id_list,get_company.companycat_id,',')]# </td>
				<td>
					<cfif len(manager_partner_id)>
						<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=updPartner&pid=#manager_partner_id#" class="tableyazi">#get_partner.company_partner_name[listfind(partner_id_list,manager_partner_id,',')]#  #get_partner.company_partner_surname[listfind(partner_id_list,manager_partner_id,',')]#</a>
					<cfelse>
						<cf_get_lang dictionary_id='30405.Tanımlı Değil'>
					</cfif>
				</td>
				<!---<td>
				<cfif len(record_emp)>
					<a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#RECORD_EMP#','medium','popup_emp_det');">#get_emp_detail.EMPLOYEE_NAME[listfind(record_emp_list,RECORD_EMP,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(record_emp_list,RECORD_EMP,',')]#</a>
				<cfelseif len(record_par)> 
					<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner.COMPANY_ID[listfind(partner_id_list,RECORD_PAR,',')]#','medium','popup_com_det');">#get_partner.NICKNAME[listfind(partner_id_list,RECORD_PAR,',')]# - #get_partner.COMPANY_PARTNER_NAME[listfind(partner_id_list,RECORD_PAR,',')]# #get_partner.COMPANY_PARTNER_SURNAME[listfind(partner_id_list,RECORD_PAR,',')]#</a>
				</cfif>
				</td>--->
				<td><cfif len(city_list)>#get_company_city.city_name[listfind(city_list,city,',')]#</cfif></td>
				<td>
					<cfif len(position_code)>
						<cfset pos_list_sira = listfind(pos_code_list,get_company.position_code,',')>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_pos_code.employee_id[pos_list_sira]#','medium','popup_emp_det')" class="tableyazi">#get_pos_code.employee_name[listfind(pos_code_list,position_code,',')]# #get_pos_code.employee_surname[listfind(pos_code_list,position_code,',')]#</a>
					<cfelse>
						<cf_get_lang dictionary_id='30405.Tanımlı Değil'>
					</cfif>
				</td>
				<td><cfif ispotantial eq 1><cf_get_lang dictionary_id='57577.Potansiyel'><cfelse><cf_get_lang dictionary_id='58061.Cari'></cfif></td>
				<!---<!-- sil -->
				<td align="center"><a href="#request.self#?fuseaction=myhome.my_company_details&cpid=#company_id#"><img src="/images/cubexport.gif" title="<cf_get_lang_main no='163.Üye Bilgileri'>"></a></td>
				<td align="center"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_branch&cpid=#company_id#"><img src="/images/branch_plus.gif" title="<cf_get_lang no='53.Şube Ekle'>"></a></td>
				<td align="center"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_partner&comp_cat=#companycat_id#&compid=#company_id#"><img src="/images/partner_plus.gif" title="<cf_get_lang no='52.Kişi Ekle'>"></a></td>
				<!-- sil -->
				<cfif get_module_user(16)>
					<cfset bakiye=get_bakiye.bakiye[listfind(company_id_list,get_company.company_id,',')]>
					<cfif not len(bakiye)><cfset bakiye=0></cfif>
				<td  style="text-align:right;">#TLFormat(Abs(bakiye))# #session.ep.money#<cfif bakiye lte 0>(A)<cfelse>(B)</cfif></td>
				</cfif>--->
			</tr>
			</cfoutput>
			<!-- sil -->
		  <cfelse>
			<tr>
				<td colspan="14"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
			</tr>
		  </cfif>
	</tbody>
</cf_big_list>
<cfset adres = attributes.fuseaction>
<cfset adres = adres&"&search_status="&attributes.search_status>
<cfset adres = adres&"&search_potential="&attributes.search_potential>
<cfif len(attributes.keyword)>
	<cfset adres = adres&"&keyword="&attributes.keyword>
</cfif>
<cfif len(attributes.keyword_partner)>
	<cfset adres = adres&"&keyword_partner="&attributes.keyword_partner>
</cfif>
<cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>
	<cfset adres = adres&"&comp_cat="&attributes.comp_cat>
</cfif>
<cfif isDefined("attributes.company_status") and len(attributes.company_status)>
	<cfset adres = adres&"&company_status="&attributes.company_status>
</cfif>
<cfif isDefined("attributes.country_id") and len(attributes.country_id)>
	<cfset adres = adres&"&country_id="&attributes.country_id>
</cfif>
<cfif isDefined("attributes.city_id") and len(attributes.city_id)>
	<cfset adres = adres&"&city_id="&attributes.city_id>
</cfif>
<cfif isDefined("attributes.county_id") and len(attributes.county_id)>
	<cfset adres = adres&"&county_id="&attributes.county_id>
</cfif> 
<cfif isDefined("attributes.sales_zones") and len(attributes.sales_zones)>
	<cfset adres = adres&"&sales_zones="&attributes.sales_zones>
</cfif>
<cfif isDefined("attributes.pos_code") and len(attributes.pos_code)>
	<cfset adres = adres&"&pos_code="&attributes.pos_code>
</cfif>
<cfif isDefined("attributes.pos_code_text") and len(attributes.pos_code_text)>
	<cfset adres = adres&"&pos_code_text="&attributes.pos_code_text>
</cfif>
<cfif isDefined("attributes.mem_code") and len(attributes.mem_code)>
	<cfset adres = adres&"&mem_code="&attributes.mem_code>
</cfif>
<cfif isDefined("attributes.record_emp") and len(attributes.record_emp)>
	<cfset adres = adres&"&record_emp="&attributes.record_emp>
</cfif>
<cfif isDefined("attributes.record_name") and len(attributes.record_name)>
	<cfset adres = adres&"&record_name="&attributes.record_name>
</cfif>
<cfif isDefined("attributes.search_type") and len(attributes.search_type)>
	<cfset adres = adres&"&search_type="&attributes.search_type>
</cfif>
<cfif isDefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>
	<cfset adres = adres&"&sector_cat_id="&attributes.sector_cat_id>
</cfif>
<cfif isDefined("attributes.responsible_branch_id") and len(attributes.responsible_branch_id)>
	<cfset adres = adres&"&responsible_branch_id="&attributes.responsible_branch_id>
</cfif>
<cfif isDefined("attributes.customer_value") and len(attributes.customer_value)>
	<cfset adres = adres&"&customer_value="&attributes.customer_value>
</cfif>
<cfif len(attributes.process_stage_type)>
	<cfset adres = adres&"&process_stage_type="&attributes.process_stage_type>
</cfif>
<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfset adres = adres&"&period_id="&attributes.period_id>
</cfif>
<cfif isdefined("attributes.is_sale_purchase") and len(attributes.is_sale_purchase)>
	<cfset adres = adres&"&is_sale_purchase="&attributes.is_sale_purchase>
</cfif>
<cfif isDefined("attributes.form_submitted")>
	<cfset adres = adres&"&form_submitted=1">
</cfif>
<cfif isdefined("attributes.blacklist_status") and len(attributes.blacklist_status)>
	<cfset adres = adres&"&blacklist_status="&attributes.blacklist_status>
</cfif>
<cf_paging 
page="#attributes.page#" 
maxrows="#attributes.maxrows#" 
totalrecords="#attributes.totalrecords#" 
startrow="#attributes.startrow#" 
adres="#adres#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<cfsetting showdebugoutput="yes">
