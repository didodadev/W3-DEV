<cf_get_lang_set module_name="objects">
<cfif isdefined("attributes.from_product_tree")><!--- ağaç temizlendiğinde malzemelerin gelmesini önlemek için eklendi 0715 PY  --->
    <cfquery name="is_prod_tree" datasource="#dsn3#">
        SELECT STOCK_ID FROM PRODUCT_TREE WHERE STOCK_ID = #attributes.stock_id#
    </cfquery>
    <cfif not is_prod_tree.recordcount>
        <cfabort>
    </cfif>
</cfif>
<cfset scrap_location = ''><!--- Hurda lokasyonların gerçek stoğa etki yapmaması için eklendi.Stok durumlarını gösteren triggerlar yapılınca kaldırılıcak. --->
<cfquery name="get_tree_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.add_product_tree"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="is_show_production_type">
</cfquery>
<cfif get_tree_xml.recordcount>
	<cfset is_show_stock_type = get_tree_xml.PROPERTY_VALUE>
<cfelse>
	<cfset is_show_stock_type = 1>
</cfif>
<cfquery name="get_tree_xml2" datasource="#dsn#"><!--- hesaplamalar bu xml bilgisine göre geliyor --->
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.add_product_tree"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="is_show_stock_type">
</cfquery>
<cfif get_tree_xml.recordcount>
	<cfset is_show_stock_type = get_tree_xml.PROPERTY_VALUE>
<cfelse>
	<cfset is_show_stock_type = 1>
</cfif>
<cfif get_tree_xml2.recordcount>
	<cfset is_show_stock_type2 = get_tree_xml2.PROPERTY_VALUE>
<cfelse>
	<cfset is_show_stock_type2 = 1>
</cfif>
<cfquery name="get_scrap_locations" datasource="#dsn#"><!--- Hurda depo ve lokasyonlar çekiliyor! GERÇEK STOK ONA GÖRE BELLİ OLACAK!--->
	SELECT
		SL.LOCATION_ID,
		SL.DEPARTMENT_ID
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
</cfquery>
<cfif (isdefined("attributes.p_order_id") and len(attributes.p_order_id))>
	<cfquery name="GET_DET_PO" datasource="#dsn3#">
		SELECT STATION_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
	</cfquery>
	<cfif len(GET_DET_PO.STATION_ID) and (isdefined("attributes.is_real_stock_from_dept") and attributes.is_real_stock_from_dept eq 1)>
		<cfquery name="GET_STATION" datasource="#dsn3#">
			SELECT 
				STATION_NAME,
				EXIT_DEP_ID,
				EXIT_LOC_ID,
				ENTER_DEP_ID,
				ENTER_LOC_ID,
				PRODUCTION_DEP_ID,
				PRODUCTION_LOC_ID
			FROM 
				WORKSTATIONS 
			WHERE 
				STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_DET_PO.STATION_ID#">
		</cfquery>
	</cfif>
