<script>
    var tree_row_count = 0,
        sales_price_round_num = '<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>';

    <cfif attributes.type eq 'upd'>
        if(document.all.order_id != undefined) document.add_spect_variations.order_id.value = document.all.order_id.value;//order dan geliyorsa popupı açan sayfadan order_id almak için
        if(document.all.upd_id != undefined) document.add_spect_variations.ship_id.value=opener.document.all.upd_id.value;//ship_id icin
    </cfif>

    <cfif isDefined("GET_SPECT_TREE")>
        tree_row_count = <cfoutput>#GET_SPECT_TREE.RECORDCOUNT#</cfoutput>;
    <cfelseif isDefined("GET_PROD_TREE")>
        tree_row_count = <cfoutput>#GET_PROD_TREE.RECORDCOUNT#</cfoutput>;
    </cfif>

    <cfif isdefined("GET_MAIN_PRICE")>
		var product_rate=<cfoutput>#GET_MAIN_PRICE.RATE2/GET_MAIN_PRICE.RATE1#</cfoutput>;
		var product_rate2=<cfoutput>#GET_MAIN_PRICE.RATE1/GET_MAIN_PRICE.RATE2#</cfoutput>;
	<cfelse>
		var product_rate=1;
		var product_rate2=1;
	</cfif>

    <cfif x_is_spec_type eq 1 or x_is_spec_type eq 3 or (x_is_spec_type eq 4 and get_product_info.is_production neq 1)>

        <cfif is_mix_product eq 0>

            function open_product_detail(pro_id,s_id)
            {
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+pro_id+'&sid='+s_id,'list'); 
            }

            function open_tree_add_row()
            {
                var money='';
                var islem_tarih='<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>';
                satir =-1 ;
                if(moneyArray!=undefined && rate2Array!=undefined && rate1Array!=undefined)
                    for(var i=0;i<moneyArray.length;i++) money=money+'&'+moneyArray[i]+'='+parseFloat(rate2Array[i]/rate1Array[i]);
                else money=money+'<cfoutput query="get_money">&#get_money.money#=#get_money.rate2/get_money.rate1#</cfoutput>';
                if(form_basket != undefined && form_basket.search_process_date != undefined) islem_tarih = document.getElementById(form_basket.search_process_date.value).value;
                windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&_spec_page_=2&update_product_row_id=0&<cfif isdefined("attributes.company_id")>company_id=#attributes.company_id#</cfif></cfoutput>&is_sale_product=1'+money+'&rowCount='+tree_row_count+'&search_process_date='+islem_tarih+'&sepet_process_type=-1&int_basket_id=<cfoutput>#attributes.basket_id#</cfoutput><cfif isdefined('attributes.unsalable')>&unsalable=1</cfif>&is_condition_sale_or_purchase=1&config_tree=1&satir='+satir,'list');//is_price=1&is_price_other=1&is_cost=1&
            }

            function UrunDegis(field,no,type)
            {
                var urun_para_birimi = document.getElementById('urun_para_birimi'+list_getat(field.value,4,',')).value;
                if(type==undefined)gizle(document.getElementById('SHOW_PRODUCT_TREE_ROW'+no));//ürün değiştiğinde değişen ürüne ait açılmış bir detayı varsa kapatıyoruz.
                var _stock_id_ = list_getat(field.value,2,',');//stock id göndererek main spect id'si varsa onu alıyoruz.
                var _is_production_ = list_getat(field.value,8,',')//is_production olup olmadığı
                if(type==undefined)
                {	
                    if(_is_production_ == 1)
                    {
                        var deger = workdata('get_main_spect_id',_stock_id_);
                        if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
                        var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
                        document.getElementById('related_spect_main_id'+no).value = SPECT_MAIN_ID;//spect_main_id değiştir.
                        goster(document.getElementById('under_tree'+no));//alt ağaç ikonunu göster
                    } 
                    else
                    {
                        gizle(document.getElementById('under_tree'+no));
                        document.getElementById('related_spect_main_id'+no).value ='';
                    }
                }	
                var price = list_getat(field.value,5,',');//5.ci eleman sistem para birimini ifade ediyor(YTL).
                if(price=="")price=0;
                var miktar = parseFloat(filterNum(document.getElementById('tree_amount'+no).value,8));
                if(isNaN(miktar) == true || miktar<=0 || miktar==''){document.getElementById('tree_amount'+no).value=1;miktar=1;}//alert(miktar);
                var fark = miktar*(price-parseFloat(filterNum(document.getElementById('reference_std_money'+no).value,8),8));//alert(fark);
                main_product_rate=product_rate2;
                form_total_amount=filterNum(document.getElementById('tree_total_amount'+no).value,8);//fiyat farkı
                document.getElementById('tree_total_amount'+no).value = commaSplit(parseFloat(form_total_amount-main_product_rate*(filterNum(document.getElementById('tree_std_money'+no).value,8)-price)),8);//fiyat farkı yazdırılıyor 
                document.getElementById('tree_diff_price'+no).value = commaSplit(fark/urun_para_birimi,8);//seçilen ürünün para birimi  bazında fiyat farkı
                //seçilen ürünün para birimi bazında fiyat farkı
                document.getElementById('tree_std_money'+no).value=commaSplit(price,8);//satırdaki fiyat yazdırılıyor(seçilen alternatif ürünün fiyatı YTL olarak)
                hesapla_();
            }

            function add_basket_row_(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_,product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id)
            {
                if(document.getElementById('value_stock_id').value==stock_id)
                {
                    alert("<cf_get_lang dictionary_id ='33934.Ana ürünü kendine bileşen olarak ekleyemezsiniz'>!");
                    return false;
                }
                add_spect_variations.is_change.value=1;
                if(money != document.add_spect_variations.main_prod_price_currency.value)
                    price_other=wrk_round(price*product_rate2,8);//ana ürün fiyat dışındaki bir para biri ise onun ana ürün fiyatı cinsinden fiyat farkı
                tree_row_count++;
                var newRow;
                var newCell;
                newRow = document.getElementById("product_tree").insertRow(document.getElementById("product_tree").rows.length);
                newRow.setAttribute("name","tree_row" + tree_row_count);
                newRow.setAttribute("id","tree_row" + tree_row_count);		
                newRow.setAttribute("NAME","tree_row" + tree_row_count);
                newRow.setAttribute("ID","tree_row" + tree_row_count);
                document.add_spect_variations.tree_record_num.value=tree_row_count;
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<input type="hidden" id="tree_is_configure'+tree_row_count+'" name="tree_is_configure'+tree_row_count+'" value="1"><input type="hidden" id="tree_row_kontrol'+tree_row_count+'"  name="tree_row_kontrol'+tree_row_count+'" value="1"><input type="hidden" name="tree_product_id'+tree_row_count+'" id="tree_product_id'+tree_row_count+'" value="'+product_id+','+stock_id+','+price_other+','+money+','+price+',0,'+product_name+' "><a href="javascript://" onClick="sil_tree_row('+tree_row_count+')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='50765.Ürün Sil'>"></i></a>';
                <cfif isdefined('is_show_line_number') and is_show_line_number eq 1>
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML = '<td></td>';
                </cfif>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="hidden" name="tree_stock_id'+tree_row_count+'" id="tree_stock_id'+tree_row_count+'" value="'+stock_id+'"><input type="text" name="tree_stock_code'+tree_row_count+'" value="'+stock_code+'" style="width:120px" readonly></div>';
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><div class="input-group col-12"><input type="text" name="tree_product_name'+tree_row_count+'" id="tree_product_name'+tree_row_count+'" value="'+product_name+'" readonly><span class="input-group-addon btnPointer icon-ellipsis"  onclick="open_product_detail('+product_id+','+stock_id+')"> </span></div></div>';
                //spec
                newCell = newRow.insertCell(newRow.cells.length);
                if(is_production==1)//üretilen ürün ise ve spectli bir ürün seçilmemiş ise
                    {
                        if(spect_id == '')
                        {
                            var deger = workdata('get_main_spect_id',stock_id);
                            if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
                            {
                                var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;
                                var SPECT_MAIN_NAME =deger.SPECT_MAIN_NAME;
                            }
                            else
                            {
                                var SPECT_MAIN_ID ='';
                                var SPECT_MAIN_NAME ='';
                            }
                        }
                        else if(spect_id != '')
                            {
                                var _get_main_spect_ = wrk_safe_query('obj_get_main_spect','dsn3',0,spect_id);
                                var SPECT_MAIN_ID = _get_main_spect_.SPECT_MAIN_ID;
                                var SPECT_MAIN_NAME = _get_main_spect_.SPECT_VAR_NAME;
                            }
                        newCell.innerHTML = '<div class="form-group"><input name="related_spect_main_name'+tree_row_count+'" id="related_spect_main_name'+tree_row_count+'"  value="'+SPECT_MAIN_NAME+'" readonly></div>';
                        //newCell.innerHTML = '<input name="related_spect_main_id'+tree_row_count+'" id="related_spect_main_id'+tree_row_count+'" style="width:43px;" class="box" value="'+SPECT_MAIN_ID+'" readonly>';
                    }
                else	
                {
                    var SPECT_MAIN_NAME = "";
                    newCell.innerHTML = '<div class="form-group"><input name="related_spect_main_name'+tree_row_count+'" id="related_spect_main_name'+tree_row_count+'"  value="'+SPECT_MAIN_NAME+'" readonly></div>';
                }
                //spec	
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input name="related_spect_main_id'+tree_row_count+'" id="related_spect_main_id'+tree_row_count+'" style="col col-12" class="box" value="" readonly></div>';
                //sb
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="checkbox" name="tree_is_sevk'+tree_row_count+'" id="tree_is_sevk'+tree_row_count+'" value="1"></div>';
                //sb
                //alt ağaç
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '';
                //alt ağaç
                //miktar
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="tree_amount'+tree_row_count+'" id="tree_amount'+tree_row_count+'" value="1" class="moneybox" style="col col-12" onBlur="hesapla_();"></div>';
                //miktar
                //fiyat farkı
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group" <cfif isdefined('is_show_diff_price') and is_show_diff_price eq 0> style="display:none;"</cfif>><input type="hidden" name="tree_total_amount'+tree_row_count+'" id="tree_total_amount'+tree_row_count+'" value="'+commaSplit(price_other,8)+'" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla_();" style="width:80px"><input type="text" name="tree_diff_price'+tree_row_count+'" id="tree_diff_price'+tree_row_count+'" value="'+commaSplit(price/document.getElementById('urun_para_birimi'+money).value,8)+'" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" onBlur="hesapla_();" style="width:80px"><input type="hidden" name="tree_kdvstd_money'+tree_row_count+'" value=""></div>';
                //fiyat farkı
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none;"</cfif>><input name="tree_total_amount_money'+tree_row_count+'" id="tree_total_amount_money'+tree_row_count+'" class="box" readonly  type="text" value="'+money+'" class="moneybox"></div>';//para br
                //maliyet
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group" <cfif not isdefined('is_show_cost') or (isdefined('is_show_cost') and is_show_cost eq 0)>style = "display:none;"</cfif>><input type="text" name="tree_product_cost'+tree_row_count+'" id="tree_product_cost'+tree_row_count+'" value="'+commaSplit(net_maliyet,8)+'" readonly class="moneybox"></div>';
                //maliyet
                //toplam miktar sistem para birimini tutar
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group" <cfif isdefined('is_show_price') and is_show_price eq 0> style="display:none;"</cfif>><input type="text" name="tree_std_money'+tree_row_count+'" id="tree_std_money'+tree_row_count+'" value="'+commaSplit(price,8)+'" class="moneybox"><input type="hidden" name="reference_std_money'+tree_row_count+'" id="reference_std_money'+tree_row_count+'" value="'+commaSplit(price,8)+'"style="width:50px"><input type="hidden" name="old_tree_std_money'+tree_row_count+'" value="'+commaSplit(price,8)+'"></div>';
                //toplam miktar
                <cfif isdefined('get_conf.origin') and get_conf.origin eq 3>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><select name="tree_types'+tree_row_count+'" id="tree_types'+tree_row_count+'"><option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option><cfoutput query="get_tree_types"><option value="#TYPE_ID#">#TYPE#</option></cfoutput></select></div>';
                </cfif>
                <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_WIDTH) and get_conf.USE_WIDTH eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="product_width'+tree_row_count+'" id="product_width'+tree_row_count+'"></div>';
                </cfif>
                <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_SIZE) and get_conf.USE_SIZE eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="product_size'+tree_row_count+'" id="product_size'+tree_row_count+'"></div>';
                </cfif>
                <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_HEIGHT) and get_conf.USE_HEIGHT eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="product_height'+tree_row_count+'" id="product_height'+tree_row_count+'"></div>';
                </cfif>
                <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_THICKNESS) and get_conf.USE_THICKNESS eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="product_thickness'+tree_row_count+'" id="product_thickness'+tree_row_count+'"></div>';
                </cfif>
                <cfif isdefined('get_conf.origin') and get_conf.origin eq 3 and len(get_conf.USE_FIRE) and get_conf.USE_FIRE eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.innerHTML = '<div class="form-group"><input type="text" name="fire_amount'+tree_row_count+'" id="fire_amount'+tree_row_count+'"></div>';
                </cfif>
                hesapla_();
            }
            <cfif len(get_conf.ORIGIN) and len(get_conf.USE_COMPONENT) and get_conf.USE_COMPONENT and get_conf.ORIGIN eq 3 and attributes.type eq 'add' and len(get_conf.USE_PRODUCT_IDS)>
            <cfquery name="GET_PROD_TREE" datasource="#DSN3#">
                SELECT 
                    *
                FROM
                    STOCKS
                WHERE
                    
                    STOCK_ID IN (#get_conf.USE_PRODUCT_IDS#)
            </cfquery>
            <cfoutput query="GET_PROD_TREE">
            <cfquery name="get_price" datasource="#dsn3#" maxrows="1">
                SELECT
                    PRICE,MONEY
                FROM
                    PRICE_STANDART
                WHERE
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
                    UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_UNIT_ID#">
                    AND PURCHASESALES = 1
                    AND PRICESTANDART_STATUS = 1
                ORDER BY
                    START_DATE DESC,
                    RECORD_DATE DESC
            </cfquery>
            add_basket_row_('#PRODUCT_ID#', '#STOCK_ID#', '#STOCK_CODE#', '#BARCOD#','','#PRODUCT_NAME#','','', '', '', '#get_price.price#', '#get_price.price#', '', '', '', '', '', '',  '', '', '', '', '', '', '', '', '', '','#get_price.money#', '', '','','','','','','','','','','','','');
            </cfoutput>
            </cfif>
            function sil_tree_row(sy)
            {
                if( confirm( "<cf_get_lang dictionary_id='62142.Silmek istediğinize emin misiniz?'>" ) ){
                    var my_element=document.getElementById("tree_row_kontrol"+sy);
                    my_element.value=0;
                    var my_element=document.getElementById("tree_row"+sy);
                    my_element.style.display="none";
                    hesapla_();
                }
            }

            function configurator_control(){
               
                <cfif isdefined("attributes.from_product_config")>
                add_spect_variations.action+="&"+add_spect_variations.basket_add_parameters.value;
                </cfif>
                
                <!--- <cfif len(get_conf.ORIGIN) and ((get_conf.ORIGIN eq 1 or get_conf.ORIGIN eq 2) or ((len(get_conf.USE_COMPONENT) and get_conf.USE_COMPONENT) and get_conf.ORIGIN eq 3))> --->
                if(document.add_spect_variations.tree_record_num.value==0)
                {
                    alert("<cf_get_lang dictionary_id='60234.Satıra Ürün Ekleyiniz'>!");
                    return false;	
                }
                hesapla_();
                //ağaç
                if( add_spect_variations.tree_record_num != undefined && parseInt(add_spect_variations.tree_record_num.value) > 0 ){
                    for (var r=1;r<=add_spect_variations.tree_record_num.value;r++)
                    {
                        form_tree_amount = $("form[name = add_spect_variations] #tree_amount"+ r +"");
                        form_tree_total_amount = $("form[name = add_spect_variations] #tree_total_amount"+ r +"");
                        form_tree_diff_price = $("form[name = add_spect_variations] #tree_diff_price"+ r +"");
                        form_tree_product_cost = $("form[name = add_spect_variations] #tree_product_cost"+ r +"");
                        form_reference_std_money = $("form[name = add_spect_variations] #reference_std_money"+ r +"");
                        form_old_tree_std_money = $("form[name = add_spect_variations] #old_tree_std_money"+ r +"");
                        form_tree_std_money = $("form[name = add_spect_variations] #tree_std_money"+ r +"");
                        
                        form_tree_amount.val(filterNum(form_tree_amount.val(),8));
                        form_tree_total_amount.val(filterNum(form_tree_total_amount.val(),8));
                        form_tree_diff_price.val(filterNum(form_tree_diff_price.val(),8));
                        form_tree_product_cost.val(filterNum(form_tree_product_cost.val(),8));
                        form_reference_std_money.val(filterNum(form_reference_std_money.val(),8));
                        if(form_old_tree_std_money.val() != undefined){form_old_tree_std_money.val(filterNum(form_old_tree_std_money.val(),8));}
                        form_tree_std_money.val(filterNum(form_tree_std_money.val(),8));
                    }
                }
                <!--- </cfif> --->
                <cfif x_is_spec_type eq 3 and isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1><!--- Özellikler görüntülenmek isteniyorsa --->
                    //özellikler
                    if( add_spect_variations.pro_record_num != undefined && parseInt(add_spect_variations.pro_record_num.value) > 0 ){
                        for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)
                        {
                            form_pro_tolerance = $("form[name = add_spect_variations] #pro_tolerance"+ r +"");
                            form_pro_amount = $("form[name = add_spect_variations] #pro_amount"+ r +"");
                            form_pro_total_amount = $("form[name = add_spect_variations] #pro_total_amount"+ r +"");
                            pro_total_min = $("form[name = add_spect_variations] #pro_total_min"+ r +"");
                            pro_total_max = $("form[name = add_spect_variations] #pro_total_max"+ r +"");
                            pro_dimension = $("form[name = add_spect_variations] #pro_dimension"+ r +"");
                            
                            if(form_pro_tolerance.val() != undefined){form_pro_tolerance.val(filterNum(form_pro_tolerance.val(),8));}
                            if(form_pro_amount.val() != undefined){form_pro_amount.val(filterNum(form_pro_amount.val(),8));}
                            if(form_pro_total_amount.val() != undefined){form_pro_total_amount.val(filterNum(form_pro_total_amount.val(),8));}
                            if(pro_total_min.val() != undefined){pro_total_min.val(filterNum(pro_total_min.val(),8));}
                            if(pro_total_max.val() != undefined){pro_total_max.val(filterNum(pro_total_max.val(),8));}
                            if(pro_dimension.val() != undefined){pro_dimension.val(filterNum(pro_dimension.val(),8));}
                        }
                    }
                </cfif>

                //test parametreleri
                <cfif len(get_conf.ORIGIN) and ((get_conf.ORIGIN eq 1 or get_conf.ORIGIN eq 2) or ((len(get_conf.USE_COMPONENT) and get_conf.USE_COMPONENT) and get_conf.ORIGIN eq 3))>
                if( add_spect_variations.testParameterCount != undefined && parseInt(add_spect_variations.testParameterCount.value) > 0 ){
                    for (var r=1;r<=add_spect_variations.testParameterCount.value;r++)
                    {
                        standart_value = $("form[name = add_spect_variations] #standart_value"+ r +"");
                        quality_measure = $("form[name = add_spect_variations] #quality_measure"+ r +"");
                        tolerance = $("form[name = add_spect_variations] #tolerance"+ r +"");
                        
                        standart_value.val(filterNum(standart_value.val(),2));
                        quality_measure.val(filterNum(quality_measure.val(),2));
                        tolerance.val(filterNum(tolerance.val(),2));
                    }
                }
                </cfif>

                //döviz kurları
                for (var r=1;r<=add_spect_variations.rd_money_num.value;r++)
                {
                    form_txt_rate1 = $("form[name = add_spect_variations] #txt_rate1_"+ r +"");
                    form_txt_rate2 = $("form[name = add_spect_variations] #txt_rate2_"+ r +"");
                    form_txt_rate1.val(filterNum(form_txt_rate1.val(),8));
                    form_txt_rate2.val(filterNum(form_txt_rate2.val(),8));
                }
                add_spect_variations.toplam_miktar.value = filterNum(add_spect_variations.toplam_miktar.value,8);
                add_spect_variations.other_toplam.value = filterNum(add_spect_variations.other_toplam.value,8);	
                <cfif not isdefined("attributes.product_id")>
                    if(add_spect_variations.is_change.value!=1)add_spect_variations.is_change.value=1;
                </cfif>

                add_spect_variations.new_price.value = filterNum(add_spect_variations.new_price.value,2);
                
                return true;
            }

            function hesapla_()
            {
                var is_change = 0, //spect üzerinde değişiklik yapılıp yapılmadığını tutmak için
                    toplam_deger = 0;

                for (var r=1;r<=add_spect_variations.tree_record_num.value;r++)
                {
                    if(document.getElementById('tree_row_kontrol'+r)!=undefined && document.getElementById('tree_row_kontrol'+r).value!='0' && document.getElementById('tree_is_configure'+r).value == 1)
                    {
                        form_amount = document.getElementById('tree_amount'+r);
                        form_total_amount = document.getElementById('tree_total_amount'+r);
                        form_total_amount.value = filterNum(form_total_amount.value,4);
                        if(form_amount.value == "")
                            value_form_amount = 0;
                        else
                            value_form_amount = filterNum(form_amount.value,4);
                        if(form_total_amount.value == "")
                            form_total_amount.value = 0;
                        toplam_deger = toplam_deger + (value_form_amount*form_total_amount.value);
                        form_total_amount.value=commaSplit(form_total_amount.value,4);
                        if(document.getElementById('tree_product_id'+r).selectedIndex>0 && is_change!=1)is_change=1;
                    }
                }
                toplam_deger=parseFloat(toplam_deger*product_rate,4);
                <cfif x_is_spec_type eq 3 and isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1 and isdefined("is_show_property_price") and is_show_property_price eq 1 and isdefined('is_show_property_amount') and is_show_property_amount eq 1 and  isdefined('is_show_tolerance_property') and is_show_tolerance_property eq 1><!--- ÖZellikler görüntülenmek isteniyorsa --->
                    for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)
                    {
                        is_change=1;
                        form_sum_amount = document.getElementById('pro_sum_amount'+r);
                        form_amount = document.getElementById('pro_amount'+r);
                        form_total_amount = document.getElementById('pro_total_amount'+r);
                        form_money_type = document.getElementById('pro_money_type'+r);
                        form_total_amount.value = filterNum(form_total_amount.value,4);
                        form_sum_amount.value=commaSplit(filterNum(form_amount.value)*filterNum(form_total_amount.value),4);
                        if(form_amount.value == "")
                            value_form_amount = 0;
                        else
                            value_form_amount = filterNum(form_amount.value,4);
                        if(form_total_amount.value == "")
                            form_total_amount.value = 0;
                        value_money_type = form_money_type.value.split(',');
                        value_money_type_ilk = value_money_type[0];
                        value_money_type_son = value_money_type[1];
                        toplam_deger = toplam_deger + (value_form_amount*(form_total_amount.value*(value_money_type_son/value_money_type_ilk)));
                        form_total_amount.value = commaSplit(form_total_amount.value,4);
                    }
                </cfif>
                $("form[ name = add_spect_variations ] #toplam_miktar").val( parseFloat(add_spect_variations.main_std_money.value,4) + parseFloat(toplam_deger,4) );
                for(var j = 0; j < add_spect_variations.rd_money.length; j++)
                {
                    if(document.add_spect_variations.rd_money[j].checked)
                    {
                        value_deger_rd_money_orta = filterNum(eval('add_spect_variations.txt_rate1_'+(j+1)).value,4);
                        value_deger_rd_money_son = filterNum(eval('add_spect_variations.txt_rate2_'+(j+1)).value,4);
                        value_deger_rd_money_ilk = eval('add_spect_variations.rd_money_name_'+(j+1)).value;
                    }
                }
                if(!value_deger_rd_money_son || (value_deger_rd_money_son!=undefined && value_deger_rd_money_son.value==''))
                {
                    value_deger_rd_money_orta=1;
                    value_deger_rd_money_son=1;
                }
                var toplam_miktar = $("form[ name = add_spect_variations ] #toplam_miktar").val() != '' ? $("form[ name = add_spect_variations ] #toplam_miktar").val() : 0;
                $("form[ name = add_spect_variations ] #doviz_name").val( value_deger_rd_money_ilk );
                $("form[ name = add_spect_variations ] #other_toplam").val( commaSplit(parseFloat(toplam_miktar,4) * (parseFloat(value_deger_rd_money_orta,4)/parseFloat(value_deger_rd_money_son,4)),4) );
                $("form[ name = add_spect_variations ] #toplam_miktar").val( commaSplit(toplam_miktar,4) );
                $("form[ name = add_spect_variations ] #is_change").val( is_change );
            }

            function calculate_spects(field_name_list)
            {
                for(i=1;i<=list_len(field_name_list)-1;i++)
                {
                    var control = 'control'+list_getat(field_name_list,i,',');
                    if(document.getElementById(control).value!=1)
                    {	var spect_id = 'related_spect_main_id'+list_getat(field_name_list,i,',');
                        var stock_id = 'stock_id'+list_getat(field_name_list,i,',');
                        var deger = workdata('get_main_spect_id',document.getElementById(stock_id).value);
                        if(deger.SPECT_MAIN_ID != undefined)//ürün üretilsede ağacı olmayabilir,o sebeble fonksiyondan undefined değeri dönebilir,hata olursa  boşaltıyoruz spect_main_id'yi
                        var SPECT_MAIN_ID =deger.SPECT_MAIN_ID;else	var SPECT_MAIN_ID ='';
                        //alert(document.getElementById(eval('add_spect_variations.spect_main_id#attributes.satir#_#satir#')).value);//=SPECT_MAIN_ID;
                        document.getElementById(spect_id).value=SPECT_MAIN_ID
                        document.getElementById(spect_id).style.background ='CCCCCC';
                        document.getElementById(control).value=1;
                    }	
                }
            }
            <cfif len(get_conf.ORIGIN) and get_conf.ORIGIN eq 1 and  not len(get_conf.WIDGET_FRIENDLY_NAME) >
            hesapla_();
            </cfif>

        <cfelse>

            row_count=<cfoutput>#recordnumber#</cfoutput>;

            function test()
            {
                
                sql = "SELECT PDP.PROPERTY_ID,PP.PROPERTY FROM PRODUCT_DT_PROPERTIES PDP,PRODUCT_PROPERTY PP WHERE PDP.PROPERTY_ID = PP.PROPERTY_ID AND PDP.PRODUCT_ID=" + $('#product_id').val() ;
                get_product_ = wrk_query(sql,'DSN1');
                $('#prod_detail').empty();
                
                $('#prod_detail').append('<option value="">Seçiniz</option>');
                for ( var i = 0; i < get_product_.recordcount; i++ ) {
                    $("#prod_detail").append('<option value='+get_product_.PROPERTY_ID[i]+'>'+get_product_.PROPERTY[i]+'</option>');
                }
            }
                
            function open_spec_page(row)
            {
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=add_spect_variations.spec_main_id'+row+'&field_name=add_spect_variations.spec_name'+row+'&is_display=1&stock_id='+document.getElementById('stock_id'+row).value,'list');
            }
        
            function sil(sy)
            {
                if(confirm("<cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'>")){
                    var is_liste_fiyat = <cfoutput>#get_product_price_lists.recordcount#</cfoutput>
                    if (is_liste_fiyat == "" || is_liste_fiyat == 0){
                        var my_element=eval("add_spect_variations.row_kontrol"+sy);
                        my_element.value=0;
                        var my_element=eval("frm_row"+sy);
                        my_element.style.display="none";
                        hesapla_();
                    } else alert("<cf_get_lang dictionary_id ='37785.Ürün Silmek İçin Öncelikle Liste Fiyatlarını Siliniz'>.");
                }	
            }
            function clearSpecM(row){
                if(document.getElementById('spec_name'+row).value =="")
                    document.getElementById('spec_main_id'+row).value ="";
            }
            function add_row(stockid,stockprop,sirano,product_id,product_name,stock_code,property,manufact_code,tax,tax_purchase,add_unit,product_unit_id,money,is_serial_no,discount1,discount2,discount3,discount4,discount5,discount6,discount7,discount8,discount9,discount10,del_date_no,p_price,s_price,product_cost,extra_product_cost,is_production,list_price,other_list_price,spec_main_id,spec_main_name)
            {
                row_count++;
                var newRow;
                var newCell;
                newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
                newRow.className = 'color-row';
                newRow.setAttribute("name","frm_row" + row_count);
                newRow.setAttribute("id","frm_row" + row_count);		
                newRow.setAttribute("NAME","frm_row" + row_count);
                newRow.setAttribute("ID","frm_row" + row_count);
                document.add_spect_variations.record_num.value=row_count;
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap');
                newCell.innerHTML='<a style="cursor:pointer" onclick="sil('+row_count+');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='37111.Ürünü Sil'>"></i></a>';
                <cfif isdefined('is_show_line_number') and is_show_line_number eq 1>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap');
                newCell.innerHTML=row_count;
                </cfif>
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap');
                newCell.innerHTML='<div class="form-group"><input type="text" name="stock_code_'+row_count+'" id="stock_code_'+row_count+'" value="'+stock_code+'" readonly></div>';
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap');
                newCell.innerHTML = '<input type="hidden" value="1" id="row_kontrol'+row_count+'" name="row_kontrol'+row_count+'">';
                newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="stock_id'+row_count+'" name="stock_id'+row_count+'" value="' + stockid + '">';
                newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="product_id'+row_count+'" name="product_id'+row_count+'" value="'+product_id+'">';
                newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="unit_id'+row_count+'" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
                newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><div class="input-group"><input type="text" name="product_name' + row_count + '" id="product_name' + row_count + '" style="width:150px;"  value="'+product_name+' - '+property+'"><span class="input-group-addon icon-ellipsis btn_Pointer" onClick="pencere_ac('+product_id+');" title="<cf_get_lang dictionary_id ='37786.Ürün Seç'>"></span></div></div>';
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap');
                newCell.innerHTML = '<div class="form-group"><div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="text" id="spec_main_id'+row_count+'" name="spec_main_id'+row_count+'" title="Spec Main ID" value="'+spec_main_id+'" style="width:35px;" readonly></div><div class="col col-8 col-md-8 col-sm-8 col-xs-12"><div class="input-group"><input type="text" style="width:100px;" id="spec_name'+row_count+'" name="spec_name'+row_count+'" value="'+spec_main_name+'" onChange="clearSpecM('+row_count+')"> <span class="input-group-addon icon-ellipsis btn_Pointer" onClick="open_spec_page('+row_count+');"></span></div></div></div>';
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap');
                newCell = newRow.insertCell(newRow.cells.length);
                newCell.setAttribute('nowrap','nowrap');
                newCell.innerHTML = '<div class="form-group"><input type="text" name="tax' + row_count + '" id="tax' + row_count + '"  value="' + commaSplit(tax,0) + '" class="moneybox" readonly="yes"></div>';
                newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="action_profit_margin' + row_count + '" id="action_profit_margin' + row_count + '"  value="0">';
                /*newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="action_price' + row_count + '" >';*/
                newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="duedate' + row_count + '" id="duedate' + row_count + '"  value="0">';
                newCell.innerHTML = newCell.innerHTML + '<input type="hidden"  name="shelf_id' + row_count + '"><input type="hidden" name="shelf_name' + row_count + '" value="">';
                newCell = newRow.insertCell(newRow.cells.length);//birim maliyet
                newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input type="text" readonly="readonly" id="products_cost'+row_count+'" name="products_cost'+row_count+'" value="' + commaSplit(product_cost,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '" class="moneybox"></div>';
                newCell = newRow.insertCell(newRow.cells.length);//Ek maliyet
                newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input type="text" readonly="readonly" id="extra_product_cost'+row_count+'" name="extra_product_cost'+row_count+'" value="' + commaSplit(extra_product_cost,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '" class="moneybox"></div>';//ek maliyet
                newCell = newRow.insertCell(newRow.cells.length);//Liste Fiyatı
                newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input type="text" readonly="readonly" id="list_price'+row_count+'" name="list_price'+row_count+'" value="' + commaSplit(list_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '" class="moneybox"></div>';
                newCell = newRow.insertCell(newRow.cells.length);//Döviz Liste Fiyatı
                newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input type="text" onKeyUp="hesapla_row(1,'+row_count+');" id="other_list_price'+row_count+'" name="other_list_price'+row_count+'" value="' + commaSplit(other_list_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '" class="moneybox"></div>';
                newCell = newRow.insertCell(newRow.cells.length);//Para birimi
                c = '<div class="form-group"><select name="product_money' + row_count  +'" id="product_money' + row_count  +'" onChange="hesapla_row(1,'+row_count+');">';
                    <cfoutput query="get_money">
                    if('#money#' == money)
                        c += '<option value="#money#;#rate2#" selected>#money#</option>';
                    else
                        c += '<option value="#money#;#rate2#">#money#</option>';
                    </cfoutput>
                    newCell.innerHTML =c+ '</select></div>';
                newCell = newRow.insertCell(newRow.cells.length);//Satış Fiyatı
                newCell.setAttribute('nowrap','nowrap');
                newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="s_price' + row_count + '" name="s_price' + row_count + '" onKeyUp="hesapla_row(3,'+row_count+');"  value="' + commaSplit(s_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"  style="width:80px;" onBlur="if(this.value==\'\')this.value=0;calculate_amount(' + row_count + ');" class="moneybox"><span class="input-group-addon icon-ellipsis btn_Pointer" onclick="open_price(' + row_count + ');"></span><input type="hidden" name="p_price' + row_count + '" value="' + commaSplit(p_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"><input type="hidden" name="profit_margin' + row_count + '" value="0"></div></div>';
                newCell = newRow.insertCell(newRow.cells.length);//Miktar
                newCell.innerHTML = '<div class="form-group"><input type="text" name="row_amount' + row_count + '" id="row_amount' + row_count + '" value="1" onBlur="calculate_amount(' + row_count + ');" class="moneybox"></div>';
                newCell = newRow.insertCell(newRow.cells.length);//Toplam Maliyet
                newCell.innerHTML = '<div class="form-group"><input type="text" name="total_product_cost' + row_count + '" id="total_product_cost' + row_count + '" readonly value="1" onBlur="calculate_amount(' + row_count + ');" class="moneybox"></div>';
                newCell = newRow.insertCell(newRow.cells.length);//Toplam satış fiyatı
                newCell.innerHTML = '<div class="form-group"><input type="text" name="total_product_price' + row_count + '" id="total_product_price' + row_count + '"readonly value="1" onBlur="calculate_amount(' + row_count + ');" class="moneybox"></div>';
                
                calculate_amount(row_count);
            }		
            function pencere_ac(no)
            {
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&is_sub_category=1&pid='+no,'medium');
            }
            function getShelf(no)
            {
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_shelf&shelf_id=add_spect_variations.shelf_id'+no+'&shelf_name=add_spect_variations.shelf_name'+no,'medium');
            }
            function openProducts()
            {
                windowopen('<cfoutput>#request.self#?fuseaction=product.popup_stocks&price_cat=-2<cfif isdefined("attributes.compid")>&compid=<cfoutput>#attributes.compid#</cfoutput></cfif>&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists='</cfoutput>,'page');
            }
            function configurator_control()
            {
                <cfif isdefined("attributes.from_product_config")>
                add_spect_variations.action+="&"+add_spect_variations.basket_add_parameters.value;
                </cfif>
                if(document.add_spect_variations.record_num.value==0)
                {
                    alert("<cf_get_lang dictionary_id='60234.Satıra Ürün Ekleyiniz'>!");
                    return false;
                }

                hesapla_();

                if( add_spect_variations.record_num != undefined && parseInt(add_spect_variations.record_num.value) > 0 ){
                    for(var r=1; r <= document.add_spect_variations.record_num.value; r++)
                    {

                        p_price = $("form[name = add_spect_variations] #p_price"+ r +"");
                        s_price = $("form[name = add_spect_variations] #s_price"+ r +"");
                        extra_product_cost = $("form[name = add_spect_variations] #extra_product_cost"+ r +"");
                        products_cost = $("form[name = add_spect_variations] #products_cost"+ r +"");
                        total_product_cost = $("form[name = add_spect_variations] #total_product_cost"+ r +"");
                        total_product_price = $("form[name = add_spect_variations] #total_product_price"+ r +"");
                        row_amount = $("form[name = add_spect_variations] #row_amount"+ r +"");
                        tax = $("form[name = add_spect_variations] #tax"+ r +"");
                        list_price = $("form[name = add_spect_variations] #list_price"+ r +"");
                        other_list_price = $("form[name = add_spect_variations] #other_list_price"+ r +"");

                        p_price.val(filterNum(p_price.val(),sales_price_round_num));
                        s_price.val(filterNum(s_price.val(),sales_price_round_num));
                        extra_product_cost.val(filterNum(extra_product_cost.val(),sales_price_round_num));
                        products_cost.val(filterNum(products_cost.val(),sales_price_round_num));
                        total_product_cost.val(filterNum(total_product_cost.val(),sales_price_round_num));
                        total_product_price.val(filterNum(total_product_price.val(),sales_price_round_num));
                        row_amount.val(filterNum(row_amount.val(),sales_price_round_num));
                        tax.val(filterNum(tax.val(),sales_price_round_num));
                        list_price.val(filterNum(list_price.val(),sales_price_round_num));
                        other_list_price.val(filterNum(other_list_price.val(),sales_price_round_num));

                    }
                }
                
                <cfif x_is_spec_type eq 3 and isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1><!--- Özellikler görüntülenmek isteniyorsa --->
                    //özellikler
                    if( add_spect_variations.pro_record_num != undefined && parseInt(add_spect_variations.pro_record_num.value) > 0 ){
                        for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)
                        {
                            form_pro_tolerance = $("form[name = add_spect_variations] #pro_tolerance"+ r +"");
                            form_pro_amount = $("form[name = add_spect_variations] #pro_amount"+ r +"");
                            form_pro_total_amount = $("form[name = add_spect_variations] #pro_total_amount"+ r +"");
                            pro_total_min = $("form[name = add_spect_variations] #pro_total_min"+ r +"");
                            pro_total_max = $("form[name = add_spect_variations] #pro_total_max"+ r +"");
                            pro_dimension = $("form[name = add_spect_variations] #pro_dimension"+ r +"");
                            
                            form_pro_tolerance.val(filterNum(form_pro_tolerance.val(),8));
                            form_pro_amount.val(filterNum(form_pro_amount.val(),8));
                            form_pro_total_amount.val(filterNum(form_pro_total_amount.val(),8));
                            pro_total_min.val(filterNum(pro_total_min.val(),8));
                            pro_total_max.val(filterNum(pro_total_max.val(),8));
                            pro_dimension.val(filterNum(pro_dimension.val(),8));
                        }
                    }
                </cfif>

                //test parametreleri
                if( add_spect_variations.testParameterCount != undefined && parseInt(add_spect_variations.testParameterCount.value) > 0 ){
                    for (var r=1;r<=add_spect_variations.testParameterCount.value;r++)
                    {
                        standart_value = $("form[name = add_spect_variations] #standart_value"+ r +"");
                        quality_measure = $("form[name = add_spect_variations] #quality_measure"+ r +"");
                        tolerance = $("form[name = add_spect_variations] #tolerance"+ r +"");
                        
                        standart_value.val(filterNum(standart_value.val(),2));
                        quality_measure.val(filterNum(quality_measure.val(),2));
                        tolerance.val(filterNum(tolerance.val(),2));
                    }
                }

                //döviz kurları
                for (var r=1;r<=add_spect_variations.rd_money_num.value;r++)
                {
                    form_txt_rate1 = $("form[name = add_spect_variations] #txt_rate1_"+ r +"");
                    form_txt_rate2 = $("form[name = add_spect_variations] #txt_rate2_"+ r +"");
                    form_txt_rate1.val(filterNum(form_txt_rate1.val(),8));
                    form_txt_rate2.val(filterNum(form_txt_rate2.val(),8));
                }
                add_spect_variations.toplam_miktar.value = filterNum(add_spect_variations.toplam_miktar.value,8);
                add_spect_variations.other_toplam.value = filterNum(add_spect_variations.other_toplam.value,8);	
                <cfif not isdefined("attributes.product_id")>
                    if(add_spect_variations.is_change.value!=1)add_spect_variations.is_change.value=1;
                </cfif>

                add_spect_variations.new_price.value = filterNum(add_spect_variations.new_price.value,2);

                return true;
            }
            function calculate_amount(rowno)
            {
                var money_count = <cfoutput>#GET_MONEY.RECORDCOUNT#</cfoutput>;
                var temp_products_cost = parseFloat(filterNum(document.getElementById('products_cost'+rowno).value,sales_price_round_num));
                var temp_extra_product_cost = parseFloat(filterNum(document.getElementById('extra_product_cost'+rowno).value,sales_price_round_num));
                var temp_row_amount = document.getElementById('row_amount'+rowno).value != '' ? parseFloat(filterNum(document.getElementById('row_amount'+rowno).value,sales_price_round_num)) : 0;
                document.getElementById('total_product_cost'+rowno).value = commaSplit( ( (temp_products_cost + temp_extra_product_cost)* temp_row_amount ),sales_price_round_num);//Burada birim maliyet ve ek maliyeti toplayarak miktar ile çarpıyoruz.
                
                <cfloop query="GET_MONEY">
                if(list_getat(document.getElementById('product_money'+rowno).value,1,';') == '<cfoutput>#money#</cfoutput>')
                {
                    //KDV 'li eval("document.add_spect_variations.total_product_price"+rowno).value = commaSplit(Number((Number(filterNum(eval('document.add_spect_variations.tax'+rowno).value)) + 100) / 100) * Number(filterNum(eval('document.add_spect_variations.s_price'+rowno).value)*(filterNum(eval('document.add_spect_variations.row_amount'+rowno).value))));//Burada liste satış fiyatı kdv oranı ve miktarı ile çarpılıyor.
                    document.getElementById('total_product_price'+rowno).value = commaSplit(Number(filterNum(document.getElementById('s_price'+rowno).value,sales_price_round_num)*(filterNum(document.getElementById('row_amount'+rowno).value,sales_price_round_num))),sales_price_round_num);//Burada liste satış fiyatı kdv oranı ve miktarı ile çarpılıyor.
                    //eval("document.add_spect_variations.total_product_price"+rowno).value = commaSplit((<cfoutput>#GET_MONEY.RATE2#</cfoutput>)*filterNum(eval("document.add_spect_variations.total_product_price"+rowno).value));//Burada 1 üst satırda oluşturulan toplam liste satış fiyatı döviz kuru rate2 ile çarpılarak genel toplam sistem para birimi cinsinden yazılıyor.
                    hesapla_();
                    
                }	
                </cfloop>
                
            }

            function hesapla_()
            {
                var is_change = 0, //spect üzerinde değişiklik yapılıp yapılmadığını tutmak için
                    toplam_deger = 0;

                for (var r=1;r<=add_spect_variations.record_num.value;r++)
                {
                    if(document.getElementById('row_kontrol'+r)!=undefined && document.getElementById('row_kontrol'+r).value!='0')
                    {
                        form_amount = document.getElementById('row_amount'+r);
                        form_total_amount = document.getElementById('other_list_price'+r);
                        form_total_amount.value = filterNum(form_total_amount.value,sales_price_round_num);
                        if(form_amount.value == "")
                            value_form_amount = 0;
                        else
                            value_form_amount = filterNum(form_amount.value,sales_price_round_num);
                        if(form_total_amount.value == "")
                            form_total_amount.value = 0;
                        toplam_deger = toplam_deger + (value_form_amount*form_total_amount.value);
                        form_total_amount.value=commaSplit(form_total_amount.value,sales_price_round_num);
                    }
                }
                toplam_deger=parseFloat(toplam_deger*product_rate,sales_price_round_num);
                <cfif x_is_spec_type eq 3 and isdefined('is_show_property_and_calculate') and is_show_property_and_calculate eq 1 and isdefined("is_show_property_price") and is_show_property_price eq 1 and isdefined('is_show_property_amount') and is_show_property_amount eq 1 and  isdefined('is_show_tolerance_property') and is_show_tolerance_property eq 1><!--- ÖZellikler görüntülenmek isteniyorsa --->
                    for (var r=1;r<=add_spect_variations.pro_record_num.value;r++)
                    {
                        is_change=1;
                        form_sum_amount = document.getElementById('pro_sum_amount'+r);
                        form_amount = document.getElementById('pro_amount'+r);
                        form_total_amount = document.getElementById('pro_total_amount'+r);
                        form_money_type = document.getElementById('pro_money_type'+r);
                        form_total_amount.value = filterNum(form_total_amount.value,sales_price_round_num);
                        form_sum_amount.value=commaSplit(filterNum(form_amount.value)*filterNum(form_total_amount.value),sales_price_round_num);
                        if(form_amount.value == "")
                            value_form_amount = 0;
                        else
                            value_form_amount = filterNum(form_amount.value,sales_price_round_num);
                        if(form_total_amount.value == "")
                            form_total_amount.value = 0;
                        value_money_type = form_money_type.value.split(',');
                        value_money_type_ilk = value_money_type[0];
                        value_money_type_son = value_money_type[1];
                        toplam_deger = toplam_deger + (value_form_amount*(form_total_amount.value*(value_money_type_son/value_money_type_ilk)));
                        form_total_amount.value = commaSplit(form_total_amount.value,sales_price_round_num);
                    }
                </cfif>
                $("form[ name = add_spect_variations ] #toplam_miktar").val( parseFloat(toplam_deger,sales_price_round_num) );
                for(var j = 0; j < add_spect_variations.rd_money.length; j++)
                {
                    if(document.add_spect_variations.rd_money[j].checked)
                    {
                        value_deger_rd_money_orta = filterNum(eval('add_spect_variations.txt_rate1_'+(j+1)).value,sales_price_round_num);
                        value_deger_rd_money_son = filterNum(eval('add_spect_variations.txt_rate2_'+(j+1)).value,sales_price_round_num);
                        value_deger_rd_money_ilk = eval('add_spect_variations.rd_money_name_'+(j+1)).value;
                    }
                }
                if(!value_deger_rd_money_son || (value_deger_rd_money_son!=undefined && value_deger_rd_money_son.value==''))
                {
                    value_deger_rd_money_orta=1;
                    value_deger_rd_money_son=1;
                }
                var toplam_miktar = $("form[ name = add_spect_variations ] #toplam_miktar").val() != '' ? $("form[ name = add_spect_variations ] #toplam_miktar").val() : 0;
                $("form[ name = add_spect_variations ] #doviz_name").val( value_deger_rd_money_ilk );
                $("form[ name = add_spect_variations ] #other_toplam").val( commaSplit(parseFloat(toplam_miktar,sales_price_round_num) * (parseFloat(value_deger_rd_money_orta,sales_price_round_num)/parseFloat(value_deger_rd_money_son,sales_price_round_num)),sales_price_round_num) );
                $("form[ name = add_spect_variations ] #toplam_miktar").val( commaSplit(toplam_miktar,sales_price_round_num) );
                $("form[ name = add_spect_variations ] #is_change").val( is_change );
            }

            function change_price_cat(id)
            {
                document.add_spect_variations.action = '<cfoutput>#request.self#?fuseaction=product.dsp_karma_contents&pid=#attributes.product_id#&price_catid='+id+'</cfoutput>';
                document.add_spect_variations.submit();
            }
            function uyar(type)
            {
                if (type==1)
                alert("<cf_get_lang dictionary_id ='37783.Bir Liste Fiyatı Varken ya da Seçili İken, Miktar Üzerinde Değişiklik Yapamazsınız Liste Fiyatlarını Silerek Standart Ürün Listesini Tekrar Düzenleyiniz'>.");
                if (type==2)
                alert("<cf_get_lang dictionary_id ='37784.Bir Liste Fiyatı Varken ya da Seçili İken, Ürün Listesine Ekleme Yada Çıkarma Yapamazsınız Liste Fiyatlarını Silerek Standart Ürün Listesini Tekrar Düzenleyiniz'>.");
            }
            function open_price(satir)
            {
                url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_price_history_js&is_from_product&row_no='+satir+'';
                product_id = eval("document.add_spect_variations.product_id"+satir).value;
                stock_id = eval("document.add_spect_variations.stock_id"+satir).value;
                product_name = '';
                unit_ = eval("document.add_spect_variations.unit_id"+satir).value;
                url_str = url_str + '&sepet_process_type=-1';
                url_str = url_str + '&product_id=' + product_id + '&stock_id=' + stock_id + '&pid=' + product_id + '&product_name=' + product_name + '&unit=' + unit_ + '&row_id=' + satir;
                <cfloop query="get_money">
                    url_str = url_str + '&<cfoutput>#money#=#rate2/rate1#</cfoutput>';
                </cfloop>
                if(product_id != "")
                    windowopen(url_str,'medium');
            }
            function hesapla_row(type,row_info)
            {
                
                form_value_rate_satir = list_getat(eval("document.getElementById('product_money" + row_info + "')").value,2,';');
                if(type != 3)
                {
                    eval("document.add_spect_variations.s_price"+row_info).value = commaSplit(filterNum(eval("document.add_spect_variations.other_list_price"+row_info).value,sales_price_round_num)*form_value_rate_satir,sales_price_round_num);
                }
                else
                {
                    eval("document.add_spect_variations.other_list_price"+row_info).value = commaSplit(filterNum(eval("document.add_spect_variations.s_price"+row_info).value,sales_price_round_num)/form_value_rate_satir,sales_price_round_num);
                }
                
                calculate_amount(row_info);
            }
            moneyArray = new Array(<cfoutput>#get_money.recordcount#</cfoutput>);
            rate1Array = new Array(<cfoutput>#get_money.recordcount#</cfoutput>);
            rate2Array = new Array(<cfoutput>#get_money.recordcount#</cfoutput>);
            <cfoutput query="get_money">
                /*javascript array doldurulur*/
                <cfif session.ep.period_year gte 2009 and get_money.MONEY is 'YTL'>
                    moneyArray[#currentrow-1#] = '#session.ep.money#';
                <cfelse>
                    moneyArray[#currentrow-1#] = '#MONEY#';
                </cfif>
                rate1Array[#currentrow-1#] = #rate1#;
                rate2Array[#currentrow-1#] = #rate2#;
                /*javascript array doldurulur*/
            </cfoutput>
            
            function pricelist(product_id)
            {
                url_ = "/V16/product/cfc/GetPrice.cfc?method=getPriceList&product_id="+product_id;
                $.ajax({
                    url: url_,
                    dataType: "text",
                    success: function(read_data) {
                        read_data = read_data.substring(2, read_data.length);
                        data_ = jQuery.parseJSON(read_data);
                        if(data_.DATA.length !=0)
                        {
                            $('#price_list').empty();
                            $('#price_list').append('<option value="">Seçiniz</option>');
                            $.each(data_.DATA,function(i){
                                $.each(data_.COLUMNS,function(k){
                                    var PRICE_ID = data_.DATA[i][0];
                                    var PRICE_CAT = data_.DATA[i][1];
                                    if( k == 1 )
                                    $("#price_list").append('<option value='+PRICE_ID+'>'+PRICE_CAT+'</option>');
                                    
                                });
                            });

                        }
                    }
                });
            }

            if (<cfoutput>#recordnumber#</cfoutput> > 0) hesapla_();

        </cfif>

    <cfelseif x_is_spec_type eq 2 or (x_is_spec_type eq 4 and get_product_info.is_production eq 1)>

        function add_hidden_value(object_)
        {
            var deger_ = object_.value;
            var deger_title_ = object_.title;
            var select_box_leng = document.getElementsByName('altertive_selectbox').length;
            for(var cl_ind=0; cl_ind < select_box_leng; cl_ind++)
            {
                if(document.getElementsByName('altertive_selectbox')[cl_ind].title == deger_title_ && document.getElementsByName('altertive_selectbox')[cl_ind] != object_)
                {
                    old_rate = list_getat(document.getElementsByName('altertive_selectbox')[cl_ind].value,4,'█');
                    if(old_rate == '') old_rate = 0;

                    deger_new = list_setat(deger_,4,old_rate,'█');
                    deger_new = ReplaceAll(deger_new,',','█');
                    document.getElementsByName('altertive_selectbox')[cl_ind].value = deger_new;
                }
            }
        }

        function configurator_control()
        {
            var select_box_leng = <cfoutput>#isdefined('alternativeQuestQuery') ? counter : 0#</cfoutput>;
            if(select_box_leng > 0)
            {
                for(var cl_ind=0; cl_ind < select_box_leng; cl_ind++)
                {
                    if(document.getElementById("altertive_selectbox" + cl_ind ) != undefined)
                    {
                        if(document.getElementById("altertive_selectbox" + cl_ind).value=="")
                        {
                            alert("<cf_get_lang dictionary_id='33106.Alternatif Ürün Seçiniz'>"); 
                            document.getElementById("altertive_selectbox" + cl_ind ).focus(); 
                            return false;
                        }
                    }
                }
            }
            else
            {
                alert("<cf_get_lang dictionary_id='33261.Lütfen Ürüne Soru ve Alternatif Ürün Tanımlayınız'> !");
                return false
            }
            return true;
        }

    </cfif>

    function special_code_control(type,value){
        special_code_query_text = (type == 1) ? "obj_sp_query_result_3" : "obj_sp_query_result_4";
        var sp_query_result = wrk_safe_query(special_code_query_text,'dsn3',value);
        if(sp_query_result.recordcount) {alert(''+sp_query_result.SPECT_MAIN_ID+' nolu Spec Main ve '+sp_query_result.SPECT_VAR_ID+' Spec Var ID de bu özel kodlar kullanılmış.'); return false}
        else return true;
    }

</script>