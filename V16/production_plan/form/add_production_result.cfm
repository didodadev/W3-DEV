<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="prod.upd_prod_order_result">
<cfparam name="attributes.other_amount" default="1">
<cfif not isdefined('attributes.seri_list')>
  <cfset attributes.seri_list = ''>
</cfif>
<form name="add_product" method="post" action="">
	<input type="hidden" name="seri_list" id="seri_list" value="<cfoutput>#attributes.seri_list#</cfoutput>">
	<div class="ui-form-list ui-form-block">
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12 pl-0">
			<div class="form-group">
				<label><cf_get_lang dictionary_id='57635.Miktar'></label>
				<input name="other_amount" id="other_amount" type="text" value="<cfoutput>#TlFormat(attributes.other_amount,3)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,3));" class="moneybox">
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="form-group">
				<label><cf_get_lang dictionary_id='36769.Barkod dan Ürün Ekle'></label>
				<input name="other_barcod" id="other_barcod" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_barkod_serial();}">
			</div>
		</div>
		<cfif isdefined("attributes.type")>
			<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
				<div class="form-group">
					<input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>">
					<label><cf_get_lang dictionary_id='36770.Seri Nodan Ürün Ekle'></label> 
					<input name="serial_number" id="serial_number" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_barkod_serial();}">
				</div>
			</div>
		</cfif>
		<input type="hidden" name="product_cost_date" id="product_cost_date" value=""><!--- Satıra Ürün Eklenirken Maliyeti Üretim Sonucunun Bitiş Tarihine Göre HEsaplaması için eklendi.M.ER --->
	</div>
</form>
<script type="text/javascript">
	function add_barkod_serial()
	{
		document.add_product.other_amount.value = filterNum(document.add_product.other_amount.value,3);
		document.getElementById('product_cost_date').value=parent.document.getElementById('finish_date').value;
		add_product.submit();
		return true;
	}
