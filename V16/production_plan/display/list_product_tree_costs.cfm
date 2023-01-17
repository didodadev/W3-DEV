<cf_xml_page_edit fuseact="prod.product_tree_costs">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.last_spect_id" default="">
<cfif is_rate2_show eq 2>
	<cfparam name="attributes.rate2_info" default="1">
<cfelse>
	<cfparam name="attributes.rate2_info" default="0">
</cfif>
<cfset last_stock_id = attributes.stock_id>			
<cfquery name="get_product_name" datasource="#dsn3#" maxrows="1">
	SELECT
		PRODUCT_ID,
		PRODUCT_NAME,
		PROPERTY
	FROM
		STOCKS
	WHERE
		STOCK_ID = #attributes.stock_id#
</cfquery>

<cfquery name="get_main_spec" datasource="#dsn3#" maxrows="1">
	SELECT
		SPECT_MAIN_ID
	FROM
		SPECT_MAIN
	WHERE
		STOCK_ID = #attributes.stock_id#
		<cfif isdefined("attributes.spec_main_id") and len(attributes.spec_main_id) and len(attributes.spec_name)>
			AND SPECT_MAIN_ID = #attributes.spec_main_id#
		<cfelse>
			AND IS_TREE = 1
		</cfif>
	ORDER BY
		SPECT_MAIN_ID DESC
