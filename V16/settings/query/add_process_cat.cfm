<!--- action file upload --->
<cfif isdefined('attributes.action_file_name') and len(attributes.action_file_name) and isdefined('attributes.action_file_name_template') and not len(attributes.action_file_name_template)>
	<cftry>
	  <cffile action = "upload" 
		filefield = "action_file_name" 
		destination = "#upload_folder#settings#dir_seperator#" 
		nameconflict = "MakeUnique" 
		mode="777">
	  <cfset action_file_name = createUUID() & '.' & #cffile.serverfileext#>
	  <cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##action_file_name#">
	  <cfcatch type="Any">
	  	<script type="text/javascript">
		  alert("<cf_get_lang no ='2517.Action Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
		  history.back();
	    </script>
	  	<cfabort>
	  </cfcatch>
	</cftry>
</cfif>   
<!--- display file upload --->
<cfif isdefined('attributes.display_file_name') and len(attributes.display_file_name) and isdefined('attributes.display_file_name_template') and not len(attributes.display_file_name_template)>
	<cftry>
	  <cffile action = "upload" 
		filefield = "display_file_name" 
		destination = "#upload_folder#settings#dir_seperator#" 
		nameconflict = "MakeUnique" 
		mode="777">
	  <cfset display_file_name = createUUID() & '.' & #cffile.serverfileext#>
	  <cffile action="rename" source="#upload_folder#settings#dir_seperator##cffile.serverfile#" destination="#upload_folder#settings#dir_seperator##display_file_name#">
	  <cfcatch type="Any">
	  	<script type="text/javascript">
		  alert("<cf_get_lang no ='2518.Display Dosyanız Upload Edilemedi! Dosyanızı Kontrol Ediniz'> !");
		  history.back();
	    </script>
	  	<cfabort>
	  </cfcatch>
	</cftry>
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
                <cfif listfind('51,54,55,59,60,61,63,591',attributes.process_type_id,',')><!--- alis faturalari --->
                    AND PROCESS_TYPE IN (51,54,55,59,60,61,63,591)
                <cfelseif listfind('50,52,53,56,57,58,62,531',attributes.process_type_id,',')><!--- satis faturalari --->
                    AND PROCESS_TYPE IN (50,52,53,56,57,58,62,531)
                <cfelseif listfind('73,74,75,76,77',attributes.process_type_id,',')><!--- alis irsaliyeleri --->
                    AND PROCESS_TYPE IN (73,74,75,76,77)
                <cfelseif listfind('70,71,72,78,79,88',attributes.process_type_id,',')><!--- satis irsaliyeleri --->
                    AND PROCESS_TYPE IN (70,71,72,78,79,88)
                <cfelseif listfind('140,141',attributes.process_type_id,',')><!--- servis irsaliyeleri --->
                    AND PROCESS_TYPE IN (140,141)
                <cfelse>
                    <!--- 	Ozel Durumlar veya Birden Fazla Islem Tipinin Kendi Icindeki Kontrolleri Icin Yukaridaki Gibi Yazilir, 
                            Digerleri Icin Kendi Tipleri Icinde Kontrol Edilmesi Yeterli FBS 20121224
                     --->
                    AND PROCESS_TYPE = #attributes.process_type_id#
                </cfif>
            </cfquery>
            <cfset df_flag = 1>
        </cfif>
		<cfquery name="add_process_cat" datasource="#dsn3#" result="MAX_ID">
			INSERT INTO SETUP_PROCESS_CAT
				(
				PROCESS_CAT,
				PROCESS_TYPE,
				PROCESS_MODULE,				
				IS_CARI,
                IS_LOT_NO,
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
				IS_EXPENSING_TAX,
				IS_EXPENSING_OIV,
				IS_EXPENSING_OTV,
				NEXT_PERIODS_ACCRUAL_ACTION,
                ACCRUAL_BUDGET_ACTION,
				IS_BUDGET_RESERVED_CONTROL,
				IS_EXPENSING_BSMV,
			<cfif (isdefined('attributes.action_file_name_template') and len(attributes.action_file_name_template)) or (isdefined('attributes.action_file_name') and len(attributes.action_file_name))>
				ACTION_FILE_NAME,
				ACTION_FILE_SERVER_ID,
				ACTION_FILE_FROM_TEMPLATE,
			</cfif>
			<cfif (isdefined('attributes.display_file_name_template') and len(attributes.display_file_name_template)) or (isdefined('attributes.display_file_name') and len(attributes.display_file_name))>
				DISPLAY_FILE_NAME,
				DISPLAY_FILE_SERVER_ID,
				DISPLAY_FILE_FROM_TEMPLATE,
			</cfif>
            	INVOICE_TYPE_CODE,
                PROFILE_ID,
				SPECIAL_CODE,
                DOCUMENT_TYPE,
                PAYMENT_TYPE,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
                SHIP_TYPE_ID,
                MULTI_TYPE,
				IS_ALL_USERS,
				IS_EXPORT_REGISTERED,
				IS_EXPORT_PRODUCT,
				IS_ALLOWANCE_DEDUCTION,
				IS_DEDUCTION,
				DESPATCH_ADVICE_TYPE,
				ESHIPMENT_PROFILE_ID,
				IS_VISIBLE_TEVKIFAT,
				IS_INVENTORY_VALUATION
			)
			VALUES
				(
				'#attributes.PROCESS_CAT#',
				#attributes.PROCESS_TYPE_ID#,
				#attributes.MODULE_ID#,
				<cfif isdefined("attributes.is_cari")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.is_lot_no")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_account")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_default")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_discount")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_budget")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_cost")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_stock_action")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_zero_stock_action")>1<cfelse>0</cfif>,
				<cfif session.ep.our_company_info.is_edefter and listFind('240,253,310,320,2410,410,420',attributes.PROCESS_TYPE_ID) eq 1>0<cfelseif isdefined("attributes.is_account_group")>1<cfelse>0</cfif>,
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
				<cfif isdefined("attributes.is_expensing_tax")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_expensing_oiv")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_expensing_otv")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.next_periods_accrual_action")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.accrual_budget_action")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.budget_reserved_control")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_expensing_bsmv")>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.action_file_name_template') and len(attributes.action_file_name_template)> <!--- sisteme kayıtlı template dosyalardan eklenmisse --->
					'#action_file_name_template#',
					#fusebox.server_machine#,
					1,
				<cfelseif isdefined('attributes.action_file_name') and len(attributes.action_file_name)>
					'#action_file_name#',
					#fusebox.server_machine#,
					NULL,
				</cfif>
				<cfif isdefined('attributes.display_file_name_template') and len(attributes.display_file_name_template)> <!--- sisteme kayıtlı template dosyalardan eklenmisse --->
					'#display_file_name_template#',
					#fusebox.server_machine#,
					1,
				<cfelseif isdefined('attributes.display_file_name') and len(attributes.display_file_name)>
					'#display_file_name#',
					#fusebox.server_machine#,
					NULL,
				</cfif>
            	<cfif isdefined('attributes.invoice_type_code') and len(attributes.invoice_type_code)>'#attributes.invoice_type_code#'<cfelse>NULL</cfif>,
               	<cfif isdefined('attributes.profile_id') and len(attributes.profile_id)>'#attributes.profile_id#'<cfelse>NULL</cfif>,               
				<cfif len(attributes.special_code)>'#attributes.special_code#'<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.document_type') and len(attributes.document_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.document_type#"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.payment_type') and len(attributes.payment_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type#"><cfelse>NULL</cfif>,
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#session.ep.userid#,
                <cfif isdefined('attributes.ship_type') and len(attributes.ship_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_type#"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.process_multi_type') and len(attributes.process_multi_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_multi_type#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.IS_ALL_USERS")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_export_registered")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_export_product")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_allowance_deduction")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_deduction")>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.despatch_advice_type") and len(attributes.despatch_advice_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.despatch_advice_type#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.eshipment_profile_id") and len(attributes.eshipment_profile_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.eshipment_profile_id#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.is_visible_tevkifat") and len(attributes.is_visible_tevkifat)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.is_visible_tevkifat#"><cfelse>NULL</cfif>,
				<cfif isDefined("attributes.is_inventory_valuation") and len(attributes.is_inventory_valuation)><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>
			)	
		</cfquery>
		<!--- positions --->
		<cfif isdefined("attributes.to_pos_codes")>
		<cfloop list="#attributes.to_pos_codes#" delimiters="," index="i">
			<cfquery name="add_process_position" datasource="#dsn3#">
				INSERT INTO SETUP_PROCESS_CAT_ROWS
					(PROCESS_CAT_ID,POSITION_CODE)
				VALUES
					(#MAX_ID.IDENTITYCOL#,#i#)
			</cfquery>
		</cfloop>
		</cfif>
		<cfif isdefined("attributes.position_cats")>
			<cfloop list="#attributes.position_cats#" delimiters="," index="i">
				<cfquery name="add_process_position_cat" datasource="#dsn3#">
					INSERT INTO SETUP_PROCESS_CAT_ROWS
						(PROCESS_CAT_ID,POSITION_CAT_ID)
					VALUES
						(#MAX_ID.IDENTITYCOL#,#i#)
				</cfquery>
			</cfloop>
		</cfif>
		<!--- module isimleri gonderiliyor. --->
		<cfif isdefined("attributes.fuse_names") and len(trim(attributes.fuse_names))>
			<cfloop list="#attributes.fuse_names#" delimiters="," index="i">
				<cfquery name="add_fus_names" datasource="#dsn3#">
					INSERT INTO SETUP_PROCESS_CAT_FUSENAME
						(PROCESS_CAT_ID,FUSE_NAME)
					VALUES
						(#MAX_ID.IDENTITYCOL#,'#i#')
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.list_process_cats&event=upd&process_cat_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
