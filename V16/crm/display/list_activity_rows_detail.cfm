<cfquery name="GET_ROW" datasource="#dsn#">
	SELECT * FROM ACTIVITY_PLAN_ROW WHERE EVENT_PLAN_ID = #attributes.visit_id#
</cfquery>
<cfset row_count = get_row.recordcount>
<cf_grid_list name="table1" id="table1" class="detail_basket_list">
  <thead>	
    <tr>
      <th width="15"><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#row_count#</cfoutput>"><a href="javascript://" onClick="pencere_ac_company();"><img src="/images/plus_list.gif" border="0"></a></th>
      <th nowrap colspan="2"><cf_get_lang dictionary_id='51838.Etkinlik Yapılacak'></th>
      <th nowrap><cf_get_lang dictionary_id='58467.Başlama'>*</th>
      <th nowrap><cf_get_lang dictionary_id='57502.Bitiş'>*</th>
      <th nowrap><cf_get_lang dictionary_id='57578.Yetkili'></th>
      <th>&nbsp;</th>
    </tr>
  </thead>
  <tbody>
	<cfoutput query="get_row">
        <tr id="frm_row#currentrow#">
            <input type="hidden" name="event_row_ids#currentrow#" id="event_row_ids#currentrow#" value="#event_plan_row_id#">
            <input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="#event_plan_row_id#">
            <td nowrap><a style="cursor:pointer" onclick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>        
            <td><input  type="hidden"  value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
            <cfquery name="GET_COMPANY_NAME" datasource="#dsn#">
                SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_row.company_id#
            </cfquery>
            <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#get_row.company_id#">
            <input type="text" name="company_name#currentrow#" id="company_name#currentrow#" readonly="" style="width:150px;" value="#get_company_name.fullname#"></td>
            <td>
            <cfif len(get_row.partner_id)>
            <cfquery name="GET_PARTNER" datasource="#dsn#">
                SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_row.partner_id#
            </cfquery>
            <div class="form-group">
                <div class="input-group">
                    <input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#get_row.partner_id#">
                    <input type="text" name="partner_name#currentrow#" id="partner_name#currentrow#" readonly="" value="#get_partner.company_partner_name# #get_partner.company_partner_surname#"><cfelse><input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value=""><input type="text" name="partner_name#currentrow#" id="partner_name#currentrow#" readonly=""></cfif>
                    <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac('#currentrow#');"></span></td>
                </div>
            </div>
            <td>
                <input type="text" name="start_date#currentrow#" id="start_date#currentrow#" style="width:65px;" value="#dateformat(get_row.start_date,dateformat_style)#">
                <cf_wrk_date_image date_field="start_date#currentrow#">
            <td>
                <input type="text"  name="finish_date#currentrow#" id="finish_date#currentrow#" style="width:65px;" value="#dateformat(get_row.start_date,dateformat_style)#">
                <cf_wrk_date_image date_field="finish_date#currentrow#">
            <td>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="pos_emp_id#currentrow#" id="pos_emp_id#currentrow#" value="#position_id#">
                        <input type="text" name="pos_emp_name#currentrow#" id="pos_emp_name#currentrow#" readonly="" style="width:130;" value="#get_emp_info(position_id,1,0)#">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_pos('#currentrow#');"></span></td>
                    </div>
                </div>
            <td>
              <cfif len(get_row.result_record_emp)>
                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_upd_activity_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#');"><i class="fa fa-paper-plane"></i></a>
              <cfelse>
                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_activity_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#');"><i class="fa fa-paper-plane"></i></a>
              </cfif>
           </td>
        </tr>
	</cfoutput>
  </tbody>
</cf_grid_list>



<script type="text/javascript">
  function sil(sy)
    {
      var my_element=eval("add_event.row_kontrol"+sy);
      my_element.value=0;
      var my_element=eval("frm_row"+sy);
      my_element.style.display="none";
    }
  function kontrol_et()
    {
      if(row_count ==0)
        return false;
      else
        return true;
    }
</script>
