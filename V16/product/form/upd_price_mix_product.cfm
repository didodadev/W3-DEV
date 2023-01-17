<cfinclude template="../query/get_money.cfm">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.p_product_id" default="">
<cfparam name="attributes.product_model_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.product_model_id" default="">
<cfparam name="attributes.product_model_name" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset pageHead = "#getLang('product',456)# #getLang('product',379)#">
<cf_catalystHeader>
	<cf_box title="#getLang('','settings',34010)#">
<cf_basket_form id="product_prices">
<cfform name="search_product" method="post" action="#request.self#?fuseaction=product.collacted_product_prices&event=upd-mix">
	<cf_box_elements>
	<input type="hidden" name="form_varmi" id="form_varmi" value="1">
	<div class="row"> 
		<div class="col col-12 uniqueRow"> 		
			<div class="row formContent">
				<div class="row" type="row">
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-product_name">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="p_product_id" id="p_product_id" value="<cfif isdefined("attributes.p_product_id") and len(attributes.p_product_id)><cfoutput>#attributes.p_product_id#</cfoutput></cfif>" >
									<input name="product_name" type="text" id="product_name" style="width:150px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','p_product_id','','3','130',true,'test()');" value="<cfif isdefined("attributes.product_name") and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=search_product.p_product_id&field_name=search_product.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(search_product.product_name.value),'list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-brand_name">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<cf_wrk_brands form_name='search_product' brand_id='brand_id' brand_name='brand_name'>
									<input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined("attributes.brand_id")><cfoutput>#attributes.brand_id#</cfoutput></cfif>">
									<input type="text" name="brand_name" id="brand_name" value="<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)><cfoutput>#attributes.brand_name#</cfoutput></cfif>" onKeyUp="get_brand();" style="width:150px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=search_product.brand_id&brand_name=search_product.brand_name&keyword='+encodeURIComponent(document.search_product.brand_name.value)</cfoutput>,'small');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-product_cat">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
									<input type="text" name="product_cat" id="product_cat" style="width:150px;" value="<cfoutput>#attributes.product_cat#</cfoutput>">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=3&field_id=search_product.product_catid&field_name=search_product.product_cat&keyword='+encodeURIComponent(document.search_product.product_cat.value)</cfoutput>);" title="<cf_get_lang dictionary_id ='58730.Ürün Kategorisi Seç'>!"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-product_model_name">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="product_model_id" id="product_model_id" value="<cfif len(attributes.product_model_name)><cfoutput>#attributes.product_model_id#</cfoutput></cfif>">
									<input type="text" name="product_model_name" id="product_model_name" value="<cfif len(attributes.product_model_name)><cfoutput>#attributes.product_model_name#</cfoutput></cfif>" style="width:150px;" onfocus="AutoComplete_Create('product_model_name','MODEL_NAME','MODEL_NAME','get_product_model','0','MODEL_ID,MODEL_NAME','product_model_id,product_model_name','','3','130','','1');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_product_model&model_id=search_product.product_model_id&model_name=search_product.product_model_name&keyword='+encodeURIComponent(document.search_product.product_model_name.value)</cfoutput>,'list');" title="<cf_get_lang dictionary_id='58225.Model'>"></span>
								</div>
							</div>
						</div>
					</div>
				</div>	
				<div class="row formContentFooter">	
					<div class="col col-12 text-right"><cf_wrk_search_button button_type='1' is_excel='0'></div> 
				</div>
			</div>
		</div>
	</div>
