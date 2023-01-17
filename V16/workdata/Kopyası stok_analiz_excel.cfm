
<table border="1">
<tr>
<cfif listfind('1,8',attributes.report_type,',')>
	<td>Stok Kodu</td>
</cfif>
<cfif attributes.report_type eq 1>
	<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
		<td>Özel Kod</td>
	</cfif>
</cfif>
	<td>
	<cfif attributes.report_type eq 1>Stok
	<cfelseif attributes.report_type eq 2>Ürün
	<cfelseif attributes.report_type eq 3>Kategori
	<cfelseif attributes.report_type eq 4>Sorumlu
	<cfelseif attributes.report_type eq 5>Marka
	<cfelseif attributes.report_type eq 6>Tedarik
	<cfelseif attributes.report_type eq 8>Stok
	<cfelseif attributes.report_type eq 9>Depo
	<cfelseif attributes.report_type eq 10>Lokasyon
	</cfif>
	</td>
<cfif listfind('1,2,8',attributes.report_type)>
	<td>Barkod</td>
</cfif>
<cfif attributes.report_type eq 8>
	<td>Main Spec</td>
</cfif>

<cfif listfind('1,2,8',attributes.report_type)>
    <td>Ürün Kodu</td>
    <td>Üretici Kodu</td>
    <td>Birim</td>
    <td>Stok Miktarı</td>
    <cfif isdefined('attributes.display_cost')>
        <td>Stok Maliyeti</td>
        <cfif isdefined('attributes.is_system_money_2')>
        <td>Maliyet</td>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
       <td>Alım Miktarı</td>
       <td>Alım İade Miktarı</td>
       <td>Net Alım Miktarı</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Alım Tutar</td>
            <td>Alım İade Tutarı</td>
            <td>Net Alım Tutarı</td>
            <cfif isdefined('attributes.is_system_money_2')>
                 <td>Alım Tutar</td>
                 <td>Alım İade Tutarı</td>
                 <td>Net Alım Tutarı</td>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
        <td>Satış Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Satış Maliyeti</td>
        </cfif>
        <td>Satış İade Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Satış İade Maliyeti</td>
        </cfif>
        <td>Net Satış Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Net Satış Maliyeti</td>
        </cfif>
        <cfif isdefined('attributes.from_invoice_actions')><!--- faturadan hesapla secilmisse --->
            <td>Fatura Satış Miktar</td>
            <td>Fatura Satış Tutar</td>
            <cfif isdefined('attributes.is_system_money_2')>
               <td>Fatura Satış Tutar</td>
            </cfif>
            <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
                <td>Fatura Satış Maliyet</td>
                <cfif isdefined('attributes.is_system_money_2')>
                <td>Fatura Satış Maliyet</td>
                </cfif>
            </cfif>
            <td>Fatura Satış İade Miktar</td>
            <td>Fatura Satış İade Tutar</td>
            <cfif isdefined('attributes.is_system_money_2')>
             <td>Fatura Satış İade Tutar</td>
            </cfif>
            <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
                <td>Fatura Satış İade Maliyet</td>
                <cfif isdefined('attributes.is_system_money_2')>
                <td>Fatura Satış İade Maliyet</td>
                </cfif>
            </cfif>
        </cfif>
        <cfif isdefined('attributes.display_cost')>
            <td>Net FaturaSatış Maliyeti </td>
            <cfif isdefined('attributes.is_system_money_2')>
                 <td>Satış Maliyeti</td>
                <td>Satış İade Maliyeti</td>
                 <td>Net Satış Maliyeti</td>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
        <td>Konsinye Çıkış Miktar</td>
        <cfif isdefined('attributes.display_cost')>
           <td>Konsinye Çıkış Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td>Konsinye Çıkış Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <!--- iade gelen konsinye --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
       <td>Konsinye İade Miktar</td>
        <cfif isdefined('attributes.display_cost')>
          <td> Konsinye İade Maliyet </td>
            <cfif isdefined('attributes.is_system_money_2')>
                  <td>Konsinye İade Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <!--- konsinye giriş iade--->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
        <td>Konsinye Giriş Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Konsinye Giriş Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                 <td>Konsinye Giriş Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <!--- konsinye giriş iade--->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
        <cfif isdefined('attributes.display_cost')>
            <td>Konsinye Giriş İade Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                 <td>Konsinye Giriş İade Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>				
        <td>Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                 <td>Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
        <td>Miktar</td>
        <cfif isdefined('attributes.display_cost')>
        <td>Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                 <td>Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
        <td>Miktar</td>
        <cfif isdefined('attributes.display_cost')>
        <td>Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td> Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
        <td>Miktar</td>
        <cfif isdefined('attributes.display_cost')>
        <td>Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td> Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <!---donemici uretim fişleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
        <td>Üretim Miktar</td>
        <cfif isdefined('attributes.display_cost')>
           <td>Üretim Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td>Üretim Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
       <td>Sarf Miktar</td>
        <td>Üretim Sarf Miktar</td>
       <td>Fire Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Sarf Maliyet</td>
            <td>Üretim Sarf Maliyet</td>
            <td>Fire Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
               <td>Sarf Maliyet</td>
               <td>Üretim Sarf Maliyet</td>
               <td>Fire Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
        <td>Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
            #session.ep.money2#Sayım Maliyet
            </cfif>
        </cfif>
    </cfif>
    <!--- demontajdan giris --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
        <td>Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                Demontajdan Giriş #session.ep.money2# Maliyet
            </cfif>
        </cfif>
    </cfif>
    <!--- demontaja giden --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
        <td>Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td>Demontaja Giden</td> <td>Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <!--- masraf fişleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
        <td>Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Maliyet</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td>Masraf Fişleri</td>
                <td>Maliyet</td>
            </cfif>
        </cfif>
    </cfif>
    <!--- depo sevk--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
        <td>Stok Giriş Miktar</td>
        <td>Stok Çıkış Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Stok Giriş Maliyeti</td>
            <td>Stok Çıkış Maliyeti</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td>Stok Giriş Maliyeti</td>
               <td>Stok Çıkış Maliyeti</td>
            </cfif>
        </cfif>
    </cfif>
    <!--- ithal mal girişi--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
        <td>Stok Giriş Miktar</td>
        <td>Stok Çıkış Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Stok Giriş Maliyeti</td>
            <td>Stok Çıkış Maliyeti</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td>Stok Giriş Maliyeti</td>
               <td>Stok Çıkış Maliyeti</td>
            </cfif>
        </cfif>
    </cfif>
    <!--- ambar fişi --->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
        <td>Stok Giriş Miktar</td>
        <td>Stok Çıkış Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Stok Giriş Maliyeti</td>
           <td>Stok Çıkış Maliyeti</td>
            <cfif isdefined('attributes.is_system_money_2')>
             <td>Stok Giriş Maliyeti</td>
             <td>Stok Çıkış Maliyeti</td>
            </cfif>
        </cfif>
    </cfif>
    <!--- stok virman --->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
        <td>Stok Giriş Miktar</td>
        <td>Stok Çıkış Miktar</td>
        <cfif isdefined('attributes.display_cost')>
            <td>Stok Giriş Maliyeti</td>
           	<td>Stok Çıkış Maliyeti</td>
            <cfif isdefined('attributes.is_system_money_2')>
                <td>Stok Giriş Maliyeti</td>
                <td>Stok Çıkış Maliyeti</td>
            </cfif>
        </cfif>
    </cfif>
 </cfif>
 
 
 		<td>Stok Miktar</td>
            <cfif isdefined('attributes.display_cost')>
				<TD>Stok Maliyet</TD>
				<cfif isdefined('attributes.is_system_money_2')>
					<td> Maliyet</td>
				</cfif>
				<cfif isdefined('attributes.display_ds_prod_cost')><!--- donem sonu stokta urun birim maliyetinin gosterilmesi secilmiş ise --->
					<td>Birim Maliyet</td>
					<cfif isdefined('attributes.is_system_money_2')>
						<td>Birim Maliyet</td>
					</cfif>
				</cfif>
			</cfif>
			<cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)>
				<td>Birim Hacim</td>
				<td>Toplam Hacim</td>
			</cfif>
			<cfif isdefined('attributes.stock_age')>
				<td>Stok Yaşı</td>
			</cfif>
