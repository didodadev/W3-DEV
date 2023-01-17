<cf_get_lang_set module_name="member"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="member.list_company">
<cfparam name="attributes.watalogy_code" default="">
<cfparam name="attributes.marketplace" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.country_id" default="">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.comp_cat" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.is_sale_purchase" default="">
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
<cfparam name="attributes.use_efatura" default="">
<cfparam name="attributes.tax_no" default="">
<cfparam name="attributes.tc_identity" default="">
<cfparam name="attributes.private_code" default="">
<cfset company_cmp = CreateObject("component","V16.member.cfc.member_company")>
<cfset GET_SALES_ZONES = company_cmp.GET_SALES_ZONES()>
<cfset GET_PERIOD = company_cmp.GET_PERIOD()>
<cfset GET_COMP = company_cmp.GET_COMP()>
<cfset GET_CUSTOMER_VALUE = company_cmp.GET_CUSTOMER_VALUE()>
<cfset GET_COMPANY_STAGE = company_cmp.GET_COMPANY_STAGE()>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset GET_OURCMP_INFO = company_cmp.GET_OURCMP_INFO()>
<cfif isdefined("attributes.form_submitted")>
	<cfset GET_COMPANYCAT = company_cmp.GET_COMPANYCAT()>
	<cfset company_cat_list = valuelist(get_companycat.companycat_id,',')>

	<cfscript>
			get_company = company_cmp.get_company_list_fnc2(
				cpid : '#iif(isdefined("attributes.cpid"),"attributes.cpid",DE(""))#',
				is_store_followup :'#iif(isdefined("get_ourcmp_info.is_store_followup"),"get_ourcmp_info.is_store_followup",DE(""))#' ,
				row_block : '#iif((session.ep.our_company_info.sales_zone_followup eq 1),"500",DE(""))#',
				period_id : '#iif(isdefined("attributes.period_id"),"attributes.period_id",DE(""))#' ,
				responsible_branch_id : '#iif(isdefined("attributes.responsible_branch_id"),"attributes.responsible_branch_id",DE(""))#' ,
				blacklist_status : '#iif(isdefined("attributes.blacklist_status"),"attributes.blacklist_status",DE(""))#' ,
				get_companycat_recordcount : '#iif(isdefined("get_companycat.recordcount"),"get_companycat.recordcount",DE(""))#' ,
				process_stage_type : '#iif(isdefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#' ,
				record_emp : '#iif(isdefined("attributes.record_emp"),"attributes.record_emp",DE(""))#' ,
				record_name : '#iif(isdefined("attributes.record_name"),"attributes.record_name",DE(""))#' ,
				pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#' ,
				pos_code_text : '#iif(isdefined("attributes.pos_code_text"),"attributes.pos_code_text",DE(""))#' ,
				city :'#iif(isdefined("attributes.city"),"attributes.city",DE(""))#' ,
				sales_zones :'#iif(isdefined("attributes.sales_zones"),"attributes.sales_zones",DE(""))#' ,
				sector_cat_id : '#iif(isdefined("attributes.sector_cat_id"),"attributes.sector_cat_id",DE(""))#' ,				
				search_potential: '#iif(isdefined("attributes.search_potential"),"attributes.search_potential",DE(""))#' ,
				is_related_company: '#iif(isdefined("attributes.is_related_company"),"attributes.is_related_company",DE(""))#' ,
				comp_cat: '#iif(isdefined("attributes.comp_cat"),"attributes.comp_cat",DE(""))#' ,
				search_status: '#iif(isdefined("attributes.search_status"),"attributes.search_status",DE(""))#' ,
				customer_value: '#iif(isdefined("attributes.customer_value"),"attributes.customer_value",DE(""))#' ,
				country_id: '#iif(isdefined("attributes.country_id"),"attributes.country_id",DE(""))#' ,
				city_id: '#iif(isdefined("attributes.city_id"),"attributes.city_id",DE(""))#' ,
				county_id: '#iif(isdefined("attributes.county_id"),"attributes.county_id",DE(""))#' ,
				keyword: '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#' ,
				is_sale_purchase: '#iif(isdefined("attributes.is_sale_purchase"),"attributes.is_sale_purchase",DE(""))#',
				keyword_partner: '#iif(isdefined("attributes.keyword_partner"),"attributes.keyword_partner",DE(""))#',
				database_type: '#iif(isdefined("database_type"),"database_type",DE(""))#',
				get_companycat_companycat_id : '#iif(isdefined("get_companycat.recordcount"),"valuelist(get_companycat.companycat_id,',')",DE(""))#',
				maxrows: '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
				startrow:'#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
				is_fulltext_search: '#iif(isdefined("is_fulltext_search"),"is_fulltext_search",DE(""))#',
				watalogy_code: '#iif(len(attributes.watalogy_code),"attributes.watalogy_code",DE(""))#',
				marketplace: '#iif(len(attributes.marketplace),"attributes.marketplace",DE(""))#',
				use_efatura: '#iif(len(attributes.use_efatura),"attributes.use_efatura",DE(""))#',
				tax_no: '#iif(len(attributes.tax_no),"attributes.tax_no",DE(""))#',
				tc_identity: '#iif(len(attributes.tc_identity),"attributes.tc_identity",DE(""))#',
				private_code: '#iif(len(attributes.private_code),"attributes.private_code",DE(""))#'
			);
	</cfscript>
