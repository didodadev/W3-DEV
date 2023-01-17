<cfinclude template="../query/get_workgroup_inf.cfm">
<table align="center" width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
	  <tr>
		<td valign="top">
    <cfloop query="GET_WORKGROUPS">
    <cfquery name="get_emps" datasource="#DSN#">
        SELECT 
            EMPLOYEE_POSITIONS.EMPLOYEE_ID,
            EMPLOYEE_POSITIONS.POSITION_CODE,
            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
            EMPLOYEE_POSITIONS.POSITION_NAME,
            WORKGROUP_EMP_PAR.HIERARCHY 
        FROM 
            EMPLOYEE_POSITIONS,
            WORKGROUP_EMP_PAR
        WHERE 
            EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
            EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
            EMPLOYEE_POSITIONS.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
            WORKGROUP_EMP_PAR.WORKGROUP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#workgroup_id#">
        ORDER BY 
            WORKGROUP_EMP_PAR.HIERARCHY
      </cfquery> 
        <table width="98%" align="center" cellpadding="2" cellspacing="2">
           <tr>
           <td width="25"><img src="/objects2/image/tavsiye.gif"  border="0"></td>
           <td class="formbold" height="25"><cfoutput>#WORKGROUP_NAME#</cfoutput></td>
           </tr>
          <cfif len(GOAL)>
           <tr>
            <td></td>
            <td class="txtbold">
                <cfoutput>#GOAL#</cfoutput><br/><br/>
            </td>
           </tr>
           </cfif>
            <cfoutput query="GET_EMPS">
            <tr> 
              <td></td>		
              <td>
              <cfif get_workcube_app_user(employee_id, 0).recordcount and isdefined("session_base.userid")>
                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_message&employee_id=#EMPLOYEE_ID#','small');"><img src="/images/onlineuser.gif" border="0" title="<cf_get_lang_main no='1899.Mesaj Gönder'>" align="absmiddle"></a>
              <cfelse>
                  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_nott&public=1&employee_id=#EMPLOYEE_ID#','small');"><img src="/objects2/image/ok.gif" border="0" title="<cf_get_lang no ='1140.Not Bırak'>" align="absmiddle"></a>
              </cfif>
              &nbsp;#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - (#POSITION_NAME#)</td>					 
            </tr>
            </cfoutput>
          </table>
        </cfloop>
        </td>
      </tr>
</table>
