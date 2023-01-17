<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="account.list_kebir">
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
<cfparam name="attributes.name1" default="">
<cfparam name="attributes.name2" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.form_is_submitted" default=0>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_quantity" default="0">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_sub_project" default="">
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih="attributes.date1">
	<cfset attributes.date1 = dateformat(attributes.date1,dateformat_style) >
<cfelse>
	<cfset attributes.date1 = "1/#month(now())#/#session.ep.period_year#">
</cfif>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih="attributes.date2">
	<cfset attributes.date2 = dateformat(attributes.date2,dateformat_style)>
<cfelse>
	<cfset attributes.date2 = "#daysinmonth(now())#/#month(now())#/#session.ep.period_year#">
</cfif>
<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
	<cfset attributes.form_is_submitted = 1>
<cfelse>
	<cfset attributes.form_is_submitted = 0>
</cfif>
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

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_kebir" action="#request.self#?fuseaction=account.list_kebir" method="post">
			<cf_box_search>
				<input type="hidden" name="form_is_submitted" id="form_is_submitted" value="1">
				<div class="form-group">
					<label class="col col-3 col-md-3 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'> *</label>
					<cf_wrk_multi_account_code form_name='list_kebir' acc_code1_1='#attributes.acc_code1_1#' acc_code2_1='#attributes.acc_code2_1#' acc_code1_2='#attributes.acc_code1_2#' acc_code2_2='#attributes.acc_code2_2#' acc_code1_3='#attributes.acc_code1_3#' acc_code2_3='#attributes.acc_code2_3#' acc_code1_4='#attributes.acc_code1_4#' acc_code2_4='#attributes.acc_code2_4#' acc_code1_5='#attributes.acc_code1_5#' acc_code2_5='#attributes.acc_code2_5#' is_multi='#is_select_multi_acc_code#'><!---  is_multi='#is_select_multi_acc_code#'--->
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput value="#attributes.date1#" type="text" name="date1" required="yes" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput value="#attributes.date2#" type="text" name="date2" required="yes" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
					</div>
				</div>
				<div class="form-group">
					<label><input type="checkbox" name="is_quantity" id="is_quantity" value="1" <cfif attributes.is_quantity eq 1>checked</cfif>><cf_get_lang dictionary_id='47527.Miktar Goster'></label>
				</div>
				<div class="form-group">
					<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
				</div>
				<div class="form-group small">
					<div class="input-group">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" >
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='search_kontrol()' is_excelbuton="0" is_wordbuton="0" is_pdfbuton="0" is_mailbuton="0">
				</div>
				<div class="form-group">
					<cfif get_module_user(33) and not listfindnocase(denied_pages,'report.popup_rapor_kebir')>
						<a class="ui-btn ui-btn-gray" href="javascript://" onClick="pencere_ac();"><i class="fa fa-file" alt="<cf_get_lang dictionary_id ='58600.Dosya Oluştur'>" title="<cf_get_lang dictionary_id ='58600.Dosya Oluştur'>"></i></a> 
					</cfif>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-acc_card_type">
						<label class="col col-12"><cfoutput>#getLang(86,'Fiş Türü',47348)#</cfoutput></label>
						<div class="col col-12">
							<cfquery name="get_acc_card_type" datasource="#dsn3#">
								SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
							</cfquery>
								<cf_multiselect_check
								name="acc_card_type"
								option_name="process_cat"
								option_value="process_type-process_cat_id"
								value="#attributes.acc_card_type#"
								query_name="get_acc_card_type">
						</div>
					</div>
					<div class="form-group" id="item-acc_code_type">
						<label class="col col-12"><cfoutput>#getLang(647,'Düzenleme Tipi',37658)#</cfoutput></label>
						<div class="col col-12">
							<select name="acc_code_type" id="acc_code_type" style="width:90px;">
								<option value="0" <cfif attributes.acc_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
								<option value="1" <cfif attributes.acc_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58308.UFRS'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-">
						<label class="col col-12"><cfoutput>#getLang(4,'Proje',57416)#</cfoutput></label>
						<div class="col col-12">
							<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
							<cfset project_id_ = attributes.project_id>
							<cfelse>
								<cfset project_id_ = ''>
							</cfif>
							<cf_wrkProject
								project_Id="#project_id_#"
								AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
								boxwidth="600"
								boxheight="400">
						</div>
					</div>
					<div class="form-group" id="item-department">
						<label class="col col-12"><cf_get_lang dictionary_id="57572.Departman"></label>
						<div class="col col-12">
							<select name="department" id="department" style="width:120px;">
							<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
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
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-branch_id">
						<label class="col col-12"><cf_get_lang dictionary_id="57453.Şube"></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" style="width:120px;">
							<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
							<cfoutput query="get_branches" group="NICK_NAME">
								<optgroup label="#NICK_NAME#"></optgroup>
								<cfoutput>
									<option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>&nbsp;&nbsp;&nbsp;#BRANCH_NAME#</option>
								</cfoutput>
							</cfoutput>
						</select>
						</div>
					</div>
					<div class="form-group" id="item-is_sub_project">
						<label class="col col-12 hide"><cfoutput>#getLang(302,'Alt Projeleri Getir',47564)#</cfoutput></label>
						<label><input type="checkbox" name="is_sub_project" id="is_sub_project" value="1" <cfif attributes.is_sub_project eq 1>checked</cfif>><cfoutput>#getLang(302,'Alt Projeleri Getir',47564)#</cfoutput></label>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	
