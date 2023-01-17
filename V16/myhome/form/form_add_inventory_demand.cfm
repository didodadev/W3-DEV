<cf_get_lang_set module_name="myhome">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='59988.Envanter Talep Formu'></cfsavecontent>
<cf_popup_box title="#message#">
<cfif isdefined("attributes.form_type") and attributes.form_type eq 3>
	<cfscript>
        get_demands = createObject("component","V16.myhome.cfc.get_inventory_demands_row");
        get_demands.dsn = dsn;
        get_inventory_demand = get_demands.inventory_demands
                        (
                            employee_id : attributes.employee_id
                        );
    </cfscript>
    <cfquery name="get_finish_date" datasource="#DSN#">
		SELECT FINISH_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID =  #get_inventory_demand.EMPLOYEE_ID# AND VALID = 1
  	</cfquery>
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
      	GROUP BY
            IDR.INVENTORY_CAT_ID        
    </cfquery>
<cfelse>
    <cfquery name="get_inventory_demand" datasource="#DSN#">
        SELECT
            E.EMPLOYEE_ID,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_NAME, 
            E.GROUP_STARTDATE AS STARTDATE,
            EP.UPPER_POSITION_CODE,
            EP.POSITION_ID,
            EP.POSITION_NAME,
            EP2.EMPLOYEE_NAME +' '+ EP2.EMPLOYEE_SURNAME AS MANAGER_NAME_SURNAME,
            D.BRANCH_ID,
            D.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            B.BRANCH_NAME,
            B.COMPANY_ID,
            OC.COMP_ID,
            OC.COMPANY_NAME
            <cfif isdefined("attributes.form_type") and len(attributes.form_type) and attributes.form_type eq 2>
                ,EI.*
            </cfif>
        FROM 
            EMPLOYEES E INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = EP.UPPER_POSITION_CODE
            INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
            INNER JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
            INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
            <cfif isdefined("attributes.form_type") and len(attributes.form_type) and attributes.form_type eq 2>
                INNER JOIN EMPLOYEES_INVENTORY_DEMAND EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
            </cfif>
        WHERE 
            E.EMPLOYEE_ID = #attributes.employee_id# 
        <cfif isdefined("attributes.form_type") and len(attributes.form_type) and attributes.form_type eq 2>
            ORDER BY 
                EI.RECORD_DATE DESC
        </cfif>
    </cfquery>
    <!---<cfscript>
        get_demands = createObject("component","V16.myhome.cfc.get_inventory_demands");
        get_demands.dsn = dsn;
        get_inventory_demand = get_demands.inventory_demands
                        (
                            employee_id : attributes.employee_id
                        );
    </cfscript>--->
</cfif>
<cfif isdefined("attributes.form_type") and attributes.form_type eq 2 and get_inventory_demand.recordcount eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='59987.Kayıtlı Formunuz Bulunmadığından Dolayı Güncelleme Talebinde Bulunamazsınız'>!");
		window.close();
	</script>
    <cfabort>
