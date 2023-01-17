<cfsetting showdebugoutput="no">
<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>
<cfif isdefined('attributes.add_stock_id') and len(attributes.add_stock_id) and isdefined('attributes.add_stock_amount') and len(attributes.add_stock_amount)><!--- hızlı sipariş haricinde urun eklenen sayfadan buraya yonlendirilmisse --->
	<cfset from_stock_id=1>
</cfif>
<cfif not isdefined('from_stock_id')>
	<cfset list_product_code="">
	<cfset list_stock_code="">
    <cfif isDefined('attributes.is_stock_change') and attributes.is_stock_change eq 1>
        <cfloop from="1" to="#attributes.rowcount#" index="be">
            <cfif isdefined("attributes.product_code#be#") and len(evaluate("attributes.product_code#be#")) and not listfind(list_product_code,evaluate("attributes.product_code#be#"))>
                <cfset list_product_code = listappend(list_product_code,evaluate("attributes.product_code#be#"),',')>
            </cfif>
        </cfloop>      
    <cfelse>
        <cfloop from="1" to="#attributes.rowcount#" index="be">
            <cfif isdefined("attributes.product_code#be#") and len(evaluate("attributes.product_code#be#")) and not listfind(list_product_code,evaluate("attributes.product_code#be#"))>
                <cfset list_product_code = listappend(list_product_code,evaluate("attributes.product_code#be#"),',')>
            </cfif>
        </cfloop>    
    </cfif>
<cfelse>
	<cfset list_product_code="1">
</cfif>
<cfif listlen(list_product_code) eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1395.Sipariş Verilecek Ürün Seçmelisiniz'> !");
	</script>
	<cflocation url="#request.self#?fuseaction=#attributes.fuseact#" addtoken="no">