</script>
<cfif (isdefined("form.other_barcod") and len(form.other_barcod))>
  <cf_date tarih = "attributes.product_cost_date">
  <cfif len(attributes.other_barcod)>
	<cfquery name="GET_PRODUCT_DETAIL" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
			S._ID,
			S.PRODUCT_ID,
			S._CODE,
			PRODUCT.PRODUCT_NAME,
			S.PROPERTY,
			S.BARCOD AS BARCOD,
			PRODUCT.TAX AS TAX,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.IS_SERIAL_NO,
			PRODUCT.IS_PRODUCTION,
			PRODUCT.TAX,<!--- PRODUCT.TAX_PURCHASE, --->
			PRODUCT.IS_INVENTORY,
			S.MANUFACT_CODE,
			S.PRODUCT_UNIT_ID,
			GSB.BARCODE,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.DIMENTION,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY
		FROM
			PRODUCT,
			S,
			GET__BARCODES AS GSB,
			PRODUCT_UNIT,
			PRICE_STANDART
		WHERE	
			PRICE_STANDART.PURCHASESALES = 0 AND
			PRICE_STANDART.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
			PRODUCT.PRODUCT_STATUS = 1 AND
			S._STATUS = 1 AND
			PRODUCT.PRODUCT_ID = S.PRODUCT_ID AND
			S._ID = GSB._ID AND
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
			GSB.BARCODE = '#attributes.other_barcod#'
	</cfquery>
	<cfif get_product_detail.recordcount>
		<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
			SELECT 
				PRODUCT_COST_ID,
				PURCHASE_NET,
				PURCHASE_NET_MONEY,
				PURCHASE_NET_SYSTEM,
				PURCHASE_NET_SYSTEM_2,
				PURCHASE_NET_SYSTEM_MONEY,
				PURCHASE_EXTRA_COST,
				PURCHASE_EXTRA_COST_SYSTEM,
				PURCHASE_EXTRA_COST_SYSTEM_2,
				PRODUCT_COST,
				MONEY 
			FROM 
				PRODUCT_COST 
			WHERE 
				PRODUCT_ID = #get_product_detail.product_id# AND
				START_DATE < #attributes.product_cost_date# 
			ORDER BY 
				START_DATE DESC,
				RECORD_DATE DESC
		</cfquery>
	</cfif>
	<cfscript>
		if(isdefined("get_product_cost.recordcount") and get_product_cost.recordcount)
		{
			cost_id = GET_PRODUCT_COST.product_cost_id;
			purchase_extra_cost = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
			product_cost = GET_PRODUCT_COST.PRODUCT_COST;
			product_cost_money = GET_PRODUCT_COST.MONEY;
			cost_price = GET_PRODUCT_COST.PURCHASE_NET;
			cost_price_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
			cost_price_2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_2;
			cost_price_money_2 = session.ep.money2;
			cost_price_system = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
			cost_price_system_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
			purchase_extra_cost_system = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
			purchase_extra_cost_system_2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2;
		}
		else
		{
			cost_id = 0;
			purchase_extra_cost = 0;
			product_cost = 0;
			product_cost_money = session.ep.money;
			cost_price = 0;
			cost_price_money = session.ep.money;
			cost_price_2 = 0;
			cost_price_money_2 = session.ep.money2;
			cost_price_system = 0;
			cost_price_system_money = session.ep.money;
			purchase_extra_cost_system = 0;			
			purchase_extra_cost_system_2 = 0;		
		}
		if(session.ep.period_year gt 2008){
			if(cost_price_money is 'YTL') cost_price_money = 'TL';
			if(product_cost_money is 'YTL') product_cost_money = 'TL';
			if(cost_price_system_money is 'YTL') cost_price_system_money = 'TL';
		}
		if(session.ep.period_year lt 2009){
			if(cost_price_money is 'TL') cost_price_money = 'YTL';
			if(product_cost_money is 'TL') product_cost_money = 'YTL';
			if(cost_price_system_money is 'TL') cost_price_system_money = 'YTL';
		}
	</cfscript>
	<cfif get_product_detail.recordcount>
	    <cfparam name="attributes.spec_name" default="">
    	<script type="text/javascript">
			<cfoutput>
			var SPECT_MAIN_ID ='';
			var spect_name ='';
			var deger = workdata('get_main_spect_id','#get_product_detail._id#');
			if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz related_spect_main_id'yi
				SPECT_MAIN_ID = deger.SPECT_MAIN_ID; 
			if(SPECT_MAIN_ID!=""){
				getSpecNameQuery = wrk_safe_query('prdp_getSpecName','dsn3',0,SPECT_MAIN_ID);
				spect_name =getSpecNameQuery.SPECT_MAIN_NAME;
			}	
			</cfoutput>
        </script>
	  <cfif isdefined("attributes.type") and attributes.type eq 'outage'>
	  	<script type="text/javascript">
		<cfoutput>																																																																																																																																																					
			parent.add_row_outage('#get_product_detail._id#','#get_product_detail.product_id#','#get_product_detail._code#','#get_product_detail.product_name#','#get_product_detail.property#','#get_product_detail.barcode#','#get_product_detail.main_unit#','#get_product_detail.product_unit_id#','#TLformat(attributes.other_amount,3)#','#get_product_detail.tax#','#cost_id#','#tlformat(cost_price,round_number)#','#cost_price_money#','#tlformat(cost_price_2,round_number)#','#tlformat(purchase_extra_cost_system_2,round_number)#','#cost_price_money_2#','#cost_price_system#','#cost_price_system_money#','#tlformat(purchase_extra_cost,round_number)#','#purchase_extra_cost_system#','#product_cost#','#product_cost_money#','','#get_product_detail.is_production#','#get_product_detail.dimention#',SPECT_MAIN_ID,spect_name);
		</cfoutput>
		</script>
	  <cfelseif isdefined("attributes.type")>
		<script type="text/javascript">
		<cfoutput>
			parent.add_row_exit('#get_product_detail._id#','#get_product_detail.product_id#','#get_product_detail._code#','#get_product_detail.product_name#','#get_product_detail.property#','#get_product_detail.barcode#','#get_product_detail.main_unit#','#get_product_detail.product_unit_id#','#TLformat(attributes.other_amount,3)#','#get_product_detail.tax#','#cost_id#','#tlformat(cost_price,round_number)#','#cost_price_money#','#tlformat(cost_price_2,round_number)#','#tlformat(purchase_extra_cost_system_2,round_number)#','#cost_price_money_2#','#cost_price_system#','#cost_price_system_money#','#tlformat(purchase_extra_cost,round_number)#','#purchase_extra_cost_system#','#product_cost#','#product_cost_money#','','#get_product_detail.is_production#','#get_product_detail.dimention#',SPECT_MAIN_ID,spect_name);
		</cfoutput>
		</script>
	  <cfelse>
		<script type="text/javascript">
		<cfoutput>
		 	parent.add_row('#get_product_detail._id#','#get_product_detail.product_id#','#get_product_detail._code#','#get_product_detail.product_name#','#get_product_detail.property#','#get_product_detail.barcode#','#get_product_detail.main_unit#','#get_product_detail.product_unit_id#','#TLFormat(attributes.other_amount,3)#','#get_product_detail.tax#','#cost_id#','#tlformat(cost_price,round_number)#','#cost_price_money#','#tlformat(cost_price_2,round_number)#','#tlformat(purchase_extra_cost_system_2,round_number)#','#cost_price_money_2#','#cost_price_system#','#cost_price_system_money#','#purchase_extra_cost#','#purchase_extra_cost_system#','#product_cost#','#product_cost_money#','','#get_product_detail.is_production#','#get_product_detail.dimention#',SPECT_MAIN_ID,spect_name);																																																																																																																																																					
		</cfoutput>
		</script>
	  </cfif>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='36771.Aradığınız Barkod Kayıtlı Değil'> !");
		</script>
	</cfif>
  </cfif>
