<cfquery name="GET_EVENT_INFO" datasource="#dsn#">
	SELECT DISTINCT
		ACTIVITY_PLAN_ROW.EVENT_PLAN_ID,
		ACTIVITY_PLAN_ROW.WARNING_ID,
		ACTIVITY_PLAN_ROW.START_DATE,
		ACTIVITY_PLAN_ROW.FINISH_DATE,
		ACTIVITY_PLAN_ROW.EVENT_PLAN_ROW_ID,
		ACTIVITY_PLAN_ROW.EXECUTE_STARTDATE,
		ACTIVITY_PLAN_ROW.EXECUTE_FINISHDATE,
		ACTIVITY_PLAN_ROW.VISIT_STAGE,
		ACTIVITY_PLAN_ROW.POSITION_ID,
		ACTIVITY_PLAN_ROW.RESULT_RECORD_EMP,
		ACTIVITY_PLAN_ROW.EXPENSE,
		ACTIVITY_PLAN_ROW.MONEY_CURRENCY,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.PARTNER_ID,
		SETUP_ACTIVITY_TYPES.ACTIVITY_TYPE
	FROM
		ACTIVITY_PLAN_ROW,
		COMPANY,
		COMPANY_PARTNER,
		SETUP_ACTIVITY_TYPES,
		COMPANY_BRANCH_RELATED,
		BRANCH
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND
		COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
		ACTIVITY_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		SETUP_ACTIVITY_TYPES.ACTIVITY_TYPE_ID = ACTIVITY_PLAN_ROW.WARNING_ID AND
		ACTIVITY_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY 
		ACTIVITY_PLAN_ROW.EVENT_PLAN_ROW_ID DESC
</cfquery>
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cf_box title="#getLang('','',51624)#">
<cf_grid_list>
	<thead>
        <tr>
            <th width="30"><cf_get_lang no='273.Plan'></th>
            <th><cf_get_lang_main no='74.Kategori'></th>
            <th><cf_get_lang_main no='157.Görevli'></th>
            <th><cf_get_lang_main no='41.Şube'></th>
            <th><cf_get_lang_main no='330.Tarih'></th>
            <th style="text-align:right;"><cf_get_lang no='85.Harcama'></th>
            <th><cf_get_lang_main no='272.Sonuç'></th>
            <th class="header_icn_none"></th>
        </tr>
    </thead>
    <tbody>
		<cfif get_event_info.recordcount>
            <cfoutput query="get_event_info">
                <tr>
                    <td><cfif len(event_plan_id)>
                            <cfquery name="GET_ACTIVITY_PLAN" datasource="#dsn#">
                                SELECT EVENT_PLAN_HEAD, ANALYSE_ID FROM ACTIVITY_PLAN WHERE EVENT_PLAN_ID = #event_plan_id#
                            </cfquery>#get_activity_plan.event_plan_head#<cfelse><font color="##990000"><cf_get_lang no='278.Plansız'></font></cfif>
                    </td>
                    <td><cfif len(warning_id)>
                            <cfquery name="GET_VISIT_TYPE" datasource="#dsn#">
                                SELECT ACTIVITY_TYPE FROM SETUP_ACTIVITY_TYPES WHERE ACTIVITY_TYPE_ID = #warning_id#
                            </cfquery>#get_visit_type.ACTIVITY_TYPE#
                        </cfif>
                    </td>
                    <td>#get_emp_info(position_id,1,0)#</td>
                    <td>&nbsp;</td>
                    <td>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)# - #timeformat(finish_date,timeformat_style)#</td>
                    <td style="text-align:right;">#tlformat(expense)# #money_currency#</td>
                    <td><cfif len(visit_stage)>
                            <cfquery name="GET_VISIT_STAGE" datasource="#dsn#">
                                SELECT 
        	                        VISIT_STAGE_ID, 
                                    VISIT_STAGE, 
                                    DETAIL,
                                    RECORD_EMP, 
                                    RECORD_DATE, 
                                    RECORD_IP, 
                                    UPDATE_EMP, 
                                    UPDATE_DATE, 
                                    UPDATE_IP 
                                FROM 
    	                            SETUP_VISIT_STAGES 
                                WHERE 
	                                VISIT_STAGE_ID = #visit_stage#
                            </cfquery>#get_visit_stage.visit_stage#
                        </cfif>
                    </td>
                    <td width="20">
                        <cfif event_plan_id eq "">
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_activity&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'list');"><i class="fa fa-pencil"></i></a>
                        <cfelse>
                            <cfif len(result_record_emp)>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_activity_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'medium');"><i class="fa fa-pencil"></i></a>
                            <cfelse>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_activity_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'medium');"><i class="fa fa-pencil"></i></a>
                            </cfif>
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="8"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
</cf_box>

