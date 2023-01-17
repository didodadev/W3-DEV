<cfparam name="attributes.ssk_office" default="0">
<cfparam name="attributes.startdate" default="#now()#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfscript>
	get_pos_cat_action = createObject("component", "V16.hr.cfc.get_position_cat");
	get_pos_cat_action.dsn = dsn;
	get_position_cats = get_pos_cat_action.get_position_cat();
	
	get_branch_action = createObject("component", "V16.hr.cfc.get_branches");
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
		    ) AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
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
			SIRA_NO AS "<cf_get_lang dictionary_id='57487.No'>",
			CALISAN AS "<cf_get_lang dictionary_id='30368.Çalışan'>",
            POZISYON AS "<cf_get_lang dictionary_id='58497.Pozisyon'>",
			NORMAL_GUN AS "<cf_get_lang dictionary_id='55715.Normal Gün'>",
			NORMAL_MESAI AS "<cf_get_lang dictionary_id='55887.Normal Mesai'>",
			HAFTASONU_MESAI AS "<cf_get_lang dictionary_id='55888.Haftasonu Mesai'>",
			RESMI_TATIL_MESAI AS "<cf_get_lang dictionary_id='55889.Resmi Tatil Mesai'>",
			OFFSHORE AS "<cf_get_lang dictionary_id='33569.Offshore'>"
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=hr.day_pdks_table" name="searchform" method="post">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='55814.Gün Bazında PDKS'></cfsavecontent>
					<input type="hidden" name="is_submitted" id="is_submitted" value="1" placeholder="<cfoutput>#place#</cfoutput>">
				</div>
				<div class="form-group">
					<select name="branch_id" id="branch_id">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_branches">
							<option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="text" name="employee" id="employee" value="<cfif isdefined('attributes.employee') and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" style="width:120px;" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" autocomplete="off" placeholder="<cfoutput>#getLang('','Çalışan',30368)#</cfoutput>">
						<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=searchform.employee_id&field_name=searchform.employee&select_list=1','list');"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="position_cat_id" id="position_cat_id" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></option>
						<cfoutput query="GET_POSITION_CATS">
							<option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></cfsavecontent> 
						<cfif len(attributes.startdate)>
							<cfinput type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
						<cfelse>
							<cfinput type="text" name="startdate" id="startdate" value="" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group">
					<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id="57858.Excel Getir">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div> 
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='55814.Gün Bazında PDKS'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cfform name="add_day_pdks" action="#request.self#?fuseaction=hr.emptypopup_add_day_pdks" method="post">
			<cf_grid_list sort="0">
				<thead>
					<tr>
						<th><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
						<th><cf_get_lang dictionary_id="57576.Çalışan"></th>
						<th><cf_get_lang dictionary_id="55715.Normal Gün"></th>
						<th><cf_get_lang dictionary_id="55887.Normal Mesai"></th>
						<th><cf_get_lang dictionary_id="55888.Haftasonu Mesai"></th>
						<th><cf_get_lang dictionary_id="55889.Resmi Tatil Mesai"></th>
						<th>Offshore</th>
					<!--- <th></th>--->
					</tr>
				</thead>
				<tbody id="link_table">
					<tr>
						<td></td>
						<td><label class="col col-12"><cf_get_lang dictionary_id="55886.Toplu Ekleme"></label></td>
						<td>
							<input name="record_num" id="record_num" type="hidden" value="0">
							<input type="hidden" name="startdate_" id="startdate_" value="<cfoutput>#attributes.startdate#</cfoutput>">
							<input type="hidden" value="1" name="row_kontrol_0" id="row_kontrol_0">
							<input type="hidden" value="<cfoutput>#attributes.branch_id#</cfoutput>" name="branch_id" id="branch_id">
							<input type="hidden" name="is_submitted" id="is_submitted" value="<cfif isdefined('attributes.is_submitted')><cfoutput>#attributes.is_submitted#</cfoutput></cfif>">
							<input type="hidden" name="startdate" id="startdate" value="<cfif isdefined('attributes.startdate') and len(attributes.startdate)><cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput></cfif>">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
							<input type="hidden" name="employee" id="employee" value="<cfif isdefined('attributes.employee') and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>">
							<div class="form-group"><cfinput type="text" name="normal_day0" id="normal_day0" validate="float" class="moneybox" value="" onChange="hepsi(row_count,'normal_day');" onkeyup="hepsi(row_count,'normal_day');"></div>
						</td>
						<td><div class="form-group"><cfinput type="text" name="normal_workhour0" id="normal_workhour0" class="moneybox" value="" onChange="hepsi(row_count,'normal_workhour');" onkeyup="hepsi(row_count,'normal_workhour');"></div></td>
						<td><div class="form-group"><cfinput type="text" name="weekend_work0" id="weekend_work0" class="moneybox" value="" onChange="hepsi(row_count,'weekend_work');" onkeyup="hepsi(row_count,'weekend_work');"></div></td>
						<td><div class="form-group"><cfinput type="text" name="holiday_work0" id="holiday_work0" class="moneybox" value="" onChange="hepsi(row_count,'holiday_work');" onkeyup="hepsi(row_count,'holiday_work');"></div></td>
						<td><div class="form-group"><cfinput type="text" name="offshore0" id="offshore0" class="moneybox" value="" onChange="hepsi(row_count,'offshore');" onkeyup="hepsi(row_count,'offshore');"></div></td>
					</tr>
					<cfif isdefined("attributes.is_submitted") and (get_employees.recordcount)>
						<cfoutput query="get_employees">
							<input type="hidden" name="old_emp_id#currentrow#" id="old_emp_id#currentrow#" value="#employee_id#">
							<tr id="my_row_#currentrow#">
								<input type="hidden" value="1" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
								<input type="hidden" name="row_id#currentrow#" id="row_id#currentrow#" value="#row_id#">
								<!---<input type="hidden" name="ewt_id#currentrow#" id="ewt_id#currentrow#" value="#ewt_id#">--->
								<input type="hidden" name="old_normal_day#currentrow#" id="old_normal_day#currentrow#" value="#wrk_round(total_min/60)#">
								<td <cfif offtimecat_id eq 1>style="background-color:darkgrey;"<cfelseif listlen(list_paid_offtimecat,',') and listfind(list_paid_offtimecat,offtimecat_id,',')>style="background-color:##3399FF;"<cfelseif listlen(list_rest_offtimecat,',') and listfind(list_rest_offtimecat,offtimecat_id,',')>style="background-color:##339900;"<cfelseif listlen(list_both_offtimecat,',') and listfind(list_both_offtimecat,offtimecat_id,',')>style="background-color:yellow;"</cfif>><a style="cursor:pointer" onclick="sil(#currentrow#);"><i class="fa fa-minus" border="0"></i></a></td>
								<td nowrap <cfif offtimecat_id eq 1>style="background-color:darkgrey;"<cfelseif listlen(list_paid_offtimecat,',') and listfind(list_paid_offtimecat,offtimecat_id,',')>style="background-color:##3399FF;"<cfelseif listlen(list_rest_offtimecat,',') and listfind(list_rest_offtimecat,offtimecat_id,',')>style="background-color:##339900;"<cfelseif listlen(list_both_offtimecat,',') and listfind(list_both_offtimecat,offtimecat_id,',')>style="background-color:yellow;"</cfif>>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="in_out_id#currentrow#" id="in_out_id#currentrow#" value="#in_out_id#">
											<input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
											<input name="employee#currentrow#" id="employee#currentrow#" type="text" style="width:120px;" value="#employee_name# #employee_surname#" onfocus="AutoComplete_Create('employee#currentrow#','EMPLOYEE_NAME,EMPLOYEE_SURNAME','FULLNAME','get_in_outs_autocomplete','3','EMPLOYEE_ID,IN_OUT_ID','employee_id#currentrow#,in_out_id#currentrow#','','3','135');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_day_pdks.in_out_id#currentrow#&field_emp_name=add_day_pdks.employee#currentrow#&field_emp_id=add_day_pdks.employee_id#currentrow#');"></span>
										</div>
									</div>
								</td>
								<cfsavecontent variable="message">Normal Gün verisini kontrol ediniz</cfsavecontent>
								<td <cfif offtimecat_id eq 1>style="background-color:darkgrey;"<cfelseif listlen(list_paid_offtimecat,',') and listfind(list_paid_offtimecat,offtimecat_id,',')>style="background-color:##3399FF;"<cfelseif listlen(list_rest_offtimecat,',') and listfind(list_rest_offtimecat,offtimecat_id,',')>style="background-color:##339900;"<cfelseif listlen(list_both_offtimecat,',') and listfind(list_both_offtimecat,offtimecat_id,',')>style="background-color:yellow;"</cfif>><div class="form-group"><cfinput type="text" name="normal_day#currentrow#" id="normal_day#currentrow#" validate="float" style="width:100px; text-align:right;" value="#wrk_round(total_min/60)#" message="#currentrow#. #message#"></div></td>
								<cfsavecontent variable="message">Normal Mesai verisini kontrol ediniz</cfsavecontent>
								<td <cfif offtimecat_id eq 1>style="background-color:darkgrey;"<cfelseif listlen(list_paid_offtimecat,',') and listfind(list_paid_offtimecat,offtimecat_id,',')>style="background-color:##3399FF;"<cfelseif listlen(list_rest_offtimecat,',') and listfind(list_rest_offtimecat,offtimecat_id,',')>style="background-color:##339900;"<cfelseif listlen(list_both_offtimecat,',') and listfind(list_both_offtimecat,offtimecat_id,',')>style="background-color:yellow;"</cfif>><div class="form-group"><cfinput type="text" name="normal_workhour#currentrow#" id="normal_workhour#currentrow#" validate="float" style="width:100px; text-align:right;" value="#wrk_round(overtime_value_0/60)#" message="#currentrow#. #message#"></div></td>
								<cfsavecontent variable="message">Haftasonu Mesai verisini kontrol ediniz</cfsavecontent>
								<td <cfif offtimecat_id eq 1>style="background-color:darkgrey;"<cfelseif listlen(list_paid_offtimecat,',') and listfind(list_paid_offtimecat,offtimecat_id,',')>style="background-color:##3399FF;"<cfelseif listlen(list_rest_offtimecat,',') and listfind(list_rest_offtimecat,offtimecat_id,',')>style="background-color:##339900;"<cfelseif listlen(list_both_offtimecat,',') and listfind(list_both_offtimecat,offtimecat_id,',')>style="background-color:yellow;"</cfif>><div class="form-group"><cfinput type="text" name="weekend_work#currentrow#" id="weekend_work#currentrow#" validate="float" style="width:100px; text-align:right;" value="#wrk_round(overtime_value_1/60)#" message="#currentrow#. #message#"></div></td>
								<cfsavecontent variable="message">Resmi Tatil Mesai verisini kontrol ediniz</cfsavecontent>
								<td <cfif offtimecat_id eq 1>style="background-color:darkgrey;"<cfelseif listlen(list_paid_offtimecat,',') and listfind(list_paid_offtimecat,offtimecat_id,',')>style="background-color:##3399FF;"<cfelseif listlen(list_rest_offtimecat,',') and listfind(list_rest_offtimecat,offtimecat_id,',')>style="background-color:##339900;"<cfelseif listlen(list_both_offtimecat,',') and listfind(list_both_offtimecat,offtimecat_id,',')>style="background-color:yellow;"</cfif>><div class="form-group"><cfinput type="text" name="holiday_work#currentrow#" id="holiday_work#currentrow#" validate="float" style="width:100px; text-align:right;" value="#wrk_round(overtime_value_2/60)#" message="#currentrow#. #message#"></div></td>
								<cfsavecontent variable="message">OffShore verisini kontrol ediniz</cfsavecontent>
								<td <cfif offtimecat_id eq 1>style="background-color:darkgrey;"<cfelseif listlen(list_paid_offtimecat,',') and listfind(list_paid_offtimecat,offtimecat_id,',')>style="background-color:##3399FF;"<cfelseif listlen(list_rest_offtimecat,',') and listfind(list_rest_offtimecat,offtimecat_id,',')>style="background-color:##339900;"<cfelseif listlen(list_both_offtimecat,',') and listfind(list_both_offtimecat,offtimecat_id,',')>style="background-color:yellow;"</cfif>><div class="form-group"><cfinput type="text" name="offshore#currentrow#" id="offshore#currentrow#" validate="float" style="width:100px; text-align:right;" value="#wrk_round(overtime_value_3/60)#" message="#currentrow#. #message#"></div></td>
								<!---<td>
									<cfif total_min gt 0>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_daily_in_out_history&row_id=#row_id#','wide');"><img src="/images/history.gif"  alt="<cf_get_lang dictionary_id='57473.Tarihçe'>"></a>
									</cfif>
								</td>--->
							</tr>
						</cfoutput>
					</cfif>
				</tbody>
			</cf_grid_list>
			<div class="ui-info-bottom flex-end">
				<cf_workcube_buttons  is_upd='0' add_function='kontrol()'>
			</div>
		</cfform>
	</cf_box>
