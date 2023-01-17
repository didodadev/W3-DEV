<cffunction name="add_pre_order_rows" returntype="numeric" output="false">
	<cfargument name="stock_id" type="numeric" required="yes">
	<cfargument name="stock_amount" type="numeric" required="yes">
	<cfargument name="product_unit_id" default="">
	<cfargument name="is_promotion" default="0">
	<cfargument name="period_id" default="">
	<cfargument name="company_id" default="">
	<cfargument name="consumer_id" default="">
	<cfargument name="partner_id" default="">
	<cfargument name="is_commission" default="0">
	<cfargument name="sales_member_id" default="">
	<cfargument name="sales_cons_id" default="">
	<cfargument name="sales_member_type" default="">
	<cfargument name="price_catid" default="">
	<cfargument name="prom_work_type" default="">
	<cfargument name="is_nondelete_product" default="">
	<cfargument name="is_product_promotion_noneffect" default="">
	<cfargument name="catalog_id" default="">
	<cfargument name="is_general_prom" default="">
	<cfargument name="prom_product_price" default="">
	<cfargument name="prom_cost" default="">
	<cfargument name="prom_id" default="">
	<cfargument name="price" default="">
	<cfargument name="price_kdv" default="">
	<cfargument name="price_money" default="">
	<cfargument name="product_tax" default="">
	<cfargument name="stock_action_id" default="">
	<cfargument name="stock_action_type" default="">
	<cfargument name="prom_stock_amount" default="">
	<cfargument name="IS_PROM_ASIL_HEDIYE" default="">
	<cfargument name="PROM_FREE_STOCK_ID" default="">
	<cfargument name="PRICE_STANDARD" default="">
	<cfargument name="PRICE_STANDARD_KDV" default="">
	<cfargument name="PRICE_STANDARD_MONEY" default="">
	<cfargument name="TO_CONS" default="">
	<cfargument name="TO_COMP" default="">
	<cfargument name="TO_PAR" default="">
	<cfargument name="SALE_PARTNER_ID" default="">
	<cfargument name="SALE_CONSUMER_ID" default="">
	<cfargument name="prod_prom_action_type" default="">
