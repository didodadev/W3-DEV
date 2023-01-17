
<cfif isDefined("session.pda")>
	<!--- Pda Kullanimi Icin Eklendi, Sayfa Pda Uretimden De Kullaniliyor FBS 20111215 --->
	<cfset session_userid = session.pda.userid>
	<cfset session_money = session.pda.money>
	<cfset session_money2 = session.pda.money2>
	<cfset session_our_company_info_spect_type = session.pda.our_company_info.spect_type>
	<cfset session_period_year = session.pda.period_year>
	<cfset session_period_id = session.pda.period_id>
	<cfset session_our_company_info_is_cost = 1>
<cfelse>
	<cfset session_userid = session.ep.userid>
	<cfset session_money = session.ep.money>
	<cfset session_money2 = session.ep.money2>
	<cfset session_our_company_info_spect_type = session.ep.our_company_info.spect_type>
	<cfset session_period_year = session.ep.period_year>
	<cfset session_period_id = session.ep.period_id>
	<cfset session_our_company_info_is_cost = session.ep.our_company_info.is_cost>
</cfif>
<cfinclude template="/V16/workdata/get_main_spect_id.cfm">
<cfif (isdefined("attributes.is_delstock") and Len(attributes.is_delstock)) and not len(attributes.finish_date) or year(attributes.finish_date) neq session_period_year>
	<script type="text/javascript">
		alert("<cf_get_lang no ='634.Üretim Sonuç Bitiş Tarihi Döneminiz ile Aynı Değil Stok Fişlerini Silemezsiniz'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN3#"><!--- del icinde de kullandigimizdan yukari aldim, muhasebe fisinin ustundeydi fbs 20130201  --->
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
	 FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>

<cfif not form.del_pr_order_id eq 0>
	<cfinclude template="del_prod_order_result.cfm">
    <cfquery name="upd_prod_orders" datasource="#dsn3#">
        UPDATE PRODUCTION_ORDERS SET IS_STAGE = 0,IS_GROUP_LOT = 0 WHERE PARTY_ID = #form.party_id#
    </cfquery>
	<cfif session_our_company_info_is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
		<cfscript>cost_action(action_type:4,action_id:attributes.pr_order_id,query_type:3);</cfscript>
		<script type="text/javascript">
			<cfif isDefined("session.ep")><!--- Pda de Gelmemesi Icin --->
				window.location.href="<cfoutput>#request.self#?fuseaction=textile.order&event=upd&party_id=#attributes.party_id#</cfoutput>";
			<cfelse>
				window.location.href="<cfoutput>#request.self#?fuseaction=pda.list_production_order</cfoutput>";
			</cfif>
		</script>
		<cfabort>
	<cfelse>
		<cfif isDefined("session.ep")><!--- Pda de Gelmemesi Icin --->
			<cflocation url="#request.self#?fuseaction=textile.order&event=upd&party_id=#attributes.p_order_id#" addtoken="no">
		<cfelse>
			<cflocation url="#request.self#?fuseaction=pda.list_production_order" addtoken="no">
		</cfif>
	</cfif>
<cfelse>
	<cfscript>
		//saat bazında uretim suresi hesaplaniyor rota ve istasyon maliyetleri icin
		hour_time=0;
		start_minute=(attributes.start_h*60)+attributes.start_m;
		finish_minute=(attributes.finish_h*60)+attributes.finish_m;
		hour_time=(finish_minute-start_minute)/60;
	</cfscript>
	<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
	<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
	<cfscript>
		account_action_date=attributes.finish_date; /*muhasebe isleminde kullanılıyor*/
		attributes.start_date = createdatetime(year(attributes.start_date),month(attributes.start_date),day(attributes.start_date),attributes.start_h,attributes.start_m,0);
		attributes.finish_date = createdatetime(year(attributes.finish_date),month(attributes.finish_date),day(attributes.finish_date),attributes.finish_h,attributes.finish_m,0);
	</cfscript>	
	<cflock name="#CreateUUID()#" timeout="60">
	 <cftransaction>
	  	<!---rota ve istasyon maliyet hesapalamalari--->
	  	<cfset station_route_cost=0>
		<cfif len(attributes.station_id) and len(attributes.station_name)>
			<cfquery name="GET_WORKSTATION_DETAIL" datasource="#DSN3#">
				SELECT AVG_COST FROM WORKSTATIONS WHERE STATION_ID = #attributes.station_id#
			</cfquery>
			<cfif len(GET_WORKSTATION_DETAIL.AVG_COST) and len(hour_time)>
				<cfset station_route_cost=GET_WORKSTATION_DETAIL.AVG_COST*hour_time>
			</cfif>
		</cfif>
		<cfquery name="ADD_PRODUCTION_ORDER" datasource="#DSN3#">
			UPDATE 
				PRODUCTION_ORDER_RESULTS 
			SET
				PARTY_ID = #attributes.party_id#,
				PROCESS_ID = #attributes.process_cat#,
				START_DATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
				FINISH_DATE = <cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
				EXIT_DEP_ID = <cfif len(attributes.exit_department) and len(attributes.exit_department_id)>'#attributes.exit_department_id#'<cfelse>NULL</cfif>,
				EXIT_LOC_ID = <cfif len(attributes.exit_department) and len(attributes.exit_location_id)>'#attributes.exit_location_id#'<cfelse>NULL</cfif>,				
				STATION_ID = <cfif len(attributes.station_id)>#attributes.station_id#<cfelse>NULL</cfif>,
				PRODUCTION_ORDER_NO = <cfif len(attributes.production_order_no)>'#attributes.production_order_no#'<cfelse>NULL</cfif>,
				RESULT_NO = <cfif len(attributes.production_result_no)>'#attributes.production_result_no#'<cfelse>NULL</cfif>,
				ENTER_DEP_ID = <cfif len(attributes.enter_department) and len(attributes.enter_department_id)>'#attributes.enter_department_id#'<cfelse>NULL</cfif>,
				ENTER_LOC_ID = <cfif len(attributes.enter_department) and len(attributes.enter_location_id)>'#attributes.enter_location_id#'<cfelse>NULL</cfif>,
				ORDER_NO = <cfif len(attributes.order_no)>'#attributes.order_no#'<cfelse>NULL</cfif>,
				REFERENCE_NO = <cfif len(attributes.reference_no)>'#attributes.reference_no#'<cfelse>NULL</cfif>,
				POSITION_ID = <cfif len(attributes.expense_employee_id)>#attributes.expense_employee_id#<cfelse>NULL</cfif>,
				UPDATE_EMP = #session_userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#',
				LOT_NO = <cfif len(attributes.lot_no)>'#attributes.lot_no#'<cfelse>NULL</cfif>,
				PRODUCTION_DEP_ID = <cfif len(attributes.production_department) and len(attributes.production_department_id)>'#attributes.production_department_id#'<cfelse>NULL</cfif>,
				PRODUCTION_LOC_ID = <cfif len(attributes.production_department) and len(attributes.production_location_id)>'#attributes.production_location_id#'<cfelse>NULL</cfif>,
				PROD_ORD_RESULT_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_delstock") and Len(attributes.is_delstock)>IS_STOCK_FIS=0,</cfif><!--- fisleri siliyorsa 0 atılıyor fisi olmadıgını anlamak icin --->
				STATION_ROUTE_COST=#station_route_cost#
			WHERE
				PR_ORDER_ID = #attributes.pr_order_id#
		</cfquery>
        <!---<cfquery name="UPD_PRODUCTION_ORDERS" datasource="#dsn3#">
        	UPDATE PRODUCTION_ORDERS SET REFERENCE_NO = <cfif len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif> WHERE P_ORDER_ID = #attributes.p_order_id#
        </cfquery>--->
		<cfquery name="get_stock_fis_kontrol" datasource="#dsn3#">
			SELECT ISNULL(IS_STOCK_FIS,0) IS_STOCK_FIS FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #attributes.pr_order_id#
		</cfquery>
        <cfif attributes.lot_no neq attributes.old_lot_no><!--- Eğer Lot no değişmiş ise üretim emrindeki lot numarasınıda değiştiriyoruz! --->
        	<cfquery name="upd_pro_order_lot_number" datasource="#dsn3#">
	        	UPDATE PRODUCTION_ORDERS SET  LOT_NO = <cfif len(attributes.lot_no)>'#attributes.lot_no#'<cfelse>NULL</cfif>  WHERE P_ORDER_ID = #attributes.p_order_id#
            </cfquery>
		</cfif>
		<cfif isdefined("attributes.is_delstock") and Len(attributes.is_delstock)>
			<cfquery name="UPD_RESULT" datasource="#DSN3#">
				UPDATE
					PRODUCTION_ORDER_RESULTS_ROW
				SET
					IS_STOCK_FIS=0
				WHERE
					PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = #attributes.pr_order_id#
			</cfquery>
		</cfif>
		<cfquery name="DEL_ROWS" datasource="#DSN3#">
			DELETE FROM
				PRODUCTION_ORDER_RESULTS_ROW
			WHERE
				PR_ORDER_ID = #attributes.pr_order_id#
		</cfquery>
		<cfquery name="GET_FIS" datasource="#DSN3#">
			SELECT
				FIS_NUMBER,
				FIS_TYPE,
				FIS_ID,
				FIS_DATE
			FROM
				#dsn2_alias#.STOCK_FIS
			WHERE
				PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
		</cfquery>
		<cfif isdefined("attributes.is_delstock") and Len(attributes.is_delstock)>
                <cfquery name="upd_prod_orders" datasource="#dsn3#">
                    UPDATE PRODUCTION_ORDERS SET IS_STAGE = 1 WHERE PARTY_ID = #attributes.party_id#<!--- oluşmuş olan stok fişlerini siliyoruz yani durumu 2 den 1e yani başladı konumuna getiriyoruz. --->
                </cfquery>
			<cfloop query="GET_FIS">
				<cfquery name="DEL_ROW" datasource="#DSN3#">
					DELETE FROM
						#dsn2_alias#.STOCK_FIS_ROW 
					WHERE
						FIS_ID = #get_fis.fis_id#
				</cfquery>
				<cfquery name="DEL_ROW_STOCK" datasource="#DSN3#">
					DELETE FROM
						#dsn2_alias#.STOCKS_ROW
					WHERE
						UPD_ID = #get_fis.fis_id#
						AND PROCESS_TYPE=#get_fis.fis_type#
				</cfquery>
			</cfloop>
				<cfquery name="DEL_FIS" datasource="#DSN3#">
					DELETE FROM
						#dsn2_alias#.STOCK_FIS 
					WHERE
						PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
				</cfquery>
				<!---Depolar arası sevk--->
				<cfquery name="GET_SHIP" datasource="#DSN3#">
					SELECT
						SHIP_ID,
						SHIP_TYPE
					FROM
						#dsn2_alias#.SHIP
					WHERE 
						PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
				</cfquery>
				<cfloop query="get_ship">
					<cfquery name="DEL_SHIP_ROW" datasource="#DSN3#">
						DELETE FROM
							#dsn2_alias#.SHIP_ROW
						WHERE
							SHIP_ID = #get_ship.ship_id#
					</cfquery>
					<cfquery name="DEL_STOCK_ROW" datasource="#DSN3#">
						DELETE FROM
							#dsn2_alias#.STOCKS_ROW
						WHERE
							UPD_ID = #get_ship.ship_id#
							AND PROCESS_TYPE=#get_ship.ship_type#
					</cfquery>
				</cfloop>
				<cfquery name="DEL_SHIP" datasource="#DSN3#">
					DELETE FROM
						#dsn2_alias#.SHIP
					WHERE
						PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
				</cfquery>
				<!--- su ana kadar emire girilen sonuçlardan stok fisi kesilenler toplam emirdeki miktarı karsılıyorsa rezerveyi kaldırıyoruz degilse rezerve kalıyor--->
				<cfquery name="GET_P_O_R" datasource="#DSN3#">
					SELECT 
						SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT),
						PRODUCTION_ORDERS.QUANTITY,
						PRODUCTION_ORDER_RESULTS.P_ORDER_ID
					FROM
						PRODUCTION_ORDERS,
						PRODUCTION_ORDER_RESULTS,
						PRODUCTION_ORDER_RESULTS_ROW
					WHERE
						PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
						PRODUCTION_ORDER_RESULTS.PR_ORDER_ID=PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
						PRODUCTION_ORDER_RESULTS.PARTY_ID=#attributes.party_id# AND
						PRODUCTION_ORDERS.STOCK_ID=PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
						PRODUCTION_ORDER_RESULTS_ROW.TYPE=<cfif attributes.is_demontaj eq 0>1<cfelse>2</cfif> AND
						PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS=1
					GROUP BY
						PRODUCTION_ORDERS.QUANTITY,
						PRODUCTION_ORDER_RESULTS.P_ORDER_ID
					HAVING 
						SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT)>=PRODUCTION_ORDERS.QUANTITY
				</cfquery>
				<cfif not GET_P_O_R.RECORDCOUNT>
					<cfquery name="UPD_PROD_ORDER" datasource="#dsn3#">
						UPDATE 
							PRODUCTION_ORDERS
						SET
							IS_STOCK_RESERVED = 1
						WHERE
							PARTY_ID =  #attributes.party_id#
					</cfquery>
				</cfif>
			</cfif><!--- <cfif isdefined("attributes.is_delstock")> --->
			<cfscript>
				value_price = 0;
				value_price_extra = 0;
				value_price2 = 0;
				value_price_extra2 = 0;
			</cfscript>
			
			<!--- Sonuç kısmındaki ürün 1 tane ise vede XML ayarlarından "Sarf değişikliklerinden spec değişssin" seçeneği seçilmiş ise satırların değişmesi duruma göre spect kontrolü yapmak üzere specer fonksiyonuna gönderilmek üzere değişkenler tanımlanıyor --->
			<cfif attributes.record_num eq 1 and attributes.is_changed_spec_main eq 1>
				<cfscript>
					m_main_stock_id = attributes.STOCK_ID1;
					m_main_product_id = attributes.PRODUCT_ID1;
					if(len(attributes.SPECT_NAME1))
						m_spec_name = attributes.SPECT_NAME1;
					else
						m_spec_name = attributes.product_name1;
					m_row_count=0;
					m_spec_total_value = 0;
					m_spec_other_total_value = 0;
					m_other_money = session_money2;
					m_main_prod_price = attributes.COST_PRICE1;
					m_main_product_money = attributes.MONEY1;
					m_stock_id_list="";
					m_product_id_list="";
					m_lot_no_list="";
					m_product_name_list="";
					m_amount_list="";
					m_sevk_list="";
					m_product_price_list="";
					m_product_money_list="";
					m_is_property_list ="";//0 set edilecek sarf olduğu için
					m_property_id_list ="";
					m_variation_id_list="";
					m_total_min_list = "";
					m_total_max_list = "";
					m_tolerance_list="";
					m_is_configure_list="";
					m_diff_price_list = "";
					m_product_price_2_list = "";
					m_product_money_2_list = "";
					m_related_spect_main_id_list ="";
				</cfscript>
			</cfif>

			<cfif len(attributes.record_num_exit) and attributes.record_num_exit neq "">
			  <cfloop from="1" to="#attributes.record_num_exit#" index="i">
				<cfif evaluate("attributes.row_kontrol_exit#i#")>
					<cfscript>
						form_tree_type_exit = evaluate("attributes.tree_type_exit_#i#");
						if(isdefined("attributes.barcode_exit#i#"))
							form_barcode_exit = evaluate("attributes.barcode_exit#i#");
						else
							form_barcode_exit = '';
						form_product_id_exit = evaluate("attributes.product_id_exit#i#");
						form_stock_id_exit = evaluate("attributes.stock_id_exit#i#");
						form_lot_no_exit = evaluate("attributes.lot_no_exit#i#");
						form_amount_exit = evaluate("attributes.amount_exit#i#");
						if(isdefined("attributes.amount_exit2_#i#"))
							form_amount_exit2 = evaluate("attributes.amount_exit2_#i#");
						else
							form_amount_exit2 = 0;
						form_unit_id_exit = evaluate("attributes.unit_id_exit#i#");
						if(isdefined("attributes.unit2_exit#i#"))
							form_unit2_exit = evaluate("attributes.unit2_exit#i#");
						else
							form_unit2_exit ='';
						form_serial_no_exit = evaluate("attributes.serial_no_exit#i#");
						form_exit_product_name = evaluate("attributes.product_name_exit#i#");
						form_exit_unit = evaluate("attributes.unit_exit#i#");
						form_spect_id_exit = evaluate("attributes.spect_id_exit#i#");
						form_spec_main_id_exit = evaluate("attributes.spec_main_id_exit#i#");
						form_spect_name_exit = evaluate("attributes.spect_name_exit#i#");
						form_cost_id_exit = evaluate("attributes.cost_id_exit#i#");
						//form_product_cost_exit=evaluate("attributes.product_cost_exit#i#");
						//form_product_cost_money_exit=evaluate("attributes.product_cost_money_exit#i#");
						form_kdv_amount_exit=evaluate("attributes.kdv_amount_exit#i#");
						form_cost_price_system_exit=evaluate("attributes.cost_price_system_exit#i#");
						form_purchase_extra_cost_system_exit=evaluate("attributes.purchase_extra_cost_system_exit#i#");
						form_purchase_extra_cost_exit=evaluate("attributes.purchase_extra_cost_exit#i#");
						form_money_system_exit=evaluate("attributes.money_system_exit#i#");
						form_cost_price_exit=evaluate("attributes.cost_price_exit#i#");
						form_money_exit=evaluate("attributes.money_exit#i#");
						if (isdefined("attributes.wrk_row_id_exit_#i#") and len(evaluate("attributes.wrk_row_id_exit_#i#")))//sarflar icin wrk_row_id
							form_wrk_row_id_exit=evaluate("attributes.wrk_row_id_exit_#i#");
						else
							form_wrk_row_id_exit='WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##attributes.pr_order_id##form_stock_id_exit#_2';
						if (isdefined("attributes.cost_price_exit_2#i#"))
						{
							form_cost_price_exit_2 = evaluate("attributes.cost_price_exit_2#i#");
							form_cost_price_exit_extra_2 = evaluate("attributes.purchase_extra_cost_exit_2#i#");
							form_money_exit_2 = evaluate("attributes.money_exit_2#i#");
						}
						else
						{
							form_cost_price_exit_2 = 0;
							form_cost_price_exit_extra_2 = 0;
							form_money_exit_2 = '';
						}
						if(attributes.record_num eq 1 and attributes.is_changed_spec_main eq 1)//sarf kısmında 1 tane ürün varsa vede xml ayarlarından sarf değişikliklerinden spec seçilmiş denilmiş ise.
						{
							m_row_count=m_row_count+1;
							m_product_id_list = listappend(m_product_id_list,form_product_id_exit,',');
							m_stock_id_list =  listappend(m_stock_id_list,form_stock_id_exit,',');
							m_lot_no_list = listappend(m_lot_no_list,form_lot_no_exit,',');
							m_product_name_list =  listappend(m_product_name_list,form_exit_product_name,',');
							m_amount_list = listappend(m_amount_list,form_amount_exit/attributes.amount1,',');//sarfların miktarı bölü ana ürünün miktarı
							if(isdefined('attributes.is_sevkiyat#i#'))
								m_sevk_list = listappend(m_sevk_list,1,',');
							else
								m_sevk_list = listappend(m_sevk_list,0,',');
							m_product_price_list = 	listappend(m_product_price_list,form_cost_price_exit,',');
							m_product_money_list = listappend(m_product_money_list,form_money_exit,',');
							if(isdefined("form_cost_price_exit_2"))
							{
								m_product_price_2_list = 	listappend(m_product_price_2_list,form_cost_price_exit_2,',');
								m_product_money_2_list = listappend(m_product_money_2_list,form_money_exit_2,',');
							}
							else
							{
								m_product_price_2_list = 	listappend(m_product_price_2_list,0,',');
								m_product_money_2_list = listappend(m_product_money_2_list,0,',');
							}
							m_is_property_list = listappend(m_is_property_list,0,',');
							m_property_id_list = listappend(m_property_id_list,0,',');
							m_variation_id_list = listappend(m_variation_id_list,0,',');
							m_total_min_list = listappend(m_total_min_list,0,',');
							m_total_max_list = listappend(m_total_max_list,0,',');
							m_tolerance_list = listappend(m_tolerance_list,'-',',');
							m_is_configure_list = listappend(m_is_configure_list,1,',');
							m_diff_price_list = listappend(m_diff_price_list,0,',');
							if(len(form_spec_main_id_exit))
								m_related_spect_main_id_list =  listappend(m_related_spect_main_id_list,form_spec_main_id_exit,',');
							else
								m_related_spect_main_id_list =  listappend(m_related_spect_main_id_list,0,',');						}
					</cfscript>
					<cfquery name="ADD_ROW_ENTER" datasource="#dsn3#">
						INSERT INTO
							PRODUCTION_ORDER_RESULTS_ROW
							(
								TREE_TYPE,
                                TYPE,
								PR_ORDER_ID,
								BARCODE,
								STOCK_ID,
								PRODUCT_ID,
								LOT_NO,
								AMOUNT,
                                AMOUNT2,
								UNIT_ID,
                                UNIT2,
								SERIAL_NO,
								NAME_PRODUCT,
								UNIT_NAME,
								IS_SEVKIYAT,
								SPECT_ID,
                                SPEC_MAIN_ID,
								SPECT_NAME,								
								COST_ID,
								KDV_PRICE,
								PURCHASE_NET_SYSTEM,
								PURCHASE_NET_SYSTEM_MONEY,
								PURCHASE_EXTRA_COST_SYSTEM,
								PURCHASE_NET_SYSTEM_TOTAL,
								PURCHASE_NET,
								PURCHASE_NET_MONEY,
								PURCHASE_NET_2,
								PURCHASE_EXTRA_COST_SYSTEM_2,
								PURCHASE_NET_MONEY_2,
								PURCHASE_EXTRA_COST,
								PURCHASE_NET_TOTAL,
								PRODUCT_NAME2,
								IS_STOCK_FIS,
								IS_FROM_SPECT,
								IS_FREE_AMOUNT,
								WRK_ROW_ID
							)
							VALUES
							(
								'#form_tree_type_exit#',
                                2,
								#attributes.pr_order_id#,
								<cfif isdefined("form_barcode_exit") and len(form_barcode_exit)>'#form_barcode_exit#'<cfelse>NULL</cfif>,
								<cfif len(form_stock_id_exit)>#form_stock_id_exit#<cfelse>NULL</cfif>,
								<cfif len(form_product_id_exit)>#form_product_id_exit#<cfelse>NULL</cfif>,
								<cfif len(form_lot_no_exit)>'#form_lot_no_exit#'<cfelse>NULL</cfif>,
								<cfif len(form_amount_exit)>#form_amount_exit#<cfelse>NULL</cfif>,
                                <cfif len(form_amount_exit2) and len(form_unit2_exit) >#form_amount_exit2#<cfelse>NULL</cfif>,
								<cfif len(form_unit_id_exit)>#form_unit_id_exit#<cfelse>NULL</cfif>,
                                <cfif len(form_unit2_exit)>'#form_unit2_exit#'<cfelse>NULL</cfif>,
								<cfif len(form_serial_no_exit)>'#form_serial_no_exit#'<cfelse>NULL</cfif>,
								'#left(form_exit_product_name,250)#',
								'#left(form_exit_unit,75)#',
								<cfif isdefined("attributes.is_sevkiyat#i#")>1<cfelse>0</cfif>,
								<cfif len(form_spect_id_exit)>#form_spect_id_exit#<cfelse>NULL</cfif>,
								<cfif len(form_spec_main_id_exit)>#form_spec_main_id_exit#<cfelse>NULL</cfif>,
								<cfif len(form_spect_name_exit)>'#left(form_spect_name_exit,50)#'<cfelse>NULL</cfif>,
								
								<cfif len(form_cost_id_exit) and (form_cost_id_exit neq 0)>#form_cost_id_exit#<cfelse>NULL</cfif>,
								<cfif len(form_kdv_amount_exit)>#form_kdv_amount_exit#<cfelse>0</cfif>,
								<cfif len(form_cost_price_system_exit)>#form_cost_price_system_exit#<cfelse>0</cfif>,
								<cfif len(form_money_system_exit)>'#form_money_system_exit#'<cfelse>'#session_money#'</cfif>,
								<cfif len(form_purchase_extra_cost_system_exit)>#form_purchase_extra_cost_system_exit#<cfelse>0</cfif>,
								<cfif len(form_cost_price_system_exit) and len(form_amount_exit)>#form_cost_price_system_exit*form_amount_exit#<cfelse>0</cfif>,
								<cfif len(form_cost_price_exit)>#form_cost_price_exit#<cfelse>0</cfif>,
								<cfif len(form_money_exit)>'#form_money_exit#'<cfelse>'#session_money#'</cfif>,
								<cfif isdefined("form_cost_price_exit_2") and len(form_cost_price_exit_2)>#form_cost_price_exit_2#<cfelse>0</cfif>,
								<cfif isdefined("form_cost_price_exit_extra_2") and len(form_cost_price_exit_extra_2)>#form_cost_price_exit_extra_2#<cfelse>0</cfif>,
								<cfif isdefined("form_money_exit_2") and  len(form_money_exit_2)>'#form_money_exit_2#'<cfelse>'#session_money2#'</cfif>,
								<cfif len(form_purchase_extra_cost_exit)>#form_purchase_extra_cost_exit#<cfelse>0</cfif>,
								<cfif len(form_cost_price_exit)>#form_cost_price_exit*form_amount_exit#<cfelse>0</cfif>,
								<cfif isdefined("attributes.product_name2_exit#i#")>'#left(evaluate("attributes.product_name2_exit#i#"),250)#'<cfelse>NULL</cfif>,
								#get_stock_fis_kontrol.is_stock_fis#,
								<cfif isdefined("attributes.is_add_info_#i#")>1<cfelse>0</cfif>,
								<cfif isdefined("attributes.is_free_amount#i#") and evaluate("attributes.is_free_amount#i#") eq 1>1<cfelse>0</cfif>,
								'#form_wrk_row_id_exit#'
							)				
					</cfquery>
					<cfscript>
					if(not len(form_amount_exit))form_amount_exit=0;
					if(not len(form_cost_price_exit_2))form_cost_price_exit_2=0;
					if(not len(form_cost_price_exit_extra_2))form_cost_price_exit_extra_2=0;
					if(not len(form_cost_price_system_exit))form_cost_price_system_exit=0;
					if(not len(form_purchase_extra_cost_system_exit))form_purchase_extra_cost_system_exit=0;
						value_price = value_price + form_cost_price_system_exit * form_amount_exit;
						value_price_extra = value_price_extra + form_purchase_extra_cost_system_exit * form_amount_exit;
						value_price2 = value_price2 + form_cost_price_exit_2 * form_amount_exit;
						value_price_extra2 = value_price_extra2 + form_cost_price_exit_extra_2 * form_amount_exit;
					</cfscript>
				</cfif>
			  </cfloop>
			   <!--- Sarflar değişti ise ve XML ayarlarından "Sarf değişikliklerinden spec değişssin" seçeneği seçilmiş ise spect değiştir --->
			   <cfif attributes.record_num eq 1 and attributes.is_changed_spec_main eq 1>
					<!--- Sonuç kısmında ürün 1 tane ise yukarıda oluşturulan değişkenler ile önce sadece MAIN SPECT oluşturuluyor,daha sonra aşağıda formdan gelen sonuç 
					kısmındaki ürünün spect_main_id'si ile karşılaştırma yapılacak ve eğer fonksiyondan gelen main spect id formdan gelen ürünün main spect id'sinden 
					farklı ise(bu durumda ürünün sarfları değiştirilmiş demektir,eklenmiş çıkarılmış yada alternatifi seçilmiş olabilir.) aşağıdaki blokta fonksiyondan
					gelen main_spect_id'yi kullanarak yeni bir spect oluşturulacak ve bu yeni spect id ile üretim tabloları güncellenecek. --->
					<cfscript>
						a=specer(
						dsn_type : dsn3,
						spec_is_tree : 0,
						only_main_spec: 1,
						spec_row_count : m_row_count,
						spec_type : session_our_company_info_spect_type,
						main_stock_id : m_main_stock_id ,
						main_product_id : m_main_product_id,
						spec_name : m_spec_name,
						spec_total_value : m_spec_total_value,
						spec_other_total_value : m_spec_other_total_value,
						other_money : m_other_money,
						main_prod_price : m_main_prod_price,
						main_product_money:m_main_product_money,
						product_id_list : m_product_id_list,
						stock_id_list : m_stock_id_list,
						product_name_list:m_product_name_list,
						amount_list:m_amount_list,
						is_sevk_list:m_sevk_list,
						product_price_list:m_product_price_list,
						product_money_list:m_product_money_list,
						is_property_list:m_is_property_list,
						property_id_list : m_property_id_list,
						variation_id_list : m_variation_id_list,
						total_max_list : m_total_max_list,
						total_min_list : m_total_min_list,
						tolerance_list:m_tolerance_list,
						is_configure_list : m_is_configure_list,
						diff_price_list :m_diff_price_list,
						related_spect_id_list : m_related_spect_main_id_list
						);	
					</cfscript>
					<!--- Burda formdan gelen sonuç kısmındaki ürünün spect id'sini kullanarak hangi main_spect_id'ye bağlı olduğunu çekiyoruz --->
					<cfif not len(attributes.SPECT_ID1) and len(attributes.SPEC_MAIN_ID1)>
						<cfset SPECT_CHANGE_CONTROL.SPECT_MAIN_ID = attributes.SPEC_MAIN_ID1>
					<cfelseif len(attributes.SPECT_ID1)>
                        <cfquery name="SPECT_CHANGE_CONTROL" datasource="#DSN3#">
                            SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = #attributes.SPECT_ID1#
                        </cfquery>
                    </cfif>
					<!--- Formdan gelen,sonuç kısmındaki ürünün spect_main_id'si yukarıdaki main spect oluşturan specer fonksiyonundan gelen main_spect_id'den farklı ise(sarf ürünleri değiştirilmiş anlamına geliyor)  --->
					<cfif isdefined("SPECT_CHANGE_CONTROL.SPECT_MAIN_ID") and SPECT_CHANGE_CONTROL.SPECT_MAIN_ID neq listgetat(a,1,',')>
						<cfscript>
						//Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
						main_to_spect = specer(
								dsn_type:dsn3,
								spec_type:session_our_company_info_spect_type,
								main_spec_id:listgetat(a,1,','),
								main_stock_id : m_main_stock_id ,
								main_product_id : m_main_product_id,
								spec_name : m_spec_name,
								add_to_main_spec:1
								
							);
						</cfscript>
						<!--- Oluşturulan yeni spect id ve ismi --->
						<cfset new_created_spect_main_id = listgetat(main_to_spect,1,',')>
						<cfset new_created_spect_id = listgetat(main_to_spect,2,',')>
						<cfset new_created_spect_name = listgetat(main_to_spect,3,',')>
					</cfif>
				</cfif>
			</cfif>
			<!---fireler kayıt ediliyor--->
			<cfif len(attributes.record_num_outage) and attributes.record_num_outage neq "">
				<cfloop from="1" to="#attributes.record_num_outage#" index="i">
					<cfif evaluate("attributes.row_kontrol_outage#i#")>
						<cfscript>
							if(isdefined("attributes.barcode_outage#i#"))
								form_barcode_outage = evaluate("attributes.barcode_outage#i#");
							else
								form_barcode_outage = '';
							form_product_id_outage = evaluate("attributes.product_id_outage#i#");
							form_stock_id_outage = evaluate("attributes.stock_id_outage#i#");
							form_lot_no_outage = evaluate("attributes.lot_no_outage#i#");
							form_amount_outage = evaluate("attributes.amount_outage#i#");						
							if(isdefined("attributes.amount_outage2_#i#"))
								form_amount_outage2 = evaluate("attributes.amount_outage2_#i#");
							else
								form_amount_outage2 = 0;
							form_unit_id_outage = evaluate("attributes.unit_id_outage#i#");
							if(isdefined("attributes.unit2_outage#i#"))
								form_unit2_outage = evaluate("attributes.unit2_outage#i#");
							else
								form_unit2_outage = '';
							form_serial_no_outage = evaluate("attributes.serial_no_outage#i#");
							form_kdv_amount_outage = evaluate("attributes.kdv_amount_outage#i#");
							form_spect_id_outage = evaluate("attributes.spect_id_outage#i#");
							form_spec_main_id_outage = evaluate("attributes.spec_main_id_outage#i#");
							form_spect_name_outage = evaluate("attributes.spect_name_outage#i#");
							form_outage_unit = evaluate("attributes.unit_outage#i#");
							form_outage_product_name = evaluate("attributes.product_name_outage#i#");
							
							form_cost_id_outage = evaluate("attributes.cost_id_outage#i#");
							//form_product_cost_outage=evaluate("attributes.product_cost_outage#i#");
							//form_product_cost_money_outage=evaluate("attributes.product_cost_money_outage#i#");
							form_kdv_amount_outage=evaluate("attributes.kdv_amount_outage#i#");
							form_cost_price_system_outage=evaluate("attributes.cost_price_system_outage#i#");
							form_purchase_extra_cost_system_outage=evaluate("attributes.purchase_extra_cost_system_outage#i#");
							form_purchase_extra_cost_outage=evaluate("attributes.purchase_extra_cost_outage#i#");
							form_money_system_outage=evaluate("attributes.money_system_outage#i#");
							form_cost_price_outage=evaluate("attributes.cost_price_outage#i#");
							form_money_outage=evaluate("attributes.money_outage#i#");
							if (isdefined("attributes.wrk_row_id_outage_#i#") and len(evaluate("attributes.wrk_row_id_outage_#i#")))//fireler icin wrk_row_id
								form_wrk_row_id_outage=evaluate("attributes.wrk_row_id_outage_#i#");
							else
								form_wrk_row_id_outage='WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##attributes.pr_order_id##form_stock_id_outage#_3';
							if(isdefined("attributes.cost_price_outage_2#i#"))
							{
								form_cost_price_outage_2=evaluate("attributes.cost_price_outage_2#i#");
								form_cost_price_outage_extra_2 = evaluate("attributes.purchase_extra_cost_outage_2#i#");
								form_money_outage_2=evaluate("attributes.money_outage_2#i#");
							}
							else
							{
								form_cost_price_outage_2=0;
								form_cost_price_outage_extra_2=0;
								form_money_outage_2='';
							}
						</cfscript>
						<cfquery name="ADD_ROW_ENTER" datasource="#dsn3#">
							INSERT INTO
								PRODUCTION_ORDER_RESULTS_ROW
								(
									TYPE,
									PR_ORDER_ID,
									BARCODE,
									STOCK_ID,
									PRODUCT_ID,
									LOT_NO,
									AMOUNT,
                                    AMOUNT2,
									UNIT_ID,
                                    UNIT2,
									SERIAL_NO,
									NAME_PRODUCT,
									UNIT_NAME,
									IS_SEVKIYAT,
									SPECT_ID,
                                    SPEC_MAIN_ID,
									SPECT_NAME,
									COST_ID,
									KDV_PRICE,
									PURCHASE_NET_SYSTEM,
									PURCHASE_NET_SYSTEM_MONEY,
									PURCHASE_EXTRA_COST_SYSTEM,
									PURCHASE_NET_SYSTEM_TOTAL,
									PURCHASE_NET,
									PURCHASE_NET_MONEY,
									PURCHASE_NET_2,
									PURCHASE_EXTRA_COST_SYSTEM_2,
									PURCHASE_NET_MONEY_2,
									PURCHASE_EXTRA_COST,
									PURCHASE_NET_TOTAL,
									PRODUCT_NAME2,
									IS_STOCK_FIS,
									WRK_ROW_ID
								)
								VALUES
								(
									3,
									#attributes.pr_order_id#,
									<cfif isdefined("form_barcode_outage") and len(form_barcode_outage)>'#form_barcode_outage#'<cfelse>NULL</cfif>,
									<cfif len(form_stock_id_outage)>#form_stock_id_outage#<cfelse>NULL</cfif>,
									<cfif len(form_product_id_outage)>#form_product_id_outage#<cfelse>NULL</cfif>,
									<cfif len(form_lot_no_outage)>'#form_lot_no_outage#'<cfelse>NULL</cfif>,
									<cfif len(form_amount_outage)>#form_amount_outage#<cfelse>NULL</cfif>,
									<cfif len(form_amount_outage2) and len(form_unit2_outage)>#form_amount_outage2#<cfelse>NULL</cfif>,
									<cfif len(form_unit_id_outage)>#form_unit_id_outage#<cfelse>NULL</cfif>,
                                    <cfif len(form_unit2_outage)>'#form_unit2_outage#'<cfelse>NULL</cfif>,
									<cfif len(form_serial_no_outage)>'#form_serial_no_outage#'<cfelse>NULL</cfif>,
									'#left(form_outage_product_name,75)#',
									'#left(form_outage_unit,75)#',
									0,
									<cfif len(form_spect_id_outage)>#form_spect_id_outage#<cfelse>NULL</cfif>,
                                    <cfif len(form_spec_main_id_outage)>#form_spec_main_id_outage#<cfelse>NULL</cfif>,
									<cfif len(form_spect_name_outage)>'#left(form_spect_name_outage,50)#'<cfelse>NULL</cfif>,
									<cfif len(form_cost_id_outage) and (form_cost_id_outage neq 0)>#form_cost_id_outage#<cfelse>NULL</cfif>,
									<cfif len(form_kdv_amount_outage)>#form_kdv_amount_outage#<cfelse>0</cfif>,
									<cfif len(form_cost_price_system_outage)>#form_cost_price_system_outage#<cfelse>0</cfif>,
									<cfif len(form_money_system_outage)>'#form_money_system_outage#'<cfelse>'#session_money#'</cfif>,
									<cfif len(form_purchase_extra_cost_system_outage)>#form_purchase_extra_cost_system_outage#<cfelse>0</cfif>,
									<cfif len(form_cost_price_system_outage) and len(form_amount_outage)>#form_cost_price_system_outage*form_amount_outage#<cfelse>0</cfif>,
									<cfif len(form_cost_price_outage)>#form_cost_price_outage#<cfelse>0</cfif>,
									<cfif len(form_money_outage)>'#form_money_outage#'<cfelse>'#session_money#'</cfif>,
									<cfif isdefined("form_cost_price_outage_2") and len(form_cost_price_outage_2)>#form_cost_price_outage_2#<cfelse>0</cfif>,
									<cfif isdefined("form_cost_price_outage_extra_2") and len(form_cost_price_outage_extra_2)>#form_cost_price_outage_extra_2#<cfelse>0</cfif>,
									<cfif isdefined("form_money_outage_2") and len(form_money_outage_2)>'#form_money_outage_2#'<cfelse>'#session_money2#'</cfif>,
									<cfif len(form_purchase_extra_cost_outage)>#form_purchase_extra_cost_outage#<cfelse>0</cfif>,
									<cfif len(form_cost_price_outage)>#form_cost_price_outage*form_amount_outage#<cfelse>0</cfif>,
									<cfif isdefined("attributes.product_name2_outage#i#")>'#left(evaluate("attributes.product_name2_outage#i#"),250)#'<cfelse>NULL</cfif>,
									#get_stock_fis_kontrol.is_stock_fis#,
									'#form_wrk_row_id_outage#'
								)				
						</cfquery>
						<cfscript>
							if(not len(form_amount_outage))form_amount_outage=0;
							if(not len(form_cost_price_system_outage))form_cost_price_system_outage=0;
							if(not len(form_purchase_extra_cost_system_outage))form_purchase_extra_cost_system_outage=0;
							value_price = value_price + form_cost_price_system_outage * form_amount_outage;
							value_price_extra = value_price_extra + form_purchase_extra_cost_system_outage * form_amount_outage;
							value_price2 = value_price2 + form_cost_price_outage_2 * form_amount_outage;
							value_price_extra2 = value_price_extra2 + form_cost_price_outage_extra_2 * form_amount_outage;
						</cfscript>
					</cfif>
				</cfloop>
			</cfif>
			<cfif len(attributes.record_num) and attributes.record_num neq "">
				<cfset record_num_ = 0>
				<cfloop from="1" to="#attributes.record_num#" index="i">
					<cfif evaluate("attributes.row_kontrol#i#") and not(isdefined("attributes.is_free_amount_#i#") and len(evaluate("attributes.is_free_amount_#i#")) and evaluate("attributes.is_free_amount_#i#"))>
						<cfset record_num_ = record_num_ + 1>
					</cfif>
				</cfloop>
				<cfscript>
					total_cost=0;
					total_cost2=0;
					if(record_num_ gt 1)
					for(j=1;j lte attributes.record_num;j=j+1)
					{
						if(evaluate("attributes.row_kontrol#j#"))
						{						
							form_amount_1 = evaluate("attributes.amount#j#");
							form_cost_price_system_1 = evaluate("attributes.cost_price_system#j#");
							if(not len(form_cost_price_system_1))form_cost_price_system_1=0;
							total_cost=total_cost+(form_cost_price_system_1*form_amount_1);
							if(isdefined("attributes.cost_price_2#i#"))
							{
								form_cost_price_system_2 = evaluate("attributes.cost_price_2#j#");
								if(not len(form_cost_price_system_2))form_cost_price_system_2=0;
								total_cost2=total_cost2+(form_cost_price_system_2*form_amount_1);
							}
						}
					}else 
					{
						total_cost=100;
						total_cost2=100;
					}// ürün tek satirsa sarflarin maliyetinin tüm miktarını o ürüne yazar
					if(total_cost gt 0)
					{
						birim_cost=value_price/total_cost;
						birim_cost_extra=value_price_extra/total_cost;
					}
					else
					{
						birim_cost=0;
						birim_cost_extra=0;
					}
					if(total_cost2 gt 0)
					{
						birim_cost2=value_price2/total_cost2;
						birim_cost_extra2=value_price_extra2/total_cost2;
					}
					else
					{
						birim_cost2=0;
						birim_cost_extra2=0;
					}
				</cfscript>
				<cfloop from="1" to="#attributes.record_num#" index="i">
					<cfif evaluate("attributes.row_kontrol#i#")>
						<cfscript>
							form_tree_type = evaluate("attributes.tree_type_#i#");
							if(isdefined("attributes.barcode#i#"))
								form_barcode = evaluate("attributes.barcode#i#");
							else
								form_barcode = '';
							if(isdefined("attributes.fire_amount_#i#"))
								fire_amount_ = evaluate("attributes.fire_amount_#i#");
							else
								fire_amount_ = 0;
							form_product_id = evaluate("attributes.product_id#i#");
							form_stock_id = evaluate("attributes.stock_id#i#");
							form_amount = evaluate("attributes.amount#i#");
							if(isdefined("attributes.amount2_#i#"))
								form_amount2 = evaluate("attributes.amount2_#i#");
							else
								form_amount2 = 0;
							form_unit_id = evaluate("attributes.unit_id#i#");
							form_unit = evaluate("attributes.unit#i#");
							if(isdefined("attributes.unit2#i#"))
							form_unit2 = evaluate("attributes.unit2#i#");
							else
							form_unit2 = '';
							form_kdv_amount = evaluate("attributes.kdv_amount#i#");
							form_product_name = evaluate("attributes.product_name#i#");
							form_spect_name = evaluate("attributes.spect_name#i#");
							form_spect_id = evaluate("attributes.spect_id#i#");
							form_spec_main_id = evaluate("attributes.spec_main_id#i#");
							form_cost_id = evaluate("attributes.cost_id#i#");
							//form_product_cost=evaluate("attributes.product_cost#i#");
							//form_product_cost_money=evaluate("attributes.product_cost_money#i#");
							form_kdv_amount=evaluate("attributes.kdv_amount#i#");
							form_cost_price_system=evaluate("attributes.cost_price_system#i#");
							if(isdefined('attributes.station_reflection_cost_system#i#'))
								form_station_reflection_cost_system=evaluate("attributes.station_reflection_cost_system#i#");
							else
								form_station_reflection_cost_system ='';
							if(isdefined('attributes.labor_cost#i#'))
								form_labor_cost_system=evaluate("attributes.labor_cost#i#");
							else
								form_labor_cost_system ='';
							form_purchase_extra_cost_system=evaluate("attributes.purchase_extra_cost_system#i#");
							form_purchase_extra_cost=evaluate("attributes.purchase_extra_cost#i#");
							form_money_system=evaluate("attributes.money_system#i#");
							form_cost_price=evaluate("attributes.cost_price#i#");
							form_money=evaluate("attributes.money#i#");
							if (isdefined("attributes.wrk_row_id_#i#") and len(evaluate("attributes.wrk_row_id_#i#")))//ana urun icin wrk_row_id
								form_wrk_row_id=evaluate("attributes.wrk_row_id_#i#");
							else
								form_wrk_row_id='WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##attributes.pr_order_id##form_stock_id#_1';
							if(isdefined("attributes.cost_price_2#i#"))
							{
								form_cost_price_2=evaluate("attributes.cost_price_2#i#");
								if(isdefined("attributes.cost_price_extra_2#i#"))	
									form_cost_price_extra_2=evaluate("attributes.cost_price_extra_2#i#");
								else
									form_cost_price_extra_2=0;
								form_money_2=evaluate("attributes.money_2#i#");
							}
							else
							{
								form_cost_price_2=0;
								form_cost_price_extra_2=0;
								form_money_2='';
							}
							if(not (isdefined("attributes.is_free_amount_#i#") and len(evaluate("attributes.is_free_amount_#i#")) and evaluate("attributes.is_free_amount_#i#")))
							{
								if(record_num_ eq 1)
								{
									form_cost_price_system=100;
									form_cost_price_2=100;
									form_cost_price_extra_2=100;
								}// sonuc ürünü tek satir oldugunda total_cost 100 atandıgı için burdada 100 atanıyor maliyetin tamamı bu ürüne yazıyor
								else 
								{
									if(not len(form_cost_price_system))form_cost_price_system=0;
									if(not len(form_cost_price_2))form_cost_price_2=0;
									if(not len(form_cost_price_extra_2))form_cost_price_extra_2=0;
								}
								if(record_num_ eq 1)
								{//bir üretim soncu varsa maliyet adede bölünüyorki birim maliyet bulunsun
									deger_value_price=(birim_cost*form_cost_price_system)/form_amount;
									deger_value_price_extra=(birim_cost_extra*form_cost_price_system)/form_amount;
									deger_value_price2=(birim_cost2*form_cost_price_2)/form_amount;
									deger_value_price_extra2=(birim_cost_extra2*form_cost_price_extra_2)/form_amount;
								}else{
									deger_value_price=(birim_cost*form_cost_price_system);
									deger_value_price_extra=(birim_cost_extra*form_cost_price_system);
									deger_value_price2=(birim_cost2*form_cost_price_2);
									deger_value_price_extra2=(birim_cost_extra2*form_cost_price_extra_2);
								}
								deger_value_total_price = deger_value_price * form_amount;
							}
							else
							{
								deger_value_price=(form_cost_price_system);
								deger_value_price_extra=(form_purchase_extra_cost_system);
								deger_value_price2=(form_cost_price_2);
								deger_value_price_extra2=(form_cost_price_extra_2);
							}
						</cfscript>
						<cfset sub_p_order_id="">
						 <cfif isdefined("attributes.sub_p_order_id#i#")  and len(evaluate("attributes.sub_p_order_id#i#"))>
							<cfset sub_p_order_id=evaluate("attributes.sub_p_order_id#i#")>
						 </cfif>
						 <cfset party_id="">
						 <cfif IsDefined("attributes.party_id") and len(attributes.party_id)>
							<cfset party_id=attributes.party_id>
						 </cfif>
						<cfquery name="ADD_ROW_ENTER" datasource="#dsn3#">
							INSERT
							INTO
								PRODUCTION_ORDER_RESULTS_ROW
								(
									TREE_TYPE,
                                    TYPE,
									PR_ORDER_ID,
									BARCODE,
									STOCK_ID,
									PRODUCT_ID,
									AMOUNT,
                                    AMOUNT2,
									UNIT_ID,
                                    UNIT2,
									NAME_PRODUCT,
									UNIT_NAME,
									SPECT_ID,
                                    SPEC_MAIN_ID,
									SPECT_NAME,
									COST_ID,
									KDV_PRICE,
									PURCHASE_NET_SYSTEM,
									PURCHASE_NET_SYSTEM_MONEY,
									PURCHASE_EXTRA_COST_SYSTEM,
									PURCHASE_NET_SYSTEM_TOTAL,
									PURCHASE_NET,
									PURCHASE_NET_MONEY,
									PURCHASE_NET_2,
									PURCHASE_EXTRA_COST_SYSTEM_2,
									PURCHASE_NET_MONEY_2,
									PURCHASE_EXTRA_COST,
									PURCHASE_NET_TOTAL,
                                    STATION_REFLECTION_COST_SYSTEM,
									LABOR_COST_SYSTEM,
									PRODUCT_NAME2,
									IS_STOCK_FIS,
									FIRE_AMOUNT,
									IS_FREE_AMOUNT,
									WRK_ROW_ID,
									P_ORDER_ID
								)
								VALUES
								(
                                	'#form_tree_type#',
									1,
									#attributes.pr_order_id#,
									<cfif isdefined("form_barcode") and len(form_barcode)>'#form_barcode#',<cfelse>NULL,</cfif>
									<cfif len(form_stock_id)>#form_stock_id#,<cfelse>NULL,</cfif>
									<cfif len(form_product_id)>#form_product_id#,<cfelse>NULL,</cfif>
									<cfif len(form_amount)>#form_amount#,<cfelse>NULL,</cfif>
									<cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
									<cfif len(form_unit_id)>#form_unit_id#,<cfelse>NULL,</cfif>
                                    <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
									'#left(form_product_name,75)#',
									'#left(form_unit,75)#',
									<cfif len(form_spect_id)>#form_spect_id#,<cfelse>NULL,</cfif>
                                    <cfif len(form_spec_main_id)>#form_spec_main_id#,<cfelse>NULL,</cfif>
									<cfif len(form_spect_name)>'#left(form_spect_name,50)#',<cfelse>NULL,</cfif>									
									<cfif len(form_cost_id) and (form_cost_id neq 0)>#form_cost_id#<cfelse>NULL</cfif>,
									<cfif len(form_kdv_amount)>#form_kdv_amount#<cfelse>0</cfif>,
									<cfif len(deger_value_price)>#deger_value_price#<cfelse>0</cfif>,
									<cfif len(form_money_system)>'#form_money_system#'<cfelse>'#session_money#'</cfif>,
									<cfif len(deger_value_price_extra)>#deger_value_price_extra#<cfelse>0</cfif>,
									<cfif len(deger_value_total_price)>#deger_value_total_price#<cfelse>0</cfif>,
									<cfif len(form_cost_price)>#form_cost_price#<cfelse>0</cfif>,
									<cfif len(form_money)>'#form_money#'<cfelse>'#session_money#'</cfif>,
									<cfif isdefined("deger_value_price2") and len(deger_value_price2)>#deger_value_price2#<cfelse>0</cfif>,
									<cfif isdefined("deger_value_price_extra2") and len(deger_value_price_extra2)>#deger_value_price_extra2#<cfelse>0</cfif>,
									<cfif isdefined("form_money_2") and len(form_money_2)>'#form_money_2#'<cfelse>'#session_money2#'</cfif>,
									<cfif len(form_purchase_extra_cost)>#form_purchase_extra_cost#<cfelse>0</cfif>,
									<cfif len(form_cost_price) and len(form_amount)>#form_cost_price*form_amount#<cfelse>0</cfif>,
                                    <cfif len(form_station_reflection_cost_system)>#form_station_reflection_cost_system#<cfelse>NULL</cfif>,
									<cfif len(form_labor_cost_system)>#form_labor_cost_system#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.product_name2#i#")>'#left(evaluate("attributes.product_name2#i#"),250)#'<cfelse>NULL</cfif>,
									#get_stock_fis_kontrol.is_stock_fis#,
									<cfif len(fire_amount_)>#fire_amount_#<cfelse>0</cfif>,
									<cfif isdefined("attributes.is_free_amount_#i#") and len(evaluate("attributes.is_free_amount_#i#")) and evaluate("attributes.is_free_amount_#i#")>1<cfelse>0</cfif>,
									'#form_wrk_row_id#',
									 <cfif len(sub_p_order_id)>
											#sub_p_order_id#
									<cfelse>
											NULL
									</cfif>
								)				
						</cfquery>
						
						<cfif len(party_id) and len(sub_p_order_id)>
								<cfquery name="get_result_amount" datasource="#dsn3#">
									SELECT
										ISNULL(SUM(POR_.AMOUNT),0) RESULT_AMOUNT
									FROM
										PRODUCTION_ORDER_RESULTS_ROW POR_,
										PRODUCTION_ORDER_RESULTS POO
									WHERE
										POR_.PR_ORDER_ID = POO.PR_ORDER_ID
										AND POR_.P_ORDER_ID =#sub_p_order_id#
										AND POR_.TYPE = 1
										AND POO.IS_STOCK_FIS = 1
										<!---AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)--->
									</cfquery>
								<!---<cfdump var="#get_result_amount#"><cfabort>--->
								 <cfquery name="upd_prod_orders" datasource="#dsn3#">
									UPDATE PRODUCTION_ORDERS SET RESULT_AMOUNT=#get_result_amount.RESULT_AMOUNT# WHERE P_ORDER_ID = #sub_p_order_id#
								</cfquery>
						</cfif>
						
						
						
					</cfif>
				</cfloop>
			</cfif>
			<cfif isdefined('new_created_spect_id')><!--- Eğer ana ürün için yeni bir spect id oluşmuş ise --->
				<cfquery name="UPD_PROD_ORDER_SPECT" datasource="#dsn3#">
					UPDATE 
						PRODUCTION_ORDERS
					SET
						SPECT_VAR_ID = #new_created_spect_id#,
						SPECT_VAR_NAME = '#new_created_spect_name#',
                        SPEC_MAIN_ID = #new_created_spect_main_id#
					WHERE
						P_ORDER_ID =  #attributes.p_order_id#
				</cfquery>
				<cfquery name="UPD_PROD_ORDER_ROW_SPECT" datasource="#dsn3#">
					UPDATE 
						PRODUCTION_ORDER_RESULTS_ROW
					SET
						SPECT_ID = #new_created_spect_id#,
						SPECT_NAME = '#new_created_spect_name#',
                        SPEC_MAIN_ID = #new_created_spect_main_id#
					WHERE
						TYPE=1 AND <!--- SADECE ANA URUN GUNCELLENIYOR --->
						PR_ORDER_ID =  #attributes.pr_order_id#
				</cfquery>
				<cfif isdefined('attributes.ORDER_ROW_ID') and ListLen(attributes.ORDER_ROW_ID,',')><!---  and ListLen(attributes.ORDER_ROW_ID,',') eq 1 --->
                    <!--- Buraya girerse bu üretim sipariş ile ilişkilidir demektir,bu sebeble oluşan yeni spect_var_id için siparişide güncelliyoruz. --->
                    <cfloop from="1" to="#ListLen(attributes.ORDER_ROW_ID,',')#" index="i_in_d">
                        <cfquery name="UPD_ORDERS" datasource="#dsn3#">
                            UPDATE ORDER_ROW SET SPECT_VAR_ID = #new_created_spect_id# WHERE ORDER_ROW_ID = #ListGetAt(attributes.ORDER_ROW_ID,i_in_d,',')# 
                        </cfquery>
                    </cfloop>
                </cfif>
			</cfif>
			<!---muhasebe fişi kaydediyor OZDEN20060421  --->
			<cfif isDefined("session.ep")><!--- PDA de gelmemesi icin --->
				<cfscript>
					if(GET_PROCESS_TYPE.IS_ACCOUNT eq 1 and 1 eq 2)
					{
						is_dept_based_acc = GET_PROCESS_TYPE.IS_DEPT_BASED_ACC;
						include('../../../production_plan/query/prod_order_result_account_process.cfm');
						muhasebeci(
							action_id : attributes.pr_order_id,
							workcube_process_type : get_process_type.process_type,
							workcube_old_process_type : form.old_process_type,
							muhasebe_db : '#dsn3#',
							account_card_type : 13,
							islem_tarihi :account_action_date,
							borc_hesaplar : str_borclu_hesaplar,
							borc_tutarlar : str_borc_tutar,
							other_amount_borc : str_borc_dovizli,
							other_currency_borc : str_other_currency_borc,
							alacak_hesaplar : str_alacakli_hesaplar,
							alacak_tutarlar : str_alacak_tutar,
							other_amount_alacak : str_alacak_dovizli,
							other_currency_alacak :str_other_currency_alacak,
							to_branch_id : to_branch_id,
							fis_detay : 'ÜRETİM SONUCU',
							fis_satir_detay : 'Üretim Sonucu',
							belge_no : form.production_result_no,
							is_account_group : get_process_type.is_account_group,
							acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_name") and len(attributes.project_name)),attributes.project_id,de(''))
						);
						if(isdefined("attributes.is_delstock") and Len(attributes.is_delstock))
						{
							AMBAR_FIS =cfquery(datasource:"#dsn3#",sqlstring:"SELECT * FROM GET_FIS WHERE FIS_TYPE=113",dbtype="1");
							if(len(AMBAR_FIS.FIS_ID)) 
								muhasebe_sil(action_id:AMBAR_FIS.FIS_ID, process_type:113, muhasebe_db : '#dsn3#');
						}
					}
					else
					{
						muhasebe_sil(action_id:attributes.pr_order_id, process_type:form.old_process_type,muhasebe_db : '#dsn3#');
						 if( not (isdefined("attributes.is_delstock") and Len(attributes.is_delstock)))
							AMBAR_FIS_ID = cfquery(datasource:"#dsn3#",sqlstring:"SELECT FIS_ID FROM #dsn2_alias#.STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id# AND FIS_TYPE=113");
						else
							AMBAR_FIS_ID =cfquery(datasource:"#dsn3#",sqlstring:"SELECT * FROM GET_FIS WHERE FIS_TYPE=113",dbtype="1");
						
						if(len(AMBAR_FIS_ID.FIS_ID)) //ambar fisini muhasebe fisi silinecek
							muhasebe_sil(action_id:AMBAR_FIS_ID.FIS_ID, process_type:113, muhasebe_db : '#dsn3#');
					}
				</cfscript>
			</cfif>
			<cfif not len(party_id)>
				<cfquery name="get_result_amount" datasource="#dsn3#">
					SELECT
						ISNULL(SUM(POR_.AMOUNT),0) RESULT_AMOUNT
					FROM
						PRODUCTION_ORDER_RESULTS_ROW POR_,
						PRODUCTION_ORDER_RESULTS POO
					WHERE
						POR_.PR_ORDER_ID = POO.PR_ORDER_ID
						AND POO.P_ORDER_ID = #attributes.p_order_id#
						AND POR_.TYPE = 1
						AND POO.IS_STOCK_FIS = 1
						AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
					</cfquery>
				
				 <cfquery name="upd_prod_orders" datasource="#dsn3#">
					UPDATE PRODUCTION_ORDERS SET RESULT_AMOUNT=#get_result_amount.RESULT_AMOUNT# WHERE P_ORDER_ID = #attributes.p_order_id#
				</cfquery>
			</cfif>
			<cfif isdefined("attributes.party_id") and len(attributes.party_id)>
							<cfquery name="get_result_amount" datasource="#dsn3#">
								SELECT
									ISNULL(SUM(POR_.AMOUNT),0) RESULT_AMOUNT
								FROM
									PRODUCTION_ORDER_RESULTS_ROW POR_,
									PRODUCTION_ORDER_RESULTS POO
								WHERE
									POR_.PR_ORDER_ID = POO.PR_ORDER_ID
									AND POO.PARTY_ID = #attributes.party_id#
									AND POR_.TYPE = 1
									AND POO.IS_STOCK_FIS = 1
							</cfquery>
							 <cfquery name="upd_prod_orders" datasource="#dsn3#">
								UPDATE PRODUCTION_ORDERS_MAIN SET RESULT_AMOUNT=#get_result_amount.RESULT_AMOUNT# WHERE PARTY_ID = #attributes.party_id#
							</cfquery>
					</cfif>
			<cfif len(get_process_type.action_file_name)><!--- secilen islem kategorisine bir action file eklenmisse --->
				<cf_workcube_process_cat 
					process_cat="#form.process_cat#"
					action_id = #attributes.pr_order_id#
					action_db_type = '#dsn3#'
					is_action_file = 1
					action_page='#request.self#?fuseaction=prod.list_results_tex&event=upd&party_id=#attributes.party_id#&pr_order_id=#attributes.pr_order_id#'
					action_file_name='#get_process_type.action_file_name#'
					is_template_action_file = '#get_process_type.action_file_from_template#'>
			</cfif>
		</cftransaction>
	</cflock>
	<cf_workcube_process 
		is_upd='1' 
		process_stage='#attributes.process_stage#' 
		record_member='#session_userid#' 
		record_date='#now()#' 
		action_page='#request.self#?fuseaction=textile.list_results&event=upd&party_id=#attributes.party_id#&pr_order_id=#attributes.pr_order_id#' 
		action_id='#attributes.party_id#'
		action_table='PRODUCTION_ORDER_RESULTS'
		action_column='PR_ORDER_ID'
		old_process_line='#attributes.party_id#' 
		warning_description = 'Tekstil Üretim Sonucu : #attributes.production_order_no#'>
	<cfif (isdefined("attributes.is_delstock") and Len(attributes.is_delstock)) and session_our_company_info_is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
		<cfscript>cost_action(action_type:4,action_id:attributes.pr_order_id,query_type:3);</cfscript>
		<cfif isDefined("session.ep")><!--- Pda de Gelmemesi Icin --->
			<script type="text/javascript">
				window.location.href="<cfoutput>#request.self#?fuseaction=textile.list_results&event=upd&party_id=#attributes.party_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>";
			</script>
		</cfif>
	<cfelse>
		<cfif isDefined("session.ep")><!--- Pda de Gelmemesi Icin --->
			<!---<cflocation url="#request.self#?fuseaction=prod.list_results_tex&event=upd&party_id=#attributes.party_id#&pr_order_id=#attributes.pr_order_id#" addtoken="no">--->
			<script type="text/javascript">
				window.location.href="<cfoutput>#request.self#?fuseaction=textile.list_results&event=upd&party_id=#attributes.party_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>";
			</script>
		</cfif>
 	</cfif> 
</cfif>