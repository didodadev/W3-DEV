<cfparam name="attributes.empId" default="">
<cfparam name="attributes.empName" default="">
<form name="listUserGroup" action="" method="post">
    <div class="row">
        <div class="form-group pull-right">    
            <label>
            	<cfoutput>
                    <input type="hidden" name="empId" id="empId" value="<cfif len(attributes.empId)><cfoutput>#attributes.empId#</cfoutput></cfif>">
                    <input type="text" name="empName" id="empName" readonly="readonly" value="<cfif len(attributes.empName)><cfoutput>#attributes.empName#</cfoutput></cfif>"><!---onfocus="AutoComplete_Create('empName','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','empId','form','3','135')" value="<cfif len(attributes.empName)>#attributes.empName#</cfif>" autocomplete="off"--->
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=listUserGroup.empName&field_emp_id=listUserGroup.empId&select_list=1,9','list');return false"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>
                </cfoutput>
            </label>
            <cf_wrk_search_button search_function="kontrolUserGroupList(this)">
        </div>
    </div>
</form>
<cfif len(attributes.empId) and len(attributes.empName)>
	<cf_big_list>
    	<thead>
        	<tr>
            	<th>#</th>
            	<th><cf_get_lang dictionary_id="57576.Çalışan"></th>
            	<th><cf_get_lang dictionary_id="30350.Yetki Grubu"></th>
            </tr>
        </thead>
        <tbody>
			<cfoutput query="GET_USER_GROUP_MEMBER">
                <tr>
                    <td>#currentrow#</td>
                    <td>#USER_INFO#</td>
                    <td>#User_group_name#</td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_big_list>
</cfif>