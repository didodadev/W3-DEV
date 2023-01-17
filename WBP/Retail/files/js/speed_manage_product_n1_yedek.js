function gonder_price_new(r_row_id,price,discount_list,manuel_discount,row_id,start_,finish_,p_start_,p_finish_,margin_,p_margin_,satis_,satis_kdv_,p_type_,is_active_s_,is_active_p_)
{
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'new_alis_start',filterNum(price));
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'sales_discount',discount_list);
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'p_discount_manuel',filterNum(manuel_discount));
		
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'startdate',start_);
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'finishdate',finish_);
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'p_startdate',p_start_);
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'p_finishdate',p_finish_);
		
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'product_price_change_lastrowid',row_id);
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'p_ss_marj',filterNum(margin_));
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'alis_kar',filterNum(p_margin_));
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'first_satis_price',filterNum(satis_));
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'first_satis_price_kdv',filterNum(satis_kdv_));
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'price_type',eval('j_price_type_' + p_type_));
		$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'price_type_id',p_type_);
		if(is_active_s_ == 0)
			$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'is_active_s',false);
		else
			$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'is_active_s',true);
				
		if(is_active_p_ == 0)
			$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'is_active_p',false);
		else
			$("#jqxgrid").jqxGrid('setcellvalue',r_row_id,'is_active_p',true);
	get_product_price_detail();
	//hesapla_satis(r_row_id,'kdvli','first_satis_price_kdv',filterNum(satis_kdv_));
	p_discount_calc(r_row_id,'new_alis_start',filterNum(price));
}

function goster_seller_limit_rows(pcat)
{
	rel_ = "row_code='product_cat_" + pcat + "'";
	col1 = $("#manage_table_seller_limit tr[" + rel_ + "]");
	col1.toggle();	
}

function add_product()
{
	adres_ = 'index.cfm?fuseaction=extra.popup_add_row_to_speed_manage_product&new_page=1';
	adres_ += '&search_startdate=' + document.getElementById('search_startdate').value;
	adres_ += '&search_finishdate=' + document.getElementById('search_finishdate').value;
	windowopen(adres_,'page','add_product_wind');
	add_product_wind.focus();
}

function del_manage_row(row)
{
	if(confirm('Ürünü Listeden Kaldırmak İstediğinize Emin misiniz?'))
	{
		var rows = $("#jqxgrid").jqxGrid('getboundrows');
		var ret = jQuery("#jqxgrid").jqxGrid('getRowData',row);
		ret_p = ret.ReportsTo;
		ret_t = ret.row_type;
		ret_s = ret.sub_rows_count;
		
		var id = $("#jqxgrid").jqxGrid('getrowid',row);
		id_list_ = id;
		
		var rowIDs = new Array();
		rowIDs.push(rows[row].uid);
		
		if(ret_s > 0)
		{
				for (var c=1; c <= ret_s; c++)
				{
					var ret_ic = jQuery("#jqxgrid").jqxGrid('getRowData',(row+c));
					ret_p_ic = ret_ic.ReportsTo;
					
					if(ret_p_ic == ret_p)
					{
						rowIDs.push(rows[row+c].uid);
					}
				}
		}
		$("#jqxgrid").jqxGrid('deleterow', rowIDs);
		
		eleman_sayisi = list_len(document.getElementById('all_product_list').value);
		ilk_deger_ = document.getElementById('all_product_list').value;
		
		yeni_liste = '';
		
		for (var m=1; m <= eleman_sayisi; m++)
		{
			deger_ = list_getat(ilk_deger_,m);
			if(deger_ != ret_p)
			{
				if(yeni_liste == '')
					yeni_liste = '' + deger_;
				else
					yeni_liste = yeni_liste + ',' + deger_;
			}
		}
		document.getElementById('all_product_list').value = yeni_liste;
		
		if(document.getElementById('table_id').value != '')
		{
			adress_ = 'index.cfm?fuseaction=extra.emptypopup_del_product_from_table&product_id=' + ret.product_id + '&table_id=' + document.getElementById('table_id').value;
			AjaxPageLoad(adress_,'speed_action_div','1');
		}
	}
	else
	{
		return false;	
	}
}

function save_list()
{
	if(document.getElementById('all_product_list').value == '')
	{
		alert('Ürün Seçiniz!');
		return false;	
	}
	
	//set_line_numbers();
	
	document.getElementById("message_div_main_header_info").innerHTML = 'Liste Yap';
	document.getElementById("message_div_main").style.height = 220 + "px";
	document.getElementById("message_div_main").style.width = 300 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-220)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-300)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	show_hide('message_div_main');
	
	AjaxPageLoad('index.cfm?fuseaction=extra.emptypopup_get_list_save_screen','message_div_main_body','1');
}

function open_price_window(row)
{
	windowopen('index.cfm?fuseaction=extra.popup_calc_price_window&row_id=' + row,'medium','fiyat_hesapla');	
}