<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
		<cfset cookie_name_ = createUUID()>
		<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
	</cfif>
	<cfscript>
		saleable_stock_id_list_='';
		not_added_stock_code_list='';
		non_find_stock_list = '';
		control_strategy_list_='';
		stock_strategy_list_='';
	</cfscript>
	<!--- temsilciye baglı fiyat listesi bulunuyor --->
	<cfif not len(arguments.price_catid)>
		<cfif not isdefined("int_period_id")>
			<cfscript>
				if (listfindnocase(partner_url,'#cgi.http_host#',';'))
				{
					int_comp_id = session.pp.our_company_id;
					int_period_id = session.pp.period_id;
					attributes.company_id = session.pp.company_id;
				}
				else if (listfindnocase(server_url,'#cgi.http_host#',';') )
				{	
					int_comp_id = session.ww.our_company_id;
					int_period_id = session.ww.period_id;
					if(isdefined('session.ww.userid'))
						attributes.consumer_id = session.ww.userid;
				}
				else if (listfindnocase(employee_url,'#cgi.http_host#',';') )
				{	
					int_comp_id = session.ep.company_id;
					int_period_id = session.ep.period_id;
				}
			</cfscript>
		</cfif>
		<cfif isdefined("arguments.company_id") and len(arguments.company_id)>
			<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
				SELECT PRICE_CAT FROM COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
			</cfquery>
			<cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
				<cfset arguments.price_catid = get_credit_limit.price_cat>
			<cfelse>		
				<cfquery name="GET_COMP_CAT" datasource="#dsn#">
					SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
				</cfquery>
				<cfquery name="GET_PRICE_CAT" datasource="#dsn3#">
					SELECT PRICE_CATID FROM PRICE_CAT WHERE COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
				</cfquery>
				<cfif get_price_cat.recordcount>
					<cfset arguments.price_catid=get_price_cat.price_catid>
				</cfif>		
			</cfif>
		<cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
			<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
				SELECT PRICE_CAT FROM COMPANY_CREDIT WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
			</cfquery>
			<cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
				<cfset arguments.price_catid = get_credit_limit.price_cat>
			<cfelse>		
				<cfquery name="GET_COMP_CAT" datasource="#dsn#">
					SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
				</cfquery>
				<cfquery name="GET_PRICE_CAT" datasource="#dsn3#">
					SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
				</cfquery>
				<cfif get_price_cat.recordcount>
					<cfset arguments.price_catid=get_price_cat.price_catid>
				</cfif>
			</cfif>
		</cfif>
		<cfif not len(arguments.price_catid)>
			<cfset arguments.price_catid=-2>
		</cfif>
	</cfif>
	<!---// temsilciye baglı fiyat listesi bulunuyor --->
	<cfquery name="get_all_stock" datasource="#dsn3#">
		SELECT
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_UNIT_ID,
			TAX,
			PROPERTY,
			PRODUCT_NAME,
			STOCK_CODE,
			STOCK_CODE_2,
			IS_ZERO_STOCK,
			IS_INVENTORY
		FROM
			STOCKS
		WHERE
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
			AND STOCK_STATUS = 1
			<cfif len(arguments.is_promotion) and is_promotion eq 0>
				AND IS_SALES = 1
			</cfif>
	</cfquery>
	<cfif get_all_stock.recordcount>
		<cfset row_product_id=get_all_stock.PRODUCT_ID>
		<cfif get_all_stock.IS_ZERO_STOCK neq 1 and get_all_stock.IS_INVENTORY neq 0> <!--- sıfır stokla calış secili degilse ve urun envantere dahilse satılabilir stok miktarı kontrol ediliyor--->
			<cfquery name="get_stock_last" datasource="#dsn3#">
				#dsn2_alias#.get_stock_last_function '#arguments.stock_id#'
			</cfquery>
			<cfquery name="GET_LAST_STOCKS" dbtype="query">
				SELECT SALEABLE_STOCK, STOCK_ID FROM get_stock_last WHERE SALEABLE_STOCK > 0
			</cfquery>
			<cfif get_last_stocks.recordcount>
				<cfset saleable_stock_amount=get_last_stocks.SALEABLE_STOCK>
			<cfelse>
				<cfset saleable_stock_amount=0>
			</cfif>
			<cfset saleable_stock_id_list_ =get_last_stocks.STOCK_ID>
		<cfelse>
			<cfset get_last_stocks.recordcount=0>
		</cfif>
		<cfif get_last_stocks.recordcount>
			<cfif len(get_last_stocks.SALEABLE_STOCK)>
				<!--- satılabilir stogu yeterli değilse stratejisi kontrol edilecek  --->
				<cfset 'use_saleable_stock_#arguments.stock_id#'=get_last_stocks.SALEABLE_STOCK>
				<cfif get_last_stocks.SALEABLE_STOCK lt arguments.stock_amount>
					<cfset control_strategy_list_=arguments.stock_id>
				</cfif>
			</cfif>
		<cfelse>
			<cfset control_strategy_list_=arguments.stock_id>
		</cfif>
		<cfif listlen(control_strategy_list_)><!--- satılabilir stogu yeterli olmayan urunlerin strateji bilgileri alınır --->
			<cfset add_alternative_prod_list_=''>
			<cfquery name="get_all_stock_strategy" datasource="#dsn3#">
				SELECT 
					SS.STOCK_ACTION_ID,SS.STOCK_ID,SS.PRODUCT_ID, 
					STOCK_A.STOCK_ACTION_TYPE
				FROM 
					STOCK_STRATEGY SS,
					SETUP_SALEABLE_STOCK_ACTION STOCK_A
				WHERE 
					SS.STOCK_ID IN (#control_strategy_list_#)
					AND SS.STRATEGY_TYPE = 0
					AND SS.STOCK_ACTION_ID = STOCK_A.STOCK_ACTION_ID
			</cfquery>
			<cfset stock_strategy_list_=valuelist(get_all_stock_strategy.STOCK_ID)>
			<cfset strategy_stock_id_=arguments.stock_id>
				<cfset 'row_stock_action_id_#strategy_stock_id_#' = get_all_stock_strategy.STOCK_ACTION_ID>
				<cfset 'row_stock_action_type_#strategy_stock_id_#' = get_all_stock_strategy.STOCK_ACTION_TYPE>
				<cfif get_all_stock_strategy.STOCK_ACTION_TYPE eq 4> <!--- hareket türü 4 ise alternatif urunleri kontrol edilir --->
					<cfif listfind(saleable_stock_id_list_,strategy_stock_id_) and isdefined('use_saleable_stock_#strategy_stock_id_#')><!--- satılabilir stogu var ama talebi karsılayamıyorsa, kalan kısım için stratejilere bakılır --->
						<cfset required_stock_amount=arguments.stock_amount-evaluate('use_saleable_stock_#strategy_stock_id_#')>
					<cfelse>
						<cfset required_stock_amount=arguments.stock_amount>
					</cfif>
					<cfquery name="get_alternative_prods" datasource="#dsn3#">
						SELECT
							AP.ALTERNATIVE_PRODUCT_ID,AP.ALTERNATIVE_PRODUCT_NO,
							AP.ALTERNATIVE_PRODUCT_AMOUNT,AP.START_DATE,AP.FINISH_DATE,
							S.STOCK_ID,S.IS_ZERO_STOCK,S.IS_INVENTORY,
							S.STOCK_ID AS ALTERNATIVE_STOCK_ID
						FROM
							ALTERNATIVE_PRODUCTS AP,
							STOCKS S
						WHERE
							S.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID
							AND AP.PRODUCT_ID IN (SELECT S2.PRODUCT_ID FROM STOCKS S2 WHERE STOCK_ID=#strategy_stock_id_#)
							AND S.STOCK_STATUS=1
							AND AP.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">
							AND AP.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(DATEADD('d',-1,now()))#">
							AND S.STOCK_STATUS = 1
							<cfif len(arguments.is_promotion) and is_promotion eq 0>
								AND S.IS_SALES = 1
							</cfif>
						ORDER BY AP.ALTERNATIVE_PRODUCT_NO		
					</cfquery>
					<cfif get_alternative_prods.recordcount neq 0><!--- satılabilir stogu olan alternatif urun yoksa asıl urunun sıfır stokla calıs parametresi kontrol edilir --->
						<cfset alternative_stock_list = ''>
						<cfquery name="get_stock_alternative" datasource="#dsn3#">
							SELECT SALEABLE_STOCK,STOCK_ID FROM #dsn2_alias#.GET_STOCK_LAST WHERE STOCK_ID IN (#valuelist(get_alternative_prods.ALTERNATIVE_STOCK_ID)#) ORDER BY STOCK_ID
						</cfquery>
						<cfset alternative_stock_list = listsort(valuelist(get_stock_alternative.stock_id),'numeric','ASC')>
						<cfset 'add_alternative_prod_list_#strategy_stock_id_#'="">
						<cfoutput query="get_alternative_prods">
							<cfif required_stock_amount neq 0>
								<cfif isdefined("alternative_stock_list") and listfindnocase(alternative_stock_list,alternative_stock_id)>
									<cfset saleable_stock_amount = get_stock_alternative.SALEABLE_STOCK[listfind(alternative_stock_list,alternative_stock_id)]>
								<cfelse>
									<cfset saleable_stock_amount = 0>
								</cfif>	
								<cfif get_alternative_prods.IS_INVENTORY eq 0 or get_alternative_prods.IS_ZERO_STOCK eq 1> <!--- alternatif ürun icins sıfır stokla calıs secilmisse veya envantere dahil degilse --->
									<cfset 'add_alternative_prod_list_#strategy_stock_id_#'=listappend(evaluate('add_alternative_prod_list_#strategy_stock_id_#'),get_alternative_prods.ALTERNATIVE_STOCK_ID)>
									<cfset 'alternative_prod_amount_#ALTERNATIVE_STOCK_ID#'=Int(get_alternative_prods.ALTERNATIVE_PRODUCT_AMOUNT*required_stock_amount)> <!--- kullanılacak miktar --->
									<cfset 'pre_prod_amount_#ALTERNATIVE_STOCK_ID#'=required_stock_amount> <!--- kullanılacak miktar --->
									<cfset required_stock_amount=0>
								<cfelseif saleable_stock_amount neq 0 and Int(saleable_stock_amount/ALTERNATIVE_PRODUCT_AMOUNT) neq 0> <!--- satılabilir stogu varsa --->
									<cfset 'add_alternative_prod_list_#strategy_stock_id_#'=listappend(evaluate('add_alternative_prod_list_#strategy_stock_id_#'),get_alternative_prods.ALTERNATIVE_STOCK_ID)>
									<cfif Int(get_alternative_prods.ALTERNATIVE_PRODUCT_AMOUNT*required_stock_amount) gt saleable_stock_amount> <!--- gerekli olan miktar alternatif ürünün satılabilir stogundan fazlaysa --->
										<cfset temp_add_amount=Int(saleable_stock_amount/ALTERNATIVE_PRODUCT_AMOUNT)> <!--- alternatif urunun satılabilir stogu asıl urunun için gerekli olan miktarın ne kadarını karıslayabiliyor --->
										<cfset 'alternative_prod_amount_#ALTERNATIVE_STOCK_ID#'=temp_add_amount*ALTERNATIVE_PRODUCT_AMOUNT> <!--- kullanılacak miktar --->
										<cfset required_stock_amount=required_stock_amount-temp_add_amount>
										<cfset 'pre_prod_amount_#ALTERNATIVE_STOCK_ID#'=temp_add_amount> <!---alternatif urunden eklenen miktarın asıl urunden karşılıgı --->
									<cfelse>
										<cfset 'alternative_prod_amount_#ALTERNATIVE_STOCK_ID#'=Int(get_alternative_prods.ALTERNATIVE_PRODUCT_AMOUNT*required_stock_amount)> <!--- kullanılacak miktar --->
										<cfset 'pre_prod_amount_#ALTERNATIVE_STOCK_ID#'=required_stock_amount> <!--- kullanılacak miktar --->
										<cfset required_stock_amount=0>
									</cfif>
								</cfif>
							</cfif>
						</cfoutput>
					<cfelse>
						<cfquery name="get_action_type" datasource="#dsn3#">
							SELECT TOP 1 STOCK_ACTION_ID FROM SETUP_SALEABLE_STOCK_ACTION WHERE STOCK_ACTION_TYPE = 1
						</cfquery>
						<cfset 'row_stock_action_id_#strategy_stock_id_#' = get_action_type.stock_action_id>
						<cfset 'row_stock_action_type_#strategy_stock_id_#' = 1> <!--- hareket türü 4 oldugu halde yeterli stokta alternatif ürünü yoksa hareket turu 1 set edilir --->
					</cfif>
				</cfif>
		</cfif>
		<cfset add_stock_list_=''>
		<cfscript>
			add_row_info = QueryNew("STOCK_ID,AMOUNT,PRE_PRODUCT_ID,PRE_STOCK_ID,PRE_STOCK_AMOUNT,STOCK_ACTION_ID,STOCK_ACTION_TYPE","Integer,Double,Integer,Integer,Double,Integer,Integer");
			add_row_info_count = 0;
			/*for(list_i=1; list_i lte listlen(list_stock_id_);list_i=list_i+1)
			{*/
				temp_stock_id=arguments.stock_id;
				'is_finish_#temp_stock_id#'=0;
				if(get_all_stock.IS_INVENTORY eq 0 or get_all_stock.IS_ZERO_STOCK eq 1) //envantere dahil degilse veya sıfır stokla calısıyorsa tumu eklenir
				{
					add_row_info_count = add_row_info_count + 1;
					QueryAddRow(add_row_info,1);
					QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
					QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count);
					QuerySetCell(add_row_info,"PRE_PRODUCT_ID",row_product_id,add_row_info_count);
					QuerySetCell(add_row_info,"AMOUNT",arguments.stock_amount,add_row_info_count);
					QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",arguments.stock_amount,add_row_info_count);
					'is_finish_#temp_stock_id#'=1;
				}
				else if(listfind(saleable_stock_id_list_,temp_stock_id)) //satılabilir stogu varsa
				{
					add_row_info_count = add_row_info_count + 1;
					QueryAddRow(add_row_info,1);
					QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
					QuerySetCell(add_row_info,"PRE_PRODUCT_ID",row_product_id,add_row_info_count);
					QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count);
						if(len(get_last_stocks.SALEABLE_STOCK) and get_last_stocks.SALEABLE_STOCK lt arguments.stock_amount)
						{
							QuerySetCell(add_row_info,"AMOUNT",get_last_stocks.SALEABLE_STOCK,add_row_info_count);
							QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",get_last_stocks.SALEABLE_STOCK,add_row_info_count);
						}
						else
						{
							QuerySetCell(add_row_info,"AMOUNT",arguments.stock_amount,add_row_info_count);
							QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",arguments.stock_amount,add_row_info_count);
							'is_finish_#temp_stock_id#'=1;
						}
				}
				if(evaluate('is_finish_#temp_stock_id#') neq 1 and listfind(stock_strategy_list_,temp_stock_id)) //satılabilir stogu yeterli olmayıp stok stratejisine gore eklenecek urunler
				{
					if( isdefined('row_stock_action_type_#temp_stock_id#') and evaluate('row_stock_action_type_#temp_stock_id#') eq 4 and isdefined('add_alternative_prod_list_#temp_stock_id#') and len(evaluate('add_alternative_prod_list_#temp_stock_id#'))) //stratejiye gore hareket turu alternatif urun verilir ise, urun miktarını karsılayacak kadar alternatif urunlerinden eklenir
					{
						for(kk=1; kk lte listlen(evaluate('add_alternative_prod_list_#temp_stock_id#'));kk=kk+1) //alternatif urunler ekleniyor
						{
							temp_alter_stock_id_=listgetat(evaluate('add_alternative_prod_list_#temp_stock_id#'),kk);
							add_row_info_count = add_row_info_count + 1;
							QueryAddRow(add_row_info,1);
							QuerySetCell(add_row_info,"STOCK_ID",temp_alter_stock_id_,add_row_info_count);
							QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count); //alternatifi eklenen asıl urunu bu alanda tutuyoruz
							QuerySetCell(add_row_info,"PRE_PRODUCT_ID",row_product_id,add_row_info_count);
							QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",evaluate('pre_prod_amount_#temp_alter_stock_id_#'),add_row_info_count);
							QuerySetCell(add_row_info,"STOCK_ACTION_ID",evaluate('row_stock_action_id_#temp_stock_id#'),add_row_info_count);
							QuerySetCell(add_row_info,"STOCK_ACTION_TYPE",evaluate('row_stock_action_type_#temp_stock_id#'),add_row_info_count);
							QuerySetCell(add_row_info,"AMOUNT",evaluate('alternative_prod_amount_#temp_alter_stock_id_#'),add_row_info_count);
						}
					}
					else if(evaluate('is_finish_#temp_stock_id#') neq 1 and isdefined('row_stock_action_type_#temp_stock_id#') and listfind('1,2,3',evaluate('row_stock_action_type_#temp_stock_id#')) )
					{
						add_row_info_count = add_row_info_count + 1;
						QueryAddRow(add_row_info,1);
						QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
						QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count);
						QuerySetCell(add_row_info,"PRE_PRODUCT_ID",row_product_id,add_row_info_count);
						QuerySetCell(add_row_info,"STOCK_ACTION_ID",evaluate('row_stock_action_id_#temp_stock_id#'),add_row_info_count);
						QuerySetCell(add_row_info,"STOCK_ACTION_TYPE",evaluate('row_stock_action_type_#temp_stock_id#'),add_row_info_count);
						if( listfind(saleable_stock_id_list_,temp_stock_id) and isdefined('use_saleable_stock_#temp_stock_id#'))
						{
							QuerySetCell(add_row_info,"AMOUNT",(arguments.stock_amount-evaluate('use_saleable_stock_#temp_stock_id#')),add_row_info_count);
							QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",(arguments.stock_amount-evaluate('use_saleable_stock_#temp_stock_id#')),add_row_info_count);
						}
						else
						{
							QuerySetCell(add_row_info,"AMOUNT",arguments.stock_amount,add_row_info_count);
							QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",arguments.stock_amount,add_row_info_count);
						}
					}
				}
				else if(not listfind(saleable_stock_id_list_,temp_stock_id) and get_all_stock.IS_ZERO_STOCK neq 1 and get_all_stock.IS_INVENTORY neq 0)
					not_added_stock_code_list=listappend(not_added_stock_code_list,get_all_stock.STOCK_CODE);
			//}
		</cfscript>
	<cfelse>
		<cfset add_row_info.recordcount=0>
		<cfif arguments.is_promotion neq 1><!--- promosyon urunu ekleme degilse --->
			<script type="text/javascript">
				alert("Ürün Kaydı Bulunamadı'> !");
			</script>
		</cfif>
	</cfif>
	<cfif listlen(not_added_stock_code_list) neq 0>
		<cfif arguments.is_promotion neq 1>
			<script type="text/javascript">
				alert("<cfoutput>#not_added_stock_code_list#</cfoutput> Stok Kodlu Ürünün Yeterli Stoğu Bulunmamaktadır!");
			</script>
		</cfif>
	</cfif>
	<cfif add_row_info.recordcount>
		<cfset add_row_stock_id_list = valuelist(add_row_info.STOCK_ID)>
		<cfquery name="get_last_stock_info" datasource="#dsn3#">
			SELECT
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_UNIT_ID,
				TAX,
				PROPERTY,
				PRODUCT_NAME,
				STOCK_CODE,
				IS_ZERO_STOCK
			FROM
				STOCKS
			WHERE
				STOCK_ID IN (#add_row_stock_id_list#)
			ORDER BY STOCK_ID
		</cfquery>
		<cfset add_row_stock_id_list = valuelist(get_last_stock_info.STOCK_ID)>
		<cfset add_basket_express_prod_id_list = valuelist(add_row_info.PRE_PRODUCT_ID)><!--- fiyatlar asıl urunlere gore alınıyor, alternatif urun içinde yerine eklendigi asıl urunun fiyatı getiriliyor --->
		
		<!--- //urunlere ait fiyatlar cekiliyor --->
		<cfif not isdefined("get_price_all.recordcount")>
			<cfquery name="GET_PRICE_EXCEPTIONS_ALL" datasource="#dsn3#">
				SELECT
					*
				FROM 
					PRICE_CAT_EXCEPTIONS
				WHERE
					ACT_TYPE = 1 AND
				<cfif isdefined("arguments.company_id") and len(arguments.company_id)>
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
				<cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
				<cfelse>
					1=0
				</cfif>	
			</cfquery>
			<cfquery name="get_price_exceptions_pid" dbtype="query">
				SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_ID IS NOT NULL
			</cfquery>
			<cfquery name="get_price_exceptions_pcatid" dbtype="query">
				SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_CATID IS NOT NULL
			</cfquery>
			<cfquery name="get_price_exceptions_brid" dbtype="query">
				SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE BRAND_ID IS NOT NULL
			</cfquery>
			<cfquery name="get_price_all" datasource="#dsn3#">
				SELECT  
					P.CATALOG_ID,
					P.UNIT,
					P.PRICE PRICE,
					P.PRICE_KDV,
					P.PRODUCT_ID,
					P.MONEY,
					P.PRICE_CATID
				FROM 
					PRICE P,
					PRODUCT PR,
					PRODUCT_CAT
				WHERE 
					PRICE > 0 AND
					<cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
					PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
					</cfif>
					PRODUCT_CAT.PRODUCT_CATID = PR.PRODUCT_CATID AND 
					P.PRODUCT_ID = PR.PRODUCT_ID AND 
					ISNULL(P.STOCK_ID,0)=0 AND
					ISNULL(P.SPECT_VAR_ID,0)=0 AND
					P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#"> AND
					(
						P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
						(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL)
					)
					AND
					(
					<cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount>
						<cfif get_price_exceptions_pid.recordcount>
							P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#)
						</cfif>
						<cfif get_price_exceptions_pcatid.recordcount>
							<cfif get_price_exceptions_pid.recordcount>AND </cfif> PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#)
						</cfif>
						<cfif get_price_exceptions_brid.recordcount>
							<cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount>AND </cfif> 
							(PR.BRAND_ID NOT IN (#valuelist(get_price_exceptions_brid.BRAND_ID)#) OR PR.BRAND_ID IS NULL )
						</cfif>
					<cfelse>
					1=1
					</cfif>
					)
				<cfif get_price_exceptions_pid.recordcount>
				UNION
				SELECT 
					CATALOG_ID,
					UNIT,
					PRICE,
					PRICE_KDV,
					PRODUCT_ID,
					MONEY,
					PRICE_CATID
				FROM
					PRICE
				WHERE
					PRICE > 0 AND
					<cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
					PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
					</cfif>
					ISNULL(STOCK_ID,0)=0 AND
					ISNULL(SPECT_VAR_ID,0)=0 AND
					STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
					(FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR FINISHDATE IS NULL) AND
					<cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
						<cfoutput query="get_price_exceptions_pid">
						(PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
						<cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
						OR
						</cfif>
						</cfoutput>
					<cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
				</cfif>
				<cfif get_price_exceptions_pcatid.recordcount>
				UNION
				SELECT
					P.CATALOG_ID,
					P.UNIT,
					P.PRICE PRICE,
					P.PRICE_KDV,
					P.PRODUCT_ID,
					P.MONEY,
					P.PRICE_CATID
				FROM
					PRICE P,
					PRODUCT PR
				WHERE 
					PRICE > 0 AND
					<cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
					PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
					</cfif>
					<cfif get_price_exceptions_pid.recordcount>
					P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
					</cfif>
					P.PRODUCT_ID = PR.PRODUCT_ID AND
					ISNULL(P.STOCK_ID,0)=0 AND
					ISNULL(P.SPECT_VAR_ID,0)=0 AND
					P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
					(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
					<cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
					<cfoutput query="get_price_exceptions_pcatid">
					(PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
					<cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
					OR
					</cfif>
					</cfoutput>
					<cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
				</cfif>
				<cfif get_price_exceptions_brid.recordcount>
				UNION
				SELECT
					P.CATALOG_ID,
					P.UNIT,
					P.PRICE PRICE,
					P.PRICE_KDV,
					P.PRODUCT_ID,
					P.MONEY,
					P.PRICE_CATID
				FROM
					PRICE P,
					PRODUCT PR
				WHERE 
					PRICE > 0 AND
					<cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
					PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
					</cfif>
					<cfif get_price_exceptions_pid.recordcount>
					P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
					</cfif>
					<cfif get_price_exceptions_pcatid.recordcount>
					PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
					</cfif>
					P.PRODUCT_ID = PR.PRODUCT_ID AND
					ISNULL(P.STOCK_ID,0)=0 AND
					ISNULL(P.SPECT_VAR_ID,0)=0 AND
					P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
					(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
					<cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>
					<cfoutput query="get_price_exceptions_brid">
					(PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
					<cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
					OR
					</cfif>
					</cfoutput>
					<cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>
				</cfif>
			</cfquery>
		</cfif>
		<!--- //urunlere ait fiyatlar cekiliyor --->
		
		<cfquery name="get_all_price_standart" datasource="#dsn3#">
			SELECT
				PRICE_STANDART.PRODUCT_ID,
				PRICE,
				PRICE_KDV,
				IS_KDV,
				MONEY 
			FROM 
				PRICE_STANDART,
				PRODUCT_UNIT
			WHERE
				PRICE_STANDART.PURCHASESALES = 1 AND
				PRODUCT_UNIT.IS_MAIN = 1 AND 
				PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
				PRICE_STANDART.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
				PRICE_STANDART.PRODUCT_ID IN (#add_basket_express_prod_id_list#)
		</cfquery>
		<cfoutput query="add_row_info">
			<cfquery name="GET_PRICE" dbtype="query">
				SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM get_all_price_standart WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.PRE_PRODUCT_ID#">
			</cfquery>
			<cfif get_price_all.recordcount>
				<cfquery name="get_p" dbtype="query">
					SELECT * FROM get_price_all WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_stock.PRODUCT_UNIT_ID#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_stock.PRODUCT_ID#">
				</cfquery>
			<cfelse>
				<cfset get_p.recordcount=0>
			</cfif>
			<cfif is_promotion neq 1> <!--- promosyon olarak eklenecek urun degilse sepette olup olmadıgı kontrol ediliyor, promosyonlar kendi dosyalarında kontrol ediliyor --->
				<cfquery name="control_same_prod_exists" datasource="#dsn3#">
					SELECT 
						ORDER_ROW_ID,QUANTITY,PRE_STOCK_AMOUNT
					FROM
						ORDER_PRE_ROWS
					WHERE
						STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.stock_id#">
						AND ISNULL(PRE_STOCK_ID,STOCK_ID)=#add_row_info.pre_stock_id# <!--- asıl urun ve alternatif urun bazında kontrol ediliyor --->
						AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.pre_product_id#">
						<cfif get_p.recordcount>
							AND PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#get_p.price#">
							AND PRICE_KDV = <cfqueryparam cfsqltype="cf_sql_float" value="#get_p.price_kdv#">
							AND PRICE_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_p.money#">
						<cfelse>
							AND PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#get_price.price#">
							AND PRICE_KDV = <cfqueryparam cfsqltype="cf_sql_float" value="#get_price.price_kdv#">
							AND PRICE_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_price.money#">
						</cfif>
						<cfif len(add_row_info.stock_action_type)>
							AND	STOCK_ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.stock_action_type#">
						<cfelse>
							AND STOCK_ACTION_TYPE IS NULL
						</cfif>
							AND PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last_stock_info.PRODUCT_UNIT_ID#">
							AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0
							AND ISNULL(IS_COMMISSION,0)=0
						<cfif isdefined('arguments.consumer_id') and len(arguments.consumer_id)>
							AND TO_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
						<cfelse>
							AND TO_CONS IS NULL
						</cfif>
						<cfif isdefined('arguments.company_id') and len(arguments.company_id)>
							AND TO_COMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
						<cfelse>
							AND TO_COMP IS NULL
						</cfif>
						<cfif isdefined('arguments.partner_id') and len(arguments.partner_id)>
							AND TO_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
						<cfelse>
							AND TO_PAR IS NULL
						</cfif>
							AND RECORD_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
						<cfif isdefined("session.pp")>AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelse>AND RECORD_PAR IS NULL</cfif>
						<cfif isdefined("session.ww.userid")>AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"><cfelse>AND RECORD_CONS IS NULL</cfif>
						<cfif isdefined("session.ep.userid")>AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>AND RECORD_EMP IS NULL</cfif>
				</cfquery>
			<cfelse>
				<cfset control_same_prod_exists.recordcount=0>
			</cfif>
			<cfif control_same_prod_exists.recordcount>
				<cfquery name="upd_main_product_" datasource="#dsn3#">
					UPDATE 
						ORDER_PRE_ROWS
					SET
						QUANTITY=#control_same_prod_exists.QUANTITY+add_row_info.amount#,
						PRE_STOCK_AMOUNT=#control_same_prod_exists.PRE_STOCK_AMOUNT+add_row_info.amount#
					WHERE
						ORDER_ROW_ID=#control_same_prod_exists.ORDER_ROW_ID#
						AND STOCK_ID=#add_row_info.stock_id#
						AND PRE_STOCK_ID=#add_row_info.pre_stock_id#
				</cfquery>
			<cfelse>
				<cfif isdefined('arguments.PRICE') and len(arguments.PRICE) and len(get_last_stock_info.TAX[listfind(add_row_stock_id_list,add_row_info.stock_id)]) and get_last_stock_info.TAX[listfind(add_row_stock_id_list,add_row_info.stock_id)] neq 0>
					<cfset arguments.PRICE=wrk_round(((arguments.PRICE/(100+get_last_stock_info.TAX[listfind(add_row_stock_id_list,add_row_info.stock_id)]))*100),4)>
				</cfif>
				<cfquery name="add_main_product_" datasource="#dsn3#">
					INSERT INTO
						ORDER_PRE_ROWS
					(
						PROM_WORK_TYPE,
						IS_NONDELETE_PRODUCT,
						IS_PRODUCT_PROMOTION_NONEFFECT,
						CATALOG_ID,
						IS_GENERAL_PROM,
						PROM_PRODUCT_PRICE,
						PROM_COST,
						PROM_ID,
						PRE_PRODUCT_ID,
						PRE_STOCK_ID,
						PRE_STOCK_AMOUNT,
						PRODUCT_ID,
						PRODUCT_NAME,
						QUANTITY,
						PRICE,
						PRICE_KDV,
						PRICE_MONEY,
						TAX,
						STOCK_ID,
						STOCK_ACTION_ID,
						STOCK_ACTION_TYPE,
						PRODUCT_UNIT_ID,
						PROM_STOCK_AMOUNT,
						IS_PROM_ASIL_HEDIYE,
						PROM_FREE_STOCK_ID,
						IS_COMMISSION,
						PRICE_STANDARD,
						PRICE_STANDARD_KDV,
						PRICE_STANDARD_MONEY,
						TO_CONS,
						TO_COMP,
						TO_PAR,
						RECORD_PERIOD_ID,
						RECORD_PAR,
						RECORD_CONS,
						RECORD_EMP,
						RECORD_GUEST,
						COOKIE_NAME,
						SALE_PARTNER_ID,
						SALE_CONSUMER_ID,
						PROD_PROM_ACTION_TYPE,
						RECORD_IP,
						RECORD_DATE
					)
						VALUES
					(
						<cfif isdefined('arguments.PROM_WORK_TYPE') and len(arguments.PROM_WORK_TYPE)>#PROM_WORK_TYPE#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.IS_NONDELETE_PRODUCT') and len(arguments.IS_NONDELETE_PRODUCT)>#IS_NONDELETE_PRODUCT#<cfelse>0</cfif>,
						<cfif isdefined('arguments.IS_PRODUCT_PROMOTION_NONEFFECT') and len(arguments.IS_PRODUCT_PROMOTION_NONEFFECT)>#arguments.IS_PRODUCT_PROMOTION_NONEFFECT#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.CATALOG_ID') and len(arguments.CATALOG_ID)>#arguments.CATALOG_ID#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.IS_GENERAL_PROM') and len(arguments.IS_GENERAL_PROM)>#arguments.IS_GENERAL_PROM#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.PROM_PRODUCT_PRICE') and len(arguments.PROM_PRODUCT_PRICE)>#arguments.PROM_PRODUCT_PRICE#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.PROM_COST') and len(arguments.PROM_COST)>#arguments.PROM_COST#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.PROM_ID') and len(arguments.PROM_ID)>#arguments.PROM_ID#<cfelse>NULL</cfif>,
						<cfif len(add_row_info.PRE_PRODUCT_ID)>#add_row_info.PRE_PRODUCT_ID#<cfelse>#get_last_stock_info.PRODUCT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#</cfif>,
						<cfif len(add_row_info.PRE_STOCK_ID)>#add_row_info.PRE_STOCK_ID#<cfelse>#get_last_stock_info.STOCK_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#</cfif>,
						<cfif len(add_row_info.PRE_STOCK_AMOUNT)>#add_row_info.PRE_STOCK_AMOUNT#<cfelse>#add_row_info.amount#</cfif>,
						#get_last_stock_info.PRODUCT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
						<cfif trim(get_last_stock_info.PROPERTY[listfind(add_row_stock_id_list,add_row_info.stock_id)]) is '-'>'#get_last_stock_info.PRODUCT_NAME[listfind(add_row_stock_id_list,add_row_info.stock_id)]#'<cfelse>'#get_last_stock_info.PRODUCT_NAME[listfind(add_row_stock_id_list,add_row_info.stock_id)]# #get_last_stock_info.PROPERTY[listfind(add_row_stock_id_list,add_row_info.stock_id)]#'</cfif>,
						#add_row_info.amount#,
						<cfif arguments.is_promotion eq 1>
							<cfif add_row_info.PRE_STOCK_ID neq add_row_info.stock_id and len(add_row_info.PRE_STOCK_AMOUNT) and add_row_info.PRE_STOCK_AMOUNT neq 0>
								<cfif isdefined('arguments.PRICE') and len(arguments.PRICE)>
								#wrk_round(arguments.PRICE/(add_row_info.amount/add_row_info.PRE_STOCK_AMOUNT))#
								<cfelse>NULL</cfif>,
								<cfif isdefined('arguments.PRICE_KDV') and len(arguments.PRICE_KDV)>
								#wrk_round(arguments.PRICE_KDV/(add_row_info.amount/add_row_info.PRE_STOCK_AMOUNT))#
								<cfelse>NULL</cfif>,
							<cfelse>
								<cfif isdefined('arguments.PRICE') and len(arguments.PRICE)>#arguments.PRICE#<cfelse>NULL</cfif>,
								<cfif isdefined('arguments.PRICE_KDV') and len(arguments.PRICE_KDV)>#arguments.PRICE_KDV#<cfelse>NULL</cfif>,
							</cfif>
							<cfif isdefined('arguments.PRICE_MONEY') and len(arguments.PRICE_MONEY)>'#arguments.PRICE_MONEY#'<cfelse>NULL</cfif>,
						<cfelse>
							<cfif get_p.recordcount>
								#get_p.PRICE#,
								#get_p.PRICE_KDV#,
								'#get_p.MONEY#',
							<cfelse>
								#GET_PRICE.PRICE#,
								#GET_PRICE.PRICE_KDV#,
								'#GET_PRICE.MONEY#',
							</cfif>
						</cfif>
						#get_last_stock_info.TAX[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
						#add_row_info.stock_id#,
						<cfif len(add_row_info.stock_action_id)>#add_row_info.stock_action_id#<cfelse>0</cfif>,
						<cfif len(add_row_info.stock_action_type)>#add_row_info.stock_action_type#<cfelse>NULL</cfif>,
						#get_last_stock_info.PRODUCT_UNIT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
						<cfif arguments.is_promotion eq 1>
							<cfif isdefined('arguments.PROM_STOCK_AMOUNT') and len(arguments.PROM_STOCK_AMOUNT)>#arguments.PROM_STOCK_AMOUNT#<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.IS_PROM_ASIL_HEDIYE') and len(arguments.IS_PROM_ASIL_HEDIYE)>#arguments.IS_PROM_ASIL_HEDIYE#<cfelse>NULL</cfif>,
							<cfif isdefined('arguments.PROM_FREE_STOCK_ID') and len(arguments.PROM_FREE_STOCK_ID)>#arguments.PROM_FREE_STOCK_ID#<cfelse>NULL</cfif>,
						<cfelse>
							1,
							0,
							0,
						</cfif>
						0, <!--- komisyon satırı mı --->
						<cfif arguments.is_promotion eq 1>
							<cfif add_row_info.PRE_STOCK_ID neq add_row_info.stock_id and len(add_row_info.PRE_STOCK_AMOUNT) and add_row_info.PRE_STOCK_AMOUNT neq 0>
								<cfif isdefined('arguments.PRICE_STANDARD') and len(arguments.PRICE_STANDARD)>#wrk_round(arguments.PRICE_STANDARD/(add_row_info.amount/add_row_info.PRE_STOCK_AMOUNT))#<cfelse>NULL</cfif>,
								<cfif isdefined('arguments.PRICE_STANDARD_KDV') and len(arguments.PRICE_STANDARD_KDV)>#wrk_round(arguments.PRICE_STANDARD_KDV/(add_row_info.amount/add_row_info.PRE_STOCK_AMOUNT))#<cfelse>NULL</cfif>,
							<cfelse>
								<cfif isdefined('arguments.PRICE_STANDARD') and len(arguments.PRICE_STANDARD)>#arguments.PRICE_STANDARD#<cfelse>NULL</cfif>,
								<cfif isdefined('arguments.PRICE_STANDARD_KDV') and len(arguments.PRICE_STANDARD_KDV)>#arguments.PRICE_STANDARD_KDV#<cfelse>NULL</cfif>,
							</cfif>
							<cfif isdefined('arguments.PRICE_STANDARD_MONEY') and len(arguments.PRICE_STANDARD_MONEY)>'#arguments.PRICE_STANDARD_MONEY#'<cfelse>NULL</cfif>,
						<cfelse>
							#GET_PRICE.PRICE#,
							#GET_PRICE.PRICE_KDV#,
							'#GET_PRICE.MONEY#',
						</cfif>
						<cfif isdefined('arguments.consumer_id') and len(arguments.consumer_id)>#arguments.consumer_id#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.company_id') and len(arguments.company_id)>#arguments.company_id#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.partner_id') and len(arguments.partner_id)>#arguments.partner_id#<cfelse>NULL</cfif>,
						#session_base.period_id#,
						<cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
						<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
						<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
						<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not isdefined("session.ep.userid")>1<cfelse>0</cfif>,
						<cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.sales_member_id') and len(arguments.sales_member_id) and arguments.sales_member_type is 'partner'>#arguments.sales_member_id#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.sales_cons_id') and len(arguments.sales_cons_id) and arguments.sales_member_type is 'consumer'>#arguments.sales_cons_id#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.prod_prom_action_type') and len(arguments.prod_prom_action_type)>#arguments.prod_prom_action_type#<cfelse>0</cfif>,
						'#cgi.remote_addr#',
						#now()#
					)
				</cfquery>
			</cfif>
		</cfoutput>
	</cfif>
	<cfif fusebox.use_stock_speed_reserve><!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
		<cfinclude template="../../objects2/query/get_basket_rows.cfm">
		<!---<cfquery name="del_reserve_rows" datasource="#dsn3#">
			DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID='#CFTOKEN#'
		</cfquery>--->
        <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#dsn3#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
        </cfstoredproc>
		<cfoutput query="get_rows">
			<!--- Stok stratejisine göre action_type ı 1,2,3 olmayanlara rezerve yapılıyor --->
			<cfif (len(get_rows.STOCK_ACTION_TYPE) and not listfind('1,2,3',get_rows.STOCK_ACTION_TYPE,',')) or not len(get_rows.STOCK_ACTION_TYPE)>
				<cfquery name="add_reserve_" datasource="#dsn3#">
					INSERT INTO 
						ORDER_ROW_RESERVED
						(
							STOCK_ID,
							PRODUCT_ID,
							RESERVE_STOCK_OUT,
							ORDER_ROW_ID,
							PRE_ORDER_ID,
							IS_BASKET
						) 
						VALUES
						(
							#get_rows.STOCK_ID#,
							#get_rows.PRODUCT_ID#,
							#QUANTITY#,
							#ORDER_ROW_ID#,
							'#CFTOKEN#',
							1				
						)
				</cfquery>
			</cfif>
		</cfoutput>
	</cfif>
	<cfreturn true>
</cffunction>
