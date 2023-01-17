<cfquery name="GET_COMPANY_ACTION_PLAN" datasource="#DSN#">
	SELECT 
		COMPANY_ACTION_PLAN_NOTES.ACTION_PLAN_ID,
		COMPANY_ACTION_PLAN_NOTES.SUBJECT,
		COMPANY_ACTION_PLAN_NOTES.DETAIL,
		COMPANY_ACTION_PLAN_NOTES.RECORD_DATE,
		PROCESS_TYPE_ROWS.STAGE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		BRANCH.BRANCH_NAME
	FROM
		COMPANY_ACTION_PLAN_NOTES,
		PROCESS_TYPE_ROWS,
		EMPLOYEES,
		BRANCH
	 WHERE
		COMPANY_ACTION_PLAN_NOTES.COMPANY_ID = #attributes.cpid# AND
		COMPANY_ACTION_PLAN_NOTES.PROCESS_CAT_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND 
		COMPANY_ACTION_PLAN_NOTES.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID AND 
		COMPANY_ACTION_PLAN_NOTES.RELATED_ACTION_ID = 0 AND 
		COMPANY_ACTION_PLAN_NOTES.BRANCH_ID = BRANCH.BRANCH_ID AND
		COMPANY_ACTION_PLAN_NOTES.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_company_action_plan.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','',51560)#">
	<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
    <cf_grid_list>
        <thead>
            <tr>
                <th width="30"><cf_get_lang_main no='75.No'></th>
                <th width="30"><cf_get_lang_main no='68.Konu'></th>				
                <th><cf_get_lang_main no='217.Açıklama'></th>
                <th width="200"><cf_get_lang_main no='41.Şube'></th>
                <th width="200"><cf_get_lang_main no='71.Kayıt'></th>
                <th width="120"><cf_get_lang_main no='1447.Süreç'></th>
                <th width="15"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=crm.popup_add_company_action_plan&cpid=#attributes.cpid#</cfoutput>');"><i class="fa fa-plus"></i></a></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_company_action_plan.recordcount>
              <cfoutput query="get_company_action_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td>#left(subject,50)#</td>
                    <td>#detail#</td>
                    <td>#branch_name#</td>
                    <td>#employee_name# #employee_surname# - #dateformat(record_date,dateformat_style)#</td>
                    <td>#stage#</td>
                    <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=crm.popup_upd_company_action_plan&action_plan_id=#action_plan_id#&cpid=#attributes.cpid#');"><i class="fa fa-pencil"></i></a></td>
                </tr>
              </cfoutput>
            <cfelse>
                <tr class="color-row" height="20">
                    <td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
       </tbody>
    </cf_grid_list>
  </cf_box>
<cfif attributes.totalrecords gt attributes.maxrows>
  <cf_paging
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="finance.list_securefund#url_str#">
</cfif>
<cfif isdefined("attributes.is_open_securefund") and len(attributes.is_open_securefund)>
	<script type="text/javascript">
		windowopen('<cfoutput>#request.self#?fuseaction=crm.popup_upd_securefund&securefund_id=#attributes.action_id#&cpid=#attributes.cpid#</cfoutput>','longpage');
	</script>
	<cfset attributes.is_open_securefund = ''>
</cfif>

