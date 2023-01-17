<!--- 
	urune spect secilmemis ancak urun agaci varsa veya ozellikleri varsa spect olarak onu kaydediyoruz o satir icin
	Kullanildigi yerler siparis, fatura, irsaliye, teklif, fisler
	** bu dosyanın iceriyi degisirse üretim planlamadıki prod/query/add_production_order.cfm ve objects/query/add_basket_spec.cfm de var dosyasındaki bu bolge duzenlensin

bu sayfadan birde kampanya için çoğaltıldı... Aysenur20061225
--->
<cfscript>
	if(not isdefined('dsn_type'))dsn_type=dsn3;
	main_stock_id=session.basketww_camp[i][8];
	main_product_id=session.basketww_camp[i][1];
	spec_name='#session.basketww_camp[i][2]#';
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
<cfset spec_type=1>
<cfif IsStruct(session.basketww_camp[i][19])><!--- spec kaydedilmisse sessionda varsa --->
  	<cfif len(session.basketww_camp[i][19].product_id) and len(session.basketww_camp[i][19].stock_id)>
		<cfscript>
		//spec_type=1;//simdikil 1 attik ama bu durumda baska degerlerde gelebilir cunku sessionda 3 olsada ozellik yoksa bu taraga giriiyor
		if(len(session.basketww_camp[i][19].product_id) and len(session.basketww_camp[i][19].stock_id))
		  for(n=1;n lte StructCount(session.basketww_camp[i][19].spect_row);n=n+1)
			{
				product_id_list=listappend(product_id_list,session.basketww_camp[i][19].spect_row[n][1],',');
				stock_id_list = listappend(stock_id_list,session.basketww_camp[i][19].spect_row[n][2],',');
				if(session.basketww_camp[i][19].spect_row[n][4] gt 0)
					amount_list = listappend(amount_list,session.basketww_camp[i][19].spect_row[n][4],',');
				else
					amount_list = listappend(amount_list,1,',');
				sevk_list = listappend(sevk_list,session.basketww_camp[i][19].spect_row[n][10],',');
				if(session.basketww_camp[i][19].spect_row[n][9] eq 0)
					is_property_list=listappend(is_property_list,0,',');
				else
					is_property_list=listappend(is_property_list,1,',');
				if(len(session.basketww_camp[i][19].spect_row[n][8]))
					diff_price_list=listappend(diff_price_list,session.basketww_camp[i][19].spect_row[n][8],',');
				else
					diff_price_list=listappend(diff_price_list,0,',');
				if(len(session.basketww_camp[i][19].spect_row[n][3]))
					product_name_list = listappend(product_name_list,'#session.basketww_camp[i][19].spect_row[n][3]#',',');
				else
					product_name_list = listappend(product_name_list,'-',',');
				if(session.basketww_camp[i][19].spect_row[n][7] eq 1)
					configure_list = listappend(configure_list,1,',');
				else
					configure_list = listappend(configure_list,0,',');
				if(len(session.basketww_camp[i][19].spect_row[n][11]))
					property_id_list = listappend(property_id_list,session.basketww_camp[i][19].spect_row[n][11],',');
				else
					property_id_list = listappend(property_id_list,0,',');
				if(len(session.basketww_camp[i][19].spect_row[n][12]))
					variation_id_list = listappend(variation_id_list,session.basketww_camp[i][19].spect_row[n][12],',');
				else
					variation_id_list = listappend(variation_id_list,0,',');
				total_min_list = listappend(total_min_list,'-',',');
				total_max_list = listappend(total_max_list,'-',',');
				tolerance_list = listappend(tolerance_list,'-',',');
			}
		</cfscript>
		<!--- <cfset spec_type=1> --->
	</cfif>
