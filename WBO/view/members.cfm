<cfset members = CreateObject('component','cfc.members')>
<cfset component = createObject("component", "WBO.model.userGroup")>
<cfset memberInfo = members.userGroupMembers('#attributes.user_group_id#','#dsn#')>
<cfif isdefined("attributes.action") and attributes.action is 'upd'>	
	<cfquery name="UPDATE_E_P" datasource="#dsn#">
    	<cfif len(attributes.positionIdList)>
            UPDATE EMPLOYEE_POSITIONS SET USER_GROUP_ID = #attributes.user_group_ID# WHERE POSITION_ID IN (#attributes.positionIdList#)
            DELETE FROM USER_GROUP_EMPLOYEE WHERE USER_GROUP_ID = #attributes.user_group_ID#
			INSERT INTO USER_GROUP_EMPLOYEE (EMPLOYEE_ID,POSITION_ID,USER_GROUP_ID,RECORD_EMP,RECORD_DATE,RECORD_IP,UPDATE_EMP,UPDATE_DATE,UPDATE_IP) VALUES
            <cfloop index="ind" from="1" to="#listlen(attributes.positionIdList,',')#">
				(#listgetat(attributes.employeeList,ind,',')#,#listgetat(attributes.positionIdList,ind,',')#,#attributes.user_group_ID#,#session.ep.userid#,#now()#,'#cgi.remote_addr#',#session.ep.userid#,#now()#,'#cgi.remote_addr#')<cfif ind neq listlen(attributes.positionIdList,',')>,</cfif>				
			</cfloop>
		<cfelse>
        	DELETE FROM USER_GROUP_EMPLOYEE WHERE USER_GROUP_ID = #attributes.user_group_ID#
        </cfif>
	</cfquery>
	<cfif len(attributes.delEmployeePosList)>
		<cfloop list="#attributes.delEmployeePosList#" index="cc">
			<cfquery name="get_default_group" datasource="#dsn#">
				SELECT
					USER_GROUP_EMPLOYEE.USER_GROUP_ID ,IS_DEFAULT
				FROM 
					USER_GROUP_EMPLOYEE 
					LEFT JOIN USER_GROUP ON USER_GROUP_EMPLOYEE.USER_GROUP_ID = USER_GROUP.USER_GROUP_ID
					WHERE
						USER_GROUP_EMPLOYEE.POSITION_ID = #CC#
				UNION ALL
				SELECT 
					USER_GROUP_ID,IS_DEFAULT 
				FROM 
					USER_GROUP
				WHERE
				IS_DEFAULT = 1
				ORDER BY IS_DEFAULT DESC
			</cfquery>
			<cfquery name="upd_default_group" datasource="#dsn#">
				UPDATE EMPLOYEE_POSITIONS SET USER_GROUP_ID = #get_default_group.USER_GROUP_ID# WHERE POSITION_ID = #CC#
			</cfquery>

		</cfloop>
	</cfif>
	<cf_wrk_get_history datasource="#dsn#" source_table="USER_GROUP_EMPLOYEE" target_table="USER_GROUP_EMPLOYEE_HISTORY" record_id= "#attributes.user_group_ID#" record_name="USER_GROUP_ID">

	<cfset attributes.spa = 1>

	<script type="text/javascript">
        window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_user_group";
    </script>
</cfif>
<div id="membersHiddenDiv" style="display:none"></div>
	<cfform name="members" method="post" action="#request.self#?fuseaction=objects.members&action=upd&spa=1&ajax_box_page=1">
		<input type="hidden" name="employeeList" id="employeeList" value="" />
		<input type="hidden" name="positionIdList" id="positionIdList" value="" />
		<input type="hidden" name="delEmployeePosList" id="delEmployeePosList" value="" />
		<input type="hidden" name="user_group_ID" id="user_group_ID" value="<cfoutput>#attributes.user_group_ID#</cfoutput>" />
		<cf_box_elements>
			<cf_grid_list>
				<thead>
					<th width="35"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_members</cfoutput>','list');return false"><i class="fa fa-plus"></i></a></th>
					<th width="20"><cf_get_lang dictionary_id='58577.Line'></th>
					<th width="150"><cf_get_lang_main dictionary_id='57576.Çalışan'></th>
					<th><cf_get_lang_main dictionary_id='58497.Pozisyon'></th>
				</thead> 
				<tbody id="maindiv">	
					<cfoutput query="memberInfo">
						<tr id="row#currentrow#">
							<td width="35"><a onclick="delEmployeeRow(#currentrow#);"><i class="fa fa-minus"></i></a></td>
							<td width="20" class="text-center">#currentrow#</td>
							<td>
								<div class="form-group"> <div class="input-group"><input type="hidden" class="control" name="control#currentrow#" id="control#currentrow#" value="1" />
								<input type="hidden" class="employeeId" name="employee_id_#currentrow#" id="employee_id_#currentrow#" value="#EMPLOYEE_ID#" />
								<input type="hidden" class="positionId" name="position_id_#currentrow#" id="position_id_#currentrow#" value="#POSITION_ID#" />
								<input type="text" name="employee_name_#currentrow#" id="employee_name_#currentrow#" value="#EMPLOYEE#" readonly="readonly"/>
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_members&single=1&rowNumber=#currentrow#','list');return false"></span></div></div>
							</td>
							<td id="divPositionInfo#currentrow#"> <div class="form-group">#POSITION_NAME#</div></td>
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
		</cf_box_elements>
		<cf_box_footer>
			<div class="col col-12 text-right">
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='checkEmployees()'>
			</div>
		</cf_box_footer>
	</cfform>
<script type="text/javascript">
var rowCount = '<cfoutput>#memberInfo.recordcount#</cfoutput>';
function addEmployeeRow(employeeInfo,row)
{
	//console.log(employeeInfo);
	if(row)
	{
		$("#employee_id_"+row).val(list_getat(employeeInfo,1,';'));
		$("#employee_name_"+row).val(list_getat(employeeInfo,2,';'));
		$("#divPositionInfo"+row).html(list_getat(employeeInfo,3,';'));
		$("#position_id_"+row).val(list_getat(employeeInfo,4,';'));
	}
	else
	{
		
		valuesArray = new Array();
		$("form[name=members] .positionId").map(function(i){
			valuesArray[i] = $(this).val();
		});

		if($("form[name=members] .positionId") == undefined || valuesArray.indexOf(list_getat(employeeInfo,4,';')) == -1 )
		{
			rowCount = parseFloat(rowCount) + 1;
			rowDiv = document.createElement('tr');
		
			$(rowDiv).prop('id','row'+rowCount);
			div1 = document.createElement('td');
			$(div1).prop('width','35');	
			$(div1).html('<a onclick="delEmployeeRow('+rowCount+');"><i class="fa fa-minus"></i></a>');
			div2 = document.createElement('td');
			$(div2).prop('width','20');	
			$(div2).prop('class','text-center');	
			$(div2).html(rowCount);
			div3 = document.createElement('td');
			$(div3).html('<div class="form-group"> <div class="input-group"><input type="hidden" class="control" name="control'+rowCount+'" id="control'+rowCount+'" value="1" /><input type="hidden" class="employeeId" name="employee_id_'+rowCount+'" id="employee_id_'+rowCount+'" value="'+list_getat(employeeInfo,1,';')+'" /><input type="hidden" class="positionId" name="position_id_'+rowCount+'" id="position_id_'+rowCount+'" value="'+list_getat(employeeInfo,4,';')+'" /><input type="text" name="employee_name_'+rowCount+'" id="employee_name_'+rowCount+'" value="'+list_getat(employeeInfo,2,';')+'" readonly="readonly"/> <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen(\'index.cfm?fuseaction=objects.popup_list_positions&field_name=employee_name_'+rowCount+'&field_emp_id=employee_id_'+rowCount+'&select_list=1,9\',\'list\');return false"></span></div></div>');
			div4 = document.createElement('td');
			div4.id = 'divPositionInfo'+rowCount;
			$(div4).html(list_getat(employeeInfo,3,';'));
			$(rowDiv).append(div1);
			$(rowDiv).append(div2);	
			$(rowDiv).append(div3);
			$(rowDiv).append(div4);
			$("#maindiv").append(rowDiv);
	
		}
	}
}

function delEmployeeRow(row)
{
	$("#row"+row).css('display','none');
	$("#control"+row).val(0);


	myEmp = $("#position_id_"+row).val();
	
	if(!$("#delEmployeePosList").val().length)
		$("#delEmployeePosList").val(myEmp);
	else
		$("#delEmployeePosList").val($("#delEmployeePosList").val()+','+myEmp);
}

function checkEmployees()
{	
	$(".employeeId").each(function( index ){
		if($(this).parent('div').children('.control').val() == 1)
		{
			if(!$("#employeeList").val().length)
				$("#employeeList").val($(this).val());
			else
				$("#employeeList").val($("#employeeList").val()+','+$(this).val());
		}
	});
	
	$(".positionId").each(function( index ){
		if($(this).parent('div').children('.control').val() == 1)
		{
			if(!$("#positionIdList").val().length)
				$("#positionIdList").val($(this).val());
			else
				$("#positionIdList").val($("#positionIdList").val()+','+$(this).val());
		}
	});
	//AjaxFormSubmit('members1','membersHiddenDiv','','','','','',1);
	// parametreler get ile url sonuna eklendiğinde uzun url yapısı oluştuğu için hataya düşüyor, bu yüzden parametreler post ile gönderildi.
	$.ajax({
		type: "POST",
		url: '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.members&action=upd&spa=1&ajax_box_page=1',
		data: $("form[name=members]").serialize(),
		success: function(response){
			$('#membersHiddenDiv').html(response);
		}
	  });
	return false;	
}
$(document).ajaxStart(function(){
	$('#membersHiddenDiv').html('<div id="divPageLoad"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></div>');
});

</script>
