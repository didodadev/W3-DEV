<!--- FB 20070830 olusturdu DB2 acisindan bir sorun olursa lutfen bildiriniz.. 
Modified 20121019 SG Belirli süreli iş sözleşmesi tarihi ve gözlem süresi tarihi eklendi.
--->
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.start_date" default="#date_add('d',-7,now())#">
<cfparam name="attributes.finish_date" default="#now()#">
<cfparam name="attributes.branch_names" default="">
<cfparam name="attributes.vid_times" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.is_excel" default="0">
<cfif isdefined("is_submitted")>
	<cfset url_str = "">
    <cfset url_str = "#url_str#&is_submitted=1">
    <cfif len(attributes.vid_times)>
        <cfset url_str = "#url_str#&vid_times=#attributes.vid_times#">
    </cfif>
    <cfif len(attributes.branch_names)>
        <cfset url_str="#url_str#&branch_names=#attributes.branch_names#">
    </cfif>
    <cfif len(attributes.start_date)>
        <cfset url_str="#url_str#&start_date=#attributes.start_date#">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cfset url_str="#url_str#&finish_date=#attributes.finish_date#">
    </cfif>
	<cf_date tarih = "attributes.start_date">
	<cf_date tarih = "attributes.finish_date">
	<cfif (isdefined("attributes.vid_times") and attributes.vid_times eq 1) or (isdefined("attributes.vid_times") and attributes.vid_times eq 5)>
		<cfquery name="get_employee_time" datasource="#dsn#">
			SELECT
				EMPLOYEE_POSITIONS.EMPLOYEE_ID EMPLOYEE_ID,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				<cfif isdefined("attributes.vid_times") and attributes.vid_times eq 1>
					EMPLOYEE_POSITIONS.VEKALETEN_DATE TARIH_SONUC,
				<cfelseif isdefined("attributes.vid_times") and attributes.vid_times eq 5>
					EMPLOYEE_POSITIONS.OBSERVATION_DATE TARIH_SONUC,
				</cfif>
				BRANCH.BRANCH_NAME BRANCH_NAME
			FROM
				EMPLOYEE_POSITIONS,
				DEPARTMENT,
				BRANCH
			WHERE
				<cfif isdefined("attributes.branch_names") and len(attributes.branch_names)>
					DEPARTMENT.BRANCH_ID = #attributes.branch_names# AND
				</cfif>
				<cfif isdefined("attributes.vid_times") and attributes.vid_times eq 1>
					EMPLOYEE_POSITIONS.IS_VEKALETEN = 1 AND
					EMPLOYEE_POSITIONS.VEKALETEN_DATE >= #attributes.start_date# AND
					EMPLOYEE_POSITIONS.VEKALETEN_DATE <= #attributes.finish_date# AND
				<cfelseif isdefined("attributes.vid_times") and attributes.vid_times eq 5>
					EMPLOYEE_POSITIONS.IS_OBSERVATION = 1 AND
					EMPLOYEE_POSITIONS.OBSERVATION_DATE >= #attributes.start_date# AND
					EMPLOYEE_POSITIONS.OBSERVATION_DATE <= #attributes.finish_date# AND
				</cfif>
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND 
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
				<cfif session.ep.ehesap neq 1>
				AND	DEPARTMENT.BRANCH_ID IN
					(
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = #session.ep.position_code#
					)
				</cfif>
			ORDER BY
				<cfif isdefined("attributes.vid_times") and attributes.vid_times eq 1>
					EMPLOYEE_POSITIONS.VEKALETEN_DATE DESC
				<cfelse>
					EMPLOYEE_POSITIONS.OBSERVATION_DATE DESC
				</cfif>
		</cfquery>
	<cfelseif isdefined("attributes.vid_times") and attributes.vid_times eq 2>
		<cfquery name="get_employee_time" datasource="#dsn#">
			SELECT
				EMPLOYEES.EMPLOYEE_ID EMPLOYEE_ID,
				EMPLOYEES.EMPLOYEE_NAME EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
			<cfif (database_type is 'MSSQL')>
				DATEADD(DAY,TEST_TIME,START_DATE) TARIH_SONUC,
			<cfelseif (database_type is 'DB2')>
				DATE(EMPLOYEES_IN_OUT.START_DATE) + EMPLOYEES_DETAIL.TEST_TIME DAYS AS TARIH_SONUC,
			</cfif>
				BRANCH.BRANCH_NAME BRANCH_NAME
			FROM
				EMPLOYEES,
				EMPLOYEE_POSITIONS,
				EMPLOYEES_IN_OUT,
				EMPLOYEES_DETAIL,
				DEPARTMENT,
				BRANCH
			WHERE
				<cfif isdefined("attributes.branch_names") and len(attributes.branch_names)>
					DEPARTMENT.BRANCH_ID = #attributes.branch_names# AND
				</cfif>
				<cfif (database_type is 'MSSQL')>
					DATEADD(DAY,TEST_TIME,START_DATE) >= #attributes.start_date# AND
					DATEADD(DAY,TEST_TIME,START_DATE) <= #attributes.finish_date# AND
				<cfelseif (database_type is 'DB2')>
					DATE(EMPLOYEES_IN_OUT.START_DATE) + EMPLOYEES_DETAIL.TEST_TIME DAYS  >= #attributes.start_date# AND
					DATE(EMPLOYEES_IN_OUT.START_DATE) + EMPLOYEES_DETAIL.TEST_TIME DAYS <= #attributes.finish_date# AND
				</cfif>
				EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
				EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND 
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID		
				<cfif session.ep.ehesap neq 1>
				AND	DEPARTMENT.BRANCH_ID IN
					(
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = #session.ep.position_code#
					)
				</cfif>
			ORDER BY
			<cfif (database_type is 'MSSQL')>
				DATEADD(DAY,TEST_TIME,START_DATE) DESC
			<cfelseif (database_type is 'DB2')>
				DATE(EMPLOYEES_IN_OUT.START_DATE) + EMPLOYEES_DETAIL.TEST_TIME DAYS DESC
			</cfif>
		</cfquery>
	<cfelseif ((isdefined("attributes.vid_times") and attributes.vid_times eq 3) or (isdefined("attributes.vid_times") and attributes.vid_times eq 4))>
		<cfquery name="get_employee_time" datasource="#dsn#">
			SELECT
				EMPLOYEES.EMPLOYEE_ID EMPLOYEE_ID,
				EMPLOYEES.EMPLOYEE_NAME EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				<cfif isdefined("attributes.vid_times") and attributes.vid_times eq 3>
					EMPLOYEES_IN_OUT.FINISH_DATE TARIH_SONUC,	
				<cfelseif isdefined("attributes.vid_times") and attributes.vid_times eq 4>
					EMPLOYEES_IN_OUT.SURELI_IS_FINISHDATE TARIH_SONUC,
				</cfif>	
				BRANCH.BRANCH_NAME BRANCH_NAME
			FROM
				EMPLOYEES,
				EMPLOYEES_IN_OUT,
				BRANCH
			WHERE
				<cfif isdefined("attributes.branch_names") and len(attributes.branch_names)>
					EMPLOYEES_IN_OUT.BRANCH_ID = #attributes.branch_names# AND
				</cfif>
				<cfif isdefined("attributes.vid_times") and attributes.vid_times eq 3><!--- işten çıkış tarihi--->
					EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL AND
					EMPLOYEES_IN_OUT.FINISH_DATE >= #attributes.start_date# AND
					EMPLOYEES_IN_OUT.FINISH_DATE <= #attributes.finish_date# AND
				<cfelseif isdefined("attributes.vid_times") and attributes.vid_times eq 4><!--- Belirli Süreli--->
					EMPLOYEES_IN_OUT.FINISH_DATE IS NULL AND
					EMPLOYEES_IN_OUT.SURELI_IS_AKDI = 1 AND
					EMPLOYEES_IN_OUT.SURELI_IS_FINISHDATE >= #attributes.start_date# AND
					EMPLOYEES_IN_OUT.SURELI_IS_FINISHDATE <= #attributes.finish_date# AND
				</cfif>
				EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
				<cfif session.ep.ehesap neq 1>
				AND	EMPLOYEES_IN_OUT.BRANCH_ID IN
					(
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = #session.ep.position_code#
					)
				</cfif>
			ORDER BY
				<cfif isdefined("attributes.vid_times") and attributes.vid_times eq 3>
					EMPLOYEES_IN_OUT.FINISH_DATE DESC
				<cfelse>
					EMPLOYEES_IN_OUT.SURELI_IS_FINISHDATE DESC
				</cfif>
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_employee_time.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_employee_time.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_branch_name" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME
	FROM
		BRANCH
	WHERE
		BRANCH_ID IS NOT NULL
		<cfif session.ep.ehesap neq 1>
		AND	BRANCH_ID IN
			(
			SELECT
				BRANCH_ID
			FROM
				EMPLOYEE_POSITION_BRANCHES
			WHERE
				POSITION_CODE = #session.ep.position_code#
			)
		</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
