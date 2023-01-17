<cfparam name="attributes.shift_employee_id" default="#session.ep.USERID#">
<cfparam name="attributes.master_plan_status" default="">
<cfparam name="attributes.start_h" default="08">
<cfparam name="attributes.finish_h" default="18">
<cfparam name="attributes.start_m" default="00">
<cfparam name="attributes.finish_m" default="00">
<cfquery name="get_defaults" datasource="#dsn3#">
	SELECT DEFAULT_IFLOW_MASTER_PAPER, DEFAULT_IFLOW_MASTER_PAPER_NO FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<table class="dph">
  	<tr>
        <td class="dpht">
            <a href="javascript:gizle_goster_basket(detail_inv_menu);">&raquo;</a><cf_get_lang_main no='3332.Üretim Planı Ekle'>
        </td>
  	</tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_iflow_master_plan">
	<cf_basket_form id="detail_inv_menu">
		<cfoutput>
        <cf_object_main_table>	
            <cf_object_table column_width_list="100,250">
                <cfsavecontent variable="header_"><cfoutput>#getLang('project',6)#</cfoutput></cfsavecontent>
                <cf_object_tr id="form_ul_order_date" Title="#header_#">
                    <cf_object_td type="text"><cfoutput>#getLang('project',6)#</cfoutput>*</cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="shift_id" id="shift_id" value="">
						<input type="text" name="shift_name" id="shift_name" value="" style="width:175px;" >
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_list_ezgi_shift&field_name=shift_name&field_id=shift_id','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </cf_object_td>
                </cf_object_tr>
                
                <cfsavecontent variable="header_"><cfoutput>#getLang('project',161)#</cfoutput></cfsavecontent>
                <cf_object_tr id="form_ul_order_date" Title="#header_#">
                    <cf_object_td type="text"><cfoutput>#getLang('project',161)#</cfoutput>*</cf_object_td>
                    <cf_object_td>
                        <input type="hidden" name="shift_employee_id" id="shift_employee_id" value="<cfif Len(attributes.shift_employee_id)>#attributes.shift_employee_id#</cfif>">
						<input type="text" name="shift_employee" id="shift_employee" value="<cfif Len(attributes.shift_employee_id)>#get_emp_info(attributes.shift_employee_id,0,0)#</cfif>" style="width:175px;" onFocus="AutoComplete_Create('shift_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','shift_employee_id','','3','125');" autocomplete="off">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=shift_employee_id&field_name=shift_employee&select_list=1','list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </cf_object_td>
                </cf_object_tr>
                
                <cfsavecontent variable="header_"><cf_get_lang_main no='468.Belge No'></cfsavecontent>
                <cf_object_tr id="form_ul_order_date" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='468.Belge No'>*</cf_object_td>
                    <cf_object_td>
                        <input name="paper_serious" type="text" readonly="readonly" value="#Trim(get_defaults.DEFAULT_IFLOW_MASTER_PAPER)#" maxlength="2" style="width:25px;" />
						<input name="paper_number" type="text" readonly="readonly"  value="#get_defaults.DEFAULT_IFLOW_MASTER_PAPER_NO#" maxlength="6" style="width:80px;" />
                    </cf_object_td>
                </cf_object_tr>
                
            </cf_object_table>
            <cf_object_table column_width_list="120,180">
                <cfsavecontent variable="header_"><cf_get_lang_main no='243.Baslama Tarihi'></cfsavecontent>
                <cf_object_tr id="form_ul_lot_no" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='243.Baslama Tarihi'> *</cf_object_td>
                    <cf_object_td>
						<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
							<input type="text" name="start_date" id="start_date"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.start_date,'DD/MM/YYYY')#"> 
						<cfelse>
							<input type="text" name="start_date" id="start_date"  validate="eurodate" style="width:65px;" value="">
                            <cf_wrk_date_image date_field="start_date">
                            <select name="start_h" id="start_h">
                             	<cfloop from="0" to="23" index="i">
                                  	<option value="#i#" 
										<cfif attributes.start_h eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#
                                 	</option>
                              	</cfloop>
                         	</select>
                        	<select name="start_m" id="start_m">
                              	<cfloop from="0" to="59" index="i">
                                  	<option value="#i#" 
										<cfif attributes.start_m eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#
                                  	</option>
                           		</cfloop>
                         	</select>
						</cfif>
						
                    </cf_object_td>
                </cf_object_tr>
                
                <cfsavecontent variable="header_"><cf_get_lang_main no='288.Bitis Tarihi '></cfsavecontent>
                <cf_object_tr id="form_ul_lot_no" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='288.Bitis Tarihi '> *</cf_object_td>
                    <cf_object_td>
						<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
							<input type="text" name="finish_date" id="finish_date"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.finish_date,'DD/MM/YYYY')#"> 
						<cfelse>
							<input type="text" name="finish_date" id="finish_date"  validate="eurodate" style="width:65px;" value="">
                            <cf_wrk_date_image date_field="finish_date">
                            <select name="finish_h" id="finish_h">
                             	<cfloop from="0" to="23" index="i">
                                  	<option value="#i#" 
										<cfif attributes.finish_h eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#
                                 	</option>
                              	</cfloop>
                         	</select>
                        	<select name="finish_m" id="finish_m">
                              	<cfloop from="0" to="59" index="i">
                                  	<option value="#i#" 
										<cfif attributes.finish_m eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#
                                  	</option>
                           		</cfloop>
                         	</select>
						</cfif>
						
                    </cf_object_td>
                </cf_object_tr>
                
                <cfsavecontent variable="header_"><cf_get_lang_main no='642.Süreç/Asama'></cfsavecontent>
                <cf_object_tr id="form_ul_lot_no" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='642.Süreç/Asama'> *</cf_object_td>
                    <cf_object_td>
						<cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'>
                    </cf_object_td>
                </cf_object_tr>
                
            </cf_object_table>
             <cf_object_table column_width_list="90,250">
                <cfsavecontent variable="header_"><cf_get_lang_main no='81.Aktif'></cfsavecontent>
                <cf_object_tr id="form_ul_process_stage" Title="#header_#">
                    <cf_object_td type="text"></cf_object_td>
                    <cf_object_td>
                    	<input type="checkbox" name="master_plan_status" checked="checked" value="1"><cf_get_lang_main no='81.Aktif'>
                    </cf_object_td>
                </cf_object_tr>
                
                <cfsavecontent variable="header_"><cf_get_lang_main no='217.Açiklama'></cfsavecontent>
                <cf_object_tr id="form_ul_process_stage" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='217.Açiklama'></cf_object_td>
                    <cf_object_td>
                    	<textarea name="detail" id="detail" style="width:200px;height:40px;"></textarea>
                    </cf_object_td>
                </cf_object_tr>
                
            </cf_object_table>
        </cf_object_main_table>
        </cfoutput>	
     	<cf_basket_form_button>
        	<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
      	</cf_basket_form_button>
    </cf_basket_form>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
		if (form_basket.shift_id.value.length == 0)
		{
			alert("<cf_get_lang_main no='3333.Plan Adı Girmelisiniz'> !");
			return false;
		}
		if (form_basket.start_date.value.length == 0)
		{
			alert("<cf_get_lang_main no='3334.Plan Başlama Tarihi Girmelisiniz'> !");
			return false;
		}
		if (form_basket.finish_date.value.length == 0)
		{
			alert("<cf_get_lang_main no='3335.Plan Bitiş Tarihi Girmelisiniz'> !");
			return false;
		}
		if(process_cat_control())
			return true;
		else
			return false;
	}
</script>