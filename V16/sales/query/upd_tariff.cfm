<cfscript>
    Tariff = createObject("component", "V16.sales.cfc.tariff");
        LastId = Tariff.updTariffProduct(
            tariff_id : '#iif(isdefined("attributes.tariff_id"),"attributes.tariff_id",DE(""))#',
            active : '#iif(isdefined("attributes.active"),1,DE(0))#',
            tariff_name : '#iif(isdefined("attributes.tariff_name"),"attributes.tariff_name",DE(""))#',
            stock_id : '#iif(isdefined("attributes.stock_id"),"attributes.stock_id",DE(""))#',
            product_id : '#iif(isdefined("attributes.product_id"),"attributes.product_id",DE(""))#',
            unit_id : '#iif(isdefined("attributes.unit_id"),"attributes.unit_id",DE(""))#',
            product_unit : '#iif(isdefined("attributes.product_unit"),"attributes.product_unit",DE(""))#',
            price_list : '#iif(isdefined("attributes.price_list"),"attributes.price_list",DE(""))#',
            tariff_price : '#iif(isdefined("attributes.tariff_price"),"attributes.tariff_price",DE(""))#',
            money : '#iif(isdefined("attributes.money"),"attributes.money",DE(""))#'
    );
    </cfscript>

    
    <cfif isdefined("attributes.productRow") and len(attributes.productRow)>
        <cfset attributes.productRow = listLast(attributes.productRow)>
        <cfscript>
            for(kk=1;kk lte attributes.productRow;kk=kk+1)
                {
                    if(isdefined("attributes.satir#kk#") and evaluate("attributes.satir#kk#") eq 1)
                        {
                            Tariff.upd_additional_product(
                                additional_id : '#iif(isdefined("attributes.additional_id#kk#"),"attributes.additional_id#kk#",DE(""))#',
                                tariff_id : '#iif(isdefined("attributes.tariff_id"),"attributes.tariff_id",DE(""))#',
                                stock_id : '#iif(isdefined("attributes.stock_id#kk#"),"attributes.stock_id#kk#",DE(""))#',
                                product_id : '#iif(isdefined("attributes.product_id#kk#"),"attributes.product_id#kk#",DE(""))#',
                                hesaplama : '#iif(isdefined("attributes.hesaplama#kk#"),"attributes.hesaplama#kk#",DE(""))#',
                                urun_rakam : '#iif(isdefined("attributes.urun_rakam#kk#"),"attributes.urun_rakam#kk#",DE(""))#',
                                fiyatListesi : '#iif(isdefined("attributes.fiyatListesi#kk#"),"attributes.fiyatListesi#kk#",DE(""))#',
                                ozel_fiyat : '#iif(isdefined("attributes.ozel_fiyat#kk#"),"attributes.ozel_fiyat#kk#",DE(""))#',
                                money : '#iif(isdefined("attributes.money#kk#"),"attributes.money#kk#",DE(""))#'
                            );
                        }
                    else if(isdefined("attributes.satir#kk#") and evaluate("attributes.satir#kk#") eq 0)
                        {
                            Tariff.del_additional_product(
                                additional_id : '#iif(isdefined("attributes.additional_id#kk#"),"attributes.additional_id#kk#",DE(""))#'
                            );
                        }
                }
        </cfscript>
    </cfif>
    <cfif isdefined("attributes.taxRow") and len(attributes.taxRow)>
        <cfset attributes.taxRow = listLast(attributes.taxRow)>
        <cfscript>
            for(kk=1;kk lte attributes.taxRow;kk=kk+1)
                {
                    if(isdefined("attributes.satirTax#kk#") and evaluate("attributes.satirTax#kk#") eq 1)
                        {
                            Tariff.upd_tax_fund(
                                tax_funds_id : '#iif(isdefined("attributes.tax_funds_id#kk#"),"attributes.tax_funds_id#kk#",DE(""))#',
                                tariff_id : '#iif(isdefined("attributes.tariff_id"),"attributes.tariff_id",DE(""))#',
                                account_code : '#iif(isdefined("attributes.account_code#kk#"),"attributes.account_code#kk#",DE(""))#',
                                hesaplamaTax : '#iif(isdefined("attributes.hesaplamaTax#kk#"),"attributes.hesaplamaTax#kk#",DE(""))#',
                                rakamTax : '#iif(isdefined("attributes.rakamTax#kk#"),"attributes.rakamTax#kk#",DE(""))#',
                                tutar : '#iif(isdefined("attributes.tutar#kk#"),"attributes.tutar#kk#",DE(""))#',
                                moneyTax : '#iif(isdefined("attributes.moneyTax#kk#"),"attributes.moneyTax#kk#",DE(""))#'
                            );
                        }
                    else if(isdefined("attributes.satirTax#kk#") and evaluate("attributes.satirTax#kk#") eq 0)
                        {
                            Tariff.del_tax_fund(
                                tax_funds_id : '#iif(isdefined("attributes.tax_funds_id#kk#"),"attributes.tax_funds_id#kk#",DE(""))#'
                            );
                        }
                }
        </cfscript>
    </cfif>

    <script type="text/javascript">
        window.location.href="/<cfoutput>#request.self#?fuseaction=sales.tariff&event=upd&tariff_id=#attributes.tariff_id#</cfoutput>";
    </script>