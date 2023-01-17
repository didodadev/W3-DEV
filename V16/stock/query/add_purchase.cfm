<!--- Bu sayfada yapılacak ciddi yapısal degisikilikler TAT Metal Entegrasyon sistemine de yansitilmali --->
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfsetting showdebugoutput="no">
<cfinclude template="check_our_period.cfm">
<cfif isdefined('ship_number')>
	<cfset list1=",">
	<cfset list2="">
	<cfset ship_number = Replace(ship_number,list1,list2,"ALL")> 
</cfif>
<!---<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("	<cf_get_lang_main no='815.Ürün Seçmelisiniz'> !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>--->
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif isDefined("session.ep")><cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)></cfif><!--- pda den gelen işlemler için --->
<cfinclude template="get_process_cat.cfm">
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>
<cf_date tarih = 'attributes.action_date'>
<cfset attributes.deliver_date_frm = createdatetime(year(attributes.deliver_date_frm),month(attributes.deliver_date_frm),day(attributes.deliver_date_frm),attributes.deliver_date_h,attributes.deliver_date_m,0)>
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset ship_due_date = date_add("d",attributes.basket_due_value,attributes.ship_date)>
<cfelse>
    <cfquery name="get_order_due_date" datasource="#dsn3#">
    	SELECT DUE_DATE FROM ORDERS WHERE ORDER_NUMBER=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.order_id#">
    </cfquery>
    <cfif get_order_due_date.recordcount>
    	<cfset ship_due_date = get_order_due_date.DUE_DATE>
    <cfelse>
		<cfset ship_due_date = "">
    </cfif>
</cfif>
<cfquery name="GET_PURCHASE" datasource="#new_dsn2_group#">
	SELECT
		SHIP_NUMBER,
		PURCHASE_SALES
	FROM
		SHIP
	WHERE 
		PURCHASE_SALES = 0 AND 
		SHIP_NUMBER = '#SHIP_NUMBER#'
	  <cfif len(attributes.company_id)>
		AND COMPANY_ID = #attributes.company_id# 
	 <cfelseif len(attributes.consumer_id)>
	  	AND CONSUMER_ID = #attributes.consumer_id#
        <cfelse>
		AND EMPLOYEE_ID = #attributes.employee_id#
	  </cfif>
