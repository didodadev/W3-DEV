<cfcomponent>
    <!---  IT Varlık Ekleme   --->
    <cffunction name="addAssetpItFnc" access="public" returntype="any">
    	<cfargument name="assetp" type="string" required="no">
		<cfargument name="barcode" default="">
        <cfargument name="inventory_number" default="">
		<cfargument name="sup_company_id" default="">
		<cfargument name="sup_partner_id" default="">
		<cfargument name="sup_consumer_id"  default="">
        <cfargument name="assetp_catid" default="">
		<cfargument name="assetp_sub_catid"  default="">
		<cfargument name="department_id" default="">
		<cfargument name="department_id2" default="">
		<cfargument name="position_code" default="">
        <cfargument name="company_partner_id" default="">
        <cfargument name="brand_id" default="">
        <cfargument name="brand_type_id" default="">
        <cfargument name="brand_type_cat_id" default="">
        <cfargument name="assetp_detail" type="string" required="no" default="">
        <cfargument name="make_year" default="">
        <cfargument name="company_relation_id" default="">
        <cfargument name="is_collective_usage" default="">
        <cfargument name="relation_asset_id" default="">
        <cfargument name="serial_number" type="string" required="no" default="">
        <cfargument name="status" default="">
        <cfargument name="special_code" default="">
		<cfargument name="usage_purpose_id" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="property" default="">
        <cfargument name="position_code2" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="assetp_other_money" default="">
        <cfargument name="assetp_other_money_value" default="">
        <cfargument name="emp_id" default="">
        <cfargument name="MEMBER_TYPE_2" default="">
        <cfargument name="relation_asset" default="">
        <cfargument name="rent_amount" default="">
        <cfargument name="rent_amount_currency" type="string" required="no" default="">
        <cfargument name="rent_payment_period" default="">
        <cfargument name="rent_finish_date"  default="">
        <cfargument name="fuel_amount" default="">
        <cfargument name="fuel_amount_currency" type="string" required="no" default="">
        <cfargument name="is_fuel_added" default="" >
        <cfargument name="is_care_added" default="">
        <cfargument name="care_amount" default="">
        <cfargument name="care_amount_currency" type="string" required="no" default="">
        <cfargument name="assetp_group" default="">
        <cfargument name="start_date"  default="">     
        <cfargument name="rent_start_date" default="">
        <cfargument name="get_date" default="">
        <cfargument name="get_exit_date" default="">
        <cfargument name="transfer_date" default="">
        <cfargument name="assetp_id" default="">
        <cfargument name="old_property" default="">
        <cfargument name="keyword" default="">
        <cfargument name="branch_id" default="">
        <cfargument name="branch" default="">
        <cfargument name="department" default="">
        <cfargument name="employee_name" default="">
        <cfargument name="is_active" default="">
        <cfargument name="brand_name" default="">
        <cfargument name="order_type" default="1">
        <cfargument name="inventory_no" default="">
		<cfargument name="assetp_status" default="">
        <cfargument name="position2" default=""> 
		<cfargument name="assetp_space_id" default="">
        	<cfquery name="ADD_ASSETP" datasource="#this.DSN#" result="MAX_ID">
			INSERT INTO 
				ASSET_P
			(
				PROPERTY,
				BARCODE,
				INVENTORY_NUMBER,
				ASSETP,
				SUP_COMPANY_ID,
				SUP_PARTNER_ID,
				SUP_CONSUMER_ID,				
				ASSETP_CATID,
				DEPARTMENT_ID,
				DEPARTMENT_ID2,
				EMPLOYEE_ID,
				POSITION_CODE,
				POSITION_CODE2,
				COMPANY_PARTNER_ID,
				SUP_COMPANY_DATE,
				SERIAL_NO,
				PRIMARY_CODE,
				SERVICE_EMPLOYEE_ID,
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
                MEMBER_TYPE_2,
				PROCESS_STAGE,
                IS_IT,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				RELATION_PHYSICAL_ASSET_ID,
                ASSETP_SUB_CATID,
				ASSET_P_SPACE_ID
			)
			VALUES
			(
				#arguments.property#,
				<cfif len(arguments.barcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.barcode#"><cfelse>NULL</cfif>,
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
				<cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.department_id2)>#arguments.department_id2#<cfelse>NULL</cfif>,
				<cfif len(arguments.emp_id)>#arguments.emp_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.position_code) and len(arguments.employee_name)>#arguments.position_code#<cfelse>NULL</cfif>,
				<cfif len(arguments.position2) and len(arguments.position_code2)>#arguments.position_code2#<cfelse>NULL</cfif>,
				<cfif len(arguments.company_partner_id)>#arguments.company_partner_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.start_date)>#arguments.start_date#<cfelse>NULL</cfif>,
				<cfif len(arguments.serial_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serial_number#"><cfelse>NULL</cfif>,
				<cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
				<cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.assetp_status)>#arguments.assetp_status#<cfelse>NULL</cfif>,				
				<cfif isdefined('arguments.usage_purpose_id') and len(arguments.usage_purpose_id)>#arguments.usage_purpose_id#<cfelse>NULL</cfif>,
				<cfif isdefined('arguments.assetp_group') and len(arguments.assetp_group)>#arguments.assetp_group#<cfelse>NULL</cfif>,
				<cfif isdefined('arguments.brand_id') and len(arguments.brand_id)>#arguments.brand_id#<cfelse>NULL</cfif>,
				<cfif isdefined('arguments.brand_type_id') and len(arguments.brand_type_id)>#arguments.brand_type_id#<cfelse>NULL</cfif>,
				<cfif isdefined('arguments.brand_type_cat_id') and len(arguments.brand_type_cat_id)>#arguments.brand_type_cat_id#<cfelse>NULL</cfif>,
				<cfif isdefined('arguments.make_year') and len(arguments.make_year)>#arguments.make_year#<cfelse>NULL</cfif>,
				<cfif len(arguments.assetp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_detail#"><cfelse>NULL</cfif>,
				<cfif len(arguments.status)>#arguments.status#<cfelse>NULL</cfif>,
				0,
				<cfif arguments.is_collective_usage eq 1>1<cfelse>0</cfif>,
				<cfif len(arguments.assetp_other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_other_money#"><cfelse>NULL</cfif>,
				<cfif len(arguments.assetp_other_money_value)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_other_money_value#"><cfelse>NULL</cfif>,
                <cfif len(arguments.position2) and len(arguments.MEMBER_TYPE_2)>'#arguments.MEMBER_TYPE_2#'<cfelse>NULL</cfif>,	
				<cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>#arguments.process_stage#<cfelse>NULL</cfif>,
                1,									
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,								
				<cfif len(arguments.relation_asset_id) and len(arguments.relation_asset)>#arguments.relation_asset_id#<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.assetp_sub_catid") and len(arguments.assetp_sub_catid)>#arguments.assetp_sub_catid#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.assetp_space_id") and len(arguments.assetp_space_id)>#arguments.assetp_space_id#<cfelse>NULL</cfif>
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
                IS_IT,
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
				<cfif len(arguments.department_id2)>#arguments.department_id2#<cfelse>NULL</cfif>,
				<cfif len(arguments.position_code)>#arguments.position_code#<cfelse>NULL</cfif>,
				0,
				0,
                1,
				#now()#,
				#session.ep.userid#,
				<cfif isDefined('cgi.remote_addr') and len(cgi.remote_addr)><cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"><cfelse>NULL</cfif>
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
                        STATUS,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        #MAX_ID.IDENTITYCOL#,
                        <cfif len(arguments.rent_amount)>#arguments.rent_amount#<cfelse>NULL</cfif>,
                        <cfif len(arguments.rent_amount_currency) and len(arguments.rent_amount)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rent_amount_currency#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.rent_payment_period)>#arguments.rent_payment_period#<cfelse>NULL</cfif>,
                        <cfif len(arguments.rent_start_date)>#arguments.rent_start_date#<cfelse>NULL</cfif>,
                        <cfif len(arguments.rent_finish_date)>#arguments.rent_finish_date#<cfelse>NULL</cfif>,
                        1,
                        #now()#,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
			</cfquery>
		</cfif>
		<!--- Mulkiyet Sozlesme ise  --->
		<cfif arguments.property eq 4>
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
                    RECORD_IP,
					
					IS_CARE_ADDED
                )
                VALUES
                (
                    #MAX_ID.IDENTITYCOL#,
                    <cfif len(arguments.rent_amount)>#arguments.rent_amount#<cfelse>NULL</cfif>,
                    <cfif len(arguments.rent_amount_currency) and len(arguments.rent_amount)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rent_amount_currency#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.rent_payment_period)>#arguments.rent_payment_period#<cfelse>NULL</cfif>,
                    <cfif len(arguments.rent_start_date)>#arguments.rent_start_date#<cfelse>NULL</cfif>,
                    <cfif len(arguments.rent_finish_date)>#arguments.rent_finish_date#<cfelse>NULL</cfif>,
                    <cfif isdefined(arguments.is_fuel_added) AND len(arguments.is_fuel_added)>#arguments.is_fuel_added#<cfelse>NULL</cfif>,
                    <cfif (arguments.is_fuel_added eq 1) and len(arguments.fuel_amount)>#arguments.fuel_amount#<cfelse>NULL</cfif>,
                    <cfif (arguments.is_fuel_added eq 1) and len(arguments.fuel_amount_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuel_amount_currency#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.is_care_added)>#arguments.is_care_added#<cfelse>NULL</cfif>,
                    <cfif (arguments.is_care_added eq 1) and len(arguments.care_amount)>#arguments.care_amount#<cfelse>NULL</cfif>,
                    <cfif (arguments.is_care_added eq 1) and len(arguments.care_amount)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.care_amount_currency#"><cfelse>NULL</cfif>,
                    1,
                    #now()#,
                    #session.ep.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					
					#arguments.is_care_added#
                )
		</cfquery>
		</cfif>	
            <cfreturn MAX_ID.IDENTITYCOL>      
     </cffunction> 
     <!---  IT Varlık Güncelleme Güncelleme  --->
     <cffunction name="updAssetpItFnc" access="public" returntype="any">
     <cfargument name="assetp" default="">
       	<cfargument name="barcode" default="">
        <cfargument name="inventory_number" default="">
		<cfargument name="sup_company_id" default="">
		<cfargument name="sup_partner_id" default="">
		<cfargument name="sup_consumer_id"  default="">
        <cfargument name="assetp_catid" default="">
		<cfargument name="assetp_sub_catid"  default="">
		<cfargument name="department_id" default="">
		<cfargument name="department_id2" default="">
		<cfargument name="position_code" default="">
        <cfargument name="company_partner_id" default="">
        <cfargument name="brand_id" default="">
        <cfargument name="brand_type_id" default="">
        <cfargument name="brand_type_cat_id" default="">
        <cfargument name="assetp_detail" type="string" required="no" default="">
        <cfargument name="make_year" default="">
        <cfargument name="is_collective_usage" default="">
        <cfargument name="relation_asset_id" default="">
        <cfargument name="serial_number" type="string" required="no" default="">
        <cfargument name="assetp_status" default="">
        <cfargument name="status" default="">
        <cfargument name="special_code" default="">
		<cfargument name="usage_purpose_id" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="property" default="">
        <cfargument name="position_code2" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="assetp_other_money" default="">
        <cfargument name="assetp_other_money_value" default="">
        <cfargument name="emp_id" default="">
        <cfargument name="MEMBER_TYPE_2" default="">
        <cfargument name="relation_asset" default="">
        <cfargument name="assetp_group" default="">
        <cfargument name="get_date" default="">
        <cfargument name="get_exit_date" default="">
        <cfargument name="assetp_id" default="">
        <cfargument name="old_property" default="">        
        <cfargument name="employee_name" default=""> 
        <cfargument name="position2" default="">
		<cfargument name="rent_amount" default="">
		<cfargument name="rent_payment_period" default="">
		<cfargument name="rent_start_date" default="">
		<cfargument name="rent_finish_date" default="">
		<cfargument name="is_fuel_added" default="">
		
		<cfargument name="is_care_added" default="">
		<cfargument name="care_amount" default="">
		<cfargument name="rent_amount_currency" default="">
		<cfargument name="fuel_amount_currency" default="">
		<cfargument name="care_amount_curuency" default="">
		<cfargument name="assetp_space_id" default="">
        <cfquery name="UPD_ASSETP" datasource="#this.DSN#">
			UPDATE
				ASSET_P
			SET
				PROPERTY = #arguments.property#,
				BARCODE = <cfif len(arguments.barcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.barcode#"><cfelse>NULL</cfif>,
				INVENTORY_NUMBER = <cfif len(arguments.inventory_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.inventory_number)#"><cfelse>NULL</cfif>,
				ASSETP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.assetp)#">,
				<cfif isDefined("arguments.sup_company_id") and len(arguments.sup_company_id)>
					SUP_COMPANY_ID = #arguments.sup_company_id#,
					SUP_PARTNER_ID = <cfif isDefined("arguments.sup_partner_id") and len(arguments.sup_partner_id)>#arguments.sup_partner_id#<cfelse>NULL</cfif>,
					SUP_CONSUMER_ID = NULL,
				<cfelse>
					SUP_COMPANY_ID =  NULL,
					SUP_PARTNER_ID = NULL,
					SUP_CONSUMER_ID = #arguments.sup_consumer_id#,
				</cfif>				
				ASSETP_CATID = #arguments.assetp_catid#,
				DEPARTMENT_ID = <cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
				DEPARTMENT_ID2 = <cfif len(arguments.department_id2)>#arguments.department_id2#<cfelse>NULL</cfif>,
				EMPLOYEE_ID = <cfif len(arguments.emp_id) and len(arguments.employee_name)>#arguments.emp_id#<cfelse>NULL</cfif>,
				POSITION_CODE = <cfif len(arguments.position_code) and len(arguments.employee_name)>#arguments.position_code#<cfelse>NULL</cfif>,
				POSITION_CODE2 = <cfif len(arguments.position2) and len(arguments.position_code2)>#arguments.position_code2#<cfelse>NULL</cfif>,
                MEMBER_TYPE_2 = <cfif len(arguments.position2) and len(arguments.MEMBER_TYPE_2)>'#arguments.MEMBER_TYPE_2#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_ID = <cfif len(arguments.company_partner_id)>#arguments.company_partner_id#<cfelse>NULL</cfif>,
				SUP_COMPANY_DATE = <cfif len(arguments.get_date)>#arguments.get_date#<cfelse>NULL</cfif>,
				EXIT_DATE = <cfif len(arguments.get_exit_date)>#arguments.get_exit_date#<cfelse>NULL</cfif>,
				SERIAL_NO = <cfif len(arguments.serial_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serial_number#"><cfelse>NULL</cfif>,
				PRIMARY_CODE = <cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
				SERVICE_EMPLOYEE_ID = <cfif len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
				ASSETP_STATUS = <cfif len(arguments.assetp_status)>#arguments.assetp_status#<cfelse>NULL</cfif>,
				USAGE_PURPOSE_ID = <cfif isdefined('arguments.usage_purpose_id') and len(arguments.usage_purpose_id)>#arguments.usage_purpose_id#<cfelse>NULL</cfif>,
				ASSETP_GROUP = <cfif isdefined('arguments.assetp_group') and len(arguments.assetp_group)>#arguments.assetp_group#<cfelse>NULL</cfif>,
				BRAND_ID =<cfif isdefined('arguments.brand_id') and len(arguments.brand_id)>#arguments.brand_id#<cfelse>NULL</cfif>,
				BRAND_TYPE_ID = <cfif isdefined('arguments.brand_type_id') and len(arguments.brand_type_id)>#arguments.brand_type_id#<cfelse>NULL</cfif>,
				BRAND_TYPE_CAT_ID = <cfif isdefined('arguments.brand_type_cat_id') and len(arguments.brand_type_cat_id)>#arguments.brand_type_cat_id#<cfelse>NULL</cfif>,
				MAKE_YEAR = <cfif isdefined('arguments.make_year') and len(arguments.make_year)>#arguments.make_year#<cfelse>NULL</cfif>,
				ASSETP_DETAIL = <cfif len(arguments.assetp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_detail#"><cfelse>NULL</cfif>,
				STATUS = #arguments.status#,
				IS_SALES = 0,
				IS_COLLECTIVE_USAGE = <cfif arguments.is_collective_usage eq 1>1<cfelse>0</cfif>,
				OTHER_MONEY = <cfif len(arguments.assetp_other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assetp_other_money#"><cfelse>NULL</cfif>,
				OTHER_MONEY_VALUE = <cfif len(arguments.assetp_other_money_value)>#arguments.assetp_other_money_value#<cfelse>NULL</cfif>,
				PROCESS_STAGE=<cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>#arguments.process_stage#<cfelse>NULL</cfif>,
                IS_IT = 1,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfif isdefined("cgi.remote_addr") and len(cgi.remote_addr)><cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"><cfelse>NULL</cfif>,
				RELATION_PHYSICAL_ASSET_ID = <cfif len(arguments.relation_asset_id) and len(relation_asset)>#arguments.relation_asset_id#<cfelse>NULL</cfif>,
                ASSETP_SUB_CATID = <cfif isdefined("arguments.assetp_sub_catid") and len(arguments.assetp_sub_catid)>#arguments.assetp_sub_catid#<cfelse>NULL</cfif>,
				ASSET_P_SPACE_ID=<cfif isdefined("arguments.assetp_space_id") and len(arguments.assetp_space_id)>#arguments.assetp_space_id#<cfelse>NULL</cfif>
		
			WHERE
				ASSETP_ID = #arguments.assetp_id#
		</cfquery>
		<cfif len(arguments.rent_start_date)>
			<cf_date tarih="arguments.rent_start_date">
		</cfif>
		<cfif len(arguments.rent_finish_date)>
			<cf_date tarih="arguments.rent_finish_date">
		</cfif>
		
		<!--- Mulkiyet Bilgi Kayit --->
		<cfif arguments.property neq arguments.old_property>
			<cfif (arguments.old_property eq 2) or (arguments.old_property eq 4)>
				<cfquery name="UPD_ASSETP" datasource="#this.dsn#">
					UPDATE ASSET_P_RENT SET STATUS = 0 WHERE ASSETP_ID = #arguments.assetp_id#			
				</cfquery>
			</cfif>
			<cfif (arguments.property eq 2) or (arguments.property eq 4)>
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
                    RECORD_IP,
					
					IS_CARE_ADDED
                )
                VALUES
                (
                    #arguments.assetp_id#,
                    <cfif len(arguments.rent_amount)>#arguments.rent_amount#<cfelse>NULL</cfif>,
                    <cfif len(arguments.rent_amount_currency) and len(arguments.rent_amount)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rent_amount_currency#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.rent_payment_period)>#arguments.rent_payment_period#<cfelse>NULL</cfif>,
                    <cfif len(arguments.rent_start_date)>#arguments.rent_start_date#<cfelse>NULL</cfif>,
                    <cfif len(arguments.rent_finish_date)>#arguments.rent_finish_date#<cfelse>NULL</cfif>,
                    <cfif len(arguments.is_fuel_added)>#arguments.is_fuel_added#<cfelse>NULL</cfif>,
                    <cfif (arguments.is_fuel_added eq 1) and len(arguments.fuel_amount)>#arguments.fuel_amount#<cfelse>NULL</cfif>,
                    <cfif (arguments.is_fuel_added eq 1) and len(arguments.fuel_amount_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuel_amount_currency#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.is_care_added)>#arguments.is_care_added#<cfelse>NULL</cfif>,
                    <cfif (arguments.is_care_added eq 1) and len(arguments.care_amount)>#arguments.care_amount#<cfelse>NULL</cfif>,
                    <cfif (arguments.is_care_added eq 1) and len(arguments.care_amount)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.care_amount_currency#"><cfelse>NULL</cfif>,
                    1,
                    #now()#,
                    #session.ep.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					
					#arguments.is_care_added#
                )
		</cfquery>
				
			</cfif>
		<CFELSE>
				<cfquery name="UPD_RENT" datasource="#this.DSN#">
				UPDATE 
						ASSET_P_RENT
				SET
						RENT_AMOUNT =  <cfif len(arguments.rent_amount)>#arguments.rent_amount#<cfelse>NULL</cfif>,
						RENT_AMOUNT_CURRENCY = <cfif len(arguments.rent_amount_currency) and len(arguments.rent_amount)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rent_amount_currency#"><cfelse>NULL</cfif>,
						RENT_PAYMENT_PERIOD = <cfif len(arguments.rent_payment_period)>#arguments.rent_payment_period#<cfelse>NULL</cfif>,
						RENT_START_DATE = <cfif len(arguments.rent_start_date)>#arguments.rent_start_date#<cfelse>NULL</cfif>,
						RENT_FINISH_DATE = <cfif len(arguments.rent_finish_date)>#arguments.rent_finish_date#<cfelse>NULL</cfif>,
						<cfif arguments.property eq 4>
						FUEL_EXPENSE = <cfif len(arguments.is_fuel_added)>#arguments.is_fuel_added#<cfelse>NULL</cfif>,
						FUEL_AMOUNT =  <cfif (arguments.is_fuel_added eq 1) and len(arguments.fuel_amount)>#arguments.fuel_amount#<cfelse>NULL</cfif>,
						FUEL_AMOUNT_CURRENCY = <cfif (arguments.is_fuel_added eq 1) and len(arguments.fuel_amount_currency)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuel_amount_currency#"><cfelse>NULL</cfif>,
						CARE_EXPENSE =  <cfif len(arguments.is_care_added)>#arguments.is_care_added#<cfelse>NULL</cfif>,
						CARE_AMOUNT =  <cfif (arguments.is_care_added eq 1) and len(arguments.care_amount)>#arguments.care_amount#<cfelse>NULL</cfif>,
						CARE_AMOUNT_CURRENCY = <cfif (arguments.is_care_added eq 1) and len(arguments.care_amount)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.care_amount_currency#"><cfelse>NULL</cfif>,
						</cfif>
						STATUS = 1,
						RECORD_DATE =  #now()#,
						RECORD_EMP = #session.ep.userid#,
						RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	,
						
						IS_CARE_ADDED=#arguments.is_care_added#		
					
				WHERE
					ASSETP_ID = #arguments.assetp_id#	
				</cfquery>
		</cfif>
              <cfreturn true>
      </cffunction>
	<!---  Araç Listeleme --->
	<cffunction name="GET_ASSETP_IT_FNC" returntype="query"> 
		<cfargument name="keyword" default="">
		<cfargument name="is_active" default="">
		<cfargument name="is_collective_usage" default="">
		<cfargument name="assetp_catid" default="">
		<cfargument name="assetp_sub_catid" default="">
		<cfargument name="brand_name" default="">
		<cfargument name="brand_type_cat_id" default="">
		<cfargument name="emp_id" default="">   
		<cfargument name="employee_name" default="">         
		<cfargument name="make_year" default="">
		<cfargument name="property" default="">            
		<cfargument name="branch" default="">
		<cfargument name="branch_id" default=""> 
		<cfargument name="department" default="">      
		<cfargument name="department_id" default="">            
		<cfargument name="sup_company_id" default=""> 
		<cfargument name="sup_partner_id" default=""> 
		<cfargument name="sup_consumer_id" default=""> 
		<cfargument name="company_id" default=""> 
		<cfargument name="it_assept" default=""> 
		<cfargument name="ASSETP_STATUS" default=""> 
		<cfquery name="GET_ASSET_IT" datasource="#this.DSN#">
			SELECT 
				ASSET_P.ASSETP_ID,
				ASSET_P.ASSETP,
				ASSET_P.EMPLOYEE_ID,
				ASSET_P.POSITION_CODE,
				ASSET_P.POSITION_CODE2,
				ASSET_P.ASSETP_STATUS,
				ASSET_P.PROPERTY,
				ASSET_P.INVENTORY_NUMBER,
				ASSET_P.STATUS,
				ASSET_P.BRAND_TYPE_CAT_ID,
				ASSET_P.BRAND_TYPE_ID,
				ASSET_P.BARCODE,
				ASSET_P.SUP_COMPANY_ID,
				ASSET_P.SUP_PARTNER_ID,
				ASSET_P.SUP_CONSUMER_ID,
				ASSET_P.SERIAL_NO,
				ASSET_P.INVENTORY_NUMBER,
				ASSET_P.SUP_COMPANY_DATE,
				ASSET_P.DEPARTMENT_ID,
				ASSET_P_CAT.ASSETP_CAT,
				ASSET_P_CAT.IT_ASSET,
				ASSET_P_SUB_CAT.ASSETP_SUB_CAT,
				S_BRAND.BRAND_NAME,
				S_BRAND.BRAND_TYPE_NAME,
				S_BRAND.BRAND_TYPE_CAT_NAME,
				EP.EMPLOYEE_NAME,
				EP.EMPLOYEE_SURNAME,
				AST.ASSET_STATE,
				SETUP_ASSETP_GROUP.GROUP_NAME,
				ASSET_P_SPACE.SPACE_CODE,
				ASSET_P_SPACE.SPACE_NAME 
			FROM 
				ASSET_P
				LEFT JOIN ASSET_P_SPACE ON ASSET_P_SPACE.ASSET_P_SPACE_ID=ASSET_P.ASSET_P_SPACE_ID
				LEFT JOIN ASSET_STATE AST ON  ASSET_STATE_ID =ASSET_P.ASSETP_STATUS
				LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ASSET_P.EMPLOYEE_ID AND IS_MASTER = 1
				LEFT JOIN ASSET_P_SUB_CAT ON ASSET_P_SUB_CAT.ASSETP_CATID=ASSET_P.ASSETP_CATID AND ASSET_P_SUB_CAT.ASSETP_SUB_CATID=ASSET_P.ASSETP_SUB_CATID
				LEFT JOIN 
				(
						SELECT
							SETUP_BRAND.BRAND_NAME,
							SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID,
							SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
							SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME
						FROM
							SETUP_BRAND,
							SETUP_BRAND_TYPE,
							SETUP_BRAND_TYPE_CAT
						WHERE
							SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
							SETUP_BRAND.BRAND_ID = SETUP_BRAND_TYPE.BRAND_ID
				)S_BRAND ON S_BRAND.BRAND_TYPE_CAT_ID = ASSET_P.BRAND_TYPE_CAT_ID
				LEFT JOIN SETUP_ASSETP_GROUP ON SETUP_ASSETP_GROUP.GROUP_ID = ASSET_P.ASSETP_GROUP,
				ASSET_P_CAT
			WHERE		
				ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
				<cfif isdefined("arguments.it_assept") and len(arguments.it_assept) and arguments.it_assept eq 1>
					AND ASSET_P_CAT.IT_ASSET = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<cfelse> 
					AND ASSET_P_CAT.IT_ASSET = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				</cfif>
				<cfif len(arguments.keyword)>
				AND (
						ASSET_P.ASSETP LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
						ASSET_P.INVENTORY_NUMBER LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR 
						ASSET_P.BARCODE LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
						ASSET_P.SERIAL_NO LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
					)
				</cfif>
				<cfif len(arguments.is_active) and (arguments.is_active neq 2)>AND ASSET_P.STATUS = #arguments.is_active#</cfif>
				<cfif len(arguments.is_collective_usage) and (arguments.is_collective_usage eq 1)>AND ASSET_P.IS_COLLECTIVE_USAGE = #is_collective_usage#</cfif>
				<cfif len(arguments.assetp_catid)>AND ASSET_P.ASSETP_CATID = #arguments.assetp_catid# </cfif>
				<cfif len(arguments.assetp_sub_catid)>AND ASSET_P.ASSETP_SUB_CATID = #arguments.assetp_sub_catid#</cfif>
				<cfif len(arguments.assetp_status)>AND ASSET_P.ASSETP_STATUS = #arguments.assetp_status#</cfif>
				<cfif len(arguments.brand_name) and len(arguments.brand_type_cat_id)>AND ASSET_P.BRAND_TYPE_CAT_ID = #arguments.brand_type_cat_id#</cfif>
				<cfif len(arguments.emp_id) and len(arguments.employee_name)>AND ASSET_P.EMPLOYEE_ID = #arguments.emp_id#</cfif>
				<cfif len(arguments.make_year)>AND ASSET_P.MAKE_YEAR = #arguments.make_year#</cfif>
				<cfif isDefined("arguments.property") and len(arguments.property)>AND ASSET_P.PROPERTY = #arguments.property#</cfif>
				<cfif len(arguments.branch) and len(arguments.branch_id)>AND BRANCH.BRANCH_ID = #arguments.branch_id#</cfif>
				<cfif len(arguments.department) and len(arguments.department_id)>AND ASSET_P.DEPARTMENT_ID2 = #arguments.department_id#</cfif>
				<cfif isDefined("arguments.sup_company_id") and len(arguments.sup_company_id)>AND ASSET_P.SUP_COMPANY_ID = #arguments.sup_company_id#</cfif>
				<cfif isDefined("arguments.sup_partner_id") and len(arguments.sup_partner_id)>AND ASSET_P.SUP_PARTNER_ID = #arguments.sup_partner_id#</cfif>
				<cfif isDefined("arguments.sup_consumer_id") and len(arguments.sup_consumer_id)>AND ASSET_P.SUP_CONSUMER_ID = #arguments.sup_consumer_id#</cfif>
				<cfif isDefined("arguments.company_id") and len(arguments.company_id)>AND BRANCH.COMPANY_ID = #arguments.company_id#</cfif>
				<cfif len(arguments.asset_p_space_id) and len(arguments.asset_p_space_name)>AND ASSET_P.ASSET_P_SPACE_ID=#arguments.asset_p_space_id#</cfif>
			ORDER BY 
				ASSET_P.ASSETP 
		</cfquery>
		<cfreturn GET_ASSET_IT>
    </cffunction> 
	<cffunction name="GET_BRANCHS_DEPS" returntype="query">       
		<cfargument name="department_id" default="">            
		<cfquery name="GET_BRANCHS_DEPS" datasource="#this.DSN#">
			SELECT
				DEPARTMENT.DEPARTMENT_HEAD,
				BRANCH.BRANCH_NAME
			FROM
				BRANCH,
				DEPARTMENT
			WHERE
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		</cfquery>
		<cfreturn GET_BRANCHS_DEPS>
    </cffunction> 
</cfcomponent> 