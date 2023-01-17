<cfif (not session.ep.ehesap)>
	<cfinclude template="../query/get_emp_branches.cfm">
</cfif>
<cfquery name="EMP_DET" datasource="#dsn#">
  SELECT 
  		EMPLOYEES.EMPLOYEE_NAME,
  		EMPLOYEES.EMPLOYEE_SURNAME ,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.NICK_NAME,
        EMPLOYEES_IN_OUT.BRANCH_ID
	FROM 
  		EMPLOYEES,
		EMPLOYEES_IN_OUT,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY
  WHERE 
  		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.IN_OUT_ID#
		AND EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
</cfquery>
<cfif EMP_DET.recordcount>
	<cfif (not session.ep.ehesap) and (not listFind(emp_branch_list, EMP_DET.branch_id))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !");
			history.back();
		</script>
		<!--- yetki dışı kullanım için mail şablonu hazırlanmalı erk 20030911--->
		<cfabort>
	</cfif>
</cfif>
<cfquery name="GET_SALARY_HISTORY" datasource="#dsn#">
	SELECT
		EMPLOYEES_SALARY_HISTORY.*,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES_SALARY_HISTORY,
		EMPLOYEES
	WHERE
		EMPLOYEES_SALARY_HISTORY.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND EMPLOYEES_SALARY_HISTORY.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
		AND EMPLOYEES_SALARY_HISTORY.IN_OUT_ID = #attributes.in_out_id#
</cfquery>
<cfquery name="GET_SALARIES" datasource="#dsn#">
	SELECT
		EMPLOYEES_SALARY.*,
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS RECORD_EMP FROM EMPLOYEES WHERE EMPLOYEE_ID = EMPLOYEES_SALARY.RECORD_EMP) AS RECORDEMP,
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS UPDATE_EMP FROM EMPLOYEES WHERE EMPLOYEE_ID = EMPLOYEES_SALARY.UPDATE_EMP) AS UPDATEEMP
	FROM
		EMPLOYEES_SALARY
	WHERE
		EMPLOYEES_SALARY.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		<!---AND EMPLOYEES_SALARY.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID--->
		AND EMPLOYEES_SALARY.IN_OUT_ID = #attributes.in_out_id#
	ORDER BY
		EMPLOYEES_SALARY.PERIOD_YEAR DESC
</cfquery>

<cf_box title="#getLang('','Yıllara Göre Son Ücretler',54123)# : #EMP_DET.EMPLOYEE_NAME# #EMP_DET.EMPLOYEE_SURNAME#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">	
    <cf_grid_list>
        <thead>
            <tr>
                <th colspan="15">
                    <strong><cf_get_lang dictionary_id ='57574.Şirket'> :</strong>&nbsp; <cfoutput>#EMP_DET.NICK_NAME#</cfoutput>&nbsp;&nbsp;&nbsp;
                    <strong><cf_get_lang dictionary_id ='57453.Şube'> :</strong>&nbsp; <cfoutput>#EMP_DET.BRANCH_NAME#</cfoutput>&nbsp;&nbsp;&nbsp;
                    <strong><cf_get_lang dictionary_id ='57572.Departman'> :</strong>&nbsp; <cfoutput>#EMP_DET.DEPARTMENT_HEAD#</cfoutput>&nbsp;&nbsp;&nbsp;
                </th>
            </tr>
            <tr class="color-header" height="22">
                <th width="30"><cf_get_lang dictionary_id='58455.Yıl'></th>
                <th width="125"><cf_get_lang dictionary_id='57592.Ocak'></th>
                <th width="125"><cf_get_lang dictionary_id='57593.Şubat'></th>
                <th width="125"><cf_get_lang dictionary_id='57594.Mart'></th>
                <th width="125"><cf_get_lang dictionary_id='57595.Nisan'></th>
                <th width="125"><cf_get_lang dictionary_id='57596.Mayıs'></th>
                <th width="125"><cf_get_lang dictionary_id='57597.Haziran'></th>
                <th width="125"><cf_get_lang dictionary_id='57598.Temmuz'></th>
                <th width="125"><cf_get_lang dictionary_id='57599.Ağustos'></th>
                <th width="125"><cf_get_lang dictionary_id='57600.Eylül'></th>
                <th width="125"><cf_get_lang dictionary_id='57601.Ekim'></th>
                <th width="125"><cf_get_lang dictionary_id='57602.Kasım'></th>
                <th width="125"><cf_get_lang dictionary_id='57603.Aralık'></th>
                <th width="150"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                <th width="125"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="GET_SALARIES">
                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td class="text-right">#period_year#</td>
                    <td class="text-right">#TLFORMAT(M1)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M2)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M3)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M4)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M5)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M6)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M7)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M8)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M9)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M10)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M11)# #MONEY#</td>
                    <td class="text-right">#TLFORMAT(M12)# #MONEY#</td>
                    <td class="text-right"><cfif len(update_emp)>#updateemp#<cfelse>#recordemp#</cfif></td>
                    <td class="text-right"><cfif len(update_emp)>#dateformat(date_add("h",session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,update_date),timeformat_style)#<cfelse>#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</cfif></td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    
    <cfset title_list = "">
    <cfif get_salary_history.recordcount>
        <cfset temp_ = 0>
        <cfoutput query="get_salary_history">
            <cfset temp_ = temp_ +1>
            <cf_seperator title="#getLang('','Ücret Tarihçesi',53227)# #dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#) - #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#" id="history_#temp_#" is_closed="1">
            <table id="history_#temp_#" style="display:none;">
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57592.Ocak'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M1)# #MONEY#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57598.Temmuz'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M7)# #MONEY#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57593.Şubat'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M2)# #MONEY#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57599.Ağustos'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M8)# #MONEY#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57594.Mart'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M3)# #MONEY#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57600.Eylül'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M9)# #MONEY#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57595.Nisan'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M4)# #MONEY#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57601.Ekim'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M10)# #MONEY#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57596.Mayıs'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M5)# #MONEY#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57602.Kasım'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M11)# #MONEY#</td>
                </tr>
                <tr>
                    <td class="txtbold"><cf_get_lang dictionary_id='57597.Haziran'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M6)# #MONEY#</td>
                    <td class="txtbold"><cf_get_lang dictionary_id='57603.Aralık'></td>
                    <td style="text-align:right; width:100px;">#TLFORMAT(M12)# #MONEY#</td>
                </tr>
            </table>
        </cfoutput>
    </cfif>
</cf_box>
