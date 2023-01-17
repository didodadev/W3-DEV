<cf_xml_page_edit fuseact ="report.detail_report_project">
<cfparam name="attributes.module_id_control" default="1">
<cfinclude template="report_authority_control.cfm">
<cf_get_lang_set module_name="project"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.project_no" default="">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.project_status" default="">
<cfparam name="attributes.process_catid" default="">
<cfparam name="attributes.pro_employee" default="">
<cfparam name="attributes.pro_employee_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.consumer" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.expense_code" default="">
<cfparam name="attributes.expense_code_name" default="">
<cfparam name="attributes.country_id" default="">
<cfparam name="attributes.sz_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.county_id" default="">
<cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfquery name="get_process_cat" datasource="#dsn#">
	SELECT
	   DISTINCT 
	   SMC.MAIN_PROCESS_CAT_ID,
	   SMC.MAIN_PROCESS_CAT
	FROM 
	   SETUP_MAIN_PROCESS_CAT SMC,
	   SETUP_MAIN_PROCESS_CAT_ROWS SMR,
	   EMPLOYEE_POSITIONS
	WHERE
	   SMC.MAIN_PROCESS_CAT_ID = SMR.MAIN_PROCESS_CAT_ID AND
	   EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
	   (EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE = SMR.MAIN_POSITION_CODE)
</cfquery>
<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.projects%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_CATS" datasource="#DSN#">
	SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
