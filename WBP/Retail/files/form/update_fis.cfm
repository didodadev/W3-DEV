<cfquery name="get_fis" datasource="#dsn_dev#">
SELECT
    B.BRANCH_NAME,
    PE.EQUIPMENT_CODE,
    GAT.TYPE_NAME AS BELGE_TUR_ADI,
    E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KASIYER,
    GAT.TYPE_NAME AS BELGE_TUR_ADI,
    GA.*
FROM 
    #dsn_alias#.BRANCH B,
    #dsn3_alias#.POS_EQUIPMENT PE,
    GENIUS_ACTIONS GA
        INNER JOIN GENIUS_ACTION_TYPES GAT ON (GAT.TYPE_ID = GA.BELGE_TURU)
        INNER JOIN #dsn_alias#.EMPLOYEES E ON (E.EMPLOYEE_ID = GA.KASIYER_NO)
WHERE
    <cfif not session.ep.ehesap>
        B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
    </cfif>
    PE.BRANCH_ID = B.BRANCH_ID AND
    PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
    GA.ACTION_ID = #attributes.action_id#
</cfquery>
<cfif not get_fis.recordcount>
	<script>
		alert('Hatalı Bir Harekete Girmeye Çalışıyorsunuz!');
		window.close();
	</script>
    <cfabort>
</cfif>

<cfquery name="bir_onceki" datasource="#dsn_dev#">
	SELECT TOP 1
    	ACTION_ID
    FROM
        GENIUS_ACTIONS
   	WHERE
    	ACTION_ID < #get_fis.action_id# AND
        SUBE_KODU = '#get_fis.SUBE_KODU#'
    ORDER BY
    	KASA_NUMARASI ASC,
    	ACTION_ID DESC
</cfquery>
<cfquery name="bir_sonraki" datasource="#dsn_dev#">
	SELECT TOP 1
    	ACTION_ID
    FROM
        GENIUS_ACTIONS
   	WHERE
    	ACTION_ID > #get_fis.action_id# AND
        SUBE_KODU = '#get_fis.SUBE_KODU#'
    ORDER BY
    	KASA_NUMARASI ASC,
    	ACTION_ID ASC
</cfquery>

<cfquery name="get_rows_active" datasource="#dsn_dev#">
	SELECT
    	*,
        S.PROPERTY
    FROM
    	GENIUS_ACTIONS_ROWS
        	LEFT JOIN #dsn3_alias#.STOCKS S ON (S.STOCK_ID = GENIUS_ACTIONS_ROWS.STOCK_ID)
    WHERE
    	ACTION_ID = #attributes.action_id# AND
        SATIR_IPTALMI = 0
</cfquery>

<cfquery name="get_rows_passive" datasource="#dsn_dev#">
	SELECT
    	*,
        S.PROPERTY
    FROM
    	GENIUS_ACTIONS_ROWS
        	LEFT JOIN #dsn3_alias#.STOCKS S ON (S.STOCK_ID = GENIUS_ACTIONS_ROWS.STOCK_ID)
    WHERE
    	ACTION_ID = #attributes.action_id# AND
        SATIR_IPTALMI = 1
</cfquery>

<cfquery name="get_payments" datasource="#dsn_dev#">
	SELECT
    	*,
        (SELECT HEADER FROM SETUP_POS_PAYMETHODS SPP WHERE SPP.CODE = GENIUS_ACTIONS_PAYMENTS.ODEME_TURU) AS BASLIK
    FROM
    	GENIUS_ACTIONS_PAYMENTS
    WHERE
    	ACTION_ID = #attributes.action_id#
</cfquery>

