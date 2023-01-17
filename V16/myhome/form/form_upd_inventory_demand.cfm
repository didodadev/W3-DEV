<cf_get_lang_set module_name="myhome">
<cfif fusebox.circuit eq 'myhome'>
	<cfset attributes.inventory_demand_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.inventory_demand_id,accountKey:'wrk') />
</cfif>
<cfif isdefined("attributes.form_type") and attributes.form_type eq 3>
	<cfscript>
        get_demands = createObject("component","V16.myhome.cfc.get_inventory_demands_row");
        get_demands.dsn = dsn;
        get_inventory_demand = get_demands.inventory_demands
                        (
                            employee_id : attributes.employee_id
                        );
    </cfscript>
    <cfquery name="get_inventory_demand_rows" datasource="#dsn#">
        SELECT
            IDR.INVENTORY_CAT_ID
        FROM
            EMPLOYEES_INVENTORY_DEMAND ID LEFT JOIN EMPLOYEES_INVENTORY_DEMAND_ROWS IDR ON IDR.INVENTORY_DEMAND_ID = ID.INVENTORY_DEMAND_ID
        WHERE
            ID.EMPLOYEE_ID IS NOT NULL
            <cfif isdefined('attributes.employee_id')>
                AND ID.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
            </cfif>
            AND FORM_TYPE <> 3
            AND IDR.INVENTORY_CAT_ID IS NOT NULL
      	GROUP BY
            IDR.INVENTORY_CAT_ID        
    </cfquery>
<cfelse>
	<cfscript>
        get_demands = createObject("component","V16.myhome.cfc.get_inventory_demands");
        get_demands.dsn = dsn;
        get_inventory_demand = get_demands.inventory_demands
                        (
                            inventory_demand_id : attributes.inventory_demand_id
                        );
    </cfscript>
</cfif>
<cfquery name="get_demand_reason" datasource="#DSN#">
    SELECT REASON_ID, REASON FROM SETUP_INVENTORY_DEMAND_REASON WHERE ACTIVE = 1