function std_p_discount_calc(row,alan_adi,base_deger)
{
	kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis_kdvli');
	alis_kdv = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis_kdv');
	if(alan_adi == 'standart_alis')
		base_deger_ = base_deger;
	else
		base_deger_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis');
	
	if(alan_adi == 'standart_alis_indirim_yuzde')
		indirim_kolon = base_deger;
	else
		indirim_kolon = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis_indirim_yuzde');
		
	if(alan_adi == 'standart_alis_indirim_tutar')
		manuel_indirim_kolon = base_deger;
	else
		manuel_indirim_kolon = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis_indirim_tutar');
	
	indirim_kolon = indirim_kolon + '';
	if(indirim_kolon.indexOf("+") > 0)
	{
		eleman_sayisi = list_len(indirim_kolon,'+');
		for (var m=1; m <= eleman_sayisi; m++)
		{
			dis1 = list_getat(indirim_kolon,m,'+');
			dis1 = filterNum(dis1,4);
			base_deger_ = base_deger_ - (base_deger_*dis1/100);	
		}
	}
	else
	{
		dis1 = indirim_kolon;
		dis1 = filterNum(dis1,4);
		base_deger_ = base_deger_ - (base_deger_*dis1/100);	
	}
	
	
	if(manuel_indirim_kolon != '')
	{
		manuel_ = manuel_indirim_kolon;
		base_deger_ = base_deger_ - manuel_;
	}
	base_deger_ = wrk_round(base_deger_,4);
	
	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_alis_liste',wrk_round(base_deger_,4));
	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_alis_kdvli',wrk_round(base_deger_ * (1 + (alis_kdv / 100)),4));

	deger_new = wrk_round(base_deger_,4);
	deger_old = $('#jqxgrid').jqxGrid('getcellvalue',row,'info_standart_alis');
	
	deger_ortalama_ = wrk_round(100 * deger_new / deger_old) - 100;
	
	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_alis_oran',wrk_round(deger_ortalama_,2));
			
	hesapla_standart_satis(row,'kdvli','standart_alis',base_deger);
}

function p_discount_calc(row,alan_adi,base_deger)
{
		kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'new_alis_kdvli');
		alis_kdv = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis_kdv');
		
		if(alan_adi == 'new_alis_start')
			base_deger_ = base_deger;
		else
			base_deger_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'new_alis_start');
		
		if(alan_adi == 'sales_discount')
			indirim_kolon = base_deger;
		else
			indirim_kolon = $('#jqxgrid').jqxGrid('getcellvalue',row,'sales_discount');
			
		if(alan_adi == 'p_discount_manuel')
			manuel_indirim_kolon = base_deger;
		else
			manuel_indirim_kolon = $('#jqxgrid').jqxGrid('getcellvalue',row,'p_discount_manuel');
		
		indirim_kolon = indirim_kolon + '';
		if(indirim_kolon.indexOf("+") > 0)
		{
			eleman_sayisi = list_len(indirim_kolon,'+');
			for (var m=1; m <= eleman_sayisi; m++)
			{
				dis1 = list_getat(indirim_kolon,m,'+');
				dis1 = filterNum(dis1,4);
				base_deger_ = base_deger_ - (base_deger_*dis1/100);	
			}
		}
		else
		{
			dis1 = indirim_kolon;
			dis1 = filterNum(dis1,4);
			base_deger_ = base_deger_ - (base_deger_*dis1/100);	
		}	
		
		if(manuel_indirim_kolon != '')
		{
			manuel_ = manuel_indirim_kolon;
			base_deger_ = base_deger_ - manuel_;
		}
		base_deger_ = wrk_round(base_deger_,4);
		
		
		$("#jqxgrid").jqxGrid('setcellvalue',row,'new_alis',wrk_round(base_deger_,4));
		$("#jqxgrid").jqxGrid('setcellvalue',row,'new_alis_kdvli',wrk_round(base_deger_ * (1 + (alis_kdv / 100)),4));

		hesapla_satis(row,'kdvli','new_alis_start',base_deger);
		
}