<cfsavecontent variable="sag_icerik">
	<cfoutput>
    <table align="right">
    	<tr>
        	<td>
            <cfif bir_onceki.recordcount>
            	<a href="#request.self#?fuseaction=retail.genius_fis&event=upd&action_id=#bir_onceki.ACTION_ID#"><img src="/images/first20.gif" border="0"/></a>
            </cfif>
            </td>
            <td>Fiş No : #get_fis.fis_numarasi#</td>
            <td>
            <cfif bir_sonraki.recordcount>
            	<a href="#request.self#?fuseaction=retail.genius_fis&event=upd&action_id=#bir_sonraki.ACTION_ID#"><img src="/images/last20.gif" border="0"/></a>
            </cfif>
            </td>
        </tr>
    </table>
    </cfoutput>
</cfsavecontent>
<cfset durum_list = "Geçerli,İptal,İptal,İptal,İptal">
<cf_popup_box title="Fiş Detay : #get_fis.fis_numarasi# (#get_fis.BELGE_TUR_ADI#) - #get_fis.kasiyer# - #listgetat(durum_list,(get_fis.fis_iptal+1))#" right_images="#sag_icerik#">
<cfform action="" method="post" name="update_fis_form">
<cfinput type="hidden" name="action_id" value="#get_fis.action_id#">
<cfinput type="hidden" name="payment_count" value="#get_payments.recordcount#">
<cfinput type="hidden" name="active_row_count" value="#get_rows_active.recordcount#">
<table>
<tr>
<td width="200" class="color-list" valign="top">
	<cfoutput query="get_fis">
    <table>
    <tr>
    	<td class="formbold">Tarih</td>
        <td>#dateformat(fis_tarihi,'dd/mm/yyyy')# (#timeformat(fis_tarihi,'HH:MM')#)</td>
    </tr> 
    <tr>
    	<td class="formbold">Mağaza No</td>
        <td>#val(sube_kodu)#</td>
    </tr>
    <tr>
    	<td class="formbold">Kasa No</td>
        <td>#kasa_numarasi#</td>
    </tr>  
    <tr>
    	<td class="formbold">Fiş No</td>
        <td>#fis_numarasi#</td>
    </tr>
    <tr>
    	<td class="formbold">Hareket Türü</td>
        <td>#BELGE_TUR_ADI#</td>
    </tr>
    <tr>
    	<td class="formbold">Kasiyer</td>
        <td>#kasiyer# (#KASIYER_NO#)</td>
    </tr>
    </table>
    <hr />
    <br />
    <table>
    <tr>
    	<td class="formbold">KDV Toplam</td>
        <td style="text-align:right;">#tlformat(fis_toplam_kdv)#</td>
    </tr>
    <tr>
    	<td class="formbold">Satır İndirim</td>
        <td style="text-align:right;">#tlformat(fis_satir_alti_indirim)#</td>
    </tr>
    <tr>
    	<td class="formbold">Promosyon İndirim</td>
        <td style="text-align:right;">#tlformat(fis_promosyon_indirim)#</td>
    </tr>
    <tr>
    	<td class="formbold">Toplam İndirim</td>
        <td style="text-align:right;">#tlformat(fis_satir_alti_indirim + fis_promosyon_indirim)#</td>
    </tr>
    <tr>
    	<td class="formbold">Fiş Toplam</td>
        <td style="text-align:right;">#tlformat(fis_toplam)#</td>
    </tr>
    </table>
    <hr />
    <br />
    <table>
   	<tr>
    	<td class="formbold">Maliye No</td>
        <td>#get_fis.maliye_no#</td>
    </tr>
    <tr>
    	<td class="formbold">Z No</td>
        <td>#get_fis.zno#</td>
    </tr>
    </table>
    <hr />
    <br />
    <table>
   	<tr>
    	<td class="formbold">Kazanılan Puan</td>
        <td>#tlformat(get_fis.kazanilan_puan)#</td>
    </tr>
    <tr>
    	<td class="formbold">Kullanılan Puan</td>
        <td>#tlformat(get_fis.kullanilan_puan)#</td>
    </tr>
    </table>
    </cfoutput>
