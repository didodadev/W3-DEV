<!--- 
	TolgaS 20080904 ilişkili sayfaları getirir 
	upd : Uğur Hamurpet 14.02.2020 - display_type değerine göre tüm teklif ve siparişleri listeleme ve ilişkili teklifin bağlı olduğu ana teklifi getirme özellikleri eklendi
	action_id: belge idsi
	attributes.action_type: belge tipi (OPP_ID,OFFER_ID,ORDER_ID,P_ORDER_ID,SHIP_ID,INVOICE_ID,PR_ORDER_ID,FIS_ID,SHIP_RESULT_ID)
	attributes.display_type: Teklif ve siparişlerde tüm ilişkili kayıtların listelenmesi için 1 gönderilir
	not: siparişin faturaya çekildiği durumlarda order_ship e kayıt atılmadığından bir cok sorun oluyor.. ilgili sipariş faturaya çekildiğinde order_ship e kayıt atılır ise ozaman aşağıdaki gereksiz kodlar kaldırılmalı 
--->
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.display_type" default="0">
<cfparam name="attributes.view_type" default="paper">
<cfset totalRecordCount = 0 />
<style>
	.relation_process > div > div:last-child > i.fa-arrow-down{
		display:none;
	}
	.relation_process > div > div > div:nth-of-type(2){
		font-size:13px;
	}
	@media screen and (max-width: 768px) {
		.relation_process > div > div:last-child{
			padding:15px 0;
			text-align:center;
		}
		.relation_process > div > div > div:nth-of-type(2){
			margin-top:10px;
			font-size:18px;
		}
		.relation_process > div > div:last-child > i.fa-arrow-down{
			display:inline;
		}
		.relation_process > div > div:last-child > i.fa-arrow-right{
			display:none;
		}
	}
</style>