</cfquery>
<cfif get_purchase.recordcount>
	<script type="text/javascript">
		alert("	<cf_get_lang no ='518.Girdiğiniz İrsaliye Numarası Seçilen Cari Adına Kullanılmış Lütfen Tekrar Giriniz'> !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>
</cfif>
<!---<cfif not isdefined("function_off")><!--- Toplu Irsaliye Ekleme Islemleri Icın eklendi fbs 20091201 --->
	<cfinclude template="../../objects/functions/add_relation_rows.cfm"><!--- sip,irs,fat satırlarının birbiri ile ilişkileri.. --->
</cfif>--->

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PURCHASE" datasource="#new_dsn2_group#" result="ADD_PURCHASE_MAX_ID"> 
        	INSERT INTO
				SHIP
			(
				WRK_ID,
				PURCHASE_SALES,
				SHIP_NUMBER,
				SHIP_TYPE,
				PROCESS_CAT,
				DUE_DATE ,
				PAYMETHOD_ID, 
				<cfif isDefined("attributes.SHIP_METHOD") and len(attributes.SHIP_METHOD)>SHIP_METHOD,</cfif>
				SHIP_DATE,
				<cfif len(attributes.action_date) and attributes.action_date neq 'NULL'>ACTION_DATE,</cfif>
				<cfif len(attributes.company_id) and len(attributes.comp_name)>
					COMPANY_ID,
					PARTNER_ID,
				<cfelseif len(attributes.consumer_id)>
					CONSUMER_ID,
				<cfelse>
					EMPLOYEE_ID,
				</cfif>
				DELIVER_DATE,
				DELIVER_EMP,
				DELIVER_EMP_ID,
				DELIVER_PAR_ID,
				DISCOUNTTOTAL,
				NETTOTAL,
				GROSSTOTAL,
				TAXTOTAL,
				OTV_TOTAL,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				DEPARTMENT_IN,
				LOCATION_IN,
				RECORD_DATE,
				IS_WITH_SHIP,
				RECORD_EMP,
				REF_NO,
				CARD_PAYMETHOD_ID,
				CARD_PAYMETHOD_RATE,
				PROJECT_ID_IN,
                <cfif session.ep.our_company_info.project_followup eq 1>
	                PROJECT_ID,
                </cfif>
				SUBSCRIPTION_ID,
				SERVICE_ID,
				SHIP_DETAIL,
                CITY_ID,
                COUNTY_ID,
                DELIVER_COMP_ID,
                DELIVER_CONS_ID,
                SHIP_ADDRESS_ID,
                ADDRESS,
				IS_FROM_RETURN
				<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>,PROCESS_STAGE</cfif>
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SHIP_NUMBER#">,
				#get_process_type.PROCESS_TYPE#,
				#form.process_cat#,
				<cfif isdefined("ship_due_date") and len(ship_due_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#ship_due_date#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.SHIP_METHOD") and len(attributes.SHIP_METHOD)>
					#attributes.SHIP_METHOD#,
				</cfif>
				#attributes.ship_date#,
				<cfif len(attributes.action_date) and attributes.action_date neq 'NULL'><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.action_date#">,</cfif>
				<cfif len(attributes.company_id) and len(attributes.comp_name)>
					#attributes.company_id#,
					<cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
				<cfelseif len(attributes.consumer_id)>
					#attributes.consumer_id#,
				<cfelse>
					#attributes.employee_id#,
				</cfif>
				<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.deliver_get") and len(attributes.deliver_get)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(trim(attributes.deliver_get),50)#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id) and attributes.deliver_member_type eq "employee">#attributes.deliver_get_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.deliver_get_id") and len(attributes.deliver_get_id) and attributes.deliver_member_type eq "partner">#attributes.deliver_get_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_net_total")>#attributes.basket_net_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_gross_total")>#attributes.basket_gross_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_tax_total")>#attributes.basket_tax_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_otv_total") and len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>NULL</cfif>,
				<cfif isDefined("form.basket_money") and len(form.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#"><cfelse>NULL</cfif>,
				<cfif isDefined("form.BASKET_NET_TOTAL") and len(form.BASKET_NET_TOTAL)>#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#<cfelse>NULL</cfif>,
				#attributes.department_id#,
				#attributes.location_id#,
				#now()#,
				0,
				<cfif isDefined("session.pda")>#session.pda.userid#,<cfelse>#session.ep.userid#,</cfif><!--- pda den gelen kayıtlar için --->
				<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
					#attributes.card_paymethod_id#,
					<cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>
						#attributes.commission_rate#,
					<cfelse>
						NULL,
					</cfif>
				<cfelse>
					NULL,
					NULL,
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
                <cfif session.ep.our_company_info.project_followup eq 1>
					<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
                </cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.service_app_id") and len(attributes.service_app_id) and isDefined("attributes.service_app_no") and len(attributes.service_app_no)>#attributes.service_app_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ship_address_city_id") and len(attributes.ship_address_city_id)>#attributes.ship_address_city_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.deliver_comp_id") and len(attributes.deliver_comp_id)>#attributes.deliver_comp_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.deliver_cons_id") and len(attributes.deliver_cons_id)>#attributes.deliver_cons_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.ship_address") and len(attributes.ship_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_address#"><cfelse>NULL</cfif>,
				<cfif (isdefined("attributes.invent_return_row_ids") and listlen(attributes.invent_return_row_ids)) or (isdefined("attributes.kons_row_ids") and listlen(attributes.kons_row_ids))>1<cfelse>0</cfif>
				<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"></cfif>	
			)
		</cfquery>
		<cfset sr_row_id_list ="">
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfif isDefined("session.ep") and not isdefined("is_from_import")>
				<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and ( not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#')))>
					<cfset dsn_type=new_dsn2_group>
					<cfinclude template="../../objects/query/add_basket_spec.cfm">
				</cfif>
			</cfif>
			<cf_date tarih = 'attributes.deliver_date#i#'><!--- satırdaki teslim tarihi burada formatlanıyor, fakat stocks_row'a kayıt atılırken de aynı degerler kullanılıyor --->
			<cfinclude template="get_dis_amount.cfm">
			<cfquery name="ADD_SHIP_ROW" datasource="#new_dsn2_group#" result="xx">
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
				<cfif len(evaluate("attributes.price#i#"))>
					PRICE,
				</cfif>
					PURCHASE_SALES,
					DISCOUNT,
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
					DELIVER_DATE,				
					DELIVER_DEPT,
					DELIVER_LOC,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
				</cfif>
					LOT_NO,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,				
					PRICE_OTHER,
					OTHER_MONEY_GROSS_TOTAL,
				<cfif listfind('73,74',evaluate('ct_process_type_#attributes.process_cat#'),',')>
					COST_PRICE,
				</cfif>
					EXTRA_COST,
					ROW_ORDER_ID,
				<cfif listfind('73,74,75,77',get_process_type.PROCESS_TYPE) and isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)>
					RELATED_SHIP_ID,
					RELATED_SHIP_PERIOD,
				</cfif>
					DARA,
					DARALI,
					IS_PROMOTION,
					DISCOUNT_COST,
					UNIQUE_RELATION_ID,
					PROM_RELATION_ID,
					PRODUCT_NAME2,
					AMOUNT2,
					UNIT2,
					EXTRA_PRICE,
					EK_TUTAR_PRICE,<!--- iscilik birim maliyet --->
					EXTRA_PRICE_TOTAL,
					EXTRA_PRICE_OTHER_TOTAL,
					SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE,
					BASKET_EXTRA_INFO_ID,
					SELECT_INFO_EXTRA,
                	DETAIL_INFO_EXTRA,
					BASKET_EMPLOYEE_ID,
					LIST_PRICE,
					PRICE_CAT,
					CATALOG_ID,
					NUMBER_OF_INSTALLMENT,
					DUE_DATE,
					KARMA_PRODUCT_ID,
					OTV_ORAN,
					OTVTOTAL,
					SERVICE_ID,
                    WRK_ROW_ID,
                    WRK_ROW_RELATION_ID,
                    RELATED_ACTION_ID,
                    RELATED_ACTION_TABLE,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID,
                    ROW_WORK_ID
					<cfif listfind('76',evaluate('ct_process_type_#attributes.process_cat#'),',')>
						<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
						<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
						<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
						<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
					</cfif>
					<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
					<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
					<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
					<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
					<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
					<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
					<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name#i#'),250)#">,
					<cfif isdefined("attributes.paymethod_id#i#") and  len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#,<cfelse>NULL,</cfif>
					#ADD_PURCHASE_MAX_ID.IDENTITYCOL#,
					#evaluate("attributes.stock_id#i#")#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.amount#i#")#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
					<cfif isdefined("attributes.unit_id#i#") and len(evaluate("attributes.unit_id#i#"))>#evaluate("attributes.unit_id#i#")#,<cfelse>NULL,</cfif>
					#evaluate("attributes.tax#i#")#,
					<cfif len(evaluate("attributes.price#i#"))>
					#evaluate("attributes.price#i#")#,
					</cfif>
					0,
					#indirim1#,
					#indirim2#,
					#indirim3#,
					#indirim4#,
					#indirim5#,
					#indirim6#,
					#indirim7#,
					#indirim8#,
					#indirim9#,
					#indirim10#,
					#DISCOUNT_AMOUNT#,
					#evaluate("attributes.row_lasttotal#i#")#,
					#evaluate("attributes.row_nettotal#i#")#,
					#evaluate("attributes.row_taxtotal#i#")#,
					<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
						#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif isdefined('attributes.department_id') and len(attributes.department_id)>
						#attributes.department_id#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
						#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif isdefined('attributes.location_id') and len(attributes.location_id)>
						#attributes.location_id#,
					<cfelse>
						NULL,
					</cfif>
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
					#evaluate('attributes.spect_id#i#')#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_name#i#')#">,
				</cfif>
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
				<cfif listfind('73,74',evaluate('ct_process_type_#attributes.process_cat#'),',')>
					<!--- <cfif isdefined('attributes.cost_id#i#') and len(evaluate('attributes.cost_id#i#'))>#evaluate('attributes.cost_id#i#')#<cfelse>NULL</cfif>, --->
					<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
				</cfif>
					<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					#order_id_for_ship_row#, <!--- onceden order_id değişkeniyle atanıyordu --->
				<cfif listfind('73,74,75,77',get_process_type.PROCESS_TYPE) and isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)>
					<cfif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 2>#listfirst(evaluate("attributes.row_ship_id#i#"),';')#,<cfelse>NULL,</cfif>
					<cfif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 2>#listlast(evaluate("attributes.row_ship_id#i#"),';')#,<cfelse>NULL,</cfif>
				</cfif>
					<cfif isdefined('attributes.dara#i#') and len(evaluate('attributes.dara#i#'))>#evaluate('attributes.dara#i#')#,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.darali#i#') and len(evaluate('attributes.darali#i#'))>#evaluate('attributes.darali#i#')#,<cfelse>NULL,</cfif>
					0,
					<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
					<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>#evaluate('attributes.otv_oran#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.service_id') and len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
					<cfif listfind('76',evaluate('ct_process_type_#attributes.process_cat#'),',')>
						<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
						<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
						<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
						<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
					</cfif>
					<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
					<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
					<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
					<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
					<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
					<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
					<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
				)
			</cfquery>
			<cfset sr_row_id_list =listappend(sr_row_id_list,xx.IDENTITYCOL)>
            <cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
				<cfscript>
                    add_relation_rows(
                        action_type:'add',
                        action_dsn : '#new_dsn2_group#',
                        to_table:'SHIP',
                        from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
                        to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
                        from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
                        amount : Evaluate("attributes.amount#i#"),
                        to_action_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL,
                        from_action_id :Evaluate("attributes.related_action_id#i#")
                        );
                </cfscript>
            </cfif>
			<cfif isdefined("attributes.return_row_ids")><!--- Eğer iade irsaliyesiyle değişim ürünleri için bloke miktarlarını eski değerlerine çekiyor --->
				<cfquery name="UPD_STOCK" datasource="#new_dsn2_group#">
					UPDATE
						#dsn3_alias#.STOCK_STRATEGY
					SET
						BLOCK_STOCK_VALUE = ISNULL(BLOCK_STOCK_VALUE,0) - ISNULL(RETURN_BLOCK_VALUE,0)
					WHERE
						STOCK_ID = #evaluate("attributes.stock_id#i#")#
						AND STRATEGY_TYPE = 0
				</cfquery>
			</cfif>
			
            
			<!--- Burasi eklemede satir bazinda girilen serilerin belge numaralarini guncellemeyi sagliyor --->
			<cfquery name="upd_serial" datasource="#new_dsn2_group#">
				UPDATE
					#dsn3_alias#.SERVICE_GUARANTY_NEW
				SET
					PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ADD_PURCHASE_MAX_ID.IDENTITYCOL#">,
					SPECT_ID = <cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>#evaluate('attributes.spect_id#i#')#<cfelse>NULL</cfif>,
					PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ship_number#">,
					PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_type.process_type#">,
					PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
                    SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
                    DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.department_id#">,
                    LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
				WHERE
					WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#">
                    AND PROCESS_ID = 0
			</cfquery>
		</cfloop>
		<cfscript>
			if(get_process_type.IS_STOCK_ACTION eq 1)//Stok hareketi yapılsın
			{
				sr_product_id_list ="";
				sr_stock_id_list ="";
				sr_unit_list ="";
				sr_amount_list ="";
				sr_spec_id_list ="";
				sr_lot_no_list ="";
				sr_shelf_number_list ="";
				sr_manufact_code_list ="";
				sr_amount_other_list ="";
				sr_unit_other_list ="";
				sr_deliver_date_list ="";
				sr_row_width_list="";
				sr_row_height_list="";
				sr_row_depth_list="";
				sr_row_department_list="";
				sr_row_location_list="";
				if(isdefined('attributes.deliver_date_frm') and isdate(attributes.deliver_date_frm))
					sr_process_date_=attributes.deliver_date_frm;
				else
					sr_process_date_=attributes.ship_date;
				for(_ind_=1;_ind_ lte attributes.rows_;_ind_=_ind_+1)
				{
					if(evaluate('attributes.is_inventory#_ind_#') eq 1) //urun envantere dahilse stock hareketi yapar
					{
						sr_product_id_list = ListAppend(sr_product_id_list,Evaluate('attributes.product_id#_ind_#'),',');
						sr_stock_id_list = ListAppend(sr_stock_id_list,Evaluate('attributes.stock_id#_ind_#'),',');
						sr_unit_list = ListAppend(sr_unit_list,Evaluate('attributes.unit#_ind_#'),',');
						sr_amount_list = ListAppend(sr_amount_list,Evaluate('attributes.amount#_ind_#'),',');
						if(isdefined('attributes.spect_id#_ind_#') and len(Evaluate('attributes.spect_id#_ind_#')) )
							sr_spec_id_list = ListAppend(sr_spec_id_list,Evaluate('attributes.spect_id#_ind_#'),',');
						else
							sr_spec_id_list = ListAppend(sr_spec_id_list,0,',');
						if(isdefined('attributes.lot_no#_ind_#') and len(Evaluate('attributes.lot_no#_ind_#')) )
							sr_lot_no_list = ListAppend(sr_lot_no_list,Evaluate('attributes.lot_no#_ind_#'),',');
						else
							sr_lot_no_list = ListAppend(sr_lot_no_list,0,',');
						
						if(isdefined('attributes.shelf_number#_ind_#') and len(Evaluate('attributes.shelf_number#_ind_#')) )
							sr_shelf_number_list = ListAppend(sr_shelf_number_list,Evaluate('attributes.shelf_number#_ind_#'),',');
						else
							sr_shelf_number_list = ListAppend(sr_shelf_number_list,0,',');
						
						if(isdefined('attributes.manufact_code#_ind_#') and len(Evaluate('attributes.manufact_code#_ind_#')) )
							sr_manufact_code_list = ListAppend(sr_manufact_code_list,Evaluate('attributes.manufact_code#_ind_#'),',');
						else
							sr_manufact_code_list = ListAppend(sr_manufact_code_list,0,',');
						
						if(isdefined('attributes.amount_other#_ind_#') and len(Evaluate('attributes.amount_other#_ind_#')) )
							sr_amount_other_list = ListAppend(sr_amount_other_list,Evaluate('attributes.amount_other#_ind_#'),',');
						else
							sr_amount_other_list = ListAppend(sr_amount_other_list,0,',');
						
						if(isdefined('attributes.unit_other#_ind_#') and len(Evaluate('attributes.unit_other#_ind_#')) )
							sr_unit_other_list = ListAppend(sr_unit_other_list,Evaluate('attributes.unit_other#_ind_#'),',');
						else
							sr_unit_other_list = ListAppend(sr_unit_other_list,0,',');
						if(isdefined('attributes.deliver_date#_ind_#') and isdate(Evaluate('attributes.deliver_date#_ind_#')) )
							sr_deliver_date_list = ListAppend(sr_deliver_date_list,Evaluate('attributes.deliver_date#_ind_#'),',');
						else
							sr_deliver_date_list = ListAppend(sr_deliver_date_list,0,',');
						if(isdefined('attributes.row_width#_ind_#') and len(evaluate('attributes.row_width#_ind_#')) )
							sr_row_width_list = ListAppend(sr_row_width_list,evaluate('attributes.row_width#_ind_#'),',');
						else
							sr_row_width_list = ListAppend(sr_row_width_list,0,',');
						
						if(isdefined('attributes.row_height#_ind_#') and len(evaluate('attributes.row_height#_ind_#')) )
							sr_row_height_list = ListAppend(sr_row_height_list,evaluate('attributes.row_height#_ind_#'),',');
						else
							sr_row_height_list = ListAppend(sr_row_height_list,0,',');
					
						if(isdefined('attributes.row_depth#_ind_#') and len(evaluate('attributes.row_depth#_ind_#')) )
							sr_row_depth_list = ListAppend(sr_row_depth_list,Evaluate('attributes.row_depth#_ind_#'),',');
						else
							sr_row_depth_list = ListAppend(sr_row_depth_list,0,',');
						if(isdefined('attributes.deliver_dept#_ind_#') and listlen(evaluate('attributes.deliver_dept#_ind_#'),'-') eq 2 ) //teslim depo-lokasyon
						{
							sr_row_department_list=ListAppend(sr_row_department_list,listfirst(evaluate('attributes.deliver_dept#_ind_#'),'-') );
							sr_row_location_list=ListAppend(sr_row_location_list,listlast(evaluate('attributes.deliver_dept#_ind_#'),'-') );
						}
						else
						{
							sr_row_department_list=attributes.department_id;
							sr_row_location_list=attributes.location_id;
						}
					}
				}
				if(len(sr_product_id_list) and len(sr_stock_id_list))
				{
					if (not isdefined("function_off"))//Toplu Irsaliye Ekleme Islemleri Icın eklendi FBS 20091201
					add_stock_rows(
						sr_is_purchase_sales : 0,
						sr_stock_row_count : listlen(sr_stock_id_list,','), //attributes.rows_,
						sr_max_id :ADD_PURCHASE_MAX_ID.IDENTITYCOL,
						sr_department_id : attributes.department_id,
						sr_location_id : attributes.location_id,
						sr_process_date :sr_process_date_,
						sr_document_date : attributes.ship_date,
						sr_process_type : get_process_type.PROCESS_TYPE,
						sr_product_id_list: sr_product_id_list,
						sr_control_process_type : '73,74,75', // iade process type lar satıs ve alısa gore degisiyor, dikkat plz.
						sr_stock_id_list: sr_stock_id_list,
						sr_unit_list: sr_unit_list,
						sr_amount_list: sr_amount_list,
						sr_spec_id_list: sr_spec_id_list,
						sr_lot_no_list: sr_lot_no_list,
						sr_shelf_number_list:sr_shelf_number_list,
						sr_manufact_code_list:sr_manufact_code_list,
						sr_amount_other_list : sr_amount_other_list,
						sr_unit_other_list : sr_unit_other_list,
						sr_deliver_date_list :sr_deliver_date_list,
						sr_width_list:sr_row_width_list,
						sr_depth_list:sr_row_depth_list,
						sr_paper_row_id_list:sr_row_id_list,
						sr_height_list:sr_row_height_list,
						sr_row_department_id:sr_row_department_list,
						sr_row_location_id:sr_row_location_list,
						sr_dsn_type : new_dsn2_group
						
					);
				}
			}
				if(get_process_type.process_type eq 74 or get_process_type.process_type eq 73)//eğer iade irsaliyesi ise ilişkili satış iraliyelelerinin satış siparişleri bulunacak
				{
					if (not isdefined("function_off"))//Toplu Irsaliye Ekleme Islemleri Icın eklendi FBS 20091201
					get_related_order_row = cfquery(datasource : "#dsn2#", sqlstring : "SELECT  SRR.STOCK_ID, ORR.ORDER_ID,SR.SHIP_ID,SR.AMOUNT OLD_AMOUNT,SR.WRK_ROW_ID FROM #dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SR,SHIP_ROW SRR WHERE ORR.WRK_ROW_ID = SR.WRK_ROW_RELATION_ID AND SR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.SHIP_ID = #ADD_PURCHASE_MAX_ID.IDENTITYCOL#");
					for(kk_order=1;kk_order<=get_related_order_row.recordcount;kk_order++)
					{
						get_total_ship_amount = cfquery(datasource : "#dsn2#", sqlstring : "SELECT SUM(SRR.AMOUNT) AMOUNT FROM SHIP_ROW SRR WHERE SRR.WRK_ROW_RELATION_ID='#get_related_order_row.WRK_ROW_ID#'");
						if(get_total_ship_amount.recordcount and len(get_total_ship_amount.amount))
							amount_new = get_related_order_row.old_amount - get_total_ship_amount.amount;
						else
							amount_new = get_related_order_row.old_amount;
						if(amount_new lt 0) amount_new = 0;
						upd_row = cfquery(datasource : "#dsn2#",is_select:0, sqlstring : "UPDATE #dsn3_alias#.ORDER_ROW_RESERVED SET STOCK_OUT = #amount_new# WHERE ORDER_ID = #get_related_order_row.order_id[kk_order]# AND SHIP_ID = #get_related_order_row.ship_id[kk_order]# AND PERIOD_ID=#session.ep.period_id# AND STOCK_ID = #get_related_order_row.STOCK_ID[kk_order]#");
						add_reserve_row(
							reserve_order_id:get_related_order_row.order_id[kk_order],
							related_process_id : get_related_order_row.ship_id[kk_order],
							reserve_action_type:1,
							reserve_process_type:74,
							control_stockid: get_related_order_row.STOCK_ID[kk_order],
							reserve_action_iptal : 0,
							is_order_process:1,
							is_purchase_sales:0,
							is_stock_row_action :get_process_type.IS_STOCK_ACTION,
							process_db :dsn2
							);
					}
				}
				if(isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)) //irsaliyeye cekilen konsinye irsaliye veya toptan satis iade varsa
				{
					if (not isdefined("function_off"))//Toplu Irsaliye Ekleme Islemleri Icın eklendi FBS 20091201
					add_ship_row_relation(
						to_related_process_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL,
						to_related_process_type : get_process_type.PROCESS_TYPE,
						ship_related_action_type:0,
						is_invoice_ship:1,
						process_db :new_dsn2_group
						);
				}
				
				if(isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)) //irsaliyeye cekilen siparis varsa
				{
					if (not isdefined("function_off"))//Toplu Irsaliye Ekleme Islemleri Icın eklendi FBS 20091201
					add_reserve_row(
						reserve_order_id:attributes.order_id_listesi,
						related_process_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL,
						reserve_action_type:0,
						is_order_process:1,
						is_purchase_sales:0,
						is_stock_row_action : get_process_type.IS_STOCK_ACTION,
						process_db :new_dsn2_group
						);
				}
				if(not isDefined("session.ep")) // pda den gelen kayıtlar için
					if (not isdefined("function_off"))//Toplu Irsaliye Ekleme Islemleri Icın eklendi FBS 20091201
						include('get_basket_money_js.cfm','\objects\functions');
			basket_kur_ekle(action_id:ADD_PURCHASE_MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0,basket_money_db:new_dsn2_group);
		</cfscript>		
		<!---demirbaş iade islemleri --->
		<cfif get_process_type.is_add_inventory eq 1>
			<cfinclude template="add_return_inventory.cfm">
		</cfif>
		<!--- secilen islem kategorisine bir action file eklenmisse --->
			<cfif listgetat(attributes.fuseaction,1,'.') is 'service'>
				<cfset new_fuse_ = "service.popup_upd_purchase_ship">
			<cfelse>
				<cfset new_fuse_ = "#listgetat(attributes.fuseaction,1,'.')#.form_add_purchase&event=upd">
			</cfif>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#ADD_PURCHASE_MAX_ID.IDENTITYCOL#"
				action_table="SHIP"
				action_column="SHIP_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#new_fuse_#&ship_id=#ADD_PURCHASE_MAX_ID.IDENTITYCOL#'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#new_dsn2_group#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		<cfset last_ship_id_sale = ADD_PURCHASE_MAX_ID.IDENTITYCOL>
		<cfif not isdefined("first_ship_id")>
			<cfset first_ship_id = ADD_PURCHASE_MAX_ID.IDENTITYCOL>
		</cfif>

		<!--- E-İrsaliye Onay islemi--->
		<cfinclude template="../../e_government/query/eshipment_approval.cfm" />
		
         <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#ADD_PURCHASE_MAX_ID.IDENTITYCOL#" action_name="#SHIP_NUMBER# Eklendi" paper_no="#SHIP_NUMBER#"  period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#new_dsn2_group#">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
	<cf_workcube_process 
			is_upd='1' 
			data_source='#new_dsn2_group#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='SHIP'
			action_column='SHIP_ID'
			action_id='#ADD_PURCHASE_MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=stock.form_add_purchase&event=upd&SHIP_ID=#ADD_PURCHASE_MAX_ID.IDENTITYCOL#'
			warning_description='Alış İrsaliyesi : #SHIP_NUMBER#' >
