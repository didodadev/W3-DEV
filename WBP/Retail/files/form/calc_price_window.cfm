<cfif isdefined("attributes.row_id")>
	    <cf_popup_box title="Fiyat Hesaplayıcı">
        <cf_medium_list>
            <thead>
            <tr style="font-weight:bold;">
                <th>Alış Fiyatı</th>
                <th>Alış Fiyatı KDV'li</th>
                <th>Satılmak İstenen Fiyat</th>
                <th>Kar</th>
                <th>Yüzde İndirim</th>
                <th>Tutar İndirim</th>
                <th>Yeni Alış</th>
                <th>Yeni Alış KDV'li</th>
            </tr>
            <tbody>
            <tr>
                <td id="active_price"></td>
                <td id="active_price_kdv"></td>
                <td><input type="text" name="yeni_fiyat" id="yeni_fiyat" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));" value="" onBlur="hesapla();" style="width:63px;"></td>
                <td><input type="text" name="yeni_kar" id="yeni_kar" class="moneybox" onkeyup="return(FormatCurrency(this,event,0));" value="25" onBlur="hesapla();" style="width:30px;"></td>
                <td id="yuzde"></td>
                <td id="tutar"></td>
                <td id="yeni_alis"></td>
                <td id="yeni_alis_kdv"></td>
            </tr>
            </td>
            </thead>
        </cf_medium_list>
    </cf_popup_box>
    <script>
    <cfoutput>
	m = #attributes.row_id#;
    $(document).ready(function()
    {
        document.getElementById('active_price').innerHTML = commaSplit(window.opener.$("##jqxgrid").jqxGrid('getcellvalue', m,'new_alis'));
        document.getElementById('active_price_kdv').innerHTML = commaSplit(window.opener.$("##jqxgrid").jqxGrid('getcellvalue', m, 'new_alis_kdvli'));
		
        alis_kdv = window.opener.$("##jqxgrid").jqxGrid('getcellvalue', m,'standart_alis_kdv');
        satis_kdv = window.opener.$("##jqxgrid").jqxGrid('getcellvalue', m,'satis_kdv');
        
        satis_kdv_rank = 1 + (satis_kdv / 100);
        alis_kdv_rank = 1 + (alis_kdv / 100);
        
        document.getElementById('yeni_fiyat').focus();
    });
    function hesapla()
    {
        deger_ = parseFloat(filterNum(document.getElementById('yeni_fiyat').value,4));
        kar_ = parseFloat(filterNum(document.getElementById('yeni_kar').value,4));
        
        //kar_rank_ = (100 + kar_) / 100;
        kar_rank_ = 1 - (kar_ / 100);
        
        old_ = filterNum(document.getElementById('active_price').innerHTML,4);
        
        satis_kdvli_yeni_maliyet = deger_ * kar_rank_;
        yeni_maliyet = satis_kdvli_yeni_maliyet / satis_kdv_rank;
        
        yeni_maliyet_kdv = yeni_maliyet * alis_kdv_rank;
        
        fark_ = old_ - yeni_maliyet;
        
        fark_yuzde_ = fark_ * 100 / old_;
        
        
        document.getElementById('tutar').innerHTML = '<a href="javascript://" onclick="manuel_deger_at();" class="tableyazi">' + commaSplit(fark_,4) + '</a>';
        document.getElementById('yuzde').innerHTML = '<a href="javascript://" onclick="yuzde_deger_at();" class="tableyazi">' + commaSplit(fark_yuzde_,4) + '</a>';
        document.getElementById('yeni_alis').innerHTML = commaSplit(yeni_maliyet,4);
        document.getElementById('yeni_alis_kdv').innerHTML = commaSplit(yeni_maliyet_kdv,4);
    }
    
    function manuel_deger_at()
    {
		window.opener.$("##jqxgrid").jqxGrid('setcellvalue',m,'p_ss_marj',filterNum(document.getElementById('yeni_kar').value));
		window.opener.$("##jqxgrid").jqxGrid('setcellvalue',m,'first_satis_price_kdv',filterNum(document.getElementById('yeni_fiyat').value));
		
		p_discount_manuel_ = window.opener.$("##jqxgrid").jqxGrid('getcellvalue', m,'p_discount_manuel');
		
        if(p_discount_manuel_ != '')
            window.opener.$("##jqxgrid").jqxGrid('setcellvalue',m,'p_discount_manuel',wrk_round(p_discount_manuel_ + fark_,4));
        else
            window.opener.$("##jqxgrid").jqxGrid('setcellvalue',m,'p_discount_manuel',wrk_round(fark_,4));
               
	    window.opener.p_discount_calc(m,'p_discount_manuel',wrk_round(fark_,4));
        window.close();
    }
    
    function yuzde_deger_at()
    {
        window.opener.$("##jqxgrid").jqxGrid('setcellvalue',m,'p_ss_marj',filterNum(document.getElementById('yeni_kar').value));
        window.opener.$("##jqxgrid").jqxGrid('setcellvalue',m,'first_satis_price_kdv',filterNum(document.getElementById('yeni_fiyat').value));
        
        
		sales_discount = window.opener.$("##jqxgrid").jqxGrid('getcellvalue', m,'sales_discount');
		
		if(sales_discount != '' && sales_discount != null)
            deger_ = sales_discount + '+' + commaSplit(fark_yuzde_,4);
        else
            deger_ = commaSplit(fark_yuzde_,4);
        
        window.opener.$("##jqxgrid").jqxGrid('setcellvalue',m,'sales_discount',deger_);
		window.opener.p_discount_calc(m,'sales_discount',deger_,1);
		window.close();
    }
    </cfoutput>
    </script>
