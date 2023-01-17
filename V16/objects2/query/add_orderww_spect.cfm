<!--- 
	urune spect secilmemis ancak urun agaci varsa veya ozellikleri varsa spect olarak onu kaydediyoruz o satir icin
	Kullanildigi yerler siparis, fatura, irsaliye, teklif, fisler
	** bu dosyanın iceriyi degisirse üretim planlamadıki prod/query/add_production_order.cfm ve objects/query/add_basket_spec.cfm de var dosyasındaki bu bolge duzenlensin

bu sayfadan birde kampanya için çoğaltıldı... Aysenur20061225
--->
<cfscript>
	if(not isdefined('dsn_type'))dsn_type=dsn3;
	main_stock_id=STOCK_ID;
	main_product_id=PRODUCT_ID;
	spec_name='#PRODUCT_NAME#';
	stock_id_list="";
	product_id_list="";
	product_name_list="";
	amount_list="";
	diff_price_list="";
	sevk_list="";
	configure_list="";
	is_property_list="";
	property_id_list = "";
	variation_id_list = "";
	total_min_list = "";
	total_max_list = "";
	tolerance_list = "";
	money_list="";
	money_rate1_list="";
	money_rate2_list="";
	if(not isdefined('attributes.company_id'))attributes.company_id='';
	if(not isdefined('attributes.consumer_id'))attributes.consumer_id='';
</cfscript>
<cfset spec_type_=1>

<cfif this_spec_ eq 1>
	<cfquery name="get_inner_rows" datasource="#dsn3#">
		SELECT * FROM ORDER_PRE_ROWS_SPECS WHERE MAIN_ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.order_row_id#">
	</cfquery>
		
	<cfoutput query="get_inner_rows">
		<cfscript>
			product_id_list=listappend(product_id_list,product_id,',');
			stock_id_list = listappend(stock_id_list,stock_id,',');
			if(AMOUNT gt 0)
				amount_list = listappend(amount_list,AMOUNT,',');
			else
				amount_list = listappend(amount_list,1,',');
			sevk_list = listappend(sevk_list,is_sevk,',');
			
			if(is_property eq 0)
				is_property_list=listappend(is_property_list,0,',');
			else
				is_property_list=listappend(is_property_list,1,',');
				
			if(len(DIFF_PRICE))
					diff_price_list=listappend(diff_price_list,DIFF_PRICE,',');
				else
					diff_price_list=listappend(diff_price_list,0,',');
			
			if(len(PRODUCT_NAME))
					product_name_list = listappend(product_name_list,'#PRODUCT_NAME#',',');
				else
					product_name_list = listappend(product_name_list,'-',',');
					
			if(IS_CONFIGURE eq 1)
					configure_list = listappend(configure_list,1,',');
				else
					configure_list = listappend(configure_list,0,',');
			
			if(len(PROPERTY_ID))
					property_id_list = listappend(property_id_list,PROPERTY_ID,',');
				else
					property_id_list = listappend(property_id_list,0,',');
					
			if(len(VARIATION_ID))
					variation_id_list = listappend(variation_id_list,VARIATION_ID,',');
				else
					variation_id_list = listappend(variation_id_list,0,',');
					
			total_min_list = listappend(total_min_list,'-',',');
			total_max_list = listappend(total_max_list,'-',',');
			tolerance_list = listappend(tolerance_list,'-',',');
		</cfscript>
	</cfoutput>
