<!---Action  File sistem i�i [1] --->

<cfquery name="get_service" datasource="#caller.dsn3#">

	SELECT * FROM SERVICE WHERE SERVICE_ID = #attributes.action_id#

</cfquery>

<cfset attributes.service_id = get_service.SERVICE_ID>

<cfset attributes.stock_id = get_service.STOCK_ID>

<cfset attributes.service_product_id = get_service.SERVICE_PRODUCT_ID>

<cfset attributes.service_serial_no = get_service.PRO_SERIAL_NO>

<cfset attributes.department_id = get_service.DEPARTMENT_ID>

<cfset attributes.location_id = get_service.LOCATION_ID>

<cfset attributes.doc_no = get_service.service_no>

<cfset attributes.service_product = get_service.PRODUCT_NAME>

<cfset attributes.company_id = get_service.SERVICE_COMPANY_ID>

<cfset attributes.consumer_id = get_service.SERVICE_CONSUMER_ID>

<cfset attributes.partner_id = get_service.SERVICE_PARTNER_ID>

<cfset attributes.applicator_name = get_service.applicator_name>

<cfset attributes.adres = get_service.SERVICE_ADDRESS>





<cfset dsn3_alias = caller.dsn3_alias>

<cfset dsn2_alias = caller.dsn2_alias>

<cfset dsn_alias = caller.dsn_alias>

<cfset dsn1_alias = caller.dsn1_alias>

<cfset dsn3 = caller.dsn3>

<cfset dsn2 = caller.dsn2>

<cfset dsn1 = caller.dsn1>



<cfif len(get_service.FINISH_DATE)>

	<cfset attributes.apply_date = dateadd("h",session.ep.time_zone,get_service.FINISH_DATE)>

	<cfset islem_yap = 1>

<cfelse>

	<cfset attributes.apply_date = now()>

	<cfset islem_yap = 1>

</cfif>



<cfif islem_yap eq 1 and len(attributes.stock_id) and len(attributes.service_serial_no)>

	<cfset islem_yap = 1>

<cfelseif islem_yap eq 1 and (not len(attributes.stock_id) or not len(attributes.service_serial_no))>

	<script>

		alert('Servise Bal1 �r�n Olmad11 0�in 0rsaliye Kesilemedi!');

	</script>

	<cfset islem_yap = 0>

</cfif>



<cfif islem_yap eq 1 and len(attributes.service_product_id) and len(attributes.service_product_id)>

	<cfset islem_yap = 1>

<cfelseif islem_yap eq 1 and (not len(attributes.service_product_id) or not len(attributes.service_product_id))>

	<script>

		alert('Servise Bal1 �r�n Olmad11 0�in 0rsaliye Kesilemedi!');

	</script>

	<cfset islem_yap = 0>

</cfif>



<cfif islem_yap eq 1 and len(attributes.apply_date)>

	<cfset islem_yap = 1>

<cfelseif islem_yap eq 1 and not len(attributes.apply_date)>

	<script>

		alert('Servis Biti_ Tarihi Olmad11 0�in 0rsaliye Kesilemedi!');

	</script>

	<cfset islem_yap = 0>

</cfif>



<cfif islem_yap eq 1 and len(attributes.department_id)>

	<cfset islem_yap = 1>

<cfelseif islem_yap eq 1 and not len(attributes.department_id)>

	<script>

		alert('Servis Departman1 Olmad11 0�in 0rsaliye Kesilemedi!');

	</script>

	<cfset islem_yap = 0>

</cfif>



<cfif islem_yap eq 1 and len(attributes.location_id)>

	<cfset islem_yap = 1>

<cfelseif islem_yap eq 1 and not len(attributes.location_id)>

	<script>

		alert('Servis Lokasyonu Olmad11 0�in 0rsaliye Kesilemedi!');

	</script>

	<cfset islem_yap = 0>

</cfif>



<cfset product_id_list = "">

<cfset stock_id_list = "">



<cfif isdefined('attributes.doc_no')>

	<cfset list1=",">

	<cfset list2="">

	<cfset ship_number = Replace(attributes.doc_no,list1,list2,"ALL")> 

</cfif>