</cfquery>
<cfquery name="GET_SALES_ZONE" datasource="#DSN#">
	SELECT SZ_NAME,SZ_ID FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_ID
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_projects" datasource="#dsn#">
		SELECT 
			PP.PROJECT_ID,
			PP.PRODUCT_ID,
			PP.PROJECT_NUMBER,
			PP.PROJECT_HEAD,
			PP.CONSUMER_ID,
			PP.COMPANY_ID,
			PP.PARTNER_ID,
			PP.PROJECT_EMP_ID,
			PP.OUTSRC_CMP_ID,
			PP.OUTSRC_PARTNER_ID,
			PP.TARGET_FINISH,
			PP.TARGET_START,
			PP.AGREEMENT_NO,
			PP.PRO_CURRENCY_ID,
			PP.EXPENSE_CODE,
			PP.PROCESS_CAT,
			PP.EXPECTED_BUDGET,
			PP.EXPECTED_COST,
			P.PRODUCT_NAME,
			SETUP_PRIORITY.COLOR,
			SETUP_PRIORITY.PRIORITY,
            SETUP_COUNTRY.COUNTRY_NAME,
            SETUP_CITY.CITY_NAME,
            SETUP_COUNTY.COUNTY_NAME,
            SALES_ZONES.SZ_NAME,
			CASE
            WHEN PP.CONSUMER_ID IS NOT NULL 
            THEN 
            	C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME
            WHEN PP.PARTNER_ID IS NOT NULL
	        THEN(
                    SELECT 
                        C.NICKNAME +' - '+CP.COMPANY_PARTNER_NAME +' '+CP.COMPANY_PARTNER_SURNAME 
                    FROM 
                        COMPANY_PARTNER CP,
                        COMPANY C 
                    WHERE 
                        (CP.PARTNER_ID = PP.PARTNER_ID)
                        AND CP.COMPANY_ID = C.COMPANY_ID
                )
            END AS NAME,
            CASE WHEN PP.PROJECT_EMP_ID IS NOT NULL 
            THEN 
            	E.EMPLOYEE_NAME +' '+E.EMPLOYEE_SURNAME
            WHEN PP.OUTSRC_PARTNER_ID IS NOT NULL
            THEN(
                    SELECT 
                        C.NICKNAME +' - '+CP.COMPANY_PARTNER_NAME +' '+CP.COMPANY_PARTNER_SURNAME 
                    FROM 
                        COMPANY_PARTNER CP,
                        COMPANY C 
                    WHERE 
                        (CP.PARTNER_ID = PP.OUTSRC_PARTNER_ID)
                        AND CP.COMPANY_ID = C.COMPANY_ID
                )
            END AS OUTSRC_PARTNER_NAME,
            PTR.STAGE,
            STMC.MAIN_PROCESS_CAT
		FROM 
			PRO_PROJECTS PP
                LEFT JOIN SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = PP.COUNTRY_ID
                LEFT JOIN SETUP_CITY ON SETUP_CITY.CITY_ID = PP.CITY_ID
                LEFT JOIN SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID = PP.COUNTY_ID
                LEFT JOIN SALES_ZONES ON SALES_ZONES.SZ_ID = PP.SALES_ZONE_ID
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = PP.PROJECT_EMP_ID
				LEFT JOIN #dsn3_alias#.PRODUCT P ON P.PRODUCT_ID = PP.PRODUCT_ID
                LEFT JOIN CONSUMER C ON C.CONSUMER_ID = PP.CONSUMER_ID,
			SETUP_PRIORITY,
            PROCESS_TYPE_ROWS PTR,
            SETUP_MAIN_PROCESS_CAT STMC
		WHERE  
			PP.PRO_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
            PP.PRO_CURRENCY_ID = PTR.PROCESS_ROW_ID AND
            STMC.MAIN_PROCESS_CAT_ID = PP.PROCESS_CAT
            <cfif len(attributes.country_id)>
	            AND PP.COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#">
            </cfif>
            <cfif len(attributes.city_id)>
	            AND PP.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
            </cfif>
            <cfif len(attributes.county_id)>
	            AND PP.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#">
            </cfif>
            <cfif len(attributes.sz_id)>
            	AND PP.SALES_ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sz_id#">
            </cfif>
			<cfif len(attributes.company) and len(attributes.company_id)>
				AND PP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif len(attributes.consumer) and len(attributes.consumer_id)>
				AND PP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
			<cfif len(attributes.keyword) gte 1>
				AND (
						PP.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						PP.AGREEMENT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
					)
			<cfelseif len(attributes.keyword) eq 1>
				AND PP.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
			</cfif>
			<cfif len(attributes.project_no)>
				AND PP.PROJECT_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.project_no#%">
			</cfif>
			<cfif len(attributes.currency)>
				AND PP.PRO_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency#">
			</cfif>
			<cfif len(attributes.priority_cat)>
				AND PP.PRO_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority_cat#">
			</cfif>
			<cfif Len(attributes.project_status)>
				AND PP.PROJECT_STATUS = <cfqueryparam cfsqltype="cf_sql_bigint" value="#attributes.project_status#">
			</cfif>
			<cfif len(attributes.pro_employee_id) and len(attributes.pro_employee)>
				AND PP.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_employee_id#">
			</cfif>
			<cfif xml_related_product_id eq 1 and len(attributes.product_id) and len(attributes.product_name)>
				AND PP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
			</cfif>
			<cfif isDate(attributes.start_date)>
				AND PP.TARGET_START >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			</cfif>
			<cfif isDate(attributes.finish_date)>
				AND PP.TARGET_FINISH <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			</cfif>
			<cfif len(attributes.expense_code) and len(attributes.expense_code_name)>
				AND PP.EXPENSE_CODE LIKE '#attributes.expense_code#'
			</cfif>
			<cfif len(attributes.process_catid)>
				AND PP.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_catid#">
			<cfelseif Len(ValueList(get_process_cat.main_process_cat_id))>
				AND PP.PROCESS_CAT IN (#ValueList(get_process_cat.main_process_cat_id)#)
			<cfelse>
				AND PP.PROCESS_CAT IS NULL
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_projects.recordcount=0>
</cfif>
<cfif len(attributes.start_date)><cfset attributes.start_date = DateFormat(attributes.start_date,dateformat_style)></cfif>
<cfif len(attributes.finish_date)><cfset attributes.finish_date = DateFormat(attributes.finish_date,dateformat_style)></cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_projects.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

    <cfsavecontent variable="head"><cf_get_lang dictionary_id='38323.Proje Raporu' ></cfsavecontent>
    <cfform name="search" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
		<cf_report_list_search title="#head#">
			<cf_report_list_search_area>  
				<div class="row">
					<div class="col col-12 col-xs-12">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'></label>
												<div class="input-group">
													<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
													<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
													<input type="text" name="company" id="company" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','consumer_id,company_id','','3','250');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=search.company&field_comp_id=search.company_id&field_consumer=search.consumer_id&field_member_name=search.company</cfoutput>','list')"></span>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
												<div class="input-group">
													<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
													<input type="hidden" name="pro_employee_id" id="pro_employee_id" value="<cfif isdefined('attributes.pro_employee_id') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee_id#</cfoutput></cfif>">
													<input type="text" name="pro_employee" id="pro_employee" value="<cfif isdefined('attributes.pro_employee') and len(attributes.pro_employee)><cfoutput>#attributes.pro_employee#</cfoutput></cfif>" onfocus="AutoComplete_Create('pro_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','pro_employee_id','','3','135');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search.pro_employee_id&field_name=search.pro_employee&select_list=1','list');"></span>
												</div>
											</div>
											<div class="form-group">	
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>	
												<select name="process_catid" id="process_catid">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfoutput query="get_process_cat"> 
														<option value="#main_process_cat_id#" <cfif attributes.process_catid is main_process_cat_id>selected</cfif>>#main_process_cat#</option>
													</cfoutput> 
												</select>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>	
												<select name="CURRENCY" id="CURRENCY">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfoutput query="get_procurrency">
														<option value="#PROCESS_ROW_ID#"<cfif attributes.currency eq PROCESS_ROW_ID>selected</cfif>>#STAGE#</option>
													</cfoutput>
												</select>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
												<select name="city_id" id="city_id" onchange="LoadCounty(this.value,'county_id')">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfif isdefined('attributes.country_id') and len(attributes.country_id)>
															<cfquery name="GET_CITY" datasource="#dsn#">
																SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = #attributes.country_id# ORDER BY CITY_NAME 
															</cfquery>
															<cfoutput query="get_city">
																<option value="#city_id#" <cfif attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
															</cfoutput>
														</cfif>
												</select>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
												<select name="county_id" id="county_id" >
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
															<cfquery name="get_county" datasource="#DSN#">
																SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = #attributes.city_id# ORDER BY COUNTY_NAME
															</cfquery>
															<cfoutput query="get_county">
																<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
															</cfoutput>
														</cfif>
												</select>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></label>
												<div class="input-group">
													<input type="hidden" name="expense_code" id="expense_code"  value="<cfif len(attributes.expense_code_name)><cfoutput>#attributes.expense_code#</cfoutput></cfif>">
													<input type="text" name="expense_code_name" id="expense_code_name" value="<cfif len(attributes.expense_code_name)><cfoutput>#attributes.expense_code_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('expense_code_name','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_CODE','expense_code','','3','150');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_id=search.expense_code&field_name=search.expense_code_name</cfoutput>','list');"></span>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>				
												<cfinput type="text" name="keyword" value="#attributes.keyword#">
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12">P.<cf_get_lang dictionary_id='57487.no'></label>
												<input type="text" name="project_no" id="project_no" value="<cfoutput>#attributes.project_no#</cfoutput>">
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="38186.İlişkili Ürünler"></label>
												<div class="input-group">
													<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_id) and len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
													<input type="text" name="product_name" id="product_name" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','100');" value="<cfif len(attributes.product_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=search.product_id&field_name=search.product_name&keyword='+encodeURIComponent(document.search.product_name.value),'list');"></span>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="form-group">		
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
												<select name="priority_cat" id="priority_cat">
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfoutput query="get_cats">
															<option value="#priority_id#"<cfif attributes.priority_cat is priority_id>selected</cfif>>#priority#</option>
														</cfoutput>
												</select>
											</div>	
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>	
												<select name="project_status" id="project_status">
													<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
													<option value="1" <cfif attributes.project_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
													<option value="0" <cfif attributes.project_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
												</select>						
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>					
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'> !</cfsavecontent>
													<cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#" message="#message#" maxlength="10">
													<span class="input-group-addon">
													<cf_wrk_date_image date_field="start_date">	
													</span>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>				
												<div class="input-group">
													<cfinput type="text" name="finish_date" value="#attributes.finish_date#" validate="#validate_style#"  message="#message#" maxlength="10">
													<span class="input-group-addon">
													<cf_wrk_date_image date_field="finish_date">
													</span>	
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
								<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
								<cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
								<cf_wrk_report_search_button button_type='1' search_function="control()" insert_info="#message#" is_excel="1">
							</div>
						</div>
					</div>
				</div>
			</cf_report_list_search_area>
		</cf_report_list_search>
	</cfform>
	<cfif attributes.is_excel eq 1>
		<cfset type_ = 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfelse>
		<cfset type_ = 0>
	</cfif>