</cfif>
<cfscript>
	if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_comp_id = session.pp.our_company_id;
		int_period_id = session.pp.period_id;
		if(not (isdefined('attributes.company_id') and len(attributes.company_id) )) //formda secilmemisse
			attributes.company_id = session.pp.company_id;
		if(not (isdefined('attributes.partner_id') and len(attributes.partner_id) ))
			attributes.member_id = session.pp.userid;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = session.ww.our_company_id;
		int_period_id = session.ww.period_id;
		if(isdefined("session.ww.basket_cons_id") and len(session.ww.basket_cons_id))
			attributes.consumer_id = session.ww.basket_cons_id;
		else if(not (isdefined('attributes.basket_expres_consumer_id') and len(attributes.basket_expres_consumer_id) ) and isdefined('session.ww.userid')) //formda secilmemisse
			attributes.consumer_id = session.ww.userid;
		else if((isdefined('attributes.basket_expres_consumer_id') and len(attributes.basket_expres_consumer_id) ) and isdefined('session.ww.userid')) //formda secilmisse
			attributes.consumer_id = attributes.basket_expres_consumer_id;	
		attributes.member_id = '';
	}
	else if (listfindnocase(employee_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = session.ep.company_id;
		int_period_id = session.ep.period_id;
		if((isdefined('attributes.basket_expres_consumer_id') and len(attributes.basket_expres_consumer_id) )) //formda secilmisse
			attributes.consumer_id = attributes.basket_expres_consumer_id;		
	}
	attributes.price_catid=-2;
	not_added_stock_code_list='';
	non_find_stock_list = '';
	if(isDefined('attributes.is_stock_change') and attributes.is_stock_change eq 1) use_table_field = "STOCK_CODE";		
	else
	{
		if(isdefined('attributes.use_prod_code_type') and  attributes.use_prod_code_type eq 1)//islemler stok koduna gore yapılacak
			use_table_field='STOCK_CODE';
		else if(isdefined('attributes.use_prod_code_type') and  attributes.use_prod_code_type eq 2)//islemler ozel koda gore yapılacak
			use_table_field='PRODUCT_CODE';
		else if(isdefined('attributes.use_prod_code_type') and  attributes.use_prod_code_type eq 3)//islemler stok özel koduna gore yapılacak
			use_table_field='STOCK_CODE_2'; 
	}
</cfscript>
<cfinclude template="get_price_cats_moneys.cfm">
<cfquery name="GET_ACTION_TYPE" datasource="#DSN3#">
	SELECT TOP 1 STOCK_ACTION_ID FROM SETUP_SALEABLE_STOCK_ACTION WHERE STOCK_ACTION_TYPE = 1
</cfquery>
<!--- promosyonlar siliniyor --->
<cfquery name="DEL_PROM_ROWS" datasource="#DSN3#"><!--- daha once eklenmiş ve li promosyonlar siliniyor --->
	DELETE FROM 
		ORDER_PRE_ROWS
	WHERE
		PROM_WORK_TYPE IN (0,1) AND
		(ISNULL(PROD_PROM_ACTION_TYPE,0) = 0) AND
		ISNULL(IS_PROM_ASIL_HEDIYE,0) = 1 AND 
		<cfif isdefined("session.pp")>
            RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
        <cfelseif isdefined("session.ww.userid")>
            RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
        <cfelseif isdefined("session.ep.userid")>
            RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        <cfelse>
            1=2
        </cfif>
</cfquery>
<cfquery name="UPD_PROM_ROWS" datasource="#DSN3#"> <!--- baskete eklenmis, fakat sonradan ekle degistir promosyon kazanc urunleriyle degistirilen satırlar geri alınıyor --->
	UPDATE 
		ORDER_PRE_ROWS
	SET
		PROD_PROM_ACTION_TYPE = 0,
		IS_PROM_ASIL_HEDIYE = 0,
		QUANTITY = ISNULL(QUANTITY_OLD,QUANTITY),
		PRICE = ISNULL(PRICE_OLD_2,PRICE),
		PRICE_MONEY = ISNULL(PRICE_OLD_MONEY_2,PRICE_MONEY),
		PRICE_KDV = ISNULL(PRICE_KDV_OLD,PRICE_KDV),
		IS_PRODUCT_PROMOTION_NONEFFECT = NULL,
		IS_NONDELETE_PRODUCT = NULL,
		PROM_ID = NULL
	WHERE
		ISNULL(PROD_PROM_ACTION_TYPE,0) = 1 AND 
		<cfif isdefined("session.pp")>
            RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
        <cfelseif isdefined("session.ww.userid")>
            RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
        <cfelseif isdefined("session.ep.userid")>
            RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        <cfelse>
            1 = 2
        </cfif>
</cfquery>

<cfif isDefined('attributes.is_stock_change') and attributes.is_stock_change eq 1>
    <cfquery name="GET_ALL_STOCK" datasource="#DSN3#">
        SELECT
            PRODUCT_ID,
            STOCK_ID,
            PRODUCT_UNIT_ID,
            TAX,
            PROPERTY,
            PRODUCT_NAME,
            STOCK_CODE,
            PRODUCT_CODE,
            STOCK_CODE_2,
            IS_ZERO_STOCK,
            IS_INVENTORY
        FROM
            STOCKS
        WHERE
            STOCK_STATUS = 1 AND 
            IS_SALES = 1 AND
           	<!---  S.IS_INTERNET = 1 AND--->
            <cfif isdefined('from_stock_id')> <!--- hızlı siparis haricinde urun ekleme sayfalarından cagrılıyorsa --->
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.add_stock_id#">
            <cfelse>
                (
                    <cfif isdefined('attributes.use_prod_code_type') and  attributes.use_prod_code_type eq 2>
                        <cfloop list="#list_product_code#" delimiters="," index="pro_i">
                            #use_table_field# LIKE '#pro_i#' 
                            <!---  OR #use_table_field# LIKE '%#pro_i#' --->
                            <cfif pro_i neq listlast(list_product_code,',') and listlen(list_product_code,',') gte 1> OR</cfif>
                        </cfloop>
                    </cfif>
                )
            </cfif>
        ORDER BY
            STOCK_ID
    </cfquery>
<cfelse>
    <cfquery name="GET_ALL_STOCK" datasource="#DSN3#">
        SELECT
            PRODUCT_ID,
            STOCK_ID,
            PRODUCT_UNIT_ID,
            TAX,
            PROPERTY,
            PRODUCT_CODE,
            PRODUCT_NAME,
            STOCK_CODE,
            STOCK_CODE_2,
            IS_ZERO_STOCK,
            IS_INVENTORY
        FROM
            STOCKS
        WHERE
            STOCK_STATUS = 1 AND 
            <!--- IS_SALES = 1 AND --->
            IS_INTERNET = 1 AND
            <cfif isdefined('from_stock_id')> <!--- hızlı siparis haricinde urun ekleme sayfalarından cagrılıyorsa --->
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.add_stock_id#">
            <cfelse>
            (
                <cfloop list="#list_product_code#" delimiters="," index="pro_i">
                    #use_table_field# = '#pro_i#'
                    <cfif pro_i neq listlast(list_product_code,',') and listlen(list_product_code,',') gte 1> OR</cfif>
                </cfloop>
            )
            </cfif>
        ORDER BY
            STOCK_ID
    </cfquery>
</cfif>
<cfset list_stock_id_ = ''>
<cfif isdefined('from_stock_id')>
	<cfset 'row_stock_amount_#attributes.add_stock_id#'=attributes.add_stock_amount>
	<cfset list_stock_id_=listappend(list_stock_id_,attributes.add_stock_id)>
<cfelse>
	<cfloop from="1" to="#attributes.rowcount#" index="i">
		<!--- BK 20100423 Dore de tanimsiz geldigi durumlar icin --->
		<cfif isdefined("attributes.product_code#i#") and len(evaluate("attributes.product_code#i#"))>
			<cfscript>
				row_prod_code = evaluate("attributes.product_code#i#");
				is_flag =1;
				for(tyy=1; tyy lte get_all_stock.recordcount; tyy=tyy+1)
				{ 
					if(evaluate('get_all_stock.#use_table_field#[tyy]') eq row_prod_code or right(evaluate('get_all_stock.#use_table_field#[tyy]'),len(row_prod_code)) eq row_prod_code)
					{
						if(isdefined('row_stock_amount_#get_all_stock.STOCK_ID[tyy]#') and len(evaluate('row_stock_amount_#get_all_stock.STOCK_ID[tyy]#')))
							'row_stock_amount_#get_all_stock.STOCK_ID[tyy]#'=evaluate('row_stock_amount_#get_all_stock.STOCK_ID[tyy]#')+evaluate("attributes.amount#i#");
						else
						{
							'row_stock_amount_#get_all_stock.STOCK_ID[tyy]#'=evaluate('attributes.amount#i#');
							list_stock_id_=listappend(list_stock_id_,get_all_stock.STOCK_ID[tyy]);
						}
						is_flag =0;
						break;
					}
				}
				if(is_flag)	non_find_stock_list=listappend(non_find_stock_list,evaluate("attributes.product_code#i#"));
			</cfscript>
		</cfif>
	</cfloop>
</cfif>
<cfif listlen(list_stock_id_)> <!--- satılabilir stok kontrol ediliyor, kullanıcının rezerve ettiklerini de ekliyor --->
    <cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
        <cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
			get_stock_last_location_function '#list_stock_id_#'
        <cfelseif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
            get_stock_last_location_function '#list_stock_id_#'
        <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
            get_stock_last_location_function '#list_stock_id_#'
        <cfelse>
            get_stock_last_function '#list_stock_id_#'
        </cfif>
    </cfquery>
    
    <cfquery name="GET_LAST_STOCKS_1" dbtype="query">
        SELECT
            SUM(SALEABLE_STOCK) AS SALEABLE_STOCK,
            STOCK_ID
        FROM
            GET_STOCK_LAST
        <cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
            WHERE
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,1,'-')#"> AND 
                LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,2,'-')#">	
        <cfelseif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
            WHERE DEPARTMENT_ID IN (#session.ww.department_ids#)
        <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
            WHERE DEPARTMENT_ID IN (#session.pp.department_ids#)
        </cfif>
        GROUP BY 
            STOCK_ID
    </cfquery>
    <cfquery name="GET_LAST_STOCKS_2" datasource="#DSN2#">
        SELECT
            STOCK_ID,SUM(SALEABLE_STOCK) AS SALEABLE_STOCK
        FROM
        (
            SELECT 
                (RESERVE_STOCK_IN-RESERVE_STOCK_OUT)*-1 AS SALEABLE_STOCK, 
                STOCK_ID
            FROM
                #dsn3_alias#.ORDER_ROW_RESERVED ORDER_ROW_RESERVED
            WHERE
                PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#"> AND
                STOCK_ID IN (#list_stock_id_#) AND
                IS_BASKET IS NULL
				<cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
                    AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,1,'-')#"> 
                    AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,2,'-')#">	
                </cfif>					
        ) AS GET_ALL_SALEABLE_STOCK
        GROUP BY STOCK_ID
    </cfquery>
    <cfquery name="GET_LAST_STOCKS_3" dbtype="query">
            SELECT 
                * 
            FROM 
                GET_LAST_STOCKS_1
        UNION ALL
            SELECT 
                * 
            FROM 
                GET_LAST_STOCKS_2
    </cfquery>
    <cfquery name="GET_LAST_STOCKS" dbtype="query">
        SELECT
            STOCK_ID,SUM(SALEABLE_STOCK) AS SALEABLE_STOCK
        FROM
            GET_LAST_STOCKS_3
        GROUP BY 
            STOCK_ID
        HAVING 
            SUM(SALEABLE_STOCK) >0
        ORDER BY
            STOCK_ID
    </cfquery>
	<cfset saleable_stock_id_list_ =valuelist(get_last_stocks.stock_id)>
	<cfset control_strategy_list_=''>
	<cfset stock_strategy_list_=''>
	<cfset list_stock_id_ = listsort(list_stock_id_,"numeric","ASC",",")>
	<cfif get_last_stocks.recordcount>
		<cfloop list="#list_stock_id_#" index="row_stock_i">
			<cfif not listfind(saleable_stock_id_list_,row_stock_i) or ( len(get_last_stocks.saleable_stock[listfind(saleable_stock_id_list_,row_stock_i)]) and get_last_stocks.saleable_stock[listfind(saleable_stock_id_list_,row_stock_i)] lt evaluate('row_stock_amount_#row_stock_i#') )>
				<!--- satılabilir stok listesinde yoksa veya satılabilir stogu yeterli değilse stratejisi kontrol edilecek  --->
				<cfif len(get_last_stocks.saleable_stock[listfind(saleable_stock_id_list_,row_stock_i)]) and get_last_stocks.saleable_stock[listfind(saleable_stock_id_list_,row_stock_i)]>
					<cfset 'use_saleable_stock_#row_stock_i#'=get_last_stocks.saleable_stock[listfind(saleable_stock_id_list_,row_stock_i)]>
				</cfif>
				<cfset control_strategy_list_=listappend(control_strategy_list_,row_stock_i)>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset control_strategy_list_=list_stock_id_>
	</cfif>
	<cfif listlen(control_strategy_list_)> <!--- satılabilir stogu yeterli olmayan urunlerin strateji bilgileri alınır --->
		<cfset add_alternative_prod_list_=''>
		<cfquery name="GET_ALL_STOCK_STRATEGY" datasource="#DSN3#">
			SELECT 
				SS.STOCK_ACTION_ID,
                SS.STOCK_ID,
                SS.PRODUCT_ID, 
				STOCK_A.STOCK_ACTION_TYPE
			FROM 
				STOCK_STRATEGY SS,
				SETUP_SALEABLE_STOCK_ACTION STOCK_A
			WHERE 
				SS.STOCK_ID IN (#control_strategy_list_#) AND
				SS.STRATEGY_TYPE = 0 AND
				SS.STOCK_ACTION_ID = STOCK_A.STOCK_ACTION_ID
		</cfquery>
		<cfset stock_strategy_list_=valuelist(get_all_stock_strategy.stock_id)>
		<cfloop list="#stock_strategy_list_#" index="strategy_stock_id_">
			<cfset 'row_stock_action_id_#strategy_stock_id_#' = get_all_stock_strategy.stock_action_id[listfind(stock_strategy_list_,strategy_stock_id_)]>
			<cfset 'row_stock_action_type_#strategy_stock_id_#' = get_all_stock_strategy.stock_action_type[listfind(stock_strategy_list_,strategy_stock_id_)]>
			<cfif get_all_stock_strategy.stock_action_type[listfind(stock_strategy_list_,strategy_stock_id_)] eq 4> <!--- hareket türü 4 ise alternatif urunleri kontrol edilir --->
				<cfif listfind(saleable_stock_id_list_,strategy_stock_id_) and isdefined('use_saleable_stock_#strategy_stock_id_#')><!--- satılabilir stogu var ama talebi karsılayamıyorsa, kalan kısım için stratejilere bakılır --->
					<cfset required_stock_amount=evaluate('row_stock_amount_#strategy_stock_id_#')-evaluate('use_saleable_stock_#strategy_stock_id_#')>
				<cfelse>
					<cfset required_stock_amount=evaluate('row_stock_amount_#strategy_stock_id_#')>
				</cfif>
				<cfquery name="GET_ALTERNATIVE_PRODS" datasource="#DSN3#">
					SELECT
						AP.ALTERNATIVE_PRODUCT_ID,
                        AP.ALTERNATIVE_PRODUCT_NO,
						AP.ALTERNATIVE_PRODUCT_AMOUNT,
                        AP.START_DATE,
                        AP.FINISH_DATE,
						S.STOCK_ID,
                        S.IS_ZERO_STOCK,
                        S.IS_INVENTORY,
						S.STOCK_ID AS ALTERNATIVE_STOCK_ID
					FROM
						ALTERNATIVE_PRODUCTS AP,
						STOCKS S
					WHERE
						S.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID
						AND AP.PRODUCT_ID IN (SELECT S2.PRODUCT_ID FROM STOCKS S2 WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#strategy_stock_id_#">)
						AND S.STOCK_STATUS = 1
						AND AP.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">
						AND AP.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(DATEADD('d',-1,now()))#">
					ORDER BY AP.ALTERNATIVE_PRODUCT_NO		
				</cfquery>
				<cfif get_alternative_prods.recordcount neq 0><!--- satılabilir stogu olan alternatif urun yoksa asıl urunun sıfır stokla calıs parametresi kontrol edilir --->
					<cfset alternative_stock_list = ''>
					<cfquery name="GET_STOCK_ALTERNATIVE" datasource="#DSN3#">
						SELECT 
                        	SUM(SALEABLE_STOCK) AS SALEABLE_STOCK,
                            STOCK_ID 
                        FROM 	
                        <cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids) or isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
                        	#dsn2_alias#.GET_STOCK_LAST_LOCATION
                        <cfelse>
                        	#dsn2_alias#.GET_STOCK_LAST 
                        </cfif>
                        WHERE 
                        	STOCK_ID IN (#valuelist(get_alternative_prods.alternative_stock_id)#) 
                            <cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
                               AND DEPARTMENT_ID IN (#session.ww.department_ids#)
                            <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
                               AND DEPARTMENT_ID IN (#session.pp.department_ids#)
                            </cfif>
                        GROUP BY STOCK_ID
                        ORDER BY STOCK_ID
					</cfquery>
					<cfset alternative_stock_list = listsort(valuelist(get_stock_alternative.stock_id),'numeric','ASC')>
					<cfset 'add_alternative_prod_list_#strategy_stock_id_#'="">
					<cfoutput query="get_alternative_prods">
						<cfif required_stock_amount gt 0>
							<cfif isdefined("alternative_stock_list") and listfindnocase(alternative_stock_list,alternative_stock_id)>
								<cfset saleable_stock_amount = get_stock_alternative.SALEABLE_STOCK[listfind(alternative_stock_list,alternative_stock_id)]>
							<cfelse>
								<cfset saleable_stock_amount = 0>
							</cfif>	
							<cfif get_alternative_prods.is_inventory eq 0 or get_alternative_prods.is_zero_stock eq 1> <!--- alternatif ürun icins sıfır stokla calıs secilmisse veya envantere dahil degilse --->
								<cfset 'add_alternative_prod_list_#strategy_stock_id_#'=listappend(evaluate('add_alternative_prod_list_#strategy_stock_id_#'),get_alternative_prods.alternative_stock_id)>
								<cfset 'alternative_prod_amount_#alternative_stock_id#'=int(get_alternative_prods.alternative_product_amount*required_stock_amount)><!--- kullanılacak miktar --->
								<cfset 'pre_prod_amount_#alternative_stock_id#'=required_stock_amount> <!--- kullanılacak miktar --->
								<cfset required_stock_amount=0>
							<cfelseif saleable_stock_amount gt 0 and Int(saleable_stock_amount/alternative_product_amount) gt 0> <!--- satılabilir stogu varsa --->
								<cfset 'add_alternative_prod_list_#strategy_stock_id_#'=listappend(evaluate('add_alternative_prod_list_#strategy_stock_id_#'),get_alternative_prods.alternative_stock_id)>
								<cfif Int(get_alternative_prods.alternative_product_amount*required_stock_amount) gt saleable_stock_amount> <!--- gerekli olan miktar alternatif ürünün satılabilir stogundan fazlaysa --->
									<cfset temp_add_amount=Int(saleable_stock_amount/alternative_product_amount)> <!--- alternatif urunun satılabilir stogu asıl urunun için gerekli olan miktarın ne kadarını karıslayabiliyor --->
									<cfset 'alternative_prod_amount_#alternative_stock_id#'=temp_add_amount*alternative_product_amount> <!--- kullanılacak miktar --->
									<cfset required_stock_amount=required_stock_amount-temp_add_amount>
									<cfset 'pre_prod_amount_#alternative_stock_id#'=temp_add_amount> <!---alternatif urunden eklenen miktarın asıl urunden karşılıgı --->
								<cfelse>
									<cfset 'alternative_prod_amount_#alternative_stock_id#'=Int(get_alternative_prods.alternative_product_amount*required_stock_amount)> <!--- kullanılacak miktar --->
									<cfset 'pre_prod_amount_#alternative_stock_id#'=required_stock_amount> <!--- kullanılacak miktar --->
									<cfset required_stock_amount=0>
								</cfif>
							</cfif>
						</cfif>
					</cfoutput>
				<cfelse>
					<cfset 'row_stock_action_id_#strategy_stock_id_#' = get_action_type.stock_action_id>
					<cfset 'row_stock_action_type_#strategy_stock_id_#' = 1> <!--- hareket türü 4 oldugu halde yeterli stokta alternatif ürünü yoksa hareket turu 1 set edilir --->
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfset add_stock_list_=''>
	<cfscript>
		add_row_info = QueryNew("STOCK_ID,AMOUNT,PRE_PRODUCT_ID,PRE_STOCK_ID,PRE_STOCK_AMOUNT,STOCK_ACTION_ID,STOCK_ACTION_TYPE","Integer,Double,Integer,Integer,Double,Integer,Integer");
		add_row_info_count = 0;
		for(list_i=1; list_i lte listlen(list_stock_id_);list_i=list_i+1)
		{
			temp_stock_id=listgetat(list_stock_id_,list_i);
			total_row_stock_amount=evaluate('row_stock_amount_#temp_stock_id#');
			'is_finish_#temp_stock_id#'=0;
			if(get_all_stock.IS_INVENTORY[listfind(list_stock_id_,temp_stock_id)] eq 0 or get_all_stock.IS_ZERO_STOCK[listfind(list_stock_id_,temp_stock_id)] eq 1) //envantere dahil degilse veya sıfır stokla calıs secilmisse satılabilir stoguna bakılmaz
			{
				add_row_info_count = add_row_info_count + 1;
				QueryAddRow(add_row_info,1);
				QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
				QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count);
				QuerySetCell(add_row_info,"PRE_PRODUCT_ID",get_all_stock.PRODUCT_ID[listfind(list_stock_id_,temp_stock_id)],add_row_info_count);
				if( isdefined('row_stock_amount_#temp_stock_id#') and len(evaluate('row_stock_amount_#temp_stock_id#')) )
				{
					QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",evaluate('row_stock_amount_#temp_stock_id#'),add_row_info_count);
					QuerySetCell(add_row_info,"AMOUNT",evaluate('row_stock_amount_#temp_stock_id#'),add_row_info_count);
					total_row_stock_amount=0;
					'is_finish_#temp_stock_id#'=1;
				}
				else
				{
					QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",0,add_row_info_count);
					QuerySetCell(add_row_info,"AMOUNT",0,add_row_info_count);
				}
			}
			else if(listfind(saleable_stock_id_list_,temp_stock_id)) //satılabilir stogu varsa
			{
				add_row_info_count = add_row_info_count + 1;
				QueryAddRow(add_row_info,1);
				QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
				QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count);
				QuerySetCell(add_row_info,"PRE_PRODUCT_ID",get_all_stock.PRODUCT_ID[listfind(list_stock_id_,temp_stock_id)],add_row_info_count);
				if( isdefined('row_stock_amount_#temp_stock_id#') and len(evaluate('row_stock_amount_#temp_stock_id#')) )
				{
					if(len(get_last_stocks.SALEABLE_STOCK[listfind(saleable_stock_id_list_,temp_stock_id)]) and get_last_stocks.SALEABLE_STOCK[listfind(saleable_stock_id_list_,temp_stock_id)] lt evaluate('row_stock_amount_#temp_stock_id#'))
					{
						QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",get_last_stocks.SALEABLE_STOCK[listfind(saleable_stock_id_list_,temp_stock_id)],add_row_info_count);
						total_row_stock_amount=wrk_round(total_row_stock_amount-get_last_stocks.SALEABLE_STOCK[listfind(saleable_stock_id_list_,temp_stock_id)]);
						QuerySetCell(add_row_info,"AMOUNT",get_last_stocks.SALEABLE_STOCK[listfind(saleable_stock_id_list_,temp_stock_id)],add_row_info_count);
					}
					else
					{
						QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",evaluate('row_stock_amount_#temp_stock_id#'),add_row_info_count);
						QuerySetCell(add_row_info,"AMOUNT",evaluate('row_stock_amount_#temp_stock_id#'),add_row_info_count);
						total_row_stock_amount=0;
						'is_finish_#temp_stock_id#'=1;
					}
				}
				else
				{
					QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",0,add_row_info_count);
					QuerySetCell(add_row_info,"AMOUNT",0,add_row_info_count);
				}
			}
			if(evaluate('is_finish_#temp_stock_id#') neq 1 and listfind(stock_strategy_list_,temp_stock_id)) //satılabilir stogu yeterli olmayıp stok stratejisine gore eklenecek urunler
			{
				if( isdefined('row_stock_action_type_#temp_stock_id#') and evaluate('row_stock_action_type_#temp_stock_id#') eq 4) //stratejiye gore hareket turu alternatif urun verilir ise, urun miktarını karsılayacak kadar alternatif urunlerinden eklenir
				{
					if(isdefined('add_alternative_prod_list_#temp_stock_id#') and len(evaluate('add_alternative_prod_list_#temp_stock_id#')))
					{
						for(kk=1; kk lte listlen(evaluate('add_alternative_prod_list_#temp_stock_id#'));kk=kk+1) //alternatif urunler ekleniyor
						{
							temp_alter_stock_id_=listgetat(evaluate('add_alternative_prod_list_#temp_stock_id#'),kk);
							add_row_info_count = add_row_info_count + 1;
							QueryAddRow(add_row_info,1);
							QuerySetCell(add_row_info,"STOCK_ID",temp_alter_stock_id_,add_row_info_count);
							QuerySetCell(add_row_info,"STOCK_ACTION_ID",evaluate('row_stock_action_id_#temp_stock_id#'),add_row_info_count);
							QuerySetCell(add_row_info,"STOCK_ACTION_TYPE",evaluate('row_stock_action_type_#temp_stock_id#'),add_row_info_count);
							QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count); //alternatifi eklenen asıl urunu bu alanda tutuyoruz
							QuerySetCell(add_row_info,"PRE_PRODUCT_ID",get_all_stock.PRODUCT_ID[listfind(list_stock_id_,temp_stock_id)],add_row_info_count);
							if( isdefined('alternative_prod_amount_#temp_alter_stock_id_#') and len(evaluate('alternative_prod_amount_#temp_alter_stock_id_#')) )
							{
								QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",evaluate('pre_prod_amount_#temp_alter_stock_id_#'),add_row_info_count);
								total_row_stock_amount=wrk_round(total_row_stock_amount-evaluate('pre_prod_amount_#temp_alter_stock_id_#'));
								QuerySetCell(add_row_info,"AMOUNT",evaluate('alternative_prod_amount_#temp_alter_stock_id_#'),add_row_info_count);
							}
							else
							{
								QuerySetCell(add_row_info,"AMOUNT",0,add_row_info_count);
								QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",0,add_row_info_count);
							}
						}
					}
					else //alternatif urunler eklenemiyorsa strateji_type 1 set edilir
					{
						add_row_info_count = add_row_info_count + 1;
						QueryAddRow(add_row_info,1);
						QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
						QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count); //alternatifi eklenen asıl urunu bu alanda tutuyoruz
						QuerySetCell(add_row_info,"PRE_PRODUCT_ID",get_all_stock.PRODUCT_ID[listfind(list_stock_id_,temp_stock_id)],add_row_info_count);
						QuerySetCell(add_row_info,"STOCK_ACTION_ID", get_action_type.stock_action_id,add_row_info_count);
						QuerySetCell(add_row_info,"STOCK_ACTION_TYPE",1,add_row_info_count);
						if( listfind(saleable_stock_id_list_,temp_stock_id) and isdefined('use_saleable_stock_#temp_stock_id#'))
						{
							QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",(evaluate('row_stock_amount_#temp_stock_id#')-evaluate('use_saleable_stock_#temp_stock_id#')),add_row_info_count);
							total_row_stock_amount=total_row_stock_amount-wrk_round(evaluate('row_stock_amount_#temp_stock_id#')-evaluate('use_saleable_stock_#temp_stock_id#'));
							QuerySetCell(add_row_info,"AMOUNT",(evaluate('row_stock_amount_#temp_stock_id#')-evaluate('use_saleable_stock_#temp_stock_id#')),add_row_info_count);
						}
						else
						{
							QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",evaluate('row_stock_amount_#temp_stock_id#'),add_row_info_count);
							total_row_stock_amount=0;
							QuerySetCell(add_row_info,"AMOUNT",evaluate('row_stock_amount_#temp_stock_id#'),add_row_info_count);
						}
					}
				}
				else if(evaluate('is_finish_#temp_stock_id#') neq 1 and isdefined('row_stock_action_type_#temp_stock_id#') and listfind('1,2,3',evaluate('row_stock_action_type_#temp_stock_id#')) )
				{
					add_row_info_count = add_row_info_count + 1;
					QueryAddRow(add_row_info,1);
					QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
					QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count); //alternatifi eklenen asıl urunu bu alanda tutuyoruz
					QuerySetCell(add_row_info,"PRE_PRODUCT_ID",get_all_stock.PRODUCT_ID[listfind(list_stock_id_,temp_stock_id)],add_row_info_count);
					QuerySetCell(add_row_info,"STOCK_ACTION_ID",evaluate('row_stock_action_id_#temp_stock_id#'),add_row_info_count);
					QuerySetCell(add_row_info,"STOCK_ACTION_TYPE",evaluate('row_stock_action_type_#temp_stock_id#'),add_row_info_count);
					if( listfind(saleable_stock_id_list_,temp_stock_id) and isdefined('use_saleable_stock_#temp_stock_id#'))
					{
						QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",(evaluate('row_stock_amount_#temp_stock_id#')-evaluate('use_saleable_stock_#temp_stock_id#')),add_row_info_count);
						total_row_stock_amount=total_row_stock_amount-wrk_round(evaluate('row_stock_amount_#temp_stock_id#')-evaluate('use_saleable_stock_#temp_stock_id#'));
						QuerySetCell(add_row_info,"AMOUNT",(evaluate('row_stock_amount_#temp_stock_id#')-evaluate('use_saleable_stock_#temp_stock_id#')),add_row_info_count);
					}
					else
					{
						QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",evaluate('row_stock_amount_#temp_stock_id#'),add_row_info_count);
						total_row_stock_amount=0;
						QuerySetCell(add_row_info,"AMOUNT",evaluate('row_stock_amount_#temp_stock_id#'),add_row_info_count);
					}
				}
				if(total_row_stock_amount gt 0) //stratejilere ragmen karıslanamayan urun varsa stokta yok olarak satır ekleniyor
				{
					add_row_info_count = add_row_info_count + 1;
					QueryAddRow(add_row_info,1);
					QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
					QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count); //alternatifi eklenen asıl urunu bu alanda tutuyoruz
					QuerySetCell(add_row_info,"PRE_PRODUCT_ID",get_all_stock.PRODUCT_ID[listfind(list_stock_id_,temp_stock_id)],add_row_info_count);
					QuerySetCell(add_row_info,"STOCK_ACTION_ID", get_action_type.stock_action_id,add_row_info_count);
					QuerySetCell(add_row_info,"STOCK_ACTION_TYPE",1,add_row_info_count);
					QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",total_row_stock_amount,add_row_info_count);
					QuerySetCell(add_row_info,"AMOUNT",total_row_stock_amount,add_row_info_count);
					total_row_stock_amount=0;
				}
			}
			else if(not listfind(saleable_stock_id_list_,temp_stock_id) and get_all_stock.IS_ZERO_STOCK[listfind(list_stock_id_,temp_stock_id)] neq 1 and get_all_stock.IS_INVENTORY[listfind(list_stock_id_,temp_stock_id)] neq 0)
			{
				if(isdefined('attributes.use_prod_code_type') and  attributes.use_prod_code_type eq 2) //özel kod 
				{
					if(not listfind(not_added_stock_code_list,get_all_stock.STOCK_CODE_2[listfind(list_stock_id_,temp_stock_id)]))
						not_added_stock_code_list=listappend(not_added_stock_code_list,get_all_stock.STOCK_CODE_2[listfind(list_stock_id_,temp_stock_id)]);
				}
				else //stock_kodu
				{
					if(not listfind(not_added_stock_code_list,get_all_stock.STOCK_CODE[listfind(list_stock_id_,temp_stock_id)]))
						not_added_stock_code_list=listappend(not_added_stock_code_list,get_all_stock.STOCK_CODE[listfind(list_stock_id_,temp_stock_id)]);
				}
			}
		}
	</cfscript>
