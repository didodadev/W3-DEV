<cfinclude template="../query/get_branchs_deps.cfm">
<cfinclude template="../query/get_usage_purpose.cfm">
<cfinclude template="../query/get_max_line.cfm">
<cfinclude template="../query/get_authorization.cfm">
<cfinclude template="../query/get_sales_return_request.cfm">

<cf_catalystHeader>
  <div class="col col-9 col-md-12 col-sm-12 col-xs-12">
      <cf_box>
          <cfform name="upd_return_request" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_return_request" onsubmit="return(unformat_fields());">
            <input type="hidden" name="request_id" id="request_id" value="<cfoutput>#attributes.request_id#</cfoutput>">
            <input type="hidden" name="request_row_id" id="request_row_id" value="<cfoutput>#attributes.request_row_id#</cfoutput>">
            <cf_basket_form id="return_request_">
                <cf_box_elements>
                  <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-branch_id">
                      <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
                      <div class="col col-8 col-sm-12">
                        <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_request_rows.branch_id#</cfoutput>">
                        <cfinput type="text" name="branch" value="#get_request_rows.branch_name#" readonly="yes">
                      </div>                
                    </div>
                    <div class="form-group" id="item-process_stage">
                      <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                      <div class="col col-8 col-sm-12">
                        <cf_workcube_process 
                          is_upd='0' 
                          select_value='#get_request_rows.request_state#' 
                          process_cat_width='180' 
                          is_detail='1'>
                      </div>                
                    </div> 
                    <div class="form-group" id="item-employee_id">
                      <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='47953.Talep Eden'> *</label>
                      <div class="col col-8 col-sm-12">
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_request_rows.employee_id#</cfoutput>">
                        <input type="text" name="employee" id="employee" value="<cfoutput>#get_request_rows.employee_name# #get_request_rows.employee_surname#</cfoutput>" readonly>
                      </div>                
                    </div> 
                  </div>
                  <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-request_date">
                      <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='47994.Talep Tarihi'> *</label>
                      <div class="col col-8 col-sm-12">
                        <input type="text" name="request_date" id="request_date" value="<cfoutput>#dateformat(get_request_rows.request_date,dateformat_style)#</cfoutput>" maxlength="10" readonly>
                      </div>                
                    </div>
                    <div class="form-group" id="item-detail">
                      <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                      <div class="col col-8 col-sm-12">
                        <textarea name="detail" id="detail" style="width:320px;height:70px;"><cfoutput>#get_request_rows.detail#</cfoutput></textarea>
                      </div>                
                    </div>
                  </div>
                </cf_box_elements>
            </cf_basket_form>
            <cf_basket id="return_request_bask_">
                <cfinclude template="../form/upd_return_row.cfm"></td>
            </cf_basket>
            <cf_box_footer>
              <div class="col col-6">
                <cf_record_info query_name="get_request_rows">
              </div>
              <!--- Eğer yetki yok ise butonu gösterme --->
              <div class="col col-6">
                <cfif get_max_line.max_line gte get_authorization.line_number>
                    <cfif get_request_rows.line_number eq 1 or session.ep.admin eq 1>
                    <cf_workcube_buttons is_upd='1' is_reset='0' is_delete='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_purchase_request&request_row_id=#attributes.request_row_id#&request_id=#attributes.request_id#&head=#get_request_rows.employee_name# #get_request_rows.employee_surname#' is_cancel='0'>
                    <cfelse>
                    <cf_workcube_buttons is_upd='1' is_reset='0' is_delete='0' add_function='kontrol()' is_cancel='0'>
                    </cfif>
                </cfif>
              </div>
          </cf_box_footer>
          </cfform>
      </cf_box>
  </div>
  <div class="col col-3 col-md-12 col-sm-12 col-xs-12">
      <!--- Notlar --->
      <cf_get_workcube_note action_section='EXCHANGE_REQUEST_ID' action_id='#attributes.request_row_id#'>
  </div>
<script type="text/javascript">
function plaka_ac()
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_return_request.assetp_id&field_name=upd_return_request.assetp&field_brand_type_id=upd_return_request.brand_type_id&field_brand_name=upd_return_request.brand_name&field_make_year=upd_return_request.make_year');
}	

function unformat_fields()
{
	document.upd_return_request.make_year.disabled = false;
}	

function kontrol()
{
	if(document.upd_return_request.detail.value.length > 250)
	{
		alert("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='48082.en fazla 250 karakter'>!");
		return false;
	}
	if(document.upd_return_request.branch.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'>!");
		return false;
	}
	if(document.upd_return_request.employee.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='47953.Talep Eden'>!");
		return false;
	}
	if(!CheckEurodate(document.upd_return_request.request_date.value,'Talep Tarihi') || !document.upd_return_request.request_date.value.length) 
	{
		alert("<cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='47994.Talep Tarihi'>!");
		return false;
	}
	if(document.upd_return_request.assetp.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29453.Plaka'>!");
		return false;
	}
	if(document.upd_return_request.brand_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'>!");
		return false;
	}
	x = document.upd_return_request.make_year.selectedIndex;
	if (document.upd_return_request.make_year[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58225.Model'>!");
		return false;
	}
	return process_cat_control();
}
</script>
