<cfset xml_department_id_list = "1275">
<cfset xml_employee_id_list = "16,1398">
<cfquery name="Get_Employee_List" datasource="#dsn#">
	SELECT
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		IS_MASTER = 1 AND
		POSITION_STATUS = 1 AND
		<cfif isDefined("xml_employee_id_list") and Len(xml_employee_id_list)>
			EMPLOYEE_ID IN (#xml_employee_id_list#) AND
		</cfif>
		<cfif isDefined("xml_department_id_list") and Len(xml_department_id_list)>
			DEPARTMENT_ID IN (#xml_department_id_list#) AND
		</cfif>
		EMPLOYEE_ID IS NOT NULL
	ORDER BY
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
</cfquery>
<cfquery name="Get_Time_Cost" datasource="#dsn#">
	SELECT EMPLOYEE_ID, SUM(EXPENSED_MINUTE) EXPENSED_MINUTE, OVERTIME_TYPE, EVENT_DATE FROM TIME_COST WHERE P_ORDER_RESULT_ID = #attributes.pr_order_id# GROUP BY EMPLOYEE_ID,OVERTIME_TYPE, EVENT_DATE
</cfquery>
<cfif isDefined("attributes.pr_order_id") and Len(attributes.pr_order_id)>
	<cfquery name="Get_Relation_Production" datasource="#dsn3#">
		SELECT P_ORDER_ID,PR_ORDER_ID,RESULT_NO FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
	</cfquery>
</cfif>
<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td height="30" class="headbold">
			Zaman Harcaması
			<cfif isDefined("attributes.pr_order_id") and Len(attributes.pr_order_id)>
				: <cfoutput><a href="#request.self#?fuseaction=pda.form_upd_production_result&p_order_id=#Get_Relation_Production.P_Order_Id#&pr_order_id=#Get_Relation_Production.Pr_Order_Id#">#Get_Relation_Production.Result_No#</a></cfoutput>
			</cfif>
		</td>
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">	
	<tr>
		<td class="color-row">
		<table cellpadding="1" cellspacing="1" width="100%">
			<cfform name="add_time_cost" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_time_cost">
			<input type="hidden" name="pr_order_id" id="pr_order_id" value="<cfif isDefined("attributes.pr_order_id") and Len(attributes.pr_order_id)><cfoutput>#attributes.pr_order_id#</cfoutput></cfif>">
			<input type="hidden" name="pr_order_number" id="pr_order_number" value="<cfif isDefined("attributes.pr_order_id") and Len(attributes.pr_order_id)><cfoutput>#Get_Relation_Production.Result_No#</cfoutput></cfif>">
			<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#Get_Employee_List.RecordCount#</cfoutput>">
			<tr class="color-list">
				<td class="txtboldblue" style="width:80px;">Çalışan</td>
				<td class="txtboldblue" style="width:70px;">Tarih</td>
				<td class="txtboldblue" style="width:45px;">Sa / Dk</td>
				<td class="txtboldblue" style="text-align:center;">Mesai</td>
			</tr>
			<cfoutput query="Get_Employee_List">
				<input type="hidden" name="employee_id_#currentrow#" id="employee_id_#currentrow#" value="#employee_id#">
				<tr>
					<td>#Left("#Employee_Name# #Employee_Surname#",18)#</td>
					<td nowrap>
						<input type="text" name="event_date_#currentrow#" id="event_date_#currentrow#" value="#DateFormat(now(),'dd/mm/yyyy')#" maxlength="10" style="width:50px;">
						<cf_wrk_date_image date_field="event_date_#currentrow#">
					</td>
					<td nowrap>
						<input type="text" name="event_hour_#currentrow#" id="event_hour_#currentrow#" value="0" maxlength="2" style="width:13px;" onKeyUp="isNumber(this);">
						<input type="text" name="event_minute_#currentrow#" id="event_minute_#currentrow#" value="0" maxlength="2" style="width:13px;" onKeyUp="isNumber(this);">
					</td>
					<td><select name="overtime_type_#currentrow#" id="overtime_type_#currentrow#" style="width:42px;">
							<option value="1" title="Normal Mesai">NM</option>
							<option value="2" title="Fazla Mesai">FM</option>
							<option value="3" title="Hafta Sonu">HS</option>
							<option value="4" title="Resmi Tatil">RT</option>
						</select>
					</td>
				</tr>
			</cfoutput>
			<tr valign="top" style="height:40px;">
				<td colspan="4" style="text-align:right"><input type="button" value="Kaydet" onClick="control_timecost();"></td>
			</tr>
			</cfform>
			<tr>
				<td colspan="4">
				<table cellpadding="1" cellspacing="1" width="100%">
					<tr class="color-list">
						<td class="txtboldblue" style="width:80px;">Çalışan</td>
						<td class="txtboldblue" style="width:70px;">Tarih</td>
						<td class="txtboldblue" style="width:45px;">Sa / Dk</td>
						<td class="txtboldblue" style="text-align:center;">Mesai</td>
					</tr>
					<cfoutput query="Get_Time_Cost">
						<tr>
							<td>#get_emp_info(employee_id,0,0)#</td>
							<td style="text-align:center;">#Dateformat(event_date,'dd/mm/yyyy')#</td>
							<td style="text-align:center;">
								<cfif Len(Get_Time_Cost.Expensed_Minute)>
									<cfset event_minute = Get_Time_Cost.Expensed_Minute mod 60>
									<cfset event_hour = (Get_Time_Cost.Expensed_Minute - event_minute)/60>
								<cfelse>
									<cfset event_hour = 0>
									<cfset event_minute = 0>
								</cfif>
								#NumberFormat(event_hour,00)# : #NumberFormat(event_minute,00)#
							</td>
							<td style="text-align:center;">
								<cfif overtime_type eq 1>NM
								<cfelseif overtime_type eq 2>FM
								<cfelseif overtime_type eq 3>HS
								<cfelse>RT
								</cfif>
							</td>
						</tr>
					</cfoutput>
				</table>
				</td>
				
			</tr>
		</table>
		</td>
	</tr>
</table>
<script language="javascript" type="text/javascript">
	function control_timecost()
	{
		<cfoutput query="Get_Employee_List">
			if(document.getElementById("event_date_#currentrow#").value == "")
			{
				alert("#CurrentRow#. Tarih Değerini Kontrol Ediniz!");
				return false;
			}
			if(document.getElementById("event_hour_#currentrow#").value == "" || document.getElementById("event_minute_#currentrow#").value == "")
			{
				alert("#CurrentRow#. Sa / Dk Değerini Kontrol Ediniz!");
				return false;
			}
		</cfoutput>
		if(confirm("Kaydetmek İstediğinize Emin Misiniz?"))
			document.getElementById("add_time_cost").submit();
		else
			return false;
	}
</script>