</cf_box_elements>
</cfform>
</cf_basket_form>
<cfif IsDefined("attributes.form_varmi") and len (attributes.p_product_id)>
<cfform name="form_add_price" method="post" action="#request.self#?fuseaction=product.emptypopupupd_price_mix_product&product_id=#attributes.p_product_id#">
	<cf_basket id="product_prices_bask">
		<cf_grid_list id="fiyat">
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='30108.Referans Fiyat'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<th><cf_get_lang dictionary_id='37467.Karma Koli'> <cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				</tr>
			</thead>
			<tbody>         
				<cfquery name="get_mix_prod_price" datasource="#DSN1#">
					SELECT
						KP.ENTRY_ID,
						KP.KARMA_PRODUCT_ID,
						KP.PRODUCT_NAME,
						S.BARCOD,
						PC.PRODUCT_CAT,
						KP.PRODUCT_NAME+ ' ' +S.PROPERTY AS 'URUN',
						KP.SALES_PRICE,
						KP.MONEY,
						KP.UNIT
					FROM 
						KARMA_PRODUCTS KP
						INNER JOIN PRODUCT P ON P.PRODUCT_ID = KP.PRODUCT_ID
						INNER JOIN PRODUCT_CAT PC ON PC.PRODUCT_CATID = P.PRODUCT_CATID
						INNER JOIN STOCKS S ON KP.STOCK_ID =S.STOCK_ID 
					WHERE 
						
							KP.KARMA_PRODUCT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_product_id#"> 
						<cfif isdefined("attributes.product_catid") and isdefined("attributes.product_cat") and len (attributes.product_catid) and len (attributes.product_cat)>
							AND PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
						</cfif>
						<cfif isdefined("attributes.brand_name") and isdefined("attributes.brand_id") and len (attributes.brand_id) and len (attributes.brand_name)>
							AND P.BRAND_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> 
						</cfif>
						<cfif isdefined("attributes.product_model_id") and isdefined("attributes.product_model_name") and len (attributes.product_model_id) and len (attributes.product_model_name)>
							AND P.BRAND_ID ==<cfqueryparam cfsqltype="cf_sql_integer" value=" #attributes.product_model_id#"> 
						</cfif>
				</cfquery>
				<cfparam name="attributes.totalrecords" default="#get_mix_prod_price.recordcount#">
				<input type ="hidden" name="record_count" id="record_count" value="<cfoutput>#get_mix_prod_price.recordcount#</cfoutput>">
					<cfset s_total=0>
				<cfoutput query="get_mix_prod_price">
					<tr>
						<td>#currentrow#</td>
						<td>#URUN#</td>
						<td>#BARCOD#</td>
						<td>#PRODUCT_CAT#</td>
						<td>#UNIT#</td>
						<td>
							<cfset s_total=s_total + #SALES_PRICE#>
							#tlformat(SALES_PRICE,2)#
						</td>
						<td>#get_mix_prod_price.MONEY#</td>
						<td>
							<input type="hidden" name="entry_id#currentrow#" id="entry_id#currentrow#" value="#ENTRY_ID#">               	   	
							<input name="new_price#currentrow#" id="new_price#currentrow#" value="#TLFormat(SALES_PRICE,2)#" class="box" style="width:100px;" onKeyUp="return(FormatCurrency(this,event));">
						</td>
						<td>
							<select name="p_money#currentrow#" id="p_money#currentrow#" onChange="hesapla_row(2,#currentrow#);">
									<cfloop query="get_money">
										<option value="#money#;#rate2#" <cfif get_money.money eq get_mix_prod_price.money>selected</cfif>>#money#</option>
									</cfloop>
							</select>			
						</td>	
					
					</tr>   
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<div class="row text-right"> 
			<div class="col col-12 form-inline">
		
						<cfquery name="GET_PRICE" datasource="#DSN3#">
							SELECT
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
								PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
								PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
								PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_product_id#">
						</cfquery>
					<!---<cfinput type="text" name="STANDART_SATIS" id="STANDART_SATIS" class="moneybox"  passthrough="onkeyup=""return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));""" value="#TLFormat(get_price.price,session.ep.our_company_info.sales_price_round_num)#" style="width:100px;">		--->		
					
						<div class="form-group">
							<cfinput type="text" name="total" id="total" value="#s_total#">
						</div><div class="form-group">
							<select name="f_money" id="f_money" onChange="hesapla_row(3,1);">
							<cfoutput query="get_money">
								<option value="#money#;#rate2#">#money#</option>
							</cfoutput>
							</select>
						</div><div class="form-group">
						<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Güncelle' add_function='gonder1(1)'>
						</div>
					</div></div>
	</cf_basket>
