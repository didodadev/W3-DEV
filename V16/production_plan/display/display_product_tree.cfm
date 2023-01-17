<cfparam name="attributes.is_stock_info_display" default="0">
<cfsetting showdebugoutput="no">
<!--- bu case diyelimki üretilen bir ürüne spect seçilmedi sipariş spectsiz olarak üretime geldi bu aşamada 
ürünün is_tree yani ağaçtan oluşturulmuş son main_spect_id'sini alıcaz,eğer adam hiç spect oluşturmamış ise 
bu sefer  ürünün ağacından bir spect oluşturucaz bu 2 işlemi  --->
<cfif (isdefined('attributes.SPECT_VAR_ID') and not len(attributes.SPECT_VAR_ID)) or (isdefined('attributes.spect_main_id') and not len(attributes.spect_main_id) )>
	<cfinclude template="../../workdata/get_main_spect_id.cfm">
	<cfset _new_main_spec_id_ = get_main_spect_id(attributes.stock_id)>
    <cfset attributes.spect_main_id = _new_main_spec_id_.SPECT_MAIN_ID>
</cfif>
<cfset scrap_location = ''>
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
<cfif get_scrap_locations.recordcount>
	<cfsavecontent variable="scrap_location">
		<cfoutput>
			<cfloop query="get_scrap_locations">
				AND NOT ( STORE_LOCATION = #LOCATION_ID# AND STORE = #DEPARTMENT_ID#)
			</cfloop>
		</cfoutput>
	</cfsavecontent>
</cfif>
<cfif isdefined('attributes.is_product_station_relation') and attributes.is_product_station_relation eq 0><!--- Eğerki XML ayarlarından İStasyon Ürün ilişkisi kullanma seçilmiş ise tüm istasyonları gelicek her seferinde. --->
    <cfquery name="GET_ALL_STATIONS" datasource="#dsn3#">
        SELECT
        	-1 AS WS_P_ID,
        	0 AS PRODUCTION_TYPE,
            0 AS MIN_PRODUCT_AMOUNT,
            0 AS SETUP_TIME,
        	STATION_ID,
            STATION_NAME,
            ISNULL(EXIT_DEP_ID,0) AS EXIT_DEP_ID,
			ISNULL(EXIT_LOC_ID,0) AS EXIT_LOC_ID,
			ISNULL(PRODUCTION_DEP_ID,0) AS PRODUCTION_DEP_ID,
			ISNULL(PRODUCTION_LOC_ID,0) AS PRODUCTION_LOC_ID
		FROM 
        	WORKSTATIONS
		WHERE 
       		ACTIVE = 1
		ORDER BY
			STATION_NAME
    </cfquery>
</cfif>
<cfset production_row_count = 0>
<cfform name="add_production_ordel_all" action="#request.self#?fuseaction=prod.emptypopup_add_production_ordel_all" method="post">
	<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		<cf_box title="#getLang('prod',52)#">
			<cf_grid_list>
				<thead>
					<cfset colspan_info = 8>
					<cfif ListFind(ListDeleteDuplicates(xml_show_production_type),1)>
						<cfset colspan_info = colspan_info + 1>
					</cfif>
					<cfif  attributes.is_stock_info_display eq 1>
						<cfif ListFind(ListDeleteDuplicates(xml_show_production_type),2)>
							<cfset colspan_info = colspan_info + 2>
						</cfif>
						<cfif ListFind(ListDeleteDuplicates(xml_show_production_type),3)>
							<cfset colspan_info = colspan_info + 2>
						</cfif>
						<cfif attributes.is_select_min_stock eq 1>
							<cfset colspan_info = colspan_info + 1>
						</cfif>
						<cfset colspan_info = colspan_info + 1>
					</cfif>		             
					<tr height="20" class="color-list">
						<th class="txtbold" width="200"><cf_get_lang dictionary_id='57518.Stok Kodu'>-<cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th class="txtbold" width="60"><cf_get_lang dictionary_id='57647.Spec'></th>
						<th width="50" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						<cfif  ListFind(ListDeleteDuplicates(xml_show_production_type),1)>
							<th width="50" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57636.Birim'><cf_get_lang dictionary_id='36437.İhtiyaç'></th>
						</cfif>
						<cfif  attributes.is_stock_info_display eq 1>
							<cfif ListFind(ListDeleteDuplicates(xml_show_production_type),2)>
								<th width="50" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
								<th width="55" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58120.Gerçek Stok'> <cf_get_lang dictionary_id='36437.İhtiyaç'></th>
							</cfif>
							<cfif ListFind(ListDeleteDuplicates(xml_show_production_type),3)>
								<th width="50" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='36857.Satılabilir Stok'></th>
								<th width="55" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='36857.Satılabilir Stok'> <cf_get_lang dictionary_id='36437.İhtiyaç'></th>
							</cfif>
							<cfif attributes.is_select_min_stock eq 1>
								<th width="55" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='36601.Min Stok'></th>
							</cfif>
							<th width="50" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='36800.Verilen ÜE'></th>
						</cfif>
						<th width="50" align="right" class="txtbold" style="text-align:right;"><cfif attributes.is_stock_info_display eq 1><cf_get_lang dictionary_id='36801.Kalan ÜE'><cfelse><cf_get_lang dictionary_id ='36858.Verilecek Üretim emri'></cfif></th>
						<th class="txtbold" width="150"><cf_get_lang dictionary_id='58834.İstasyon'></th>
						<th width="20"></th>
						<th width="20" align="center">&nbsp;</th>
						<th style="text-align:center;" title="<cf_get_lang dictionary_id ='36859.Hepsini Seç'>" width="20"><input type="checkbox" title="<cf_get_lang dictionary_id ='36859.Hepsini Seç'>" onClick="all_select();" <cfif isdefined("attributes.is_select_sub_product") and attributes.is_select_sub_product eq 1>checked</cfif>></th>	
					</tr>
				</thead>
				<cfif not isdefined('attributes.spect_main_id')>
					<cfquery name="get_spect_main_id" datasource="#dsn3#">
						SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_var_id#">
					</cfquery>
					<cfif get_spect_main_id.recordcount>
						<cfset attributes.spect_main_id = get_spect_main_id.SPECT_MAIN_ID>
					<cfelse>
						<cfset attributes.spect_main_id = 0>
					</cfif>
				</cfif>
				<cfif (isdefined('attributes.spect_var_id') and not len(attributes.spect_var_id)) or not isdefined("attributes.spect_var_id")>
					<cfset attributes.spect_var_id = 0>
				</cfif>
				<!---Değerler sırası ile = stock_id,spect_var_id(sadece ana üründe spect_var id aşağıda ise spect_main_id),miktar,deep_level(oluşturulacak olan rota haritasında işimiz görecek.) --->
				<cfoutput>
					<input type="hidden" name="product_amount_2" id="product_amount_2" value="#tlformat(attributes.order_amount2,0)#">
					<input type="hidden" name="product_unit_2" id="product_unit_2" value="#attributes.unit2#">
					<input type="hidden" name="product_amount_1_0" id="product_amount_1_0" value="#tlformat(attributes.order_amount,8)#">
					<input type="hidden" name="product_values_1_0" id="product_values_1_0" value="#attributes.stock_id#,#attributes.spect_var_id#,0,0,#attributes.spect_main_id#"><!--- Ana Ürün olduğu için  product_values_0 değerini veriyoruz--->
				</cfoutput>
				<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
					<cfset stock_id_list = ''>
					<cfset spect_id_list = ''>
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
								spect_id_list = listappend(spect_id_list,spect_main_id,',');
								if(_next_spect_id_ gt 0)
									writeTree2(_next_spect_id_);//writeoutput(spect_main_id&'sssss<br/>'&spect_id_list);
								}
						}
						writeTree2(attributes.spect_main_id);
					</cfscript>
					<cfif listlen(stock_id_list)>
						<cfquery name="get_stock_all_1" datasource="#dsn2#">
							SELECT
								SUM(PRODUCT_STOCK) PRODUCT_STOCK,
								SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
								PRODUCT_ID,
								STOCK_ID
							FROM
							(
									SELECT
										(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
										0 AS RESERVED_STOCK,
										SR.PRODUCT_ID, 
										SR.STOCK_ID
									FROM			
										#dsn#.STOCKS_LOCATION SL,
										STOCKS_ROW SR WITH (NOLOCK)
									WHERE			
										SR.STORE =SL.DEPARTMENT_ID
										AND SR.STORE_LOCATION=SL.LOCATION_ID
										AND SL.NO_SALE = 0
										AND SR.STOCK_ID IN (#stock_id_list#)
									UNION ALL
									SELECT
										-1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
										0 AS RESERVED_STOCK,
										SR.PRODUCT_ID, 
										SR.STOCK_ID
									FROM
										STOCKS_ROW SR WITH (NOLOCK)
										,#dsn#.STOCKS_LOCATION SL 
									WHERE	
										SR.STORE = SL.DEPARTMENT_ID AND
										SR.STORE_LOCATION = SL.LOCATION_ID AND
										ISNULL(SL.IS_SCRAP,0)=1	
										AND SR.STOCK_ID IN (#stock_id_list#)
								<cfif ListFind(ListDeleteDuplicates(xml_show_production_type),3)>
									UNION ALL
									SELECT
										0 AS PRODUCT_STOCK,
										((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1)  AS RESERVED_STOCK,
										ORR.PRODUCT_ID, 
										ORR.STOCK_ID
									FROM
										#dsn3#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
										
										, 
										#dsn3#.ORDERS ORDS WITH (NOLOCK)
									WHERE
										ORDS.RESERVED = 1 AND 
										ORDS.ORDER_STATUS = 1 AND	
										ORR.ORDER_ID = ORDS.ORDER_ID AND
										((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)	
										AND ORR.STOCK_ID IN (#stock_id_list#)
									UNION ALL
									SELECT
										0 AS PRODUCT_STOCK,
										(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
										ORR.PRODUCT_ID, 
										ORR.STOCK_ID
									FROM
										#dsn#.STOCKS_LOCATION SL,
										#dsn3#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
										
										, 
										#dsn3#.ORDERS ORDS WITH (NOLOCK)
									WHERE
										ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
										ORDS.LOCATION_ID=SL.LOCATION_ID AND
										SL.NO_SALE = 0 AND
										ORDS.PURCHASE_SALES=0 AND
										ORDS.ORDER_ZONE=0 AND	
										ORDS.RESERVED = 1 AND 
										ORDS.ORDER_STATUS = 1 AND	
										ORR.ORDER_ID = ORDS.ORDER_ID AND
										(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
										AND ORR.STOCK_ID IN (#stock_id_list#)
									UNION ALL
									SELECT
										0 AS PRODUCT_STOCK,
										(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
										GRS.PRODUCT_ID, 
										GRS.STOCK_ID
									FROM
										#dsn3#.GET_PRODUCTION_RESERVED_SPECT GRS WITH (NOLOCK)
									WHERE 
										GRS.STOCK_ID IN (#stock_id_list#)
								</cfif>
					
							) T1
							GROUP BY
								PRODUCT_ID, 
								STOCK_ID
						</cfquery>
						<cfquery name="get_stock_all_2" datasource="#dsn2#">
							SELECT
								SUM(PRODUCT_STOCK) PRODUCT_STOCK,
								SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
								PRODUCT_ID,
								STOCK_ID
							FROM
							(
								SELECT
									(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
									0 AS RESERVED_STOCK,
									SR.PRODUCT_ID, 
									SR.STOCK_ID
								FROM			
									#DSN_ALIAS#.STOCKS_LOCATION SL,
									STOCKS_ROW SR WITH (NOLOCK)
								WHERE			
									SR.STORE =SL.DEPARTMENT_ID
									AND SR.STORE_LOCATION=SL.LOCATION_ID
									AND SL.NO_SALE = 0
									AND SR.SPECT_VAR_ID IN (#spect_id_list#)
							UNION ALL
								SELECT
									-1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
									0 AS RESERVED_STOCK,
									SR.PRODUCT_ID, 
									SR.STOCK_ID
								FROM
									STOCKS_ROW SR WITH (NOLOCK)
									,
									#DSN_ALIAS#.STOCKS_LOCATION SL  
								WHERE	
									SR.STORE = SL.DEPARTMENT_ID AND
									SR.STORE_LOCATION = SL.LOCATION_ID AND
									ISNULL(SL.IS_SCRAP,0)=1	
									AND SR.SPECT_VAR_ID IN (#spect_id_list#)
								UNION ALL
								SELECT
									0 AS PRODUCT_STOCK,
									((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1)  AS RESERVED_STOCK,
									ORR.PRODUCT_ID, 
									ORR.STOCK_ID
								FROM
									#DSN3_ALIAS#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK),
									#DSN3_ALIAS#.ORDERS ORDS WITH (NOLOCK)
								WHERE
									ORDS.RESERVED = 1 AND 
									ORDS.ORDER_STATUS = 1 AND	
									ORR.ORDER_ID = ORDS.ORDER_ID AND
									((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)	
									AND ORR.SPECT_VAR_ID IN (#spect_id_list#)
							UNION ALL
								SELECT
									0 AS PRODUCT_STOCK,
									(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
									ORR.PRODUCT_ID, 
									ORR.STOCK_ID
								FROM
									#DSN_ALIAS#.STOCKS_LOCATION SL,
									#DSN3_ALIAS#.GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
									, 
									#DSN3_ALIAS#.ORDERS ORDS WITH (NOLOCK)
								WHERE
									ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
									ORDS.LOCATION_ID=SL.LOCATION_ID AND
									SL.NO_SALE = 0 AND
									ORDS.PURCHASE_SALES=0 AND
									ORDS.ORDER_ZONE=0 AND	
									ORDS.RESERVED = 1 AND 
									ORDS.ORDER_STATUS = 1 AND	
									ORR.ORDER_ID = ORDS.ORDER_ID AND
									(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
									AND ORR.SPECT_VAR_ID IN (#spect_id_list#)
							UNION ALL
								SELECT
									0 AS PRODUCT_STOCK,
									(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
									GRS.PRODUCT_ID, 
									GRS.STOCK_ID
								FROM
									#DSN3_ALIAS#.GET_PRODUCTION_RESERVED_SPECT GRS WITH (NOLOCK)
								WHERE
									GRS.SPECT_MAIN_ID IN (#spect_id_list#)
								
							) T1
							GROUP BY
								PRODUCT_ID, 
								STOCK_ID
						</cfquery>
						<cfquery name="get_stock_all"  dbtype="query">
							SELECT * FROM get_stock_all_1
							UNION ALL
							SELECT * FROM get_stock_all_2
						</cfquery>
						<cfoutput query="get_stock_all">
							<cfset "product_stock_#stock_id#" = get_stock_all.product_stock>
							<cfset "saleable_stock_#stock_id#" = get_stock_all.saleable_stock>
						</cfoutput>
						<cfif attributes.is_add_scrap_amount eq 0>
							<cfquery name="get_real_stock" datasource="#dsn2#">
								SELECT
									ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) AS PRODUCT_STOCK,
									STOCK_ID
								FROM
									STOCKS_ROW SR
								WHERE
									SR.STOCK_ID IN (#stock_id_list#)
									#scrap_location#
								GROUP BY
									STOCK_ID
							</cfquery>
							<cfoutput query="get_real_stock">
								<cfset "product_stock_#stock_id#" = get_real_stock.product_stock>
							</cfoutput>
						</cfif>
					</cfif>
					<cfscript>
						class0='color-row';
						class1='color-list';//hayalet ürün ağacı ise class'ı farklı göster.
						stations_list = '';
						if (isdefined('attributes.is_product_station_relation') and attributes.is_product_station_relation eq 0)
						{
							for(i=1;  i lte GET_ALL_STATIONS.RECORDCOUNT; i=i+1)
								stations_list = '#stations_list#<option value="#GET_ALL_STATIONS.STATION_ID[i]#,#GET_ALL_STATIONS.PRODUCTION_TYPE[i]#,#GET_ALL_STATIONS.MIN_PRODUCT_AMOUNT[i]#,#GET_ALL_STATIONS.SETUP_TIME[i]#,#GET_ALL_STATIONS.WS_P_ID[i]#,#GET_ALL_STATIONS.EXIT_DEP_ID[i]#,#GET_ALL_STATIONS.EXIT_LOC_ID[i]#,#GET_ALL_STATIONS.PRODUCTION_DEP_ID[i]#,#GET_ALL_STATIONS.PRODUCTION_LOC_ID[i]#">#GET_ALL_STATIONS.STATION_NAME[i]#</option>';
						}
						stock_and_spect_list ='';
						deep_level = 0;
						color1="black";color2="red";color3="brown";color4="orange";color5="pink";color6="purple";
						color7="blue";color8="darkblue";color9="gray";color10="silver";color11="silver";
						color12="silver";color13="silver";color14="silver";color15="silver";
						color16="silver";color17="silver";color18="silver";
						color19="silver";color20="silver";color21="silver";
						color22="silver";color23="silver";color24="silver";
						color25="silver";color26="silver";color27="silver";
						function get_subs(spect_main_id,production_tree_id,type)
						{
							if(isdefined('attributes.is_line_number') and attributes.is_line_number eq 1)
								order_by = "LINE_NUMBER";
							else
								order_by = "LINE_NUMBER,STOCK_ID DESC,PRODUCT_NAME";
		
							SQLStr = "
										SELECT * FROM
										(
											SELECT
													S.STOCK_CODE,
													ISNULL(S.IS_PURCHASE,0) IS_PURCHASE,
													ISNULL(S.IS_PRODUCTION,0)IS_PRODUCTION,
													ISNULL(SMR.RELATED_MAIN_SPECT_ID,0)AS RELATED_ID,
													SMR.STOCK_ID,
													SMR.AMOUNT,
													S.PRODUCT_NAME,
													S.PROPERTY,
													ISNULL(SMR.IS_PHANTOM,0) as IS_PHANTOM,
													SMR.LINE_NUMBER,
													0 AS OPERATION_TYPE_ID,
													ISNULL(RELATED_TREE_ID,0) AS RELATED_TREE_ID,
													ISNULL(SMR.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT
												FROM 
													SPECT_MAIN_ROW SMR,
													STOCKS S
												WHERE 
													S.STOCK_ID = SMR.STOCK_ID AND
													SPECT_MAIN_ID = #spect_main_id# AND 
													SMR.STOCK_ID IS NOT NULL AND
													IS_PROPERTY IN (0,4) --SADECE SARFLAR GELSİN
											UNION ALL
												SELECT 
													'&nbsp;' AS STOCK_CODE,
													0 AS IS_PURCHASE,
													0 AS IS_PRODUCTION,
													0 AS RELATED_ID,
													0 AS STOCK_ID,
													1 AS AMOUNT,
													'<font color=purple>'+OP.OPERATION_TYPE+'</font>'  AS PRODUCT_NAME,
													'' PROPERTY,
													ISNULL(SMR.IS_PHANTOM,0) AS IS_PHANTOM,
													SMR.LINE_NUMBER,
													ISNULL(OP.OPERATION_TYPE_ID,0) AS OPERATION_TYPE_ID,
													ISNULL(SMR.RELATED_TREE_ID,0) AS RELATED_TREE_ID,
													ISNULL(SMR.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT
												FROM 
													OPERATION_TYPES OP,
													SPECT_MAIN_ROW SMR
												WHERE
													OP.OPERATION_TYPE_ID = SMR.OPERATION_TYPE_ID AND 
													SPECT_MAIN_ID = #spect_main_id# AND 
													OP.OPERATION_TYPE_ID IS NOT NULL AND
													IS_PROPERTY IN(3,4) -- OPERASYONLAR GELSİN
										) TABLE_1
										ORDER BY
											#order_by#
									";
							query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
							stock_id_ary='';
							for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
							{
								stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
								stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
								stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_NAME[str_i],'§');
								stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
								stock_id_ary=listappend(stock_id_ary,query1.IS_PRODUCTION[str_i],'§');
								stock_id_ary=listappend(stock_id_ary,query1.IS_PURCHASE[str_i],'§');
								stock_id_ary=listappend(stock_id_ary,query1.STOCK_CODE[str_i],'§');
								stock_id_ary=listappend(stock_id_ary,query1.IS_PHANTOM[str_i],'§');
								stock_id_ary=listappend(stock_id_ary,query1.RELATED_TREE_ID[str_i],'§');
								stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
								if(len(query1.PROPERTY[str_i]))
									stock_id_ary=listappend(stock_id_ary,query1.PROPERTY[str_i],'§');
								else
									stock_id_ary=listappend(stock_id_ary,' ','§');
								stock_id_ary=listappend(stock_id_ary,query1.IS_FREE_AMOUNT[str_i],'§');
							}
							return stock_id_ary;
						}
						function writeRow(_next_spect_main_id_,_next_stock_id_,_next_product_name_,_next_stock_amount_,deep_level,_next_is_production_,_next_is_purchase_,_next_stock_code_,_next_is_phantom_,_next_related_tree_id_,_next_operation_type_id_,_next_property_,_n_free_amount_)	
						{
							//if(_next_is_inventory_ eq 0) tr_color = 'title="Operasyon" style="background-color:FFCC99"'; else 
							tr_color = '';
							if(deep_level eq 1)
							{
								if(_n_free_amount_  eq 0)
									'product_amount_#deep_level#' = wrk_round(attributes.order_amount*_next_stock_amount_,8,1);// satır bazında malzeme ihtiyaçları
								else
									'product_amount_#deep_level#' = wrk_round(_next_stock_amount_,8,1);
							}
							else if(len(_next_stock_amount_))
								'product_amount_#deep_level#' =  wrk_round(Evaluate('product_amount_#deep_level-1#')*_next_stock_amount_,8,1);
							else
								'product_amount_#deep_level#' = wrk_round(Evaluate('product_amount_#deep_level-1#'),8,1);
							if(not isdefined('product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#'))//genel anlamda malzeme ihtiyaçları
								{
								'product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#' = Evaluate(Evaluate('product_amount_#deep_level#'));//ürününlerin miktarı
									stock_and_spect_list = ListAppend(stock_and_spect_list,'#_next_stock_id_#_#_next_spect_main_id_#_#_next_is_production_#_#_next_is_purchase_#',',');//ürünlerimizin listesi
								}
							if(_next_is_production_ eq 1 and _next_is_phantom_ eq 0) 
							{
									production_row_count = production_row_count+1;
									writeoutput('<input type="hidden" name="product_values_1_#production_row_count#" id="product_values_1_#production_row_count#" value="#_next_stock_id_#,#_next_spect_main_id_#,#deep_level#,#production_row_count#">');//,#Evaluate(Evaluate("product_amount#deep_level#"))#,
									Sql_Spect_Main_Name = 'SELECT SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #_next_spect_main_id_#';
									Spect_Main_Name_Q = cfquery(SQLString : Sql_Spect_Main_Name, Datasource : dsn3);
									if(Spect_Main_Name_Q.recordcount)
									_spect_main_name_ = Spect_Main_Name_Q.SPECT_MAIN_NAME;
									else
									_spect_main_name_ = '';
								_spect_link_ = '<a href="javascript://"  class="tableyazi" onClick="windowopen(''#request.self#?fuseaction=objects.popup_upd_spect_main&spect_main_id=#_next_spect_main_id_#'',''list'');">#_next_spect_main_id_#<!--- #_spect_main_name_# ---></a>';
								_color_ ="FF0000"; 
								if ( attributes.is_stock_info_display eq 1){
								//verilen üretim emirleri başla
								if(len(attributes.order_row_id))
								{
									SqlRelatedProduction = '
														SELECT
															SUM(PO.QUANTITY) QUANTITY
														FROM 
															PRODUCTION_ORDERS PO 
														WHERE 
															P_ORDER_ID IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE ORDER_ROW_ID IN (#attributes.order_row_id#))
															AND PRODUCTION_LEVEL = #production_row_count#';
									GET_RELATED_PRODUCTION_ORDERS = cfquery(SQLString : SqlRelatedProduction, Datasource : dsn3);
								}
								if( isdefined('GET_RELATED_PRODUCTION_ORDERS') and len(GET_RELATED_PRODUCTION_ORDERS.QUANTITY))
									'verilen_uretim_emri#production_row_count#' = GET_RELATED_PRODUCTION_ORDERS.QUANTITY;
								else
									'verilen_uretim_emri#production_row_count#' =  0;
									//verilen üretim emirleri bitiş
								}
							}
							else
							{
								_color_ = "";
								_spect_link_ = "";
							}
							if( ListFind(ListDeleteDuplicates(xml_show_production_type),1))
								product_amount_all = '<td style="text-align:right;">#tlformat(wrk_round(Evaluate(Evaluate("product_amount_#deep_level#")),8,1),8)#</td>';
							else
								product_amount_all = '';
							if(attributes.is_select_min_stock eq 1)
							{
								SqlMinStock = '
													SELECT 
														SUM(ISNULL(MINIMUM_STOCK,0)) MINIMUM_STOCK
													FROM 
														STOCK_STRATEGY 
													WHERE 
														STOCK_ID = #_next_stock_id_#';
								GET_MIN_STOCK = cfquery(SQLString : SqlMinStock, Datasource : dsn3);
								if(get_min_stock.recordcount and len(get_min_stock.minimum_stock))
								{
									min_stock_td='<td style="text-align:right;">#tlformat(get_min_stock.minimum_stock)#</td>';
									min_stock = get_min_stock.minimum_stock;
								}
								else
								{
									min_stock_td='<td style="text-align:right;">#tlformat(0)#</td>';
									min_stock = 0;
								}
							}
							else
							{
								min_stock_td = '';
								min_stock = 0;
							}
							if ( attributes.is_stock_info_display eq 1) {
									if (isdefined("real_stock_#_next_stock_id_#")) real_stock_ = evaluate("real_stock_#_next_stock_id_#"); else real_stock_ = 0;
									if (isdefined("saleable_stock_#_next_stock_id_#")) saleable_stock_ = evaluate("saleable_stock_#_next_stock_id_#"); else saleable_stock_ = 0;
									if (isdefined("product_stock_#_next_stock_id_#")) product_stock_ = evaluate("product_stock_#_next_stock_id_#"); else product_stock_ = 0;
									if(not len(product_stock_)) product_stock_ = 0;
									if(not len(saleable_stock_)) saleable_stock_ = 0;
									//gerçek ihtiyaç başlangıç
									if(deep_level eq 1)//eğer 1.ci kırılım ise
										if(wrk_round(Evaluate(Evaluate("product_amount_#deep_level#")),8,1) gt (product_stock_-min_stock))//1.ci kırılımdaki BİRİM İHTİYAÇ ürünün gerçek stoğundan büyük ise..Yani eldeki stok ile üretim miktarı karşılanamıyorsa..
											"real_product_amount#deep_level#" = wrk_round(wrk_round(Evaluate(Evaluate("product_amount_#deep_level#")),8,1)-product_stock_+min_stock,8,1);//gerçek üretim miktarı = birim ihtiyaç-gerçek stok.
										else
											"real_product_amount#deep_level#" = 0;//eğer birim ihtiyaç miktarı gerçek ürün stoğundan küçük ise zaten satır için üretim karşılanmış oluyor,dolayısı ile 0 set ediyoruz ve bu üretimin altında üretimlerde varsa bu satır sıfır olduğu için bunun altındakilerlerde otomatik olarak sıfır oluyor..
									else
										if((isdefined('real_product_amount#deep_level-1#') and Evaluate('real_product_amount#deep_level-1#')*_next_stock_amount_) gt (product_stock_-min_stock) and (Evaluate('real_product_amount#deep_level-1#')*_next_stock_amount_) gt 0)//eğer 1.ci kırılım değilse bu sefer bir önceki kırılımdaki GERÇEK ÜRETİM miktarını alıyoruz ve satırın kendi miktarı ile çarpıyoruz,bu değer ürünün gerçek stoğundan büyükse ve satır için hesaplanan gerçek üretim ihtiyacı 0 dan büyükse
											'real_product_amount#deep_level#' =  wrk_round((wrk_round(Evaluate('real_product_amount#deep_level-1#'),8,1)*_next_stock_amount_)-product_stock_+min_stock,8,1);//1 üst kırılımdaki için GERÇEK İHTİYAC*SATIRDAKİ MİKTAR-ÜRÜNÜN GERÇEK STOĞU bu satırın gerçek ihtiyacını verir bize.
										else//satır için gerekli GERÇEK ÜRETİM MİKTARI,ÜRÜNÜN GERÇEK STOĞUNUN ALTINDAYSA YADA 0 DAN KÜÇÜK İSE DİRETK OLARAK 0 olarak set ediyoruz,bu kırılımın altındaki ürünlerde 0 oluyor bu durumda..
											"real_product_amount#deep_level#" = 0;
									//gerçek ihtiyaç bitiş
									//kullanılabilir ihtiyaç başlangıç
									
									if(deep_level eq 1)//eğer 1.ci kırılım ise
										if(wrk_round(Evaluate(Evaluate("product_amount_#deep_level#")),8,1) gt (saleable_stock_-min_stock) and len(saleable_stock_))//1.ci kırılımdaki BİRİM İHTİYAÇ ürünün gerçek stoğundan büyük ise..Yani eldeki stok ile üretim miktarı karşılanamıyorsa..
											"saleable_product_amount#deep_level#" = wrk_round(wrk_round(Evaluate(Evaluate("product_amount_#deep_level#")),8,1)-saleable_stock_+min_stock,8,1);//gerçek üretim miktarı = birim ihtiyaç-gerçek stok.
										else
											"saleable_product_amount#deep_level#" = 0;//eğer birim ihtiyaç miktarı gerçek ürün stoğundan küçük ise zaten satır için üretim karşılanmış oluyor,dolayısı ile 0 set ediyoruz ve bu üretimin altında üretimlerde varsa bu satır sıfır olduğu için bunun altındakilerlerde otomatik olarak sıfır oluyor..
									else
										if(isdefined('saleable_product_amount#deep_level-1#') and (Evaluate('saleable_product_amount#deep_level-1#')*_next_stock_amount_) gt (saleable_stock_-min_stock) and (Evaluate('saleable_product_amount#deep_level-1#')*_next_stock_amount_) gt 0)//eğer 1.ci kırılım değilse bu sefer bir önceki kırılımdaki GERÇEK ÜRETİM miktarını alıyoruz ve satırın kendi miktarı ile çarpıyoruz,bu değer ürünün gerçek stoğundan büyükse ve satır için hesaplanan gerçek üretim ihtiyacı 0 dan büyükse
											'saleable_product_amount#deep_level#' = '#(Evaluate('saleable_product_amount#deep_level-1#')*_next_stock_amount_)-saleable_stock_+min_stock#';//1 üst kırılımdaki için GERÇEK İHTİYAC*SATIRDAKİ MİKTAR-ÜRÜNÜN GERÇEK STOĞU bu satırın gerçek ihtiyacını verir bize.
										else//satır için gerekli GERÇEK ÜRETİM MİKTARI,ÜRÜNÜN GERÇEK STOĞUNUN ALTINDAYSA YADA 0 DAN KÜÇÜK İSE DİRETK OLARAK 0 olarak set ediyoruz,bu kırılımın altındaki ürünlerde 0 oluyor bu durumda..
											"saleable_product_amount#deep_level#" = 0;
									//kullanılabilir ihtiyaç bitiş
							}
							if((attributes.is_select_prod_product eq 1 and _next_is_production_ eq 1 and _next_is_phantom_ eq 0 and _next_spect_main_id_ gt 0) or attributes.is_select_prod_product eq 0)
							{
							writeoutput('
							<tr #tr_color# class="#Evaluate("class#_next_is_phantom_#")#" height="20"> 
								<td nowrap>
									<table>
										<tr>
											#leftSpace#
											<!-- sil -->
											<td style="background:#Evaluate("color#deep_level#")#;width:15px;bgcolor:red;margin-left:#(deep_level*15)-15#;color:white;">
												&nbsp;#deep_level#
											</td>
											<!-- sil -->
											<td><a href="javascript://"  class="tableyazi" onClick="windowopen(''#request.self#?fuseaction=objects.popup_detail_product&sid=#_next_stock_id_#'',''list'');"><font color="#_color_#"> #_next_stock_code_# - #_next_product_name_# #_next_property_#</font></a></td>
										</tr>
									</table>
								</td>			
								<td>#_spect_link_#</td>
								<td style="text-align:right;">#wrk_round(Evaluate("product_amount_#deep_level#"),8,1)#<!--- MAIN_UNIT ---></td>
								#product_amount_all#
							');
							if ( attributes.is_stock_info_display eq 1) {
									if( ListFind(ListDeleteDuplicates(xml_show_production_type),2))
									{
										writeoutput('<td style="text-align:right;" nowrap>#tlformat(product_stock_)#</td>');
										writeoutput('<td style="text-align:right;">#tlformat(wrk_round(Evaluate("real_product_amount#deep_level#"),8,1),8)#</td>');
									}
									if( ListFind(ListDeleteDuplicates(xml_show_production_type),3))
									{
										if(saleable_stock_ lt Evaluate(Evaluate("product_amount_#deep_level#")))
											writeoutput('<td style="text-align:right;" nowrap><font color="red">#tlformat(saleable_stock_)#</font></td>');//SATILABİLİR stok
										else
											writeoutput('<td style="text-align:right;">#tlformat(saleable_stock_)#</td>');//SATILABİLİR stok
										writeoutput('<td style="text-align:right;">#tlformat(Evaluate("saleable_product_amount#deep_level#"),8)#</td>');
									}
									writeoutput('#min_stock_td#');
							}
							if(_next_is_production_ eq 1 and _next_is_phantom_ eq 0 and _next_spect_main_id_ gt 0)//eğer ürünümüz üretilen bir ürün ise bağlı bulunduğu istasyonu bu ürünün ağacından alıyoruz
							{
								if (attributes.is_stock_info_display eq 1) 
								{
									if(xml_production_type eq 1)//toplam birim ihtiyaçtan
										gerekli_uretim_miktarı = Evaluate(Evaluate("product_amount_#deep_level#"));
									else if(xml_production_type eq 2)//gerçek stok ihtiyacından
										gerekli_uretim_miktarı = Evaluate(Evaluate("real_product_amount#deep_level#"));
									else if(xml_production_type eq 3)//satılabilir  stok ihtiyacından
										gerekli_uretim_miktarı = Evaluate(Evaluate("saleable_product_amount#deep_level#"));
									if(gerekli_uretim_miktarı lt 0)gerekli_uretim_miktarı = 0;
										gerekli_uretim_miktarı = gerekli_uretim_miktarı - Evaluate('verilen_uretim_emri#production_row_count#');
										writeoutput('<td style="text-align:right;">#Evaluate('verilen_uretim_emri#production_row_count#')#</td>');
								}
								else
									gerekli_uretim_miktarı = Evaluate(Evaluate("product_amount_#deep_level#"));
								writeoutput('<input name="product_amount_old_1_#production_row_count#" id="product_amount_old_1_#production_row_count#" type="hidden" class="box" value="#TlFormat(gerekli_uretim_miktarı,2)#"></td>');
								if(gerekli_uretim_miktarı lt 0) gerekli_uretim_miktarı = 0;
								SQL_PRODUCT_STATION_ID ='SELECT WS_P_ID,STATION_ID,STATION_NAME,PRODUCTION_TYPE,MIN_PRODUCT_AMOUNT,SETUP_TIME,ISNULL(WS.EXIT_DEP_ID,0) AS EXIT_DEP_ID,ISNULL(WS.EXIT_LOC_ID,0) AS EXIT_LOC_ID,ISNULL(WS.PRODUCTION_DEP_ID,0) AS PRODUCTION_DEP_ID,ISNULL(WS.PRODUCTION_LOC_ID,0) AS PRODUCTION_LOC_ID FROM WORKSTATIONS_PRODUCTS WSP,WORKSTATIONS WS WHERE WS.STATION_ID = WSP.WS_ID AND WSP.STOCK_ID = #_next_stock_id_#';
								GET_PRODUCT_STATION_ID = cfquery(SQLString : SQL_PRODUCT_STATION_ID, Datasource : dsn3);
								if(gerekli_uretim_miktarı gt 0 and attributes.is_product_station_relation eq 1)
								{
									var _production_type = GET_PRODUCT_STATION_ID.PRODUCTION_TYPE;
									if(_production_type eq 1)
									{	//üretim tipi katları şeklinde girilmişse verilen üretim miktarı istasyonun üretim miktarının katları şeklinde olmlıdır.
										if(gerekli_uretim_miktarı lt GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT)
											gerekli_uretim_miktarı = GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT;
										else
										{
											new_amount = Int(gerekli_uretim_miktarı/GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT)+1;
											gerekli_uretim_miktarı = GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT*new_amount;
										}
									}	
									else if(gerekli_uretim_miktarı lt GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT)
										gerekli_uretim_miktarı = GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT;
								}
								writeoutput('<td style="text-align:right;"><input name="product_amount_1_#production_row_count#" id="product_amount_1_#production_row_count#" type="text" class="box" value="#TlFormat(gerekli_uretim_miktarı,2)#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,4))"></td>');
								if (isdefined('attributes.is_product_station_relation') and attributes.is_product_station_relation eq 0  and isdefined('GET_ALL_STATIONS') and GET_ALL_STATIONS.recordcount)
								{
								writeoutput('<td id="station_id_1_name_#production_row_count#"><select name="station_id_1_#production_row_count#" id="station_id_1_#production_row_count#" onChange="change_prod_amount(#production_row_count#);" style="width:150px;">#stations_list#</select></td>');
									writeoutput('<td><img src="/images/alternative_list.gif" border="0" align="absmiddle" title="Alternatif" onClick="open_product_alternative(#_next_stock_id_#,#attributes.stock_id#);"></td>');
								}
								else
								{
									stations_list ='';
									for(i=1;  i lte GET_PRODUCT_STATION_ID.RECORDCOUNT; i=i+1)
										stations_list = '#stations_list#<option value="#GET_PRODUCT_STATION_ID.STATION_ID[i]#,#GET_PRODUCT_STATION_ID.PRODUCTION_TYPE[i]#,#GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT[i]#,#GET_PRODUCT_STATION_ID.SETUP_TIME[i]#,#GET_PRODUCT_STATION_ID.WS_P_ID[i]#,#GET_PRODUCT_STATION_ID.EXIT_DEP_ID[i]#,#GET_PRODUCT_STATION_ID.EXIT_LOC_ID[i]#,#GET_PRODUCT_STATION_ID.PRODUCTION_DEP_ID[i]#,#GET_PRODUCT_STATION_ID.PRODUCTION_LOC_ID[i]#">#GET_PRODUCT_STATION_ID.STATION_NAME[i]#&nbsp;[#GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT[i]#]</option>';
									writeoutput('<td id="station_id_1_name_#production_row_count#"><select name="station_id_1_#production_row_count#" id="station_id_1_#production_row_count#" style="width:150px;" onChange="change_prod_amount(#production_row_count#);">#stations_list#</select></td>');
									writeoutput('<td><img src="/images/alternative_list.gif" border="0" align="absmiddle" cursor="hand" title="İşlemler" onClick="open_product_alternative(#_next_stock_id_#,#attributes.stock_id#);"></td>');
								}
							}
							else{
								if( attributes.is_stock_info_display eq 1)
									writeoutput('<td></td>');
									writeoutput('<td></td>
												<td></td>
												<td></td>');
								}
							if(_next_is_phantom_ eq  1) is_disable='disabled'; else  is_disable='';//hayalet ürün ağacı ise checkbox disabled olur..
							if(_next_is_production_ eq 1 and _next_is_phantom_ eq 0 and _next_spect_main_id_ gt 0){//üretilen bir ürünse
								writeoutput('<td><a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#_next_stock_id_#" target="blank_"><img src="/images/shema_list.gif" alt="Alt Ağaç" border="0"></a></td>');
								if(isdefined("attributes.is_select_sub_product") and attributes.is_select_sub_product eq 1)is_checked='checked="true"'; else  is_checked='false';
									writeoutput('<td><input type="checkbox" #is_disable# #is_checked# name="product_is_production_1_#production_row_count#" id="product_is_production_1_#production_row_count#"></td></tr>');
							}	
							else
								writeoutput('<td></td><td></td>');
							writeoutput('</tr>');	
						}
						}
						function writeTree(next_spect_main_id,production_tree_id,type)
						{
							var i = 1;
							var sub_products = get_subs(next_spect_main_id,production_tree_id,type);
							deep_level = deep_level + 1;
							//writeoutput('#sub_products#<br/>-----------------------');
							for (i=1; i lte listlen(sub_products,'█'); i = i+1)
							{
								product_values_list = ListGetAt(sub_products,i,'█');
								if(deep_level-1 gt 0)
									leftSpace = RepeatString('&nbsp;', (deep_level-1)*5);
								else
									leftSpace = '';
								if(len(leftSpace))leftSpace="<td>#leftSpace#</td>";
								_next_spect_main_id_ = ListGetAt(product_values_list,1,'§');//alt+987 = █ --//alt+789 = §
								_next_stock_id_ = ListGetAt(product_values_list,2,'§');
								_next_product_name_ = ListGetAt(product_values_list,3,'§');
								_next_stock_amount_ = wrk_round(ListGetAt(product_values_list,4,'§'),8,1);
								_next_is_production_ = ListGetAt(product_values_list,5,'§');
								_next_is_purchase_ = ListGetAt(product_values_list,6,'§');
								_next_stock_code_ = ListGetAt(product_values_list,7,'§');
								_next_is_phantom_ = ListGetAt(product_values_list,8,'§');
								_next_related_tree_id_ = ListGetAt(product_values_list,9,'§');
								_next_operation_type_id_ = ListGetAt(product_values_list,10,'§');
								_next_property_ = ListGetAt(product_values_list,11,'§');
								_n_free_amount_ = ListGetAt(product_values_list,12,'§');
								writeRow(_next_spect_main_id_,_next_stock_id_,_next_product_name_,_next_stock_amount_,deep_level,_next_is_production_,_next_is_purchase_,_next_stock_code_,_next_is_phantom_,_next_related_tree_id_,_next_operation_type_id_,_next_property_,_n_free_amount_);
								//writeoutput('#leftSpace##_next_product_name_#--#_next_spect_main_id_#--#_next_is_production_#--#_next_stock_id_#');
								if(_next_spect_main_id_ gt 0 and _next_is_production_ eq 1 and _next_stock_id_ gt 0){
									writeTree(_next_spect_main_id_,0,0);
								}	
								else if	(_next_related_tree_id_ gt 0 and _next_operation_type_id_ gt 0){
									writeTree(_next_spect_main_id_,_next_related_tree_id_,3);
								}	
								}
								deep_level = deep_level-1;
						}
						writeTree(attributes.spect_main_id,0,0);
					</cfscript>
				</cfif>
			</cf_grid_list>
			<cf_box_elements>
				<div class="col col-4 col-md-6 col-xs-12">				
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
						</div>
					</div>
					<cfset _now_ = date_add('h',session.ep.TIME_ZONE,now())>
					<cfif isdefined('is_work_time') and is_work_time eq 1>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='36795.Çalışma Programı'></label>
							<div class="col col-8 col-xs-12">
								<cfquery name="get_station_times" datasource="#dsn#">
									SELECT
										SHIFT_ID,
										SHIFT_NAME,
										START_HOUR,
										START_MIN,
										END_HOUR,
										END_MIN
									FROM 
										SETUP_SHIFTS 
									WHERE 
										IS_PRODUCTION = 1 AND 
									FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(now())#">
								</cfquery>
								<select name="works_prog_1" id="works_prog_1" style="width:200px;">
									<cfoutput query="get_station_times">
										<option value="#SHIFT_ID#">#SHIFT_NAME# [#START_HOUR#:#START_MIN#]-[#END_HOUR#:#END_MIN#]</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif> 
				</div> 
				<div class="col col-4 col-md-6 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='36698.Lot No'></label>
						<div class="col col-8 col-xs-12">
							<cfif isDefined('show_lot_no_counter') And show_lot_no_counter>
								<cfquery name="get_lot_counter" datasource ="#dsn1#">
									SELECT * FROM LOT_NO_COUNTER WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
								</cfquery> 
								<cfif get_lot_counter.recordcount and len(get_lot_counter.lot_number)>
									<cfset paper_number = get_lot_counter.lot_no&get_lot_counter.lot_number>
								<cfelseif isDefined('xml_free_lot_no') And xml_free_lot_no>
									<cfset paper_number = '' />
								<cfelse>
									<cf_papers paper_type="production_lot">
								</cfif>
							<cfelse>
								<cf_papers paper_type="production_lot">
								<cfset paper_number = '#paper_code#-#paper_number#'>
							</cfif>
							<input type="text" name="lot_no" id="lot_no" value="<cfoutput>#paper_number#</cfoutput>" style="text-align:right;width:180px;"<cfif isDefined('xml_free_lot_no') And xml_free_lot_no Neq 1> readonly="readonly"</cfif><cfif isDefined('xml_free_lot_no') And xml_free_lot_no> onKeyup="lotno_control(1,1);"</cfif>>
						</div>
					</div>
					<div class="form-group">
						<cfif not isdefined('attributes.is_demand')><!--- talepde stok rezerve edilmez... --->
							<label class="col col-3">
								<cf_get_lang dictionary_id ='36385.Stok Rezerve Et'>
								<input type="checkbox" name="stock_reserved" id="stock_reserved" value="1" checked>
							</label>
						<cfelse>
							<label class="col col-3">
								<input type="hidden" name="is_demand" id="is_demand" value="<cfoutput>#attributes.is_demand#</cfoutput>">
								<cf_get_lang dictionary_id='36438.Talep Numarası'><input type="text" name="demand_no" id="demand_no" value="<cfif isdefined('attributes.demand_no') and len(attributes.demand_no)><cfoutput>#attributes.demand_no#</cfoutput></cfif>" onKeyPress="if(event.keyCode==13)send_to_production('','','',1);">
							</label>
						</cfif>
						<label class="col col-3">
							<input type="hidden" name="is_stage" id="is_stage" value="<cfif isdefined('attributes.is_demand')>-1<cfelse>4</cfif>">
							<cf_get_lang dictionary_id ='36860.Demontaj'>
							<input type="checkbox" name="is_demontaj" id="is_demontaj" value="1">
						</label>
						<label class="col col-3">
							<cf_get_lang dictionary_id ='36859.Hepsini Seç'>
							<input type="checkbox" title="<cf_get_lang dictionary_id ='36859.Hepsini Seç'>" onClick="all_select();"> 
						</label>
					</div>
				</div> 
				<div class="col col-4 col-md-6 col-xs-12"> 
					<div class="form-group">
						<cfif isdefined('attributes.is_time_calculation') and attributes.is_time_calculation eq 1><!--- Termin Hesabı Yapılsın Denmiş ise --->
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='36861.Çalışma Tipi'></label>
							<label class="col col-3"><input type="radio" name="production_type_1" id="production_type_1" value="1" checked><cf_get_lang dictionary_id ='36862.Parçalı'></label>
							<label class="col col-3"><input type="radio" name="production_type_1" id="production_type_1" value="0"><cf_get_lang dictionary_id ='36863.Sürekli'></label>
						</cfif>     
					</div>
				</div>  			
			</cf_box_elements>  
			<div class="row formContentFooter">
				<div class="col col-12 text-right">
					<cf_workcube_buttons add_function="control()" insert_info="#getLang('main',49)#" is_cancel="0">
				</div>
			</div> 
		</cf_box>
		<cfoutput>
			<cfif isdefined('attributes.lot_no') and len(attributes.lot_no)><input type="hidden" name="lot_no" id="lot_no" value="#attributes.lot_no#"></cfif>  <!--- Eğer bir üretimin detayından başka bir üretim ekleniyorsa bunun için bu üretilen ürün ile diğer ürün arasındaki bağlantıyı bu değişken tutar --->
			<cfif isdefined('attributes.po_related_id') and len(attributes.po_related_id)><input type="hidden" name="po_related_id_main_1" id="po_related_id_main_1" value="#attributes.po_related_id#"></cfif>  <!--- Eğer bir üretimin detayından başka bir üretim ekleniyorsa bunun için bu üretilen ürün ile diğer ürün arasındaki bağlantıyı bu değişken tutar --->
			<cfif isdefined('attributes.fusect') and len(attributes.fusect)><input type="hidden" name="fusect" id="fusect" value="#attributes.fusect#"></cfif>
			<cfif isdefined('attributes.finish_h')><input type="hidden" name="finish_h_1" id="finish_h_1" value="#attributes.finish_h#"></cfif>    
			<cfif isdefined('attributes.finish_m')><input type="hidden" name="finish_m_1" id="finish_m_1" value="#attributes.finish_m#"></cfif>    
			<cfif isdefined('attributes.start_h')><input type="hidden" name="start_h_1" id="start_h_1" value="#attributes.start_h#"></cfif>    
			<cfif isdefined('attributes.start_m')><input type="hidden" name="start_m_1" id="start_m_1" value="#attributes.start_m#"></cfif>    
			<cfif isdefined('attributes.start_date')><input type="hidden" name="start_date_1" id="start_date_1" value="#attributes.start_date#"></cfif>    
			<cfif isdefined('attributes.finish_date')><input type="hidden" name="finish_date_1" id="finish_date_1" value="#attributes.finish_date#"></cfif>    
			<cfif isdefined('attributes.company_id')><input type="hidden" name="company_id_1" id="company_id_1" value="#attributes.company_id#"></cfif>    
			<cfif isdefined('attributes.project_id')><input type="hidden" name="project_id_1" id="project_id_1" value="#attributes.project_id#"></cfif>    
			<cfif isdefined('attributes.order_row_id')><input type="hidden" name="order_row_id_1" id="order_row_id_1" value="#attributes.order_row_id#"></cfif>
			<cfif isdefined('attributes.order_id')><input type="hidden" name="order_id_1" id="order_id_1" value="#attributes.order_id#"></cfif>
			<cfif isdefined('attributes.deliver_date')><cfinput type="hidden" name="deliver_date_1" id="deliver_date_1" value="#attributes.deliver_date#"></cfif>
			<cfif isdefined('attributes.detail')><input type="hidden" name="detail" id="detail" value="#replace("#attributes.detail#","|","##","all")#"></cfif>
			<cfif isdefined('attributes.wrk_row_relation_id')><input type="hidden" name="wrk_row_relation_id_1" id="wrk_row_relation_id_1" value="#attributes.wrk_row_relation_id#"></cfif>
			<cfif isdefined('attributes.is_time_calculation')><input type="hidden" name="is_time_calculation_1" id="is_time_calculation_1" value="#attributes.is_time_calculation#"></cfif>
			<cfif isdefined('attributes.is_line_number')><input type="hidden" name="is_line_number_1" id="is_line_number_1" value="#attributes.is_line_number#"></cfif>
			<cfif isdefined('attributes.is_operator_display') and is_operator_display eq 1>
				<input type="hidden" name="is_operator_display_1" id="is_operator_display_1" value="1">
			</cfif>
			<cfif isdefined('attributes.is_generate_serial_nos') and is_generate_serial_nos eq 1>
				<input type="hidden" name="is_generate_serial_nos" id="is_generate_serial_nos" value="1">
			</cfif>
			<input name="show_lot_no_counter" id="show_lot_no_counter" type="hidden" value="<cfoutput>#show_lot_no_counter#</cfoutput>">
			<input name="xml_free_lot_no" id="xml_free_lot_no" type="hidden" value="<cfif isdefined("xml_free_lot_no") and xml_free_lot_no><cfoutput>#xml_free_lot_no#</cfoutput></cfif>" />
			<input type="hidden" name="production_row_count_1" id="production_row_count_1" value="#production_row_count#"><!--- Ağaçtaki üretilen ürünlerin kaç tane olduğu! --->
			<input type="hidden" name="xml_is_order_row_deliver_date_update_1" id="xml_is_order_row_deliver_date_update_1" value="#xml_is_order_row_deliver_date_update#">
			<cfif isdefined('attributes.work_id')><input type="hidden" name="work_id_1" id="work_id_1" value="#attributes.work_id#"></cfif>   
			<cfif isdefined('attributes.work_head')><input type="hidden" name="work_head_1" id="work_head_1" value="#attributes.work_head#"></cfif>   
		</cfoutput>       
	</cfif>  
</cfform>
<script type="text/javascript">
	function open_product_alternative(stock_id,main_stock_id){ 
		windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_anative_product&sid='+stock_id+'&tree_stock_id='+main_stock_id+'','medium'</cfoutput>);
	}
	function all_select(){
		for(i=1;i<=<cfoutput>#production_row_count#</cfoutput>;i++)
			if(document.getElementById('product_is_production_1_'+i) && document.getElementById('product_is_production_1_'+i).disabled != true)//eğer hayalet ürün ağacı ise disabled olacağından onu ellemiyoruz.
				document.getElementById('product_is_production_1_'+i).checked = (document.getElementById('product_is_production_1_'+i).checked)?false:true;
	}
	function station_warning(i){
		if(i != 0)
			document.getElementById('station_id_1_'+i).focus();
		document.getElementById('station_id_1_name_'+i).style.backgroundColor='green';
	}
	function change_prod_amount(i)
	{
		<cfif attributes.is_product_station_relation eq 1>
			var _min_station_amount = list_getat(document.getElementById('station_id_1_'+i).value,3,',');//İstasyonda üretilecek en düşük miktar
			var _production_amount = filterNum(document.getElementById('product_amount_old_1_'+i).value);//verilen üretim miktarı
			if(_production_amount != 0)
			{
				var _production_type = list_getat(document.getElementById('station_id_1_'+i).value,2,',');
				if(_production_type == 1)
				{	//üretim tipi katları şeklinde girilmişse verilen üretim miktarı istasyonun üretim miktarının katları şeklinde olmlıdır.
					new_amount = parseInt(_production_amount/_min_station_amount)+1;
					document.getElementById('product_amount_1_'+i).value = commaSplit(parseFloat(_min_station_amount*new_amount));
				}	
				else if(parseFloat(_production_amount) < _min_station_amount)
					document.getElementById('product_amount_1_'+i).value = commaSplit(parseFloat(_min_station_amount));
				else
					document.getElementById('product_amount_1_'+i).value = commaSplit(parseFloat(_production_amount));
			}
		</cfif>
	}
	function control(){
		<!---for(i=1;i<=<cfoutput>#production_row_count#</cfoutput>;i++)
		{
			if(document.getElementById('station_id_1_'+i).value ==''){
				alert("Zorunlu alan İstasyon!");
			}
		}--->
		if(document.getElementById('process_stage').value ==''){
			alert("<cf_get_lang dictionary_id ='36868.Üretim Emirleri Sürecine Yetkiniz Yok'>");
			return false;
		}
		if(document.getElementById('lot_no').value == ''){
			alert("<cf_get_lang dictionary_id='33868.Lot No Girmelisiniz'>");
			document.getElementById('lot_no').focus();
			return false;
		}
		<cfif isdefined('is_work_time') and is_work_time eq 1>
			if(document.getElementById('works_prog_1').value==''){
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='36795.Çalışma Programı'>!");
				return false;
			}
		</cfif>
		is_ok = 1;
		if (!process_cat_control()) return false;
		if(document.getElementById('demand_no')){
			demand_no = document.getElementById('demand_no').value;
			if(demand_no ==""){
				alert('Talep Numarası');
				document.getElementById('demand_no').focus();
				return false;
			}
		
			var get_demend_control = wrk_safe_query('prdp_get_demend_control','dsn3',0,document.getElementById('demand_no').value);
			if(get_demend_control.recordcount){
				if(confirm("<cf_get_lang dictionary_id='60528.Bu Talep Numarası Daha Önceden Kullanılmış,Devam Ederseniz Seçtiğiniz Siparişler Bu Talep Numarasına Eklenecektir.Devam Etmek İstiyormusunuz?'>"))
					is_ok = 1;
				else
					is_ok = 0;
			}
		}
		<cfoutput>
			if(is_ok ==1){
			for(i=0;i<=#production_row_count#;i++)
			{	
				if(document.getElementById('product_is_production_1_'+i))
				{
					document.getElementById('station_id_1_'+i).style.background='';
					if(document.getElementById('product_is_production_1_'+i) && document.getElementById('product_is_production_1_'+i).checked == true)//üret checkbox'ı seçilmiş ise istasyonu varmı diye kontrol edilecek
					{
						if(document.getElementById('station_id_1_'+i).value == '')
						{
							alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58834.İstasyon'>");
							station_warning(i);
							return false;
						}
						<cfif is_station_amount_kontrol eq 1>
							var _min_station_amount = list_getat(document.getElementById('station_id_1_'+i).value,3,',');//İstasyonda üretilecek en düşük miktar
							var _production_amount = filterNum(document.getElementById('product_amount_1_'+i).value);//verilen üretim miktarı
							if(_min_station_amount <= _production_amount)
							{
								var _production_type = list_getat(document.getElementById('station_id_1_'+i).value,2,',');
								if(_production_type == 1 && (_production_amount%_min_station_amount)!= 0 ){//üretim tipi katları şeklinde girilmişse verilen üretim miktarı istasyonun üretim miktarının katları şeklinde olmlıdır.
									alert("<cf_get_lang dictionary_id ='36871.Bu İstasyonda Üretilecek Ürününün Miktarı'> "+ _min_station_amount +" <cf_get_lang dictionary_id ='36872.ve Katları Şeklinde Girilmelidir'>");
									station_warning(i);
									return false;
								}	
							}
							else if(_min_station_amount < _production_amount)
							{
								alert("<cf_get_lang dictionary_id ='36873.Miktar,İstasyonun Min Üretim Miktarından Küçük Olamaz'>");
								station_warning(i);
								return false;
							}
						</cfif>
						if(filterNum(document.getElementById('product_amount_1_'+i).value) <= 0)
						{
							document.getElementById('product_is_production_1_'+i).checked = false;
						}
						get_sta_kontrol_1 = wrk_query('SELECT IS_CAPACITY FROM WORKSTATIONS WHERE STATION_ID='+list_getat(document.getElementById('station_id_1_'+i).value,1,','),'dsn3');
						if(get_sta_kontrol_1.IS_CAPACITY == 1)
						{
							if(document.getElementById('start_m').value == 0) new_m = '00'; else new_m=document.getElementById('start_m').value;
							if(document.getElementById('finish_m').value == 0) f_new_m = '00'; else f_new_m=document.getElementById('finish_m').value;
							if(document.getElementById('start_h').value == 0) new_h = '00'; else new_h=document.getElementById('start_h').value;
							if(document.getElementById('finish_h').value == 0) f_new_h = '00'; else f_new_h=document.getElementById('finish_h').value;
							var start_new = js_date(document.getElementById('start_date').value,new_h+':'+new_m);
							var finish_new = js_date(document.getElementById('finish_date').value,f_new_h+':'+f_new_m);
							form_warning('station_id_1_'+i+'',"<cf_get_lang dictionary_id ='36870.Ürünü Üretmek İçin Ağacında Üretilebileceği İstasyonları Tanımlamanız Gerekmektedir'>");
							<cfif isdefined('attributes.is_demand') and attributes.is_demand eq 1>
								get_sta_kontrol = wrk_query('SELECT P_ORDER_ID FROM PRODUCTION_ORDERS WHERE IS_STAGE = -1 AND ((START_DATE >= '+start_new+' AND FINISH_DATE <= '+finish_new+') OR (START_DATE <= '+start_new+' AND FINISH_DATE >= '+finish_new+') OR (START_DATE <= '+start_new+' AND FINISH_DATE <= '+finish_new+') OR (START_DATE >= '+start_new+' AND FINISH_DATE >= '+finish_new+' AND START_DATE <= '+finish_new+')) AND STATION_ID='+list_getat(document.getElementById('station_id_1_'+i).value,1,','),'dsn3');
								if(get_sta_kontrol.recordcount)
								{
									alert("<cf_get_lang dictionary_id='60529.Aynı Tarih Aralığında Girilmiş Talepler Mevcut'>. <cf_get_lang dictionary_id='58492.Lütfen Tarihi Kontrol Ediniz'> !");
									station_warning(i);
									return false;
								}
							<cfelse>
								get_sta_kontrol = wrk_query('SELECT P_ORDER_ID FROM PRODUCTION_ORDERS WHERE IS_STAGE = -1 AND ((START_DATE >= '+start_new+' AND FINISH_DATE <= '+finish_new+') OR (START_DATE <= '+start_new+' AND FINISH_DATE >= '+finish_new+') OR (START_DATE <= '+start_new+' AND FINISH_DATE <= '+finish_new+') OR (START_DATE >= '+start_new+' AND FINISH_DATE >= '+finish_new+' AND START_DATE <= '+finish_new+')) AND STATION_ID='+list_getat(document.getElementById('station_id_1_'+i).value,1,','),'dsn3');
								if(get_sta_kontrol.recordcount)
								{
									alert("<cf_get_lang dictionary_id='60530.Aynı Tarih Aralığında Girilmiş Emirler Mevcut'>. <cf_get_lang dictionary_id='58492.Lütfen Tarihi Kontrol Ediniz'> !");
									station_warning(i);
									return false;
								}
							</cfif>
						}
					}
				}
			}
		</cfoutput>
		//var _mainStockId = list_getat(document.getElementById('product_values_1_0').value,1,',');
		var _mainStationId = document.getElementById('station_id_1_0').value;
		var get_station_deploc = wrk_safe_query('prdp_get_station_deploc','dsn3',0,_mainStationId);
		if(get_station_deploc.recordcount){
			_EXIT_DEP_ID_=get_station_deploc.EXIT_DEP_ID;
			_EXIT_LOC_ID_=get_station_deploc.EXIT_LOC_ID;
			_PRODUCTION_DEP_ID_=get_station_deploc.PRODUCTION_DEP_ID;
			_PRODUCTION_LOC_ID_=get_station_deploc.PRODUCTION_LOC_ID;
		}
		else
		{
			_EXIT_DEP_ID_=0;
			_EXIT_LOC_ID_=0;
			_PRODUCTION_DEP_ID_=0;
			_PRODUCTION_LOC_ID_=0;
		}
		document.add_production_ordel_all.action = document.add_production_ordel_all.action+'&station_id_1_0='+_mainStationId+',0,0,0,-1,'+_EXIT_DEP_ID_+','+_EXIT_LOC_ID_+','+_PRODUCTION_DEP_ID_+','+_PRODUCTION_LOC_ID_+'';
		var _filterNum_ = FilterValues();
		if(_filterNum_ == true)
		{
			document.add_production_ordel_all.submit();
			return false;
		}
		}
	}
	function FilterValues()
	{
		<cfoutput>
		for(i=0;i<=#production_row_count#;i++)
			if(document.getElementById('product_amount_1_'+i))document.getElementById('product_amount_1_'+i).value = filterNum(document.getElementById('product_amount_1_'+i).value,8);
		</cfoutput>
		return true;
	}
	$( ".pageCaption " ).click(function() {	
		if($("#prod_order").is(":visible"))
			{$('.dheight').css("height", $(window).height()-485+"px").css("max-height", $(window).height()-485+"px");
		}else{
			$('.dheight').css("height", $(window).height()+"px").css("max-height", $(window).height()-270+"px");
		}
	});
	$(window).resize(function() {	
		if($("#prod_order").is(":visible"))
			{$('.dheight').css("height", $(window).height()-485+"px").css("max-height", $(window).height()-485+"px");
		}else{
			$('.dheight').css("height", $(window).height()+"px").css("max-height", $(window).height()-270+"px");
		}
	});
	<cfif isDefined('xml_free_lot_no') And xml_free_lot_no>
	function lotno_control(crntrow,type)
	{
		//var prohibited=' [space] , ",	#,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ], `, {, |,   }, , «, ';
		var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
		if(type == 2)
			lot_no = document.getElementById('lot_no_exit'+crntrow);
		else if(type ==3)
			lot_no = document.getElementById('lot_no_outage'+crntrow);
		else
			lot_no = document.getElementById('lot_no');
		toplam_ = lot_no.value.length;
		deger_ = lot_no.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],\"\,#,$,%,&,',(,),*,+,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; Katakterlerinden Oluşan Lot No Girilemez!");
					lot_no.value = '';
					break;
				}
			}
		}
	}
	</cfif>
	</script>
<cfabort>