<cfif isdefined('attributes.action_type')>

	<cfif attributes.view_type eq 'paper'>

		<cfif attributes.display_type eq 1 and (action_type eq 'OFFER_ID' or action_type eq "ORDER_ID")>
			<cfset action_table = ( action_type eq 'OFFER_ID' ) ? 'OFFER' : 'ORDERS'>
			<cfquery name="RELATION_ACTIONS" datasource="#DSN3#">
				SELECT
					TO_TABLE,
					TO_ACTION_ID,
					FROM_TABLE,
					FROM_ACTION_ID
				FROM 
					RELATION_ROW
				WHERE
					FROM_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#action_table#"> AND
					FROM_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
					(TO_TABLE = 'OFFER' OR TO_TABLE = 'ORDERS')
				UNION
				SELECT
					FROM_TABLE,
					FROM_ACTION_ID,
					TO_TABLE,
					TO_ACTION_ID
				FROM 
					RELATION_ROW
				WHERE
					TO_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#action_table#"> AND
					TO_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
					(FROM_TABLE = 'OFFER' OR FROM_TABLE = 'ORDERS')
			</cfquery>
			<cfset action_id = listAppend( action_id, valueList( RELATION_ACTIONS.TO_ACTION_ID ) )>
		</cfif>
		<cfset paper_line_main = 0>
		<cfset paper_list_main='OPP_ID,INTERNALDEMAND,INTERNAL_ID,PURCHASEDEMAND,OFFER_ID,ORDER_ID,P_ORDER_ID,SHIP_ID,INVOICE_ID'>
		<cfset paper_list_p_order_id='PR_ORDER_ID,FIS_ID'>
		<cfset paper_list_ship_id='SHIP_RESULT_ID'>
		<cfif listfind(paper_list_main,attributes.action_type,',')>
			<cfset paper_line_main=listfind(paper_list_main,attributes.action_type,',')>
		<cfelseif listfind(paper_list_p_order_id,attributes.action_type,',')>
			<cfset paper_line_main=4>
			<cfset paper_line_p_order_id=listfind(paper_list_p_order_id,attributes.action_type,',')>
		<cfelseif listfind(paper_list_ship_id,attributes.action_type,',')>
			<cfset paper_line_main=6>
			<cfset paper_line_ship_id=listfind(paper_list_ship_id,attributes.action_type,',')>
		</cfif>
		<cfset main_action_id=action_id>
		<!---  ilk gelen terim sevkiyat üretim sonucu veya stok fişi ise bu bloklardan paper_list_main deki değer ve idsi bulunur ve ordan devam eder--->
		<cfif isdefined('paper_line_ship_id')>
			<cfif attributes.action_type eq 'SHIP_RESULT_ID'>
				<cfset paper_line_main=4>
				<!---<cfset paper_list_main='ORDER_ID,SHIP_ID,INVOICE_ID'>--->
				<cfquery name="LIST_RELATION_PAPERS_SHIP_RESULT_ID" datasource="#DSN2#">
					SELECT DISTINCT
						SHIP_RESULT_ROW.ORDER_ID,
						SHIP_RESULT_ROW.SHIP_ID,
						SHIP_RESULT.SHIP_RESULT_ID,
						SHIP_RESULT.SHIP_FIS_NO,
						SHIP_RESULT.MAIN_SHIP_FIS_NO,
						SHIP_RESULT.OUT_DATE,
						IS_TYPE
					FROM
						SHIP_RESULT_ROW,
						SHIP_RESULT
					WHERE
						SHIP_RESULT.SHIP_RESULT_ID = SHIP_RESULT_ROW.SHIP_RESULT_ID AND
						SHIP_RESULT.SHIP_RESULT_ID IN (#action_id#)
						<!--- AND ISNULL(SHIP_RESULT.IS_TYPE,0) <> 2  --->
				</cfquery>
				<cfif list_relation_papers_ship_result_id.recordcount>
					<cfif list_relation_papers_ship_result_id.is_type eq 2 and len(list_relation_papers_ship_result_id.order_id)>
						<cfset action_id=valuelist(list_relation_papers_ship_result_id.order_id,',')>
					<cfelse>
						<cfset action_id=valuelist(list_relation_papers_ship_result_id.ship_id,',')>
					</cfif>
					<!---<cfif len(list_relation_papers_ship_result_id.is_type)> 
						<cfset paper_line_main=3>
					</cfif>--->  <!--- Hataya sebep olan bu kısım herhangi bir kullanıma uygun değildi ve kaldırıldı. Tekrar eklenmesi gerekli görülürse GA ya danışılabilir.--->
					<cfif len(list_relation_papers_ship_result_id.order_id)>
						<cfset main_action_id=valuelist(list_relation_papers_ship_result_id.order_id,',')><!--- ?? --->
					</cfif>
				</cfif>
			</cfif>
		</cfif>

		<cfif isdefined('paper_line_p_order_id')>
			<cfif attributes.action_type eq 'PR_ORDER_ID'><!--- üretim sonucu gelmiş ise sonuç bilgileri ve stok fiş bilgileri alınıyor --->
				<cfquery name="LIST_RELATION_PAPERS_PR_ORDER_ID" datasource="#DSN3#">
					SELECT DISTINCT
						POR.PR_ORDER_ID PAPER_ID,
						POR.P_ORDER_ID,
						POR.PR_ORDER_ID,
						POR.RECORD_DATE,
						POR.PRODUCTION_ORDER_NO,
						POR.RESULT_NO,
						PORR.AMOUNT,
						PORR.UNIT_NAME
					FROM 
						PRODUCTION_ORDER_RESULTS_ROW PORR,
						PRODUCTION_ORDER_RESULTS POR
					WHERE 
						PORR.PR_ORDER_ID = POR.PR_ORDER_ID AND
						POR.PR_ORDER_ID IN (#action_id#) AND
						PORR.TYPE = 1
				</cfquery>
				<cfif list_relation_papers_pr_order_id.recordcount>
					<cfset pr_order_id_list=valuelist(list_relation_papers_pr_order_id.paper_id,',')>
					<cfquery name="LIST_RELATION_PAPERS_FIS_ID" datasource="#DSN2#">
						SELECT 
							FIS_ID PAPER_ID,
							FIS_ID,
							FIS_NUMBER,
							FIS_DATE
						FROM 
							STOCK_FIS 
						WHERE
							PROD_ORDER_RESULT_NUMBER IN (#pr_order_id_list#)
					</cfquery>
					<cfset action_id=valuelist(list_relation_papers_pr_order_id.p_order_id,',')><!--- diğer ilişkili belgeleri bulabilmek için üretim emri action idye atılyıor --->
				</cfif>
			<cfelseif attributes.action_type eq 'FIS_ID'><!--- stok fiş gelmiş ise sonuç bilgileri ve stok fiş bilgileri alınıyor --->
				<cfquery name="LIST_RELATION_PAPERS_FIS_ID" datasource="#DSN2#">
					SELECT DISTINCT
						PROD_ORDER_RESULT_NUMBER PAPER_ID,
						FIS_ID,
						FIS_NUMBER,
						FIS_DATE
					FROM 
						STOCK_FIS 
					WHERE
						FIS_ID IN (#action_id#) AND 
						PROD_ORDER_RESULT_NUMBER IS NOT NULL
				</cfquery>
				<cfif list_relation_papers_fis_id.recordcount>
					<cfset pr_order_id_list=valuelist(list_relation_papers_fis_id.paper_id,',')>
					<cfquery name="LIST_RELATION_PAPERS_PR_ORDER_ID" datasource="#DSN3#">
						SELECT DISTINCT
							POR.PR_ORDER_ID PAPER_ID,
							POR.P_ORDER_ID,
							POR.PR_ORDER_ID,
							POR.RECORD_DATE,
							POR.PRODUCTION_ORDER_NO,
							POR.RESULT_NO,
							PORR.AMOUNT,
							PORR.UNIT_NAME
						FROM 
							PRODUCTION_ORDER_RESULTS_ROW PORR,
							PRODUCTION_ORDER_RESULTS POR
						WHERE 
							PORR.PR_ORDER_ID = POR.PR_ORDER_ID AND
							PORR.PR_ORDER_ID IN (#pr_order_id_list#) AND
							PORR.TYPE = 1
					</cfquery>
					<cfset action_id=valuelist(list_relation_papers_pr_order_id.p_order_id,',')><!--- diğer ilişkili belgeleri bulabilmek için üretim emri action idye atılyıor --->
				</cfif>
			</cfif>
		</cfif>

		<cfif listfind('P_ORDER_ID,PR_ORDER_ID,FIS_ID',attributes.action_type)>
			<!--- üretim ile ilgili yada stok fişi gelir ise order id bulunuyor ve ordan çalıştırılıyor kod çünkü üretimden sonra irsaliyeoluğundan sorun yaşıyoruz --->
			<cfquery name="GET_ORDER_ID" datasource="#DSN3#">
				SELECT DISTINCT
					ORDER_ID
				FROM 
					PRODUCTION_ORDERS_ROW
				WHERE 
					PRODUCTION_ORDER_ID IN (#action_id#)
			</cfquery>
			<cfif get_order_id.recordcount>
				<cfset action_id=valuelist(get_order_id.order_id,',')>
				<cfset paper_line_main=4>
				<cfset main_action_id=action_id>
			</cfif>
			<cfif attributes.action_type is 'P_ORDER_ID' and not get_order_id.recordcount><!---Üretim emrinden geldiğinde ve ilişkili siparişi yoksa önünü kesmek için eklendi  --->
				<cfset action_id=0>
				<cfset paper_line_main=4>
				<cfset main_action_id=action_id> 
			</cfif>
		</cfif>
		<cfloop from="#paper_line_main+1#" to="#listlen(paper_list_main,',')#" index="paper_ind">
			<cfswitch expression ="#listgetat(paper_list_main,paper_ind)#">
				<cfcase value="OPP_ID">
					<cfquery name="LIST_RELATION_PAPERS_OPP_ID" datasource="#DSN3#">
						SELECT OPP_ID PAPER_ID,OPPORTUNITIES.OPP_ID,OPP_DATE,OPP_NO,INCOME,MONEY,COST,MONEY2 FROM OPPORTUNITIES WHERE OPP_ID IN (#action_id#)
					</cfquery>
					<cfset action_id=valuelist(list_relation_papers_opp_id.paper_id,',')>
					<cfif not list_relation_papers_opp_id.recordcount>
						<cfbreak>
					</cfif>
				</cfcase>
				<cfcase value="INTERNALDEMAND">
					<cfquery name="LIST_RELATION_PAPERS_INTERNALDEMAND" datasource="#DSN3#">
						SELECT DISTINCT
							I.INTERNAL_ID PAPER_ID,
							I.INTERNAL_ID,
							I.INTERNAL_NUMBER,
							I.RECORD_DATE,
							I.OTHER_MONEY,
							I.OTHER_MONEY_VALUE,
							I.NET_TOTAL 
						FROM 
							INTERNALDEMAND I
							LEFT JOIN INTERNALDEMAND_RELATION IR ON I.INTERNAL_ID = IR.INTERNALDEMAND_ID 
						WHERE
							I.INTERNAL_ID IN (#action_id#) AND I.DEMAND_TYPE = 0
					</cfquery>
				</cfcase>
				<cfcase value="PURCHASEDEMAND">
					<cfquery name="LIST_RELATION_PAPERS_PURCHASEDEMAND" datasource="#DSN3#">
						SELECT DISTINCT
							I.INTERNAL_ID PAPER_ID,
							I.INTERNAL_ID,
							I.INTERNAL_NUMBER,
							I.RECORD_DATE,
							I.OTHER_MONEY,
							I.OTHER_MONEY_VALUE,
							I.NET_TOTAL 
						FROM 
							INTERNALDEMAND I
							LEFT JOIN INTERNALDEMAND_RELATION IR ON I.INTERNAL_ID = IR.INTERNALDEMAND_ID 
						WHERE
							I.INTERNAL_ID IN (#action_id#) AND I.DEMAND_TYPE = 1
					</cfquery>
				</cfcase>
				<cfcase value="OFFER_ID">
					<cfquery name="LIST_RELATION_PAPERS_OFFER_ID" datasource="#DSN3#">
						SELECT ISNULL(OFFER_ID,0) PAPER_ID,OFFER.OFFER_ID,OFFER_DATE,OFFER_NUMBER,OFFER_HEAD,PRICE,OTHER_MONEY_VALUE,OTHER_MONEY,PURCHASE_SALES,FOR_OFFER_ID FROM OFFER WHERE OPP_ID IN (#action_id#)
					</cfquery>
					<cfif not list_relation_papers_offer_id.recordcount>
						<cfquery name="LIST_RELATION_PAPERS_OFFER_ID" datasource="#DSN3#">
							SELECT DISTINCT
								ISNULL(OFFER.OFFER_ID,0) PAPER_ID,
								OFFER.OFFER_ID,
								OFFER.OFFER_DATE,
								OFFER.OFFER_NUMBER,
								OFFER.OFFER_HEAD,
								OFFER.PRICE,
								OFFER.OTHER_MONEY_VALUE,
								OFFER.OTHER_MONEY,
								OFFER.PURCHASE_SALES,
								OFFER.FOR_OFFER_ID
							FROM 
								INTERNALDEMAND_RELATION IR
								JOIN OFFER ON OFFER.OFFER_ID = IR.TO_OFFER_ID 
							WHERE
								IR.INTERNALDEMAND_ID  IN (#action_id#)                    
						</cfquery>
					</cfif>
					<cfset action_id=valuelist(list_relation_papers_offer_id.paper_id,',')>
					<cfif not list_relation_papers_offer_id.recordcount>
						<cfbreak>
					</cfif>
				</cfcase>
				<cfcase value="ORDER_ID">
					<!--- Siparisden sevkiyat eklenen durumlar icin eklendi. Yeri degismemeli. Action_id degeri gerekli. BK 20130731  --->
					<cfif (isdefined("list_relation_papers_ship_result_id") and not list_relation_papers_ship_result_id.recordcount) or not isdefined("list_relation_papers_ship_result_id")>
						<cfquery name="LIST_RELATION_PAPERS_SHIP_RESULT_ID" datasource="#DSN2#">
							SELECT DISTINCT
								SHIP_RESULT_ROW.SHIP_ID,					
								SHIP_RESULT.SHIP_RESULT_ID,
								SHIP_RESULT.SHIP_FIS_NO,
								SHIP_RESULT.MAIN_SHIP_FIS_NO,
								SHIP_RESULT.OUT_DATE
							FROM
								SHIP_RESULT_ROW,
								SHIP_RESULT
							WHERE
								SHIP_RESULT.SHIP_RESULT_ID = SHIP_RESULT_ROW.SHIP_RESULT_ID AND
								SHIP_RESULT_ROW.SHIP_ID IN (#action_id#) AND 
								ISNULL(SHIP_RESULT.IS_TYPE,0) = 2
						</cfquery>
					</cfif>
					<cfquery name="LIST_RELATION_PAPERS_ORDER_ID" datasource="#DSN3#">
						SELECT ORDER_ID PAPER_ID,ORDERS.ORDER_ID,ORDER_DATE,ORDER_HEAD,ORDER_NUMBER,NETTOTAL,OTHER_MONEY_VALUE,OTHER_MONEY,IS_INSTALMENT,PURCHASE_SALES FROM ORDERS WHERE OFFER_ID IN (#action_id#)
					</cfquery>
					<cfif not LIST_RELATION_PAPERS_ORDER_ID.recordcount>
						<cfquery name="get_rel_offer" datasource="#dsn3#"><!--- ilişkili teklifler çekiliyor PY 0420---->
							select 
								DISTINCT TO_ACTION_ID
							from 
								RELATION_ROW
							where 
								FROM_TABLE = 'OFFER' AND TO_TABLE = 'OFFER' AND FROM_ACTION_ID IN (#action_id#)
						</cfquery>
						<cfif get_rel_offer.recordcount>
							<cfquery name="LIST_RELATION_PAPERS_ORDER_ID" datasource="#DSN3#">
								SELECT ORDER_ID PAPER_ID,ORDERS.ORDER_ID,ORDER_DATE,ORDER_HEAD,ORDER_NUMBER,NETTOTAL,OTHER_MONEY_VALUE,OTHER_MONEY,IS_INSTALMENT,PURCHASE_SALES FROM ORDERS WHERE OFFER_ID IN (#get_rel_offer.TO_ACTION_ID#)
							</cfquery>
						</cfif>
					</cfif>
					<cfset action_id=valuelist(list_relation_papers_order_id.paper_id,',')>
					<cfif not list_relation_papers_order_id.recordcount>
						<cfbreak>
					</cfif>
				</cfcase>
				<cfcase value="P_ORDER_ID">
					<cfquery name="LIST_RELATION_PAPERS_P_ORDER_ID" datasource="#DSN3#">
						SELECT DISTINCT
							PRODUCTION_ORDERS.P_ORDER_ID PAPER_ID,
							PRODUCTION_ORDERS.P_ORDER_ID,
							PRODUCTION_ORDERS.START_DATE,
							PRODUCTION_ORDERS.FINISH_DATE,
							PRODUCTION_ORDERS.DETAIL,
							PRODUCTION_ORDERS.QUANTITY,
							PRODUCTION_ORDERS.P_ORDER_NO,
							(SELECT S.PRODUCT_NAME FROM STOCKS S WHERE S.STOCK_ID = PRODUCTION_ORDERS.STOCK_ID) AS PRODUCT_NAME
						FROM 
							PRODUCTION_ORDERS_ROW,
							PRODUCTION_ORDERS 
						WHERE 
							PRODUCTION_ORDERS_ROW.ORDER_ID IN (#action_id#) AND 
							PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
					</cfquery>
					<!---ÜRETİM İÇİN BAŞKA BİR ACTİON İD İLE SONUÇ VE FİŞE BAKMALI ESKİSİ HALLA ORDER OLARAK KALMALIKİ İRSALİYE DOĞRU OLSUN--->
					<cfif list_relation_papers_p_order_id.recordcount and not isdefined('list_relation_papers_pr_order_id')>
						<cfset p_order_id_list=valuelist(list_relation_papers_p_order_id.paper_id,',')>
						<cfquery name="LIST_RELATION_PAPERS_PR_ORDER_ID" datasource="#DSN3#">
							SELECT DISTINCT
								POR.PR_ORDER_ID PAPER_ID,
								POR.P_ORDER_ID,
								POR.PR_ORDER_ID,
								POR.RECORD_DATE,
								POR.PRODUCTION_ORDER_NO,
								POR.RESULT_NO,
								PORR.AMOUNT,
								PORR.UNIT_NAME
							FROM 
								PRODUCTION_ORDER_RESULTS_ROW PORR,
								PRODUCTION_ORDER_RESULTS POR
							WHERE 
								PORR.PR_ORDER_ID = POR.PR_ORDER_ID AND
								POR.P_ORDER_ID IN (#p_order_id_list#) AND
								PORR.TYPE = 1
						</cfquery>
						<cfif list_relation_papers_pr_order_id.recordcount>
							<cfset pr_order_id_list=valuelist(list_relation_papers_pr_order_id.paper_id,',')>
							<cfquery name="LIST_RELATION_PAPERS_FIS_ID" datasource="#DSN2#">
								SELECT DISTINCT
									FIS_ID PAPER_ID,
									FIS_ID,
									FIS_NUMBER,
									FIS_DATE
								FROM 
									STOCK_FIS 
								WHERE
									PROD_ORDER_RESULT_NUMBER IN (#pr_order_id_list#)
							</cfquery>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="SHIP_ID">
					<!---SEVKİYAT KISMI DÜZENLENDİ py--->
					<cfif attributes.action_type eq 'SHIP_RESULT_ID'>
						<cfquery name="LIST_RELATION_PAPERS_SHIP_ID" datasource="#DSN2#">
							SELECT DISTINCT
								SHIP.SHIP_ID PAPER_ID,
								SHIP.SHIP_ID,
								SHIP.SHIP_NUMBER,
								SHIP.SHIP_DATE,
								SHIP.NETTOTAL,
								SHIP.OTHER_MONEY_VALUE,
								SHIP.OTHER_MONEY,
								SHIP.PURCHASE_SALES
							FROM 
								SHIP 
							WHERE 
								SHIP.SHIP_ID IN (#action_id#)                                                  
						</cfquery>
					<cfelse>
						<cfquery name="LIST_RELATION_PAPERS_SHIP_ID" datasource="#DSN2#">
							SELECT DISTINCT
								SHIP.SHIP_ID PAPER_ID,
								SHIP.SHIP_ID,
								SHIP.SHIP_NUMBER,
								SHIP.SHIP_DATE,
								SHIP.NETTOTAL,
								SHIP.OTHER_MONEY_VALUE,
								SHIP.OTHER_MONEY,
								SHIP.PURCHASE_SALES,
								ORDERS_SHIP.ORDER_ID
							FROM 
								#dsn3_alias#.ORDERS_SHIP ORDERS_SHIP,
								SHIP 
							WHERE 
								<cfif attributes.action_type eq 'SHIP_RESULT_ID'>
									<cfif list_relation_papers_ship_result_id.is_type eq 2>
										ORDERS_SHIP.ORDER_ID IN (#action_id#) AND                         
									<cfelse>
										ORDERS_SHIP.SHIP_ID IN (#action_id#) AND                                                 
									</cfif>
								<cfelse>
									ORDERS_SHIP.ORDER_ID IN (#action_id#) AND                                                 
								</cfif>
								ORDERS_SHIP.SHIP_ID = SHIP.SHIP_ID AND
								ORDERS_SHIP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
						</cfquery>
					</cfif>
					<cfif list_relation_papers_ship_id.recordcount>
						<cfset action_id=valuelist(list_relation_papers_ship_id.paper_id,',')><!--- irsaliye idleri action id ekleniyor sevkiyatlar bununacak --->
						<cfset ship_list_id =valuelist(list_relation_papers_ship_id.ship_id,',')>
						<cfif isdefined("list_relation_papers_ship_id.order_id")>
							<cfset order_action_id=valuelist(list_relation_papers_ship_id.order_id,',')>
						<cfelse>
							<cfset order_action_id= 0>
						</cfif>
						<cfquery name="LIST_RELATION_PAPERS_SHIP_RESULT_ID" datasource="#DSN2#">
							SELECT DISTINCT
								SHIP_RESULT_ROW.SHIP_ID,					
								SHIP_RESULT.SHIP_RESULT_ID,
								SHIP_RESULT.SHIP_FIS_NO,
								SHIP_RESULT.MAIN_SHIP_FIS_NO,
								SHIP_RESULT.OUT_DATE,
								IS_TYPE
							FROM
								SHIP_RESULT_ROW,
								SHIP_RESULT
							WHERE
								SHIP_RESULT.SHIP_RESULT_ID = SHIP_RESULT_ROW.SHIP_RESULT_ID AND
								SHIP_RESULT_ROW.SHIP_ID IN (#action_id#,#order_action_id#)
						</cfquery>
						<cfif attributes.action_type eq 'SHIP_RESULT_ID' and  list_relation_papers_ship_result_id.is_type eq 2>
							<cfset main_action_id = valuelist(list_relation_papers_ship_id.order_id,',')> 
						</cfif>
					</cfif>
					<cfif not list_relation_papers_ship_id.recordcount>
						<!--- siparişden irsaliye bulunamadı ise sipariş direk faturaya çekilmiş olabilir --->
						<cfquery name="LIST_RELATION_PAPERS_INVOICE_ID" datasource="#DSN2#">
							SELECT DISTINCT
								INVOICE.INVOICE_ID PAPER_ID,
								INVOICE.INVOICE_ID,
								INVOICE.INVOICE_DATE,
								INVOICE.INVOICE_NUMBER,
								INVOICE.NETTOTAL,
								INVOICE.OTHER_MONEY_VALUE,
								INVOICE.OTHER_MONEY,
								INVOICE.PURCHASE_SALES
							FROM 
								#dsn3_alias#.ORDERS_INVOICE ORDERS_INVOICE,
								INVOICE
							WHERE 
								INVOICE.INVOICE_ID = ORDERS_INVOICE.INVOICE_ID AND
								ORDERS_INVOICE.ORDER_ID IN (#action_id#) AND 
								ORDERS_INVOICE.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
						</cfquery>
						<cfset action_id=valuelist(list_relation_papers_invoice_id.paper_id,',')>
						<cfbreak>
					</cfif>
				</cfcase>
				<cfcase value="INVOICE_ID">
					<cfquery name="get_next_year" datasource="#dsn#">
						SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #session.ep.period_year + 1#
					</cfquery>				
					<cfquery name="list_relation_papers_invoice_id" datasource="#dsn2#">
						SELECT DISTINCT
							INVOICE.INVOICE_ID PAPER_ID,
							INVOICE.INVOICE_ID,
							INVOICE.INVOICE_DATE,
							INVOICE.INVOICE_NUMBER,
							INVOICE.NETTOTAL,
							INVOICE.OTHER_MONEY_VALUE,
							INVOICE.OTHER_MONEY,
							INVOICE.PURCHASE_SALES
						FROM 
							INVOICE_SHIPS,
							INVOICE 
						WHERE 
							INVOICE_SHIPS.SHIP_ID IN (#action_id#) AND
							INVOICE_SHIPS.SHIP_PERIOD_ID = #session.ep.period_id# AND
							INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID
						<cfif get_next_year.recordcount>
						UNION ALL
						SELECT 
							INVOICE.INVOICE_ID PAPER_ID,
							INVOICE.INVOICE_ID,
							INVOICE.INVOICE_DATE,
							INVOICE.INVOICE_NUMBER,
							INVOICE.NETTOTAL,
							INVOICE.OTHER_MONEY_VALUE,
							INVOICE.OTHER_MONEY,
							INVOICE.PURCHASE_SALES
						FROM 
							#DSN#_#get_next_year.period_year#_#get_next_year.our_company_id#.INVOICE_SHIPS,
							#DSN#_#get_next_year.period_year#_#get_next_year.our_company_id#.INVOICE 
						WHERE 
							INVOICE_SHIPS.SHIP_ID IN (#action_id#) AND
							INVOICE_SHIPS.SHIP_PERIOD_ID = #session.ep.period_id# AND
							INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID
						</cfif>
					</cfquery>
					<cfif list_relation_papers_invoice_id.recordcount>
						<cfset action_id=valuelist(list_relation_papers_invoice_id.paper_id,',')>
					</cfif>
					<cfif not list_relation_papers_invoice_id.recordcount>
						<cfbreak>					
					</cfif>
				</cfcase>
				<cfdefaultcase>
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
		<cfset action_id=main_action_id><!--- sayfaya gelen idden yolla cıcağı için deger tekrar atandı --->
		<cfloop from="#paper_line_main#" to="1" index="paper_ind" step="-1">			
			<cfswitch expression = "#listgetat(paper_list_main,paper_ind)#">
				<cfcase value="OPP_ID">
					<cfif Len(action_id)>
						<cfquery name="LIST_RELATION_PAPERS_OPP_ID" datasource="#DSN3#">
							SELECT OPP_ID PAPER_ID,OPP_ID,OPP_DATE,OPP_NO,INCOME,MONEY,COST,MONEY2 FROM OPPORTUNITIES WHERE OPP_ID IN (#action_id#)
						</cfquery>
						<cfset action_id=valuelist(list_relation_papers_opp_id.paper_id,',')>
						<cfif not list_relation_papers_opp_id.recordcount>
							<cfbreak>
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="INTERNALDEMAND">
					<cfif isdefined("offer_list") and len(offer_list)>
						<cfquery name="LIST_RELATION_PAPERS_INTERNALDEMAND" datasource="#DSN3#">
							SELECT DISTINCT
								I.INTERNAL_ID PAPER_ID,
								I.INTERNAL_ID,
								I.INTERNAL_NUMBER,
								I.RECORD_DATE,
								I.OTHER_MONEY,
								I.OTHER_MONEY_VALUE,
								I.NET_TOTAL 
							FROM 
								INTERNALDEMAND I
								JOIN INTERNALDEMAND_RELATION IR ON I.INTERNAL_ID = IR.INTERNALDEMAND_ID 
							WHERE
								IR.TO_OFFER_ID IN (#offer_list#) AND I.DEMAND_TYPE = 0
						</cfquery>
					<cfelse>
						<cfset action_id = main_action_id>
						<cfquery name="LIST_RELATION_PAPERS_INTERNALDEMAND" datasource="#DSN3#">
							SELECT DISTINCT
								I.INTERNAL_ID PAPER_ID,
								I.INTERNAL_ID,
								I.INTERNAL_NUMBER,
								I.RECORD_DATE,
								I.OTHER_MONEY,
								I.OTHER_MONEY_VALUE,
								I.NET_TOTAL 
							FROM 
								INTERNALDEMAND I
								LEFT JOIN INTERNALDEMAND_RELATION IR ON I.INTERNAL_ID = IR.INTERNALDEMAND_ID
								LEFT JOIN ORDERS_SHIP OS ON OS.ORDER_ID = IR.TO_ORDER_ID
								LEFT JOIN ORDERS_INVOICE OI ON OI.ORDER_ID = IR.TO_ORDER_ID
							WHERE
								I.DEMAND_TYPE=0
								<cfif attributes.action_type eq 'INTERNALDEMAND'>
									AND I.INTERNAL_ID IN (#action_id#)
								<cfelseif attributes.action_type eq 'ORDER_ID'>
									AND IR.TO_ORDER_ID IN (#action_id#)
								<cfelseif attributes.action_type eq 'SHIP_ID'>                            	
									AND (OS.SHIP_ID IN (#action_id#) OR IR.TO_SHIP_ID IN (#action_id#) )
								<cfelseif attributes.action_type eq 'OFFER_ID'>
									AND IR.TO_OFFER_ID IN (#action_id#)
								<cfelseif attributes.action_type eq 'INVOICE_ID'>
									AND OI.INVOICE_ID IN (#action_id#)
								<cfelse>
									AND 1<>1 
								</cfif>
						</cfquery>
					</cfif>      
				</cfcase>
				<cfcase value="PURCHASEDEMAND">
					<cfif isdefined("offer_list") and len(offer_list)>
						<cfquery name="LIST_RELATION_PAPERS_PURCHASEDEMAND" datasource="#DSN3#">
							SELECT DISTINCT
								I.INTERNAL_ID PAPER_ID,
								I.INTERNAL_ID,
								I.INTERNAL_NUMBER,
								I.RECORD_DATE,
								I.OTHER_MONEY,
								I.OTHER_MONEY_VALUE,
								I.NET_TOTAL 
							FROM 
								INTERNALDEMAND I
								JOIN INTERNALDEMAND_RELATION IR ON I.INTERNAL_ID = IR.INTERNALDEMAND_ID 
							WHERE
								IR.TO_OFFER_ID IN (#offer_list#) AND I.DEMAND_TYPE = 1
						</cfquery>
					<cfelse>
						<cfset action_id = main_action_id>
						<cfquery name="LIST_RELATION_PAPERS_PURCHASEDEMAND" datasource="#DSN3#">
							SELECT DISTINCT
								I.INTERNAL_ID PAPER_ID,
								I.INTERNAL_ID,
								I.INTERNAL_NUMBER,
								I.RECORD_DATE,
								I.OTHER_MONEY,
								I.OTHER_MONEY_VALUE,
								I.NET_TOTAL 
							FROM 
								INTERNALDEMAND I
								LEFT JOIN INTERNALDEMAND_RELATION IR ON I.INTERNAL_ID = IR.INTERNALDEMAND_ID
								LEFT JOIN ORDERS_SHIP OS ON OS.ORDER_ID = IR.TO_ORDER_ID
								LEFT JOIN ORDERS_INVOICE OI ON OI.ORDER_ID = IR.TO_ORDER_ID
							WHERE
								I.DEMAND_TYPE = 1
								<cfif attributes.action_type eq 'INTERNALDEMAND'>
									AND I.INTERNAL_ID IN (#action_id#)
								<cfelseif attributes.action_type eq 'ORDER_ID'>
									AND IR.TO_ORDER_ID IN (#action_id#) 
								<cfelseif attributes.action_type eq 'SHIP_ID'>                            	
									AND (OS.SHIP_ID IN (#action_id#) OR IR.TO_SHIP_ID IN (#action_id#) )
								<cfelseif attributes.action_type eq 'OFFER_ID'>
									AND IR.TO_OFFER_ID IN (#action_id#)
								<cfelseif attributes.action_type eq 'INVOICE_ID'>
									AND OI.INVOICE_ID IN (#action_id#)
								<cfelse>
									AND 1<>1
								</cfif>
						</cfquery>
					</cfif>
				</cfcase>
				<cfcase value="OFFER_ID">
					<cfif Len(action_id)>
						<cfquery name="LIST_RELATION_PAPERS_OFFER_ID" datasource="#DSN3#">
							SELECT ISNULL(OPP_ID,0) PAPER_ID,OFFER_ID,OFFER_DATE,OFFER_NUMBER,OFFER_HEAD,PRICE,OTHER_MONEY_VALUE,OTHER_MONEY,PURCHASE_SALES,FOR_OFFER_ID FROM OFFER WHERE OFFER_ID IN (#action_id#)
						</cfquery>
						<cfset action_id = valuelist(list_relation_papers_offer_id.paper_id,',')>
						<cfset offer_list = valuelist(list_relation_papers_offer_id.offer_id,',')>
						<cfset offer_list = listappend(offer_list,valuelist(list_relation_papers_offer_id.for_offer_id,','))>
						<cfset offer_list = listdeleteduplicates(offer_list)>
						<!---talep direk siparişe çekilmiş olabilir
						<cfif not list_relation_papers_offer_id.recordcount>
							<cfbreak>
						</cfif>--->
					</cfif>
				</cfcase>
				<cfcase value="ORDER_ID">
					<cfif Len(action_id)>
						<cfquery name="LIST_RELATION_PAPERS_ORDER_ID" datasource="#DSN3#">
							SELECT DISTINCT
								ISNULL(OFFER_ID,0) PAPER_ID,
								OFFER_ID,ORDERS.ORDER_ID,
								ORDER_DATE,
								ORDER_HEAD,
								ORDER_NUMBER,
								NETTOTAL,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								IS_INSTALMENT,
								PURCHASE_SALES 
							FROM 
								ORDERS 
							WHERE 
								ORDER_ID IN (#action_id#)
						</cfquery>
						<cfset action_id=valuelist(list_relation_papers_order_id.paper_id,',')>
						<cfset order_list_id=valuelist(list_relation_papers_order_id.order_id,',')>
						<cfif not list_relation_papers_order_id.recordcount>
							<cfbreak>
						<cfelse>
						<!--- liste geriye doğru giderken shipden üretime geldiğinde üretimi bulamıyor order_id ihityaç var cünkü o neden ile burda alıyor --->
							<cfquery name="LIST_RELATION_PAPERS_P_ORDER_ID" datasource="#DSN3#">
								SELECT DISTINCT
									PRODUCTION_ORDERS_ROW.ORDER_ID PAPER_ID,
									PRODUCTION_ORDERS.P_ORDER_ID,
									PRODUCTION_ORDERS.START_DATE,
									PRODUCTION_ORDERS.FINISH_DATE,
									PRODUCTION_ORDERS.DETAIL,
									PRODUCTION_ORDERS.QUANTITY,
									PRODUCTION_ORDERS.P_ORDER_NO,
									(SELECT S.PRODUCT_NAME FROM STOCKS S WHERE S.STOCK_ID = PRODUCTION_ORDERS.STOCK_ID) AS PRODUCT_NAME
								FROM 
									PRODUCTION_ORDERS_ROW,
									PRODUCTION_ORDERS 
								WHERE 
									PRODUCTION_ORDERS_ROW.ORDER_ID IN (#order_list_id#) AND 
									PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID
							</cfquery>
							<!---ÜRETİM İÇİN BAŞKA BİR ACTİON ID İLE SONUÇ VE FİŞE BAKMALI ESKİSİ HALLA ORDER OLARAK KALMALIKİ İRSALİYE DOĞRU OLSUN--->
							<cfif list_relation_papers_p_order_id.recordcount and not isdefined('list_relation_papers_pr_order_id')>
								<cfset p_order_id_list=valuelist(list_relation_papers_p_order_id.p_order_id,',')>
								<cfquery name="LIST_RELATION_PAPERS_PR_ORDER_ID" datasource="#DSN3#">
									SELECT DISTINCT
										POR.PR_ORDER_ID PAPER_ID,
										POR.P_ORDER_ID,
										POR.PR_ORDER_ID,
										POR.RECORD_DATE,
										POR.PRODUCTION_ORDER_NO,
										POR.RESULT_NO,
										PORR.AMOUNT,
										PORR.UNIT_NAME
									FROM 
										PRODUCTION_ORDER_RESULTS_ROW PORR,
										PRODUCTION_ORDER_RESULTS POR
									WHERE 
										PORR.PR_ORDER_ID=POR.PR_ORDER_ID AND
										POR.P_ORDER_ID IN (#p_order_id_list#) AND
										PORR.TYPE = 1
								</cfquery>
								<cfif list_relation_papers_pr_order_id.recordcount>
									<cfset pr_order_id_list=valuelist(list_relation_papers_pr_order_id.pr_order_id,',')>
									<cfquery name="LIST_RELATION_PAPERS_FIS_ID" datasource="#DSN2#">
										SELECT 
											FIS_ID PAPER_ID,
											FIS_ID,
											FIS_NUMBER,
											FIS_DATE
										FROM 
											STOCK_FIS 
										WHERE
											STOCK_FIS.PROD_ORDER_RESULT_NUMBER IN (#pr_order_id_list#)
									</cfquery>
								</cfif>
							</cfif>
						</cfif> 
					</cfif>
				</cfcase>
				<cfcase value="SHIP_ID">
					<cfif not isdefined('order_ind')><!--- sipariş direk faturaye çekilmiş olduu durumda değişken tanımlı oluyor ve irsaliyeye bakmaması gerek --->
						<cfif (isDefined("list_relation_papers_ship_result_id") and Len(list_relation_papers_ship_result_id.ship_id) and list_relation_papers_ship_result_id.is_type neq 2) or not isDefined("list_relation_papers_ship_result_id.ship_id")>
							<cfquery name="LIST_RELATION_PAPERS_SHIP_ID" datasource="#DSN2#">
								SELECT DISTINCT
									ORDERS_SHIP.ORDER_ID PAPER_ID ,
									SHIP.SHIP_ID,
									SHIP.SHIP_NUMBER,
									SHIP.SHIP_DATE,
									SHIP.NETTOTAL,
									SHIP.OTHER_MONEY_VALUE,
									SHIP.OTHER_MONEY,
									SHIP.PURCHASE_SALES
								FROM 
									#dsn3_alias#.ORDERS_SHIP ORDERS_SHIP,
									SHIP 
								WHERE 
									ORDERS_SHIP.SHIP_ID IN (#action_id#) AND 
									ORDERS_SHIP.SHIP_ID = SHIP.SHIP_ID AND
									ORDERS_SHIP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
							</cfquery>
							<!--- Siparisi yoksa irsaliyenim baglantisi burda kalmasin diye sadece irsaliye cekiliyor ve devam ediliyor--->
							<cfif not list_relation_papers_ship_id.recordcount>
								<cfquery name="LIST_RELATION_PAPERS_SHIP_ID" datasource="#DSN2#">
									SELECT 
										0 PAPER_ID ,
										SHIP_ID,
										SHIP_NUMBER,
										SHIP_DATE,
										NETTOTAL,
										OTHER_MONEY_VALUE,
										OTHER_MONEY,
										PURCHASE_SALES
									FROM 
										SHIP 
									WHERE 
										SHIP_ID IN (#action_id#)
								</cfquery>
							</cfif>
							
							<cfif list_relation_papers_ship_id.recordcount>

								<!--- sevkiyat için --->
								<cfset ship_action_id=valuelist(list_relation_papers_ship_id.ship_id,',')>
								<cfset paper_action_id=valuelist(list_relation_papers_ship_id.paper_id,',')>
								<cfquery name="LIST_RELATION_PAPERS_SHIP_RESULT_ID" datasource="#DSN2#">
									SELECT 
										CASE WHEN ISNULL(SHIP_RESULT.IS_TYPE,0) = 2 THEN SHIP_RESULT_ROW.SHIP_ID ELSE '' END AS ORDER_ID,
										CASE WHEN ISNULL(SHIP_RESULT.IS_TYPE,0) <> 2 THEN SHIP_RESULT_ROW.SHIP_ID ELSE '' END AS SHIP_ID,
										ISNULL(SHIP_RESULT.IS_TYPE,0) IS_TYPE,
										SHIP_RESULT.SHIP_RESULT_ID,
										SHIP_RESULT.SHIP_FIS_NO,
										SHIP_RESULT.MAIN_SHIP_FIS_NO,
										SHIP_RESULT.OUT_DATE
									FROM
										SHIP_RESULT_ROW,
										SHIP_RESULT
									WHERE
										SHIP_RESULT.SHIP_RESULT_ID = SHIP_RESULT_ROW.SHIP_RESULT_ID AND
										SHIP_RESULT_ROW.SHIP_ID IN (#ship_action_id#,#paper_action_id#)
								</cfquery>
								<cfset ship_list_id=action_id>
								<!---<cfif isDefined("attributes.action_type") and attributes.action_type is 'ORDER_ID'>--->
								<cfset action_id=valuelist(list_relation_papers_ship_id.paper_id,',')>
								<!---<cfelse>
									<cfset action_id=valuelist(list_relation_papers_ship_id.ship_id,',')>
								</cfif>--->
								<!--- <cfset action_id=valuelist(list_relation_papers_ship_id.paper_id,',')>--->

								<cfquery name="LIST_RELATION_PAPERS_ORDER_ID" datasource="#DSN3#">
									SELECT ISNULL(OFFER_ID,0) PAPER_ID,OFFER_ID,ORDERS.ORDER_ID,ORDER_DATE,ORDER_HEAD,ORDER_NUMBER,NETTOTAL,OTHER_MONEY_VALUE,OTHER_MONEY,IS_INSTALMENT,PURCHASE_SALES FROM ORDERS WHERE ORDER_ID IN (#action_id#)
								</cfquery>
								<cfset order_list_id=valuelist(list_relation_papers_order_id.order_id,',')>
								<cfset action_id_=valuelist(list_relation_papers_order_id.paper_id,',')>
								<cfif not list_relation_papers_order_id.recordcount>
									<cfbreak>
								<cfelse>
									<!--- liste geriye doğru giderken shipden üretime geldiğinde üretimi bulamıyor order_id ihityaç var cünkü o neden ile burda alıyor --->
									<cfquery name="LIST_RELATION_PAPERS_P_ORDER_ID" datasource="#DSN3#">
										SELECT 
											PRODUCTION_ORDERS_ROW.ORDER_ID PAPER_ID,
											PRODUCTION_ORDERS.P_ORDER_ID,
											PRODUCTION_ORDERS.START_DATE,
											PRODUCTION_ORDERS.FINISH_DATE,
											PRODUCTION_ORDERS.DETAIL,
											PRODUCTION_ORDERS.QUANTITY,
											PRODUCTION_ORDERS.P_ORDER_NO,
											(SELECT S.PRODUCT_NAME FROM STOCKS S WHERE S.STOCK_ID = PRODUCTION_ORDERS.STOCK_ID) AS PRODUCT_NAME
										FROM 
											PRODUCTION_ORDERS_ROW,
											PRODUCTION_ORDERS 
										WHERE 
											PRODUCTION_ORDERS_ROW.ORDER_ID IN (#order_list_id#) AND 
											PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID
									</cfquery>
									<!---ÜRETİM İÇİN BAŞKA BİR ACTİON ID İLE SONUÇ VE FİŞE BAKMALI ESKİSİ HALLA ORDER OLARAK KALMALIKİ İRSALİYE DOĞRU OLSUN--->
									<cfif list_relation_papers_p_order_id.recordcount and not isdefined('list_relation_papers_pr_order_id')>
										<cfset p_order_id_list=valuelist(list_relation_papers_p_order_id.p_order_id,',')>
										<cfquery name="LIST_RELATION_PAPERS_PR_ORDER_ID" datasource="#DSN3#">
											SELECT
												POR.PR_ORDER_ID PAPER_ID,
												POR.P_ORDER_ID,
												POR.PR_ORDER_ID,
												POR.RECORD_DATE,
												POR.PRODUCTION_ORDER_NO,
												POR.RESULT_NO,
												PORR.AMOUNT,
												PORR.UNIT_NAME
											FROM 
												PRODUCTION_ORDER_RESULTS_ROW PORR,
												PRODUCTION_ORDER_RESULTS POR
											WHERE 
												PORR.PR_ORDER_ID = POR.PR_ORDER_ID AND
												POR.P_ORDER_ID IN (#p_order_id_list#) AND
												PORR.TYPE = 1
										</cfquery>
										<cfif list_relation_papers_pr_order_id.recordcount>
											<cfset pr_order_id_list=valuelist(list_relation_papers_pr_order_id.pr_order_id,',')>
											<cfquery name="LIST_RELATION_PAPERS_FIS_ID" datasource="#DSN2#">
												SELECT 
													FIS_ID PAPER_ID,
													FIS_ID,
													FIS_NUMBER,
													FIS_DATE
												FROM 
													STOCK_FIS 
												WHERE
													STOCK_FIS.PROD_ORDER_RESULT_NUMBER IN (#pr_order_id_list#)
											</cfquery>
										</cfif>
									</cfif>
									<cfquery name="LIST_RELATION_PAPERS_OFFER_ID" datasource="#DSN3#">
										SELECT ISNULL(OPP_ID,0) PAPER_ID,OFFER_ID,OFFER_DATE,OFFER_NUMBER,OFFER_HEAD,PRICE,OTHER_MONEY_VALUE,OTHER_MONEY,PURCHASE_SALES,FOR_OFFER_ID FROM OFFER WHERE OFFER_ID IN (#action_id_#)
									</cfquery>
									<!---<cfif not list_relation_papers_offer_id.recordcount>
										<cfbreak>
									</cfif>--->
								</cfif> 
							</cfif>
						<cfelseif isDefined("list_relation_papers_ship_result_id") and Len(list_relation_papers_ship_result_id.ship_id)>
							<cfset action_id=valuelist(list_relation_papers_ship_result_id.ship_id,',')>
							<cfset ship_list_id=valuelist(list_relation_papers_ship_result_id.ship_id,',')>
							<cfset list_relation_papers_ship_id.recordcount = 0>
						<cfelse>
							<cfset list_relation_papers_ship_id.recordcount = 0>
						</cfif>
						<cfif not list_relation_papers_ship_id.recordcount and not isDefined("list_relation_papers_ship_result_id")>
							<cfbreak>
						</cfif>
					</cfif>				
				</cfcase>
				<cfcase value="INVOICE_ID">
					<cfquery name="LIST_RELATION_PAPERS_INVOICE_ID" datasource="#DSN2#">
						SELECT DISTINCT
							INVOICE_SHIPS.SHIP_ID PAPER_ID,
							INVOICE.INVOICE_ID,
							INVOICE.INVOICE_DATE,
							INVOICE.INVOICE_NUMBER,
							INVOICE.NETTOTAL,
							INVOICE.OTHER_MONEY_VALUE,
							INVOICE.OTHER_MONEY,
							INVOICE.PURCHASE_SALES
						FROM 
							INVOICE_SHIPS,
							SHIP,
							INVOICE 
						WHERE 
							INVOICE_SHIPS.INVOICE_ID IN (#action_id#) AND 
							INVOICE_SHIPS.SHIP_ID = SHIP.SHIP_ID AND
							INVOICE_SHIPS.INVOICE_ID = INVOICE.INVOICE_ID
					</cfquery>
					<cfif not list_relation_papers_invoice_id.recordcount>
						<!--- fatura irsaliye bulunamadı ise sipariş direk faturaya çekilmiş olabilir --->
						<cfquery name="LIST_RELATION_PAPERS_INVOICE_ID" datasource="#DSN2#">
							SELECT DISTINCT
								ORDERS_INVOICE.ORDER_ID PAPER_ID,
								INVOICE.INVOICE_ID,
								INVOICE.INVOICE_DATE,
								INVOICE.INVOICE_NUMBER,
								INVOICE.NETTOTAL,
								INVOICE.OTHER_MONEY_VALUE,
								INVOICE.OTHER_MONEY,
								INVOICE.PURCHASE_SALES
							FROM 
								#dsn3_alias#.ORDERS_INVOICE ORDERS_INVOICE,
								INVOICE
							WHERE 
								INVOICE.INVOICE_ID=ORDERS_INVOICE.INVOICE_ID AND
								ORDERS_INVOICE.INVOICE_ID IN (#action_id#) AND 
								ORDERS_INVOICE.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
						</cfquery>
						<cfset action_id=valuelist(list_relation_papers_invoice_id.paper_id,',')>
						<cfset order_ind=1>
						<cfif not list_relation_papers_invoice_id.recordcount>
							<cfbreak>
						</cfif>
					<cfelse>
						<cfset action_id=valuelist(list_relation_papers_invoice_id.paper_id,',')> 
					</cfif>
				</cfcase>
				<cfdefaultcase>
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
		<table class="ajax_list">
			<thead>
				<tr>
				<th></th>
				<th></th>
				<th></th>
				<th></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined('list_relation_papers_opp_id') and list_relation_papers_opp_id.recordcount>
				<cfset totalRecordCount += list_relation_papers_opp_id.recordcount />
				<tr>
					<td style="width:120px;"><img src="../../images/balon.gif" border="0" align="absmiddle"> <b><cf_get_lang_main no='200.Fırsat'></b></td>
					<td>
						<cfset opp_ids = "">
						<cfoutput query="list_relation_papers_opp_id">
							<cfset opp_ids = listAppend( opp_ids, opp_id) />
							:
							<a href="#request.self#?fuseaction=sales.list_opportunity&event=upd&opp_id=#opp_id#" target="_blank" class="tableyazi">#opp_no#</a> -
							#DateFormat(opp_date,dateformat_style)# -
							#TLFormat(income)#&nbsp;#money# - 
							#TLFormat(cost)#&nbsp;#money2#
						</cfoutput>
					</td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'OPP_ID','<cfoutput>#opp_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<!---- İç talep ve satınalma talebi aynı tablodan geliyor ---->
				<cfif isdefined('list_relation_papers_internaldemand') and list_relation_papers_internaldemand.recordcount>
				<cfset totalRecordCount += list_relation_papers_internaldemand.recordcount />
				<tr>
					<td style="width:120px;"><img src="../../images/out.gif" border="0" align="absmiddle"> <b><cf_get_lang dictionary_id='58798.İç Talep'></b></td>
					<td>
						<cfset internal_ids = "">
						<cfoutput query="list_relation_papers_internaldemand">
							<cfset internal_ids = listAppend( internal_ids, internal_id) />
							:  
							<a href="#request.self#?fuseaction=purchase.list_internaldemand&event=upd&id=#internal_id#" target="_blank" class="tableyazi">#internal_number#</a> -                      
							#DateFormat(record_date,dateformat_style)# -
							#TLFormat(net_total)#&nbsp;#session.ep.money# -
							#TLFormat(other_money_value)#&nbsp;#other_money#
						</cfoutput>	
					</td>
					<td><a href="javascript://"><i class="icon-bell"  title="Workflow" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=3&action=purchase.list_internaldemand&action_name=id&action_id=<cfoutput>#listfirst(internal_ids)#</cfoutput>','Workflow')"></a></td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'INTERNAL_ID','<cfoutput>#internal_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<cfif isdefined('list_relation_papers_purchasedemand') and list_relation_papers_purchasedemand.recordcount>
				<cfset totalRecordCount += list_relation_papers_purchasedemand.recordcount />
				<tr>
					<td style="width:120px;"><img src="../../images/out.gif" border="0" align="absmiddle"> <b><cf_get_lang dictionary_id='49752.Satınalma Talebi'></b></td>
					<td>
						<cfset mainInternalId = "" />
						<cfset internal_ids = "">
						<cfoutput query="list_relation_papers_purchasedemand">
							<cfif not len( mainInternalId ) > <cfset mainInternalId = internal_id /> </cfif>
							<cfset internal_ids = listAppend( internal_ids, internal_id) />
							:  
							<a href="#request.self#?fuseaction=purchase.list_purchasedemand&event=upd&id=#internal_id#" target="_blank" class="tableyazi">#internal_number#</a> -                      
							#DateFormat(record_date,dateformat_style)# -
							#TLFormat(net_total)#&nbsp;#session.ep.money# -
							#TLFormat(other_money_value)#&nbsp;#other_money#
							<cfif list_relation_papers_purchasedemand.recordCount gt currentrow></br></cfif>
						</cfoutput>	
					</td>
					<td><a href="javascript://"><i class="icon-bell"  title="Workflow" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=3&action=purchase.list_purchasedemand&action_name=id&action_id=<cfoutput>#mainInternalId#</cfoutput>','Workflow')"></a></td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'INTERNAL_ID','<cfoutput>#internal_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<!---- İç talep ve satınalma talebi aynı tablodan geliyor ---->
				<cfif isdefined('list_relation_papers_offer_id') and list_relation_papers_offer_id.recordcount>
				<cfset totalRecordCount += list_relation_papers_offer_id.recordcount />
				<tr>
					<td style="width:120px;"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> <b><cf_get_lang dictionary_id='57545.Teklif'></b></td>
					<td>
						<cfset offer_ids = "">
						<table>
							<cfset mainOfferId = "" />
							<cfoutput query="list_relation_papers_offer_id">
								<cfif not len( mainOfferId ) > <cfset mainOfferId = offer_id /> </cfif>
								<cfset offer_ids = listAppend( offer_ids, offer_id) />
								<tr>
									<td>
									<cfif purchase_sales eq 1>
										<a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#offer_id#" target="_blank" class="tableyazi">#offer_number#</a> -
									<cfelse>
										<a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#offer_id#" target="_blank" class="tableyazi">#offer_number#</a> -
									</cfif>
									#DateFormat(offer_date,dateformat_style)# -
									#TLFormat(price)#&nbsp;#session.ep.money# -
									#TLFormat(other_money_value)#&nbsp;#other_money#

									<cfif attributes.display_type eq 0 and len(FOR_OFFER_ID)><!--- get parent offer by for_offer_id --->
										<cfquery name="RELATION_PAPERS_PARENT_OFFER" datasource="#DSN3#">
											SELECT ISNULL(OFFER_ID,0) PAPER_ID,OFFER.OFFER_ID,OFFER_DATE,OFFER_NUMBER,OFFER_HEAD,PRICE,OTHER_MONEY_VALUE,OTHER_MONEY,PURCHASE_SALES,FOR_OFFER_ID FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FOR_OFFER_ID#">
										</cfquery>
										<cfset offer_ids = listAppend( offer_ids, RELATION_PAPERS_PARENT_OFFER.OFFER_ID) />
										<cfif purchase_sales eq 1>
											( <a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#RELATION_PAPERS_PARENT_OFFER.OFFER_ID#" target="_blank" class="tableyazi">#RELATION_PAPERS_PARENT_OFFER.OFFER_NUMBER#</a> )
										<cfelse>
											( <a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#RELATION_PAPERS_PARENT_OFFER.OFFER_ID#" target="_blank" class="tableyazi">#RELATION_PAPERS_PARENT_OFFER.OFFER_NUMBER#</a> )
										</cfif>
									</cfif>
									</td>
								</tr>
							</cfoutput>
						</table>
					</td>
					<td><a href="javascript://"><i class="icon-bell"  title="Workflow" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=3&action=purchase.list_offer&action_name=offer_id&action_id=<cfoutput>#mainOfferId#</cfoutput>','Workflow')"></a></td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'OFFER_ID','<cfoutput>#offer_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<cfif isdefined('list_relation_papers_order_id') and list_relation_papers_order_id.recordcount>
				<cfset totalRecordCount += list_relation_papers_order_id.recordcount />
				<tr>
					<td style="width:120px;"><i class="fa fa-handshake-o" aria-hidden="true" border="0" align="absmiddle"></i> <b><cf_get_lang dictionary_id='57611.Sipariş'></b></td>
					<td>
						<cfset mainOrderId = "" />
						<cfset order_ids = "">
						<table>
							<cfoutput query="list_relation_papers_order_id">
								<tr>
									<td>
									<cfif not len( mainOrderId ) > <cfset mainOrderId = order_id /> </cfif>
									<cfset order_ids = listAppend( order_ids, order_id) />
									<cfif list_relation_papers_order_id.is_instalment eq 1>
										<a href="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#order_id#" target="_blank" class="tableyazi">#order_number#</a> -
									<cfelseif list_relation_papers_order_id.purchase_sales eq 1>
										<a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" target="_blank" class="tableyazi">#order_number#</a> -
									<cfelse>
										<a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" target="_blank" class="tableyazi">#order_number#</a> -
									</cfif>
										#DateFormat(order_date,dateformat_style)# -
										#TLFormat(nettotal)#&nbsp;#session.ep.money# -
										#TLFormat(other_money_value)#&nbsp;#other_money#
									</td>
								</tr>
							</cfoutput>
						</table>
					</td>
					<td><a href="javascript://"><i class="icon-bell"  title="Workflow" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=3&action=purchase.list_order&action_name=order_id&action_id=<cfoutput>#mainOrderId#</cfoutput>','Workflow')"></a></td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'ORDER_ID','<cfoutput>#order_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<cfif isdefined('list_relation_papers_p_order_id') and list_relation_papers_p_order_id.recordcount>
				<cfset totalRecordCount += list_relation_papers_p_order_id.recordcount />
				<tr>
					<td style="width:120px;"><img src="../../images/factory.gif" border="0" align="absmiddle"> <b><cfoutput>#getLang('cost',14)#</cfoutput></b></td>
					<td>
						<cfset p_order_ids = "">
						:
						<cfoutput query="list_relation_papers_p_order_id">
							<cfset p_order_ids = listAppend( p_order_ids, p_order_id) />
							<a href="#request.self#?fuseaction=prod.in_productions&event=upd&upd=#p_order_id#" target="_blank">#p_order_no# - #product_name#</a> -
							#DateFormat(start_date,dateformat_style)# -- #DateFormat(finish_date,dateformat_style)# -
							<cf_get_lang dictionary_id='57635.Miktar'> : &nbsp;#TLFormat(quantity)#
						</cfoutput>
					</td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'P_ORDER_ID','<cfoutput>#p_order_ids#</cfoutput>')"></a></th></td>
				</tr>
				</cfif>
				<cfif isdefined('list_relation_papers_pr_order_id') and list_relation_papers_pr_order_id.recordcount>
				<cfset totalRecordCount += list_relation_papers_pr_order_id.recordcount />
				<tr>
					<td style="width:120px;"><img src="../../images/action_plus.gif" border="0" align="absmiddle"> <b><cf_get_lang dictionary_id='29651.Üretim Sonucu'></b></td>
					<td>
						<cfset pr_order_ids = "">
						:
						<cfoutput query="list_relation_papers_pr_order_id">
							<cfset pr_order_ids = listAppend( pr_order_ids, pr_order_id) />
							<a href="#request.self#?fuseaction=prod.list_results&event=upd&p_order_id=#p_order_id#&pr_order_id=#pr_order_id#" target="_blank" class="tableyazi">#result_no#</a> -
							#DateFormat(record_date,dateformat_style)# -
							<cf_get_lang dictionary_id='57635.Miktar'> : &nbsp;#TLFormat(amount)# #unit_name#
						</cfoutput>
					</td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'PR_ORDER_ID','<cfoutput>#pr_order_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<cfif isdefined('list_relation_papers_fis_id') and list_relation_papers_fis_id.recordcount>
				<cfset totalRecordCount += list_relation_papers_fis_id.recordcount />
				<tr>
					<td style="width:120px;"><img src="../../images/forklift.gif" border="0" align="absmiddle"> <b><cf_get_lang dictionary_id='33102.Stok Fişi'></b></td>
					<td>
						<cfset fis_ids = "">
						:
						<cfif isdefined('list_relation_papers_fis_id') and list_relation_papers_fis_id.recordcount>
							<cfoutput query="list_relation_papers_fis_id">
								<cfset fis_ids = listAppend( fis_ids, fis_id) />
								<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#fis_id#" target="_blank">#fis_number#</a> -
								#DateFormat(fis_date,dateformat_style)#
							</cfoutput>
						</cfif>	
					</td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'FIS_ID','<cfoutput>#fis_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<cfif isdefined('ship_list_id')>
				<cfset totalRecordCount += listLen(ship_list_id) />
				<tr>
					<td style="width:120px;"><img src="../../images/package.gif" border="0" align="absmiddle"> <b><cf_get_lang dictionary_id='57773.İrsaliye'></b></td>
					<td>
						<cfset ship_ids = "">
						<cfset mainShipId = "" />
						:
						<cfquery name="list_relation_papers_ship_id" datasource="#dsn2#">
							SELECT DISTINCT
								SHIP_ID PAPER_ID,
								SHIP_ID,
								SHIP_NUMBER,
								SHIP_DATE,
								NETTOTAL,
								OTHER_MONEY_VALUE,
								OTHER_MONEY,
								PURCHASE_SALES
							FROM 
								SHIP 
							WHERE 
								SHIP_ID IN (#ship_list_id#)   
						</cfquery>
						<cfoutput query="list_relation_papers_ship_id">
							<cfif not len( mainShipId ) > <cfset mainShipId = ship_id /> </cfif>
							<cfset ship_ids = listAppend( ship_ids, ship_id) />
							<cfquery name="Get_Ship_Period" datasource="#dsn3#">
								SELECT 
									YEAR(SHIP_DATE) AS SHIP_DATE
								FROM 
									#dsn2_alias#.SHIP S 
								WHERE 
									S.SHIP_ID = #ship_id#<!---Get_Ship_Period.Ship_Date den değer dönmediği durumlarda irsaliyenin aynı dönemde olmasına rağmen alerte takılıyordu--->
							</cfquery>
							<cfif purchase_sales eq 0>
								<cfif session.ep.period_year eq Get_Ship_Period.Ship_Date>
									<a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#ship_id#" target="_blank" class="tableyazi">#ship_number#</a> -
								<cfelse>
									<a href="javascript://" onclick="alert('Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Kayıt Bulunamadı,Lütfen İlgili Belgeye Ait Dönemi Kontrol Ediniz !');" target="_blank">#ship_number#</a> -                                  		
								</cfif>
							<cfelse>
								<cfif session.ep.period_year eq Get_Ship_Period.Ship_Date>
									<a href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#ship_id#" target="_blank" class="tableyazi">#ship_number#</a> -
								<cfelse>
									<a href="javascript://" onclick="alert('Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Kayıt Bulunamadı,Lütfen İlgili Belgeye Ait Dönemi Kontrol Ediniz !');" target="_blank">#ship_number#</a> -                                		
								</cfif>
							</cfif>
							#DateFormat(ship_date,dateformat_style)# -
							#TLFormat(nettotal)#&nbsp;#session.ep.money# -
							#TLFormat(other_money_value)#&nbsp;#other_money#
						</cfoutput>
					</td>
					<td><a href="javascript://"><i class="icon-bell"  title="Workflow" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=3&action=stock.form_add_purchase&action_name=ship_id&action_id=<cfoutput>#mainShipId#</cfoutput>','Workflow')"></a></td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'SHIP_ID','<cfoutput>#ship_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>	
				<cfif isdefined('list_relation_papers_ship_result_id') and  list_relation_papers_ship_result_id.recordcount>
				<cfset totalRecordCount += list_relation_papers_ship_result_id.recordcount />
				<tr>
					<td style="width:120px;"><img src="../../images/ship.gif" border="0" align="absmiddle"></td>
					<td><b><cf_get_lang no='713.Sevkiyat'></b>
						<cfset ship_result_ids = "">
						:
						<cfoutput query="list_relation_papers_ship_result_id">
							<cfset ship_result_ids = listAppend( ship_result_ids, ship_result_id) />
							<cfif not len(main_ship_fis_no)>
								<a href="#request.self#?fuseaction=stock.list_packetship&event=upd&ship_result_id=#ship_result_id#" target="_blank" class="tableyazi">#ship_fis_no#</a> -
							<cfelse>
								<a style="cursor:pointer;" onclick="goto_page('#main_ship_fis_no#')" class="tableyazi">#ship_fis_no#</a> -
							</cfif>
								#DateFormat(out_date,dateformat_style)#
						</cfoutput>	
					</td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'SHIP_RESULT_ID','<cfoutput>#ship_result_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<cfif isdefined('list_relation_papers_invoice_id') and list_relation_papers_invoice_id.recordcount>
				<cfset totalRecordCount += list_relation_papers_invoice_id.recordcount />
				<tr>
					<td style="width:120px;"><img src="../../images/control.gif" border="0" align="absmiddle"> <b><cf_get_lang dictionary_id='57441.Fatura'></b></td>
					<td>
						<cfset mainInvoiceId = "" />
						<cfset invoice_ids = "">
						:
						<cfoutput query="list_relation_papers_invoice_id">
							<cfif INVOICE_ID[currentrow] neq INVOICE_ID[currentrow-1]>
								<cfif not len( mainInvoiceId ) > <cfset mainInvoiceId = invoice_id /> </cfif>
								<cfset invoice_ids = listAppend( invoice_ids, invoice_id) />
								<cfif purchase_sales eq 1>
									<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#invoice_id#" target="_blank" class="tableyazi">#invoice_number#</a> -
								<cfelse>
									<a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#invoice_id#" target="_blank" class="tableyazi">#invoice_number#</a> -
								</cfif>
								#DateFormat(invoice_date,dateformat_style)# -
								#TLFormat(nettotal)#&nbsp;#session.ep.money# -
								#TLFormat(other_money_value)#&nbsp;#other_money#
							</cfif>
						</cfoutput>	
					</td>
					<td><a href="javascript://"><i class="icon-bell"  title="Workflow" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=3&action=invoice.form_add_bill_purchase&action_name=iid&action_id=<cfoutput>#mainInvoiceId#</cfoutput>','Workflow')"></a></td>
					<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'INVOICE_ID','<cfoutput>#invoice_ids#</cfoutput>')"></a></td>
				</tr>
				</cfif>
				<cfif totalRecordCount == 0>
					<tr><td colspan = "4"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
				</cfif>
			</tbody>
		</table>
		<!--- Toplu sevkiyat guncelleme ekranini acmak adina yapidi BK 20081114 --->
		<form name="submit_multi_packetship" method="post" action="<cfoutput>#request.self#?fuseaction=stock.form_upd_multi_packetship</cfoutput>">
			<input type="hidden" name="main_ship_fis_no" id="main_ship_fis_no" value="">
		</form>
	<cfelseif attributes.view_type eq 'cari'>

		<cfset relationCostSpendList = "CLOSED_ID" />
		<cfif listFindNoCase(relationCostSpendList, attributes.action_type)>
			
			<cfquery name="list_cari_closed" datasource="#DSN2#">
				SELECT
					CLOSED_ID
					,COMPANY_ID
					,CONSUMER_ID
					,DEBT_AMOUNT_VALUE
					,CLAIM_AMOUNT_VALUE
					,DIFFERENCE_AMOUNT_VALUE
					,PAYMENT_DEBT_AMOUNT_VALUE
					,PAYMENT_CLAIM_AMOUNT_VALUE
					,PAYMENT_DIFF_AMOUNT_VALUE
					,P_ORDER_DEBT_AMOUNT_VALUE
					,P_ORDER_CLAIM_AMOUNT_VALUE
					,P_ORDER_DIFF_AMOUNT_VALUE
					,OTHER_MONEY
					,IS_DEMAND
					,IS_ORDER
					,IS_CLOSED
					,PAPER_ACTION_DATE
					,ORDER_ID
					,ACC_TYPE_ID
					,'demand' COST_TYPE 
				FROM
					CARI_CLOSED
				WHERE
					CLOSED_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value="#attributes.action_id#">
					AND IS_DEMAND = 1
				UNION ALL
				SELECT
					CLOSED_ID
					,COMPANY_ID
					,CONSUMER_ID
					,DEBT_AMOUNT_VALUE
					,CLAIM_AMOUNT_VALUE
					,DIFFERENCE_AMOUNT_VALUE
					,PAYMENT_DEBT_AMOUNT_VALUE
					,PAYMENT_CLAIM_AMOUNT_VALUE
					,PAYMENT_DIFF_AMOUNT_VALUE
					,P_ORDER_DEBT_AMOUNT_VALUE
					,P_ORDER_CLAIM_AMOUNT_VALUE
					,P_ORDER_DIFF_AMOUNT_VALUE
					,OTHER_MONEY
					,IS_DEMAND
					,IS_ORDER
					,IS_CLOSED
					,PAPER_ACTION_DATE
					,ORDER_ID
					,ACC_TYPE_ID
					,'order' COST_TYPE
				FROM
					CARI_CLOSED
				WHERE
					CLOSED_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value="#attributes.action_id#">
					AND IS_ORDER = 1
			</cfquery>

			<table class="ajax_list">
				<thead>
					<tr>
						<th></th>
						<th></th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif list_cari_closed.recordcount>
						<cfoutput query="list_cari_closed">
							<tr>
								<cfif COST_TYPE eq 'demand'>
									<td style="width:120px;"><img src="../../images/balon.gif" border="0" align="absmiddle"> <b>Ödeme Talebi</b></td>
									<td>
										<a href="#request.self#?fuseaction=finance.list_payment_actions_demand&event=upd&closed_id=#CLOSED_ID#&act_type=2&company_id=#COMPANY_ID#" target="_blank" class="tableyazi">Ödeme Talebi Detayı</a> -
										#DateFormat(PAPER_ACTION_DATE,dateformat_style)# -
										#TLFormat(PAYMENT_DIFF_AMOUNT_VALUE)# #OTHER_MONEY#
									</td>
									<td><a href="javascript://"><i class="icon-bell"  title="Workflow" onclick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=finance.list_payment_actions_demand&action_name=closed_id&action_id=#CLOSED_ID#','Workflow')"></a></td>
									<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'CLOSED_ID','#CLOSED_ID#')"></a></td>
								<cfelseif COST_TYPE eq 'order'>
									<td style="width:120px;"><img src="../../images/enabled.gif" border="0" align="absmiddle"> <b>Ödeme Emri</b></td>
									<td>
										<a href="#request.self#?fuseaction=finance.list_payment_actions_order&event=upd&closed_id=#CLOSED_ID#&act_type=3&company_id=#COMPANY_ID#" target="_blank" class="tableyazi">Ödeme Emri Detayı</a> -
										#DateFormat(PAPER_ACTION_DATE,dateformat_style)# -
										#TLFormat(P_ORDER_DIFF_AMOUNT_VALUE)# #OTHER_MONEY#
									</td>
									<td><a href="javascript://"><i class="icon-bell"  title="Workflow" onclick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=finance.list_payment_actions_order&action_name=closed_id&action_id=#CLOSED_ID#','Workflow')"></a></td>
									<td><a href="javascript://"><i class="fa fa-file"  title="<cf_get_lang dictionary_id='34134.İlişkili Belgeler'>" onclick="showDigitalAsset(this,'CLOSED_ID','#CLOSED_ID#')"></a></td>
								</cfif>
							</tr>
						</cfoutput>
					<cfelse>
						<tr><td colspan = "4"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
					</cfif>
				</tbody>
			</table>

		</cfif>

	</cfif>
</cfif>
<script type="text/javascript">
	$("li").css("list-style", "none");
	function goto_page(main_ship_fis_no)
	{
		document.getElementById('main_ship_fis_no').value = main_ship_fis_no;
		document.submit_multi_packetship.target='new_window';
		document.submit_multi_packetship.submit();
	}

	function showDigitalAsset(element, action_section, action_id) {
		if( $( element ).closest( "table tbody" ).has("tr#"+action_section+"").length == 0 ){
			$( element ).closest("tr").after("<tr id='"+action_section+"'><td colspan='4' id='td_"+action_section+"'></td></tr>");
			AjaxPageLoad('V16/objects/display/get_asset_by_action_section.cfm?action_id='+action_id+'&action_section='+action_section+'', 'td_' + action_section + '', 1);
		}else $( "tr#"+action_section+"" ).remove();
	}
</script>