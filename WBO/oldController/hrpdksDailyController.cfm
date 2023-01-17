<cfparam name="attributes.ssk_office" default="0">
<cfparam name="attributes.startdate" default="#now()#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfscript>
	get_pos_cat_action = createObject("component", "hr.cfc.get_position_cat");
	get_pos_cat_action.dsn = dsn;
	get_position_cats = get_pos_cat_action.get_position_cat();
	
	get_branch_action = createObject("component", "hr.cfc.get_branches");
	get_branch_action.dsn = dsn;
	get_branches = get_branch_action.get_branch(
		status: 1,
		ehesap_control: 1
	);
</cfscript>
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfif len(attributes.startdate)>
		<cf_date tarih="attributes.startdate">
	</cfif>
	<cfscript>
		if (isdefined('attributes.startdate') and len(attributes.startdate))
		{
			last_month_1 = CreateDateTime(year(attributes.startdate),month(attributes.startdate),day(attributes.startdate),0,0,0);
			last_month_30 = CreateDateTime(year(attributes.startdate),month(attributes.startdate),day(attributes.startdate),23,59,59);
		}
	</cfscript>
	<cfquery name="get_list_type" datasource="#dsn#">
		SELECT 
			PROPERTY_VALUE,
			PROPERTY_NAME
		FROM
			FUSEACTION_PROPERTY
		WHERE
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			FUSEACTION_NAME = 'ehesap.list_ext_worktimes' AND
			PROPERTY_NAME = 'is_extwork_type'
	</cfquery>
	<cfquery name="get_employees" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EIO.IN_OUT_ID,
			ISNULL(DATEDIFF(MINUTE,EDI.START_DATE,EDI.FINISH_DATE),0) AS TOTAL_MIN,
			ISNULL(EDI.ROW_ID,0) ROW_ID,
			EIO.BRANCH_ID,
			<!---ISNULL(EEW.EWT_ID,0) EWT_ID,--->
			ISNULL(DATEDIFF(MINUTE,EEW0.START_TIME,EEW0.END_TIME),0) AS OVERTIME_VALUE_0,
			ISNULL(DATEDIFF(MINUTE,EEW1.START_TIME,EEW1.END_TIME),0) AS OVERTIME_VALUE_1,
			ISNULL(DATEDIFF(MINUTE,EEW2.START_TIME,EEW2.END_TIME),0) AS OVERTIME_VALUE_2,
			ISNULL(DATEDIFF(MINUTE,EEW3.START_TIME,EEW3.END_TIME),0) AS OVERTIME_VALUE_3,
			ISNULL(O.OFFTIMECAT_ID,0) AS OFFTIMECAT_ID
		FROM
			EMPLOYEES E
			INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
            <cfif isdefined('attributes.position_cat_id') and len(attributes.position_cat_id)>
                INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND 
                IS_MASTER=1 AND 
                EP.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#"> 
			</cfif>
			LEFT JOIN OFFTIME O ON O.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND O.VALID = 1 AND (
		        (
		        O.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        O.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        O.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        O.FINISHDATE IS NULL
		        )
		        OR
		        (
		        O.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        O.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        O.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        O.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		    )
			LEFT JOIN EMPLOYEE_DAILY_IN_OUT EDI ON EDI.IN_OUT_ID = EIO.IN_OUT_ID AND (
		        (
		        EDI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        EDI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        EDI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        EDI.FINISH_DATE IS NULL
		        )
		        OR
		        (
		        EDI.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        EDI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        EDI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        EDI.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		    )
			LEFT JOIN EMPLOYEES_EXT_WORKTIMES EEW0 ON EIO.IN_OUT_ID = EEW0.IN_OUT_ID AND EEW0.EWT_ID = (SELECT TOP 1 EWT_ID FROM EMPLOYEES_EXT_WORKTIMES WHERE DAY_TYPE = 0 AND
		        ((
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME IS NULL
		        )
		        OR
		        (
		        START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		    ) AND IN_OUT_ID = EIO.IN_OUT_ID ORDER BY EWT_ID)
		    LEFT JOIN EMPLOYEES_EXT_WORKTIMES EEW1 ON EIO.IN_OUT_ID = EEW1.IN_OUT_ID AND EEW1.EWT_ID = (SELECT TOP 1 EWT_ID FROM EMPLOYEES_EXT_WORKTIMES WHERE DAY_TYPE = 1 AND
		        ((
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME IS NULL
		        )
		        OR
		        (
		        START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		    ) AND IN_OUT_ID = EIO.IN_OUT_ID ORDER BY EWT_ID)
		    LEFT JOIN EMPLOYEES_EXT_WORKTIMES EEW2 ON EIO.IN_OUT_ID = EEW2.IN_OUT_ID AND EEW2.EWT_ID = (SELECT TOP 1 EWT_ID FROM EMPLOYEES_EXT_WORKTIMES WHERE DAY_TYPE = 2 AND
		        ((
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME IS NULL
		        )
		        OR
		        (
		        START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		    ) AND IN_OUT_ID = EIO.IN_OUT_ID ORDER BY EWT_ID)
		    LEFT JOIN EMPLOYEES_EXT_WORKTIMES EEW3 ON EIO.IN_OUT_ID = EEW3.IN_OUT_ID AND EEW3.EWT_ID = (SELECT TOP 1 EWT_ID FROM EMPLOYEES_EXT_WORKTIMES WHERE DAY_TYPE = 3 AND
		        ((
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME IS NULL
		        )
		        OR
		        (
		        START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		        OR
		        (
		        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
		        END_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
		        )
		    ) AND IN_OUT_ID = EIO.IN_OUT_ID ORDER BY EWT_ID)
		WHERE
			E.EMPLOYEE_STATUS = 1
			<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee') and len(attributes.employee)>
				AND E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
				AND (
			        (EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">)
			        OR
			        (EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND EIO.FINISH_DATE IS NULL)
			    )
			</cfif>
			AND EIO.SALARY_TYPE = 0
		ORDER BY
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_employees.recordcount = 0>
</cfif>
<script type="text/javascript">
	<cfif isdefined("get_employees") and get_employees.recordcount>
		row_count=<cfoutput>#get_employees.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
</script>
<cfquery name="get_offtimecat" datasource="#dsn#">
	SELECT OFFTIMECAT_ID,IS_PAID,EBILDIRGE_TYPE_ID FROM SETUP_OFFTIME WHERE IS_PAID = 1 OR EBILDIRGE_TYPE_ID = 1
</cfquery>
<cfquery name="get_paid_offtimecat" dbtype="query">
	SELECT OFFTIMECAT_ID FROM get_offtimecat WHERE IS_PAID = 1 AND EBILDIRGE_TYPE_ID <> 1
</cfquery>
<cfquery name="get_rest_offtimecat" dbtype="query">
	SELECT OFFTIMECAT_ID FROM get_offtimecat WHERE IS_PAID <> 1 AND EBILDIRGE_TYPE_ID = 1
</cfquery>
<cfquery name="get_both_offtimecat" dbtype="query">
	SELECT OFFTIMECAT_ID FROM get_offtimecat WHERE IS_PAID = 1 AND EBILDIRGE_TYPE_ID = 1
</cfquery>
<cfset list_paid_offtimecat = valuelist(get_paid_offtimecat.offtimecat_id,',')>
<cfset list_rest_offtimecat = valuelist(get_rest_offtimecat.offtimecat_id,',')>
<cfset list_both_offtimecat = valuelist(get_both_offtimecat.offtimecat_id,',')>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfquery name="get_temp_table" datasource="#dsn#">
	    IF object_id('tempdb..##get_employees_temp') IS NOT NULL
	       BEGIN DROP TABLE ##get_employees_temp END
	</cfquery>
	<cfquery name="temp_table" datasource="#dsn#">
		CREATE TABLE ##get_employees_temp
		(
			SIRA_NO int,
			CALISAN nvarchar(100),
            POZISYON nvarchar(100),
			NORMAL_GUN float,
			NORMAL_MESAI float,
			HAFTASONU_MESAI float,
			RESMI_TATIL_MESAI float,
			OFFSHORE float
		)
	</cfquery>
	<cfif get_employees.recordcount>
		<cfquery name="add_get_employees_temp" datasource="#dsn#">
			<cfoutput query="get_employees">
				INSERT INTO ##get_employees_temp
				(
					SIRA_NO,
					CALISAN,
					NORMAL_GUN,
					NORMAL_MESAI,
					HAFTASONU_MESAI,
					RESMI_TATIL_MESAI,
					OFFSHORE
				)
				VALUES
				(
					#currentrow#,
					'#employee_name# #employee_surname#',
					#wrk_round(total_min/60)#,
					#wrk_round(overtime_value_0/60)#,
					#wrk_round(overtime_value_1/60)#,
					#wrk_round(overtime_value_2/60)#,
					#wrk_round(overtime_value_3/60)#
				)
			</cfoutput>
		</cfquery>
	</cfif>
	<cfquery name="get_employees_temp" datasource="#dsn#">
		SELECT
			SIRA_NO AS '<cf_get_lang_main no="75.No">',
			CALISAN AS '<cf_get_lang_main no="164.Çalışan">',
            POZISYON AS '<cf_get_lang_main no='1085.Pozisyon'>',
			NORMAL_GUN AS '<cf_get_lang no="630.Normal Gün">',
			NORMAL_MESAI AS '<cf_get_lang no="802.Normal Mesai">',
			HAFTASONU_MESAI AS '<cf_get_lang no="803.Haftasonu Mesai">',
			RESMI_TATIL_MESAI AS '<cf_get_lang no="804.Resmi Tatil Mesai">',
			OFFSHORE AS '<cf_get_lang no="862.Offshore">'
		FROM 
    		##get_employees_temp
	</cfquery>
	<cfset file_name = "gun_bazinda_pdks_#session.ep.userid#_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#.xls">
	<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
	<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
        <cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
    </cfif>
    <cfspreadsheet action="write" filename="#upload_folder#reserve_files#dir_seperator##drc_name_#/#file_name#" query="get_employees_temp" sheetname="Gün Bazında PDKS" overwrite="true"  />
    <script type="text/javascript">
        <cfoutput>
            get_wrk_message_div("Excel","Excel","documents/reserve_files/#drc_name_#/#file_name#");
        </cfoutput>
    </script>
</cfif>

<script type="text/javascript">
	function hepsi(satir,nesne,baslangic)
	{
		deger = $('#'+nesne+'0');
		if(deger != undefined && $('#'+nesne+'0').val().length!=0)//değer boşdegilse çalıştır foru
		{
			if(!baslangic){baslangic=1;}//başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz
			for(var i=baslangic;i<=satir;i++)
			{
				$('#'+nesne+i).val($('#'+nesne+'0').val());
			}
		}
		return true;
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
		
		document.getElementById('record_num').value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<i class="icon-trash-o btnPointer" onclick="sil(' + row_count + ');"></i><input type="hidden" name="old_emp_id' + row_count +'" id="old_emp_id' + row_count +'" value=""><input type="hidden" name="row_id' + row_count +'" id="row_id' + row_count +'" value="0"><input type="hidden" name="ewt_id' + row_count +'" id="ewt_id' + row_count +'" value="0">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="in_out_id' + row_count +'" name="in_out_id' + row_count +'" value="in_out_id#currentrow#"><input type="text" id="employee' + row_count +'" name="employee' + row_count +'" style="width:120px;" value="" onfocus="AutoComplete_Create(\'employee'+row_count+'\',\'EMPLOYEE_NAME,EMPLOYEE_SURNAME\',\'FULLNAME\',\'get_in_outs_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID\',\'employee_id'+row_count+',in_out_id'+row_count+'\',\'\',\'3\',\'135\');" autocomplete="off"><i class="icon-ellipsis btnPointer" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=in_out_id'+row_count+'&field_emp_name=employee'+ row_count + '&field_emp_id=employee_id' + row_count + '\' ,\'list\');"></i><input type="hidden" id="employee_id' + row_count +'" value="" name="employee_id' + row_count +'"><input type="hidden" value="1" id="row_kontrol_' + row_count +'" name="row_kontrol_' + row_count +'">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="normal_day' + row_count +'" id="normal_day' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_normal_day' + row_count +'" id="old_normal_day' + row_count +'" value="0">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="normal_workhour' + row_count +'" id="normal_workhour' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_normal_workhour' + row_count +'" id="old_normal_workhour' + row_count +'" value="0" onkeyup="change_val(1,' + row_count +');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="weekend_work' + row_count +'" id="weekend_work' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_weekend_work' + row_count +'" id="old_weekend_work' + row_count +'" value="0" onkeyup="change_val(2,' + row_count +');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="holiday_work' + row_count +'" id="holiday_work' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_holiday_work' + row_count +'" id="old_holiday_work' + row_count +'" value="0" onkeyup="change_val(3,' + row_count +');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="offshore' + row_count +'" id="offshore' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_offshore' + row_count +'" id="old_offshore' + row_count +'" value="0" onkeyup="change_val(4,' + row_count +');">';
	}
	
	function sil(sy)
	{
		$('#row_kontrol_' + sy).val(0);
		$('#my_row_' +sy).css('display','none');
	}
	
	function kontrol()
	{
		$('#record_num').val(row_count);
		if(row_count == 0)
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'>");
			return false;
		}
		return true;
	}
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.day_pdks_table';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/day_pdks_table.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'hr/query/add_day_pdks.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'hr.day_pdks_table';

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrpdksDailyController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'list';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_DAILY_IN_OUT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.	
</cfscript>