function hesapla_satis(row,type,alan_adi,base_deger)
{
	avantaj = 0;
	satis_kdv = $('#jqxgrid').jqxGrid('getcellvalue',row,'satis_kdv');
	satis_kdv_rank = 1 + (satis_kdv / 100);
	
	
	if(alan_adi == 'first_satis_price')
		satis_kdvsiz = base_deger;
	else
		satis_kdvsiz = $('#jqxgrid').jqxGrid('getcellvalue',row,'first_satis_price');
	
	if(alan_adi == 'first_satis_price_kdv')
		satis_kdvli = base_deger;
	else
		satis_kdvli = $('#jqxgrid').jqxGrid('getcellvalue',row,'first_satis_price_kdv');
	
	aktif_fiyat = $('#jqxgrid').jqxGrid('getcellvalue',row,'c_standart_satis_kdv');
	fiyat_fark = aktif_fiyat - satis_kdvli;
	
	if(aktif_fiyat > 0)
		{
		avantaj = wrk_round(fiyat_fark / aktif_fiyat * 100,1);	
		}
	
	if(type == 'kdv')
	{
		satis_kdvli = satis_kdvsiz * satis_kdv_rank;	
	}
	if(type == 'kdvli')
	{
		satis_kdvsiz = satis_kdvli / satis_kdv_rank;
	}
	if(type == 'kdvsiz')
	{
		satis_kdvli = satis_kdvsiz * satis_kdv_rank;	
	}
	
	alis_ilk_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'new_alis');
	alis_kdvli = alis_ilk_ * satis_kdv_rank;
	
	kar_ = 100 - (wrk_round(alis_kdvli / satis_kdvli * 100));
	
	satis_kdvsiz = wrk_round(satis_kdvsiz,4);
	satis_kdvli = wrk_round(satis_kdvli,4);

	kar_ = wrk_round(kar_,2);

	$("#jqxgrid").jqxGrid('setcellvalue',row,'p_ss_marj',kar_);
	$("#jqxgrid").jqxGrid('setcellvalue',row,'first_satis_price',satis_kdvsiz);
	$("#jqxgrid").jqxGrid('setcellvalue',row,'first_satis_price_kdv',satis_kdvli);
	
	$("#jqxgrid").jqxGrid('setcellvalue',row,'avantaj_oran',avantaj);
	
	//alis kar hesabi
	s_kar = kar_;
	a_kar = s_kar / (100 - s_kar) * 100;
	$("#jqxgrid").jqxGrid('setcellvalue',row,'alis_kar',wrk_round(a_kar));
	//alis kar hesabi
	
	ilk_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'c_standart_satis');
	oran_ = wrk_round(((100 * satis_kdvsiz) / ilk_) - 100);
	$("#jqxgrid").jqxGrid('setcellvalue',row,'satis_standart_satis_oran',oran_);
}

function hesapla_standart_satis(row,type,alan_adi,base_deger)
{
	satis_kdv = $('#jqxgrid').jqxGrid('getcellvalue',row,'satis_kdv');
	
	if(alan_adi == 'standart_satis')
		satis_kdvsiz = base_deger;
	else
		satis_kdvsiz = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_satis');
	
	if(alan_adi == 'standart_satis_kdv')
		satis_kdvli = base_deger;
	else
		satis_kdvli = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_satis_kdv');
		
	satis_kdv_rank = 1 + (satis_kdv / 100);
	
	if(type == 'kdv')
	{
		satis_kdvli = satis_kdvsiz * satis_kdv_rank;	
	}
	if(type == 'kdvli')
	{
		satis_kdvsiz = satis_kdvli / satis_kdv_rank;
	}
	if(type == 'kdvsiz')
	{
		satis_kdvli = satis_kdvsiz * satis_kdv_rank;	
	}
	
	alis_ilk_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis_liste');
	alis_kdvli = alis_ilk_ * satis_kdv_rank;
	
	kar_ = 100 - (wrk_round(alis_kdvli / satis_kdvli * 100));
	
	satis_kdvsiz = wrk_round(satis_kdvsiz,4);
	satis_kdvli = wrk_round(satis_kdvli,4);
	kar_ = wrk_round(kar_,2);

	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_satis_kar',kar_);
	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_satis',satis_kdvsiz);
	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_satis_kdv',satis_kdvli);
	
	//alis kar hesabi
	s_kar = kar_;
	a_kar = s_kar / (100 - s_kar) * 100;
	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_alis_kar',wrk_round(a_kar,2))
	//alis kar hesabi
	
	ilk_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'c_standart_satis');
	oran_ = wrk_round(((100 * satis_kdvsiz) / ilk_) - 100);
	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_satis_oran',oran_);
}

function hesapla_first_sales(row,type,alan_adi,base_deger)
{
	ilk_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'c_standart_satis');
	kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'satis_kdv');
	alis_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'new_alis');
	
	
	satis_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'first_satis_price');
	satis_kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'first_satis_price_kdv');
	
	
	if(type == '3')
	{
		marj_ = base_deger;
		if(marj_ == '')
			marj_ = 0;
		
		marj_ = parseFloat(marj_);
		
		alis_ilk_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'new_alis');
		alis_ = alis_ilk_ * ((100 + kdv_) /100);;
		
		kdv_li_deger_ = alis_ / (100 - marj_) * 100;
		
		satis_ = parseFloat(wrk_round(kdv_li_deger_ / ((100 + kdv_) /100),4));
		
		$("#jqxgrid").jqxGrid('setcellvalue',row,'first_satis_price',wrk_round(satis_,4));
		$("#jqxgrid").jqxGrid('setcellvalue',row,'first_satis_price_kdv',kdv_li_deger_);
		
		//alis kar hesabi
		s_kar = marj_;
		a_kar = wrk_round(s_kar / (100 - s_kar) * 100);
		
		$("#jqxgrid").jqxGrid('setcellvalue',row,'alis_kar',a_kar);
		//alis kar hesabi
	}

	oran_ = wrk_round(((100 * satis_) / ilk_) - 100);
	$("#jqxgrid").jqxGrid('setcellvalue',row,'satis_standart_satis_oran',oran_);
	return true;
}

