<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.tmarket_id" default="">
<cfif isdefined("attributes.form_varmi")>
    <cfloop from="1" to="#attributes.record_num#" index="i">
        <cfquery name="GET_WORKER" datasource="#DSN3#">
            INSERT INTO
                TARGET_AUDIENCE_RECORD
                    (
                        OTHER_RECORD,
                        TMARKET_ID,
                        COMPANY_ID,
                        CONSUMER_ID,
                        PARTNER_ID,
                        CALL_STATUS
                    )
                VALUES
                    (
                        0,
                        <cfif isdefined("attributes.tmarket_id") and len(attributes.tmarket_id)>#attributes.tmarket_id#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.company_id#i#") and len(evaluate('attributes.company_id#i#'))>#evaluate('attributes.company_id#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.consumer_id#i#") and len(evaluate('attributes.consumer_id#i#'))>#evaluate('attributes.consumer_id#i#')#<cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.partner_id#i#") and len(evaluate('attributes.partner_id#i#'))>#evaluate('attributes.partner_id#i#')#<cfelse>NULL</cfif>,
                        1
                    )
        </cfquery>
    </cfloop>
    <script type="text/javascript">
          window.location.href = '<cfoutput>#request.self#?fuseaction=campaign.list_target_list_extra&tmarket_id=#attributes.tmarket_id#</cfoutput>';
    </script>
</cfif>
<cfsavecontent variable="title">
	<cfif len(attributes.company_id)>
        <cfoutput>#getLang('member',61)#</cfoutput>
    <cfelseif len(attributes.consumer_id)>
    	<cfoutput>#getLang('member',426)#</cfoutput>
	<cfelse>
    	
    </cfif>
</cfsavecontent><cfsavecontent variable="message"><cf_get_lang dictionary_id='31915.Add Target Group'></cfsavecontent>
<cf_box title="#message#" popup_box="1">
    <cfform name="worker" method="post" action="#request.self#?fuseaction=objects.popup_form_add_worker">
    <input type="hidden" name="tmarket_id" id="tmarket_id" value="<cfoutput>#attributes.tmarket_id#</cfoutput>">
    <input type="hidden" name="row_kontrol1" id="row_kontrol1" value="1">
    <input type="hidden" name="form_varmi" id="form_varmi" value="1" />
    <input type="hidden"  name="record_num" id="record_num" value="1" />
    <input type="hidden"  name="frm_row1" id="frm_row1" value="1" />
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
    <cf_grid_list>
        <thead>
            <tr>
                <th style="width:30px;">
                    <input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();">
                </th>
                <th><cf_get_lang dictionary_id='57658.Üye'>*</th>
            </tr>
        </thead>
        <tbody name="table1" id="table1">
            <tr>
                <td nowrap><a style="cursor:pointer" onClick="sil(1);"><img  src="/images/delete_list.gif" border="0" align="absmiddle"></a></td>
                <input type="hidden" name="partner_id1" id="partner_id1" value="">
                <input type="hidden" name="employee_id1" id="employee_id1" value="">
                <input type="hidden" name="position_code1" id="position_code1" value="">
                <input type="hidden" name="company_id1" id="company_id1" value="" />
                <input type="hidden" name="objects_emp_id" id="objects_emp_id" value="#GET_WORKER.objects_emp_id#">
                <td><input type="text" style="width:250px" name="emp_par_name1" id="emp_par_name1" value=""> <a href="javascript://" onClick="pencere_ac1(1);" style="cursor:pointer;">&nbsp;<img src="/images/plus_thin.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id='57785.Uye Secmelisiniz'>"></a></td><!--- onFocus="AutoComplete_Create('emp_par_name1','consumer_name','consumer_name','get_member_autocomplete','\'3\',0,0,0',',EMPLOYEE_ID','objects_emp_id','list_works','3','250');"--->
            </tr>
        </tbody>
    </cf_grid_list>
    <cf_box_footer>
    	<cf_workcube_buttons is_insert="1">
    </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	
	row_count=1;
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><img src="/images/delete_list.gif" align="absmiddle" border="0" alt="<cf_get_lang dictionary_id ='57463.sil'>"></a>';							

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="partner_id'+ row_count +'" id="partner_id'+ row_count +'" value=""> <input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value=""> <input type="hidden" name="employee_id'+ row_count +'" id="employee_id'+ row_count +'" value=""> <input type="hidden" name="position_code'+ row_count +'" id="position_code'+ row_count +'" value=""><input type="text"  name="emp_par_name'+ row_count +'" id="emp_par_name'+ row_count +'" value="" readonly="yes" style="width:250px;">&nbsp;<a href="javascript://" onClick="pencere_ac1('+ row_count +');" style="cursor:pointer;">&nbsp;<img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="<cf_get_lang dictionary_id="57785.Uye Secmelisiniz">"></a>';
		
	}
	function sil(sy)
	{
		var my_element=eval("worker.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
	function pencere_ac1(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=worker.position_code'+ no +'&field_name=worker.emp_par_name'+ no +'&field_emp_id=worker.employee_id'+ no +'&field_comp_id=worker.company_id'+ no +'&field_partner=worker.partner_id' + no + '&select_list=1,7');
	}
</script>
