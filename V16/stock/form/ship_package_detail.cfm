<cfsetting showdebugoutput="yes">
<cfset xml_page_control_list = 'is_calculate_to_product_tree,is_show_amount'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1">
<cfparam name="attributes.add_other_amount" default="1">
<cfparam name="attributes.del_other_amount" default="1">
<cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn1#">
    SELECT
		BARCOD,
		STOCK_CODE,
		PRODUCT_NAME,
		SUM(PAKETSAYISI) AS PAKETSAYISI,
		ISNULL(STOCK_ID,0) STOCK_ID
    FROM
		(	SELECT
				#dsn1_alias#.STOCKS.STOCK_CODE,
				#dsn1_alias#.PRODUCT.BARCOD,
				#dsn1_alias#.PRODUCT.PRODUCT_NAME,
				DERIVEDTBL.PAKETSAYISI,
				#dsn1_alias#.STOCKS.STOCK_ID
			FROM
				#dsn1_alias#.STOCKS RIGHT OUTER JOIN
				#dsn1_alias#.PRODUCT ON
				#dsn1_alias#.STOCKS.PRODUCT_ID = #dsn1_alias#.PRODUCT.PRODUCT_ID RIGHT OUTER JOIN
          		(	SELECT
						DERIVEDTBL.SHIP_ID,
						DERIVEDTBL.AMOUNT
						*
						#dsn3_alias#.PRODUCT_TREE.AMOUNT AS PAKETSAYISI, 
                        #dsn3_alias#.PRODUCT_TREE.RELATED_ID
            		FROM
						#dsn1_alias#.PRODUCT INNER JOIN
						(	SELECT
								#dsn2_alias#.SHIP_ROW.SHIP_ID,
								#dsn2_alias#.SHIP_ROW.AMOUNT, 
                                #dsn1_alias#.KARMA_PRODUCTS.PRODUCT_ID
							FROM
								#dsn1_alias#.KARMA_PRODUCTS RIGHT OUTER JOIN
                                #dsn1_alias#. PRODUCT ON
								#dsn1_alias#.KARMA_PRODUCTS.KARMA_PRODUCT_ID = #dsn1_alias#.PRODUCT.PRODUCT_ID RIGHT OUTER JOIN
                                #dsn2_alias#.SHIP_ROW ON
								#dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID
							WHERE
								(#dsn2_alias#.SHIP_ROW.SHIP_ID = #attributes.process_id#) AND (#dsn1_alias#.PRODUCT .IS_KARMA = 1)
						) DERIVEDTBL ON 
						#dsn1_alias#.PRODUCT .PRODUCT_ID = DERIVEDTBL.PRODUCT_ID LEFT OUTER JOIN
						#dsn3_alias#.PRODUCT_TREE RIGHT OUTER JOIN
						#dsn1_alias#.STOCKS ON 
						#dsn3_alias#.PRODUCT_TREE.STOCK_ID = #dsn1_alias#.STOCKS.STOCK_ID ON 
						DERIVEDTBL.PRODUCT_ID = #dsn1_alias#.STOCKS.PRODUCT_ID
					WHERE      
						(#dsn1_alias#.PRODUCT.PACKAGE_CONTROL_TYPE = 2)
				) DERIVEDTBL ON 
				#dsn1_alias#.PRODUCT .PRODUCT_ID = DERIVEDTBL.RELATED_ID
		UNION ALL
			SELECT
				#dsn1_alias#.STOCKS.STOCK_CODE,
				#dsn1_alias#.PRODUCT .BARCOD,
				#dsn1_alias#.PRODUCT .PRODUCT_NAME,
				DERIVEDTBL.PAKETSAYISI, 
				#dsn1_alias#.STOCKS.STOCK_ID
			FROM
				#dsn1_alias#.STOCKS RIGHT OUTER JOIN
				#dsn1_alias#.PRODUCT ON 
				#dsn1_alias#.STOCKS.PRODUCT_ID = #dsn1_alias#.PRODUCT .PRODUCT_ID RIGHT OUTER JOIN
				(	SELECT
						#dsn3_alias#.PRODUCT_TREE.RELATED_ID, 
						#dsn3_alias#.PRODUCT_TREE.AMOUNT
						*
						#dsn2_alias#.SHIP_ROW.AMOUNT AS PAKETSAYISI
					FROM
						#dsn1_alias#.PRODUCT LEFT OUTER JOIN
						#dsn3_alias#.PRODUCT_TREE RIGHT OUTER JOIN
						#dsn1_alias#.STOCKS ON 
						#dsn3_alias#.PRODUCT_TREE.STOCK_ID = #dsn1_alias#.STOCKS.STOCK_ID ON 
						#dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn1_alias#.STOCKS.PRODUCT_ID RIGHT OUTER JOIN
						#dsn2_alias#.SHIP_ROW ON #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID
					WHERE
						(#dsn1_alias#.PRODUCT .IS_KARMA = 0) AND (#dsn2_alias#.SHIP_ROW.SHIP_ID = #attributes.process_id#) AND 
						(#dsn1_alias#.PRODUCT .PACKAGE_CONTROL_TYPE = 2)
				) DERIVEDTBL ON 
				#dsn1_alias#.PRODUCT .PRODUCT_ID = DERIVEDTBL.RELATED_ID
		UNION ALL
			SELECT
				#dsn1_alias#.STOCKS.STOCK_CODE,
				#dsn1_alias#.PRODUCT.BARCOD,
				#dsn1_alias#.PRODUCT.PRODUCT_NAME,
				#dsn2_alias#.SHIP_ROW.AMOUNT, 
				#dsn1_alias#.STOCKS.STOCK_ID
			FROM
				#dsn1_alias#.PRODUCT LEFT OUTER JOIN
				#dsn1_alias#.STOCKS ON 
				#dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn1_alias#.STOCKS.PRODUCT_ID RIGHT OUTER JOIN
				#dsn2_alias#.SHIP_ROW ON #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID AND #dsn2_alias#.SHIP_ROW.STOCK_ID = #dsn1_alias#.STOCKS.STOCK_ID
			WHERE
				(#dsn1_alias#.PRODUCT .IS_KARMA = 0) AND (#dsn2_alias#.SHIP_ROW.SHIP_ID = #attributes.process_id#) AND 
				(#dsn1_alias#.PRODUCT .PACKAGE_CONTROL_TYPE = 1)
		UNION ALL
			SELECT
				#dsn1_alias#.STOCKS.STOCK_CODE,
				#dsn1_alias#.PRODUCT.BARCOD,
				#dsn1_alias#.PRODUCT.PRODUCT_NAME,
				DERIVEDTBL.PAKETSAYISI, 
				#dsn1_alias#.STOCKS.STOCK_ID
			FROM
				#dsn1_alias#.PRODUCT LEFT OUTER JOIN
				#dsn1_alias#.STOCKS ON 
				#dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn1_alias#.STOCKS.PRODUCT_ID RIGHT OUTER JOIN
				(	SELECT
						#dsn1_alias#.KARMA_PRODUCTS.PRODUCT_ID, 
                        KARMA_PRODUCTS.STOCK_ID,
						#dsn2_alias#.SHIP_ROW.AMOUNT
						*
						#dsn1_alias#.KARMA_PRODUCTS.PRODUCT_AMOUNT AS PAKETSAYISI
					FROM
						#dsn1_alias#.KARMA_PRODUCTS RIGHT OUTER JOIN
						#dsn1_alias#.PRODUCT ON 
						#dsn1_alias#.KARMA_PRODUCTS.KARMA_PRODUCT_ID = #dsn1_alias#.PRODUCT .PRODUCT_ID RIGHT OUTER JOIN
						#dsn2_alias#.SHIP_ROW ON #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID
					WHERE
						(#dsn1_alias#.PRODUCT .IS_KARMA = 1) AND (#dsn2_alias#.SHIP_ROW.SHIP_ID = #attributes.process_id#)
				) DERIVEDTBL ON 
				#dsn1_alias#.PRODUCT .PRODUCT_ID = DERIVEDTBL.PRODUCT_ID AND DERIVEDTBL.STOCK_ID = #dsn1_alias#.STOCKS.STOCK_ID
			WHERE
				(#dsn1_alias#.PRODUCT .PACKAGE_CONTROL_TYPE = 1)
		) DERIVEDTBL
	WHERE
		DERIVEDTBL.STOCK_ID IS NOT NULL
	GROUP BY
		BARCOD,
		STOCK_CODE,
		PRODUCT_NAME,
		STOCK_ID
</cfquery>
<cfquery name="get_detail_package_list" datasource="#dsn2#">
	SELECT 
		STOCK_ID,
		CONTROL_AMOUNT
	FROM 
		SHIP_PACKAGE_LIST
	WHERE
		SHIP_ID = #attributes.PROCESS_ID# 
</cfquery>
<cfoutput query="get_detail_package_list">
	<cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
</cfoutput>
<cfset stock_id_list = ListSort(ListDeleteDuplicates(ValueList(GET_SHIP_PACKAGE_LIST.STOCK_ID,',')),"numeric","asc",",")>
<cfif len(stock_id_list)>
    <cfquery name="get_property_product" datasource="#dsn3#"><!--- Donat İçin Eklendi,Ürün Özelliklerinden Değerler Alınıyor. --->
        SELECT
            S.STOCK_ID,
            P.PRODUCT_CODE_2,
            ISNULL(PIP.PROPERTY7,0) AS PAKET_NO,
            ISNULL(PIP.PROPERTY8,0) AS TOPLAM_PAKET_ADI
        FROM
            STOCKS S,
            PRODUCT P,
            PRODUCT_INFO_PLUS PIP
        WHERE
        	P.PRODUCT_ID = S.PRODUCT_ID 
	        AND PIP.PRODUCT_ID = S.PRODUCT_ID
            AND S.STOCK_ID IN (#stock_id_list#)
    </cfquery>
	<cfif get_property_product.recordcount>
		<cfscript>
			for(ppi=1;ppi lte get_property_product.recordcount;ppi=ppi+1)
			{
				'product_prop_name_#get_property_product.STOCK_ID[ppi]#' = '#get_property_product.PRODUCT_CODE_2[ppi]#-#get_property_product.TOPLAM_PAKET_ADI[ppi]# /  #get_property_product.PAKET_NO[ppi]#';
			}
        </cfscript>
	</cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<form name="add_package" id="add_package" method="post" action="<cfoutput>#request.self#?fuseaction=stock.emptypopup_add_ship_package&SHIP_ID=#attributes.PROCESS_ID#</cfoutput>">
		<cf_box >
			<cf_box_search more="0">
				<div class="form-group" id="item-add_other_amount">
					<label><cf_get_lang dictionary_id='57635.Miktar'></label>
					<div class="input-group">	
						<input name="add_other_amount" id="add_other_amount" type="text" value="<cfoutput>#TlFormat(attributes.add_other_amount,3)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,3));" class="moneybox" style="width:40px;">
					</div>
				</div>
				<div class="form-group" id="item-del_other_barcod">			
					<label><cf_get_lang dictionary_id='45543.Barkod dan Ürün Çıkar'></label>
					<div class="input-group">	
						<input name="del_other_barcod" id="del_other_barcod" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_product_to_barkod(this.value,del_other_amount.value,0);}" style="width:120px;">
					</div>
				</div>
				<div class="form-group" id="item-del_other_amount">
					<label><cf_get_lang dictionary_id='38710.Miktar'></label>
					<div class="input-group">	
						<input name="del_other_amount" id="del_other_amount" type="text" value="<cfoutput>#TlFormat(attributes.del_other_amount,3)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,3));" class="moneybox" style="width:40px;">
					</div>
				</div>
				<div class="form-group" id="item-add_other_barcod">	
					<label><cf_get_lang dictionary_id='45542.Barkod dan Ürün Ekle'></label>
					<div class="input-group">	
						<input name="add_other_barcod" id="add_other_barcod" type="text" value="" onKeyDown="if(event.keyCode == 13) {return add_product_to_barkod(trim(this.value),add_other_amount.value,1);}" style="width:120px;">
					</div>
				</div>
			</cf_box_search>
		</cf_box>
		<cf_box title='#getLang(517,'Paket Kontrol Listesi',45694)#' history_title="#getlang('','Tarihçe','57473')#" history_href="gizle_goster(PACKAGE_LIST_HISTORY);AjaxPageLoad('#request.self#?fuseaction=stock.popup_ajax_ship_package_history&SHIP_ID=#attributes.PROCESS_ID#','PACKAGE_LIST_HISTORY_INFO',1);" uidrop="1" hide_table_column="1">
				<cf_flat_list>
					<thead>
						<tr>
							<th width="30"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
							<th><cf_get_lang dictionary_id ='45693.Stok Adı'></th>
							<th><cf_get_lang dictionary_id ='36590.Paket Bilgisi'></th>
							<th><cf_get_lang dictionary_id ='57633.Barkod'></th>
							<th <cfif isdefined('is_show_amount') and is_show_amount eq 0>style="display:none"</cfif>><cf_get_lang dictionary_id ='58082.Adet'></th>
							<th width="100"><cf_get_lang dictionary_id ='45692.Kontrol Edilen'></th>
						</tr>
					</thead>
					<tbody>
						<cfset product_barcode_list = ''>
						<input type="hidden" name="stock_id_list" id="stock_id_list" value="<cfoutput>#stock_id_list#</cfoutput>">
						<cfoutput query="GET_SHIP_PACKAGE_LIST">
						<tr id="row#STOCK_ID#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>#STOCK_CODE#</td>
							<td>#PRODUCT_NAME#</td>
							<td>
								<cfif isdefined('product_prop_name_#STOCK_ID#')><!--- Donatın istediği için yapıldı,bir şarta bağlanmadı zaten diğer yerler için muhtemelen bu şartlara girmeyecektir. --->
									#Evaluate('product_prop_name_#STOCK_ID#')#
									<input type="hidden" id="PRODUCT_NAME#STOCK_ID#" name="PRODUCT_NAME#STOCK_ID#" value="#Evaluate('product_prop_name_#STOCK_ID#')#" class="moneybox" style="width:100;">
								<cfelse>
									#PRODUCT_NAME#
									<input type="hidden" id="PRODUCT_NAME#STOCK_ID#" name="PRODUCT_NAME#STOCK_ID#" value="#PRODUCT_NAME#" class="moneybox" style="width:100;">
								</cfif>
							</td>
							<td>
								<cfquery name="GET_BARCODE" datasource="#DSN3#">
									SELECT BARCODE FROM  STOCKS_BARCODES WHERE STOCK_ID=#STOCK_ID#
								</cfquery>
								<cfloop query="GET_BARCODE">
								#BARCODE#<br/>
								</cfloop>
							</td>
							<cfset product_barcode_list = listdeleteduplicates(ListAppend(product_barcode_list,ValueList(GET_BARCODE.BARCODE),','))>	
							<td align="center"<cfif isdefined('is_show_amount') and is_show_amount eq 0>style="display:none"</cfif>><input type="text" name="amount#STOCK_ID#" id="amount#STOCK_ID#" value="#PAKETSAYISI#" readonly="yes" class="moneybox" style="width:100;"></td>
							<td nowrap="nowrap">
								<input type="text" name="control_amount#STOCK_ID#" id="control_amount#STOCK_ID#" value="<cfif isdefined('control_amount#STOCK_ID#')>#Tlformat(Evaluate('control_amount#STOCK_ID#'),3)# <cfelse>#Tlformat(0,3)#</cfif>" class="moneybox"  style="width:100; color:FF0000;">
								<!--- <div style="position:absolute; width:15;" align="right"> --->
								<img id="is_ok#STOCK_ID#" name="is_ok#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') neq PAKETSAYISI)>style="display:none;"</cfif> align="center" src="images\c_ok.gif">
								<img id="is_error#STOCK_ID#" name="is_error#STOCK_ID#"<cfif not isdefined('control_amount#STOCK_ID#') or (isdefined('control_amount#STOCK_ID#') and Evaluate('control_amount#STOCK_ID#') lte PAKETSAYISI)>style="display:none;"</cfif>align="center" src="images\closethin.gif">
								<!--- </div> --->
							</td>
						</tr>
						</cfoutput>
					</tbody>
				</cf_flat_list>
				<input type="hidden" name="changed_stock_id" id="changed_stock_id" value=""><!--- Bu hidden alan kontrol yapıldıkça kontrol yapılan satırı renklendirmek için kullanılıyor. --->
				<table align="center" width="100%">
					<tr style="display:none" id="PACKAGE_LIST_HISTORY">
						<td colspan="5"><div id="PACKAGE_LIST_HISTORY_INFO"></div></td>
					</tr>
				</table>
				<cf_box_footer>
					<table align="right">
						<tr>
							<td><input type="button" value="<cfif not get_detail_package_list.recordcount><cf_get_lang dictionary_id ='57461.Kaydet'><cfelse><cf_get_lang dictionary_id ='57464.Güncelle'></cfif>" onClick="if(confirm('<cf_get_lang dictionary_id ='45686.Kaydetmek İstediğinizden Eminmisiniz'>')) kontrol(); else return false;"></td><!--- <cf_workcube_buttons is_upd='0' is_delete='0' add_function='kontrol()'> --->
						</tr>
					</table>
				</cf_box_footer>
		</cf_box>
	</form>

</div>
<script type="text/javascript">
function add_product_to_barkod(barcode,amount,type)
{
	var amount = filterNum(amount,3)
	if(list_find('<cfoutput>#product_barcode_list#</cfoutput>',barcode,','))
	{
		var get_product = wrk_safe_query('stk_get_prodct','dsn1',0,barcode);
			if(document.getElementById('control_amount'+get_product.STOCK_ID)==undefined)
				alert("<cf_get_lang dictionary_id ='45691.Ürünün Barkodlarında Sorun Var'>")		
			else
			{
				if(document.add_package.changed_stock_id.value != "")//daha önceden bir satır eklenmişse alan dolmuş demektir ve yeni eklenecek alan için satırı renklendiyoruz bir alt satırda
					eval('row'+document.all.changed_stock_id.value).style.background='ffffff';
				if(type==1)//ekleme ise
				{		
					document.getElementById('control_amount'+get_product.STOCK_ID).value = commaSplit(parseFloat(parseFloat(document.getElementById('control_amount'+get_product.STOCK_ID).value)+parseFloat(amount)),3);	
					if(parseFloat(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3)) > parseFloat(document.getElementById('amount'+get_product.STOCK_ID).value))
						alert(document.getElementById('PRODUCT_NAME'+get_product.STOCK_ID).value+"<cf_get_lang dictionary_id ='45690.Ürününde Fazla Çıkış Var'> ");
				}			
				else if(type==0)//silme ise	
					if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == 0 )
						alert("<cf_get_lang dictionary_id ='45689.Çıkan Ürünlerin Sayısı 0 dan küçük olamaz'>");
					else		
						document.getElementById('control_amount'+get_product.STOCK_ID).value = commaSplit(parseFloat(parseFloat(document.getElementById('control_amount'+get_product.STOCK_ID).value)-parseFloat(amount)),3);
							
							if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == document.getElementById('amount'+get_product.STOCK_ID).value)
							{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='';
							eval('document.all.is_error'+get_product.STOCK_ID).style.display='none';}	
							if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) > document.getElementById('amount'+get_product.STOCK_ID).value)
							{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
							eval('document.all.is_error'+get_product.STOCK_ID).style.display='';}
							if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) < document.getElementById('amount'+get_product.STOCK_ID).value)
								eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
			document.add_package.add_other_barcod.value='';
			document.add_package.del_other_barcod.value='';
			document.add_package.changed_stock_id.value = get_product.STOCK_ID;
			eval('row'+get_product.STOCK_ID).style.background='FFCCCC';
			}	
		}
	else
		alert("<cf_get_lang dictionary_id ='45688.Kayıtlı Barkod Yok'>!")
}
function kontrol()
{
	<cfloop list="#stock_id_list#" index="kk"><cfoutput>
	if(document.getElementById('amount#kk#').value != filterNum(commaSplit(document.getElementById('control_amount#kk#').value,3)) )
		{
			alert(document.getElementById('PRODUCT_NAME#kk#').value +", #kk# <cf_get_lang dictionary_id ='45687.Satırdaki Ürün Sayısında Sorun Var'>!");
			return false;
		}
		
	document.getElementById('control_amount#kk#').value	= filterNum(document.getElementById('control_amount#kk#').value,3);
	</cfoutput>
	</cfloop>
	
	document.add_package.submit();
}		
</script>