function hesapla_first_sales_std(row,type,alan_adi,base_deger)
{
	ilk_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'c_standart_satis');
	kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'satis_kdv');
	alis_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis');
	
	
	satis_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_satis');
	satis_kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_satis_kdv');
	
	
	if(type == '3')
	{
		marj_ = base_deger;
		if(marj_ == '')
			marj_ = 0;
		
		marj_ = parseFloat(marj_);
		
		alis_ilk_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'standart_alis_liste');
		alis_ = alis_ilk_ * ((100 + kdv_) /100);;
		
		kdv_li_deger_ = alis_ / (100 - marj_) * 100;
		
		satis_ = parseFloat(wrk_round(kdv_li_deger_ / ((100 + kdv_) /100),4));
		
		$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_satis',wrk_round(satis_,4));
		$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_satis_kdv',kdv_li_deger_);
		
		//alis kar hesabi
		s_kar = marj_;
		a_kar = wrk_round(s_kar / (100 - s_kar) * 100);
		
		$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_alis_kar',a_kar);
		//alis kar hesabi
	}

	oran_ = wrk_round(((100 * satis_) / ilk_) - 100);
	$("#jqxgrid").jqxGrid('setcellvalue',row,'standart_satis_oran',oran_);
	return true;
}

function add_del_product_name(type)
{
	ek_kelime_ = document.getElementById('head_product_name').value;
	if(ek_kelime_ == '')
	{
		alert('Koşul Girmediniz!');
		return false;	
	}
	ek_kelime_uzunluk_ = ek_kelime_.length;
	
	var rows = $('#jqxgrid').jqxGrid('getboundrows');
	eleman_sayisi = rows.length;
	
	ek_deger_ilk_ = document.getElementById('head_product_name').value;
	ek_deger_ = '';
	uzunluk_ = ek_deger_ilk_.length;
	for (var c=0; c < uzunluk_; c++)
	{
		char_ = ek_deger_ilk_.substring(c,(c+1));
		
		if(char_ == '$' || char_ == '*')
			ek_deger_ += "\\";
			
		ek_deger_ += char_;
	}
	
	//buldugun yerden sil
	if(type == 'd3')
	{
		var ek_deger_ = new RegExp(ek_deger_,"g");
		var bosluk_deger = new RegExp("  ","g");
		
		for (var m=0; m < eleman_sayisi; m++)
		{
			if(rows[m].active_row == true || rows[m].active_row == 'true')
			{
				bosluk_ = "";
				deger_ = rows[m].product_name;
				deger_ = 	deger_.replace(ek_deger_,bosluk_);
				deger_ = 	deger_.replace(bosluk_deger,' ');
				deger_ = 	deger_.replace(bosluk_deger,' ');
				rows[m].product_name = deger_;
			}
			/*
			var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
			ret_p = ret.active_row;
			if(ret_p == true || ret_p == 'true')
			{
				bosluk_ = "";
				deger_ = ret.product_name;
				deger_ = 	deger_.replace(ek_deger_,bosluk_);
				deger_ = 	deger_.replace(bosluk_deger,' ');
				deger_ = 	deger_.replace(bosluk_deger,' ');
				$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',deger_);
			}
			*/
		}
		$("#jqxgrid").jqxGrid('applyfilters');
	}
	
	//sondan sil
	if(type == 'd2')
	{
		ek_deger_ = document.getElementById('head_product_name').value;
		for (var m=0; m < eleman_sayisi; m++)
		{
			if(rows[m].active_row == true || rows[m].active_row == 'true')
			{
				bosluk_ = "";
				deger_ = rows[m].product_name;
				deger_uzunluk = deger_.length;
				son_karakterler_ = deger_.substring(deger_uzunluk-ek_kelime_uzunluk_,deger_uzunluk);
				if(son_karakterler_ == ek_deger_)
					yeni_deger_ = deger_.substring(0,deger_uzunluk-ek_kelime_uzunluk_);
				else
					yeni_deger_ = deger_;
					
				rows[m].product_name = yeni_deger_;
			}
			/*
			var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
			ret_p = ret.active_row;
			if(ret_p == true || ret_p == 'true')
			{
				deger_ = ret.product_name;
				deger_uzunluk = deger_.length;
				son_karakterler_ = deger_.substring(deger_uzunluk-ek_kelime_uzunluk_,deger_uzunluk);
				if(son_karakterler_ == ek_deger_)
					yeni_deger_ = deger_.substring(0,deger_uzunluk-ek_kelime_uzunluk_);
				else
					yeni_deger_ = deger_;
					
				$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',yeni_deger_);	
			}
			*/
		}
		$("#jqxgrid").jqxGrid('applyfilters');
	}
	
	//bastan sil
	if(type == 'd1')
	{
		var ek_deger_ = new RegExp(ek_deger_,"");
		var bosluk_deger = new RegExp("  ","g");
		
		for (var m=0; m < eleman_sayisi; m++)
		{
			if(rows[m].active_row == true || rows[m].active_row == 'true')
			{
				bosluk_ = "";
				deger_ = rows[m].product_name;
				deger_ = deger_.replace(ek_deger_,bosluk_);
				deger_ = deger_.replace(bosluk_deger,' ');
				deger_ = deger_.replace(bosluk_deger,' ');
				rows[m].product_name = deger_;
			}
			/*
			var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
			ret_p = ret.active_row;
			if(ret_p == true || ret_p == 'true')
			{
				bosluk_ = "";
				deger_ = ret.product_name;
				deger_ = 	deger_.replace(ek_deger_,bosluk_);
				deger_ = 	deger_.replace(bosluk_deger,' ');
				deger_ = 	deger_.replace(bosluk_deger,' ');
				$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',deger_);
			}
			*/
		}
		$("#jqxgrid").jqxGrid('applyfilters');
	}
	
	//bastan ekle
	if(type == 'a1')
	{
		for (var m=0; m < eleman_sayisi; m++)
		{
			ek_deger_ = document.getElementById('head_product_name').value;
			if(rows[m].active_row == true || rows[m].active_row == 'true')
			{
				bosluk_ = "";
				deger_ = rows[m].product_name;
				ilk_ = list_getat(deger_,1,' ');
				son_ = ilk_ + ' ' + ek_deger_ + ' ';
				yeni_deger = deger_.replace(ilk_,son_);
				rows[m].product_name = yeni_deger;
			}
			/*
			ek_deger_ = document.getElementById('head_product_name').value;
			var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
			ret_p = ret.active_row;
			if(ret_p == true || ret_p == 'true')
			{
				bosluk_ = "";
				deger_ = ret.product_name;
				ilk_ = list_getat(deger_,1,' ');
				son_ = ilk_ + ' ' + ek_deger_ + ' ';
				yeni_deger = deger_.replace(ilk_,son_);
				$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',yeni_deger);
			}
			*/
		}
		$("#jqxgrid").jqxGrid('applyfilters');
	}
	
	//sondan ekle
	if(type == 'a2')
	{
		for (var m=0; m < eleman_sayisi; m++)
		{
			ek_deger_ = document.getElementById('head_product_name').value;
			if(rows[m].active_row == true || rows[m].active_row == 'true')
			{
				deger_ = rows[m].product_name;
				yeni_deger = deger_ + ' ' + ek_deger_;
				rows[m].product_name = yeni_deger;
			}
			/*
			var ret = jQuery("#jqxgrid").jqxGrid('getRowData',m);
			ret_p = ret.active_row;
			if(ret_p == true || ret_p == 'true')
			{
				deger_ = ret.product_name;
				yeni_deger = deger_ + ' ' + ek_deger_;
				$("#jqxgrid").jqxGrid('setcellvalue',m,'product_name',yeni_deger);
			}
			*/
		}
		$("#jqxgrid").jqxGrid('applyfilters');
	}
}


