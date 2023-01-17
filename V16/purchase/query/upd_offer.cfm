<cfscript>
	if(isdefined("partner_ids")) to_par_ids = partner_ids;
	if(isdefined("company_ids")) to_comp_ids = company_ids;
	if(isdefined("consumer_ids")) to_cons_ids = consumer_ids;
	if(isdefined("to_par_ids")) CC_PART = ListSort(to_par_ids,"Numeric", "Desc") ; else CC_PART = "";
	if(isdefined("to_comp_ids")) CC_COMP = ListSort(to_comp_ids,"Numeric", "Desc") ; else CC_COMP = "";
	if(isdefined("to_cons_ids")) CC_CONS = ListSort(to_cons_ids,"Numeric", "Desc") ; else CC_CONS = "";
</cfscript>

<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='213.İşlemin Şirketi İle Aktif Şirketiniz Farklı Çalıştığınız Şirketi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=purchase.list_offer</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif not isdefined('attributes.price') or not len(attributes.price)>
	<cfif isDefined("attributes.basket_net_total") and len(attributes.basket_net_total)>
		<cfset attributes.price = attributes.basket_net_total>
	<cfelse>
		<cfset attributes.price = 0>
	</cfif>
</cfif>
<cf_date tarih = "attributes.offer_date">
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset offer_due_date = date_add("d",attributes.basket_due_value,attributes.offer_date)>
</cfif> 
<cfif isdefined("attributes.deliverdate") and isdate(attributes.deliverdate)>
	<cf_date tarih = "attributes.deliverdate">
</cfif>
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
	<cfset attributes.startdate=date_add("H", attributes.start_hour,attributes.startdate)>
	<cfset attributes.startdate=date_add("N", attributes.start_min,attributes.startdate)>
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
	<cfset attributes.finishdate=date_add("H", attributes.finish_hour,attributes.finishdate)>
	<cfset attributes.finishdate=date_add("N", attributes.finish_min,attributes.finishdate)>
</cfif>
<cfif isdefined("attributes.offer_finishdate") and isdate(attributes.offer_finishdate)>
	<cf_date tarih = "attributes.offer_finishdate">
	<cfset attributes.offer_finishdate=date_add("H", attributes.offer_finish_hour,attributes.offer_finishdate)>
	<cfset attributes.offer_finishdate=date_add("N", attributes.offer_finish_min,attributes.offer_finishdate)>
</cfif>
<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
	<cfquery name="get_type" datasource="#dsn3#">
		SELECT PROCESS_TYPE,PROCESS_CAT_ID,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_BUDGET_RESERVED_CONTROL FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
	</cfquery>
	<cfquery name="GET_PAPER" datasource="#DSN3#">
		SELECT OFFER_NUMBER FROM OFFER WHERE OFFER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
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
		butce_sil(action_id:attributes.offer_id,process_type:get_type.PROCESS_TYPE,reserv_type:1);
