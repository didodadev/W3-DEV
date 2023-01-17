<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT COMP_ID,WORKCUBE_SECTOR FROM OUR_COMPANY_INFO WHERE COMP_ID = #attributes.comp_id#
</cfquery>
<cflock name="#CreateUUID()#" timeout="500">
	<cftransaction>
	<cfif isdefined("attributes.time_control_date") and len(attributes.time_control_date)><cf_date tarih="attributes.time_control_date"></cfif>
	<cfif isdefined("attributes.efatura_date") and len(attributes.efatura_date)><cf_date tarih="attributes.efatura_date"></cfif>
	<cfif isdefined("attributes.earchive_date") and len(attributes.earchive_date)><cf_date tarih="attributes.earchive_date"></cfif>    
	<cfif get_our_company_info.recordcount>
		<cfquery name="UPD_OUR_COMPANY_INFO" datasource="#DSN#">
			UPDATE
				OUR_COMPANY_INFO
			SET
				IS_CONTROL_BRANCH_PROJECT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_control_branch_project#">,
				IS_BARCOD_REQUIRED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_BARCOD_REQ#">,
				IS_SUBSCRIPTION_AUTHORITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_SUBSCRIPTION_AUTHORITY#">,
				WORKCUBE_SECTOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.workcube_sector#">,
				LOGO_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.logo_type#">,
				IS_GUARANTY_FOLLOWUP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_GUARANTY_FOLLOWUP#">,
				IS_LOCATION_FOLLOW = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_LOCATION_FOLLOW#">,
				IS_PROJECT_FOLLOWUP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_PROJECT_FOLLOWUP#">,
				IS_ASSET_FOLLOWUP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_ASSET_FOLLOWUP#">,
				IS_SUBSCRIPTION_CONTRACT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_SUBSCRIPTION_CONTRACT#">,
				IS_SALES_ZONE_FOLLOWUP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_SALES_ZONE_FOLLOWUP#">,
				IS_SMS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_SMS#">,
				IS_UNCONDITIONAL_LIST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_UNCONDITIONAL_LIST#">,
				COMP_VIZYON = <cfif len(attributes.comp_vizyon)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_vizyon#"><cfelse>NULL</cfif>,
				EMAIL = <cfif len(attributes.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#"><cfelse>NULL</cfif>,
				IS_BRAND_TO_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_BRAND_TO_CODE#">,
				SPECT_TYPE = <cfif isdefined("attributes.spect_type")>#attributes.spect_type#<cfelse>0</cfif>,
				IS_TIME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_time#">,
				IS_TIME_STYLE = <cfif isdefined("attributes.is_time") and isdefined("attributes.is_time_style") and len(attributes.is_time_style)>#attributes.is_time_style#<cfelse>NULL</cfif>,
				TIME_CONTROL_DATE = <cfif isdefined("attributes.is_time") and isdefined("attributes.time_control_date") and len(attributes.time_control_date)>#attributes.time_control_date#<cfelse>NULL</cfif>,
				IS_RATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_rate#">,
				IS_RATE_FROM_PRE_PAPER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_rate_from_pre_paper#">,
				IS_PAPER_CLOSER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_paper_closer#">,
				IS_MAXROWS_CONTROL_OFF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_maxrows_control_off#">,
				WORK_STOCK_ID = <cfif len(attributes.work_product_name) and len(attributes.work_stock_id)>#attributes.work_stock_id#<cfelse>NULL</cfif>,
				IS_COST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_cost#">,
                IS_COST_LOCATION = <cfif isdefined("attributes.is_cost_location") and len(attributes.is_cost_location) and isdefined("attributes.is_cost")>#attributes.is_cost_location#<cfelse>0</cfif>,
				COST_CALC_TYPE = <cfif isdefined("attributes.cost_calc_type")>#attributes.cost_calc_type#<cfelse>1</cfif>,
				IS_SERIAL_CONTROL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_serial_control#">,
				IS_SHIP_CONTROL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_ship_control#">,
				IS_CONTENT_FOLLOW = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_content_follow#">,
				IS_ORDER_UPDATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_order_upd#">,
				IS_PURCHASE_ORDER_UPDATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_purchase_order_upd#">,
				IS_SHIP_UPDATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_ship_upd#">,
				IS_USE_IFRS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_use_ifrs#">,
				CARGO_CUSTOMER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cargo_customer_code#">,
				CARGO_CUSTOMER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cargo_customer_password#">,
				PUBLIC_ACCOUNT_CODE = <cfif len(attributes.account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_code#"><cfelse>NULL</cfif>,
				RATE_ROUND_NUM = <cfif len(attributes.rate_round_num)>#attributes.rate_round_num#<cfelse>4</cfif>,
				PURCHASE_PRICE_ROUND_NUM = <cfif len(attributes.purchase_price_round_num)>#attributes.purchase_price_round_num#<cfelse>4</cfif>,
				SALES_PRICE_ROUND_NUM = <cfif len(attributes.sales_price_round_num)>#attributes.sales_price_round_num#<cfelse>2</cfif>,
				IS_STORE_FOLLOWUP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_store_followup#">,
				IS_MULTI_ANALYSIS_RESULT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_multi_analysis_result#">,
				IS_ACCOUNT_CARD_UPDATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_account_card_upd#">,
				IS_DETAILED_RISK_INFO= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_detailed_risk_info#">,
				IS_SELECT_RISK_MONEY= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_select_risk_money#">,
				IS_PROD_COST_TYPE= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_prod_cost_type#">,
				IS_STOCK_BASED_COST= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_stock_based_cost#">,
				IS_REMAINING_AMOUNT= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_remaining_amount#">,
                IS_ADD_INFORMATIONS= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_ADD_INFORMATIONS#">,
				IS_FILE_SIZE= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.file_size_check#">,
				<!--- IS_USE_SMS_WEBSERVICE = <cfif isdefined("attributes.is_use_sms_webservice")>1<cfelse>0</cfif>, --->
				IS_PROJECT_GROUP= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_project_group#">,
                IS_PRODUCT_COMPANY= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_PRODUCT_COMPANY#">,
				SPECIAL_MENU_FILE= <cfif isdefined("attributes.special_menu_file_name") and len(attributes.special_menu_file_name)>'#attributes.special_menu_file_name#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_sms") and attributes.is_sms eq 1>
				SMS_COMPANY = <cfif isdefined("attributes.sms_Company") and len(attributes.sms_Company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_Company#"><cfelse>NULL</cfif>, 
				SMS_CUSTOMERNO = <cfif isdefined("attributes.sms_customerno") and len(azttributes.sms_customerno)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_customerno#"><cfelse>NULL</cfif>,
				SMS_USERNAME = <cfif isdefined("attributes.sms_username") and len(attributes.sms_username)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_username#"><cfelse>NULL</cfif>,
				SMS_PASSWORD = <cfif isdefined("attributes.sms_password") and len(attributes.sms_password)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_password#"><cfelse>NULL</cfif>,
				SMS_SERVICECODE = <cfif isdefined("attributes.sms_servicecode") and len(attributes.sms_servicecode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_servicecode#"><cfelse>NULL</cfif>,
				SMS_ALPHANUMERIC = <cfif isdefined("attributes.sms_alphanumeric") and len(attributes.sms_alphanumeric)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_alphanumeric#"><cfelse>NULL</cfif>,
			<cfelse>
				SMS_COMPANY = NULL,
				SMS_CUSTOMERNO = NULL,
				SMS_USERNAME = NULL,
				SMS_PASSWORD = NULL,
				SMS_SERVICECODE = NULL,
				SMS_ALPHANUMERIC = NULL,
			</cfif>
			<cfif isdefined("file_size_check") and file_size_check eq 1>
				FILE_SIZE = <cfif isdefined("attributes.file_size") and len(attributes.file_size)>#attributes.file_size#<cfelse>NULL</cfif>,
			</cfif>                
                IS_LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_LOT_NO#">,
                IS_OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_OTHER_MONEY#">,
                IS_SERIAL_CONTROL_LOCATION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.is_serial_control_location#">,
				IS_ENCRYPTED_SALARY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_ENCRYPTED_SALARY#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				IS_WATALOGY_INTEGRATED = <cfif isdefined('attributes.is_watalogy_integrated') and len(attributes.is_watalogy_integrated)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_watalogy_integrated#"><cfelse>NULL</cfif>,
				WATALOGY_MEMBER_CODE = <cfif isdefined('attributes.watalogy_member_code') and len(attributes.watalogy_member_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.watalogy_member_code#"><cfelse>NULL</cfif>,
				IS_CTI_INTEGRATED = <cfif isdefined('attributes.is_cti_integrated') and len(attributes.is_cti_integrated)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_cti_integrated#"><cfelse>NULL</cfif>,
				OPERATOR = <cfif isdefined('attributes.operator') and len(attributes.operator)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.operator#"><cfelse>NULL</cfif>,
				EXTENSION_LIMIT = <cfif isdefined('attributes.extension_limit') and len(attributes.extension_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.extension_limit#"><cfelse>NULL</cfif>,
				LINE_LIMIT = <cfif isdefined('attributes.line_limit') and len(attributes.line_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.line_limit#"><cfelse>NULL</cfif>,
				TEL_NUMBERS = <cfif isdefined('attributes.tel_numbers') and len(attributes.tel_numbers)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel_numbers#"><cfelse>NULL</cfif>,
				API_KEY = <cfif isdefined('attributes.api_key') and len(attributes.api_key)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.api_key#"><cfelse>NULL</cfif>,
				IS_SENDGRID_INTEGRATED = <cfif isdefined('attributes.is_sendgrid_integrated') and len(attributes.is_sendgrid_integrated)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_sendgrid_integrated#"><cfelse>NULL</cfif>,	
				SENDGRID_GROUP_ID = <cfif isdefined('attributes.sendgrid_group_id') and len(attributes.sendgrid_group_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sendgrid_group_id#"><cfelse>NULL</cfif>,					
				MAIL_API_KEY = <cfif isdefined('attributes.mail_api_key') and len(attributes.mail_api_key)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mail_api_key#"><cfelse>NULL</cfif>,
				SENDER_MAIL = <cfif isdefined('attributes.sender_mail') and len(attributes.sender_mail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sender_mail#"><cfelse>NULL</cfif>,
				GOOGLE_API_KEY = <cfif isdefined('attributes.GOOGLE_API_KEY') and len(attributes.GOOGLE_API_KEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.GOOGLE_API_KEY#"><cfelse>NULL</cfif>,
				GOOGLE_CLIENT_ID = <cfif isdefined('attributes.google_client_id') and len(attributes.google_client_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.google_client_id#"><cfelse>NULL</cfif>,
				GOOGLE_CLIENT_SECRET = <cfif isdefined('attributes.google_client_secret') and len(attributes.google_client_secret)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.google_client_secret#"><cfelse>NULL</cfif>,
				GOOGLE_LANGUAGE = <cfif isdefined('attributes.GOOGLE_LANGUAGE') and len(attributes.GOOGLE_LANGUAGE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.GOOGLE_LANGUAGE#"><cfelse>NULL</cfif>,
				IS_KEP_INTEGRATED = <cfif isdefined('attributes.SENDGRID_GROUP_ID') and len(attributes.is_kep_integrated)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_kep_integrated#"><cfelse>NULL</cfif>,				
				KEP_API_KEY = <cfif isdefined('attributes.kep_api_key') and len(attributes.kep_api_key)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.kep_api_key#"><cfelse>NULL</cfif>,
				COMPANY_KEP_ADRESS = <cfif isdefined('attributes.company_kep_adress') and len(attributes.company_kep_adress)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.company_kep_adress#"><cfelse>NULL</cfif>,
				IS_ACCOUNTER_INTEGRATED = <cfif isdefined('attributes.is_accounter_integrated') and len(attributes.is_accounter_integrated)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_accounter_integrated#"><cfelse>0</cfif>,
				ACCOUNTER_DOMAIN = <cfif isdefined('attributes.accounter_domain') and len(attributes.accounter_domain)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.accounter_domain#"><cfelse>NULL</cfif>,
				ACCOUNTER_KEY = <cfif isdefined('attributes.accounter_key') and len(attributes.accounter_key)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.accounter_key#"><cfelse>NULL</cfif>		 								
			WHERE
				COMP_ID = #attributes.comp_id#
		</cfquery>

		<cfif isdefined('attributes.is_earchive')>
        	<cfquery name="getIntegrationInfo" datasource="#dsn#">
            	SELECT ID FROM EARCHIVE_INTEGRATION_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
            </cfquery>
            <cfif getIntegrationInfo.recordcount>
            	<cfquery name="updIntegrationInfo" datasource="#dsn#">
                	UPDATE 
                    	EARCHIVE_INTEGRATION_INFO
                    SET
                    	EARCHIVE_INTEGRATION_TYPE = <cfif isdefined('attributes.earchive_integration_type')>#attributes.earchive_integration_type#<cfelse>NULL</cfif>,
                        EARCHIVE_TEST_SYSTEM = <cfif isdefined('attributes.earchive_test_system')>1<cfelse>0</cfif>,
						EARCHIVE_PREFIX = <cfif isdefined('attributes.earchive_prefix')>'#attributes.earchive_prefix#'<cfelse>NULL</cfif>,
                        EARCHIVE_COMPANY_CODE = '#attributes.earchive_company_code#',
                        EARCHIVE_USERNAME = '#attributes.earchive_username#',
                        EARCHIVE_PASSWORD = '#attributes.earchive_password#',
                        UPDATE_DATE = #now()#,
                        UPDATE_EMP = #session.ep.userid#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    WHERE
                    	COMP_ID = #attributes.comp_id#
                </cfquery>
            <cfelse>
            	<cfquery name="addIntegrationInfo" datasource="#dsn#">
                	INSERT INTO 
                    	EARCHIVE_INTEGRATION_INFO
                    (
                    	COMP_ID,
                    	EARCHIVE_INTEGRATION_TYPE,
                        EARCHIVE_TEST_SYSTEM,
						EARCHIVE_PREFIX,
                        EARCHIVE_COMPANY_CODE,
                        EARCHIVE_USERNAME,
                        EARCHIVE_PASSWORD,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                     )
                     VALUES
                     (
                     	#attributes.comp_id#,
						<cfif isdefined('attributes.earchive_integration_type')>#attributes.earchive_integration_type#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.earchive_test_system')>1<cfelse>0</cfif>,
						<cfif isdefined('attributes.earchive_prefix')>'#attributes.earchive_prefix#'<cfelse>NULL</cfif>,
                        '#attributes.earchive_company_code#',
                        '#attributes.earchive_username#',
                        '#attributes.earchive_password#',
                        #now()#,
                        #session.ep.userid#,
                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                     )
                 </cfquery>
            </cfif>
        </cfif>        

		<cfif attributes.workcube_sector neq get_our_company_info.workcube_sector><!--- Sektor degistirildiginde sistemden atiliyor FB 20070717 --->
			<cfquery name="DEL_SESSION" datasource="#DSN#">
				DELETE FROM 
					WRK_SESSION
				WHERE
					(USER_TYPE= 0 AND COMPANY_ID = #attributes.comp_id#) OR
					OUR_COMPANY_ID = #attributes.comp_id#
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="ADD_OUR_COMPANY_INFO" datasource="#DSN#">
			INSERT INTO
				OUR_COMPANY_INFO
			(
				COMP_ID,
				IS_CONTROL_BRANCH_PROJECT,
				IS_BARCOD_REQUIRED,
				IS_SUBSCRIPTION_AUTHORITY,
				WORKCUBE_SECTOR,
				LOGO_TYPE,
				IS_GUARANTY_FOLLOWUP,
				IS_LOCATION_FOLLOW,
				IS_PROJECT_FOLLOWUP,
				IS_ASSET_FOLLOWUP,
				IS_SALES_ZONE_FOLLOWUP,
				IS_SMS,
				IS_UNCONDITIONAL_LIST,
				COMP_VIZYON,
				EMAIL,
				SPECT_TYPE,
				IS_COST,
                IS_COST_LOCATION,
				COST_CALC_TYPE,
				IS_TIME,
				IS_TIME_STYLE,
				TIME_CONTROL_DATE,
				IS_RATE,
				IS_RATE_FROM_PRE_PAPER,
				IS_PAPER_CLOSER,
				WORK_STOCK_ID,
				IS_SERIAL_CONTROL,
				IS_SHIP_CONTROL,
				IS_BRAND_TO_CODE,
				CARGO_CUSTOMER_CODE,
				CARGO_CUSTOMER_PASSWORD,
				IS_CONTENT_FOLLOW,
				IS_ORDER_UPDATE,
				IS_SHIP_UPDATE,
				IS_USE_IFRS,
				PUBLIC_ACCOUNT_CODE,
				RATE_ROUND_NUM,
				PURCHASE_PRICE_ROUND_NUM,
				SALES_PRICE_ROUND_NUM,
				IS_STORE_FOLLOWUP,
				IS_MULTI_ANALYSIS_RESULT,
				IS_DETAILED_RISK_INFO,
				IS_SELECT_RISK_MONEY,
				IS_PROD_COST_TYPE,
				IS_REMAINING_AMOUNT,
                IS_ADD_INFORMATIONS,
				IS_STOCK_BASED_COST,
				IS_PROJECT_GROUP,
                IS_PRODUCT_COMPANY,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
                IS_LOT_NO,
                IS_OTHER_MONEY,
                IS_SERIAL_CONTROL_LOCATION,
				IS_ENCRYPTED_SALARY,
				IS_WATALOGY_INTEGRATED,
				WATALOGY_MEMBER_CODE
			)
			VALUES
			(
				#attributes.comp_id#,
				<cfif isdefined("attributes.is_control_branch_project")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.IS_BARCOD_REQ")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.IS_SUBSCRIPTION_AUTHORITY")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.workcube_sector#">,
				<cfif isdefined("attributes.logo_type")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.logo_type#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.IS_GUARANTY_FOLLOWUP")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.IS_LOCATION_FOLLOW")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.IS_SUBSCRIPTION_CONTRACT")>1<cfelse>0</cfif>,		
				<cfif isdefined("attributes.IS_PROJECT_FOLLOWUP")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.IS_ASSET_FOLLOWUP")>1<cfelse>0</cfif>,	
				<cfif isdefined("attributes.IS_SALES_ZONE_FOLLOWUP")>1<cfelse>0</cfif>,		
				<cfif isdefined("attributes.IS_SMS")>1<cfelse>0</cfif>,		
				<cfif isdefined("attributes.IS_UNCONDITIONAL_LIST")>1<cfelse>0</cfif>,
				<cfif len(attributes.COMP_VIZYON)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COMP_VIZYON#"><cfelse>NULL</cfif>,	
				<cfif isdefined("attributes.email") and len(attributes.email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.email#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.spect_type")>#attributes.spect_type#<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_cost")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.is_cost_location")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.cost_calc_type")>#attributes.cost_calc_type#<cfelse>1</cfif>,
				<cfif isdefined("attributes.is_time")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_time") and isdefined("attributes.is_time_style") and len(attributes.is_time_style)>#attributes.is_time_style#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_time") and isdefined("attributes.time_control_date") and len(attributes.time_control_date)>#attributes.time_control_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_rate")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_rate_from_pre_paper")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_paper_closer")>1<cfelse>0</cfif>,
				<cfif len(attributes.work_product_name) and len(attributes.work_stock_id)>#attributes.work_stock_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_serial_control")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_ship_control")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_brand_to_code")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cargo_customer_code#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cargo_customer_password#">,
				<cfif isdefined("attributes.is_content_follow")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_order_upd")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_ship_upd")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_use_ifrs")>1<cfelse>0</cfif>,
				<cfif len(attributes.account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_code#"><cfelse>NULL</cfif>,
				<cfif len(attributes.rate_round_num)>#attributes.rate_round_num#<cfelse>4</cfif>,
				<cfif len(attributes.purchase_price_round_num)>#attributes.purchase_price_round_num#<cfelse>4</cfif>,
				<cfif len(attributes.sales_price_round_num)>#attributes.sales_price_round_num#<cfelse>2</cfif>,
				<cfif isdefined("attributes.is_store_followup")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_multi_analysis_result")>1<cfelse>0</cfif>,
				<cfif isdefined("is_detailed_risk_info")>1<cfelse>0</cfif>,
				<cfif isdefined("is_select_risk_money")>1<cfelse>0</cfif>,
				<cfif isdefined("is_prod_cost_type")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_remaining_amount")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.IS_ADD_INFORMATIONS")>1<cfelse>0</cfif>,
				<cfif isdefined("is_stock_based_cost")>1<cfelse>0</cfif>,
				<cfif isdefined("is_project_group")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.IS_PRODUCT_COMPANY")>1<cfelse>0</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfif isdefined("attributes.IS_LOT_NO")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.IS_OTHER_MONEY")>1<cfelse>0</cfif>,
                <cfif isdefined("attributes.is_serial_control_location")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.IS_ENCRYPTED_SALARY")>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.is_watalogy_integrated') and len(attributes.is_watalogy_integrated)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_watalogy_integrated#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.watalogy_member_code') and len(attributes.watalogy_member_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.watalogy_member_code#"><cfelse>NULL</cfif>
			)
		</cfquery>
	</cfif>
	<cf_add_log  log_type="0" action_id="#attributes.comp_id#" action_name="#attributes.comp_name#">
	</cftransaction>  
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_list_company</cfoutput>"
</script>