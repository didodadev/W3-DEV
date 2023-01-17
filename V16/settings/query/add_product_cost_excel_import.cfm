<!--- FBS Bu sayfada alis-satis kurlarinin ters calismasi durumu icin duzenleme yapilmali!! Yoksa hesaplama yanlis oluyor FBS 20120207 --->
<cfsetting showdebugoutput="no">
<cf_date tarih='attributes.date1'>
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cftry>
	<cffile action = "upload" 
		fileField = "uploaded_file" 
		destination = "#upload_folder#"
		nameConflict = "MakeUnique"  
		mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	satir_no =0;
	satir_say =0;
</cfscript>
<cfquery name="GET_SETUP_MONEY" datasource="#dsn#">
    SELECT (RATE2/RATE1) RATE, MONEY FROM SETUP_MONEY WHERE PERIOD_ID=#session.ep.period_id#
</cfquery>
<cfquery name="get_money_history" datasource="#dsn#">
	SELECT
		(RATE2/RATE1) AS RATE,MONEY ,VALIDATE_DATE
	FROM 
		MONEY_HISTORY
	WHERE
		VALIDATE_DATE IN (SELECT MAX(MH2.VALIDATE_DATE) FROM MONEY_HISTORY MH2 WHERE VALIDATE_DATE <= #DATEADD('d',1, attributes.date1)# AND PERIOD_ID = #session.ep.period_id#)
		AND VALIDATE_DATE <= #DATEADD('d',1, attributes.date1)#
		AND PERIOD_ID = #session.ep.period_id#
	ORDER BY 
		VALIDATE_DATE,
		MONEY_HISTORY_ID 
</cfquery>
<cfquery name="get_period" datasource="#dsn#">
	SELECT 
		SP.INVENTORY_CALC_TYPE
	FROM 
		SETUP_PERIOD SP
	WHERE 
		SP.PERIOD_ID = <cfqueryparam value="#session.ep.period_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfoutput query="get_money_history"><cfset '#money#_rate'=RATE></cfoutput>
<cfoutput query="GET_SETUP_MONEY"><cfif not isdefined('#money#_rate')><cfset '#money#_rate'= RATE></cfif></cfoutput>
<cflock name="#createuuid()#" timeout="500">
	<cftransaction>
		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cfset error_flag = 0>
			<cfscript>
				stock_code_or_special_code = trim(Listgetat(dosya[i],j,";")); j=j+1;
				product_cost = filternum(Listgetat(dosya[i],j,";"),8); j=j+1; //net maliyet
				if(listlen(dosya[i],';') gte j)
					product_extra_cost = filternum(Listgetat(dosya[i],j,";"),8); //ek maliyet
				else
					product_extra_cost = 0; //ek maliyet
				j=j+1;
				if(not len(product_extra_cost))product_extra_cost=0;
				product_cost_system = filternum(Listgetat(dosya[i],j,";"),8); j=j+1; //sistem net maliyet
				if(listlen(dosya[i],';') gte j)
					product_cost_extra_system = filternum(Listgetat(dosya[i],j,";"),8); //sistem ek maliyet
				else
					product_cost_extra_system =0; //sistem ek maliyet
				j=j+1;
				if(not len(product_cost_extra_system))product_cost_extra_system=0;
				product_cost_2 = filternum(Listgetat(dosya[i],j,";"),8); j=j+1; //sistem döviz net maliyet
				product_extra_cost_2 = filternum(Listgetat(dosya[i],j,";"),8); j=j+1; //sistem döviz ek maliyet
				if(listlen(dosya[i],';') gte j)
					spect_main_id = Listgetat(dosya[i],j,";");
				else
					spect_main_id ='';
			</cfscript>
			<cfif not len(stock_code_or_special_code)>
			   <cfoutput> #i#.Satırda Stok Yada Özel Kod Boş!<br/></cfoutput>
			<cfelse>	
				<cfquery name="get_product_info" datasource="#dsn3#" maxrows="1">
					SELECT PRODUCT_UNIT_ID,PRODUCT_ID,STOCK_ID,IS_PRODUCTION,IS_PROTOTYPE,(SELECT TOP 1 SM.SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = STOCKS.STOCK_ID AND SM.SPECT_STATUS = 1 ORDER BY SM.RECORD_DATE DESC) SPECT_NEW FROM STOCKS WHERE <cfif attributes.paper_key eq 1>STOCK_CODE<cfelse>PRODUCT_CODE_2</cfif> = '#stock_code_or_special_code#'
				</cfquery>
				<cfif get_product_info.recordcount>
					<cfquery name="get_money_product" datasource="#dsn3#">
						SELECT MONEY FROM PRICE_STANDART WHERE PRODUCT_ID = #get_product_info.PRODUCT_ID# AND PURCHASESALES = 0 AND PRICESTANDART_STATUS = 1
					</cfquery>
					<cfif get_money_product.recordcount>
						<cfif (not len(spect_main_id)) and (get_product_info.is_production eq 1) and (get_product_info.is_prototype eq 0) and len(get_product_info.spect_new)>
							<cfset spect_main_id = get_product_info.spect_new>
						</cfif>
						<!--- Maliyet Ekliyor --->
						<cfset _MONEY_ = get_money_product.MONEY>
						<cfif isdefined('#_MONEY_#_rate')>
							<cftry>
								<cfif len(product_cost_2)>
									<cfset price_system_2=product_cost_2>
								<cfelseif isdefined('session.ep.money2') and len(session.ep.money2)>
									<cfset price_system_2=product_cost_system/evaluate('#session.ep.money2#_rate')>
								<cfelse>
									<cfset price_system_2=product_cost_system/evaluate('USD_rate')>
								</cfif>
								<cfif len(product_extra_cost_2)>
									<cfset price_extra_system_2=product_extra_cost_2>
								<cfelseif isdefined('session.ep.money2') and len(session.ep.money2)>
									<cfset price_extra_system_2=product_extra_cost/evaluate('#session.ep.money2#_rate')>
								<cfelse>
									<cfset price_extra_system_2=product_extra_cost/evaluate('USD_rate')>
								</cfif>
								<cfquery name="UPD_COST" datasource="#dsn3#">
									UPDATE
										#dsn1_alias#.PRODUCT_COST
									SET
										PRODUCT_COST_STATUS = 0
									WHERE
										PRODUCT_ID = #get_product_info.product_id#
										AND START_DATE <= #attributes.date1#
								</cfquery>
								<cfquery name="GET_COST_STATUS" datasource="#dsn3#">
									SELECT
										PRODUCT_COST_STATUS
									FROM
										#dsn1_alias#.PRODUCT_COST
									WHERE
										PRODUCT_COST_STATUS = 1
										AND	PRODUCT_ID = #get_product_info.product_id#
										AND START_DATE > #attributes.date1#
								</cfquery>
								<cfquery name="GET_STOCK_AMOUNT" datasource="#DSN3#">
									SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM #dsn2_alias#.STOCKS_ROW SR WHERE SR.STOCK_ID = #get_product_info.STOCK_ID# AND PROCESS_DATE <= #attributes.date1#
								</cfquery>
								<cfif GET_STOCK_AMOUNT.recordcount>
									<cfset product_amount = GET_STOCK_AMOUNT.PRODUCT_TOTAL_STOCK>
								<cfelse>
									<cfset product_amount = 0>
								</cfif>
								<cfquery name="ADD_COST" datasource="#dsn3#">
									INSERT INTO
										#dsn1_alias#.PRODUCT_COST
										(
											PRODUCT_COST_STATUS,
											PROCESS_STAGE,
											INVENTORY_CALC_TYPE,
											COST_TYPE_ID,
											START_DATE,
											<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
												STOCK_ID,
											</cfif>
											PRODUCT_ID,
											UNIT_ID,
											IS_SPEC,
											IS_STANDARD_COST,
											IS_ACTIVE_STOCK,
											IS_PARTNER_STOCK,
											COST_DESCRIPTION,
											DEPARTMENT_ID,
											LOCATION_ID,
											ACTION_ID,
											ACTION_TYPE,
											ACTION_PERIOD_ID,
											ACTION_AMOUNT,
											ACTION_ROW_ID,											
											<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
											AVAILABLE_STOCK_LOCATION,
											PARTNER_STOCK_LOCATION,
											ACTIVE_STOCK_LOCATION,
											PRODUCT_COST_LOCATION,
											MONEY_LOCATION,
											STANDARD_COST_LOCATION,
											STANDARD_COST_MONEY_LOCATION,
											STANDARD_COST_RATE_LOCATION,
											PURCHASE_NET_LOCATION,
											PURCHASE_NET_LOCATION_ALL,
											PURCHASE_NET_MONEY_LOCATION,
											PURCHASE_EXTRA_COST_LOCATION,
											PRICE_PROTECTION_LOCATION,
											PRICE_PROTECTION_MONEY_LOCATION,
											PURCHASE_NET_SYSTEM_LOCATION,
											PURCHASE_NET_SYSTEM_LOCATION_ALL,
											PURCHASE_NET_SYSTEM_MONEY_LOCATION,
											PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
											PURCHASE_NET_SYSTEM_2_LOCATION,
											PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
											PURCHASE_NET_SYSTEM_MONEY_2_LOCATION,
											PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,					
											</cfif>
											AVAILABLE_STOCK,
											PARTNER_STOCK,
											ACTIVE_STOCK,
											PRODUCT_COST,
											MONEY,
											STANDARD_COST,
											STANDARD_COST_MONEY,
											STANDARD_COST_RATE,
											PURCHASE_NET,
											PURCHASE_NET_ALL,
											PURCHASE_NET_MONEY,
											PURCHASE_EXTRA_COST,
											PRICE_PROTECTION,
											PRICE_PROTECTION_MONEY,
											PURCHASE_NET_SYSTEM,
											PURCHASE_NET_SYSTEM_ALL,
											PURCHASE_NET_SYSTEM_MONEY,
											PURCHASE_EXTRA_COST_SYSTEM,
											PURCHASE_NET_SYSTEM_2,
											PURCHASE_NET_SYSTEM_2_ALL,
											PURCHASE_NET_SYSTEM_MONEY_2,
											PURCHASE_EXTRA_COST_SYSTEM_2,					
											IS_SUGGEST,
											SPECT_MAIN_ID,
											RECORD_DATE,
											RECORD_EMP,
											RECORD_IP
										)
										VALUES
										(
											<cfif GET_COST_STATUS.RECORDCOUNT>0<cfelse>1</cfif>,
											#attributes.process_stage#,
											#get_period.INVENTORY_CALC_TYPE#,
											NULL,
											<cfif isdefined('attributes.date1') and len(attributes.date1)>#attributes.date1#<cfelse>NULL</cfif>,
											<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
												#get_product_info.STOCK_ID#,
											</cfif>
											#get_product_info.product_id#,
											#get_product_info.PRODUCT_UNIT_ID#,
											0,
											0,
											0,
											0,
											NULL,
											<cfif isdefined('attributes.department_id') and len(attributes.department_id)>#listgetat(attributes.department_id,1,"-")#<cfelse>NULL</cfif>,
											<cfif isdefined('attributes.department_id') and len(attributes.department_id)>#listgetat(attributes.department_id,2,"-")#<cfelse>NULL</cfif>,									
											NULL,
											-1,<!--- Excelden aktarım olduğu için -1 atıyoruz! --->
											#session.ep.period_id#,
											0,
											NULL,
											<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
												<cfif len(product_amount)>#product_amount#<cfelse>0</cfif>,
												0,
												0,
												#wrk_round(product_cost+product_extra_cost,8)#,<!--- PRODUCT_COST --->
												'#_MONEY_#',
												0,
												'#session.ep.money#',
												0,
												#product_cost#,
												#product_cost#,
												'#_MONEY_#',
												#product_extra_cost#,
												0,
												'#session.ep.money#',
												#product_cost_system#,
												#product_cost_system#,
												'#SESSION.EP.MONEY#',
												#product_extra_cost#,
												#price_system_2#,
												#price_system_2#,
												<cfif isdefined('session.ep.money2') and len(session.ep.money2)>'#session.ep.money2#'<cfelse>'USD'</cfif>,
												#price_extra_system_2#,
											</cfif>
											<cfif len(product_amount)>#product_amount#<cfelse>0</cfif>,
											0,
											0,
											#wrk_round(product_cost+product_extra_cost,8)#,<!--- PRODUCT_COST --->
											'#_MONEY_#',
											0,
											'#session.ep.money#',
											0,
											#product_cost#,
											#product_cost#,
											'#_MONEY_#',
											#product_extra_cost#,
											0,
											'#session.ep.money#',
											#product_cost_system#,
											#product_cost_system#,
											'#SESSION.EP.MONEY#',
											#product_cost_extra_system#,
											#price_system_2#,
											#price_system_2#,
											<cfif isdefined('session.ep.money2') and len(session.ep.money2)>'#session.ep.money2#'<cfelse>'USD'</cfif>,
											#price_extra_system_2#,
											<cfif isdefined('attributes.is_suggest')>#attributes.is_suggest#<cfelse>NULL</cfif>,
											<cfif isdefined('spect_main_id') and len(spect_main_id) and spect_main_id gt 0>#spect_main_id#<cfelse>NULL</cfif>,
											#NOW()#,
											#SESSION.EP.USERID#,
											'#cgi.REMOTE_ADDR#'
										)
								</cfquery>
								<cfset satir_say = satir_say +1>
								<cfcatch type="Any">
									<cfoutput>
										#i#. Satırda <br/>
										<cfif not len(product_cost)>
											&nbsp;&nbsp;&nbsp;&nbsp;*Net Maliyet Eksik.<br/>
										</cfif> 
										<cfif not len(product_cost_system)>
											&nbsp;&nbsp;&nbsp;&nbsp;*Sistem Para Birimli Net Maliyet Eksik.<br/>
										</cfif> 
									</cfoutput>	
									<cfset kont=0>
								</cfcatch> 
							</cftry>
						<cfelse>
						   <cfoutput> [#i#]---#_MONEY_#</cfoutput> <cf_get_lang no ='2129.parabirimine ait kur bilgisi bulunamadı'><br/>
						</cfif>
						<!--- Maliyet Ekledi --->
					<cfelse>
						<cfoutput>#i#.Satırdaki #stock_code_or_special_code# kodlu ürünün Para Birimi Bulunamıyor!</cfoutput><br/>    	
					</cfif>
				<cfelse>
					<cfoutput>#i#.Satırdaki #stock_code_or_special_code# kodlu ürün bulunamadı!<br/></cfoutput>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfoutput>
    Toplam #satir_say# Tane Maliyet Eklendi!
</cfoutput>
