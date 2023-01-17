<cfcomponent>
    <!---  Araç Ekleme   --->
    <cffunction name="addAssetpVehicleFnc" access="public" returntype="any">
    				<cfargument name="PROPERTY" default="">,
					<cfargument name="INVENTORY_NUMBER" default="">,
					<cfargument name="ASSETP" default="">,
					<cfargument name="SUP_COMPANY_ID" default="">,
					<cfargument name="SUP_PARTNER_ID" default="">,
					<cfargument name="SUP_CONSUMER_ID" default="">,				
					<cfargument name="ASSETP_CATID" default="">,
					<cfargument name="ASSETP_SUB_CATID" default="">,
					<cfargument name="DEPARTMENT_ID" default="">,
					<cfargument name="DEPARTMENT_ID2" default="">,
					<cfargument name="EMP_ID" default="">,
					<cfargument name="POSITION_CODE" default="">,
					<cfargument name="MEMBER_TYPE" default="">,
					<cfargument name="POSITION_CODE2" default="">,
					<cfargument name="MEMBER_TYPE_2" default="">,
					<cfargument name="START_DATE" default="">,                    
					<cfargument name="first_date_km" default="">,
                    <cfargument name="o_first_km" default="">,
					<cfargument name="FIRST_KM" default="">,
					<cfargument name="FUEL_TYPE" default="">,
					<cfargument name="ASSETP_STATUS" default="">,
					<cfargument name="USAGE_PURPOSE_ID" default="">,
					<cfargument name="ASSETP_GROUP" default="">,
					<cfargument name="BRAND_ID" default="">,
					<cfargument name="BRAND_TYPE_ID" default="">,
					<cfargument name="BRAND_TYPE_CAT_ID" default="">,				
					<cfargument name="MAKE_YEAR" default="">,
					<cfargument name="ASSETP_DETAIL" default="">,
					<cfargument name="STATUS" default="">,
					<cfargument name="IS_SALES" default="">,
					<cfargument name="IS_COLLECTIVE_USAGE" default="">,
					<cfargument name="OTHER_MONEY" default="">,
					<cfargument name="OTHER_MONEY_VALUE" default="">,
						<cfargument name="asset_vehicle_width" default="">,
						<cfargument name="asset_vehicle_size" default="">,
						<cfargument name="asset_vehicle_height" default="">,					
					<cfargument name="PROCESS_STAGE" default="">,
					<cfargument name="RECORD_DATE" default="">,
					<cfargument name="RECORD_EMP" default="">,
                    <cfargument name="relation_asset_id" default="">,
					<cfargument name="RECORD_IP" default="">
                    <cfargument name="rent_amount" default="">
        			<cfargument name="rent_amount_currency" type="string" required="no" default="">
        			<cfargument name="rent_payment_period" default=""> 
                     <cfargument name="rent_start_date"  default="">
                     <cfargument name="rent_finish_date"  default="">
                     <cfargument name="is_fuel_added" default="">
        			<cfargument name="is_care_added" default=""> 
                    <cfargument name="fuel_amount" default="">
        			<cfargument name="fuel_amount_currency" type="string" required="no" default="">  
       				 <cfargument name="care_amount" default="">
					<cfargument name="care_amount_currency" type="string" required="no" default="">   
					<cfargument name="contract_head" default="">  
					<cfargument name="company_id" default="">
					<cfargument name="support_company_id" default="">
					<cfargument name="authorized_id" default="">
					<cfargument name="support_authorized_id" default="">
					<cfargument name="support_position_id" default="">
					<cfargument name="support_position_name" default="">
					<cfargument name="support_start_date" default="">
					<cfargument name="support_finish_date" default="">
					<cfargument name="project_id" default="">
					<cfargument name="project_head" default="">
					<cfargument name="support_cat" default="">
					<cfargument name="detail" default="">
					           
        	<cfquery name="ADD_ASSETP" datasource="#this.DSN#" result="MAX_ID">
			INSERT INTO 
					ASSET_P
				(
					PROPERTY,
					INVENTORY_NUMBER,
					ASSETP,
					SUP_COMPANY_ID,
					SUP_PARTNER_ID,
					SUP_CONSUMER_ID,				
					ASSETP_CATID,
					ASSETP_SUB_CATID,
					DEPARTMENT_ID,
					DEPARTMENT_ID2,
					EMPLOYEE_ID,
					POSITION_CODE,
					MEMBER_TYPE,
					POSITION_CODE2,
					MEMBER_TYPE_2,
					SUP_COMPANY_DATE,
					FIRST_KM_DATE,
					FIRST_KM,
					FUEL_TYPE,
					ASSETP_STATUS,
					USAGE_PURPOSE_ID,
					ASSETP_GROUP,
					BRAND_ID,
					BRAND_TYPE_ID,
					BRAND_TYPE_CAT_ID,				
					MAKE_YEAR,
					ASSETP_DETAIL,
					STATUS,
					IS_SALES,
					IS_COLLECTIVE_USAGE,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					<cfif isdefined('x_dimension') and x_dimension eq 1>
						PHYSICAL_ASSETS_WIDTH,
						PHYSICAL_ASSETS_SIZE,
						PHYSICAL_ASSETS_HEIGHT,
					</cfif>
					PROCESS_STAGE,
					RECORD_DATE,
					RECORD_EMP,
                    RELATION_PHYSICAL_ASSET_ID,
					RECORD_IP
				)
				VALUES
				(
					#arguments.property#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.inventory_number)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.assetp)#">,
					<cfif isDefined("arguments.sup_company_id") and len(arguments.sup_company_id)>
						#arguments.sup_company_id#,
							<cfif isDefined("arguments.sup_partner_id") and len(arguments.sup_partner_id)>#arguments.sup_partner_id#<cfelse>NULL</cfif>,
                                NULL,
                            <cfelse>
                                NULL,
                                NULL,
                                #arguments.sup_consumer_id#,
					</cfif>				
					#arguments.assetp_catid#,
					<cfif isdefined("arguments.assetp_sub_catid") and len(arguments.assetp_sub_catid)>#arguments.assetp_sub_catid#<cfelse>NULL</cfif>,
					<cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
					<cfif isDefined("arguments.department_id2") and len(arguments.department_id2)>#arguments.department_id2#<cfelseif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.emp_id)>#arguments.emp_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.position_code)>#arguments.position_code#<cfelse>NULL</cfif>,
					<cfif isDefined("arguments.member_type") and len(arguments.member_type)>'#arguments.member_type#'<cfelse>NULL</cfif>,
					<cfif len(arguments.position_code2)>#arguments.position_code2#<cfelse>NULL</cfif>,
					<cfif len(arguments.member_type_2)>'#arguments.member_type_2#'<cfelse>NULL</cfif>,
					<cfif len(arguments.start_date)>#arguments.start_date#<cfelse>NULL</cfif>,
					<cfif len(arguments.first_date_km)>#arguments.first_date_km#<cfelse>NULL</cfif>,
					<cfif len(arguments.first_km)>#arguments.first_km#<cfelse>NULL</cfif>,
					<cfif len(arguments.fuel_type)>#arguments.fuel_type#<cfelse>NULL</cfif>,
					<cfif len(arguments.status)>#arguments.status#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.usage_purpose_id') and len(arguments.usage_purpose_id)>#arguments.usage_purpose_id#<cfelse>NULL</cfif>,
					<cfif isdefined('arguments.assetp_group') and len(arguments.assetp_group)>#arguments.assetp_group#<cfelse>NULL</cfif>,				
					#arguments.brand_id#,
					#arguments.brand_type_id#,
					#arguments.brand_type_cat_id#,
					<cfif len(arguments.make_year)>#arguments.make_year#<cfelse>NULL</cfif>,
					<cfif len(arguments.assetp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_detail#"><cfelse>NULL</cfif>,
					1,
					0,
					<cfif isdefined('arguments.is_collective_usage') and arguments.is_collective_usage eq 1>1<cfelse>0</cfif>,
					<cfif len(arguments.assetp_other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_other_money#"><cfelse>NULL</cfif>,
					<cfif len(arguments.assetp_other_money_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_other_money_value#"><cfelse>NULL</cfif>,										
					<cfif isdefined('x_dimension') and x_dimension eq 1>
						<cfif isdefined('arguments.asset_vehicle_width') and len(arguments.asset_vehicle_width)>#arguments.asset_vehicle_width#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.asset_vehicle_size') and len(arguments.asset_vehicle_size)>#arguments.asset_vehicle_size#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.asset_vehicle_height') and len(arguments.asset_vehicle_height)>#arguments.asset_vehicle_height#<cfelse>NULL</cfif>,
					</cfif>
					<cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>#arguments.process_stage#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
                    <cfif isdefined('arguments.relation_asset_id') and len(arguments.relation_asset_id)>#arguments.relation_asset_id#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">					
				)
			</cfquery>
			<cfquery name="ADD_KMS" datasource="#this.dsn#"> 
				INSERT INTO 
					ASSET_P_KM_CONTROL
				(
					ASSETP_ID,
					KM_START,
					KM_FINISH,
					START_DATE,
					FINISH_DATE,
					IS_OFFTIME,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				) 
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,					
					<cfif len(arguments.first_km)>#arguments.first_km#<cfelse>NULL</cfif>,
					NULL,
					<cfif len(arguments.start_date)>#arguments.start_date#<cfelse>NULL</cfif>,
                    NULL,
					0,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					#now()#
				)
			</cfquery>
			<cfquery name="ADD_HISTORY" datasource="#this.DSN#">
				INSERT INTO
					ASSET_P_HISTORY
				(
					ASSETP_ID,
					ASSETP,
					PROPERTY,
					DEPARTMENT_ID,
					DEPARTMENT_ID2,
					POSITION_CODE,
					STATUS,
					IS_SALES,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.assetp)#">,
					#arguments.property#,
					#arguments.department_id#,
					<cfif isdefined('arguments.department_id2') and len(arguments.department_id2)>#arguments.department_id2#<cfelseif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.position_code)>#arguments.position_code#<cfelse>NULL</cfif>,
					0,
					0,
					#now()#,
					#session.ep.userid#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				)
			</cfquery>
			<!--- Mulkiyet Kiralama ise  --->
			<cfif arguments.property eq 2>
				<cfquery name="ADD_RENT" datasource="#this.DSN#">
					INSERT INTO
						ASSET_P_RENT
						(
							ASSETP_ID,
							RENT_AMOUNT,
							RENT_AMOUNT_CURRENCY,
							RENT_PAYMENT_PERIOD,
							RENT_START_DATE,
							RENT_FINISH_DATE,
							FUEL_EXPENSE,
							FUEL_AMOUNT,
							FUEL_AMOUNT_CURRENCY,
							CARE_EXPENSE,
							CARE_AMOUNT,
							CARE_AMOUNT_CURRENCY,
							STATUS,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							<cfif isDefined("arguments.rent_amount") and len(arguments.rent_amount)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.rent_amount#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.rent_amount_currency") and len(arguments.rent_amount_currency)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.rent_amount_currency#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.rent_payment_period") and len(arguments.rent_payment_period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rent_payment_period#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.rent_start_date") and len(arguments.rent_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.rent_start_date#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.rent_finish_date") and len(arguments.rent_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.rent_finish_date#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.is_fuel_added") and len(arguments.is_fuel_added)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_fuel_added#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.fuel_amount") and len(arguments.fuel_amount)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuel_amount#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.fuel_amount_currency") and len(arguments.fuel_amount_currency)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuel_amount_currency#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.is_care_added") and len(arguments.is_care_added)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_care_added#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.care_amount") and len(arguments.care_amount)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.care_amount#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.care_amount_currency") and len(arguments.care_amount_currency)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.care_amount_currency#"><cfelse>NULL</cfif>,					
							1,						
							#now()#,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						)
				</cfquery>
			</cfif>
			<!--- Mulkiyet Sozlesme ise  --->
			<cfif arguments.property eq 4>
				<cfquery name="add_asset_care_contract" datasource="#this.DSN#">
					INSERT INTO
						ASSET_CARE_CONTRACT
						(
							ASSET_ID
							,SUPPORT_COMPANY_ID
							,SUPPORT_AUTHORIZED_ID
							,SUPPORT_EMPLOYEE_ID
							,SUPPORT_START_DATE
							,SUPPORT_FINISH_DATE
							,SUPPORT_CAT_ID
							,USE_CERTIFICATE
							,USE_CERTIFICATE_SERVER_ID
							,DETAIL
							,CONTRACT_HEAD
							,IS_RENT
							,RECORD_DATE
							,RECORD_EMP
							,RECORD_IP
							,PROJECT_ID
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							<cfif isDefined("arguments.company_id") and len(arguments.company_id) and isDefined("arguments.support_company_id") and len(arguments.support_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.authorized_id") and len(arguments.authorized_id) and isDefined("arguments.support_authorized_id") and len(arguments.support_authorized_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authorized_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.support_position_id") and len(arguments.support_position_id) and isDefined("arguments.support_position_name") and len(arguments.support_position_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.support_position_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.support_start_date") and len(arguments.support_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.support_start_date#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.support_finish_date") and len(arguments.support_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.support_finish_date#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.support_cat") and len(arguments.support_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.support_cat#"><cfelse>NULL</cfif>,
							NULL,
							NULL,
							<cfif isDefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.contract_head") and len(arguments.contract_head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.contract_head#"><cfelse>NULL</cfif>,
							NULL,
							#now()#,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfif isDefined("arguments.project_id") and len(arguments.project_id) and isDefined("arguments.project_head") and len(arguments.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>
						)
				</cfquery>
			</cfif>	 
            <cfreturn MAX_ID.IDENTITYCOL>      
     </cffunction>   
      <!---  Araç Güncelleme Güncelleme  --->
     <cffunction name="updAssetpFnc" access="public" returntype="any">
       				 <cfargument name="PROPERTY" default="">,
					<cfargument name="INVENTORY_NUMBER" default="">,
					<cfargument name="ASSETP" default="">,
					<cfargument name="SUP_COMPANY_ID" default="">,
					<cfargument name="SUP_PARTNER_ID" default="">,
					<cfargument name="SUP_CONSUMER_ID" default="">,				
					<cfargument name="ASSETP_CATID" default="">,
					<cfargument name="ASSETP_SUB_CATID" default="">,
					<cfargument name="DEPARTMENT_ID" default="">,
					<cfargument name="DEPARTMENT_ID2" default="">,
					<cfargument name="EMP_ID" default="">,
					<cfargument name="POSITION_CODE" default="">,
					<cfargument name="MEMBER_TYPE" default="">,
					<cfargument name="POSITION_CODE2" default="">,
					<cfargument name="MEMBER_TYPE_2" default="">,
					<cfargument name="START_DATE" default="">,                    
					<cfargument name="first_date_km" default="">,
					<cfargument name="FIRST_KM" default="">,
					<cfargument name="FUEL_TYPE" default="">,
					<cfargument name="ASSETP_STATUS" default="">,
					<cfargument name="USAGE_PURPOSE_ID" default="">,
					<cfargument name="ASSETP_GROUP" default="">,
					<cfargument name="BRAND_ID" default="">,
					<cfargument name="BRAND_TYPE_ID" default="">,
					<cfargument name="BRAND_TYPE_CAT_ID" default="">,				
					<cfargument name="MAKE_YEAR" default="">,
					<cfargument name="ASSETP_DETAIL" default="">,
					<cfargument name="STATUS" default="">,
					<cfargument name="IS_SALES" default="">,
					<cfargument name="IS_COLLECTIVE_USAGE" default="">,
					<cfargument name="OTHER_MONEY" default="">,
					<cfargument name="OTHER_MONEY_VALUE" default="">,
						<cfargument name="asset_vehicle_width" default="">,
						<cfargument name="asset_vehicle_size" default="">,
						<cfargument name="asset_vehicle_height" default="">,					
					<cfargument name="PROCESS_STAGE" default="">,
					<cfargument name="RECORD_DATE" default="">,
					<cfargument name="RECORD_EMP" default="">,
                    <cfargument name="relation_asset_id" default="">,
					<cfargument name="RECORD_IP" default="">
                    <cfargument name="rent_amount" default="">
        			<cfargument name="rent_amount_currency" type="string" required="no" default="">
        			<cfargument name="rent_payment_period" default=""> 
                     <cfargument name="rent_start_date"  default="">
                     <cfargument name="rent_finish_date"  default="">
                     <cfargument name="is_fuel_added" default="">
        			<cfargument name="is_care_added" default=""> 
                    <cfargument name="fuel_amount" default="">
        			<cfargument name="fuel_amount_currency" type="string" required="no" default="">  
       				 <cfargument name="care_amount" default="">
        			<cfargument name="care_amount_currency" type="string" required="no" default="">
                    <cfargument name="care_warning_day" default=""> 
                    <cfargument name="get_date" default=""> 
                    <cfargument name="get_exit_date" default="">
                    <cfargument name="km_date_first" default="">
                   <cfargument name="new_assetp_group" default="">
                   <cfargument name="option_km" default="">
                   <cfargument name="new_usage_purpose_id" default="">
                   <cfargument name="ozel_kod" default="">
                   <cfargument name="old_property" default="">
                   <cfargument name="assetp_id" default="">
                   <cfargument name="old_first_km_date" default="">
				   <cfargument name="position_name2" default="">
				   <cfargument name="contract_head" default="">  
				   <cfargument name="company_id" default="">
				   <cfargument name="support_company_id" default="">
				   <cfargument name="authorized_id" default="">
				   <cfargument name="support_authorized_id" default="">
				   <cfargument name="support_position_id" default="">
				   <cfargument name="support_position_name" default="">
				   <cfargument name="support_start_date" default="">
				   <cfargument name="support_finish_date" default="">
				   <cfargument name="project_id" default="">
				   <cfargument name="project_head" default="">
				   <cfargument name="support_cat" default="">
				   <cfargument name="detail" default="">
				   

        <cfquery name="update_asset_p" datasource="#this.dsn#">
			UPDATE
				ASSET_P
			SET
				ASSETP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.assetp)#">,
				PROCESS_STAGE = <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
				ASSETP_CATID = #arguments.assetp_catid#,
                ASSETP_SUB_CATID = <cfif len(arguments.assetp_sub_catid)>#arguments.assetp_sub_catid#<cfelse>NULL</cfif>,
				ASSETP_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_detail#">,
				ASSETP_STATUS = <cfif len(arguments.assetp_status)>#arguments.assetp_status#<cfelse>NULL</cfif>,
				BRAND_ID = #arguments.brand_id#,
				BRAND_TYPE_CAT_ID = #arguments.brand_type_cat_id#,
				BRAND_TYPE_ID = #arguments.brand_type_id#,
				CARE_WARNING_DAY = <cfif len(arguments.care_warning_day)>#arguments.care_warning_day#<cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
				DEPARTMENT_ID2 = <cfif isDefined("arguments.department_id2") and len(arguments.department_id2)>#arguments.department_id2#<cfelseif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
				FIRST_KM = <cfif len(arguments.first_km)>#arguments.first_km#<cfelse>NULL</cfif>,
				FUEL_TYPE = <cfif len(arguments.fuel_type)>#arguments.fuel_type#<cfelse>NULL</cfif>,
				SUP_COMPANY_DATE = <cfif len(arguments.get_date)>#arguments.get_date#<cfelse>NULL</cfif>,
				EXIT_DATE = <cfif len(arguments.get_exit_date)>#arguments.get_exit_date#<cfelse>NULL</cfif>,
				INVENTORY_NUMBER = <cfif len(arguments.inventory_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.inventory_number#"><cfelse>NULL</cfif>,
				IS_COLLECTIVE_USAGE = <cfif isdefined('arguments.is_collective_usage') and arguments.is_collective_usage eq 1>1<cfelse>0</cfif>,
				FIRST_KM_DATE = <cfif len(arguments.km_date_first)>#arguments.km_date_first#<cfelse>NULL</cfif>,
				MAKE_YEAR = <cfif len(arguments.make_year)>#arguments.make_year#<cfelse>NULL</cfif>,
				ASSETP_GROUP = <cfif isdefined('arguments.new_assetp_group') and len(arguments.new_assetp_group)>#arguments.new_assetp_group#<cfelse>NULL</cfif>,
				USAGE_PURPOSE_ID = <cfif isdefined('arguments.new_usage_purpose_id') and len(arguments.new_usage_purpose_id)>#arguments.new_usage_purpose_id#<cfelse>NULL</cfif>,
				OPTION_KM = <cfif len(arguments.option_km)>#arguments.option_km#<cfelse>NULL</cfif>,
				PRIMARY_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ozel_kod#">,
				EMPLOYEE_ID = <cfif len(arguments.emp_id)>#arguments.emp_id#<cfelse>NULL</cfif>,
				POSITION_CODE = <cfif len(arguments.position_code)>#arguments.position_code#<cfelse>NULL</cfif>,
                MEMBER_TYPE = <cfif isdefined('arguments.member_type') and len(arguments.member_type)>'#arguments.member_type#'<cfelse>NULL</cfif>,
				POSITION_CODE2 = <cfif len(arguments.position_code2) and len(arguments.position_name2)>#arguments.position_code2#<cfelse>NULL</cfif>,
                MEMBER_TYPE_2 = <cfif isdefined('arguments.member_type') and len(arguments.member_type_2)>'#arguments.member_type_2#'<cfelse>NULL</cfif>,
				PROPERTY = #arguments.property#,
				STATUS = <cfif isDefined("arguments.status") and arguments.status eq 1>1<cfelse>0</cfif>,
				<cfif isDefined("arguments.sup_company_id") and len(arguments.sup_company_id)>
					SUP_COMPANY_ID = #arguments.sup_company_id#,
					SUP_PARTNER_ID = <cfif isDefined("arguments.sup_partner_id") and len(arguments.sup_partner_id)>#arguments.sup_partner_id#<cfelse>NULL</cfif>,
					SUP_CONSUMER_ID =NULL,				
				<cfelse>
					SUP_COMPANY_ID = NULL,
					SUP_PARTNER_ID = NULL,
					SUP_CONSUMER_ID = #arguments.sup_consumer_id#,
				</cfif>
				<cfif isdefined('x_dimension') and x_dimension eq 1>
					PHYSICAL_ASSETS_WIDTH = <cfif isdefined('arguments.asset_vehicle_width') and len(arguments.asset_vehicle_width)>#arguments.asset_vehicle_width#<cfelse>NULL</cfif>,
					PHYSICAL_ASSETS_SIZE = <cfif isdefined('arguments.asset_vehicle_size') and len(arguments.asset_vehicle_size)>#arguments.asset_vehicle_size#<cfelse>NULL</cfif>,
					PHYSICAL_ASSETS_HEIGHT = <cfif isdefined('arguments.asset_vehicle_height') and len(arguments.asset_vehicle_height)>#arguments.asset_vehicle_height#<cfelse>NULL</cfif>,
				</cfif>
				OTHER_MONEY = <cfif isdefined("arguments.assetp_other_money") and len(arguments.assetp_other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_other_money#"><cfelse>NULL</cfif>,
				OTHER_MONEY_VALUE = <cfif isdefined("arguments.assetp_other_money_value") and len(arguments.assetp_other_money_value)>#arguments.assetp_other_money_value#<cfelse>NULL</cfif>,				
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				RELATION_PHYSICAL_ASSET_ID = <cfif isdefined('arguments.relation_asset_id') and len(arguments.relation_asset_id) and isdefined('relation_asset') and len(relation_asset)>#arguments.relation_asset_id#<cfelse>NULL</cfif>
			WHERE
				ASSETP_ID = #arguments.assetp_id#
		</cfquery>
		
		<cfif isDefined("arguments.status") and arguments.status eq 1>
			<cfif (arguments.first_km is not arguments.o_first_km)>
				<cfquery name="get_km" datasource="#this.dsn#">
					SELECT MIN(KM_CONTROL_ID) AS KM_CONTROL_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #arguments.assetp_id#
				</cfquery>
				<cfif len(get_km.km_control_id)>
					<cfquery name="update_first_km" datasource="#this.dsn#">
						UPDATE
							ASSET_P_KM_CONTROL
						SET
							KM_FINISH = <cfif len(arguments.first_km)>#arguments.first_km#<cfelse>NULL</cfif>,
							UPDATE_EMP = #session.ep.userid#,
							UPDATE_DATE = #now()#,
							UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						WHERE 
							KM_CONTROL_ID = #get_km.km_control_id#
					</cfquery>
				<cfelse>
					<cfquery name="add_first_km" datasource="#this.dsn#">
						INSERT INTO
							ASSET_P_KM_CONTROL
						(
							ASSETP_ID,
							KM_START,
							KM_FINISH,
							START_DATE,
							FINISH_DATE,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
						)
						VALUES 
						(
							#arguments.assetp_id#,
							0,
							<cfif len(arguments.first_km)>#arguments.first_km#<cfelse>0</cfif>,
							NULL,
							#arguments.km_date_first#,
							#session.ep.userid#,
							#now()#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						)
					</cfquery>
				</cfif>
			</cfif>
			<cfif arguments.old_first_km_date is not arguments.km_date_first>
				<cfquery name="get_km" datasource="#this.dsn#">
					SELECT MIN(KM_CONTROL_ID) AS KM_CONTROL_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #arguments.assetp_id#
				</cfquery>
				<cfif len(get_km.km_control_id)>
					<cfquery name="update_first_km_date" datasource="#this.dsn#">
						UPDATE
							ASSET_P_KM_CONTROL
						SET
							FINISH_DATE = <cfif len(km_date_first)>#arguments.km_date_first#<cfelse>NULL</cfif>,
							UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							UPDATE_EMP = #session.ep.userid#,
							UPDATE_DATE = #now()#
						WHERE 
							KM_CONTROL_ID = #get_km.km_control_id#
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		
			<cfif (arguments.old_property eq 2) or (arguments.old_property eq 4)>
				<cfquery name="apdate_asset_p_rent" datasource="#this.dsn#">
					UPDATE
						ASSET_P_RENT
					SET
						STATUS = 0
					WHERE
						ASSETP_ID = #arguments.assetp_id#			
				</cfquery>
			</cfif>
			<cfif arguments.property eq 2>
				<cfquery name="add_asset_p_rent" datasource="#this.dsn#">
					INSERT INTO
						ASSET_P_RENT
					(
						ASSETP_ID,
						RENT_AMOUNT,
						RENT_AMOUNT_CURRENCY,
						RENT_PAYMENT_PERIOD,
						RENT_START_DATE,
						RENT_FINISH_DATE,
						FUEL_EXPENSE,
						FUEL_AMOUNT,
						FUEL_AMOUNT_CURRENCY,
						CARE_EXPENSE,
						CARE_AMOUNT,
						CARE_AMOUNT_CURRENCY,
						STATUS,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#arguments.assetp_id#,
						<cfif isDefined("arguments.rent_amount") and len(arguments.rent_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rent_amount#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.rent_amount_currency") and len(arguments.rent_amount_currency)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.rent_amount_currency#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.rent_payment_period") and len(arguments.rent_payment_period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rent_payment_period#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.rent_start_date") and len(arguments.rent_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.rent_start_date#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.rent_finish_date") and len(arguments.rent_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.rent_finish_date#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.is_fuel_added") and len(arguments.is_fuel_added)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_fuel_added#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.fuel_amount") and len(arguments.fuel_amount)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuel_amount#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.fuel_amount_currency") and len(arguments.fuel_amount_currency)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.fuel_amount_currency#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.is_care_added") and len(arguments.is_care_added)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_care_added#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.care_amount") and len(arguments.care_amount)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.care_amount#"><cfelse>NULL</cfif>,
						<cfif isDefined("arguments.care_amount_currency") and len(arguments.care_amount_currency)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.care_amount_currency#"><cfelse>NULL</cfif>,					
						1,						
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
			<cfelseif arguments.property eq 4>
				<cfquery name="add_asset_care_contract" datasource="#this.dsn#">
					IF NOT EXISTS(SELECT ASSET_CARE_CONTRACT_ID FROM ASSET_CARE_CONTRACT WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#">)
					BEGIN
						INSERT INTO
						ASSET_CARE_CONTRACT
						(
							ASSET_ID
							,SUPPORT_COMPANY_ID
							,SUPPORT_AUTHORIZED_ID
							,SUPPORT_EMPLOYEE_ID
							,SUPPORT_START_DATE
							,SUPPORT_FINISH_DATE
							,SUPPORT_CAT_ID
							,USE_CERTIFICATE
							,USE_CERTIFICATE_SERVER_ID
							,DETAIL
							,CONTRACT_HEAD
							,IS_RENT
							,RECORD_DATE
							,RECORD_EMP
							,RECORD_IP
							,PROJECT_ID
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#">,
							<cfif isDefined("arguments.company_id") and len(arguments.company_id) and isDefined("arguments.support_company_id") and len(arguments.support_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.authorized_id") and len(arguments.authorized_id) and isDefined("arguments.support_authorized_id") and len(arguments.support_authorized_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authorized_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.support_position_id") and len(arguments.support_position_id) and isDefined("arguments.support_position_name") and len(arguments.support_position_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.support_position_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.support_start_date") and len(arguments.support_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.support_start_date#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.support_finish_date") and len(arguments.support_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.support_finish_date#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.support_cat") and len(arguments.support_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.support_cat#"><cfelse>NULL</cfif>,
							NULL,
							NULL,
							<cfif isDefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
							<cfif isDefined("arguments.contract_head") and len(arguments.contract_head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.contract_head#"><cfelse>NULL</cfif>,
							NULL,
							#now()#,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfif isDefined("arguments.project_id") and len(arguments.project_id) and isDefined("arguments.project_head") and len(arguments.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>
						)
					END
					ELSE
					BEGIN
						UPDATE ASSET_CARE_CONTRACT
						SET
							SUPPORT_COMPANY_ID = <cfif isDefined("arguments.company_id") and len(arguments.company_id) and isDefined("arguments.support_company_id") and len(arguments.support_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>
							,SUPPORT_AUTHORIZED_ID = <cfif isDefined("arguments.authorized_id") and len(arguments.authorized_id) and isDefined("arguments.support_authorized_id") and len(arguments.support_authorized_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authorized_id#"><cfelse>NULL</cfif>
							,SUPPORT_EMPLOYEE_ID = <cfif isDefined("arguments.support_position_id") and len(arguments.support_position_id) and isDefined("arguments.support_position_name") and len(arguments.support_position_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.support_position_id#"><cfelse>NULL</cfif>
							,SUPPORT_START_DATE = <cfif isDefined("arguments.support_start_date") and len(arguments.support_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.support_start_date#"><cfelse>NULL</cfif>
							,SUPPORT_FINISH_DATE = <cfif isDefined("arguments.support_finish_date") and len(arguments.support_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.support_finish_date#"><cfelse>NULL</cfif>
							,SUPPORT_CAT_ID = <cfif isDefined("arguments.support_cat") and len(arguments.support_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.support_cat#"><cfelse>NULL</cfif>
							,USE_CERTIFICATE = NULL
							,USE_CERTIFICATE_SERVER_ID = NULL
							,DETAIL = <cfif isDefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>
							,CONTRACT_HEAD = <cfif isDefined("arguments.contract_head") and len(arguments.contract_head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.contract_head#"><cfelse>NULL</cfif>
							,IS_RENT = NULL
							,UPDATE_DATE = #now()#
							,UPDATE_EMP = #session.ep.userid#
							,UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
							,PROJECT_ID = <cfif isDefined("arguments.project_id") and len(arguments.project_id) and isDefined("arguments.project_head") and len(arguments.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>
						WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#">
					END
				</cfquery>
			</cfif>
              <cfreturn true>
      </cffunction> 
       <!---  Araç Listeleme --->
      <cffunction name="GET_ASSETP_FNC" returntype="query"> 
            <cfargument name="assetp" default="">
            <cfargument name="assetp_id" default="">
            <cfargument name="is_active" default="">
            <cfargument name="is_collective_usage" default="">
            <cfargument name="assetp_catid" default="">
            <cfargument name="assetp_sub_catid" default="">
            <cfargument name="brand_name" default="">
            <cfargument name="brand_type_id" default="">
            <cfargument name="emp_id" default="">
            <cfargument name="employee_name" default="">
            <cfargument name="keyword" default="">
            <cfargument name="make_year" default="">
            <cfargument name="property" default="">
            <cfargument name="branch" default="">
            <cfargument name="branch_id" default="">
			<cfargument name="position_cat_id" default="">
			<cfargument name="position_cat" default="">
            <cfargument name="department" default="">
			<cfargument name="department_id" default="">   
			<cfargument name="position_code" default="">     
			<cfargument name="position_name" default=""> 
			<cfargument name="sup_company_id" default=""> 
			<cfargument name="sup_partner_id" default=""> 
			<cfargument name="sup_consumer_id" default=""> 
			<cfargument name="company_id" default=""> 
            <cfquery name="GET_VEHICLES" datasource="#this.DSN#">
	SELECT 
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P.INVENTORY_NUMBER,
		ASSET_P.POSITION_CODE,
		ASSET_P.EMPLOYEE_ID,
		ASSET_P.MEMBER_TYPE,
		ASSET_P.PROPERTY,
		ASSET_P.STATUS,
		ASSET_P.ASSETP_STATUS,
		ASSET_P.BRAND_TYPE_CAT_ID,
		ASSET_P.BRAND_TYPE_ID,
        ASSET_STATE.ASSET_STATE,
		BRANCH.BRANCH_NAME,
		ASSET_P.MAKE_YEAR,
		ASSET_P.SUP_COMPANY_ID,
		ASSET_P.SUP_PARTNER_ID,
		ASSET_P.SUP_CONSUMER_ID,
		ASSET_P_CAT.ASSETP_CAT,
        ASSET_P_SUB_CAT.ASSETP_SUB_CAT,
		DEPARTMENT.DEPARTMENT_HEAD,
        EMPLOYEE_POSITIONS.EMPLOYEE_NAME +' ' +EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME EMPLOYEE_NAME, 
		EMPLOYEE_POSITIONS.POSITION_NAME,
		SETUP_POSITION_CAT.POSITION_CAT,
		(
            SELECT 
                TOP 1 FINISH_DATE
            FROM 
                EMPLOYEES_IN_OUT EIO_2,
                EMPLOYEE_POSITIONS
            WHERE 
                EIO_2.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
                EMPLOYEE_POSITIONS.POSITION_CODE = ASSET_P.POSITION_CODE
            ORDER BY 
                START_DATE 
            DESC
        ) AS FINISH_DATE
	FROM 
		ASSET_P
	        LEFT JOIN ASSET_STATE ON ASSET_P.ASSETP_STATUS = ASSET_STATE.ASSET_STATE_ID
            LEFT JOIN EMPLOYEE_POSITIONS ON ASSET_P.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND IS_MASTER = 1
			LEFT JOIN ASSET_P_SUB_CAT ON ASSET_P_SUB_CAT.ASSETP_CATID=ASSET_P.ASSETP_CATID AND ASSET_P_SUB_CAT.ASSETP_SUB_CATID=ASSET_P.ASSETP_SUB_CATID
			LEFT JOIN SETUP_POSITION_CAT ON ASSET_P.POSITION_CODE = SETUP_POSITION_CAT.POSITION_CAT_ID,

		ASSET_P_CAT,
		DEPARTMENT,
		BRANCH
	WHERE		
		<!--- Sadece yetkili olunan şubeler gözüksün.---> 
		<!--- (ASSET_P.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) OR  ) --->
		BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)	AND
		ISNULL(ASSET_P.DEPARTMENT_ID2,ASSET_P.DEPARTMENT_ID) = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
		ASSET_P_CAT.MOTORIZED_VEHICLE = 1
		<cfif len(arguments.assetp) and len(arguments.assetp_id)>AND ASSET_P.ASSETP_ID = #arguments.assetp_id#</cfif>
		<cfif isdefined('arguments.is_active') and len(arguments.is_active) and (arguments.is_active neq 2)>AND ASSET_P.STATUS = #arguments.is_active#</cfif>
		<cfif isdefined('arguments.is_collective_usage') and len(arguments.is_collective_usage) and (arguments.is_collective_usage eq 1)>AND ASSET_P.IS_COLLECTIVE_USAGE = #is_collective_usage#</cfif>
		<cfif isdefined('arguments.assetp_catid') and  len(arguments.assetp_catid)>AND ASSET_P.ASSETP_CATID = #arguments.assetp_catid#</cfif>
        <cfif isdefined('arguments.assetp_sub_catid') and  len(arguments.assetp_sub_catid)>AND ASSET_P.ASSETP_SUB_CATID = #arguments.assetp_sub_catid#</cfif>
		<cfif len(arguments.brand_name) and len(arguments.brand_type_id)>AND ASSET_P.BRAND_TYPE_ID = #arguments.brand_type_id#</cfif>
		<cfif len(arguments.emp_id) and len(arguments.employee_name)>
			<cfif arguments.emp_id gt 0>
				AND ASSET_P.EMPLOYEE_ID = #arguments.emp_id#
			<cfelse>
				AND ASSET_P.EMPLOYEE_ID IN (SELECT TOP 1 POSITION_CODE FROM EMPLOYEE_POSITIONS_HISTORY WHERE EMPLOYEE_ID IS NOT NULL AND EMPLOYEE_ID = #arguments.emp_id#)
			</cfif>
		</cfif>
		<cfif len(arguments.keyword)>
		AND (
				ASSET_P.ASSETP LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' OR 
				ASSET_P.INVENTORY_NUMBER LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' OR
				ASSET_P.ASSETP_ID IN (SELECT ASSETP_ID FROM ASSET_P_INFO_PLUS WHERE IDENTIFICATION_NUMBER LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%')
			)
		</cfif>
		<cfif isDefined("arguments.make_year") and len(arguments.make_year)>AND ASSET_P.MAKE_YEAR = #arguments.make_year#</cfif>
		<cfif isDefined("arguments.property") and len(arguments.property)>AND ASSET_P.PROPERTY = #arguments.property#</cfif>
		<cfif isDefined("arguments.branch") and len(arguments.branch) and len(arguments.branch_id)>AND BRANCH.BRANCH_ID = #arguments.branch_id#</cfif>
		<cfif isdefined("arguments.position_cat_id") and len(arguments.position_cat_id)>
			AND ASSET_P.POSITION_CODE IN (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = ASSET_P.POSITION_CODE AND EP.POSITION_CAT_ID = #arguments.position_cat_id#)
		</cfif>
		<cfif isDefined("arguments.department") and  len(arguments.department) and len(arguments.department_id)>AND ASSET_P.DEPARTMENT_ID = #arguments.department_id#</cfif>
		<cfif isDefined("arguments.sup_company_id") and len(arguments.sup_company_id)>AND ASSET_P.SUP_COMPANY_ID = #arguments.sup_company_id#</cfif>
		<cfif isDefined("arguments.sup_partner_id") and len(arguments.sup_partner_id)>AND ASSET_P.SUP_PARTNER_ID = #arguments.sup_partner_id#</cfif>
		<cfif isDefined("arguments.sup_consumer_id") and len(arguments.sup_consumer_id)>AND ASSET_P.SUP_CONSUMER_ID = #arguments.sup_consumer_id#</cfif>
		<cfif isDefined("arguments.company_id") and len(arguments.company_id)>AND BRANCH.COMPANY_ID = #arguments.company_id#</cfif>
	ORDER BY 
		ASSET_P.ASSETP 
		</cfquery>
            <cfreturn GET_VEHICLES>
          </cffunction> 
</cfcomponent> 
