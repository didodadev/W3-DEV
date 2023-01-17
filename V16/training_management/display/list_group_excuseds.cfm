<cfquery name="get_classes" datasource="#dsn#">
  SELECT
    TCGC.CLASS_ID
  FROM
    TRAINING_CLASS_GROUP_CLASSES TCGC,
	TRAINING_CLASS_GROUPS TCG
  WHERE
    TCGC.TRAIN_GROUP_ID = TCG.TRAIN_GROUP_ID
	  AND
	TCG.TRAIN_GROUP_ID = #attributes.TRAIN_GROUP_ID#
</cfquery>
<cfset CLASS_LIST = VALUELIST(get_classes.CLASS_ID)>
<cfif LEN(CLASS_LIST)>
<cfquery name="get_training_class_attendance" datasource="#dsn#">
	SELECT 
		TCA.START_DATE, 
		TCA.FINISH_DATE, 
		TCADT.EMP_ID,	
		TCADT.PAR_ID,	
		TCADT.CON_ID,	
		EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME AS ADSOYAD,
		TCADT.EXCUSE_MAIN,
		TCADT.CLASS_ATTENDANCE_ID,
        TC.CLASS_NAME
	FROM 
		TRAINING_CLASS_ATTENDANCE AS TCA, 
		TRAINING_CLASS_ATTENDANCE_DT AS TCADT, 
		EMPLOYEES,
        TRAINING_CLASS TC
	WHERE 
		TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
		EMPLOYEES.EMPLOYEE_ID=TCADT.EMP_ID AND 
		TCADT.IS_EXCUSE_MAIN = 1 AND <!--- mazeretli --->
		TCA.CLASS_ID IN (#CLASS_LIST#) AND
		TC.CLASS_ID = TCA.CLASS_ID
	UNION
	SELECT 
		TCA.START_DATE, 
		TCA.FINISH_DATE, 
		TCADT.EMP_ID,	
		TCADT.PAR_ID,	
		TCADT.CON_ID,	
		COMP.COMPANY_PARTNER_NAME+' '+COMP.COMPANY_PARTNER_SURNAME AS ADSOYAD,
		TCADT.EXCUSE_MAIN,
		TCADT.CLASS_ATTENDANCE_ID,
        TC.CLASS_NAME
	FROM 
		TRAINING_CLASS_ATTENDANCE AS TCA, 
		TRAINING_CLASS_ATTENDANCE_DT AS TCADT, 
		COMPANY_PARTNER COMP,
        TRAINING_CLASS TC
	WHERE 
		TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
		COMP.PARTNER_ID=TCADT.PAR_ID AND 
		TCADT.IS_EXCUSE_MAIN = 1 AND 
		TCA.CLASS_ID IN (#CLASS_LIST#) AND
		TC.CLASS_ID = TCA.CLASS_ID
	UNION
	SELECT 
		TCA.START_DATE, 
		TCA.FINISH_DATE, 
		TCADT.EMP_ID,	
		TCADT.PAR_ID,	
		TCADT.CON_ID,	
		CONS.CONSUMER_NAME+' '+CONS.CONSUMER_SURNAME AS ADSOYAD,
		TCADT.EXCUSE_MAIN,
		TCADT.CLASS_ATTENDANCE_ID,
        TC.CLASS_NAME
	FROM 
		TRAINING_CLASS_ATTENDANCE AS TCA, 
		TRAINING_CLASS_ATTENDANCE_DT AS TCADT, 
		CONSUMER CONS,
        TRAINING_CLASS TC 
	WHERE 
		TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID AND 
		CONS.CONSUMER_ID=TCADT.CON_ID AND 
		TCADT.IS_EXCUSE_MAIN = 1 AND
		TCA.CLASS_ID IN (#CLASS_LIST#) AND
		TC.CLASS_ID = TCA.CLASS_ID
	ORDER BY 
		TCA.START_DATE,
		TCADT.CLASS_ATTENDANCE_ID, 
		TCADT.EMP_ID,
		TCADT.CON_ID,
		TCADT.PAR_ID
</cfquery>
</cfif>
<cfif isdefined("get_training_class_attendance.EMP_ID") and LEN(get_training_class_attendance.EMP_ID)>
		<cfset attributes.list_excused = valuelist(get_training_class_attendance.EMP_ID)>
</cfif> 
<cf_medium_list_search title="#getLang('training_management',99)#">
	<cf_medium_list_search_area>
		<table>
			<thead>
				<tr>&nbsp;</tr>
				<tr>
					<th>
						<cfif isdefined("attributes.list_excused") and len(attributes.list_excused) and not listfindnocase(denied_pages,'training_management.popup_add_excuseds_class')>
							<a href="javascript://" onClick="windowopen(<cfoutput>'#request.self#?fuseaction=training_management.popup_add_excuseds_class&train_group_id=#attributes.TRAIN_GROUP_ID#&list_excused=#attributes.list_excused#','medium'</cfoutput>);"><img src="/images/examination.gif"  border="0" title="<cf_get_lang no='220.eğitim ekle'>"></a>
						</cfif>
					</th>
					<th>
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</th>
				</tr>
			</thead>
		</table>	
	</cf_medium_list_search_area>
</cf_medium_list_search>	
<cf_medium_list>
	<thead>
		<tr> 
			<th><cf_get_lang_main no='158.Ad Soyad'></th>
			<th width="150"><cf_get_lang_main no='79.Saat'></th>
            <th width="150"><cf_get_lang_main no='7.Eğitim'></th>
			<th width="150"><cf_get_lang no='183.Mazeret'></th>
		</tr>
	</thead>
	<tbody>
		<cfif LEN(CLASS_LIST)>
			<cfif get_training_class_attendance.RECORDCOUNT>
				<cfoutput query="get_training_class_attendance"> 
					<tr>
						<td> 
							<!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMP_ID#','medium');" class="tableyazi">
							#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
							</a>  --->
							<cfif len(emp_id)>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMP_ID#','medium');" class="tableyazi">#adsoyad#</a>
							<cfelseif len(par_id)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#par_id#','medium');" class="tableyazi">#adsoyad#</a>
							<cfelseif len(con_id)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#con_id#','medium');" class="tableyazi">#adsoyad#</a>
							</cfif> 
						</td>
						<td>#DateFormat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)# - #DateFormat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</td>
						<td>#class_name#</td>
                        <td>#excuse_main#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="4">
						<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
					</td> 
				</tr>
			</cfif>	
		</cfif> 
	</tbody>
</cf_medium_list>			 
