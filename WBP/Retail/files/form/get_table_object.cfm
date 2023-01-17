<cfsetting showdebugoutput="no">
<cfswitch expression = "#attributes.type#">
	<cfcase value="product_name">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><a href="javascript://" onclick="add_del_product_name('a1');"><img src="/images/plus_small.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="add_del_product_name('d1');"><img src="/images/delete12.gif" border="0"/></a></td>
            <td><input type="text" value="" id="head_product_name" name="head_product_name" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width: 100px;' ></td>
            <td><a href="javascript://" onclick="add_del_product_name('d2');"><img src="/images/delete12.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="add_del_product_name('a2');"><img src="/images/plus_small.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="add_del_product_name('d3');"><img src="/images/menu_service.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_product_name" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
        </script>
    </cfcase>
    <cfcase value="standart_satis_kar">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><input type="text" value="" id="head_standart_satis_kar" name="head_standart_satis_kar" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:25px;' ></td>
            <td><a href="javascript://" onclick="otomatik_doldur_standart_satis_kar()"><img src="/images/listele_down.gif" border="0"/></a></td>
         	<td><a href="javascript://" onclick="otomatik_doldur_standart_satis_kar2();"><img src="/images/menu_service.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_standart_satis_kar" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
		
		function otomatik_doldur_standart_satis_kar()
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Fiyatlar Düzenleniyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{
				var veri_ = document.getElementById('head_standart_satis_kar').value;
				
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
				
	
				for (var m=0; m < eleman_sayisi; m++)
				{
					last_row = rows[m];
					if((last_row.active_row == true || last_row.active_row == 'true') && last_row.row_type == '1')
					{
						last_row.standart_satis_kar = veri_;
						rows[m] = last_row;
						//hesapla_first_sales_std(m,'3','standart_satis_kar',veri_,0);
					}
				}
				grid_duzenle();
				
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
				for (var m=0; m < eleman_sayisi; m++)
				{
					if((rows[m].active_row == true || rows[m].active_row == 'true') && rows[m].row_type == '1')
					{
						hesapla_first_sales_std(m,'3','standart_satis_kar',rows[m].standart_satis_kar,0);
					}
				}
				grid_duzenle();
			hide('message_div_main');
			},100);
		}
		
		function otomatik_doldur_standart_satis_kar2()
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Fiyatlar Düzenleniyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
	
				for (var m=0; m < eleman_sayisi; m++)
				{
					if((rows[m].active_row == true || rows[m].active_row == 'true') && rows[m].row_type == '1')
					{
						ret_ilk = rows[m].s_profit;
						rows[m].standart_satis_kar = ret_ilk;
						hesapla_first_sales_std(m,'3','standart_satis_kar',ret_ilk,0);
					}
				}
				grid_duzenle();	
			hide('message_div_main');
			},100);
		}
        </script>
    </cfcase>
    <cfcase value="p_ss_marj">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><input type="text" value="" id="head_p_ss_marj" name="head_p_ss_marj" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:25px;' ></td>
            <td><a href="javascript://" onclick="otomatik_doldur_p_ss_marj()"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_p_ss_marj" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
		
		function otomatik_doldur_p_ss_marj()
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Fiyatlar Düzenleniyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{
				var veri_ = document.getElementById('head_p_ss_marj').value;
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
	
				for (var m=0; m < eleman_sayisi; m++)
				{
					if(rows[m].active_row == true || rows[m].active_row == 'true')
					{
						rows[m].p_ss_marj = veri_;
						datarow = rows[m];
						hesapla_first_sales(m,'3','p_ss_marj',veri_,0);
					}
				}
				grid_duzenle();
			hide('message_div_main');
			},100);		
		}
        </script>
    </cfcase>
    <cfcase value="add_stock_gun">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><input type="text" value="" id="head_add_stock_gun" name="head_add_stock_gun" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:25px;' ></td>
            <td><a href="javascript://" onclick="otomatik_doldur_add_stock_gun()"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_add_stock_gun" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
		
		function otomatik_doldur_add_stock_gun()
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Fiyatlar Düzenleniyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{
				var veri_ = document.getElementById('head_add_stock_gun').value;
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
	
				for (var m=0; m < eleman_sayisi; m++)
				{
					if(rows[m].active_row == true || rows[m].active_row == 'true')
					{
						rows[m].add_stock_gun = veri_;
						datarow = rows[m];
						//hesapla_first_sales(m,'3','p_ss_marj',veri_,0);
					}
				}
				grid_duzenle();
			hide('message_div_main');
			},100);		
		}
        </script>
    </cfcase>
    <cfcase value="siparis_miktar">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><input type="text" value="" id="head_siparis_miktar" name="head_siparis_miktar" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:25px;' ></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar()"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_siparis_miktar" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
		
		function otomatik_doldur_siparis_miktar()
		{
			var veri_ = document.getElementById('head_siparis_miktar').value;
			
			
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;
			
			var cells = $('#jqxgrid').jqxGrid('getselectedcells');
			c_eleman_sayisi = cells.length;

			for (var m=0; m < c_eleman_sayisi; m++)
			{
				var cell = cells[m];
         		row_ = cell.rowindex;
				kolon_ = cell.datafield;
				
				if(kolon_ == 'siparis_miktar')
				{
					hesapla_row_siparis('siparis_miktar',veri_,row_);
					$("#jqxgrid").jqxGrid('setcellvalue',row_, "siparis_miktar",veri_);
				}
			}
		}
        </script>
    </cfcase>
    <cfcase value="siparis_miktar_k">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><input type="text" value="" id="head_siparis_miktar_k" name="head_siparis_miktar_k" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:25px;' ></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_k()"><img src="/images/listele_down.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_k_round('u');"><img src="/images/up.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_k_round('c');"><img src="/images/listele.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_k_round('d');"><img src="/images/down.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_siparis_miktar_k" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
		
		function otomatik_doldur_siparis_miktar_k_round(type)
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Koli Miktarları Düzenleniyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{			
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
		
				for (var m=0; m < eleman_sayisi; m++)
				{
					if(rows[m].active_row == true || rows[m].active_row == 'true')
					{
						koli_miktar_ = parseFloat(rows[m].siparis_miktar_k);
						
						if(type == 'u')
							koli_miktar_ = Math.ceil(koli_miktar_);
						else if(type == 'd')
							koli_miktar_ = Math.floor(koli_miktar_);
						else
							koli_miktar_ = wrk_round(koli_miktar_,0);
							
						$("#jqxgrid").jqxGrid('setcellvalue',m,"siparis_miktar_k",koli_miktar_);
						hesapla_row_siparis('siparis_miktar_k_round',koli_miktar_,m);
					}
				}
				grid_duzenle();
				hide('message_div_main');
			},100);
		}
		
		
		function otomatik_doldur_siparis_miktar_k()
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Koli Miktarları Dolduruluyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{
				var koli_miktar_ = parseFloat(filterNum(document.getElementById('head_siparis_miktar_k').value));
				
				var cells = $('#jqxgrid').jqxGrid('getselectedcells');
				c_eleman_sayisi = cells.length;
	
				
				for (var m=0; m < c_eleman_sayisi; m++)
				{
					cell = cells[m];
					c_row_ = cell.rowindex;
					kolon_ = cell.datafield;
					
					if(kolon_ == 'siparis_miktar_k')
					{
						$("#jqxgrid").jqxGrid('setcellvalue',c_row_,"siparis_miktar_k",koli_miktar_);
						hesapla_row_siparis('siparis_miktar_k',koli_miktar_,c_row_);
					}
				}
				grid_duzenle();
				hide('message_div_main');
			},100);
		}
        </script>
    </cfcase>
    <cfcase value="siparis_miktar_2">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><input type="text" value="" id="head_siparis_miktar_2" name="head_siparis_miktar_2" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:25px;' ></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_2()"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_siparis_miktar_2" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
		
		function otomatik_doldur_siparis_miktar_2()
		{
			var veri_ = document.getElementById('head_siparis_miktar_2').value;
			
			
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;
			
			var cells = $('#jqxgrid').jqxGrid('getselectedcells');
			c_eleman_sayisi = cells.length;

			for (var m=0; m < c_eleman_sayisi; m++)
			{
				var cell = cells[m];
         		c_row_ = cell.rowindex;
				kolon_ = cell.datafield;
				
				if(kolon_ == 'siparis_miktar_2')
				{
					hesapla_row_siparis('siparis_miktar_2',veri_,c_row_);
					$("#jqxgrid").jqxGrid('setcellvalue',c_row_, "siparis_miktar_2",veri_);
				}
			}
		}
        </script>
    </cfcase>
    <cfcase value="siparis_miktar_k_2">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><input type="text" value="" id="head_siparis_miktar_k_2" name="head_siparis_miktar_k_2" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:25px;' ></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_k_2()"><img src="/images/listele_down.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_k_round_2('u');"><img src="/images/up.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_k_round_2('c');"><img src="/images/listele.gif" border="0"/></a></td>
            <td><a href="javascript://" onclick="otomatik_doldur_siparis_miktar_k_round_2('d');"><img src="/images/down.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_siparis_miktar_k_2" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
		
		function otomatik_doldur_siparis_miktar_k_round_2(type)
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Koli Miktarları Düzenleniyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{			
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
		
				for (var m=0; m < eleman_sayisi; m++)
				{
					if(rows[m].active_row == true || rows[m].active_row == 'true')
					{
						koli_miktar_ = parseFloat(rows[m].siparis_miktar_k_2);
						
						if(type == 'u')
							koli_miktar_ = Math.ceil(koli_miktar_);
						else if(type == 'd')
							koli_miktar_ = Math.floor(koli_miktar_);
						else
							koli_miktar_ = wrk_round(koli_miktar_,0);
							
						$("#jqxgrid").jqxGrid('setcellvalue',m,"siparis_miktar_k_2",koli_miktar_);
						hesapla_row_siparis('siparis_miktar_k_2_round',koli_miktar_,m);
					}
				}
				grid_duzenle();
				hide('message_div_main');
			},100);
		}
		
		
		function otomatik_doldur_siparis_miktar_k_2()
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Koli Miktarları Dolduruluyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{
				var koli_miktar_ = parseFloat(filterNum(document.getElementById('head_siparis_miktar_k_2').value));
				
				var cells = $('#jqxgrid').jqxGrid('getselectedcells');
				c_eleman_sayisi = cells.length;
	
				
				for (var m=0; m < c_eleman_sayisi; m++)
				{
					var cell = cells[m];
					c_row_ = cell.rowindex;
					kolon_ = cell.datafield;
					
					if(kolon_ == 'siparis_miktar_k_2')
					{
						$("#jqxgrid").jqxGrid('setcellvalue',c_row_,"siparis_miktar_k_2",koli_miktar_);
						hesapla_row_siparis('siparis_miktar_k_2',koli_miktar_,c_row_);
					}
				}
				grid_duzenle();
				hide('message_div_main');
			},100);
		}
        </script>
    </cfcase>
    <cfcase value="price_type">
    	<cfquery name="get_price_types" datasource="#dsn_dev#">
            SELECT
                *
            FROM
                PRICE_TYPES
            ORDER BY
                IS_STANDART DESC,
                TYPE_ID ASC
        </cfquery>
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
            	<select name="head_price_type" id="head_price_type">
                    <cfoutput query="get_price_types">
                    	<option value="#type_id#">#TYPE_CODE#</option>
                    </cfoutput>
                </select>
            </td>
            <td><a href="javascript://" onclick="otomatik_doldur_price_type()"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
		function otomatik_doldur_price_type()
		{
			var deger_ = document.getElementById('head_price_type').value;
			var x = document.getElementById("head_price_type").selectedIndex;
			var y = document.getElementById("head_price_type").options;
			text_ =  y[x].text;
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;

			for (var m=0; m < eleman_sayisi; m++)
			{
				if(rows[m].active_row == true || rows[m].active_row == 'true')
				{
					rows[m].price_type = text_;
					rows[m].price_type_id = deger_;	
				}
			}
			grid_duzenle();
		}
        </script>
    </cfcase>
    <cfcase value="standart_satis_kdv">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
            	<select name="head_standart_satis_kdv" id="head_standart_satis_kdv">
                    <option value="5">0.05</option>
                    <option value="10">0.1</option>
                </select>
            </td>
            <td><a href="javascript://" onclick="otomatik_doldur_standart_satis_kdv()"><img src="/images/menu_service.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
		function otomatik_doldur_standart_satis_kdv()
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Fiyat Düzenlemesi Yapılıyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{
				var deger_ = document.getElementById('head_standart_satis_kdv').value;
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
	
				for (var m=0; m < eleman_sayisi; m++)
				{
					if(rows[m].active_row == true || rows[m].active_row == 'true')
					{
						urun_fiyat_ = rows[m].standart_satis_kdv;
						urun_fiyat_str_ = '' + urun_fiyat_;	
						
						if(list_len(urun_fiyat_str_,'.') == 2)
						{
							ondalik_ = list_getat(urun_fiyat_str_,2,'.');
							
							if(ondalik_.length == 2)
							{
								son_hane = '' + urun_fiyat_str_.substr(urun_fiyat_str_.length-1);
								
								if(deger_ == '10' && son_hane != '0')
									urun_fiyat_ = urun_fiyat_ + ((10 - parseInt(son_hane)) / 100);
									
								if(deger_ == '5' && parseInt(son_hane) > 0 && parseInt(son_hane) < 5)
									urun_fiyat_ = urun_fiyat_ + ((5 - parseInt(son_hane)) / 100);
							
								if(deger_ == '5' && parseInt(son_hane) > 5)
									urun_fiyat_ = urun_fiyat_ + ((10 - parseInt(son_hane)) / 100);
							}
							
							urun_fiyat_ = wrk_round(urun_fiyat_,2);
							hesapla_standart_satis(m,'kdvli','standart_satis_kdv',urun_fiyat_,2);
							$("#jqxgrid").jqxGrid('setcellvalue',m,"standart_satis_kdv",urun_fiyat_);
						}
					}
				}
				hide('message_div_main');
			},100);
		}
        </script>
    </cfcase>
    <cfcase value="standart_alis_baslangic">
    	<table cellspacing="0" cellpadding="0">
            <tr>
                <td>
                	<cfset date_ = now()>
                    <input type="text" name="head_standart_alis_baslangic" id="head_standart_alis_baslangic" value="<cfoutput>#dateformat(date_,'dd/mm/yyyy')#</cfoutput>" style="width:65px;" maxlength="10">
                    <cf_wrk_date_image date_field="head_standart_alis_baslangic">
                </td>
                <td><a href="javascript://" onclick="otomatik_doldur_standart_alis_baslangic();"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
        <script>
		function otomatik_doldur_standart_alis_baslangic()
		{
			var date_= document.getElementById('head_standart_alis_baslangic').value;
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;
			for (var i=0;i<eleman_sayisi;i++)
			{
			  	if(rows[i].active_row == true || rows[i].active_row == 'true')
				{
					rows[i].standart_alis_baslangic = date_;
				}
            }
			grid_duzenle();
		}
        </script>
    </cfcase>
    <cfcase value="startdate">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
            	<input type="text" name="head_startdate" id="head_startdate" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" style="width:65px;" maxlength="10">
				<cf_wrk_date_image date_field="head_startdate">
            </td>
            <td><a href="javascript://" onclick="otomatik_doldur_startdate();"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
        <script>
		function otomatik_doldur_startdate()
		{
			var date_ = document.getElementById('head_startdate').value;	
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;

			for (var m=0; m < eleman_sayisi; m++)
			{
				if(rows[m].active_row == true || rows[m].active_row == 'true')
				{
					rows[m].startdate = date_;	
				}				
			}
			grid_duzenle();
		}
        </script>
    </cfcase>
    <cfcase value="finishdate">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
            	<cfset date_ = dateadd('d',1,now())>
                <input type="text" name="head_finishdate" id="head_finishdate" value="<cfoutput>#dateformat(date_,'dd/mm/yyyy')#</cfoutput>" style="width:65px;" maxlength="10">
				<cf_wrk_date_image date_field="head_finishdate">
            </td>
            <td><a href="javascript://" onclick="otomatik_doldur_finishdate();"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
        <script>
		function otomatik_doldur_finishdate()
		{
			var date_= document.getElementById('head_finishdate').value;
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;

			for (var m=0; m < eleman_sayisi; m++)
			{
				if(rows[m].active_row == true || rows[m].active_row == 'true')
				{
					rows[m].finishdate = date_;	
					//datarow = rows[m];
					//$("#jqxgrid").jqxGrid('updaterow',rows[m].uid,datarow,true);
				}				
			}
			grid_duzenle();
		}
        </script>
    </cfcase>
    <cfcase value="standart_satis_baslangic">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
            	<cfset date_ = now()>
                <input type="text" name="head_standart_satis_baslangic" id="head_standart_satis_baslangic" value="<cfoutput>#dateformat(date_,'dd/mm/yyyy')#</cfoutput>" style="width:65px;" maxlength="10">
				<cf_wrk_date_image date_field="head_standart_satis_baslangic">
            </td>
            <td><a href="javascript://" onclick="otomatik_doldur_standart_satis_baslangic();"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
        <script>
		function otomatik_doldur_standart_satis_baslangic()
		{
			var date_= document.getElementById('head_standart_satis_baslangic').value;	
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;

			for (var i=0;i<eleman_sayisi;i++)
			{
				if(rows[i].active_row == true || rows[i].active_row == 'true')
				{
					rows[i].standart_satis_baslangic = date_;
					//datarow = rows[i];
					//$("#jqxgrid").jqxGrid('updaterow',rows[i].uid,datarow,true);
				}
			}
			grid_duzenle();
		}
        </script>
    </cfcase>
    <cfcase value="p_startdate">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
                <input type="text" name="head_p_startdate" id="head_p_startdate" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" style="width:65px;" maxlength="10">
				<cf_wrk_date_image date_field="head_p_startdate">
            </td>
            <td><div id="head_p_startdate_checkbox"></div></td>
            <td><a href="javascript://" onclick="otomatik_doldur_p_startdate();"><img src="/images/listele_down.gif" border="0" align="absmiddle"/></a></td>
            </tr>
    	</table>
        <script>
		 $("#head_p_startdate_checkbox").jqxCheckBox({ width: 20, height: 20,checked:true});
		 function otomatik_doldur_p_startdate()
			{
				var date_= document.getElementById('head_p_startdate').value;	
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
				
				aktar_ =  $("#head_p_startdate_checkbox").jqxCheckBox('checked');
	
				for (var m=0; m < eleman_sayisi; m++)
				{
					if(rows[m].active_row == true || rows[m].active_row == 'true')
					{
						rows[m].p_startdate = date_;
						if(aktar_ == true)
							rows[m].startdate = date_;
					}
				}
				grid_duzenle();
			}
        </script>
    </cfcase>
    <cfcase value="p_finishdate">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
				<cfset date_ = dateadd('d',1,now())>
                <input type="text" name="head_p_finishdate" id="head_p_finishdate" value="<cfoutput>#dateformat(date_,'dd/mm/yyyy')#</cfoutput>" style="width:65px;" maxlength="10">
				<cf_wrk_date_image date_field="head_p_finishdate">
            </td>
            <td><div id="head_p_finishdate_checkbox"></div></td>
            <td><a href="javascript://" onclick="otomatik_doldur_p_finishdate();"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
        <script>
		$("#head_p_finishdate_checkbox").jqxCheckBox({ width: 20, height: 20,checked:true});
		
		function otomatik_doldur_p_finishdate()
		{
			var date_= document.getElementById('head_p_finishdate').value;
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;
			
			aktar_ =  $("#head_p_finishdate_checkbox").jqxCheckBox('checked');

			for (var m=0; m < eleman_sayisi; m++)
			{
				if(rows[m].active_row == true || rows[m].active_row == 'true')
				{
					rows[m].p_finishdate = date_;
					if(aktar_ == true)
						rows[m].finishdate = date_;
						
					//datarow = rows[m];
					//$("#jqxgrid").jqxGrid('updaterow',rows[m].uid,datarow,true);
				}				
			}
			grid_duzenle();
		}
        </script>
    </cfcase>
    <cfcase value="dueday">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td><input type="text" value="" id="head_dueday" name="head_dueday" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:25px;' ></td>
            <td><a href="javascript://" onclick="otomatik_doldur_dueday()"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
		<script>
        $( "#head_dueday" ).on('keydown', function (event) 
        {
            event.stopPropagation();
        });
		
		function otomatik_doldur_dueday()
		{
			document.getElementById("message_div_main_header_info").innerHTML = 'Fiyatlar Düzenleniyor';
			document.getElementById("message_div_main").style.height = 300 + "px";
			document.getElementById("message_div_main").style.width = 400 + "px";
			document.getElementById("message_div_main").style.top = (document.body.offsetHeight-300)/2 + "px";
			document.getElementById("message_div_main").style.left = (document.body.offsetWidth-400)/2 + "px";
			document.getElementById("message_div_main").style.zIndex = 99999;
			document.getElementById('message_div_main_body').style.overflowY = 'auto';
			document.getElementById('message_div_main_body').innerHTML = '<br><br><b>Lütfen Bekleyiniz!</b>';
			show('message_div_main');
			
			setTimeout(function() 
			{
				var veri_ = document.getElementById('head_dueday').value;
				var rows = $('#jqxgrid').jqxGrid('getboundrows');
				eleman_sayisi = rows.length;
	
				for (var m=0; m < eleman_sayisi; m++)
				{
					if(rows[m].active_row == true || rows[m].active_row == 'true')
					{
						rows[m].dueday = veri_;
						datarow = rows[m];
					}
				}
				grid_duzenle();
			hide('message_div_main');
			},100);		
		}
        </script>
    </cfcase>
    <cfcase value="product_id">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
                <input type="hidden" value="" id="head_price_departments" name="head_price_departments" readonly="readonly" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left;' >
            </td>
            <td>
            	<a href="javascript://" onclick="get_row_departments('-1');"><img src="/images/branch_black.gif" align="absmiddle"/></a>
            </td>
            <td><a href="javascript://" onclick="otomatik_doldur_product_id();"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
        <script>
		function otomatik_doldur_product_id()
		{
			var alan_1 = document.getElementById('head_price_departments').value;
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;

			for (var m=0; m < eleman_sayisi; m++)
			{
				if(rows[m].active_row == true || rows[m].active_row == 'true')
				{
					rows[m].price_departments = alan_1;
				}				
			}
			grid_duzenle();
		}
        </script>
    </cfcase>
    <cfcase value="company_name">
    	<table cellspacing="0" cellpadding="0">
            <tr>
            <td>
            	<input type="text" value="" id="head_company_name" name="head_company_name" readonly="readonly" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left; width:150px;' >
                <input type="hidden" value="" id="head_company_code" name="head_company_code" readonly="readonly" class='jqx-input jqx-widget-content jqx-rc-all'  style='height:16px; float: left;' >
            </td>
            <td>
            	<a href="javascript://" onclick="open_popup_comp();"><img src="/images/plus_thin.gif" border="0"/></a>
            </td>
            <td><a href="javascript://" onclick="otomatik_doldur_company_name();"><img src="/images/listele_down.gif" border="0"/></a></td>
            </tr>
    	</table>
        <script>
		function open_popup_comp()
		{
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_manufact_comps&field_comp_name=head_company_name&field_comp_code=head_company_code</cfoutput>','list');
		}
		function otomatik_doldur_company_name()
		{
			var alan_1 = document.getElementById('head_company_name').value;
			var alan_2 = document.getElementById('head_company_code').value;
			var rows = $('#jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;

			for (var m=0; m < eleman_sayisi; m++)
			{
				if(rows[m].active_row == true || rows[m].active_row == 'true')
				{
					rows[m].company_name = alan_1;
					rows[m].company_code = alan_2;
				}				
			}
			grid_duzenle();
		}
        </script>
    </cfcase>
</cfswitch>