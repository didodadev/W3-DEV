<cfquery name="GET_IN_OUTS" datasource="#dsn#">
	SELECT 
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.RECORD_DATE,
		EMPLOYEES_IN_OUT.UPDATE_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		EMPLOYEES_IN_OUT,
		EMPLOYEES,
		BRANCH
	WHERE
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND	EMPLOYEES_IN_OUT.EMPLOYEE_ID = #ATTRIBUTES.EMPLOYEE_ID#
		<cfif not session.ep.ehesap>
		AND 
		BRANCH.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
                            )
	</cfif>
	ORDER BY EMPLOYEES_IN_OUT.IN_OUT_ID DESC
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="52965.İşe Giriş Çıkışlar"></cfsavecontent>
<cf_popup_box title="#message# : #get_in_outs.employee_name# #get_in_outs.employee_surname#">
	<cf_medium_list>
	   <thead>
	     <tr height="22">
		     <th><cf_get_lang dictionary_id ='57453.Şube'></th>
		     <th width="65"><cf_get_lang dictionary_id ='57628.Giriş Tarihi'></th>
		     <th width="65"><cf_get_lang dictionary_id ='29438.Çıkış Tarihi'></th>
			 <th width="45"></th>
			 <th width="35"></th>
		</tr>
		</thead>
		<tbody>
	  <cfoutput query="GET_IN_OUTS">
	     <tr height="20">             
		     <td>#branch_name#</td>
		     <td>#dateformat(start_date,dateformat_style)#&nbsp;</td>
		     <td>#dateformat(finish_date,dateformat_style)#&nbsp;</td>
			 <td width="50">
			 	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_ssk_start_work&employee_id=#attributes.employee_id#&IN_OUT_ID=#IN_OUT_ID#','page');"><img src="/images/emp_gi.gif" border="0" title="<cf_get_lang dictionary_id='53452.İşe Giriş Bildirgesi'>"></a>
			    <cfif len(finish_date)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_new_ssk_worker_out_self&employee_id=#attributes.employee_id#&branch_id=#branch_id#&IN_OUT_ID=#IN_OUT_ID#','page');"><img src="/images/employ.gif" border="0" title="<cf_get_lang dictionary_id='53453.işten ayrılma bildirgesi'>"></a></cfif>
			</td>
			<td width="35">
			 	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_ssk_start_work_secure&employee_id=#attributes.employee_id#&IN_OUT_ID=#IN_OUT_ID#&branch_id=#branch_id#','page');"><img src="/images/caution_small.gif" border="0" title="<cf_get_lang dictionary_id ='54114.İşçi Kolluk Kuvvetleri Belgesi'>"></a>
			</td>
	      </tr>
	  </cfoutput>
	  </tbody>
	</cf_medium_list>
</cf_popup_box> 
