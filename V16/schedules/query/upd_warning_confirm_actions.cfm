<!--- FBS 20120622 Onaylarimdan Secilen Onay ve Redlerin Ilgili Tablolarda Asama Guncellemesi Yapmasi Icin Olusturulmustur --->

<!--- Sonraki Asama Kontrolleri Icin Cfc --->
<cfset Cmp = createObject("component","CustomTags.cfc.get_workcube_process") />
<cfset Cmp.module_type = "e" />
<cfset Cmp.process_db = dsn&".">
<cfset Cmp.lang = "tr">
<cfset data_source = dsn>
<!--- //Sonraki Asama Kontrolleri Icin Cfc --->

<cfquery name="get_warnings_actions" datasource="#dsn#">
	SELECT
		PWA.ID,
		PWA.WARNING_ID,
		PWA.URL_LINK,
		PWA.WARNING_DESCRIPTION,
		PWA.ACTION_DB,
		PWA.ACTION_TABLE,
		PWA.ACTION_COLUMN,
		PWA.ACTION_STAGE_COLUMN,
		PWA.ACTION_STAGE_ID,
		PWA.ACTION_ID,
		PWA.OUR_COMPANY_ID,
		PWA.PERIOD_ID,
		PWA.IS_CONFIRM,
		PWA.CONFIRM_POSITION_CODE,
		PWA.RECORD_DATE,
		PWA.RECORD_EMP,
		PWA.RECORD_IP,
		MS.TIME_ZONE,
		OC.COMPANY_NAME,
		OC.NICK_NAME,
		OC.EMAIL,
		SP.OTHER_MONEY,
		SP.PERIOD_YEAR,
		SM.MONEY SYSTEM_MONEY,
		EP.EMPLOYEE_ID CONFIRM_EMPLOYEE_ID,
		EP.EMPLOYEE_NAME CONFIRM_NAME,
		EP.EMPLOYEE_SURNAME CONFIRM_SURNAME,
		EP.POSITION_NAME CONFIRM_POSITION_NAME			
	FROM
		PAGE_WARNINGS_ACTIONS PWA
		LEFT JOIN MY_SETTINGS MS ON MS.EMPLOYEE_ID = PWA.RECORD_EMP
		LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = PWA.OUR_COMPANY_ID
		LEFT JOIN SETUP_PERIOD SP ON SP.PERIOD_ID = PWA.PERIOD_ID
		LEFT JOIN SETUP_MONEY SM ON SM.PERIOD_ID = PWA.PERIOD_ID AND SP.OUR_COMPANY_ID = PWA.OUR_COMPANY_ID AND SM.RATE1 = SM.RATE2
		LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = PWA.CONFIRM_POSITION_CODE
	WHERE
		PWA.IS_CONFIRM IS NOT NULL
	ORDER BY
		PWA.RECORD_DATE DESC
</cfquery>

