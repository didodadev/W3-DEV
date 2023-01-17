<!--- Basketteki ürün satırının raf ve son kullanma tarihine gore dağıtımını yapar. OZDEN20071003--->
<cf_xml_page_edit>
<cfif not (isdefined("url.stock_id") and len(url.stock_id) and isdefined("url.prod_id") and len(url.prod_id))>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1719.Ürün Bilgileri Eksik'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_SHELF_STOCK" datasource="#dsn3#">
	SELECT 
		SUM(GS.PRODUCT_STOCK) PRODUCT_STOCK,
        <cfif xml_is_date_list eq 1>
        	GS.DELIVER_DATE,
        </cfif>
		PRO_P.SHELF_CODE,
		S.STOCK_CODE,
		S.PRODUCT_NAME,
		S.PROPERTY,
        S.PRODUCT_ID,
        S.STOCK_ID,
        GS.SHELF_ID
	FROM 
		#dsn2_alias#.GET_STOCK_SHELF GS,
		STOCKS S,
		PRODUCT_PLACE PRO_P
	WHERE 
		GS.STOCK_ID = S.STOCK_ID
		AND GS.SHELF_ID= PRO_P.PRODUCT_PLACE_ID
		AND PRO_P.PLACE_STATUS=1
		<cfif isdefined('url.department_id') and len(url.department_id) and isdefined('url.location_id') and len(url.location_id)>
		AND PRO_P.STORE_ID = #url.department_id#
		AND PRO_P.LOCATION_ID = #url.location_id#
		</cfif>
		AND S.STOCK_ID = #url.stock_id#
		AND S.PRODUCT_ID = #url.prod_id#
    GROUP BY
    	<cfif xml_is_date_list eq 1>
        	GS.DELIVER_DATE,
        </cfif>
       	PRO_P.SHELF_CODE,
		S.STOCK_CODE,
		S.PRODUCT_NAME,
		S.PROPERTY,
        GS.SHELF_ID,
        S.PRODUCT_ID,
        S.STOCK_ID
	ORDER BY
		GS.SHELF_ID