function get_calc_type()
{
	c_type_ = document.getElementById('calc_type').value;
	if(c_type_ == '0')
	{
		hide('calc_table_1');
	}
	else if(c_type_ == '1')
	{
		show('calc_table_1');
	}
	else if(c_type_ == '2')
	{
		hide('calc_table_1');
	}
	else if(c_type_ == '3')
	{
		hide('calc_table_1');
	}	
}

function get_product_kare_bedeli(row_id)
{
	table_code_ = document.getElementById('table_code').value;
	table_secret_code_ = document.getElementById('table_secret_code').value;
	
	
	if(row_id == -1)
	{
		windowopen('index.cfm?fuseaction=extra.popup_make_process_action&table_code='+table_code_+'&table_secret_code=' + table_secret_code_,'wwide1');
	}
	else
	{
		var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData',row_id);
		code_ = ret_row.company_code;
		name_ = ret_row.company_name;
		
		company_id_ = list_getat(code_,1,'_');
		project_id_ =  list_getat(code_,2,'_');
		comp_ = name_;
		windowopen('index.cfm?fuseaction=extra.popup_make_process_action&table_code='+table_code_+'&table_secret_code=' + table_secret_code_+'&company_id=' + company_id_+'&project_id=' + project_id_+'&company_name='+comp_,'wwide1');
	}
}

function get_product_detail(product_id)
{
	if(f6_pop == 0)
	{
		header_ = '<a href="javascript://" onclick="f6_pop=1;get_product_detail();">(X)</a> Ürün Detay Ekranı';
		ajaxwindow('index.cfm?fuseaction=objects.popup_detail_product&pid=' + product_id,'list','product_detail_window',header_);
		f6_pop = 1;
	}
	else
	{
		try 
		{ 
			ColdFusion.Window.destroy('product_detail_window',true); 
		} 
		catch(e) 
		{}
		f6_pop = 0;	
	}	
	//windowopen('index.cfm?fuseaction=objects.popup_detail_product&pid=' + product_id,'list');
}

function get_rival_price_list(product_id)
{
	if(f5_pop == 0)
	{
		header_ = '<a href="javascript://" onclick="f5_pop=1;get_rival_price_list();">(X)</a> Rakip Fiyat Ekranı';
		ajaxwindow('index.cfm?fuseaction=extra.popup_detail_rival_prices&pid=' + product_id,'list','rival_window',header_);
		f5_pop = 1;
	}
	else
	{
		try 
		{ 
			ColdFusion.Window.destroy('rival_window',true); 
		} 
		catch(e) 
		{}
		f5_pop = 0;	
	}
	//windowopen('index.cfm?fuseaction=extra.popup_detail_rival_prices&pid=' + product_id,'list');
}

