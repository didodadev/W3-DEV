<!---  buranin sirasina dokunmayin!!!!  --->
<cf_xml_page_edit fuseact="account.list_account_card">
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		AND BRANCH.BRANCH_STATUS = 1
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfset yevmiye_borc=0>
<cfset yevmiye_alacak=0>
<cfset yevmiye_borc_dev=0>
<cfset yevmiye_alacak_dev=0>
<cfset row_counter=0>
<cfif not isdefined('attributes.date1') or not isdefined('attributes.date2')>
	<cfset date1 = "#day(now())#/#month(now())#/#session.ep.period_year#" >
	<cfset date2 = "#daysinmonth(now())#/#month(now())#/#session.ep.period_year#">
<cfelse>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">
	<cfset date1 = dateformat(attributes.date1,dateformat_style) >
	<cfset date2 = dateformat(attributes.date2,dateformat_style) >
</cfif>
<cfparam name="attributes.form_is_submitted" default="0">
<cfparam name="attributes.is_detail" default="0">
<cfparam name="attributes.is_quantity" default="0">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_sub_project" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.acc_code1_2" default="">
<cfparam name="attributes.acc_code2_2" default="">
<cfparam name="attributes.acc_code1_3" default="">
<cfparam name="attributes.acc_code2_3" default="">
<cfparam name="attributes.acc_code1_4" default="">
<cfparam name="attributes.acc_code2_4" default="">
<cfparam name="attributes.acc_code1_5" default="">
<cfparam name="attributes.acc_code2_5" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_acc_card" action="#request.self#?fuseaction=account.list_account_card" method="post">
		<input type="hidden" name="form_is_submitted" id="form_is_submitted" value="1">
		<cf_box_search>
			<div class="form-group">
				<label class="col col-3 col-md-3 col-sm-12 col-xs-12"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></label>
				<cf_wrk_multi_account_code acc_code1_1='#attributes.acc_code1_1#' acc_code2_1='#attributes.acc_code2_1#' acc_code1_2='#attributes.acc_code1_2#' acc_code2_2='#attributes.acc_code2_2#' acc_code1_3='#attributes.acc_code1_3#' acc_code2_3='#attributes.acc_code2_3#' acc_code1_4='#attributes.acc_code1_4#' acc_code2_4='#attributes.acc_code2_4#' acc_code1_5='#attributes.acc_code1_5#' acc_code2_5='#attributes.acc_code2_5#' form_name="list_acc_card" is_multi='#is_select_multi_acc_code#'>  <!--- is_multi='#is_select_multi_acc_code#' --->
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfinput value="#date1#" required="Yes" type="text" name="date1" validate="#validate_style#" maxlength="10">
					<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfinput value="#date2#" required="Yes" type="text" name="date2" validate="#validate_style#" maxlength="10">
					<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
				</div>
			</div>
			<div class="form-group">
				<label><input type="checkbox" name="is_detail" id="is_detail" value="1" <cfif attributes.is_detail eq 1>checked</cfif>><cf_get_lang dictionary_id='58785.Detaylı'></label>
			</div>
			<div class="form-group">
				<label><input type="checkbox" name="is_quantity" id="is_quantity" value="1" <cfif attributes.is_quantity eq 1>checked</cfif>><cf_get_lang dictionary_id='47527.Miktar Goster'></label>
			</div>
			<div class="form-group">
				<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
			</div>
			<div class="form-group small">
				<div class="input-group">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999"maxlength="3">
				</div>
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="kontrol_tarih()">
			</div>
			<cfif get_module_user(33) and not listfindnocase(denied_pages,'report.popup_rapor_yevmiye')>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onClick="pencere_ac();"><i class="fa fa-file" alt="<cf_get_lang dictionary_id ='58600.Dosya Oluştur'>" title="<cf_get_lang dictionary_id ='58600.Dosya Oluştur'>"></i></a>
				</div>
			</cfif>
			<div class="form-group">
				<cf_workcube_file_action pdf='1' print='1' trail='1'>
			</div>
		</cf_box_search>
		<cf_box_search_detail>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-acc_card_type">
					<label class="col col-12"><cfoutput>#getLang(86,'Fiş Türü',47348)#​</cfoutput></label>
					<div class="col col-12">
						<cfquery name="get_acc_card_type" datasource="#dsn3#">
							SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
						</cfquery>
						<cf_multiselect_check
							name="acc_card_type"
							option_name="process_cat"
							option_value="process_type-process_cat_id"
							width="130"
							value="#attributes.acc_card_type#"
							query_name="get_acc_card_type">
						</div>                 
				</div>
				<div class="form-group" id="item-acc_code_type">
					<label class="col col-12"><cfoutput>#getLang(647,'Düzenleme Tipi',37658)#</cfoutput></label>
					<div class="col col-12">
							<select name="acc_code_type" id="acc_code_type" style="width:80px;">
							<option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
							<option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
						</select>  
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-branch_id">
					<label class="col col-12"><cfoutput>#getLang(41,'Şube',57453)#​</cfoutput></label>
					<div class="col col-12">
						<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" style="width:120px;">
							<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#​</cfoutput></option>
							<cfoutput query="get_branches" group="NICK_NAME">
								<optgroup label="#NICK_NAME#"></optgroup>
								<cfoutput>
									<option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>&nbsp;&nbsp;&nbsp;#BRANCH_NAME#</option>
								</cfoutput>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-department">
					<label class="col col-12"><cf_get_lang dictionary_id="57572.Departman"></label>
					<div class="col col-12">
						<div width="120" id="DEPARTMENT_PLACE">
						<select name="department" id="department" style="width:120px;">
							<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#​</cfoutput></option>
							<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
								<cfquery name="GET_DEPARTMANT" datasource="#DSN#">
									SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
								</cfquery>
								<cfoutput query="get_departmant">
									<option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.department_id)>selected</cfif>>#department_head#</option>
								</cfoutput>
							</cfif>
						</select>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-project_id_">
					<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
					<div class="col col-12">
						<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
							<cfset project_id_ = attributes.project_id>
						<cfelse>
							<cfset project_id_ = ''>
						</cfif>
						<cf_wrkProject
							project_Id="#project_id_#"
							width="110"
							AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
							boxwidth="600"
							boxheight="400">
					</div>
				</div>
				<div class="form-group" id="item-is_sub_project">
					<label class="col col-12"><span class="hide"><cf_get_lang dictionary_id='47564.Alt Projeleri Getir'></span></label>
					<label><input type="checkbox" name="is_sub_project" id="is_sub_project" value="1" <cfif attributes.is_sub_project eq 1>checked</cfif>><cf_get_lang dictionary_id='47564.Alt Projeleri Getir'></label>
				</div>
			</div>
		</cf_box_search_detail>
		</cfform>
	</cf_box>

	<cfif attributes.form_is_submitted>
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<cfset filename = "#createuuid()#">
			<cfheader name="Expires" value="#Now()#">
			<cfcontent type="application/vnd.msexcel;charset=utf-16">
			<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
			<meta http-equiv="content-type" content="text/plain; charset=utf-16">
		</cfif>
		<!--- <cfsavecontent variable="excel_icerik"> --->
			<cfquery name="GET_CARD_ID" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
				<cfif isdefined('attributes.is_detail') and attributes.is_detail eq 1>
					SELECT 
						CARD_ID, 
						ACTION_DATE,
						BILL_NO,
						CARD_TYPE,
						CARD_TYPE_NO,		
						PAPER_NO,
						ACTION_TYPE,
						CARD_DETAIL,
						COMPANY.FULLNAME AS CARI_HESAP,
						COMPANY.TAXOFFICE AS VERGI_DAIRESI,
						COMPANY.TAXNO AS VERGI_NO,
						COMPANY.IS_RELATED_COMPANY AS BAGLI_UYE
					FROM
						ACCOUNT_CARD,
						#dsn_alias#.COMPANY COMPANY
					WHERE 
						ACC_COMPANY_ID = COMPANY.COMPANY_ID AND 
						ACC_COMPANY_ID IS NOT NULL
						<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
							AND (
							<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
								(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
								<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
							</cfloop>  
								)
						</cfif>				
						<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
							AND ACTION_DATE <= #attributes.date2# 
							AND ACTION_DATE>=#attributes.date1#
						</cfif>
						<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
							AND CARD_ID IN 
							(SELECT 
								ACR.CARD_ID
							FROM 
								#dsn_alias#.PRO_PROJECTS,
								ACCOUNT_CARD_ROWS ACR
							WHERE 
								PROJECT_ID = ACR.ACC_PROJECT_ID 
								<cfif attributes.is_sub_project	eq 1>
									AND (RELATED_PROJECT_ID = #attributes.project_id# OR ACR.ACC_PROJECT_ID = #attributes.project_id#)
								<cfelse>
									AND ACR.ACC_PROJECT_ID = #attributes.project_id#
								</cfif>
							)
						</cfif>
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND CARD_ID IN(SELECT ACR.CARD_ID FROM ACCOUNT_CARD_ROWS ACR WHERE ACR.ACC_BRANCH_ID = #attributes.branch_id#)
						</cfif>
						<cfif isdefined("attributes.department") and len(attributes.department)>
							AND CARD_ID IN(SELECT ACR.CARD_ID FROM ACCOUNT_CARD_ROWS ACR WHERE ACR.ACC_DEPARTMENT_ID = #attributes.department#)
						</cfif>	
						<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
							AND CARD_ID IN
								(SELECT
									ACR.CARD_ID	
								FROM 
									ACCOUNT_CARD_ROWS ACR
								WHERE 
									1=1
									AND 
									(
										<cfloop from="1" to="5" index="kk">
											<cfif kk neq 1>OR</cfif>
											(
												1 = 0
												<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
													OR
													(
														1 = 1
														<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
															<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
																AND ACR.IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
															<cfelse>
																AND ACR.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
															</cfif>
														</cfif>
														<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
															<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
																AND ACR.IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
															<cfelse>
																AND ACR.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
															</cfif>
														</cfif>
													)
												</cfif>
											)
										</cfloop>
									)
								)
						</cfif>							
					UNION 
					SELECT 
						CARD_ID, 
						ACTION_DATE,
						BILL_NO,
						CARD_TYPE,
						CARD_TYPE_NO,		
						PAPER_NO,
						ACTION_TYPE,
						CARD_DETAIL,
						(CONSUMER.CONSUMER_NAME + CONSUMER.CONSUMER_SURNAME) AS CARI_HESAP,
						CONSUMER.TAX_OFFICE AS VERGI_DAIRESI,
						TAX_POSTCODE AS VERGI_NO,
						CONSUMER.IS_RELATED_CONSUMER AS BAGLI_UYE
					FROM
						ACCOUNT_CARD,	
						#dsn_alias#.CONSUMER CONSUMER
					WHERE 	
						ACC_CONSUMER_ID = CONSUMER.CONSUMER_ID AND 
						ACC_CONSUMER_ID IS NOT NULL
						<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
							AND (
							<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
								(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
								<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
							</cfloop>  
								)
						</cfif>				
						<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
							AND ACTION_DATE <= #attributes.date2# 
							AND ACTION_DATE>=#attributes.date1#
						</cfif>
						<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
							AND CARD_ID IN 
							(SELECT 
								ACR.CARD_ID
							FROM 
								#dsn_alias#.PRO_PROJECTS,
								ACCOUNT_CARD_ROWS ACR
							WHERE 
								PROJECT_ID = ACR.ACC_PROJECT_ID 
								<cfif attributes.is_sub_project	eq 1>
									AND (RELATED_PROJECT_ID = #attributes.project_id# OR ACR.ACC_PROJECT_ID = #attributes.project_id#)
								<cfelse>
									AND ACR.ACC_PROJECT_ID = #attributes.project_id#
								</cfif>
							)
						</cfif>
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND CARD_ID IN(SELECT ACR.CARD_ID FROM ACCOUNT_CARD_ROWS ACR WHERE ACR.ACC_BRANCH_ID = #attributes.branch_id#)
						</cfif>
						<cfif isdefined("attributes.department") and len(attributes.department)>
							AND CARD_ID IN(SELECT ACR.CARD_ID FROM ACCOUNT_CARD_ROWS ACR WHERE ACR.ACC_DEPARTMENT_ID = #attributes.department#)
						</cfif>	
						<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
							AND CARD_ID IN
								(SELECT
									ACR.CARD_ID	
								FROM 
									ACCOUNT_CARD_ROWS ACR
								WHERE 
									1=1
									AND 
									(
										<cfloop from="1" to="5" index="kk">
											<cfif kk neq 1>OR</cfif>
											(
												1 = 0
												<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
													OR
													(
														1 = 1
														<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
															<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
																AND ACR.IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
															<cfelse>
																AND ACR.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
															</cfif>
														</cfif>
														<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
															<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
																AND ACR.IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
															<cfelse>
																AND ACR.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
															</cfif>
														</cfif>
													)
												</cfif>
											)
										</cfloop>
									)
								)
						</cfif>
					UNION 
				</cfif>
				SELECT 
					CARD_ID, 
					ACTION_DATE,
					BILL_NO,
					CARD_TYPE,
					CARD_TYPE_NO,
					PAPER_NO,
					ACTION_TYPE,
					CARD_DETAIL,
					'' AS CARI_HESAP,
					'' AS VERGI_DAIRESI,
					'' AS VERGI_NO,
					2 AS BAGLI_UYE
				FROM
					ACCOUNT_CARD 
				WHERE 
					CARD_ID IS NOT NULL
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
						AND (
						<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
							(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
							<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
						</cfloop>  
							)
					</cfif>				
					<cfif isdefined('attributes.is_detail') and attributes.is_detail eq 1>
						AND ACC_CONSUMER_ID IS NULL
						AND ACC_COMPANY_ID IS NULL 
					</cfif>
					<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
						AND ACTION_DATE <= #attributes.date2# 
						AND ACTION_DATE> = #attributes.date1#
					</cfif>
					<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
						AND CARD_ID IN 
						(SELECT 
							ACR.CARD_ID
						FROM 
							#dsn_alias#.PRO_PROJECTS,
							ACCOUNT_CARD_ROWS ACR
						WHERE 
							PROJECT_ID = ACR.ACC_PROJECT_ID 
							<cfif attributes.is_sub_project	eq 1>
								AND (RELATED_PROJECT_ID = #attributes.project_id# OR ACR.ACC_PROJECT_ID = #attributes.project_id#)
							<cfelse>
								AND ACR.ACC_PROJECT_ID = #attributes.project_id#
							</cfif>
						)
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND CARD_ID IN(SELECT ACR_1.CARD_ID FROM ACCOUNT_CARD_ROWS ACR_1 WHERE ACR_1.ACC_BRANCH_ID = #attributes.branch_id#)
					</cfif>
					<cfif isdefined("attributes.department") and len(attributes.department)>
						AND CARD_ID IN(SELECT ACR_2.CARD_ID FROM ACCOUNT_CARD_ROWS ACR_2 WHERE ACR_2.ACC_DEPARTMENT_ID = #attributes.department#)
					</cfif>	
					<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
						AND CARD_ID IN
							(SELECT
								ACR.CARD_ID	
							FROM 
								ACCOUNT_CARD_ROWS ACR
							WHERE 
								1=1
								AND 
								(
									<cfloop from="1" to="5" index="kk">
										<cfif kk neq 1>OR</cfif>
										(
											1 = 0
											<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
												OR
												(
													1 = 1
													<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
														<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
															AND ACR.IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
														<cfelse>
															AND ACR.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
														</cfif>
													</cfif>
													<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
														<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
															AND ACR.IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
														<cfelse>
															AND ACR.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
														</cfif>
													</cfif>
												)
											</cfif>
										)
									</cfloop>
								)
							)
					</cfif>
				ORDER BY
					ACTION_DATE,
					BILL_NO
			</cfquery>
			<!--- <cfdump var="#GET_CARD_ID#"> --->
			<cfparam name="attributes.totalrecords" default="#get_card_id.recordcount#">
			<cfset endrow=attributes.maxrows+attributes.startrow-1>
			<cfif attributes.totalrecords lt endrow>
				<cfset endrow=attributes.totalrecords>
			</cfif>
			<cfif isdefined('get_card_id.recordcount')>
				<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
					<cfset endrow=get_card_id.recordcount>
				</cfif>
			</cfif>
		<cf_box title="#getLang(19,'Yevmiye',47281)#"  uidrop="#IIf((isdefined('attributes.is_excel') and attributes.is_excel eq 1),Evaluate(DE("")),DE("1"))#" hide_table_column="1">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="30"></th>
						<th><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='47284.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='47299.Hesap Kodu'></cfif></th>
						<cfif is_acc_branch><th><cf_get_lang dictionary_id='57453.Sube'></th></cfif>
						<cfif is_acc_department><th><cf_get_lang dictionary_id='57572.Departman'></th></cfif>	
						<cfif is_acc_project eq 1><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
						<th><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='47296.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='47300.Hesap Adı'></cfif></th>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<cfif attributes.is_quantity>
							<th><cf_get_lang dictionary_id='57635.Miktar'></th>
						</cfif>
						<cfif attributes.is_detail>
							<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57587.Borç'></th>
						<th><cf_get_lang dictionary_id='57588.Alacak'></th>
					</tr>
				</thead>
				<cfset colspan_num_ = 6>
				<cfset colspan_num_2 = 4>
				<cfif attributes.is_quantity>
					<cfset colspan_num_ = colspan_num_ + 1>
					<cfset colspan_num_2 = colspan_num_2 + 1>
				</cfif>
				<cfif attributes.is_detail>
					<cfset colspan_num_ = colspan_num_ + 1>
					<cfset colspan_num_2 = colspan_num_2 + 1>
				</cfif>
				<cfif is_acc_project eq 1>
					<cfset colspan_num_ = colspan_num_ + 1>
					<cfset colspan_num_2 = colspan_num_2 + 1>
				</cfif>
				<cfif is_acc_branch eq 1>
					<cfset colspan_num_ = colspan_num_ + 1>
					<cfset colspan_num_2 = colspan_num_2 + 1>
				</cfif>
				<cfif is_acc_department eq 1>
					<cfset colspan_num_ = colspan_num_ + 1>
					<cfset colspan_num_2 = colspan_num_2 + 1>
				</cfif>
				<cfif get_card_id.recordcount>
					<!---  devreden  --->
					<cfif attributes.page gt 1 >
						<cfset our_ls=attributes.startrow-1>
						<cfset yevmiye_borc_dev=0>
						<cfset yevmiye_alacak_dev=0>
						<cfloop from="1" to="#our_ls#" index="I">
							<cfquery name="GET_CARD_ROWS" datasource="#DSN2#">
								SELECT 
									ACR.AMOUNT,
									ACR.BA,
									ACR.DETAIL,
									<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)>
										AP.IFRS_CODE AS ACC_ACCOUNT_ID,
										AP.IFRS_NAME AS ACCOUNT_NAME
									<cfelse>
										ACR.ACCOUNT_ID AS ACC_ACCOUNT_ID,
										AP.ACCOUNT_NAME
									</cfif>
								FROM 
									ACCOUNT_CARD_ROWS ACR,
									ACCOUNT_PLAN AP 
								WHERE 
									CARD_ID=#GET_CARD_ID.CARD_ID[I]# AND 
									AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
								ORDER BY BA ASC,AMOUNT DESC
							</cfquery>
							<cfoutput query="GET_CARD_ROWS">
								<cfif BA EQ 0>
									<cfset yevmiye_borc_dev=yevmiye_borc_dev+AMOUNT>
								<cfelse>
									<cfset yevmiye_alacak_dev=yevmiye_alacak_dev+AMOUNT>
								</cfif>
							</cfoutput>
						</cfloop>
						<tbody>
							<tr>
								<td colspan="<cfoutput>#colspan_num_2#</cfoutput>" class="txtbold"><cf_get_lang dictionary_id='58034.Devreden'> :</td>
								<td style="text-align:right;" class="txtbold"><cfoutput>#TLFormat(yevmiye_borc_dev)#</cfoutput></td>
								<td style="text-align:right;" class="txtbold"><cfoutput>#TLFormat(yevmiye_alacak_dev)#</cfoutput></td>
							</tr>
						</tbody>
					</cfif>
					<!---  devreden  --->
					<cfloop from="#attributes.startrow#" to="#endrow#" index="I">
						<cfset A_toplam=0>
						<cfset B_toplam=0>
						<cfquery name="GET_CARD_ROWS" datasource="#DSN2#">
							SELECT 
								ACR.*,
								PRO_PROJECTS.PROJECT_HEAD,
								DEPARTMENT.DEPARTMENT_HEAD,							
								BRANCH.BRANCH_NAME,
								<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)>
									AP.IFRS_CODE AS ACC_ACCOUNT_ID,
									AP.IFRS_NAME AS ACCOUNT_NAME
								<cfelse>
									ACR.ACCOUNT_ID AS ACC_ACCOUNT_ID,
									AP.ACCOUNT_NAME
								</cfif>
							FROM 
								ACCOUNT_CARD_ROWS ACR
									LEFT JOIN #dsn_alias#.PRO_PROJECTS ON ACR.ACC_PROJECT_ID = PRO_PROJECTS.PROJECT_ID
									LEFT JOIN #dsn_alias#.DEPARTMENT ON ACR.ACC_DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
									LEFT JOIN #dsn_alias#.BRANCH ON ACR.ACC_BRANCH_ID = BRANCH.BRANCH_ID,
								ACCOUNT_PLAN AP 
							WHERE 
								CARD_ID=#GET_CARD_ID.CARD_ID[I]# AND 
								AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
							ORDER BY BA ASC,AMOUNT DESC
						</cfquery>
						<cfswitch expression="#GET_CARD_ID.CARD_TYPE[I]#">
							<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
							<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
							<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
							<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
							<cfcase value="19"><cfset TYPE = 'KAPANIŞ'>	</cfcase>
						</cfswitch>
						<tbody>
							<tr>
								<td colspan="<cfoutput>#colspan_num_#</cfoutput> " class="form" align="center"> 
									<cfoutput><cf_get_lang dictionary_id='39373.YEVMİYE NO'>:#GET_CARD_ID.BILL_NO[I]#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;___________#dateformat(GET_CARD_ID.ACTION_DATE[I],dateformat_style)#____________</cfoutput> 
								</td>
							</tr>
							<cfset is_new_acc_card = true>
							<cfoutput query="GET_CARD_ROWS">
								<tr>
									<cfif is_new_acc_card>
										<td rowspan="#GET_CARD_ROWS.RECORDCOUNT#" class="txtbold" valign="top" style="width:120px;">
											#TYPE# <cf_get_lang dictionary_id='57946.FİŞ NO'>:  <cfif len(GET_CARD_ID.CARD_TYPE_NO[I])>#GET_CARD_ID.CARD_TYPE_NO[I]#<cfelse>1</cfif>
											<cfif attributes.is_detail>
												<br><cf_get_lang dictionary_id='57880.Belge No'>: <cfif len(GET_CARD_ID.PAPER_NO[I])>#GET_CARD_ID.PAPER_NO[I]#</cfif>
												<cfif len(GET_CARD_ID.CARI_HESAP[I])>
													<br>#GET_CARD_ID.CARI_HESAP[I]#
													<br><cf_get_lang dictionary_id='58762.Vergi Dairesi'>/<cf_get_lang dictionary_id='57487.No'> : <cfif len(GET_CARD_ID.VERGI_DAIRESI[I])>#GET_CARD_ID.VERGI_DAIRESI[I]#</cfif> <cfif len(GET_CARD_ID.VERGI_NO[I])>-#GET_CARD_ID.VERGI_NO[I]#</cfif>
												</cfif>
											</cfif>
										</td>
										<cfset is_new_acc_card = false>
									</cfif>
									<td>#ACC_ACCOUNT_ID#</td>
									<cfif is_acc_branch><td>#BRANCH_NAME#</td></cfif>
									<cfif is_acc_department><td>#DEPARTMENT_HEAD#</td></cfif>
									<cfif is_acc_project eq 1><td>#PROJECT_HEAD#</td></cfif>
									<td>#ACCOUNT_NAME#</td>
									<td>#DETAIL#</td>
									<cfif attributes.is_quantity>
										<td>#TLFormat(QUANTITY)#</td>
									</cfif>
									<cfif attributes.is_detail>
										<td style="text-align:right;">#TLFormat(PRICE)#</td>
									</cfif>
									<td style="text-align:right;">&nbsp;<cfif BA eq 0>#TLFormat(AMOUNT)#<cfset yevmiye_borc=yevmiye_borc+AMOUNT><cfset B_toplam = B_toplam + AMOUNT></cfif></td>
									<td style="text-align:right;">&nbsp;<cfif BA eq 1>#TLFormat(AMOUNT)#<cfset yevmiye_alacak = yevmiye_alacak +AMOUNT><cfset A_toplam = A_toplam + AMOUNT></cfif></td>
								</tr>
							</cfoutput>
							<tr class="total">
								<td colspan="<cfoutput>#colspan_num_2#</cfoutput>" class="txtbold"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
								<td style="text-align:right;" class="txtbold"><cfoutput>#TLFormat(A_toplam)#</cfoutput></td>
								<td style="text-align:right;" class="txtbold"><cfoutput>#TLFormat(B_toplam)#</cfoutput></td>
							</tr>
						</tbody>
					</cfloop>
					<tfoot>
						<!--- Genel Toplam --->
						<tr>
							<td colspan="<cfoutput>#colspan_num_2#</cfoutput>" class="txtbold"><cf_get_lang dictionary_id='57680.Genel Toplam'>:</td>
							<td style="text-align:right;" class="txtbold">
								<cfset yevmiye_borc= yevmiye_borc_dev+yevmiye_borc>
								<cfset yevmiye_alacak= yevmiye_alacak_dev+yevmiye_alacak>
								<cfoutput>#TLFormat(yevmiye_borc)#</cfoutput>
							</td>
							<td style="text-align:right;" class="txtbold"> <cfoutput>#TLFormat(yevmiye_alacak)#</cfoutput> </td>
						</tr>
					</tfoot>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="<cfoutput>#colspan_num_#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</tbody>
				</cfif>
			</cf_grid_list>
			<cfset adres=attributes.fuseaction>
			<cfset adres='#adres#&form_is_submitted=#attributes.form_is_submitted#'>
			<cfset adres='#adres#&is_detail=#attributes.is_detail#'>
			<cfset adres='#adres#&is_quantity=#attributes.is_quantity#'>
			<cfif isdefined("attributes.date1")>
				<cfset adres='#adres#&date1=#date1#'>
				<cfset adres='#adres#&date2=#date2#'>
			</cfif>
			<cfif isdefined("attributes.acc_card_type") and len(attributes.acc_card_type)>
				<cfset adres='#adres#&acc_card_type=#attributes.acc_card_type#'>
			</cfif>
			<cfif isdefined("attributes.acc_code_type") and len(attributes.acc_code_type)>
				<cfset adres='#adres#&acc_code_type=#attributes.acc_code_type#'>
			</cfif>
			<cfif isdefined ("attributes.acc_code1_1") and len(attributes.acc_code1_1)>
				<cfset adres = "#adres#&acc_code1_1=#attributes.acc_code1_1#">
			</cfif>
			<cfif isdefined ("attributes.acc_code2_1") and len(attributes.acc_code2_1)>
				<cfset adres = "#adres#&acc_code2_1=#attributes.acc_code2_1#">
			</cfif>
			<cfif isdefined ("attributes.acc_code1_2") and len(attributes.acc_code1_2)>
				<cfset adres = "#adres#&acc_code1_2=#attributes.acc_code1_2#">
			</cfif>
			<cfif isdefined ("attributes.acc_code2_2") and len(attributes.acc_code2_2)>
				<cfset adres = "#adres#&acc_code2_2=#attributes.acc_code2_2#">
			</cfif>
			<cfif isdefined ("attributes.acc_code1_3") and len(attributes.acc_code1_3)>
				<cfset adres = "#adres#&acc_code1_3=#attributes.acc_code1_3#">
			</cfif>
			<cfif isdefined ("attributes.acc_code2_3") and len(attributes.acc_code2_3)>
				<cfset adres = "#adres#&acc_code2_3=#attributes.acc_code2_3#">
			</cfif>
			<cfif isdefined ("attributes.acc_code1_4") and len(attributes.acc_code1_4)>
				<cfset adres = "#adres#&acc_code1_4=#attributes.acc_code1_4#">
			</cfif>
			<cfif isdefined ("attributes.acc_code2_4") and len(attributes.acc_code2_4)>
				<cfset adres = "#adres#&acc_code2_4=#attributes.acc_code2_4#">
			</cfif>
			<cfif isdefined ("attributes.acc_code1_5") and len(attributes.acc_code1_5)>
				<cfset adres = "#adres#&acc_code1_5=#attributes.acc_code1_5#">
			</cfif>
			<cfif isdefined ("attributes.acc_code2_5") and len(attributes.acc_code2_5)>
				<cfset adres = "#adres#&acc_code2_5=#attributes.acc_code2_5#">
			</cfif>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
				<cfset adres='#adres#&project_id=#attributes.project_id#'>
			</cfif>
			<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
				<cfset adres='#adres#&project_head=#attributes.project_head#'>
			</cfif>
			<cfif isdefined("attributes.is_sub_project") and len(attributes.is_sub_project)>
				<cfset adres='#adres#&is_sub_project=#attributes.is_sub_project#'>
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				<cfset adres='#adres#&branch_id=#attributes.branch_id#'>
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				<cfset adres='#adres#&department=#attributes.department#'>
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
		</cf_box>
	<!--- 	</cfsavecontent>
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<cfoutput>#wrk_content_clear(excel_icerik)#</cfoutput>
		<cfelse>
			<cfoutput>#excel_icerik#</cfoutput>
		</cfif> --->
	</cfif>
</div>
<script type="text/javascript">
	function kontrol_tarih()
	{
		if(!$("#date1").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57738.Başlama Tarihi Girmelisiniz'> !</cfoutput>"})    
			return false;
		}
		if(!$("#date2").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'> !</cfoutput>"}) 
			return false;
		}
		if(list_acc_card.date1.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_acc_card.date1.value, "<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>"))
				return false;
		}
		if(list_acc_card.date2.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_acc_card.date2.value, "<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>"))
				return false;
		}
		if(document.list_acc_card.is_excel.checked==false)
		{
			document.list_acc_card.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_account_card</cfoutput>";
			return true;
		}
		else
		{	
			document.list_acc_card.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_list_account_card</cfoutput>";
			document.list_acc_card.submit();
		}
	}
	function pencere_ac()
	{
		if((document.list_acc_card.date1.value=='') || (document.list_acc_card.date2.value==''))
			{
			alert("<cf_get_lang dictionary_id ='47459.Önce Tarihleri Seçiniz'>!");
			return false;
			}
			date1 = document.list_acc_card.date1.value;
			date2 = document.list_acc_card.date2.value;
			if(document.list_acc_card.is_detail.checked==true)
				is_detail = 1;
			else
				is_detail = 0;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_rapor_yevmiye&date1='+date1+'&date2='+date2+'&is_detail='+is_detail,'norm_horizontal');
	}
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById("branch_id").value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popupajax_list_departments&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		else
		{
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang dictionary_id="57572.Departman">'));
			myList.appendChild(txtFld);
		}
	}
</script>