<cfif attributes.form_is_submitted eq 1>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
	</cfif>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">
	<cfquery name="GET_ACCOUNT_NAME" datasource="#dsn2#">
		SELECT
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
			IFRS_CODE AS ACCOUNT_CODE,
			IFRS_NAME AS ACCOUNT_NAME
		<cfelse>
			ACCOUNT_CODE, 
			ACCOUNT_NAME 
		</cfif>
		FROM 
			ACCOUNT_PLAN 
		WHERE
			<cfif len(evaluate("attributes.acc_code1_1")) or len(evaluate("attributes.acc_code1_2")) or len(evaluate("attributes.acc_code1_3")) or len(evaluate("attributes.acc_code1_4")) or len(evaluate("attributes.acc_code1_5"))>
				(
					<cfloop from="1" to="5" index="kk">
						<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
							<cfif kk neq 1>OR</cfif>
							(
								1 = 1
								<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
									AND (<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>IFRS_CODE<cfelse>ACCOUNT_CODE</cfif> >= '#evaluate("attributes.acc_code1_#kk#")#' OR <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>IFRS_CODE<cfelse>ACCOUNT_CODE</cfif> = '#left(evaluate("attributes.acc_code1_#kk#"),3)#')
								</cfif>
								<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
									AND (<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>IFRS_CODE<cfelse>ACCOUNT_CODE</cfif> <= '#evaluate("attributes.acc_code2_#kk#")#' OR <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>IFRS_CODE<cfelse>ACCOUNT_CODE</cfif> = '#left(evaluate("attributes.acc_code2_#kk#"),3)#')
								</cfif>
							)
						</cfif>
					</cfloop>
				)
			</cfif>
		ORDER BY 
			<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
				IFRS_CODE
			<cfelse>
				ACCOUNT_CODE
			</cfif>
	</cfquery>
	<cfset acc_code_list = valuelist(GET_ACCOUNT_NAME.ACCOUNT_CODE,"█")> <!--- ayrac = alt+987 --->
	<cfset acc_hesap_list = valuelist(GET_ACCOUNT_NAME.ACCOUNT_NAME,"█")>
	<cfquery name="get_account_id" dbtype="query">
		  SELECT
			  ACCOUNT_CODE, 
			  ACCOUNT_NAME 
		  FROM 
			  GET_ACCOUNT_NAME 
		  WHERE 
			  ACCOUNT_CODE NOT LIKE '%.%'
		  ORDER BY
			  ACCOUNT_CODE
	</cfquery>
	<cfoutput query="get_account_id">
		<cfloop from="1" to="5" index="kk">
			<cfif isDefined("attributes.acc_code1_#kk#") and evaluate("attributes.acc_code1_#kk#") eq get_account_id.account_code>
				<cfset "attributes.new_acc_code1_#get_account_id.currentrow#" = evaluate("attributes.acc_code1_#kk#")>
				<cfset "attributes.new_acc_code2_#get_account_id.currentrow#" = evaluate("attributes.acc_code2_#kk#")>
			</cfif>
		</cfloop>
	</cfoutput>
	<cfset attributes.totalrecords=get_account_id.recordcount>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset endrow=attributes.maxrows+attributes.startrow-1>
	<cfif attributes.totalrecords lt endrow><cfset endrow=attributes.totalrecords></cfif>
	<cfif isdefined('get_account_id.recordcount')>
		<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
			<cfset endrow=get_account_id.recordcount>
		</cfif>
	</cfif>
		<cfloop from="#attributes.startrow#" to="#endrow#" index="i">
			<cfset alacak_bakiye = 0>
			<cfset borc_bakiye = 0>
			<cfset bakiye = 0>
			<cfquery name="get_account_card_rows" datasource="#dsn2#">
				SELECT 
					AC.BILL_NO, 
					AC.CARD_TYPE, 
					AC.CARD_TYPE_NO, 
					AC.RECORD_DATE, 
					AC.CARD_DETAIL AS DETAIL,
					AC.ACTION_DATE, 
					ACR.AMOUNT,
					<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
						ACC_P.IFRS_CODE AS ACCOUNT_ID,
					<cfelse>
						ACR.ACCOUNT_ID,
					</cfif>
					ACR.BA,
					ACR.ACC_DEPARTMENT_ID,
					ACR.ACC_BRANCH_ID,
					ACR.ACC_PROJECT_ID,
					ACR.QUANTITY
				FROM 
					ACCOUNT_CARD AC, 
					ACCOUNT_CARD_ROWS ACR 
					<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
						,ACCOUNT_PLAN ACC_P
					</cfif>
				WHERE 
					AC.CARD_ID=ACR.CARD_ID
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
						AND (
						<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
							(AC.CARD_TYPE = #listfirst(type_ii,'-')# AND AC.CARD_CAT_ID = #listlast(type_ii,'-')#)
							<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
						</cfloop>  
							)
					</cfif>
					<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
						AND ACR.ACCOUNT_ID=ACC_P.ACCOUNT_CODE
					</cfif>
					<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
						AND ACR.ACCOUNT_ID=ACC_P.ACCOUNT_CODE
						AND ACR.IFRS_CODE LIKE '#get_account_id.ACCOUNT_CODE[i]#%'
					<cfelse>
						AND ACR.ACCOUNT_ID LIKE '#get_account_id.ACCOUNT_CODE[i]#%'
					</cfif>
					<cfif isdefined("attributes.date1") and len(attributes.date1)>
						AND AC.ACTION_DATE >= #attributes.date1#
					</cfif>
					<cfif isdefined("attributes.date2") and len(attributes.date2)>
						AND AC.ACTION_DATE <= #attributes.date2#
					</cfif>
					<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
						<cfif attributes.is_sub_project eq 1>
							AND ISNULL((SELECT RELATED_PROJECT_ID FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACR.ACC_PROJECT_ID),ACR.ACC_PROJECT_ID) = #attributes.project_id#
						<cfelse>	
							AND ACR.ACC_PROJECT_ID = #attributes.project_id#
						</cfif>
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND ACR.ACC_BRANCH_ID = #attributes.branch_id# 
					</cfif>
					<cfif isdefined("attributes.department") and len(attributes.department)>
						AND ACR.ACC_DEPARTMENT_ID = #attributes.department# 
					</cfif>	
					<cfif len(evaluate("attributes.acc_code1_1")) or len(evaluate("attributes.acc_code1_2")) or len(evaluate("attributes.acc_code1_3")) or len(evaluate("attributes.acc_code1_4")) or len(evaluate("attributes.acc_code1_5"))>
						AND (
							<cfloop from="1" to="5" index="kk">
								<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
									<cfif kk neq 1>OR</cfif>
									(
										1 = 1
										<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
											AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACR.IFRS_CODE<cfelse>ACR.ACCOUNT_ID</cfif> >= '#evaluate("attributes.acc_code1_#kk#")#'
										</cfif>
										<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
											AND <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>ACR.IFRS_CODE<cfelse>ACR.ACCOUNT_ID</cfif> <= '#evaluate("attributes.acc_code2_#kk#")#'
										</cfif>
									)
								</cfif>
							</cfloop>
						)
					</cfif>
				ORDER BY
					<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)>
						ACR.ACCOUNT_ID ASC,
					<cfelse>
						ACR.ACCOUNT_ID ASC,
					</cfif>
					AC.BILL_NO
			</cfquery>
			
		<cf_box title="#getLang(21,'Defter-i Kebir',47283)#" uidrop="1" hide_table_column="1">
			<cf_grid_list>     
				<thead>
					<tr>
						<th colspan="13"><cfoutput>#get_account_id.ACCOUNT_CODE[i]# / <cfif listfind(acc_code_list,get_account_id.ACCOUNT_CODE[i],"█")>#listgetat(acc_hesap_list,listfind(acc_code_list,get_account_id.ACCOUNT_CODE[i],"█"),"█")#</cfif></cfoutput></th>
					</tr>
					<tr>
						<th><cf_get_lang dictionary_id ='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='57946.Fiş No'></th>
						<th><cf_get_lang dictionary_id ='39373.Yev No'></th>
						<th><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id ='47284.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id ='47299.Hesap Kodu'></cfif></th>
						<cfif is_acc_branch><th><cf_get_lang dictionary_id='57453.Sube'></th></cfif>
						<cfif is_acc_department><th><cf_get_lang dictionary_id='57572.Departman'></th></cfif>
						<cfif is_acc_project><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
						<th><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id ='47296.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id ='47300.Hesap Adı'></cfif></th>
						<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
						<cfif isdefined("attributes.is_quantity") and attributes.is_quantity eq 1>
							<th><cf_get_lang dictionary_id='57635.Miktar'></th>
						</cfif>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></th>
						<th style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></th>
					</tr>
				</thead>
				<tbody>
					<cfset colspan_ = 9>
					<cfset dep_id_list=''>
					<cfset branch_id_list=''>
					<cfset project_id_list = ''>
					<cfoutput query="get_account_card_rows">
						<cfif isdefined("acc_department_id") and len(acc_department_id) and not listfind(dep_id_list,acc_department_id)>
						<cfset dep_id_list=listappend(dep_id_list,acc_department_id)>
						</cfif>
						<cfif isdefined("acc_branch_id") and len(acc_branch_id) and not listfind(branch_id_list,acc_branch_id)>
							<cfset branch_id_list=listappend(branch_id_list,acc_branch_id)>
						</cfif>
						<cfif isdefined("acc_project_id") and len(acc_project_id) and not listfind(project_id_list,acc_project_id)>
							<cfset project_id_list=listappend(project_id_list,acc_project_id)>
						</cfif>
					</cfoutput>
					<cfif listlen(dep_id_list)>
						<cfset dep_id_list=listsort(dep_id_list,"numeric","ASC",",")>
						<cfquery name="get_dep_detail" datasource="#dsn#">
							SELECT
								D.DEPARTMENT_HEAD,
								B.BRANCH_NAME
							FROM
								DEPARTMENT D,
								BRANCH B
							WHERE
								D.BRANCH_ID=B.BRANCH_ID
								AND D.DEPARTMENT_ID IN (#dep_id_list#)
							ORDER BY
								D.DEPARTMENT_ID
						</cfquery>
					</cfif>
					<cfif listlen(branch_id_list)>
						<cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
						<cfquery name="GET_BRANCH" datasource="#dsn#">
							SELECT
								BRANCH_ID,
								BRANCH_NAME
							FROM
								BRANCH               
							WHERE
								BRANCH_ID IN (#branch_id_list#)
							ORDER BY 
								BRANCH_ID
						</cfquery>
					</cfif>
					<cfif listlen(project_id_list)>
						<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
						<cfquery name="get_pro_detail" datasource="#dsn#">
							SELECT
								PROJECT_ID,
								PROJECT_HEAD
							FROM
								PRO_PROJECTS               
							WHERE
								PROJECT_ID IN (#project_id_list#)
							ORDER BY 
								PROJECT_ID
						</cfquery>
					</cfif>
					<cfif is_acc_branch><cfset colspan_ = colspan_ + 1></cfif>
					<cfif is_acc_department><cfset colspan_ = colspan_ + 1></cfif>
					<cfif is_acc_project><cfset colspan_ = colspan_ + 1></cfif>
					<cfif isdefined("attributes.is_quantity") and attributes.is_quantity eq 1><cfset colspan_ = colspan_ + 1></cfif>
					<cfif get_account_card_rows.recordcount>
						<cfoutput query="get_account_card_rows">
							<tr class="color-row" height="20">
								<td>#dateformat(get_account_card_rows.ACTION_DATE,dateformat_style)#</td>
								<td>#CARD_TYPE_NO#</td>
								<td>#BILL_NO#</td>
								<td>&nbsp;#ACCOUNT_ID#</td>
								<cfif is_acc_branch>
									<td>
										<cfif isdefined("ACC_BRANCH_ID") and  len(ACC_BRANCH_ID)>#get_branch.branch_name[listfind(branch_id_list,acc_branch_id,',')]#</cfif>
									</td>
								</cfif>
								<cfif is_acc_department>
									<td>
										<cfif isdefined("ACC_DEPARTMENT_ID") and len(ACC_DEPARTMENT_ID)>#get_dep_detail.BRANCH_NAME[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]# - #get_dep_detail.DEPARTMENT_HEAD[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]#</cfif>
									</td>
								</cfif>
								<cfif is_acc_project>
									<td>
										<cfif isdefined("ACC_PROJECT_ID") and len(ACC_PROJECT_ID)>#get_pro_detail.PROJECT_HEAD[listfind(project_id_list,ACC_PROJECT_ID,',')]#</cfif>
									</td>
								</cfif>
								<td nowrap="nowrap">
									<cfif listfind(acc_code_list,ACCOUNT_ID,"█")>
											#listgetat(acc_hesap_list,listfind(acc_code_list,ACCOUNT_ID,"█"),"█")#
									<cfelse>
											<font color="FF0000">!!<cf_get_lang dictionary_id ='47475.Hesap Yok'>  !!</font>
									</cfif>
								</td>
								<td>#DETAIL#</td>
								<cfif isdefined("attributes.is_quantity") and attributes.is_quantity eq 1>
									<td>#TLFormat(QUANTITY)#</td>
								</cfif>
								<cfif BA > <!--- eq 1 : alacak --->
									<cfset alacak_bakiye = alacak_bakiye + AMOUNT>
									<td style="text-align:right;" nowrap="nowrap">&nbsp;</td>
									<td style="text-align:right;" nowrap="nowrap">#TLFormat(AMOUNT)#</td>
								<cfelse> <!--- borc --->
									<cfset borc_bakiye = borc_bakiye + AMOUNT>
									<td style="text-align:right;" nowrap="nowrap">#TLFormat(AMOUNT)#</td>
									<td style="text-align:right;" nowrap="nowrap">&nbsp;</td>
								</cfif>
								<td style="text-align:right;" nowrap="nowrap">
									<cfif borc_bakiye gt alacak_bakiye>
									<cfset bakiye = borc_bakiye - alacak_bakiye>
										#TlFormat(bakiye)#(B)
									<cfelse>
									<cfset bakiye = alacak_bakiye - borc_bakiye>
										#TlFormat(bakiye)#(A)
									</cfif>
								</td>
							</tr>	
						</cfoutput>	
					<cfelse>
						<tr>
							<td colspan="<cfoutput>#colspan_#</cfoutput>"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
						</tr>
					</cfif>				
				</tbody>
			</cf_grid_list>
		</cf_box>

		</cfloop>
		<cfset adres="account.list_kebir">
		<cfif isdefined("attributes.date1")>
			<cfset adres='#adres#&date1=#dateFormat(attributes.date1,dateformat_style)#'>
			<cfset adres='#adres#&date2=#dateFormat(attributes.date2,dateformat_style)#'>
		</cfif>
		<cfset adres='#adres#&is_quantity=#attributes.is_quantity#'>
		<cfif len(attributes.acc_code1_1)><cfset adres = "#adres#&acc_code1_1=#attributes.acc_code1_1#"></cfif>
		<cfif len(attributes.acc_code2_1)><cfset adres = "#adres#&acc_code2_1=#attributes.acc_code2_1#"></cfif>
		<cfif len(attributes.acc_code1_2)><cfset adres = "#adres#&acc_code1_2=#attributes.acc_code1_2#"></cfif>
		<cfif len(attributes.acc_code2_2)><cfset adres = "#adres#&acc_code2_2=#attributes.acc_code2_2#"></cfif>
		<cfif len(attributes.acc_code1_3)><cfset adres = "#adres#&acc_code1_3=#attributes.acc_code1_3#"></cfif>
		<cfif len(attributes.acc_code2_3)><cfset adres = "#adres#&acc_code2_3=#attributes.acc_code2_3#"></cfif>
		<cfif len(attributes.acc_code1_4)><cfset adres = "#adres#&acc_code1_4=#attributes.acc_code1_4#"></cfif>
		<cfif len(attributes.acc_code2_4)><cfset adres = "#adres#&acc_code2_4=#attributes.acc_code2_4#"></cfif>
		<cfif len(attributes.acc_code1_5)><cfset adres = "#adres#&acc_code1_5=#attributes.acc_code1_5#"></cfif>
		<cfif len(attributes.acc_code2_5)><cfset adres = "#adres#&acc_code2_5=#attributes.acc_code2_5#"></cfif>
		<cfif isDefined('attributes.name1') and len(attributes.name1)><cfset adres = adres&"&name1="&attributes.name1></cfif>
		<cfif isDefined('attributes.name2') and len(attributes.name2)><cfset adres = adres&"&name2="&attributes.name2></cfif>
		<cfif isDefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
			<cfset adres = adres&"&acc_card_type="&attributes.acc_card_type>
		</cfif>
		<cfif isdefined("attributes.acc_code_type") and len(attributes.acc_code_type)>
			<cfset adres='#adres#&acc_code_type=#attributes.acc_code_type#'>
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
			adres="#adres#&form_is_submitted=1">
</div>
</cfif>
<script type="text/javascript">
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
	function search_kontrol()
	{
		if(!$("#maxrows").val().length)
		  {
			  alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfoutput>"})    
			  return false;
		  }
		if(list_kebir.date1.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_kebir.date1.value, 'Başlangıç Tarihi'))
				return false;
		}
		if(list_kebir.date2.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_kebir.date2.value, 'Bitiş Tarihi'))
				return false;
		}
		if((document.list_kebir.acc_code1_1.value=='') || (document.list_kebir.acc_code2_1.value==''))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id ='58811.Muhasebe Kodu'>");
			return false;
		}
		if(document.list_kebir.is_excel.checked==false)
		{
			document.list_kebir.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_kebir</cfoutput>";
			return true;
		}
		else
		{
			document.list_kebir.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_list_kebir</cfoutput>";
			document.list_kebir.submit();
		}
	}
	function pencere_ac_kebir(str_alan_1,str_alan_2,str_alan){
		var txt_keyword = eval(str_alan + ".value" );
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_2+'&keyword='+txt_keyword,'list');
	}
	
	function pencere_ac()
	{
		if((document.list_kebir.acc_code1_1.value=='') || (document.list_kebir.acc_code2_1.value==''))
		{
			alert("<cf_get_lang dictionary_id ='47458.Önce Hesap Kodlarını Seçiniz'>!");
			return false;
		}
		if((document.list_kebir.date1.value=='') || (document.list_kebir.date2.value==''))
		{
			alert("<cf_get_lang dictionary_id ='47459.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		if (!search_kontrol())
			return false;
		code1=document.list_kebir.acc_code1_1.value;
		code2=document.list_kebir.acc_code2_1.value;
		date1=document.list_kebir.date1.value;
		date2=document.list_kebir.date2.value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_rapor_kebir&date1='+date1+'&date2='+date2+'&code1='+code1+'&code2='+code2,'wide');
	}
</script>
<br />