</cfif>
<cfform name="inventory_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_inventory_demand" method="post">
    <table border="0" cellpadding="1" cellspacing="1">
    		<input type="hidden" name="MANAGER_VALID" id="MANAGER_VALID" value="">
            <input type="hidden" name="IT_VALID_DATE" id="IT_VALID" value="">
            <input type="hidden" name="EMPLOYEE_VALID" id="EMPLOYEE_VALID" value="">
        <tr>
            <td style="width:150px;">
            <cf_get_lang dictionary_id='31759.Form Tipi'> 
                <select name="form_type" id="form_type" style="width:90px; float: right;" >
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <option value="1" <cfif isdefined("attributes.form_type") and attributes.form_type eq 1> selected</cfif>><cf_get_lang dictionary_id='31274.İşe Giriş'></option>
                    <option value="2" <cfif isdefined("attributes.form_type") and attributes.form_type eq 2> selected</cfif>><cf_get_lang dictionary_id='57703.Güncelleme'></option>
                    <option value="3" <cfif isdefined("attributes.form_type") and attributes.form_type eq 3> selected</cfif>><cf_get_lang dictionary_id='29832.İşten Çıkış'></option>
                </select>
            </td>
        	<td style="width:30px;"><cf_get_lang dictionary_id ='58859.Süreç'></td>
            <td></td>
			<td><cf_workcube_process is_upd='0' process_cat_width='82' is_detail='0'></td>
       	</tr>
  	</table>
	<table border="0" cellpadding="1" cellspacing="1">
        <cfoutput>
            <tr>
                <td><cf_get_lang dictionary_id='57576.Calışan'></td>
                <td>
                    <input type="hidden" name="employee_id" id="employee_id" value="#get_inventory_demand.EMPLOYEE_ID#">
                    <input name="emp_name" type="text" id="emp_name" style="width:100%;" readonly="readonly" value="#get_inventory_demand.EMPLOYEE_NAME#">
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='29511.Yönetici'></td>
                <td>
                    <input type="hidden" name="upper_position_code" id="upper_position_code" value="#get_inventory_demand.upper_position_code#">
                    <input type="text" name="upper_position" id="upper_position" value="#get_inventory_demand.MANAGER_NAME_SURNAME#" style="width:100%;" readonly="readonly">
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='30031.Lokasyon'></td>
                <td>
                    <input type="hidden" name="dept_id" id="dept_id" value="#get_inventory_demand.department_id#">
                    <input type="hidden" name="branch_id" id="branch_id" value="#get_inventory_demand.branch_id#">
                    <input type="text" name="branch" id="branch" value="#get_inventory_demand.branch_name#" style="width:100%;" readonly="readonly">
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58497.Pozisyon'></td>
                <td>
                    <input type="hidden" name="position_id" id="position_id" value="#get_inventory_demand.position_id#">
                    <input type="text" name="position" id="position" style="width:100%;" readonly="readonly" value="#get_inventory_demand.position_name#">
                </td>
            </tr>
            <tr>
                <td width="100"><cf_get_lang dictionary_id='57574.Şirket'></td>
                <td>
                    <input type="hidden" name="company_id" id="company_id" value="#get_inventory_demand.COMPANY_ID#">
                    <input type="text" name="company" id="company" style="width:100%;" value="#get_inventory_demand.COMPANY_NAME#" readonly="readonly">
                </td>
            </tr>
            <tr>
				<cfif isdefined("attributes.FORM_TYPE") and attributes.FORM_TYPE eq 3>
                    <td><cf_get_lang dictionary_id='31287.İşten Çıkış Tarihi'></td>
                    <td>
                        <input type="text" name="finish_date" id="finish_date" style="width:100%;" readonly="readonly" value="<cfif len(get_finish_date.FINISH_DATE)>#dateformat(get_finish_date.FINISH_DATE,dateformat_style)#</cfif>" />
                    	<input type="hidden" name="start_date" id="start_date" style="width:65px;" value="#dateformat(get_inventory_demand.STARTDATE,dateformat_style)#">                   
                    </td>
               	<cfelse>
                    <td><cf_get_lang dictionary_id='31622.İşe Başlama Tarihi'></td>
                    <td>
                        <input type="text" name="start_date" id="start_date" style="width:65px;" value="#dateformat(get_inventory_demand.STARTDATE,dateformat_style)#" readonly="readonly">                   
                    </td>
              	</cfif>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='31289.RCD Definition'></td>
                <td>
                    <input type="text" name="rcd_definition" id="rcd_definition" style="width:100%;" value="<cfif isdefined("get_inventory_demand.RCD_DEFINITION") and len(get_inventory_demand.RCD_DEFINITION)>#get_inventory_demand.RCD_DEFINITION#</cfif>" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='58482.Mobil Tel'></td>
                <td>
                    <input type="text" name="mobile_code" id="mobile_code" onkeyup="isNumber(this)" style="width:45px; float:left" value="<cfif isdefined("get_inventory_demand.MOBILE_CODE") and len(get_inventory_demand.MOBILE_CODE)>#get_inventory_demand.MOBILE_CODE#</cfif>" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                    <input type="text" name="mobile_tel" id="mobile_tel" onkeyup="isNumber(this)" style="width:73%;" value="<cfif isdefined("get_inventory_demand.MOBILE_TEL") and len(get_inventory_demand.MOBILE_TEL)>#get_inventory_demand.MOBILE_TEL#</cfif>" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id='31311.Dahili Hat Tanımlaması'></td>
                <td>
                    <input type="text" name="intercom" id="intercom" style="width:100%;" value="<cfif isdefined("get_inventory_demand.INTERCOM") and len(get_inventory_demand.INTERCOM)>#get_inventory_demand.INTERCOM#</cfif>" onkeyup="isNumber(this)"<cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
                </td>
            </tr>
            <tr> 
                <td><cf_get_lang dictionary_id='31313.Masa'></td>
                <td>
                    <input type="text" name="emp_table" id="emp_table" style="width:100%;" value="<cfif isdefined("get_inventory_demand.EMP_TABLE") and len(get_inventory_demand.EMP_TABLE)>#get_inventory_demand.EMP_TABLE#</cfif>" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap' or listgetat(attributes.fuseaction,1,'.') eq 'myhome'> readonly="readonly"</cfif>>
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
                                            <td colspan="2">
                                                <label id="inventory_cat_label_#row#"><input type="checkbox" name="inventory_cat_id_#row#" id="inventory_cat_id_#row#" value="#get_sub_inventory_cat.INVENTORY_CAT_ID#" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap'>hidden</cfif>>#INVENTORY_CAT#</label>
                                            </td>
                                            <cfif isdefined("get_sub_inventory_cat.DEFINITION") and len(get_sub_inventory_cat.DEFINITION) and get_sub_inventory_cat.DEFINITION eq 1>
                                                <td>
                                                    <input type="text" name="inventory_cat_value_#row#" id="inventory_cat_value_#row#" style="width:91%;" value="" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap'> readonly="readonly"</cfif>>
                                                </td>
                                            </cfif>
                                        </tr>
                                        <cfset sub_inventory_cat = get_sub_inventory_cat.recordcount>
                                        <tr>
                                    </cfloop>
                                        <td></td>
                                        <td><label><input type="checkbox" name="none_" id="none_" value="" onclick="uncheck(#start_row#,#row#);" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap'>hidden</cfif>> <cf_get_lang dictionary_id='31318.Hiçbiri'></label></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">&nbsp;</td>
                                    </tr>
                                <cfelse>
                                    <td>
                                        <input type="checkbox" style="float:left;" name="another_cat_id_#currentrow#" id="another_cat_id_#currentrow#" value="#get_upper_inventory_cat.INVENTORY_CAT_ID#" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap'>hidden</cfif>>
                                        <cfif isdefined("get_upper_inventory_cat.DEFINITION") and len(get_upper_inventory_cat.DEFINITION) and get_upper_inventory_cat.DEFINITION eq 1>
                                            <input type="text" name="another_value_#currentrow#" id="another_value_#currentrow#" style="width:91%;" value="" <cfif listgetat(attributes.fuseaction,1,'.') eq 'ehesap'> readonly="readonly"</cfif>>
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
    		<cfif isdefined("attributes.form_type") and attributes.form_type eq 2 and get_inventory_demand.EMPLOYEE_ID eq session.ep.userid>
                <table>
                    <tr>
                        <td style="width:165px;"><cf_get_lang dictionary_id='31317.Talep Nedeni'>
                            <cfquery name="get_reason" datasource="#DSN#">
                                SELECT REASON_ID, REASON FROM SETUP_INVENTORY_DEMAND_REASON WHERE ACTIVE = 1
                            </cfquery>
                            <select name="reason_type" id="reason_type" style="width:90px; float:right;" onchange="changeFunc();">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_reason">
                                    <option value="#reason_id#" <cfif isdefined("attributes.reason_type") and attributes.reason_type eq reason_id>selected</cfif>>#reason#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td><cf_get_lang dictionary_id='58156.Diğer'> &nbsp;<input type="checkbox" id="other_reason" name="other_reason" value="" onclick="enable();"/></td>
                       
                        <td id="desc" style="display:none"><textarea rows="3" type="text" name="definition" id="definition"></textarea></td>
                    </tr>               
                </table>
   			</cfif>
		</cfif>
    <cf_popup_box_footer>
    	<cf_workcube_buttons is_upd='0' type_format='1' add_function='control()'>
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
function enable()
{
	if (document.inventory_demand.other_reason.checked == true){
		desc.style.display = '';
	}else{
		desc.style.display = 'none';
	}
}
function changeFunc()
{
	if($('#reason_type').val() === '') {
		$('#other_reason').prop('disabled', false);
		desc.style.display = '';
	}else{
		$('#other_reason').prop('disabled', true);
		desc.style.display = 'none';
	}
}
function control()
{	
	if(document.getElementById('form_type').value == "")
	{
		alert("<cf_get_lang dictionary_id='59989.Form tipini seçiniz'>");
		return false;
	}
	
	if(document.getElementById('form_type').value != 3)
	{
		if(document.getElementById('form_type').value == 2)
		{
			var count = $("input[name^='inventory_cat_id']:checked").length;
			var count2 = $("input[name^='another_cat_id_']:checked").length;
			var total = count + count2;
			if(total == 0)
			{
				alert("<cf_get_lang dictionary_id='59990.Lütfen Talepte Bulunmak İçin Bir Tane Envanter Seçiniz'>.");
				return false;
			}else if(total > 1){
				alert("<cf_get_lang dictionary_id='59991.Sadece Bir Envanter Seçebilirsiniz'>.");
				return false;
			}
			if(document.getElementById('reason_type').value == "" && document.inventory_demand.other_reason.checked == false)
			{		
				alert("<cf_get_lang dictionary_id='59992.Talep Nedenini Seçiniz'>");
				return false;
			}
			if (document.getElementById('reason_type').value != "" && document.inventory_demand.other_reason.checked == true)
			{
				alert("<cf_get_lang dictionary_id='59993.Talep Nedeni ve Diğer Seçeneklerinden Yalnızca Birini Seçebilirsiniz'>.");
				return false;
			}
			if(document.inventory_demand.other_reason.checked == true && document.inventory_demand.definition.value == '') 
			{
				alert("<cf_get_lang dictionary_id='59994.Talep Nedeni İçin Açıklama Alanını Doldurunuz'>.");
				return false;
			}
		}
		
		var count2 = document.getElementById('inventory_cat_id_count').value;
		var another_label_count = document.getElementById('another_label_count').value;
		
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
		
		for (i=1; i<=count2; i++){ 
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
	return process_cat_control();
}	
</script>