<cfelse>
	<cfif session_base.our_company_info.spect_type eq 3>
		<cfset spec_type_=3>
		<cfquery name="GET_TREE#this_row_#" datasource="#dsn_type#">
			SELECT 
				*
			FROM 
				#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
			WHERE
				PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_stock_id#">
		</cfquery>
		<cfscript>
			if(evaluate('GET_TREE#this_row_#.RECORDCOUNT'))
			{
				spec_type_=3;//ozellikli oldugu icin 3
				for(ii=1;ii lte evaluate('GET_TREE#this_row_#.RECORDCOUNT');ii=ii+1)
				{
					stock_id_list = listappend(stock_id_list,0,',');
					product_id_list = listappend(product_id_list,0,',');
					amount_list = listappend(amount_list,evaluate('GET_TREE#this_row_#.AMOUNT[#ii#]'),',');
					diff_price_list=listappend(diff_price_list,0,',');
					product_name_list = listappend(product_name_list,'-',',');
					sevk_list = listappend(sevk_list,0,',');
					configure_list = listappend(configure_list,0,',');
					is_property_list=listappend(is_property_list,1,',');
					if(len(evaluate('GET_TREE#this_row_#.PROPERTY_ID[#ii#]')))
						property_id_list = listappend(property_id_list,evaluate('GET_TREE#this_row_#.PROPERTY_ID[#ii#]'),',');
					else
						property_id_list = listappend(property_id_list,0,',');
					if(len(evaluate('GET_TREE#this_row_#.VARIATION_ID[#ii#]')))
						variation_id_list = listappend(variation_id_list,evaluate('GET_TREE#this_row_#.VARIATION_ID[#ii#]'),',');
					else 
						variation_id_list = listappend(variation_id_list,0,',');
					if(len(evaluate('GET_TREE#this_row_#.TOTAL_MIN[#ii#]')))
						total_min_list = listappend(total_min_list,evaluate('GET_TREE#this_row_#.TOTAL_MIN[#ii#]'),',');
					else
						total_min_list = listappend(total_min_list,0,',');
					if(len(evaluate('GET_TREE#this_row_#.TOTAL_MAX[#ii#]')))
						total_max_list = listappend(total_max_list,evaluate('GET_TREE#this_row_#.TOTAL_MAX[#ii#]'),',');
					else
						total_max_list = listappend(total_max_list,0,',');
					tolerance_list = listappend(tolerance_list,'-',',');
				}
			}
		</cfscript>
	<cfelse>
		<cfquery name="GET_TREE#this_row_#" datasource="#dsn_type#">
			SELECT 
				STOCKS.PRODUCT_ID,
				STOCKS.PRODUCT_NAME,
				STOCKS.PROPERTY,
				PRODUCT_TREE.PRODUCT_TREE_ID,
				PRODUCT_TREE.RELATED_ID,
				PRODUCT_TREE.HIERARCHY,
				PRODUCT_TREE.IS_TREE,
				PRODUCT_TREE.AMOUNT,
				PRODUCT_TREE.UNIT_ID,
				PRODUCT_TREE.STOCK_ID,
				PRODUCT_TREE.IS_CONFIGURE,
				PRODUCT_TREE.IS_SEVK
			FROM 
				#dsn3_alias#.PRODUCT_TREE PRODUCT_TREE,
				#dsn3_alias#.STOCKS STOCKS
			WHERE 
				PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_stock_id#"> AND
				PRODUCT_TREE.RELATED_ID = STOCKS.STOCK_ID
		</cfquery>
		<cfscript>
			spec_type_=1;
			if(evaluate('GET_TREE#this_row_#.RECORDCOUNT'))
			{
				for(ii=1;ii lte evaluate('GET_TREE#this_row_#.RECORDCOUNT');ii=ii+1)
				{
					if(evaluate('GET_TREE#this_row_#.STOCK_ID[#ii#]') gt 0)
						stock_id_list = listappend(stock_id_list,evaluate('GET_TREE#this_row_#.RELATED_ID[#ii#]'),',');
					else
						stock_id_list = listappend(stock_id_list,0,',');
					if(evaluate('GET_TREE#this_row_#.PRODUCT_ID[#ii#]') gt 0)
						product_id_list = listappend(product_id_list,evaluate('GET_TREE#this_row_#.PRODUCT_ID[#ii#]'),',');
					else
						product_id_list = listappend(product_id_list,0,',');
					amount_list = listappend(amount_list,evaluate('GET_TREE#this_row_#.AMOUNT[#ii#]'),',');
					diff_price_list=listappend(diff_price_list,0,',');
					if(len(evaluate('GET_TREE#this_row_#.PRODUCT_NAME[#ii#]')))
						product_name_list = listappend(product_name_list,'#evaluate('GET_TREE#this_row_#.PRODUCT_NAME[#ii#]')# #evaluate('GET_TREE#this_row_#.PROPERTY[#ii#]')#',',');
					else
						product_name_list = listappend(product_name_list,'-',',');
					if(evaluate('GET_TREE#this_row_#.IS_SEVK[#ii#]') eq 1)
						sevk_list = listappend(sevk_list,1,',');
					else
						sevk_list = listappend(sevk_list,0,',');
					if(evaluate('GET_TREE#this_row_#.IS_CONFIGURE[#ii#]') eq 1)
						configure_list = listappend(configure_list,1,',');
					else
						configure_list = listappend(configure_list,0,',');
					is_property_list = listappend(is_property_list,0,',');						
					property_id_list = listappend(property_id_list,0,',');
					variation_id_list = listappend(variation_id_list,0,',');
					total_min_list = listappend(total_min_list,'-',',');
					total_max_list = listappend(total_max_list,'-',',');
					tolerance_list = listappend(tolerance_list,'-',',');
				}
			}
		</cfscript>
	</cfif>
</cfif>

<cfquery name="get_money_spec" datasource="#dsn_type#">
	SELECT
		MONEY AS MONEY_TYPE,
		RATE1,
	<cfif isDefined("session.pp")>
		RATEPP2 RATE2,
	<cfelseif isDefined("session.ww")>
		RATEWW2 RATE2,
	<cfelse>
		RATE2,
	</cfif>	
		0 AS IS_SELECTED
	FROM
		#dsn_alias#.SETUP_MONEY
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#"> AND
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND
		MONEY_STATUS = 1
</cfquery>

<cfscript>
	row_count=listlen(stock_id_list,',');
	for(qq=1;qq lte get_money_spec.recordcount;qq=qq+1)
	{
		money_list=listappend(money_list,get_money_spec.MONEY_TYPE[#qq#],',');
		money_rate1_list=listappend(money_rate1_list,get_money_spec.RATE1[#qq#],',');
		money_rate2_list=listappend(money_rate2_list,get_money_spec.RATE2[#qq#],',');
	}
	spec_money_select=#get_rows.PRICE_MONEY#;//urun fiyat cinsi secili para birimi olacak

	'spec_info#this_row_#'=specer(
			dsn_type: dsn_type,
			spec_type: spec_type_,
			spec_is_tree: 1,
			company_id: attributes.company_id,
			consumer_id: attributes.consumer_id,
			main_stock_id: main_stock_id,
			main_product_id: main_product_id,
			spec_name: spec_name,
			spec_total_value : get_rows.PRICE_KDV,
			spec_other_total_value : get_rows.PRICE,
			other_money : get_rows.PRICE_MONEY,
			money_list :money_list,
			money_rate1_list :money_rate1_list,
			money_rate2_list : money_rate2_list,
			spec_money_select : spec_money_select,
			spec_row_count: row_count,
			stock_id_list: stock_id_list,
			product_id_list: product_id_list,
			product_name_list: product_name_list,
			amount_list: amount_list,
			diff_price_list: diff_price_list,
			is_sevk_list: sevk_list,	
			is_configure_list: configure_list,
			is_property_list: is_property_list,
			property_id_list: property_id_list,
			variation_id_list: variation_id_list,
			total_min_list: total_min_list,
			total_max_list : total_max_list,
			tolerance_list : tolerance_list
		);
</cfscript>
<cfif isdefined('spec_info#this_row_#') and listlen(evaluate('spec_info#this_row_#'),',')>
	<cfset 'row_spect_id#this_row_#'=listgetat(evaluate('spec_info#this_row_#'),2,',')>
	<cfif len(listgetat(evaluate('spec_info#this_row_#'),3,','))>
		<cfset 'row_spect_name#this_row_#'=listgetat(evaluate('spec_info#this_row_#'),3,',')>
	<cfelse>
		<cfset 'row_spect_name#this_row_#'=evaluate("attributes.product_name#this_row_#")>
	</cfif>
	<cfif len(listgetat(evaluate('spec_info#this_row_#'),3,','))>
		<cfset 'cost_id#this_row_#'=''>
		<cfset 'net_maliyet#this_row_#'=listgetat(evaluate('spec_info#this_row_#'),9,',')>
		<cfset 'extra_cost#this_row_#'=listgetat(evaluate('spec_info#this_row_#'),10,',')>
	</cfif>
<cfelse>
	<cfquery name="GET_TREE#this_row_#" datasource="#dsn_type#"><!--- Ürün Ağacından En Son Varyasyonlanan yani kaydedilen SPECT_MAIN_ID'yi getiriyor.aşağıdada bu main spec kullanılarak bir spec oluşturuluyor..ve baskete yansıtılıyor.. --->
        SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_stock_id#"> AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
    </cfquery>
	<cfscript>
		if(not isdefined('attributes.company_id')) attributes.company_id = 0;
		if(not isdefined('attributes.consumer_id')) attributes.consumer_id = 0;
		if(evaluate('GET_TREE#this_row_#.RECORDCOUNT'))
		{
			'spec_info#this_row_#' = specer(
					dsn_type:dsn_type,
					spec_type:1,
					main_spec_id:evaluate('GET_TREE#this_row_#.SPECT_MAIN_ID'),
					add_to_main_spec:1,
					company_id: attributes.company_id,
					consumer_id: attributes.consumer_id
				);
		}
	</cfscript>
	<cfif isdefined('spec_info#this_row_#') and listlen(evaluate('spec_info#this_row_#'),',')>
		<cfset 'row_spect_id#this_row_#'=listgetat(evaluate('spec_info#this_row_#'),2,',')>
		<cfif len(listgetat(evaluate('spec_info#this_row_#'),3,','))>
			<cfset 'row_spect_name#this_row_#'=listgetat(evaluate('spec_info#this_row_#'),3,',')>
		<cfelse>
			<cfset 'row_spect_name#this_row_#'=evaluate("attributes.product_name#this_row_#")>
		</cfif>
		<cfif len(listgetat(evaluate('spec_info#this_row_#'),3,','))>
			<cfset 'cost_id#this_row_#'=''>
			<cfset 'net_maliyet#this_row_#'=listgetat(evaluate('spec_info#this_row_#'),9,',')>
			<cfset 'extra_cost#this_row_#'=listgetat(evaluate('spec_info#this_row_#'),10,',')>
		</cfif>
	</cfif>
</cfif>
