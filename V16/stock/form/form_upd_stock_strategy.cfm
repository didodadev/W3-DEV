<cfsetting showdebugoutput="no">
<cfquery name="GET_PROD_STOCKS" datasource="#dsn3#">
	SELECT 
        S.STOCK_ID,
        #dsn#.Get_Dynamic_Language(PRODUCT.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT.PRODUCT_NAME) AS PRODUCT_NAME,
		S.PROPERTY,
        S.STOCK_CODE,
        S.BARCOD,
        S.RECORD_EMP,
        S.RECORD_DATE,
        S.UPDATE_EMP,
        S.UPDATE_DATE
	FROM 
		STOCKS S,
        PRODUCT
	WHERE
        PRODUCT.PRODUCT_ID = S.PRODUCT_ID AND
		S.PRODUCT_ID = #attributes.pid#
</cfquery>
<cfquery name="GET_UNITS" datasource="#dsn3#">
	SELECT PRODUCT_UNIT_ID,ADD_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND PRODUCT_UNIT_STATUS = 1
</cfquery>
<cfquery name="GET_SALEABLE_STOCK_ACTION" datasource="#DSN3#">
	SELECT STOCK_ACTION_ID,STOCK_ACTION_NAME FROM SETUP_SALEABLE_STOCK_ACTION