<cfif islem_yap eq 1>

	<cfquery name="GET_PURCHASE" datasource="#DSN2#">

		SELECT 

			SHIP_NUMBER,

			PURCHASE_SALES

		FROM 

			SHIP

		WHERE 

			PURCHASE_SALES = 1 AND 

			SHIP_NUMBER='#SHIP_NUMBER#'

	</cfquery>

	<cfif get_purchase.recordcount eq 0>

		<cfset islem_yap = 1>	

	<cfelse>

		<script>

			alert('Girilen 0rsaliye No Ge�ersiz Olduu 0�in 0rsaliye Kesilemedi!');

		</script>

		<cfset islem_yap = 0>

	</cfif>

</cfif>



<cfif islem_yap eq 1>

	<cfquery name="get_process_type" datasource="#caller.dsn3#" maxrows="1">

		SELECT 

			PROCESS_TYPE,

			IS_CARI,

			IS_ACCOUNT,

			IS_STOCK_ACTION,

			PROCESS_CAT_ID

		 FROM 

			SETUP_PROCESS_CAT 

		WHERE 

			PROCESS_TYPE = 141

	</cfquery>

	<cfif get_process_type.recordcount>

		<cfset islem_yap = 1>

	<cfelse>

		<script>

			alert('0rsaliye Tipi Tan1ml1 Olmad11 0�in 0rsaliye Kesilemedi!');

		</script>

		<cfset islem_yap = 0>

	</cfif>

</cfif>



<cfif islem_yap eq 1>

	<cfscript>

		if (caller.database_type is 'MSSQL') 

			{last_year_dsn2 = '#caller.dsn#_#session.ep.period_year-1#_#session.ep.company_id#';}

		else if (caller.database_type is 'DB2') 

			{last_year_dsn2 = '#caller.dsn#_#session.ep.company_id#_#right(session.ep.period_year,2)-1#';}	

	</cfscript>

	<cfquery name="control_" datasource="#caller.dsn2#">

		SELECT

			SHIP_ID

		FROM 

			SHIP

		WHERE 

			SERVICE_ID =  #attributes.service_id# AND SHIP_TYPE = 140

	</cfquery>

	<cfif session.ep.period_year eq year(now())>

		<cfquery name="control_2" datasource="#last_year_dsn2#">

			SELECT

				SHIP_ID

			FROM 

				SHIP

			WHERE 

				SERVICE_ID =  #attributes.service_id# AND SHIP_TYPE = 140

		</cfquery>

	<cfelse>

		<cfset control_2.recordcount = 0>

	</cfif>

	<cfif not control_.recordcount and not control_2.recordcount>

		<script>

			alert('Servis Giri_ 0rsaliyesi Olmad11 0�in �1k1_ 0rsaliyesi Kesilemedi!');

		</script>

		<cfset islem_yap = 0>

	</cfif>

	

	<cfif islem_yap eq 1>

				<cfif control_.recordcount>

					<cfset attributes.active_dsn2 = '#dsn2#'>

					<cfset attributes.in_ship_id = control_.ship_id>

				<cfelse>

					<cfset attributes.active_dsn2 = '#last_year_dsn2#'>

					<cfset attributes.in_ship_id = control_2.ship_id>

				</cfif>

				<cfquery name="GET_SHIP_ROW" datasource="#attributes.active_dsn2#">

					SELECT DISTINCT

						SH.*,

						S.IS_INVENTORY,

						S.IS_PRODUCTION,

						S.STOCK_CODE,

						S.BARCOD,

						S.IS_SERIAL_NO,

						S.MANUFACT_CODE

					FROM 

						SHIP_ROW SH,

						SHIP SHIP,

						#dsn3_alias#.STOCKS S,

						#dsn3_alias#.SERVICE SR

					WHERE 

						SHIP.SERVICE_ID = SR.SERVICE_ID AND

						SHIP.SHIP_ID = SH.SHIP_ID AND

						SHIP.SHIP_ID = #attributes.in_ship_id# AND

						SR.STOCK_ID = S.STOCK_ID AND

						SHIP.SHIP_TYPE = 140

					ORDER BY

						SH.SHIP_ROW_ID

				</cfquery>

				<cfif GET_SHIP_ROW.recordcount>

					<cfset islem_yap = 1>

				<cfelse>

					<script>

						alert('Servis Giri_ 0rsaliyesi Olmad11 0�in �1k1_ 0rsaliyesi Kesilemedi!');

					</script>

					<cfset islem_yap = 0>

				</cfif>

	</cfif>

