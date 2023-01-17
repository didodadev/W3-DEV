<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="../standart/report_authority_control.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_email_list" datasource="#dsn#">
		SELECT 
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			CB.EMAIL,
			CB.ACCOUNT,
			CB.POP,
			CB.SMTP,
			EMP_IDE.TC_IDENTY_NO
		FROM
			CUBE_MAIL CB,
			EMPLOYEES E,
			EMPLOYEES_IDENTY EMP_IDE
		WHERE
			E.EMPLOYEE_ID = CB.EMPLOYEE_ID
			AND EMP_IDE.EMPLOYEE_ID=E.EMPLOYEE_ID
			<cfif len(attributes.keyword)>
				AND
				((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#' OR CB.EMAIL LIKE '%#attributes.keyword#%' OR EMP_IDE.TC_IDENTY_NO LIKE '#attributes.keyword#')
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_email_list.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default=#get_email_list.recordcount#>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39051.Çalışan Mailleri' ></cfsavecontent>
<cfform name="employees" action="#request.self#?fuseaction=report.report_email_list" method="post">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57460.Filtre"></label>
											<div class="col col-12">
												<cfinput type="Text" maxlength="255" value="#attributes.keyword#" name="keyword" id="keyword">
											</div>	
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							<cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
							<cf_wrk_report_search_button button_type='1' search_function="control()" is_excel='1'>
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
	<cf_report_list>
			<thead>
				<tr> 
					<th width="125"><cf_get_lang dictionary_id="57631.Ad"></th>
					<th width="125"><cf_get_lang dictionary_id="58726.Soyad"></th>
					<th width="125"><cf_get_lang dictionary_id="39186.E-Mail"></th>
					<th width="125"><cf_get_lang dictionary_id="57551.Kullanici Adi"></th>
					<th width="125"><cf_get_lang dictionary_id="39189.POP"></th>
					<th width="125"><cf_get_lang dictionary_id="39191.SMTP"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_email_list.recordcount>
				<cfoutput query="get_email_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#EMPLOYEE_NAME#</td>
						<td>#EMPLOYEE_SURNAME#</td> 
						<td>#EMAIL#</td>
						<td>#ACCOUNT#</td>
						<td>#POP#</td>
						<td>#SMTP#</td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
	</cf_report_list>
</cfif>
<cfif attributes.maxrows lt attributes.totalrecords>
	
				<cfset url_str = "">
				<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
				</cfif>		
				<cfif len(attributes.is_form_submitted)>
				<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
				</cfif>
				<cf_paging page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="report.report_email_list#url_str#"></td>
	
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function control(){
		if(document.employees.is_excel.checked==false)
		{
			document.employees.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.employees.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_report_email_list</cfoutput>"
		}
</script>