</cfscript>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
    <cfscript>
        add_relation_rows(
            action_type:'del',
            action_dsn : '#dsn3#',
            to_table:'OFFER',
			to_action_id : attributes.offer_id
            );
    </cfscript>
	<!--- History --->
	<cfinclude template="add_offer_history.cfm">
	<!--- //History --->
	<cfquery name="UPD_OFFER" datasource="#DSN3#">
		UPDATE 
			OFFER 
		SET
			OFFER_CURRENCY = <cfif isDefined("FORM.OFFER_CURRENCY") and Len(FORM.OFFER_CURRENCY)>#FORM.OFFER_CURRENCY#<cfelse>NULL</cfif>,
			OFFER_STATUS = <cfif isDefined("FORM.OFFER_STATUS")>1<cfelse>0</cfif>,
			OFFER_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#<cfelse>NULL</cfif>,
			OFFER_DATE = #attributes.offer_date#,
			PAYMETHOD = <cfif len(attributes.paymethod_id) and len(attributes.pay_method)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
			CARD_PAYMETHOD_ID = <cfif len(attributes.card_paymethod_id) and len(attributes.pay_method)>#attributes.card_paymethod_id#<cfelse>NULL</cfif>,
			CARD_PAYMETHOD_RATE = <cfif len(attributes.commission_rate) and len(attributes.pay_method)>#attributes.commission_rate#<cfelse>NULL</cfif>,
			DELIVERDATE = <cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>#attributes.deliverdate#<cfelse>NULL</cfif>,
			STARTDATE = <cfif isdefined("attributes.startdate") and len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
			FINISHDATE = <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
			OFFER_FINISHDATE = <cfif isdefined("attributes.offer_finishdate") and isdate(attributes.offer_finishdate)>#attributes.offer_finishdate#<cfelse>NULL</cfif>,
			INCLUDED_KDV = <cfif isdefined("form.included_kdv")>1<cfelse>0</cfif>,
			IS_PARTNER_ZONE = <cfif isdefined("form.IS_PARTNER_ZONE")>1<cfelse>0</cfif>,
			IS_PUBLIC_ZONE = <cfif isdefined("form.IS_PUBLIC_ZONE")>1<cfelse>0</cfif>,
			OFFER_TO = ',#CC_COMP#,',
			OFFER_TO_PARTNER = ',#CC_PART#,',
			OFFER_TO_CONSUMER = ',#CC_CONS#,',
			SALES_EMP_ID = <cfif len(attributes.sales_emp_id) and len(attributes.sales_emp_name)>#attributes.sales_emp_id#<cfelse>NULL</cfif>,
			<cfif isdefined("form.basket_money") and len(form.basket_money)>
				OTHER_MONEY = '#form.basket_money#',
				OTHER_MONEY_VALUE = #((form.basket_net_total*form.basket_rate1)/form.basket_rate2)#,
			</cfif>
			<cfif isdefined("form.TAX")>
				TAX = #FORM.TAX#,
			</cfif>
			LOCATION_ID = <cfif isdefined("form.deliver_loc_id") and len(form.deliver_loc_id) and len(form.deliver_state)>#form.deliver_loc_id#<cfelse>NULL</cfif>,
			DELIVER_PLACE = '#FORM.DELIVER_STATE_ID#',
			OFFER_HEAD = '#FORM.OFFER_HEAD#',
			OFFER_DETAIL = '#attributes.OFFER_DETAIL#',
			PRICE = <cfif isdefined('attributes.price') and len(attributes.price)>#attributes.price#<cfelse>NULL</cfif>,
			DUE_DATE = <cfif isdefined("offer_due_date") and len(offer_due_date)>#offer_due_date#<cfelse>NULL</cfif>,
			PRIORITY_ID = #FORM.PRIORITY_ID#,
			REF_NO = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
			SHIP_METHOD = <cfif len(attributes.ship_method_id) and len(attributes.ship_method_name)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
			PROJECT_ID = <cfif len(attributes.project_head) and len(attributes.PROJECT_ID)>#attributes.PROJECT_ID#<cfelse>NULL</cfif>,
            FOR_OFFER_ID = <cfif isdefined("attributes.related_offer_id") and len(attributes.related_offer_id)>#attributes.related_offer_id#<cfelse>NULL</cfif>,
			WORK_ID=<cfif isdefined("attributes.work_id") and len(attributes.work_id)>#attributes.work_id#<cfelse>NULL</cfif>,
			UPDATE_DATE = #NOW()#,
			UPDATE_MEMBER = #SESSION.EP.USERID#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			SA_DISCOUNT = <cfif isdefined("form.genel_indirim") and len(form.genel_indirim)>#form.genel_indirim#<cfelse>NULL</cfif>,
			PROCESS_CAT =<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"><cfelse>NULL</cfif>
			<cfif isDefined("attributes.tender_type")>
				,TENDER_TYPE_ID = <cfif len(attributes.tender_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tender_type#"><cfelse>NULL</cfif>
			</cfif>
			<cfif isDefined("attributes.bargaining_type")>
				,BARGAINING_TYPE_ID = <cfif len(attributes.bargaining_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bargaining_type#"><cfelse>NULL</cfif>
			</cfif>
		WHERE 
			OFFER_ID = #FORM.offer_id#
	</cfquery>
    <!--- Ana teklifin ilişkilerini yeniden güncelliyor--->
    <cfif isDefined('attributes.related_offer_id') and len(attributes.related_offer_id)>
    	<cfquery name="GET_ALL_REL_OFFERS" datasource="#DSN3#">
       		SELECT 
            	OFFER_TO, 
                OFFER_TO_PARTNER 
            FROM 
            	OFFER 
            WHERE 
            	OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_offer_id#">
        </cfquery>
		<cfset comp_list = replace(get_all_rel_offers.offer_to,'#attributes.old_company_ids#',',#attributes.company_ids#,','All')>
		<cfset part_list = replace(get_all_rel_offers.offer_to_partner,'#attributes.old_partner_ids#',',#attributes.partner_ids#,','All')>
        <cfquery name="UPD_OFFER" datasource="#DSN3#">
        	UPDATE
            	OFFER
            SET
            	OFFER_TO = '#comp_list#',
            	OFFER_TO_PARTNER = '#part_list#'
            WHERE
            	OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_offer_id#">
        </cfquery>
    </cfif>
    <!--- Ana teklifin ilişkilerini yeniden güncelliyor--->

	<!--- urun asortileri siliniyor --->
	<cfquery name="DEL_OFFER_ASSORT_ROWS" datasource="#DSN3#">
		DELETE FROM
			PRODUCTION_ASSORTMENT
		WHERE
			ACTION_TYPE=1
			AND 
			ASSORTMENT_ID IN
			(
			SELECT
				 OFFER_ROW_ID 
			FROM
				OFFER_ROW
			WHERE
				OFFER_ID = #FORM.OFFER_ID#			
			)
	</cfquery>
 	<!--- // urun asortileri  --->	
	<cfquery name="DEL_OFFER_ROW" datasource="#DSN3#">
		DELETE OFFER_ROW WHERE OFFER_ID = #FORM.offer_id#
	</cfquery>
	<cfloop from="1" to="#attributes.rows_#" index="i">
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
		<cf_date tarih="attributes.deliver_date#i#">
		<cfquery name="ADD_PRODUCT_TO_OFFER" datasource="#DSN3#">
			INSERT INTO 
				OFFER_ROW 
				(
				OFFER_ID, 
				PRODUCT_ID,
				STOCK_ID,
				QUANTITY,
				UNIT,
				UNIT_ID,					
				PRICE,
				TAX,
				DUEDATE,
				PRODUCT_NAME,
				<!--- APPROVE_STATUS, ---> 
				DELIVER_DEPT,
				DELIVER_LOCATION,
				DELIVER_DATE,
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
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
			</cfif>
				NET_MALIYET,
				EXTRA_COST,
				MARJ,
				PRICE_OTHER,
				DISCOUNT_COST,
				UNIQUE_RELATION_ID,
				PRODUCT_NAME2,
				AMOUNT2,
				UNIT2,
				EXTRA_PRICE,
				EK_TUTAR_PRICE,
				EXTRA_PRICE_TOTAL,
				EXTRA_PRICE_OTHER_TOTAL,
				SHELF_NUMBER,
				PRODUCT_MANUFACT_CODE,
				BASKET_EXTRA_INFO_ID,
				SELECT_INFO_EXTRA,
                DETAIL_INFO_EXTRA,
				LIST_PRICE,
				NUMBER_OF_INSTALLMENT,
				PRICE_CAT,
				CATALOG_ID,
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
				BASKET_EMPLOYEE_ID,
                ROW_WORK_ID
				<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,EXPENSE_CENTER_ID</cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,EXPENSE_ITEM_ID</cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ACC_CODE</cfif>
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
				#FORM.offer_id#,
				#evaluate("attributes.product_id#i#")#,
				#evaluate("attributes.stock_id#i#")#,
				#evaluate("attributes.amount#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
				#evaluate("attributes.unit_id#i#")#,
				#evaluate("attributes.price#i#")#,
				#evaluate("attributes.tax#i#")#,
				<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name#i#')#">,
				<!--- NULL, --->
			<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined("attributes.deliver_date#i#") and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.indirim1#i#') and len(evaluate("attributes.indirim1#i#"))>#evaluate('attributes.indirim1#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim2#i#') and len(evaluate("attributes.indirim2#i#"))>#evaluate('attributes.indirim2#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim3#i#') and len(evaluate("attributes.indirim3#i#"))>#evaluate('attributes.indirim3#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim4#i#') and len(evaluate("attributes.indirim4#i#"))>#evaluate('attributes.indirim4#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim5#i#') and len(evaluate("attributes.indirim5#i#"))>#evaluate('attributes.indirim5#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim6#i#') and len(evaluate("attributes.indirim6#i#"))>#evaluate('attributes.indirim6#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim7#i#') and len(evaluate("attributes.indirim7#i#"))>#evaluate('attributes.indirim7#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim8#i#') and len(evaluate("attributes.indirim8#i#"))>#evaluate('attributes.indirim8#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim9#i#') and len(evaluate("attributes.indirim9#i#"))>#evaluate('attributes.indirim9#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.indirim10#i#') and len(evaluate("attributes.indirim10#i#"))>#evaluate('attributes.indirim10#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.other_money_value_#i#') and len(evaluate("attributes.other_money_value_#i#"))>#evaluate('attributes.other_money_value_#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
				#evaluate('attributes.spect_id#i#')#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
			</cfif>
			<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#,<cfelse>0,</cfif>			
			<cfif len(evaluate('attributes.price_other#i#'))>#evaluate('attributes.price_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
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
			<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
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
			<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>
			<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
			)
		</cfquery>
        <cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
        	<cfscript>
            	add_relation_rows(
					action_type:'add',
					action_dsn : '#dsn3#',
					to_table:'OFFER',
					from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
					to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
					from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
					amount : Evaluate("attributes.amount#i#"),
					to_action_id : attributes.offer_id,
					from_action_id :Evaluate("attributes.related_action_id#i#")
					);
			</cfscript>
        </cfif>
		<!---  urun asortileri --->			
		<cfquery name="get_max_offer_row" datasource="#DSN3#">
			SELECT MAX(OFFER_ROW_ID) AS OFFER_ROW_ID FROM OFFER_ROW
		</cfquery>
		<cfset attributes.ROW_MAIN_ID = get_max_offer_row.OFFER_ROW_ID>
		<cfset row_id = i>
		<cfset ACTION_TYPE_ID = 1>
		<cfinclude template="../../objects/query/add_assortment_textile_js.cfm">
		<cfinclude template="add_department_information.cfm">
		<!--- //  urun asortileri --->	
        
        <!---Iliskili Ic Talep Belgeleriyle Ilgili Islem Yapmak Icin --->    
        <cfif isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)>
        	<cfloop list="#attributes.internaldemand_id_list#" index="iil">            	
				<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>
                    <cfif ListLast(iil,';') eq evaluate('attributes.wrk_row_relation_id#i#')>
                        <cfset "attributes.row_ship_id#i#" = "#ListFirst(iil,';')#;#ListGetAt(iil,2,';')#">
                    </cfif>
				</cfif>
            </cfloop>
		</cfif>	
		<!--- bütçe rezerv kayıt --->

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
				action_id : attributes.offer_id,
				muhasebe_db : dsn3,
				is_income_expense : true,
				period_id:session.ep.period_id,
				process_type : get_type.process_type,
				product_tax: evaluate("attributes.tax#i#"),//kdv
				stock_id: evaluate("attributes.stock_id#i#"),
				product_id: evaluate("attributes.product_id#i#"),
				nettotal : wrk_round(evaluate("attributes.price#i#") * evaluate("attributes.amount#i#")),
				other_money_value : other_money_val,
				action_currency : other_money,
				currency_multiplier : attributes.currency_multiplier,
				expense_date : attributes.offer_date,
				expense_center_id : iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
				expense_item_id : iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),
				detail : '#GET_PAPER.OFFER_NUMBER# Nolu Teklif',
				paper_no : GET_PAPER.OFFER_NUMBER,
				branch_id : ListGetAt(session.ep.user_location,2,"-"),
				discounttotal: iif((isdefined("form.genel_indirim") and len('form.genel_indirim')),"#form.genel_indirim#",0),
				project_id: iif(isdefined("attributes.project_id") and len(attributes.project_id), "attributes.project_id", DE('')),
				reserv_type :1, //expense_reserved_rows tablosuna gelir olarak yazılsın.
				activity_type : evaluate("attributes.row_activity_id#i#"),
				invoice_row_id:attributes.ROW_MAIN_ID
				);
			</cfscript>
		</cfif>
	</cfloop>

	<cfscript>basket_kur_ekle(action_id:FORM.OFFER_ID,table_type_id:4,process_type:1);
   if(isdefined('attributes.internaldemand_id_list') and len(attributes.internaldemand_id_list)) //teklif satınalma talebinden olusturulacaksa
		{
			add_internaldemand_row_relation(
				to_related_action_id:attributes.offer_id,
				to_related_action_type:3,
				is_related_action_iptal :iif((isdefined("FORM.OFFER_STATUS") and (FORM.OFFER_STATUS eq 1)),0,1),
				action_status:1,
				process_db:dsn3
				);
		}
	</cfscript>	
		<!---Ek Bilgiler--->
		<cfset attributes.info_id = attributes.offer_id>
		<cfset attributes.is_upd = 1>
		<cfset attributes.info_type_id = -30>
		<cfinclude template="../../objects/query/add_info_plus2.cfm">
		<!---Ek Bilgiler--->
	<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn3#' 
		process_stage='#attributes.process_stage#' 
		old_process_line='#attributes.old_process_line#'
		record_member='#session.ep.userid#'
		record_date='#now()#' 
		action_table='OFFER'
		action_column='OFFER_ID'
		action_id='#form.offer_id#' 
		action_page='index.cfm?fuseaction=purchase.list_offer&event=upd&offer_id=#form.offer_id#' 
		warning_description='Teklif : #offer.offer_number#'
		paper_no='#offer.offer_number#'>

	<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				old_process_cat_id = ""
				action_id = "#form.offer_id#"
				is_action_file = "1"
				action_table="OFFER"
				action_column="OFFER_ID"
				action_file_name='#get_type.action_file_name#'
				action_page='#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#form.offer_id#'
				action_db_type="#dsn3#"
				is_template_action_file = '#get_type.action_file_from_template#'>
	</cfif>	
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#form.offer_id#</cfoutput>";
</script>
