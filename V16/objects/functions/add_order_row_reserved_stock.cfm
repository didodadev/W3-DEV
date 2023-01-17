<!---Siparişte rezerve bilgilerini ve satır aşamalarını güncelleyip,siparişin irsaliye-fatura baglantısını oluşturur. OZDEN20071031 --->
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cfsetting showdebugoutput="yes">
<cffunction name="add_reserve_row" returntype="boolean" output="false">
	<cfargument name="reserve_order_id" required="yes" default=""> <!--- irsaliye islemlerinden liste olarak gonderilebilir, birden fazla siparisin tek irsaliyeye cekildigi durumlar icin --->
	<cfargument name="reserve_stock_id" default="">
	<cfargument name="reserve_product_id" default="">
	<cfargument name="reserve_spect_id" default="">
	<cfargument name="reserve_wrk_row_id" default=""> <!--- stok detayda rezerve çöz ekranından geliyor --->
	<cfargument name="reserve_amount" default="">
	<cfargument name="cancel_amount" default="">
	<cfargument name="related_process_id" default=""><!--- siparis irsaliye ile iliskiliyse ship_id, faturadan ise invoice_id 'yi tutar --->
	<cfargument name="reserve_action_type" required="yes" type="numeric"><!--- 0: ekleme 1: guncelleme 2: silme , 3: reserve çözme işlemi --->
	<cfargument name="reserve_action_iptal" default="0"> <!--- iptal islemlerinde (siparis cekilen irsaliyenin iptali) --->
	<cfargument name="is_order_process" required="yes" type="numeric"> <!--- 0: siparis, 1: irsaliye, 2: fatura, 3: stok durum listesinden işleminden cagrılmıs --->
	<cfargument name="is_purchase_sales" required="yes" type="numeric"> <!--- 0: satınalma siparisi 1: satıs siparisi ORDER_ZONE kontrolu eklenecek--->
	<cfargument name="process_db" required="yes" default="#dsn3#" type="string">
	<cfargument name="process_db_alias" type="string">
	<cfargument name="is_stock_row_action" required="yes" default="1">
	<cfargument name="order_from_partner" default="0">
	<cfargument name="reserve_process_type" default="0">
	<cfscript>
		order_list_for_dept='';
		if(isdefined("session.pp"))
			session_base = evaluate('session.pp');
		else if(isdefined("session.ep"))
			session_base = evaluate('session.ep');
		else if(isdefined("session.pda"))
			session_base = evaluate('session.pda');
		else if(isdefined("session.ww"))
			session_base = evaluate('session.ww');
		else if(isdefined("arguments.session_base"))
			session_base = evaluate('arguments.session_base');
	
		ship_related_order_list=''; // irsaliyeye cekilen siparislerin listesi
		no_change_order_list =''; //reserve bilgileri degistirilmeyecek irsaliyelerin listesi
		old_order_list_ = ''; //onceden iliskilendirilmis irsaliyeler
		removed_order_list = ''; //irsaliye ve faturadan cıkarılmıs irsaliyeler
		stock_count_list_='';

		if(not (isdefined("arguments.process_db_alias") and len(arguments.process_db_alias)))
			if(arguments.process_db is not 'dsn3')
				arguments.process_db_alias = '#dsn3_alias#.';
			else
				arguments.process_db_alias = '';
	</cfscript>
	<cfif reserve_action_iptal neq 1 and reserve_action_type neq 2 and not len(arguments.reserve_order_id)>
		<script type="text/javascript">
			alert('İşlem İle İlgili Sipariş Bilgisi Eksik!');
		</script>
		<cfabort>
	</cfif>
	<!--- ORDER_ROW_RESERVED tablosuna depo ve lokasyon bilgileri gönderilecek. irsaliye ve faturada ilgili oldukları siparişlere ait rezerveleri çözdügü için,
	 irs. fatura satırlarına da sipariş depo-lokasyon bilgileri gönderiliyor --->
	<cfif len(arguments.reserve_order_id)>
		<cfquery name="GET_ORD_DEPT_INFO_" datasource="#arguments.process_db#">
			SELECT
				(CAST(DELIVER_DEPT_ID AS NVARCHAR(20))+'_'+CAST(LOCATION_ID AS NVARCHAR(20))) AS ORD_DEPT_LOCATION,
				ORDER_ID
			FROM
				#arguments.process_db_alias#ORDERS
			WHERE
				ORDER_ID IN (#arguments.reserve_order_id#)
				AND DELIVER_DEPT_ID IS NOT NULL
		</cfquery>
		<cfif GET_ORD_DEPT_INFO_.recordcount>
			<cfset order_list_for_dept= valuelist(GET_ORD_DEPT_INFO_.ORDER_ID)>
		</cfif>
	<cfelse>
		<cfset GET_ORD_DEPT_INFO_.recordcount=0>
	</cfif>
	<cfif listfind('0,1',arguments.reserve_action_type) and not listfind('0,3',arguments.is_order_process)> <!--- ekleme ve güncelleme --->
		<!--- siparis veya faturayla iliskili oldugu halde bu islemler guncellendiginde satır reserveleri degistirilmeyecek siparisler cekiliyor --->
		<cfquery name="CONTROL_RESERVE_STATUS" datasource="#arguments.process_db#"> 
			SELECT 
				ORDER_ID,CHANGE_RESERVE_STATUS
			FROM
				<cfif arguments.is_order_process eq 1>
				#arguments.process_db_alias#ORDERS_SHIP
				<cfelseif arguments.is_order_process eq 2>
				#arguments.process_db_alias#ORDERS_INVOICE
				</cfif>
			WHERE
				<cfif arguments.is_order_process eq 1 and len(arguments.related_process_id)>
					SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
					AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
				<cfelseif arguments.is_order_process eq 2 and len(arguments.related_process_id)>
					INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
					AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
				<cfelseif arguments.reserve_action_type eq 0 and len(arguments.reserve_order_id)>
					ORDER_ID IN (#arguments.reserve_order_id#) 
				</cfif>
		</cfquery>
		<cfif CONTROL_RESERVE_STATUS.recordcount>
			<cfif not listfind('0,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- ekleme ve reserve çözme islemi haricindekiler icin --->
				<cfset old_order_list_ = valuelist(CONTROL_RESERVE_STATUS.ORDER_ID)>
			</cfif>
		</cfif>
	</cfif>
	<!--- reserve_order_id sadece iptal ve silme islemlerinde bos gelebilir kontrol eklenecek --->
	<!--- ekleme islemi haric her durumda oncelikle ORDER_ROW_RESERVED tablosundaki kayıtlar siliniyor--->
	<cfif not listfind('0,3',arguments.reserve_action_type) and reserve_process_type eq 0> <!--- guncelleme islemiyse --->
		<cfquery name="DEL_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
			DECLARE @RetryCounter INT
			SET @RetryCounter = 1
			RETRY:
				BEGIN TRY
					DELETE FROM 
						#arguments.process_db_alias#ORDER_ROW_RESERVED WITH (UPDLOCK,ROWLOCK)
					WHERE
					<cfif len(arguments.reserve_order_id)>
						ORDER_ID IN (#arguments.reserve_order_id#) AND 
					</cfif> 
					<cfif is_order_process eq 1>  <!--- siparisin cekildigi irsaliyeye ait rezerve satırlar siliniyor --->
						SHIP_ID = #arguments.related_process_id# AND 
						PERIOD_ID =#session_base.period_id#
					<cfelseif is_order_process eq 2> <!---siparisin cekildigi faturaya ait rezerve satırlar siliniyor --->
						INVOICE_ID = #arguments.related_process_id# AND
						PERIOD_ID =#session_base.period_id#
					<cfelse>  <!--- siparisteki rezerve satırlar siliniyor --->
						SHIP_ID IS NULL	AND
						INVOICE_ID IS NULL				
					</cfif>
				END TRY
				BEGIN CATCH
					DECLARE @DoRetry bit; 
					DECLARE @ErrorMessage varchar(500)
					SET @doRetry = 0;
					SET @ErrorMessage = ERROR_MESSAGE()
					IF ERROR_NUMBER() = 1205 
					BEGIN
						SET @doRetry = 1; 
					END
					IF @DoRetry = 1
					BEGIN
						SET @RetryCounter = @RetryCounter + 1
						IF (@RetryCounter > 3)
						BEGIN
							RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
						END
						ELSE
						BEGIN
							WAITFOR DELAY '00:00:00.05' 
							GOTO RETRY	
						END
					END
					ELSE
					BEGIN
						RAISERROR(@ErrorMessage, 18, 1)
					END
				END CATCH
		</cfquery>
	</cfif>
	<!--- IPTAL VE SILME ISLEMLERINDE CALISAN BOLUM --->
	<cfif listfind('1,2',arguments.is_order_process) and ( arguments.reserve_action_iptal eq 1 or arguments.reserve_action_type eq 2 )>
		<!--- IPTAL IRSALIYE BOLUMU: irsaliye iptal secildiginde, irsaliyeye çekilmiş sipariş varsa; irsaliye-sipariş baglantıları koparılıp, sipariş satır aşamaları ve rezerve tipleri guncellenir... --->
		<cfif arguments.is_order_process eq 1 and arguments.reserve_action_iptal eq 1> <!---iptal edilen irsaliyenin satırlarındaki siparis bilgileri siliniyor --->
			<cfquery name="UPD_RELATED_SHIP_ROW" datasource="#arguments.process_db#"> 
				UPDATE #dsn2_alias#.SHIP_ROW SET ROW_ORDER_ID = 0 WHERE SHIP_ID = #arguments.related_process_id#
			</cfquery>
		<cfelseif arguments.is_order_process eq 2 and arguments.reserve_action_iptal eq 1> 
			<cfquery name="UPD_RELATED_INVOICE_ROW" datasource="#arguments.process_db#"> 
				UPDATE #dsn2_alias#.INVOICE_ROW SET ORDER_ID=NULL WHERE INVOICE_ID=#form.invoice_id#
			</cfquery>
		</cfif>
		<cfif arguments.is_order_process eq 1><!--- irsaliyeden --->
			<cfquery name="GET_RESERVE_ORDERS" datasource="#arguments.process_db#"> <!--- silinecek veya iptal edilecek irsaliyenin siparis bilgileri alınıyor --->
				SELECT ORDER_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
			</cfquery>
		<cfelse><!--- faturadan --->
			<cfquery name="GET_RESERVE_ORDERS" datasource="#arguments.process_db#"> <!--- silinecek veya iptal edilecek irsaliyenin siparis bilgileri alınıyor --->
				SELECT ORDER_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#"> AND PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
			</cfquery>
		</cfif>
		<cfif GET_RESERVE_ORDERS.recordcount>
			<cfset ship_related_order_list=valuelist(GET_RESERVE_ORDERS.ORDER_ID)> <!--- bu listeye gore alt bolumde siparisler guncelleniyor --->
		</cfif>
	<cfelse>
		<!--- ekleme --->
		<cfif arguments.is_order_process eq 0 and isdefined('arguments.order_from_partner') and arguments.order_from_partner eq 1> <!--- ww ve ppden siparis kaydedilgidinde otomatik reserve kaydediliyor --->
			<cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
				DECLARE @RetryCounter INT
				SET @RetryCounter = 1
				RETRY:
				BEGIN TRY
					INSERT INTO
						#arguments.process_db_alias#ORDER_ROW_RESERVED
					(
						STOCK_ID,
						PRODUCT_ID,
						SPECT_VAR_ID,
						ORDER_ID,
						<cfif arguments.is_purchase_sales eq 1>
							RESERVE_STOCK_OUT,
						<cfelse>
							RESERVE_STOCK_IN,
						</cfif>
						SHELF_NUMBER,
						ORDER_WRK_ROW_ID,
						DEPARTMENT_ID,
						LOCATION_ID		
					)
					SELECT
						ORDER_ROW.STOCK_ID,
						ORDER_ROW.PRODUCT_ID,
						ORDER_ROW.SPECT_VAR_ID,
						ORDER_ROW.ORDER_ID,
						ORDER_ROW.QUANTITY,
						ORDER_ROW.SHELF_NUMBER,
						ORDER_ROW.WRK_ROW_ID,
						ISNULL(ORDER_ROW.DELIVER_DEPT,ORDERS.DELIVER_DEPT_ID),
						ISNULL(ORDER_ROW.DELIVER_LOCATION,ORDERS.LOCATION_ID)
					FROM 
						#arguments.process_db_alias#ORDER_ROW ORDER_ROW,
						#arguments.process_db_alias#ORDERS ORDERS
					WHERE
						ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID
						AND ORDERS.ORDER_ID= #reserve_order_id#
				END TRY
				BEGIN CATCH
					DECLARE @DoRetry bit; 
					DECLARE @ErrorMessage varchar(500)
					SET @doRetry = 0;
					SET @ErrorMessage = ERROR_MESSAGE()
					IF ERROR_NUMBER() = 1205 
					BEGIN
						SET @doRetry = 1; 
					END
					IF @DoRetry = 1
					BEGIN
						SET @RetryCounter = @RetryCounter + 1
						IF (@RetryCounter > 3)
						BEGIN
							RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
						END
						ELSE
						BEGIN
							WAITFOR DELAY '00:00:00.05' 
							GOTO RETRY	
						END
					END
					ELSE
					BEGIN
						RAISERROR(@ErrorMessage, 18, 1)
					END
				END CATCH
			</cfquery>
		<cfelseif arguments.is_order_process eq 3 and len(arguments.reserve_stock_id) and ( (len(arguments.reserve_amount) and arguments.reserve_amount neq 0) or len(arguments.cancel_amount) )>
			<!--- stok durum listesinden stock_id, spect_id ,order_id ve miktar göndererek urun reserve edilmesi --->
			<cfquery name="CONTROL_ORDER_RESERVE_AMOUNT" datasource="#arguments.process_db#">
				SELECT 
					<cfif arguments.is_purchase_sales eq 1>
						SUM(RESERVE_STOCK_OUT+RESERVE_CANCEL_AMOUNT) AS CONTROL_RESERVE_AMOUNT,
					<cfelse>
						SUM(RESERVE_STOCK_IN+RESERVE_CANCEL_AMOUNT) AS CONTROL_RESERVE_AMOUNT,
					</cfif>
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						,ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID
					</cfif>
				FROM 
					#arguments.process_db_alias#ORDER_ROW_RESERVED 
				WHERE 
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
					AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
					</cfif>
					<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
						AND ISNULL(ORDER_WRK_ROW_ID,0) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reserve_wrk_row_id#">
					</cfif>
				GROUP BY
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					,ISNULL(SPECT_VAR_ID,0)
					</cfif>
				ORDER BY
					STOCK_ID
			</cfquery>
			<cfif arguments.reserve_action_type neq 3><!--- reserve çözme işlemi degilse --->
				<cfquery name="CONTROL_ORDER_AMOUNT" datasource="#arguments.process_db#">
					SELECT 
						SUM(QUANTITY-CANCEL_AMOUNT) QUANTITY,STOCK_ID
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						,ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID
						</cfif>
					FROM 
						#arguments.process_db_alias#ORDER_ROW 
					WHERE 
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
						AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
						</cfif>
						<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
						AND ISNULL(WRK_ROW_ID,0) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reserve_wrk_row_id#">
						</cfif>
					GROUP BY
						STOCK_ID
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						,ISNULL(SPECT_VAR_ID,0)
						</cfif>
					ORDER BY
						STOCK_ID
				</cfquery> 
				<cfif CONTROL_ORDER_RESERVE_AMOUNT.recordcount>
					<cfset max_reserve_amount = CONTROL_ORDER_AMOUNT.QUANTITY-CONTROL_ORDER_RESERVE_AMOUNT.CONTROL_RESERVE_AMOUNT>
				<cfelse>
					<cfset max_reserve_amount = CONTROL_ORDER_AMOUNT.QUANTITY>
				</cfif>
			<cfelse>
				<cfif CONTROL_ORDER_RESERVE_AMOUNT.recordcount> <!--- çözülebilecek max. reserve miktarı belirleniyor --->
					<cfset max_reserve_amount = CONTROL_ORDER_RESERVE_AMOUNT.CONTROL_RESERVE_AMOUNT>
				<cfelse>
					<cfset max_reserve_amount = 0>
				</cfif>
			</cfif>
			<cfif len(arguments.cancel_amount)> <!--- iptal edilecek miktar çözülecek veya reserve edilecek miktara ekleniyor. --->
				<cfset arguments.reserve_amount=arguments.reserve_amount+arguments.cancel_amount>
			</cfif>
			<cfif arguments.reserve_amount gt max_reserve_amount>
				<script type="text/javascript">
					alert("Max. Reserve Miktarını Aştınız!<cfif arguments.reserve_action_type eq 3>Rezervesi Çözülebilecek<cfelse>Rezerve Edilebilecek </cfif> Max. Miktar <cfoutput>#max_reserve_amount#</cfoutput> 'dir");
				</script>
				<cfif not len(arguments.cancel_amount)><!--- iptal işlemi çalıştırılacaksa max_reserve_amount reserve_amount olarak set edilip, işleme devam edilir ve sipariş aşaması güncellenir --->
					<cfabort>
				</cfif>
				<cfset arguments.reserve_amount = max_reserve_amount> 
			</cfif>
			<cfif arguments.reserve_action_type eq 3>
				<cfset arguments.reserve_amount = max_reserve_amount-arguments.reserve_amount> <!--- reserve edilmis miktardan çözülecek miktar cıkarılarak, kalması gereken rezerve miktarı bulunur --->
				<cfquery name="DEL_RESERVE_ROWS" datasource="#arguments.process_db#">
					DELETE FROM 
						ORDER_ROW_RESERVED
					WHERE
						SHIP_ID IS NULL AND INVOICE_ID IS NULL
						AND ORDER_ID=#arguments.reserve_order_id#
						AND STOCK_ID =#arguments.reserve_stock_id#
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						AND SPECT_VAR_ID = #arguments.reserve_spect_id#
						</cfif>
						<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
						AND ISNULL(ORDER_WRK_ROW_ID,0) = '#arguments.reserve_wrk_row_id#'
						</cfif>
				</cfquery>
			</cfif>
			<cfif arguments.reserve_amount gt 0 or (len(arguments.cancel_amount) and arguments.cancel_amount gt 0)>
				<cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
					INSERT INTO
						#arguments.process_db_alias#ORDER_ROW_RESERVED
					(
						STOCK_ID,
						PRODUCT_ID,
						SPECT_VAR_ID,
						ORDER_ID,
						<!--- DEPARTMENT_ID,
						LOCATION_ID, --->
						ORDER_WRK_ROW_ID,
						RESERVE_CANCEL_AMOUNT,
						<cfif arguments.is_purchase_sales eq 1>
							RESERVE_STOCK_OUT
						<cfelse>
							RESERVE_STOCK_IN
						</cfif>
					)
					VALUES
					(
						#arguments.reserve_stock_id#,
						#arguments.reserve_product_id#,
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>#arguments.reserve_spect_id#<cfelse>NULL</cfif>,
						#arguments.reserve_order_id#,
						<!--- <cfif len(listfirst(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,arguments.reserve_order_id)],'_'))>#listfirst(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,arguments.reserve_order_id)],'_')#<cfelse>NULL</cfif>,
						<cfif len(listlast(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,arguments.reserve_order_id)],'_'))>#listlast(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,arguments.reserve_order_id)],'_')#<cfelse>NULL</cfif>,
						 --->
						 <cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>'#arguments.reserve_wrk_row_id#'<cfelse>NULL</cfif>,
						<cfif len(arguments.cancel_amount)>#arguments.cancel_amount#<cfelse>0</cfif>,
						#arguments.reserve_amount#
					)
				</cfquery>
			</cfif>
			<cfquery name="GET_ORDER_ROW_INFO" datasource="#arguments.process_db#">
				SELECT 
					 QUANTITY,STOCK_ID,
					 <cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					  ISNULL(SPECT_VAR_ID,0),
					 </cfif>
					 RESERVE_TYPE,ORDER_ROW_ID,ISNULL(WRK_ROW_ID,0) AS WRK_ROW_ID
				FROM 
					#arguments.process_db_alias#ORDER_ROW 
				WHERE 
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
					AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
					</cfif>
					<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
					AND ISNULL(WRK_ROW_ID,0) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reserve_wrk_row_id#">
					</cfif>
			</cfquery>
			<cfquery name="get_reserve_amounts" datasource="#arguments.process_db#">
				SELECT
					<cfif arguments.is_purchase_sales>
						SUM(RESERVE_STOCK_OUT) AS TOTAL_RESERVED_AMOUNT,
						SUM(STOCK_OUT) AS PROCESSED_RESERVED_AMOUNT,
					<cfelse>
						SUM(RESERVE_STOCK_IN) AS TOTAL_RESERVED_AMOUNT,
						SUM(STOCK_IN) AS PROCESSED_RESERVED_AMOUNT,
					</cfif>
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					,ISNULL(SPECT_VAR_ID,0)
					</cfif>
					,ISNULL(ORDER_WRK_ROW_ID,0) AS ORDER_WRK_ROW_ID
				FROM
					#arguments.process_db_alias#ORDER_ROW_RESERVED
				WHERE
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
					AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
					</cfif>
				GROUP BY
					ISNULL(ORDER_WRK_ROW_ID,0),
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					,ISNULL(SPECT_VAR_ID,0)
					</cfif>
			</cfquery>
			<cfset upd_order_ =''>
			<cfoutput query="GET_ORDER_ROW_INFO">
				<cfif get_reserve_amounts.recordcount>
					<cfloop query="get_reserve_amounts">
						<cfif (get_reserve_amounts.ORDER_WRK_ROW_ID eq 0) or (get_reserve_amounts.ORDER_WRK_ROW_ID eq GET_ORDER_ROW_INFO.WRK_ROW_ID)> <!--- sadece bu satır icin yapılan rezervasyonlar vewrk_row_id siz  eski kayıtları içinde 0 olanlara bakılıyor --->
							<cfif get_reserve_amounts.TOTAL_RESERVED_AMOUNT neq 0 and get_reserve_amounts.TOTAL_RESERVED_AMOUNT eq get_reserve_amounts.PROCESSED_RESERVED_AMOUNT>
								<cfset order_row_reserve_type_ = -4><!--- Rezerve Kapatıldı --->
							<cfelse>
								<cfif (get_reserve_amounts.TOTAL_RESERVED_AMOUNT-get_reserve_amounts.PROCESSED_RESERVED_AMOUNT) neq 0 and (get_reserve_amounts.TOTAL_RESERVED_AMOUNT-get_reserve_amounts.PROCESSED_RESERVED_AMOUNT) lt GET_ORDER_ROW_INFO.QUANTITY>
									<cfset order_row_reserve_type_ = -2>
								<cfelse>
									<cfset order_row_reserve_type_ = -1>
								</cfif>
							</cfif>
						<cfelse>
							<cfset order_row_reserve_type_ = -3>
						</cfif>
					</cfloop>
				<cfelse>
					<cfset order_row_reserve_type_ = -3>
				</cfif>
				<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
					UPDATE 
						#arguments.process_db_alias#ORDER_ROW 
					SET 
						RESERVE_TYPE = #order_row_reserve_type_#
					WHERE
						ORDER_ID = #arguments.reserve_order_id# AND
						ORDER_ROW_ID = #GET_ORDER_ROW_INFO.ORDER_ROW_ID#
				</cfquery>
				<cfif listfind('-1,-2',order_row_reserve_type_)>
					<cfset upd_order_=1>
				</cfif>
			</cfoutput>
			<cfquery name="GET_PAPER_RESERVE_INFO" datasource="#arguments.process_db#">
				SELECT DISTINCT RESERVE_TYPE FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
			</cfquery>
			<cfset paper_row_reserve_list = valuelist(GET_PAPER_RESERVE_INFO.RESERVE_TYPE)>
			<cfif isdefined('paper_row_reserve_list') and len(paper_row_reserve_list)>
				<cfquery name="UPD_ORD" datasource="#arguments.process_db#">
					UPDATE 
						#arguments.process_db_alias#ORDERS 
					SET
					<cfif listfind(paper_row_reserve_list,'-1') or listfind(paper_row_reserve_list,'-2')>
						RESERVED = 1
					<cfelse>
						RESERVED = 0
					</cfif>
					WHERE 
						ORDER_ID = #arguments.reserve_order_id#
				</cfquery>			
			</cfif>
		<cfelse>
			<cfloop from="1" to="#attributes.rows_#" index="row_xx" >
				<cfif arguments.is_order_process eq 0 and (isdefined("attributes.reserve_type#row_xx#") and evaluate("attributes.reserve_type#row_xx#") neq -3 AND isdefined("attributes.order_currency#row_xx#") and not listfind('-8,-9,-10',evaluate("attributes.order_currency#row_xx#")))><!---siparisten gelen islemlerde rezerve olmayan satırlar haricindekiler ekleniyor --->
					<cfset add_reserve_row_ =1>
				<cfelseif arguments.is_order_process eq 1 and isdefined('attributes.row_ship_id#row_xx#') and listfirst(evaluate('attributes.row_ship_id#row_xx#'),';') neq 0> <!--- irsaliyeye siparis cekme islemlerinde siparisten gelen satırlar icin --->
					<cfif not listfind(ship_related_order_list,listfirst(evaluate('attributes.row_ship_id#row_xx#'),';')) and reserve_process_type eq 0>
					<!--- irsaliye satırlarındaki order_id'lerden ilişkili siparis listesi olusturuluyor --->
						<cfset ship_related_order_list = listappend(ship_related_order_list,listfirst(evaluate('attributes.row_ship_id#row_xx#'),';'))>
					</cfif>
					<cfif arguments.is_stock_row_action eq 1>
						<cfset add_reserve_row_ =1>
					<cfelse>
						<cfset add_reserve_row_ =0>
					</cfif>
				<cfelseif arguments.is_order_process eq 2> <!--- faturaya --->
					<cfset ship_related_order_list = arguments.reserve_order_id>
					<cfif arguments.is_stock_row_action eq 1>
						<cfset add_reserve_row_ =1>
					<cfelse>
						<cfset add_reserve_row_ =0>
					</cfif>
				<cfelse>
					<cfset add_reserve_row_ =0>
				</cfif>
				<cfif add_reserve_row_ eq 1 and reserve_process_type eq 0>
					<cfif arguments.is_order_process eq 1><!--- irsaliyeden cagrılıyorsa --->
						<cfset row_rel_ord_id_info_=listfirst(evaluate('attributes.row_ship_id#row_xx#'),';')>
					<cfelseif arguments.is_order_process eq 2><!--- faturadan cagrılıyorsa ve çoklu satır var ise --->
                    	<cfif isdefined("attributes.row_ship_id#row_xx#") and len(evaluate('attributes.row_ship_id#row_xx#')) and listfirst(evaluate("attributes.row_ship_id#row_xx#"),';') neq 0>
							<cfset row_rel_ord_id_info_=listfirst(evaluate("attributes.row_ship_id#row_xx#"),';')>
                        <cfelse>
                        	<cfset row_rel_ord_id_info_=''>
                        </cfif>
                    <cfelse>
						<cfset row_rel_ord_id_info_=arguments.reserve_order_id>
					</cfif>
					<cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
						INSERT INTO
							#arguments.process_db_alias#ORDER_ROW_RESERVED
						(
							STOCK_ID,
							PRODUCT_ID,
						<cfif isdefined('attributes.spect_id#row_xx#') and len(evaluate('attributes.spect_id#row_xx#'))>
							SPECT_VAR_ID,
						</cfif>
							DEPARTMENT_ID,
							LOCATION_ID,
						<cfif arguments.is_order_process eq 1><!--- irsaliyeden cagrılıyorsa --->
							ORDER_ID,
							ORDER_WRK_ROW_ID,
							SHIP_ID,
							PERIOD_ID,
						<cfelseif arguments.is_order_process eq 2><!--- faturadan cagrılıyorsa --->
							ORDER_ID,
							ORDER_WRK_ROW_ID,
							INVOICE_ID,
							PERIOD_ID,
						<cfelse><!--- siparişten cagrılıyorsa --->
							ORDER_ID,
							ORDER_WRK_ROW_ID,
						</cfif>
						<cfif arguments.is_purchase_sales eq 0>
							<cfif arguments.is_order_process eq 0> <!--- satınalma siparis ekleme --->
								RESERVE_STOCK_IN,
							<cfelse> <!---alıs irsaliye ve fatura ekleme --->
								STOCK_IN,
							</cfif>
						<cfelse>
							<cfif arguments.is_order_process eq 0> <!--- satıs siparisi --->
								RESERVE_STOCK_OUT,
							<cfelse>
								STOCK_OUT, <!--- satış irs. ve faturası --->
							</cfif>
						</cfif>
							SHELF_NUMBER		
						)
						VALUES
						(
							#evaluate('attributes.stock_id#row_xx#')#,
							#evaluate('attributes.product_id#row_xx#')#,
						<cfif isdefined('attributes.spect_id#row_xx#') and len(evaluate('attributes.spect_id#row_xx#'))>
							#evaluate('attributes.spect_id#row_xx#')#,	
						</cfif>
						<cfif isdefined("attributes.deliver_dept#row_xx#") and len(trim(evaluate("attributes.deliver_dept#row_xx#"))) and len(listfirst(evaluate("attributes.deliver_dept#row_xx#"),"-"))>
							#listfirst(evaluate("attributes.deliver_dept#row_xx#"),"-")#
						<cfelseif len(listfirst(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,row_rel_ord_id_info_)],'_'))>
							#listfirst(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,row_rel_ord_id_info_)],'_')#
						<cfelse>
							NULL
						</cfif>,
						<cfif isdefined("attributes.deliver_dept#row_xx#") and listlen(trim(evaluate("attributes.deliver_dept#row_xx#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#row_xx#"),"-"))>
							#listlast(evaluate("attributes.deliver_dept#row_xx#"),"-")#
						<cfelseif len(listlast(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,row_rel_ord_id_info_)],'_'))>
							#listlast(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,row_rel_ord_id_info_)],'_')#
						<cfelse>
							NULL
						</cfif>,
						<cfif arguments.is_order_process eq 1>
							#row_rel_ord_id_info_#,
							<!--- irsaliye satırlarındaki siparis baglntısı  wrk_row_relation_id alanında tutuluyor. wrk_row_relation_id alanı satırın ilgili oldugu  siparisin wrk_row_id degerlerini taşır.--->
							<cfif isDefined("attributes.wrk_row_relation_id#row_xx#") and len(evaluate('attributes.wrk_row_relation_id#row_xx#'))>'#wrk_eval('attributes.wrk_row_relation_id#row_xx#')#'<cfelse>NULL</cfif>, <!--- irsaliyede satırlarındaki wrk_row_relation_id order_row daki wrk_row_id yi tutar--->
							#arguments.related_process_id#,
							#session_base.period_id#,
						<cfelseif arguments.is_order_process eq 2>
							<cfif isDefined('row_rel_ord_id_info_') and len(row_rel_ord_id_info_)>#row_rel_ord_id_info_#<cfelse>NULL</cfif>,
							<!--- fatura satırlarındaki siparis baglantısı  wrk_row_relation_id alanında tutuluyor. wrk_row_relation_id alanı satırın ilgili oldugu siparisin wrk_row_id degerlerini taşır.--->
							<cfif isDefined("attributes.wrk_row_relation_id#row_xx#") and len(evaluate('attributes.wrk_row_relation_id#row_xx#'))>'#wrk_eval('attributes.wrk_row_relation_id#row_xx#')#'<cfelse>NULL</cfif>,<!--- fatura satırlarındaki wrk_row_relation_id order_row daki wrk_row_id yi tutar--->
							#arguments.related_process_id#,
							#session_base.period_id#,
						<cfelse>
							#row_rel_ord_id_info_#,
							<!--- siparisin satırlarındaki wrk_row_id yani kendi unique id si --->
							<cfif isDefined("attributes.wrk_row_id#row_xx#") and len(evaluate('attributes.wrk_row_id#row_xx#'))>'#wrk_eval('attributes.wrk_row_id#row_xx#')#'<cfelse>NULL</cfif>,
						</cfif>
							#evaluate('attributes.amount#row_xx#')#,
						<cfif isdefined('attributes.shelf_number#row_xx#') and len(evaluate('attributes.shelf_number#row_xx#'))>#evaluate('attributes.shelf_number#row_xx#')#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop >		
		</cfif>
	</cfif>
	<cfif len(old_order_list_)>
		<cfloop list="#old_order_list_#" index="old_order_">
			<cfif not listfind(ship_related_order_list,old_order_)>
				<cfset ship_related_order_list = listappend(ship_related_order_list,old_order_)>
				<cfset removed_order_list = listappend(removed_order_list,old_order_) >
			</cfif>
		</cfloop>
	</cfif>
	<cfif (listfind('1,2',arguments.is_order_process) and len(ship_related_order_list)) or arguments.is_order_process eq 3><!--- siparisi irsaliyeye cekme islemiyse siparisin satır aşamaları update edilir. --->
	<!--- islemle ilgili cıkarılmıs ya da onceden eklenmis irsaliyelerin hepsinin icinden degistirilmeyecek eski siparisler bulunuyor --->
		<cfif arguments.is_order_process neq 3><!--- rezerve çöz ve satır iptal işlemlerinden gelmiyorsa --->
			<cfquery name="GET_CHANGE_RESERVE_STATUS" datasource="#arguments.process_db#">
				SELECT 
					DISTINCT ORDER_ID
				FROM
					<cfif arguments.is_order_process eq 1>
					#arguments.process_db_alias#ORDERS_SHIP
					<cfelseif arguments.is_order_process eq 2>
					#arguments.process_db_alias#ORDERS_INVOICE
					</cfif>
				WHERE
					ORDER_ID IN (#ship_related_order_list#)
					AND CHANGE_RESERVE_STATUS=0
					<cfif (arguments.reserve_action_type eq 1 and arguments.reserve_action_iptal eq 1) or arguments.reserve_action_type eq 2><!--- silme ve guncelleme isleminde ilgili isleme ait kayıt haric bırakılır --->
					AND
					<cfif arguments.is_order_process eq 1>
					 ORDER_SHIP_ID NOT IN (
					<cfelseif arguments.is_order_process eq 2>
					 ORDER_INVOICE_ID NOT IN (
					</cfif>
								SELECT 
								<cfif arguments.is_order_process eq 1>
								ORDER_SHIP_ID
								<cfelseif arguments.is_order_process eq 2>
								ORDER_INVOICE_ID
								</cfif>
									 
								FROM
									<cfif arguments.is_order_process eq 1>
									#arguments.process_db_alias#ORDERS_SHIP
									<cfelseif arguments.is_order_process eq 2>
									#arguments.process_db_alias#ORDERS_INVOICE
									</cfif>
								WHERE
									<cfif arguments.is_order_process eq 1 and len(arguments.related_process_id)>
										SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
										AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
									<cfelseif arguments.is_order_process eq 2 and len(arguments.related_process_id)>
										INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
										AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
									</cfif>
					)	
					</cfif>
			</cfquery>
			<cfif GET_CHANGE_RESERVE_STATUS.recordcount>
				<cfset no_change_order_list = valuelist(GET_CHANGE_RESERVE_STATUS.ORDER_ID)>
			</cfif>
			<cfif listfind('1,2',arguments.reserve_action_type) and reserve_process_type eq 0> <!--- irsaliye guncelleme veya silme sayfasından cagrılıyorsa once o irsaliyeye ait ORDERS_SHIP kayıtları silinir --->
				<cfif arguments.is_order_process eq 1> <!--- siparis irsaliyeye cekilmis --->
					<cfquery name="del_ship_orders" datasource="#arguments.process_db#">
						DELETE 
							FROM #arguments.process_db_alias#ORDERS_SHIP 
						WHERE 
							SHIP_ID=#arguments.related_process_id#
							AND PERIOD_ID=#session_base.period_id#
							<cfif len(no_change_order_list) and not listfind('2,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- silme veya iptal degilse CHANGE_RESERVE_STATUS 0 olan siparislere ait satırlar silinmiyor --->
							AND ORDER_ID NOT IN (#no_change_order_list#)
							</cfif> 
					</cfquery>
				<cfelseif arguments.is_order_process eq 2>
					<cfquery name="del_ship_orders" datasource="#arguments.process_db#">
						DELETE 
							FROM #arguments.process_db_alias#ORDERS_INVOICE 
						WHERE 
							INVOICE_ID=#arguments.related_process_id#
							AND PERIOD_ID=#session_base.period_id#
							<cfif len(no_change_order_list) and not listfind('2,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- silme veya iptal degilse CHANGE_RESERVE_STATUS 0 olan siparislere ait satırlar silinmiyor --->
							AND ORDER_ID NOT IN (#no_change_order_list#)
							</cfif> 
					</cfquery>
				</cfif>
			</cfif>
		<cfelse>
			<cfset ship_related_order_list=arguments.reserve_order_id>
		</cfif> 
		<cfloop list="#ship_related_order_list#" index="order_ind_">
			<cfset reserve_stock_list_ =''><!--- yerini degistirmeyelim her sipariste liste resetlenmeli. --->
			<cfset ship_stock_list_ =''>
			<cfset ship_stock_relation_list_ =''>
			<!--- ORDERS_SHIP - ORDER_INVOICE tablosuna kayıt yazılması için
			1-irsaliye veya faturayla iliskisi kesilmis siparisler listesinde olmamalı.
			2-iptal veya silme isleminden cagrılmamıs olmalı
			3-guncelleme isleminden cagrılmıssa degistirilmeyecek siparisler listesinde olmamalı, cunku guncellemede bu siparislerin ORDERS_SHIP - ORDER_INVOICE'deki kayıtları silmiyoruz --->
			<cfif arguments.is_order_process neq 3 and not listfind(removed_order_list,order_ind_) and not ( arguments.reserve_action_iptal eq 1 or arguments.reserve_action_type eq 2 ) and not (arguments.reserve_action_type eq 1 and listfind(no_change_order_list,order_ind_) )>
				<cfif arguments.is_order_process eq 1>
					<cfquery name="add_orders_ship" datasource="#arguments.process_db#"> <!--- 1. siparis-irsaliye iliskisini tutan ORDERS_SHIP tablosuna kayıt atılır --->
						INSERT INTO
							#arguments.process_db_alias#ORDERS_SHIP
							(
								ORDER_ID,
								SHIP_ID,
								PERIOD_ID
							)
						VALUES
							(
								#order_ind_#,
								#arguments.related_process_id#,
								#session_base.period_id#
							)
					</cfquery>
				<cfelseif arguments.is_order_process eq 2> <!--- siparis faturaya cekilmisse --->
					<cfquery name="add_orders_ship" datasource="#arguments.process_db#"> <!--- 1. siparis-irsaliye iliskisini tutan ORDERS_SHIP tablosuna kayıt atılır --->
						INSERT INTO
							#arguments.process_db_alias#ORDERS_INVOICE
							(
								ORDER_ID,
								INVOICE_ID,
								PERIOD_ID
							)
						VALUES
							(
								#order_ind_#,
								#arguments.related_process_id#,
								#session_base.period_id#
							)
					</cfquery>
				</cfif>
			</cfif> 
			<!--- 2.siparisi urunlerinin miktarları alınıyor --->
			<cfquery name="get_order_amounts" datasource="#arguments.process_db#">
				SELECT 
					(ORR.QUANTITY-ISNULL(ORR.CANCEL_AMOUNT,0)) AS ORDER_AMOUNT,
					ORR.STOCK_ID,
					ORR.ORDER_ROW_ID,
					ISNULL(ORR.WRK_ROW_ID,0) AS WRK_ROW_ID,
					ORR.RESERVE_TYPE,
					ORR.ORDER_ROW_CURRENCY AS ROW_CURRENCY,
					O.RESERVED
				FROM 
					#arguments.process_db_alias#ORDERS O,
					#arguments.process_db_alias#ORDER_ROW ORR
				WHERE 
					O.ORDER_ID=ORR.ORDER_ID
					AND O.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					<cfif arguments.is_order_process eq 3>
						<!--- Iptalden Geliyorsa sadece ilgili satiri degerlendirsin, Siparis Karsilama Popupindan baska bir yerde is_order_process:3 gelmediginden ekledim, sorun olursa duzeltelim fbs 20130314 --->
						<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
							AND ISNULL(WRK_ROW_ID,0) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reserve_wrk_row_id#">
						</cfif>
					</cfif>
				ORDER BY
					ORR.STOCK_ID,
					ORR.ORDER_ROW_ID				
			</cfquery>
			<cfquery name="get_order_stock_counts" datasource="#arguments.process_db#">
				SELECT 
					COUNT(STOCK_ID) AS STOCK_COUNT,
					ORR.STOCK_ID
				FROM 
					#arguments.process_db_alias#ORDER_ROW ORR
				WHERE 
					ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
				GROUP BY
					ORR.STOCK_ID
				HAVING 
					COUNT(STOCK_ID) > 1
				ORDER BY
					ORR.STOCK_ID				
			</cfquery>
			<cfset stock_count_list_=valuelist(get_order_stock_counts.STOCK_ID)>
			<!---3.satır rezerveleri karsılastırmak icin siparisteki urunlerin  stok hareketi yapan irsaliyelere cekilmis miktarları bulunuyor --->
			<cfif arguments.is_order_process neq 3> <!--- iptalden gelen rezerve işlemleri farklı bölümde set edildi --->
				<cfquery name="get_reserve_amounts" datasource="#arguments.process_db#">
					SELECT
					<cfif arguments.is_purchase_sales>
						SUM(STOCK_OUT) AS RESERVE_AMOUNT,
					<cfelse>
						SUM(STOCK_IN) AS RESERVE_AMOUNT,
					</cfif>
						STOCK_ID,
						ISNULL(ORDER_WRK_ROW_ID,0) AS ORDER_WRK_ROW_ID
					FROM
						#arguments.process_db_alias#ORDER_ROW_RESERVED
					WHERE
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
						AND (SHIP_ID IS NOT NULL OR INVOICE_ID IS NOT NULL)
					GROUP BY
						STOCK_ID,
						ISNULL(ORDER_WRK_ROW_ID,0)
					ORDER BY
						STOCK_ID
				</cfquery>
			</cfif>
			<cfif listfind('1,3',arguments.is_order_process)><!--- irsaliyeyle iliskiliyse veya satır iptal den geliyorsa--->
				<cfquery name="get_order_ship_periods" datasource="#arguments.process_db#">
					SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					UNION
					SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
				</cfquery>
				<cfif get_order_ship_periods.recordcount> <!--- siparisle ilgili irsaliye kaydı varsa --->
					<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
					<!--- 4. siparis sadece aktif donemdeki irsaliyelerle iliskilendirilmis --->
					<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session_base.period_id>
						<cfquery name="get_all_ship_amount" datasource="#arguments.process_db#">
							SELECT
								ROUND(SUM(SHIP_AMOUNT),2) SHIP_AMOUNT,
								STOCK_ID,
								WRK_ROW_RELATION_ID
							FROM
							(
								<!--- direkt ilişkili irsaliyeler --->
								SELECT
									SUM(SR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.SHIP S,
									#dsn2_alias#.SHIP_ROW SR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2><!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
									AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0)
								<!--- irsaliyelerin iadeleri --->
								UNION ALL
								SELECT
									SUM(-1*SRR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.SHIP S,
									#dsn2_alias#.SHIP SS,
									#dsn2_alias#.SHIP_ROW SR,
									#dsn2_alias#.SHIP_ROW SRR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SS.SHIP_ID=SRR.SHIP_ID
									AND SR.WRK_ROW_ID=SRR.WRK_ROW_RELATION_ID
									AND SS.SHIP_TYPE IN(73,74,78)
									AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2><!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
										AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0)
								UNION ALL
								SELECT
									SUM(IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.INVOICE I,
									#dsn2_alias#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND IR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
								GROUP BY
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0)
							)T1
							GROUP BY
								STOCK_ID,
								WRK_ROW_RELATION_ID
							ORDER BY
								STOCK_ID
						</cfquery>
					<cfelse>
						<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
						<cfquery name="get_period_dsns" datasource="#arguments.process_db#">
							SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
						</cfquery>
						<cfquery name="get_all_ship_amount" datasource="#arguments.process_db#">
							SELECT
								ROUND(SUM(SHIP_AMOUNT),2) AS SHIP_AMOUNT,
								A1.STOCK_ID,
								A1.WRK_ROW_RELATION_ID
							FROM
							(
								<cfloop query="get_period_dsns">
									SELECT
										SUM(SR.AMOUNT) AS SHIP_AMOUNT,
										SR.STOCK_ID,
										ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
									FROM
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
									WHERE
										S.SHIP_ID = SR.SHIP_ID
										AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
										<cfif get_period_dsns.PERIOD_YEAR eq session_base.period_id and len(arguments.related_process_id) and reserve_action_type eq 2>
										AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
										</cfif>
									GROUP BY
										SR.STOCK_ID,
										ISNULL(SR.WRK_ROW_RELATION_ID,0)
									<!--- irsaliyelerin iadeleri --->
									UNION ALL
									SELECT
										SUM(-1*SRR.AMOUNT) AS SHIP_AMOUNT,
										SR.STOCK_ID,
										ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
									FROM
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP SS,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SRR
									WHERE
										S.SHIP_ID=SR.SHIP_ID
										AND SS.SHIP_ID=SRR.SHIP_ID
										AND SR.WRK_ROW_ID=SRR.WRK_ROW_RELATION_ID
										AND SS.SHIP_TYPE IN(73,74,78)
										AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
										<cfif len(arguments.related_process_id) and reserve_action_type eq 2><!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
											AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
										</cfif>
									GROUP BY
										SR.STOCK_ID,
										ISNULL(SR.WRK_ROW_RELATION_ID,0)
									UNION ALL
									SELECT
										SUM(IR.AMOUNT) AS SHIP_AMOUNT,
										IR.STOCK_ID,
										ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
									FROM
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE I,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
									WHERE
										I.INVOICE_ID=IR.INVOICE_ID
										AND IR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									GROUP BY
										IR.STOCK_ID,
										ISNULL(IR.WRK_ROW_RELATION_ID,0)
									<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
								</cfloop> 
							) AS A1
							GROUP BY
								A1.STOCK_ID,
								A1.WRK_ROW_RELATION_ID
							ORDER BY
								A1.STOCK_ID
						</cfquery>
					</cfif>
					<cfset reserve_stock_list_ = listsort(valuelist(get_reserve_amounts.STOCK_ID),'numeric','ASC')>
					<cfset reserve_stock_relation_list_ = valuelist(get_reserve_amounts.ORDER_WRK_ROW_ID)>
					<cfset ship_stock_list_ = listsort(valuelist(get_all_ship_amount.STOCK_ID),'numeric','ASC')>
					<cfset ship_stock_relation_list_ = valuelist(get_all_ship_amount.WRK_ROW_RELATION_ID)>
				</cfif>
			<cfelseif arguments.is_order_process eq 2> <!--- faturayla iliskiliyse --->
				<cfquery name="get_order_ship_periods" datasource="#arguments.process_db#">
					SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					UNION
					SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
				</cfquery>
				<cfif get_order_ship_periods.recordcount>
					<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
					<!--- 4. siparis sadece aktif donemdeki irsaliyelerle iliskilendirilmis --->
					<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session_base.period_id>
						<cfquery name="get_all_ship_amount" datasource="#arguments.process_db#">
							SELECT
								ROUND(SUM(SHIP_AMOUNT),2) AS SHIP_AMOUNT,
								T1.STOCK_ID,
								T1.WRK_ROW_RELATION_ID
							FROM
							(	SELECT
									SUM(SR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.SHIP S,
									#dsn2_alias#.SHIP_ROW SR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SR.ROW_ORDER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
								GROUP BY
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0)
							UNION ALL
								SELECT
									SUM(IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.INVOICE I,
									#dsn2_alias#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND I.INVOICE_CAT NOT IN(55,62)
									AND IR.ORDER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2> <!--- silme isleminde silinecek fatura haricindeki faturaların satırlarına bakılıyor --->
									AND I.INVOICE_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0)
							UNION ALL
								SELECT
									SUM(-1*IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.INVOICE I,
									#dsn2_alias#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND I.INVOICE_CAT IN(55,62)
									AND IR.ORDER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2> <!--- silme isleminde silinecek fatura haricindeki faturaların satırlarına bakılıyor --->
									AND I.INVOICE_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0)
							)T1
							GROUP BY
								T1.STOCK_ID,
								T1.WRK_ROW_RELATION_ID
							ORDER BY
								T1.STOCK_ID
						</cfquery>
					<cfelse>
					<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
						<cfquery name="get_period_dsns" datasource="#arguments.process_db#">
							SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
						</cfquery>
						<cfquery name="get_all_ship_amount" datasource="#arguments.process_db#">
							SELECT
								SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
								A1.STOCK_ID,
								A1.WRK_ROW_RELATION_ID
							FROM
							(
							<cfloop query="get_period_dsns">
								SELECT
									SUM(SR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
								GROUP BY
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0)
							UNION ALL
								SELECT
									SUM(IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID,
									ISNULL(WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE I,
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND IR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif get_period_dsns.PERIOD_YEAR eq session_base.period_id and len(arguments.related_process_id) and reserve_action_type eq 2> <!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
									AND I.INVOICE_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									IR.STOCK_ID,
									ISNULL(WRK_ROW_RELATION_ID,0)
								<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
							</cfloop> ) AS A1
								GROUP BY
									A1.STOCK_ID,
									A1.WRK_ROW_RELATION_ID
								ORDER BY
									A1.STOCK_ID
						</cfquery>
					</cfif>
					<cfset reserve_stock_list_ = listsort(valuelist(get_reserve_amounts.STOCK_ID),'numeric','ASC')>
					<cfset reserve_stock_relation_list_ = valuelist(get_reserve_amounts.ORDER_WRK_ROW_ID)>
					<cfset ship_stock_list_ = listsort(valuelist(get_all_ship_amount.STOCK_ID),'numeric','ASC')>
					<cfset ship_stock_relation_list_ = valuelist(get_all_ship_amount.WRK_ROW_RELATION_ID)>
				</cfif>
			</cfif>
			<cfset order_process_flag = 0>
			<!--- -1 Açık, -2 Tedarik, -3 Kapatıldı, -4 Kısmi Üretim, -5 Üretim, -6 Sevk, -7 Eksik Teslimat, -8 Fazla Teslimat, -9 İptal, -10 Kapatıldı(Manuel --->
			<cfset paper_general_reserve_type = false> <!--- belge bazında rezerveyi gosterir --->
			<cfloop query="get_order_amounts"><!---6. siparis satırlarının reserve_type belirleniyor. DIKKAT: rezerve_type stok hareketi yapan irsaliyelerdeki miktarlara gore hesaplanır --->
				<br/>
				<cfif arguments.is_order_process neq 3> <!--- satır iptal veya rezerve çöz değilse --->
					<cfif listlen(reserve_stock_list_) and listfind(reserve_stock_list_,STOCK_ID) and (get_order_amounts.RESERVE_TYPE neq -3  AND get_order_amounts.row_currency and not listfind('-8,-9,-10',get_order_amounts.row_currency)) and not listfind(no_change_order_list,order_ind_)>
						<cfset order_row_reserve_amount_=ORDER_AMOUNT>
						<cfif not ( isdefined('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') and len(evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#')) ) and get_reserve_amounts.ORDER_WRK_ROW_ID[listfind(reserve_stock_list_,STOCK_ID)] eq 0>
							<cfset '_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#'=get_reserve_amounts.RESERVE_AMOUNT[listfind(reserve_stock_list_,STOCK_ID)]>
						</cfif>
						<cfif len(WRK_ROW_ID) and WRK_ROW_ID neq 0 and listfind(reserve_stock_relation_list_,WRK_ROW_ID)><!--- satırın birebir ilişkili oldugu sipariş satırları bulunuyor --->
							<cfset '_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=get_reserve_amounts.RESERVE_AMOUNT[listfind(reserve_stock_relation_list_,WRK_ROW_ID)]>
						<cfelse>
							<cfset '_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=0>
						</cfif>
						<cfif not (isdefined('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') and len(evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#')) )>
							<cfset '_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#'=0>
						</cfif>
						<cfif len(WRK_ROW_ID) and WRK_ROW_ID neq 0 and evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
							<cfset row_temp_reserve_amount=ORDER_AMOUNT-evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')> <!--- satırı kapatmak için gerekli olan kalan miktar --->
						<cfelse>
							<cfset row_temp_reserve_amount=ORDER_AMOUNT>
						</cfif>	
						<cfif evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') gt 0 and row_temp_reserve_amount gt 0>
							<cfif evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') gte row_temp_reserve_amount>
								<cfset '_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')+row_temp_reserve_amount>
								<cfset '_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#'=evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#')-row_temp_reserve_amount>
							<cfelseif evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') lt row_temp_reserve_amount>
								<cfset '_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')+evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#')>
								<cfset '_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#'=0>
							</cfif>
						</cfif>
						<cfif ORDER_AMOUNT lte evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') and evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
							<cfset order_row_reserve_type_ = -4> <!--- Rezerve Kapatıldı --->
						<cfelseif ORDER_AMOUNT gt evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') and evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
							<cfset order_row_reserve_type_ = -2> <!--- Kısmı Rezerve--->
						<cfelseif evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') eq 0>
							<cfset order_row_reserve_type_ = -1> <!--- Rezerve Değil--->
						<cfelse>
							<cfset order_row_reserve_type_ = get_order_amounts.RESERVE_TYPE>
						</cfif>
					<cfelse>
					 <!--- 1-irsaliyeye cekilmis olsada siparis satırında rezerve degil secilmisse rezerve tipi değiştirilmez 2- CHANGE_RESERVE_STATUS 0 olan yani no_change_order_list listesindeki siparislerin reserve asamaları da degistirilmez. --->
						<cfset order_row_reserve_type_ = get_order_amounts.RESERVE_TYPE> <!--- stok hareketi yapan irsaliyeye cekilmemis satır siparisteki rezerve tipini korur --->
					</cfif>
					<cfif listfind('-1,-2',order_row_reserve_type_) and listfind('0,1',arguments.reserve_action_type)><!---Ekleme ve Güncelleme İşlemlerinde tek bir satır bile rezerve veya kısmı rezerve ise belge bazında rezervasyon secilir--->
						<cfset paper_general_reserve_type = true>
					<cfelseif listfind('-1,-2,-4',order_row_reserve_type_) and (arguments.reserve_action_type eq 2 or reserve_action_iptal eq 1)>
					<!--- silme ve iptal islemlerinde kısmı rezerve ve kapatılan rezerve satırlar asagıda rezerve olarak update edileceginden belge bazında rezervede secilmelidir  --->
						<cfset paper_general_reserve_type = true>
					</cfif>
				</cfif>
				
				<cfif listfind('-1,-3,-6,-7,-8,-10',get_order_amounts.ROW_CURRENCY) and listlen(ship_stock_list_) and listfind(ship_stock_list_,STOCK_ID)>	<!---7. siparis satırlarının asamaları (order_currency) belirleniyor. DIKKAT: order_currency irsaliyelestirilen toplam miktara gore bulunuyor --->
					<cfset order_process_flag = 1>
				</cfif>
				<cfif listfind('-1,-3,-6,-7,-8',get_order_amounts.ROW_CURRENCY) and listlen(ship_stock_list_) and listfind(ship_stock_list_,STOCK_ID)>	<!---7. siparis satırlarının asamaları (order_currency) belirleniyor. DIKKAT: order_currency irsaliyelestirilen toplam miktara gore bulunuyor --->
					<cfif not (isdefined('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') and len(evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#')) ) and get_all_ship_amount.WRK_ROW_RELATION_ID[listfind(ship_stock_list_,STOCK_ID)] eq 0>
						<!--- relation baglantısı olmayan o siparişteki aynı urunler için toplam kullanılmış miktar --->
						<cfset '_used_order_stock_amount_#order_ind_#_#STOCK_ID#'=get_all_ship_amount.SHIP_AMOUNT[listfind(ship_stock_list_,STOCK_ID)]>
					</cfif>
					<cfif len(WRK_ROW_ID) and WRK_ROW_ID neq 0 and listfind(ship_stock_relation_list_,WRK_ROW_ID)><!--- satırın birebir ilişkili oldugu sipariş satırları bulunuyor --->
						<cfset '_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=get_all_ship_amount.SHIP_AMOUNT[listfind(ship_stock_relation_list_,WRK_ROW_ID)]>
					<cfelse>
						<cfset '_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=0>
					</cfif>
					<cfif not (isdefined('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') and len(evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#')) )>
						<cfset '_used_order_stock_amount_#order_ind_#_#STOCK_ID#'=0>
					</cfif>
					<cfif len(WRK_ROW_ID) and WRK_ROW_ID neq 0 and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
						<cfset row_temp_amount=ORDER_AMOUNT-evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')> <!--- satırı kapatmak için gerekli olan kalan miktar --->
					<cfelse>
						<cfset row_temp_amount=ORDER_AMOUNT>
					</cfif>
					<cfif evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') gte 0 and row_temp_amount gt 0>
						<cfif evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') gte row_temp_amount>
							<cfset '_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')+row_temp_amount>
							<cfset '_used_order_stock_amount_#order_ind_#_#STOCK_ID#'=evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#')-row_temp_amount>
						<cfelseif evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') lt row_temp_amount>
							<cfset '_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')+evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#')>
							<cfset '_used_order_stock_amount_#order_ind_#_#STOCK_ID#'=0>
						</cfif>
					</cfif>
					<cfif wrk_round(ORDER_AMOUNT,2) eq wrk_round(evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'),2) and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
						<cfset order_row_currency = -3> <!--- kapatıldı aşaması --->
					<cfelseif wrk_round(ORDER_AMOUNT,2) gt wrk_round(evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'),2) and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
						<cfset order_row_currency = -7> <!---eksik teslimat aşaması--->
					<cfelseif ORDER_AMOUNT lt evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
						<cfif listfind(stock_count_list_,STOCK_ID) and not (len(WRK_ROW_ID) and WRK_ROW_ID neq 0)> 
							<!--- siparişte aynı ürün birden fazla satırda varsa ilk satırlar sipariş aşaması kapatıldı set edilir --->
							<cfif isdefined('order_stock_count_#order_ind_#_#STOCK_ID#_') and len(evaluate('order_stock_count_#order_ind_#_#STOCK_ID#_'))>
								<cfset 'order_stock_count_#order_ind_#_#STOCK_ID#_'=evaluate('order_stock_count_#order_ind_#_#STOCK_ID#_')+1>
							<cfelse>
								<cfset 'order_stock_count_#order_ind_#_#STOCK_ID#_'=1>
							</cfif>
							<cfif evaluate('order_stock_count_#order_ind_#_#STOCK_ID#_') lt get_order_stock_counts.STOCK_COUNT[listfind(stock_count_list_,STOCK_ID)]>
								<cfset order_row_currency = -3> <!--- kapatıldı aşaması--->
							<cfelse>
								<cfset order_row_currency = -8> <!--- fazla teslimat aşaması--->
							</cfif>
						<cfelse>
							<cfset order_row_currency = -8> <!--- fazla teslimat aşaması--->
						</cfif>
					<cfelseif listfind('-3,-7,-8',get_order_amounts.ROW_CURRENCY) and ORDER_AMOUNT gt evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') eq 0>
						<cfset order_row_currency = -6> <!---sevk teslimat aşaması--->
					<cfelse>
						<cfset order_row_currency = get_order_amounts.ROW_CURRENCY>
					</cfif>
				<cfelse>	
					<cfset order_row_currency = get_order_amounts.ROW_CURRENCY>
				</cfif>
				
				<cfif listlen(ship_stock_list_) and listfind(ship_stock_list_,STOCK_ID)>
				<!---8. irsaliyelere cekilen toplam miktarına gore siparis asaması , stok hareketi yapan miktara baglı olarak ise rezerve turu update ediliyor.--->
					<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
						UPDATE 
							#arguments.process_db_alias#ORDER_ROW 
						SET 
							ORDER_ROW_CURRENCY = #order_row_currency#
							<cfif isdefined('_used_order_row_stock_amount_#order_ind_#_#get_order_amounts.WRK_ROW_ID#')>
							,DELIVER_AMOUNT = #evaluate('_used_order_row_stock_amount_#order_ind_#_#get_order_amounts.WRK_ROW_ID#')#
							<cfelse>
							,DELIVER_AMOUNT = 0
							</cfif>
							<cfif isdefined('order_row_reserve_type_') and len(order_row_reserve_type_) and listfind(reserve_stock_list_,STOCK_ID)>
							,RESERVE_TYPE = #order_row_reserve_type_#
							</cfif>
						WHERE
							ORDER_ID = #order_ind_# AND
							STOCK_ID = #STOCK_ID# AND
							ORDER_ROW_ID=#get_order_amounts.ORDER_ROW_ID#
					</cfquery>
				<cfelse> 
					<!--- 9.siparisin cekildigi irsaliye yoksa eksik teslimat, kapatıldı ve fazla teslimat aşamaları tekrar sevk haline getiriliyor
					kapatılmıs ve eksik rezerve satırlar rezerve olarak update ediliyor --->
					<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
						UPDATE 
							#arguments.process_db_alias#ORDER_ROW 
						SET 
							ORDER_ROW_CURRENCY = -6
							<cfif isdefined('_used_order_row_stock_amount_#order_ind_#_#get_order_amounts.WRK_ROW_ID#')>
							,DELIVER_AMOUNT = #evaluate('_used_order_row_stock_amount_#order_ind_#_#get_order_amounts.WRK_ROW_ID#')#
							<cfelse>
							,DELIVER_AMOUNT = 0
							</cfif>
							<cfif listfind('-2,-4',get_order_amounts.reserve_type)>
								,RESERVE_TYPE = -1
							</cfif> 
						WHERE 
							ORDER_ID = #order_ind_# AND
							STOCK_ID = #STOCK_ID# AND
							ORDER_ROW_CURRENCY IN (-3,-7,-8) AND
							ORDER_ROW_ID=#get_order_amounts.ORDER_ROW_ID#
					</cfquery>
				</cfif>
			</cfloop>
			<!--- Siparisle iliskili irsaliye ve fatura kontrol edilerek IS_PROCESSED degeri sekilleniyor FBS 20120510 --->
			<cfquery name="get_relation_document_control" datasource="#arguments.process_db#" maxrows="1">
				SELECT ORDER_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE ORDER_ID = #order_ind_#
				UNION ALL
				SELECT ORDER_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE ORDER_ID = #order_ind_#
			</cfquery>
			<cfif get_relation_document_control.recordcount>
				<cfset order_process_flag = 1>
			<cfelse>
				<cfset order_process_flag = 0>
			</cfif>
			<!--- //Siparisle iliskili irsaliye ve fatura kontrol edilerek IS_PROCESSED degeri sekilleniyor FBS 20120510 --->
			<cfquery name="UPD_ORD" datasource="#arguments.process_db#">
				UPDATE 
					#arguments.process_db_alias#ORDERS 
				SET 
					IS_PROCESSED = <cfif order_process_flag>1<cfelse>0</cfif>
					<cfif arguments.is_order_process neq 3>
						,RESERVED = <cfif paper_general_reserve_type>1<cfelse>0</cfif>
					</cfif>
				WHERE 
					ORDER_ID = #order_ind_#
			</cfquery>			
		</cfloop>
	</cfif>
	<cfreturn true>
</cffunction></cfprocessingdirective><cfsetting enablecfoutputonly="no">