function get_cost_list(product_id,stock_id)
{
	if(f9_pop == 0)
	{
		adress_ = 'index.cfm?fuseaction=extra.popup_detail_product_cost&product_id=' + product_id;
		if(stock_id != '')
			adress_ = adress_ + '&stock_id='+stock_id;
		
		header_ = '<a href="javascript://" onclick="f9_pop=1;get_cost_list();">(X)</a> Maliyet Ekranı';
		ajaxwindow(adress_,'list','cost_window',header_);
		f9_pop = 1;
	}
	else
	{
		try 
		{ 
			ColdFusion.Window.destroy('cost_window',true); 
		} 
		catch(e) 
		{}
		f9_pop = 0;	
	}
	//windowopen('index.cfm?fuseaction=extra.popup_detail_product_cost&product_id=' + product_id +'&stock_id='+stock_id,'list');
}

function get_product_price_detail(product_id,row_id)
{
	if(f1_pop == 0)
	{
		header_ = '<a href="javascript://" onclick="f1_pop=1;get_product_price_detail();">(X)</a> Fiyat Ekranı';
		ajaxwindow('index.cfm?fuseaction=extra.popup_detail_product_price&pid=' + product_id + '&row_id=' + row_id,'wwide1','price_window',header_);
		f1_pop = 1;
	}
	else
	{
		try 
		{ 
			ColdFusion.Window.destroy('price_window',true); 
		} 
		catch(e) 
		{}
		f1_pop = 0;	
	}
	//windowopen('index.cfm?fuseaction=extra.popup_detail_product_price&pid=' + product_id,'wide2');
}

function get_product_relateds(product_id)
{
	if(f3_pop == 0)
	{
		header_ = '<a href="javascript://" onclick="f3_pop=1;get_product_relateds();">(X)</a> Muadil Ürünler';
		ajaxwindow('index.cfm?fuseaction=extra.emptypopup_detail_product_others&pid=' + r_product,'adminTv','product_others',header_);
		f3_pop = 1;
	}
	else
	{
		try 
		{ 
			ColdFusion.Window.destroy('product_others',true); 
		} 
		catch(e) 
		{}
		f3_pop = 0;	
	}
}

function get_product_detail_send(product_id)
{
	window.open('index.cfm?fuseaction=product.form_upd_product&pid=' + product_id,'list');
}

function get_product_detail_send_stock(product_id)
{
	window.open('index.cfm?fuseaction=stock.detail_stock&pid=' + product_id,'list');
}


function seller_limit_table(table_code)
{
	if(f4_pop == 0)
	{
		if(document.info_form.inner_table_code.value == '')
		{
			alert('Satıcı Limiti Alabilmek İçin Tabloyu Kayıt Etmelisiniz!');
			return false;	
		}
		
		vade_list = '';
		add_stock_list = '';
	
		
		adres_ = 'index.cfm?fuseaction=extra.emptypopup_seller_limit_table';
		adres_ += '&table_code=' + document.info_form.inner_table_code.value;
		adres_ += '&search_startdate=' + document.getElementById('search_startdate').value;
		adres_ += '&search_finishdate=' + document.getElementById('search_finishdate').value;
		
		header_ = '<a href="javascript://" onclick="seller_limit_table();">(X)</a> Satıcı Limitleri';
		ajaxwindow(adres_,'wwide1','seller_limit',header_);
		f4_pop = 1;
	}
	else
	{
		try 
		{ 
			ColdFusion.Window.destroy('seller_limit',true); 
		} 
		catch(e) 
		{}
		f4_pop = 0;	
	}
}

function show_shortcuts()
{
	document.getElementById("message_div_main_header_info").innerHTML = 'Kısayol Tuşları';
	document.getElementById("message_div_main").style.height = 500 + "px";
	document.getElementById("message_div_main").style.width = 500 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-500)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-500)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	show_hide('message_div_main');
	
	AjaxPageLoad('index.cfm?fuseaction=extra.emptypopup_get_short_cuts','message_div_main_body','1');
}

function get_stock_list(id_,type,dept)
{
	if(f2_pop == 0)
	{
		if(type=='product')
			header_ = '<a href="javascript://" onclick="f2_pop=1;get_stock_list();">(X)</a> Ürün Hareketleri';
		else if(type=='stock')
			header_ = '<a href="javascript://" onclick="f2_pop=1;get_stock_list();">(X)</a> Stok Hareketleri';
		else if(type=='department')
			header_ = '<a href="javascript://" onclick="f2_pop=1;get_stock_list();">(X)</a> Stok Hareketleri';
			
		if(type=='product')
			ajaxwindow('index.cfm?fuseaction=extra.popup_product_stocks_pre&&product_id=' + id_,'page_display','stock_window',header_);
		else if(type=='stock')
			ajaxwindow('index.cfm?fuseaction=extra.popup_product_stocks_pre&stock_id=' + id_,'page_display','stock_window',header_);	
		else if(type=='department')	
			ajaxwindow('index.cfm?fuseaction=extra.popup_product_stocks_pre&stock_id=' + id_ + '&search_department_id=' + dept,'page_display','stock_window',header_);
		f2_pop = 1;
	}
	else
	{
		try 
		{ 
			ColdFusion.Window.destroy('stock_window',true); 
		} 
		catch(e) 
		{}
		f2_pop = 0;	
	}
}

