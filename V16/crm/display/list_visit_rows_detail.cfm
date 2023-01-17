<cfquery name="GET_ROW" datasource="#DSN#">
	SELECT
		*
	FROM
		EVENT_PLAN_ROW
	WHERE
		EVENT_PLAN_ID = #attributes.visit_id#
	ORDER BY
		EVENT_PLAN_ROW_ID
</cfquery>
<cfset row_count = get_row.recordcount>
<cf_grid_list name="table1" id="table1" class="detail_basket_list">
  <thead>
      <tr>
        <th><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#row_count#</cfoutput>"><a href="javascript://" onClick="pencere_ac_company();"><i class="fa fa-plus"></i></a></th>
    <th width="200" colspan="2"><cf_get_lang dictionary_id='51654.Ziyaret Edilecek'></th>
          <th width="120" nowrap><cf_get_lang dictionary_id='57742.Tarih'> *</th>
          <th width="100" nowrap><cf_get_lang dictionary_id='53066.Başlama Saati'> *</th>
          <th width="100" nowrap><cf_get_lang dictionary_id='51547.Bitiş Saati'> *</th>
          <th width="155" nowrap><cf_get_lang dictionary_id='51717.Ziyaret Nedeni'></th>
          <th width="200" nowrap><cf_get_lang dictionary_id='51831.Ziyaret Edecekler'></th>
        <th width="19"></th>
      </tr>
  </thead>
  <tbody>
  <cfoutput query="get_row">
	<input type="hidden" name="event_row_ids#currentrow#" id="event_row_ids#currentrow#" value="#event_plan_row_id#">
	<input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="#event_plan_row_id#">
      <tr id="frm_row#currentrow#">
        <td nowrap><a style="cursor:pointer" onClick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></td>
        <td>
          <input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
          <cfif Len(get_row.company_id)>
              <cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
                SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_row.company_id#
              </cfquery>
          </cfif>
          <div class="form-group">
          <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#get_row.company_id#">
          <input type="text" name="company_name#currentrow#" id="company_name#currentrow#" readonly="" value="<cfif Len(get_row.company_id)>#get_company_name.fullname#</cfif>">
        </div>
        </td>
        <td nowrap="nowrap">
          <cfif len(get_row.partner_id)>
            <cfquery name="GET_PARTNER" datasource="#DSN#">
                SELECT
                    COMPANY_PARTNER_NAME,
                    COMPANY_PARTNER_SURNAME
                FROM
                    COMPANY_PARTNER
                WHERE
                    PARTNER_ID = #get_row.partner_id#
            </cfquery>
            <input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#get_row.partner_id#">
            <div class="form-group">
            <div class="input-group">
            <input type="text" name="partner_name#currentrow#" id="partner_name#currentrow#" readonly=""  value="#get_partner.company_partner_name# #get_partner.company_partner_surname#"><cfelse><input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value=""><input type="text" name="partner_name#currentrow#" id="partner_name#currentrow#" readonly=""></cfif><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac('#currentrow#');"></span>
            </div>
          </div>
        </td>
        <td nowrap="nowrap"><div class="form-group"><div class="input-group"><input  type="text" name="start_date#currentrow#" id="start_date#currentrow#" style="width:65" value="#dateformat(get_row.start_date,dateformat_style)#" maxlength="10"><span class="input-group-addon"><cf_wrk_date_image date_field="start_date#currentrow#"></span></div></div>
        <td>
          <div class="form-group">
            <div class="col col-6">
          <select name="start_clock#currentrow#" id="start_clock#currentrow#" >
          <option value="0" selected><cf_get_lang dictionary_id='57491.Saat'></option>
          <cfif len(get_row.start_date)>
            <cfset start_hour = hour(get_row.start_date)>
          <cfelse>
            <cfset start_hour = 0>
          </cfif>
          <cfloop from="7" to="30" index="i">
          <cfset saat=i mod 24>
          <option value="#saat#" <cfif start_hour eq saat>selected</cfif>>#saat#</option>
          </cfloop>
          </select>
          </div><div class="col col-6">
          <cfif len(get_row.start_date)>
            <cfset start_minute = minute(get_row.start_date)>
          <cfelse>
            <cfset start_minute = 0>
          </cfif>
          <select name="start_minute#currentrow#" id="start_minute#currentrow#" >
            <option value="00" <cfif start_minute eq 00>selected</cfif>>00</option>
            <option value="05" <cfif start_minute eq 05>selected</cfif>>05</option>
            <option value="10" <cfif start_minute eq 10>selected</cfif>>10</option>
            <option value="15" <cfif start_minute eq 15>selected</cfif>>15</option>
            <option value="20" <cfif start_minute eq 20>selected</cfif>>20</option>
            <option value="25" <cfif start_minute eq 25>selected</cfif>>25</option>
            <option value="30" <cfif start_minute eq 30>selected</cfif>>30</option>
            <option value="35" <cfif start_minute eq 35>selected</cfif>>35</option>
            <option value="40" <cfif start_minute eq 40>selected</cfif>>40</option>
            <option value="45" <cfif start_minute eq 45>selected</cfif>>45</option>
            <option value="50" <cfif start_minute eq 50>selected</cfif>>50</option>
            <option value="55" <cfif start_minute eq 55>selected</cfif>>55</option>
          </select>
        </div>
        </td>
        <td>
          <div class="form-group">
            <div class="col col-6">
          <select name="finish_clock#currentrow#" id="finish_clock#currentrow#" style="width:45px;">
          <option value="0" selected><cf_get_lang dictionary_id='57491.Saat'></option>
          <cfif len(get_row.finish_date)>
            <cfset finish_hour = hour(get_row.finish_date)>
          <cfelse>
            <cfset finish_hour = 0>
          </cfif>
          <cfloop from="7" to="30" index="i">
          <cfset saat=i mod 24>
            <option value="#saat#" <cfif finish_hour eq saat>selected</cfif>>#saat#</option>
          </cfloop>
          </select>
          </div><div class="col col-6">
          <cfif len(get_row.finish_date)>
            <cfset finish_minute = minute(get_row.finish_date)>
          <cfelse>
            <cfset finish_minute = 0>
          </cfif>
          <select name="finish_minute#currentrow#" id="finish_minute#currentrow#" style="width:40px;">
            <option value="30" <cfif finish_minute eq 30>selected</cfif>>30</option>
            <option value="00" <cfif finish_minute eq 00>selected</cfif>>00</option>
            <option value="05" <cfif finish_minute eq 05>selected</cfif>>05</option>
            <option value="10" <cfif finish_minute eq 10>selected</cfif>>10</option>
            <option value="15" <cfif finish_minute eq 15>selected</cfif>>15</option>
            <option value="20" <cfif finish_minute eq 20>selected</cfif>>20</option>
            <option value="25" <cfif finish_minute eq 25>selected</cfif>>25</option>
            <option value="30" <cfif finish_minute eq 30>selected</cfif>>30</option>
            <option value="35" <cfif finish_minute eq 35>selected</cfif>>35</option>
            <option value="40" <cfif finish_minute eq 40>selected</cfif>>40</option>
            <option value="45" <cfif finish_minute eq 45>selected</cfif>>45</option>
            <option value="50" <cfif finish_minute eq 50>selected</cfif>>50</option>
            <option value="55" <cfif finish_minute eq 55>selected</cfif>>55</option>
          </select>
        </div>
        </td>
        <td>
          <div class="form-group">
          <cfset form_warning_id = get_row.warning_id>
          <select name="warning_id#currentrow#" id="warning_id#currentrow#" style="width:150px;">
          <cfloop query="get_event_cats">
            <option value="#visit_type_id#" <cfif form_warning_id eq visit_type_id>selected</cfif>>#visit_type#</option>
          </cfloop>
          </select>
        </div>
        </td>
        <td>
          <cfquery name="GET_ROW_POS" datasource="#dsn#">
            SELECT
                EVENT_POS_ID
            FROM 
                EVENT_PLAN_ROW_PARTICIPATION_POS
            WHERE
                EVENT_ROW_ID = #event_plan_row_id#
          </cfquery>
          <input type="hidden" name="pos_emp_id#currentrow#" id="pos_emp_id#currentrow#" value="#session.ep.userid#">
          <div class="input-group">
          <input type="text" name="pos_emp_name#currentrow#" id="pos_emp_name#currentrow#" readonly="" value="#get_emp_info(session.ep.userid,0,0)#" style="width:160px;"><span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_pos('#currentrow#');temizlerim('#currentrow#');"></span>
          </div>
        </td>
        <td width="19">
          <cfif len(get_row.result_record_emp)>		
            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#');"><i class="fa fa-clock-o" title="<cf_get_lang dictionary_id='58437.Ziyaret Sonucu'>"></i></a>
          <cfelse>
            <!--- Ziyaret tarihine gore 7 gun kontrolu --->
            <cfif DateDiff("d",Now(),date_add("d",7,get_row.finish_date)) gt 0>
              <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#');"><i class="fa fa-clock-o" title="<cf_get_lang dictionary_id='58437.Ziyaret Sonucu'>"></i></a>
            </cfif>
          </cfif>
        </td>
     </tr>
  </tbody>
</cfoutput>
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

/*function temizlerim(no)
{
	var my_element=eval("add_event.pos_emp_id"+no);
	var my_element2=eval("add_event.pos_emp_name"+no);
	my_element.value='';
	my_element2.value='';
}*/

function pencere_ac(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=add_event.partner_id' + no +'&field_comp_name=add_event.company_name' + no +'&field_name=add_event.partner_name' + no +'&field_comp_id=add_event.company_id' + no + '&is_crm_module=1&select_list=2,3,5,6','list');
}

function pencere_ac_date(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_event.start_date' + no ,'date');
}

function pencere_ac_company(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&sales_zone_id=' + add_event.sales_zones.value + '&ims_code_id=' +  add_event.ims_code_id.value +'&is_submitted=1&record_num_=' + add_event.record_num.value,'medium');
}
</script>
