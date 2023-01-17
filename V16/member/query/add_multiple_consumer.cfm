<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfif len(attributes.picture)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" 
		   destination="#upload_folder#member#dir_seperator#consumer#dir_seperator#" 
			 filefield="picture" 
		  nameconflict="MAKEUNIQUE" accept="image/*"> 
		<cffile action="rename" 
			    source="#upload_folder#member#dir_seperator#consumer#dir_seperator##cffile.serverfile#" 
		   destination="#upload_folder#member#dir_seperator#consumer#dir_seperator##file_name#.#cffile.serverfileext#">
		<cfcatch>
			<font face="Verdana" size="1" color="#ff0000"><strong>Bu dosya adı ile bir dosya sistemede mevcut lütfen kontrol ediniz..</strong></font><br/>		
			<cfabort>
		</cfcatch>
	</cftry>	
<cfscript>
	attributes.picture = file_name &"." & cffile.serverfileext;
</cfscript>	
<cfelse>
</cfif>
<cf_papers paper_type="subscription">
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
</cfquery>
<cfquery name="get_product_price" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		#dsn3_alias#.PRICE_STANDART
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		PURCHASESALES = 1 AND
		PRICESTANDART_STATUS = 1
</cfquery>
<cfquery name="get_product_unit" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		#dsn3_alias#.PRODUCT_UNIT
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		IS_MAIN=1 AND
		PRODUCT_UNIT_STATUS=1	
</cfquery>
<cfquery name="get_product_tax"  datasource="#DSN#">
	SELECT 
		TAX 
	FROM 
		#dsn3_alias#.PRODUCT
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		PRODUCT_STATUS=1
</cfquery>
<cfif isdefined('session.ep.money2') and len(session.ep.money2)>
	<cfquery name="get_money" datasource="#DSN#">
		SELECT 
			(RATE2/RATE1) AS RATE
		FROM 
			#dsn2_alias#.SETUP_MONEY
		WHERE 
			MONEY='#SESSION.EP.MONEY2#'	
	</cfquery>
