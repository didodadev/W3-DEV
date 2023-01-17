<!--- TolgaS 20060801 performans formlarından sonuclari getiriyor bölüm bazında --->
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfflush interval="3000">
<cfsetting enablecfoutputonly="no">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.related_year" default="#session.ep.period_year#">
<cfif not isdefined("attributes.RELATED_COMPANY")>
	<cfquery name="get_emp_branch" datasource="#DSN#">
		SELECT
			BRANCH_ID
		FROM
			EMPLOYEE_POSITION_BRANCHES
		WHERE
			POSITION_CODE = #SESSION.EP.POSITION_CODE#
	</cfquery>
	<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>
	<cfquery name="get_branches" datasource="#dsn#">
		SELECT DISTINCT
			RELATED_COMPANY,
			BRANCH_ID,
			BRANCH_NAME
		FROM 
			BRANCH 
		WHERE 
			BRANCH_ID IS NOT NULL
			<cfif not session.ep.ehesap>
				AND BRANCH_ID IN (#emp_branch_list#)
			</cfif>
		ORDER BY 
			BRANCH_NAME
	</cfquery>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='39172.Performans Değerlendirme Bölüm Bazlı'></cfsavecontent>
<cfform name="ara_form" method="post" action="#request.self#?fuseaction=report.emptypopup_perform_report">	
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
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12"><cf_get_lang dictionary_id='39016.Kayıt Tipi Seçiniz'></label>
												<div class="col col-12">
													<select name="record_type" id="record_type">
														<option value=""><cf_get_lang dictionary_id='39017.Tüm Formlar'></option>
														<option value="1" <cfif isdefined("attributes.record_type") and attributes.record_type is 1>selected</cfif>><cf_get_lang dictionary_id='39018.Asıl'></option>
														<option value="2" <cfif isdefined("attributes.record_type") and attributes.record_type is 2>selected</cfif>><cf_get_lang dictionary_id='39019.Görüş'> 1</option>
														<option value="3" <cfif isdefined("attributes.record_type") and attributes.record_type is 3>selected</cfif>><cf_get_lang dictionary_id='39019.Görüş '>2</option>
														<option value="4" <cfif isdefined("attributes.record_type") and attributes.record_type is 4>selected</cfif>><cf_get_lang dictionary_id='39020.Ara Değerlendirme'></option>
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label class="col col-12"><cf_get_lang dictionary_id='30126.Şube Seçiniz'></label>
												<div class="col col-12">
													<select name="RELATED_COMPANY" id="RELATED_COMPANY">
														<option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
													<cfoutput query="get_branches">
														<option value="#BRANCH_ID#" <cfif isdefined("attributes.RELATED_COMPANY") and attributes.RELATED_COMPANY is BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
													</cfoutput>	
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<div class="col col-12 col-md-12 col-xs-12">
													<label class="col col-12 paddingNone"><cf_get_lang dictionary_id='58455.Yıl(1043)'></label>
													<select name="RELATED_YEAR" id="RELATED_YEAR">
														<cfloop from="#session.ep.period_year-5#" to="#session.ep.period_year + 5#" index="ccc">
															<cfoutput><option value="#ccc#" <cfif isdefined("attributes.RELATED_YEAR") and attributes.RELATED_YEAR eq ccc>selected</cfif>>#ccc#</option></cfoutput>
														</cfloop>
													</select>
												</div>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-md-12 col-xs-12">
												<label><input type="checkbox" name="order_type" id="order_type" value="1" <cfif isdefined("attributes.order_type")>checked</cfif>><cf_get_lang dictionary_id='39023.Form Bazında Siralama'></label>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							
							<input type="submit" value="<cf_get_lang dictionary_id='57858.Excel Getir'>">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfelse>
	<cfquery name="GET_PERFORM_1" datasource="#dsn#">
		SELECT
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NO,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES.GROUP_STARTDATE,
			EMPLOYEES_IDENTY.TC_IDENTY_NO,
			EMPLOYEE_PERFORMANCE.PER_ID,
			EMPLOYEE_PERFORMANCE.PERFORM_POINT,
			EMPLOYEE_PERFORMANCE.USER_POINT,
			EMPLOYEE_PERFORMANCE.USER_POINT_OVER_5,
			EMPLOYEE_PERFORMANCE.EMP_PERFORM_POINT,
			EMPLOYEE_PERFORMANCE.EMP_POINT,
			EMPLOYEE_PERFORMANCE.EMP_POINT_OVER_5,
			EMPLOYEE_PERFORMANCE.MANAGER3_PERFORM_POINT,
			EMPLOYEE_PERFORMANCE.MANAGER3_POINT,
			EMPLOYEE_PERFORMANCE.MANAGER3_POINT_OVER_5,
			EMPLOYEE_PERFORMANCE.MANAGER_PERFORM_POINT,
			EMPLOYEE_PERFORMANCE.MANAGER_POINT,
			EMPLOYEE_PERFORMANCE.MANAGER_POINT_OVER_5,
			EMPLOYEE_PERFORMANCE.MAN_EMP_PERFORM_POINT,
			EMPLOYEE_PERFORMANCE.MAN_EMP_POINT,
			EMPLOYEE_PERFORMANCE.MAN_EMP_POINT_OVER_5,
			EMPLOYEE_PERFORMANCE.IS_PERF_SALARY,
			EMPLOYEE_PERFORMANCE.IS_PERF_SALARY_RESULTING,
			EMPLOYEE_PERFORMANCE.RECORD_TYPE,
			EMPLOYEE_QUIZ.QUIZ_ID,
			EMPLOYEE_QUIZ.QUIZ_HEAD,
			EMPLOYEE_QUIZ_CHAPTER.CHAPTER_ID,
			<cfif database_type is 'MSSQL'>
				CAST(EMPLOYEE_QUIZ_CHAPTER.CHAPTER AS NVARCHAR(100)) AS CHAPTER,
			<cfelse>
				CAST(EMPLOYEE_QUIZ_CHAPTER.CHAPTER AS VARGRAPHIC(100)) AS CHAPTER,
			</cfif>
			EMPLOYEE_QUIZ_CHAPTER.CHAPTER_WEIGHT,
			EMPLOYEE_QUIZ_RESULTS_DETAILS.QUESTION_USER_ANSWERS AS QUESTION_POINT,
			EMPLOYEE_QUIZ_RESULTS_DETAILS.QUESTION_MANAGER1_ANSWERS AS QUESTION_POINT_MANAGER1,<!--- birinci amirin isaretledigi şık SG20120727--->
			EMPLOYEE_QUIZ_RESULTS_DETAILS.QUESTION_MANAGER2_ANSWERS AS QUESTION_POINT_MANAGER2,<!--- ikinci amirin isaretledigi şık SG20120727--->
			EMPLOYEE_QUIZ_CHAPTER.*,
			EMPLOYEE_QUIZ_QUESTION.QUESTION_ID,
			EMPLOYEE_QUIZ_RESULTS_DETAILS.GD
		FROM 
			EMPLOYEES,
			EMPLOYEE_PERFORMANCE,
			EMPLOYEE_QUIZ,
			EMPLOYEE_QUIZ_RESULTS,
			EMPLOYEES_IDENTY,
			EMPLOYEE_QUIZ_CHAPTER,
			EMPLOYEE_QUIZ_RESULTS_DETAILS,
			EMPLOYEE_QUIZ_QUESTION,
			EMPLOYEE_QUIZ_CHAPTER_EXPL
		WHERE			
			YEAR(EMPLOYEE_PERFORMANCE.START_DATE) = #attributes.RELATED_YEAR# AND
			<cfif len(attributes.RECORD_TYPE)>EMPLOYEE_PERFORMANCE.RECORD_TYPE=#attributes.RECORD_TYPE# AND</cfif>
			EMPLOYEE_PERFORMANCE.EMP_ID =  EMPLOYEES.EMPLOYEE_ID AND
			EMPLOYEE_PERFORMANCE.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
			EMPLOYEE_QUIZ_RESULTS.RESULT_ID = EMPLOYEE_QUIZ_RESULTS_DETAILS.RESULT_ID AND
			EMPLOYEES_IDENTY.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID AND
			EMPLOYEE_QUIZ.QUIZ_ID = EMPLOYEE_QUIZ_RESULTS.QUIZ_ID AND
			EMPLOYEE_QUIZ_CHAPTER.QUIZ_ID = EMPLOYEE_QUIZ_RESULTS.QUIZ_ID AND		
			EMPLOYEE_QUIZ_QUESTION.CHAPTER_ID=EMPLOYEE_QUIZ_CHAPTER.CHAPTER_ID AND
			EMPLOYEE_QUIZ_QUESTION.QUESTION_ID=EMPLOYEE_QUIZ_RESULTS_DETAILS.QUESTION_ID AND
			EMPLOYEE_QUIZ_CHAPTER_EXPL.CHAPTER_ID=EMPLOYEE_QUIZ_QUESTION.CHAPTER_ID AND
			EMPLOYEE_QUIZ_RESULTS.RESULT_ID=EMPLOYEE_QUIZ_CHAPTER_EXPL.RESULT_ID
	</cfquery>
	<cfquery name="GET_PERFORM_2" datasource="#dsn#">
		SELECT DISTINCT 
			EMPLOYEE_PERFORMANCE.PER_ID AS PER_ID_2,
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			SETUP_TITLE.TITLE,
			SETUP_POSITION_CAT.POSITION_CAT,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			OUR_COMPANY.NICK_NAME,
			BRANCH.RELATED_COMPANY,
			EMPLOYEES.EMPLOYEE_NAME AMIR1_AD,
			EMPLOYEES.EMPLOYEE_SURNAME AMIR1_SOYAD
		FROM
			EMPLOYEES,
			EMPLOYEE_PERFORMANCE,
			EMPLOYEE_POSITIONS,
			SETUP_TITLE,
			SETUP_POSITION_CAT,
			DEPARTMENT,
			BRANCH,
			OUR_COMPANY
		WHERE
			YEAR(EMPLOYEE_PERFORMANCE.START_DATE) = #attributes.RELATED_YEAR# AND
			<cfif len(attributes.RELATED_COMPANY)>
				BRANCH.BRANCH_ID = #attributes.RELATED_COMPANY# AND
			<cfelseif not session.ep.ehesap>
				BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #SESSION.EP.POSITION_CODE#) AND
			</cfif>
			<cfif len(attributes.RECORD_TYPE)>EMPLOYEE_PERFORMANCE.RECORD_TYPE=#attributes.RECORD_TYPE# AND</cfif>
			EMPLOYEES.EMPLOYEE_ID=EMPLOYEE_PERFORMANCE.MANAGER_1_EMP_ID AND
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEE_PERFORMANCE.EMP_ID AND
			EMPLOYEE_POSITIONS.IS_MASTER=1 AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
			SETUP_TITLE.TITLE_ID = EMPLOYEE_POSITIONS.TITLE_ID AND
			EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID
	</cfquery>

	<cfquery name="GET_PERFORM" dbtype="query">
		SELECT 
			* 
		FROM 
			GET_PERFORM_2,
			GET_PERFORM_1
		WHERE 
			PER_ID_2=PER_ID
		ORDER BY
			<cfif not isdefined('attributes.order_type')>
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				PER_ID,
				QUIZ_ID,
			<cfelse>
				QUIZ_ID,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				PER_ID,
			</cfif>
				CHAPTER_ID
	</cfquery>
	<cfquery name="GET_PER_FORM_DIST" dbtype="query">
		SELECT DISTINCT 
			PER_ID,
			EMPLOYEE_ID
		FROM 
			GET_PERFORM
	</cfquery>

	<cfquery name="GET_CHAPTER" dbtype="query">
		SELECT DISTINCT CHAPTER_ID,CHAPTER,QUIZ_HEAD FROM GET_PERFORM ORDER BY CHAPTER_ID
	</cfquery>

	
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-8"> 
	<title><cf_get_lang dictionary_id='39024.Çalışan Performans Notları'></title>
	<cf_report_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
				<th><cf_get_lang dictionary_id='58487.Çalışan No'></th>
				<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
				<th><cf_get_lang dictionary_id='57750.Şirket Adı'></th>
				<th><cf_get_lang dictionary_id='38955.İlgili Şirket'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='57572.Departman'></th>
				<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
				<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
				<th><cf_get_lang dictionary_id='59004.Poz Tipi'></th>
				<th><cf_get_lang dictionary_id='39429.Gruba Giriş T'>.</th>
				<th>PD Formu 2006</th>
				<th>1. <cf_get_lang dictionary_id='29666.Amir'></th>
				<cfoutput query="GET_CHAPTER"><th>#CHAPTER# (#QUIZ_HEAD#)</th></cfoutput>
				<th><cf_get_lang dictionary_id='57576.Çalışan'> PD <cf_get_lang dictionary_id='39466.Puanı'></th>
				<th><cf_get_lang dictionary_id='57576.Çalışan'> PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th><cf_get_lang dictionary_id='57576.Çalışan'> PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th><cf_get_lang dictionary_id='29908.Görüş Bildiren'> PD <cf_get_lang dictionary_id='39466.Puanı'></th>
				<th><cf_get_lang dictionary_id='29908.Görüş Bildiren'> PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th><cf_get_lang dictionary_id='29908.Görüş Bildiren'> PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th><cf_get_lang dictionary_id='29511.Yönetici'> PD <cf_get_lang dictionary_id='39466.Puanı'></th>
				<th><cf_get_lang dictionary_id='29511.Yönetici'> PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th><cf_get_lang dictionary_id='29511.Yönetici'> PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th><cf_get_lang dictionary_id='29511.Yönetici'> PD Yüzdesi</th>
				<th><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'> PD <cf_get_lang dictionary_id='39466.Puanı'></th>
				<th><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'> PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'> PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th>PD <cf_get_lang dictionary_id='39466.Puanı'></th>
				<th>PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th>PD <cf_get_lang dictionary_id='39466.Puanı'> <cf_get_lang dictionary_id='57771.Detay'></th>
				<th>PD <cf_get_lang dictionary_id='40896.Yüzdesi'></th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_PERFORM.RECORDCOUNT>
			<cfset q=0>
			<cfloop from="1" to="#GET_PER_FORM_DIST.RECORDCOUNT#" index="i">
				<cfset q=q+1>
				<cfset satir=q>
				<tr>
				<cfoutput>
					<td>#GET_PERFORM.TC_IDENTY_NO[satir]#</td>
					<td>#GET_PERFORM.EMPLOYEE_NO[satir]#</td>
					<td>#GET_PERFORM.EMPLOYEE_NAME[satir]# #GET_PERFORM.EMPLOYEE_SURNAME[satir]#</td>
					<td>#GET_PERFORM.NICK_NAME[satir]#</td>
					<td>#GET_PERFORM.RELATED_COMPANY[satir]#</td>
					<td>#GET_PERFORM.BRANCH_NAME[satir]#</td>
					<td>#GET_PERFORM.DEPARTMENT_HEAD[satir]#</td>
					<td>#GET_PERFORM.TITLE[satir]#</td>
					<td>#GET_PERFORM.POSITION_NAME[satir]#</td>
					<td>#GET_PERFORM.POSITION_CAT[satir]#</td>
					<td><cfif len(GET_PERFORM.GROUP_STARTDATE[satir])>#Dateformat(GET_PERFORM.GROUP_STARTDATE[satir],'yyyy-mm-dd')#</cfif></td>
					<td>#GET_PERFORM.QUIZ_HEAD[satir]# <cfif GET_PERFORM.RECORD_TYPE[satir] is 1>(<cf_get_lang dictionary_id='39018.Asıl'>)<cfelseif GET_PERFORM.RECORD_TYPE[satir] is 2>(<cf_get_lang dictionary_id='39019.Görüş'> 1)<cfelseif GET_PERFORM.RECORD_TYPE[satir] is 3>(<cf_get_lang dictionary_id='39019.Görüş'> 2)</cfif></td>
					<td>#GET_PERFORM.AMIR1_AD[satir]# #GET_PERFORM.AMIR1_SOYAD[satir]#</td>
				</cfoutput>
					<cfset birinci_amir_puan = 0>
					<cfset ikinci_amir_puan = 0>
					<cfloop from="1" to="#GET_CHAPTER.RECORDCOUNT#" index="j">
						<cfif GET_PERFORM.PER_ID[satir] eq GET_PERFORM.PER_ID[q]>
							<cfset a = 0>
							<cfset b = 0>
							<cfset c = 0>
							<cfset d = GET_PERFORM.CHAPTER_WEIGHT[q]><!--- bolum agırlıgı --->
							
							<cfif GET_CHAPTER.CHAPTER_ID[j] eq GET_PERFORM.CHAPTER_ID[q]>
								<cfif d gt 1><!---ağırlık 1 se sadece acıklama yazılacak bolumlerdendir--->
									<cfloop condition="GET_PERFORM.CHAPTER_ID[q] equal GET_CHAPTER.CHAPTER_ID[j] AND GET_PERFORM.PER_ID[satir] eq GET_PERFORM.PER_ID[q]">
										<cfset a = a+1><!--- soru sayısı --->
										<cfif len(GET_PERFORM.QUESTION_POINT[q]) and GET_PERFORM.QUESTION_POINT[q] gt 0>
											<cfif session.ep.userid eq 1>(#evaluate("GET_PERFORM.ANSWER#GET_PERFORM.QUESTION_POINT[q]#_POINT[#q#]")#)</cfif>
											<cfset b = b + evaluate("GET_PERFORM.ANSWER#GET_PERFORM.QUESTION_POINT[q]#_POINT[#q#]")>
											<!--- <cfset b = b+GET_PERFORM.QUESTION_POINT[q]> --->
											<!--- iskur icin 1. ve 2.amir puanlari alinmistir SG20120727--->
											<cfif len(GET_PERFORM.QUESTION_POINT_MANAGER1[q]) and GET_PERFORM.QUESTION_POINT_MANAGER1[q] gt 0>
												<cfset birinci_amir_puan = birinci_amir_puan+evaluate("GET_PERFORM.ANSWER#GET_PERFORM.QUESTION_POINT_MANAGER1[q]#_POINT[#q#]")>
											</cfif>
											<cfif len(GET_PERFORM.QUESTION_POINT_MANAGER2[q]) and GET_PERFORM.QUESTION_POINT_MANAGER2[q] gt 0>
												<cfset ikinci_amir_puan = ikinci_amir_puan+evaluate("GET_PERFORM.ANSWER#GET_PERFORM.QUESTION_POINT_MANAGER2[q]#_POINT[#q#]")>
											</cfif>
										</cfif>								
										<cfif GET_PERFORM.GD[q] eq 0><cfset c = c+1></cfif><!--- gecerli sor sayısı--->
										<cfset q = q+1>
									</cfloop>
									<cfif c gte (a/2) and isdefined("birinci_amir_puan")>
										<cfset puan=b>
										<cfset amir1_puan = birinci_amir_puan>
										<cfset amir2_puan = ikinci_amir_puan>
									<cfelse>
										<cfset puan=0>
										<cfset amir1_puan = 0>
										<cfset amir2_puan = 0>
									</cfif>
									<td><cfoutput>#tlformat(puan)#<!---iskur icin parantezli bolum acilmali 2 amirin puan ortalamasi gosterilmektedir. SG20120727(<cfif amir2_puan gt 0>#tlformat((amir1_puan+amir2_puan)/2)#<cfelse>#tlformat(amir1_puan)#</cfif>)---></cfoutput></td>
								<cfelse>
									<!--- AGIRLIK 1 OLDUĞU İCİN SADECE SORU SAYISI KADAR Q DEGEREİ ATIRILIYOR --->
									<cfloop condition="GET_PERFORM.CHAPTER_ID[q] equal GET_CHAPTER.CHAPTER_ID[j] AND GET_PERFORM.PER_ID[satir] eq GET_PERFORM.PER_ID[q]">
										<cfset q = q+1>
									</cfloop>
									<td><!--- <cfoutput>#GET_PERFORM.MANAGER_EXPLANATION[q-1]#</cfoutput> ---></td>
								</cfif>
							<cfelse>
								<td>-</td>
							</cfif>
						<cfelse>
							<td>-</td>
						</cfif>
					</cfloop>
					<!--- Çalışan değerlendirme puanları --->
					<cfif len(GET_PERFORM.EMP_POINT[satir]) and len(GET_PERFORM.EMP_PERFORM_POINT[satir])>
						<cfset emp_puan_detay=GET_PERFORM.EMP_POINT[satir]/GET_PERFORM.EMP_PERFORM_POINT[satir]>
					<cfelse>
						<cfset emp_puan_detay=0>
					</cfif>
					<!--- Görüş Bildiren Değerlendirme Puanları --->
					<cfif len(GET_PERFORM.MANAGER3_POINT[satir]) and len(GET_PERFORM.MANAGER3_PERFORM_POINT[satir])>
						<cfset manager3_puan_detay=GET_PERFORM.MANAGER3_POINT[satir]/GET_PERFORM.MANAGER3_PERFORM_POINT[satir]>
					<cfelse>
						<cfset manager3_puan_detay=0>
					</cfif>
					<!--- Yönetici değerlendirme Puanları --->
					<cfif len(GET_PERFORM.MANAGER_POINT[satir]) and len(GET_PERFORM.MANAGER_PERFORM_POINT[satir])>
						<cfset manager_puan_detay=GET_PERFORM.MANAGER_POINT[satir]/GET_PERFORM.MANAGER_PERFORM_POINT[satir]>
					<cfelse>
						<cfset manager_puan_detay=0>
					</cfif>
					<!--- Ortak değerlendirme puanları --->
					<cfif len(GET_PERFORM.MAN_EMP_POINT[satir]) and len(GET_PERFORM.MAN_EMP_PERFORM_POINT[satir])>
						<cfset man_emp_puan_detay=GET_PERFORM.MAN_EMP_POINT[satir]/GET_PERFORM.MAN_EMP_PERFORM_POINT[satir]>
					<cfelse>
						<cfset man_emp_puan_detay=0>
					</cfif>
					<!--- En son değerlendirme puanı --->
					<cfif len(GET_PERFORM.USER_POINT[satir]) and len(GET_PERFORM.PERFORM_POINT[satir]) and GET_PERFORM.USER_POINT[satir] gt 0>
						<cfset puan_detay=GET_PERFORM.USER_POINT[satir]/GET_PERFORM.PERFORM_POINT[satir]>
					<cfelse>
						<cfset puan_detay=0>
					</cfif>
					<cfoutput>
					<td>#TLFORMAT(GET_PERFORM.EMP_POINT_OVER_5[satir])#</td>
					<td>#TLFORMAT(5*emp_puan_detay)#</td>
					<td>#GET_PERFORM.EMP_POINT[satir]#/#GET_PERFORM.EMP_PERFORM_POINT[satir]#</td>
					
					<td>#TLFORMAT(GET_PERFORM.MANAGER3_POINT_OVER_5[satir])#</td>
					<td>#TLFORMAT(5*manager3_puan_detay)#</td>
					<td>#GET_PERFORM.MANAGER3_POINT[satir]#/#GET_PERFORM.MANAGER3_PERFORM_POINT[satir]#</td>
					
					<td>#TLFORMAT(GET_PERFORM.MANAGER_POINT_OVER_5[satir])#</td>
					<td>#TLFORMAT(5*manager_puan_detay)#</td>
					<td>#GET_PERFORM.MANAGER_POINT[satir]#</td>
					<td>#GET_PERFORM.MANAGER_PERFORM_POINT[satir]#</td>
					
					<td>#TLFORMAT(GET_PERFORM.MAN_EMP_POINT_OVER_5[satir])#</td>
					<td>#TLFORMAT(5*man_emp_puan_detay)#</td>
					<td>#GET_PERFORM.MAN_EMP_POINT[satir]#/#GET_PERFORM.MAN_EMP_PERFORM_POINT[satir]#</td>
					
					<td>#TLFORMAT(GET_PERFORM.USER_POINT_OVER_5[satir])#</td>
					<td>#TLFORMAT(5*puan_detay)#</td>
					<td>#GET_PERFORM.USER_POINT[satir]#</td>
					<td>#GET_PERFORM.PERFORM_POINT[satir]#</td>
					</cfoutput>
					<cfset q = q-1>
				</tr>
			</cfloop>
			</cfif>
		</tbody>
	</cf_report_list>

</cfif>
