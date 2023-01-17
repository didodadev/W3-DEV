<cf_popup_box title="Ürün Bağlayıcı">
	<form name="select_p" action="" method="post"><div id="inner_div"></div></form>
<cfoutput>
<script>
function clear_old_upper()
{
	deger_list_ = window.opener.document.getElementById('all_product_list').value;
	eleman_sayisi = list_len(deger_list_);
	
	alt_eleman_varmi = 0;
	
	for (var m=1; m <= eleman_sayisi; m++)
	{
		product_id_ = list_getat(deger_list_,m);
		if(window.opener.document.getElementById('upper_product_id_' + product_id_).value == old_upper_product)
		{
			alt_eleman_varmi = 1;				
		}
	}
	
	if(alt_eleman_varmi == 0)
	{
		window.opener.document.getElementById('is_upper_' + old_upper_product).value = '0';
		window.opener.hide('up_attach_div_' + old_upper_product);	
	}	
}

function connect_product_up()
{
	yeni_urun_ = document.select_p.upper_product_id.value;
	
	window.opener.document.getElementById('upper_product_id_#attributes.product_id#').value = yeni_urun_;
	window.opener.document.getElementById('is_upper_' + yeni_urun_).value = '1';
	window.opener.show('up_attach_div_' + yeni_urun_);
	window.opener.show('attach_div_#attributes.product_id#');
	
	if(old_upper_product != '')
	{
		clear_old_upper();
	}	
	
	window.close();
}

function clear_product_up()
{
	window.opener.document.getElementById('upper_product_id_#attributes.product_id#').value = '';
	window.opener.hide('attach_div_#attributes.product_id#');
	
	if(old_upper_product != '')
	{
		clear_old_upper();
	}	
	window.close();
}
	icerik_ = '';
	icerik_2 = '';
	old_upper_product = window.opener.document.getElementById('upper_product_id_#attributes.product_id#').value;
	if(old_upper_product != '')
	{
		my_query = wrk_query('SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = ' + old_upper_product,'dsn1',1);
		icerik_ += '<br><b>&nbsp;Ürün Zaten Bağlı! Üst Ürün : ' + my_query.PRODUCT_NAME +  '</b><br><br>';	
	}
	
	deger_list_ = window.opener.document.getElementById('all_product_list').value;
	eleman_sayisi = list_len(deger_list_);
	
	if(eleman_sayisi == '1')
	{
		alert('Ürün Bağlanabilecek Farklı Bir Ürün Bulunamadı!');
		window.close();	
	}
	
	
	//baska urunun ust urunuyse alt urun olamaz
	crow_ = 0;
	icerik_2 += '<table>';
	icerik_2 += '<tr><td colspan="2" class="formbold">Alt Ürünler</td></tr>';
	for (var m=1; m <= eleman_sayisi; m++)
	{
		product_id_ = list_getat(deger_list_,m);
		if(product_id_ != '#attributes.product_id#')
		{
			if(window.opener.document.getElementById('upper_product_id_' + product_id_).value == '#attributes.product_id#')
			{
				crow_ = crow_ + 1;
				icerik_2 += '<tr>';
				icerik_2 += '<td>';
				my_query = wrk_query('SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = ' + product_id_,'dsn1',1);
				icerik_2 += my_query.PRODUCT_NAME;
				icerik_2 += '</td></tr>';				
			}
		}
	}
	icerik_2 += '</table>';
	if(crow_ > 0) document.getElementById('inner_div').innerHTML = icerik_2;
	//baska urunun ust urunuyse alt urun olamaz
	
	if(crow_ == 0)
	{
		icerik_ += '<table>';
		icerik_ += '<tr><td colspan="2" class="formbold">Bağlanılabilir Ürünler</td></tr>';
		row_ = 0;
		for (var m=1; m <= eleman_sayisi; m++)
		{
			product_id_ = list_getat(deger_list_,m);
			if(product_id_ != '#attributes.product_id#')
			{
				if(window.opener.document.getElementById('upper_product_id_' + product_id_).value == '')
				{
					row_ = row_ + 1;
					icerik_ += '<tr>';
					if(old_upper_product != '' && old_upper_product == product_id_)
						icerik_ += '<td><input type="radio" name="upper_product_id" value="' + product_id_ + '" checked></td>';
					else if(row_ == 1 && old_upper_product == '')
						icerik_ += '<td><input type="radio" name="upper_product_id" value="' + product_id_ + '" checked></td>';
					else
						icerik_ += '<td><input type="radio" name="upper_product_id" value="' + product_id_ + '"></td>';
					icerik_ += '<td>';
					my_query = wrk_query('SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = ' + product_id_,'dsn1',1);
					icerik_ += my_query.PRODUCT_NAME;
					icerik_ += '</td></tr>';
				}
			}
		}
		icerik_ += '</table>';
		
		if(row_ == 0)
		{
			alert('Ürün Bağlanabilecek Farklı Bir Ürün Bulunamadı!');
			window.close();	
		}
		
		icerik_ += '<tr><td colspan="2" class="formbold"><input type="button" value="Ürünü Ayır" onclick="clear_product_up();"> <input type="button" value="Ürünü Bağla" onclick="connect_product_up();"></td></tr>';
		
		document.getElementById('inner_div').innerHTML = icerik_;
	}
</script>
</cfoutput>
</cf_popup_box>