<cfsetting showdebugoutput="no">
<cfset _new_deep_level_main_stock_id_0 = attributes._deep_level_main_stock_id_0>
<cfset _deep_level_main_stock_id_0 = attributes._deep_level_main_stock_id_0>
<cfset _deep_level_main_product_id_0 = attributes._deep_level_main_product_id_0>
<cfset _deep_level_main_product_name_0 = attributes._deep_level_main_product_name_0>
<cfset main_spec_id_0 = attributes.main_spec_id_0>
<cfif isDefined('session.ep.userid')>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session_base.company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
<cfelseif isDefined('session.pp.userid')>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session.pp.our_company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
<cfelse>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session.ww.our_company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
</cfif>

<cfset wrk_id_tree = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_#_deep_level_main_stock_id_0#_'&round(rand()*100)>

<cfif isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)><!--- Main Spec Güncelleme Sayfası ise sadece spec_main üzerinde özel kod ve isim güncellemeleri yaptırıcaz... --->
	<cfquery name="UPD_MAIN_SPECT" datasource="#new_dsn3#">
		UPDATE
			SPECT_MAIN
		SET
        	IS_LIMITED_STOCK = <cfif isdefined('attributes.is_limited_stock')>1<cfelse>0</cfif>, 
			SPECT_STATUS = <cfif isdefined('attributes.spect_status')>1<cfelse>0</cfif>,
            SPECT_MAIN_NAME = '#wrk_eval("attributes.SPEC_NAME")#',
			SPECIAL_CODE_1 = <cfif isdefined('attributes.special_code_1') and len(attributes.special_code_1)>'#attributes.special_code_1#'<cfelse>NULL</cfif>,
			SPECIAL_CODE_2 = <cfif isdefined('attributes.special_code_2') and len(attributes.special_code_2)>'#attributes.special_code_2#'<cfelse>NULL</cfif>,
			SPECIAL_CODE_3 = <cfif isdefined('attributes.special_code_3') and len(attributes.special_code_3)>'#attributes.special_code_3#'<cfelse>NULL</cfif>,
			SPECIAL_CODE_4 = <cfif isdefined('attributes.special_code_4') and len(attributes.special_code_4)>'#attributes.special_code_4#'<cfelse>NULL</cfif>
		WHERE
			SPECT_MAIN_ID = #attributes.MAIN_SPEC_ID_0#
            
        UPDATE
			SPECTS
		SET
        	IS_LIMITED_STOCK = <cfif isdefined('attributes.is_limited_stock')>1<cfelse>0</cfif>, 
            SPECT_VAR_NAME = '#wrk_eval("attributes.SPEC_NAME")#',
			SPECIAL_CODE_1 = <cfif isdefined('attributes.special_code_1') and len(attributes.special_code_1)>'#attributes.special_code_1#'<cfelse>NULL</cfif>,
			SPECIAL_CODE_2 = <cfif isdefined('attributes.special_code_2') and len(attributes.special_code_2)>'#attributes.special_code_2#'<cfelse>NULL</cfif>,
			SPECIAL_CODE_3 = <cfif isdefined('attributes.special_code_3') and len(attributes.special_code_3)>'#attributes.special_code_3#'<cfelse>NULL</cfif>,
			SPECIAL_CODE_4 = <cfif isdefined('attributes.special_code_4') and len(attributes.special_code_4)>'#attributes.special_code_4#'<cfelse>NULL</cfif>
		WHERE
			SPECT_MAIN_ID = #attributes.MAIN_SPEC_ID_0#
	</cfquery>
    <script type="text/javascript">
    	this.close();
    </script>
