<cfquery name="get_training_class_attendance" datasource="#dsn#">
	SELECT 
		TCA.START_DATE, 
		TCA.FINISH_DATE, 
		TCADT.EMP_ID,	
		TCADT.CON_ID,	
		TCADT.PAR_ID,	
		EP.EMPLOYEE_NAME AS AD,
		EP.EMPLOYEE_SURNAME AS SOYAD,
		TCADT.EXCUSE_MAIN,
		TCADT.CLASS_ATTENDANCE_ID
	FROM 
		TRAINING_CLASS_ATTENDANCE AS TCA, 
		TRAINING_CLASS_ATTENDANCE_DT AS TCADT, 
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE 
		EP.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND 
		BRANCH.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    POSITION_CODE = #SESSION.EP.POSITION_CODE#	
                            ) AND 
		C.COMP_ID=BRANCH.COMPANY_ID AND 
		TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
		EP.EMPLOYEE_ID=TCADT.EMP_ID AND 
		TCADT.IS_EXCUSE_MAIN = 1 AND 
		TCA.CLASS_ID=#attributes.CLASS_ID#
	UNION
	SELECT 
		TCA.START_DATE, 
		TCA.FINISH_DATE, 
		TCADT.EMP_ID,	
		TCADT.CON_ID,	
		TCADT.PAR_ID,	
		COMPANY_PARTNER.COMPANY_PARTNER_NAME AS AD,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SOYAD,
		TCADT.EXCUSE_MAIN,
		TCADT.CLASS_ATTENDANCE_ID
	FROM 
		TRAINING_CLASS_ATTENDANCE AS TCA, 
		TRAINING_CLASS_ATTENDANCE_DT AS TCADT, 
		COMPANY_PARTNER
	WHERE 
		TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
		COMPANY_PARTNER.PARTNER_ID=TCADT.PAR_ID AND 
		TCADT.IS_EXCUSE_MAIN = 1 AND 
		TCA.CLASS_ID = #attributes.CLASS_ID#
	UNION
	SELECT 
		TCA.START_DATE, 
		TCA.FINISH_DATE, 
		TCADT.EMP_ID,	
		TCADT.CON_ID,	
		TCADT.PAR_ID,	
		CONSUMER.CONSUMER_NAME AS AD,
		CONSUMER.CONSUMER_SURNAME AS SOYAD,
		TCADT.EXCUSE_MAIN,
		TCADT.CLASS_ATTENDANCE_ID
	FROM 
		TRAINING_CLASS_ATTENDANCE AS TCA, 
		TRAINING_CLASS_ATTENDANCE_DT AS TCADT, 
		CONSUMER
	WHERE 
		TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
		CONSUMER.CONSUMER_ID=TCADT.CON_ID AND 
		TCADT.IS_EXCUSE_MAIN = 1 AND 
		TCA.CLASS_ID = #attributes.CLASS_ID#
	ORDER BY 
		TCA.START_DATE,
		TCADT.CLASS_ATTENDANCE_ID
</cfquery>
<cfset attributes.list_excused = valuelist(get_training_class_attendance.EMP_ID)>
<cfset attributes.list_excused_con = valuelist(get_training_class_attendance.CON_ID)>
<cfset attributes.list_excused_par = valuelist(get_training_class_attendance.PAR_ID)>
<cfif isdefined("attributes.trail")>
<cfinclude template="view_class.cfm">
</cfif>
<cf_medium_list_search title="#getLang('training_management',99)#">
	<cf_medium_list_search_area>
		<table>
			<tr>
				<td>
					<cfif (len(attributes.list_excused)or len(attributes.list_excused_con) or len(attributes.list_excused_par)) and not listfindnocase(denied_pages,'training_management.popup_add_excuseds_class')>
					<a href="javascript://" onClick="windowopen(<cfoutput>'#request.self#?fuseaction=training_management.popup_add_excuseds_class&list_excused=#attributes.list_excused#&list_excused_par=#attributes.list_excused_par#&list_excused_con=#attributes.list_excused_con#','medium'</cfoutput>);"><img src="/images/examination.gif"  border="0" title="<cf_get_lang no='220.Eğitim Ekle'>"></a>
					</cfif>
				</td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</tr>
		</table>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr> 
			<th><cf_get_lang_main no='158.Ad Soyad'></th>
			<th width="150"><cf_get_lang_main no='79.Saat'></th>
			<th width="150"><cf_get_lang no='183.Mazeret'></th>
		</tr>
	</thead>
	<tbody>
	<cfif get_training_class_attendance.RECORDCOUNT>
	<cfoutput query="get_training_class_attendance"> 
		<tr>
			<td> 
			  <cfif len(emp_id)>
			  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMP_ID#','medium');" class="tableyazi">#ad# #soyad#</a>
			  <cfelseif len(par_id)>
			  <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
			  <cfelseif len(con_id)>
			  <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
			  </cfif> 
			</td>
			<td>#DateFormat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)# - #DateFormat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</td>
			<td>#excuse_main#</td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr>
			<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td> 
		</tr>
	</cfif>
	</tbody>
</cf_medium_list> 		