<cfelse>
	<cfif session_base.our_company_info.spect_type eq 3>
		<cfset spec_type=3>
		<cfquery name="GET_TREE#i#" datasource="#dsn_type#">
			SELECT 
				*
			FROM 
				#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
			WHERE 
				PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_stock_id#">
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
	<cfelse>
		<cfquery name="GET_TREE#i#" datasource="#dsn_type#">
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
			spec_type=1;
			if(evaluate('GET_TREE#i#.RECORDCOUNT'))
			{
				//spec_type=1;//simdikil 1 attik ama bu durumda baska degerlerde gelebilir cunku sessionda 3 olsada ozellik yoksa bu taraga giriiyor
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
		MONEY_STATUS=1
</cfquery>

<cfscript>
	row_count=listlen(stock_id_list,',');
	for(qq=1;qq lte get_money_spec.recordcount;qq=qq+1)
	{
		money_list=listappend(money_list,get_money_spec.MONEY_TYPE[#qq#],',');
		money_rate1_list=listappend(money_rate1_list,get_money_spec.RATE1[#qq#],',');
		money_rate2_list=listappend(money_rate2_list,get_money_spec.RATE2[#qq#],',');
	}
	spec_money_select=#session.basketww_camp[i][6]#;//urun fiyat cinsi secili para birimi olacak

	'spec_info#i#'=specer(
			dsn_type: dsn_type,
			spec_type: spec_type,
			spec_is_tree: 1,
			company_id: attributes.company_id,
			consumer_id: attributes.consumer_id,
			main_stock_id: main_stock_id,
			main_product_id: main_product_id,
			spec_name: spec_name,
			
			spec_total_value : #session.basketww_camp[i][5]#,
			//main_prod_price  : #session.basketww_camp[i][4]# ,
			//main_product_money : #session.basketww_camp[i][6]#,
			spec_other_total_value : #session.basketww_camp[i][4]#,
			other_money : #session.basketww_camp[i][6]#,
			
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
<cfif isdefined('spec_info#i#') and listlen(evaluate('spec_info#i#'),',')>
	<cfset 'row_spect_id#i#'=listgetat(evaluate('spec_info#i#'),2,',')>
	<cfif len(listgetat(evaluate('spec_info#i#'),3,','))>
		<cfset 'row_spect_name#i#'=listgetat(evaluate('spec_info#i#'),3,',')>
	<cfelse>
		<cfset 'row_spect_name#i#'=evaluate("attributes.product_name#i#")>
	</cfif>
	<cfif len(listgetat(evaluate('spec_info#i#'),3,','))>
		<cfset 'cost_id#i#'=''>
		<cfset 'net_maliyet#i#'=listgetat(evaluate('spec_info#i#'),9,',')>
		<cfset 'extra_cost#i#'=listgetat(evaluate('spec_info#i#'),10,',')>
	</cfif>
</cfif>

<!--- ***********************************************************************

<!---AYNI TARZ SPECT VARMI KONTROLU--->
<cfset row_spect_id=''>
<cfset attributes.main_spect_id=''>
<cfif IsStruct(session.basketww_camp[i][19])>
	<cfif IsStruct(session.basketww_camp[i][19]) and isdefined('spect_id') and len(spect_id)>
		<cfset row_spect_id=spect_id>
	</cfif>
  	<cfif len(session.basketww_camp[i][19].product_id) and len(session.basketww_camp[i][19].stock_id)>
		<cfscript>
		satir=0;
		form_stock_id_list="";
		form_amount_list="";
		form_sevk_list="";
		form_stock_id_list_2="";
		form_amount_list_2="";
		form_sevk_list_2="";
		if(len(session.basketww_camp[i][19].product_id) and len(session.basketww_camp[i][19].stock_id))
		  for(n=1;n lte StructCount(session.basketww_camp[i][19].spect_row);n=n+1)
			{
			satir=satir+1;
			if(session.basketww_camp[i][19].spect_row[n][9] eq 0)
			  {
				form_stock_id_list = listappend(form_stock_id_list,session.basketww_camp[i][19].spect_row[n][2],',');
				form_amount_list = listappend(form_amount_list,session.basketww_camp[i][19].spect_row[n][4],',');
				form_sevk_list = listappend(form_sevk_list,session.basketww_camp[i][19].spect_row[n][10],',');
			  }else{
				form_stock_id_list_2 = listappend(form_stock_id_list_2,session.basketww_camp[i][19].spect_row[n][2],',');
				form_amount_list_2 = listappend(form_amount_list_2,session.basketww_camp[i][19].spect_row[n][4],',');
				form_sevk_list_2 = listappend(form_sevk_list_2,session.basketww_camp[i][19].spect_row[n][10],',');
			  }
			}
		</cfscript>
		<cfquery name="GET_SPECT_ROW_COUNT" datasource="#DSN3#">
			SELECT 
				COUNT(SPECT_MAIN.STOCK_ID),SPECT_MAIN.SPECT_MAIN_ID
			FROM 
				SPECT_MAIN,SPECT_MAIN_ROW
			WHERE
				SPECT_MAIN.SPECT_MAIN_ID=SPECT_MAIN_ROW.SPECT_MAIN_ID
				AND SPECT_MAIN.STOCK_ID=#session.basketww_camp[i][19].stock_id#
			GROUP BY 
				SPECT_MAIN.SPECT_MAIN_ID
			HAVING 
				COUNT(SPECT_MAIN.STOCK_ID)=#satir#
		</cfquery>
		<cfset spect_list_id=valuelist(GET_SPECT_ROW_COUNT.SPECT_MAIN_ID,',')>
		<cfif listlen(spect_list_id,',')>
		  <cfset st=0>
		  <cfquery name="GET_SPECT" datasource="#dsn3#">
			SELECT 
				COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID),
				SPECT_MAIN.SPECT_MAIN_ID,
				SPECT_MAIN.SPECT_MAIN_NAME
			FROM 
				SPECT_MAIN_ROW,
				SPECT_MAIN
			WHERE
				SPECT_MAIN.SPECT_MAIN_ID IN (#spect_list_id#) AND
				SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND
				(
				<cfloop list="#form_stock_id_list#" index="stok">
				  <cfset st=st+1>
					(
					SPECT_MAIN_ROW.STOCK_ID=#stok# 
					AND SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list,st,',')#
					AND SPECT_MAIN_ROW.IS_PROPERTY=0
					AND SPECT_MAIN_ROW.IS_SEVK=#listgetat(form_sevk_list,st,',')#
					) 
				  <cfif listlen(form_stock_id_list) gt st>OR</cfif>
				</cfloop>
				<cfset st=0>
				<cfloop list="#form_stock_id_list_2#" index="stok_2">
				  <cfset st=st+1>
					<cfif listlen(form_stock_id_list_2) lt st or listlen(form_stock_id_list)>OR</cfif>
					(
					SPECT_MAIN_ROW.STOCK_ID=#stok_2# 
					AND	SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list_2,st,',')#
					AND SPECT_MAIN_ROW.IS_PROPERTY=1
					AND SPECT_MAIN_ROW.IS_SEVK=#listgetat(form_sevk_list_2,st,',')#
					)
				</cfloop>
				)
			GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME
			HAVING COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID)=#satir#
		  </cfquery>
		 </cfif>
	 
		<!--- session daki satira UYGUN MASTER SPEC YOKSA MASTER SPEC KAYDI YAPILIYOR--->
		<cfif not isdefined('GET_SPECT.SPECT_MAIN_ID') or not len(GET_SPECT.SPECT_MAIN_ID)>
			<cfquery name="ADD_VAR_SPECT" datasource="#dsn3#">
				INSERT
				INTO
					SPECT_MAIN
					(
						SPECT_MAIN_NAME,
						SPECT_TYPE,
						PRODUCT_ID,
						STOCK_ID,
						IS_TREE,
						RECORD_IP,
						RECORD_PAR,
						RECORD_DATE
					)
					VALUES
					(
						'#session.basketww_camp[i][19].spec_name#',
						1,
						#session.basketww_camp[i][19].product_id#,
						#session.basketww_camp[i][19].stock_id#,
						0,
						'#cgi.remote_addr#',
						#MEMBER_ID#,
						#now()#
					)
			</cfquery>
			<cfquery name="GET_MAX_ID" datasource="#dsn3#">
				SELECT MAX(SPECT_MAIN_ID) AS MAX_ID FROM SPECT_MAIN
			</cfquery>
			<cfset attributes.main_spect_id=get_max_id.max_id>
		
			<cfif IsStruct(session.basketww_camp[i][19].spect_row)>
			  <cfloop from="1" to="#StructCount(session.basketww_camp[i][19].spect_row)#" index="a">
				<cfif session.basketww_camp[i][19].spect_row[a][1]>
				<cfquery name="ADD_ROW" datasource="#dsn3#">
					INSERT
						INTO
					SPECT_MAIN_ROW
					(
						SPECT_MAIN_ID,
						PRODUCT_ID,
						STOCK_ID,
						AMOUNT,
						PRODUCT_NAME,
						IS_PROPERTY,
						IS_CONFIGURE,
						IS_SEVK,
						PROPERTY_ID,
						VARIATION_ID
					)
					VALUES
					(
						#attributes.main_spect_id#,
						<cfif len(session.basketww_camp[i][19].spect_row[a][1])>#session.basketww_camp[i][19].spect_row[a][1]#,<cfelse>NULL,</cfif>
						<cfif len(session.basketww_camp[i][19].spect_row[a][2])>#session.basketww_camp[i][19].spect_row[a][2]#<cfelse>NULL</cfif>,
						<cfif len(session.basketww_camp[i][19].spect_row[a][4])>#session.basketww_camp[i][19].spect_row[a][4]#,<cfelse>0,</cfif>
						'#session.basketww_camp[i][19].spect_row[a][3]#',
						<cfif session.basketww_camp[i][19].spect_row[a][9] eq 1>1<cfelse>0</cfif>,
						<cfif session.basketww_camp[i][19].spect_row[a][7] eq 1>1<cfelse>0</cfif>,
						<cfif session.basketww_camp[i][19].spect_row[a][10] eq 1>1<cfelse>0</cfif>,
						<cfif len(session.basketww_camp[i][19].spect_row[a][11])>#session.basketww_camp[i][19].spect_row[a][11]#<cfelse>NULL</cfif>,
						<cfif len(session.basketww_camp[i][19].spect_row[a][12])>#session.basketww_camp[i][19].spect_row[a][12]#<cfelse>NULL</cfif>
					)
				</cfquery>
				</cfif>
			  </cfloop>
			</cfif>
		<cfelse>
			<cfset attributes.main_spect_id=GET_SPECT.SPECT_MAIN_ID>
		</cfif>
		<!--- //session daki satira UYGUN MASTER SPEC YOKSA MASTER SPEC KAYDI YAPILIYOR--->
	</cfif>
<cfelse>
<!--- session da spect yoksa --->
	<cfquery name="GET_TREE" datasource="#DSN3#">
		SELECT 
			*
		FROM
			PRODUCT_TREE
		WHERE
			STOCK_ID=#session.basketww_camp[i][8]#
	</cfquery>
	<cfif GET_TREE.RECORDCOUNT>
		<cfset stock_id_list=ValueList(GET_TREE.RELATED_ID,',')>
		<cfset stock_id_list=ListAppend(stock_id_list,GET_TREE.STOCK_ID,',')>
		<cfquery name="GET_PROD_ID_ALL" datasource="#DSN3#">
			SELECT PRODUCT_ID,STOCK_ID,PRODUCT_NAME,PROPERTY FROM STOCKS WHERE STOCK_ID IN (#stock_id_list#)
		</cfquery>
		<cfscript>
			satir=0;
			form_stock_id_list="";
			form_amount_list="";
			form_sevk_list="";
			for(n=1;n lte GET_TREE.RECORDCOUNT;n=n+1)
			{
				form_stock_id_list = listappend(form_stock_id_list,GET_TREE.RELATED_ID[n],',');
				form_amount_list = listappend(form_amount_list,GET_TREE.AMOUNT[n],',');
				if(GET_TREE.IS_SEVK[n] eq 1)
					form_sevk_list = listappend(form_sevk_list,1,',');
				else
					form_sevk_list = listappend(form_sevk_list,0,',');
			}
		</cfscript>
		<cfquery name="GET_SPECT_ROW_COUNT" datasource="#DSN3#">
			SELECT 
				COUNT(SPECT_MAIN.STOCK_ID),
				SPECT_MAIN.SPECT_MAIN_ID
			FROM 
				SPECT_MAIN,SPECT_MAIN_ROW
			WHERE
				SPECT_MAIN.SPECT_MAIN_ID=SPECT_MAIN_ROW.SPECT_MAIN_ID
				AND SPECT_MAIN.STOCK_ID=#session.basketww_camp[i][8]#
			GROUP BY 
				SPECT_MAIN.SPECT_MAIN_ID
			HAVING 
				COUNT(SPECT_MAIN.STOCK_ID)=#GET_TREE.RECORDCOUNT#
		</cfquery>
		<cfset spect_list_id=valuelist(GET_SPECT_ROW_COUNT.SPECT_MAIN_ID,',')>
		<cfif listlen(spect_list_id,',')>
			<cfset st=0>
			<cfquery name="GET_SPECT" datasource="#dsn3#">
				SELECT 
					COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID),
					SPECT_MAIN.SPECT_MAIN_ID,
					SPECT_MAIN.SPECT_MAIN_NAME
				FROM 
					SPECT_MAIN_ROW ,
					SPECT_MAIN
				WHERE
					SPECT_MAIN.SPECT_MAIN_ID IN (#spect_list_id#) AND
					SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND
					(
						<cfloop list="#form_stock_id_list#" index="stok">
							<cfset st=st+1>
							(
								SPECT_MAIN_ROW.STOCK_ID=#stok# 
								AND SPECT_MAIN_ROW.AMOUNT=#listgetat(form_amount_list,st,',')#
								AND SPECT_MAIN_ROW.IS_PROPERTY=0
								AND IS_SEVK=#listgetat(form_sevk_list,st,',')#
							) 
							<cfif listlen(form_stock_id_list) gt st>OR</cfif>
						</cfloop>
					)
				GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME
				HAVING COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID)=#GET_TREE.RECORDCOUNT#
			</cfquery>
		</cfif>

		<cfif not isdefined('GET_SPECT.SPECT_MAIN_ID') or not len(GET_SPECT.SPECT_MAIN_ID)>
			<cfquery name="ADD_VAR_SPECT" datasource="#dsn3#">
				INSERT
					INTO
				SPECT_MAIN
				(
					SPECT_MAIN_NAME,
					SPECT_TYPE,
					PRODUCT_ID,
					STOCK_ID,
					IS_TREE,
					RECORD_IP,
					RECORD_PAR,
					RECORD_DATE
				)
				VALUES
				(
					'#session.basketww_camp[i][2]#',
					1,
					#session.basketww_camp[i][1]#,
					#session.basketww_camp[i][8]#,
					1,
					'#cgi.remote_addr#',
					#MEMBER_ID#,
					#now()#
				)
			</cfquery>
			<cfquery name="GET_MAX_ID" datasource="#dsn3#">
				SELECT MAX(SPECT_MAIN_ID) AS MAX_ID FROM SPECT_MAIN
			</cfquery>
			<cfset attributes.main_spect_id=get_max_id.max_id>
	
			<cfloop query="GET_TREE">
				<cfquery name="GET_PROD_ID" dbtype="query">
					SELECT PRODUCT_ID,PRODUCT_NAME,PROPERTY FROM GET_PROD_ID_ALL WHERE STOCK_ID=#GET_TREE.RELATED_ID#
				</cfquery>
				<cfquery name="ADD_ROW" datasource="#dsn3#">
					INSERT
					INTO
						SPECT_MAIN_ROW
						(
							SPECT_MAIN_ID,
							PRODUCT_ID,
							STOCK_ID,
							AMOUNT,
							PRODUCT_NAME,
							IS_PROPERTY,
							IS_CONFIGURE,
							IS_SEVK
						)
						VALUES
						(
							#get_max_id.max_id#,
							<cfif isdefined('GET_PROD_ID.PRODUCT_ID') and len(GET_PROD_ID.PRODUCT_ID)>#GET_PROD_ID.PRODUCT_ID#<cfelse>NULL</cfif>,
							#GET_TREE.RELATED_ID#,
							<cfif len(GET_TREE.AMOUNT)>#GET_TREE.AMOUNT#<cfelse>0</cfif>,
							<cfif len(GET_PROD_ID.PRODUCT_NAME)>'#GET_PROD_ID.PRODUCT_NAME#'<cfelse>NULL</cfif>,
							0,
							<cfif GET_TREE.IS_CONFIGURE eq 1>1<cfelse>0</cfif>,
							<cfif GET_TREE.IS_SEVK eq 1>1<cfelse>0</cfif>
						)
				</cfquery>
			</cfloop>
			<!--- //AGACA UYGUN MASTER SPEC YOKSA MASTER SPEC KAYDI YAPILIYOR--->
		<cfelse>
			<cfset attributes.main_spect_id=GET_SPECT.SPECT_MAIN_ID>
		</cfif>
	</cfif>	
</cfif>

<cfif isdefined('attributes.main_spect_id') and len(attributes.main_spect_id)>
	<cfquery name="GET_MAIN_SPECT" datasource="#DSN3#">
		SELECT 
			SPECT_MAIN.SPECT_MAIN_NAME,
			SPECT_MAIN.SPECT_TYPE,
			SPECT_MAIN.STOCK_ID MAIN_STOCK_ID,
			SPECT_MAIN.PRODUCT_ID MAIN_PRODUCT_ID,
			SPECT_MAIN.IS_TREE,
			SPECT_MAIN_ROW.* 
		FROM 
			SPECT_MAIN,
			SPECT_MAIN_ROW
		WHERE
			SPECT_MAIN.SPECT_MAIN_ID=#attributes.main_spect_id#
			AND SPECT_MAIN.SPECT_MAIN_ID=SPECT_MAIN_ROW.SPECT_MAIN_ID
	</cfquery>
	<cfset product_id_list=listdeleteduplicates(valuelist(GET_MAIN_SPECT.PRODUCT_ID,','))><!--- AGAC VEYA MASTER SPECTEKI TUM URUNLERIN PRODUCT_ID ALIYORUZ--->
	<cfset product_id_list=ListAppend(product_id_list,session.basketww_camp[i][1],',')>
	<!--- uyenin fiyat listesini bulmak icin--->
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#dsn3#">
			SELECT
				PRICE_CAT
			FROM
				#dsn_alias#.COMPANY_CREDIT
			WHERE
				COMPANY_ID = #attributes.company_id#  AND
				OUR_COMPANY_ID = #int_comp_id#
		</cfquery>
		<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
			<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
		<cfelse>
			<cfquery name="GET_COMP_CAT" datasource="#dsn3#">
				SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = #attributes.company_id#
			</cfquery>
			<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
				SELECT 
					PRICE_CATID
				FROM
					PRICE_CAT
				WHERE
					COMPANY_CAT LIKE '%,#GET_COMP_CAT.COMPANYCAT_ID#,%'
			</cfquery>
			<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_COMP_CAT" datasource="#DSN3#">
			SELECT CONSUMER_CAT_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE '%,#get_comp_cat.consumer_cat_id#,%'
		</cfquery>
		<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
	</cfif>
	<!--- //uyenin fiyat listesini bulmak icin--->
	
	<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
		<cfquery name="GET_PRICE" datasource="#dsn3#">
			SELECT
				PRICE_STANDART.PRODUCT_ID,
				PRICE_STANDART.MONEY,
				PRICE_STANDART.PRICE
			FROM
				PRICE PRICE_STANDART,	
				PRODUCT_UNIT
			WHERE
				PRICE_STANDART.PRICE_CATID=#attributes.price_catid# AND
				PRICE_STANDART.STARTDATE< #now()# AND 
				(PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
				PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
				PRICE_STANDART.PRODUCT_ID IN (#product_id_list#) AND 
				PRODUCT_UNIT.IS_MAIN = 1
		</cfquery>
	</cfif>
	<cfquery name="GET_PRICE_STANDART" datasource="#dsn3#">
		SELECT
			PRICE_STANDART.PRODUCT_ID,
			PRICE_STANDART.MONEY,
			PRICE_STANDART.PRICE
		FROM
			PRODUCT,
			PRICE_STANDART
		WHERE
			PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
			PURCHASESALES = 1 AND
			PRICESTANDART_STATUS = 1 AND
			PRODUCT.PRODUCT_ID IN (#product_id_list#)
	</cfquery>
	<!--- //tum sayfadaki urunler icin fiyatları aliyor sonra query of query ile cekecek--->

	<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
		<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
			SELECT
				*
			FROM
				GET_PRICE
			WHERE
				PRODUCT_ID=#GET_MAIN_SPECT.MAIN_PRODUCT_ID#
		  </cfquery>
	</cfif>
	<cfif not isdefined("GET_PRICE_MAIN_PROD") or GET_PRICE_MAIN_PROD.RECORDCOUNT eq 0>
		<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">

			SELECT
				*
			FROM
				GET_PRICE_STANDART
			WHERE
				PRODUCT_ID=#GET_MAIN_SPECT.MAIN_PRODUCT_ID#
		</cfquery>
	</cfif>
	<cfquery name="ADD_VAR_SPECT" datasource="#dsn3#">
		INSERT
		INTO
			SPECTS
			(
				SPECT_MAIN_ID,
				SPECT_VAR_NAME,
				SPECT_TYPE,
				PRODUCT_ID,
				STOCK_ID,
				<!---TOTAL_AMOUNT,
				 OTHER_MONEY_CURRENCY,
				OTHER_TOTAL_AMOUNT, --->
				PRODUCT_AMOUNT,
				PRODUCT_AMOUNT_CURRENCY,
				IS_TREE,
				RECORD_IP,
				RECORD_PAR,
				RECORD_DATE
			)
			VALUES
			(
				#attributes.main_spect_id#,
				'#GET_MAIN_SPECT.SPECT_MAIN_NAME#',
				#GET_MAIN_SPECT.SPECT_TYPE#,
				#GET_MAIN_SPECT.MAIN_PRODUCT_ID#,
				#GET_MAIN_SPECT.MAIN_STOCK_ID#,
				<!--- <cfif len(GET_PRICE_MAIN_PROD.PRICE)>#GET_PRICE_MAIN_PROD.PRICE#,<cfelse>0,</cfif>
				'#GET_PRICE_MAIN_PROD.MONEY#', 
				<cfif len(attributes.other_toplam)>#attributes.other_toplam#,<cfelse>0,</cfif>--->
				<cfif len(GET_PRICE_MAIN_PROD.PRICE)>#GET_PRICE_MAIN_PROD.PRICE#,<cfelse>0,</cfif>
				<cfif len(GET_PRICE_MAIN_PROD.MONEY)>'#GET_PRICE_MAIN_PROD.MONEY#',<cfelse>'#session.pp.money#',</cfif>
				<cfif isdefined("GET_MAIN_SPECT.IS_TREE") and len(GET_MAIN_SPECT.IS_TREE)>#GET_MAIN_SPECT.IS_TREE#<cfelse>0</cfif>,
				'#cgi.remote_addr#',
				#MEMBER_ID#,
				#now()#
			)
	</cfquery>
	<cfquery name="GET_MAX_ID" datasource="#dsn3#">
		SELECT MAX(SPECT_VAR_ID) AS MAX_ID FROM SPECTS
	</cfquery>
		
	<cfquery name="get_money" datasource="#dsn3#">
		SELECT MONEY,RATE1,RATE2 FROM #dsn_alias#.SETUP_MONEY WHERE PERIOD_ID=#int_period_id# AND COMPANY_ID=#int_comp_id#
	</cfquery>
	<cfoutput query="get_money">
	  <cfquery name="add_spec_money" datasource="#dsn3#">
		INSERT INTO
			SPECT_MONEY
		(
			MONEY_TYPE,
			ACTION_ID,
			RATE2,
			RATE1,
			IS_SELECTED
		)
		VALUES
		(
			'#get_money.MONEY#',
			#GET_MAX_ID.MAX_ID#,
			#get_money.RATE2#,
			#get_money.RATE1#,
			<cfif get_money.MONEY eq int_money2>1<cfelse>0</cfif>
		)
	  </cfquery>
	</cfoutput>
		
	<cfset toplam_spect_tutar=0>
	<cfset toplam_spect_maliyet=0>
	<cfloop query="GET_MAIN_SPECT">
		<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			<cfquery name="GET_PRICE_PROD" dbtype="query">
				SELECT
					*
				FROM
					GET_PRICE
				WHERE
					PRODUCT_ID=#GET_MAIN_SPECT.PRODUCT_ID#
			  </cfquery>
		</cfif>
		<cfif not isdefined("GET_PRICE_PROD") or GET_PRICE_PROD.RECORDCOUNT eq 0>
			<cfquery name="GET_PRICE_PROD" dbtype="query">
				SELECT
					*
				FROM
					GET_PRICE_STANDART
				WHERE
					PRODUCT_ID=#GET_MAIN_SPECT.PRODUCT_ID#
			</cfquery>
		</cfif>
	
		<cfquery name="GET_COST" datasource="#dsn3#" maxrows="1">
			SELECT  
				PRODUCT_COST,
				PRODUCT_COST_ID,
				MONEY
			FROM
				#dsn1_alias#.PRODUCT_COST
			WHERE    
				PRODUCT_ID = #GET_MAIN_SPECT.PRODUCT_ID# AND
				START_DATE <= #now()#
			ORDER BY
				START_DATE DESC,
				RECORD_DATE DESC
		</cfquery>
		<cfif len(GET_COST.PRODUCT_COST)><cfset satir_maliyet=GET_COST.PRODUCT_COST><cfelse><cfset satir_maliyet=0></cfif>
		<!--- satir fiyat farki icin aceleden bu sekilde yapildi ancak sessiondan direk kayit yapilirsa spectler tum sorunlar cozulur--->
		<cfset satir_diff_price=0>
		<cfif IsStruct(session.basketww_camp[i][19])>
			<cfscript>
			  for(n=1;n lte StructCount(session.basketww_camp[i][19].spect_row);n=n+1)
				{
					if(session.basketww_camp[i][19].spect_row[n][2] eq GET_MAIN_SPECT.STOCK_ID and len(session.basketww_camp[i][19].spect_row[n][8]))
					{
						satir_diff_price=session.basketww_camp[i][19].spect_row[n][8];
						break;
					}
				}
			</cfscript>
		</cfif>
		<cfquery name="ADD_ROW" datasource="#dsn3#">
			INSERT
			INTO
				SPECTS_ROW
				(
					SPECT_ID,
					PRODUCT_ID,
					STOCK_ID,
					AMOUNT_VALUE,
					TOTAL_VALUE,
					MONEY_CURRENCY,
					PRODUCT_NAME,
					IS_PROPERTY,
					IS_CONFIGURE,
					DIFF_PRICE,
					PRODUCT_COST,
					PRODUCT_COST_MONEY,
					PRODUCT_COST_ID,
					IS_SEVK,
					PROPERTY_ID,
					VARIATION_ID
				)
				VALUES
				(
					#get_max_id.max_id#,
					<cfif len(GET_MAIN_SPECT.PRODUCT_ID)>#GET_MAIN_SPECT.PRODUCT_ID#<cfelse>NULL</cfif>,
					<cfif len(GET_MAIN_SPECT.STOCK_ID)>#GET_MAIN_SPECT.STOCK_ID#<cfelse>NULL</cfif>,
					<cfif len(GET_MAIN_SPECT.AMOUNT)>#GET_MAIN_SPECT.AMOUNT#<cfelse>0</cfif>,
					<cfif len(GET_PRICE_PROD.PRICE)>#GET_PRICE_PROD.PRICE#<cfelse>0</cfif>,
					'#GET_PRICE_PROD.MONEY#',
					<cfif len(GET_MAIN_SPECT.PRODUCT_NAME)>'#GET_MAIN_SPECT.PRODUCT_NAME#'<cfelse>NULL</cfif>,
					<cfif GET_MAIN_SPECT.IS_PROPERTY eq 1>1<cfelse>0</cfif>,
					<cfif GET_MAIN_SPECT.IS_CONFIGURE eq 1>1<cfelse>0</cfif>,
					#satir_diff_price#,
					#satir_maliyet#,
					<cfif len(GET_COST.MONEY)>'#GET_COST.MONEY#'<cfelse>NULL</cfif>,
					<cfif len(GET_COST.PRODUCT_COST_ID)>#GET_COST.PRODUCT_COST_ID#<cfelse>NULL</cfif>,
					<cfif GET_MAIN_SPECT.IS_SEVK eq 1>1<cfelse>0</cfif>,
					<cfif len(GET_MAIN_SPECT.PROPERTY_ID)>#PROPERTY_ID#<cfelse>NULL</cfif>,
					<cfif len(GET_MAIN_SPECT.VARIATION_ID)>#GET_MAIN_SPECT.VARIATION_ID#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfset GET_PRICE_PROD.RECORDCOUNT=0>
		
		<cfif len(GET_COST.MONEY) and GET_PRICE_MAIN_PROD.MONEY neq GET_COST.MONEY>
			<!--- ana urun fiyatla satir maliyet para birimi farkli ise once ana para birimine ordanda ana urun fiyat cinsine cevirir--->
			<cfquery name="GET_ROW_MONEY_COST" dbtype="query">
				SELECT	MONEY,RATE2 RATE FROM GET_MONEY WHERE MONEY='#GET_COST.MONEY#'
			</cfquery>
			<cfset satir_maliyet=satir_maliyet*GET_ROW_MONEY_COST.RATE>
			<cfif GET_PRICE_MAIN_PROD.MONEY neq session.pp.money>
				<cfquery name="GET_ROW_MONEY_COST_2" dbtype="query">
					SELECT	MONEY,RATE2 RATE FROM GET_MONEY WHERE MONEY='#GET_PRICE_MAIN_PROD.MONEY#'
				</cfquery>
				<cfif GET_ROW_MONEY_COST_2.RECORDCOUNT>
					<cfset satir_maliyet=satir_maliyet/GET_ROW_MONEY_COST_2.RATE>
				</cfif>
			</cfif>
		</cfif>
		<cfif GET_MAIN_SPECT.AMOUNT gt 1>
			<cfset satir_maliyet=satir_maliyet*GET_MAIN_SPECT.AMOUNT>
		</cfif>
		<cfset toplam_spect_maliyet=toplam_spect_maliyet+satir_maliyet>
		

		<cfset satir_urun_tutar=0>
		<cfif len(GET_PRICE_PROD.PRICE)>
			<cfset satir_urun_tutar=GET_PRICE_PROD.PRICE>
			<cfif GET_PRICE_MAIN_PROD.MONEY neq GET_PRICE_PROD.MONEY>
			<!--- ana urun fiyatla satir fiyat birimi farkli ise once ana para birimine ordanda ana urun fiyat cinsine cevirir--->
				<cfquery name="GET_ROW_MONEY" dbtype="query">
					SELECT	MONEY, RATE2 RATE FROM GET_MONEY WHERE MONEY='#GET_PRICE_PROD.MONEY#'
				</cfquery>
				<cfif GET_ROW_MONEY.RECORDCOUNT and len(GET_ROW_MONEY.RATE)>
					<cfset satir_urun_tutar=GET_PRICE_PROD.PRICE*GET_ROW_MONEY.RATE>
				</cfif>
				<cfquery name="GET_ROW_MONEY_2" dbtype="query">
					SELECT	MONEY,RATE2 RATE FROM GET_MONEY WHERE MONEY='#GET_PRICE_MAIN_PROD.MONEY#'
				</cfquery>
				<cfif GET_ROW_MONEY_2.RECORDCOUNT>
					<cfset satir_maliyet=satir_maliyet/GET_ROW_MONEY_2.RATE>
				</cfif>
			</cfif>
			<cfif GET_MAIN_SPECT.AMOUNT gt 1>
				<cfset satir_urun_tutar=satir_urun_tutar*GET_MAIN_SPECT.AMOUNT>
			</cfif>
			<cfset toplam_spect_tutar=toplam_spect_tutar+satir_urun_tutar>
		</cfif>
	</cfloop>
	<cfset toplam_spect_tutar_ep_money=0>
	<cfif GET_PRICE_MAIN_PROD.MONEY neq session.pp.money>
		<cfquery name="GET_ROW_MONEY_TOTAL" dbtype="query">
			SELECT	MONEY,RATE2 RATE FROM GET_MONEY WHERE MONEY='#GET_PRICE_MAIN_PROD.MONEY#'
		</cfquery>
		<cfif GET_ROW_MONEY_TOTAL.RECORDCOUNT>
			<cfset toplam_spect_tutar_ep_money=toplam_spect_tutar*GET_ROW_MONEY_TOTAL.RATE>
		</cfif>
	<cfelse>
		<cfset toplam_spect_tutar_ep_money=toplam_spect_tutar>
	</cfif>
	<cfquery name="UPD_SPEC_COST" datasource="#dsn3#">
		UPDATE 
			SPECTS 
		SET 	
			SPECT_COST=#toplam_spect_maliyet#,
			SPECT_COST_CURRENCY=<cfif len(GET_PRICE_MAIN_PROD.MONEY)>'#GET_PRICE_MAIN_PROD.MONEY#'<cfelse>'#session.pp.money#'</cfif>,
			OTHER_MONEY_CURRENCY=<cfif len(GET_PRICE_MAIN_PROD.MONEY)>'#GET_PRICE_MAIN_PROD.MONEY#'<cfelse>'#session.pp.money#'</cfif>,
			OTHER_TOTAL_AMOUNT=#toplam_spect_tutar#, 
			TOTAL_AMOUNT=#toplam_spect_tutar_ep_money#
		WHERE 
			SPECT_VAR_ID=#get_max_id.max_id#
	</cfquery>
	<cfset row_spect_id=get_max_id.max_id>
</cfif> --->
