<cfinclude template="../query/my_sett.cfm">
<cfif isdefined("attributes.employee_id")>
  <cfquery name="get_employee_name" datasource="#DSN#">
  SELECT EMPLOYEE_NAME , EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
  </cfquery>
</cfif>
<table width="100%" height="100%" border="0" cellspacing="1" cellpadding="2">
  <tr>
	<td valign="top" width="180">
	  <table width="100%" border="0">
		<tr>
		  <td class="txtboldblue" ><cf_get_lang dictionary_id='31038.Kişisel İletişim Grupları'></td>
		  <td width="20" align="center">
			<cfif  not listfindnocase(denied_pages,'settings.popup_add_users')>
			  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_users&process=sett</cfoutput>','list')"><img src="/images/plus_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
			</cfif>
		  </td>
		</tr>
		<cfquery name="GET" datasource="#dsn#">
		SELECT * FROM USERS WHERE
		<cfif isdefined("attributes.employee_id")>
		  RECORD_MEMBER=#attributes.employee_id#
		  <cfelse>
		  RECORD_MEMBER=#SESSION.EP.USERID#
		</cfif>
		</cfquery>
		<cfoutput>
		  <cfloop from="1" to="#get.recordcount#" index="i">
			<tr>
			  <td>
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_users&group_id=#get.GROUP_ID[i]#','small')" class="tableyazi">#get.GROUP_NAME[i]#</a> </td>
			  <td width="20" align="center">
				<cfif  not listfindnocase(denied_pages,'settings.popup_upd_users')>
				  <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_upd_users&group_id=#get.group_id[i]#&process=sett','list')"><img src="/images/update_list.gif" border="0" align="absmiddle"></a>
				</cfif>
			  </td>
			</tr>
		  </cfloop>
		</cfoutput>
	  </table>
	  <br/>
	  <table width="100%">
		<tr>
		  <td class="txtboldblue"><cf_get_lang dictionary_id='29818.İş Grupları'></td>
		</tr> 
		<cfquery name="get_pos_code" datasource="#DSN#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE
		<cfif isdefined("attributes.employee_id")>
		  EMPLOYEE_ID = #attributes.employee_id#
		  <cfelse>
		  EMPLOYEE_ID = #session.ep.userid#
		</cfif>
		</cfquery>
		<cfquery name="get_mygroups" datasource="#DSN#">
		SELECT WORKGROUP_NAME,WORKGROUP_ID FROM WORK_GROUP WHERE
		WORKGROUP_ID IN (SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR
		WHERE POSITION_CODE = #get_pos_code.position_code#)
		</cfquery>
		<cfif get_mygroups.recordcount>
		  <cfoutput query="get_mygroups">
			<tr>
			  <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_workgroup&workgroup_id=#workgroup_id#','small');" class="tableyazi">#workgroup_name#</a></td>
			</tr>
		  </cfoutput>
		  <cfelse>
		  <tr>
			<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
		  </tr>
		</cfif>
	  </table>
	</td>
  </tr>
</table>