<cfelse>
    <cf_popup_box title="Fiyat Hesaplayıcı">
        <cf_medium_list>
            <thead>
            <tr style="font-weight:bold;">
                <th>Alış Fiyatı</th>
                <th>Alış Fiyatı KDV'li</th>
                <th>Satılmak İstenen Fiyat</th>
                <th>Kar</th>
                <th>Yüzde İndirim</th>
                <th>Tutar İndirim</th>
                <th>Yeni Alış</th>
                <th>Yeni Alış KDV</th>
            </tr>
            <tbody>
            <tr>
                <td id="active_price"></td>
                <td id="active_price_kdv"></td>
                <td><input type="text" name="yeni_fiyat" id="yeni_fiyat" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));" value="" onBlur="hesapla();" style="width:63px;"></td>
                <td><input type="text" name="yeni_kar" id="yeni_kar" class="moneybox" onkeyup="return(FormatCurrency(this,event,0));" value="10" onBlur="hesapla();" style="width:30px;"></td>
                <td id="yuzde"></td>
                <td id="tutar"></td>
                <td id="yeni_alis"></td>
                <td id="yeni_alis_kdv"></td>
            </tr>
            </td>
            </thead>
        </cf_medium_list>
    </cf_popup_box>
    <script>
    <cfoutput>
    $(document).ready(function()
    {
        document.getElementById('active_price').innerHTML = window.opener.document.getElementById('NEW_ALIS_#attributes.product_id#').value;
        document.getElementById('active_price_kdv').innerHTML = window.opener.document.getElementById('NEW_ALIS_KDVLI_#attributes.product_id#').value;
        alis_kdv = parseInt(window.opener.document.getElementById('STANDART_ALIS_KDV_#attributes.product_id#').innerHTML);
        satis_kdv = parseInt(window.opener.document.getElementById('STANDART_SATIS_KDV_#attributes.product_id#').innerHTML);
        /*
        sales_discount_#attributes.product_id#
        p_discount_manuel_#attributes.product_id#
        */
        
        satis_kdv_rank = 1 + (satis_kdv / 100);
        alis_kdv_rank = 1 + (alis_kdv / 100);
        
        document.getElementById('yeni_fiyat').focus();
    });
    function hesapla()
    {
        deger_ = parseFloat(filterNum(document.getElementById('yeni_fiyat').value,4));
        kar_ = parseFloat(filterNum(document.getElementById('yeni_kar').value,4));
        
        //kar_rank_ = (100 + kar_) / 100;
        kar_rank_ = 1 - (kar_ / 100);
        
        old_ = filterNum(document.getElementById('active_price').innerHTML,4);
        
        satis_kdvli_yeni_maliyet = deger_ * kar_rank_;
        yeni_maliyet = satis_kdvli_yeni_maliyet / satis_kdv_rank;
        
        yeni_maliyet_kdv = yeni_maliyet * alis_kdv_rank;
        
        fark_ = old_ - yeni_maliyet;
        
        fark_yuzde_ = fark_ * 100 / old_;
        
        
        document.getElementById('tutar').innerHTML = '<a href="javascript://" onclick="manuel_deger_at();" class="tableyazi">' + commaSplit(fark_,4) + '</a>';
        document.getElementById('yuzde').innerHTML = '<a href="javascript://" onclick="yuzde_deger_at();" class="tableyazi">' + commaSplit(fark_yuzde_,4) + '</a>';
        document.getElementById('yeni_alis').innerHTML = commaSplit(yeni_maliyet,4);
        document.getElementById('yeni_alis_kdv').innerHTML = commaSplit(yeni_maliyet_kdv,4);
    }
    
    function manuel_deger_at()
    {
        window.opener.document.getElementById('p_ss_marj_#attributes.product_id#').value = document.getElementById('yeni_kar').value;
        window.opener.document.getElementById('FIRST_SATIS_PRICE_KDV_#attributes.product_id#').value = document.getElementById('yeni_fiyat').value;
        
        if(window.opener.document.getElementById('p_discount_manuel_#attributes.product_id#').value != '')
            window.opener.document.getElementById('p_discount_manuel_#attributes.product_id#').value = commaSplit(parseFloat(filterNum(window.opener.document.getElementById('p_discount_manuel_#attributes.product_id#').value)) + fark_,4);
        else
            window.opener.document.getElementById('p_discount_manuel_#attributes.product_id#').value = commaSplit(fark_,4);
        
        window.opener.p_discount_calc('#attributes.product_id#');
        /*
        window.opener.hesapla_first_sales('#attributes.product_id#','1');
        window.opener.duzenle_first_sales('#attributes.product_id#');
        */
        window.opener.hesapla_standart_satis('#attributes.product_id#','kdvli');
        
        window.close();
    }
    
    function yuzde_deger_at()
    {
        window.opener.document.getElementById('p_ss_marj_#attributes.product_id#').value = document.getElementById('yeni_kar').value;
        window.opener.document.getElementById('FIRST_SATIS_PRICE_KDV_#attributes.product_id#').value = document.getElementById('yeni_fiyat').value;
        
        if(window.opener.document.getElementById('sales_discount_#attributes.product_id#').value != '')
            window.opener.document.getElementById('sales_discount_#attributes.product_id#').value = window.opener.document.getElementById('sales_discount_#attributes.product_id#').value + '+' + commaSplit(fark_yuzde_,4);
        else
            window.opener.document.getElementById('sales_discount_#attributes.product_id#').value = commaSplit(fark_yuzde_,4);
        
        window.opener.p_discount_calc('#attributes.product_id#');
        /*
        window.opener.hesapla_first_sales('#attributes.product_id#','1');
        window.opener.duzenle_first_sales('#attributes.product_id#');
        */
        window.opener.hesapla_standart_satis('#attributes.product_id#','kdvli');
        window.close();
    }
    </cfoutput>
    </script>
</cfif>