<cfif isdefined("attributes.is_form_submitted")>
	<cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_projects.recordcount>
	</cfif>

<cf_report_list>
	<thead>
		<tr>
			<th style="text-align:center;" ><cf_get_lang dictionary_id='57487.No'></th>
			<th width="120"><cf_get_lang dictionary_id='58015.Projeler'></th>
			<th>P.<cf_get_lang dictionary_id='57487.no'></th>
			<cfif xml_related_product_id>
			<th style="text-align:center;" ><cf_get_lang dictionary_id="38186.İlişkili Ürünler"></th>
			</cfif>
			<th><cf_get_lang dictionary_id='57486.Kategori'></th>
			<th style="text-align:center;" >S.<cf_get_lang dictionary_id='57487.no'></th>
			<th><cf_get_lang dictionary_id='57487.no'></th>
			<th style="text-align:center;" ><cf_get_lang dictionary_id='58219.ülke'></th>
			<cfif xml_show_city_county>
			<th><cf_get_lang dictionary_id='58608.İl'></th>
			<th style="text-align:center;" ><cf_get_lang dictionary_id='58638.İlçe'></th>
			</cfif>  
			<th><cf_get_lang dictionary_id='57574.şirket'></th>
			<th style="text-align:center;" ><cf_get_lang dictionary_id='57569.görevli'></th>
			<th><cf_get_lang dictionary_id='57485.Öncelik'></th>
			<th style="text-align:center;" ><cf_get_lang dictionary_id='58053.bitiş tarihi'></th>
			<th><cf_get_lang dictionary_id='57700.bitiş tarihi'></th>
			<th style="text-align:center;" ><cf_get_lang dictionary_id='38175.Tahmini Bütçe'></th>
			<th><cf_get_lang dictionary_id='38300.Tahmini Maliyet'></th>
			<th style="text-align:center;" ><cf_get_lang dictionary_id='57482.Aşama'></th>
		</tr>
	</thead>
	<!---tbody start--->
	<tbody>
		<cfif get_projects.recordcount>
				<cfif type_ eq 1>
					<cfset attributes.maxrows = attributes.totalrecords>
				</cfif>
				<cfoutput query="get_projects" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>
				#currentrow#
				</td>
				<td>
					<cfif type_ eq 1>
						#project_head#						
					<cfelse>
							<a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a>
					</cfif>
				</td>
				<td>
				#project_number#
				</td>
					<cfif xml_related_product_id>
				<td>
				#product_name#
				</td>
					</cfif>
				<td>
				#main_process_cat#
				</td>
				<td>
				#agreement_no#
				</td>
				<td>
				#sz_name#
				</td>
				<td>
				#country_name#
				</td>
					<cfif xml_show_city_county>
				<td>
				#city_name#
				</td>
				<td>
				#county_name#
				</td>
					</cfif>
				<td>
					<cfif len(company_id)>
					<cfif type_ eq 1>#trim(listfirst(name,'-'))#
						<cfelse>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#trim(listfirst(name,'-'))#</a>
					</cfif>
					<cfif type_ eq 1>
				#trim(listlast(name,'-'))#
						<cfelse>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PARTNER_ID#','medium');">#trim(listlast(name,'-'))#</a>
					</cfif>								
						<cfelseif len(consumer_id)>
					<cfif type_ eq 1>
				#name#
						<cfelse>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">#name#</a>
					</cfif>
					</cfif>
				</td>
				<td>
					<cfif len(project_emp_id)>
					<cfif type_ eq 1>#OUTSRC_PARTNER_NAME#
						<cfelse>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#project_emp_id#','medium');">#OUTSRC_PARTNER_NAME#</a>
					</cfif>
					</cfif>
					<cfif len(outsrc_partner_id)>		
					<cfif type_ eq 1>
					#trim(listfirst(OUTSRC_PARTNER_NAME,'-'))#
						<cfelse>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#outsrc_cmp_id#','medium');">#trim(listfirst(OUTSRC_PARTNER_NAME,'-'))#</a>-
					</cfif>		
					<cfif type_ eq 1>
				#trim(listlast(OUTSRC_PARTNER_NAME,'-'))#
						<cfelse>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#outsrc_partner_id#','medium');">#trim(listlast(OUTSRC_PARTNER_NAME,'-'))#</a>
					</cfif>										
					</cfif>
				</td>
				<td>
					<cfif type_ eq 1>
					#get_projects.priority#
						<cfelse>
								<font color="#get_projects.color#">#get_projects.priority#</font>							
					</cfif>
				</td>
				<td>
				#dateformat(get_projects.target_start,dateformat_style)#
				</td>
				<td>
				#dateformat(get_projects.target_finish,dateformat_style)#
				</td>
				<td align="right" style="text-align:right;" format="numeric">
				#TLFormat(expected_budget)#
				</td>
				<td align="right" style="text-align:right;" format="numeric">
				#TLFormat(expected_cost)#
				</td>
				<td>
					<cfif type_ eq 1>
				#stage#							
						<cfelse>
							<font color="#get_projects.color#">
				#stage#
							</font>							
					</cfif>
				</td>
				</tr>
			</cfoutput>
			<cfelse>
			<tr>
			<td colspan="18"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '>!</cfif>
			</td>
			</tr>
		</cfif>			
	</tbody>
	<!---tbody stop--->
