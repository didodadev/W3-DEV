<!---Not:Bu raporun orjinali Çalışan Banka Maaş Kontrol Raporu  olarak değiştirilmiş
  Çalışan Banka Hesapları olarak da bu rapor yeniden kodlanmıştır.--->
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.paymethod_id" default="">
<cfparam name="attributes.employee_bank_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="0">
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="get_banks" datasource="#dsn#">
		SELECT DISTINCT
			EBA.BANK_ID,
			B.BRANCH_NAME,
			EI.TC_IDENTY_NO,
			EMP.EMPLOYEE_NAME,
			EMP.EMPLOYEE_ID,
			EMP.EMPLOYEE_SURNAME,
			EBA.IBAN_NO,
			EBA.BANK_BRANCH_NAME,
			EBA.BANK_BRANCH_CODE,
			EBA.BANK_ACCOUNT_NO,		
			EIO.PAYMETHOD_ID,
            EBA.BANK_SWIFT_CODE
		FROM 
			EMPLOYEES_BANK_ACCOUNTS AS EBA,
			EMPLOYEES_IN_OUT AS EIO,
			BRANCH AS B,
			EMPLOYEES AS EMP,
			EMPLOYEES_IDENTY AS EI
		WHERE 
			<cfif len(attributes.branch_id)>
			  B.BRANCH_ID=#attributes.branch_id# AND
			</cfif>
			<cfif len(attributes.paymethod_id)>
			   EIO.PAYMETHOD_ID = #attributes.paymethod_id# AND
			</cfif>
			<cfif len(attributes.employee_bank_id)>
			   EBA.BANK_ID = #attributes.employee_bank_id# AND
			</cfif>	
			<cfif not session.ep.ehesap>
				B.BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
							) AND
			</cfif>
			EIO.BRANCH_ID=B.BRANCH_ID AND
			EIO.EMPLOYEE_ID = EBA.EMPLOYEE_ID AND
			EMP.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
			EI.EMPLOYEE_ID=EIO.EMPLOYEE_ID AND
			EIO.FINISH_DATE IS NULL
		ORDER BY
			EMP.EMPLOYEE_NAME,
			EMP.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_banks.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_banks.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!---Selectionda çıkan Değerler VTYS DEN ÇEKİLİYOR--->
	<cfquery name="GET_PAYMETHODS" datasource="#dsn#">
		SELECT 
			SP.PAYMETHOD,
			SP.PAYMETHOD_ID 
		FROM 
			SETUP_PAYMETHOD SP,
			SETUP_PAYMETHOD_OUR_COMPANY SPOC
		WHERE 
			SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
			AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		ORDER BY 
			SP.PAYMETHOD
	</cfquery>
	<cfset pay_list = listsort(listdeleteduplicates(valuelist(GET_PAYMETHODS.PAYMETHOD_ID,',')),'numeric','ASC',',')>
	<cfquery name="GET_BANKS_ALL" datasource="#DSN#">
		 SELECT
             *
		 FROM
             SETUP_BANK_TYPES
		 ORDER BY
             BANK_ID
    </cfquery>
	<cfquery name="GET_SSK_OFFICES" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME,		
		SSK_OFFICE,
		COMPANY_ID,
		SSK_NO,
		RELATED_COMPANY
	FROM
		BRANCH AS B <!---SUBE) TABLOSU--->
	WHERE
		B.SSK_NO IS NOT NULL AND
		B.SSK_OFFICE IS NOT NULL AND
		B.SSK_BRANCH IS NOT NULL AND
		B.SSK_NO <> '' AND
		B.SSK_OFFICE <> '' AND
		B.SSK_BRANCH <> ''
		<cfif not session.ep.ehesap>
		AND BRANCH_ID IN (
                            SELECT
                                BRANCH_ID
                            FROM
                                EMPLOYEE_POSITION_BRANCHES
                            WHERE
                                EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
					     )
		</cfif>
	</cfquery>
	<cfif get_banks.recordcount>
	<cfset bank_list=''>
		<cfoutput query="get_banks">
			<cfif len(bank_id) and bank_id neq 0 and not listfind(bank_list,bank_id)>
				<cfset bank_list=listappend(bank_list,bank_id)>
			</cfif>
		</cfoutput>
		<cfif listlen(bank_list)> <!---Banka listesi varsa banka adlarını getir--->
		<cfset bank_list = listsort(bank_list,"numeric","ASC",',')>
			<cfquery name="get_bank_name" datasource="#DSN#">
				 SELECT
					  *
				 FROM
					  SETUP_BANK_TYPES
				 WHERE
					  BANK_ID IN (#bank_list#)
				 ORDER BY
					  BANK_ID
		   </cfquery>
		 </cfif>
	</cfif>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39581.Çalışan Banka Hesapları'></cfsavecontent>
<!---Table Structures --->
<cfform name="list_payments" method="post" action="#request.self#?fuseaction=report.employees_bank_accounts_report&form_varmi=1">
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
											<select name="paymethod_id" id="paymethod_id">
												<option value=""><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></option>
												<cfoutput query="GET_PAYMETHODS">
													<option value="#paymethod_id#" <cfif attributes.paymethod_id eq paymethod_id>selected</cfif>>#PAYMETHOD#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<select name="employee_bank_id" id="employee_bank_id" style="width:250px;">
												<option value=""><cf_get_lang dictionary_id='58940.Banka Seçiniz'></option>
												<cfoutput query="GET_BANKS_ALL">
													<option value="#bank_id#" <cfif attributes.employee_bank_id eq bank_id>selected</cfif>>#bank_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<select name="branch_id" id="branch_id">
												<option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
												<cfoutput query="GET_SSK_OFFICES">
												<option value="#branch_id#" <cfif attributes.branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
												</cfoutput>
											</select>
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
							<input name="form_varmi" id="form_varmi" value="1" type="hidden">
							<cf_wrk_report_search_button button_type='1' is_excel='1' search_function='control()'>
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
<cfif isdefined("attributes.form_varmi")>
	<cfset url_str = "">
	<cfset url_str = "#url_str#&form_varmi=1">
	<cfif len(attributes.paymethod_id)>
		<cfset url_str = "#url_str#&paymethod_id=#attributes.paymethod_id#">
	</cfif>
	<cfif len(attributes.employee_bank_id)>
		<cfset url_str="#url_str#&employee_bank_id=#attributes.employee_bank_id#">
	</cfif>
	<cfif len(attributes.branch_id)>
		<cfset url_str="#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
	<cf_report_list>
            <thead>
				<tr>
					<th><cf_get_lang dictionary_id="58577.sıra"></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="75"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
					<th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
					<th width="200"><cf_get_lang dictionary_id='40596.IBAN'></th>
					<th width="150"><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
					<th width="100"><cf_get_lang dictionary_id='58933.Banka Şubesi'></th>
					<th width="100"><cf_get_lang dictionary_id='59005.Şube Kodu'></th>
					<th width="100"><cf_get_lang dictionary_id='29530.Swift Kodu'></th>
					<th width="100"><cf_get_lang dictionary_id='58178.Hesap No'></th>
					<th width="100"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
				</tr>
            </thead>
            <tbody>
				<cfif get_banks.recordcount>
				<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows = get_banks.recordcount>
				</cfif>
				<cfoutput query="get_banks" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>#branch_name#</td>
						<td><cf_duxi name='identity_no' class="tableyazi" type="label" value="#TC_IDENTY_NO#" gdpr="2"></td>
						<td>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi"> 
								#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
								</a>
							</cfif>
						</td>
						<td>#iban_no#</td>
						<td>#get_bank_name.BANK_NAME[listfind(bank_list,bank_id,',')]#</td>
						<td>#bank_branch_name#</td>
						<td>#bank_branch_code#</td>
						<td>#bank_swift_code#</td>
						<td>#bank_account_no#</td>
						<td><cfif len(paymethod_id)>#GET_PAYMETHODS.PAYMETHOD[listfind(pay_list,paymethod_id,',')]#</cfif></td>
					</tr>
				</cfoutput> 
				<cfelse>
				<tr>
					<td colspan="11"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayit Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
				</cfif>
				<cfset attributes.totalrecords=get_banks.recordcount>
            </tbody>
    </cf_report_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="report.employees_bank_accounts_report#url_str#">
	</cfif>
</cfif>
<script type="text/javascript">
    function control()	
	{
		if(document.list_payments.is_excel.checked==false)
		{
			document.list_payments.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.list_payments.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employees_bank_accounts_reports</cfoutput>"
    }
</script>