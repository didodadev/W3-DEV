<CFQUERY name="GET_EMP_QUIZS" datasource="#DSN#">
	SELECT 
		EI.INTERVIEW_ID,
		EI.INTERVIEW_EMP_ID,
		EI.INTERVIEW_DATE,
		EQ.QUIZ_ID,
		EQ.QUIZ_HEAD
	FROM 
		EMPLOYEES_INTERVIEW EI,
		EMPLOYEE_QUIZ EQ
	WHERE 
		EI.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND
		EI.QUIZ_ID = EQ.QUIZ_ID
	ORDER BY EI.INTERVIEW_ID ASC
</CFQUERY>
	<cf_medium_list_search title="#getLang('hr',867)#"></cf_medium_list_search>
    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
	<cf_medium_list>
    	<thead>
            <tr> 
                <th width="150"><cf_get_lang dictionary_id='55953.Form Adı'></th>
                <th width="150"><cf_get_lang dictionary_id ='56705.Değerlendirmeyi Yapan'></th>
                <th><cf_get_lang dictionary_id ='55944.Değerlendirme Tarihi'></th>
                <th <cfif get_module_power_user(48)>width="40"<cfelse>width="20"</cfif>></th>
            </tr>
        </thead>
        <tbody>
			<cfif  GET_EMP_QUIZS.RECORDCOUNT>
                <cfset interview_emp_list=''>
                <cfoutput query="GET_EMP_QUIZS">
                    <cfif not listfind(interview_emp_list,INTERVIEW_EMP_ID)>
                        <cfset interview_emp_list=listappend(interview_emp_list,INTERVIEW_EMP_ID)>
                     </cfif>
                </cfoutput>
                <cfset interview_emp_list=listsort(interview_emp_list,"numeric")>
                <cfif len(interview_emp_list)>
                     <cfquery name="get_interview_emp" datasource="#DSN#">
                        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#interview_emp_list#) ORDER BY EMPLOYEE_ID
                     </cfquery>
                </cfif>
                <cfoutput query="GET_EMP_QUIZS">
                    <tr>
                        <td>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_int_emp&employee_id=#attributes.employee_id#&quiz_id=#quiz_id#&interview_id=#interview_id#','list');" class="tableyazi">#QUIZ_HEAD#</a>
                        </td>
                        <td><cfif len(interview_emp_list)>#get_interview_emp.EMPLOYEE_NAME[listfind(interview_emp_list,INTERVIEW_EMP_ID,',')]# #get_interview_emp.EMPLOYEE_SURNAME[listfind(interview_emp_list,INTERVIEW_EMP_ID,',')]#</cfif></td>
                        <td>#dateformat(INTERVIEW_DATE,dateformat_style)#</td>
                        <td width="<cfif get_module_power_user(48)>40<cfelse>20</cfif>" align="center">
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_int_emp&employee_id=#attributes.employee_id#&quiz_id=#quiz_id#&interview_id=#interview_id#','list');" class="tableyazi"><img src="images/update_list.gif" border="0"></a>
                             <cfif get_module_power_user(48)><a href="#request.self#?fuseaction=hr.emptypopup_del_emp_int&quiz_id=#quiz_id#&employee_id=#attributes.employee_id#" class="tableyazi"><img src="images/delete_list.gif" border="0"></a></cfif>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_medium_list>
    <!---
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='867.Mülakat Formları'></td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class=color-border> 
    <td> 
	<input type="hidden" name="employee_id" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">
        <tr class="color-header"   height="22"> 
  	      <td width="150" class="form-title"><cf_get_lang no='868.Form Adı'></td>
		  <td width="150" class="form-title"><cf_get_lang no ='1620.Değerlendirmeyi Yapan'></td>
		  <td class="form-title"><cf_get_lang no ='859.Değerlendirme Tarihi'></td>
		  <td <cfif get_module_power_user()>width="40"<cfelse>width="20"</cfif>></td>
		</tr>
	<cfif  GET_EMP_QUIZS.RECORDCOUNT>
		<cfset interview_emp_list=''>
		<cfoutput query="GET_EMP_QUIZS">
			<cfif not listfind(interview_emp_list,INTERVIEW_EMP_ID)>
				<cfset interview_emp_list=listappend(interview_emp_list,INTERVIEW_EMP_ID)>
			 </cfif>
		</cfoutput>
		<cfset interview_emp_list=listsort(interview_emp_list,"numeric")>
		<cfif len(interview_emp_list)>
			 <cfquery name="get_interview_emp" datasource="#DSN#">
				SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#interview_emp_list#) ORDER BY EMPLOYEE_ID
			 </cfquery>
		</cfif>
		<cfoutput query="GET_EMP_QUIZS">
			<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_int_emp&employee_id=#attributes.employee_id#&quiz_id=#quiz_id#&interview_id=#interview_id#','list');" class="tableyazi">#QUIZ_HEAD#</a>
				</td>
				<td><cfif len(interview_emp_list)>#get_interview_emp.EMPLOYEE_NAME[listfind(interview_emp_list,INTERVIEW_EMP_ID,',')]# #get_interview_emp.EMPLOYEE_SURNAME[listfind(interview_emp_list,INTERVIEW_EMP_ID,',')]#</cfif></td>
				<td>#dateformat(INTERVIEW_DATE,dateformat_style)#</td>
				<td width="<cfif get_module_power_user()>40<cfelse>20</cfif>" align="center">
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_upd_int_emp&employee_id=#attributes.employee_id#&quiz_id=#quiz_id#&interview_id=#interview_id#','list');" class="tableyazi"><img src="images/update_list.gif" border="0"></a>
					 <cfif get_module_power_user()><a href="#request.self#?fuseaction=hr.emptypopup_del_emp_int&quiz_id=#quiz_id#&employee_id=#attributes.employee_id#" class="tableyazi"><img src="images/delete_list.gif" border="0"></a></cfif>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
	</cfif>
	  </table>
	</td>
  </tr>
</table>
--->




