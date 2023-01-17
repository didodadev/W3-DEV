<cf_get_lang_set module_name="myhome">
<!---<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
--->    <cf_xml_page_edit fuseact="myhome.list_extra_worktimes">
    <cfset Cmp = createObject("component","CustomTags.cfc.get_workcube_process") />
    <cfset Cmp.data_source = dsn />
    <cfset Cmp.process_db = '#dsn_alias#.' />
    <cfparam name="emp_id_list" default="">
    <cfparam name="aydaki_gun_sayisi" default="">
    <cfparam name="attributes.admin1_pos_code" default="">
    <cfparam name="attributes.admin2_pos_code" default="">
    <cfparam name="attributes.admin3_pos_code" default="">
    <cfsavecontent variable="ay1"><cf_get_lang_main no ='180.Ocak'></cfsavecontent>
    <cfsavecontent variable="ay2"><cf_get_lang_main no ='181.Subat'></cfsavecontent>
    <cfsavecontent variable="ay3"><cf_get_lang_main no ='182.Mart'></cfsavecontent>
    <cfsavecontent variable="ay4"><cf_get_lang_main no ='183.Nisan'></cfsavecontent>
    <cfsavecontent variable="ay5"><cf_get_lang_main no ='184.Mayis'></cfsavecontent>
    <cfsavecontent variable="ay6"><cf_get_lang_main no ='185.Haziran'></cfsavecontent>
    <cfsavecontent variable="ay7"><cf_get_lang_main no ='186.Temmuz'></cfsavecontent>
    <cfsavecontent variable="ay8"><cf_get_lang_main no ='187.Agustos'></cfsavecontent>
    <cfsavecontent variable="ay9"><cf_get_lang_main no ='188.Eylül'></cfsavecontent>
    <cfsavecontent variable="ay10"><cf_get_lang_main no ='189.Ekim'></cfsavecontent>
    <cfsavecontent variable="ay11"><cf_get_lang_main no ='190.Kasim'></cfsavecontent>
    <cfsavecontent variable="ay12"><cf_get_lang_main no ='191.Aralik'></cfsavecontent>
    <cfscript>
        ay_list = '#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#';
    </cfscript>
    <cfparam name="attributes.sal_mon" default="#month(now())#">
    <cfparam name="attributes.sal_year" default="#year(now())#">
    <cfquery name="get_emp_pos" datasource="#dsn#">
        SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
    </cfquery>
    <cfset pos_code_list = valuelist(get_emp_pos.position_code)>
    <cfset branch_list = "">
    <!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
    <cfquery name="Get_Offtime_Valid" datasource="#dsn#">
        SELECT
            O.EMPLOYEE_ID,
            EP.POSITION_CODE
        FROM
            OFFTIME O,
            EMPLOYEE_POSITIONS EP
        WHERE
            O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
            O.VALID = 1 AND
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> BETWEEN O.STARTDATE AND O.FINISHDATE
    </cfquery>
    <cfif Get_Offtime_Valid.recordcount>
        <cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
        <cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position1">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position2">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
        </cfoutput>
        <cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
            SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_1 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_2 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#now_offtime_poscode#">) AND CANDIDATE_POS_3 IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
        </cfquery>
        <cfoutput query="Get_StandBy_Position3">
            <cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
        </cfoutput>
    </cfif>
    <cfquery name="get_departments" datasource="#dsn#">
        SELECT
            DEPARTMENT_ID,
            BRANCH_ID
        FROM
            DEPARTMENT
        WHERE
            DEPARTMENT_STATUS = 1
            <cfif len(x_manager_pos_code) and x_manager_pos_code neq session.ep.position_code and not get_module_power_user(48)>
            AND 
            (
            DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)) OR
            ADMIN1_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">) OR
            ADMIN2_POSITION_CODE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#pos_code_list#">)
            )
            </cfif>
    </cfquery>
    <cfif get_departments.recordcount>
        <cfset branch_list = valuelist(get_departments.BRANCH_ID)>
        <cfset dept_list = valuelist(get_departments.DEPARTMENT_ID)>
        
        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and isdefined('attributes.department') and len(attributes.department) and not listfindnocase(dept_list,attributes.department)>
            <script>
                alert('Bu Departmanda Yetkili Değilsiniz!');
                window.location.href='<cfoutput>#request.self#?fuseaction=myhome.list_extra_worktimes</cfoutput>';
            </script>
            <cfabort>
        </cfif>
        
        <cfquery name="GET_BRANCHES" datasource="#DSN#">
            SELECT
                BRANCH_NAME,
                BRANCH_ID
            FROM
                BRANCH
            WHERE
                BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#listremoveDuplicates(branch_list)#">)
            ORDER BY
                BRANCH_NAME
        </cfquery>
    <cfelse>
        <cfset get_branches.recordcount = 0>
    </cfif>
    <cfif isdefined("attributes.is_form_submitted")>
		<cfscript>
            last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon, 1,0,0,0);
            last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon, daysinmonth(last_month_1), 23,59,59);
            aydaki_gun_sayisi = daysinmonth(last_month_1);
            sal_mon_ = attributes.sal_mon;
            sal_year_ = attributes.sal_year;
        </cfscript>
        <cfquery name="get_comp" datasource="#dsn#">
            SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
        </cfquery>
        <cfset attributes.comp_id = get_comp.COMPANY_ID>
        <cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
            SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
        </cfquery>
        <cfquery name="get_saturday_off" datasource="#dsn#">
            SELECT		
                OUR_COMPANY_HOURS.SATURDAY_OFF
            FROM
                OUR_COMPANY_HOURS,
                OUR_COMPANY
            WHERE
                OUR_COMPANY.COMP_ID = OUR_COMPANY_HOURS.OUR_COMPANY_ID
                AND OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
        </cfquery>
    <!--- bu ay içindeki genel tatiller --->
        <cfscript>
            offdays_day_list = '';
            for (ggotrc = 1; ggotrc lte get_GENERAL_OFFTIMES.recordcount; ggotrc=ggotrc+1)
                for (ijklmn = 0; ijklmn lte datediff("d", get_GENERAL_OFFTIMES.start_date[ggotrc], get_GENERAL_OFFTIMES.FINISH_DATE[ggotrc]); ijklmn=ijklmn+1)
                    {
                    tempo_day = date_add("d", ijklmn, get_GENERAL_OFFTIMES.start_date[ggotrc]);
                    offdays_day_list = listappend(offdays_day_list,'#dateformat(tempo_day,"ddmmyyyy")#');
                    }
        </cfscript>
    <!--- // bu ay içindeki genel tatiller --->
        <cfset special_code_ = 'FM#attributes.branch_id#-#attributes.department#-#attributes.sal_year#-#attributes.sal_mon#'>
        <cfquery name="get_my_dep" datasource="#dsn#">
            SELECT 
                DEPARTMENT_ID
            FROM 
                EMPLOYEE_POSITIONS
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                (
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#"> <!--- kendisi bu departmanda ise --->
                OR #attributes.department#IN(SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP,EMPLOYEE_POSITIONS_STANDBY EPS WHERE EP.POSITION_CODE = EPS.POSITION_CODE AND EPS.CANDIDATE_POS_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)<!--- 1.yedek olduğu kişi bu departmanda ise --->
                OR #attributes.department# IN(SELECT EP.DEPARTMENT_ID FROM EMPLOYEE_POSITIONS EP,EMPLOYEE_POSITIONS_STANDBY EPS WHERE EP.POSITION_CODE = EPS.POSITION_CODE AND EPS.CANDIDATE_POS_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)<!--- 2.yedek olduğu kişi bu departmanda ise --->
                )
        </cfquery>
        <cfquery name="get_department_positions" datasource="#DSN#">
            SELECT 
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_ID,
                D.DEPARTMENT_HEAD,
                D.DEPARTMENT_ID,
                B.BRANCH_NAME,
                B.BRANCH_ID,
                EIO.IN_OUT_ID,
                D.ADMIN1_POSITION_CODE,
                D.ADMIN2_POSITION_CODE
            FROM
                EMPLOYEES_IN_OUT EIO,
                EMPLOYEES E,
                DEPARTMENT D,
                BRANCH B
            WHERE
                (EIO.IS_PUANTAJ_OFF = 0 OR EIO.IS_PUANTAJ_OFF IS NULL) AND
                E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
                EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                B.BRANCH_STATUS = 1 AND
                E.EMPLOYEE_STATUS = 1 AND
                E.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = D.ADMIN1_POSITION_CODE) AND
                E.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = D.ADMIN2_POSITION_CODE) AND
                D.BRANCH_ID = B.BRANCH_ID
                    AND
                    EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(last_month_30)#">
                    AND
                    (
                        EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(last_month_1)#"> OR EIO.FINISH_DATE IS NULL
                    )
                    AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
                    AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> 
            ORDER BY
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME
        </cfquery>
        <!--- satirlar doner --->
        <!---<cfform name="add_extra_worktimes" action="#request.self#?fuseaction=myhome.emptypopup_view_extra_worktimes">--->
            <cfif len(get_department_positions.ADMIN1_POSITION_CODE)>
				<cfset pos1 = get_department_positions.ADMIN1_POSITION_CODE>
                <cfset name1 = get_emp_info(get_department_positions.ADMIN1_POSITION_CODE,1,0)>
                <cfset get_Real_Izin = Cmp.get_Real_Izin(
                position_code	: pos1,
                record_date	: now()
                ) />
				<cfif get_Real_Izin.recordcount>
					<cfset get_StandBys = Cmp.get_StandBys(
                    position_code	: pos1
                    ) />
                    <cfset gercek_yaz = 0>
                    <cfset yedek_1_yaz = 0>
                    <cfset yedek_2_yaz = 0>
                    <cfset yedek_3_yaz = 0>
                    <cfif get_standbys.recordcount>
						<cfif len(get_standbys.candidate_pos_1)>
							<cfset get_yedek_1 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_1
                            ) />
                            <cfset get_real_izin_1 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_1,
                            record_date		: now()
                            ) />
                            <cfif not get_real_izin_1.recordcount><cfset yedek_1_yaz = 1></cfif>
                        </cfif>
						<cfif yedek_1_yaz eq 0 and len(get_standbys.candidate_pos_2)>
							<cfset get_yedek_2 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_2
                            ) />
                            <cfset get_real_izin_2 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_2,
                            record_date		: now()
                            ) />
                            <cfif not get_real_izin_2.recordcount><cfset yedek_2_yaz = 1></cfif>
                        </cfif>
						<cfif yedek_1_yaz eq 0 and yedek_2_yaz eq 0 and len(get_standbys.candidate_pos_3)>
							<cfset get_yedek_3 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_3
                            ) />
                            <cfset get_real_izin_3 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_3,
                            record_date		: now()
                            ) />
                            <cfif not get_real_izin_3.recordcount><cfset yedek_3_yaz = 1></cfif>
                        </cfif>
                    <cfelse>
                    	<cfset gercek_yaz = 1>
                    </cfif>
                <cfelse>
                	<cfset gercek_yaz = 1>
                </cfif>
            
				<cfif gercek_yaz eq 1>
					<cfset pos1 = get_department_positions.ADMIN1_POSITION_CODE>
                    <cfset name1 = get_emp_info(get_department_positions.ADMIN1_POSITION_CODE,1,0)>
                <cfelseif yedek_1_yaz eq 1>
					<cfset pos1 = get_yedek_1.POSITION_CODE>
                    <cfset name1 = get_yedek_1.EMPLOYEE_NAME & ' ' & get_yedek_1.EMPLOYEE_SURNAME>
                <cfelseif yedek_2_yaz eq 1>
					<cfset pos1 = get_yedek_2.POSITION_CODE>
                    <cfset name1 = get_yedek_2.EMPLOYEE_NAME & ' ' & get_yedek_2.EMPLOYEE_SURNAME>
                <cfelseif yedek_3_yaz eq 1>
					<cfset pos1 = get_yedek_3.POSITION_CODE>
                    <cfset name1 = get_yedek_3.EMPLOYEE_NAME & ' ' & get_yedek_3.EMPLOYEE_SURNAME>
                </cfif>	
            <cfelse>
				<cfset pos1 = "">
                <cfset name1 = "">
            </cfif>
        
            <cfif len(get_department_positions.ADMIN2_POSITION_CODE)>
				<cfset pos2 = get_department_positions.ADMIN2_POSITION_CODE>
                <cfset name2 = get_emp_info(get_department_positions.ADMIN2_POSITION_CODE,1,0)>
                <cfset get_Real_Izin = Cmp.get_Real_Izin(
                position_code	: pos2,
                record_date	: now()
                ) />
				<cfif get_Real_Izin.recordcount>
					<cfset get_StandBys = Cmp.get_StandBys(
                    position_code	: pos2
                    ) />
                    <cfset gercek_yaz = 0>
                    <cfset yedek_1_yaz = 0>
                    <cfset yedek_2_yaz = 0>
                    <cfset yedek_3_yaz = 0>
					<cfif get_standbys.recordcount>
						<cfif len(get_standbys.candidate_pos_1)>
							<cfset get_yedek_1 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_1
                            ) />
							<cfset get_real_izin_1 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_1,
                            record_date		: now()
                            ) />
                        	<cfif not get_real_izin_1.recordcount><cfset yedek_1_yaz = 1></cfif>
                        </cfif>
						<cfif yedek_1_yaz eq 0 and len(get_standbys.candidate_pos_2)>
							<cfset get_yedek_2 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_2
                            ) />
                            <cfset get_real_izin_2 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_2,
                            record_date		: now()
                            ) />
                            <cfif not get_real_izin_2.recordcount><cfset yedek_2_yaz = 1></cfif>
                        </cfif>
						<cfif yedek_1_yaz eq 0 and yedek_2_yaz eq 0 and len(get_standbys.candidate_pos_3)>
							<cfset get_yedek_3 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_3
                            ) />
                            <cfset get_real_izin_3 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_3,
                            record_date		: now()
                            ) />
                            <cfif not get_real_izin_3.recordcount><cfset yedek_3_yaz = 1></cfif>
                        </cfif>
                    <cfelse>
                    	<cfset gercek_yaz = 1>
                    </cfif>
                <cfelse>
                	<cfset gercek_yaz = 1>
                </cfif>
            
				<cfif gercek_yaz eq 1>
					<cfset pos2 = get_department_positions.ADMIN2_POSITION_CODE>
                    <cfset name2 = get_emp_info(get_department_positions.ADMIN2_POSITION_CODE,1,0)>
                <cfelseif yedek_1_yaz eq 1>
					<cfset pos2 = get_yedek_1.POSITION_CODE>
                    <cfset name2 = get_yedek_1.EMPLOYEE_NAME & ' ' & get_yedek_1.EMPLOYEE_SURNAME>
                <cfelseif yedek_2_yaz eq 1>
					<cfset pos2 = get_yedek_2.POSITION_CODE>
                    <cfset name2 = get_yedek_2.EMPLOYEE_NAME & ' ' & get_yedek_2.EMPLOYEE_SURNAME>
                <cfelseif yedek_3_yaz eq 1>
					<cfset pos2 = get_yedek_3.POSITION_CODE>
                    <cfset name2 = get_yedek_3.EMPLOYEE_NAME & ' ' & get_yedek_3.EMPLOYEE_SURNAME>
                </cfif>	
            <cfelse>
				<cfset pos2 = "">
                <cfset name2 = "">
            </cfif>
        
            <cfif len(x_manager_pos_code)>
				<cfset pos3 = x_manager_pos_code>
                <cfset name3 = get_emp_info(x_manager_pos_code,1,0)>
                <cfset get_Real_Izin = Cmp.get_Real_Izin(
                position_code	: pos3,
                record_date	: now()
                ) />
				<cfif get_Real_Izin.recordcount>
					<cfset get_StandBys = Cmp.get_StandBys(
                    position_code	: pos3
                    ) />
                    <cfset gercek_yaz = 0>
                    <cfset yedek_1_yaz = 0>
                    <cfset yedek_2_yaz = 0>
                    <cfset yedek_3_yaz = 0>
                    <cfif get_standbys.recordcount>
						<cfif len(get_standbys.candidate_pos_1)>
							<cfset get_yedek_1 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_1
                            ) />
                            <cfset get_real_izin_1 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_1,
                            record_date		: now()
                            ) />
                            <cfif not get_real_izin_1.recordcount><cfset yedek_1_yaz = 1></cfif>
                        </cfif>
						<cfif yedek_1_yaz eq 0 and len(get_standbys.candidate_pos_2)>
							<cfset get_yedek_2 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_2
                            ) />
                            <cfset get_real_izin_2 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_2,
                            record_date		: now()
                            ) />
                            <cfif not get_real_izin_2.recordcount><cfset yedek_2_yaz = 1></cfif>
                        </cfif>
						<cfif yedek_1_yaz eq 0 and yedek_2_yaz eq 0 and len(get_standbys.candidate_pos_3)>
							<cfset get_yedek_3 = Cmp.get_Yedek(
                            position_code	: get_standbys.candidate_pos_3
                            ) />
                            <cfset get_real_izin_3 = Cmp.get_Real_Izin(
                            position_code	: get_standbys.candidate_pos_3,
                            record_date		: now()
                            ) />
                            <cfif not get_real_izin_3.recordcount><cfset yedek_3_yaz = 1></cfif>
                        </cfif>
                    <cfelse>
                    	<cfset gercek_yaz = 1>
                    </cfif>
                <cfelse>
                	<cfset gercek_yaz = 1>
                </cfif>
            
				<cfif gercek_yaz eq 1>
					<cfset pos3 = x_manager_pos_code>
                    <cfset name3 = get_emp_info(x_manager_pos_code,1,0)>
                <cfelseif yedek_1_yaz eq 1>
					<cfset pos3 = get_yedek_1.POSITION_CODE>
                    <cfset name3 = get_yedek_1.EMPLOYEE_NAME & ' ' & get_yedek_1.EMPLOYEE_SURNAME>
                <cfelseif yedek_2_yaz eq 1>
					<cfset pos3 = get_yedek_2.POSITION_CODE>
                    <cfset name3 = get_yedek_2.EMPLOYEE_NAME & ' ' & get_yedek_2.EMPLOYEE_SURNAME>
                <cfelseif yedek_3_yaz eq 1>
					<cfset pos3 = get_yedek_3.POSITION_CODE>
                    <cfset name3 = get_yedek_3.EMPLOYEE_NAME & ' ' & get_yedek_3.EMPLOYEE_SURNAME>
                </cfif>	
            <cfelse>
				<cfset pos3 = "">
                <cfset name3 = "">
            </cfif>
            <cfquery name="get_cont_record" datasource="#dsn#">
                SELECT TOP 1 
                    EEW.VALID,
                    EEW.VALID_1,
                    EEW.VALID_2,
                    EEW.VALID_3,
                    EEW.VALID_EMPLOYEE_ID_1,
                    EEW.VALID_EMPLOYEE_ID_2,
                    EEW.VALID_EMPLOYEE_ID_3,
                    EEW.VALID_EMPLOYEE_ID,
                    EEW.VALIDATOR_POSITION_CODE,
                    EEW.VALIDATOR_POSITION_CODE_1,
                    EEW.VALIDATOR_POSITION_CODE_2,
                    EEW.VALIDATOR_POSITION_CODE_3,
                    EIO.DEPARTMENT_ID
                FROM 
                    EMPLOYEES_EXT_WORKTIMES EEW,
                    EMPLOYEES_IN_OUT EIO
                WHERE 
                    EIO.IN_OUT_ID = EEW.IN_OUT_ID AND
                    MONTH(EEW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_mon_#"> AND 
                    YEAR(EEW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year_#"> AND
                    EEW.SPECIAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#special_code_#">
            </cfquery>
            <cfset attributes.type = -1>
            <cfif get_module_power_user(48) or (get_my_dep.recordcount eq 1 and not get_cont_record.recordcount) or (get_my_dep.recordcount eq 1 and get_cont_record.recordcount and not len(get_cont_record.VALID_1) and not len(get_cont_record.VALID_2) and not len(get_cont_record.VALID_3) and not len(get_cont_record.VALID))>
                <cfset attributes.type = 0>
            </cfif>
            <cfif get_cont_record.recordcount and listfind(pos_code_list,get_cont_record.VALIDATOR_POSITION_CODE_2) and len(get_cont_record.VALID_1) and not len(get_cont_record.VALID_2) and not len(get_cont_record.VALID_3) and not len(get_cont_record.VALID)>
                <cfset attributes.type = 2>
            <cfelseif get_cont_record.recordcount and listfind(pos_code_list,get_cont_record.VALIDATOR_POSITION_CODE_3) and len(get_cont_record.VALID_1) and len(get_cont_record.VALID_2) and not len(get_cont_record.VALID_3) and not len(get_cont_record.VALID)>
                <cfset attributes.type = 3>
            <cfelseif get_cont_record.recordcount and len(get_cont_record.VALID_1) and len(get_cont_record.VALID_2) and len(get_cont_record.VALID_3) and not len(get_cont_record.VALID) and get_module_power_user(48)>
                <cfset attributes.type = 4>
            <cfelseif get_cont_record.recordcount and len(get_cont_record.VALID)>
                <cfset attributes.type = 5>
            </cfif> 
            <cfset attributes.deny_type = 0>
            <cfif get_cont_record.recordcount and listfind(pos_code_list,get_cont_record.VALIDATOR_POSITION_CODE_1) and not len(get_cont_record.VALID_2) and not len(get_cont_record.VALID_3) and not len(get_cont_record.VALID)>
                <cfset attributes.deny_type = 1>
            </cfif>                                             
       <!--- </cfform>--->
    </cfif>
<!---</cfif>--->
<script type="text/javascript">
	function get_first_value(deger_,row,col)
	{
		if(deger_ == '')
			deger_ = 0;
		my_temp_deger = deger_;
	}
	function get_value(deger,row_,col_)
	{
		if(deger == '')
			deger = 0;
		//satır toplam için
		if(arguments[2]!=null)
		{
			ilk_deger = parseInt(document.getElementById('satir_toplam_'+row_).innerHTML);
			var toplam = parseInt(deger) + parseInt(ilk_deger);
			toplam = parseInt(toplam) - parseInt(my_temp_deger);
			document.getElementById('satir_toplam_'+row_).innerHTML = toplam;
		}
		//genel toplam
		if(arguments[2]!=null)
		{
			var genel_toplam = parseInt(document.getElementById('dikey_toplam_').innerHTML);
			genel_toplam = parseInt(deger) + genel_toplam ;
			genel_toplam = parseInt(genel_toplam) - parseInt(my_temp_deger);
			document.getElementById('dikey_toplam_').innerHTML = genel_toplam;
		}
		//dikey toplam
		if(arguments[2]!=null)
		{
			ilk_dikey_deger = parseInt(document.getElementById('gun_'+col_).innerHTML);
			var toplam = parseInt(deger) + parseInt(ilk_dikey_deger);
			toplam = parseInt(toplam) - parseInt(my_temp_deger);
			document.getElementById('gun_'+col_).innerHTML = toplam;
		}
		//gece mesai toplam
		if(arguments[2]==null)
		{
			var gece_mesai = parseInt(document.getElementById('gece_mesai_').innerHTML);
			gece_mesai = parseInt(deger) + gece_mesai;
			gece_mesai = parseInt(gece_mesai) - parseInt(my_temp_deger);
			document.getElementById('gece_mesai_').innerHTML = gece_mesai;
		}
	}
	function send_delete()
	{
		document.add_extra_worktimes.is_del.value = '1';
	}
	function send_deny()
	{
		document.add_extra_worktimes.is_add.value = '0';
		document.add_extra_worktimes.type.value = '1';
	}
	function kontrol_extra_time()
	{
		if(document.getElementById('branch_id').value == '')
		{
			alert('<cf_get_lang_main no="1167.Lütfen Şube Seçiniz">');
			return false;
		}	
		if(document.getElementById('department').value == '')
		{
			alert('<cf_get_lang_main no="1424.Lütfen Departman Seçiniz">');
			return false;
			}
		return true;
	}
	function showDepartment(branch_id)	
	{
		if (arguments[0]==null)
			{
			var branch_id_ = document.getElementById('branch_id').value;
			}
		else
			{
			var branch_id_ = branch_id;
			}
		if (branch_id_ != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_hr&self_department_control=1&x_manager_pos_code=<cfoutput>#x_manager_pos_code#</cfoutput>&branch_id="+branch_id_;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'Iliskili Departmanlar');
		}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_extra_worktimes';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_extra_worktimes.cfm';
	
	WOStruct['#attributes.fuseaction#']['viewOther'] = structNew();
	WOStruct['#attributes.fuseaction#']['viewOther']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['viewOther']['fuseaction'] = 'myhome.list_extra_worktimes';
	WOStruct['#attributes.fuseaction#']['viewOther']['filePath'] = 'myhome/query/view_extra_worktimes.cfm';
	WOStruct['#attributes.fuseaction#']['viewOther']['queryPath'] = 'myhome/query/view_extra_worktimes.cfm';
	WOStruct['#attributes.fuseaction#']['viewOther']['nextEvent'] = 'myhome.list_extra_worktimes';
	
</cfscript>