</cfquery>
 <form name="add_stock_str" id="add_stock_str" action="<cfoutput>#request.self#?fuseaction=stock.emptypopup_upd_stock_strategy</cfoutput>">
    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
    <input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_prod_stocks.recordcount#</cfoutput>">
    <cf_grid_list>
        <thead>
            <tr>
                <th width="20">&nbsp;</td>
                <th><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
                <th><cf_get_lang dictionary_id ='57657.Ürün'></th>
                <th style="min-width:50px;"><cf_get_lang dictionary_id='45232.Strateji Türü'>*</th>
                <th><cf_get_lang dictionary_id='45203.Maksimum stok'>*</th>
                <th><cf_get_lang dictionary_id='45206.minumum stok'>*</th>
                <th><cf_get_lang dictionary_id='58882.Bloke Stok'></th>
                <th ><cf_get_lang dictionary_id='45205.yeniden sip noktası'>*</th>
                <th style="min-width:120px;"><cf_get_lang dictionary_id='45233.Minimum Sipariş Miktarı'>*</th>
                <th style="min-width:120px;"><cf_get_lang dictionary_id='45399.Maksimum Sipariş Miktarı'></th>
                <th  style="min-width:110px;"><cf_get_lang dictionary_id ='45707.Sipariş Tipi'></th>
                <th><cf_get_lang dictionary_id='45204.tedarik süresi'>*</th>
                <th><i style="font-size:12px;color:red !important;" class="icon-warning" title="<cf_get_lang dictionary_id ='45210.Yeniden Sipariş Noktasında Uyar'>"></i></th>
                <th style="min-width:140px;"><cf_get_lang dictionary_id ='58747.Satılabilir Stok Prensipleri'></th>
            </tr>
        </thead>
        <cfif get_prod_stocks.recordcount>
          <cfoutput query="get_prod_stocks">
            <cfquery name="GET_STOCK_STRATEGY" datasource="#dsn3#" maxrows="1">
                SELECT 
        	        STOCK_STRATEGY_ID, 
                    PRODUCT_ID, 
                    STOCK_ID, 
                    MAXIMUM_STOCK, 
                    PROVISION_TIME, 
                    REPEAT_STOCK_VALUE, 
                    MINIMUM_STOCK, 
                    MINIMUM_ORDER_STOCK_VALUE,
                    MINIMUM_ORDER_UNIT_ID, 
                    CRITERION_ID, 
                    ADD_FACTOR_ID, 
                    IS_LIVE_ORDER, 
                    DEPARTMENT_ID, 
                    STRATEGY_TYPE, 
                    STRATEGY_ORDER_TYPE, 
                    BLOCK_STOCK_VALUE, 
                    STOCK_ACTION_ID, 
                    MAXIMUM_ORDER_STOCK_VALUE, 
                    MAXIMUM_ORDER_UNIT_ID, 
                    RETURN_BLOCK_VALUE, 
                    RECORD_DATE, 
                    RECORD_EMP, 
                    RECORD_IP 
                FROM 
    	            STOCK_STRATEGY 
                WHERE 
	                STOCK_ID = #get_prod_stocks.stock_id# AND DEPARTMENT_ID IS NULL ORDER BY STOCK_STRATEGY_ID DESC
            </cfquery>                  
            <input type="hidden" name="row_stock_id_#get_prod_stocks.currentrow#" id="row_stock_id_#get_prod_stocks.currentrow#" value="#stock_id#">
            <tbody>
                <tr>
                    <td width="20"><cfif not listfindnocase(denied_pages,'stock.popup_list_departments_stock_strategy')><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=stock.popup_list_departments_stock_strategy&pid=#attributes.pid#&sid=#get_prod_stocks.stock_id#');"><i class="icon-question"  style="font-size:12px;color:##FF0000 !important;" title="<cf_get_lang dictionary_id='45393.depo bazında Strateji'>" border="0"></i></a></cfif></td>
                    <td>#STOCK_CODE#</td>
                    <td nowrap="nowrap">#PRODUCT_NAME# #PROPERTY#</td>
                    <td>
                        <div class="form-group">
                            <select name="strategy_type_#get_prod_stocks.currentrow#" id="strategy_type_#get_prod_stocks.currentrow#">
                                <option value="1" <cfif get_stock_strategy.STRATEGY_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
                                <option value="0" <cfif get_stock_strategy.STRATEGY_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id='57636.Birim'></option>
                            </select>
                        </div>
                    </td>
                    <td style="text-align:right;"><input type="text" name="maximum_stock_#get_prod_stocks.currentrow#" id="maximum_stock_#get_prod_stocks.currentrow#" value="#TLFormat(get_stock_strategy.MAXİMUM_STOCK)#" style="width:70px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td style="text-align:right;"><input type="text" name="minimum_stock_#get_prod_stocks.currentrow#" id="minimum_stock_#get_prod_stocks.currentrow#" value="#TLFormat(get_stock_strategy.MINIMUM_STOCK)#" style="width:70px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td style="text-align:right;"><input type="text" name="blk_st_val_#get_prod_stocks.currentrow#" id="blk_st_val_#get_prod_stocks.currentrow#" value="#TLFormat(get_stock_strategy.BLOCK_STOCK_VALUE)#" style="width:70px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td style="text-align:right;"><input type="text" name="rpt_st_val_#get_prod_stocks.currentrow#" id="rpt_st_val_#get_prod_stocks.currentrow#" value="#TLFormat(get_stock_strategy.REPEAT_STOCK_VALUE)#" style="width:70px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td nowrap style="text-align:right;">   
                        <div class="form-group">
                        <div class="col col-6">
                        <cfsavecontent variable="message3"><cf_get_lang dictionary_id='45570.Minimum Sipariş Miktarı Değerini Kontrol Ediniz'> !</cfsavecontent>
                        <input type="text" name="min_ord_st_val_#get_prod_stocks.currentrow#" id="min_ord_st_val_#get_prod_stocks.currentrow#" value="#TLFormat(get_stock_strategy.MINIMUM_ORDER_STOCK_VALUE)#" class="moneybox" required="yes" message="#message3#" onkeyup="return(formatcurrency(this,event));">
                    </div> <div class="col col-6">
                        <select name="min_ord_unt_id_#get_prod_stocks.currentrow#" id="min_ord_unt_id_#get_prod_stocks.currentrow#">
                            <cfloop query="GET_UNITS">
                                <option value="#GET_UNITS.PRODUCT_UNIT_ID#" <cfif get_stock_strategy.MINIMUM_ORDER_UNIT_ID eq GET_UNITS.PRODUCT_UNIT_ID>selected</cfif>>#GET_UNITS.add_unit#</option>
                            </cfloop>
                        </select>
                    </div></div>
                    </td>
                    <td nowrap style="text-align:right;">    
                        <div class="form-group">
                        <div class="col col-6">
                        <input type="text" name="max_ord_st_val_#get_prod_stocks.currentrow#" id="max_ord_st_val_#get_prod_stocks.currentrow#" value="#TLFormat(get_stock_strategy.MAXIMUM_ORDER_STOCK_VALUE)#" class="moneybox"  onkeyup="return(formatcurrency(this,event));">
                    </div><div class="col col-6">
                        <select name="max_ord_unt_id_#get_prod_stocks.currentrow#" id="max_ord_unt_id_#get_prod_stocks.currentrow#" >
                            <cfloop query="GET_UNITS">
                                <option value="#GET_UNITS.PRODUCT_UNIT_ID#" <cfif get_stock_strategy.MAXIMUM_ORDER_UNIT_ID eq GET_UNITS.PRODUCT_UNIT_ID>selected</cfif>>#GET_UNITS.add_unit#</option>
                            </cfloop>
                        </select>
                    </div> </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <select name="strgy_ord_typ_#get_prod_stocks.currentrow#" id="strgy_ord_typ_#get_prod_stocks.currentrow#">
                                <option value="" <cfif not len(get_stock_strategy.STRATEGY_ORDER_TYPE)>selected</cfif>><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                <option value="0" <cfif len(get_stock_strategy.STRATEGY_ORDER_TYPE) and get_stock_strategy.STRATEGY_ORDER_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id ='45706.Artarak Devam'></option>
                                <option value="1" <cfif len(get_stock_strategy.STRATEGY_ORDER_TYPE) and get_stock_strategy.STRATEGY_ORDER_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id ='45705.Katları Şeklinde'></option>
                            </select>
                        </div>
                    </td>
                    <td nowrap style="text-align:right;">
                        <cfsavecontent variable="message4"><cf_get_lang dictionary_id='45571.Tedarik Süresi Değerini Kontrol Ediniz'>!</cfsavecontent>
                        <input type="text" name="prov_tm_#get_prod_stocks.currentrow#" id="prov_tm_#get_prod_stocks.currentrow#" value="#TLFormat(get_stock_strategy.provision_time,0)#" style="width:30px;" class="moneybox" message="#message4#" onkeyup="return(FormatCurrency(this,event,0));">&nbsp;<cf_get_lang dictionary_id='57490.Gün'> 
                    </td>
                    <td style="text-align:center;"><input type="checkbox" name="is_live_order_#get_prod_stocks.currentrow#" id="is_live_order_#get_prod_stocks.currentrow#" value="1" <cfif get_stock_strategy.IS_LIVE_ORDER is 1>checked</cfif>></td>
                    <td>
                        <div class="form-group">
                    <select name="salable_st_act_id_#get_prod_stocks.currentrow#" id="salable_st_act_id_#get_prod_stocks.currentrow#">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>!</option>
                        <cfloop query="GET_SALEABLE_STOCK_ACTION">
                        <option value="#GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_ID#" <cfif GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_ID eq get_stock_strategy.stock_action_id>selected</cfif>>#GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_NAME#</option>
                        </cfloop>
                    </select>
                </div>
                    </td>
                 </tr>
              </cfoutput>
            </tbody>
            
        </cfif>
    </cf_grid_list>
        <div class="ui-info-bottom flex-end">
            <div class="col col-6 ">
                <cfif len(GET_STOCK_STRATEGY.record_emp) and len(GET_STOCK_STRATEGY.RECORD_DATE)>
                    <cf_get_lang dictionary_id='57891.Güncelleyen'> : 
                    <cfoutput>
                        #get_emp_info(GET_STOCK_STRATEGY.record_emp,0,0)#-
                        #dateformat(date_add('h',session.ep.time_zone,GET_STOCK_STRATEGY.RECORD_DATE),dateformat_style)# -
                        #timeformat(date_add('h',session.ep.time_zone,GET_STOCK_STRATEGY.RECORD_DATE),timeformat_style)#
                    </cfoutput>
                </cfif>
            </div>
            <div class="col col-6 "> 
                <cf_workcube_buttons is_upd='0' add_function='form_control()' type_format='1'>
                <div id="_USER_INFO_MESSAGE_" style="float:right;"></div>
            </div>
        </div>
  </form>    
