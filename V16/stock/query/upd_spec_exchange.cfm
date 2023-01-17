<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
<cfinclude template="get_process_cat.cfm">

<cfquery name="GET_MAIN_SPEC" datasource="#DSN3#">
	SELECT 
    	SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
		SPECT_MAIN.SPECT_TYPE,
		SPECT_MAIN_ROW.STOCK_ID,
		SPECT_MAIN_ROW.PRODUCT_ID,
		SPECT_MAIN_ROW.AMOUNT,
		SPECT_MAIN_ROW.IS_SEVK,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_NAME,
		STOCKS.PROPERTY,
		SPECT_MAIN_ROW.IS_CONFIGURE
	FROM 
		SPECT_MAIN,
		SPECT_MAIN_ROW,
		STOCKS 
	WHERE 
		SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND 
		SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
		SPECT_MAIN_ROW.IS_SEVK = 0 AND
		SPECT_MAIN.SPECT_MAIN_ID = <cfif len(attributes.main_spec_id) and len(attributes.main_spec_name)>#attributes.main_spec_id#</cfif>
</cfquery>

<cfquery name="GET_MAIN_PROD" datasource="#dsn3#">
	SELECT PRODUCT_ID,PRODUCT_NAME,PROPERTY,PRODUCT_UNIT_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#
</cfquery>

<cfscript>
	main_stock_id = attributes.stock_id;
	main_product_id = GET_MAIN_PROD.PRODUCT_ID;
	spec_name = "#GET_MAIN_PROD.PRODUCT_NAME# #GET_MAIN_PROD.PROPERTY#";
	row_count = GET_MAIN_SPEC.RECORDCOUNT;
	stock_id_list = "";
	product_id_list = "";
	product_name_list = "";
	amount_list = "";
	sevk_list = "";
	configure_list = "";
	is_property_list = "";
	property_id_list = "";
	variation_id_list = "";
	total_min_list = "";
	total_max_list = "";
	tolerance_list = "";
	related_spect_main_id_list ="";
	for(i=1;i lte GET_MAIN_SPEC.RECORDCOUNT;i=i+1)
	{
		if(GET_MAIN_SPEC.STOCK_ID[i] gt 0)
			stock_id_list = listappend(stock_id_list,GET_MAIN_SPEC.STOCK_ID[i],',');
		if(GET_MAIN_SPEC.PRODUCT_ID[i] gt 0)
			product_id_list = listappend(product_id_list,GET_MAIN_SPEC.PRODUCT_ID[i],',');
		amount_list = listappend(amount_list,GET_MAIN_SPEC.AMOUNT[i],',');
		if(len(GET_MAIN_SPEC.PRODUCT_NAME[i]))
			product_name_list = listappend(product_name_list,'#GET_MAIN_SPEC.PRODUCT_NAME[i]# #GET_MAIN_SPEC.PROPERTY[i]#',',');
		if(GET_MAIN_SPEC.IS_SEVK[i] eq 1)
			sevk_list = listappend(sevk_list,1,',');
		else
			sevk_list = listappend(sevk_list,0,',');
		if(GET_MAIN_SPEC.IS_CONFIGURE[i] eq 1)
			configure_list = listappend(configure_list,1,',');
		else 
			configure_list = listappend(configure_list,0,',');
		if( len(GET_MAIN_SPEC.RELATED_MAIN_SPECT_ID[i]) and GET_MAIN_SPEC.RELATED_MAIN_SPECT_ID[i] gt 0 )
			related_spect_main_id_list  = ListAppend(related_spect_main_id_list,GET_MAIN_SPEC.RELATED_MAIN_SPECT_ID[i],',');
		else
			related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
		is_property_list=listappend(is_property_list,0,',');
		property_id_list = listappend(property_id_list,0,',');
		variation_id_list = listappend(variation_id_list,0,',');
		total_min_list = listappend(total_min_list,'-',',');
		total_max_list = listappend(total_max_list,'-',',');
		tolerance_list = listappend(tolerance_list,'-',',');
	}
	for(i=1;i lte attributes.sb_record_num; i=i+1)
	{
		row_cnt=row_count+1;
		if(isdefined("attributes.sb_product_id#row_cnt#") and len(evaluate('attributes.sb_product_id#row_cnt#')) and evaluate('attributes.sb_row_kontrol#row_cnt#'))
		{
			row_count=row_count+1;
			stock_id_list = listappend(stock_id_list,evaluate('attributes.sb_stock_id#row_cnt#'),',');
			product_id_list = listappend(product_id_list,evaluate('attributes.sb_product_id#row_cnt#'),',');
			amount_list = listappend(amount_list,evaluate('attributes.sb_amount#row_cnt#'),',');
			product_name_list = listappend(product_name_list,'#evaluate("attributes.sb_product_name#row_cnt#")#',',');
			if(isdefined("attributes.related_spect_main_id#row_cnt#") and Evaluate("attributes.related_spect_main_id#row_cnt#")  gt 0)
				related_spect_main_id_list =ListAppend(related_spect_main_id_list,Evaluate("attributes.related_spect_main_id#row_cnt#"),',');
			else
				related_spect_main_id_list = ListAppend(related_spect_main_id_list,0,',');
			sevk_list = listappend(sevk_list,1,',');
			configure_list = listappend(configure_list,1,',');
			is_property_list=listappend(is_property_list,0,',');
			property_id_list = listappend(property_id_list,0,',');
			variation_id_list = listappend(variation_id_list,0,',');
			total_min_list = listappend(total_min_list,'-',',');
			total_max_list = listappend(total_max_list,'-',',');
			tolerance_list = listappend(tolerance_list,'-',',');
		}
	}
