<cfparam name="attributes.module_id_control" default="3,48">
<cfparam name="attributes.is_excel" default="">
<cfinclude template="report_authority_control.cfm">
<cfprocessingdirective suppresswhitespace="yes">
<cfif isdefined("form_submited")>
	<cfquery name="employee_branch_" datasource="#dsn#">
		SELECT 
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.POSITION_NAME,
			EP.DYNAMIC_HIERARCHY,
			EP.DYNAMIC_HIERARCHY_ADD,
			EP.POSITION_ID,
			EP.EMPLOYEE_ID,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD
		FROM 
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B
		WHERE
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND 
			B.BRANCH_ID = D.BRANCH_ID
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND B.BRANCH_ID = #attributes.branch_id#
			</cfif>
			<cfif not session.ep.ehesap>
                AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
		ORDER BY BRANCH_NAME,DEPARTMENT_HEAD,EMPLOYEE_NAME
	</cfquery>
<cfelse>
	<cfset employee_branch_.recordcount = 0>
</cfif>
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>

<cfquery name="get_branches" datasource="#dsn#">
	SELECT * FROM BRANCH <cfif not session.ep.ehesap>WHERE BRANCH_ID IN (#emp_branch_list#)</cfif> ORDER BY BRANCH_NAME
</cfquery>

<cfparam name="attributes.branch_id" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#employee_branch_.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39576.Özel Kod Kullananlar' ></cfsavecontent>
<cfform name="form_branch" action="#request.self#?fuseaction=report.employee_branch_ozel_kod" method="post">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-6 col-xs-12">
								<div class="form-group">
									<select name="branch_id" id="branch_id">
										<option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
										<cfoutput query="get_branches">
										<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
										</cfoutput>	
									</select>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cfinput type="hidden" name="form_submited" id="form_submited" value="1">
							<cf_wrk_report_search_button button_type='1' is_excel="1" search_function='control()'>
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
<cfif isdefined("form_submited")>
	<cf_report_list>
			<thead>
				<tr height="22"> 
					<th width="30"><cf_get_lang dictionary_id ='58577.No'></th>
					<th width="150"><cf_get_lang dictionary_id ='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id ='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id ='57572.Departman'></th>
					<th width="150"><cf_get_lang dictionary_id ='57453.Şube'></th>
					<th><cf_get_lang dictionary_id ='39962.Dinamik Hiyerarşi'></th>
					<th><cf_get_lang dictionary_id ='39963.Dinamik Hiyerarşi Kodu'></th>
				</tr>	
			</thead>
			<tbody>
				<cfif employee_branch_.recordcount>			
					<cfoutput query="employee_branch_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td height="20">#employee_name# #employee_surname#</td>
							<td height="20">#position_name#</td>
							<td>#department_head#</td>
							<td>#branch_name#</td>
							<td>#DYNAMIC_HIERARCHY#</td>
							<td>#DYNAMIC_HIERARCHY_ADD#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr height="20">
					<td colspan="7"><cfif isdefined("form_submited")><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
	</cf_report_list>
</cfif>
<cfif attributes.is_excel neq 1>
<!-- sil -->

<cfif attributes.totalrecords gt attributes.maxrows>
	<cfscript>
		url_str = "#attributes.fuseaction#";
		if(isdefined('attributes.form_submited'))
			url_str = "#url_str#&form_submited=#attributes.form_submited#";
		if(isdefined('attributes.branch_id') and len(attributes.branch_id))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
	</cfscript>
    <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#url_str#">
</cfif>
<!-- sil -->
</cfif>
<script type="text/javascript">
function control()
{  
	if(document.form_branch.is_excel.checked==false)
		{
			document.form_branch.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
	else
			document.form_branch.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employee_branch_ozel_kod</cfoutput>"

}
</script>
</cfprocessingdirective>
