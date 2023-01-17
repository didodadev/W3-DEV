<!--- urune spect secilmemis ancak urun agaci varsa veya özellikleri varsa spect olarak onu kaydediyoruz o satir icin--->
<cfscript>
	main_stock_id=evaluate("attributes.stock_id#i#");
	main_product_id=evaluate("attributes.product_id#i#");
	spec_name='#evaluate("attributes.product_name#i#")#';
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
</cfscript>
<!--- <cfif session.ep.our_company_info.spect_type eq 3>
	<cfquery name="GET_TREE#i#" datasource="#DSN2#">
		SELECT 
			*
		FROM 
			#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
		WHERE 
			PRODUCT_DT_PROPERTIES.PRODUCT_ID = #evaluate("attributes.product_id#i#")#
	</cfquery>
	<cfscript>
		if(evaluate('GET_TREE#i#.RECORDCOUNT'))
		{
			spec_type=3;//ozellikli oldugu icin 3
			for(ii=1;ii lte evaluate('GET_TREE#i#.RECORDCOUNT');ii=ii+1)
			{
				stock_id_list = listappend(stock_id_list,0,',');
				product_id_list = listappend(product_id_list,0,',');
				amount_list = listappend(amount_list,evaluate('GET_TREE#i#.AMOUNT[#ii#]'),',');
				diff_price_list=listappend(diff_price_list,0,',');
				product_name_list = listappend(product_name_list,'-',',');
				sevk_list = listappend(sevk_list,0,',');
				configure_list = listappend(configure_list,0,',');
				is_property_list=listappend(is_property_list,1,',');
				if(len(evaluate('GET_TREE#i#.PROPERTY_ID[#ii#]')))
					property_id_list = listappend(property_id_list,evaluate('GET_TREE#i#.PROPERTY_ID[#ii#]'),',');
				else
					property_id_list = listappend(property_id_list,0,',');
				if(len(evaluate('GET_TREE#i#.VARIATION_ID[#ii#]')))
					variation_id_list = listappend(variation_id_list,evaluate('GET_TREE#i#.VARIATION_ID[#ii#]'),',');
				else 
					variation_id_list = listappend(variation_id_list,0,',');
				if(len(evaluate('GET_TREE#i#.TOTAL_MIN[#ii#]')))
					total_min_list = listappend(total_min_list,evaluate('GET_TREE#i#.TOTAL_MIN[#ii#]'),',');
				else
					total_min_list = listappend(total_min_list,0,',');
				if(len(evaluate('GET_TREE#i#.TOTAL_MAX[#ii#]')))
					total_max_list = listappend(total_max_list,evaluate('GET_TREE#i#.TOTAL_MAX[#ii#]'),',');
				else
					total_max_list = listappend(total_max_list,0,',');
				tolerance_list = listappend(tolerance_list,'-',',');
			}
		}
	</cfscript>
