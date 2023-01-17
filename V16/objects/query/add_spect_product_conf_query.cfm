<cfif attributes.record_count gt 0>
	<!--- iLK OLARAK BİR  SPECT KAYDI YAPIYORUZ..--->
    <cfscript>
		main_stock_id = attributes.stock_id;
		main_product_id = attributes.product_id;
		spec_name='#attributes.product_name#';
		row_count=0;
		spec_total_value = filterNum(attributes.SYSTEM_MONEY_TOTAL_VALUE);
		spec_other_total_value=filterNum(attributes.OTHER_MONEY_TOTAL_VALUE);
		other_money = listgetat(attributes.rd_money,1,',');
		main_prod_price = attributes.main_prod_price;
		main_product_money ='#attributes.main_product_money#';
		spec_is_tree = 0;
		stock_id_list="";
		product_id_list="";
		product_name_list="";
		amount_list="";
		total_min_list = "";
		total_max_list = "";
		tolerance_list = "";
		dimension_list = "";
		sevk_list="";
		diff_price_list="";
		product_price_list="";
		product_money_list="";
		configure_list="";
		is_property_list="";
		property_id_list = "";
		variation_id_list = "";
		rel_variation_id_list = "";
		chapter_id_list = "";
		related_spect_main_id_list ="";
		property_detail_id_list = "";
		line_number_list = "";
    </cfscript>
    <cfloop from="1" to="#attributes.record_count#" index="ci"><!--- kayıt sayısı kadar döner. --->
		<cfif isdefined("attributes.stock_id_#ci#")><!--- Seçim değiştirildiğinde diğer ürünler silindiğinden tanımlı olmayabilir. --->
            <cfscript>
				row_count=row_count+1;
				if(isdefined("attributes.chapter_id_#ci#"))
					chapter_id = Evaluate("attributes.chapter_id_#ci#");
				else
					chapter_id =0;
				chapter_id_list = ListAppend(chapter_id_list,chapter_id,',');
				if (isdefined("attributes.compenent_id_#ci#"))
					property_id = Evaluate("attributes.compenent_id_#ci#");
				else
					property_id = 0;
					if(len(property_id) and property_id gt 0)
						property_id_list = ListAppend(property_id_list,property_id,',');
					else
						property_id_list = ListAppend(property_id_list,0,',');
				if(isdefined("attributes.variation_id_#ci#"))
					variation_id = Evaluate("attributes.variation_id_#ci#");
				else
					variation_id = 0 ;
				if(len(variation_id) and variation_id gt 0)
					variation_id_list = ListAppend(variation_id_list,variation_id,',');
				else
					variation_id_list = ListAppend(variation_id_list,0,',');
				if(isdefined("attributes.sub_variation_id#ci#"))	
					rel_variation_id = Evaluate("attributes.sub_variation_id#ci#");
				else
					rel_variation_id = 0;
				if(len(rel_variation_id) and rel_variation_id gt 0)
					rel_variation_id_list = ListAppend(rel_variation_id_list,rel_variation_id,',');
				else
					rel_variation_id_list = ListAppend(rel_variation_id_list,0,',');
				amount = filterNum(Evaluate("attributes.product_amount_#ci#"),3);
					if(len(amount) and amount gt 0)
						amount_list = ListAppend(amount_list,amount,',');
					else
						amount_list = ListAppend(amount_list,0,',');
				cost = Evaluate("attributes.product_amount_#ci#");//maliyet spec satırlarında tutulmuyor...
				stock_id = Evaluate("attributes.stock_id_#ci#");
					if(len(stock_id) and stock_id gt 0)
						stock_id_list = ListAppend(stock_id_list,stock_id,',');
					else
						stock_id_list = ListAppend(stock_id_list,0,',');
				product_id = Evaluate("attributes.product_id_#ci#");
					if(len(product_id) and product_id gt 0)
						product_id_list = ListAppend(product_id_list,product_id,',');
					else
						product_id_list = ListAppend(product_id_list,0,',');
				price =filterNum(Evaluate("attributes.product_price_#ci#"),3);
					if(len(price) and price gt 0)
						product_price_list = ListAppend(product_price_list,price,',');
					else
						product_price_list = ListAppend(product_price_list,0,',');
				total_price = filterNum(Evaluate("attributes.product_total_price_#ci#"),3);//toplam fiyat spec satırlarında tutulmuyor.
				if(isdefined("attributes.property_detail_id_#ci#"))
					property_detail_id = Evaluate("attributes.property_detail_id_#ci#");
				else
					property_detail_id =0;
				if(len(property_detail_id) and property_detail_id gt 0)
					property_detail_id_list = ListAppend(property_detail_id_list,property_detail_id,',');
				else
					property_detail_id_list = ListAppend(property_detail_id_list,0,',');
				money = listgetat(Evaluate("attributes.PRODUCT_MONEY_#ci#"),3,',');
					if(len(money))
						product_money_list = ListAppend(product_money_list,money,',');
					else
						product_money_list = ListAppend(product_money_list,0,',');		
				if(isdefined("attributes.total_min#ci#"))		
					value1= filterNum(Evaluate("attributes.total_min#ci#"),3);
				else
					value1='-';
				if(len(value1))
					total_min_list = ListAppend(total_min_list,value1,',');
				else
					total_min_list = listappend(total_min_list,'-',',');	
				if(isdefined("attributes.total_max#ci#"))	
					value2= filterNum(Evaluate("attributes.total_max#ci#"),3);
				else
					value2='-';
				if(len(value2))
					total_max_list = ListAppend(total_max_list,value2,',');
				else
					total_max_list = listappend(total_max_list,'-',',');	
				if (isdefined("attributes.tolerance#ci#"))
					tolerance= filterNum(Evaluate("attributes.tolerance#ci#"),3);
				else
					tolerance='-';
				if(len(tolerance))
					tolerance_list = ListAppend(tolerance_list,tolerance,',');
				else
					tolerance_list = listappend(tolerance_list,'-',',');	
				if(isdefined("attributes.dimension_#ci#"))	
					dimension = filterNum(Evaluate("attributes.dimension_#ci#"),3);
				else
					dimension ='-';
				if(len(dimension))
					dimension_list = ListAppend(dimension_list,dimension,',');
				else
					dimension_list = listappend(dimension_list,'-',',');	
				diff_price_list=listappend(diff_price_list,0,',');//fiyat farkı olmadığı için default olarak 0 atıyoruz..
				sevk_list=listappend(sevk_list,0,',');//sevkte birleştir olmadığı için default olarak 0
				configure_list=listappend(configure_list,1,',');//satırlar konfigüre edilebilir...
				if(len(stock_id) and stock_id gt 0)//satırda ürün var ise sarf satırı değilse özellik satırıdır.
					is_property_list = ListAppend(is_property_list,0,',');
				else
					is_property_list = ListAppend(is_property_list,1,',');
				related_spect_main_id_list  = ListAppend(related_spect_main_id_list,0,',');
				line_number_list = ListAppend(line_number_list,0,',');//sıra numarasını şu anda boş gönderiyoruz.ilerde belki doluda gidebilir..
            </cfscript>
        </cfif>
    </cfloop>
    <cfscript>
		money_list="";
		money_rate1_list="";
		money_rate2_list="";
		spec_money_select=session.ep.money2;
		if(isdefined("attributes.rd_money_num") and attributes.rd_money_num gt 0)
		{
			for(i=1;i lte attributes.rd_money_num;i=i+1)
			{
				money_list = listappend(money_list,evaluate("attributes.rd_money_name_#i#"),',');
				money_rate1_list = listappend(money_rate1_list,filterNum(evaluate("attributes.txt_rate1_#i#"),4),',');
				money_rate2_list = listappend(money_rate2_list,filterNum(evaluate("attributes.txt_rate2_#i#"),4),',');
			}
		}
		specer_return_value_list=specer(
			dsn_type : dsn3,
			spec_type : 1000,
			insert_spec : 1,
			main_stock_id : main_stock_id,
			main_product_id : main_product_id,
			spec_name : spec_name,
			spec_total_value : spec_total_value,
			main_prod_price  : main_prod_price ,
			main_product_money : main_product_money,
			spec_other_total_value : spec_other_total_value,
			other_money : other_money,
			money_list : money_list,
			money_rate1_list : money_rate1_list,
			money_rate2_list : money_rate2_list,
			spec_row_count : row_count,
			stock_id_list : stock_id_list,
			product_id_list : product_id_list,
			product_name_list : product_name_list,
			amount_list : amount_list,
			is_sevk_list : sevk_list,
			is_configure_list : configure_list,
			is_property_list : is_property_list,
			property_id_list : property_id_list,
			variation_id_list : variation_id_list,
			total_min_list : total_min_list,
			total_max_list : total_max_list,
			diff_price_list : diff_price_list,
			product_price_list : product_price_list,
			product_money_list : product_money_list,
			tolerance_list : tolerance_list,
			related_spect_id_list : related_spect_main_id_list,
			line_number_list : line_number_list,
			property_detail_id_list:property_detail_id_list,
			chapter_id_list:chapter_id_list,
			dimension_list:dimension_list,
			rel_variation_id_list:rel_variation_id_list
		);
		new_spect_var_name = listgetat(specer_return_value_list,3,',');
        </cfscript>
        
<cfelse>
	<script type="text/javascript">
        alert('Özellik Seçiniz.');
		history.go(-1);
    </script>
</cfif>
<!--- Aşağıdaki include sayfası spec ekleme yada güncelleme sayfasının ürün basketlerinden yada üretim emirlerinden seçilme durumlarda çağıran sayfaya seçilen spec değerlerini göndermek içindir... --->
<cfinclude template="../form/add_spec_js.cfm">