</cf_report_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "&is_form_submitted=1">
			<cfif Len(attributes.process_catid)>
				<cfset adres = "#adres#&process_catid=#attributes.process_catid#">
			</cfif>
			<cfif Len(attributes.priority_cat)>
				<cfset adres = "#adres#&priority_cat=#attributes.priority_cat#">
			</cfif>
			<cfif Len(attributes.company_id) and Len(attributes.company)>
				<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
			<cfelseif Len(attributes.consumer_id) and Len(attributes.company)>
				<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
			</cfif>
			<cfif Len(attributes.expense_code_name)>
				<cfset adres = "#adres#&expense_code_name=#attributes.expense_code_name#">
			</cfif>
			<cfif Len(attributes.project_status)>
				<cfset adres = "#adres#&project_status=#attributes.project_status#">
			</cfif>
			<cfif len(attributes.pro_employee_id) and len(attributes.pro_employee)>
				<cfset adres = "#adres#&pro_employee_id=#attributes.pro_employee_id#&pro_employee=#attributes.pro_employee#">
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				<cfset adres = "#adres#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
			</cfif>
			<cfif len(attributes.currency)>
				<cfset adres = "#adres#&CURRENCY=#attributes.currency#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.project_no)>
				<cfset adres = "#adres#&project_no=#attributes.project_no#">
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset adres = "#adres#&start_date=#attributes.start_date#">
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset adres = "#adres#&finish_date=#attributes.finish_date#">
			</cfif>
            <cfif len(attributes.country_id)>
				<cfset adres = "#adres#&country_id=#attributes.country_id#">
			</cfif>
            <cfif len(attributes.city_id)>
				<cfset adres = "#adres#&city_id=#attributes.city_id#">
			</cfif>
            <cfif len(attributes.county_id)>
				<cfset adres = "#adres#&county_id=#attributes.county_id#">
			</cfif>
			<cf_paging page="#attributes.page#"
						  maxrows="#attributes.maxrows#"
						  totalrecords="#attributes.totalrecords#"
						  startrow="#attributes.startrow#"
						  adres="#attributes.fuseaction##adres#">
		</cfif>
</cfif>
<script type="text/javascript">
   document.getElementById('keyword').focus();
	function control(){
				
					if(!date_check(search.start_date,search.finish_date,"<cf_get_lang dictionary_id='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
						return false;
					}
				if(document.search.is_excel.checked==false)
				{
					document.search.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
					return true;
				}
				else
					document.search.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_report_project</cfoutput>"
			}
   
</script>
<br/>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->