<cfelseif isdefined("form.serial_number") and len(form.serial_number)>
  <cfif listfind(attributes.seri_list,attributes.serial_number,',')>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='36772.Bu Seri Daha Önce Eklenmişti'> !");			
	</script>
  	<cfexit method="exittemplate">
  </cfif>
  <cfquery name="serino_control_satis" datasource="#dsn3#">
	SELECT
		GUARANTY_ID,
		_ID,
		DEPARTMENT_ID,
		LOCATION_ID,
		SERIAL_NO
	FROM
		SERVICE_GUARANTY_NEW
	WHERE
		IN_OUT = 1 AND
		SERIAL_NO = '#attributes.serial_number#'
  </cfquery>
  <cfif not serino_control_satis.recordcount>
	<script type="text/javascript">
	  alert("<cf_get_lang dictionary_id='36773.Bu Seri Nolu Ürün Satılamaz Durumda'>!");			
	</script>
	<cfexit method="exittemplate">
  <cfelse>
	<cfquery name="GET_PRODUCT_DETAIL" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
		SELECT 
			S._ID,
			S.PRODUCT_ID,
			S._CODE,
			PRODUCT.PRODUCT_NAME,
			S.PROPERTY,
			PRODUCT.IS_PRODUCTION,
			S.BARCOD AS BARCOD,
			PRODUCT.TAX AS TAX,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.IS_SERIAL_NO,
			PRODUCT.TAX_PURCHASE,
			PRODUCT.IS_INVENTORY,
			S.MANUFACT_CODE,
			S.PRODUCT_UNIT_ID,
			GSB.BARCODE,
			PRODUCT_UNIT.ADD_UNIT,
			PRODUCT_UNIT.MAIN_UNIT,
			PRODUCT_UNIT.DIMENTION,
			PRICE_STANDART.PRICE,
			PRICE_STANDART.MONEY
		FROM
			PRODUCT,
			S,
			GET__BARCODES AS GSB,
			PRODUCT_UNIT,
			PRICE_STANDART
		WHERE	
			PRICE_STANDART.PURCHASESALES = 0 AND
			PRICE_STANDART.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
			PRODUCT.PRODUCT_STATUS = 1 AND
			S._STATUS = 1 AND
			PRODUCT.IS_SALES = 1 AND
			PRODUCT.PRODUCT_ID = S.PRODUCT_ID AND
			S._ID = GSB._ID AND
			PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
			S._ID = '#serino_control_satis._id#'
	</cfquery>
	<cfif get_product_detail.recordcount>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT 
					PRODUCT_COST_ID,
					PURCHASE_NET,
					PURCHASE_NET_MONEY,
					PURCHASE_NET_SYSTEM,
					PURCHASE_NET_SYSTEM_2,
					PURCHASE_NET_SYSTEM_MONEY,
					PURCHASE_EXTRA_COST,
					PURCHASE_EXTRA_COST_SYSTEM,
					PURCHASE_EXTRA_COST_SYSTEM_2,
					PRODUCT_COST,
					MONEY 
				FROM 
					PRODUCT_COST 
				WHERE 
					PRODUCT_ID = #get_product_detail.product_id# AND
					START_DATE < #attributes.product_cost_date# 
				ORDER BY 
					START_DATE DESC,
					RECORD_DATE DESC
			</cfquery>
		</cfif>
		<cfscript>
			if(isdefined("get_product_cost.recordcount") and get_product_cost.recordcount)
			{
				cost_id = GET_PRODUCT_COST.product_cost_id;
				purchase_extra_cost = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
				product_cost = GET_PRODUCT_COST.PRODUCT_COST;
				product_cost_money = GET_PRODUCT_COST.MONEY;
				cost_price = GET_PRODUCT_COST.PURCHASE_NET;
				cost_price_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
				cost_price_2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_2;
				cost_price_money_2 = session.ep.money2;
				cost_price_system = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
				cost_price_system_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
				purchase_extra_cost_system = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
				purchase_extra_cost_system_2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_2;
			}
			else
			{
				cost_id = 0;
				purchase_extra_cost = 0;
				product_cost = 0;
				product_cost_money = session.ep.money;
				cost_price = 0;
				cost_price_money = session.ep.money;
				cost_price_2 = 0;
				cost_price_money_2 = session.ep.money2;
				cost_price_system = 0;
				cost_price_system_money = session.ep.money;
				purchase_extra_cost_system = 0;		
				purchase_extra_cost_system_2 = 0;			
			}
			if(session.ep.period_year gt 2008){
				if(cost_price_money is 'YTL') cost_price_money = 'TL';
				if(product_cost_money is 'YTL') product_cost_money = 'TL';
				if(cost_price_system_money is 'YTL') cost_price_system_money = 'TL';
			}
			if(session.ep.period_year lt 2009){
				if(cost_price_money is 'TL') cost_price_money = 'YTL';
				if(product_cost_money is 'TL') product_cost_money = 'YTL';
				if(cost_price_system_money is 'TL') cost_price_system_money = 'YTL';
			}
		</cfscript>
	<cfset attributes.seri_list = ListAppend(attributes.seri_list,attributes.serial_number,',')>
	<script type="text/javascript">
		document.add_product.seri_list.value = <cfoutput>'#attributes.seri_list#'</cfoutput>
	</script>
    <cfparam name="attributes.spec_name" default="">
    <script type="text/javascript">
        <cfoutput>
        var SPECT_MAIN_ID ='';
        var spect_name ='';
        var deger = workdata('get_main_spect_id','#get_product_detail._id#');
        if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz related_spect_main_id'yi
            SPECT_MAIN_ID = deger.SPECT_MAIN_ID; 
        if(SPECT_MAIN_ID!=""){
		
            getSpecNameQuery = wrk_safe_query('prdp_getSpecName','dsn3',0,SPECT_MAIN_ID);
            spect_name =getSpecNameQuery.SPECT_MAIN_NAME;
        }	
        </cfoutput>
    </script>
	<cfif isdefined("attributes.type") and attributes.type eq 'outage'>
	  	<script type="text/javascript">
		<cfoutput>
			parent.add_row_outage('#get_product_detail._id#','#get_product_detail.product_id#','#get_product_detail._code#','#get_product_detail.product_name#','#get_product_detail.property#','#get_product_detail.barcode#','#get_product_detail.main_unit#','#get_product_detail.product_unit_id#','#attributes.other_amount#','#get_product_detail.tax#','#cost_id#','#tlformat(cost_price)#','#cost_price_money#','#tlformat(cost_price_2)#','#tlformat(purchase_extra_cost_system_2)#','#cost_price_money_2#','#cost_price_system#','#cost_price_system_money#','#tlformat(purchase_extra_cost)#','#purchase_extra_cost_system#','#product_cost#','#product_cost_money#','#serino_control_satis.serial_no#','#get_product_detail.is_production#','#get_product_detail.dimention#',SPECT_MAIN_ID,spect_name);
		</cfoutput>
		</script>
	<cfelse>
		<script type="text/javascript">
		<cfoutput>
			parent.add_row_exit('#get_product_detail._id#','#get_product_detail.product_id#','#get_product_detail._code#','#get_product_detail.product_name#','#get_product_detail.property#','#get_product_detail.barcode#','#get_product_detail.main_unit#','#get_product_detail.product_unit_id#','#attributes.other_amount#','#get_product_detail.tax#','#cost_id#','#tlformat(cost_price)#','#cost_price_money#','#tlformat(cost_price_2)#','#tlformat(purchase_extra_cost_system_2)#','#tlformat(purchase_extra_cost_system_2)#','#cost_price_money_2#','#cost_price_system#','#cost_price_system_money#','#tlformat(purchase_extra_cost)#','#purchase_extra_cost_system#','#product_cost#','#product_cost_money#','#serino_control_satis.serial_no#','#get_product_detail.is_production#','#get_product_detail.dimention#',SPECT_MAIN_ID,spect_name);
		</cfoutput>
		</script>
	</cfif>
  </cfif>
</cfif>