</div>
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
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus" border="0"></i></a><input type="hidden" name="old_emp_id' + row_count +'" id="old_emp_id' + row_count +'" value=""><input type="hidden" name="row_id' + row_count +'" id="row_id' + row_count +'" value="0"><input type="hidden" name="ewt_id' + row_count +'" id="ewt_id' + row_count +'" value="0">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="in_out_id' + row_count +'" name="in_out_id' + row_count +'" value="in_out_id#currentrow#"><input type="text" id="employee' + row_count +'" name="employee' + row_count +'" style="width:120px;" value="" onfocus="AutoComplete_Create(\'employee'+row_count+'\',\'EMPLOYEE_NAME,EMPLOYEE_SURNAME\',\'FULLNAME\',\'get_in_outs_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID\',\'employee_id'+row_count+',in_out_id'+row_count+'\',\'\',\'3\',\'135\');" autocomplete="off"><span class="input-group-addon icon-ellipsis" onClick="windowopen(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&field_in_out_id=in_out_id'+row_count+'&field_emp_name=employee'+ row_count + '&field_emp_id=employee_id' + row_count + '\' ,\'list\');"></span></div><input type="hidden" id="employee_id' + row_count +'" value="" name="employee_id' + row_count +'"><input type="hidden" value="1" id="row_kontrol_' + row_count +'" name="row_kontrol_' + row_count +'">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="normal_day' + row_count +'" id="normal_day' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_normal_day' + row_count +'" id="old_normal_day' + row_count +'" value="0"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="normal_workhour' + row_count +'" id="normal_workhour' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_normal_workhour' + row_count +'" id="old_normal_workhour' + row_count +'" value="0" onkeyup="change_val(1,' + row_count +');"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="weekend_work' + row_count +'" id="weekend_work' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_weekend_work' + row_count +'" id="old_weekend_work' + row_count +'" value="0" onkeyup="change_val(2,' + row_count +');"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="holiday_work' + row_count +'" id="holiday_work' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_holiday_work' + row_count +'" id="old_holiday_work' + row_count +'" value="0" onkeyup="change_val(3,' + row_count +');"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="offshore' + row_count +'" id="offshore' + row_count +'" style="width:100px;text-align:right;" value="0"><input type="hidden" name="old_offshore' + row_count +'" id="old_offshore' + row_count +'" value="0" onkeyup="change_val(4,' + row_count +');"></div>';
	}
	
	function sil(sy)
	{
		$('#row_kontrol_' + sy).val(0);
		$('#my_row_' +sy).css('display','none');
	}
	
	function kontrol()
	{
		$('#record_num').val(row_count);
		if(record_num == 0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>");
			return false;
		}
	}
</script>