<cfelse>
	<cfset get_company.recordcount = 0 >
</cfif>
<cfif get_company.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_company.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form_list_company" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<input type="hidden" name="company_id" id="company_id" value="">
			<cf_box_search> 
				<cfoutput>
					<div class="form-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="58585.Kod"> - <cf_get_lang dictionary_id="57574.Şirket"></cfsavecontent>
						<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
					</div>
					<div class="form-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57789.Özel Kod"></cfsavecontent>
						<cfinput type="text" name="private_code" value="#attributes.private_code#" maxlength="50" placeholder="#message#">
					</div>
					<cfif  GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1>
						<div class="form-group">
							<cfinput type="text" name="watalogy_code" id="watalogy_code" value="#attributes.watalogy_code#" placeholder="#getLang('','Watalogy kod',63801)#">
						</div>
					</cfif>
					<div class="form-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="30368.Çalışan"> - <cf_get_lang dictionary_id="57571.Ünvan"></cfsavecontent>
						<cfinput type="text" name="keyword_partner" value="#attributes.keyword_partner#" maxlength="50" placeholder="#message#">
					</div>
					<div class="form-group">
						<select name="search_type" id="search_type">
							<option value="0" <cfif isDefined('attributes.search_type') and attributes.search_type is 0>selected</cfif>><cf_get_lang dictionary_id='29531.Şirketler'></option>
							<option value="1" <cfif isDefined('attributes.search_type') and attributes.search_type is 1>selected</cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						</select>
						
					</div>
					<div class="form-group">
						<select name="search_status" id="search_status">
							<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							<option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</div>
				</cfoutput>
			</cf_box_search> 	
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-record_name">
						<label class="col col-12"><cf_get_lang dictionary_id ='57899.kaydeden'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#attributes.record_emp#</cfoutput>">
								<input type="text" name="record_name" id="record_name" value="<cfoutput>#attributes.record_name#</cfoutput>" style="width:100px;" onfocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp','','3','125');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_list_company.record_emp&field_name=form_list_company.record_name&select_list=1&branch_related','list','popup_list_positions')"></span>
							</div>
							
						</div>
					</div>
					<div class="form-group" id="item-pos_code_text">
						<label class="col col-12"><cf_get_lang dictionary_id='57908.Temsilci'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
								<input name="pos_code_text" type="text" id="pos_code_text" style="width:120px;" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','form_list_company','3','120');" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>" autocomplete="off"><!---onKeyUp="get_emp_pos_1();" tabindex="29"---><!---<cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput>--->
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_list_company.pos_code&field_name=form_list_company.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1','list','popup_list_positions2');return false"></span>
							</div>
							
						</div>
					</div>
					<div class="form-group" id="item-customer_value">
						<label class="col col-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
						<div class="col col-12">
							<select name="customer_value" id="customer_value" style="width:120px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_customer_value">
									<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value>selected</cfif>>#customer_value#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-sales_zones">
						<label class="col col-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
						<div class="col col-12">
							<select name="sales_zones" id="sales_zones" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_sales_zones">
									<option value="#sz_hierarchy#" <cfif sz_hierarchy eq attributes.sales_zones> selected</cfif>><cfif ListLen(sz_hierarchy,'.') gt 2>&nbsp;&nbsp;&nbsp;</cfif>#sz_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<cfif  GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1>
						<div class="form-group" id="item-marketplaces">
							<label class="col col-12"><cf_get_lang dictionary_id='61344.Marketplaces'></label>
							<div class="col col-12">
								<cfset wrk = createObject("component","V16.worknet.cfc.worknet")>
								<cfset get_all_marketplace = wrk.select(status : 1)>
								<select name="marketplace" id="get_all_marketplace">
									<option value=""><cf_get_lang dictionary_id='61344.Marketplaces'></option>
									<cfoutput query="get_all_marketplace">
										<option value="#WORKNET_ID#" <cfif attributes.marketplace eq WORKNET_ID>selected</cfif>>#WORKNET#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-country_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-12">
							<select name="country_id" id="country_id" style="width:150px;" onchange="LoadCity(this.value,'city_id','county_id',0);">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfset GET_COUNTRY = company_cmp.GET_COUNTRY()>
								<cfoutput query="get_country">
									<option value="#country_id#" <cfif attributes.country_id eq country_id>selected</cfif>>#country_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-city_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<div class="col col-12">
							<select name="city_id" id="city_id" style="width:132px;" onchange="LoadCounty(this.value,'county_id');">
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
					<div class="form-group" id="item-county_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-12">
							<select name="county_id" id="county_id"  style="width:150px;">
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
					<div class="form-group" id="item-process_stage_type">
						<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
						<div class="col col-12">
							<select name="process_stage_type" id="process_stage_type" style="width:120px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_company_stage">
									<option value="#process_row_id#" <cfif attributes.process_stage_type eq get_company_stage.process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-sector_cat_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
						<div class="col col-12">
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
						</div>
					</div>
					<div class="form-group" id="item-search_potential">
						<label class="col col-12"><cf_get_lang dictionary_id='58061.Cari'> <cf_get_lang dictionary_id='30152.Tipi'></label>
						<div class="col col-12">
						<select name="search_potential" id="search_potential" style="width:80px;">
						<option value="" <cfif not len(attributes.search_potential)>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="1" <cfif attributes.search_potential is 1>selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>
						<option value="0" <cfif attributes.search_potential is 0>selected</cfif>><cf_get_lang dictionary_id='58061.Cari'></option>                
						</select>
						</div>
					</div>
					<div class="form-group" id="item-use_efatura">
						<label class="col col-12"><cf_get_lang dictionary_id="29872.E-Fatura"></label>
						<div class="col col-12">
							<select name="use_efatura" id="use_efatura">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='29492.Kullanıyor'></option>
								<option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='29493.Kullanmıyor'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-tc_identity">
						<label class="col col-12"><cf_get_lang dictionary_id='58025.TC Kimlik No'></label>
						<div class="col col-12">
							<input type="text" name="tc_identity" id="tc_identity" value="<cfoutput>#attributes.tc_identity#</cfoutput>" maxlength="11">
						</div>
					</div>					
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-is_sale_purchase">
						<label class="col col-12"><cf_get_lang dictionary_id='31097.Üye Tipi'></label>
						<div class="col col-12">
						<select name="is_sale_purchase" id="is_sale_purchase" style="width:80px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 1>selected</cfif>><cf_get_lang dictionary_id='58733.Alıcı'></option>
							<option value="2" <cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 2>selected</cfif>><cf_get_lang dictionary_id='58873.Satıcı'></option>
						</select>
						</div>
					</div>
					<div class="form-group" id="item-comp_cat">
						<label class="col col-12"><cf_get_lang dictionary_id='58137.Kategoriler'></label>
						<div class="col col-12">
						<cfsavecontent variable="text2"><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></cfsavecontent>
						<cf_wrk_membercat
							name="comp_cat"
							option_text="#text2#"
							value="#attributes.comp_cat#"
							comp_cons=1>
						</div>
					</div>
					<div class="form-group" id="item-tax_no">
						<label class="col col-12"><cf_get_lang dictionary_id='57752.VergiNo'></label>
						<div class="col col-12">
						<input type="text" name="tax_no" id="tax_no" value="<cfoutput>#attributes.tax_no#</cfoutput>" maxlength="10" />
						</div>
					</div>
					<div class="form-group" id="item-period_id">
						<label class="col col-12"><cf_get_lang dictionary_id ='58472.Dönem'></label>
						<div class="col col-12">
						<select name="period_id" id="period_id" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfset totalvalue = 0>
						<cfoutput query="get_comp">
							<cfset totalvalue = totalvalue + 1>
							<cfset GET_PERIODID = company_cmp.GET_PERIODID(comp_id:comp_id)>
							<option value="#totalvalue#,0,#comp_id#,0" <cfif len(attributes.period_id) and  listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>#company_name#</option>
							<cfloop query="get_periodid">
								<cfset totalvalue = totalvalue + 1>
								<option value="#totalvalue#,1,#comp_id#,#period_id#" <cfif len(attributes.period_id) and listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>&nbsp;&nbsp;&nbsp;#period#</option>
							</cfloop>
						</cfoutput>
						</select>
						</div>
					</div>
					<div class="form-group" id="item-blacklist_status">
						<label class="col col-12 hide"><cf_get_lang dictionary_id='30649.Kara Liste Üyeleri'></label>
						<div class="col col-12">
						<label><cf_get_lang dictionary_id='30649.Kara Liste Üyeleri'><input type="checkbox" name="blacklist_status" id="blacklist_status" value="1" <cfif isdefined("attributes.blacklist_status")>checked</cfif>></label>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="47167.Kurumsal Hesaplar"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_company_id',  print_type : 127 }#">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57558.Üye No'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<cfif GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1><th><cf_get_lang dictionary_id='63801.Watalogy'></th></cfif>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='30367.Yonetici'></th>
					<th><cf_get_lang dictionary_id='57971.Şehir'></th>
					<cfif xml_county_id eq 1>
					<th><cf_get_lang dictionary_id='58638.İlçe'></th>
					</cfif>
					<cfif xml_semt eq 1>
					<th><cf_get_lang dictionary_id='58132.Semt'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57908.Temsilci'></th>
					<th><cf_get_lang dictionary_id='57577.Potansiyel'></th>
					<!--- Ömer Turhan tarafından kaldırıldı.
					<!-- sil --><th width="70" class="header_icn_text" nowrap="nowrap"><cf_get_lang_main no ='163.Üye Bilgileri'></th><!-- sil -->
					<!--- finans module kullanılıyorsa ve kullanıcının finance modulunde yetkisi varsa cari hesap görülebilir--->
					--->
					<cfif get_module_user(16) and fusebox.use_period eq true>
						<th><cf_get_lang dictionary_id='57589.Bakiye'></th>
					</cfif>
					<cfif GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1><th style="width:20px;" title="<cf_get_lang dictionary_id='61344.Marketplaces'>"><a href="javascript://"><i class="icon-globe"></i></a></th></cfif>					
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=member.form_list_company&event=add"><i class="fa fa-plus" 
						title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<cfif isdefined("attributes.form_submitted") and get_company.recordcount >
								<th width="20" class="text-center header_icn_none">
								
                                <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_company_id');">
                            
					</th>	
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_company.recordcount>
					<cfset partner_id_list = ''>
					<cfset company_id_list = ''>
					<cfset company_cat_id_list = ''>
					<cfset pos_code_list = ''>
					<cfset city_list = ''>
					<cfset county_list = ''>
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
						</cfif>
						--->
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
						<cfif len(county) and not listfind(county_list,county)>
							<cfset county_list = listappend(county_list,county)>
						</cfif>
					</cfoutput>
					<cfif listlen(partner_id_list)>
						<cfset GET_PARTNER = company_cmp.GET_PARTNER(partner_id_list:partner_id_list)>
						<cfset partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner.partner_id,',')),'numeric','ASC',',')>
					</cfif>
				
					<cfif get_module_user(16) and len(company_id_list) and fusebox.use_period eq true>
						<cfset GET_BAKIYE = company_cmp.GET_BAKIYE(company_id_list:company_id_list, dsn2:dsn2)>
						<cfset company_id_list=listsort(valuelist(get_bakiye.company_id,','),"numeric","ASC",",")>
					</cfif>
					<!---
					<cfif len(record_emp_list)>
						<cfset record_emp_list=listsort(record_emp_list,"numeric","ASC",",")>
						<cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
							SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset record_emp_list=listsort(valuelist(get_emp_detail.employee_id,','),"numeric","ASC",",")> 
					</cfif>
					--->
					<cfif len(pos_code_list)>
						<cfset pos_code_list=listsort(pos_code_list,"numeric","ASC",",")>			
						<cfset GET_POS_CODE = company_cmp.GET_POS_CODE(pos_code_list:pos_code_list)>
						<cfset pos_code_list=listsort(valuelist(get_pos_code.position_code,','),"numeric","ASC",",")>
					</cfif>
					<cfif len(company_cat_id_list)>
						<cfset GET_COMPANY_CAT = company_cmp.GET_COMPANY_CAT(company_cat_id_list:company_cat_id_list)>
						<cfset company_cat_id_list=listsort(valuelist(get_company_cat.companycat_id,','),"numeric","ASC",",")>
					</cfif>
					<cfif len(city_list)>
						<cfset GET_COMPANY_CITY = company_cmp.GET_COMPANY_CITY(city_list:city_list)>
						<cfset city_list=listsort(valuelist(get_company_city.city_id,','),"numeric","ASC",",")>
					</cfif>
					<cfif len(county_list) and xml_county_id eq 1>
						<cfset GET_COMPANY_COUNTY = company_cmp.GET_COMPANY_COUNTY(county_list:county_list)>
						<cfset county_list=listsort(valuelist(get_company_county.county_id,','),"numeric","ASC",",")>
					</cfif>
					<cfoutput query="get_company">
						<tr>
							<td width="40">#rownum#</td>
							<td width="50">#member_code#</td>
							<td>#ozel_kod#</td>
							<cfif GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1><td>#WATALOGY_MEMBER_CODE#</td></cfif>							
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=det&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
							<td>#get_company_cat.companycat[listfind(company_cat_id_list,get_company.companycat_id,',')]# </td>
							<td>
								<cfif len(manager_partner_id)>
									<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_contact&event=upd&pid=#manager_partner_id#" class="tableyazi">#get_partner.company_partner_name[listfind(partner_id_list,manager_partner_id,',')]#  #get_partner.company_partner_surname[listfind(partner_id_list,manager_partner_id,',')]#</a>
								<cfelse>
									<cf_get_lang dictionary_id='30405.Tanımlı Değil'>
								</cfif>
							</td>
							<!---
							<td>
								<cfif len(record_emp)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#RECORD_EMP#','medium','popup_emp_det');">#get_emp_detail.EMPLOYEE_NAME[listfind(record_emp_list,RECORD_EMP,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(record_emp_list,RECORD_EMP,',')]#</a>
								<cfelseif len(record_par)> 
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner.COMPANY_ID[listfind(partner_id_list,RECORD_PAR,',')]#','medium','popup_com_det');">#get_partner.NICKNAME[listfind(partner_id_list,RECORD_PAR,',')]# - #get_partner.COMPANY_PARTNER_NAME[listfind(partner_id_list,RECORD_PAR,',')]# #get_partner.COMPANY_PARTNER_SURNAME[listfind(partner_id_list,RECORD_PAR,',')]#</a>
								</cfif>
							</td>
							--->
							<td><cfif len(city_list)>#get_company_city.city_name[listfind(city_list,city,',')]#</cfif></td>
							<cfif xml_county_id eq 1>
							<td><cfif len(county_list)>#get_company_county.county_name[listfind(county_list,county,',')]#</cfif></td>
							</cfif>
							<cfif xml_semt eq 1>
							<td><cfif len(semt)>#semt#</cfif></td>
							</cfif>
							<td>
								<cfif len(position_code)>
									<cfset pos_list_sira = listfind(pos_code_list,get_company.position_code,',')>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_pos_code.employee_id[pos_list_sira]#','medium','popup_emp_det')" class="tableyazi">#get_pos_code.employee_name[listfind(pos_code_list,position_code,',')]# #get_pos_code.employee_surname[listfind(pos_code_list,position_code,',')]#</a>
								<cfelse>
									<cf_get_lang dictionary_id='30405.Tanımlı Değil'>
								</cfif>
							</td>
							<td><cfif ispotantial eq 1><cf_get_lang dictionary_id='57577.Potansiyel'><cfelse><cf_get_lang dictionary_id='58061.Cari'></cfif></td>
							<!--- Ömer Turhan tarafından kaldırıldı. Query temizlenecek.
							<!-- sil -->
							<td nowrap="nowrap">
								<a href="#request.self#?fuseaction=myhome.my_company_details&cpid=#company_id#"><img src="/images/cubexport.gif" title="<cf_get_lang_main no='163.Üye Bilgileri'>"></a>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_branch&cpid=#company_id#"><img src="/images/branch_plus.gif" title="<cf_get_lang no='53.Şube Ekle'>" width="17" height="21"></a>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_partner&comp_cat=#companycat_id#&compid=#company_id#"><img src="/images/partner_plus.gif" title="<cf_get_lang no='52.Kişi Ekle'>" width="19" height="21"></a>
							</td>
							<!-- sil -->
							--->
							<cfif get_module_user(16) and fusebox.use_period eq true>
								<cfset bakiye=get_bakiye.bakiye[listfind(company_id_list,get_company.company_id,',')]>
								<cfif not len(bakiye)><cfset bakiye=0></cfif>
								<td style="text-align:right;"><span>#TLFormat(Abs(bakiye))#</span><span>#session.ep.money#</span><cfif bakiye lte 0>(A)<cfelse>(B)</cfif></td>
							</cfif>	 
							<!-- sil -->
							<cfif GET_OURCMP_INFO.IS_WATALOGY_INTEGRATED eq 1>
								<td>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=worknet.form_list_company&event=popup_addWorknetRelation&cpid=#company_id#&form_submitted=1&draggable=1&logo_list=1','','ui-draggable-box-small')"><i class="icon-globe"></i></a>
								</td>
							</cfif>
							
							<td align="center">	
							<a href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#company_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<!-- sil -->
						
							<td style="text-align:center"><input type="checkbox" name="print_company_id" id="print_company_id"  value="#company_id#"></td>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="15"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
		
						<cfset adres = attributes.fuseaction>
						<cfset adres = adres&"&search_status="&attributes.search_status>
						<cfset adres = adres&"&search_potential="&attributes.search_potential>
						<cfif len(attributes.keyword)>
							<cfset adres = adres&"&keyword="&attributes.keyword>
						</cfif>
						<cfif len(attributes.keyword_partner)>
							<cfset adres = adres&"&keyword_partner="&attributes.keyword_partner>
						</cfif>
						<cfif len(attributes.tc_identity)>
							<cfset adres = adres&"&tc_identity="&attributes.tc_identity>
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
						<cfif isdefined("attributes.use_efatura") and len(attributes.use_efatura)>
							<cfset adres = adres&"&use_efatura="&attributes.use_efatura>
						</cfif>
						<cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>
							<cfset adres = adres&"&tax_no="&attributes.tax_no>
						</cfif>  
						<cfif isdefined("attributes.private_code") and len(attributes.private_code)>
							<cfset adres = adres&"&private_code="&attributes.private_code>
						</cfif>               
						<cf_paging 
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="#adres#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$(function(){
		document.getElementById('keyword').focus();
	});
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->