function get_new_layout()
{
	if(document.getElementById('layout_id').value != '')
	{
		adress_ = 'index.cfm?fuseaction=extra.popup_change_drag_table_new';
		adress_ += '&layout_id=' + document.getElementById('layout_id').value;
		
		document.getElementById("message_div_main_header_info").innerHTML = 'Görünüm';
		document.getElementById("message_div_main").style.height = 200 + "px";
		document.getElementById("message_div_main").style.width = 300 + "px";
		document.getElementById("message_div_main").style.top = (document.body.offsetHeight-200)/2 + "px";
		document.getElementById("message_div_main").style.left = (document.body.offsetWidth-300)/2 + "px";
		document.getElementById("message_div_main").style.zIndex = 99999;
		document.getElementById('message_div_main_body').style.overflowY = 'auto';
		document.getElementById('message_div_main_body').innerHTML = '<br><br>Görünüm Değiştiriliyor. Lütfen Bekleyiniz!';
		show('message_div_main');
		AjaxPageLoad(adress_,'speed_action_div');
	}
}

function save_layout()
{
	document.getElementById("message_div_main_header_info").innerHTML = 'Görünümü Kaydet';
	document.getElementById("message_div_main").style.height = 220 + "px";
	document.getElementById("message_div_main").style.width = 300 + "px";
	document.getElementById("message_div_main").style.top = (document.body.offsetHeight-220)/2 + "px";
	document.getElementById("message_div_main").style.left = (document.body.offsetWidth-300)/2 + "px";
	document.getElementById("message_div_main").style.zIndex = 99999;
	
	document.getElementById('message_div_main_body').style.overflowY = 'auto';
	show_hide('message_div_main');
	
	AjaxPageLoad('index.cfm?fuseaction=extra.emptypopup_save_layout_new&layout_id=' + document.getElementById('layout_id').value,'message_div_main_body','1');
}

function change_table_col_sh(col_name)
{
	if(document.getElementById('sh_' + col_name).checked == true)
	{
		$("#jqxgrid").jqxGrid('beginupdate');
		$("#jqxgrid").jqxGrid('showcolumn', col_name);
		$("#jqxgrid").jqxGrid('endupdate');
}
	else
	{
		$("#jqxgrid").jqxGrid('beginupdate');
		$("#jqxgrid").jqxGrid('hidecolumn', col_name);
		$("#jqxgrid").jqxGrid('endupdate');
	}
}

function change_table_col_sh2(col_name)
{
	$("#jqxgrid").jqxGrid('beginupdate');
	$("#jqxgrid").jqxGrid('hidecolumn', col_name);
	$("#jqxgrid").jqxGrid('endupdate');
}

function open_company_list(row_id)
{
		windowopen('index.cfm?fuseaction=objects.popup_list_manufact_comps&row_id=' + row_id,'list');
}

function callURL(url, callback, data, target, async)
{   
	// Make method POST if data parameter is specified
	var method = (data != null) ? "POST": "GET";
	$.ajax({
		async: async != null ? async: true,
		url: url,
		type: method,
		data: data,
		success: function(responseData, status, jqXHR)
		{ 
			callback(target, responseData, status, jqXHR); 
		},
		error: function(xhr, opt, err)
		{
			// If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
			if (err != null && err.toString().length != 0) callback(target, err, opt, xhr); 
		}
	});
}

function handlerPost(target, responseData, status, jqXHR){
	responseData = $.trim(responseData);
	
	if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
	//console.log(responseData);
	if (responseData == "1")
	{
		alert("İşlem başarılı!");
	} else 
	{
		document.getElementById('note').value = responseData;
		hide('message_div_main');
		windowopen('index.cfm?fuseaction=extra.popup_form_add_order2&order_id_list=' + responseData,'page');
	}
	//console.log($.evalJSON(responseData));
}

function callURL_table(url, callback, data, target, async)
{   
	// Make method POST if data parameter is specified
	var method = (data != null) ? "POST": "GET";
	$.ajax({
		async: async != null ? async: true,
		url: url,
		type: method,
		data: data,
		success: function(responseData, status, jqXHR)
		{ 
			callback(target, responseData, status, jqXHR); 
		},
		error: function(xhr, opt, err)
		{
			// If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
			if (err != null && err.toString().length != 0) callback(target, err, opt, xhr); 
		}
	});
}