</td>
<td valign="top">
    <cf_ajax_list_search title="Fiş Satırları"></cf_ajax_list_search>
    <cf_ajax_list>
    	<thead>
        	<tr>
            	<th>Sıra</th>
                <th>Ürün Kodu</th>
                <th>Ürün Adı</th>
                <th>Barkod</th>
                <th>Birim</th>
                <th style="text-align:right;">Miktar</th>
                <th style="text-align:right;">Fiyat</th>
                <th style="text-align:right;">Satış T.</th>
                <th style="text-align:right;">KDV</th>
            </tr>
        </thead>
        <tbody>
        	<cfoutput query="get_rows_active">
            <tr>
            	<td>
                <cfinput type="hidden" name="action_row_id_#currentrow#" value="#action_row_id#">
                <cfinput type="hidden" name="action_row_kdv_#currentrow#" value="#satir_kdv#">
                #currentrow#
                </td>
                <td>#STOCK_ID#</td>
                <td><cfif len(STOCK_ID)><a href="#request.self#?fuseaction=product.form_upd_product&pid=#product_id#" class="tableyazi" target="product_page">#PROPERTY#</a><cfelse>#PROPERTY#</cfif></td>
                <td>#barcode#</td>
                <td>#birim_adi#</td>
                <td>
                <cfif birim_adi is 'adet'>
                	<cfinput type="text" name="action_row_miktar_#currentrow#" class="moneybox" value="#tlformat(miktar,0)#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,0));" onBlur="hesapla('#currentrow#','miktar');">
               	<cfelse>
                	<cfinput type="text" name="action_row_miktar_#currentrow#" class="moneybox" value="#tlformat(miktar,4)#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,4));" onBlur="hesapla('#currentrow#','miktar');">
                </cfif>
                </td>
            	<td><cfinput type="text" name="action_row_birim_fiyat_#currentrow#" class="moneybox" value="#tlformat(birim_fiyat,2)#" style="width:60px;" onkeyup="return(FormatCurrency(this,event,2));" onBlur="hesapla('#currentrow#','tutar');"></td>
                <td><cfinput type="text" name="action_row_satir_toplam_#currentrow#" class="moneybox" readonly value="#tlformat(satir_toplam,2)#" style="width:60px;" onkeyup="return(FormatCurrency(this,event,2));"></td>
            	<td style="text-align:right;">#satır_kdv#</td>
            </tr>
            </cfoutput>
        </tbody>
    </cf_ajax_list>
    
    <cf_ajax_list_search title="İptal Satırlar"></cf_ajax_list_search>
    <cf_ajax_list>
    	<thead>
        	<tr>
            	<th>Sıra</th>
                <th>Ürün Kodu</th>
                <th>Ürün Adı</th>
                <th>Barkod</th>
                <th>Birim</th>
                <th style="text-align:right;">Miktar</th>
                <th style="text-align:right;">Fiyat</th>
                <th style="text-align:right;">Satış T.</th>
                <th style="text-align:right;">KDV</th>
            </tr>
        </thead>
        <tbody>
        	<cfoutput query="get_rows_passive">
            <tr>
            	<td>
                #currentrow#
                </td>
                <td>#STOCK_ID#</td>
                <td>#PROPERTY#</td>
                <td>#barcode#</td>
                <td>#birim_adi#</td>
                <td style="text-align:right;">#tlformat(miktar,0)#</td>
            	<td style="text-align:right;">#tlformat(birim_fiyat,2)#</td>
                <td style="text-align:right;">#tlformat(satir_toplam,2)#</td>
            	<td style="text-align:right;">#satır_kdv#</td>
            </tr>
            </cfoutput>
        </tbody>
    </cf_ajax_list>
    
    <cf_ajax_list_search title="Promosyonlar"></cf_ajax_list_search>
    <cf_ajax_list>
    	<thead>
        	<tr>
            	<th>Sıra</th>
                <th>İndirim Tipi</th>
                <th style="text-align:right;">İndirim Tutar</th>
            </tr>
        </thead>
        <tbody>
        <cfoutput>
        	<cfset indirim_c = 0>
			<cfif get_fis.fis_promosyon_indirim gt 0>
            <cfset indirim_c = indirim_c + 1>
            <tr>
            	<td>#indirim_c#</td>
                <td>Promosyon</td>
            	<td style="text-align:right;">#tlformat(get_fis.fis_promosyon_indirim)#</td>
            </tr>
            </cfif>
            <cfif get_fis.fis_satir_alti_indirim gt 0>
            <cfset indirim_c = indirim_c + 1>
            <tr>
            	<td>#indirim_c#</td>
                <td>Tutar</td>
            	<td style="text-align:right;">#tlformat(get_fis.fis_satir_alti_indirim)#</td>
            </tr>
            </cfif>
        </cfoutput>
        </tbody>
    </cf_ajax_list>
    
    <cf_ajax_list_search title="Ödeme Satırları"></cf_ajax_list_search>
    <cf_ajax_list>
    	<thead>
        	<tr>
            	<th>Sıra</th>
                <th>Alınan / Verilen</th>
                <th colspan="2">Ödeme Tipi</th>
                <th style="text-align:right;">Ödenen T.</th>
                <th style="text-align:right;">Alınan T.</th>
                <th style="text-align:right;">Verilen T.</th>
            </tr>
        </thead>
        <tbody>
        	<cfoutput query="get_payments">
            <tr>
            	<td>
                <cfinput type="hidden" name="payment_row_id_#currentrow#" value="#action_payment_id#">
                <cfinput type="hidden" name="payment_odeme_tipi_#currentrow#" value="#ODEME_TIPI#">
                #currentrow#</td>
                <td><cfif ODEME_TIPI eq 0>Ödeme<cfelse>Para Üstü</cfif></td>
                <td>#ODEME_TURU#</td>
                <td>#BASLIK#</td>
                <td style="text-align:right;"><cfif ODEME_TIPI eq 0>#tlformat(get_fis.fis_toplam)#</cfif></td>
                <td style="text-align:right;"><cfif ODEME_TIPI eq 0><cfinput type="text" name="payment_odeme_tutar_#currentrow#" class="moneybox" value="#tlformat(odeme_tutar)#" style="width:75px;" onkeyup="return(FormatCurrency(this,event));"></cfif></td>
                <td style="text-align:right;"><cfif ODEME_TIPI eq 1><cfinput type="text" name="payment_odeme_tutar_#currentrow#" class="moneybox" value="#tlformat(-1 * odeme_tutar)#" style="width:75px;" onkeyup="return(FormatCurrency(this,event));"></cfif></td>
            </tr>
            </cfoutput>
        </tbody>
    </cf_ajax_list>
</td>
</tr>
</table>
	<cf_popup_box_footer>
    	<cf_workcube_buttons>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script>
function hesapla(row,type)
{
	if(type == 'miktar')
	{
		miktar_ = document.getElementById('action_row_miktar_' + row).value;
		if(miktar_ == '')
		{
			alert('Miktar Girmelisiniz!');
			return false;	
		}
		miktar_ = filterNum(miktar_,4);
		satir_fiyat_ = filterNum(document.getElementById('action_row_birim_fiyat_' + row).value);
		document.getElementById('action_row_satir_toplam_' + row).value = commaSplit(miktar_ * satir_fiyat_);
	}
	else if(type == 'tutar')
	{
		miktar_ = filterNum(document.getElementById('action_row_miktar_' + row).value,4);	
		satir_fiyat_ = filterNum(document.getElementById('action_row_birim_fiyat_' + row).value);
		document.getElementById('action_row_satir_toplam_' + row).value = commaSplit(miktar_ * satir_fiyat_);
	}
}
</script>