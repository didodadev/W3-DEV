<!--- fiziki varlık import --->
<cfsetting showdebugoutput="no">
<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cftry>
	<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
	<cffile action="delete" file="#upload_folder_##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1653.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>.");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset property = trim(listgetat(dosya[i],1,';'))>
		<cfset barcode = trim(listgetat(dosya[i],2,';'))>
		<cfset assetp = trim(listgetat(dosya[i],3,';'))>
		<cfset sup_partner_id = trim(listgetat(dosya[i],4,';'))>
		<cfset sup_consumer_id = trim(listgetat(dosya[i],5,';'))>
		<cfset assetp_catid = trim(listgetat(dosya[i],6,';'))>
        <cfset assetp_sub_catid = trim(listgetat(dosya[i],7,';'))>
		<cfset department_id = trim(listgetat(dosya[i],8,';'))>
		<cfset department_id2 = trim(listgetat(dosya[i],9,';'))>
		<cfset position_code = trim(listgetat(dosya[i],10,';'))>
		<cfset start_date = trim(listgetat(dosya[i],11,';'))>
		<cfset inventory_id = trim(listgetat(dosya[i],12,';'))>
		<cfset serial_no = trim(listgetat(dosya[i],13,';'))>
		<cfset primary_code = trim(listgetat(dosya[i],14,';'))>
		<cfset service_employee_id = trim(listgetat(dosya[i],15,';'))>
		<cfset fuel_type = trim(listgetat(dosya[i],16,';'))>
		<cfset status = trim(listgetat(dosya[i],17,';'))>
		<cfset assetp_group = trim(listgetat(dosya[i],18,';'))>
		<cfset usage_purpose_id = trim(listgetat(dosya[i],19,';'))>
		<cfset brand_type_cat_id = trim(listgetat(dosya[i],20,';'))>
		<cfset make_year = trim(listgetat(dosya[i],21,';'))>
		<cfset color = trim(listgetat(dosya[i],22,';'))>
		<cfset engine_number = trim(listgetat(dosya[i],23,';'))>
		<cfset identification_number = trim(listgetat(dosya[i],24,';'))>
		<cfset assetp_detail = trim(listgetat(dosya[i],25,';'))>
		<cfset assetp_other_money_value = trim(listgetat(dosya[i],26,';'))>
		<cfset assetp_other_money = trim(listgetat(dosya[i],27,';'))>
		<cfset is_collective_usage = trim(listgetat(dosya[i],28,';'))>
		<cfset first_km = trim(listgetat(dosya[i],29,';'))>
		<cfif (listlen(dosya[i],';') gte 30)>
			<cfset first_date_km = trim(listgetat(dosya[i],30,';'))>
		<cfelse>
			<cfset first_date_km = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
		</cfcatch>  
	</cftry>
	<cfif len(sup_partner_id) and (isNumeric(sup_partner_id) and sup_partner_id neq 0) and not len(sup_consumer_id)>
		<cfquery name="get_company" datasource="#dsn#">
			SELECT C.COMPANY_ID,CP.PARTNER_ID FROM COMPANY C,COMPANY_PARTNER CP WHERE C.COMPANY_ID = CP.COMPANY_ID AND CP.PARTNER_ID = #sup_partner_id#
		</cfquery>
		<cfset get_consumer.consumer_id = ''>
	<cfelseif len(sup_consumer_id) and (isNumeric(sup_consumer_id) and sup_consumer_id neq 0) and not len(sup_partner_id)>
		<cfquery name="get_consumer" datasource="#dsn#">
			SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sup_consumer_id#">
		</cfquery>
		<cfset get_company.company_id = ''>
		<cfset get_company.partner_id = ''>
	<cfelseif (len(sup_partner_id) and isNumeric(sup_partner_id) and sup_partner_id neq 0) or (len(sup_consumer_id) and isNumeric(sup_consumer_id) and sup_consumer_id neq 0)>
		<cfset get_company.company_id = ''>
		<cfset get_company.partner_id = ''>
		<cfset get_consumer.consumer_id = ''>
	<cfelse>
		<cfset get_company.company_id = ''>
		<cfset get_company.partner_id = ''>
		<cfset get_consumer.consumer_id = ''>
	</cfif>
	<cfif len(department_id) and isNumeric(department_id)>
		<cfquery name="get_dept" datasource="#dsn#">
			SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
		</cfquery>
	<cfelse>
		<cfset get_dept.department_id = ''>
	</cfif>
	<cfif len(department_id2) and isNumeric(department_id2)>
		<cfquery name="get_dept2" datasource="#dsn#">
			SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id2#">
		</cfquery>
	<cfelse>
		<cfset get_dept2.department_id = ''>
	</cfif>
	<cfif len(inventory_id) and isNumeric(inventory_id)>
		<cfquery name="get_inventory" datasource="#dsn3#">
			SELECT INVENTORY_NUMBER,INVENTORY_ID FROM INVENTORY WHERE INVENTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#inventory_id#">
		</cfquery>
		<cfif get_inventory.recordcount>
			<cfquery name="add_asset" datasource="#dsn3#">
				UPDATE INVENTORY SET TO_ASSET=1 WHERE INVENTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory.inventory_id#">
			</cfquery>
		</cfif>
	<cfelse>
		<cfset get_inventory.inventory_id = ''>
		<cfset get_inventory.inventory_number = ''>
	</cfif>
	<cfif len(start_date)>
		<cf_date tarih="start_date">
	</cfif>
	<cfif isdefined("first_date_km") and len(first_date_km)>
		<cf_date tarih="first_date_km">
	</cfif>
	<cfif len(fuel_type) and isNumeric(fuel_type)>
		<cfquery name="GET_FUEL_TYPE" datasource="#DSN#">
			SELECT FUEL_ID FROM SETUP_FUEL_TYPE WHERE FUEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fuel_type#">
		</cfquery> 
	<cfelse>
		<cfset get_fuel_type.fuel_id = ''>
	</cfif>
	<cfif len(status) and isNumeric(status)>
		<cfquery name="get_asset_state" datasource="#DSN#">
			SELECT ASSET_STATE_ID FROM ASSET_STATE WHERE ASSET_STATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#status#">
		</cfquery>
	<cfelse>
		<cfset get_asset_state.asset_state_id = ''>
	</cfif>
	<cfif len(assetp_group) and isNumeric(assetp_group)>
		<cfquery name="get_assetp_group" datasource="#DSN#">
			SELECT GROUP_ID FROM SETUP_ASSETP_GROUP WHERE GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetp_group#">
		</cfquery>
	<cfelse>
		<cfset get_assetp_group.group_id = ''>
	</cfif>
	
	<cfif len(usage_purpose_id) and isNumeric(usage_purpose_id)>
		<cfquery name="get_purpose" datasource="#DSN#">
			SELECT USAGE_PURPOSE_ID FROM SETUP_USAGE_PURPOSE WHERE MOTORIZED_VEHICLE = 1 AND USAGE_PURPOSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#usage_purpose_id#">
		</cfquery>
	<cfelse>
		<cfset get_purpose.usage_purpose_id = ''>
	</cfif>
	<cfif len(assetp_catid) and isNumeric(assetp_catid)>
		<cfquery name="get_assetp_cat" datasource="#dsn#">
			SELECT ASSETP_CATID FROM ASSET_P_CAT WHERE ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetp_catid#">
		</cfquery>
	<cfelse>
		<cfset get_assetp_cat.assetp_catid = ''>
	</cfif>
    <cfif len(assetp_sub_catid) and isNumeric(assetp_sub_catid)>
		<cfquery name="GET_SUB_CAT" datasource="#dsn#">
			SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_SUB_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetp_sub_catid#">
		</cfquery>
	<cfelse>
		<cfset get_sub_cat.assetp_sub_catid = ''>
	</cfif>
	<cfif len(brand_type_cat_id) and isNumeric(brand_type_cat_id)>
		<cfquery name="get_brand_cat" datasource="#dsn#">
			SELECT BRAND_TYPE_CAT_ID,BRAND_TYPE_ID,BRAND_ID FROM SETUP_BRAND_TYPE_CAT WHERE BRAND_TYPE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#brand_type_cat_id#">
		</cfquery>
	<cfelse>
		<cfset get_brand_cat.brand_type_cat_id = ''>
		<cfset get_brand_cat.brand_type_id = ''>
		<cfset get_brand_cat.brand_id = ''>
	</cfif>
	<cfif len(service_employee_id) and isNumeric(service_employee_id)>
		<cfquery name="get_emp" datasource="#dsn#">
			SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_employee_id#">
		</cfquery>
	<cfelse>
		<cfset get_emp.employee_id = ''>
	</cfif>
	<cfif len(position_code) and isNumeric(position_code)>
		<cfquery name="get_pos" datasource="#dsn#">
			SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_code#">
		</cfquery>
	<cfelse>
		<cfset get_pos.position_code = ''>
	</cfif>
	<cfif len(position_code) and isNumeric(position_code)>
		<cfquery name="get_emp_id" datasource="#dsn#">
			SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_code#">
		</cfquery>
	<cfelse>
		<cfset get_emp_id.employee_id = ''>
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cftry>
				<cfquery name="add_expense_items" datasource="#dsn#">
					INSERT INTO 
						ASSET_P
					(
						BARCODE,
						PROPERTY,
						ASSETP,
						SUP_COMPANY_ID,
						SUP_PARTNER_ID,
						SUP_CONSUMER_ID,
						ASSETP_CATID,
                        ASSETP_SUB_CATID,
						DEPARTMENT_ID,
						DEPARTMENT_ID2,
						POSITION_CODE,
						EMPLOYEE_ID,
						SUP_COMPANY_DATE,
						INVENTORY_NUMBER,
						INVENTORY_ID,
						SERIAL_NO,
						PRIMARY_CODE,
						SERVICE_EMPLOYEE_ID,
						FUEL_TYPE,
						ASSETP_STATUS,
						ASSETP_GROUP,
						USAGE_PURPOSE_ID,
						BRAND_ID,
						BRAND_TYPE_ID,
						BRAND_TYPE_CAT_ID,				
						MAKE_YEAR,
						ASSETP_DETAIL,
						OTHER_MONEY_VALUE,
						OTHER_MONEY,
						IS_COLLECTIVE_USAGE,
						STATUS,
						IS_SALES,
						FIRST_KM,
						FIRST_KM_DATE,
						PROCESS_STAGE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						<cfif len(barcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#barcode#"><cfelse>NULL</cfif>,
						#property#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(assetp)#">,
						<cfif len(get_company.company_id)>
							#get_company.company_id#,
							<cfif len(get_company.partner_id)>#get_company.partner_id#<cfelse>NULL</cfif>,
							NULL,
						<cfelseif len(get_consumer.consumer_id)>
							NULL,
							NULL,
							#get_consumer.consumer_id#,
						</cfif>
						#get_assetp_cat.assetp_catid#,
                        <cfif len(get_sub_cat.assetp_sub_catid)>#get_sub_cat.assetp_sub_catid#<cfelse>NULL</cfif>,
						#get_dept.department_id#,
						<cfif len(get_dept2.department_id)>#get_dept2.department_id#<cfelse>#get_dept.department_id#</cfif>,
						#get_pos.position_code#,
						#get_emp_id.employee_id#,
						#start_date#,
						<cfif len(get_inventory.inventory_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(get_inventory.inventory_number)#"><cfelseif len(inventory_id)>'#inventory_id#'<cfelse>NULL</cfif>,
						<cfif len(get_inventory.inventory_id)>#get_inventory.inventory_id#<cfelse>NULL</cfif>,
						<cfif len(serial_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#serial_no#"><cfelse>NULL</cfif>,
						<cfif len(primary_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#primary_code#"><cfelse>NULL</cfif>,
						<cfif len(get_emp.employee_id)>#get_emp.employee_id#<cfelse>NULL</cfif>,
						<cfif len(get_fuel_type.fuel_id)>#get_fuel_type.fuel_id#<cfelse>NULL</cfif>,
						#get_asset_state.asset_state_id#,
						<cfif len(get_assetp_group.group_id)>#get_assetp_group.group_id#<cfelse>NULL</cfif>,				
						<cfif len(get_purpose.usage_purpose_id)>#get_purpose.usage_purpose_id#<cfelse>NULL</cfif>,
						#get_brand_cat.brand_id#,
						#get_brand_cat.brand_type_id#,
						#get_brand_cat.brand_type_cat_id#,
						#make_year#,
						<cfif len(assetp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_detail#"><cfelse>NULL</cfif>,
						<cfif len(assetp_other_money_value)>#assetp_other_money_value#<cfelse>NULL</cfif>,											
						<cfif len(assetp_other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_other_money#"><cfelse>NULL</cfif>,
						<cfif len(is_collective_usage)>#is_collective_usage#<cfelse>0</cfif>,
						1,
						0,
						<cfif isdefined("first_km") and len(first_km)>#first_km#<cfelse>NULL</cfif>,
						<cfif isdefined("first_date_km") and len(first_date_km)>#first_date_km#<cfelse>NULL</cfif>,
						#attributes.process_stage#,
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">								
					)
				</cfquery>
				<cfquery name="get_max_id" datasource="#DSN#">
					SELECT MAX(ASSETP_ID) AS ASSETP_ID FROM ASSET_P
				</cfquery>
				<cfquery name="get_info_plus" datasource="#dsn#">
					INSERT INTO
						ASSET_P_INFO_PLUS
					(
						ASSETP_ID,
						RENK,
						ENGINE_NUMBER,
						IDENTIFICATION_NUMBER
					)
					VALUES
					(
						#get_max_id.assetp_id#,
						<cfif len(color)><cfqueryparam cfsqltype="cf_sql_varchar" value="#color#"><cfelse>NULL</cfif>,
						<cfif len(engine_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#engine_number#"><cfelse>NULL</cfif>,
						<cfif len(identification_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#identification_number#"><cfelse>NULL</cfif>
					)
				</cfquery>
                <cfif isdefined("first_km") and len(first_km)>
                    <cfquery name="ADD_KMS" datasource="#dsn#"> 
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
                            #get_max_id.assetp_id#,
                            0,
                            <cfif isdefined("first_km") and len(first_km)>#first_km#<cfelse>NULL</cfif>,
                            NULL,
                            <cfif isdefined("first_date_km") and len(first_date_km)>#first_date_km#<cfelse>NULL</cfif>,
                            <cfif isDefined("attributes.is_offtime")>#attributes.is_offtime#<cfelse>0</cfif>,
                            #session.ep.userid#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                            #now()#
                        )
                    </cfquery>
                </cfif>
				<cfcatch type="Any">
					<cfoutput>
						#i#. Satırda;<br/>
							<cfif not len(property)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang no='2793.Mülkiyet'> ID <br/>
							</cfif>
							<cfif not len(assetp)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang_main no ='1655.Varlık'>/<cf_get_lang_main no ='1656.Plaka'><br/>
							</cfif>
							<cfif not len(get_pos.position_code)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang_main no ='1718.Pozisyon Kodu'><br/>
							</cfif>
							<cfif not len(get_company.partner_id) and not len(get_consumer.consumer_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang no ='2784.Alınan Şirket'> <br/>
							</cfif>
							<cfif not len(get_assetp_cat.assetp_catid)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang no ='2785.Varlık Tipi'><br/>
							</cfif>
							<cfif not len(get_brand_cat.brand_type_cat_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang no ='3125.Marka Kategorisi'> Id<br/>
							</cfif>
							<cfif not len(start_date)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang no ='2789.Alış Tarihi'><br/>
							</cfif>
							<cfif not len(get_dept.department_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang no ='2786.Kayıtlı Departman'><br/>
							</cfif>
							<cfif not len(make_year)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang_main no ='813.Model'><br/>
							</cfif>
							<cfif not len(get_asset_state.asset_state_id)>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<cf_get_lang_main no ='344.Durum'><br/>
							</cfif>
							&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang no ='3130.Eksik Olduğu için Import Yapılamadı'>!<br /> 
					</cfoutput>	
					<cfset kont=0>
				</cfcatch>
			</cftry>
			<cfif kont eq 1>
				<cfoutput>#i#. Satır İmport Edildi...<br/></cfoutput>
			</cfif> 
		</cftransaction>
	</cflock>
</cfloop>
