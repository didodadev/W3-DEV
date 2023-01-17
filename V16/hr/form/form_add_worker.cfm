<cfquery name="CATEGORY" datasource="#dsn#">
    SELECT 
    	WORKGROUP_ID, 
        WORKGROUP_NAME, 
        GOAL, 
        ONLINE_HELP, 
        ONLINE_SALES, 
        COMPANY_ID, 
        PROJECT_ID, 
        OPP_ID, 
        STATUS, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        HIERARCHY, 
        WORKGROUP_TYPE_ID, 
        MANAGER_POSITION_CODE, 
        IS_ORG_VIEW, 
        MANAGER_ROLE_HEAD, 
        MANAGER_EMP_ID, 
        DEPARTMENT_ID, 
        BRANCH_ID, 
        OUR_COMPANY_ID, 
        HEADQUARTERS_ID, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        SUB_WORKGROUP, 
        SPONSOR_EMP_ID, 
        IS_BUDGET 
    FROM 
	    WORK_GROUP 
    WHERE 
    	WORKGROUP_ID=#URL.WORKGROUP_ID#
</cfquery>
<cfquery name="GET_ROL" datasource="#dsn#">
	SELECT 
		PROJECT_ROLES_ID, 
        PROJECT_ROLES, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
	FROM 
		SETUP_PROJECT_ROLES
	ORDER BY
		PROJECT_ROLES
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="58140.İş Grubu"></cfsavecontent>
<cf_popup_box title="#message# #category.workgroup_name#">
	<cfform action="#request.self#?fuseaction=hr.emptypopup_worker_add&workgroup_id=#url.workgroup_id#" method="post" name="worker">
    	<cf_medium_list>
        	<thead>
                <tr>
                    <th></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='55478.Rol'></th>
                </tr>
            </thead>
            <tbody>
                <cfloop index="i" from="1" to="10">
                    <tr>
                        <td></td>
                        <td width="185">
							<cfoutput>
                                <input type="hidden" name="POSITION_CODE#i#" id="POSITION_CODE#i#" value="">
                                <input type="hidden" name="PARTNER_ID#i#" id="PARTNER_ID#i#" value="">
                                <input type="text" name="emp_par_name#i#" id="emp_par_name#i#" value="" style="width:150px;">
                            </cfoutput> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=worker.PARTNER_ID#i#&field_code=worker.POSITION_CODE#i#&field_name=worker.emp_par_name#i#</cfoutput>','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> </td>
                        <td>
                        	<select name="get_rol<cfoutput>#i#</cfoutput>" id="get_rol<cfoutput>#i#</cfoutput>">
                                <option value="0"><cf_get_lang dictionary_id='55202.Rol Seçiniz'></option>
                                <cfif get_rol.recordcount>
                                  <cfoutput query="get_rol">
                                    <option value="#PROJECT_ROLES_ID#">#PROJECT_ROLES#</option>
                                  </cfoutput>
                                </cfif>
                        	</select>
                        </td>
                    </tr>
                </cfloop>
            </tbody>
        </cf_medium_list>
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'> </cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<!---<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr height="35" class="color-list">
          <td class="headbold">&nbsp;<cf_get_lang_main no='728.İş Grubu'> <cfoutput>#category.workgroup_name#</cfoutput></td>
        </tr>
        <tr class="color-row">
          <td valign="top">
            <table border="0">
              <tr class="txtboldblue" height="25">
                <td></td>
                <td><cf_get_lang_main no='164.Çalışan'></td>
                <td><cf_get_lang no='393.Rol'></td>
              </tr>
              <cfform action="#request.self#?fuseaction=hr.emptypopup_worker_add&workgroup_id=#url.workgroup_id#" method="post" name="worker">
                <cfloop index="i" from="1" to="10">
                  <tr>
                    <td></td>
                    <td width="185"> <cfoutput>
                        <input type="hidden" name="POSITION_CODE#i#" value="">
                        <input type="hidden" name="PARTNER_ID#i#" value="">
                        <input type="text" name="emp_par_name#i#" value="" style="width:150px;">
                      </cfoutput> <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=worker.PARTNER_ID#i#&field_code=worker.POSITION_CODE#i#&field_name=worker.emp_par_name#i#</cfoutput>','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> </td>
                    <td>
                      <select name="get_rol<cfoutput>#i#</cfoutput>">
                        <option value="0"><cf_get_lang no='117.Rol Seçiniz'></option>
                        <cfif get_rol.recordcount>
                          <cfoutput query="get_rol">
                            <option value="#PROJECT_ROLES_ID#">#PROJECT_ROLES#</option>
                          </cfoutput>
                        </cfif>
                      </select>
                    </td>
                  </tr>
                </cfloop>
                <tr>
                  <td style="text-align:right;" colspan="3" height="35">
					  <cf_workcube_buttons is_upd='0' add_function='kontrol()'> 
                  </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>--->
<script type="text/javascript">
  function kontrol(){
    for(i=1; i<=10; i++)
	  {
	    temp = eval('worker.POSITION_CODE'+i+'.value');
	  if (temp!= '' && temp!= 0)
	  {
		for(j=i+1; j<=10; j++)
		  {
		   if (temp == eval('worker.POSITION_CODE'+j+'.value'))
		     {
			 alert("<cf_get_lang dictionary_id='38675.Aynı kişiden birden fazla seçilmiş, kontrol ediniz'>");
			  return false;
			 }
		  }
		 } 
	  } 
   
   for(i=1; i<=10; i++)
	  {
	    temp = eval('worker.PARTNER_ID'+i+'.value');
	  if (temp!= '' && temp!= 0)
		{
		for(j=i+1; j<=10; j++)
		  {
		   if (temp == eval('worker.PARTNER_ID'+j+'.value'))
		     {
			 alert("<cf_get_lang dictionary_id='38675.Aynı kişiden birden fazla seçilmiş, kontrol ediniz'>");
			  return false;
			 }
		  } 
		}  
	  }  
    return true;
  }
</script>


