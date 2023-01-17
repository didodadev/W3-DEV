<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.title_id" default="0">
<cfparam name="attributes.position_cat_id" default="0">
<cfparam name="attributes.comp_id" default="0">
<cfparam name="attributes.is_form_submit" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.branch_id" default="">
<cfquery name="get_pos_type" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="titles" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfquery name="get_quizes" datasource="#dsn#">
	SELECT 
		EQ.QUIZ_ID,
		EQ.QUIZ_HEAD
	FROM 
		EMPLOYEE_QUIZ EQ
	WHERE
		EQ.QUIZ_ID IS NOT NULL 
		AND EQ.IS_EDUCATION <> 1
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY
		BRANCH_ID
</cfquery>
<cfquery name="get_company_name" datasource="#dsn#">
	SELECT NICK_NAME,COMP_ID,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID IN 
		(SELECT 
			O.COMP_ID
		FROM 
			BRANCH B,OUR_COMPANY O 
		WHERE 
			B.COMPANY_ID = O.COMP_ID AND
			B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		)
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfif attributes.is_form_submit>
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
		<cf_date tarih="attributes.start_date">
	</cfif>
	<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		<cf_date tarih="attributes.finish_date">
	</cfif>
	<cfquery name="GET_PERF_RESULTS" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_NO,
			EI.TC_IDENTY_NO,
			EP.POSITION_NAME,
			ST.TITLE,
			SPC.POSITION_CAT,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME,
			O.NICK_NAME,
			EMP_P.MANAGER_POINT AS AMIR1_PUAN,
			EMP_P.USER_POINT AS AMIR2_PUAN,
			EQ.QUIZ_HEAD
		FROM
			EMPLOYEES E,
			EMPLOYEES_IDENTY EI,
			EMPLOYEE_POSITIONS EP,
			SETUP_TITLE ST,
			SETUP_POSITION_CAT SPC,
			DEPARTMENT D,
			BRANCH B,
			OUR_COMPANY O,
			EMPLOYEE_PERFORMANCE EMP_P,
			EMPLOYEE_QUIZ EQ,
			EMPLOYEE_QUIZ_RESULTS EQR
		WHERE
			EMP_P.RESULT_ID = EQR.RESULT_ID AND
			EQR.QUIZ_ID = EQ.QUIZ_ID AND
			EMP_P.EMP_ID = E.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			EP.IS_MASTER = 1 AND
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = O.COMP_ID AND
			ST.TITLE_ID = EP.TITLE_ID AND
			SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
			<cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>
				AND EQR.QUIZ_ID = #attributes.quiz_id#
			</cfif>	
			<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND O.COMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
			</cfif>	
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
			</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND O.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				AND D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">)
			</cfif>
			<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
				AND ST.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#" list = "yes">)
			</cfif>
			<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
				AND SPC.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#" list = "yes">)
			</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND 
					(
					E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
					OR
					EP.POSITION_NAME LIKE '%#attributes.keyword#%'
					OR
					EI.TC_IDENTY_NO = '#attributes.keyword#'
					)
			</cfif>
			<cfif isDefined("attributes.start_date")>
			<cfif len(attributes.start_date) AND len(attributes.start_date)>
				<!--- IKI TARIH DE VAR --->
				AND
				(
					(
					EMP_P.START_DATE >= #attributes.start_date# AND
					EMP_P.START_DATE < #DATEADD("d",1,attributes.finish_date)#
					)
				OR
					(
					EMP_P.START_DATE <= #attributes.start_date# AND
					EMP_P.FINISH_DATE >= #attributes.start_date#
					)
				)
				<cfelseif len(attributes.start_date)>
				<!--- SADECE BAŞLANGIÇ --->
				AND
				(
				EMP_P.START_DATE >= #attributes.start_date#
				OR
					(
					EMP_P.START_DATE < #attributes.start_date# AND
					EMP_P.FINISH_DATE >= #attributes.start_date#
					)
				)
				<cfelseif len(attributes.finish_date)>
				<!--- SADECE BITIŞ --->
				AND
				(
				EMP_P.FINISH_DATE < #DATEADD("d",1,attributes.finish_date)#
				OR
					(
					EMP_P.START_DATE <= #DATEADD("d",1,attributes.finish_date)# AND
					EMP_P.FINISH_DATE > #DATEADD("d",1,attributes.finish_date)#
					)
				)
				</cfif>
			</cfif>
	</cfquery>
<cfelse>
	<cfset GET_PERF_RESULTS.recordcount = 0>
</cfif>

