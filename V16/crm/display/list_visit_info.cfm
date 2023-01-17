<cfquery name="GET_EVENT_INFO" datasource="#DSN#">
	SELECT
		EVENT_PLAN.EVENT_PLAN_HEAD,
		EVENT_PLAN_ROW.PARTNER_ID,
		EVENT_PLAN_ROW.EVENT_PLAN_ID,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.FINISH_DATE,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN_ROW.EXPENSE,
		EVENT_PLAN_ROW.MONEY_CURRENCY,
		EVENT_PLAN_ROW.EXECUTE_STARTDATE,
		EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
		EVENT_PLAN_ROW.VISIT_STAGE,
		EVENT_PLAN_ROW.RESULT_RECORD_EMP,
		EVENT_PLAN_ROW.BRANCH_ID,
		EVENT_PLAN_ROW.WARNING_ID
	FROM
		EVENT_PLAN,
		EVENT_PLAN_ROW
	WHERE
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
		EVENT_PLAN_ROW.COMPANY_ID = #attributes.cpid# AND
		EVENT_PLAN_ROW.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY
		EVENT_PLAN_ROW.START_DATE DESC,
		EVENT_PLAN_ROW.FINISH_DATE DESC
</cfquery>
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cf_box title="#getLang('','',51625)#">

<cf_grid_list>
    <thead>
        <tr>
            <th width="30"><cf_get_lang_main no='75.No'></th>
            <th width="30"><cf_get_lang no='273.Plan'></th>
            <th width="125"><cf_get_lang_main no='74.Kategori'></th>
            <th width="100"><cf_get_lang no='272.Ziyareti Yapan'></th>
            <th><cf_get_lang_main no='41.Şube'></th>
            <th width="58"><cf_get_lang_main no='330.Tarih'></th>
            <th width="60"><cf_get_lang_main no='79.Saat'></th>
            <th width="70" style="text-align:right;"><cf_get_lang no='85.Harcama'></th>
            <th width="90"><cf_get_lang_main no='272.Sonuç'></th>
            <th class="header_icn_none"></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_event_info.recordcount>
            <cfset event_visit_stage_list = "">
            <cfset event_visit_type_list = "">
            <cfoutput query="get_event_info">
                <cfif Len(visit_stage) and not ListFind(event_visit_stage_list,visit_stage,',')>
                    <cfset event_visit_stage_list = ListAppend(event_visit_stage_list,visit_stage,',')>
                </cfif>
                <cfif Len(warning_id) and not ListFind(event_visit_type_list,warning_id,',')>
                    <cfset event_visit_type_list = ListAppend(event_visit_type_list,warning_id,',')>
                </cfif>
            </cfoutput>
            <cfif ListLen(event_visit_stage_list)>
                <cfset event_visit_stage_list = ListSort(event_visit_stage_list,"numeric","asc",",")>
                <cfquery name="Get_Event_Stage" datasource="#dsn#">
                    SELECT VISIT_STAGE_ID, VISIT_STAGE FROM SETUP_VISIT_STAGES WHERE VISIT_STAGE_ID IN (#event_visit_stage_list#) ORDER BY VISIT_STAGE_ID
                </cfquery>
                <cfset event_visit_stage_list = ListSort(ListDeleteDuplicates(ValueList(Get_Event_Stage.Visit_Stage_Id,',')),"numeric","asc",",")>
            </cfif>
            <cfif ListLen(event_visit_type_list)>
                <cfset event_visit_type_list = ListSort(event_visit_type_list,"numeric","asc",",")>
                <cfquery name="Get_Event_Visit_Type" datasource="#dsn#">
                    SELECT VISIT_TYPE_ID, VISIT_TYPE FROM SETUP_VISIT_TYPES WHERE VISIT_TYPE_ID IN (#event_visit_type_list#) ORDER BY VISIT_TYPE_ID
                </cfquery>
                <cfset event_visit_type_list = ListSort(ListDeleteDuplicates(ValueList(Get_Event_Visit_Type.Visit_Type_Id,',')),"numeric","asc",",")>
            </cfif>
            <cfoutput query="get_event_info">
            <tr>
                <td>#currentrow#</td>
                <td><cfif Len(event_plan_head)>#event_plan_head#<cfelse><font color="##990000"><cf_get_lang no='278.Plansız'></font></cfif></td>
                <td><cfif Len(warning_id)>#Get_Event_Visit_Type.Visit_Type[ListFind(event_visit_type_list,warning_id,',')]#</cfif></td>
                <td><cfquery name="Get_Event_Pos" datasource="#dsn#">
                        SELECT
                            E.EVENT_ROW_ID,
                            EP.EMPLOYEE_NAME,
                            EP.EMPLOYEE_SURNAME
                        FROM
                            EMPLOYEE_POSITIONS EP,
                            EVENT_PLAN_ROW_PARTICIPATION_POS E
                        WHERE
                            E.EVENT_ROW_ID IN (#event_plan_row_id#) AND
                            E.EVENT_POS_ID = EP.POSITION_CODE
                        ORDER BY
                            E.EVENT_ROW_ID
                    </cfquery>
                <cfloop query="Get_Event_Pos">
                    #Get_Event_Pos.employee_name# #Get_Event_Pos.employee_surname#
                    <cfif currentrow neq Get_Event_Pos.recordcount>,</cfif><br/>
                </cfloop>
                </td>
                <td></td>
                <td>#dateformat(start_date,dateformat_style)#</td>
                <td>#timeformat(start_date,timeformat_style)#-#timeformat(finish_date,timeformat_style)#</td>
                <td  style="text-align:right;">#tlformat(expense)# #money_currency#</td>
                <td><cfif len(visit_stage)>#Get_Event_Stage.Visit_Stage[ListFind(event_visit_stage_list,visit_stage,',')]#</cfif></td>
                <td width="20">
                    <cfif event_plan_id eq "">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_form_upd_visit&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'list');"><img src="/images/time.gif" border="0"></a>
                    <cfelse>
                        <cfif len(get_event_info.result_record_emp)>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'list');"><img src="/images/time.gif" border="0"></a>
                        <cfelse>
                            <cfif DateDiff("d",Now(),date_add("d",7,get_event_info.finish_date)) gt 0>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'list');"><img src="/images/time.gif" border="0"></a>
                            </cfif>
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

