<cfinclude template="../query/get_user_groups.cfm">
<cfinclude template="../query/get_modules.cfm">
<cfinclude template="../../myhome/query/my_sett.cfm">
<cfif not len(attributes.employee_id)>
	<cfset attributes.employee_id = 0>
</cfif>
<cfquery name="get_hr" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_USERNAME,
		EMPLOYEES.EMPLOYEE_PASSWORD,
		EMPLOYEE_POSITIONS.MEMBER_VIEW_CONTROL,
		EMPLOYEE_POSITIONS.POWER_USER,
		EMPLOYEE_POSITIONS.DISCOUNT_VALID,
		EMPLOYEE_POSITIONS.PRICE_VALID,
		EMPLOYEE_POSITIONS.PRICE_DISPLAY_VALID,
		EMPLOYEE_POSITIONS.COST_DISPLAY_VALID,
		EMPLOYEE_POSITIONS.CONSUMER_PRIORITY,
		EMPLOYEE_POSITIONS.MEMBER_DIRECT_DENIED,
		EMPLOYEE_POSITIONS.DUEDATE_VALID,
		EMPLOYEE_POSITIONS.RATE_VALID,
		EMPLOYEE_POSITIONS.THEIR_RECORDS_ONLY,
		EMPLOYEES.UPDATE_EMP,
		EMPLOYEES.UPDATE_DATE,
		EMPLOYEES.RECORD_EMP,
		EMPLOYEES.RECORD_DATE,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.POSITION_CAT_ID,
		EMPLOYEE_POSITIONS.USER_GROUP_ID 
	FROM 
		EMPLOYEES,
		EMPLOYEE_POSITIONS
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND 
		EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		EMPLOYEE_POSITIONS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
</cfquery>
<cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.USER_GROUP_ID,
		EMPLOYEE_POSITIONS.LEVEL_ID,
		EMPLOYEE_POSITIONS.LEVEL_EXTRA_ID,
		EMPLOYEE_POSITIONS.POWER_USER_LEVEL_ID,
		EMPLOYEE_POSITIONS.UPDATE_EMP,
		EMPLOYEE_POSITIONS.UPDATE_DATE,
		EMPLOYEE_POSITIONS.WRK_MENU,
		EPH.RECORD_DATE,
		EPH.RECORD_EMP
	FROM
		EMPLOYEE_POSITIONS 
		LEFT JOIN EMPLOYEE_POSITIONS_HISTORY EPH ON EPH.POSITION_ID=EMPLOYEE_POSITIONS.POSITION_ID AND EPH.HISTORY_ID = (SELECT TOP 1 EPH2.HISTORY_ID FROM EMPLOYEE_POSITIONS_HISTORY EPH2 WHERE EPH2.POSITION_ID = #attributes.POSITION_ID# ORDER BY EPH2.HISTORY_ID ASC)
	WHERE
		EMPLOYEE_POSITIONS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
</cfquery>
<cfset attributes.is_hr = 1>
<cfif attributes.type eq 1>
	<cfinclude template="list_positions_poweruser_in_1.cfm">
<cfelseif attributes.type eq 2>
	<cfinclude template="list_employee_periods.cfm">
<cfelseif attributes.type eq 3>
	<cfinclude template="list_employee_branchs.cfm">
	<cfinclude template="list_employee_standart_departments.cfm">
<cfelseif attributes.type eq 4>
	<cfinclude template="list_positions_poweruser_in_2.cfm">
<cfelseif attributes.type eq 5>
	<cfinclude template="list_positions_poweruser_in_3.cfm">
<cfelseif attributes.type eq 6>
	<cfinclude template="list_positions_poweruser_in_4.cfm">
<cfelseif attributes.type eq 7>
	<cfinclude template="list_positions_poweruser_in_5.cfm">
<cfelseif attributes.type eq 8>
	<cfinclude template="list_positions_poweruser_in_6.cfm">
<cfelseif attributes.type eq 9>
	<cfinclude template="list_positions_poweruser_in_7.cfm">
<cfelseif attributes.type eq 10>
	<cfinclude template="list_positions_poweruser_in_8.cfm">
</cfif>
<script language="javascript">
	function kullanici_grubu_kontrol()
	{
		document.getElementById('group_id').selectedIndex = 0;
	}
	function kontrol()
	{
		if (document.list_search.employee_name.value=="" || document.list_search.position_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='33713.Lütfen Kullanıcı Seçiniz'>!");
			return false;
		}
		else return true;	
	}
	
	function reset_level()
	{
		if (td_group.style.display == 'none')
			upd_pos.group_id.selectedIndex = 0;
	}
	
	function hepsi_power_user_sec()
	{
		if (document.power_user.all_power_user.checked)
		{
			<cfoutput query="get_modules">
			  document.power_user.POWER_USER_LEVEL_ID_#module_id#.checked = true;
			</cfoutput>
		}
		else
		{
			<cfoutput query="get_modules">
			  document.power_user.POWER_USER_LEVEL_ID_#module_id#.checked = false;
			</cfoutput>
		}
	}
	
	function hepsi_level_id_sec()
	{
		if (document.employee_user_name.all_level_id.checked)
		{
			<cfoutput query="get_modules">
			  document.employee_user_name.LEVEL_ID_#module_id#.checked = true;
			</cfoutput>
		}
		else
		{
			<cfoutput query="get_modules">
			  document.employee_user_name.LEVEL_ID_#module_id#.checked = false;
			</cfoutput>
		}
	}
	
	function hepsi_level_extra_id_sec()
	{
	<!---	if (document.upd_pos.all_level_extra_id.checked)
		{
			<cfoutput query="get_modules_extra">
			  document.upd_pos.level_extra_id_#extra_module_id#.checked = true;
			</cfoutput>
		}
		else
		{
			<cfoutput query="get_modules_extra">
			  document.upd_pos.level_extra_id_#extra_module_id#.checked = false;
			</cfoutput>
		}
		--->
	}
	function ozel_modul_kontrol_et()
	{
		if(document.getElementById('group_id').selectedIndex == 0)
			goster(gizli2);
		else
			gizle(gizli2);
	}
	function private_agenda_display()
	{
		if(document.getElementById('day_agenda').checked == false)
		{
			gizle(private_agenda_id);
		}
		else if(document.getElementById('day_agenda').checked == true)
			goster(private_agenda_id);
	}
</script>
