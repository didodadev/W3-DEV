<cfdump var="#form.active_company# - #session.ep.company_id#">
<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='213.İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif not isdefined("attributes.rows_") or attributes.rows_ lte 0>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='313.Ürün Seçmediniz Lütfen Ürün Seçiniz'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
	<cfquery name="get_type" datasource="#dsn3#">
		SELECT PROCESS_TYPE,PROCESS_CAT_ID,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_BUDGET_RESERVED_CONTROL FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
	</cfquery>
	<cfquery name="GET_PAPER" datasource="#DSN3#">
		SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.order_id#">
	</cfquery>
<cfscript>
	attributes.currency_multiplier = '';
	paper_currency_multiplier ='';
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				attributes.currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is form.basket_money)
				paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
		butce_sil(action_id:FORM.order_id,process_type:get_type.PROCESS_TYPE,reserv_type:1);
</cfscript>
</cfif>

<!--- History --->
<cfset attributes.order_id = FORM.ORDER_ID>
<cfinclude template="add_order_history.cfm">
<!--- //History --->
<cf_xml_page_edit fuseact="purchase.detail_order">
<cf_date tarih = "attributes.basket_due_value_date_">
<cf_date tarih = "attributes.order_date">
<!--- irsaliye tarihine gore ortalama vade tarihi --->
<cfset order_due_date = attributes.basket_due_value_date_> 
<cfif isdefined("attributes.deliverdate") and isdate(attributes.deliverdate)><cf_date tarih = "attributes.deliverdate"></cfif>
<cfif isdefined("attributes.publishdate") and isdate(attributes.publishdate)><cf_date tarih = "attributes.publishdate"></cfif>
<cflock name="#CreateUUID()#" timeout="40">
  <cftransaction>
	<cfscript>
        add_relation_rows(
            action_type:'del',
            action_dsn : '#dsn3#',
            to_table:'ORDERS',
			to_action_id : attributes.order_id
            );
	</cfscript>
	<!--- Sözleşme eski ID için kullanıldı mcifci --->
	<cfquery name="get_old_contract" datasource="#dsn3#">
		SELECT CONTRACT_ID FROM ORDERS WHERE ORDER_ID = #attributes.order_id#
	</cfquery>

	<cfquery name="UPD_OFFER" datasource="#DSN3#">
		UPDATE 
			ORDERS 
		SET
			ORDER_STATUS = <cfif isDefined("ORDER_STATUS")>1<cfelse>0</cfif>,
			ORDER_DATE = #attributes.order_date#,
			ORDER_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#,<cfelse>NULL,</cfif>
			DELIVER_DEPT_ID = <cfif isdefined("form.deliver_dept_id") and len(form.deliver_dept_id) and len(form.deliver_dept_name)>#form.deliver_dept_id#<cfelse>NULL</cfif>,
			LOCATION_ID = <cfif isdefined("form.deliver_loc_id") and len(form.deliver_loc_id) and len(form.deliver_dept_name)>#form.deliver_loc_id#<cfelse>NULL</cfif>,
			SHIP_ADDRESS = <cfif isdefined("attributes.ship_address") and len(attributes.ship_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_address#"><cfelse>NULL</cfif>,
			SHIP_ADDRESS_ID = <cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
			CITY_ID = <cfif isdefined("attributes.ship_address_city_id") and len(attributes.ship_address_city_id)>#attributes.ship_address_city_id#<cfelse>NULL</cfif>,
			COUNTY_ID = <cfif isdefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#<cfelse>NULL</cfif>,
			DELIVERDATE = <cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
			PUBLISHDATE = <cfif len(attributes.publishdate)>#attributes.publishdate#<cfelse>NULL</cfif>,
			INCLUDED_KDV = <cfif isdefined("form.INCLUDED_KDV")>1<cfelse>0</cfif>,
			PAYMETHOD = <cfif isdefined("form.paymethod_id") and len(form.paymethod_id) and len(form.pay_method)>#form.paymethod_id#<cfelse>NULL</cfif>,
			INVISIBLE = <cfif isDefined("FORM.INVISIBLE")>1<cfelse>0</cfif>,
			PARTNER_ID = <cfif len(FORM.PARTNER_ID)>#FORM.PARTNER_ID#<cfelse>NULL</cfif>,
			COMPANY_ID = <cfif len(FORM.COMPANY_ID)>#FORM.COMPANY_ID#<cfelse>NULL</cfif>,
			CONSUMER_ID = <cfif len(FORM.CONSUMER_ID)>#FORM.CONSUMER_ID#<cfelse>NULL</cfif>,
			OTHER_MONEY = <cfif isDefined("FORM.basket_money")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,<cfelse> NULL,</cfif>
			OTHER_MONEY_VALUE = #((form.basket_net_total*form.basket_rate1)/form.basket_rate2)#,
			TAX = <cfif isDefined("FORM.TAX")>#FORM.TAX#<cfelse>NULL</cfif>,
			PRIORITY_ID = #FORM.PRIORITY_ID#,
			ORDER_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ORDER_HEAD#">,
			ORDER_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ORDER_DETAIL#">,
			DUE_DATE = <cfif isdefined("order_due_date") and len(order_due_date)>#order_due_date#<cfelse>NULL</cfif>,
			RESERVED = <cfif isDefined('attributes.RESERVED')>1<cfelse>0</cfif>,
			SHIP_METHOD = <cfif isdefined("attributes.ship_method_id") and len(attributes.ship_method_id) and len(trim(attributes.ship_method_name))>#attributes.ship_method_id#<cfelse>NULL</cfif>,
			NETTOTAL = <cfif isdefined("form.basket_net_total") and len(form.basket_net_total)>#form.basket_net_total#<cfelse>NULL</cfif>,
			TAXTOTAL = <cfif isdefined("form.basket_tax_total") and len(form.basket_tax_total)>#form.basket_tax_total#<cfelse>NULL</cfif>,
			DISCOUNTTOTAL = <cfif isdefined("form.basket_discount_total") and len(form.basket_discount_total)> #form.basket_discount_total#<cfelse>NULL</cfif>,
			GROSSTOTAL = <cfif isdefined("form.basket_gross_total") and len(form.basket_gross_total)>#form.basket_gross_total#<cfelse>NULL</cfif>,
			PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and LEN(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
			CATALOG_ID = <cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id) and len(attributes.catalog_name)>#attributes.catalog_id#<cfelse>NULL</cfif>,
			ORDER_EMPLOYEE_ID = <cfif isdefined("attributes.order_employee_id") and len(attributes.order_employee_id)>#attributes.order_employee_id#<cfelse>NULL</cfif>,
			REF_NO  = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
				CARD_PAYMETHOD_ID= #attributes.card_paymethod_id#,
				CARD_PAYMETHOD_RATE = <cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>#attributes.commission_rate#,<cfelse>NULL,</cfif>
			<cfelse>
				CARD_PAYMETHOD_ID= NULL,
				CARD_PAYMETHOD_RATE = NULL,
			</cfif>
			WORK_ID = <cfif isdefined("attributes.work_id") and len(attributes.work_id)>#attributes.work_id#<cfelse>NULL</cfif>,
            IS_FOREIGN = <cfif isdefined("attributes.is_foreign")>1<cfelse>0</cfif>,
			UPDATE_DATE = #NOW()#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			UPDATE_EMP = #SESSION.EP.USERID#,
			CONTRACT_ID	= <cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>,
			PROCESS_CAT =<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"><cfelse>NULL</cfif>,
			SA_DISCOUNT = <cfif isdefined("attributes.genel_indirim") and len(attributes.genel_indirim)>#attributes.genel_indirim#<cfelse>NULL</cfif>
		WHERE 
			ORDER_ID = #FORM.ORDER_ID#
	</cfquery>

	<cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>
		<!--- Eski sözleşmeden sipariş bağlantısı çıkartılıyor --->
		<cfif Len(get_old_contract.CONTRACT_ID) And get_old_contract.CONTRACT_ID Neq attributes.contract_id>
			<cfquery name="get_contract" datasource="#dsn3#">
				SELECT ORDER_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_old_contract.CONTRACT_ID#
			</cfquery>
			<cfset old_list = '' />
			<cfloop from="1" to="#listlen(get_contract.ORDER_ID)#" index="sayac">
				<cfif len(ListGetAt(get_contract.ORDER_ID,sayac,',')) and not listfind(old_list,ListGetAt(get_contract.ORDER_ID,sayac,','),',')>
					<cfset old_list = Listappend(old_list,ListGetAt(get_contract.ORDER_ID,sayac,','),',') />
				</cfif>
			</cfloop>
			<cfif listFind(old_list,attributes.order_id)>
				<cfset old_list = listDeleteAt(old_list,listFind(old_list,attributes.order_id)) />
				<cfquery datasource="#dsn3#">
					UPDATE RELATED_CONTRACT SET ORDER_ID = ',#old_list#,' WHERE CONTRACT_ID = #get_old_contract.CONTRACT_ID#
				</cfquery>
			</cfif>
		</cfif>
		<!---// Eski sözleşmeden sipariş bağlantısı çıkartılıyor --->
		<!--- Yeni sözleşmeye sipariş bağlantısı ekleniyor --->
		<cfquery name="get_contracts" datasource="#dsn3#">
			SELECT ORDER_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
		</cfquery>
		<cfset related_list = '' />
		<cfloop from="1" to="#listlen(get_contracts.ORDER_ID)#" index="sayac">
			<cfif len(ListGetAt(get_contracts.ORDER_ID,sayac,',')) and not listfind(related_list,ListGetAt(get_contracts.ORDER_ID,sayac,','),',')>
				<cfset related_list = Listappend(related_list,ListGetAt(get_contracts.ORDER_ID,sayac,','),',') />
			</cfif>
		</cfloop>
		<cfscript>
			related_list = Listappend(related_list,attributes.order_id);
			related_list = ListSort(ListDeleteDuplicates(related_list),"numeric","asc",",");
			new_related_id  = '';
			if (ListLen(get_contracts.ORDER_ID) Eq 0) {
				new_related_id = ',';
			}
			new_related_id	= '#new_related_id##get_contracts.ORDER_ID##attributes.order_id#,';
		</cfscript>
		<cfquery datasource="#dsn3#">
			UPDATE RELATED_CONTRACT SET ORDER_ID = '#related_list#' WHERE CONTRACT_ID = #attributes.contract_id#
		</cfquery>
		<!---// Yeni sözleşmeye sipariş bağlantısı ekleniyor --->
	<cfelseif Len(get_old_contract.CONTRACT_ID)>
		<cfquery name="get_contract" datasource="#dsn3#">
			SELECT ORDER_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_old_contract.CONTRACT_ID#
		</cfquery>
		<cfset old_list = '' />
		<cfloop from="1" to="#listlen(get_contract.ORDER_ID)#" index="sayac">
			<cfif len(ListGetAt(get_contract.ORDER_ID,sayac,',')) and not listfind(old_list,ListGetAt(get_contract.ORDER_ID,sayac,','),',')>
				<cfset old_list = Listappend(old_list,ListGetAt(get_contract.ORDER_ID,sayac,','),',') />
			</cfif>
		</cfloop>
		<cfif listFind(old_list,attributes.order_id)>
			<cfset old_list = listDeleteAt(old_list,listFind(old_list,attributes.order_id)) />
			<cfquery datasource="#dsn3#">
				UPDATE RELATED_CONTRACT SET ORDER_ID = ',#old_list#,' WHERE CONTRACT_ID = #get_old_contract.CONTRACT_ID#
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- urun asortileri siliniyor --->
	<cfquery name="DEL_ORDER_ASSORT_ROWS" datasource="#DSN3#">
		DELETE FROM
			PRODUCTION_ASSORTMENT
		WHERE
			ACTION_TYPE = 2 AND 
			ASSORTMENT_ID IN
			(
			SELECT
				 ORDER_ROW_ID 
			FROM
				ORDER_ROW
			WHERE
				ORDER_ID = #FORM.ORDER_ID#			
			)
	</cfquery>
	<!---  uruna sortileri  --->
	<cfset order_row_id_list_ = ''>
	<cfloop from="1" to="#attributes.rows_#" index="i">
		<cf_date tarih="attributes.deliver_date#i#">
		<cf_date tarih="attributes.reserve_date#i#">
		<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1>
			<cfset specer_spec_id=''>
            <cfset dsn_type=dsn3>
			<cfif not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
				<cfinclude template="../../objects/query/add_basket_spec.cfm">
			<cfelseif attributes.basket_spect_type eq 7 ><!--- satırdada guncellenebilmeli bu spec tipinde--->
				<cfset specer_spec_id=evaluate('attributes.spect_id#i#')>
				<cfinclude template="../../objects/query/add_basket_spec.cfm">
			</cfif>
		</cfif>
		<cfif len(evaluate('attributes.action_row_id#i#')) and evaluate('attributes.action_row_id#i#') neq 0><!--- yeni eklenmis bir satır degilse --->
			<cfquery name="UPD_ORDER_ROW" datasource="#DSN3#"><!--- eski satır update --->
				UPDATE
					ORDER_ROW
				SET
					ORDER_ID = #FORM.ORDER_ID#,
					ROW_INTERNALDEMAND_ID = <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
					RELATED_INTERNALDEMAND_ROW_ID = <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and listlen(evaluate('attributes.row_ship_id#i#'),";") eq 2 and len(listgetat(evaluate('attributes.row_ship_id#i#'),2,';'))>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelse>NULL</cfif>,
					ROW_PRO_MATERIAL_ID = <cfif isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
					PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
					PRODUCT_ID = #evaluate('attributes.product_id#i#')#,
					STOCK_ID = #evaluate('attributes.stock_id#i#')#,
					QUANTITY = #evaluate('attributes.amount#i#')#,
					UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
					UNIT_ID = #evaluate("attributes.unit_id#i#")#,
					PRICE = #evaluate("attributes.price#i#")#,
					TAX = #evaluate("attributes.tax#i#")#,
                    <cfif isdefined("x_apply_deliverdate_to_rows") and x_apply_deliverdate_to_rows eq 1 and not (isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#')))>
						DELIVER_DATE = <cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
                    <cfelse>    
						DELIVER_DATE = <cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
					</cfif>                        
					<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
						DELIVER_DEPT=#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif isdefined('attributes.deliver_dept_id') and len(attributes.deliver_dept_id)>
						DELIVER_DEPT=#attributes.deliver_dept_id#,
					<cfelse>
						DELIVER_DEPT=NULL,
					</cfif>
					<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
						DELIVER_LOCATION=#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif isdefined('attributes.deliver_loc_id') and len(attributes.deliver_loc_id)>
						DELIVER_LOCATION=#attributes.deliver_loc_id#,
					<cfelse>
						DELIVER_LOCATION=NULL,
					</cfif>
					DISCOUNT_1=<cfif isdefined('attributes.indirim1#i#')>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_2=<cfif isdefined('attributes.indirim2#i#')>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_3=<cfif isdefined('attributes.indirim3#i#')>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_4=<cfif isdefined('attributes.indirim4#i#')>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_5=<cfif isdefined('attributes.indirim5#i#')>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_6=<cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_7=<cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_8=<cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_9=<cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
					DISCOUNT_10=<cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
					OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#">,
					OTHER_MONEY_VALUE=<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						SPECT_VAR_ID=#evaluate('attributes.spect_id#i#')#,
						SPECT_VAR_NAME=<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
					<cfelse>
						SPECT_VAR_ID=NULL,
						SPECT_VAR_NAME=NULL,
					</cfif>
					LOT_NO=<cfif isdefined('attributes.lot_no#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
					PRICE_OTHER=<cfif isdefined('attributes.price_other#i#')>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
					IS_PROMOTION=<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
					NETTOTAL=<cfif isdefined("attributes.row_nettotal#i#") and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
					ORDER_ROW_CURRENCY=<cfif isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#"))>#evaluate("attributes.order_currency#i#")#<cfelse>-1</cfif>,
					RESERVE_TYPE=<cfif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#")) and isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#")) and evaluate("attributes.order_currency#i#") eq -9>-3<cfelseif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#"))>#evaluate("attributes.reserve_type#i#")#<cfelse>-1</cfif>,
					RESERVE_DATE=<cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
					COST_PRICE=<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
					EXTRA_COST=<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					DISCOUNT_COST=<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
					UNIQUE_RELATION_ID=<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
					PROM_RELATION_ID=<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
					PRODUCT_NAME2=<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
					AMOUNT2=<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					UNIT2=<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
					MARJ=<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#,<cfelse>0,</cfif>
					EXTRA_PRICE=<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
					EK_TUTAR_PRICE=<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
					EXTRA_PRICE_TOTAL=<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
					EXTRA_PRICE_OTHER_TOTAL=<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
					SHELF_NUMBER=<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					PRODUCT_MANUFACT_CODE=<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
					BASKET_EXTRA_INFO_ID=<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
					SELECT_INFO_EXTRA=<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
					DETAIL_INFO_EXTRA=<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
					BASKET_EMPLOYEE_ID=<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
					PRICE_CAT=<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
					CATALOG_ID = <cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
					LIST_PRICE=<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
					NUMBER_OF_INSTALLMENT=<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
					DUEDATE=<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate('attributes.duedate#i#')#<cfelse>0</cfif>,
					KARMA_PRODUCT_ID=<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
					OTV_ORAN=<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
					OTVTOTAL=<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
					WRK_ROW_ID=<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
					WRK_ROW_RELATION_ID=<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
					RELATED_ACTION_ID=<cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
					RELATED_ACTION_TABLE=<cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
					WIDTH_VALUE=<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
					DEPTH_VALUE=<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
					HEIGHT_VALUE=<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
					ROW_PROJECT_ID = <cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
                    ROW_WORK_ID = <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
					<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>
					,EXPENSE_CENTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>
					,EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>
					,ACTIVITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>
					,ACC_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>
					,SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>
					,ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>
					,BSMV_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>
					,BSMV_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>
					,BSMV_CURRENCY = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>
					,OIV_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>
					,OIV_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>
					,TEVKIFAT_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#">
					</cfif>
					<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>
					,TEVKIFAT_AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#">
					</cfif>
				WHERE
					ORDER_ID=#attributes.order_id#
					AND ORDER_ROW_ID=#evaluate('attributes.action_row_id#i#')#
			</cfquery>
			<cfset attributes.ROW_MAIN_ID = evaluate('attributes.action_row_id#i#')>
		<cfelse>
			<cfquery name="ADD_PRODUCT_TO_OFFER" datasource="#DSN3#">
				INSERT INTO 
					ORDER_ROW 
					(
					ORDER_ID, 
					ROW_INTERNALDEMAND_ID,
					RELATED_INTERNALDEMAND_ROW_ID,
					ROW_PRO_MATERIAL_ID,
					PRODUCT_NAME,
					PRODUCT_ID,
					STOCK_ID,
					QUANTITY,
					UNIT,
					UNIT_ID,
					PRICE,
					TAX,
					DELIVER_DATE,
					DELIVER_DEPT,
					DELIVER_LOCATION,
					DISCOUNT_1,
					DISCOUNT_2,
					DISCOUNT_3,
					DISCOUNT_4,
					DISCOUNT_5,					
					DISCOUNT_6,
					DISCOUNT_7,
					DISCOUNT_8,
					DISCOUNT_9,
					DISCOUNT_10,						
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
					LOT_NO,
					PRICE_OTHER,
					IS_PROMOTION,
					NETTOTAL,
					ORDER_ROW_CURRENCY,
					RESERVE_TYPE,
					RESERVE_DATE,
					COST_PRICE,
					EXTRA_COST,
					DISCOUNT_COST,
					UNIQUE_RELATION_ID,
					PROM_RELATION_ID,
					PRODUCT_NAME2,
					AMOUNT2,
					UNIT2,
					MARJ,
					EXTRA_PRICE,
					EK_TUTAR_PRICE,<!--- iscilik birim maliyet --->
					EXTRA_PRICE_TOTAL,
					EXTRA_PRICE_OTHER_TOTAL,
					SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE,
					BASKET_EXTRA_INFO_ID,
					BASKET_EMPLOYEE_ID,
					PRICE_CAT,
					CATALOG_ID,
					LIST_PRICE,
					NUMBER_OF_INSTALLMENT,
					DUEDATE,
					KARMA_PRODUCT_ID,
					OTV_ORAN,
					OTVTOTAL,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID,
					RELATED_ACTION_ID,
					RELATED_ACTION_TABLE,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID,
                    ROW_WORK_ID
					<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
					<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
					<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
					<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
					<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
					<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
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
					#FORM.ORDER_ID#,
					<cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list) and isdefined("attributes.row_ship_id#i#") and listlen(evaluate('attributes.row_ship_id#i#'),";") eq 2 and len(listgetat(evaluate('attributes.row_ship_id#i#'),2,';'))>#listgetat(evaluate('attributes.row_ship_id#i#'),2,';')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list) and isdefined("attributes.row_ship_id#i#") and len(evaluate('attributes.row_ship_id#i#')) and listfirst(evaluate('attributes.row_ship_id#i#'),';') neq 0>#listfirst(evaluate('attributes.row_ship_id#i#'),';')#<cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
						#evaluate('attributes.product_id#i#')#,
						#evaluate('attributes.stock_id#i#')#,
						#evaluate('attributes.amount#i#')#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
						#evaluate("attributes.unit_id#i#")#,
						#evaluate("attributes.price#i#")#,
						#evaluate("attributes.tax#i#")#,
					<cfif isdefined("x_apply_deliverdate_to_rows") and x_apply_deliverdate_to_rows eq 1 and not (isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#')))>
						<cfif len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
					<cfelse>                    
						<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
					</cfif>
					<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
						#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif isdefined("attributes.deliver_dept_id") and len(attributes.deliver_dept_id)>
						#attributes.deliver_dept_id#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
						#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
					<cfelseif isdefined("attributes.deliver_loc_id") and len(attributes.deliver_loc_id)>
						#attributes.deliver_loc_id#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined('attributes.indirim1#i#') and len(evaluate("attributes.indirim1#i#"))>#evaluate('attributes.indirim1#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim2#i#') and len(evaluate("attributes.indirim2#i#"))>#evaluate('attributes.indirim2#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim3#i#') and len(evaluate("attributes.indirim3#i#"))>#evaluate('attributes.indirim3#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim4#i#') and len(evaluate("attributes.indirim4#i#"))>#evaluate('attributes.indirim4#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim5#i#') and len(evaluate("attributes.indirim5#i#"))>#evaluate('attributes.indirim5#i#')#<cfelse>NULL</cfif>,					
					<cfif isdefined('attributes.indirim6#i#')>#evaluate('attributes.indirim6#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim7#i#')>#evaluate('attributes.indirim7#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim8#i#')>#evaluate('attributes.indirim8#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim9#i#')>#evaluate('attributes.indirim9#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.indirim10#i#')>#evaluate('attributes.indirim10#i#')#<cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#">,
					<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>#evaluate('attributes.spect_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.spect_name#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#"><cfelse>NULL</cfif>,			
					<cfif isdefined('attributes.lot_no#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_other#i#') and len(evaluate("attributes.price_other#i#"))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
						0,
					<cfif isdefined("attributes.row_nettotal#i#") and len(evaluate("attributes.row_nettotal#i#"))>#evaluate("attributes.row_nettotal#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.order_currency#i#") and len(evaluate("attributes.order_currency#i#"))>#evaluate("attributes.order_currency#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.reserve_type#i#") and len(evaluate("attributes.reserve_type#i#"))>#evaluate("attributes.reserve_type#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.reserve_date#i#") and isdate(evaluate('attributes.reserve_date#i#'))>#evaluate('attributes.reserve_date#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))>#evaluate('attributes.basket_extra_info#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
					<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
					<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
					<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
					<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
					<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
					<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
					<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
					<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
					<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
					<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
					<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
					<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
					<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
					<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
					)
			</cfquery>
			<cfquery name="get_max_order_row" datasource="#DSN3#">
				SELECT MAX(ORDER_ROW_ID) AS ORDER_ROW_ID FROM ORDER_ROW
			</cfquery>
			<cfset attributes.ROW_MAIN_ID = get_max_order_row.ORDER_ROW_ID>
		</cfif>
        <!---Ek Bilgiler--->
        <cfset attributes.is_upd = 1>
        <cfset attributes.info_id = attributes.order_id>
        <cfset attributes.info_type_id = -12>
        <cfinclude template="../../objects/query/add_info_plus2.cfm">
        <!---Ek Bilgiler--->
		<cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
        	<cfscript>
            	add_relation_rows(
					action_type:'add',
					action_dsn : '#dsn3#',
					to_table:'ORDERS',
					from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
					to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
					from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
					amount : Evaluate("attributes.amount#i#"),
					to_action_id : attributes.order_id,
					from_action_id :Evaluate("attributes.related_action_id#i#")
					);
			</cfscript>
        </cfif>
		<!---  urun asortileri --->			
		<cfset order_row_id_list_ =listappend(order_row_id_list_,attributes.ROW_MAIN_ID)> <!--- order_row_id_list olusturuluyor, bu liste haricindeki order_row satırları silinir --->
		<cfset row_id = i>
		<cfset ACTION_TYPE_ID = 2>
		<cfinclude template="../../objects/query/add_assortment_textile_js.cfm">
		<cfinclude template="add_department_information.cfm">		

		<cfif isdefined('attributes.process_cat') and len(attributes.process_cat) and isdefined("get_type.IS_BUDGET_RESERVED_CONTROL") and get_type.IS_BUDGET_RESERVED_CONTROL eq 1>
			<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>
				<cfset other_money_val = evaluate('attributes.other_money_value_#i#')>
			<cfelse>
				<cfset other_money_val =''>
			</cfif>
			<cfif isdefined('attributes.other_money_#i#') and len(evaluate("attributes.other_money_#i#"))>
				<cfset other_money = evaluate('attributes.other_money_#i#')>
			<cfelse>
				<cfset other_money = ''>
			</cfif>
			
			<cfscript>
				butceci(
				action_id : attributes.ORDER_ID,
				muhasebe_db : dsn3,
				is_income_expense : true,
				period_id:session.ep.period_id,
				process_type : get_type.process_type,
				product_tax: evaluate("attributes.tax#i#"),//kdv
				stock_id: evaluate("attributes.stock_id#i#"),
				product_id: evaluate("attributes.product_id#i#"),
				product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
				product_oiv: iif((isdefined("attributes.row_oiv_rate#i#") and len(evaluate('attributes.row_oiv_rate#i#'))),evaluate("attributes.row_oiv_rate#i#"),0),
				tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
				nettotal : wrk_round(evaluate("attributes.row_nettotal#i#")),
				other_money_value : other_money_val,
				action_currency : other_money,
				currency_multiplier : attributes.currency_multiplier,
				expense_date : attributes.order_date,
				expense_center_id : iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
				expense_item_id : iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),
				detail : '#GET_PAPER.ORDER_NUMBER# Nolu Sipariş',
				paper_no : GET_PAPER.ORDER_NUMBER,
				branch_id : ListGetAt(session.ep.user_location,2,"-"),
				reserv_type :1, //expense_reserved_rows tablosuna gelir olarak yazılsın.
				project_id: iif(isdefined("attributes.project_id") and len(attributes.project_id), "attributes.project_id", DE('')),
				activity_type : evaluate("attributes.row_activity_id#i#"),
				invoice_row_id:attributes.ROW_MAIN_ID
				);
			</cfscript>
		</cfif>

	</cfloop>
	<cfif len(order_row_id_list_)>
		<cfquery name="DEL_ORDER_ROW_" datasource="#DSN3#"> <!--- basketten cıkarılan satırlar ORDER_ROW dan siliniyor --->
			DELETE FROM ORDER_ROW WHERE ORDER_ID =#attributes.order_id# AND ORDER_ROW_ID NOT IN (#order_row_id_list_#)
		</cfquery>
	</cfif>
	<cfscript>
		basket_kur_ekle(action_id:FORM.ORDER_ID,table_type_id:3,process_type:1);
		/*if(not isdefined("is_from_import") or not isdefined("add_reserve_row"))//importdan geliyorsa fonksiyon tanımlanmasın
			include('add_order_row_reserved_stock.cfm','\V16/objects\functions'); //rezerve edilen satırlar icin ORDER_ROW_RESERVED'a kayıt atıyor.
			*/
		add_reserve_row(
			reserve_order_id:FORM.ORDER_ID,
			reserve_action_type:1,
			is_related_action_iptal :iif((isdefined("attributes.irsaliye_iptal") and (attributes.irsaliye_iptal eq 1)),1,0),
			is_order_process:0,
			is_purchase_sales:0
			);
		
		if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //siparis ic talepten olusturulmussa
		{
			/*
			if(not isdefined("is_from_import") or not isdefined("add_internaldemand_row_relation"))//importdan geliyorsa fonksiyon tanımlanmasın
				include('add_internaldemand_relation.cfm','\V16/objects\functions'); 
				*/
			add_internaldemand_row_relation(
				to_related_action_id:FORM.ORDER_ID,
				to_related_action_type:0,
				action_status:1,
				is_related_action_iptal :iif((isdefined("ORDER_STATUS") and (ORDER_STATUS eq 1)),0,1)
				);
		}
		if(isdefined('attributes.pro_material_id_list') and len(attributes.pro_material_id_list)) //proje malzeme planı ile baglantısı olusturuluyor
		{
		/*	if(not isdefined("is_from_import") or not isdefined("add_paper_relation"))//importdan geliyorsa fonksiyon tanımlanmasın
				include('add_paper_relation.cfm','\V16/objects\functions'); 
				*/
			add_paper_relation(
				to_paper_id :FORM.ORDER_ID,
				to_paper_table : 'ORDERS',
				to_paper_type :1,
				from_paper_table : 'PRO_MATERIAL',
				from_paper_type :2,
				relation_type : 1,
				action_status:1
				);
		}
	</cfscript>
	<!---sipariş güncellendiğinde parçalı cari ödeme planı sablonu silinir --->
	<cfquery name="DEL_PAYMENT_PLANS" datasource="#dsn3#">
		DELETE FROM ORDER_PAYMENT_PLAN_ROWS WHERE PAYMENT_PLAN_ID IN (ISNULL((SELECT PAYMENT_PLAN_ID FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID=#attributes.order_id#),0))
	</cfquery>
	<cfquery name="DEL_PAYMENT_PLANS" datasource="#dsn3#">
		DELETE FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID=#attributes.order_id#
	</cfquery>
 		<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn3#' 
			process_stage='#attributes.process_stage#' 
			old_process_line='#attributes.old_process_line#'
			record_member='#session.ep.userid#'
			record_date='#now()#' 
			action_table='ORDERS'
			action_column='ORDER_ID'
			action_id='#form.order_id#' 
			action_page='#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#form.order_id#' 
			warning_description="#getLang('','Sipariş',57611)# : #get_order.order_number#">

		<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
			<cf_workcube_process_cat 
				process_cat="#attributes.process_cat#"
				action_id = "#attributes.ORDER_ID#"
				action_table="ORDER"
				action_column="ORDER_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#attributes.ORDER_ID#'
				action_file_name='#get_type.action_file_name#'
				action_db_type = '#dsn3#'
				is_template_action_file = '#get_type.action_file_from_template#'>
		</cfif>	
	</cftransaction>
</cflock>
<cfset attributes.actionId=form.order_id> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#form.order_id#</cfoutput>";
</script>