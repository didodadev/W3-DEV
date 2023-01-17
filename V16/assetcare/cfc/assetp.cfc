<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="init" access="public" returntype="any" hint="">
	    <cfargument name="assetp" type="string" required="no">
		<cfargument name="barcode" default="">
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
        <cfargument name="physical_assets_width" default="">
        <cfargument name="physical_assets_height" default="">
        <cfargument name="physical_assets_size" default="">
        <cfargument name="make_year" default="">
        <cfargument name="company_relation_id" default="">
        <cfargument name="is_collective_usage" default="">
        <cfargument name="relation_asset_id" default="">
        <cfargument name="serial_number" type="string" required="no" default="">
        <cfargument name="assetp_status" default="">
        <cfargument name="special_code" default="">
		<cfargument name="usage_purpose_id" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="property" default="">
        <cfargument name="position_code2" default="">
        <cfargument name="inventory_number" default="">
        <cfargument name="fixtures_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="assetp_other_money" default="">
        <cfargument name="assetp_other_money_value" default="">
        <cfargument name="position2" default="">
        <cfargument name="emp_id" default="">
        <cfargument name="MEMBER_TYPE_2" default="">
        <cfargument name="relation_asset" default="">

        <cfscript>
			variable.assetp = arguments.assetp;
			variable.barcode = arguments.barcode;
			variable.sup_company_id = arguments.sup_company_id;
			variable.sup_partner_id = arguments.sup_partner_id;
			variable.sup_consumer_id = arguments.sup_consumer_id;
		    variable.assetp_catid = arguments.assetp_catid;
			variable.assetp_sub_catid = arguments.assetp_sub_catid;
			variable.department_id = arguments.department_id;
			variable.department_id2 = arguments.department_id2;
			variable.position_code = arguments.position_code;
			variable.company_partner_id = arguments.company_partner_id;
			variable.brand_id = arguments.brand_id;
		    variable.brand_type_id = arguments.brand_type_id;
			variable.brand_type_cat_id = arguments.brand_type_cat_id;
			variable.assetp_detail = arguments.assetp_detail;
			variable.physical_assets_width = arguments.physical_assets_width;
			variable.physical_assets_height = arguments.physical_assets_height;
			variable.physical_assets_size = arguments.physical_assets_size;
			variable.make_year = arguments.make_year;
			variable.company_relation_id = arguments.company_relation_id;
			variable.is_collective_usage = arguments.is_collective_usage;
			variable.relation_asset_id = arguments.relation_asset_id;
			variable.serial_number = arguments.serial_number;
			variable.assetp_status = arguments.assetp_status;
			variable.special_code = arguments.special_code;
			variable.usage_purpose_id = arguments.usage_purpose_id;
			variable.process_stage = arguments.process_stage;
			variable.property = arguments.property;
			variable.position_code2 = arguments.position_code2;
			variable.inventory_number = arguments.inventory_number;
			variable.fixtures_id = arguments.fixtures_id;
			variable.employee_id = arguments.employee_id;
			variable.assetp_other_money = arguments.assetp_other_money;
			variable.assetp_other_money_value = arguments.assetp_other_money_value;
			variable.position2 = arguments.position2;
			variable.emp_id = arguments.emp_id;
			variable.MEMBER_TYPE_2 = arguments.MEMBER_TYPE_2;
			variable.relation_asset = arguments.relation_asset;
		</cfscript>
        <cfreturn this>
    </cffunction>
    <!---  Fiziki Varlık Ekleme   --->
    <cffunction name="addAssetpFnc" access="public" returntype="any">
        <cfargument name="rent_amount" default="">
        <cfargument name="rent_amount_currency" type="string" required="no" default="">
        <cfargument name="rent_payment_period" default="">
        <cfargument name="rent_finish_date"  default="">
        <cfargument name="fuel_amount" default="">
        <cfargument name="fuel_amount_currency" type="string" required="no" default="">
        <cfargument name="is_fuel_added" default="">
        <cfargument name="is_care_added" default="">
        <cfargument name="care_amount" default="">
        <cfargument name="care_amount_currency" type="string" required="no" default="">
        <cfargument name="assetp_group" default="">
        <cfargument name="start_date"  default="">
        <cfargument name="rent_start_date" default="">
        <cfargument name="asset_p_space_id" default="">
        <cfargument name="status" default="">
        <cfargument name="property" default="">
        <cfargument name="coordinate_1" default="">
        <cfargument name="coordinate_2" default="">
		
        <cfquery name="ADD_ASSETP" datasource="#this.DSN#" result="MAX_ID">
			INSERT INTO 
				ASSET_P
			(
				PROPERTY,
				BARCODE,
				INVENTORY_NUMBER,
                INVENTORY_ID,
				ASSETP,
				SUP_COMPANY_ID,
				SUP_PARTNER_ID,
				SUP_CONSUMER_ID,			
				ASSETP_CATID,
                ASSETP_SUB_CATID,
				DEPARTMENT_ID,
				DEPARTMENT_ID2,
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
				RELATION_PHYSICAL_ASSET_ID,
			<cfif isdefined('x_dimension') and x_dimension eq 1>
				PHYSICAL_ASSETS_WIDTH,
				PHYSICAL_ASSETS_SIZE,
				PHYSICAL_ASSETS_HEIGHT,
                PHYSICAL_ASSETS_WEIGHT,
			</cfif>
            	COMPANY_RELATION_ID,
                COUNTRY_ID,
                FIRST_PORT,
                LAST_PORT,
                RAW_MATERIAL_ID,
                ELECTRIC_TYPE_ID,
                MEMBER_TYPE_2,
				EMPLOYEE_ID,
				PROCESS_STAGE,
                IS_IT,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				ASSET_P_SPACE_ID,
                COORDINATE_1,
                COORDINATE_2
			)
			VALUES
			(
				#variable.property#,
				<cfif len(variable.barcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.barcode#"><cfelse>NULL</cfif>,
				<cfif isdefined('variable.inventory_number') and len(variable.inventory_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(variable.inventory_number)#"><cfelse>NULL</cfif>, 
				<cfif isdefined('variable.fixtures_id') and len(variable.fixtures_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#variable.fixtures_id#"><cfelse>NULL</cfif>, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.assetp#">,
				<cfif isDefined("variable.sup_company_id") and len(variable.sup_company_id)>
					#variable.sup_company_id#,
					<cfif isDefined("variable.sup_partner_id") and len(variable.sup_partner_id)>#variable.sup_partner_id#<cfelse>NULL</cfif>,
					NULL,
				<cfelseif isdefined('variable.sup_consumer_id') and len(variable.sup_consumer_id)>
					NULL,
					NULL,
					#variable.sup_consumer_id#,
                <cfelse>
                	NULL,
                    NULL,
                    NULL,
				</cfif>	
				#variable.assetp_catid#,
                <cfif isdefined("variable.assetp_sub_catid") and len(variable.assetp_sub_catid)>#variable.assetp_sub_catid#<cfelse>NULL</cfif>,
				<cfif len(variable.department_id)>#variable.department_id#<cfelse>NULL</cfif>,
				<cfif isDefined("variable.department_id2") and len(variable.department_id2)>#variable.department_id2#<cfelseif len(variable.department_id)>#variable.department_id#<cfelse>NULL</cfif>,
				<cfif len(variable.position_code)>#variable.position_code#<cfelse>NULL</cfif>,
				<cfif len(variable.position_code2)>#variable.position_code2#<cfelse>NULL</cfif>,
				<cfif len(variable.company_partner_id)>#variable.company_partner_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.start_date)>#arguments.start_date#<cfelse>NULL</cfif>,
				<cfif len(variable.serial_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.serial_number#"><cfelse>NULL</cfif>,
				<cfif len(variable.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.special_code#"><cfelse>NULL</cfif>,
				<cfif len(variable.employee_id)>#variable.employee_id#<cfelse>NULL</cfif>,
				<cfif len(variable.assetp_status)>#variable.assetp_status#<cfelse>NULL</cfif>,
				<cfif len(variable.usage_purpose_id)>#variable.usage_purpose_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.assetp_group)>#arguments.assetp_group#<cfelse>NULL</cfif>,				
				<cfif len(variable.brand_id)>#variable.brand_id#<cfelse>NULL</cfif>,
				<cfif len(variable.brand_type_id)>#variable.brand_type_id#<cfelse>NULL</cfif>,
				<cfif len(variable.brand_type_cat_id)>#variable.brand_type_cat_id#<cfelse>NULL</cfif>,
				<cfif len(variable.make_year)>#variable.make_year#<cfelse>NULL</cfif>,
				<cfif len(variable.assetp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.assetp_detail#"><cfelse>NULL</cfif>,
				<cfif isdefined('arguments.status') and arguments.status eq 1>1<cfelse>0</cfif>,
				0,
				<cfif variable.is_collective_usage eq 1>1<cfelse>0</cfif>,
				<cfif len(variable.assetp_other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.assetp_other_money#"><cfelse>NULL</cfif>,
				<cfif len(variable.assetp_other_money_value)>'#variable.assetp_other_money_value#'<cfelse>NULL</cfif>,								
				<cfif len(variable.relation_asset_id) and len(variable.relation_asset)>#variable.relation_asset_id#<cfelse>NULL</cfif>,
				<cfif isdefined('x_dimension') and x_dimension eq 1>
                    <cfif len(variable.physical_assets_width)>#variable.physical_assets_width#<cfelse>NULL</cfif>,
                    <cfif len(variable.physical_assets_size)>#variable.physical_assets_size#<cfelse>NULL</cfif>,
                    <cfif len(variable.physical_assets_height)>#variable.physical_assets_height#<cfelse>NULL</cfif>,
                    <cfif isdefined("variable.physical_assets_weight") and len(variable.physical_assets_weight)>#variable.physical_assets_weight#<cfelse>NULL</cfif>,
                </cfif>
            	<cfif isdefined("arguments.company_relation_id") and len(arguments.company_relation_id)>#arguments.company_relation_id#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.physical_assets_flag") and len(arguments.physical_assets_flag)>#arguments.physical_assets_flag#<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.first_port") and len(arguments.first_port)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.first_port#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.last_port") and len(arguments.last_port)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.last_port#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.raw_material_id") and len(arguments.raw_material_id)>#arguments.raw_material_id#<cfelse>NULL</cfif>,
                <cfif isdefined("arguments.electric_type_id") and len(arguments.electric_type_id)>#arguments.electric_type_id#<cfelse>NULL</cfif>,
                <cfif len(variable.position2) and len(variable.MEMBER_TYPE_2)>'#variable.MEMBER_TYPE_2#'<cfelse>NULL</cfif>,
				<cfif len(variable.emp_id)>'#variable.emp_id#'<cfelse>NULL</cfif>,
				<cfif isdefined("variable.process_stage") and len(variable.process_stage)>#variable.process_stage#<cfelse>NULL</cfif>,
                0,
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif isdefined("arguments.asset_p_space_id") and len(arguments.asset_p_space_id)>#arguments.asset_p_space_id#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.coordinate_1") and len(arguments.coordinate_1)>#arguments.coordinate_1#<cfelse>NULL</cfif>,
				<cfif isdefined("arguments.coordinate_2") and len(arguments.coordinate_2)>#arguments.coordinate_2#<cfelse>NULL</cfif>
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
				POSITION_CODE2,
				STATUS,
				IS_SALES,
				USAGE_PURPOSE_ID,
				ASSETP_STATUS,
				ASSETP_DETAIL,
                IS_IT,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#MAX_ID.IDENTITYCOL#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.assetp#">,
				#variable.property#,
				#variable.department_id#,
				<cfif isDefined("variable.department_id2") and len(variable.department_id2)>#variable.department_id2#<cfelseif len(variable.department_id)>#variable.department_id#<cfelse>NULL</cfif>,
				<cfif len(variable.position_code)>#variable.position_code#<cfelse>NULL</cfif>,
				<cfif len(variable.position_code2)>#variable.position_code2#<cfelse>NULL</cfif>,
				0,
				0,
				<cfif len(variable.usage_purpose_id)>#variable.usage_purpose_id#<cfelse>NULL</cfif>,
				<cfif len(variable.assetp_status)>#variable.assetp_status#<cfelse>NULL</cfif>,
				<cfif len(variable.assetp_detail)>'#variable.assetp_detail#'<cfelse>NULL</cfif>,
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
					IS_FUEL_ADDED,
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
					#arguments.is_fuel_added#,
					#arguments.is_care_added#
                )
		</cfquery>
		</cfif>
		<cfif isdefined('arguments.sup_company_id') and len(arguments.sup_company_id) and isdefined('arguments.sup_partner_id') and len(arguments.sup_partner_id)>
        <cfquery name="add_relation_member" datasource="#this.dsn#">
                INSERT INTO 
                    RELATION_ASSETP_MEMBER
                (
                    ASSETP_ID,
                    COMPANY_ID,
                    PARTNER_ID
                )
                VALUES
                (
                    #MAX_ID.IDENTITYCOL#,
                    #arguments.sup_company_id#,
                    #arguments.sup_partner_id#
                )
          </cfquery>
          </cfif>
          <cfreturn MAX_ID.IDENTITYCOL>
     </cffunction>


    <!---  Fiziki Varlık Güncelleme  --->
    <cffunction name="updAssetpFnc" access="public" returntype="any">
        <cfargument name="assetp_group" default="">
        <cfargument name="rent_start_date" default="">
        <cfargument name="employee_name" default="">
        <cfargument name="get_date" default="">
        <cfargument name="get_exit_date" default="">
        <cfargument name="transfer_date" default="">
        <cfargument name="assetp_id" default="">
        <cfargument name="old_property" default="">
        <cfargument name="status" default="">
        <cfargument name="property" default="">
        <cfargument name="rent_amount" default="">
        <cfargument name="rent_amount_currency" default="">
        <cfargument name="rent_payment_period" default="">
        <cfargument name="rent_finish_date" default="">
        <cfargument name="is_fuel_added" default="">
        <cfargument name="fuel_amount" default="">
        <cfargument name="fuel_amount_currency" default="">
        <cfargument name="is_care_added" default="">
        <cfargument name="care_amount" default="">
        <cfargument name="asset_p_space_id" default="">
        <cfargument name="care_amount_currency" default="">
        <cfargument name="coordinate_1" default="">
        <cfargument name="coordinate_2" default="">

        <cfquery name="UPD_ASSETP" datasource="#this.DSN#">
			UPDATE
				ASSET_P
			SET
				PROPERTY = #variable.property#,
				BARCODE = <cfif len(variable.barcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.barcode#"><cfelse>NULL</cfif>,
				INVENTORY_NUMBER =  <cfif isdefined("variable.inventory_number") and len(variable.inventory_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.inventory_number#"><cfelse>NULL</cfif>,
				INVENTORY_ID = <cfif isdefined('variable.fixtures_id') and len(variable.fixtures_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#variable.fixtures_id#"><cfelse>NULL</cfif>, 
                ASSETP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.assetp#">,
				<cfif isDefined("variable.sup_company_id") and len(variable.sup_company_id)>
					SUP_COMPANY_ID = #variable.sup_company_id#,
					SUP_PARTNER_ID = <cfif isDefined("variable.sup_partner_id") and len(variable.sup_partner_id)>#variable.sup_partner_id#<cfelse>NULL</cfif>,
					SUP_CONSUMER_ID = NULL,
				<cfelseif isdefined('variable.sup_consumer_id') and len(variable.sup_consumer_id)>
					SUP_COMPANY_ID =  NULL,
					SUP_PARTNER_ID = NULL,
					SUP_CONSUMER_ID = #variable.sup_consumer_id#,
				</cfif>				
				ASSETP_CATID = #variable.assetp_catid#,
                ASSETP_SUB_CATID = <cfif isdefined("variable.assetp_sub_catid") and  len(variable.assetp_sub_catid)>#variable.assetp_sub_catid#<cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif len(variable.department_id)>#variable.department_id#<cfelse>NULL</cfif>,
				DEPARTMENT_ID2 = <cfif isDefined("variable.department_id2") and len(variable.department_id2)>#variable.department_id2#<cfelseif len(variable.department_id)>#variable.department_id#<cfelse>NULL</cfif>,
				EMPLOYEE_ID = <cfif len(variable.emp_id) and len(arguments.employee_name)>#variable.emp_id#<cfelse>NULL</cfif>,
				POSITION_CODE = <cfif len(variable.position_code)>#variable.position_code#<cfelse>NULL</cfif>,
				POSITION_CODE2 = <cfif len(variable.position2) and len(variable.position_code2)>#variable.position_code2#<cfelse>NULL</cfif>,
                MEMBER_TYPE_2 = <cfif len(variable.position2) and len(variable.MEMBER_TYPE_2)>'#variable.MEMBER_TYPE_2#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_ID = <cfif len(variable.company_partner_id)>#variable.company_partner_id#<cfelse>NULL</cfif>,
				SUP_COMPANY_DATE = <cfif len(arguments.get_date)>#arguments.get_date#<cfelse>NULL</cfif>,
				EXIT_DATE = <cfif len(arguments.get_exit_date)>#arguments.get_exit_date#<cfelse>NULL</cfif>,
				SERIAL_NO = <cfif len(variable.serial_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.serial_number#"><cfelse>NULL</cfif>,
				PRIMARY_CODE = <cfif len(variable.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.special_code#"><cfelse>NULL</cfif>,
				SERVICE_EMPLOYEE_ID = <cfif len(variable.employee_id)>#variable.employee_id#<cfelse>NULL</cfif>,
				ASSETP_STATUS = <cfif len(variable.assetp_status)>#variable.assetp_status#<cfelse>NULL</cfif>,
				USAGE_PURPOSE_ID = <cfif len(variable.usage_purpose_id)>#variable.usage_purpose_id#<cfelse>NULL</cfif>,
				ASSETP_GROUP = <cfif len(arguments.assetp_group)>#arguments.assetp_group#<cfelse>NULL</cfif>,
				BRAND_ID = <cfif len(variable.brand_id)>#variable.brand_id#<cfelse>NULL</cfif>,
				BRAND_TYPE_ID = <cfif len(variable.brand_type_id)>#variable.brand_type_id#<cfelse>NULL</cfif>,
				BRAND_TYPE_CAT_ID = <cfif len(variable.brand_type_cat_id)>#variable.brand_type_cat_id#<cfelse>NULL</cfif>,				
				MAKE_YEAR = <cfif len(variable.make_year)>#variable.make_year#<cfelse>NULL</cfif>,
				ASSETP_DETAIL = <cfif len(variable.assetp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.assetp_detail#"><cfelse>NULL</cfif>,
				STATUS = #arguments.status#,
				IS_SALES = 0,
				IS_COLLECTIVE_USAGE = <cfif variable.is_collective_usage eq 1>1<cfelse>0</cfif>,
				OTHER_MONEY = <cfif len(variable.assetp_other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#variable.assetp_other_money#"><cfelse>NULL</cfif>,
				OTHER_MONEY_VALUE = <cfif len(variable.assetp_other_money_value)>'#variable.assetp_other_money_value#'<cfelse>NULL</cfif>,
				RELATION_PHYSICAL_ASSET_ID = <cfif len(variable.relation_asset_id) and len(relation_asset)>#variable.relation_asset_id#<cfelse>NULL</cfif>,
			<cfif isdefined('x_dimension') and x_dimension eq 1>
				PHYSICAL_ASSETS_WIDTH = <cfif len(variable.physical_assets_width)>#variable.physical_assets_width#<cfelse>NULL</cfif>,
				PHYSICAL_ASSETS_SIZE = <cfif len(variable.physical_assets_size)>#variable.physical_assets_size#<cfelse>NULL</cfif>,
				PHYSICAL_ASSETS_HEIGHT = <cfif len(variable.physical_assets_height)>#variable.physical_assets_height#<cfelse>NULL</cfif>,
                PHYSICAL_ASSETS_WEIGHT = <cfif isdefined("variable.physical_assets_weight") and len(variable.physical_assets_weight)>#variable.physical_assets_weight#<cfelse>NULL</cfif>,
			</cfif>
            	COMPANY_RELATION_ID = <cfif isdefined("variable.company_relation_id") and len(variable.company_relation_id)>#variable.company_relation_id#<cfelse>NULL</cfif>,
				COUNTRY_ID = <cfif isdefined("arguments.physical_assets_flag") and len(arguments.physical_assets_flag)>#arguments.physical_assets_flag#<cfelse>NULL</cfif>,
				FIRST_PORT = <cfif isdefined("arguments.first_port") and len(arguments.first_port)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.first_port#"><cfelse>NULL</cfif>, 
                LAST_PORT = <cfif isdefined("arguments.last_port") and len(arguments.last_port)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.last_port#"><cfelse>NULL</cfif>,
                RAW_MATERIAL_ID = <cfif isdefined("arguments.raw_material_id") and len(arguments.raw_material_id)>#arguments.raw_material_id#<cfelse>NULL</cfif>,
                ELECTRIC_TYPE_ID = <cfif isdefined("arguments.electric_type_id") and len(arguments.electric_type_id)>#arguments.electric_type_id#<cfelse>NULL</cfif>,
                PROCESS_STAGE=<cfif isdefined("variable.process_stage") and len(variable.process_stage)>#variable.process_stage#<cfelse>NULL</cfif>,
				TRANSFER_DATE = <cfif len(arguments.transfer_date)>#arguments.transfer_date#<cfelse>NULL</cfif>,
                IS_IT = 0,
                UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				ASSET_P_SPACE_ID=<cfif isdefined("arguments.asset_p_space_id") and len(arguments.asset_p_space_id)>#arguments.asset_p_space_id#<cfelse>NULL</cfif>,
                COORDINATE_1 = <cfif isdefined("arguments.coordinate_1") and len(arguments.coordinate_1)>#arguments.coordinate_1#<cfelse>NULL</cfif>,
				COORDINATE_2 = <cfif isdefined("arguments.coordinate_2") and len(arguments.coordinate_2)>#arguments.coordinate_2#<cfelse>NULL</cfif>
			WHERE
				ASSETP_ID = #arguments.assetp_id#
		</cfquery>

		 <cf_date tarih="arguments.rent_start_date">
		 <cf_date tarih="arguments.rent_finish_date">
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
						<cfif variable.property eq 4>
						FUEL_EXPENSE,
						FUEL_AMOUNT,
						FUEL_AMOUNT_CURRENCY,
						CARE_EXPENSE,
						CARE_AMOUNT,
						CARE_AMOUNT_CURRENCY,
						</cfif>
						STATUS,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#arguments.assetp_id#,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						<cfif variable.property eq 4>
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,							
						</cfif>
						1,						
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
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
                    IS_FUEL_ADDED = <cfif isdefined("arguments.is_fuel_added") AND LEN(arguments.is_fuel_added)>#arguments.is_fuel_added#<cfelse>NULL</cfif>,
                    IS_CARE_ADDED = <cfif isdefined("arguments.is_care_added") AND LEN(arguments.is_care_added)>#arguments.is_care_added#<cfelse>NULL</cfif>
				WHERE
					ASSETP_ID = #arguments.assetp_id#
			</cfquery>
		</cfif>

        <cfreturn true>
    </cffunction>
    <!---   Fiziki Varlık Listeleme --->
    <cffunction name="GET_ASSETP_FNC" returntype="query">
        <cfargument name="keyword" default="">
        <cfargument name="branch_id" default="">
        <cfargument name="branch" default="">
        <cfargument name="serial_no" default="">
        <cfargument name="department" default="">
        <cfargument name="emp_id" default="">
        <cfargument name="employee_name" default="">
        <cfargument name="is_active" default="">
        <cfargument name="brand_name" default="">
        <cfargument name="order_type" default="1">
        <cfargument name="inventory_no" default=""> 
        <cfargument name="is_collective_usage" default="">
        <cfargument name="assetp_catid" default="">
        <cfargument name="property" default="">
        <cfargument name="department_id" default="">
        <cfargument name="assetp_status" default="">
        <cfargument name="assetp_sub_catid" default="">
        <cfargument name="position2" default="">
        <cfargument name="position_code2" default="">
        <cfargument name="brand_type_id" default=""> 
        <cfargument name="make_year" default="">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="">
        <cfargument name="member_type_2" default="">
        <cfargument name="sup_company_id" default=""> 
        <cfargument name="sup_partner_id" default=""> 
        <cfargument name="sup_consumer_id" default=""> 
        <cfargument name="company_id" default="">
        <cfargument name="asset_p_space_id" default="">
        <cfargument name="asset_p_space_name" default="">
        <cfargument name="coordinate_1" default="">
        <cfargument name="coordinate_2" default="">

        <cfquery name="GET_ASSETPS" datasource="#this.DSN#">
            WITH CTE1 AS 
            (
            SELECT 
                ASSET_P.ASSETP_ID,
                ASSET_P.ASSETP_DETAIL,
                ASSET_P.ASSETP,
                ASSET_P.EMPLOYEE_ID,
                ASSET_P.PROPERTY,
                ASSET_P.INVENTORY_NUMBER,
                ASSET_P.STATUS,
                ASSET_P.POSITION_CODE,		
                ASSET_P.ASSETP_STATUS,
                ASSET_P.BRAND_TYPE_CAT_ID,
                ASSET_P.BRAND_TYPE_ID,
                ASSET_P.BARCODE,
                ASSET_P.SERIAL_NO,
                ASSET_P.SUP_COMPANY_ID,
                ASSET_P.SUP_PARTNER_ID,
                ASSET_P.SUP_CONSUMER_ID,
                ASSET_P_SUB_CAT.ASSETP_SUB_CAT,
                ASSET_P.SUP_COMPANY_DATE,
                ASSET_P.COORDINATE_1,
                ASSET_P.COORDINATE_2,
                ASSET_P.ASSET_P_SPACE_ID,
                APS.SPACE_CODE,
                APS.SPACE_NAME,
                ASSET_P_CAT.ASSETP_CAT,
                SB.BRAND_NAME,
                SBT.BRAND_TYPE_NAME,
                SBTC.BRAND_TYPE_CAT_NAME,
                COALESCE(ASSET_P.UPDATE_DATE,ASSET_P.RECORD_DATE) DATE,
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME,
                EMP.EMPLOYEE_NAME +' '+ EMP.EMPLOYEE_SURNAME EMP_NAME,
                CASE
                    WHEN ASSET_P.MEMBER_TYPE_2 = 'employee'
                    THEN
                        (SELECT EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEES.EMPLOYEE_ID = ASSET_P.POSITION_CODE2)
                    WHEN ASSET_P.MEMBER_TYPE_2 = 'partner'
                    THEN
                        (SELECT COMPANY_PARTNER.COMPANY_PARTNER_NAME +' '+COMPANY_PARTNER.COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE COMPANY_PARTNER.PARTNER_ID = ASSET_P.POSITION_CODE2)
                    WHEN ASSET_P.MEMBER_TYPE_2 = 'consumer'
                    THEN
                        (SELECT CONSUMER.CONSUMER_NAME +' '+ CONSUMER.CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER.CONSUMER_ID = ASSET_P.POSITION_CODE2)
                END AS
                NAME_2,
                ASSET_STATE.ASSET_STATE
            FROM 
                ASSET_P
                    LEFT JOIN ASSET_P_SPACE APS ON APS.ASSET_P_SPACE_ID=ASSET_P.ASSET_P_SPACE_ID
                    LEFT JOIN EMPLOYEES EMP ON ASSET_P.EMPLOYEE_ID = EMP.EMPLOYEE_ID
                    LEFT JOIN ASSET_STATE ON ASSET_P.ASSETP_STATUS = ASSET_STATE.ASSET_STATE_ID
                    LEFT JOIN ASSET_P_SUB_CAT ON ASSET_P_SUB_CAT.ASSETP_CATID=ASSET_P.ASSETP_CATID AND ASSET_P_SUB_CAT.ASSETP_SUB_CATID=ASSET_P.ASSETP_SUB_CATID
                    LEFT JOIN SETUP_BRAND_TYPE SBT ON ASSET_P.BRAND_TYPE_ID = SBT.BRAND_TYPE_ID
                    LEFT JOIN SETUP_BRAND_TYPE_CAT SBTC ON ASSET_P.BRAND_TYPE_CAT_ID = SBTC.BRAND_TYPE_CAT_ID
                    LEFT JOIN SETUP_BRAND SB ON SB.BRAND_ID = SBT.BRAND_ID,
                ASSET_P_CAT,
                DEPARTMENT,
                BRANCH
            WHERE
                BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) AND
                ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID AND
                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
                ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND
                (ASSET_P_CAT.MOTORIZED_VEHICLE<>1) AND (ASSET_P_CAT.IT_ASSET <> 1)
                <cfif len(arguments.is_active) and (arguments.is_active neq 2)>AND ASSET_P.STATUS = #arguments.is_active#</cfif>
                <cfif len(arguments.is_collective_usage) and (arguments.is_collective_usage eq 1)>AND ASSET_P.IS_COLLECTIVE_USAGE = #is_collective_usage#</cfif>
                <cfif len(arguments.assetp_catid)>AND ASSET_P.ASSETP_CATID = #arguments.assetp_catid#</cfif>
                <cfif len(arguments.brand_name) and len(arguments.brand_type_id)>AND ASSET_P.BRAND_TYPE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_type_id#"></cfif>
                <cfif len(arguments.emp_id) and len(arguments.employee_name)>AND ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"></cfif>
                <cfif len(arguments.keyword)>
                AND (
                        ASSET_P.ASSETP LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        ASSET_P.BARCODE LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
                        ASSET_P.SERIAL_NO LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
                    )
                </cfif>
                <cfif len(arguments.inventory_no)>
                    AND ASSET_P.INVENTORY_NUMBER LIKE '<cfif len(arguments.inventory_no) gt 2>%</cfif>#arguments.inventory_no#%'
                </cfif>
                <cfif len(arguments.make_year)>AND ASSET_P.MAKE_YEAR =#arguments.make_year#</cfif>
                <cfif isDefined("arguments.property") and len(arguments.property)>AND ASSET_P.PROPERTY = #arguments.property#</cfif>
                <cfif len(arguments.branch) and len(arguments.branch_id)>AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#" list="yes">)</cfif>
                <cfif len(arguments.department) and len(arguments.department_id)>AND ASSET_P.DEPARTMENT_ID2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> </cfif>
                <cfif len(arguments.assetp_status)>AND ASSET_P.ASSETP_STATUS = #arguments.assetp_status#</cfif>
                <cfif len(arguments.assetp_sub_catid)>AND ASSET_P.ASSETP_SUB_CATID=#arguments.assetp_sub_catid#</cfif>
                <cfif len(arguments.position2) and len(arguments.position_code2) and len(arguments.member_type_2)>AND ASSET_P.MEMBER_TYPE_2 = '#arguments.member_type_2#' AND ASSET_P.POSITION_CODE2 = #arguments.position_code2#</cfif>
                <cfif isDefined("arguments.sup_company_id") and len(arguments.sup_company_id)>AND ASSET_P.SUP_COMPANY_ID = #arguments.sup_company_id#</cfif>
                <cfif isDefined("arguments.sup_partner_id") and len(arguments.sup_partner_id)>AND ASSET_P.SUP_PARTNER_ID = #arguments.sup_partner_id#</cfif>
                <cfif isDefined("arguments.sup_consumer_id") and len(arguments.sup_consumer_id)>AND ASSET_P.SUP_CONSUMER_ID = #arguments.sup_consumer_id#</cfif>
                <cfif isDefined("arguments.company_id") and len(arguments.company_id)>AND BRANCH.COMPANY_ID = #arguments.company_id#</cfif>
                <cfif len(arguments.asset_p_space_id) and len(arguments.asset_p_space_name)>AND ASSET_P.ASSET_P_SPACE_ID=#arguments.asset_p_space_id#</cfif>
            ),
            
            CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (	ORDER BY 
                            <cfif arguments.order_type eq 1>
                                LTRIM(ASSETP)
                            <cfelseif arguments.order_type eq 2>
                                LTRIM(ASSETP) DESC
                            <cfelseif arguments.order_type eq 3>
                                ASSETP_CAT
                            <cfelseif arguments.order_type eq 4>
                                ASSET_STATE
                            <cfelseif arguments.order_type eq 5>
                                DATE
                            <cfelseif arguments.order_type eq 6>
                                DATE DESC
                            <cfelseif arguments.order_type eq 7>
                                SUP_COMPANY_DATE
                            <cfelseif arguments.order_type eq 8>
                                SUP_COMPANY_DATE DESC
                            </cfif> ) 
                            AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>
        <cfreturn GET_ASSETPS>
    </cffunction>
    <cffunction name="getBranchCoordinatesById" returntype="query">
        <cfargument name="branch_id" default="">
        <cfquery name="getBranchCoordinatesById" datasource="#dsn#">
            SELECT
                COORDINATE_1,
                COORDINATE_2
            FROM
                BRANCH
            WHERE
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
        </cfquery>
        <cfreturn getBranchCoordinatesById>
    </cffunction>
</cfcomponent> 