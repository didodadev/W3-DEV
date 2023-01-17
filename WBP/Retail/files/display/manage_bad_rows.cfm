<cfquery name="get_rows" datasource="#dsn_Dev#">
	SELECT
    	GA.FIS_TARIHI,
        GA.KASA_NUMARASI,
        GA.FIS_NUMARASI,
        GAR.BARCODE,
        GAR.MIKTAR,
        GAR.ACTION_ROW_ID,
        T1.PRODUCT_STATUS,
        T1.IS_SALES,
        T1.PROPERTY,
        T1.PRODUCT_ID,
        GAR.BIRIM_FIYAT
    FROM
    	GENIUS_ACTIONS GA,
        GENIUS_ACTIONS_ROWS GAR
        	LEFT JOIN 
            	(
                	SELECT
                    	P.PRODUCT_ID,
                        SB.BARCODE,
                        S.PROPERTY,
                        P.PRODUCT_STATUS,
                        P.IS_SALES
                    FROM
                    	#dsn1_alias#.STOCKS_BARCODES SB,
                        #dsn1_alias#.STOCKS S,
                        #dsn1_alias#.PRODUCT P
                    WHERE
                    	SB.STOCK_ID = S.STOCK_ID AND
                        S.PRODUCT_ID = P.PRODUCT_ID
                ) T1 ON GAR.BARCODE = T1.BARCODE
    WHERE
    	GA.ACTION_ID = GAR.ACTION_ID AND
        GAR.STOCK_ID IS NULL
        ORDER BY
        GA.FIS_TARIHI  DESC
        
</cfquery>

<table class="dph">
  <tr>
    <td class="dpht">
    	Hatalı İşlem Satırları
    </td>
    <td style="text-align:right;">
    <input type="button" onclick="window.location.href='index.cfm?fuseaction=retail.popup_manage_bad_rows_upd';" value="Hatalı Kayıtları Aktar"/>
    </td>
  </tr>
</table>
<table class="medium_list" align="center"> 
<thead>             
	<tr> 
		<th width="25"><cf_get_lang_main no='75.No'></th>
		<th>İşlem Tarihi</th>
        <th>Kasa Numarası</th>
        <th>Fiş Numarası</th>
		<th>Barkod</th>
        <th>Stok Adı</th>
        <th>Miktar</th>
        <th>Br. Fiyat</th>
        <th>Satış</th>
		<th>Aktif / Pasif</th>				
	  </tr>
	  </thead>
	  <tbody>
	  <cfoutput query="get_rows">
        <tr>
            <td>#currentrow#</td>
            <td>#dateformat(fis_tarihi,'dd/mm/yyyy')#</td>
            <td>#KASA_NUMARASI#</td>
            <td>#FIS_NUMARASI#</td>
            <td nowrap="nowrap"><input type="text" value="#BARCODE#" name="barcode_#action_row_id#" id="barcode_#action_row_id#" style="width:100px;"/> <a href="javascript://" onclick="update_row('#action_row_id#')"><img src="/images/reload_page.gif" align="absmiddle" border="0"/></a></td>
            <td><cfif len(PRODUCT_ID)><a href="#request.self#?fuseaction=product.form_upd_product&pid=#PRODUCT_ID#" target="blank" class="tableyazi">#PROPERTY#</a></cfif></td>
       		<td>#TLFORMAT(MIKTAR)#</td>
            <td>#TLFORMAT(BIRIM_FIYAT)#</td>
            <td><cfif IS_SALES eq 1>Satışta</cfif></td>
            <td><cfif len(PRODUCT_ID)><cfif PRODUCT_STATUS eq 1>Aktif<cfelse>Pasif</cfif></cfif></td>
       </tr>
	  </cfoutput> 
	</tbody>
</table>
<div id="action_update_div"></div>
<script>
function update_row(action_row_id)
{
	deger_ = document.getElementById('barcode_' + action_row_id).value;
	if(deger_ == '')
	{
		alert('Barkod Girmelisiniz!');
		return false;	
	}
	adress_ = 'index.cfm?fuseaction=retail.emptypopup_update_action_row';
	adress_ += '&action_row_id=' + action_row_id;
	adress_ += '&barcode=' + deger_;
	AjaxPageLoad(adress_,'action_update_div');
}
</script>