<cfelse>
	<cfif isdefined('attributes.special_code_1') and len(attributes.special_code_1)><cfset special_code_1 = attributes.special_code_1><cfelse><cfset special_code_1 = ''></cfif>
	<cfif isdefined('attributes.special_code_2') and len(attributes.special_code_2)><cfset special_code_2 = attributes.special_code_2><cfelse><cfset special_code_2 = ''></cfif>
	<cfif isdefined('attributes.special_code_3') and len(attributes.special_code_3)><cfset special_code_3 = attributes.special_code_3><cfelse><cfset special_code_3 = ''></cfif>
	<cfif isdefined('attributes.special_code_4') and len(attributes.special_code_4)><cfset special_code_4 = attributes.special_code_4><cfelse><cfset special_code_4 = ''></cfif>
    <cfparam name="attributes.is_update" default="0"><!--- ekleme yafa güncelleme sayfası hiç farketmez sadece ana ürün için spect_var_id oluşturulacağı için ilk başta is_update her zaman 0 dır.. --->
    <cfparam name="attributes.spec_id" default=""><!--- ekleme yafa güncelleme sayfası hiç farketmez sadece ana ürün için spect_var_id oluşturulacağı için ilk başta spec_id her zaman boştur... --->
    <cfif len(main_spec_id_0)>
		<cfscript>
			deep_level = 0;
			main_product_special_spec_name='';
			//bu alttaki 3 deger seçilen alternatiflerden ana ürünün fiyatının ne kadar artacağını belirliyor...
			main_prod_price_extra = 0;
			main_prod_price_kdv_extra = 0;
			spec_total_value_extra =0;
			spec_other_total_value_extra =0;
			spec_main_id_list='';
			spec_main_id_list2='';
			main_stock_id_list='';
			old_spec_main_id_list='';
			spec_main_name_list='';
			all_spec_main_id_list='';
			question_no_list='';
			question_name_list='';
			usage_rate_list='';
			question_detail_list='';
			process_stage = attributes.process_stage?:"";
			employee_id = (isdefined('attributes.employee_id') and isDefined("attributes.employee_name") and len(attributes.employee_name)) ? attributes.employee_id : "";
			save_date = attributes.save_date?:"";	
			SQLStrRow="
				SELECT
					ISNULL(QUESTION_NO,0) QUESTION_NO,
					REPLACE(QUESTION_DETAIL,',','.') QUESTION_DETAIL,
					REPLACE(QUESTION_NAME,',','.') QUESTION_NAME
				FROM
					SETUP_ALTERNATIVE_QUESTIONS
				ORDER BY
					QUESTION_NO
			";
			query1Row = cfquery(SQLString : SQLStrRow, Datasource : dsn);

			for (str_i=1; str_i lte query1Row.recordcount; str_i = str_i+1)
			{
				question_no_list=listappend(question_no_list,query1Row.QUESTION_NO[str_i]);
				if(isDefined('session.pp.userid') and session.pp.language neq 'tr')
				{
					SQLStrRowLangDet2="
						SELECT 
							UNIQUE_COLUMN_ID,
							ITEM 
						FROM 
							SETUP_LANGUAGE_INFO 
						WHERE 
							TABLE_NAME = 'SETUP_ALTERNATIVE_QUESTIONS' AND 
							COLUMN_NAME = 'QUESTION_DETAIL' AND
							LANGUAGE = '#session.pp.language#' AND
							UNIQUE_COLUMN_ID = #query1Row.QUESTION_NO[str_i]#
					";
					query2Rows = cfquery(SQLString : SQLStrRowLangDet2, Datasource : dsn);	
					SQLStrRowLangDet3="
						SELECT 
							UNIQUE_COLUMN_ID,
							ITEM 
						FROM 
							SETUP_LANGUAGE_INFO 
						WHERE 
							TABLE_NAME = 'SETUP_ALTERNATIVE_QUESTIONS' AND 
							COLUMN_NAME = 'QUESTION_NAME' AND
							LANGUAGE = '#session.pp.language#' AND
							UNIQUE_COLUMN_ID = #str_i#
					";
					query3Rows = cfquery(SQLString : SQLStrRowLangDet3, Datasource : dsn);	
					if(query2Rows.recordcount)
						"name_#query1Row.QUESTION_NO[str_i]#" = query2Rows.ITEM;
					else
						"name_#query1Row.QUESTION_NO[str_i]#" = query1Row.QUESTION_DETAIL[str_i];
					if(query3Rows.recordcount)
						"detail_#query1Row.QUESTION_NO[str_i]#" = query3Rows.ITEM; 
					else
						"detail_#query1Row.QUESTION_NO[str_i]#" = query1Row.QUESTION_NAME[str_i]; 
				}
				else
				{ 
					"name_#query1Row.QUESTION_NO[str_i]#" = query1Row.QUESTION_DETAIL[str_i];					
					"detail_#query1Row.QUESTION_NO[str_i]#" = query1Row.QUESTION_NAME[str_i];
				}
			}
			question_no_list = listsort(question_no_list,'numeric','ASC',',');
			for (str_i=1; str_i lte listlen(question_no_list); str_i = str_i+1)
			{
				question_name_list=listappend(question_name_list,evaluate("name_#query1Row.QUESTION_NO[str_i]#"),';');
				question_detail_list=listappend(question_detail_list,evaluate("detail_#query1Row.QUESTION_NO[str_i]#"),';');
			}
			if (isdefined('attributes.is_limited_stock')) is_limited_stock = 1; else is_limited_stock = 0;
			 function get_subs(product_tree_id,next_stock_id,type)
			{
				if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #product_tree_id#';
				SQLStr="
						SELECT
							*
						FROM
						(
							SELECT
								0 SPECT_MAIN_ID,
								PT.PRODUCT_TREE_ID RELATED_ID,
								0 AS STOCK_ID,
								1 AS AMOUNT,
								OP.OPERATION_TYPE AS PRODUCT_NAME,
								ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
								OP.OPERATION_TYPE_ID,
								PT.PRODUCT_TREE_ID PRODUCT_TREE_ID,
								ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
								0 AS PRODUCT_ID,
								0 STOCK_RELATED_ID,
								0 IS_PROPERTY,
								ISNULL(PT.IS_PHANTOM,0) IS_PHANTOM
							FROM 
								OPERATION_TYPES OP,
								PRODUCT_TREE PT
							WHERE 
								OP.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID AND
								#where_parameter#
							UNION ALL
							SELECT
								ISNULL(PT.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
								PT.PRODUCT_TREE_ID RELATED_ID,
								ISNULL(S.STOCK_ID,0) STOCK_ID,
								ISNULL(PT.AMOUNT,0) AMOUNT,
								S.PRODUCT_NAME,
								ISNULL(PT.LINE_NUMBER,0) AS LINE_NUMBER,
								0 AS OPERATION_TYPE_ID,
								PT.PRODUCT_TREE_ID PRODUCT_TREE_ID,
								ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
								ISNULL(PT.PRODUCT_ID,0) AS PRODUCT_ID,
								ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID,
								0 IS_PROPERTY,
								ISNULL(PT.IS_PHANTOM,0) IS_PHANTOM
							FROM 
								STOCKS S,
								PRODUCT_TREE PT
							WHERE 
								S.STOCK_ID = PT.RELATED_ID AND
								#where_parameter#
						)T1
						ORDER BY
							STOCK_ID DESC,
							LINE_NUMBER
					";
				query1 = cfquery(SQLString : SQLStr, Datasource : new_dsn3);
				stock_id_ary='';
				for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
				{
					stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
					stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_NAME[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_TREE_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.IS_PROPERTY[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.LINE_NUMBER[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.STOCK_RELATED_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
					stock_id_ary=listappend(stock_id_ary,query1.IS_PHANTOM[str_i],'§');
				}
				return stock_id_ary;
			}
			function GetDeepLevelMaınStockId(_deeplevel){
				for (lind_ = _deeplevel-1;lind_ gte 0; lind_ = lind_-1){
					if(isdefined('_new_deep_level_main_stock_id_#lind_#') and len(Evaluate('_new_deep_level_main_stock_id_#lind_#')) and Evaluate('_new_deep_level_main_stock_id_#lind_#') gt 0)
						return Evaluate('_new_deep_level_main_stock_id_#lind_#');
				}
				return 1;
			}
			function GetDeepLevelMaınStockId2(_deeplevel){
				for (lind_ = _deeplevel-1;lind_ gte 0; lind_ = lind_-1){
					if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')))
						return Evaluate('_deep_level_main_stock_id_#lind_#');
				}
				return 1;
			}
			row_count = 0;
			function writeTree(next_spect_main_id,next_stock_id,type,nex_spect_main_id_)
			{
				var new_i = 1;
				var sub_products = get_subs(next_spect_main_id,next_stock_id,type);
				
				'main_stock_id#deep_level#'=next_stock_id;
				'main_product_id#deep_level#'= Evaluate('_deep_level_main_product_id_#deep_level#');
				'spec_name#deep_level#' = '#Evaluate('_deep_level_main_product_name_#deep_level#')#';
				
				deep_level = deep_level + 1;
				for (new_i=1; new_i lte listlen(sub_products,'█'); new_i = new_i+1)
				{
					leftSpace = RepeatString('&nbsp;', deep_level*5);
					_next_spect_main_id_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
					_next_stock_id_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),2,'§');
					_next_product_name_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),3,'§');
					_next_product_name_ = replace(_next_product_name_,',','','all');
					_next_product_name_ = replace(_next_product_name_,'/','','all');
					_next_product_name_ = replace(_next_product_name_,':','','all');
					_next_stock_amount_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),4,'§');
					_new_tree_id_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),5,'§');
					_next_operation_type_id_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),6,'§');
					_next_question_id_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),7,'§');
					_next_product_id_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),8,'§');
					_next_is_property_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),9,'§');
					_next_is_line_number_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),10,'§');
					_next_related_tree_id_ = ListGetAt(ListGetAt(sub_products,new_i,'█'),11,'§');
					_n_stock_related_id_= ListGetAt(ListGetAt(sub_products,new_i,'█'),12,'§');
					_n_spect_main_id_= ListGetAt(ListGetAt(sub_products,new_i,'█'),13,'§');
					_next_spect_main_id_row_= ListGetAt(ListGetAt(sub_products,new_i,'█'),13,'§');
					_next_is_phantom_= ListGetAt(ListGetAt(sub_products,new_i,'█'),14,'§');
					_new_deep_level_ = GetDeepLevelMaınStockId(deep_level);
					kontrol_alternative = 0;
					if(isdefined('attributes.alternative_products_#_new_deep_level_#_#_next_question_id_#') and len(Evaluate('attributes.alternative_products_#_new_deep_level_#_#_next_question_id_#'))){
						if(listlen(Evaluate('attributes.alternative_products_#_new_deep_level_#_#_next_question_id_#'),',') neq 1)
							'attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#' = listgetat(Evaluate('attributes.alternative_products_#_new_deep_level_#_#_next_question_id_#'),1,',');
						else
							'attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#' = Evaluate('attributes.alternative_products_#_new_deep_level_#_#_next_question_id_#');
						_next_stock_id_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),1,'█');
						_next_product_name_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),2,'█');
						_next_special_code_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),3,'█');
						_usage_rate_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),4,'█');
						_next_product_id_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),5,'█');
						_next_short_question_name_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),6,'█');
						_next_spect_main_id_row_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),7,'█');
						_next_use_amount_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),8,'█');
						_next_phantom_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),9,'█');
						_next_main_stock_id_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),10,'█');
						_next_main_product_id_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),11,'█');
						_next_main_product_name_  = ListGetAt(Evaluate('attributes.new_alternative_products_#_new_deep_level_#_#_next_question_id_#'),12,'█');
						if(_next_phantom_ eq 1)
						{
							_next_product_id_ = _next_main_product_id_;
							_next_stock_id_ = _next_main_stock_id_;
							_next_product_name_ = _next_main_product_name_;
						}
						main_prod_price_extra = main_prod_price_extra+(attributes.main_prod_price*_usage_rate_)/100;
						usage_rate_list = ListAppend(usage_rate_list,_usage_rate_);
						main_prod_price_kdv_extra= main_prod_price_kdv_extra+(attributes.main_prod_price_kdv*_usage_rate_)/100;
						spec_total_value_extra = spec_total_value_extra+(attributes.toplam_miktar*_usage_rate_)/100;
						spec_other_total_value_extra = spec_other_total_value_extra+(attributes.other_toplam*_usage_rate_)/100;
						new_name = '#_next_short_question_name_#:#_next_special_code_#';
						if(not isdefined("main_product_special_spec_name_#_new_deep_level_#"))
							"main_product_special_spec_name_#_new_deep_level_#"='#new_name#/';
						else
							"main_product_special_spec_name_#_new_deep_level_#"='#evaluate("main_product_special_spec_name_#_new_deep_level_#")##new_name#/';
						kontrol_alternative = 1;	
						if(not isdefined("related_spect_main_id_list_#_new_deep_level_#"))
							'related_spect_main_id_list_#_new_deep_level_#'= _next_spect_main_id_row_;
						else
							'related_spect_main_id_list_#_new_deep_level_#'= ListAppend(Evaluate('related_spect_main_id_list_#_new_deep_level_#'),_next_spect_main_id_row_,',');
						if(_next_use_amount_ neq 0) _next_stock_amount_=_next_use_amount_;
					}
					if(_next_spect_main_id_ gt 0)  
					{
						if(isdefined("stock_id_list_#_new_deep_level_#"))
						{
							'row_count_#_new_deep_level_#' = evaluate("row_count_#_new_deep_level_#")+ 1;
							'stock_id_list_#_new_deep_level_#' = ListAppend(evaluate("stock_id_list_#_new_deep_level_#"),_next_stock_id_,',');
							'product_id_list_#_new_deep_level_#'=ListAppend(Evaluate('product_id_list_#_new_deep_level_#'),_next_product_id_,',');
							'related_tree_id_list_#_new_deep_level_#'=ListAppend(Evaluate('related_tree_id_list_#_new_deep_level_#'),_next_related_tree_id_,',');
							'operation_type_id_list_#_new_deep_level_#'=ListAppend(Evaluate('operation_type_id_list_#_new_deep_level_#'),_next_operation_type_id_,',');
							'product_name_list_#_new_deep_level_#'=ListAppend(Evaluate('product_name_list_#_new_deep_level_#'),_next_product_name_,'@');
							'amount_list_#_new_deep_level_#'=ListAppend(Evaluate('amount_list_#_new_deep_level_#'),_next_stock_amount_,',');
							'sevk_list_#_new_deep_level_#'=ListAppend(Evaluate('sevk_list_#_new_deep_level_#'),0,',');
							'configure_list_#_new_deep_level_#'=ListAppend(Evaluate('configure_list_#_new_deep_level_#'),1,',');
							if(deep_level eq 1)
							{
								if(_next_stock_id_ gt 0)
									'is_property_list_#_new_deep_level_#'=ListAppend(Evaluate('is_property_list_#_new_deep_level_#'),0,',');//sarf
								else
									'is_property_list_#_new_deep_level_#'=ListAppend(Evaluate('is_property_list_#_new_deep_level_#'),3,',');//operasyon..
							}
							else
							{
								if(_next_stock_id_ gt 0)
								{
									if(GetDeepLevelMaınStockId2(deep_level) lt 0)//operasyona bağlı ise
										'is_property_list_#_new_deep_level_#'=ListAppend(Evaluate('is_property_list_#_new_deep_level_#'),4,',');//operasyon altından gelen ürünler anlamına geliyor...
									else
										'is_property_list_#_new_deep_level_#'=ListAppend(Evaluate('is_property_list_#_new_deep_level_#'),0,',');//sarf
								}
								else
									'is_property_list_#_new_deep_level_#'=ListAppend(Evaluate('is_property_list_#_new_deep_level_#'),3,',');//operasyon..
							}
							'property_id_list_#_new_deep_level_#' = ListAppend(Evaluate('property_id_list_#_new_deep_level_#'),0,',');
							'variation_id_list_#_new_deep_level_#' =ListAppend(Evaluate('variation_id_list_#_new_deep_level_#'),0,',');
							'total_min_list_#_new_deep_level_#' = ListAppend(Evaluate('total_min_list_#_new_deep_level_#'),'-',',');
							'total_max_list_#_new_deep_level_#' = ListAppend(Evaluate('total_max_list_#_new_deep_level_#'),'-',',');
							'tolerance_list_#_new_deep_level_#' = ListAppend(Evaluate('tolerance_list_#_new_deep_level_#'),'-',',');
							'line_number_list_#_new_deep_level_#' =ListAppend(Evaluate('line_number_list_#_new_deep_level_#'),_next_is_line_number_,',');
							'is_phantom_list_#_new_deep_level_#' =ListAppend(Evaluate('is_phantom_list_#_new_deep_level_#'),_next_is_phantom_,',');
							if(kontrol_alternative eq 0)
								'related_spect_main_id_list_#_new_deep_level_#'= ListAppend(Evaluate('related_spect_main_id_list_#_new_deep_level_#'),_next_spect_main_id_row_,',');
							'question_id_list_#_new_deep_level_#' = ListAppend(Evaluate('question_id_list_#_new_deep_level_#'),_next_question_id_,',');
						}
						else
						{
							'row_count_#_new_deep_level_#' = 1;
							'stock_id_list_#_new_deep_level_#' = _next_stock_id_;
							'product_id_list_#_new_deep_level_#'= _next_product_id_;
							'related_tree_id_list_#_new_deep_level_#'= _next_related_tree_id_;
							'operation_type_id_list_#_new_deep_level_#'= _next_operation_type_id_;
							'product_name_list_#_new_deep_level_#'=_next_product_name_;
							'amount_list_#_new_deep_level_#'=_next_stock_amount_;
							'sevk_list_#_new_deep_level_#'=0;
							'configure_list_#_new_deep_level_#'=1;
							if(deep_level eq 1)
							{
								if(_next_stock_id_ gt 0)
									'is_property_list_#_new_deep_level_#'=0;//sarf
								else
									'is_property_list_#_new_deep_level_#'=3;//operasyon..
							}
							else
							{
								if(_next_stock_id_ gt 0)
								{
									if(GetDeepLevelMaınStockId2(deep_level) lt 0)//operasyona bağlı ise
										'is_property_list_#_new_deep_level_#'=4;//operasyon altından gelen ürünler anlamına geliyor...
									else
										'is_property_list_#_new_deep_level_#'=0;//sarf
								}
								else
									'is_property_list_#_new_deep_level_#'=3;//operasyon..
							}
							'property_id_list_#_new_deep_level_#' = 0;
							'variation_id_list_#_new_deep_level_#' = 0;
							'total_min_list_#_new_deep_level_#' = '-';
							'total_max_list_#_new_deep_level_#' = '-';
							'tolerance_list_#_new_deep_level_#' = '-';
							'line_number_list_#_new_deep_level_#' =_next_is_line_number_;
							'is_phantom_list_#_new_deep_level_#' =_next_is_phantom_;
							if(kontrol_alternative eq 0)
								'related_spect_main_id_list_#_new_deep_level_#'= 0;
							'question_id_list_#_new_deep_level_#' = _next_question_id_;
						}
						'main_spec_id_#deep_level#' = _next_spect_main_id_;
						'_deep_level_main_stock_id_#deep_level#' = _next_stock_id_;
						'_deep_level_main_product_id_#deep_level#' = _next_product_id_;
						'_deep_level_main_product_name_#deep_level#'=_next_product_name_;
					}
					'_new_deep_level_main_stock_id_#deep_level#' = _next_stock_id_;
					/* if(_next_operation_type_id_ gt 0) */ type_=3;/* else type_=0; */
					writeTree(_new_tree_id_,_n_stock_related_id_,type_,_n_spect_main_id_);
				 }
				deep_level = deep_level-1;
	
				if(deep_level gt 0){
					only_main_spec= 0;
					main_prod_price = 0;
					main_product_money = 'TL';
					spec_total_value = 0;
					spec_other_total_value = 0;
					money_list="";
					money_rate1_list="";
					money_rate2_list="";
				}
				else{
					only_main_spec= 0;
					main_prod_price = attributes.main_prod_price+main_prod_price_extra;
					main_product_money = attributes.main_product_money;
					spec_total_value = attributes.toplam_miktar+spec_total_value_extra;
					spec_other_total_value = attributes.other_toplam+spec_other_total_value_extra;
					if(isdefined('attributes.is_update') and attributes.is_update eq 1)
						attributes.is_update=1;
					else 
					{
						attributes.is_update='';
						attributes.spec_id='';
					}
					money_list="";
					money_rate1_list="";
					money_rate2_list="";
					if(isdefined("attributes.rd_money_num") and attributes.rd_money_num gt 0)
					{
						for(i=1;i lte attributes.rd_money_num;i=i+1)
						{
							money_list = listappend(money_list,evaluate("attributes.rd_money_name_#i#"),',');
							money_rate1_list = listappend(money_rate1_list,evaluate("attributes.txt_rate1_#i#"),',');
							money_rate2_list = listappend(money_rate2_list,evaluate("attributes.txt_rate2_#i#"),',');
						}
					}
				}
				if(nex_spect_main_id_ gt 0)
				{				
					new_stock_id = Evaluate('main_stock_id#deep_level#');
					main_stock_id_list = listappend(main_stock_id_list,new_stock_id,',');
					diff_price_list = RepeatString('0,',Evaluate('row_count_#new_stock_id#'));
					
					new_spect_name = '';
					for(new_indx = 1;new_indx lte listlen(Evaluate('stock_id_list_#new_stock_id#'),',');new_indx = new_indx + 1)
					{
						row_stock_id = listgetat(Evaluate('stock_id_list_#new_stock_id#'),new_indx,',');
						if(isdefined("main_product_special_spec_name_#row_stock_id#") and len(evaluate("main_product_special_spec_name_#row_stock_id#")))
							new_spect_name = "#new_spect_name##evaluate("main_product_special_spec_name_#row_stock_id#")#";
					}
					
					if(isdefined("main_product_special_spec_name_#new_stock_id#") and len(evaluate("main_product_special_spec_name_#new_stock_id#")))
					{
						spec_name = "#new_spect_name##Left(evaluate("main_product_special_spec_name_#new_stock_id#"),(len(evaluate("main_product_special_spec_name_#new_stock_id#"))-1))#";
						"main_product_special_spec_name_#new_stock_id#"='#spec_name#/';
					}
					else if(len(new_spect_name))
					{
						spec_name =new_spect_name;
						"main_product_special_spec_name_#new_stock_id#"='#spec_name#';
					}
					else
						spec_name =Evaluate('spec_name#deep_level#');
					last_name = spec_name;				
					new_name_last = '';
					if(listlen(spec_name,'/') gt 1)
					{
						for(name_indx=1;name_indx lte listlen(spec_name,'/');name_indx=name_indx+1)
						{
							row_name_2 = "#listgetat(spec_name,name_indx,'/')#";
							row_name_ = "#listfirst(listgetat(spec_name,name_indx,'/'),':')#";
							row_name_indx = listfind(question_detail_list,row_name_,';');
							row_detail = listgetat(question_detail_list,row_name_indx,';');
							row_no = listgetat(question_no_list,row_name_indx,',');
							row_name = listgetat(question_name_list,row_name_indx,';');
							row_name_2 = replace(row_name_2,row_detail,row_name);
							'd_#row_no#' = row_name_2;
						}
						if(listlen(question_no_list,','))
							for(name_indx=1;name_indx lte listlen(question_no_list,',');name_indx=name_indx+1)
							{
								row_no_ = listgetat(question_no_list,name_indx);
								if(isdefined("d_#row_no_#") and len(evaluate("d_#row_no_#")))
								{
									new_name_last = "#new_name_last##evaluate("d_#row_no_#")#/";
								}
							}
						else
							new_name_last = spec_name;					
					}
					else
					{
						if(listlen(spec_name,':') gt 1)
						{
							row_name_ = listfirst(spec_name,':');
							row_name_indx = listfind(question_detail_list,row_name_,';');
							if(row_name_indx neq 0)
							{
								row_name = listgetat(question_name_list,row_name_indx,';');
								row_detail = listgetat(question_detail_list,row_name_indx,';');
								spec_name = replace(spec_name,row_detail,row_name);
							}
						}
						new_name_last = spec_name;
					}
					//writeoutput("first_name:#Evaluate('main_stock_id#deep_level#')#___#new_name_last#<br/>");
					
					spec_name = new_name_last;
					new_spect_name_info = '';
					for(name_indx = 1 ; name_indx lte listlen(spec_name,'/');name_indx= name_indx + 1)
					{
						if(not new_spect_name_info contains "/#listgetat(spec_name,name_indx,'/')#/")
							new_spect_name_info  = "#new_spect_name_info##listgetat(spec_name,name_indx,'/')#/";
					}
					spec_name = new_spect_name_info;
					if(right(spec_name,1) is '/')
						spec_name = Left(spec_name,(len(spec_name)-1));
					//writeoutput("last_name:#Evaluate('main_stock_id#deep_level#')#___#spec_name#<br/>");
					
					if(listfind(old_spec_main_id_list,nex_spect_main_id_,','))
						is_product_tree_import = 1;
					else
						is_product_tree_import = '';
					
					if(Evaluate('main_stock_id#deep_level#') eq _deep_level_main_stock_id_0)
					{
						special_code_1_= special_code_1;
						special_code_2_ = special_code_2;
						special_code_3_ = special_code_3;
						special_code_4_ = special_code_4;
					}
					else
					{
						special_code_1_= '';
						special_code_2_ = '';
						special_code_3_ = '';
						special_code_4_ = '';
					}
					for(name_indx=1;name_indx lte listlen(spec_name,'/');name_indx=name_indx+1)
					{
						row_name_2 = "#listgetat(spec_name,name_indx,'/')#";
						row_name_ = "#listfirst(listgetat(spec_name,name_indx,'/'),':')#";
						row_name_indx = listfind(question_name_list,row_name_,';');
						if(row_name_indx gt 0)
						{
							row_no = listgetat(question_no_list,row_name_indx,',');
							'd_#row_no#' = '';
						}
					}
					
					specer_return_value_list=specer(
						dsn_type: dsn3,
						spec_type: 1,
						is_control_spect_name :1,
						is_control_tree :0,
						is_product_tree_import:is_product_tree_import,
						insert_spec : iif(len(attributes.is_update),0,1),
						spec_id : iif(len(attributes.is_update),de('#attributes.spec_id#'),de('')),
						only_main_spec: only_main_spec,
						main_prod_price:main_prod_price,
						main_product_money:main_product_money,
						diff_price_list:diff_price_list,
						spec_total_value : spec_total_value,
						money_list : money_list,
						money_rate1_list : money_rate1_list,
						money_rate2_list : money_rate2_list,
						spec_other_total_value : spec_other_total_value,
						other_money : attributes.other_money,
						main_stock_id: Evaluate('main_stock_id#deep_level#'),
						main_product_id: Evaluate('main_product_id#deep_level#'),
						spec_name:spec_name,
						spec_row_count: Evaluate('row_count_#new_stock_id#'),
						stock_id_list: Evaluate('stock_id_list_#new_stock_id#'),
						product_id_list: Evaluate('product_id_list_#new_stock_id#'),
						product_name_list: Evaluate('product_name_list_#new_stock_id#'),
						amount_list: Evaluate('amount_list_#new_stock_id#'),
						is_sevk_list: Evaluate('sevk_list_#new_stock_id#'),
						is_configure_list: Evaluate('configure_list_#new_stock_id#'),
						is_property_list: Evaluate('is_property_list_#new_stock_id#'),
						property_id_list: Evaluate('property_id_list_#new_stock_id#'),
						variation_id_list: Evaluate('variation_id_list_#new_stock_id#'),
						total_min_list: Evaluate('total_min_list_#new_stock_id#'),
						total_max_list : Evaluate('total_max_list_#new_stock_id#'),
						tolerance_list : Evaluate('tolerance_list_#new_stock_id#'),
						related_spect_id_list : Evaluate('related_spect_main_id_list_#new_stock_id#'),
						line_number_list :  Evaluate('line_number_list_#new_stock_id#'),
						related_tree_id_list : Evaluate('related_tree_id_list_#new_stock_id#'),
						operation_type_id_list: Evaluate('operation_type_id_list_#new_stock_id#'),
						question_id_list: Evaluate('question_id_list_#new_stock_id#'),
						is_limited_stock : is_limited_stock,
						is_phantom_list : Evaluate('is_phantom_list_#new_stock_id#'),
						special_code_1 : special_code_1_,special_code_2 : special_code_2_,special_code_3 : special_code_3_,special_code_4 : special_code_4_,
						is_add_same_name_spect : attributes.is_add_same_name_spect,
						process_stage : process_stage,
						employee_id : employee_id,
						save_date : save_date
					);
					new_cre_main_spec_id =ListGetAt(specer_return_value_list,1,',');//yeni bir main spec oluştu...
						//writeoutput("#Evaluate('main_stock_id#deep_level#')#____#new_cre_main_spec_id#<br/>");
					is_new_spect =ListGetAt(specer_return_value_list,11,',');//yeni bir main spec oluştu...
					if(isdefined("last_spect_id"))
					{
						"spect_value_#last_spect_id#" = new_cre_main_spec_id;			
					}
					last_spect_id = new_cre_main_spec_id;
					if(is_new_spect eq 1)
						spec_main_id_list = ListAppend(spec_main_id_list,new_cre_main_spec_id);
					else
						spec_main_id_list2 = ListAppend(spec_main_id_list2,new_cre_main_spec_id);
					spec_main_name_list = ListAppend(spec_main_name_list,'#ListGetAt(specer_return_value_list,3,',')#');
					all_spec_main_id_list = ListAppend(all_spec_main_id_list,new_cre_main_spec_id);
					old_spec_main_id_list = ListAppend(old_spec_main_id_list,nex_spect_main_id_);
					if(isdefined("related_spect_main_id_list_#GetDeepLevelMaınStockId(deep_level)#"))
					{
						'related_spect_main_id_list_#GetDeepLevelMaınStockId(deep_level)#'= ListSetAt(Evaluate('related_spect_main_id_list_#GetDeepLevelMaınStockId(deep_level)#'),ListLen(Evaluate('related_spect_main_id_list_#GetDeepLevelMaınStockId(deep_level)#'),','),new_cre_main_spec_id,',');
				   }
					if(deep_level eq 0)
					{//sadece ana ürün için spect_var_id oluşur...
						new_cre_main_spec_id =ListGetAt(specer_return_value_list,1,',');
						new_cre_spec_var_id =ListGetAt(specer_return_value_list,2,',');
						new_spect_var_name = listgetat(specer_return_value_list,3,',');
					}
				}
			}
			writeTree(main_spec_id_0,_deep_level_main_stock_id_0,0,main_spec_id_0);
		</cfscript>
		<cfquery name="DEL_ROWS" datasource="#DSN3#">
			DELETE FROM TEMP_PRODUCT_TREE WHERE WRK_ID_TREE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id_tree#"> AND MAIN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_deep_level_main_stock_id_0#">
		</cfquery>
		<cfif isdefined('new_cre_spec_var_id') and not isdefined("is_from_webservice")>
			<cfif isdefined('new_cre_spec_var_id')>
				<cfif isdefined('attributes.is_partner')>
					<cfif isDefined('attributes.spect_var_id') and len(attributes.spect_var_id)>
						<cfquery name="GET_ALTERNATIVE_PRODUCT" datasource="#DSN3#">
							SELECT 
								SPECT_MAIN.SPECT_MAIN_NAME
							FROM 
								SPECTS SP,
								SPECT_MAIN
							WHERE 
								SP.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID AND
								SP.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_var_id#">
						</cfquery>
					</cfif>
					<script type="text/javascript">
						<cfoutput>
							<cfif isDefined('attributes.spect_var_id') and len(attributes.spect_var_id)>
								window.opener.document.getElementById('spec_var_id_'+#attributes.row_id#).value = '#attributes.spect_var_id#';
								window.opener.document.getElementById('spec_var_name_'+#attributes.row_id#).value = '#get_alternative_product.spect_main_name#';				
							<cfelse>
								window.opener.document.getElementById('spec_var_id_'+#attributes.row_id#).value = '#listgetat(specer_return_value_list,2,',')#';
								window.opener.document.getElementById('spec_var_name_'+#attributes.row_id#).value = '#new_spect_var_name#';
							</cfif>
							window.opener.document.getElementById('diff_rate_values_'+#attributes.row_id#).value = '#usage_rate_list#';
							window.opener.document.getElementById('price_'+#attributes.row_id#).value =<cfif listgetat(specer_return_value_list,5,',') gt 0>#listgetat(specer_return_value_list,5,',')#<cfelse>0</cfif>;
							window.opener.document.getElementById('price_kdv_'+#attributes.row_id#).value =<cfif listgetat(specer_return_value_list,5,',') gt 0>#attributes.main_prod_price_kdv+main_prod_price_kdv_extra#<cfelse>0</cfif>;
							window.opener.document.getElementById('price_money_'+#attributes.row_id#).value='<cfif len(listgetat(specer_return_value_list,6,','))>#listgetat(specer_return_value_list,6,',')#<cfelse>#session_base.money#</cfif>';
							new_spect_id = '#listgetat(specer_return_value_list,2,',')#';
							var get_spect_product = wrk_safe_query("obj_get_spect_product","dsn3",0,new_spect_id);
							if(get_spect_product.STOCK_ID != window.opener.document.getElementById('sid_'+#attributes.row_id#).value)
								control_submit_info = 0;
							else
								control_submit_info = 1;
							window.opener.urun_gonder('#attributes.row_id#','0','0',control_submit_info);
							this.close();
						</cfoutput>
					</script>
				<cfelseif isdefined("attributes.is_from_prod_order") and attributes.is_from_prod_order eq 1> <!--- çalışılıyor silmeyiniz --->
					<script type="text/javascript">
						<cfoutput>
							<cfif isdefined('specer_return_value_list') and len(specer_return_value_list)>
								opener.document.getElementById('spec_var_id').value = '#listgetat(specer_return_value_list,2,',')#';
								opener.document.getElementById('spect_var_name').value = '#new_spect_var_name#';
								opener.document.getElementById('spect_main_id').value = '#listgetat(specer_return_value_list,1,',')#';
								this.close();
							</cfif>
						</cfoutput>
					</script>
				<cfelse>
					<cfinclude template="../form/add_spec_js.cfm">
				</cfif>
			</cfif>
		</cfif>
    <cfelse>
        Ürüne Ait Bir Spec Kaydedilmemiş!
    </cfif>
</cfif>
<cfif not isdefined("is_from_webservice")>
	<script type="text/javascript">
		<cfif isdefined('attributes.add_main_spect')>
			<cflocation url="#request.self#?fuseaction=objects.popup_upd_spect&upd_main_spect=1&spect_main_id=#listgetat(specer_return_value_list,1,',')#" addtoken="no">
		<cfelse>
			<cfif isDefined("attributes.draggable") and isDefined("attributes.modal_id")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>')<cfelse>window.close()</cfif>;
		</cfif>	
	</script>
</cfif>