</cfquery>
<cfif get_main_spec.recordcount>
	<cfscript>
	function get_product_tree(stock_id,main_spec_id,product_id)
	{
		tr_count=1;
		product_tree_list='#stock_id#;#main_spec_id#;0;1;1;Adet;1;#product_id#';
		deep_level=1;
		while(tr_count lt listlen(product_tree_list,';'))
		{
			pre_stock_id=listgetat(product_tree_list,tr_count,';');
			pre_main_spec_id=listgetat(product_tree_list,tr_count+1,';');
			pre_deep_level=listgetat(product_tree_list,tr_count+2,';');
			pre_is_production=listgetat(product_tree_list,tr_count+3,';');
			pre_is_amount=listgetat(product_tree_list,tr_count+4,';');
			if(pre_is_production)//uretiliyorsa spec yada agac bileşenlerine baksın
			{		
				if(len(pre_main_spec_id) and pre_main_spec_id gt 0)//sepecli ise spec bileşenleri degil ise agac
					SQLStr = 'SELECT SUM(SPECT_MAIN_ROW.AMOUNT) AMOUNT,STOCKS.PRODUCT_CATID,STOCKS.PRODUCT_ID,SPECT_MAIN_ROW.STOCK_ID RELATED_ID,RELATED_MAIN_SPECT_ID AS SPECT_MAIN_ID,STOCKS.IS_PRODUCTION,PRODUCT_UNIT.ADD_UNIT FROM SPECT_MAIN_ROW,STOCKS,PRODUCT_UNIT WHERE STOCKS.STOCK_ID=SPECT_MAIN_ROW.STOCK_ID AND PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID AND PRODUCT_UNIT.PRODUCT_UNIT_STATUS=1 AND PRODUCT_UNIT.IS_MAIN=1 AND SPECT_MAIN_ROW.SPECT_MAIN_ID = #pre_main_spec_id# GROUP BY STOCKS.PRODUCT_CATID,STOCKS.PRODUCT_ID,SPECT_MAIN_ROW.STOCK_ID,RELATED_MAIN_SPECT_ID,STOCKS.IS_PRODUCTION,PRODUCT_UNIT.ADD_UNIT,STOCKS.STOCK_CODE ORDER BY STOCKS.STOCK_CODE';
				else
					SQLStr = 'SELECT STOCKS.PRODUCT_CATID,STOCKS.PRODUCT_ID,PRODUCT_TREE_ID,RELATED_ID,ISNULL(SPECT_MAIN_ID,0) SPECT_MAIN_ID, STOCKS.IS_PRODUCTION,PRODUCT_TREE.AMOUNT,PRODUCT_UNIT.ADD_UNIT FROM PRODUCT_TREE,STOCKS,PRODUCT_UNIT WHERE STOCKS.STOCK_ID=PRODUCT_TREE.RELATED_ID AND PRODUCT_UNIT.PRODUCT_ID=STOCKS.PRODUCT_ID AND PRODUCT_UNIT.PRODUCT_UNIT_STATUS=1 AND PRODUCT_UNIT.IS_MAIN=1 AND PRODUCT_TREE.STOCK_ID = #pre_stock_id# ORDER BY PRODUCT_TREE.LINE_NUMBER,STOCKS.STOCK_CODE';
				sub_query = cfquery(SQLString : SQLStr, Datasource : dsn3);
				if(sub_query.recordcount)
				{
					product_tree_list_gecici='';
					for(list_i=1;list_i lte tr_count;list_i=list_i+8)
					{
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+1,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+2,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+3,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+4,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+5,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+6,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+7,';'),';');
					}
					for (i=1; i lte sub_query.recordcount; i = i+1)
					{
						product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.RELATED_ID[i],';');
						if(len(sub_query.SPECT_MAIN_ID[i]))product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.SPECT_MAIN_ID[i],';'); else product_tree_list_gecici = listappend(product_tree_list_gecici,0,';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,pre_deep_level+1,';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.IS_PRODUCTION[i],';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.AMOUNT[i],';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.ADD_UNIT[i],';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.PRODUCT_CATID[i],';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,sub_query.PRODUCT_ID[i],';');
					}
					tr_count = tr_count+8;
					for(list_i=tr_count;list_i lt listlen(product_tree_list,';');list_i=list_i+8)
					{
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+1,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+2,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+3,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+4,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+5,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+6,';'),';');
						product_tree_list_gecici = listappend(product_tree_list_gecici,listgetat(product_tree_list,list_i+7,';'),';');
					}
					product_tree_list=product_tree_list_gecici;
					product_tree_list_gecici='';
				}else{tr_count = tr_count+8;}
			}else{tr_count = tr_count+8;}
		}
		return product_tree_list;
	}
	</cfscript>
	<cfscript>
		'product_tree_list_#STOCK_ID#'=get_product_tree(attributes.stock_id,get_main_spec.spect_main_id,get_product_name.product_id);
		product_id_list='';
		'product_tree_list_#STOCK_ID#' = replace(evaluate('product_tree_list_#STOCK_ID#'),';',' ;','all');
		stock_id_list='';
		spec_id_list='';
		for(c=1;c lte listlen(evaluate('product_tree_list_#STOCK_ID#'),';');c=c+8)
		{
			product_id_list=listappend(product_id_list,listgetat(evaluate('product_tree_list_#STOCK_ID#'),c+7,';'),',');
			stock_id_list=listappend(stock_id_list,listgetat(evaluate('product_tree_list_#STOCK_ID#'),c,';'),',');
			spec_id_list=listappend(spec_id_list,listgetat(evaluate('product_tree_list_#STOCK_ID#'),c+1,';'),',');
		}
	</cfscript>
	<cfquery name="GET_PURCHASE_COST" datasource="#DSN3#">
		SELECT
			PC.PURCHASE_NET_SYSTEM,
			PC.PURCHASE_NET_SYSTEM_2,
			PC.PURCHASE_EXTRA_COST_SYSTEM,
			PC.PURCHASE_EXTRA_COST_SYSTEM_2,
			PC.START_DATE,
			PC.RECORD_DATE,
			PC.PRODUCT_COST_ID,
			PC.STANDARD_COST,
			PC.STANDARD_COST_RATE,
			PC.PRODUCT_ID,
			ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID
		FROM	
			PRODUCT_COST PC
		WHERE
			PC.PRODUCT_ID IN(#product_id_list#)
	</cfquery>
	<cfquery name="GET_STOCKS" datasource="#DSN3#">
		SELECT 
			S.STOCK_CODE,
			S.PROPERTY,
			S.BARCOD,
			(S.PRODUCT_NAME + ' ' + ISNULL(S.PROPERTY,'')) PRODUCT_NAME,
			S.PROPERTY,
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.PRODUCT_CATID,
			PU.ADD_UNIT,
			PS.PRICE,
			PS.MONEY
		FROM 
			STOCKS S,	
			PRODUCT_UNIT PU,
			PRICE_STANDART PS
		WHERE
			S.PRODUCT_ID = PU.PRODUCT_ID AND
			PS.PURCHASESALES = 0 AND
			PS.PRICESTANDART_STATUS = 1 AND	
			S.PRODUCT_ID = PS.PRODUCT_ID AND
			PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
			PU.PRODUCT_UNIT_STATUS = 1
	</cfquery>
	<cfquery name="GET_PROD_WORKSTATION" datasource="#dsn3#">
		SELECT 
			WSP.PROCESS,
			WSP.STOCK_ID,
			WS_P_ID,
			PRODUCTION_TIME,
			WSP.CAPACITY,
			STATION_ID,
			STATION_NAME,
			PRODUCTION_TYPE,
			ISNULL(SETUP_TIME,0) SETUP_TIME,
			ISNULL(WS.AVG_COST,0) AVG_COST,
			WS.COST_MONEY
		FROM 
			WORKSTATIONS_PRODUCTS WSP,
			WORKSTATIONS WS 
		WHERE 
			WS.STATION_ID = WSP.WS_ID AND
			WSP.STOCK_ID IN (#stock_id_list#)
	</cfquery>
	<cfquery name="GET_MONEY" datasource="#dsn2#">
		SELECT (RATE2/RATE1) RATE, MONEY FROM SETUP_MONEY UNION ALL SELECT 1,'YTL' FROM SETUP_MONEY WHERE RATE1 = RATE2
	</cfquery>
	<cfoutput query="GET_MONEY"> 
		<cfset 'rate_#MONEY#'=RATE> 
	</cfoutput>
</cfif>
<cfsavecontent variable="right">
	<cfif not listfindnocase(denied_pages,'prod.product_tree_costs')>
		<a style="color:#E08283;font-size:15px;" href="<cfoutput>#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#attributes.stock_id#</cfoutput>"><i class="fa fa-tree" title="<cf_get_lang dictionary_id='58258.Maliyet'>"></i></a>&nbsp;&nbsp;
	</cfif>		
	<cfif not listfindnocase(denied_pages,'stock.detail_stock')>
		<a style="color:#E08283;font-size:15px;" href="<cfoutput>#request.self#?fuseaction=stock.list_stock&event=det&pid=#GET_PRODUCT_NAME.PRODUCT_ID#</cfoutput>"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='37132.Stok Detayları'>"></i></a> &nbsp;&nbsp;
	</cfif>
	<cfif get_module_user(5)>
		<a style="color:#E08283;font-size:15px;" href="<cfoutput>#request.self#?fuseaction=product.list_product&event=det&pid=#GET_PRODUCT_NAME.PRODUCT_ID#&sid=#attributes.stock_id#</cfoutput>"><i class="fa fa-cubes"  title="<cf_get_lang dictionary_id='57657.Ürün'>"></i></a>&nbsp;
	<cfelse>
		<a style="color:#E08283;font-size:15px;" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_detail_product&pid=#GET_PRODUCT_NAME.PRODUCT_ID#&sid=#attributes.stock_id#</cfoutput>','page');"><i class="fa fa-cubes" title="<cf_get_lang dictionary_id='36369.Stok Detayları'>"></i></a>&nbsp;
	</cfif>
</cfsavecontent>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='57456.Üretim'> <cf_get_lang dictionary_id='36621.Öngörülen Maliyet'>: <cfoutput>#get_product_name.product_name#&nbsp;#get_product_name.property#</cfoutput></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="box_counter" title="#title#" scroll="1" uidrop="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#" right_images="#right#">
		<cfform name="product_tree_cost" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
			<cfinput type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
			<cf_box_search>	
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="last_spect_id" id="last_spect_id" value="<cfif isdefined('attributes.spec_main_id') and len(attributes.spec_name)><cfoutput>#attributes.spec_main_id#</cfoutput></cfif>">
						<input type="hidden" name="spec_main_id" id="spec_main_id" value="<cfif isdefined('attributes.spec_main_id') and len(attributes.spec_name)><cfoutput>#attributes.spec_main_id#</cfoutput></cfif>">
						<input type="text" name="spec_name" id="spec_name" placeholder="<cfoutput>#getLang('','Spec',34299)#</cfoutput>" value="<cfif isdefined('attributes.spec_name') and len(attributes.spec_name)><cfoutput>#attributes.spec_name#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_main&field_main_id=product_tree_cost.spec_main_id&field_name=product_tree_cost.spec_name&is_display=1&stock_id=#attributes.stock_id#</cfoutput>','list')"></a>
					</div>
				</div>
				<div class="form-group">
					<cfif isdefined("is_rate2_show") and (is_rate2_show eq 1 or is_rate2_show eq 2)>
						<cfoutput>#session.ep.money2#</cfoutput> <cf_get_lang dictionary_id="58596.Göster"><input type="checkbox" name="rate2_info" id="rate2_info" value="1"<cfif attributes.rate2_info eq 1>checked</cfif>>
					</cfif>
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="hidden" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('product_tree_cost' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr id="my_header_tr" style="position:relative;height:41;" class="color-list" height="22">
					<th width="80"  class="txtboldblue" style="text-align:center;"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
					<th height="22" class="txtboldblue"><cf_get_lang dictionary_id='36319.Malzeme'></th>
					<th class="txtboldblue" width="40"><cf_get_lang dictionary_id='57647.Spec'></th>
					<th width="45" class="txtboldblue" style="text-align:right;" title="<cf_get_lang dictionary_id='60537.Ana Ürün Üretimi İçin Gereken Toplam Üretim Miktarı'>"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="txtboldblue" width="50"><cf_get_lang dictionary_id='57636.Birim'></th>
					<th width="65" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='36473.Alış Fiyat'></th>
					<th width="50" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
					<th width="50" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='33046.Sistem Para Birimi'></th>
					<th width="65" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='37511.Sabit Maliyet'></th>
					<th width="65" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='36805.Sabit Maliyet Oranı'></th>
					<th width="100" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id = '36806.Kayıtlı Net Maliyet'></th>
					<th width="65" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id = '36807.Kayıtlı Ek Maliyet'></th>
					<th width="65" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='36808.Kayıtlı Toplam Maliyet'></th>
					<th width="65" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id = '36809.Üretim Net Maliyet'></th>
					<th width="65" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id = '36810.Üretim Ek Maliyet'></th>
					<th width="65" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='36811.İstasyon Maliyeti'></th>
					<th width="100" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='36812.Toplam Maliyet'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_main_spec.recordcount>
					<cfif listlen(evaluate('product_tree_list_#last_stock_id#'),';') gte 8>
						<cfoutput>
							<cfset row_count = 0>
							<cfset total_rec_cost=0>
							<cfset total_price=0>
							<cfset production_count=0>
							<cfset gross_total_cost = 0>
							<cfset gross_total_extra_cost = 0>
							<cfset gross_total_sta_cost = 0>
							<cfloop from="9" to="#listlen(evaluate('product_tree_list_#last_stock_id#'),';')#" step="8" index="prd_list_ind">
								<cfscript>
									amount=1;
									row_deep_level=listgetat(product_tree_list,prd_list_ind+2,';');
									'pre_amount_#row_deep_level#'=wrk_round(listgetat(product_tree_list,prd_list_ind+4,';'),8,1);//kademe miktarı
									for(i=1;i lte listgetat(product_tree_list,prd_list_ind+2,';');i=i+1)//miktar için kademe miktarları çarpılıyor
										amount=wrk_round((amount*evaluate('pre_amount_#i#')),8,1);
								</cfscript>		
								<cfquery name="GET_STOCK" dbtype="query">
									SELECT * FROM GET_STOCKS WHERE STOCK_ID=#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind,';')#
								</cfquery>
								<cfif listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') gt 0>
									<cfset _tr_class_ ='color-gray'>
									<cfset is_prod = 1>
								<cfelse>
									<cfset _tr_class_ ='color-row'>
									<cfset is_prod = 0>
								</cfif>
								
								<cfif listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+2,';') eq 1>
									<cfset class_bold ='txtbold'>
									<cfif isdefined("last_main_spec_id")>
										<cfset last_main_spec_id = trim(last_main_spec_id)>
									</cfif>
									<cfif isdefined("last_main_spec_id") and isdefined("total_cost_#last_main_spec_id#")>
										<script>
											<cfif (listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') gt 0 and row_count neq 1) or row_count eq (listlen(evaluate('product_tree_list_#last_stock_id#'),';')/8-1)>
												$("##total_cost_#last_main_spec_id#").html('#tlformat(evaluate("total_cost_#last_main_spec_id#"),4)#');
												$("##total_extra_cost_#last_main_spec_id#").html('#tlformat(evaluate("total_extra_cost_#last_main_spec_id#"),4)#');
												$("##all_total_cost_#last_main_spec_id#").html('#tlformat(evaluate("total_cost_#last_main_spec_id#")+evaluate("total_extra_cost_#last_main_spec_id#"),4)#');
											</cfif>
										</script>
									</cfif>
									<cfset last_main_spec_id = listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')>
								<cfelse>
									<cfset class_bold =''>
								</cfif>
								<cfset row_count = row_count + 1>
								<cfset station_cost = 0>
								<cfif row_count eq 1>
									<cfset last_spec_id = listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')>
									<cfset main_spec_id = listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')>
								<cfelse>
									<cfset last_spec_id = 0>
									<cfset main_spec_id = 0>
								</cfif>
								<tr height="20" class="#_tr_class_#">
									<cfif isdefined("attributes.new_amount_#row_count#") and len(evaluate("attributes.new_amount_#row_count#"))>
										<cfset new_amount_ = filterNum(evaluate("attributes.new_amount_#row_count#"),8)>
									<cfelse>
										<cfset new_amount_ = amount>
									</cfif>
									<cfquery name="GET_PROD_COST" dbtype="query" maxrows="1">
										SELECT 
											* 
										FROM 
											GET_PURCHASE_COST 
										WHERE 
											PRODUCT_ID=#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+7,';')#
											<cfif len(listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')) and session.ep.our_company_info.is_prod_cost_type eq 0>
												AND SPECT_MAIN_ID = #listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')#
											</cfif>
										ORDER BY 
											START_DATE DESC,
											PRODUCT_COST_ID DESC,
											RECORD_DATE DESC
									</cfquery>
									<cfif is_prod eq 1>
										<cfset "total_cost_#trim(listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';'))#" = 0>
										<cfset "total_extra_cost_#trim(listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';'))#" = 0>
										<cfquery name="GET_WORK" dbtype="query">
											SELECT
												*
											FROM
												GET_PROD_WORKSTATION
											WHERE
												STOCK_ID = #listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind,';')#
										</cfquery>
										<cfset station_cost=0>
										<cfif GET_WORK.RECORDCOUNT>
											<cfloop query="GET_WORK"><cfif CAPACITY gt 0 and AVG_COST gt 0><cfset station_cost=station_cost+(AVG_COST/CAPACITY)+(SETUP_TIME*AVG_COST)/60></cfif></cfloop>
											<cfset station_cost=station_cost/GET_WORK.RECORDCOUNT>
										</cfif>
									</cfif> 
									<td class="#class_bold#">#RepeatString('&nbsp;&nbsp;&nbsp;',listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+2,';')-1)##GET_STOCK.STOCK_CODE#</td>
									<td class="#class_bold#">#RepeatString('&nbsp;&nbsp;&nbsp;',listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+2,';')-1)##GET_STOCK.PRODUCT_NAME#</td>
									<td class="#class_bold#"><cfif listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') gt 0>#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')#</cfif></td>
									<td class="#class_bold#" style="text-align:right; mso-number-format:'0';">#TLFormat(wrk_round(new_amount_,8,1),8,0)#</td>
									<td class="#class_bold#">#GET_STOCK.ADD_UNIT#</td>
									<td class="#class_bold#" style="text-align:right;">#TLFormat(GET_STOCK.PRICE,4)#</td>
									<td class="#class_bold#">#GET_STOCK.MONEY#</td>
									<td class="#class_bold#" style="text-align:right;">
										<cfif isdefined('rate_#GET_STOCK.MONEY#') and len(GET_STOCK.MONEY)>
											#TLFormat(GET_STOCK.PRICE*evaluate('rate_#GET_STOCK.MONEY#'))#
										</cfif>
									</td>
									<td class="#class_bold#" style="text-align:right;"><cfif GET_PROD_COST.RECORDCOUNT>#TLFormat(GET_PROD_COST.STANDARD_COST,4)#<cfelse>#TLFormat(0,4)#</cfif></td>
									<td class="#class_bold#" style="text-align:right;"><cfif GET_PROD_COST.RECORDCOUNT>#TLFormat(GET_PROD_COST.STANDARD_COST_RATE,4)#<cfelse>#TLFormat(0,4)#</cfif></td>
									<td class="#class_bold#" style="text-align:right;">
										<cfif GET_PROD_COST.RECORDCOUNT>
											<cfif isdefined("attributes.rate2_info") and attributes.rate2_info eq 1>
												<cfif is_prod eq 0 and is_change_cost eq 1>
													<input type="text" name="new_cost_#row_count#" id="new_cost_#row_count#" class="moneybox" onkeyup="return(FormatCurrency(this,event,4))" value="<cfif isdefined("attributes.new_cost_#row_count#")>#evaluate('attributes.new_cost_#row_count#')#<cfelse>#TLFormat(GET_PROD_COST.PURCHASE_NET_SYSTEM_2,4)#</cfif>">
												<cfelse>	
													#TLFormat(GET_PROD_COST.PURCHASE_NET_SYSTEM_2,4)#
												</cfif>
											<cfelse>
												<cfif is_prod eq 0 and is_change_cost eq 1>
													<input type="text" name="new_cost_#row_count#" id="new_cost_#row_count#" class="moneybox" onkeyup="return(FormatCurrency(this,event,4))" value="<cfif isdefined("attributes.new_cost_#row_count#")>#evaluate('attributes.new_cost_#row_count#')#<cfelse>#TLFormat(GET_PROD_COST.PURCHASE_NET_SYSTEM,4)#</cfif>">
												<cfelse>	
													#TLFormat(GET_PROD_COST.PURCHASE_NET_SYSTEM,4)#
												</cfif>
											</cfif>
										<cfelse>
											<cfif is_prod eq 0 and is_change_cost eq 1>
												<input type="text" name="new_cost_#row_count#" id="new_cost_#row_count#" class="moneybox" onkeyup="return(FormatCurrency(this,event,4))" value="<cfif isdefined("attributes.new_cost_#row_count#")>#evaluate('attributes.new_cost_#row_count#')#<cfelse>#TLFormat(0,4)#</cfif>">
											<cfelse>	
												#TLFormat(0,4)#
											</cfif>
										</cfif>
									</td>
									<td class="#class_bold#" style="text-align:right;">
										<cfif GET_PROD_COST.RECORDCOUNT>
											<cfif isdefined("attributes.rate2_info") and attributes.rate2_info eq 1>
												#TLFormat(GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM_2,4)#
												<cfset row_extra_cost = new_amount_*(GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM_2)>
											<cfelse>
												#TLFormat(GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM,4)#
												<cfset row_extra_cost = new_amount_*(GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM)>
											</cfif>
										<cfelse>
											#TLFormat(0,4)#
											<cfset row_extra_cost = 0>
										</cfif>
									</td>
									<td class="#class_bold#" style="text-align:right;">
										<cfif GET_PROD_COST.RECORDCOUNT>
											<cfset extra_cost = GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM>
											<cfset extra_cost2 = GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM_2>
										<cfelse>
											<cfset extra_cost = 0>
											<cfset extra_cost2 = 0>
										</cfif>
										<cfif isdefined("attributes.rate2_info") and attributes.rate2_info eq 1>
											<cfif isdefined("attributes.new_cost_#row_count#")>
												<cfset row_cost = new_amount_*(filternum(evaluate('attributes.new_cost_#row_count#'),4)+extra_cost2)>
											<cfelse>
												<cfif GET_PROD_COST.RECORDCOUNT>
													<cfset row_cost = new_amount_*(GET_PROD_COST.PURCHASE_NET_SYSTEM_2)>
												<cfelse>
													<cfif isdefined('rate_#GET_STOCK.MONEY#') and len(GET_STOCK.MONEY)>
														<cfset row_cost = GET_STOCK.PRICE*evaluate('rate_#GET_STOCK.MONEY#')>
													<cfelse>
														<cfset row_cost = new_amount_*(GET_STOCK.PRICE)>
													</cfif>
												</cfif>
											</cfif>
										<cfelse>
											<cfif isdefined("attributes.new_cost_#row_count#")>
												<cfset row_cost = new_amount_*(filternum(evaluate('attributes.new_cost_#row_count#'),4)+extra_cost)>
											<cfelse>
												<cfif GET_PROD_COST.RECORDCOUNT>                                	                                 
														<cfset row_cost = new_amount_*(GET_PROD_COST.PURCHASE_NET_SYSTEM)>
												<cfelse>
													<cfif isdefined('rate_#GET_STOCK.MONEY#') and len(GET_STOCK.MONEY)>
														<cfset row_cost = GET_STOCK.PRICE*evaluate('rate_#GET_STOCK.MONEY#')>
													<cfelse>
														<cfset row_cost = new_amount_*(GET_STOCK.PRICE)>
													</cfif>
												</cfif>
											</cfif>
										</cfif>
										
										#TLFormat(row_cost+row_extra_cost,4)#
										<cfif listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+2,';') neq 1 and listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') eq 0>
											<cfloop list="#last_spec_id#" index="kk">
												<cfif kk neq 0>
													<cfset "total_cost_#kk#" = evaluate("total_cost_#kk#") + row_cost>
													<cfset "total_extra_cost_#kk#" = evaluate("total_extra_cost_#kk#") + row_extra_cost>
													<cfif last_main_spec_id neq kk and isdefined("last_main_spec_id") and isdefined("total_cost_#last_main_spec_id#")>
														<cfset "total_cost_#last_main_spec_id#" = evaluate("total_cost_#last_main_spec_id#") + row_cost>
														<cfset "total_extra_cost_#last_main_spec_id#" = evaluate("total_extra_cost_#last_main_spec_id#") + row_extra_cost>
													</cfif>
												</cfif>
											</cfloop>
										</cfif>
									</td>
									<cfloop list="#last_spec_id#" index="kk">
										<script>
											<cfif kk neq 0>
												<cfif (listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') gt 0 and row_count neq 1) or row_count eq (listlen(evaluate('product_tree_list_#last_stock_id#'),';')/8-1)>
													$("##total_cost_#kk#").text('#tlformat(evaluate("total_cost_#kk#"),4)#');
													$("##total_extra_cost_#kk#").text('#tlformat(evaluate("total_extra_cost_#kk#"),4)#');
													$("##all_total_cost_#kk#").text('#tlformat(evaluate("total_cost_#kk#")+evaluate("total_extra_cost_#kk#"),4)#');
												</cfif>
											</cfif>
										</script>
									</cfloop>
									<cfif listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') gt 0>
										<cfset last_spec_id = listappend(last_spec_id,listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';'))>
									</cfif>
									<cfif listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') gt 0>
										<cfset last_spec_id = listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')>
									</cfif>
									<cfif listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+2,';') eq 1 and listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';') gt 0>
										<cfif not listfind(main_spec_id,listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';'))>
											<cfset main_spec_id = listappend(main_spec_id,listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';'))>
										</cfif>
										<cfscript>
											total_rec_cost = total_rec_cost + row_cost;
											gross_total_cost = gross_total_cost + row_cost;
											gross_total_extra_cost = gross_total_extra_cost + row_extra_cost;
										</cfscript>
									<cfelseif listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+2,';') eq 1 and listgetat(evaluate('product_tree_list_#STOCK_ID#'),prd_list_ind+1,';') eq 0>
										<cfscript>
											total_rec_cost = total_rec_cost + row_cost;
											gross_total_cost = gross_total_cost + row_cost;
											gross_total_extra_cost = gross_total_extra_cost + row_extra_cost;
										</cfscript>
									</cfif>
									<cfif is_prod eq 1>
										<td class="#class_bold#" style="text-align:right;" name="total_cost_#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')#" id="total_cost_#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')#">
											<cfif GET_PROD_COST.RECORDCOUNT>
												<cfif isdefined("attributes.rate2_info") and attributes.rate2_info eq 1>
													#TLFormat(GET_PROD_COST.PURCHASE_NET_SYSTEM_2,4)#
												<cfelse>
													#TLFormat(GET_PROD_COST.PURCHASE_NET_SYSTEM,4)#
												</cfif>
											</cfif>
										</td>
										<td class="#class_bold#" style="text-align:right;" name="total_extra_cost_#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')#" id="total_extra_cost_#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')#">
											<cfif GET_PROD_COST.RECORDCOUNT>
												<cfif isdefined("attributes.rate2_info") and attributes.rate2_info eq 1>
													#TLFormat(GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM_2,4)#
												<cfelse>
													#TLFormat(GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM,4)#
												</cfif>
											</cfif>
										</td>
										<td class="#class_bold#" style="text-align:right;"><cfif stock_id eq attributes.stock_id><font color="red"></cfif>#TLFormat(new_amount_*station_cost,4)#<cfif stock_id eq attributes.stock_id></font></cfif></td>
										<td class="#class_bold#" style="text-align:right;" name="all_total_cost_#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')#" id="all_total_cost_#listgetat(evaluate('product_tree_list_#last_stock_id#'),prd_list_ind+1,';')#">
											<cfif GET_PROD_COST.RECORDCOUNT>
												<cfif isdefined("attributes.rate2_info") and attributes.rate2_info eq 1>
													#TLFormat(new_amount_*(GET_PROD_COST.PURCHASE_NET_SYSTEM_2+GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM_2),4)#
												<cfelse>
													#TLFormat(new_amount_*(GET_PROD_COST.PURCHASE_NET_SYSTEM+GET_PROD_COST.PURCHASE_EXTRA_COST_SYSTEM),4)#
												</cfif>
											</cfif>
										</td>
									<cfelse>
										<td class="#class_bold#" colspan="4"></td>
									</cfif>
								</tr>
							</cfloop>
							<cfif isdefined("main_spec_id") and len(main_spec_id)>
								<cfloop list="#main_spec_id#" index="kk">
									<cfif kk neq 0>
										<cfscript>
											total_rec_cost = total_rec_cost + evaluate("total_cost_#kk#");
											gross_total_cost = gross_total_cost + evaluate("total_cost_#kk#");
											gross_total_extra_cost = gross_total_extra_cost + evaluate("total_extra_cost_#kk#");
										</cfscript>
									</cfif>
								</cfloop>
							</cfif>
						</cfoutput>
				</cfif>
				<tr class="color-list">
					<td class="txtboldblue" colspan="13" height="22"><cf_get_lang dictionary_id ='36812.Toplam Birim Maliyeti'></td>
					<td class="txtbold" style="text-align:right;" title="<cf_get_lang dictionary_id ='36854.Ağaçtaki ürünlerin varsa kayıtlı maliyetlerinin yoksa alış fiyatlarının toplamı'>"><cfoutput>#TLFormat(total_rec_cost,4)#</cfoutput></td>
					<td class="txtbold" style="text-align:right;" id="gross_total_extra_cost" title="<cf_get_lang dictionary_id ='36856.Ağaçtaki üretilen ürünlerin  üretim ek maliyeti ile üretilmeyen ürünlerin kayıtlı ek maliyetlerinin toplamı'>"><cfoutput>#TLFormat(gross_total_extra_cost,4)#</cfoutput></td>
					<td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(gross_total_sta_cost,4)#</cfoutput></td>
					<td class="txtbold" style="text-align:right;" id="gross_total_all_cost"><cfoutput>#TLFormat(total_rec_cost+gross_total_extra_cost,4)#</cfoutput></td>
				</tr>
				<cfquery name="GET_WORK" dbtype="query">
					SELECT
						*
					FROM
						GET_PROD_WORKSTATION
					WHERE
						STOCK_ID = <cfqueryparam value="#attributes.stock_id#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset station_cost=0>
				<cfif GET_WORK.RECORDCOUNT>
					<cfoutput query="GET_WORK"><cfif CAPACITY gt 0 and AVG_COST gt 0><cfset station_cost=station_cost+(AVG_COST/CAPACITY)+(SETUP_TIME*AVG_COST)/60></cfif></cfoutput>
					<cfset station_cost=(station_cost/GET_WORK.RECORDCOUNT)>
					<cfif isdefined('rate_#GET_WORK.COST_MONEY#') and len(GET_WORK.COST_MONEY)>
						<cfset station_cost=station_cost*evaluate('rate_#GET_WORK.COST_MONEY#')>
					</cfif>
				</cfif>
				<tr class="color-list">
					<td class="txtboldblue" colspan="16" height="22"><cf_get_lang dictionary_id ='36814.Kullanılan Ürün İstasyon Maliyeti'></td>
					<td align="right" class="txtbold" id="td_gross_station_cost" style="text-align:right;"><font color="red"><cfoutput>#TLFormat(station_cost,4)#</cfoutput></font></td>
				</tr>
				<tr class="color-list">
					<td class="txtboldblue" colspan="16" height="22"><cf_get_lang dictionary_id='36627.Kullanılan Ürün Toplam Maliyeti'></td>
					<td align="right" class="txtbold" id="td_gross" style="text-align:right;"><cfoutput>#TLFormat(total_rec_cost+gross_total_extra_cost+station_cost,4)#</cfoutput></td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="20"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>

			

<script language="javascript">
	function change_amount(row_no)
	{
		<cfif is_change_amount eq 1>
			if(eval('document.all.new_amount_'+row_no) != undefined && list_getat(eval('document.all.alternative_product_'+row_no).value,2,';') != 0)
			{
				eval('document.all.new_amount_'+row_no).value = commaSplit(list_getat(eval('document.all.alternative_product_'+row_no).value,2,';'),8);
			}
		</cfif>
		<cfif is_change_cost eq 1>
			if(eval('document.all.new_cost_'+row_no) != undefined)
			{
				eval('document.all.new_cost_'+row_no).value = commaSplit(list_getat(eval('document.all.alternative_product_'+row_no).value,3,';'),4);
			}
		</cfif>
	}
</script>