<script type="text/javascript">
	function form_control()
	{
		if(add_stock_str.row_count.value!='')
		{
            
			for(var i=1;i <= add_stock_str.row_count.value; i=i+1)
			{
                if(parseFloat(filterNum(document.getElementById('maximum_stock_'+i).value))< parseFloat(filterNum(document.getElementById('minimum_stock_'+i).value)))
                {
                    alert('<cf_get_lang dictionary_id="31107.Maksimum Stok Değeri Minimum Stok Değerinden Büyük Olmalıdır!">');
                    return false;
                }
                if(parseFloat(filterNum(document.getElementById('max_ord_st_val_'+i).value)) < parseFloat(filterNum(document.getElementById('min_ord_st_val_'+i).value)))
                {
                    alert('<cf_get_lang dictionary_id="55059.Maksimum Sipariş Miktarı Minimum Sipariş Miktarından Büyük Olmalıdır!">');
                    return false;
                }
                if(document.getElementById('maximum_stock_'+i).value=='' || document.getElementById('rpt_st_val_'+i).value=='' || document.getElementById('minimum_stock_'+i).value=='' || document.getElementById('min_ord_st_val_'+i).value=='' || document.getElementById('prov_tm_'+i).value=='')
                {
                    alert(i + '. <cf_get_lang dictionary_id="45412.Satırdaki Zorunlu Alanlar Doldurulmadan Stok Stratejisi Kaydedilmez">!');
                    return false;
                }
            }
		
		}
		AjaxFormSubmit('add_stock_str','_USER_INFO_MESSAGE_','1',"<cf_get_lang dictionary_id='58889.Kaydediliyor'>..","<cf_get_lang dictionary_id='58890.Kaydedildi'>","<cfoutput>#request.self#?fuseaction=stock.emptypopup_list_stock_strategy&pid=#attributes.pid#</cfoutput>","div_strategy_menu");
		return false;
	}
</script>