</cfform>
<cfset url_str = "">
    <cfif isdefined("attributes.p_product_id") and len(attributes.p_product_id)>
        <cfset url_str = "#url_str#&p_product_id=#attributes.p_product_id#">
    </cfif>
    <cfif isdefined("attributes.product_name") and len(attributes.product_name)>
        <cfset url_str = "#url_str#&product_name=#attributes.product_name#">
    </cfif>
     <cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
        <cfset url_str = "#url_str#&p_product_id=#attributes.p_product_id#">
    </cfif>
    <cfif isdefined("attributes.brand_name") and len(attributes.brand_name)>
        <cfset url_str = "#url_str#&product_name=#attributes.product_name#">
    </cfif>
     <cfif isdefined("attributes.product_model_id") and len(attributes.product_model_id)>
        <cfset url_str = "#url_str#&p_product_id=#attributes.p_product_id#">
    </cfif>
    <cfif isdefined("attributes.product_model_name") and len(attributes.product_model_name)>
        <cfset url_str = "#url_str#&product_name=#attributes.product_name#">
    </cfif>
     <cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
        <cfset url_str = "#url_str#&product_catid=#attributes.product_catid#">
    </cfif>
     <cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
        <cfset url_str = "#url_str#&product_cat=#attributes.product_cat#">
    </cfif>
    <cfset url_str = "#url_str#&form_varmi=1">
    <cf_paging 
	    name="deneme"
	    page="#attributes.page#"
	    maxrows="#attributes.maxrows#"
	    totalrecords="#attributes.TOTALRECORDS#"
	    startrow="#attributes.startrow#"
	    adres="product.upd_price_mix_product.cfm#url_str#">
</cfif>
</cf_box> 
<script>	
	function calculate_grosstotal(type)
	{		
		document.form_basket.grosstotal_cost.value = 0;
		document.form_basket.grosstotal_price.value = 0;
		var row_count=<cfoutput>#GET_MONEY.RECORDCOUNT#</cfoutput>
		for(ix=1;ix<row_count+1;ix++){							
			<cfloop query=GET_MONEY>
				if(type =='<cfoutput>#GET_MONEY.MONEY#</cfoutput>')
				{
				document.form_basket.grosstotal_price.value = commaSplit(Number(filterNum(document.form_basket.grosstotal_price.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')) + Number(filterNum(eval("document.form_basket.total_product_price"+ix).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'))/<cfoutput>#GET_MONEY.RATE2[currentrow]#</cfoutput>,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
				}
			</cfloop>
			document.form_basket.selected_money.value=type;			
		}
	}	
	function hesapla_row(type,row_info)
	{		
		if(type==2)
		{
			var k= parseFloat(filterNum($('#new_price'+row_info).val(),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
			var m=eval(document.getElementById('total').value)-eval(k);
			form_value_rate_satir = list_getat(eval("document.getElementById('p_money" + row_info + "')").value,2,';');
			p=eval(form_value_rate_satir) * eval(k);
			$('#total').val()=(eval(m)+ eval(p));
			//document.getElementById('total').value=(eval(m)+ eval(p));
	    }
	    if(type==3)
	    {
		   	form_value_rate_foot = list_getat(eval("document.getElementById('f_money')").value,2,';');
		   	var k= parseFloat(filterNum($('#total').val(),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
		   //	var c=document.getElementById('total').value;
			var c=$('#total').val();
		 	p=form_value_rate_foot *c;
			$('#total').val()=p;
		 	//document.getElementById('total').value =p; 
		}
	}
</script>
