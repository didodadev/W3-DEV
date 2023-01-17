<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_salary_plan.cfm">

<cf_box title="#getLang('','Maaş Planlanması',53296)# : #get_Emp_info(URL.EMPLOYEE_ID,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id="58455.Yıl"></th>
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
				<th width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_add_salary_plan&employee_id=<cfoutput>#employee_id#</cfoutput>&in_out_id=<cfoutput>#attributes.in_out_id#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				<!---<th><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_add_salary_plan&employee_id=<cfoutput>#employee_id#</cfoutput>&in_out_id=<cfoutput>#attributes.in_out_id#</cfoutput>','medium');"><img src="/images/plus_list.gif" border="0"></a></th>--->
			</tr>
		</thead>
		<tbody>
			<cfoutput query="get_salary_plan">
				<tr height="20">
					<td>#period_year#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M1)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M2)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M3)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M4)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M5)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M6)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M7)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M8)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M9)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M10)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M11)# #MONEY#</td>
					<td  nowrap style="text-align:right;">#TLFORMAT(M12)# #MONEY#</td>
					<cfif Len(UPDATE_EMP)>
						<cfquery name="get_upd_emp" datasource="#DSN#">
							SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, UPDATE_DATE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#UPDATE_EMP#">
						</cfquery>
						<td>#get_upd_emp.EMPLOYEE_NAME# #get_upd_emp.EMPLOYEE_SURNAME#</td>
						<td>#dateformat(date_add("h",session.ep.time_zone,UPDATE_DATE),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,UPDATE_DATE),timeformat_style)#)</td>
					<cfelse>
						<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
						<td>#dateformat(date_add("h",session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</td>
					</cfif>
					<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_upd_salary_plan&SALARY_PLAN_ID=#SALARY_PLAN_ID#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
				</tr>
			</cfoutput>
		</tbody>
	</cf_grid_list>
</cf_box>