function open_close_down_product(product_id)
{
	if(list_find(open_js_product_id_list,product_id))
	{
		open_js_product_id_list = list_setat(open_js_product_id_list,list_find(open_js_product_id_list,product_id),'0');
		
		var datainformations = $('#jqxgrid').jqxGrid('getdatainformation');
		var eleman_sayisi = datainformations.rowscount;
		
		for (var m=0; m < eleman_sayisi; m++)
		{
			var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData',m);
			r_type = ret_row.row_type;
			r_product = ret_row.ReportsTo;
			
			if(r_type != '1' && r_product == product_id)
			{
				$("#jqxgrid").jqxGrid('hiderow',m);	
			}
		}
	}
	else
	{
		if(open_js_product_id_list != '')
			open_js_product_id_list = open_js_product_id_list + ',' + product_id;
		else
			open_js_product_id_list = '0,' + product_id;
		
		var datainformations = $('#jqxgrid').jqxGrid('getdatainformation');
		var eleman_sayisi = datainformations.rowscount;
		
		for (var m=0; m < eleman_sayisi; m++)
		{
			var ret_row = jQuery("#jqxgrid").jqxGrid('getRowData',m);
			r_type = ret_row.row_type;
			r_product = ret_row.ReportsTo;
			
			if(r_type != '1' && r_product == product_id)
			{
				$("#jqxgrid").jqxGrid('showrow',m);	
			}
		}
	}
	return false;
}

function hesapla_row_siparis(alan_adi,deger,rowBoundIndex)
{
	var rows = $('#jqxgrid').jqxGrid('getboundrows');
	var eleman_sayisi = rows.length;
	
	if(alan_adi == 'siparis_miktar')
	{
		if(deger == '')
		{
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_1',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_kdv_1',0);	
		}
		else
		{
			list_price_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price');
			list_price_kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price_kdv');
			
			carpan = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan');
			carpan2 = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan2');
			
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_1',deger * list_price_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_kdv_1',deger * list_price_kdv_);
			
			if(carpan != '')
				$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_k',wrk_round(deger / carpan,2));
				
			if(carpan2 != '')
				$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_p',wrk_round(deger / carpan2,2));
				
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_onay',true);
		}	
	}
	else if(alan_adi == 'siparis_miktar_2')
	{
		if(deger == '')
		{
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_kdv_2',0);	
		}
		else
		{
			list_price_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price');
			list_price_kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price_kdv');
			
			carpan = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan');
			carpan2 = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan2');
			
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_2',deger * list_price_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_kdv_2',deger * list_price_kdv_);
			
			if(carpan != '')
				$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_k_2',wrk_round(deger / carpan,2));
				
			if(carpan2 != '')
				$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_p_2',wrk_round(deger / carpan2,2));
				
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_onay_2',true);
		}	
	}
	else if(alan_adi == 'siparis_miktar_k')
	{
		carpan = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan');
		
		if(deger == '' || carpan == '')
		{
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_k',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_p',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_1',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_kdv_1',0);	
		}
		else
		{
			list_price_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price');
			list_price_kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price_kdv');
			
			carpan = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan');
			carpan2 = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan2');
			
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_1',deger * carpan * list_price_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_kdv_1',deger * carpan * list_price_kdv_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar',wrk_round(deger * carpan,2));
			
			if(carpan2 != '')
				$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_p',wrk_round(deger * carpan / carpan2,2));
				
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_onay',true);
		}	
	}
	else if(alan_adi == 'siparis_miktar_k_2')
	{
		carpan = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan');
		
		if(deger == '' || carpan == '')
		{
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_k_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_p_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_kdv_2',0);	
		}
		else
		{
			list_price_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price');
			list_price_kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price_kdv');
			
			carpan = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan');
			carpan2 = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan2');
			
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_2',deger * carpan * list_price_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_kdv_2',deger * carpan * list_price_kdv_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_2',wrk_round(deger * carpan,2));
			
			if(carpan2 != '')
				$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_p_2',wrk_round(deger * carpan / carpan2,2));
				
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_onay_2',true);
		}	
	}
	else if(alan_adi == 'siparis_miktar_p')
	{
		carpan2 = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan2');
		
		if(deger == '' || carpan2 == '')
		{
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_k',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_p',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_1',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_kdv_1',0);	
		}
		else
		{
			list_price_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price');
			list_price_kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price_kdv');
			
			carpan = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan');
			carpan2 = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan2');
			
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_1',deger * carpan2 * list_price_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_kdv_1',deger * carpan2 * list_price_kdv_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar',wrk_round(deger * carpan2,2));
			
			if(carpan != '')
				$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_k',wrk_round(deger * carpan2 / carpan,2));
				
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_onay',true);
		}	
	}
	else if(alan_adi == 'siparis_miktar_p_2')
	{
		carpan2 = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan2');
		
		if(deger == '' || carpan2 == '')
		{
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_k_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_miktar_p_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_2',0);
			 $("#jqxgrid").jqxGrid('setcellvalue',rowBoundIndex,'siparis_tutar_kdv_2',0);	
		}
		else
		{
			list_price_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price');
			list_price_kdv_ = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'list_price_kdv');
			
			carpan = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan');
			carpan2 = $('#jqxgrid').jqxGrid('getcellvalue',rowBoundIndex,'carpan2');
			
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_2',deger * carpan2 * list_price_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_tutar_kdv_2',deger * carpan2 * list_price_kdv_);
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_2',wrk_round(deger * carpan2,2));
			
			if(carpan != '')
				$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_miktar_k_2',wrk_round(deger * carpan2 / carpan,2));
				
			$("#jqxgrid").jqxGrid('setcellvalue', rowBoundIndex,'siparis_onay_2',true);
		}	
	}
}