<cflock timeout="1000">
<cftransaction>
	<cfoutput query="get_warnings_actions">
		<cfset data_source = ListFirst(action_db,".")>
		<cfset Cmp.data_source = data_source />

		<cfset dsn1 = "#dsn#_product">
		<cfset dsn3 = "#dsn#_#get_warnings_actions.our_company_id#">
		<cfset dsn2 = "#dsn#_#year(now())#_#get_warnings_actions.our_company_id#">
		<cfset dsn1_alias = "#dsn1#">
		<cfset dsn3_alias = "#dsn3#">
		<cfset dsn2_alias = "#dsn2#">
		
		<!--- Sonraki Asama Kontrolleri Icin Surec CustomTag Icerisindeki Queryler Cagrilir --->
		<cfset get_ProcessType = Cmp.get_ProcessType(
			our_company_id	: get_warnings_actions.our_company_id,
			fuseaction		: ListFirst(ListGetAt(get_warnings_actions.url_link,2,'='),'&')
			) />
		<cfset get_Faction = Cmp.get_Faction(
			position_code		: get_warnings_actions.confirm_position_code,
			extra_process_row_id = -1
			) />
		<cfset get_Line_Number = Cmp.get_Line_Number(
				select_value	: get_warnings_actions.action_stage_id
				) />
		<!--- //Sonraki Asama Kontrolleri Icin Surec CustomTag Icerisindeki Queryler Cagrilir --->
		<cfif get_Faction.RecordCount>
			<cfquery name="get_Next_Process_Rows" datasource="#data_source#">
				SELECT
					PROCESS_ROW_ID,
					LINE_NUMBER
				FROM
					#dsn#.PROCESS_TYPE_ROWS
				WHERE
					PROCESS_ROW_ID IN (#ValueList(get_Faction.Process_Row_Id)#) AND
					IS_CONFIRM = #is_confirm# AND
					LINE_NUMBER > #get_Line_Number.Line_Number#
				ORDER BY
					LINE_NUMBER
			</cfquery>
			<cfif get_Next_Process_Rows.RecordCount>
				<cfset action_table_history = "">
				<cfset action_table_row = "">
				<cfset action_table_row_column = "">
				<cfset action_table_row_history = "">
				<cfset action_table_row_history_column = "">
				<cfset action_add_column_name = "">
				<cfset action_add_column_value = "">
				<cfset action_row_add_column_name = "">
				<cfset action_row_add_column_value = "">
				<!--- Ilgili Belge Guncellenmeden Once, History Kaydi Atilir --->
				<cfif action_table is 'INTERNALDEMAND'>
					<cfset action_table_history = "INTERNALDEMAND_HISTORY">
					<cfset action_table_row = "INTERNALDEMAND_ROW">
					<cfset action_table_row_column = "I_ID">
					<cfset action_table_row_history = "INTERNALDEMAND_ROW_HISTORY">
					<cfset action_table_row_history_column = "I_HISTORY_ID">
					<cfset action_add_column_name = "UPDATE_EMP,UPDATE_DATE">
					<cfset action_add_column_value = "#record_emp#,#CreateOdbcDateTime(record_date)#">
					<cfset action_row_add_column_name = "INTERNAL_HISTORY_ID">
				<cfelseif action_table is 'OFFER'>
					<cfset action_table_history = "OFFER_HISTORY">
					<cfset action_table_row = "OFFER_ROW">
					<cfset action_table_row_column = "OFFER_ID">
					<cfset action_table_row_history = "OFFER_ROW_HISTORY">
					<cfset action_table_row_history_column = "O_HISTORY_ID">
					<cfset action_add_column_name = "RECORD_EMP,RECORD_DATE,RECORD_IP">
					<cfset action_add_column_value = "#record_emp#,#CreateOdbcDateTime(record_date)#,#record_ip#">
					<cfset action_row_add_column_name = "OFFER_HISTORY_ID">
				<cfelseif action_table is 'ORDERS'>
					<cfset action_table_history = "ORDERS_HISTORY">
					<cfset action_table_row = "ORDER_ROW">
					<cfset action_table_row_column = "ORDER_ID">
					<cfset action_table_row_history = "ORDER_ROW_HISTORY">
					<cfset action_table_row_history_column = "ORDER_HISTORY_ID">
					<cfset action_add_column_name = "RECORD_EMP,RECORD_DATE,RECORD_IP">
					<cfset action_add_column_value = "#record_emp#,#CreateOdbcDateTime(record_date)#,#record_ip#">
					<cfset action_row_add_column_name = "ORDER_HISTORY_ID">
				</cfif>
				<cfif Len(action_table_history)>					
					<!--- History Belge --->
					<cf_wrk_get_history 
						datasource			= "#data_source#"
						source_table		= "#action_table#"
						target_table		= "#action_table_history#"
						insert_column_name	= "#action_add_column_name#"
						insert_column_value	= "#action_add_column_value#"
						record_name			= "#action_column#"
						record_id			= "#action_id#">
						
					<cfif Len(action_table_row_history)>
						<!--- History Satir --->
						<cf_wrk_get_history 
							datasource			= "#data_source#"
							source_table		= "#action_table_row#"
							target_table		= "#action_table_row_history#"
							record_name			= "#action_table_row_column#"
							record_id			= "#action_id#">
						
						<cfif Len(action_row_add_column_name)><!--- Max_History_Id Degeri Bulunur --->
							<cfquery name="Get_Actions_Row" datasource="#data_source#">
								SELECT MAX(#action_row_add_column_name#) MAX_HISTORY_ID FROM #action_table_history# WHERE #action_column# = #action_id#
							</cfquery>
							<cfset action_row_add_column_value = Get_Actions_Row.Max_History_Id>
							<cfif Len(action_row_add_column_value)>
								<cfquery name="Upd_History_Id" datasource="#data_source#"><!--- Row Tablosunda History_Id Atanir --->
									UPDATE #action_table_row_history# SET #action_table_row_history_column# = #action_row_add_column_value# WHERE #action_table_row_column# = #action_id# AND #action_table_row_history_column# IS NULL
								</cfquery>
							</cfif>
						</cfif>	
							
					</cfif>
				</cfif>
				<!--- //Ilgili Belge Guncellenmeden Once, History Kaydi Atilir --->
				
				<!--- Ilgili Belgenin Asamasi Guncellenir --->
				<cfquery name="Upd_Actions" datasource="#data_source#">
					UPDATE
						#action_db#.#action_table#
					SET
						#action_stage_column# = #get_Next_Process_Rows.Process_Row_Id#,
						<cfif action_table is not "INTERNALDEMAND">UPDATE_IP = '#record_ip#',</cfif>
						<cfif action_table is 'OFFER'>UPDATE_MEMBER<cfelse>UPDATE_EMP</cfif> = #record_emp#,
						UPDATE_DATE = #CreateOdbcDateTime(record_date)#
					WHERE
						#action_column# = #action_id#
				</cfquery>
				
				<!--- Uyari Pasife Alinir ve Onay/Red Bilgisi Guncellenir --->
				<cfquery name="Upd_Warnings" datasource="#data_source#">
					UPDATE
						#dsn#.PAGE_WARNINGS
					SET
						IS_ACTIVE = 0,
						IS_CONFIRM = #is_confirm#,
						CONFIRM_RESULT = #get_Next_Process_Rows.Process_Row_Id#
					WHERE
						W_ID = #get_warnings_actions.warning_id#
				</cfquery>
				
					<!--- workcube_process te kullanildigi icin gonderiyoruz --->
					<cfset module_type = "e">
					<cfset my_our_company_id_ = get_warnings_actions.our_company_id>
					<cfset lang = "tr">
					<cfset session_position_code = get_warnings_actions.confirm_position_code>
					<cfset session_period_id = get_warnings_actions.period_id>
					<cfset my_our_company_name_ = get_warnings_actions.company_name>
					<cfset my_our_company_email_ = get_warnings_actions.email>
					<cfset session_time_zone = get_warnings_actions.time_zone>
					
					<!--- Filelarda kullanilma ihtimaline karsi ekleniyor --->
					<cfset session.ep.userid = get_warnings_actions.confirm_employee_id>
					<cfset session.ep.position_code = session_position_code>
					<cfset session.ep.position_name = get_warnings_actions.confirm_position_name>
					<cfset session.ep.name = get_warnings_actions.confirm_name>
					<cfset session.ep.surname = get_warnings_actions.confirm_surname>
					<cfset session.ep.period_id = session_period_id>
					<cfset session.ep.period_year = get_warnings_actions.period_year>
					<cfset session.ep.company_id = my_our_company_id_>
					<cfset session.ep.company = my_our_company_name_>
					<cfset session.ep.company_nick = get_warnings_actions.nick_name>
					<cfset session.ep.company_email = my_our_company_email_>
					<cfset session.ep.time_zone = session_time_zone>
					<cfset session.ep.money = get_warnings_actions.system_money>
					<cfset session.ep.money2 = get_warnings_actions.other_money>
					<cfset session.ep.language = lang>
					<cfquery name="Get_Our_Company_Info" datasource="#data_source#">
						SELECT SPECT_TYPE FROM #dsn#.OUR_COMPANY_INFO WHERE COMP_ID = #my_our_company_id_#
					</cfquery>
					<cfset session.ep.our_company_info.spect_type = Get_Our_Company_Info.Spect_Type>
					
				
				<cf_workcube_process
					is_upd				= "1"
					data_source			= "#data_source#"
					old_process_line	= "#get_Line_Number.Line_Number#"
					process_stage		= "#get_Next_Process_Rows.Process_Row_Id#"
					record_member		= "#record_emp#"
					record_date			= "#CreateOdbcDateTime(record_date)#"
					action_table		= "#action_table#"
					action_column		= "#action_column#"
					action_id			= "#action_id#"
					action_page			= "#get_warnings_actions.url_link#"
					warning_description	= "#get_warnings_actions.warning_description#">
			</cfif>
		</cfif>
	</cfoutput>
	<!--- Donen Butun Degerler Temizlenir --->
	<cfquery name="Upd_Warnings_Actions" datasource="#data_source#">			
		DELETE FROM #dsn#.PAGE_WARNINGS_ACTIONS WHERE IS_CONFIRM IS NOT NULL
	</cfquery>
</cftransaction>
</cflock>