<cfsavecontent variable="head"><cf_get_lang dictionary_id ='40087.Çalışan Görev Bitiş Tarihleri Raporu'></cfsavecontent>
<cfform name="search_form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
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
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39467.Tarih Tipi'></label>
											<select name="vid_times" id="vid_times">
												<option value="1" <cfif attributes.vid_times eq 1>selected</cfif>><cf_get_lang dictionary_id='56711.Vekalet Tarihi'></option>
												<option value="2" <cfif attributes.vid_times eq 2>selected</cfif>><cf_get_lang dictionary_id='39569.Deneme Tarihi'></option>
												<option value="3" <cfif attributes.vid_times eq 3>selected</cfif>><cf_get_lang dictionary_id='39464.İşten Çıkış Tarihi'></option>
												<option value="4" <cfif attributes.vid_times eq 4>selected</cfif>><cf_get_lang dictionary_id='39194.Belirli Süreli İş Sözleşmesi'></option>
												<option value="5" <cfif attributes.vid_times eq 5>selected</cfif>><cf_get_lang dictionary_id='39193.Gözlem Süresi'></option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<select name="branch_names" id="branch_names">
												<option value=""><cf_get_lang dictionary_id='57734.Şube'></option>
												<cfoutput query="get_branch_name">
													<option value="#branch_id#" <cfif isdefined("attributes.branch_names") and attributes.branch_names eq branch_id>selected</cfif>>#branch_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="form-group">
										<div class="col col-6 col-md-6"><label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
											<div class="input-group">
												<cfsavecontent variable="messages"><cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!</cfsavecontent>
												<cfinput type="text" name="start_date" validate="#validate_style#" message="#messages#" required="yes" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" style="width:65px;">
												<span class="input-group-addon">
													<cf_wrk_date_image date_field="start_date">
												</span>
											</div>
										</div>
										<div class="col col-6 col-md-6"><label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
											<div class="input-group">
												<cfinput type="text" name="finish_date" validate="#validate_style#" message="#messages#" required="yes" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" style="width:65px;">
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
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
                            <input type="hidden" name="is_submitted" id="is_submitted" value="1">	
                            <cf_wrk_report_search_button button_type="1" is_excel='1' search_function="control()">
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
<cfif isdefined("attributes.is_submitted")>
	<cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_employee_time.recordcount>
	</cfif>
	<cf_report_list>

		<thead>	
			<tr>
				<th width="250"><cf_get_lang dictionary_id='57576.Çalışan'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
			</tr>
		</thead>
		<tbody>
		<cfif isdefined("is_submitted") and get_employee_time.recordcount>
			<cfoutput query="get_employee_time" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>#branch_name#</td>
					<td>#dateformat(tarih_sonuc,dateformat_style)#</td>
				</tr>
			</cfoutput>
			<cfset attributes.totalrecords=get_employee_time.recordcount>
			<cfelse>
			<tr>
				<td colspan="3">
					<cfif isdefined("attributes.is_submitted")>
						<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
					<cfelse>
						<cf_get_lang dictionary_id='57701.Filtre Ediniz'>!
					</cfif>
				</td>
			</tr>
		</cfif>
		</tbody>
	</cf_report_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "">
            <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
                <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
            </cfif>
			<cfif isdefined("attributes.vid_times") and len(attributes.vid_times)>
                <cfset url_str = "#url_str#&vid_times=#attributes.vid_times#">
            </cfif>
            <cfif isdefined("attributes.branch_names") and len(attributes.branch_names)>
                <cfset url_str = "#url_str#&branch_names=#attributes.branch_names#">
            </cfif>
            <cfif isdefined("attributes.puantaj_type") and len(attributes.puantaj_type)>
                <cfset url_str = "#url_str#&puantaj_type=#attributes.puantaj_type#">
            </cfif>
			<cfif len(attributes.start_date)>
                <cfset url_str = '#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
            </cfif>
            <cfif len(attributes.finish_date)>
                <cfset url_str = '#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
            </cfif>
            <cfif attributes.is_excel eq 0>
				<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#&#url_str#"> 
            </cfif>
    </cfif>
</cfif>

<script type="text/javascript">
    function control()	
	{
		if(!date_check(search_form.start_date,search_form.finish_date,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(document.search_form.is_excel.checked==false)
		{
			document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.search_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employee_test_out_vekalet_times</cfoutput>"
    }
	
</script>