</tr>       
        
        
     <cfoutput query="get_all_stock">   
	<tr>
	<cfif listfind('1,8',attributes.report_type,',')>
    	<td>#replace(GET_ALL_STOCK.STOCK_CODE,";","","all")#</td> 
    </cfif>
	<cfif attributes.report_type eq 1>
		<cfif isdefined("x_dsp_special_code") and x_dsp_special_code eq 1>
            <td>#stock_code_2#</td> 
        </cfif>
    </cfif> 
    
    <cfif listfind('1,8',attributes.report_type,',') and not listfind('1,2',attributes.is_excel)>
       <td>#GET_ALL_STOCK.ACIKLAMA#</td>
    <cfelseif attributes.report_type eq 2 and not listfind('1,2',attributes.is_excel)>
        <td>#GET_ALL_STOCK.ACIKLAMA#</td>
     <cfelse>
       <td>#replace(GET_ALL_STOCK.ACIKLAMA,";","","all")#</td>
    </cfif>
    
    <cfif listfind('1,2,8',attributes.report_type)>					
    	<td>#replace(GET_ALL_STOCK.BARCOD,";","","all")#</td>  
    </cfif>
    
    <cfif attributes.report_type eq 8>
		<cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                <td>#GET_ALL_STOCK.SPECT_VAR_ID#</td>  
                <cfif isdefined('x_dsp_spec_name') and x_dsp_spec_name eq 1>
                 <td>- #GET_ALL_STOCK.SPECT_NAME# </td>
                </cfif>
        <cfelse>
                <td>#GET_ALL_STOCK.SPECT_VAR_ID#</td>
        </cfif>
    </cfif>
    
    <cfif listfind('1,2,8',attributes.report_type)>					
         <td>#replace(GET_ALL_STOCK.PRODUCT_CODE,";","","all")#</td> 
    </cfif>
    
        <td>#replace(GET_ALL_STOCK.MANUFACT_CODE,";","","all")#</td> 
        
        <td>#replace(GET_ALL_STOCK.MAIN_UNIT,";","","all")#</td>
        
	<cfif isdefined("GET_ALL_STOCK.DB_STOK_MIKTAR") and len(GET_ALL_STOCK.DB_STOK_MIKTAR)>
        <td>#TLFormat(evaluate("#GET_ALL_STOCK.DB_STOK_MIKTAR#"),4)#</td>
    <cfelse>
        <td>#TLFormat(0,4)#</td>
    </cfif>
    
    <cfif isdefined('attributes.display_cost')>
        <td>#TLFormat(GET_ALL_STOCK.DB_STOK_MIKTAR*GET_ALL_STOCK.ALL_START_COST/1)#</td>
        <cfif isdefined("attributes.display_cost_money")>
            <td>#all_start_money#</td>
        <cfelse>
        </cfif>
        <cfif isdefined('attributes.is_system_money_2')>
            <td>#TLFormat(GET_ALL_STOCK.DB_STOK_MIKTAR*GET_ALL_STOCK.ALL_START_COST_2/1)#</td>
        </cfif>
    </cfif>
    <!--- alıs ve alıs iadeler bolumu --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,2)>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS") and len(GET_ALL_STOCK.TOPLAM_ALIS)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS,4)#</td>
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE") and len(GET_ALL_STOCK.TOPLAM_ALIS_IADE)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_IADE,4)#</td>
            </cfif>
        <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS-GET_ALL_STOCK.TOPLAM_ALIS_IADE,4)#</td>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_MALIYET") and len(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET)#</td> 
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_MALIYET") and len(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET)></cfif>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET") and len(GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET)#</td> 
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET") and len(GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET)></cfif>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET - GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET )#</td> 
                <cfif (GET_ALL_STOCK.TOPLAM_ALIS_MALIYET - GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET) neq 0></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2") and len(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2)>
                    <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2)#</td> 
                </cfif>
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2") and len(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2)></cfif>
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2") and len(GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2)>
                        <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2)#</td> 
                    </cfif>
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2") and len(GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2)></cfif>
                    <td>#TLFormat(GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2- GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2 )#</td> 
                <cfif (GET_ALL_STOCK.TOPLAM_ALIS_MALIYET_2- GET_ALL_STOCK.TOPLAM_ALIS_IADE_MALIYET_2) neq 0></cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- satıs ve satıs iade bolumu --->
	<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>
                <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS") and len(GET_ALL_STOCK.TOPLAM_SATIS)>
                    <td>#TLFormat(GET_ALL_STOCK.TOPLAM_SATIS,4)#</td> 
                </cfif>
            <cfif isdefined('attributes.display_cost')>
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS_MALIYET") and len(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET)>
                        <td>#TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET)#</td>
                    </cfif>
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS_MALIYET") and len(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET)></cfif>
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS_IADE") and len(GET_ALL_STOCK.TOPLAM_SATIS_IADE)>
                    <td>#TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_IADE,4)#</td>
                </cfif>
            <cfif isdefined('attributes.display_cost')>
                    <cfif isdefined("GET_ALL_STOCK.TOP_SAT_IADE_MALIYET") and len(GET_ALL_STOCK.TOP_SAT_IADE_MALIYET)>
                        <td>#TLFormat(GET_ALL_STOCK.TOP_SAT_IADE_MALIYET)#</td> 
                    </cfif>
                    <cfif isdefined("GET_ALL_STOCK.TOP_SAT_IADE_MALIYET") and len(GET_ALL_STOCK.TOP_SAT_IADE_MALIYET)></cfif>
            </cfif>
                <td>#TLFormat((GET_ALL_STOCK.TOPLAM_SATIS - GET_ALL_STOCK.TOPLAM_SATIS_IADE),4)#</td>
             <cfif isdefined('attributes.display_cost')>
                    <td>#TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET - GET_ALL_STOCK.TOP_SAT_IADE_MALIYET)#</td>
                    <cfif (GET_ALL_STOCK.TOPLAM_SATIS_MALIYET - GET_ALL_STOCK.TOP_SAT_IADE_MALIYET) neq 0>
                    	
                    </cfif>
            </cfif>
            
            
            <cfif isdefined('attributes.from_invoice_actions')><!--- satıs fatura tutarı --->
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MIKTAR") and len(GET_ALL_STOCK.FATURA_SATIS_MIKTAR)>
                       <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_MIKTAR)#</td>
                    </cfif>	
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_TUTAR") and len(GET_ALL_STOCK.FATURA_SATIS_TUTAR)>
                        <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_TUTAR)# </td>
                    </cfif>	
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_TUTAR") and len(GET_ALL_STOCK.FATURA_SATIS_TUTAR)></cfif>
                <cfif isdefined('attributes.is_system_money_2')>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_TUTAR_2") and len(GET_ALL_STOCK.FATURA_SATIS_TUTAR_2)>
                            <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_TUTAR_2)#</td> 
                        </cfif>	
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_TUTAR_2") and len(GET_ALL_STOCK.FATURA_SATIS_TUTAR_2)></cfif>
                </cfif>
                <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MALIYET") and len(GET_ALL_STOCK.FATURA_SATIS_MALIYET)>
                            <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_MALIYET)#</td> 
                        </cfif>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MALIYET") and len(GET_ALL_STOCK.FATURA_SATIS_MALIYET)></cfif>
                    <cfif isdefined('attributes.is_system_money_2')>
                            <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MALIYET_2") and len(GET_ALL_STOCK.FATURA_SATIS_MALIYET_2)>
                                <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_MALIYET_2)#</td> 
                            </cfif>	
                            <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MALIYET_2") and len(GET_ALL_STOCK.FATURA_SATIS_MALIYET_2)></cfif>
                    </cfif>
                </cfif>
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_MIKTAR") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_MIKTAR)>
                        <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_MIKTAR,4)#</td>
                    </cfif>	
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR)>
                        <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR)#</td> 
                    </cfif>
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR)></cfif>
                <cfif isdefined('attributes.is_system_money_2')>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR_2") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR_2)>
                            <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR_2)#</td> 
                        </cfif>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR_2") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_TUTAR_2)></cfif>
                </cfif>
                <cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET)>
                            <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET)#</td> 
                        </cfif>
                        <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET)></cfif>
                    <cfif isdefined('attributes.is_system_money_2')>
                            <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET_2") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET_2)>
                                <td>#TLFormat(GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET_2)#</td> 
                            </cfif>	
                            <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET_2") and len(GET_ALL_STOCK.FATURA_SATIS_IADE_MALIYET_2)></cfif>
                    </cfif>
                </cfif>
            </cfif>
            <cfif isdefined('attributes.display_cost')>
                    <cfif isdefined("GET_ALL_STOCK.FATURA_SATIS_MIKTAR")>
                    <td>#TLFormat(((GET_ALL_STOCK.FATURA_SATIS_MIKTAR - GET_ALL_STOCK.FATURA_SATIS_IADE_MIKTAR)*GET_ALL_STOCK.ALL_FINISH_COST)/1)# </td>
                    <cfelse>
                    <td>
                    ADASD
                    </td>
                    </cfif>
                <cfif isdefined('attributes.is_system_money_2')>	 				
                    <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2") and len(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2)>
                        <td>#TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2)#</td> 
                    </cfif>
                        <cfif isdefined("GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2") and len(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2)></cfif>
                    <cfif isdefined("GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2") and len(GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2)>
                        <td>#TLFormat(GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2)#</td>
                    </cfif>
                        <cfif isdefined("GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2") and len(GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2)></cfif>
                        <td>#TLFormat(GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2-GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2)#</td> 
                        <cfif (GET_ALL_STOCK.TOPLAM_SATIS_MALIYET_2-GET_ALL_STOCK.TOP_SAT_IADE_MALIYET_2) neq 0> </cfif>
                </cfif>
            </cfif>
    </cfif>
    <!--- Konsinye cikis irs. --->
   	<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>
            <cfif isdefined("GET_ALL_STOCK.KONS_CIKIS_MIKTAR") and len(GET_ALL_STOCK.KONS_CIKIS_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.KONS_CIKIS_MIKTAR,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.KONS_CIKIS_MALIYET") and len(GET_ALL_STOCK.KONS_CIKIS_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.KONS_CIKIS_MALIYET)#</td> 	
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.KONS_CIKIS_MALIYET") and len(GET_ALL_STOCK.KONS_CIKIS_MALIYET)></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.KONS_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.KONS_CIKIS_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.KONS_CIKIS_MALIYET_2)#</td> 	
                </cfif>
                    <cfif isdefined("GET_ALL_STOCK.KONS_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.KONS_CIKIS_MALIYET_2)></cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- konsinye iade gelen --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,7)>
            <cfif isdefined("GET_ALL_STOCK.KONS_IADE_MIKTAR") and len(GET_ALL_STOCK.KONS_IADE_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.KONS_IADE_MIKTAR,4)#</td>
            <cfelse>
            	<TD>0</TD>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.KONS_IADE_MALIYET") and len(GET_ALL_STOCK.KONS_IADE_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.KONS_IADE_MALIYET)#</td> 	
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.KONS_IADE_MALIYET") and len(GET_ALL_STOCK.KONS_IADE_MALIYET)></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                    <cfif isdefined("GET_ALL_STOCK.KONS_IADE_MALIYET_2") and len(GET_ALL_STOCK.KONS_IADE_MALIYET_2)>								
                        <td>#TLFormat(GET_ALL_STOCK.KONS_IADE_MALIYET_2)#</td> 
                    </cfif>
                    <cfif isdefined("GET_ALL_STOCK.KONS_IADE_MALIYET_2") and len(GET_ALL_STOCK.KONS_IADE_MALIYET_2)></cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- Konsinye Giriş İrs. --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,19)>
            <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_MIKTAR") and len(GET_ALL_STOCK.KONS_GIRIS_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.KONS_GIRIS_MIKTAR,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_MALIYET") and len(GET_ALL_STOCK.KONS_GIRIS_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.KONS_GIRIS_MALIYET)#</td> 	
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_MALIYET") and len(GET_ALL_STOCK.KONS_GIRIS_MALIYET)></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_MALIYET_2") and len(GET_ALL_STOCK.KONS_GIRIS_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.KONS_GIRIS_MALIYET_2)#</td> 	
                </cfif>
                    <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_MALIYET_2") and len(GET_ALL_STOCK.KONS_GIRIS_MALIYET_2)></cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- Konsinye Giriş İade İrs. --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,20)>
            <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_IADE_MIKTAR") and len(GET_ALL_STOCK.KONS_GIRIS_IADE_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.KONS_GIRIS_IADE_MIKTAR,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET") and len(GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET)#</td> 	
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET") and len(GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET)></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET_2") and len(GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET_2)#</td> 	
                </cfif>
                    <cfif isdefined("GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET_2") and len(GET_ALL_STOCK.KONS_GIRIS_IADE_MALIYET_2)></cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- Teknik Servis Giriş --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,8)>
            <cfif isdefined("GET_ALL_STOCK.SERVIS_GIRIS_MIKTAR") and len(GET_ALL_STOCK.SERVIS_GIRIS_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.SERVIS_GIRIS_MIKTAR,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SERVIS_GIRIS_MALIYET") and len(GET_ALL_STOCK.SERVIS_GIRIS_MALIYET)>
                <td>#TLFormat(GET_ALL_STOCK.SERVIS_GIRIS_MALIYET)#</td> 
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.SERVIS_GIRIS_MALIYET") and len(GET_ALL_STOCK.SERVIS_GIRIS_MALIYET)></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SERVIS_GIRIS_MALIYET_2") and len(GET_ALL_STOCK.SERVIS_GIRIS_MALIYET_2)>
                    <td>#TLFormat(GET_ALL_STOCK.SERVIS_GIRIS_MALIYET_2)#</td> 
                </cfif>
                    <cfif isdefined("GET_ALL_STOCK.SERVIS_GIRIS_MALIYET_2") and len(GET_ALL_STOCK.SERVIS_GIRIS_MALIYET_2)></cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- Teknik Servis Çıkış --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,9)>
            <cfif isdefined("GET_ALL_STOCK.SERVIS_CIKIS_MIKTAR") and len(GET_ALL_STOCK.SERVIS_CIKIS_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.SERVIS_CIKIS_MIKTAR,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SERVIS_CIKIS_MALIYET") and len(GET_ALL_STOCK.SERVIS_CIKIS_MALIYET)>
                <td>#TLFormat(GET_ALL_STOCK.SERVIS_CIKIS_MALIYET)#</td>
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.SERVIS_CIKIS_MALIYET") and len(GET_ALL_STOCK.SERVIS_CIKIS_MALIYET)></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SERVIS_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.SERVIS_CIKIS_MALIYET_2)>
                    <td>#TLFormat(GET_ALL_STOCK.SERVIS_CIKIS_MALIYET_2)#</td> 
                </cfif>
                    <cfif isdefined("GET_ALL_STOCK.SERVIS_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.SERVIS_CIKIS_MALIYET_2)></cfif>
            </cfif>
        </cfif>
    </cfif>  
    <!--- RMA Giriş --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,11)>
            <cfif isdefined("GET_ALL_STOCK.RMA_GIRIS_MIKTAR") and len(GET_ALL_STOCK.RMA_GIRIS_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.RMA_GIRIS_MIKTAR,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.RMA_GIRIS_MALIYET") and len(GET_ALL_STOCK.RMA_GIRIS_MALIYET)>
                <td>#TLFormat(GET_ALL_STOCK.RMA_GIRIS_MALIYET)#</td> 
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.RMA_GIRIS_MALIYET") and len(GET_ALL_STOCK.RMA_GIRIS_MALIYET)></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                    <cfif isdefined("GET_ALL_STOCK.RMA_GIRIS_MALIYET_2") and len(GET_ALL_STOCK.RMA_GIRIS_MALIYET_2)>
                        <td>#TLFormat(GET_ALL_STOCK.RMA_GIRIS_MALIYET_2)#</td> 
                    </cfif>
                    <cfif isdefined("GET_ALL_STOCK.RMA_GIRIS_MALIYET_2") and len(GET_ALL_STOCK.RMA_GIRIS_MALIYET_2)></cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- RMA Çıkış --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,10)>
            <cfif isdefined("GET_ALL_STOCK.RMA_CIKIS_MIKTAR") and len(GET_ALL_STOCK.RMA_CIKIS_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.RMA_CIKIS_MIKTAR,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
                <cfif isdefined("GET_ALL_STOCK.RMA_CIKIS_MALIYET") and len(GET_ALL_STOCK.RMA_CIKIS_MALIYET)>
                    <td>#TLFormat(GET_ALL_STOCK.RMA_CIKIS_MALIYET)#</td> 
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.RMA_CIKIS_MALIYET") and len(GET_ALL_STOCK.RMA_CIKIS_MALIYET)></cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                    <cfif isdefined("GET_ALL_STOCK.RMA_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.RMA_CIKIS_MALIYET_2)>
                        <td>#TLFormat(GET_ALL_STOCK.RMA_CIKIS_MALIYET_2)#</td> 
                    </cfif>
                    <cfif isdefined("GET_ALL_STOCK.RMA_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.RMA_CIKIS_MALIYET_2)></cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- uretim fisleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,4)>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_URETIM") and len(GET_ALL_STOCK.TOPLAM_URETIM)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_URETIM,4)#</cfif></td>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.URETIM_MALIYET") and len(GET_ALL_STOCK.URETIM_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.URETIM_MALIYET)#</td> 
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.URETIM_MALIYET_2") and len(GET_ALL_STOCK.URETIM_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.URETIM_MALIYET_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- sarf ve fire fisleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,5)>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_SARF") and len(GET_ALL_STOCK.TOPLAM_SARF)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_SARF,4)#</td>
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_URETIM_SARF") and len(GET_ALL_STOCK.TOPLAM_URETIM_SARF)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_URETIM_SARF,4)#</td>
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_FIRE") and len(GET_ALL_STOCK.TOPLAM_FIRE)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_FIRE,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SARF_MALIYET") and len(GET_ALL_STOCK.SARF_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.SARF_MALIYET)#</td> 	
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.URETIM_SARF_MALIYET") and len(GET_ALL_STOCK.URETIM_SARF_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.URETIM_SARF_MALIYET)#</td> 	
            </cfif>
                <cfif isdefined("GET_ALL_STOCK.FIRE_MALIYET") and len(GET_ALL_STOCK.FIRE_MALIYET)>								
                    <td>#TLFormat(GET_ALL_STOCK.FIRE_MALIYET)#</td> 	
                </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SARF_MALIYET_2") and len(GET_ALL_STOCK.SARF_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.SARF_MALIYET_2)#</td> 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.URETIM_SARF_MALIYET_2") and len(GET_ALL_STOCK.URETIM_SARF_MALIYET_2)>								
                   <td>#TLFormat(GET_ALL_STOCK.URETIM_SARF_MALIYET_2)#</td> 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.FIRE_MALIYET_2") and len(GET_ALL_STOCK.FIRE_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.FIRE_MALIYET_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- sayim fisleri --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,12)>
		<cfif isdefined("GET_ALL_STOCK.TOPLAM_SAYIM") and len(GET_ALL_STOCK.TOPLAM_SAYIM)>
            <td>#TLFormat(GET_ALL_STOCK.TOPLAM_SAYIM,4)#</td>
        </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SAYIM_MALIYET") and len(GET_ALL_STOCK.SAYIM_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.SAYIM_MALIYET)#</td> 	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SAYIM_MALIYET_2") and len(GET_ALL_STOCK.SAYIM_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.SAYIM_MALIYET_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- demontajdan giris --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,14)>
            <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIRIS") and len(GET_ALL_STOCK.DEMONTAJ_GIRIS)>
                <td>#TLFormat(GET_ALL_STOCK.DEMONTAJ_GIRIS,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET") and len(GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET)#</td> 
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET_2") and len(GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.DEMONTAJ_GIRIS_MALIYET_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- demontaja giden --->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,13)>
            <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIDEN") and len(GET_ALL_STOCK.DEMONTAJ_GIDEN)>
                <td>#TLFormat(GET_ALL_STOCK.DEMONTAJ_GIDEN,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET") and len(GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET)#</td>	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET_2") and len(GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.DEMONTAJ_GIDEN_MALIYET_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!--- masraf fişleri--->
    <cfif len(attributes.process_type) and listfind(attributes.process_type,15)>
            <cfif isdefined("GET_ALL_STOCK.TOPLAM_MASRAF_MIKTAR") and len(GET_ALL_STOCK.TOPLAM_MASRAF_MIKTAR)>
                <td>#TLFormat(GET_ALL_STOCK.TOPLAM_MASRAF_MIKTAR,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.MASRAF_MALIYET") and len(GET_ALL_STOCK.MASRAF_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.MASRAF_MALIYET)#</td>	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.MASRAF_MALIYET_2") and len(GET_ALL_STOCK.MASRAF_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.MASRAF_MALIYET_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!---depo sevk : giris-cıkıs stok bilgileri ayrı kolonlarda--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,16)>
            <cfif isdefined("GET_ALL_STOCK.SEVK_GIRIS_MIKTARI") and len(GET_ALL_STOCK.SEVK_GIRIS_MIKTARI)>
                <td>#TLFormat(GET_ALL_STOCK.SEVK_GIRIS_MIKTARI,4)#</td>
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.SEVK_CIKIS_MIKTARI") and len(GET_ALL_STOCK.SEVK_CIKIS_MIKTARI)>
                <td>#TLFormat(GET_ALL_STOCK.SEVK_CIKIS_MIKTARI,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.SEVK_GIRIS_MALIYETI") and len(GET_ALL_STOCK.SEVK_GIRIS_MALIYETI)>								
                <td>#TLFormat(GET_ALL_STOCK.SEVK_GIRIS_MALIYETI)#</td>
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.SEVK_CIKIS_MALIYETI") and len(GET_ALL_STOCK.SEVK_CIKIS_MALIYETI)>								
                <td>#TLFormat(GET_ALL_STOCK.SEVK_CIKIS_MALIYETI)#</td>	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.SEVK_GIRIS_MALIYETI_2") and len(GET_ALL_STOCK.SEVK_GIRIS_MALIYETI_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.SEVK_GIRIS_MALIYETI_2)#</td>	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.SEVK_CIKIS_MALIYETI_2") and len(GET_ALL_STOCK.SEVK_CIKIS_MALIYETI_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.SEVK_CIKIS_MALIYETI_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!---ithal mal girişi: giris-cıkıs stok bilgileri ayrı kolonlarda--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,17)>
            <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_GIRIS_MIKTARI") and len(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MIKTARI)>
                <td>#TLFormat(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MIKTARI,4)#</td>
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_CIKIS_MIKTARI") and len(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MIKTARI)>
                <td>#TLFormat(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MIKTARI,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
            <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI") and len(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI)>								
               <td>#TLFormat(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI)#</td>	
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI") and len(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI)>								
                <td>#TLFormat(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI)#</td>	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI_2") and len(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.ITHAL_MAL_GIRIS_MALIYETI_2)#</td> 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI_2") and len(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.ITHAL_MAL_CIKIS_MALIYETI_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!---ambar fişi--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,18)>
            <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_GIRIS_MIKTARI") and len(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MIKTARI)>
                <td>#TLFormat(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MIKTARI,4)#</td>
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_CIKIS_MIKTARI") and len(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MIKTARI)>
                <td>#TLFormat(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MIKTARI,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
                <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI") and len(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI)>								
                    <td>#TLFormat(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI)#</td>	
                </cfif>
            <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET") and len(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET)#</td>	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI_2") and len(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.AMBAR_FIS_GIRIS_MALIYETI_2)#</td> 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.AMBAR_FIS_CIKIS_MALIYET_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <!---stok virman--->
    <cfif len(attributes.department_id) and len(attributes.process_type) and listfind(attributes.process_type,21)>
            <cfif isdefined("GET_ALL_STOCK.stok_virman_GIRIS_MIKTARI") and len(GET_ALL_STOCK.stok_virman_GIRIS_MIKTARI)>
                <td>#TLFormat(GET_ALL_STOCK.stok_virman_GIRIS_MIKTARI,4)#</td>
            </cfif>
            <cfif isdefined("GET_ALL_STOCK.stok_virman_CIKIS_MIKTARI") and len(GET_ALL_STOCK.stok_virman_CIKIS_MIKTARI)>
                <td>#TLFormat(GET_ALL_STOCK.stok_virman_CIKIS_MIKTARI,4)#</td>
            </cfif>
        <cfif isdefined('attributes.display_cost')>
                <cfif isdefined("GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI") and len(GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI)>								
                    <td>#TLFormat(GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI)#</td>	
                </cfif>
            <cfif isdefined("GET_ALL_STOCK.stok_virman_CIKIS_MALIYET") and len(GET_ALL_STOCK.stok_virman_CIKIS_MALIYET)>								
                <td>#TLFormat(GET_ALL_STOCK.stok_virman_CIKIS_MALIYET)#</td>	
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif isdefined("GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI_2") and len(GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI_2)>								
                    <tD>#TLFormat(GET_ALL_STOCK.stok_virman_GIRIS_MALIYETI_2)#</tD> 	
                </cfif>
                <cfif isdefined("GET_ALL_STOCK.stok_virman_CIKIS_MALIYET_2") and len(GET_ALL_STOCK.stok_virman_CIKIS_MALIYET_2)>								
                    <td>#TLFormat(GET_ALL_STOCK.stok_virman_CIKIS_MALIYET_2)#</td> 	
                </cfif>
            </cfif>
        </cfif>
    </cfif>
	<cfif isdefined("GET_ALL_STOCK.TOTAL_STOCK") and len(GET_ALL_STOCK.TOTAL_STOCK)>
            <cfset donem_sonu_stok=GET_ALL_STOCK.TOTAL_STOCK>
            <td>#TLFormat(GET_ALL_STOCK.TOTAL_STOCK,4)#</td>
        <cfelse>
            <td>#TLFormat(0,4)#</td>
        </cfif>
    <cfif isdefined('attributes.display_cost')>
        <cfif wrk_round(GET_ALL_STOCK.TOTAL_STOCK) neq 0>
            <cfif (GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST) neq 0>
            </cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                <cfif (GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST_2) neq 0>
                </cfif>
            </cfif>
        </cfif>
            <td>#TLFormat(GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST)#</td>
        <cfif isdefined('attributes.is_system_money_2')>
                <td>#TLFormat(GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST_2)#</td>
        </cfif>
        <cfif isdefined('attributes.display_ds_prod_cost')><!--- birim maliyet --->
                <cfif wrk_round(GET_ALL_STOCK.TOTAL_STOCK) neq 0>
                	<td>#TLFormat(GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST/GET_ALL_STOCK.TOTAL_STOCK)#</td>
              	</cfif>
            <cfif isdefined('attributes.is_system_money_2')>
                    <cfif wrk_round(donem_sonu_stok) neq 0><tD>#TLFormat(GET_ALL_STOCK.TOTAL_STOCK*GET_ALL_STOCK.ALL_FINISH_COST_2/GET_ALL_STOCK.TOTAL_STOCK)#</tD></cfif>
            </cfif>
        </cfif>
    </cfif>
    <cfif isdefined('attributes.display_prod_volume') and listfind('1,2,8',attributes.report_type)>
        <cfif len(GET_ALL_STOCK.DIMENTION)>
            <cfif attributes.volume_unit eq 1>
                <cfset prod_volume = evaluate(GET_ALL_STOCK.DIMENTION)>
            <cfelseif attributes.volume_unit eq 2>
                <cfset prod_volume = evaluate(GET_ALL_STOCK.DIMENTION)/ 1000>
            <cfelseif attributes.volume_unit eq 3>
                <cfset prod_volume = evaluate(GET_ALL_STOCK.DIMENTION) / 1000000>
            </cfif>
        </cfif>
        <td>
            <cfif len(GET_ALL_STOCK.DIMENTION)>#prod_volume#</cfif>
        </td>
        <td>
            <cfif wrk_round(donem_sonu_stok) neq 0 and len(GET_ALL_STOCK.DIMENTION)>#prod_volume*wrk_round(GET_ALL_STOCK.TOTAL_STOCK)# </cfif>
    	</td>
    </cfif>
    <cfif isdefined('attributes.stock_age')>
        <cfset agirlikli_toplam=0>
        <cfif donem_sonu_stok gt 0>
            <cfset kalan=donem_sonu_stok>
            <cfquery name="get_product_detail" dbtype="query">
                SELECT 
                    AMOUNT AS PURCHASE_AMOUNT,
                    GUN_FARKI 
                FROM 
                    GET_STOCK_AGE 
                WHERE 
                    #ALAN_ADI# =<cfif attributes.report_type eq 8>'#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#'<cfelse>#GET_ALL_STOCK.PRODUCT_GROUPBY_ID#</cfif>
                ORDER BY ISLEM_TARIHI DESC
            </cfquery>
            <cfloop query="get_product_detail">
                <cfif kalan gt 0 and PURCHASE_AMOUNT lte kalan>
                    <cfset kalan = kalan - PURCHASE_AMOUNT>
                    <cfset agırlıklı_toplam=  agırlıklı_toplam + (PURCHASE_AMOUNT*GUN_FARKI)>
                <cfelseif kalan gt 0 and PURCHASE_AMOUNT gt kalan>
                    <cfset agırlıklı_toplam=  agırlıklı_toplam + (kalan*GUN_FARKI)>
                    <cfbreak>
                </cfif>
            </cfloop>
            <cfset agırlıklı_toplam=agırlıklı_toplam/donem_sonu_stok>
        </cfif>
		<td>            
			<cfif agırlıklı_toplam gt 0>#TLFormat(agırlıklı_toplam)#</cfif>
       </td>
    </cfif>
    </tr>
	</cfoutput>
  </table> 
   
   
    <cfabort>


    
    
    