</cfif>			
<!---Ek Bilgiler--->
<cfset attributes.info_id = ADD_PURCHASE_MAX_ID.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -14>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cfset attributes.actionId = ADD_PURCHASE_MAX_ID.IDENTITYCOL>
<cfif isdefined('attributes.service_stock_id') and len(attributes.service_stock_id) and isdefined('attributes.service_serial_no') and len(attributes.service_serial_no)> <!--- servis basvuru eklemeden cagrılmıssa --->
	<cfquery name="GET_PRO_GUARANTY" datasource="#dsn3#">
		SELECT
			SGN.SALE_START_DATE,
			SGN.SALE_GUARANTY_CATID,
			(SELECT SGT.GUARANTYCAT_TIME FROM #dsn_alias#.SETUP_GUARANTYCAT_TIME SGT WHERE SGT.GUARANTYCAT_TIME_ID = SG.GUARANTYCAT_TIME) GUARANTYCAT_TIME
		FROM
			SERVICE_GUARANTY_NEW SGN,
			#dsn_alias#.SETUP_GUARANTY AS SG
		WHERE
			SGN.SALE_GUARANTY_CATID=SG.GUARANTYCAT_ID AND
			SGN.IS_SALE = 1 AND
			SGN.SALE_START_DATE IS NOT NULL AND
			SGN.STOCK_ID = #attributes.service_stock_id# AND
			SGN.SERIAL_NO = '#attributes.service_serial_no#'
	</cfquery>
	<cfif GET_PRO_GUARANTY.recordcount>
		<cfif not isdefined("function_off")><!--- Toplu Irsaliye Ekleme Islemleri Icın eklendi FBS 20091201 --->
			<cfinclude template="../../objects/functions/add_serial_no.cfm">
		</cfif>
		<cfset attributes.serial_no_start_number1 = attributes.service_serial_no>
		<cfset attributes.stock_id1 = attributes.service_stock_id>
		<cfset attributes.guaranty_purchasesales1 = 0>
		<cfset attributes.guaranty_cat1 = GET_PRO_GUARANTY.SALE_GUARANTY_CATID>
		<cfset attributes.guaranty_startdate1 = GET_PRO_GUARANTY.SALE_START_DATE>
		<cfset temp_start_date = GET_PRO_GUARANTY.SALE_START_DATE>
		<cfif len(temp_start_date) and isdate(temp_start_date) and len(GET_PRO_GUARANTY.GUARANTYCAT_TIME)>
			<cfset temp_date = date_add("m", GET_PRO_GUARANTY.GUARANTYCAT_TIME, temp_start_date)>
		</cfif>
		<cf_date tarih="temp_start_date">
		<cfscript>
			add_serial_no(
			session_row : 1,
			process_type : get_process_type.PROCESS_TYPE, 
			process_number : SHIP_NUMBER,
			process_id : ADD_PURCHASE_MAX_ID.IDENTITYCOL,
			dpt_id : attributes.department_id,
			loc_id : attributes.location_id,
			par_id : attributes.partner_id,
			con_id : attributes.consumer_id,
			main_stock_id : '',
			comp_id : attributes.company_id
			);
		</cfscript>
	</cfif>
</cfif>
<cfif isdefined("attributes.return_row_ids")>
	<cfquery name="upd_" datasource="#dsn3#">
		UPDATE 
			SERVICE_PROD_RETURN_ROWS 
		SET 
			IS_SHIP = 1,
			RETURN_SHIP_ID = #ADD_PURCHASE_MAX_ID.IDENTITYCOL#,
			RETURN_SHIP_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SHIP_NUMBER#">,
			RETURN_PERIOD_ID = #session.ep.period_id#
		WHERE
			RETURN_ROW_ID IN (#attributes.return_row_ids#)
	</cfquery>
</cfif>
<cfif attributes.fuseaction is 'stock.emptypopup_add_multi_packetship_to_ship' and len(attributes.paper_number)>
	<cfquery name="UPD_PAPERS" datasource="#new_dsn3_group#">
		UPDATE 
			PAPERS_NO 
		SET 
			SHIP_NUMBER = #attributes.paper_number# 
		WHERE 
		<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
			PRINTER_ID = #attributes.paper_printer_id#
		<cfelse>
			EMPLOYEE_ID = #SESSION.EP.USERID#
		</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.receiving_detail_id") and len(attributes.receiving_detail_id)>
	<script type="text/javascript">
		wrk_opener_reload();
	</script>
</cfif>
<cfif not(isdefined('xml_import') and xml_import eq 1)>
	<cfif isDefined("session.ep") and session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonleniyor cunku cost_action locationda calismiyor --->
		<cfscript>cost_action(action_type:2,action_id:ADD_PURCHASE_MAX_ID.IDENTITYCOL,query_type:1);</cfscript>
	<cfelseif get_process_type.is_add_inventory eq 1 and isDefined("session.ep") and session.ep.our_company_info.is_cost eq 1 and isdefined("get_inventory_type.is_cost") and get_inventory_type.is_cost eq 1 and isdefined("get_s_id.max_id")><!--- sirket maliyet takip ediliyorsa not js le yonleniyor cunku cost_action locationda calismiyor --->
		<cfscript>cost_action(action_type:3,action_id:get_s_id.max_id,query_type:1);</cfscript>
	</cfif>
    <cfif not listfindnocase('stock.emptypopup_add_multi_packetship_to_ship,objects.emptypopupflush_xml_import_ship_purchase_query',attributes.fuseaction,',')>
		<script type="text/javascript">
			<cfif listgetat(attributes.fuseaction,1,'.') is 'service'>
				window.location.href = '<cfoutput>#request.self#?fuseaction=service.popup_check_service_ships&service_id=#attributes.service_id#</cfoutput>';
			<cfelse>
				window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_purchase&event=upd&ship_id=#first_ship_id#</cfoutput>";
			</cfif> 
		</script>
    </cfif>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