</cfscript>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
		specer_return_value_list = specer(
						dsn_type: dsn3,
						spec_type: 1,
						spec_is_tree: 1,
						only_main_spec: 1,
						main_stock_id: main_stock_id,
						main_product_id: main_product_id,
						spec_name: spec_name,
						spec_row_count: row_count,
						stock_id_list: stock_id_list,
						product_id_list: product_id_list,
						product_name_list: product_name_list,
						amount_list: amount_list,
						is_sevk_list: sevk_list,	
						is_configure_list: configure_list,
						is_property_list: is_property_list,
						property_id_list: property_id_list,
						variation_id_list: variation_id_list,
						total_min_list: total_min_list,
						total_max_list : total_max_list,
						tolerance_list : tolerance_list,
						related_spect_id_list : related_spect_main_id_list
					);
		</cfscript>
	</cftransaction>
</cflock>

<cf_date tarih = 'attributes.process_date'>
<cfquery name="GET_PRD_ZERO" datasource="#dsn1#">
	SELECT IS_ZERO_STOCK FROM PRODUCT WHERE PRODUCT_ID=#attributes.product_id#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfif GET_PRD_ZERO.IS_ZERO_STOCK eq 0>
			<cfquery name="GET_STOCK" datasource="#dsn2#">
				SELECT
					SUM(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK, 
					PRODUCT_ID, 
					STOCK_ID,
					SPECT_VAR_ID,
					STORE,
					STORE_LOCATION
				FROM
					STOCKS_ROW
				WHERE
					SPECT_VAR_ID = #attributes.main_spec_id# AND <!--- giris spec stokta varmı diye bakyıor cunku ona daha once yapılmıs virman silinecek ve sonra tekrar eskisinden yeni virman yapılacak --->
					STORE = #attributes.department_id# AND
					STORE_LOCATION = #attributes.location_id# AND
					PROCESS_DATE <= #attributes.process_date#
				GROUP BY
					PRODUCT_ID,
					STOCK_ID,
					SPECT_VAR_ID,
					STORE,
					STORE_LOCATION
			</cfquery>
		</cfif>
		<cfif GET_PRD_ZERO.IS_ZERO_STOCK eq 1 or GET_STOCK.PRODUCT_STOCK gte attributes.amount>
			<cfquery name="add_exchange" datasource="#dsn2#">
				UPDATE 
				STOCK_EXCHANGE
				SET
					PROCESS_TYPE=#GET_PROCESS_TYPE.PROCESS_TYPE#,
					PROCESS_CAT=#attributes.process_cat#,
					PROCESS_DATE=#attributes.process_date#,
					STOCK_ID=#attributes.stock_id#,
					PRODUCT_ID=#attributes.product_id#,
					SPECT_ID=NULL,
					SPECT_MAIN_ID=#listgetat(specer_return_value_list,1,',')#,
					AMOUNT=#attributes.amount#,
					UNIT_ID=#GET_MAIN_PROD.PRODUCT_UNIT_ID#,
					EXIT_STOCK_ID=#attributes.stock_id#,
					EXIT_PRODUCT_ID=#attributes.product_id#,
					EXIT_SPECT_ID=NULL,
					EXIT_SPECT_MAIN_ID=#attributes.main_spec_id#,
					EXIT_AMOUNT=#attributes.amount#,
					EXIT_UNIT_ID=#GET_MAIN_PROD.PRODUCT_UNIT_ID#,
					DEPARTMENT_ID=#attributes.department_id#,
					LOCATION_ID=#attributes.location_id#,
					EXIT_DEPARTMENT_ID=#attributes.department_id#,
					EXIT_LOCATION_ID=#attributes.location_id#,
					UPDATE_EMP=#session.ep.userid#,
					UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					UPDATE_DATE=#now()#
				WHERE
					STOCK_EXCHANGE_ID=#attributes.exchange_id#
			</cfquery>
			
			<cfquery name="del_exchange_stock" datasource="#dsn2#">
				DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE = #GET_PROCESS_TYPE.PROCESS_TYPE# AND UPD_ID=#attributes.exchange_id#
			</cfquery>
			
			<cfquery name="add_exchange_stock" datasource="#dsn2#">
				INSERT INTO
				STOCKS_ROW
					(
						PROCESS_TYPE,
						STOCK_ID,
						PRODUCT_ID,
						UPD_ID,
						STOCK_IN,
						STOCK_OUT,
						STORE,
						STORE_LOCATION,
						PROCESS_DATE,
						SPECT_VAR_ID
					)
				VALUES
					(
						#GET_PROCESS_TYPE.PROCESS_TYPE#,
						#attributes.stock_id#,
						#attributes.product_id#,
						#attributes.exchange_id#,
						#attributes.amount#,
						0,
						#attributes.department_id#,
						#attributes.location_id#,
						#attributes.process_date#,
						#listgetat(specer_return_value_list,1,',')#
					)
			</cfquery>
			<cfquery name="add_exchange_stock" datasource="#dsn2#">
				INSERT INTO
				STOCKS_ROW
					(
						PROCESS_TYPE,
						STOCK_ID,
						PRODUCT_ID,
						UPD_ID,
						STOCK_IN,
						STOCK_OUT,
						STORE,
						STORE_LOCATION,
						PROCESS_DATE,
						SPECT_VAR_ID
					)
				VALUES
					(
						#GET_PROCESS_TYPE.PROCESS_TYPE#,
						#attributes.stock_id#,
						#attributes.product_id#,
						#attributes.exchange_id#,
						0,
						#attributes.amount#,
						#attributes.department_id#,
						#attributes.location_id#,
						#attributes.process_date#,
						#attributes.main_spec_id#
					)
			</cfquery>
			<cfset is_virman =1><!--- tanımlıysa maliyet olusacak --->
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no ='541.Stok Virman için Depo-Lokasyonda yeterli Miktar Yok'>");
				history.go(-1);
			</script>
		</cfif>
	</cftransaction>
</cflock>
<!--- maliyet --->
<cfif isdefined('is_virman') and session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1>
	<cfscript>cost_action(action_type:5,action_id:attributes.exchange_id,query_type:2);</cfscript>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=stock.form_add_spec_exchange&event=upd&exchange_id=#attributes.exchange_id#</cfoutput>";
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=stock.form_add_spec_exchange&event=upd&exchange_id=#attributes.exchange_id#</cfoutput>";
	</script>
</cfif>

