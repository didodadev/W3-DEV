<!---Siparişte rezerve bilgilerini ve satır aşamalarını güncelleyip,siparişin irsaliye-fatura baglantısını oluşturur. OZDEN20071031 --->
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="add_reserve_row" returntype="boolean" output="false">
	<cfargument name="reserve_order_id" required="yes" default=""> <!--- irsaliye islemlerinden liste olarak gonderilebilir, birden fazla siparisin tek irsaliyeye cekildigi durumlar icin --->
	<cfargument name="reserve_stock_id" default="">
	<cfargument name="reserve_product_id" default="">
	<cfargument name="reserve_spect_id" default="">
	<cfargument name="reserve_amount" default="">
	<cfargument name="related_process_id" default=""><!--- siparis irsaliye ile iliskiliyse ship_id, faturadan ise invoice_id 'yi tutar --->
	<cfargument name="reserve_action_type" required="yes" type="numeric"> <!--- 0: ekleme 1: guncelleme 2: silme , 3: reserve çözme işlemi --->
	<cfargument name="reserve_action_iptal" default="0"> <!--- iptal islemlerinde (siparis cekilen irsaliyenin iptali) --->
	<cfargument name="is_order_process" required="yes" type="numeric"> <!--- 0: siparis, 1: irsaliye, 2: fatura, 3: stok durum listesinden işleminden cagrılmıs --->
	<cfargument name="is_purchase_sales" required="yes" type="numeric"> <!--- 0: satınalma siparisi 1: satıs siparisi ORDER_ZONE kontrolu eklenecek--->
	<cfargument name="process_db" required="yes" default="#dsn3#" type="string">
	<cfargument name="process_db_alias" type="string">
	<cfargument name="is_stock_row_action" required="yes" default="1">
	<cfargument name="order_from_partner" default="0">
	<cfif isdefined("session.pp")>
		<cfset session_base = evaluate('session.pp')>
	<cfelseif isdefined("session.ep")>
		<cfset session_base = evaluate('session.ep')>
	<cfelseif isdefined("session.pda")>
		<cfset session_base = evaluate('session.pda')>
	<cfelse>
		<cfset session_base = evaluate('session.ww')>
	</cfif>
	<cfset ship_related_order_list=''> <!--- irsaliyeye cekilen siparislerin listesi --->
	<cfset no_change_order_list =''> <!--- reserve bilgileri degistirilmeyecek irsaliyelerin listesi --->
	<cfset old_order_list_ = ''> <!--- onceden iliskilendirilmis irsaliyeler --->
	<cfset removed_order_list = ''> <!--- irsaliye ve faturadan cıkarılmıs irsaliyeler --->
	<cfif arguments.process_db is not 'dsn3'>
		<cfset arguments.process_db_alias = '#dsn3_alias#.'>
	<cfelse>
		<cfset arguments.process_db_alias = ''>
	</cfif>
	<cfif isdefined('fusebox.control_reserve_stock_action')><!--- sadece pronet için tanımlı geliyor, sonrasında şirket akış parametrelerine baglanabilir --->
		<cfset arguments.is_stock_row_action=1>
	</cfif>
	<cfif reserve_action_iptal neq 1 and reserve_action_type neq 2 and not len(reserve_order_id)>
		<script type="text/javascript">
			alert('İşlem İle İlgili Sipariş Bilgisi Eksik!');
		</script>
		<cfabort>
	</cfif>
	<cfif listfind('0,1',arguments.reserve_action_type) and not listfind('0,3',arguments.is_order_process)> 
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
		<cfif control_reserve_status.recordcount>
			<cfif not listfind('0,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- ekleme ve reserve çözme islemi haricindekiler icin --->
				<cfset old_order_list_ = valuelist(control_reserve_status.order_id)>
			</cfif>
		</cfif>
	</cfif>
	<!--- reserve_order_id sadece iptal ve silme islemlerinde bos gelebilir kontrol eklenecek --->
	<!--- ekleme islemi haric her durumda oncelikle ORDER_ROW_RESERVED tablosundaki kayıtlar siliniyor--->
	<cfif not listfind('0,3',arguments.reserve_action_type)> <!--- guncelleme islemiyse --->
		<cfquery name="DEL_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
			DELETE FROM 
				#arguments.process_db_alias#ORDER_ROW_RESERVED 
			WHERE
				<cfif len(arguments.reserve_order_id)>
					ORDER_ID IN (#arguments.reserve_order_id#) AND 
				</cfif> 
				<cfif is_order_process eq 1>  <!--- siparisin cekildigi irsaliyeye ait rezerve satırlar siliniyor --->
					SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#"> AND 
					PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
				<cfelseif is_order_process eq 2> <!---siparisin cekildigi faturaya ait rezerve satırlar siliniyor --->
					INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#"> AND
					PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
				<cfelse>  <!--- siparisteki rezerve satırlar siliniyor --->
					SHIP_ID IS NULL	AND
					INVOICE_ID IS NULL				
				</cfif>
		</cfquery>
	</cfif>	

	<!--- IPTAL VE SILME ISLEMLERINDE CALISAN BOLUM --->
	<cfif listfind('1,2',arguments.is_order_process) and ( arguments.reserve_action_iptal eq 1 or arguments.reserve_action_type eq 2 )>
		<!--- IPTAL IRSALIYE BOLUMU: irsaliye iptal secildiginde, irsaliyeye çekilmiş sipariş varsa; irsaliye-sipariş baglantıları koparılıp, sipariş satır aşamaları ve rezerve tipleri guncellenir... --->
		<cfif arguments.is_order_process eq 1 and arguments.reserve_action_iptal eq 1> <!---iptal edilen irsaliyenin satırlarındaki siparis bilgileri siliniyor --->
			<cfquery name="UPD_RELATED_SHIP_ROW" datasource="#arguments.process_db#"> 
				UPDATE #dsn2_alias#.SHIP_ROW SET ROW_ORDER_ID = 0 WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
			</cfquery>
		<cfelseif arguments.is_order_process eq 2 and arguments.reserve_action_iptal eq 1> 
			<cfquery name="UPD_RELATED_INVOICE_ROW" datasource="#arguments.process_db#"> 
				UPDATE #dsn2_alias#.INVOICE_ROW SET ORDER_ID=NULL WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
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
		<cfif get_reserve_orders.recordcount>
			<cfset ship_related_order_list=valuelist(get_reserve_orders.order_id)> <!--- bu listeye gore alt bolumde siparisler guncelleniyor --->
		</cfif>
	<cfelse>
		<!--- ekleme --->
		<cfif arguments.is_order_process eq 0 and isdefined('arguments.order_from_partner') and arguments.order_from_partner eq 1> <!--- ww ve ppden siparis kaydedilgidinde otomatik reserve kaydediliyor --->
			<cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
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
					SHELF_NUMBER		
				)
				SELECT
					ORDER_ROW.STOCK_ID,
					ORDER_ROW.PRODUCT_ID,
					ORDER_ROW.SPECT_VAR_ID,
					ORDER_ROW.ORDER_ID,
					ORDER_ROW.QUANTITY,
					ORDER_ROW.SHELF_NUMBER
				FROM 
					#arguments.process_db_alias#ORDER_ROW ORDER_ROW
				WHERE
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#reserve_order_id#">
			</cfquery>
		<cfelseif arguments.is_order_process eq 3 and len(arguments.reserve_stock_id) and len(arguments.reserve_amount) and arguments.reserve_amount neq 0>
			<!--- stok durum listesinden stock_id, spect_id ,order_id ve miktar göndererek urun reserve edilmesi --->
			<cfquery name="CONTROL_ORDER_RESERVE_AMOUNT" datasource="#arguments.process_db#">
				SELECT 
					<cfif arguments.is_purchase_sales eq 1>
						SUM(RESERVE_STOCK_OUT) AS CONTROL_RESERVE_AMOUNT,
					<cfelse>
						SUM(RESERVE_STOCK_IN) AS CONTROL_RESERVE_AMOUNT,
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
				GROUP BY
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						,ISNULL(SPECT_VAR_ID,0)
					</cfif>
			</cfquery>
			<cfif arguments.reserve_action_type neq 3><!--- reserve çözme işlemi degilse --->
				<cfquery name="CONTROL_ORDER_AMOUNT" datasource="#arguments.process_db#">
					SELECT 
						SUM(QUANTITY) QUANTITY,STOCK_ID
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
					GROUP BY
						STOCK_ID
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
							,ISNULL(SPECT_VAR_ID,0)
						</cfif>
				</cfquery> 
				<cfif control_order_reserve_amount.recordcount>
					<cfset max_reserve_amount = control_order_amount.quantity-control_order_reserve_amount.control_reserve_amount>
				<cfelse>
					<cfset max_reserve_amount = control_order_amount.quantity>
				</cfif>
			<cfelse>
				<cfif control_order_reserve_amount.recordcount> <!--- çözülebilecek max. reserve miktarı belirleniyor --->
					<cfset max_reserve_amount = control_order_reserve_amount.control_reserve_amount>
				<cfelse>
					<cfset max_reserve_amount = 0>
				</cfif>
			</cfif>
			<cfif arguments.reserve_amount gt max_reserve_amount>
				<script type="text/javascript">
					alert("Max. Reserve Miktarını Aştınız!<cfif arguments.reserve_action_type eq 3>Rezervesi Çözülebilecek<cfelse>Rezerve Edilebilecek</cfif> Max. Miktar <cfoutput>#max_reserve_amount#</cfoutput> 'dir");
				</script>
				<cfabort>
				<cfset arguments.reserve_amount = max_reserve_amount> 
			</cfif>
			<cfif arguments.reserve_action_type eq 3>
				<cfset arguments.reserve_amount = max_reserve_amount-arguments.reserve_amount> <!--- reserve edilmis miktardan çzöülecek miktar cıkarılarak, kalması gereken rezerve miktarı bulunur --->
				<cfquery name="DEL_RESERVE_ROWS" datasource="#arguments.process_db#">
					DELETE FROM 
						ORDER_ROW_RESERVED
					WHERE
						SHIP_ID IS NULL AND INVOICE_ID IS NULL
						AND ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
						AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
							AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
						</cfif>
				</cfquery>
			</cfif>
			<cfif arguments.reserve_amount gt 0>
				<cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
					INSERT INTO
						#arguments.process_db_alias#ORDER_ROW_RESERVED
					(
						STOCK_ID,

						PRODUCT_ID,
						SPECT_VAR_ID,
						ORDER_ID,
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
					RESERVE_TYPE,ORDER_ROW_ID
				FROM 
					#arguments.process_db_alias#ORDER_ROW 
				WHERE 
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
					AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
					</cfif>
			</cfquery>
			<cfquery name="GET_RESERVE_AMOUNTS" datasource="#arguments.process_db#">
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
				FROM
					#arguments.process_db_alias#ORDER_ROW_RESERVED
				WHERE
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
					AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
					</cfif>
				GROUP BY
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						,ISNULL(SPECT_VAR_ID,0)
					</cfif>
			</cfquery>
			<!--- <cfif get_reserve_amounts.recordcount> --->
			<cfset upd_order_ =''>
			<cfoutput query="get_order_row_info">
				<cfif get_reserve_amounts.recordcount>
					<cfif get_reserve_amounts.total_reserved_amount neq 0 and get_reserve_amounts.total_reserved_amount eq get_reserve_amounts.processed_reserved_amount>
						<cfset order_row_reserve_type_ = -4><!--- Rezerve Kapatıldı --->
					<cfelse>
						<cfif (get_reserve_amounts.total_reserved_amount-get_reserve_amounts.processed_reserved_amount) neq 0 and (get_reserve_amounts.total_reserved_amount-get_reserve_amounts.processed_reserved_amount) lt quantity>
							<cfset order_row_reserve_type_ = -2>
						<cfelse>
							<cfset order_row_reserve_type_ = -1>
						</cfif>
					</cfif>
				<cfelse>
					<cfset order_row_reserve_type_ = -3>
				</cfif>
				<!--- <cfif processed_reserve_ neq 0 and QUANTITY lte processed_reserve_>
				<cfelseif processed_reserve_ neq 0 and QUANTITY gt processed_reserve_>
					<cfset order_row_reserve_type_ = -2>
				<cfelse>
					<cfset order_row_reserve_type_ = -1>
				</cfif>
				<cfset processed_reserve_ = processed_reserve_ - QUANTITY> --->
				<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
					UPDATE 
						#arguments.process_db_alias#ORDER_ROW 
					SET 
						RESERVE_TYPE = #order_row_reserve_type_#
					WHERE
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#"> AND
						ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row_info.order_row_id#">
				</cfquery>
				<cfif listfind('-1,-2',order_row_reserve_type_)>
					<cfset upd_order_=1>
				</cfif>
			</cfoutput>
			<!--- </cfif> --->
			<cfquery name="GET_PAPER_RESERVE_INFO" datasource="#arguments.process_db#">
				SELECT DISTINCT RESERVE_TYPE FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
			</cfquery>
			<cfset paper_row_reserve_list = valuelist(get_paper_reserve_info.reserve_type)>
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
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
				</cfquery>			
			</cfif>
		<cfelse>
			<cfloop from="1" to="#attributes.rows_#" index="row_xx">
            	<cfif evaluate('attributes.row_kontrol#row_xx#')>
					<cfif arguments.is_order_process eq 0 and isdefined("attributes.reserve_type#row_xx#") and evaluate("attributes.reserve_type#row_xx#") neq -3><!---siparisten gelen islemlerde rezerve olmayan satırlar haricindekiler ekleniyor --->
						<cfset add_reserve_row_ =1>
					<cfelseif arguments.is_order_process eq 1 and isdefined('attributes.row_ship_id#row_xx#') and listfirst(evaluate('attributes.row_ship_id#row_xx#'),';') neq 0> <!--- irsaliyeye siparis cekme islemlerinde siparisten gelen satırlar icin --->
						<cfif not listfind(ship_related_order_list,listfirst(evaluate('attributes.row_ship_id#row_xx#'),';')) and len(trim(listfirst(evaluate('attributes.row_ship_id#row_xx#'),';')))>
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
					<cfif add_reserve_row_ eq 1>
						<cfif arguments.is_order_process eq 1 and isdefined('attributes.row_ship_id#row_xx#') and Len(evaluate('attributes.row_ship_id#row_xx#')) and Len(Evaluate("attributes.reserve_type#row_xx#"))><!--- irsaliyeden cagrılıyorsa --->
							<cfset row_rel_ord_id_info_=listfirst(evaluate('attributes.row_ship_id#row_xx#'),';')>
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
									<cfif arguments.is_order_process eq 1>
										#row_rel_ord_id_info_#,
										<!--- irsaliye satırlarındaki siparis baglntısı  wrk_row_relation_id alanında tutuluyor. wrk_row_relation_id alanı satırın ilgili oldugu  siparisin wrk_row_id degerlerini taşır.--->
										<cfif len(evaluate('attributes.wrk_row_relation_id#row_xx#'))>'#evaluate('attributes.wrk_row_relation_id#row_xx#')#'<cfelse>NULL</cfif>, <!--- irsaliyede satırlarındaki wrk_row_relation_id order_row daki wrk_row_id yi tutar--->
										#arguments.related_process_id#,
										#session_base.period_id#,
									<cfelseif arguments.is_order_process eq 2>
										#row_rel_ord_id_info_#,
										<!--- fatura satırlarındaki siparis baglntısı  wrk_row_relation_id alanında tutuluyor. wrk_row_relation_id alanı satırın ilgili oldugu siparisin wrk_row_id degerlerini taşır.--->
										<cfif len(evaluate('attributes.wrk_row_relation_id#row_xx#'))>'#evaluate('attributes.wrk_row_relation_id#row_xx#')#'<cfelse>NULL</cfif>,<!--- fatura satırlarındaki wrk_row_relation_id order_row daki wrk_row_id yi tutar--->
										#arguments.related_process_id#,
										#session_base.period_id#,
									<cfelse>
										#row_rel_ord_id_info_#,
										<!--- siparisin satırlarındaki wrk_row_id yani kendi unique id si --->
										<cfif len(evaluate('attributes.wrk_row_id#row_xx#'))>'#evaluate('attributes.wrk_row_id#row_xx#')#'<cfelse>NULL</cfif>,
									</cfif>
									#evaluate('attributes.amount#row_xx#')#,
									<cfif isdefined('attributes.shelf_number#row_xx#') and len(evaluate('attributes.shelf_number#row_xx#'))>#evaluate('attributes.shelf_number#row_xx#')#<cfelse>NULL</cfif>
								)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>		
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
	<cfif listfind('1,2',arguments.is_order_process) and len(ship_related_order_list)><!--- siparisi irsaliyeye cekme islemiyse siparisin satır aşamaları update edilir. --->
	<!--- islemle ilgili cıkarılmıs ya da onceden eklenmis irsaliyelerin hepsinin icinden degistirilmeyecek eski siparisler bulunuyor --->
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
			<cfif get_change_reserve_status.recordcount>
				<cfset no_change_order_list = valuelist(get_change_reserve_status.order_id)>
			</cfif>
			<cfif listfind('1,2',arguments.reserve_action_type)> <!--- irsaliye guncelleme veya silme sayfasından cagrılıyorsa once o irsaliyeye ait ORDERS_SHIP kayıtları silinir --->
				<cfif arguments.is_order_process eq 1> <!--- siparis irsaliyeye cekilmis --->
					<cfquery name="DEL_SHIP_ORDERS" datasource="#arguments.process_db#">
						DELETE 
							FROM #arguments.process_db_alias#ORDERS_SHIP 
						WHERE 
							SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
							AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
							<cfif len(no_change_order_list) and not listfind('2,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- silme veya iptal degilse CHANGE_RESERVE_STATUS 0 olan siparislere ait satırlar silinmiyor --->
								AND ORDER_ID NOT IN (#no_change_order_list#)
							</cfif> 
					</cfquery>
				<cfelseif arguments.is_order_process eq 2>
					<cfquery name="DEL_SHIP_ORDERS" datasource="#arguments.process_db#">
						DELETE 
							FROM #arguments.process_db_alias#ORDERS_INVOICE 
						WHERE 
							INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
							AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
							<cfif len(no_change_order_list) and not listfind('2,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- silme veya iptal degilse CHANGE_RESERVE_STATUS 0 olan siparislere ait satırlar silinmiyor --->
								AND ORDER_ID NOT IN (#no_change_order_list#)
							</cfif> 
					</cfquery>
				</cfif>
			</cfif>
			<cfloop list="#ship_related_order_list#" index="order_ind_">
				<cfset reserve_stock_list_ =''> <!--- yerini degistirmeyelim her sipariste liste resetlenmeli. --->
				<cfset ship_stock_list_ =''>
				<!--- ORDERS_SHIP - ORDER_INVOICE tablosuna kayıt yazılması için
				1-irsaliye veya faturayla iliskisi kesilmis siparisler listesinde olmamalı.
				2-iptal veya silme isleminden cagrılmamıs olmalı
				3-guncelleme isleminden cagrılmıssa degistirilmeyecek siparisler listesinde olmamalı, cunku guncellemede bu siparislerin ORDERS_SHIP - ORDER_INVOICE'deki kayıtları silmiyoruz --->		 --->
				<cfif not listfind(removed_order_list,order_ind_) and not ( arguments.reserve_action_iptal eq 1 or arguments.reserve_action_type eq 2 ) and not (arguments.reserve_action_type eq 1 and listfind(no_change_order_list,order_ind_) )>
					<cfif arguments.is_order_process eq 1>
						<cfquery name="ADD_ORDERS_SHIP" datasource="#arguments.process_db#"> <!--- 1. siparis-irsaliye iliskisini tutan ORDERS_SHIP tablosuna kayıt atılır --->
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
						<cfquery name="ADD_ORDERS_SHIP" datasource="#arguments.process_db#"> <!--- 1. siparis-irsaliye iliskisini tutan ORDERS_SHIP tablosuna kayıt atılır --->
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
				<cfquery name="GET_ORDER_AMOUNTS" datasource="#arguments.process_db#">
					SELECT 
						SUM(ORR.QUANTITY) AS ORDER_AMOUNT,
						ORR.STOCK_ID,
						ORR.RESERVE_TYPE,
						O.RESERVED
					FROM 
						#arguments.process_db_alias#ORDERS O,
						#arguments.process_db_alias#ORDER_ROW ORR
					WHERE 
						O.ORDER_ID=ORR.ORDER_ID
						AND O.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					GROUP BY
						ORR.STOCK_ID,
						ORR.RESERVE_TYPE,
						O.RESERVED
					ORDER BY
						ORR.STOCK_ID					
				</cfquery>
				<!---3.satır rezerveleri karsılastırmak icin siparisteki urunlerin  stok hareketi yapan irsaliyelere cekilmis miktarları bulunuyor --->
				<cfquery name="GET_RESERVE_AMOUNTS" datasource="#arguments.process_db#">
					SELECT
						<cfif arguments.is_purchase_sales>
							SUM(STOCK_OUT) AS RESERVE_AMOUNT,
						<cfelse>
							SUM(STOCK_IN) AS RESERVE_AMOUNT,
						</cfif>
						STOCK_ID
					FROM
						#arguments.process_db_alias#ORDER_ROW_RESERVED
					WHERE
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
						AND (SHIP_ID IS NOT NULL OR INVOICE_ID IS NOT NULL)
					GROUP BY
						STOCK_ID
				</cfquery>
				<cfif arguments.is_order_process eq 1><!--- irsaliyeyle iliskiliyse --->
					<cfquery name="get_order_ship_periods" datasource="#arguments.process_db#">
						SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					</cfquery>
					<cfif get_order_ship_periods.recordcount> <!--- siparisle ilgili irsaliye kaydı varsa --->
						<cfset orders_ship_period_list = valuelist(get_order_ship_periods.period_id)>
						<!--- 4. siparis sadece aktif donemdeki irsaliyelerle iliskilendirilmis --->
						<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session_base.period_id>
							<cfquery name="GET_ALL_SHIP_AMOUNT" datasource="#arguments.process_db#">
								SELECT
									SUM(SR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID
								FROM
									#dsn2_alias#.SHIP S,
									#dsn2_alias#.SHIP_ROW SR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2> <!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
										AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									SR.STOCK_ID
							</cfquery>
						<cfelse>
						<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
							<cfquery name="GET_PERIOD_DSNS" datasource="#arguments.process_db#">
								SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
							</cfquery>
							<cfquery name="GET_ALL_SHIP_AMOUNT" datasource="#arguments.process_db#">
								SELECT
									SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
									A1.STOCK_ID
								FROM
								(
									<cfloop query="get_period_dsns">
										SELECT
											SUM(SR.AMOUNT) AS SHIP_AMOUNT,
											SR.STOCK_ID
										FROM
											#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
											#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
										WHERE
											S.SHIP_ID=SR.SHIP_ID
											AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
											<cfif get_period_dsns.PERIOD_YEAR eq session_base.period_id and len(arguments.related_process_id) and reserve_action_type eq 2>
												AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
											</cfif>
										GROUP BY
											SR.STOCK_ID
										<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
									</cfloop> 
								) AS A1
								GROUP BY
									A1.STOCK_ID
							</cfquery>
						</cfif>
						<cfset reserve_stock_list_ = listsort(valuelist(get_reserve_amounts.stock_id),'numeric','ASC')>
						<cfset ship_stock_list_ = listsort(valuelist(get_all_ship_amount.stock_id),'numeric','ASC')>
					</cfif>
				<cfelseif arguments.is_order_process eq 2> <!--- faturayla iliskiliyse --->
					<cfquery name="GET_ORDER_SHIP_PERIODS" datasource="#arguments.process_db#">
						SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					</cfquery>
					<cfif get_order_ship_periods.recordcount>
						<cfset orders_ship_period_list = valuelist(get_order_ship_periods.period_id)>
						<!--- 4. siparis sadece aktif donemdeki irsaliyelerle iliskilendirilmis --->
						<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session_base.period_id>
							<cfquery name="GET_ALL_SHIP_AMOUNT" datasource="#arguments.process_db#">
								SELECT
									SUM(IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID
								FROM
									#dsn2_alias#.INVOICE I,
									#dsn2_alias#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND IR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2> <!--- silme isleminde silinecek fatura haricindeki faturaların satırlarına bakılıyor --->
										AND I.INVOICE_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									IR.STOCK_ID
							</cfquery>
						<cfelse>
							<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
							<cfquery name="GET_PERIOD_DSNS" datasource="#arguments.process_db#">
								SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
							</cfquery>
							<cfquery name="GET_ALL_SHIP_AMOUNT" datasource="#arguments.process_db#">
								SELECT
									SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
									A1.STOCK_ID
								FROM
								(
									<cfloop query="get_period_dsns">
										SELECT
											SUM(IR.AMOUNT) AS SHIP_AMOUNT,
											IR.STOCK_ID
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
											IR.STOCK_ID
										<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
									</cfloop> ) AS A1
									GROUP BY
										A1.STOCK_ID
							</cfquery>
						</cfif>
						<cfset reserve_stock_list_ = listsort(valuelist(get_reserve_amounts.stock_id),'numeric','ASC')>
						<cfset ship_stock_list_ = listsort(valuelist(get_all_ship_amount.stock_id),'numeric','ASC')>
					</cfif>
				</cfif>
				<cfset order_process_flag = false>
				<cfset paper_general_reserve_type = false> <!--- belge bazında rezerveyi gosterir --->
				<cfloop query="get_order_amounts"> 
					<!---6. siparis satırlarının reserve_type belirleniyor. DIKKAT: rezerve_type stok hareketi yapan irsaliyelerdeki miktarlara gore hesaplanır --->
					<cfif listlen(reserve_stock_list_) and listfind(reserve_stock_list_,stock_id) and get_order_amounts.reserve_type neq -3 and not listfind(no_change_order_list,order_ind_)>
						<cfif order_amount lte get_reserve_amounts.reserve_amount[listfind(reserve_stock_list_,stock_id)]>
							<cfset order_row_reserve_type_ = -4> <!--- Rezerve Kapatıldı --->
						<cfelseif order_amount gt get_reserve_amounts.reserve_amount[listfind(reserve_stock_list_,stock_id)]>
							<cfset order_row_reserve_type_ = -2> <!--- Kısmı Rezerve--->
						</cfif>
					<cfelse>
					<!--- 1-irsaliyeye cekilmis olsada siparis satırında rezerve degil secilmisse rezerve tipi değiştirilmez
					 2- CHANGE_RESERVE_STATUS 0 olan yani no_change_order_list listesindeki siparislerin reserve asamaları da degistirilmez. --->
						<cfset order_row_reserve_type_ = get_order_amounts.reserve_type> <!--- stok hareketi yapan irsaliyeye cekilmemis satır siparisteki rezerve tipini korur --->
					</cfif>
				
					<cfif listfind('-1,-2',order_row_reserve_type_) and listfind('0,1',arguments.reserve_action_type)><!---Ekleme ve Güncelleme İşlemlerinde tek bir satır bile rezerve veya kısmı rezerve ise belge bazında rezervasyon secilir--->
						<cfset paper_general_reserve_type = true>
					<cfelseif listfind('-1,-2,-4',order_row_reserve_type_) and (arguments.reserve_action_type eq 2 or reserve_action_iptal eq 1)>
					<!--- silme ve iptal islemlerinde kısmı rezerve ve kapatılan rezerve satırlar asagıda rezerve olarak update edileceginden belge bazında rezervede secilmelidir  --->
						<cfset paper_general_reserve_type = true>
					</cfif>
					<cfif listlen(ship_stock_list_) and listfind(ship_stock_list_,stock_id)>
					<!---7. siparis satırlarının asamaları (order_currency) belirleniyor. DIKKAT: order_currency irsaliyelestirilen toplam miktara gore bulunuyor --->
						<cfset order_process_flag = true>
						<cfif order_amount eq get_all_ship_amount.ship_amount[listfind(ship_stock_list_,stock_id)]>
							<cfset order_row_currency = -3> <!--- kapatıldı aşaması --->
						<cfelseif order_amount gt get_all_ship_amount.SHIP_AMOUNT[listfind(ship_stock_list_,stock_id)]>
							<cfset order_row_currency = -7> <!---eksik teslimat aşaması--->
						<cfelseif order_amount lt get_all_ship_amount.SHIP_AMOUNT[listfind(ship_stock_list_,stock_id)]>
							<cfset order_row_currency = -8> <!--- fazla teslimat aşaması--->
						</cfif>
					</cfif>
					<cfif listlen(ship_stock_list_) and listfind(ship_stock_list_,STOCK_ID)>
					<!---8. irsaliyelere cekilen toplam miktarına gore siparis asaması , stok hareketi yapan miktara baglı olarak ise rezerve turu update ediliyor.--->
						<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
							UPDATE 
								#arguments.process_db_alias#ORDER_ROW 
							SET 
								ORDER_ROW_CURRENCY = #order_row_currency#
								<cfif listfind(reserve_stock_list_,STOCK_ID)>
									,RESERVE_TYPE = #order_row_reserve_type_#
								</cfif>
							WHERE
								ORDER_ID = #order_ind_# AND
								STOCK_ID = #STOCK_ID#
						</cfquery>
					<cfelse> 
					<!--- 9.siparisin cekildigi irsaliye yoksa eksik teslimat, kapatıldı ve fazla teslimat aşamaları tekrar sevk haline getiriliyor
					kapatılmıs ve eksik rezerve satırlar rezerve olarak update ediliyor --->
						<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
							UPDATE 
								#arguments.process_db_alias#ORDER_ROW 
							SET 
								ORDER_ROW_CURRENCY = -6
							<cfif listfind('-2,-4',get_order_amounts.reserve_type)>
								,RESERVE_TYPE = -1
							</cfif> 
							WHERE 
								ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#"> AND
								STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
								ORDER_ROW_CURRENCY IN (-3,-7,-8)
						</cfquery>
					</cfif>
				</cfloop>
				<cfquery name="UPD_ORD" datasource="#arguments.process_db#">
					UPDATE 
						#arguments.process_db_alias#ORDERS 
					SET 
						IS_PROCESSED = <cfif order_process_flag>1<cfelse>0</cfif>,
						RESERVED = <cfif paper_general_reserve_type>1<cfelse>0</cfif>
					WHERE 
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
				</cfquery>			
			</cfloop>
		</cfif>
	<cfreturn true>
</cffunction></cfprocessingdirective><cfsetting enablecfoutputonly="no">