</cfquery>
<cfif not isdefined('attributes.is_submitted')>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33942.Ürün Raf Bilgiler'></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="shelf_stock_list" action="" method="post">
		<cf_form_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>          
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>        
                    <cfif xml_is_date_list eq 1>  
						<th width="100"><cf_get_lang dictionary_id ='33943.S K Tarihi'></th>
					</cfif>
                    <th width="50"><cf_get_lang dictionary_id ='30001.Raf Bilgisi'></th>	  
					<th width="55" style="text-align:right;"><cf_get_lang dictionary_id ='57452.Stok'></th>
					<th width="55" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
					<th width="20"></th>
				</tr>
			</thead>
			<tbody>
				<cfif GET_SHELF_STOCK.recordcount>
					<cfset total_shelf_amount=0>
					<cfoutput>
					<input type="hidden" name="is_submitted" id="is_submitted" value="1">
					<input type="hidden" name="product_id" id="product_id" value="#get_shelf_stock.product_id#">
					<input type="hidden" name="stock_id" id="stock_id" value="#get_shelf_stock.stock_id#">
					<input type="hidden" name="basket_stok_amount" id="basket_stok_amount" value="#url.prod_amount#">
					<input type="hidden" name="basket_rowno" id="basket_rowno" value="#url.bskt_row_id#">
					<input type="hidden" name="basket_rowcount" id="basket_rowcount" value="#url.bskt_row_count#">
					</cfoutput>
					<cfoutput query="GET_SHELF_STOCK">
						<input type="hidden" name="shelf_date_#GET_SHELF_STOCK.currentrow#" id="shelf_date_#GET_SHELF_STOCK.currentrow#" value="<cfif xml_is_date_list eq 1>#dateformat(GET_SHELF_STOCK.DELIVER_DATE,dateformat_style)#</cfif>">
						<input type="hidden" name="shelf_id_#GET_SHELF_STOCK.currentrow#" id="shelf_id_#GET_SHELF_STOCK.currentrow#" value="#GET_SHELF_STOCK.SHELF_ID#">
						<cfset total_shelf_amount = total_shelf_amount + GET_SHELF_STOCK.PRODUCT_STOCK>
						<tr>
							<td>#GET_SHELF_STOCK.STOCK_CODE#</td>		
							<td>#GET_SHELF_STOCK.PRODUCT_NAME# #GET_SHELF_STOCK.PROPERTY#</td>
                            <cfif xml_is_date_list eq 1> 
								<td>#dateformat(GET_SHELF_STOCK.DELIVER_DATE,dateformat_style)#</td>
							</cfif>
                            <td>#GET_SHELF_STOCK.SHELF_CODE#</td>
							<td style="text-align:right;">#TLFormat(GET_SHELF_STOCK.PRODUCT_STOCK,4)#</td>
							<td style="text-align:right;">
							<cfinput type="text" name="shelf_amount_#GET_SHELF_STOCK.currentrow#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox" value="#TLFormat(GET_SHELF_STOCK.PRODUCT_STOCK,4)#"  style="width:100%">
							</td>
							<td width="20" align="center">
                            	<input type="checkbox" name="txt_shelf_id" id="txt_shelf_id" value="#GET_SHELF_STOCK.currentrow#" <cfif GET_SHELF_STOCK.PRODUCT_STOCK lte 0>disabled</cfif>>
                            </td>
						</tr>
					</cfoutput>
					<tr>
						<td colspan="10" style="text-align:right;">
							 <cfsavecontent variable="message"><cf_get_lang dictionary_id ='33946.Dağıt'></cfsavecontent>
							 <cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#' add_function='control()'>
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_form_list>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
	function control()
	{
		var check_shelf_flag=0;
		var total_amount_= 0
		if(shelf_stock_list.txt_shelf_id.length != undefined)
		{
			for(var xx=0; xx<shelf_stock_list.txt_shelf_id.length; xx++)
			{
				if(shelf_stock_list.txt_shelf_id[xx].checked)
				{
					control_shelf_currentrow = shelf_stock_list.txt_shelf_id[xx].value;
					formatted_shelf_amount = filterNum(eval('document.shelf_stock_list.shelf_amount_'+control_shelf_currentrow).value,4);
					if(formatted_shelf_amount == '' || formatted_shelf_amount ==0) //raf secildigi halde miktar belirtilmemisse dagıtım durduruluyor
						shelf_stock_list.txt_shelf_id[xx].checked =  false;
					else
					{
						total_amount_ = total_amount_ + formatted_shelf_amount;
						check_shelf_flag=1;
					}
				}
			}
		}
		else if(shelf_stock_list.txt_shelf_id.checked)
		{
			control_shelf_currentrow = shelf_stock_list.txt_shelf_id.value;
			formatted_shelf_amount = filterNum(eval('document.shelf_stock_list.shelf_amount_'+control_shelf_currentrow).value,4);
			if(formatted_shelf_amount == '' || formatted_shelf_amount ==0) //raf secildigi halde miktar belirtilmemisse dagıtım durduruluyor
				shelf_stock_list.txt_shelf_id.checked =  false;
			else
			{
				total_amount_ = total_amount_ + formatted_shelf_amount;
				check_shelf_flag=1;
			}
		}
		if(!check_shelf_flag)
		{
			alert("<cf_get_lang dictionary_id ='37105.Raf Seçiniz'>!");
			return false;
		}
		if(document.shelf_stock_list.basket_stok_amount != undefined && parseFloat(total_amount_) > parseFloat(document.shelf_stock_list.basket_stok_amount.value))
		{
			alert("<cf_get_lang dictionary_id ='33948.Raf Dağılımı Yapılacak Ürün Miktarı Sepetteki Ürün Miktarından Fazla'>!");
			return false;
		}
		return true;
	}
</script>
<cfelse>
	<script type="text/javascript">
		<cfoutput>
		<cfloop from="1" to="#listlen(attributes.txt_shelf_id)#" index="cpy_ind">
			<cfset cpy_control_shlf_row = listgetat(attributes.txt_shelf_id,cpy_ind)> 
			<cfset cpy_shlf_id =  evaluate('attributes.shelf_id_#cpy_control_shlf_row#')>
			<cfset cpy_shelf_date_ = evaluate('attributes.shelf_date_#cpy_control_shlf_row#')>
			<cfset cpy_shelf_amount_ = filterNum(evaluate('attributes.shelf_amount_#cpy_control_shlf_row#'),4)>
			<cfif cpy_ind eq 1>
				opener.copy_basket_row('#attributes.basket_rowno-1#',1,1,'#cpy_shlf_id#','#cpy_shelf_date_#','#cpy_shelf_amount_#'); //ilk raf icin kopyalanan ilk satır update ediliyor
			<cfelse>
				opener.copy_basket_row('#attributes.basket_rowno-1#',1,0,'#cpy_shlf_id#','#cpy_shelf_date_#','#cpy_shelf_amount_#'); //2. ve sonraki raflar icin yeni satır ekleniyor
			</cfif>
		</cfloop>
		opener.clear_row('#attributes.basket_rowno#');
		</cfoutput>
		window.close();
	</script>	
</cfif>