</cfif>
<cfif get_scrap_locations.recordcount>
	<cfsavecontent variable="scrap_location">
		<cfoutput>
		<cfloop query="get_scrap_locations">
		  AND NOT ( STORE_LOCATION = #LOCATION_ID# AND STORE = #DEPARTMENT_ID#)
		</cfloop>
		</cfoutput>
	</cfsavecontent>
</cfif>
<cfparam name="attributes.row_number" default="1"><!--- Eğerki Malzeme İhtiyaçları Liste Sayfası Gibi bir yerlerden çağırılmıyorsa tek çağırlıyorsa satır numarası default olarak 1 olsun.. --->
<script type="text/javascript">
	function tedarik_suresini_belirt(sid){
		if(document.getElementById('max_provision_time_'+sid) != undefined)
			document.getElementById('max_provision_time_'+sid).className = 'txtbold';
		else
			setTimeout('tedarik_suresini_belirt('+sid+')',20);
	
	}
</script>
<cfparam name="attributes.deep_level_max" default="99"><!--- Malzeme İhtiyaçlarının kaç kırılım alta gideceğini gösteriyor. boş ise son kırılıma kadar gider. --->
<cfif not isdefined("attributes.order_amount")><cfset attributes.order_amount = 1></cfif>
<cfif not isdefined("attributes.main_stock_id")><cfset attributes.main_stock_id = 0></cfif>
<cfsetting showdebugoutput="no">
<cfif (not isdefined('attributes.spect_main_id') or not len(attributes.spect_main_id) or attributes.spect_main_id eq 0) and len(attributes.stock_id) and attributes.stock_id gt 0><!--- spec main id yoksa ağactaki mevcut main spec id'sini alıcaz. --->
	<cfinclude template="../../workdata/get_main_spect_id.cfm">
	<cfset _new_main_spec_id_ = get_main_spect_id(attributes.stock_id,0)>
    <cfset attributes.spect_main_id = _new_main_spec_id_.SPECT_MAIN_ID>	
<cfelseif (not isdefined('attributes.spect_main_id') or not len(attributes.spect_main_id) or attributes.spect_main_id eq 0) and len(attributes.main_stock_id) and attributes.main_stock_id gt 0><!--- spec main id yoksa ağactaki mevcut main spec id'sini alıcaz. --->
	<cfinclude template="../../workdata/get_main_spect_id.cfm">
	<cfset _new_main_spec_id_ = get_main_spect_id(attributes.main_stock_id,0)>
    <cfset attributes.spect_main_id = _new_main_spec_id_.SPECT_MAIN_ID>	
<cfelseif (not isdefined('attributes.spect_main_id') or not len(attributes.spect_main_id) or attributes.spect_main_id eq 0) >
    <cfset attributes.spect_main_id = ''>	
</cfif>
<cfif not isdefined("attributes.this_production_amount")><cfset attributes.this_production_amount = 1></cfif>
<cfif (isdefined('attributes.spect_var_id') and spect_var_id gt 0) or len(attributes.spect_main_id)><!--- Ürünün bir spec'i varsa spectdeki ürünlerin kırılımlarını getir --->
	<cfset stock_id_list = ''>
	<cfset spect_main_id_list = ''>
	<cfscript>
		function get_subs_2(spect_id)
		{		
			SQLStr = "
					SELECT
						SM.AMOUNT,
						ISNULL(RELATED_MAIN_SPECT_ID,0) RELATED_MAIN_SPECT_ID,
						SM.STOCK_ID
					FROM 
						SPECT_MAIN_ROW SM
					WHERE
						SM.SPECT_MAIN_ID = #spect_id#
						AND SM.STOCK_ID IS NOT NULL
				";
			query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
			stock_id_ary2='';
			for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
			{
				stock_id_ary2=listappend(stock_id_ary2,query1.AMOUNT[str_i],'█');
				stock_id_ary2=listappend(stock_id_ary2,query1.RELATED_MAIN_SPECT_ID[str_i],'§');
				stock_id_ary2=listappend(stock_id_ary2,query1.STOCK_ID[str_i],'§');
			}
			return stock_id_ary2;
		}
		function writeTree2(spect_main_id)
		{
			var i = 1;
			var sub_products = get_subs_2(spect_main_id);
			for (i=1; i lte listlen(sub_products,'█'); i = i+1)
			{
				_next_amount_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
				_next_spect_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
				_next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
				stock_id_list = listappend(stock_id_list,_next_stock_id_,',');
				spect_main_id_list = listappend(spect_main_id_list,_next_spect_id_,',');
				if(_next_spect_id_ gt 0)
					writeTree2(_next_spect_id_);
			 }
		}
		writeTree2(attributes.spect_main_id);
		if(isdefined("attributes.p_order_id") and len(attributes.p_order_id))
			new_state = 'AND PO.P_ORDER_ID <> #attributes.p_order_id#';
		else if(isdefined("attributes.upd") and len(attributes.upd))
			new_state = 'AND PO.P_ORDER_ID <> #attributes.upd#';
		else
			new_state = '';
	</cfscript>
	<cfif listlen(stock_id_list)>
    	<cfquery name="get_stock_all" datasource="#dsn2#">
			EXEC SP_GET_STOCK_ALL '#stock_id_list#',
            <cfif get_scrap_locations.recordcount>2<cfelse>1</cfif>
            <cfif isdefined("attributes.p_order_id") and len(attributes.p_order_id)>
            	,#attributes.p_order_id#
            <cfelseif isdefined("attributes.upd") and len(attributes.upd)>
            	,#attributes.upd#
            <cfelse>
            	,-1
            </cfif>
		</cfquery>
		<cfoutput query="get_stock_all">
			<cfset "product_stock_#stock_id#_#spec_main_id#" = get_stock_all.product_stock>
			<cfset "saleable_stock_#stock_id#_#spec_main_id#" = get_stock_all.saleable_stock>
		</cfoutput>
	</cfif>
	<cfscript>
		stock_and_spect_list ='';
		stock_id_list ='';
		deep_level = 0;
		function get_subs(stock_id,spec_id,product_tree_id,type)//type 0 ise sarf 3 ise operasyon
		{
			if(new_state == '')
				SQLStr = "
						SELECT 
							ISNULL(PT.RELATED_MAIN_SPECT_ID,0) AS SPECT_MAIN_ID,
							STOCKS.STOCK_ID,
							STOCKS.STOCK_CODE,
							STOCKS.PRODUCT_NAME,
							STOCKS.PROPERTY,
							PRODUCT_UNIT.MAIN_UNIT,
							STOCKS.IS_PRODUCTION,
							ISNULL(PT.IS_CONFIGURE,0) AS IS_CONFIGURE,
							ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
							STOCKS.PRODUCT_ID,
							ISNULL(PT.AMOUNT,0) AS AMOUNT,
							ISNULL(RELATED_MAIN_SPECT_ID,0) PRODUCT_TREE_ID,
							ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
							ISNULL(PT.IS_PHANTOM,0) AS IS_PHANTOM,
							ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
							0 AS OPERATION_TYPE_ID,
							ISNULL(PT.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT
						FROM
							STOCKS,
							SPECT_MAIN_ROW PT,
							PRODUCT_UNIT
						WHERE
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
							PT.STOCK_ID = STOCKS.STOCK_ID AND
							PT.SPECT_MAIN_ID = #product_tree_id# AND
							PT.IS_PROPERTY IN(0,4)
						ORDER BY
							ISNULL(PT.LINE_NUMBER,0)
					";
			else
				SQLStr = "
						SELECT 
							ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
							STOCKS.STOCK_ID,
							STOCKS.STOCK_CODE,
							STOCKS.PRODUCT_NAME,
							STOCKS.PROPERTY,
							PRODUCT_UNIT.MAIN_UNIT,
							STOCKS.IS_PRODUCTION,
							0 AS IS_CONFIGURE,
							0 AS QUESTION_ID,
							STOCKS.PRODUCT_ID,
							ISNULL(PT.AMOUNT,0) AS AMOUNT,
							ISNULL(SPECT_MAIN_ID,0) PRODUCT_TREE_ID,
							ISNULL(PT.IS_SEVK,0) AS IS_SEVK,
							0 AS IS_PHANTOM,
							ISNULL(PT.LINE_NUMBER,0) LINE_NUMBER,
							0 AS OPERATION_TYPE_ID,
							1 AS IS_FREE_AMOUNT
						FROM
							STOCKS,
							PRODUCTION_ORDERS_STOCKS PT,
							PRODUCT_UNIT
						WHERE
							PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
							PT.STOCK_ID = STOCKS.STOCK_ID AND
							PT.P_ORDER_ID = #attributes.p_order_id# AND
							PT.IS_PROPERTY IN(0,4)
						ORDER BY
							ISNULL(PT.LINE_NUMBER,0)
							
					";
			query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
			stock_id_ary='';
			for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
			{
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'█');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.STOCK_CODE[str_i],'§');
				if(len(query1.PROPERTY[str_i]))
					stock_id_ary=listappend(stock_id_ary,query1.PROPERTY[str_i],'§');
				else
					stock_id_ary=listappend(stock_id_ary,'-','§');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_NAME[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_TREE_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_CONFIGURE[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_SEVK[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_PHANTOM[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_PRODUCTION[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.LINE_NUMBER[str_i],'§');
				stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
				if(len(query1.MAIN_UNIT[str_i]))
					stock_id_ary=listappend(stock_id_ary,query1.MAIN_UNIT[str_i],'§');
				else
					stock_id_ary=listappend(stock_id_ary,'-','§');
				stock_id_ary=listappend(stock_id_ary,query1.IS_FREE_AMOUNT[str_i],'§');
			}
			return stock_id_ary;
		}
		function writeRow(_next_spect_main_id_,_next_stock_id_,_next_product_name_,_next_stock_amount_,deep_level,_next_is_production_,_next_is_purchase_,_next_is_stock_code_,_next_is_phantom_,_n_free_amount_)	
		{
			//birim ihtiyaç başlangıç
				if(deep_level eq 1)
			{
				'product_amount#deep_level#' = _next_stock_amount_;// satır bazında malzeme ihtiyaçları
				carpan = 1;
			}
			else if(isdefined("product_amount#deep_level-1#"))
			{
				'product_amount#deep_level#' = Evaluate('product_amount#deep_level-1#')*_next_stock_amount_;
				carpan = Evaluate('product_amount#deep_level-1#');
			}
			else
			{
				'product_amount#deep_level#' = _next_stock_amount_;// satır bazında malzeme ihtiyaçları
				carpan = 1;
			}
			strategy_total_query_txt="
				  SELECT
					ISNULL(SS.MINIMUM_STOCK,0) AS MINIMUM_STOCK
				FROM
					STOCK_STRATEGY SS
				WHERE
					STOCK_ID = #_next_stock_id_#";
			strategy_total_query_result = cfquery(SQLString : strategy_total_query_txt, Datasource : dsn3);
			if(strategy_total_query_result.recordcount gt 0 and not listfind(stock_id_list,_next_stock_id_)) min_stock_ = strategy_total_query_result.MINIMUM_STOCK;else min_stock_ = 0;
			if (isdefined("saleable_stock_#_next_stock_id_#_#_next_spect_main_id_#")) stock_total_query_saleable_stock = evaluate("saleable_stock_#_next_stock_id_#_#_next_spect_main_id_#"); else stock_total_query_saleable_stock = 0;
			if (isdefined("product_stock_#_next_stock_id_#_#_next_spect_main_id_#")){ stock_total_query_product_stock = evaluate("product_stock_#_next_stock_id_#_#_next_spect_main_id_#"); }else {stock_total_query_product_stock = 0;}
			if(_n_free_amount_ eq 1)attributes.this_production_amount=1;
			//gerçek ihtiyaç başlangıç
			if(deep_level eq 1)//eğer 1.ci kırılım ise
			{//writeoutput(((Evaluate("product_amount#deep_level#")*attributes.this_production_amount)+min_stock_)&'**'&stock_total_query_product_stock&'<br>');
				if(Evaluate((Evaluate("product_amount#deep_level#")*attributes.this_production_amount)+min_stock_) gt stock_total_query_product_stock)//1.ci kırılımdaki BİRİM İHTİYAÇ ürünün gerçek stoğundan büyük ise..Yani eldeki stok ile üretim miktarı karşılanamıyorsa..
				{//writeoutput(_next_stock_id_&'**'&attributes.this_production_amount&'***'&Evaluate("product_amount#deep_level#")&'+'&min_stock_&'*'&stock_total_query_product_stock&'<br>');
					"real_product_amount#deep_level#" = (Evaluate((Evaluate("product_amount#deep_level#")*attributes.this_production_amount)+min_stock_)-stock_total_query_product_stock);//gerçek üretim miktarı = birim ihtiyaç-gerçek stok.
				}
				else
				{//writeoutput(#_next_stock_id_#&'<br>');
					"real_product_amount#deep_level#" = 0;//eğer birim ihtiyaç miktarı gerçek ürün stoğundan küçük ise zaten satır için üretim karşılanmış oluyor,dolayısı ile 0 set ediyoruz ve bu üretimin altında üretimlerde varsa bu satır sıfır olduğu için bunun altındakilerlerde otomatik olarak sıfır oluyor..
				}
			}
			else
			{
				if(((carpan*_next_stock_amount_*attributes.this_production_amount)+min_stock_) gt stock_total_query_product_stock and ((carpan*_next_stock_amount_*attributes.this_production_amount)+min_stock_) gt 0)//eğer 1.ci kırılım değilse bu sefer bir önceki kırılımdaki GERÇEK ÜRETİM miktarını alıyoruz ve satırın kendi miktarı ile çarpıyoruz,bu değer ürünün gerçek stoğundan büyükse ve satır için hesaplanan gerçek üretim ihtiyacı 0 dan büyükse
					'real_product_amount#deep_level#' = '#((carpan*_next_stock_amount_*attributes.this_production_amount)+min_stock_)-stock_total_query_product_stock#';//1 üst kırılımdaki için GERÇEK İHTİYAC*SATIRDAKİ MİKTAR-ÜRÜNÜN GERÇEK STOĞU bu satırın gerçek ihtiyacını verir bize.
				else//satır için gerekli GERÇEK ÜRETİM MİKTARI,ÜRÜNÜN GERÇEK STOĞUNUN ALTINDAYSA YADA 0 DAN KÜÇÜK İSE DİRETK OLARAK 0 olarak set ediyoruz,bu kırılımın altındaki ürünlerde 0 oluyor bu durumda..
					"real_product_amount#deep_level#" = 0;
			}
			//gerçek ihtiyaç bitiş
			//kullanılabilir ihtiyaç başlangıç
			'saleable_product_stock_#_next_stock_id_#_#_next_spect_main_id_#' = stock_total_query_saleable_stock;
			if(deep_level eq 1)//eğer 1.ci kırılım ise
				if(Evaluate(Evaluate("product_amount#deep_level#")*attributes.this_production_amount+min_stock_) gt stock_total_query_saleable_stock)//1.ci kırılımdaki BİRİM İHTİYAÇ ürünün gerçek stoğundan büyük ise..Yani eldeki stok ile üretim miktarı karşılanamıyorsa..
					"saleable_product_amount#deep_level#" = Evaluate(Evaluate("product_amount#deep_level#")*attributes.this_production_amount+min_stock_)-stock_total_query_saleable_stock;//gerçek üretim miktarı = birim ihtiyaç-gerçek stok.
				else
					"saleable_product_amount#deep_level#" = 0;//eğer birim ihtiyaç miktarı gerçek ürün stoğundan küçük ise zaten satır için üretim karşılanmış oluyor,dolayısı ile 0 set ediyoruz ve bu üretimin altında üretimlerde varsa bu satır sıfır olduğu için bunun altındakilerlerde otomatik olarak sıfır oluyor..
			else
				if(((carpan*_next_stock_amount_*attributes.this_production_amount)+min_stock_) gt stock_total_query_saleable_stock and ((carpan*_next_stock_amount_*attributes.this_production_amount)+min_stock_) gt 0)//eğer 1.ci kırılım değilse bu sefer bir önceki kırılımdaki GERÇEK ÜRETİM miktarını alıyoruz ve satırın kendi miktarı ile çarpıyoruz,bu değer ürünün gerçek stoğundan büyükse ve satır için hesaplanan gerçek üretim ihtiyacı 0 dan büyükse
					'saleable_product_amount#deep_level#' = '#((carpan*_next_stock_amount_*attributes.this_production_amount)+min_stock_)-stock_total_query_saleable_stock#';//1 üst kırılımdaki için GERÇEK İHTİYAC*SATIRDAKİ MİKTAR-ÜRÜNÜN GERÇEK STOĞU bu satırın gerçek ihtiyacını verir bize.
				else//satır için gerekli GERÇEK ÜRETİM MİKTARI,ÜRÜNÜN GERÇEK STOĞUNUN ALTINDAYSA YADA 0 DAN KÜÇÜK İSE DİRETK OLARAK 0 olarak set ediyoruz,bu kırılımın altındaki ürünlerde 0 oluyor bu durumda..
					"saleable_product_amount#deep_level#" = 0;		
			//kullanılabilir ihtiyaç bitiş
			//*****
			if(_next_stock_id_ gt 0 and _next_is_phantom_ neq 1)
			{
				stock_id_list = ListAppend(stock_id_list,_next_stock_id_);
				if(not isdefined('product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#'))//genel anlamda malzeme ihtiyaçları
					{
					'product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#' = Evaluate(Evaluate('product_amount#deep_level#'));//ürününlerin miktarı
					'real_product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#' = Evaluate(Evaluate('real_product_amount#deep_level#'));//gerçek stok için ürününlerin miktarı
					'saleable_product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#' = Evaluate(Evaluate('saleable_product_amount#deep_level#'));//gerçek stok için ürününlerin miktarı
					 stock_and_spect_list = ListAppend(stock_and_spect_list,'#_next_stock_id_#_#_next_spect_main_id_#_#_next_is_production_#_#_next_is_purchase_#_#Replace(_next_is_stock_code_,',',';')#_#_next_is_phantom_#_#_n_free_amount_#',',');//ürünlerimizin listesi  _#Replace(_next_is_stock_code_,',',';')#_ stok kodunda virgül kullnılınca sayfa hata veriyosa kullanılabilir.
					}
				else
					{
					//eğer aynı ürün ağaç içinde birden fazla kullanılmış ise ürünü kendi içinde topluyoruz.
					'product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#' = Evaluate('product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#') + Evaluate(Evaluate('product_amount#deep_level#'));
					'real_product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#' = Evaluate('real_product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#') + Evaluate(Evaluate('real_product_amount#deep_level#'));
					'saleable_product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#'= Evaluate('saleable_product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#') + Evaluate(Evaluate('saleable_product_amount#deep_level#'));
					}
			}
		}	
		function writeTree(next_stock_id,next_spec_id,next_production_tree_id,type)
		{
			var i = 1;
			var sub_products = get_subs(next_stock_id,next_spec_id,next_production_tree_id,type);
			if(deep_level lt attributes.deep_level_max)
			{//kaç kırılım gideceğni belirliyoruz.
				deep_level = deep_level + 1;
				for (i=1; i lte listlen(sub_products,'█'); i = i+1)
				{
					product_values_list = ListGetAt(sub_products,i,'█');
					leftSpace = RepeatString('&nbsp;', deep_level*5);
					_n_stock_id_ = ListGetAt(product_values_list,1,'§');
					_n_product_id_ = ListGetAt(product_values_list,2,'§');
					_n_stock_code_ = ListGetAt(product_values_list,3,'§');
					_n_property_ = ListGetAt(product_values_list,4,'§');
					_n_product_name_ = ListGetAt(product_values_list,5,'§');
					_n_spec_main_id_ = ListGetAt(product_values_list,6,'§');
					_n_product_tree_id_ = ListGetAt(product_values_list,7,'§');
					_n_operation_type_id_ = ListGetAt(product_values_list,8,'§');
					_n_amount_ = ListGetAt(product_values_list,9,'§');
					_n_is_confg_ = ListGetAt(product_values_list,10,'§');
					_n_is_sevk_ = ListGetAt(product_values_list,11,'§');
					_n_is_phantom_ = ListGetAt(product_values_list,12,'§');
					_n_is_production_ = ListGetAt(product_values_list,13,'§');
					_n_line_number_ = ListGetAt(product_values_list,14,'§');
					_n_question_id_ = ListGetAt(product_values_list,15,'§');
					_n_main_unit_ = ListGetAt(product_values_list,16,'§');
					_n_free_amount_ = ListGetAt(product_values_list,17,'§');
					writeRow(_n_spec_main_id_,_n_stock_id_,_n_product_name_,_n_amount_,deep_level,_n_is_production_,0,_n_stock_code_,_n_is_phantom_,_n_free_amount_);
					if(new_state == '')writeTree(_n_stock_id_,_n_spec_main_id_,_n_product_tree_id_,0);
				}
				deep_level = deep_level-1;
			}	
		}
		writeTree(attributes.stock_id,0,attributes.spect_main_id,0);
	</cfscript>
</cfif>
<cf_grid_list>
	<thead>
		<!--- <cfif not isdefined('from_upd_production_page')><!--- Üretim Emri Güncellemesinden Geliyorsa Bu Kısmı Gösterme --->
            <tr>
                <th colspan="16"><img src="/images/forklift.gif"><cf_get_lang no ='1582.Malzeme İhtiyaçları'></th>
            </tr>
        </cfif> --->
        <tr>
            <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
            <th><cf_get_lang dictionary_id='34299.Spec'></th>
            <th><cf_get_lang dictionary_id='57636.Birim'></th>
            <cfif not isdefined("attributes.is_production")>
                <th width="60"><cf_get_lang dictionary_id='57611.Sipariş'><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
            </cfif> 
            <th width="60"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57636.Birim'><cf_get_lang dictionary_id='36437.İhtiyaç'></th>
			<cfif ListFind(ListDeleteDuplicates(is_show_stock_type),2)>
            	<th width="60"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
            </cfif>
		    <cfif not isdefined("attributes.is_production")>
				<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),2)>
					<th width="55"><cf_get_lang dictionary_id='58120.Gerçek Stok'> <cf_get_lang dictionary_id='36437.İhtiyaç'></th>
					<th width="20"><input type="radio" name="get_all" id="all_select_<cfoutput>#attributes.row_number#</cfoutput>" onclick="check_all(<cfoutput>#attributes.row_number#</cfoutput>,0)" title="<cf_get_lang dictionary_id='58120.Gerçek Stok'> <cf_get_lang dictionary_id='36437.İhtiyaç'>" value="0"></th>	
				</cfif>
				<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),3)>
					<th width="60" ><cf_get_lang dictionary_id='45241.Satılabilir Stok'></th>
					<th width="55" ><cf_get_lang dictionary_id='45241.Satılabilir Stok'><cf_get_lang dictionary_id='36437.İhtiyaç'></th>
					<th width="20"><input type="radio" name="get_all" id="all_select_<cfoutput>#attributes.row_number#</cfoutput>" onclick="check_all(<cfoutput>#attributes.row_number#</cfoutput>,1)" title="<cf_get_lang dictionary_id='45241.Satılabilir Stok'><cf_get_lang dictionary_id='36437.İhtiyaç'>" value="1"></th>
				</cfif>
                <th width="40"  nowrap title="<cf_get_lang dictionary_id='32684.Stoktaki Miktar ile % Kaç Üretim Yapılabilir'>">%</th>
                <cfif isdefined('is_prod_real_stock') and is_prod_real_stock eq 1><th width="60" class="text-right"><cf_get_lang dictionary_id='36504.ÜE Gerçek Stok'></th></cfif>
                <th width="60" ><cf_get_lang dictionary_id='33969.Min Stok'></th>
                <th width="60"><cf_get_lang dictionary_id='33971.Min Sipariş Miktarı'></th>
                <th width="60" title="<cf_get_lang dictionary_id='30008.Satınalma Siparişleri'>.."><cf_get_lang dictionary_id='30851.Verilen Siparişler'></th>
            </cfif>
            <th width="60"><cf_get_lang dictionary_id='33970.Tedarik Süresi(Gün)'></th>
        </tr>
    </thead>
    <tbody id="status" name="status">
	<cfif isdefined('stock_and_spect_list') and  ListLen(stock_and_spect_list,',')><!--- Oluşan yeni listemizde her ürünümüz ve spect'imiz bir kere bulunuyor. --->
        <cfquery name="get_scrap_locations" datasource="#dsn#"><!--- Hurda depo ve lokasyonlar çekiliyor! GERÇEK STOK ONA GÖRE BELLİ OLACAK!--->
        SELECT
            SL.LOCATION_ID,
            SL.DEPARTMENT_ID
        FROM 
            #dsn_alias#.STOCKS_LOCATION SL,
            #dsn_alias#.DEPARTMENT D
        WHERE
            SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
        </cfquery>
        <cfquery name="_PRODUCT_TOTAL_STOCK_" datasource="#DSN2#"><!--- Ürünlerin stock durumlarını liste yöntemi ile alıyoruz. --->
			SELECT 
				ISNULL(SUM(PRODUCT_STOCK),0) AS PRODUCT_STOCK,
                STOCK_ID,
				ISNULL(SPECT_VAR_ID,0) SPECT_VAR_ID
			FROM 
				(
                	SELECT
                        SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
						ISNULL(SR.SPECT_VAR_ID,0) SPECT_VAR_ID,
                        S.PRODUCT_ID, 
                        S.STOCK_ID, 
                        S.STOCK_CODE, 
                        S.PROPERTY,
                        S.STOCK_STATUS, 
                        S.BARCOD
                    FROM
                        #dsn1_alias#.STOCKS S,
                        STOCKS_ROW SR
                    WHERE
                        S.STOCK_ID = SR.STOCK_ID
                        #scrap_location#
						<cfif isdefined("GET_STATION") and len(GET_STATION.EXIT_DEP_ID)>
							AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION.EXIT_DEP_ID#">
							AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION.EXIT_LOC_ID#">
						</cfif>
                    GROUP BY
						SR.SPECT_VAR_ID,
                        S.PRODUCT_ID,
                        S.STOCK_ID,
                        S.STOCK_CODE,
                        S.PROPERTY,
                        S.STOCK_STATUS, 
                        S.BARCOD
                ) AS GET_STOCK<!--- GET_STOCK wiew'in içeriğinin orjinali,hurda lokasyonlarının gelmesini engellmek için bu şekilde yazıldı.Özden trigger'ları bitirince bu sayfaların tamamen düzenlemensi lazım. M.ER --->
			WHERE
			<cfloop list="#stock_and_spect_list#" index="fff">
				(STOCK_ID = #ListGetAt(fff,1,'_')#)
				<cfif listlast(stock_and_spect_list) neq fff > OR</cfif> 
			</cfloop>
            GROUP BY STOCK_ID,SPECT_VAR_ID 
		</cfquery>
        <cfif isdefined('is_prod_real_stock') and is_prod_real_stock eq 1>
            <cfquery name="_PRODUCT_TOTAL_STOCK_2" datasource="#DSN2#"><!--- xmle bağlı olarak üretim emri bitiş tarihine bazında gerçek stok bilgisi getiriyoruz. --->
                SELECT 
                    ISNULL(SUM(PRODUCT_STOCK),0) AS PRODUCT_STOCK,
                    STOCK_ID,
                    ISNULL(SPECT_VAR_ID,0) SPECT_VAR_ID
                FROM 
                    (
                        SELECT
                            SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
                            ISNULL(SR.SPECT_VAR_ID,0) SPECT_VAR_ID,
                            S.PRODUCT_ID, 
                            S.STOCK_ID, 
                            S.STOCK_CODE, 
                            S.PROPERTY,
                            S.STOCK_STATUS, 
                            S.BARCOD
                        FROM
                            #dsn1_alias#.STOCKS S,
                            STOCKS_ROW SR
                        WHERE
                            S.STOCK_ID = SR.STOCK_ID
                            #scrap_location#
                            <cfif isdefined("GET_STATION") and len(GET_STATION.EXIT_DEP_ID)>
                                AND SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION.EXIT_DEP_ID#">
                                AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STATION.EXIT_LOC_ID#">
                            </cfif>
                            <cfif isdefined("prod_finish_date")>
                            	AND SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#prod_finish_date#">
                            </cfif>
                        GROUP BY
                            SR.SPECT_VAR_ID, 
                            S.PRODUCT_ID,
                            S.STOCK_ID,
                            S.STOCK_CODE,
                            S.PROPERTY,
                            S.STOCK_STATUS, 
                            S.BARCOD
                    ) AS GET_STOCK<!--- GET_STOCK wiew'in içeriğinin orjinali,hurda lokasyonlarının gelmesini engellmek için bu şekilde yazıldı.Özden trigger'ları bitirince bu sayfaların tamamen düzenlemensi lazım. M.ER --->
                WHERE
                <cfloop list="#stock_and_spect_list#" index="fff">
                    (STOCK_ID = #ListGetAt(fff,1,'_')#)
                    <cfif listlast(stock_and_spect_list) neq fff > OR</cfif> 
                </cfloop>
                GROUP BY STOCK_ID,SPECT_VAR_ID 
            </cfquery>
        </cfif> 
        <cfquery name="getStockStrategy" datasource="#dsn3#">
            SELECT
                DISTINCT
                SS.STOCK_ID,
                ISNULL(SS.MAXIMUM_STOCK,0) AS MAXIMUM_STOCK,
                ISNULL(SS.PROVISION_TIME,0) AS PROVISION_TIME ,
                ISNULL(SS.REPEAT_STOCK_VALUE,0) AS REPEAT_STOCK_VALUE,
                ISNULL(SS.MINIMUM_STOCK,0) AS MINIMUM_STOCK,
                ISNULL(SS.MINIMUM_ORDER_STOCK_VALUE,0) AS MINIMUM_ORDER_STOCK_VALUE
            FROM
                STOCK_STRATEGY SS
            WHERE
                SS.STOCK_ID IN(<cfloop list="#stock_and_spect_list#" index="jjj">#ListGetAt(jjj,1,'_')#<cfif listlast(stock_and_spect_list) neq jjj >,</cfif></cfloop>) AND
                ISNULL(SS.DEPARTMENT_ID,0)=0
        </cfquery>
        <cfquery name="getProductId" datasource="#dsn1#">
        	SELECT PRODUCT_ID,STOCK_ID FROM STOCKS JOIN #DSN#.[fnSplit]('<cfloop list="#stock_and_spect_list#" index="ggg">#ListGetAt(ggg,1,'_')#<cfif listlast(stock_and_spect_list) neq ggg >,</cfif></cfloop>',',') AS XXX ON  XXX.item = STOCKS.STOCK_ID 
        </cfquery>
        <cfif getProductId.recordcount><cfloop query="getProductId"><cfset '_product_id_#STOCK_ID#' = PRODUCT_ID></cfloop></cfif>
        <cfscript>
		max_provision_time =0;
		for(strteg_ind=1;strteg_ind lte getStockStrategy.recordcount;strteg_ind=strteg_ind+1)
			'stock_strategy#getStockStrategy.STOCK_ID[strteg_ind]#'='#getStockStrategy.MINIMUM_STOCK[strteg_ind]#,#getStockStrategy.PROVISION_TIME[strteg_ind]#,#getStockStrategy.MINIMUM_ORDER_STOCK_VALUE[strteg_ind]#';
        </cfscript>
		<!--- <cfquery name="_GET_STOCK_RESERVED_" datasource="#DSN3#"><!--- Ürünün rezerve durumlarını liste yöntemi ile çekiyoruz. --->
			SELECT
				ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
				ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
				STOCK_ID,
				SPECT_MAIN_ID
			FROM
				GET_STOCK_RESERVED_SPECT
			WHERE
				<cfloop list="#stock_and_spect_list#" index="ccc">
				(STOCK_ID = #ListGetAt(ccc,1,'_')#
				)
				<cfif listlast(stock_and_spect_list) neq ccc > OR</cfif>
			</cfloop>
			GROUP BY STOCK_ID,SPECT_MAIN_ID
		</cfquery> --->
        <cfquery name="_GET_STOCK_RESERVED_" datasource="#DSN3#"><!--- Ürünün rezerve durumlarını liste yöntemi ile çekiyoruz. --->
			EXEC SP_GET_STOCK_RESERVED_SPECT '<cfloop list="#stock_and_spect_list#" index="ggg">#ListGetAt(ggg,1,'_')#<cfif listlast(stock_and_spect_list) neq ggg >,</cfif></cfloop>'
		</cfquery>
        <cfquery name="_location_based_total_stock_" datasource="#dsn2#">
            SELECT
            	STOCK_ID,
				SR.SPECT_VAR_ID,
                SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_LOCATION_STOCK
            FROM
                STOCKS_ROW SR,
                #dsn_alias#.STOCKS_LOCATION SL 
            WHERE
                (
                <cfloop list="#stock_and_spect_list#" index="ccc">
                STOCK_ID = #ListGetAt(ccc,1,'_')# <cfif listlast(stock_and_spect_list) neq ccc > OR</cfif>
                </cfloop>
                )
                AND
                SR.STORE = SL.DEPARTMENT_ID AND
                SR.STORE_LOCATION = SL.LOCATION_ID AND
                NO_SALE = 1
                #scrap_location#
           GROUP BY STOCK_ID,SR.SPECT_VAR_ID
        </cfquery>
		<cfscript>
			for(sayac=1; sayac lte _location_based_total_stock_.recordcount; sayac=sayac+1)//stock durumların için çektiğimiz quey'den gelen değerler set ediliyor
			{
				if(len(_location_based_total_stock_.TOTAL_LOCATION_STOCK[sayac]))
					'location_based_total_stock_amount#_location_based_total_stock_.STOCK_ID[sayac]#' = _location_based_total_stock_.TOTAL_LOCATION_STOCK[sayac];
				else
					'location_based_total_stock_amount#_location_based_total_stock_.STOCK_ID[sayac]#' = 0;	
			}
			for(sayac=1; sayac lte _PRODUCT_TOTAL_STOCK_.recordcount; sayac=sayac+1)//stock durumların için çektiğimiz quey'den gelen değerler set ediliyor
			{
				if(len(_PRODUCT_TOTAL_STOCK_.PRODUCT_STOCK[sayac]))
					'prod_stock_#_PRODUCT_TOTAL_STOCK_.STOCK_ID[sayac]#_#_PRODUCT_TOTAL_STOCK_.SPECT_VAR_ID[sayac]#' = _PRODUCT_TOTAL_STOCK_.PRODUCT_STOCK[sayac];
				else
					'prod_stock_#_PRODUCT_TOTAL_STOCK_.STOCK_ID[sayac]#_#_PRODUCT_TOTAL_STOCK_.SPECT_VAR_ID[sayac]#' = 0;	
			}
			if(isdefined('_PRODUCT_TOTAL_STOCK_2.recordcount'))
			{
				for(sayac=1; sayac lte _PRODUCT_TOTAL_STOCK_2.recordcount; sayac=sayac+1)//stock durumların için çektiğimiz quey'den gelen değerler set ediliyor
				{
					if(len(_PRODUCT_TOTAL_STOCK_2.PRODUCT_STOCK[sayac]))
						'prod_stock_2_#_PRODUCT_TOTAL_STOCK_2.STOCK_ID[sayac]#_#_PRODUCT_TOTAL_STOCK_2.SPECT_VAR_ID[sayac]#' = _PRODUCT_TOTAL_STOCK_2.PRODUCT_STOCK[sayac];
					else
						'prod_stock_2_#_PRODUCT_TOTAL_STOCK_2.STOCK_ID[sayac]#_#_PRODUCT_TOTAL_STOCK_2.SPECT_VAR_ID[sayac]#' = 0;	
				}
			}
			for(index=1; index lte _GET_STOCK_RESERVED_.recordcount; index=index+1)//Rezerve durumları için çektiğimiz quey'den gelen değerler set ediliyor
			{
				if(len(_GET_STOCK_RESERVED_.ARTAN[index]))
					'PRODUCT_ARTAN_#_GET_STOCK_RESERVED_.STOCK_ID[index]#_#_GET_STOCK_RESERVED_.SPECT_MAIN_ID[index]#' = _GET_STOCK_RESERVED_.ARTAN[index];
				else
					'PRODUCT_ARTAN_#_GET_STOCK_RESERVED_.STOCK_ID[index]#_#_GET_STOCK_RESERVED_.SPECT_MAIN_ID[index]#' = 0;
				if(len(_GET_STOCK_RESERVED_.AZALAN[index]))
					'PRODUCT_AZALAN_#_GET_STOCK_RESERVED_.STOCK_ID[index]#_#_GET_STOCK_RESERVED_.SPECT_MAIN_ID[index]#' = _GET_STOCK_RESERVED_.AZALAN[index];
				else
					'PRODUCT_AZALAN_#_GET_STOCK_RESERVED_.STOCK_ID[index]#_#_GET_STOCK_RESERVED_.SPECT_MAIN_ID[index]#' = 0;
			}
		</cfscript>
		<cfif listlen(stock_and_spect_list)><!--- Stock ve spect isimleri ise bildiğimzi lisletelem yöntemi ile yapılıyor. --->
			<cfset stock_id_lists_new = ''>
			<cfset spect_id_lists_new = ''>
			<cfloop list="#stock_and_spect_list#" index="jjj">
				<cfset stock_id_lists_new =  ListAppend(stock_id_lists_new,ListGetAt(ListFirst(jjj),1,'_'),',')>
				<cfif ListGetAt(ListFirst(jjj),2,'_') gt 0>
					<cfset spect_id_lists_new = ListAppend(spect_id_lists_new,ListGetAt(ListFirst(jjj),2,'_'),',')>
				</cfif>
			</cfloop>
			<cfset stock_id_lists_new = listsort(listdeleteduplicates(stock_id_lists_new),'numeric','ASC',',')>
			<cfset spect_id_lists_new = listsort(listdeleteduplicates(spect_id_lists_new),'numeric','ASC',',')>
			<cfquery name="get_stocks_name" datasource="#dsn3#">
				SELECT PRODUCT_NAME +'  '+ ISNULL(PROPERTY,'') AS PRODUCT_NAME,STOCK_ID,STOCK_CODE,MAIN_UNIT FROM STOCKS,PRODUCT_UNIT WHERE PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND STOCK_ID IN (#stock_id_lists_new#) ORDER BY STOCK_ID
			</cfquery>
			<cfset _stocks_name_list_ = listsort(listdeleteduplicates(valuelist(get_stocks_name.STOCK_ID,',')),'numeric','ASC',',')>
			<cfif listlen(spect_id_lists_new)>
				<cfquery name="get_spect_name" datasource="#dsn3#">
					SELECT SPECT_MAIN_NAME,SPECT_MAIN_ID FROM SPECT_MAIN WHERE SPECT_MAIN_ID IN (#spect_id_lists_new#) ORDER BY SPECT_MAIN_ID
				</cfquery>
				<cfset _spect_name_list_ = listsort(listdeleteduplicates(valuelist(get_spect_name.SPECT_MAIN_ID,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
		<!--- Bu kısım yazdırma kısmı --->
		<cfset kontrol_stock_amount = 1>
		<cfloop list="#stock_and_spect_list#" index="sss" delimiters=","><!--- stock ve spect id'ye göre gruplanan ürünlerin listesi döndürlmeye başlıyor. --->
			<!--- #sss# == stock_id,spect_id,is_production,is_purchase,stock_code,is_phantom,free_amount değerlerini tutan 7li bir liste--->
			<cfoutput>
            <cfif ListGetAt(sss,2,'_') gt 0><cfset _font_ = 'red'><cfelse><cfset _font_ = 'black'></cfif>
			<tr>
            	<td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#Evaluate('_product_id_#ListGetAt(sss,1,'_')#')#&sid=#ListGetAt(sss,1,'_')#" target="_blank">#get_stocks_name.STOCK_CODE[listfind(_stocks_name_list_,ListGetAt(sss,1,'_'),',')]#</a></td>
				<td>
					<!--- #ListGetAt(sss,1,'_')# === stock_id anlamına geliyor. --->
					<a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#ListGetAt(sss,1,'_')#','list');">
						<font color="#_font_#">#get_stocks_name.PRODUCT_NAME[listfind(_stocks_name_list_,ListGetAt(sss,1,'_'),',')]#</font>
					</a>
				</td>
				<td>
					<cfif ListGetAt(ListFirst(sss),2,'_') gt 0>
                        <!--- ListGetAt(ListFirst(sss),2,'_') SPECT_ID ANLAMINA GELİYOR. --->
                        <cfif isdefined('get_spect_name')>
                            <a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect_main&spect_main_id=#ListGetAt(sss,2,'_')#','list');">
                            #get_spect_name.SPECT_MAIN_NAME[listfind(_spect_name_list_,ListGetAt(sss,2,'_'),',')]#
                            </a>
                        </cfif>
                    </cfif>
				</td>
				<td>#get_stocks_name.MAIN_UNIT[listfind(_stocks_name_list_,ListGetAt(sss,1,'_'),',')]#</td>
				<cfif not isdefined("attributes.is_production")>
					<td class="text-right">
						<cfif isdefined('PRODUCT_AZALAN_#ListFirst(sss,'_')#')><cfset PRODUCT_REZERV =	Evaluate('PRODUCT_AZALAN_#ListFirst(sss,'_')#')><cfelse><cfset PRODUCT_REZERV =0></cfif>
						#tlformat(PRODUCT_REZERV)#<!--- AZALAN = REZERVE --->
					</td>
				</cfif>
                <cfset my_value = '#ListGetAt(sss,1,'_')#'><!--- stock_id --->
				<cfset my_value2 = '#ListGetAt(sss,1,'_')#_#ListGetAt(sss,2,'_')#'><!--- stock_id_spec_id --->
                <cfset is_free_amount = '#ListGetAt(sss,7,'_')#'><!--- miktardan bağımsız --->
                <cfif isdefined('prod_stock_#my_value2#')><cfset GERCEK_STOK = Evaluate('prod_stock_#my_value2#')><cfelse><cfset GERCEK_STOK = 0></cfif>
				<cfset eksik_stok = wrk_round(Evaluate("real_product_spect_total_amount_#my_value2#"),8,1)>
                <cfif eksik_stok gt 0><cfset eksik_stok_font ='red'><cfelse><cfset eksik_stok_font ='black'></cfif>
                <td nowrap class="text-right">
					<cfif isdefined("product_spect_total_amount_#my_value2#")>
						<cfif is_free_amount eq 0>
							<cfset "product_spect_total_amount_#my_value2#" = wrk_round(Evaluate("product_spect_total_amount_#my_value2#")*attributes.this_production_amount,8,1)>
						</cfif>
                        <font color="#eksik_stok_font#">#tlformat(wrk_round(Evaluate("product_spect_total_amount_#my_value2#"),8,1),8)#</font><!--- ToplamBirimİhtiyaç --->
					</cfif>
				</td>
				<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),2)>
					<td class="text-right"><!--- gerçek stok --->
						#tlformat(wrk_round(GERCEK_STOK,8,1))#
					</td>
				</cfif>
				<cfif isdefined('stock_strategy#ListGetAt(sss,1,'_')#')><!--- Ürün için stok stratejisi var ise,bu değer 9,8,8 gibi bir ifade döndürür burda 1.minumumstok,2.tedarik süresi ve 3.Min.Sipariş Miktarı'nı ifade eder. --->
					<cfset _min_stock__ = ListGetAt(Evaluate('stock_strategy#ListGetAt(sss,1,'_')#'),1,',')>
					<cfset _provision_time__ = ListGetAt(Evaluate('stock_strategy#ListGetAt(sss,1,'_')#'),2,',')>
					<cfset _min_order_stock_value__ = ListGetAt(Evaluate('stock_strategy#ListGetAt(sss,1,'_')#'),3,',')>
				<cfelse>
					<cfset _min_stock__ = ''>
					<cfset _provision_time__ = 0>
					<cfset _min_order_stock_value__ = ''>                    
				</cfif> 
				<cfif not isdefined("attributes.is_production")>
					<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),2)>
						<td nowrap class="text-right">
							<cfif ListGetAt(sss,6,'_') eq 1 or ListGetAt(sss,2,'_') gt 0>
								<cfif eksik_stok gt 0>
									<font color="#eksik_stok_font#">#tlformat(eksik_stok)#</font>
								
								<cfelse>
									#tlformat(0)#
									
								</cfif>
							<cfelse>
								<cfif eksik_stok gt 0>
									<font color="#eksik_stok_font#">#tlformat(eksik_stok)#</font>
								
								<cfelse>
									#tlformat(0)#
									
								</cfif>
							</cfif>
						</td>
						<td nowrap class="text-right">
							<cfif ListGetAt(sss,6,'_') eq 1 or ListGetAt(sss,2,'_') gt 0>
								<cfif eksik_stok gt 0>
									<input type="radio" class="multi_check_#attributes.row_number#" id="_ic_taleb_gercek_#attributes.row_number#" name="ic_talep_#attributes.row_number#_#ListGetAt(sss,1,'_')#" value="#eksik_stok#" disabled>
								<cfelse>
									<input type="radio" class="multi_check_#attributes.row_number#" id="_ic_taleb_gercek_#attributes.row_number#" name="ic_talep_#attributes.row_number#_#ListGetAt(sss,1,'_')#" value="0" disabled>
								</cfif>
							<cfelse>
								<cfif eksik_stok gt 0>
									<input type="radio" class="multi_check_#attributes.row_number#" id="_ic_taleb_gercek_#attributes.row_number#" name="ic_talep_#attributes.row_number#_#ListGetAt(sss,1,'_')#" value="#eksik_stok#">
								<cfelse>
									<input type="radio" class="multi_check_#attributes.row_number#" id="_ic_taleb_gercek_#attributes.row_number#" name="ic_talep_#attributes.row_number#_#ListGetAt(sss,1,'_')#" value="0">
								</cfif>
							</cfif>
						</td>
					</cfif>
						<cfset ss_eksik_stok = Evaluate("saleable_product_spect_total_amount_#my_value2#")>
                   
					<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),3)>
						<td class="text-right"><!--- satılabilir stok --->
							#tlformat(Evaluate('saleable_product_stock_#my_value2#'))#
						</td>
						<td nowrap class="text-right">
							<cfif ListGetAt(sss,6,'_') eq 1 or ListGetAt(sss,2,'_') gt 0>
								<cfif ss_eksik_stok gt 0>
									<font color="red">#tlformat(ss_eksik_stok)#</font>
								<cfelse>
									#tlformat(0)#
								</cfif>
							<cfelse>
								<cfif ss_eksik_stok gt 0>
									<font color="red">#tlformat(ss_eksik_stok)#</font>
								<cfelse>
									#tlformat(0)#
								</cfif>
							</cfif>
						</td>
						<td nowrap class="text-right">
							<cfif ListGetAt(sss,6,'_') eq 1 or ListGetAt(sss,2,'_') gt 0>
								<cfif ss_eksik_stok gt 0>
									<input type="radio" class="multi_check_#attributes.row_number#" id="_ic_taleb_#attributes.row_number#" name="ic_talep_#attributes.row_number#_#ListGetAt(sss,1,'_')#" value="#ss_eksik_stok#" disabled>
								<cfelse>
									<input type="radio" class="multi_check_#attributes.row_number#" id="_ic_taleb_#attributes.row_number#" name="ic_talep_#attributes.row_number#_#ListGetAt(sss,1,'_')#" value="0" disabled>    
								</cfif>
							<cfelse>
								<cfif ss_eksik_stok gt 0>
									<input type="radio" class="multi_uncheck_#attributes.row_number#" id="_ic_taleb_#attributes.row_number#" name="ic_talep_#attributes.row_number#_#ListGetAt(sss,1,'_')#" value="#ss_eksik_stok#" checked>
								<cfelse>
									<input type="radio" class="multi_uncheck_#attributes.row_number#" id="_ic_taleb_#attributes.row_number#" name="ic_talep_#attributes.row_number#_#ListGetAt(sss,1,'_')#" value="0" checked>    
								</cfif>
							</cfif>
						</td>
					</cfif>
					<td nowrap class="text-right">
						<cfif Evaluate("product_spect_total_amount_#my_value2#") gt 0>
							<cfset uretim_oran =(((Evaluate("product_spect_total_amount_#my_value2#")-eksik_stok)*100)/Evaluate("product_spect_total_amount_#my_value2#"))>
							<cfif uretim_oran gte 100>
								%100
							<cfelseif uretim_oran gt 0>
								%#tlformat(uretim_oran)#
							<cfelse>
								%0    
							</cfif>
						<cfelse>
							%0
						</cfif>
					</td>
                    <cfif isdefined('is_prod_real_stock') and is_prod_real_stock eq 1>
						<cfif isdefined('prod_stock_2_#my_value2#')><cfset UE_GERCEK_STOK = Evaluate('prod_stock_2_#my_value2#')><cfelse><cfset UE_GERCEK_STOK = 0></cfif>
                    	<td class="text-right">
							<cfif isdefined("product_spect_total_amount_#my_value2#")>
                                <cfif is_free_amount eq 0>
                                    <cfset "product_spect_total_amount_#my_value2#" = wrk_round(Evaluate("product_spect_total_amount_#my_value2#")*attributes.this_production_amount,8,1)>
                                </cfif>
                                <cfset last_ue_gercek_stok = UE_GERCEK_STOK - wrk_round(Evaluate("product_spect_total_amount_#my_value2#"),8,1)><!--- ToplamBirimİhtiyaç --->
                            <cfelse>
                            	<cfset last_ue_gercek_stok = UE_GERCEK_STOK>
                            </cfif>
                        	<cfif UE_GERCEK_STOK lt 0 or last_ue_gercek_stok lt 0>
                            	<font color="red">#TLFormat(wrk_round(UE_GERCEK_STOK,8,1))#</font>
                            <cfelse>
                                #TLFormat(wrk_round(UE_GERCEK_STOK,8,1))#
                            </cfif>
                        </td>
                    </cfif>
					<td class="text-right">#tlformat(_min_stock__,3)#</td>
					<td class="text-right">
					#tlformat(_min_order_stock_value__,3)#
					<div style="margin-left:-500;height:200px;position:absolute;overflow:auto;" id="show_rezerved_orders_detail#attributes.row_number#_#ListGetAt(sss,1,'_')#"></div>
					</td>
					<td class="text-right">
						<a style="cursor:pointer;" onClick="show_rezerved_orders_detail_sarf(#attributes.row_number#,#ListGetAt(sss,1,'_')#);">
						<cfif isdefined('PRODUCT_ARTAN_#ListGetAt(sss,1,'_')#_#ListGetAt(sss,2,'_')#')>#tlformat(Evaluate('PRODUCT_ARTAN_#ListGetAt(sss,1,'_')#_#ListGetAt(sss,2,'_')#'))#<cfelse>#tlformat(0)#</cfif>
						</a>
					</td>
				</cfif>
				<cfif ListGetAt(sss,2,'_') gt 0>
					<cfif  is_show_stock_type2 eq 3>
						<cfset kontrol_stock_amount = ss_eksik_stok>
					<cfelse>
						<cfset kontrol_stock_amount = eksik_stok>
					</cfif>
				<cfelse>
					<cfset kontrol_stock_amount = 1>
				</cfif>
                <td id="max_provision_time_#ListGetAt(sss,1,'_')#" class="text-right" alt="<cf_get_lang dictionary_id='32705.En Uzun Tedarik Süresi'>">
                    <font color="#eksik_stok_font#">
                    	<cfif eksik_stok_font is 'red' and _provision_time__ gt max_provision_time><!--- Eğerki Eksik Stok Varsa Eksik Stoklar Arasından En Geç Tedarik Edilenin Boyutunu biraz büyük göstericez. --->
							<cfset max_provision_time = _provision_time__>
							<cfset max_provision_time_sid = ListGetAt(sss,1,'_') >
						</cfif>
                    	#DateFormat(date_add('d',_provision_time__,now()),dateformat_style)#
                    </font>
                </td>
			</tr>
			</cfoutput>
		</cfloop>
        <cfif isdefined('max_provision_time_sid')>
			<script type="text/javascript">
                tedarik_suresini_belirt(<cfoutput>'#max_provision_time_sid#'</cfoutput>);
            </script>
        </cfif>
	</cfif>
    </tbody>
   
</cf_grid_list>
	<cfif not isdefined("attributes.is_production")>
		<div class="ui-info-bottom flex-end">
			<a class="ui-btn ui-btn-success" href="javascript://" onClick="ic_taleb_olustur<cfoutput>#attributes.row_number#</cfoutput>();"><cf_get_lang dictionary_id='51120.İç Talep Oluştur'></a>
		</div>
	</cfif>
	<script type="text/javascript">
		function check_all(row_num,is_check){
			var check_len= $(".multi_check_"+row_num).length;
			if(is_check== 0) {
				for(var cl_ind=0; cl_ind < check_len; cl_ind++)
					{
						if($(".multi_check_"+row_num)[cl_ind].disabled != true)
						$(".multi_check_"+row_num)[cl_ind].checked = true;
					}
					
				}
			else if (is_check== 1){
				for(var cl_ind=0; cl_ind < check_len; cl_ind++)
					{
						if($(".multi_uncheck_"+row_num)[cl_ind].disabled != true)
						$(".multi_uncheck_"+row_num)[cl_ind].checked = true;
					}
					
			}
				
		}
	<cfoutput>
		function ic_taleb_olustur#attributes.row_number#()
		{
			<cfif isdefined('stock_and_spect_list')>
				var uzunluk=#listlen(stock_and_spect_list,',')#;
			<cfelse>
				var uzunluk=0;
			</cfif>
			<cfif isdefined("attributes.p_order_no") and len(attributes.p_order_no)>
				var p_order_no_ = '#attributes.p_order_no#';
			<cfelse>
				var p_order_no_ = '';
			</cfif>
			var stock_id_list ='';
			var amount_list='';
			<cfif isdefined("is_zero_amount_kontrol") and is_zero_amount_kontrol eq 1>
				for(it=0;it<uzunluk;it++)
				{
					<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),3)>
						if(document.all._ic_taleb_#attributes.row_number#[it] != undefined){
							if(document.all._ic_taleb_#attributes.row_number#[it].checked==true){ //Satırlarda yer alan ihtiyaçlardan hangisi seçili ise(Eksik Stok ve SS Eksik Stok )
								if(document.all._ic_taleb_#attributes.row_number#[it].value == 0)
									document.all._ic_taleb_#attributes.row_number#[it].value = 1;
								amount_list+=document.all._ic_taleb_#attributes.row_number#[it].value+',';
								stock_id_list+=list_getat(document.all._ic_taleb_#attributes.row_number#[it].name,4,'_')+',';//radio butonun ismi ic_taleb_586 gibi bir değer olduğundna 3.cü sıradaki değer ürünün stock_id'aini tutuyor..
							}
						}
						else{
							if(document.all._ic_taleb_#attributes.row_number#.checked==true){ //Satırlarda yer alan ihtiyaçlardan hangisi seçili ise(Eksik Stok ve SS Eksik Stok )
								if(document.all._ic_taleb_#attributes.row_number#.value == 0)
									document.all._ic_taleb_#attributes.row_number#.value = 1;
								amount_list+=document.all._ic_taleb_#attributes.row_number#.value+',';
								stock_id_list+=list_getat(document.all._ic_taleb_#attributes.row_number#.name,4,'_')+',';//radio butonun ismi ic_taleb_586 gibi bir değer olduğundna 3.cü sıradaki değer ürünün stock_id'aini tutuyor..
							}
						}
						
					</cfif>
					<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),2)>
						if(document.all._ic_taleb_#attributes.row_number#[it] != undefined){
							if(document.all._ic_taleb_gercek_#attributes.row_number#[it].checked==true){ //Satırlarda yer alan ihtiyaçlardan hangisi seçili ise(Eksik Stok ve SS Eksik Stok )
								if(document.all._ic_taleb_gercek_#attributes.row_number#[it].value == 0)
									document.all._ic_taleb_gercek_#attributes.row_number#[it].value = 1;
								amount_list+=document.all._ic_taleb_gercek_#attributes.row_number#[it].value+',';
								stock_id_list+=list_getat(document.all._ic_taleb_gercek_#attributes.row_number#[it].name,4,'_')+',';//radio butonun ismi ic_taleb_586 gibi bir değer olduğundna 3.cü sıradaki değer ürünün stock_id'aini tutuyor..
							}
						}
						else{
							
							if(document.all._ic_taleb_gercek_#attributes.row_number#.checked==true){ //Satırlarda yer alan ihtiyaçlardan hangisi seçili ise(Eksik Stok ve SS Eksik Stok )
								if(document.all._ic_taleb_gercek_#attributes.row_number#.value == 0)
									document.all._ic_taleb_gercek_#attributes.row_number#.value = 1;
								amount_list+=document.all._ic_taleb_gercek_#attributes.row_number#.value+',';
								stock_id_list+=list_getat(document.all._ic_taleb_gercek_#attributes.row_number#.name,4,'_')+',';//radio butonun ismi ic_taleb_586 gibi bir değer olduğundna 3.cü sıradaki değer ürünün stock_id'aini tutuyor..
							}
						}
					</cfif>
				}
			<cfelse>
				for(it=0;it<uzunluk;it++)
				{
				<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),3)>
					if(document.all._ic_taleb_#attributes.row_number#[it] != undefined){
						if(document.all._ic_taleb_#attributes.row_number#[it].checked==true && document.all._ic_taleb_#attributes.row_number#[it].value > 0){ //Satırlarda yer alan ihtiyaçlardan hangisi seçili ise(Eksik Stok ve SS Eksik Stok )
							amount_list+=document.all._ic_taleb_#attributes.row_number#[it].value+',';
							stock_id_list+=list_getat(document.all._ic_taleb_#attributes.row_number#[it].name,4,'_')+',';//radio butonun ismi ic_taleb_586 gibi bir değer olduğundna 3.cü sıradaki değer ürünün stock_id'aini tutuyor..
						}
					}
					else{
							if(document.all._ic_taleb_#attributes.row_number#.checked==true && document.all._ic_taleb_#attributes.row_number#.value > 0){ //Satırlarda yer alan ihtiyaçlardan hangisi seçili ise(Eksik Stok ve SS Eksik Stok )
							amount_list+=document.all._ic_taleb_#attributes.row_number#.value+',';
							stock_id_list+=list_getat(document.all._ic_taleb_#attributes.row_number#.name,4,'_')+',';//radio butonun ismi ic_taleb_586 gibi bir değer olduğundna 3.cü sıradaki değer ürünün stock_id'aini tutuyor..
						}
					}
				</cfif>
				<cfif  ListFind(ListDeleteDuplicates(is_show_stock_type),2)>
					if(document.all._ic_taleb_#attributes.row_number#[it] != undefined){
						if(document.all._ic_taleb_gercek_#attributes.row_number#[it].checked==true && document.all._ic_taleb_gercek_#attributes.row_number#[it].value > 0){ //Satırlarda yer alan ihtiyaçlardan hangisi seçili ise(Eksik Stok ve SS Eksik Stok )
							amount_list+=document.all._ic_taleb_gercek_#attributes.row_number#[it].value+',';
							stock_id_list+=list_getat(document.all._ic_taleb_gercek_#attributes.row_number#[it].name,4,'_')+',';//radio butonun ismi ic_taleb_586 gibi bir değer olduğundna 3.cü sıradaki değer ürünün stock_id'aini tutuyor..
						}
					}
					else{
						if(document.all._ic_taleb_gercek_#attributes.row_number#.checked==true && document.all._ic_taleb_gercek_#attributes.row_number#.value > 0){ //Satırlarda yer alan ihtiyaçlardan hangisi seçili ise(Eksik Stok ve SS Eksik Stok )
							amount_list+=document.all._ic_taleb_gercek_#attributes.row_number#.value+',';
							stock_id_list+=list_getat(document.all._ic_taleb_gercek_#attributes.row_number#.name,4,'_')+',';//radio butonun ismi ic_taleb_586 gibi bir değer olduğundna 3.cü sıradaki değer ürünün stock_id'aini tutuyor..
						}
					}
				</cfif>
				}
			</cfif>
			//amount_list = amount_list.substr(0,amount_list.length-1);
			if(stock_id_list)	
				window.open('#request.self#?fuseaction=purchase.list_internaldemand&event=add&NUMBER_OF_INSTALLMENT=&CATALOG_ID&price_cat=&list_price=&type=convert&convert_amount_stocks_id='+amount_list+'&convert_stocks_id='+stock_id_list+'&ref_no='+p_order_no_+'','project');
			else
				alert("<cf_get_lang dictionary_id='40069.Lütfen Ürün Seçiniz'>!");
		}
		//Benzer bir fonksiyon satış siparişlerinde de var ancak bu sayfa bir çok yerden çağırıldığı için eğerki orda yoksa diye burda başka bir isim ile yeniden oluşturuyoruz..
		function show_rezerved_orders_detail_sarf(row_id,stock_id)
		{
			document.getElementById('show_rezerved_orders_detail'+row_id+'_'+stock_id+'').style.display='';
			AjaxPageLoad('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&sid='+stock_id+'&row_id='+row_id+'_'+stock_id+'','show_rezerved_orders_detail'+row_id+'_'+stock_id+'',1);
		}
		</cfoutput>
    </script>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
