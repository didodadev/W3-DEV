<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.puantaj_type" default="-1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY
	<cfif not session.ep.ehesap>
        WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfif>
	ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT * FROM BRANCH WHERE <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#) 
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif> AND BRANCH_STATUS = 1   ORDER BY BRANCH_NAME
</cfquery>
<cfif isdefined('attributes.is_submitted')>
	<cfquery name="get_puantajs" datasource="#dsn#">
		SELECT 
			EP.PUANTAJ_ID,
			EP.SAL_MON, 
			EP.SSK_OFFICE, 
			EP.SSK_OFFICE_NO, 
			EP.IS_LOCKED,
			EP.IS_BUDGET,
			EP.IS_LOCKED,
			EP.IS_ACCOUNT,
			EP.PUANTAJ_TYPE,
			B.BRANCH_ID,
			(SELECT TOP 1 PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PUANTAJ_ID = EP.PUANTAJ_ID AND IS_VIRTUAL = 0) AS IS_DEKONT,
			(SELECT TOP 1 BANK_ACTION_MULTI_ID FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PUANTAJ_ID = EP.PUANTAJ_ID AND IS_VIRTUAL = 0) AS IS_GIDEN_HAVALE
		FROM 
			EMPLOYEES_PUANTAJ EP,
			BRANCH B 
		WHERE 
			SAL_YEAR = #attributes.sal_year# AND 
			EP.SSK_OFFICE = B.SSK_OFFICE AND
			EP.SSK_OFFICE_NO = B.SSK_NO
			<cfif isdefined('attributes.comp_id') and len(attributes.comp_id) and attributes.comp_id neq 'all'>
				AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">)
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id neq 'all'>
				AND	B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
			</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
            <cfif isdefined('attributes.puantaj_type') and len(attributes.puantaj_type)>
            	AND EP.PUANTAJ_TYPE = #attributes.puantaj_type#
            </cfif>
	</cfquery>
	<CFSET B_LIST = VALUELIST(get_puantajs.BRANCH_ID)>
	<cfif len(B_LIST)>
		<cfquery name="get_branches" datasource="#dsn#">
			SELECT 
				BRANCH_NAME,
				SSK_OFFICE,
				SSK_NO 
			FROM 
				BRANCH
			WHERE
				BRANCH_ID IN (#B_LIST#)
			ORDER BY 
				BRANCH_NAME
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_puantajs.recordcount = 0>
</cfif>
<cfsavecontent variable="header"><cf_get_lang dictionary_id='59147.Puantaj Durum Raporu'></cfsavecontent>
<cfform name="form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cf_report_list_search title="#header#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<label class="col col-12 col-md-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
											<div class="col col-12 col-md-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_our_company"  
													name="comp_id"
													option_value="COMP_ID"
													option_name="company_name"
													option_text="#getLang('main',322)#"
													value="#attributes.comp_id#"
													onchange="get_branch_list(this.value)">
												</div>											
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<div id="BRANCH_PLACE" class="col col-12 col-md-12">
												<div id="BRANCH_PLACE" class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_branch"  
													name="branch_id"
													option_value="BRANCH_ID"
													option_name="BRANCH_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.branch_id#"
													onchange="showDepartment(this.value)">
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<label class="col col-12 col-md-12"><cf_get_lang dictionary_id='58650.Puantaj'> <cf_get_lang dictionary_id='58651.Türü'></label>
											<div class="col col-12 col-md-12">
												<select name="puantaj_type" id="puantaj_type">
													<option value="-1" <cfif attributes.puantaj_type eq -1>selected</cfif>><cf_get_lang dictionary_id='53548.Gerçek Puantaj'></option>
													<option value="0" <cfif attributes.puantaj_type eq 0>selected</cfif>><cf_get_lang dictionary_id='54194.Sanal Puantaj'></option>
													<option value="-2" <cfif attributes.puantaj_type eq -2>selected</cfif>><cf_get_lang dictionary_id='53575.Fark Puantajı'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12">&nbsp</label>
											<div class="col col-12 col-md-12">
												<select name="sal_year" id="sal_year">
													<cfloop from="#session.ep.period_year-3#" to="#session.ep.period_year+3#" index="i">
														<cfoutput>
														<option value="#i#"<cfif attributes.sal_year eq i> selected</cfif>>#i#</option>
														</cfoutput>
													</cfloop>
												</select>
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
							<input name="is_submitted" id="is_submitted" type="hidden" value="1">
							<cf_wrk_report_search_button button_type="1" is_excel='1' search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cf_report_list>
		<thead>
			<tr> 
				<th class="form-title"><cf_get_lang dictionary_id='57453.Şube'></th>
				<cfloop from="1" to="12" index="i">
					<th class="form-title"><cfoutput>#listgetat(ay_list(),i,',')#</cfoutput></th>
				</cfloop>
			</tr>
		</thead>
		<cfif get_puantajs.recordcount>
		<tbody>
			<cfoutput query="get_branches" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
			<tr>
				<td class="txtbold">#branch_name#</td>
				<cfloop from="1" to="12" index="i">
				<cfquery name="puantaj_exists" dbtype="query">
					SELECT PUANTAJ_ID,IS_LOCKED,IS_BUDGET,IS_ACCOUNT,IS_DEKONT,IS_GIDEN_HAVALE FROM get_puantajs WHERE SSK_OFFICE = '#SSK_OFFICE#' AND SSK_OFFICE_NO = '#SSK_NO#' AND SAL_MON = #i# AND PUANTAJ_TYPE = -1
				</cfquery>
				<td align="center">
					<cfif puantaj_exists.recordcount>+<cfelse>-</cfif>
					<cfif puantaj_exists.recordcount and puantaj_exists.is_locked eq 1><img src="/images/lock.gif" title="<cf_get_lang dictionary_id='53759.Puantaj Kilitli'> !"></cfif>
					<cfif puantaj_exists.recordcount and puantaj_exists.IS_BUDGET eq 1><img src="/images/cuberelation.gif" title="<cf_get_lang dictionary_id='57559.Bütçe'>"></cfif>
					<cfif puantaj_exists.recordcount and puantaj_exists.IS_ACCOUNT eq 1><img src="/images/extre.gif" title="<cf_get_lang dictionary_id='57447.Muhasebe'>"></cfif>
					<cfif puantaj_exists.recordcount and puantaj_exists.IS_DEKONT eq 1><img src="/images/money.gif" title="<cf_get_lang dictionary_id='29946.Ücret Dekontu'>"></cfif>
					<cfif puantaj_exists.recordcount and puantaj_exists.IS_GIDEN_HAVALE eq 1><img src="/images/outsource.gif" title="<cf_get_lang dictionary_id='57847.Ödeme'>"></cfif>
				</td>
				</cfloop>
			</tr>
			</cfoutput>
		</tbody>
		<cfset attributes.totalrecords=get_branches.recordcount>
		<cfelse>
		<tbody>
			<tr>
				<td colspan="13"><!-- sil --><cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
			</tr>
		</tbody>
		</cfif>
		
	</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
			<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
		</cfif>
		<cfif isdefined("attributes.BRANCH_PLACE") and len(attributes.BRANCH_PLACE)>
			<cfset url_str = "#url_str#&BRANCH_PLACE=#attributes.BRANCH_PLACE#">
		</cfif>
		<cfif isdefined("attributes.puantaj_type") and len(attributes.puantaj_type)>
			<cfset url_str = "#url_str#&puantaj_type=#attributes.puantaj_type#">
		</cfif>
		<cfif len(attributes.sal_year)>
			<cfset url_str = "#url_str#&sal_year=#attributes.sal_year#">
		</cfif>
		<cfif attributes.is_excel eq 0>
			<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction#&#url_str#"> 
		</cfif>
</cfif>
<script type="text/javascript">
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
function showDepartment(comp_id)	
{
}
function control()	
	{
            if(document.form.is_excel.checked==false)
            {
                document.form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_puantaj_record_status_report</cfoutput>"
    }
</script>