<cfelse>
	<cfset add_row_info.recordcount=0>
</cfif>
<cfif listlen(non_find_stock_list) neq 0>
	<script type="text/javascript">
		alert("<cfoutput>#non_find_stock_list#</cfoutput><cf_get_lang no ='1396.Nolu Ürün Kaydı Bulunamadı'> !");
	</script>
</cfif>
<cfif add_row_info.recordcount>
	<cfset add_row_stock_id_list = valuelist(add_row_info.stock_id)>
	<cfquery name="GET_LAST_STOCK_INFO" datasource="#DSN3#">
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
		ORDER BY 
			STOCK_ID
	</cfquery>
	<cfset add_row_stock_id_list = valuelist(get_last_stock_info.stock_id)>
	<cfset add_basket_express_prod_id_list = valuelist(add_row_info.pre_product_id)>
	<cfinclude template="get_price_all.cfm"> <!--- urunlere ait fiyatlar cekiliyor --->
	<cfif len(add_basket_express_prod_id_list)>
		<cfquery name="GET_ALL_PRICE_STANDART" datasource="#DSN3#">
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
	</cfif>

	<cfoutput query="add_row_info">
		<cfif get_price_all.recordcount>
			<cfquery name="GET_P" dbtype="query" maxrows="1">
				SELECT 
					* 
				FROM 
					GET_PRICE_ALL 
				WHERE 
					UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_stock.product_unit_id[listfind(list_stock_id_,add_row_info.pre_stock_id)]#"> AND <!--- #get_last_stock_info.PRODUCT_UNIT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]# --->
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.pre_product_id#"> <!--- #get_last_stock_info.PRODUCT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#  --->
                    AND STOCK_ID IN(0,#add_row_info.stock_id#) 
                ORDER BY STOCK_ID DESC
			</cfquery>
		<cfelse>
			<cfset get_p.recordcount=0>
		</cfif>
		<cfif get_p.recordcount neq 0>
			<cfquery name="GET_PRICE" dbtype="query">
				SELECT
					PRICE,
					PRICE_KDV,
					IS_KDV,
					MONEY 
				FROM 
					GET_ALL_PRICE_STANDART
				WHERE
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.pre_product_id#"> <!--- #get_last_stock_info.PRODUCT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]# --->
			</cfquery>
			<cfquery name="CONTROL_SAME_PROD_EXISTS" datasource="#DSN3#">
				SELECT 
					ORDER_ROW_ID,QUANTITY,PRE_STOCK_AMOUNT
				FROM
					ORDER_PRE_ROWS
				WHERE
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.stock_id#"> AND
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last_stock_info.product_id[listfind(add_row_stock_id_list,add_row_info.stock_id)]#">
					AND ISNULL(PRE_STOCK_ID,STOCK_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.pre_stock_id#">
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
                        AND PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last_stock_info.product_unit_id[listfind(add_row_stock_id_list,add_row_info.stock_id)]#">
                        AND ISNULL(IS_PROM_ASIL_HEDIYE,0) = 0
                        AND ISNULL(IS_COMMISSION,0) = 0
                    <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
                        AND TO_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                    <cfelse>
                        AND TO_CONS IS NULL
                    </cfif>
                    <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                        AND TO_COMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                    <cfelse>
                        AND TO_COMP IS NULL
                    </cfif>
                    <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
                        AND TO_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
                    <cfelse>
                        AND TO_PAR IS NULL
                    </cfif>
                        AND RECORD_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                    <cfif isdefined("session.pp")>AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelse>AND RECORD_PAR IS NULL</cfif>
                    <cfif isdefined("session.ww.userid")>AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"><cfelse>AND RECORD_CONS IS NULL</cfif>
                    <cfif isdefined("session.ep.userid")>AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>AND RECORD_EMP IS NULL</cfif>
			</cfquery>
			<cfif control_same_prod_exists.recordcount>
				<cfquery name="UPD_MAIN_PRODUCT_" datasource="#DSN3#">
					UPDATE 
						ORDER_PRE_ROWS 
					SET 
						QUANTITY = #control_same_prod_exists.quantity+add_row_info.amount#,
						PRE_STOCK_AMOUNT = #control_same_prod_exists.pre_stock_amount+add_row_info.amount#
					WHERE 
						ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_exists.order_row_id#">
						AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.stock_id#">
						AND PRE_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.pre_stock_id#">
				</cfquery>
			<cfelse>
				<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
					INSERT INTO
						ORDER_PRE_ROWS
                        (
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
                            IS_FROM_SERI_SONU,
                            TO_CONS,
                            TO_COMP,
                            TO_PAR,
                            IS_NONDELETE_PRODUCT,
                            RECORD_PERIOD_ID,
                            RECORD_PAR,
                            RECORD_CONS,
                            RECORD_EMP,
                            RECORD_GUEST,
                            COOKIE_NAME,
                            SALE_PARTNER_ID,
                            SALE_CONSUMER_ID,
                            RECORD_IP,
                            RECORD_DATE
                        )
                        VALUES
                        (
                            #add_row_info.pre_product_id#,
                            #add_row_info.pre_stock_id#,
                            #add_row_info.pre_stock_amount#,
                            #get_last_stock_info.product_id[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
                            <cfif trim(get_last_stock_info.property[listfind(add_row_stock_id_list,add_row_info.stock_id)]) is '-'>'#get_last_stock_info.product_name[listfind(add_row_stock_id_list,add_row_info.stock_id)]#'<cfelse>'#get_last_stock_info.product_name[listfind(add_row_stock_id_list,add_row_info.stock_id)]# #get_last_stock_info.property[listfind(add_row_stock_id_list,add_row_info.stock_id)]#'</cfif>,
                            #add_row_info.amount#,
                            <cfif get_p.recordcount>
                                <cfif add_row_info.pre_stock_id neq add_row_info.stock_id and add_row_info.pre_stock_amount neq 0> <!--- alternatif urunu verilmisse birim fiyatı yeniden hesaplanıyor --->
                                    #wrk_round(get_p.price/(add_row_info.amount/add_row_info.pre_stock_amount))#,
                                    #wrk_round(get_p.price_kdv/(add_row_info.amount/add_row_info.pre_stock_amount))#,
                                <cfelse>
                                    #get_p.price#,
                                    #get_p.price_kdv#,
                                </cfif>
                                '#get_p.money#',
                            <cfelse>
                                NULL,
                                NULL,
                                NULL,
                                <!--- #GET_PRICE.PRICE#,
                                #GET_PRICE.PRICE_KDV#,
                                '#GET_PRICE.MONEY#', --->
                            </cfif>
                            #get_last_stock_info.tax[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
                            #add_row_info.stock_id#,
                            <cfif len(add_row_info.stock_action_id)>#add_row_info.stock_action_id#<cfelse>0</cfif>,
                            <cfif len(add_row_info.stock_action_type)>#add_row_info.stock_action_type#<cfelse>NULL</cfif>,
                            #get_last_stock_info.product_unit_id[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
                            1,
                            0,
                            0,
                            <cfif isDefined("attributes.is_commission") and attributes.is_commission eq 1>1<cfelse>0</cfif>,
                            <cfif add_row_info.pre_stock_id neq add_row_info.stock_id and add_row_info.pre_stock_amount neq 0> <!--- alternatif urunu verilmisse birim fiyatı yeniden hesaplanıyor --->
                                #wrk_round(get_price.price/(add_row_info.amount/add_row_info.pre_stock_amount))#,
                                #wrk_round(get_price.price_kdv/(add_row_info.amount/add_row_info.pre_stock_amount))#,
                            <cfelse>
                                #get_price.price#,
                                #get_price.price_kdv#,
                            </cfif>
                            '#get_price.money#',
                            0,
                            <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
                            0,
                            #session_base.period_id#,
                            <cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
                            <cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                            <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
                            <cfif not isdefined("session.pp") and not isdefined("session.ww.userid")>1<cfelse>0</cfif>,
                            <cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.sales_member_id') and len(attributes.sales_member_id) and len(attributes.sales_member) and attributes.sales_member_type is 'partner'>#attributes.sales_member_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('attributes.sales_cons_id') and len(attributes.sales_cons_id) and len(attributes.sales_member) and attributes.sales_member_type is 'consumer'>#attributes.sales_cons_id#<cfelse>NULL</cfif>,
                            '#cgi.remote_addr#',
                            #now()#
                        )
				</cfquery>
			</cfif>
		<cfelse>
			<cfif isdefined('attributes.use_prod_code_type') and  attributes.use_prod_code_type eq 2><!--- özel kod --->
				<cfif not listfind(not_added_stock_code_list,get_all_stock.stock_code_2[listfind(list_stock_id_,add_row_info.pre_stock_id)])>
					<cfset not_added_stock_code_list=listappend(not_added_stock_code_list,get_all_stock.stock_code_2[listfind(list_stock_id_,add_row_info.pre_stock_id)])>
				</cfif>
			<cfelse>
				<cfif not listfind(not_added_stock_code_list,get_all_stock.stock_code[listfind(list_stock_id_,add_row_info.pre_stock_id)])>
					<cfset not_added_stock_code_list=listappend(not_added_stock_code_list,get_all_stock.stock_code[listfind(list_stock_id_,add_row_info.pre_stock_id)])>
				</cfif>
			</cfif>
		</cfif>
	</cfoutput>
</cfif>
<cfif fusebox.use_stock_speed_reserve><!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor ---> 
	<cfinclude template="../query/get_basket_rows.cfm">
     <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#dsn3#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
    </cfstoredproc>
	<cfoutput query="get_rows">
		<!--- Stok stratejisine göre action_type ı 1,2,3 olmayanlara rezerve yapılıyor --->
		<cfif (len(get_rows.stock_action_type) and not listfind('1,2,3',get_rows.stock_action_type,',')) or not len(get_rows.stock_action_type)>
			<cfquery name="ADD_RESERVE_" datasource="#DSN3#">
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
					#get_rows.stock_id#,
					#get_rows.product_id#,
					#quantity#,
					#order_row_id#,
					'#CFTOKEN#',
					1				
				)
			</cfquery>
		</cfif>
	</cfoutput>
</cfif>
<cfif listlen(not_added_stock_code_list) neq 0>
	<script type="text/javascript">
		alert("<cfoutput>#not_added_stock_code_list#</cfoutput> Nolu <cfif isdefined('attributes.use_prod_code_type') and  attributes.use_prod_code_type eq 2>Ürün Kodları<cfelse>Stok Kodları</cfif> Bulunmamaktadır veya Bu Ürünlere İlgili Fiyat Listesinde Bir Fiyat Girilmemiş!");
	</script>
</cfif>
<cfif not isdefined('from_stock_id')>
	<cfoutput>
		<form name="form_list_basket" id="form_list_basket" action="#request.self#?fuseaction=objects2.list_basket" method="post">
			<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
        	<input type="hidden" name="company_id" id="company_id" value="<cfif isDefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#</cfif>">
			<input name="price_catid" id="price_catid" value="#attributes.price_catid#" type="hidden">
			<input type="text" name="moz" id="moz" value="" style="width:0px; border-color:FFFFFF; border:0px;" /><!--- Mozilla icin eklendi silmeyelim --->
		</form>
	</cfoutput>
	<script type="text/javascript">
	   document.getElementById('form_list_basket').submit();
	</script>
</cfif>
