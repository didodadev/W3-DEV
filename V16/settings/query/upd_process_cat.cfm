<cfquery name="Get_Process_File_Control" datasource="#dsn3#">
	SELECT ACTION_FILE_NAME, ACTION_FILE_SERVER_ID,	ACTION_FILE_FROM_TEMPLATE,DISPLAY_FILE_NAME,DISPLAY_FILE_SERVER_ID,DISPLAY_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE ISNULL(ACTION_FILE_FROM_TEMPLATE,0)=0 AND PROCESS_CAT_ID = #attributes.process_cat_id#
</cfquery>
<!--- Eski dosyanin silinmesi --->
<cfif isDefined("attributes.action_file_del") and attributes.action_file_del eq 1>
	<cfif len(Get_Process_File_Control.action_file_name)>
		<cf_del_server_file output_file="settings/#Get_Process_File_Control.action_file_name#" output_server="#Get_Process_File_Control.action_file_server_id#">
	</cfif>
</cfif>
<!--- Action File Upload --->
<cfif isdefined('attributes.action_file_name') and len(attributes.action_file_name) and isdefined('attributes.action_file_name_template') and not len(attributes.action_file_name_template)>
	<cftry>
		<cffile action = "upload" filefield = "action_file_name" destination = "#upload_folder#settings#dir_seperator#" nameconflict = "MakeUnique" mode="777">
		<cfset action_file_name = createUUID() & '.' & cffile.serverfileext>
		<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##action_file_name#">
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no ='2517.Action Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	<cfif len(Get_Process_File_Control.action_file_name)>
		<cf_del_server_file output_file="settings/#Get_Process_File_Control.action_file_name#" output_server="#Get_Process_File_Control.action_file_server_id#">
	</cfif>
</cfif>
<cfif isDefined("attributes.display_file_del") and attributes.display_file_del eq 1>
	<!--- Eski dosyanin silinmesi --->
	<cfif len(Get_Process_File_Control.display_file_name)>
		<cf_del_server_file output_file="settings/#Get_Process_File_Control.display_file_name#" output_server="#Get_Process_File_Control.display_file_server_id#">
	</cfif>