<cfelse>
	<cfquery name="get_money" datasource="#DSN#">
		SELECT 
			(RATE2/RATE1) AS RATE
		FROM 
			#dsn2_alias#.SETUP_MONEY
		WHERE 
			MONEY='#SESSION.EP.MONEY#'	
	</cfquery>
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="add_consumer" datasource="#dsn#">
			INSERT INTO
				CONSUMER
			(
				CONSUMER_STAGE,
				CONSUMER_CAT_ID,
				IS_CARI,
				BIRTHDATE,
				COMPANY,
				CONSUMER_EMAIL,
				CONSUMER_HOMETEL,
				CONSUMER_HOMETELCODE,
				HOMEADDRESS,
				HOMEPOSTCODE,
				HOME_COUNTRY_ID,
				HOME_CITY_ID,
				HOME_COUNTY_ID,
				HOMESEMT,
				CONSUMER_NAME,
				CONSUMER_SURNAME,
				CONSUMER_WORKTEL,
				CONSUMER_WORKTELCODE,
				WORKADDRESS,
				WORKPOSTCODE,
				WORK_COUNTRY_ID,
				WORK_CITY_ID,
				WORK_COUNTY_ID,
				WORKSEMT,
				MOBIL_CODE,
				MOBILTEL,
				PICTURE,
				PICTURE_SERVER_ID,
				SEX,
				TC_IDENTY_NO,						  
				START_DATE,
				VOCATION_TYPE_ID,
				ISPOTANTIAL,				
				TAX_OFFICE,
				TAX_NO,
				TAX_ADRESS,
				TAX_POSTCODE,
				TAX_SEMT,
				TAX_COUNTY_ID,
				TAX_CITY_ID,
				TAX_COUNTRY_ID,
				MARRIED,
				EDUCATION_ID,
				SECTOR_CAT_ID,
				RECORD_IP,
				RECORD_MEMBER,
				RECORD_DATE
			)
				VALUES 	 
			(
				#attributes.process_stage#,
				#attributes.consumer_cat_id#,
				1,
				<cfif len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
				<cfif len(attributes.company)>'#attributes.company#'<cfelse>NULL</cfif>,
				<cfif len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_tel)>'#attributes.home_tel#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_telcode)>'#attributes.home_telcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_address)>'#attributes.home_address#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_postcode)>'#attributes.home_postcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_city)>#attributes.home_city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_county)>#attributes.home_county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_semt)>'#attributes.home_semt#'<cfelse>NULL</cfif>,
				'#attributes.consumer_name#',
				'#attributes.consumer_surname#',
				<cfif len(attributes.work_tel)>'#attributes.work_tel#'<cfelse>NULL</cfif>,
				<cfif len(attributes.work_telcode)>'#attributes.work_telcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.work_address)>'#attributes.work_address#'<cfelse>NULL</cfif>,
				<cfif len(attributes.work_postcode)>'#attributes.work_postcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.work_country)>#attributes.work_country#<cfelse>NULL</cfif>,
				<cfif len(attributes.work_city)>#attributes.work_city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.work_county)>#attributes.work_county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.work_semt)>'#attributes.work_semt#'<cfelse>NULL</cfif>,
				<cfif len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				<cfif len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				<cfif len(attributes.picture)>'#attributes.picture#'<cfelse>NULL</cfif>,
				<cfif len(attributes.picture)>#fusebox.server_machine#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.sex") and attributes.sex eq 1>1<cfelse>0</cfif>,
				'#attributes.tc_identy_no#',
				<cfif isDefined("attributes.start_date") and len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>,
				0,
				<cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,				
				<cfif len(attributes.tax_no)>'#attributes.tax_no#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_address)>'#attributes.tax_address#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_postcode)>'#attributes.tax_postcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_semt)>'#attributes.tax_semt#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_county_id)>#attributes.tax_county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_city_id)>#attributes.tax_city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_country)>#attributes.tax_country#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.married")>1<cfelse>0</cfif>,
				<cfif len(attributes.education_level)>#attributes.education_level#<cfelse>NULL</cfif>,	
				<cfif len(attributes.sector_cat_id)>#attributes.sector_cat_id#<cfelse>NULL</cfif>,	
				'#cgi.remote_addr#',
				#session.ep.userid#,
				#now()#
			)
		</cfquery>
		<cfquery name="GET_MAX_CONS" datasource="#DSN#">
			SELECT 
				MAX(CONSUMER_ID) AS MAX_CONS 
			FROM 
				CONSUMER
		</cfquery>
		<!--- FB20070716 Bireysel uye ekibine temsilci is_master olarak atiliyor --->
		<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
			<cfquery name="add_workgroup_member" datasource="#dsn#">
				INSERT INTO 
					WORKGROUP_EMP_PAR
				(
					CONSUMER_ID,
					OUR_COMPANY_ID,
					POSITION_CODE,
					IS_MASTER,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">,
					1,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			</cfquery> 
		</cfif> 
		
		<cfloop query="GET_MONEY_INFO">
			<cfif MONEY eq Evaluate("attributes.money_type_1")>
				<cfset rate__ = GET_MONEY_INFO.RATE2/GET_MONEY_INFO.RATE1>
			</cfif>
		</cfloop>
		<cfif len(evaluate("attributes.satir_price_1"))>
			<cfset get_product_price.price = wrk_round(evaluate("attributes.satir_price_1")*rate__)>
			<cfset get_product_price.price_kdv = get_product_price.price + (get_product_tax.TAX*get_product_price.price/100)>
		</cfif>
		<cfquery name="ADD_SUBSCRIPTION_CONTRACT" datasource="#DSN#">
			INSERT INTO 
				#dsn3_alias#.SUBSCRIPTION_CONTRACT
			(
				INVOICE_CONSUMER_ID,
				SUBSCRIPTION_STAGE,
				SUBSCRIPTION_NO,
				IS_ACTIVE,
				SALES_EMP_ID,
				SUBSCRIPTION_HEAD,
				CONSUMER_ID,
				SUBSCRIPTION_TYPE_ID,
				PRODUCT_ID,
				STOCK_ID,
				START_DATE,
				FINISH_DATE,
				SHIP_ADDRESS,
				INVOICE_ADDRESS,
				CONTACT_ADDRESS,
				DISCOUNTTOTAL,
				NETTOTAL,
				GROSSTOTAL,
				TAXTOTAL,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				INVOICE_POSTCODE,
				INVOICE_SEMT,
				INVOICE_COUNTY_ID,
				INVOICE_CITY_ID,
				INVOICE_COUNTRY_ID,
				SHIP_POSTCODE,
				SHIP_SEMT,
				SHIP_COUNTY_ID,
				SHIP_CITY_ID,
				SHIP_COUNTRY_ID,
				CONTACT_POSTCODE,
				CONTACT_SEMT,
				CONTACT_COUNTY_ID,
				CONTACT_CITY_ID,
				CONTACT_COUNTRY_ID,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
			VALUES
			(
				#GET_MAX_CONS.MAX_CONS#,
				#attributes.faction_value#,
				'#paper_code & '-' & paper_number#',
				1,
				<cfif isdefined('attributes.sales_emp_id') and len(attributes.sales_emp_id)>#attributes.sales_emp_id#<cfelse>NULL</cfif>,
				'Üyemiz',
				#GET_MAX_CONS.MAX_CONS#,
				#attributes.subscription_type#,
				#attributes.product_id#,
				#attributes.stock_id#,
				<cfif isDefined("attributes.start_date") and len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.finish_date") and len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_address)>'#attributes.home_address#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_address)>'#attributes.tax_address#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_address)>'#attributes.home_address#'<cfelse>NULL</cfif>,
				0,
				#get_product_price.price_kdv#,
				#get_product_price.price#,
				#get_product_price.price_kdv-get_product_price.price#,
				<cfif isdefined('session.ep.money2') and len(session.ep.money2)>'#session.ep.money2#'<cfelse>'#session.ep.money#'</cfif>,
				#wrk_round(get_product_price.price_kdv/get_money.RATE)#,
				<cfif len(attributes.tax_postcode)>'#attributes.tax_postcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_semt)>'#attributes.tax_semt#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_county_id)>#attributes.tax_county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_city_id)>#attributes.tax_city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_country)>#attributes.tax_country#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_postcode)>'#attributes.home_postcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_semt)>'#attributes.home_semt#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_postcode)>'#attributes.home_postcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_semt)>'#attributes.home_semt#'<cfelse>NULL</cfif>,
				<cfif len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				#now()#
			)
		</cfquery>	<!--- sistemlere kayıt yapılıyor --->
		<cfquery name="GET_MAX_SUBSCRIPTION" datasource="#DSN#">
			SELECT
				MAX(SUBSCRIPTION_ID) AS SUBSCRIPTION_ID
			FROM	
				#dsn3_alias#.SUBSCRIPTION_CONTRACT
		</cfquery> <!---Max sistem numarası çekiliyor.  --->
		<cfquery name="ADD_CONTRACT_ROW" datasource="#DSN#">
				INSERT INTO
					#dsn3_alias#.SUBSCRIPTION_CONTRACT_ROW
				(
					SUBSCRIPTION_ID,
					PRODUCT_NAME,
					STOCK_ID,
					PRODUCT_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,					
					TAX,
					PRICE,
					DISCOUNT1,					
					DISCOUNT2,
					DISCOUNT3,
					DISCOUNT4,
					DISCOUNT5,
					DISCOUNT6,
					DISCOUNT7,
					DISCOUNT8,
					DISCOUNT9,
					DISCOUNT10,
					DISCOUNTTOTAL,
					GROSSTOTAL,
					NETTOTAL,
					TAXTOTAL,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,					
					PRICE_OTHER,
					OTHER_MONEY_GROSS_TOTAL
				)
				VALUES
				(
					#get_max_subscription.subscription_id#,
					'#attributes.product_name#',
					#attributes.stock_id#,
					#attributes.product_id#,
					1,
					'#get_product_unit.MAIN_UNIT#',
					#get_product_unit.MAIN_UNIT_ID#,
					#get_product_tax.TAX#,
					#get_product_price.price#,
					0,0,0,0,0,0,0,0,0,0,0,
					#get_product_price.price_kdv#,
					#get_product_price.price#,
					#get_product_price.price_kdv-get_product_price.price#,
					<cfif isdefined('session.ep.money2') and len(session.ep.money2)>'#session.ep.money2#'<cfelse>'#session.ep.money#'</cfif>,
					#wrk_round(get_product_price.price_kdv/get_money.RATE)#,
					#wrk_round(get_product_price.price/get_money.RATE)#,
					#wrk_round(get_product_price.price/get_money.RATE)#
				)
		</cfquery>
		<!--- <cfoutput>
			GPP:#get_product_price.price#
			GPK:#get_product_price.price_kdv#
		</cfoutput>
		<cfabort> --->
		<!--- sistem rowları --->
		<cfif GET_MONEY_INFO.recordcount>
			<cfoutput query="GET_MONEY_INFO">
				<cfquery name="INSERT_MONEY_INFO" datasource="#dsn#">
					INSERT INTO
					#dsn3_alias#.CREDIT_CARD_BANK_PAYMENT_MONEY
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_max_subscription.subscription_id#,
						'#GET_MONEY_INFO.MONEY#',
						#GET_MONEY_INFO.RATE2#,
						#GET_MONEY_INFO.RATE1#,
						<cfif GET_MONEY_INFO.MONEY eq session.ep.money2>1<cfelse>0</cfif>
					)
				</cfquery>
			</cfoutput>
		</cfif>
		<!--- buraya ekleee. --->
		<cfquery name="ADD_PAYMENT_PLAN" datasource="#dsn#">
			INSERT INTO
				#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN
				(
					SUBSCRIPTION_ID,
					PRODUCT_ID,
					STOCK_ID,
					UNIT,
					UNIT_ID,
					QUANTITY,
					AMOUNT,
					MONEY_TYPE,
					PERIOT,
					START_DATE,
					PAYMETHOD_ID,
					CARD_PAYMETHOD_ID,
					PROCESS_STAGE,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP
				)
				VALUES
				(
					#get_max_subscription.subscription_id#,
					#attributes.product_id#,
					#attributes.stock_id#,
					'#get_product_unit.MAIN_UNIT#',
					#get_product_unit.MAIN_UNIT_ID#,
					1,
					<cfif len(evaluate("attributes.satir_price_1"))>#evaluate("attributes.satir_price_1")#<cfelse>#get_product_price.PRICE_KDV#</cfif>,
					'#wrk_eval("attributes.money_type_1")#',
					1,<!--- bu geçici olarak aylık set edilmiştir--->
				<cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.paymethod_id_1") and len(attributes.paymethod_id_1)>
					#attributes.paymethod_id_1#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isDefined("attributes.card_paymethod_id_1") and len(attributes.card_paymethod_id_1)>
					#attributes.card_paymethod_id_1#,
				<cfelse>
					NULL,
				</cfif>
					#attributes.faction_value2#,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#
				)
		</cfquery>
		<cfloop from="1" to="1" index="urun_no">
		<cfif isdefined("attributes.odeme_tarihi_#urun_no#") and len(Evaluate('attributes.odeme_tarihi_#urun_no#')) and len(Evaluate('attributes.paymethod_#urun_no#'))>
		<cf_date tarih='attributes.odeme_tarihi_#urun_no#'>
		<cfquery name="ADD_PAYMENT_PLAN_ROW" datasource="#DSN#">
		INSERT INTO
			#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
			(
				SUBSCRIPTION_ID,
				PRODUCT_ID,
				STOCK_ID,
				PAYMENT_DATE,
				DETAIL,
				UNIT,
				UNIT_ID,
				QUANTITY,
				AMOUNT,
				MONEY_TYPE,
				ROW_TOTAL,
				DISCOUNT,
				ROW_NET_TOTAL,
				IS_COLLECTED_INVOICE,
				IS_GROUP_INVOICE,
				IS_BILLED,
				IS_COLLECTED_PROVISION,
				IS_PAID,
				IS_ACTIVE,
				PAYMETHOD_ID,
				CARD_PAYMETHOD_ID,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			)
		VALUES
			(
				#get_max_subscription.subscription_id#,
				#attributes.product_id#,
				#attributes.stock_id#,
				#evaluate("attributes.odeme_tarihi_#urun_no#")#,
				'#attributes.product_name#',
				'#get_product_unit.MAIN_UNIT#',
				#get_product_unit.MAIN_UNIT_ID#,
				1,
				<cfif len(evaluate("attributes.satir_price_#urun_no#"))>#evaluate("attributes.satir_price_#urun_no#")#<cfelse>#get_product_price.PRICE_KDV#</cfif>,
				'#wrk_eval("attributes.money_type_#urun_no#")#',
				<cfif len(evaluate("attributes.satir_price_#urun_no#"))>#evaluate("attributes.satir_price_#urun_no#")#<cfelse>#get_product_price.PRICE_KDV#</cfif>,
				0,
				<cfif len(evaluate("attributes.satir_price_#urun_no#"))>#evaluate("attributes.satir_price_#urun_no#")#<cfelse>#get_product_price.PRICE_KDV#</cfif>,
				0,
				0,
				0,
				0,
				0,
				1,
				<cfif isDefined("attributes.paymethod_id_#urun_no#") and len(evaluate("attributes.paymethod_id_#urun_no#"))>#evaluate("attributes.paymethod_id_#urun_no#")#,<cfelse>NULL,</cfif>
				<cfif isDefined("attributes.card_paymethod_id_#urun_no#") and len(evaluate("attributes.card_paymethod_id_#urun_no#"))>#evaluate("attributes.card_paymethod_id_#urun_no#")#,<cfelse>NULL,</cfif>
				<!--- <cfif len(evaluate("attributes.subs_ref_id_#urun_no#")) and len(evaluate("attributes.subs_ref_name_#urun_no#"))>'#wrk_eval("attributes.subs_ref_id_#urun_no#")#',<cfelse>NULL,</cfif> --->
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#
			)
	</cfquery>
	</cfif>
	</cfloop>
	<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
		UPDATE 
			#dsn3_alias#.GENERAL_PAPERS
		SET
			SUBSCRIPTION_NUMBER = #paper_number#
		WHERE
			SUBSCRIPTION_NUMBER IS NOT NULL
	</cfquery>
	</cftransaction>
</cflock>
<!--- Sozlesme Bilgileri --->
<cfif isdefined("attributes.consumer_contract_id") and len(attributes.consumer_contract_id)>
	<cfquery name="UPD_CONTRACT" datasource="#DSN#">
		UPDATE 
			CONSUMER 
		SET 
			CONTRACT_DATE = #now()#
		<cfif isdefined("session.ww.userid")>
			,CONTRACT_CONS_ID = #session.ww.userid#
		<cfelseif isdefined("session.ep.userid")>
			,CONTRACT_EMP_ID = #session.ep.userid#
		</cfif>
		WHERE 
			CONSUMER_ID = #get_max_cons.max_cons#
	</cfquery>
</cfif>

<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
	UPDATE 
		CONSUMER 
	SET		
	<cfif isdefined("attributes.consumer_code") and len(attributes.consumer_code)>
		MEMBER_CODE='#trim(attributes.consumer_code)#'
	<cfelse>
		MEMBER_CODE = 'B#get_max_cons.max_cons#'
	</cfif>
	WHERE 
		CONSUMER_ID = #get_max_cons.max_cons#
</cfquery>
<cflocation url="#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_max_cons.max_cons#&type=multi&sub_id=#get_max_subscription.subscription_id#" addtoken="no">