<cfset url_str = "">
<cfif attributes.is_form_submit>
	<cfset url_str = '#url_str#&is_form_submit=1'>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.department") and len(attributes.department)>
	  <cfset url_str = "#url_str#&department=#attributes.department#">
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		<cfset url_str="#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
	  <cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
	</cfif>
	<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
	  <cfset url_str = "#url_str#&title_id=#attributes.title_id#">
	</cfif>
	<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
	  <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
	</cfif>	
	<cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>
	  <cfset url_str = "#url_str#&quiz_id=#attributes.quiz_id#">
	</cfif>
	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>	
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default=#get_perf_results.recordcount#>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39237.Performans Sonuç Raporu'></cfsavecontent>
<cfform name="list_perform" method="post" action="#request.self#?fuseaction=report.perform_report_results">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id="57460.Filtre"></label>
												<div class="col col-12 col-md-12">
													<cfinput name="keyword" type="text" value="#attributes.keyword#">
												</div>
											</div>
										</div>
										<div class="form-group">	
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id="57574.Şirket"></label>
												<div class="col col-12">
													<div class="multiselect-z2">
														<cf_multiselect_check 
														query_name="get_company_name"  
														name="comp_id"
														option_value="COMP_ID"
														option_name="COMPANY_NAME"
														option_text="#getLang('main',322)#"
														value="#attributes.comp_id#"
														onchange="get_branch_list(this.value)">
													</div>													
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id="57453.Şube"></label>
												<div class="col col-12">
													<div id="BRANCH_PLACE" class="multiselect-z2">
														<cf_multiselect_check 
														query_name="get_branchs"  
														name="branch_id"
														option_value="BRANCH_ID"
														option_name="BRANCH_NAME"
														option_text="#getLang('main',322)#"
														value="#attributes.branch_id#"
														onchange="get_department_list(this.value)">
													</div>
													
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id="57572.Departman"></label>
												<div class="col col-12 col-md-12 col-xs-12">
													<div class="multiselect-z2" id="DEPARTMENT_PLACE">
														<cf_multiselect_check 
														query_name="get_department"  
														name="department"
														option_text="#getLang('main',322)#" 
														option_value="department_id"
														option_name="department_head"
														value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
													</div>
												</div>										
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id='51197.Form Tipi	'></label>
												<div class="col col-12">
													<select name="quiz_id" id="quiz_id">
														<option value=""><cf_get_lang dictionary_id="39238.Performans Formu"></option>
														<cfoutput query="get_quizes">
															<option value="#quiz_id#" <cfif isdefined("attributes.quiz_id") and attributes.quiz_id eq quiz_id>selected</cfif>>#quiz_head#</option>
														</cfoutput>
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id="57779.Pozisyon Tipleri"></label>
												<div class="col col-12">
													<div class="multiselect-z1">
														<cf_multiselect_check 
														query_name="get_pos_type"  
														name="position_cat_id"
														option_value="POSITION_CAT_ID"
														option_name="POSITION_CAT"
														option_text="#getLang('main',322)#"
														value="#attributes.position_cat_id#">
													</div>													
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
												<div class="col col-12">
													<div class="multiselect-z1">
														<cf_multiselect_check 
														query_name="titles"  
														name="title_id"
														option_value="TITLE_ID"
														option_name="TITLE"
														option_text="#getLang('main',322)#"
														value="#attributes.title_id#">
													</div>						
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id="58053.başlangıç"></label>
												<div class="col col-12 col-md-12">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="58053.Baslangıç Tarihi"></cfsavecontent>
														<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
														<span class="input-group-addon">
														<cf_wrk_date_image date_field="start_date">
														</span>
													</div>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12">
												<label class="col col-12 col-md-12"><cf_get_lang dictionary_id="57700.bitiş"></label>
												<div class="col col-12 col-md-12">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
														<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
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
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_form_submit" id="is_form_submit" value="1" type="hidden">
							<cf_wrk_report_search_button button_type="1" is_excel="1" search_function="control()">	
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
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submit") and attributes.is_form_submit eq 1>
	<cf_report_list>
		<thead>
		<tr height="22"> 
			<th><cf_get_lang dictionary_id="58577.Sıra"></th>
			<th><cf_get_lang dictionary_id="58025.TC Kimlik No"></th>
			<th><cf_get_lang dictionary_id="58487.Çalışan No"></th>
			<th><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
			<th><cf_get_lang dictionary_id="57750.İşyeri Adı"></th>
			<th><cf_get_lang dictionary_id="57453.Şube"></th>
			<th><cf_get_lang dictionary_id="57572.Departman"></th>
			<th><cf_get_lang dictionary_id="59004.Pozisyon Tipi"></th>
			<th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
			<th><cf_get_lang dictionary_id="57571.Ünvan"></th>
			<th><cf_get_lang dictionary_id="58003.Performans"></th>
			<th>1.<cf_get_lang dictionary_id="39245.Amir Notu"></th>
			<th>2.<cf_get_lang dictionary_id="39245.Amir Notu"></th>
			<th><cf_get_lang dictionary_id="39247.Ortalama Puan"></th>
		</tr>
		</thead>
		<cfset total_puan_amir1_ = 0>
		<cfset total_kisi_amir1_ = 0>
		<cfset total_puan_amir2_ = 0>
		<cfset total_kisi_amir2_ = 0>
		<cfset total_puan_genel_ = 0>
		<cfset total_kisi_genel_ = 0>
		<cfif get_perf_results.recordcount>
			<cfif type_ eq 1>
				<cfset attributes.maxrows = attributes.totalrecords>
			<cfelse>
			</cfif>
			<tbody>
			<cfoutput query="get_perf_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#TC_IDENTY_NO#</td>
					<td>#EMPLOYEE_NO#</td>
					<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
					<td>#nick_name#</td>
					<td>#BRANCH_NAME#</td>
					<td>#DEPARTMENT_HEAD#</td>
					<td>#POSITION_CAT#</td>
					<td>#POSITION_NAME#</td>
					<td>#TITLE#</td>
					<td>#QUIZ_HEAD#</td>
					<td align="right" format="numeric"><cfif len(AMIR1_PUAN)>#WRK_ROUND(AMIR1_PUAN)#</cfif></td>
					<td align="right" format="numeric"><cfif len(AMIR2_PUAN)>#WRK_ROUND(AMIR2_PUAN)#</cfif></td>
					<cfset kisi_ort_ = 0>
					<cfset kisi_ort_say_ = 0>
					<cfif len(AMIR1_PUAN)>
						<cfset total_puan_amir1_ = total_puan_amir1_ + AMIR1_PUAN>
						<cfset total_kisi_amir1_ = total_kisi_amir1_ + 1>
						<cfset kisi_ort_ = AMIR1_PUAN>
						<cfset kisi_ort_say_ = 1>
					</cfif>
					<cfif len(AMIR2_PUAN)>
						<cfset total_puan_amir2_ = total_puan_amir2_ + AMIR2_PUAN>
						<cfset total_kisi_amir2_ = total_kisi_amir2_ + 1>
						<cfset kisi_ort_ = kisi_ort_ + AMIR2_PUAN>
						<cfset kisi_ort_say_ = kisi_ort_say_ + 1>
					</cfif>
						<td align="right">
					<cfif kisi_ort_say_ gt 0>
						<cfset GENEL_PUAN = kisi_ort_ / kisi_ort_say_>
						#WRK_ROUND(GENEL_PUAN)#
					<cfelse>
						<cfset GENEL_PUAN = 0>
					</cfif>
						</td>
					<cfif GENEL_PUAN gt 0>
						<cfset total_puan_genel_ = total_puan_genel_ + GENEL_PUAN>
						<cfset total_kisi_genel_ = total_kisi_genel_ + 1>
					</cfif>
				</tr>
			</cfoutput>
			</tbody>
			<cfoutput>
			<tfoot>
				<tr height="20">
					<cfif type_ eq 1>
					<cfset class_ = "txtbold">
					<cfelse>
					<cfset class_ = "txtboldblue">			  	
					</cfif>
					<td colspan="11" align="right" class="#class_#"><cf_get_lang dictionary_id="40640.Ortalama"></td>
					<td class="#class_#" align="right" format="numeric"><cfif total_kisi_amir1_>#wrk_round(total_puan_amir1_/total_kisi_amir1_)#</cfif></td>
					<td class="#class_#" align="right" format="numeric"><cfif total_kisi_amir2_>#wrk_round(total_puan_amir2_/total_kisi_amir2_)#</cfif></td>
					<td class="#class_#" align="right" format="numeric"><cfif total_kisi_genel_>#wrk_round(total_puan_genel_/total_kisi_genel_)#</cfif></td>
				</tr>
			</tfoot>
			</cfoutput>
		<cfelse>
		<tbody>
			<tr>
				<td height="20" colspan="14"><cfif attributes.is_form_submit><cf_get_lang dictionary_id='57484.kayıt yok'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
			</tr>
			</tbody>
			</cfif>
	</cf_report_list>
</cfif>			
<cfif attributes.totalrecords gt attributes.maxrows>
<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="report.perform_report_results#url_str#"> </td>
</cfif>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 0>
<script type="text/javascript">
document.getElementById('keyword').focus();
function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
function control()	
	{		if(!date_check(list_perform.start_date,list_perform.finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
			{
			return false;
			}
			if(document.list_perform.is_excel.checked==false)
			{
					document.list_perform.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
					return true;
			}
			else
					document.list_perform.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_perform_report_result</cfoutput>"
    }
</script>
</cfif>