</cfif>
<!--- Display File Upload --->
<cfif isdefined('attributes.display_file_name') and len(attributes.display_file_name) and isdefined('attributes.display_file_name_template') and not len(attributes.display_file_name_template)>
	<cftry>
		<cffile action = "upload" filefield = "display_file_name" destination = "#upload_folder#settings#dir_seperator#" nameconflict = "MakeUnique" mode="777">
		<cfset display_file_name = createUUID() & '.' & #cffile.serverfileext#>
		<cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##display_file_name#">
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no ='2518.Display Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	<cfif len(Get_Process_File_Control.display_file_name)>
		<cf_del_server_file output_file="settings/#Get_Process_File_Control.display_file_name#" output_server="#Get_Process_File_Control.display_file_server_id#">
	</cfif>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfset df_flag = 0><!--- 20041227 devam edecek ellemeyin --->
		<cfif isdefined("attributes.is_default")>
			<cfquery name="upd_process_for_default" datasource="#dsn3#">
			UPDATE 
				SETUP_PROCESS_CAT
			SET
				IS_DEFAULT=0
			WHERE
				PROCESS_MODULE = #attributes.MODULE_ID#
				<cfif listfind('51,54,55,59,60,61,63,591',attributes.PROCESS_TYPE,',')><!--- alis faturalari --->
					AND PROCESS_TYPE IN (51,54,55,59,60,61,63,591)
				<cfelseif listfind('50,52,53,56,57,58,62,531',attributes.PROCESS_TYPE,',')><!--- satis faturalari --->
					AND PROCESS_TYPE IN (50,52,53,56,57,58,62,531)
				<cfelseif listfind('73,74,75,76,77',attributes.PROCESS_TYPE,',')><!--- alis irsaliyeleri --->
					AND PROCESS_TYPE IN (73,74,75,76,77)
				<cfelseif listfind('70,71,72,78,79,88',attributes.PROCESS_TYPE,',')><!--- satis irsaliyeleri --->
					AND PROCESS_TYPE IN (70,71,72,78,79,88)
				<cfelseif listfind('140,141',attributes.PROCESS_TYPE,',')><!--- servis irsaliyeleri --->
					AND PROCESS_TYPE IN (140,141)
				<cfelse>
					<!--- 	Ozel Durumlar veya Birden Fazla Islem Tipinin Kendi Icindeki Kontrolleri Icin Yukaridaki Gibi Yazilir, 
							Digerleri Icin Kendi Tipleri Icinde Kontrol Edilmesi Yeterli FBS 20121224
					--->
					AND PROCESS_TYPE = #attributes.PROCESS_TYPE#
				</cfif>
			</cfquery>
			<cfset df_flag = 1>
		</cfif>
		<cfquery name="upd_process_cat" datasource="#dsn3#">
			UPDATE 
				SETUP_PROCESS_CAT
			SET
				PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PROCESS_CAT#">,
				<cfif isdefined('attributes.PROCESS_TYPE') and len(attributes.PROCESS_TYPE)>PROCESS_TYPE = #attributes.PROCESS_TYPE#,</cfif>
				PROCESS_MODULE = #MODULE_ID#,
				IS_CARI = <cfif isdefined("attributes.is_cari")>1<cfelse>0</cfif>,
				IS_ACCOUNT = <cfif isdefined("attributes.is_account")>1<cfelse>0</cfif>,
				IS_DEFAULT = <cfif isdefined("attributes.is_default")>1<cfelse>0</cfif>,
				IS_DISCOUNT = <cfif isdefined("attributes.is_discount")>1<cfelse>0</cfif>,
				IS_BUDGET = <cfif isdefined("attributes.is_budget")>1<cfelse>0</cfif>,
				IS_COST = <cfif isdefined("attributes.is_cost")>1<cfelse>0</cfif>,
				IS_STOCK_ACTION = <cfif isdefined("attributes.is_stock_action")>1<cfelse>0</cfif>,
				IS_ZERO_STOCK_CONTROL = <cfif isdefined("attributes.is_zero_stock_control")>1<cfelse>0</cfif>,
				IS_ACCOUNT_GROUP = <cfif session.ep.our_company_info.is_edefter and listFind('240,253,310,320,2410,410,420',attributes.PROCESS_TYPE) eq 1>0<cfelseif isdefined("attributes.is_account_group")>1<cfelse>0</cfif>,
				IS_PARTNER = <cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				IS_PUBLIC = <cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				IS_PROJECT_BASED_ACC = <cfif isdefined("attributes.is_project_based_acc")>1<cfelse>0</cfif>,
				IS_PROJECT_BASED_BUDGET = <cfif isdefined("attributes.is_project_based_budget")>1<cfelse>0</cfif>,
				IS_CHEQUE_BASED_ACTION = <cfif isdefined("attributes.is_cheque_based_action")>1<cfelse>0</cfif>,
				IS_CHEQUE_BASED_ACC_ACTION = <cfif isdefined("attributes.is_cheque_based_acc_action")>1<cfelse>0</cfif>,
				IS_UPD_CARI_ROW = <cfif isdefined("attributes.is_upd_cari_row")>1<cfelse>0</cfif>,
				IS_DUE_DATE_BASED_CARI = <cfif isdefined("attributes.is_due_date_based_cari")>1<cfelse>0</cfif>,
				IS_COST_ZERO_ROW = <cfif isdefined("attributes.is_cost_zero_row")>1<cfelse>0</cfif>,
				IS_COST_FIELD = <cfif isdefined("attributes.is_cost_field")>1<cfelse>0</cfif>,
				IS_PAYMETHOD_BASED_CARI = <cfif isdefined("attributes.is_paymethod_based_cari")>1<cfelse>0</cfif>,
				IS_EXP_BASED_ACC = <cfif isdefined("attributes.is_exp_based_acc")>1<cfelse>0</cfif>,
				IS_PROD_COST_ACC_ACTION = <cfif isdefined("attributes.is_prod_cost_acc_action")>1<cfelse>0</cfif>,
				IS_ADD_INVENTORY = <cfif isdefined("attributes.is_add_inventory")>1<cfelse>0</cfif>,
				IS_DEPT_BASED_ACC = <cfif isdefined("attributes.is_dept_based_acc")>1<cfelse>0</cfif>,
				IS_ROW_PROJECT_BASED_CARI = <cfif isdefined("attributes.is_row_project_based_cari")>1<cfelse>0</cfif>,
				IS_EXPORT_REGISTERED = <cfif isdefined("attributes.is_export_registered")>1<cfelse>0</cfif>,
				IS_EXPORT_PRODUCT = <cfif isdefined("attributes.is_export_product")>1<cfelse>0</cfif>,
				IS_INWARD_PROCESSING = <cfif isdefined("attributes.is_inward_processing")>1<cfelse>0</cfif>,
				ACCOUNT_TYPE_ID = <cfif isdefined('attributes.account_type_id') and len(attributes.account_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_type_id#"><cfelse>NULL</cfif>,
				IS_PROCESS_CURRENCY = <cfif isdefined("attributes.is_process_currency")>1<cfelse>0</cfif>,
				IS_LOT_NO = <cfif isdefined("attributes.is_lot_no")>1<cfelse>0</cfif>,
				IS_EXPENSING_TAX = <cfif isdefined("attributes.is_expensing_tax")>1<cfelse>0</cfif>,
				IS_EXPENSING_OIV = <cfif isdefined("attributes.is_expensing_oiv")>1<cfelse>0</cfif>,
				IS_EXPENSING_OTV = <cfif isdefined("attributes.is_expensing_otv")>1<cfelse>0</cfif>,
				NEXT_PERIODS_ACCRUAL_ACTION = <cfif isdefined("attributes.next_periods_accrual_action")>1<cfelse>0</cfif>,
				ACCRUAL_BUDGET_ACTION = <cfif isdefined("attributes.accrual_budget_action")>1<cfelse>0</cfif>,
				IS_BUDGET_RESERVED_CONTROL = <cfif isdefined("attributes.budget_reserved_control")>1<cfelse>0</cfif>,
				IS_EXPENSING_BSMV = <cfif isdefined("attributes.is_expensing_bsmv")>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.action_file_name_template') and len(attributes.action_file_name_template)> <!--- sisteme kayıtlı template dosyalardan eklenmisse --->
					ACTION_FILE_NAME = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#action_file_name_template#">,
					ACTION_FILE_SERVER_ID = #fusebox.server_machine#,
					ACTION_FILE_FROM_TEMPLATE = 1,
				<cfelseif (isdefined('attributes.action_file_name') and len(attributes.action_file_name)) or (isdefined('attributes.display_action_file') and len(attributes.display_action_file))>
					<cfif isdefined('attributes.action_file_name') and len(attributes.action_file_name)>
						ACTION_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#action_file_name#">,
					<cfelse>
						ACTION_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#display_action_file#">,
					</cfif>
					ACTION_FILE_SERVER_ID = #fusebox.server_machine#,
					ACTION_FILE_FROM_TEMPLATE = NULL,
				<cfelse>
					ACTION_FILE_NAME = NULL,
					ACTION_FILE_SERVER_ID = NULL,
					ACTION_FILE_FROM_TEMPLATE = NULL,
				</cfif>
				<cfif isdefined('attributes.display_file_name_template') and len(attributes.display_file_name_template)> <!--- sisteme kayıtlı template dosyalardan eklenmisse --->
					DISPLAY_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#display_file_name_template#">,
					DISPLAY_FILE_SERVER_ID = #fusebox.server_machine#,
					DISPLAY_FILE_FROM_TEMPLATE = 1,
				<cfelseif (isdefined('attributes.display_file_name') and len(attributes.display_file_name)) or (isdefined('attributes.display_display_file') and len(attributes.display_display_file))>
					<cfif isdefined('attributes.display_file_name') and len(attributes.display_file_name)>
						DISPLAY_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#display_file_name#">,
					<cfelse>
						DISPLAY_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#display_display_file#">,
					</cfif>
					DISPLAY_FILE_SERVER_ID = #fusebox.server_machine#,
					DISPLAY_FILE_FROM_TEMPLATE = NULL,
				<cfelse>
					DISPLAY_FILE_NAME = NULL,
					DISPLAY_FILE_SERVER_ID = NULL,
					DISPLAY_FILE_FROM_TEMPLATE = NULL,
				</cfif>
				INVOICE_TYPE_CODE = <cfif isdefined('attributes.invoice_type_code') and len(attributes.invoice_type_code)>'#attributes.invoice_type_code#'<cfelse>NULL</cfif>,
				PROFILE_ID = <cfif isdefined('attributes.profile_id') and len(attributes.profile_id)>'#attributes.profile_id#'<cfelse>NULL</cfif>,
				SPECIAL_CODE = <cfif len(attributes.special_code)>'#attributes.special_code#'<cfelse>NULL</cfif>,
				DOCUMENT_TYPE = <cfif isdefined('attributes.document_type') and len(attributes.document_type) and isdefined('attributes.is_account')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.document_type#"><cfelse>NULL</cfif>,
				PAYMENT_TYPE = <cfif isdefined('attributes.payment_type') and len(attributes.payment_type) and isdefined('attributes.is_account')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type#"><cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_EMP = #session.ep.userid#,
				SHIP_TYPE_ID = <cfif isdefined('attributes.ship_type') and len(attributes.ship_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_type#"><cfelse>NULL</cfif>,
				MULTI_TYPE = <cfif isdefined('attributes.process_multi_type') and len(attributes.process_multi_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_multi_type#"><cfelse>NULL</cfif>,
				IS_ALL_USERS = <cfif isdefined("attributes.IS_ALL_USERS")>1<cfelse>0</cfif>,
				IS_ALLOWANCE_DEDUCTION = <cfif isdefined("attributes.is_allowance_deduction")>1<cfelse>0</cfif>,
				IS_DEDUCTION = <cfif isdefined("attributes.is_deduction")>1<cfelse>0</cfif>,
				DESPATCH_ADVICE_TYPE = <cfif isDefined("attributes.despatch_advice_type") and len(attributes.despatch_advice_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.despatch_advice_type#"><cfelse>NULL</cfif>,
				ESHIPMENT_PROFILE_ID = <cfif isDefined("attributes.eshipment_profile_id") and len(attributes.eshipment_profile_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.eshipment_profile_id#"><cfelse>NULL</cfif>,
				IS_VISIBLE_TEVKIFAT = <cfif isDefined("attributes.is_visible_tevkifat") and len(attributes.is_visible_tevkifat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_visible_tevkifat#"><cfelse>NULL</cfif>,
				IS_INVENTORY_VALUATION = <cfif isDefined("attributes.is_inventory_valuation") and len(attributes.is_inventory_valuation)><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>
			WHERE
				PROCESS_CAT_ID = #attributes.process_cat_id#
		</cfquery>
		<!--- Tarihçe --->
		<cfquery name="add_process_cat_history" datasource="#dsn3#">
			INSERT INTO
				SETUP_PROCESS_CAT_HISTORY
			(
				PROCESS_CAT_ID,
				PROCESS_TYPE,
				PROCESS_MODULE,				
				IS_CARI,
				IS_ACCOUNT,
				IS_DEFAULT,
				IS_DISCOUNT,
				IS_BUDGET,
				IS_COST,
				IS_STOCK_ACTION,
				IS_ZERO_STOCK_CONTROL,
				IS_ACCOUNT_GROUP,
				IS_PARTNER,
				IS_PUBLIC,
				IS_PROJECT_BASED_ACC,
				IS_PROJECT_BASED_BUDGET,
				IS_CHEQUE_BASED_ACTION,
				IS_CHEQUE_BASED_ACC_ACTION,
				IS_UPD_CARI_ROW,
				IS_DUE_DATE_BASED_CARI,
				IS_COST_ZERO_ROW,
				IS_COST_FIELD,
				IS_PAYMETHOD_BASED_CARI,
				IS_EXP_BASED_ACC,
				IS_PROD_COST_ACC_ACTION,
				IS_ADD_INVENTORY,
				IS_DEPT_BASED_ACC,
				IS_ROW_PROJECT_BASED_CARI,   
				IS_PROCESS_CURRENCY,         
				ACTION_FILE_NAME,
				ACTION_FILE_SERVER_ID,
				ACTION_FILE_FROM_TEMPLATE,
				DISPLAY_FILE_NAME,
				DISPLAY_FILE_SERVER_ID,
				DISPLAY_FILE_FROM_TEMPLATE,
				SPECIAL_CODE,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				PROFILE_ID,
				INVOICE_TYPE_CODE,
				IS_LOT_NO,
				DOCUMENT_TYPE,
				PAYMENT_TYPE,
				IS_ALLOWANCE_DEDUCTION
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_cat_id#">,
				#attributes.process_type#,
				#attributes.MODULE_ID#,
				<cfif isdefined("attributes.is_cari")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_account")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_default")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_discount")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_budget")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_cost")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_stock_action")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_zero_stock_control")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_account_group") and session.ep.our_company_info.is_edefter>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_project_based_acc")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_project_based_budget")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_cheque_based_action")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_cheque_based_acc_action")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_upd_cari_row")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_due_date_based_cari")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_cost_zero_row")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_cost_field")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_paymethod_based_cari")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_exp_based_acc")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_prod_cost_acc_action")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_add_inventory")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_dept_based_acc")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_row_project_based_cari")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_process_currency")>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.action_file_name_template') and len(attributes.action_file_name_template)> <!--- sisteme kayıtlı template dosyalardan eklenmisse --->
					<cfqueryparam  cfsqltype="cf_sql_varchar" value="#action_file_name_template#">,
					#fusebox.server_machine#,
					1,
				<cfelseif (isdefined('attributes.action_file_name') and len(attributes.action_file_name)) or (isdefined('attributes.display_action_file') and len(attributes.display_action_file))>
					<cfif isdefined('attributes.action_file_name') and len(attributes.action_file_name)>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#action_file_name#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#display_action_file#">,
					</cfif>
					#fusebox.server_machine#,
					NULL,
				<cfelse>
					NULL,
					NULL,
					NULL,
				</cfif>
				<cfif isdefined('attributes.display_file_name_template') and len(attributes.display_file_name_template)> <!--- sisteme kayıtlı template dosyalardan eklenmisse --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#display_file_name_template#">,
					#fusebox.server_machine#,
					1,
				<cfelseif (isdefined('attributes.display_file_name') and len(attributes.display_file_name)) or (isdefined('attributes.display_display_file') and len(attributes.display_display_file))>
					<cfif isdefined('attributes.display_file_name') and len(attributes.display_file_name)>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#display_file_name#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#display_display_file#">,
					</cfif>
					#fusebox.server_machine#,
					NULL,
				<cfelse>
					NULL,
					NULL,
					NULL,
				</cfif>
				<cfif len(attributes.special_code)>'#attributes.special_code#'<cfelse>NULL</cfif>,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#session.ep.userid#,
				<cfif isdefined("attributes.profile_id") and len(attributes.profile_id)>'#attributes.profile_id#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.invoice_type_code") and len(attributes.invoice_type_code)>'#attributes.invoice_type_code#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_lot_no")>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.document_type') and len(attributes.document_type) and isdefined('attributes.is_account')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.document_type#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.payment_type') and len(attributes.payment_type) and isdefined('attributes.is_account')><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_allowance_deduction")>1<cfelse>0</cfif>
			)	
		</cfquery>
		<cfquery name="DEL_PROCESS_CAT_ROWS" datasource="#dsn3#">
			DELETE FROM SETUP_PROCESS_CAT_ROWS WHERE PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		</cfquery>
		<cfquery name="DEL_PROCESS_CAT_ROWS" datasource="#dsn3#">
			DELETE FROM SETUP_PROCESS_CAT_ROWS_CAUID WHERE PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		</cfquery>
		<cfquery name="DEL_PROCESS_FUS" datasource="#dsn3#">
			DELETE FROM SETUP_PROCESS_CAT_FUSENAME WHERE PROCESS_CAT_ID = #ATTRIBUTES.PROCESS_CAT_ID#
		</cfquery>
		<!--- Katılımcılar --->
		<cfif isdefined("attributes.to_pos_codes")>
			<cfloop list="#attributes.to_pos_codes#" delimiters="," index="i">
				<cfquery name="add_process_position" datasource="#dsn3#">
					INSERT INTO SETUP_PROCESS_CAT_ROWS (PROCESS_CAT_ID,POSITION_CODE) VALUES (#ATTRIBUTES.PROCESS_CAT_ID#,#i#)
				</cfquery>
			</cfloop>
		</cfif>
		<!--- Onay ve Uyarılacaklar --->
		<cfif isdefined("attributes.cc2_pos_ids")>
			<cfloop list="#attributes.cc2_pos_ids#" delimiters="," index="cc">
				<cfquery name="add_process_position_cc2" datasource="#dsn3#">
					INSERT INTO SETUP_PROCESS_CAT_ROWS_CAUID (PROCESS_CAT_ID,CAU_POSITION_CODE) VALUES (#ATTRIBUTES.PROCESS_CAT_ID#,#cc#)
				</cfquery>
			</cfloop>
		</cfif>
		<cfloop list="#attributes.position_cats#" delimiters="," index="i">
			<cfquery name="add_process_position_cat" datasource="#dsn3#">
				INSERT INTO SETUP_PROCESS_CAT_ROWS (PROCESS_CAT_ID,POSITION_CAT_ID) VALUES (#ATTRIBUTES.PROCESS_CAT_ID#,#i#)
			</cfquery>
		</cfloop>
		<!--- module isimleri gonderiliyor. --->
		<cfif isdefined("attributes.fuse_names") and len(trim(attributes.fuse_names)) >
			<cfloop list="#attributes.fuse_names#" delimiters="," index="i">
				<cfquery name="add_fus_names" datasource="#dsn3#">
					INSERT INTO SETUP_PROCESS_CAT_FUSENAME (PROCESS_CAT_ID,FUSE_NAME) VALUES (#ATTRIBUTES.PROCESS_CAT_ID#,<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.list_process_cats&event=upd&process_cat_id=#attributes.process_cat_id#</cfoutput>";
</script>