</cfif>

<cfif islem_yap eq 1>



<cfif not len(get_service.FINISH_DATE)>

	<cfquery name="upd_" datasource="#dsn3#">

		UPDATE SERVICE SET FINISH_DATE = #createodbcdatetime(attributes.apply_date)# WHERE SERVICE_ID = #attributes.service_id#

	</cfquery>

</cfif>



<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>

<cfset karma_product_list="">

<cflock name="#CreateUUID()#" timeout="20">

	<cftransaction>

		<cfquery name="ADD_SALE" datasource="#DSN2#">

			INSERT INTO

				SHIP

			(

				SERVICE_ID,

				WRK_ID,

				PURCHASE_SALES,

				SHIP_NUMBER,

				SHIP_TYPE,

				PROCESS_CAT,

				SHIP_METHOD,

				SHIP_DATE,

				COMPANY_ID,

				PARTNER_ID,

				CONSUMER_ID,

				DELIVER_DATE,

				DELIVER_EMP,

				DISCOUNTTOTAL,

				NETTOTAL,

				GROSSTOTAL,

				TAXTOTAL,

				OTHER_MONEY,

				OTHER_MONEY_VALUE,

				DELIVER_STORE_ID,

				LOCATION,

				RECORD_DATE,

				ADDRESS,

				RECORD_EMP,

				IS_WITH_SHIP

			)

			VALUES

			(

				#attributes.service_id#,

				'#wrk_id#',

				1,

				'#SHIP_NUMBER#',

				#get_process_type.PROCESS_TYPE#,

				#get_process_type.PROCESS_CAT_ID#,					

				NULL,

				#createodbcdatetime(attributes.apply_date)#,

				<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>

				<cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>

				<cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>

				#createodbcdatetime(attributes.apply_date)#,

				'#LEFT(attributes.applicator_name,50)#',

				0,

				0,

				0,

				0,

				'#session.ep.money#',

				0,

				#attributes.department_id#,

				#attributes.location_id#,

				#now()#,

				'#attributes.ADRES#',

				#session.ep.userid#,

				0

			)

		</cfquery>

	

		<cfquery name="GET_ID" datasource="#DSN2#">

			SELECT MAX(SHIP_ID) AS MAX_ID FROM SHIP WHERE WRK_ID='#wrk_id#'

		</cfquery>

		

		

		<cfloop query="GET_SHIP_ROW">

			<cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">

				INSERT INTO

					SHIP_ROW

				(

					NAME_PRODUCT,

					PAYMETHOD_ID,

					SHIP_ID,

					STOCK_ID,

					PRODUCT_ID,

					AMOUNT,

					UNIT,

					UNIT_ID,					

					TAX,

					DISCOUNT,

					PURCHASE_SALES,

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

					DELIVER_DEPT,

					DELIVER_LOC,

					LOT_NO,

					OTHER_MONEY,

					OTHER_MONEY_VALUE,				

					PRICE_OTHER,

					OTHER_MONEY_GROSS_TOTAL,

					COST_ID,

					COST_PRICE,

					EXTRA_COST,

					MARGIN,

					ROW_ORDER_ID,

					PROM_COMISSION,

					PROM_COST,

					DISCOUNT_COST,

					PROM_ID,

					IS_PROMOTION,

					

					PROM_STOCK_ID

				)

				VALUES

				(

					'#left(GET_SHIP_ROW.name_product,75)#',

					NULL,

					#GET_ID.MAX_ID#,

					#GET_SHIP_ROW.stock_id#,

					#GET_SHIP_ROW.product_id#,

					1,

					'#GET_SHIP_ROW.unit#',

					#GET_SHIP_ROW.unit_id#,

					1,

					0,

					1,

					0,

					0,

					0,

					0,

					0,

					0,

					0,

					0,

					0,

					0,

					0,

					0,

					0,					

					#attributes.department_id#,

					#attributes.location_id#,

					NULL,

					NULL,

					NULL,

					NULL,

					0,

					NULL,

					0,

					0,

					NULL,

					0,

					NULL,

					0,

					NULL,

					NULL,

					0,

					NULL

				)

			</cfquery>

		</cfloop>

			<cfset product_id_list=valuelist(GET_SHIP_ROW.product_id)>

			<cfset stock_id_list=valuelist(GET_SHIP_ROW.stock_id)>

			<cfset unit_list = valuelist(GET_SHIP_ROW.unit)>



		<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yap1ls1n --->

			<cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#"><!--- karma koli olan �r�nler --->

				SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID IN (#product_id_list#) AND IS_KARMA=1

			</cfquery>

			<cfquery name="GET_PROD_PRODUCTS" datasource="#dsn2#"><!--- �retilen �r�nler --->

				SELECT STOCK_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID IN (#stock_id_list#) AND IS_PRODUCTION=1

			</cfquery>

			<cfset karma_product_list = valuelist(GET_KARMA_PRODUCTS.PRODUCT_ID)>

			<cfset prod_product_list = valuelist(GET_PROD_PRODUCTS.STOCK_ID)>

			

			<cfloop from="1" to="#listlen(product_id_list)#" index="i">

				<cfquery name="GET_UNIT" datasource="#dsn2#">

					SELECT 

						ADD_UNIT,

						MULTIPLIER,

						MAIN_UNIT,

						PRODUCT_UNIT_ID

					FROM

						#dsn3_alias#.PRODUCT_UNIT 

					WHERE 

						PRODUCT_ID = #listgetat(product_id_list,i)# AND

						ADD_UNIT = '#listgetat(unit_list,i)#'

				</cfquery>

				

				<cfif get_unit.recordcount  and len(get_unit.multiplier)>

					<cfset multi=get_unit.multiplier*1>

				<cfelse>

					<cfset multi=1>

				</cfif>

				

				<cfif not (isdefined("karma_product_list") and ListFind(karma_product_list,listgetat(product_id_list,i)))>

				<!--- sat1rdaki �r�n karma koli olmad11 s�rece kendisine hareket yapar,

				bir �r�n hem karma koli olup hem spect se�ilme gibi durumlarda yanl1_ �al1_t1g1 d�_�n�lmesin,business gerei olamaz,

				�r�ne bal1 spec,karma koli,�r�n aac1 tan1mlamalar1ndan sadece biri yap1lmal1d1r...AE20060621--->

						<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#"><!--- sat1rlardaki ana �r�nler i�in stok hareketleri--->

							INSERT INTO 

								STOCKS_ROW

								(

									UPD_ID,

									PRODUCT_ID,

									STOCK_ID,

									PROCESS_TYPE,

									STOCK_OUT,

									STORE,

									STORE_LOCATION,

									PROCESS_DATE

								)

								VALUES

								(

									#GET_ID.MAX_ID#,

									#listgetat(product_id_list,i)#,

									#listgetat(stock_id_list,i)#,

									#get_process_type.PROCESS_TYPE#,

									#multi#,

									#attributes.department_id#,

									#attributes.location_id#,

									#now()#

								)

						</cfquery>

				</cfif>

				<!--- sat1rdaki �r�nlerin spec-�r�naac1-karmakoli ��z�mleri --->



				<cfif len(karma_product_list) and ListFind(karma_product_list,listgetat(product_id_list,i))><!--- karma koliyse --->

					<cfquery name="GET_KARMA_PRODUCT" datasource="#dsn2#">

						SELECT PRODUCT_ID,STOCK_ID,PRODUCT_AMOUNT FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = #listgetat(product_id_list,i)#

					</cfquery>

					<cfif GET_KARMA_PRODUCT.recordcount>

						<cfloop query="GET_KARMA_PRODUCT">

							<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">

								INSERT INTO

									STOCKS_ROW

								(

									UPD_ID,

									PRODUCT_ID,

									STOCK_ID,

									PROCESS_TYPE,

									STOCK_OUT,

									STORE,

									STORE_LOCATION,

									PROCESS_DATE

								)

								VALUES

								(

									#GET_ID.MAX_ID#,

									#GET_KARMA_PRODUCT.product_id#,

									#GET_KARMA_PRODUCT.stock_id#,

									#get_process_type.PROCESS_TYPE#,

									#multi*GET_KARMA_PRODUCT.product_amount#,

									#attributes.department_id#,

									#attributes.location_id#,

									#now()#

								)

							</cfquery>

						</cfloop>

					</cfif>

				<cfelseif len(prod_product_list) and ListFindnocase(prod_product_list,listgetat(stock_id_list,i))><!--- �retilen �r�nse --->

					<cfquery name="GET_PROD_PRODUCT" datasource="#dsn2#">

						SELECT

							S.STOCK_ID,

							S.PRODUCT_ID,

							PT.AMOUNT

						FROM

							#dsn3_alias#.PRODUCT_TREE PT,

							#dsn3_alias#.STOCKS S

						WHERE

							PT.RELATED_ID = S.STOCK_ID AND

							PT.IS_SEVK = 1 AND<!--- sevkte birle_tir--->

							PT.STOCK_ID = #listgetat(stock_id_list,i)#

					</cfquery>

					<cfif GET_PROD_PRODUCT.recordcount>

						<cfloop query="GET_PROD_PRODUCT">

							<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">

								INSERT INTO

									STOCKS_ROW

								(

									UPD_ID,

									PRODUCT_ID,

									STOCK_ID,

									PROCESS_TYPE,

									STOCK_OUT,

									STORE,

									STORE_LOCATION,

									PROCESS_DATE

								)

								VALUES

								(

									#GET_ID.MAX_ID#,

									#GET_PROD_PRODUCT.PRODUCT_ID#,

									#GET_PROD_PRODUCT.STOCK_ID#,

									#get_process_type.PROCESS_TYPE#,

									#multi*GET_PROD_PRODUCT.AMOUNT#,

									#attributes.department_id#,

									#attributes.location_id#,

									#now()#

								)

							</cfquery>

						</cfloop>

					</cfif>

				</cfif>

			</cfloop>

		</cfif>

	</cftransaction>

</cflock>

<!--- seriye otomatik kayit atma olayi --->

<cfquery name="GET_PRO_GUARANTY" datasource="#dsn3#" maxrows="1">

	SELECT

		SGN.PURCHASE_START_DATE,

		SGN.SERIAL_NO,

		SGN.STOCK_ID,

		SGN.PURCHASE_GUARANTY_CATID,

		SG.GUARANTYCAT_TIME

	FROM

		SERVICE_GUARANTY_NEW SGN,

		#dsn_alias#.SETUP_GUARANTY AS SG,

		#dsn2_alias#.SHIP S,

		SERVICE SR

	WHERE

		SGN.PURCHASE_GUARANTY_CATID=SG.GUARANTYCAT_ID AND

		SGN.PROCESS_ID = S.SHIP_ID AND

		SGN.PROCESS_CAT = 140 AND

		SGN.STOCK_ID = SR.STOCK_ID AND

		S.SERVICE_ID = SR.SERVICE_ID AND

		S.SERVICE_ID = #attributes.service_id#

</cfquery>



<cfif GET_PRO_GUARANTY.recordcount and len(GET_PRO_GUARANTY.PURCHASE_START_DATE)>

	<cfinclude template="../../objects/functions/add_serial_no.cfm">

	<cfset attributes.serial_no_start_number1 = GET_PRO_GUARANTY.SERIAL_NO>

	<cfset attributes.guaranty_purchasesales1 = 1>

	<cfset attributes.stock_id1 = GET_PRO_GUARANTY.STOCK_ID>

	<cfset attributes.guaranty_cat1 = GET_PRO_GUARANTY.PURCHASE_GUARANTY_CATID>

	<cfset attributes.guaranty_startdate1 = GET_PRO_GUARANTY.PURCHASE_START_DATE>

	<cfset temp_start_date = GET_PRO_GUARANTY.PURCHASE_START_DATE>

	<cfif len(temp_start_date) and isdate(temp_start_date)>

		<cfset temp_date = dateadd("m", GET_PRO_GUARANTY.GUARANTYCAT_TIME, temp_start_date)>

		<cf_date tarih="temp_start_date">

	</cfif>

		<cfscript>

			add_serial_no(

			session_row : 1,

			process_type : get_process_type.PROCESS_TYPE, 

			process_number : SHIP_NUMBER,

			process_id : GET_ID.MAX_ID,

			dpt_id : attributes.department_id,

			loc_id : attributes.location_id,

			par_id : attributes.partner_id,

			con_id : attributes.consumer_id,

			main_stock_id : '',

			comp_id : attributes.company_id

			);

		</cfscript>

<cfelse>

	<script>

		alert('0rsaliye Kaydedildi! Ancak Seri Kayd1 Yap1lamad1!');

	</script>

</cfif>

<!--- seriye otomatik kayit atma olayi --->

</cfif>




