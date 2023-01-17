<cfparam name="attributes.perform_year" default="#year(now())-1#">
<cfparam name="attributes.performance_note" default="">
<cfquery name="ALL_BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_NAME,
		BRANCH_ID
	FROM
		BRANCH
	WHERE
		SSK_NO IS NOT NULL AND
		SSK_OFFICE IS NOT NULL AND
		SSK_BRANCH IS NOT NULL AND
		SSK_NO <> '' AND
		SSK_OFFICE <> '' AND
		SSK_BRANCH <> ''
	<cfif not session.ep.ehesap>
		AND BRANCH_ID IN 
		(
			SELECT
				BRANCH_ID
			FROM
				EMPLOYEE_POSITION_BRANCHES
			WHERE
				POSITION_CODE = #SESSION.EP.POSITION_CODE#
		)
	</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
<cf_box title="#getLang('hr',922)#" uidrop="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=hr.popup_print_out_pd_form_result" method="post" name="search_">
		<cf_box_search>	
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<div class="form-group col col-4 col-xs-12">
					<select name="branch_id" id="branch_id">
						<cfoutput query="ALL_BRANCHES">
							<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (branch_id eq attributes.branch_id)> selected</cfif>>#BRANCH_NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-3 col-xs-12">
					<label><cf_get_lang dictionary_id='56009.Performans Notu'></label>
					<select name="performance_note" id="performance_note">
						<option value="2"<cfif isdefined("attributes.performance_note") and (attributes.performance_note is "2")> selected</cfif>>2</option>
						<option value="2.5"<cfif isdefined("attributes.performance_note") and (attributes.performance_note is "2.5")> selected</cfif>>2.5</option>
						<option value="3"<cfif isdefined("attributes.performance_note") and (attributes.performance_note is "3")> selected</cfif>>3</option>
						<option value="3.5"<cfif isdefined("attributes.performance_note") and (attributes.performance_note is "3.5")> selected</cfif>>3.5</option>
						<option value="4"<cfif isdefined("attributes.performance_note") and (attributes.performance_note is "4")> selected</cfif>>4</option>
						<option value="4.5"<cfif isdefined("attributes.performance_note") and (attributes.performance_note is "4.5")> selected</cfif>>4.5</option>
						<option value="5"<cfif isdefined("attributes.performance_note") and (attributes.performance_note is "5")> selected</cfif>>5</option>
					</select>
				</div>
				<div class="form-group col col-2 col-xs-12">
					<label><cf_get_lang dictionary_id='58455.Yıl'></label>
					<select name="perform_year" id="perform_year">
						<cfoutput>#attributes.perform_year#
							<cfloop from="2003" to="#year(now())#" index="i">
								<option value="#i#" <cfif i eq attributes.perform_year>selected</cfif>>#i#</option>
							</cfloop>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-1 col-xs-12">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<div class="form-group col col-1 col-xs-12">
					<a href="javascript://" onClick="$('#print_result').printThis();" class="ui-wrk-btn ui-wrk-btn-info ">
						<i class="fa fa-print" title="Yazdır" id="list_print_button"></i>
					</a>
				</div>
			</div>
		</cf_box_search>
 
		<cfif isdefined("attributes.branch_id")>
			<cfquery name="get_performances" datasource="#dsn#">
				SELECT 
					EPER.*,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME
				FROM 
					EMPLOYEE_PERFORMANCE EPER,
					EMPLOYEE_POSITIONS EP,
					DEPARTMENT D,
					EMPLOYEES E
				WHERE
					EP.EMPLOYEE_ID = EPER.EMP_ID
					AND E.EMPLOYEE_ID = EPER.EMP_ID
					AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID
					AND (EPER.RECORD_TYPE IS NULL OR EPER.RECORD_TYPE = 1)
					AND D.BRANCH_ID = #attributes.branch_id#
					AND EPER.USER_POINT_OVER_5 = #attributes.performance_note#
					AND YEAR(EPER.START_DATE) = #attributes.perform_year#
			</cfquery>
			<cfif get_performances.recordcount>
				<cfquery name="get_manager_1s" dbtype="query">
					SELECT DISTINCT MANAGER_1_EMP_ID FROM get_performances WHERE MANAGER_1_EMP_ID IS NOT NULL 
				</cfquery>
				<cfset get_manager_ids = valuelist(get_manager_1s.MANAGER_1_EMP_ID)>
				<cfquery name="get_manager_2s" dbtype="query">
					SELECT DISTINCT MANAGER_2_EMP_ID FROM get_performances WHERE MANAGER_2_EMP_ID IS NOT NULL <cfif listlen(get_manager_ids)>AND MANAGER_2_EMP_ID NOT IN (#get_manager_ids#)</cfif>
				</cfquery>
				<cfset get_manager2_ids = valuelist(get_manager_2s.MANAGER_2_EMP_ID)>
				<cfset get_manager_ids = listappend(get_manager_ids,get_manager2_ids)>
				<cfset get_manager_ids = listsort(get_manager_ids,'numeric','desc')>
				<cfif listlen(get_manager_ids)>
					<cfquery name="get_employee_names" datasource="#dsn#">
						SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#get_manager_ids#)
					</cfquery>
				</cfif>
			</cfif>
			<div id="print_result">
				<cfloop query="get_performances">
						<cfinclude template="print_out_pd_form_result_note2.cfm">
				</cfloop>
			</div>
		</cfif>
	</cfform>
</cf_box>
