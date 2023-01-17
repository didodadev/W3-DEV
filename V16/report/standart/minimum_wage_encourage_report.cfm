<cfsetting showdebugoutput="false">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfscript>
	attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(ehesap_control : 1);
</cfscript>

<cfif isdefined("attributes.is_form_submit")>
	<cfquery name="get_total" datasource="#dsn#">
		SELECT
			T2.BRANCH_ID,
			T2.BRANCH_NAME,
			<cfif len(attributes.sal_mon)>
				CASE WHEN SAL_MON_ = 'SSK_DAYS_#attributes.sal_mon#' THEN #attributes.sal_mon# END AS SAL_MON,
			<cfelse>
				CASE WHEN SAL_MON_ = 'SSK_DAYS_1' THEN 1 WHEN SAL_MON_ = 'SSK_DAYS_2' THEN 2 WHEN SAL_MON_ = 'SSK_DAYS_3' THEN 3 WHEN SAL_MON_ = 'SSK_DAYS_4' THEN 4 WHEN SAL_MON_ = 'SSK_DAYS_5' THEN 5 WHEN SAL_MON_ = 'SSK_DAYS_6' THEN 6 WHEN SAL_MON_ = 'SSK_DAYS_7' THEN 7 WHEN SAL_MON_ = 'SSK_DAYS_8' THEN 8 WHEN SAL_MON_ = 'SSK_DAYS_9' THEN 9 WHEN SAL_MON_ = 'SSK_DAYS_10' THEN 10 WHEN SAL_MON_ = 'SSK_DAYS_11' THEN 11 WHEN SAL_MON_ = 'SSK_DAYS_12' THEN 12 END AS SAL_MON,
			</cfif>
			CASE WHEN T2.SSK_DAYS_ < T4.SSK_DAYS_16 THEN T2.SSK_DAYS_ ELSE T4.SSK_DAYS_16 END AS SSK_DAYS_
		FROM
		(SELECT BRANCH_ID, BRANCH_NAME, SAL_MON_,SSK_DAYS_
		FROM
		(SELECT
			B.BRANCH_ID,
			B.BRANCH_NAME
			<cfif len(attributes.sal_mon)>
				,ISNULL((SELECT SUM(CASE WHEN EPR.SSK_DAYS IS NOT NULL AND EPR.SSK_DAYS > 0 AND EPR.SSK_MATRAH / EPR.SSK_DAYS <= 85 THEN EPR.SSK_DAYS ELSE 0 END) FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EP.SAL_MON = (SELECT TOP 1 SAL_MON FROM EMPLOYEES_PUANTAJ WHERE SSK_BRANCH_ID = B.BRANCH_ID AND SAL_YEAR = #attributes.sal_year#-1 AND SAL_MON >= #attributes.sal_mon# ORDER BY SAL_MON) AND EP.SAL_YEAR = #attributes.sal_year#-1 AND EP.SSK_BRANCH_ID = B.BRANCH_ID AND EPR.SSK_STATUTE IN (1,5,6,8,9,10,12,13,14,15,16,17,32)),0) SSK_DAYS_#attributes.sal_mon#
			<cfelse>
				<cfloop from="1" to="12" index="i">
					,ISNULL((SELECT SUM(CASE WHEN EPR.SSK_DAYS IS NOT NULL AND EPR.SSK_DAYS > 0 AND EPR.SSK_MATRAH / EPR.SSK_DAYS <= 85 THEN EPR.SSK_DAYS ELSE 0 END) FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EP.SAL_MON = (SELECT TOP 1 SAL_MON FROM EMPLOYEES_PUANTAJ WHERE SSK_BRANCH_ID = B.BRANCH_ID AND SAL_YEAR = #attributes.sal_year#-1 AND SAL_MON >= #i# ORDER BY SAL_MON) AND EP.SAL_YEAR = #attributes.sal_year#-1 AND EP.SSK_BRANCH_ID = B.BRANCH_ID AND EPR.SSK_STATUTE IN (1,5,6,8,9,10,12,13,14,15,16,17,32)),0) SSK_DAYS_#i#
				</cfloop>
			</cfif>
		FROM
			BRANCH B
		WHERE
			B.BRANCH_ID IN (SELECT DISTINCT SSK_BRANCH_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_YEAR = #attributes.sal_year#-1)
			AND B.FOUNDATION_DATE < '2016-01-01 00:00:00'
			<cfif len(attributes.branch_id)>
				AND B.BRANCH_ID IN (#attributes.branch_id#)
			<cfelseif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
			</cfif>
			UNION ALL
			SELECT
			B.BRANCH_ID,
			B.BRANCH_NAME
			<cfif len(attributes.sal_mon)>
				,ISNULL((SELECT SUM(EPR.SSK_DAYS) FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EP.SAL_MON = (SELECT TOP 1 SAL_MON FROM EMPLOYEES_PUANTAJ WHERE SSK_BRANCH_ID = B.BRANCH_ID AND SAL_YEAR = #attributes.sal_year#-1 AND SAL_MON >= #attributes.sal_mon# ORDER BY SAL_MON) AND EP.SAL_YEAR = #attributes.sal_year#-1 AND EP.SSK_BRANCH_ID = B.BRANCH_ID AND EPR.SSK_STATUTE IN (1,5,6,8,9,10,12,13,14,15,16,17,32)),0) SSK_DAYS_#attributes.sal_mon#
			<cfelse>
				<cfloop from="1" to="12" index="i">
					,ISNULL((SELECT SUM(EPR.SSK_DAYS) FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EP.SAL_MON = (SELECT TOP 1 SAL_MON FROM EMPLOYEES_PUANTAJ WHERE SSK_BRANCH_ID = B.BRANCH_ID AND SAL_YEAR = #attributes.sal_year#-1 AND SAL_MON >= #i# ORDER BY SAL_MON) AND EP.SAL_YEAR = #attributes.sal_year#-1 AND EP.SSK_BRANCH_ID = B.BRANCH_ID AND EPR.SSK_STATUTE IN (1,5,6,8,9,10,12,13,14,15,16,17,32)),0) SSK_DAYS_#i#
				</cfloop>
			</cfif>
		FROM
			BRANCH B
		WHERE
			B.BRANCH_ID IN (SELECT DISTINCT SSK_BRANCH_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_YEAR = #attributes.sal_year#-1)
			AND B.FOUNDATION_DATE >= '2016-01-01 00:00:00'
			<cfif len(attributes.branch_id)>
				AND B.BRANCH_ID IN (#attributes.branch_id#)
			<cfelseif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
			</cfif>
		)T1
		UNPIVOT
		(SSK_DAYS_ FOR SAL_MON_ IN <cfif len(attributes.sal_mon)>(SSK_DAYS_#attributes.sal_mon#)<cfelse>(SSK_DAYS_1,SSK_DAYS_2,SSK_DAYS_3,SSK_DAYS_4,SSK_DAYS_5,SSK_DAYS_6,SSK_DAYS_7,SSK_DAYS_8,SSK_DAYS_9,SSK_DAYS_10,SSK_DAYS_11,SSK_DAYS_12)</cfif>
		) AS mrks) AS T2,
		(SELECT BRANCH_ID_16, BRANCH_NAME_16, SAL_MON_16,SSK_DAYS_16
		FROM
		(SELECT
			B.BRANCH_ID AS BRANCH_ID_16,
			B.BRANCH_NAME AS BRANCH_NAME_16
			<cfif len(attributes.sal_mon)>
				,ISNULL((SELECT SUM(CASE WHEN EPR.SSK_DAYS IS NOT NULL AND EPR.SSK_DAYS > 0 AND EPR.SSK_MATRAH / EPR.SSK_DAYS <= 85 THEN EPR.SSK_DAYS ELSE 0 END) FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EP.SAL_MON = (SELECT TOP 1 SAL_MON FROM EMPLOYEES_PUANTAJ WHERE SSK_BRANCH_ID = B.BRANCH_ID AND SAL_YEAR = #attributes.sal_year# AND SAL_MON >= #attributes.sal_mon# ORDER BY SAL_MON) AND EP.SAL_YEAR = #attributes.sal_year# AND EP.SSK_BRANCH_ID = B.BRANCH_ID AND EPR.SSK_STATUTE IN (1,5,6,8,9,10,12,13,14,15,16,17,32)),0) SSK_DAYS_#attributes.sal_mon#_16
			<cfelse>
				<cfloop from="1" to="12" index="i">
					,ISNULL((SELECT SUM(CASE WHEN EPR.SSK_DAYS IS NOT NULL AND EPR.SSK_DAYS > 0 AND EPR.SSK_MATRAH / EPR.SSK_DAYS <= 85 THEN EPR.SSK_DAYS ELSE 0 END) FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EP.SAL_MON = (SELECT TOP 1 SAL_MON FROM EMPLOYEES_PUANTAJ WHERE SSK_BRANCH_ID = B.BRANCH_ID AND SAL_YEAR = #attributes.sal_year# AND SAL_MON >= #i# ORDER BY SAL_MON) AND EP.SAL_YEAR = #attributes.sal_year# AND EP.SSK_BRANCH_ID = B.BRANCH_ID AND EPR.SSK_STATUTE IN (1,5,6,8,9,10,12,13,14,15,16,17,32)),0) SSK_DAYS_#i#_16
				</cfloop>
			</cfif>
		FROM
			BRANCH B
		WHERE
			B.BRANCH_ID IN (SELECT DISTINCT SSK_BRANCH_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_YEAR = #attributes.sal_year#)
			AND B.FOUNDATION_DATE < '2016-01-01 00:00:00'
			<cfif len(attributes.branch_id)>
				AND B.BRANCH_ID IN (#attributes.branch_id#)
			<cfelseif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
			</cfif>
			UNION ALL
			SELECT
			B.BRANCH_ID AS BRANCH_ID_16,
			B.BRANCH_NAME AS BRANCH_NAME_16
			<cfif len(attributes.sal_mon)>
				,ISNULL((SELECT SUM(EPR.SSK_DAYS) FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EP.SAL_MON = (SELECT TOP 1 SAL_MON FROM EMPLOYEES_PUANTAJ WHERE SSK_BRANCH_ID = B.BRANCH_ID AND SAL_YEAR = #attributes.sal_year# AND SAL_MON >= #attributes.sal_mon# ORDER BY SAL_MON) AND EP.SAL_YEAR = #attributes.sal_year# AND EP.SSK_BRANCH_ID = B.BRANCH_ID AND EPR.SSK_STATUTE IN (1,5,6,8,9,10,12,13,14,15,16,17,32)),0) SSK_DAYS_#attributes.sal_mon#_16
			<cfelse>
				<cfloop from="1" to="12" index="i">
					,ISNULL((SELECT SUM(EPR.SSK_DAYS) FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EP.SAL_MON = (SELECT TOP 1 SAL_MON FROM EMPLOYEES_PUANTAJ WHERE SSK_BRANCH_ID = B.BRANCH_ID AND SAL_YEAR = #attributes.sal_year# AND SAL_MON >= #i# ORDER BY SAL_MON) AND EP.SAL_YEAR = #attributes.sal_year# AND EP.SSK_BRANCH_ID = B.BRANCH_ID AND EPR.SSK_STATUTE IN (1,5,6,8,9,10,12,13,14,15,16,17,32)),0) SSK_DAYS_#i#_16
				</cfloop>
			</cfif>
		FROM
			BRANCH B
		WHERE
			B.BRANCH_ID IN (SELECT DISTINCT SSK_BRANCH_ID FROM EMPLOYEES_PUANTAJ WHERE SAL_YEAR = #attributes.sal_year#)
			AND B.FOUNDATION_DATE >= '2016-01-01 00:00:00'
			<cfif len(attributes.branch_id)>
				AND B.BRANCH_ID IN (#attributes.branch_id#)
			<cfelseif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
			</cfif>
		)T3
		UNPIVOT
		(SSK_DAYS_16 FOR SAL_MON_16 IN <cfif len(attributes.sal_mon)>(SSK_DAYS_#attributes.sal_mon#_16)<cfelse>(SSK_DAYS_1_16,SSK_DAYS_2_16,SSK_DAYS_3_16,SSK_DAYS_4_16,SSK_DAYS_5_16,SSK_DAYS_6_16,SSK_DAYS_7_16,SSK_DAYS_8_16,SSK_DAYS_9_16,SSK_DAYS_10_16,SSK_DAYS_11_16,SSK_DAYS_12_16)</cfif>
		) AS mrks_16) AS T4
		WHERE
			T2.BRANCH_ID = T4.BRANCH_ID_16
	</cfquery>
<cfelse>
	<cfset get_total.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_total.recordcount#">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='47817.Asgari Ücret Teşviği'></cfsavecontent>	
<cfform name="search_form" method="post" action="#request.self#?fuseaction=report.minimum_wage_encourage_report">
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
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>			
											<div class="col col-12">
												<div id="BRANCH_PLACE" class="multiselect-z1">
													<cfsavecontent variable="text"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
													<cf_multiselect_check 
													query_name="get_branches"  
													name="branch_id"
													option_value="BRANCH_ID"
													option_name="BRANCH_NAME"
													option_text="#text#"
													value="#attributes.branch_id#">
												</div>
											</div>
										</div>
										<div class="form-group">	
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
											<div class="col col-12">
												<select name="sal_mon" id="sal_mon">
													<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
													<cfloop from="1" to="12" index="i">
														<cfoutput>
															<option value="#i#" <cfif (isdefined("attributes.sal_mon") and len(attributes.sal_mon) and attributes.sal_mon eq i) or (not isdefined("attributes.sal_mon") and len(attributes.sal_mon) and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
														</cfoutput>
													</cfloop>
												</select>	
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
											<div class="col col-12">
												<select name="sal_year" id="sal_year">
													<cfloop from="#year(now())#" to="#year(now())#" index="i">
														<cfoutput>
															<option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
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
							<input type="hidden" name="is_form_submit" id="is_form_submit" value="1">	
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
<cfif isdefined("attributes.is_form_submit")>
	<cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_total.recordcount>
	</cfif>
	<cf_report_list>
		<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			<cfset type_ = 1>
			<cfset attributes.maxrows = get_total.recordcount>
		<cfelse>
			<cfset type_ = 0>
		</cfif>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='58724.Ay'></th>
					<th><cf_get_lang dictionary_id='57490.Gün'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_total.recordcount>
					<cfset temp_count = 1>
					<cfoutput query="get_total" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#branch_name#</td>
							<td>#listgetat(ay_list(),sal_mon)#</td>
							<td>#ssk_days_#</td>
							<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat((ssk_days_ * 3.33),2)#"></td>
						</tr>
					</cfoutput>
				<cfelse>
				<tr class="color-row">
					<td colspan="5"><cfif isdefined('attributes.is_form_submit')><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
				</tr>
				</cfif>
			</tbody>
	</cf_report_list>
	<cfscript>
		url_str = "report.minimum_wage_encourage_report";
		if(isdefined('attributes.is_form_submit'))
			url_str = '#url_str#&is_form_submit=1';
		if(len('attributes.branch_id'))
			url_str = '#url_str#&branch_id=#attributes.branch_id#';
		if(len('attributes.sal_mon'))
			url_str = '#url_str#&sal_mon=#attributes.sal_mon#';
		if(len('attributes.sal_year'))
			url_str = '#url_str#&sal_year=#attributes.sal_year#';
	</cfscript>
	<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#url_str#">
</cfif>
<script type="text/javascript">
    function control()	
	{
		if(document.search_form.is_excel.checked==false)
		{
			document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.search_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_minimum_wage_encourage</cfoutput>"
    }
</script>