</cfif> --->
<cfif not isdefined('GET_TREE#i#.RECORDCOUNT') or evaluate('GET_TREE#i#.RECORDCOUNT') eq 0><!--- ozellikli spec degil veya ozellikli spec olsada urun ozelligi yoksa agaci varsa o kaydedilecek --->
	<cfquery name="GET_TREE#i#" datasource="#DSN2#">
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
			PRODUCT_TREE.STOCK_ID=#evaluate("attributes.stock_id#i#")# AND
			PRODUCT_TREE.RELATED_ID=STOCKS.STOCK_ID
	</cfquery>
	<cfscript>
		if(evaluate('GET_TREE#i#.RECORDCOUNT'))
		{
			spec_type=1;//simdikil 1 attik ama bu durumda baska degerlerde gelebilir cunku sessionda 3 olsada ozellik yoksa bu taraga giriiyor
			for(ii=1;ii lte evaluate('GET_TREE#i#.RECORDCOUNT');ii=ii+1)
			{
				if(evaluate('GET_TREE#i#.STOCK_ID[#ii#]') gt 0)
					stock_id_list = listappend(stock_id_list,evaluate('GET_TREE#i#.RELATED_ID[#ii#]'),',');
				else
					stock_id_list = listappend(stock_id_list,0,',');
				if(evaluate('GET_TREE#i#.PRODUCT_ID[#ii#]') gt 0)
					product_id_list = listappend(product_id_list,evaluate('GET_TREE#i#.PRODUCT_ID[#ii#]'),',');
				else
					product_id_list = listappend(product_id_list,0,',');
				amount_list = listappend(amount_list,evaluate('GET_TREE#i#.AMOUNT[#ii#]'),',');
				diff_price_list=listappend(diff_price_list,0,',');
				if(len(evaluate('GET_TREE#i#.PRODUCT_NAME[#ii#]')))
					product_name_list = listappend(product_name_list,'#evaluate('GET_TREE#i#.PRODUCT_NAME[#ii#]')# #evaluate('GET_TREE#i#.PROPERTY[#ii#]')#',',');
				else
					product_name_list = listappend(product_name_list,'-',',');
				if(evaluate('GET_TREE#i#.IS_SEVK[#ii#]') eq 1)
					sevk_list = listappend(sevk_list,1,',');
				else
					sevk_list = listappend(sevk_list,0,',');
				if(evaluate('GET_TREE#i#.IS_CONFIGURE[#ii#]') eq 1)
					configure_list = listappend(configure_list,1,',');
				else
					configure_list = listappend(configure_list,0,',');
				is_property_list=listappend(is_property_list,0,',');
				property_id_list = listappend(property_id_list,0,',');
				variation_id_list = listappend(variation_id_list,0,',');
				total_min_list = listappend(total_min_list,'-',',');
				total_max_list = listappend(total_max_list,'-',',');
				tolerance_list = listappend(tolerance_list,'-',',');
			}
		}
	</cfscript>
</cfif>

<cfscript>
if(evaluate('GET_TREE#i#.RECORDCOUNT'))
{
	row_count=evaluate('GET_TREE#i#.RECORDCOUNT');
	for(qq=1;qq lte attributes.kur_say;qq=qq+1)
	{
		money_list=listappend(money_list,evaluate("attributes.hidden_rd_money_#qq#"),',');
		money_rate1_list=listappend(money_rate1_list,evaluate("attributes.txt_rate1_#qq#"),',');
		money_rate2_list=listappend(money_rate2_list,evaluate("attributes.txt_rate2_#qq#"),',');
		if(evaluate("attributes.hidden_rd_money_#qq#") is attributes.BASKET_MONEY)
			spec_money_select=evaluate("attributes.hidden_rd_money_#qq#");
		else
			spec_money_select=evaluate("attributes.hidden_rd_money_#qq#");
	}
	if(not isdefined('attributes.company_id'))attributes.company_id='';
	if(not isdefined('attributes.consumer_id'))attributes.consumer_id='';
	'spec_info#i#'=specer(
			dsn_type: dsn2,
			spec_type: session.ep.our_company_info.spect_type,
			spec_is_tree: 1,
			company_id: attributes.company_id,
			consumer_id: attributes.consumer_id,
			main_stock_id: main_stock_id,
			main_product_id: main_product_id,
			spec_name: spec_name,
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
}
</cfscript>
<cfif isdefined('spec_info#i#') and listlen(evaluate('spec_info#i#'),',')>
	<cfset 'attributes.spect_id#i#'=listgetat(evaluate('spec_info#i#'),2,',')>
	<cfif len(listgetat(evaluate('spec_info#i#'),3,','))>
		<cfset 'attributes.spect_name#i#'=listgetat(evaluate('spec_info#i#'),3,',')>
	<cfelse>
		<cfset 'attributes.spect_name#i#'=evaluate("attributes.product_name#i#")>
	</cfif>
	<cfif len(listgetat(evaluate('spec_info#i#'),3,','))>
		<cfset 'attributes.cost_id#i#'=''>
		<cfset 'attributes.net_maliyet#i#'=listgetat(evaluate('spec_info#i#'),9,',')>
		<cfset 'attributes.extra_cost#i#'=listgetat(evaluate('spec_info#i#'),10,',')>
	</cfif>
</cfif>
