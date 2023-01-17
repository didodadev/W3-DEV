<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_schedules" datasource="#dsn#">
        SELECT 
            SR.*,
            R.REPORT_NAME AS REPORT,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_ID,
            E.EMPLOYEE_SURNAME
        FROM
            SCHEDULED_REPORTS SR,
            REPORTS R,
            EMPLOYEES E
        WHERE
            R.REPORT_ID = SR.REPORT_ID
            AND
            E.EMPLOYEE_ID = SR.RECORD_EMP
            <cfif len(attributes.keyword)>
            AND
            (
            R.REPORT_NAME LIKE '%#attributes.keyword#%'
            OR
            SR.REPORT_NAME LIKE '%#attributes.keyword#%'
            )
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_schedules.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_schedules.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<script type="text/javascript">
	document.getElementById("keyword").focus();
</script>



<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
<cf_get_lang_set module_name="settings">
<cfif not (isdefined("attributes.is_pos_operation") and len(attributes.is_pos_operation))><cfset attributes.is_pos_operation = 0></cfif>
<cfquery name="OUR_COMPANY" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME, 
        NICK_NAME, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
	    OUR_COMPANY 
    ORDER BY 
    	COMPANY_NAME
</cfquery>
<cfquery name="get_pos_operation_row" datasource="#dsn#">
    SELECT 
        SCHEDULE_ID, 
        ROW_NUMBER, 
        POS_OPERATION_ID 
    FROM 
    	SCHEDULE_SETTINGS_ROW 
    WHERE 
	    SCHEDULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.schedule_id#">
</cfquery>
<cfquery name="get_pos_operation" datasource="#dsn3#">
    SELECT * FROM POS_OPERATION ORDER BY POS_OPERATION_NAME
</cfquery>
<cfparam name="attributes.our_company_ids" default="#session.ep.company_id#">
<cfinclude template="../settings/query/get_schedules.cfm">
<cfsavecontent variable="img">
	<a href="<cfoutput>#request.self#?fuseaction=bank.popup_add_schedule_task</cfoutput>"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"/></a>
</cfsavecontent>

<script type="text/javascript">
	row_count = "<cfoutput>#get_pos_operation_row.recordcount#</cfoutput>";
	function sil(sy)
	{
		var my_element=eval("document.upd_schedule.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
		document.upd_schedule.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" /><a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="images/delete_list.gif" border="0"></a>';	
		newCell= newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="pos_line_'+ row_count +'" id="pos_line_'+ row_count +'" value="" style="width:50px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML= '<select name="pos_operation_id_'+ row_count +'" style="width:150px;"><option value="">Seçiniz</option><cfoutput query="get_pos_operation"><option value="#get_pos_operation.pos_operation_id#">#get_pos_operation.pos_operation_name#</option></cfoutput></select>';
	}
	function control_schedule()
	{
		alert_info = "Zaman Ayarlı Görev Çalıştırılacaktır. Emin misiniz ?";
		if (confirm(alert_info)) 
		{
			windowopen('','small','cc_che');
			upd_schedule.action='<cfoutput>#request.self#?fuseaction=schedules.emptypopup_schedule_action&schedule_id=#attributes.schedule_id#&is_from_upd</cfoutput>';
			upd_schedule.target='cc_che';
			upd_schedule.submit();
			return false;
		}
		else 
			return false;
	}
	function control()
	{
		if((document.upd_schedule.ScheduleType[2].checked && document.upd_schedule.ScheduleType[2].value == 'Custom') && ((document.upd_schedule.customInterval_min.value.length == 0) || (document.upd_schedule.customInterval_sec.value.length == 0) || (document.upd_schedule.customInterval_hour.value.length == 0)))
		{
			alert('<cf_get_lang no="2696.Period Verileri Eksik">');
			return false;
		}
		return true;
	}
	function change_currency_info()//kurlarla ilgili fuseaction ları URL input una taşır
	{
		x = document.upd_schedule.currency_schedule.selectedIndex;
		if (document.upd_schedule.currency_schedule[x].value != "")
			document.upd_schedule.schedule_url.value = document.upd_schedule.currency_schedule[x].value;
		else
			document.upd_schedule.schedule_url.value = '<cfoutput> http://#cgi.SERVER_NAME#/#request.self#?fuseaction=schedules.emptypopup_schedule_action</cfoutput>';
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

</cfif>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'report.list_schedules';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'report/display/list_schedules.cfm';
	
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.upd_schedule_task';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'settings/form/upd_schedule_task.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'settings/query/upd_schedule.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'report.list_schedules&event=list';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'schedule_id=##attributes.schedule_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.schedule_id##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'settings.upd_schedule_task';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'settings/query/del_schedule_task.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'settings/query/del_schedule_task.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'report.list_schedules&event=list';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'REPORT_CAT_ID=##attributes.REPORT_CAT_ID##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.REPORT_CAT_ID##';
	


</cfscript>