</cfquery>
<cf_popup_box title="Envanter Talep Güncelleme Formu">
	<cfform name="inventory_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_inventory_demand" method="post">
		<cfoutput query="get_inventory_demand">
            <input type="hidden" name="inventory_demand_id" id="inventory_demand_id" value="#inventory_demand_id#">
            <input type="hidden" name="MANAGER_VALID" id="MANAGER_VALID" value="#MANAGER_VALID#">
            <input type="hidden" name="MANAGER_VALID_DATE" id="MANAGER_VALID_DATE" value="#MANAGER_VALID_DATE#">
            <input type="hidden" name="IT_VALID" id="IT_VALID" value="#IT_VALID#">
            <input type="hidden" name="IT_VALID_DATE" id="IT_VALID_DATE" value="#IT_VALID_DATE#">
            <input type="hidden" name="EMPLOYEE_VALID" id="EMPLOYEE_VALID" value="#EMPLOYEE_VALID#">
            <input type="hidden" name="EMPLOYEE_VALID_DATE" id="EMPLOYEE_VALID_DATE" value="#EMPLOYEE_VALID_DATE#">
            <input type="hidden" name="old_process_stage" id="old_process_stage" value="#demand_stage#">
        	<table> 
                <tr>
                    <td style="width:150px;"><cf_get_lang no='1001.Form Tipi'>                    
                        <select name="form_type" id="form_type" style="width:90px; float:right">
                            <option value="1" <cfif isdefined("attributes.FORM_TYPE") and attributes.FORM_TYPE eq 1 or FORM_TYPE eq 1>selected</cfif>><cf_get_lang no='517.İşe Giriş'></option>
                            <option value="2" <cfif isdefined("attributes.FORM_TYPE") and attributes.FORM_TYPE eq 2 or FORM_TYPE eq 2>selected</cfif>><cf_get_lang_main no='291.Güncelleme'></option>
                            <option value="3" <cfif isdefined("attributes.FORM_TYPE") and attributes.FORM_TYPE eq 3 or FORM_TYPE eq 3>selected</cfif>><cf_get_lang_main no='2035.İşten Çıkış'></option>
                        </select>
                    </td>
                    <td style="width:30px;"><cf_get_lang_main no ='1447.Süreç'></td>
                    <td></td>
                    <td><cf_workcube_process is_upd='0' select_value='#demand_stage#' process_cat_width='100' is_detail='1'></td>
                </tr>
            </table>
            <table border="0">
                <tr>
                    <td><cf_get_lang_main no='164.Calışan'></td>
                    <td>
                        <input type="hidden" name="employee_id" id="employee_id" value="#employee_id#">
                        <input name="emp_name" type="text" id="emp_name" style="width:100%;" readonly="readonly" value="#EMPLOYEE_NAME#" />
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='1714.Yönetici'></td>
                    <td>
                        <input type="hidden" name="upper_position_code" id="upper_position_code" value="#upper_position_code#">
                        <input type="text" name="upper_position" id="upper_position" style="width:100%;" readonly="readonly" value="#manager_name_surname#"/>
                    </td>
                </tr>
                <tr> 
                    <td><cf_get_lang_main no='2234.Lokasyon'></td>
                    <td>
                        <input type="hidden" name="branch_id" id="branch_id" value="#branch_id#">
                       <input name="branch" type="text" id="branch" style="width:100%;" readonly="readonly" value="#branch_name#"/>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='1085.Pozisyon'></td>
                    <td>
                        <input type="hidden" name="position_cat_id" id="position_cat_id" value="#position_id#">
                        <input type="text" name="position" id="position" style="width:100%;" readonly="readonly" value="#position_name#"/>
                    </td>
                </tr>
                <tr>
                    <td width="100"><cf_get_lang_main no='162.Şirket'></td>
                    <td>
                        <input type="hidden" name="company_id" id="company_id" value="#COMPANY_ID#">
                        <input type="text" name="company" id="company" style="width:100%;" value="#COMPANY_NAME#" readonly="readonly">
                    </td>
                </tr>
                <tr>
                    <cfif isdefined("attributes.FORM_TYPE") and attributes.FORM_TYPE eq 3>
                        <td><cf_get_lang no='530.İşten Çıkış Tarihi'></td>
                        <td>
                            <input type="text" name="finish_date" id="finish_date" style="width:100%;" readonly="readonly" value="#dateformat(FINISH_DATE,dateformat_style)#" />
                        </td>
                    <cfelse>
                        <td><cf_get_lang no='864.İşe Başlama Tarihi'></td>
                        <td>
                            <input type="text" name="start_date" id="start_date" style="width:100%;" readonly="readonly" value="#dateformat(STARTDATE,dateformat_style)#" />
                        </td>
                    </cfif>
                </tr>
                <tr>
                    <td><cf_get_lang no='532.RCD Definition'></td>
                    <td>
                        <input type="text" name="rcd_definition" id="rcd_definition" style="width:100%;" value="#RCD_DEFINITION#" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome' and session.ep.userid eq get_inventory_demand.EMPLOYEE_ID> readonly="readonly"</cfif>>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='1070.Mobil Tel'></td>
                    <td>
                        <input type="text" name="mobile_code" id="mobile_code" onkeyup="isNumber(this)" maxlength="3" style="width:45px; float:left; " value="#MOBILE_CODE#" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                        <input type="text" name="mobile_tel" id="mobile_tel" onkeyup="isNumber(this)" maxlength="7" style="width:73%;" value="#MOBILE_TEL#" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                    </td>
                    <cfif isdefined("attributes.FORM_TYPE") and attributes.FORM_TYPE eq 2>
                        <td>
                            <select name="reason_type" id="reason_type" style="width:90px;">
                                <option value=""><cf_get_lang no='560.Talep Nedeni'></option>
                                <cfoutput query="get_demand_reason">
                                    <option value="#reason_id#">#reason#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </cfif>
                </tr>
                <tr>
                    <td><cf_get_lang no='554.Dahili Hat Tanımlaması'></td>
                    <td>
                        <input type="text" name="intercom" id="intercom" style="width:100%;" value="#INTERCOM#" onkeyup="isNumber(this)"<cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                    </td>
                </tr>
                <tr> 
                    <td><cf_get_lang no='556.Masa'></td>
                    <td>
                        <input type="text" name="emp_table" id="emp_table" style="width:100%;" value="#EMP_TABLE#" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome' and session.ep.userid eq get_inventory_demand.EMPLOYEE_ID> readonly="readonly"</cfif>>
                    </td>
                </tr>
                </cfoutput>
                <cfif isdefined("attributes.form_type") and attributes.form_type eq 3>
                    <cfset row = 0 >
                        <cfloop query="get_inventory_demand_rows">
                            <cfset row = row + 1 >
                            <cfquery name="get_inventory_demand_rows2" datasource="#dsn#">
                                SELECT TOP 1
                                    IDR.*,
                                    SC.INVENTORY_CAT
                                FROM
                                    EMPLOYEES_INVENTORY_DEMAND ID LEFT JOIN EMPLOYEES_INVENTORY_DEMAND_ROWS IDR ON IDR.INVENTORY_DEMAND_ID = ID.INVENTORY_DEMAND_ID
                                    INNER JOIN SETUP_INVENTORY_CAT SC ON IDR.INVENTORY_CAT_ID =  SC.INVENTORY_CAT_ID
                                WHERE
                                    IDR.INVENTORY_CAT_ID = #get_inventory_demand_rows.INVENTORY_CAT_ID#
                                ORDER BY
                                    IDR.UPDATE_DATE DESC        
                            </cfquery>
                            <cfoutput>
                                <tr>
                                    <td>
                                        <input type="hidden" name="inventory_cat_id_#row#" id="inventory_cat_id_#row#" value="<cfoutput>#get_inventory_demand_rows2.INVENTORY_CAT_ID#</cfoutput>" />
                                        #get_inventory_demand_rows2.INVENTORY_CAT#
                                    </td>
                                    <td>
                                        <input type="text" name="inventory_cat_value_#row#" id="inventory_cat_value_#row#" style="width:100%;" value="#get_inventory_demand_rows2.INVENTORY_VALUE#" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                                    </td>
                                    <td>
                                        <input type="text" name="inventory_request_#row#" id="inventory_request_#row#" placeholder="Request form number" style="width:91%;" value="#get_inventory_demand_rows2.REQUEST_NUMBER#" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap'> readonly="readonly"</cfif>>
                                    </td>
                                </tr>
                            </cfoutput>
                        </cfloop>
                        <input type="hidden" name="inventory_cat_id_count" id="inventory_cat_id_count" value="<cfoutput>#row#</cfoutput>" />
                    </table>
          	<cfelse>
                    <cfquery name="get_inventory_cat" datasource="#dsn#">
                        SELECT INVENTORY_CAT,INVENTORY_CAT_ID,UPPER_INVENTORY_CAT_ID,HIERARCHY,DEFINITION FROM SETUP_INVENTORY_CAT WHERE ACTIVE = 1 ORDER BY PRIORITY
                    </cfquery>
                    <cfquery name="get_upper_inventory_cat" dbtype="query">
                        SELECT INVENTORY_CAT,INVENTORY_CAT_ID,HIERARCHY,DEFINITION FROM get_inventory_cat WHERE UPPER_INVENTORY_CAT_ID IS NULL
                    </cfquery>
                    <cfif get_inventory_cat.recordcount>
                    	<cfoutput>
							<cfset rowspan = 0 >
                            <cfset row = 0 >
                            <cfset another_label_count = 0 >
                            <cfset sub_inventory_cat_count = 0>
                            <cfset sub_inventory_cat = 0>
                            <cfloop query="get_upper_inventory_cat">
                                <cfset start_row = row + 1 >
                                    <tr>
                                        <cfquery name="get_sub_inventory_cat" dbtype="query">
                                            SELECT INVENTORY_CAT,INVENTORY_CAT_ID,HIERARCHY,DEFINITION FROM get_inventory_cat WHERE HIERARCHY LIKE '%#get_upper_inventory_cat.INVENTORY_CAT_ID#.%'
                                        </cfquery>
                                        <cfset rowspan = get_sub_inventory_cat.recordcount>
                                        <td valign="top" rowspan="#rowspan#"><label id="another_cat_label_#currentrow#">#INVENTORY_CAT#</label></td>
                                        <cfset another_label_count = another_label_count + 1>
                                        <cfif get_sub_inventory_cat.recordcount>
                                            <cfset another_label_count = another_label_count - 1>
                                            <cfloop query="get_sub_inventory_cat">
                                                <cfset row = row + 1>
                                                    <td colspan="1">	
                                                        <label id="inventory_cat_label_#row#"><input type="checkbox" name="inventory_cat_id_#row#" id="inventory_cat_id_#row#" value="#get_sub_inventory_cat.INVENTORY_CAT_ID#" <cfif listfind(get_inventory_demand.INVENTORY_CAT_ID_LIST,get_sub_inventory_cat.INVENTORY_CAT_ID,',')> checked </cfif> <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or (listgetat(attributes.fuseaction,1,'.') eq 'myhome' and session.ep.position_code neq get_inventory_demand.UPPER_POSITION_CODE)>hidden</cfif>>#INVENTORY_CAT#</label>
                                                    </td>
                                                    <cfif isdefined("get_sub_inventory_cat.DEFINITION") and len(get_sub_inventory_cat.DEFINITION) and get_sub_inventory_cat.DEFINITION eq 1>
                                                        <td>
                                                            <input type="text" name="inventory_cat_value_#row#" id="inventory_cat_value_#row#" style="width:91%;" value="<cfif listfind(get_inventory_demand.INVENTORY_CAT_ID_LIST,get_sub_inventory_cat.INVENTORY_CAT_ID,',')>#trim(listgetat(get_inventory_demand.INVENTORY_VALUE_LIST,listfind(get_inventory_demand.INVENTORY_CAT_ID_LIST,get_sub_inventory_cat.INVENTORY_CAT_ID,',')))#</cfif>" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                                                        </td> 
                                                    </cfif>
                                                </tr>
                                            <cfset sub_inventory_cat = get_sub_inventory_cat.recordcount>
                                          </cfloop>
                                            <tr>
                                                <td></td>
                                                <td><label><input type="checkbox" name="none_" id="none_#currentrow#" value="" onclick="uncheck(#start_row#,#row#);" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or (listgetat(attributes.fuseaction,1,'.') eq 'myhome' and session.ep.position_code neq get_inventory_demand.UPPER_POSITION_CODE)>hidden</cfif>><cf_get_lang no='561.Hiçbiri'></label></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">&nbsp;</td>
                                            </tr>
                                        <cfelse>
                                                 <td>
                                                    <input type="checkbox"  style="float:left;" name="another_cat_id_#currentrow#" id="another_cat_id_#currentrow#" value="#get_upper_inventory_cat.INVENTORY_CAT_ID#" <cfif listfind(get_inventory_demand.INVENTORY_CAT_ID_LIST,get_upper_inventory_cat.INVENTORY_CAT_ID,',')> checked </cfif> <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or (listgetat(attributes.fuseaction,1,'.') eq 'myhome' and session.ep.position_code neq get_inventory_demand.UPPER_POSITION_CODE)>hidden</cfif>>
                                                    <cfif isdefined("get_upper_inventory_cat.DEFINITION") and len(get_upper_inventory_cat.DEFINITION) and get_upper_inventory_cat.DEFINITION eq 1>
                                                        <input type="text" name="another_value_#currentrow#" id="another_value_#currentrow#" style="width:92%;" value="<cfif listfind(get_inventory_demand.INVENTORY_CAT_ID_LIST,get_upper_inventory_cat.INVENTORY_CAT_ID,',')>#trim(listgetat(get_inventory_demand.INVENTORY_VALUE_LIST,listfind(get_inventory_demand.INVENTORY_CAT_ID_LIST,get_upper_inventory_cat.INVENTORY_CAT_ID,',')))#</cfif>" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                                                    </cfif>
                                                </td>
                                            </tr>
                                        </cfif>
                                <cfset sub_inventory_cat_count = sub_inventory_cat_count +sub_inventory_cat>
                            </cfloop>
                            <input type="hidden" name="inventory_cat_id_count" id="inventory_cat_id_count" value="#sub_inventory_cat_count#" />
                            <input type="hidden" name="another_cat_id_count" id="another_cat_id_count" value="#get_upper_inventory_cat.recordcount#" />
                            <input type="hidden" name="another_label_count" id="another_label_count" value="#another_label_count#" />
               			</cfoutput>
                    </cfif>
                    </table>
                <cfif get_inventory_demand.form_type eq 2>
                    <table>
                        <tr>
                            <td style="width:165px;"><cf_get_lang no='560.Talep Nedeni'>
                                <cfif len(get_inventory_demand.reason_type)>
                                    <select name="reason_type" id="reason_type" style="width:90px; float:right;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_demand_reason">
                                            <option value="#reason_id#" <cfif isdefined("get_inventory_demand.reason_type") and get_inventory_demand.reason_type eq get_demand_reason.reason_id>selected</cfif>>#reason#</option>
                                        </cfoutput>
                                    </select>
                                    </td>
                                <cfelse>
                                    </td>                  
                                    <td>
                                        <textarea rows="3" type="text" name="definition" id="definition" readonly="readonly"><cfoutput>#get_inventory_demand.REASON_DEFINITION#</cfoutput></textarea>
                                    </td>
                                </cfif>
                        </tr>               
                    </table>
                </cfif>
            </cfif>
        <cf_popup_box_footer>
            <cf_record_info query_name="get_inventory_demand">
            	<cfif fusebox.circuit neq 'myhome' or (fusebox.circuit eq 'myhome' and (not len(get_inventory_demand.manager_valid_date) or (len(get_inventory_demand.manager_valid_date) and len(get_inventory_demand.it_valid_date) and not len(get_inventory_demand.employee_valid_date))))>
            		<cfif fusebox.circuit eq 'ehesap'>
                       <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_inventory_demand&inventory_demand_id=#inventory_demand_id#' add_function='check()'>
                    <cfelse>
                    	<cf_workcube_buttons is_upd='1' is_delete='0' add_function='check()'>
                    </cfif>
                </cfif>
        </cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
	function uncheck(start,end)
	{ 
		for (i=start; i<=end; i++)
		{
			if($('#inventory_cat_id_'+i).attr('disabled')) {
				$('#inventory_cat_id_'+i).prop('disabled', false);
				$('#inventory_cat_value_'+i).prop('disabled', false);
			} else {
				$('#inventory_cat_id_'+i).prop('checked', false);
				$('#inventory_cat_id_'+i).prop('disabled', true);
				$('#inventory_cat_value_'+i).prop('disabled', true);
				$('#inventory_cat_value_'+ i).val('');
			}
		}
	}
	
	function check()
	{	
		var count = $("input[name^='inventory_cat_id']:checked").length;
		var count2 = $("input[name^='another_cat_id_']:checked").length;
		var total = count + count2;
		if(document.getElementById('form_type').value != 3)
		{
			if(total == 0)
			{
				alert("Lütfen Envanter Seçiniz.");
				return false;
			}
		}
		if(document.getElementById('form_type').value == 2 && total > 1)
		{
			alert("Sadece Bir Envanter Seçebilirsiniz.");
			return false;
		}
		<cfif fusebox.circuit neq 'myhome'>
			if(document.getElementById('form_type').value != 3)
			{
				var inventory_cat_id_count = $('#inventory_cat_id_count').val();
				var another_label_count = $('#another_label_count').val();
				for (i=1; i<=another_label_count; i++){
					
					if(document.getElementById('another_cat_id_'+ i).checked == true && document.getElementById('another_value_'+ i).value == '') 
					{
						alert(document.getElementById('another_cat_label_'+ i).textContent + ' alanı boş bırakılamaz.');
						return false;
					}
					if(document.getElementById('another_cat_id_'+ i).checked == false &&  document.getElementById('another_value_'+ i).value != '') 
					{
						alert(document.getElementById('another_cat_label_'+ i).textContent + ' checkboxını işaretleyiniz.');
						return false;
					}
				}
				for (i=1; i<=inventory_cat_id_count; i++){
					if(document.getElementById('inventory_cat_id_'+ i).checked == true && document.getElementById('inventory_cat_value_'+ i).value == '') 
					{
						alert(document.getElementById('inventory_cat_label_'+ i).textContent + ' alanı boş bırakılamaz.');
						return false;
					}
				 
					if(document.getElementById('inventory_cat_id_'+ i).checked == false && document.getElementById('inventory_cat_value_'+ i).value != '') 
					{
						alert(document.getElementById('inventory_cat_label_'+ i).textContent + ' checkboxını işaretleyiniz.');
						return false;
					}
				}
			}
		</cfif>
		return process_cat_control();
	}
</script>
