<!---
	  ! ! ! ! ! !     D İ K K A T  ! ! ! ! ! ! 
	Bu dosyada habersiz degisiklik yapmayin, problem agir gelebilir. 
	  ! ! ! ! ! !     D İ K K A T  ! ! ! ! ! !
--->
<script language="JavaScript1.3">
var basket_unique_code = 'window_' + js_create_unique_id();
var basket_last_input_value = 0;
var basket_last_input_new_value = 0;
var sale_product = '<cfoutput>#sale_product#</cfoutput>';
var amount_round = <cfoutput>#amount_round#</cfoutput>; <!--- //miktarın virgulden sonraki basamak sayısı --->
var price_round_number = <cfoutput>#price_round_number#</cfoutput>; <!--- //satır fiyat alanlarının virgulden sonraki basamak sayısı --->
var basket_total_round_number = <cfoutput>#basket_total_round_number#</cfoutput>; <!--- //basket genel toplamdaki alanlarının virgulden sonraki basamak sayısı --->
var basket_rate_round_number = <cfoutput>#basket_rate_round_number#</cfoutput>; <!--- //basket kur bilgisinin virgulden sonraki basamak sayısı --->
var use_basket_project_discount_ = <cfoutput>#use_basket_project_discount_#</cfoutput>; <!--- //baskette proje iskontoları calıstırılsın mı --->
var rowCount = document.getElementById('rows_').value;
var basket_member_id = '';<!--- 20060228 promlarda kullanmak uzere baskete secilen uyeyi tutuyor --->
<cfif ListFindNoCase(display_list, "deliver_dept_assortment")>
	departmentArray = new Array(1); 
	<cftry>
		<cfoutput>
			<cfloop from="1" to="#ArrayLen(sepet.satir)#" index="ai">
				<cfset temp_row = sepet.satir[ai]>
				departmentArray[#ai#] = new Array(1);
				<cfloop from="1" to="#ArrayLen(sepet.satir[ai].department_array)#" index="aj">
					departmentArray[#ai#][#aj#] = new Array(1);
					departmentArray[#ai#][#aj#][0] = #sepet.satir[ai].department_array[aj].AMOUNT#;  <!--- // miktar --->
					departmentArray[#ai#][#aj#][1] = #sepet.satir[ai].department_array[aj].DEPARTMENT_ID#;  <!--- // departman --->
					departmentArray[#ai#][#aj#][2] = #sepet.satir[ai].department_array[aj].LOCATION_ID#;  <!--- // lokasyon --->
				</cfloop>
			</cfloop>
		</cfoutput>
	<cfcatch></cfcatch>
	</cftry>
</cfif>
function apply_deliver_date(date_field_name,project_field_name,project_field_id)
{ /*taksitli satış ve satış siparişinde xmle baglı olarak cagrılıyor. belgenin teslim tarihini, satırlardaki boş teslim tarihi alanlarına aktarıyor.*/
	/*teslim tarihi kısmı*/
	if(date_field_name != '')
	{
		if(eval('document.form_basket.'+date_field_name)!=undefined && eval('document.form_basket.'+date_field_name).value!='')
			row_deliver_date_=eval('document.form_basket.'+date_field_name).value;
		else
			row_deliver_date_='';
	
		if(row_deliver_date_ != '')
		{
			if(rowCount > 1)
			{
				for(var row_db=0;row_db<rowCount;row_db++)
				{
					if(document.form_basket.deliver_date[row_db]!=undefined && document.form_basket.deliver_date[row_db].value=='')
						document.form_basket.deliver_date[row_db].value=row_deliver_date_;
				}
			}
			else if(rowCount == 1)
			{
				if(document.form_basket.deliver_date!=undefined && document.form_basket.deliver_date.value=='')
					document.form_basket.deliver_date.value=row_deliver_date_;
				else if(document.form_basket.deliver_date[0]!=undefined && document.form_basket.deliver_date[0].value=='')
					document.form_basket.deliver_date[0].value=row_deliver_date_;
			}
		}
	}
	/*proje kısmı*/
	if(project_field_name != undefined && project_field_name != '')
	{
		if(eval('document.form_basket.'+project_field_name)!=undefined && eval('document.form_basket.'+project_field_name).value!='' && (project_field_id == undefined || project_field_id == ''))
		{
			row_project_id_=document.form_basket.project_id.value;
			row_project_name_=document.form_basket.project_head.value;
		}
		else if(eval('document.form_basket.'+project_field_name)!=undefined && eval('document.form_basket.'+project_field_name).value!='' && project_field_id != undefined && project_field_id != '')
		{
			row_project_id_ = eval('document.form_basket.'+project_field_id).value ;
			row_project_name_ = eval('document.form_basket.'+project_field_name).value ;
		}
		else
		{
			row_project_id_='';
			row_project_name_='';
		}
		if(row_project_name_ != '' && row_project_id_ != '')
		{
			if(rowCount > 1)
			{
				for(var row_db=0;row_db<rowCount;row_db++)
				{
					if(document.form_basket.row_project_id[row_db]!=undefined && (document.form_basket.row_project_id[row_db].value=='' || document.form_basket.row_project_name[row_db].value==''))
					{
						document.form_basket.row_project_id[row_db].value=row_project_id_;
						document.form_basket.row_project_name[row_db].value=row_project_name_;
					}
				}
			}
			else if(rowCount == 1)
			{
				if(document.form_basket.row_project_id!=undefined && (document.form_basket.row_project_id.value=='' || document.form_basket.row_project_name.value==''))
				{
					document.form_basket.row_project_id.value=row_project_id_;
					document.form_basket.row_project_name.value=row_project_name_;
				}
				else if(document.form_basket.row_project_id[0]!=undefined && (document.form_basket.row_project_id[0].value=='' || document.form_basket.row_project_name[0].value==''))
				{
					document.form_basket.row_project_id[0].value=row_project_id_;
					document.form_basket.row_project_name[0].value=row_project_name_;
				}
			}
		}
	}
	return true;
}
function check_project_changes()
{ /*baskette urun secilmisse belgede seçilen projenin değistirilmesini engeller*/
<cfif ListFindNoCase(display_list, "is_project_not_change")>
	var str_control=0;
	if(document.form_basket.product_id!=undefined && document.form_basket.product_id.value!=undefined && document.form_basket.product_id.value!='' )
		str_control=1;
	else if(document.form_basket.product_id!=undefined && document.form_basket.product_id.length!= undefined && document.form_basket.product_id.length > 1)
	{
		for(var spt_row=0;spt_row < document.all.product_id.length;spt_row++)
		{
			if(document.all.product_id[spt_row].value!='')
			{
				str_control=1;
				break;
			}
		}
	}
	if(str_control==1)
	{
		document.form_basket.project_head.readOnly = true;
		alert("<cf_get_lang dictionary_id='60051.Belgede Satırlar Seçilmiş Projeyi Değiştiremezsiniz'>");
		return false;
	}
	else
	{
		AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135');		
	}
<cfelse>
	AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135');
	return true;
</cfif>
}
function check_reserved_rows()
{ 
//sipariste belge bazında rezervasyon secenegine baglı olarak satır reserve tiplerini edit eder.
	if(form_basket.reserved != undefined && form_basket.reserved.checked)
	{
		<cfif ListFindNoCase(display_list, "reserve_type")>
			if(rowCount > 1)
			{
				for(var inf_count_=0; inf_count_ < form_basket.reserve_type[1].options.length; inf_count_++)
					if(document.all.reserve_type[1].options[inf_count_].value == -1) //-1 rezerve secenegini gosteren  option bulunuyor
						var temp_reserve_index = inf_count_;
						
				for(var counter_i=0; counter_i < rowCount; counter_i++)
					if(document.all.order_currency[counter_i] != undefined && document.all.order_currency[counter_i].value != -3 && document.all.order_currency[counter_i].value != -8)
						setSelectedIndex('reserve_type', counter_i, temp_reserve_index); //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
			}
			else if(rowCount==1)
			{
				for(var inf_count_=0; inf_count_ < document.all.reserve_type.options.length; inf_count_++)
					if(document.all.reserve_type.options[inf_count_].value == -1) //-1 rezerve secenegini gosteren  option bulunuyor
						var temp_reserve_index = inf_count_;
						
				if(document.all.order_currency!= undefined && form_basket.order_currency.value != -3 && document.all.order_currency.value != -8)
					setSelectedIndex('reserve_type', rowCount-1, temp_reserve_index); //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
			}
		<cfelse> //reserve_type display listte secili ise selectox, degilse input olarak olusturuluyor.
			if(rowCount > 1)
			{
				for(var counter_i=0; counter_i < rowCount; counter_i++)
					if(document.all.order_currency[counter_i] != undefined && document.all.order_currency[counter_i].value != -3 && document.all.order_currency[counter_i].value != -8)
						document.all.reserve_type[counter_i].value= -1; //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
			}
			else if(rowCount==1 && document.all.order_currency!= undefined && document.all.order_currency.value != -3 && document.all.order_currency.value != -8)
				document.all.reserve_type.value= -1; //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
		</cfif>
	}
	else
	{
		<cfif ListFindNoCase(display_list, "reserve_type")>
			if(rowCount > 1)
			{
				for(var inf_count_=0; inf_count_ < document.all.reserve_type[1].options.length; inf_count_++)
					if(document.all.reserve_type[1].options[inf_count_].value == -3) //-1 rezerve degil secenegini gosteren  option bulunuyor
						var temp_reserve_index = inf_count_;
						
				for(var counter_i=0; counter_i < rowCount; counter_i++)
					if(document.all.order_currency[counter_i] != undefined && document.all.order_currency[counter_i].value != -3 && document.all.order_currency[counter_i].value != -8)
						setSelectedIndex('reserve_type', counter_i, temp_reserve_index); //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
			}
			else if(rowCount==1)
			{
				for(var inf_count_=0; inf_count_ < document.all.reserve_type.options.length; inf_count_++)
					if(document.all.reserve_type.options[inf_count_].value == -3) //-1 rezerve degil secenegini gosteren  option bulunuyor
						var temp_reserve_index = inf_count_;
						
				if(document.all.order_currency!= undefined && document.all.order_currency.value != -3 && document.all.order_currency.value != -8)
					setSelectedIndex('reserve_type', rowCount-1, temp_reserve_index); //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
			}
		<cfelse>
			if(rowCount > 1)
			{
				for(var counter_i=0; counter_i < rowCount; counter_i++)
					if(document.all.order_currency[counter_i] != undefined && document.all.order_currency[counter_i].value != -3 && document.all.order_currency[counter_i].value != -8)
						document.all.reserve_type[counter_i].value= -3; //kapatılmıs ve fazla teslimat asaması haricindeki tum satırlar rezerve olarak set ediliyors
			}
			else if(rowCount==1  && document.all.order_currency!= undefined && document.all.order_currency.value != -3 && document.all.order_currency.value != -8)
				document.all.reserve_type.value= -3;
		</cfif>
	}
}

function check_member_price_cat(type)
{
/*basketli islemler secilen uyenin dahil oldugu fiyat listesini baskete set eder. fatura vb islemlerde uye secme popupına gonderilmelidir OZDEN20071018*/
	if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
	{
		var get_member_pricecat = wrk_safe_query('obj_get_member_pricecat','dsn' , 0, form_basket.company_id.value);
		if(get_member_pricecat.recordcount == 0 || get_member_pricecat.PRICE_CATID == '')	
		{
			var get_member_cat = wrk_safe_query('obj_get_member_cat','dsn',0, form_basket.company_id.value);
			
			var listParam = "<cfoutput>#dsn_alias#</cfoutput>" + "*" + get_member_cat.COMPANYCAT_ID + "*" + +form_basket.company_id.value;
			var get_member_pricecat = wrk_safe_query("obj_get_member_pricecat_2","dsn3", 0, listParam);
		}	
		if(get_member_pricecat.recordcount)
			form_basket.basket_member_pricecat.value=get_member_pricecat.PRICE_CATID;
	}
	else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
	{
		var get_member_pricecat = wrk_safe_query('obj_get_member_pricecat','dsn',0,form_basket.consumer_id.value);
		if(get_member_pricecat.recordcount == 0 || get_member_pricecat.PRICE_CATID == '' )
		{
			var get_member_cat = wrk_safe_query('obj_get_member_cat_2','dsn',0,form_basket.consumer_id.value);
			
			var listParam = "<cfoutput>#dsn_alias#</cfoutput>" + "*" + get_member_cat.CONSUMER_CAT_ID + "*" + form_basket.consumer_id.value;
			var get_member_pricecat = wrk_safe_query("obj_get_member_pricecat_3","dsn3",0,listParam);
		}	
		if(get_member_pricecat.recordcount) 
			form_basket.basket_member_pricecat.value=get_member_pricecat.PRICE_CATID;
	}
	if(type == undefined)
	{
		<cfif listfind('2',attributes.basket_id)>
			control_einvoice_paper();
		</cfif>
	}
}
function control_einvoice_paper()
{
	if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
	{
		var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
	}
	else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
	{
		var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
	}
	if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
		paper_type = 'E_INVOICE';
	else
		paper_type = 'INVOICE';

	var get_paper = workdata('get_paper',paper_type);
	if(eval('get_paper.'+paper_type+'_NUMBER') != '')
	{
		obj_name = 'form_basket.serial_no';
		obj_name_extra = 'form_basket.serial_number';
		if(get_paper.recordcount)
		{
			document.getElementById('paper').value = String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
			eval(obj_name_extra).value = String(eval('get_paper.'+paper_type+'_NO'));
			eval(obj_name).value = String(parseFloat(eval('get_paper.'+paper_type+'_NUMBER'))+1);
		}
		/*else
		{
			document.getElementById('paper').value = '';
			eval(obj_name_extra).value = '';
			eval(obj_name).value = '';
		}*/
	}
}
check_member_price_cat(0);
function apply_duedate(type,due_date_value)
{	
	var row_count = rowCount-1;
	temp_row_due_date=eval('form_basket.duedate');
	if(type==2)
		set_due_date = form_basket.set_row_duedate.value;
	else if(type==1 && due_date_value != undefined && due_date_value !='')
		set_due_date=due_date_value;
	else
		set_due_date='';
	if(rowCount > 1)
	{
		for(var dd=0;dd<=row_count;dd++){
			document.getElementById('sepetim').scrollTop = document.getElementById('sepetim').scrollTop+21;
			if(type==1 && temp_row_due_date[dd].value=='')//change_paper_duedate fonksiyonundan type 1 gonderilerek cagrılıyor ve sadece bos olan vadeler degistiriliyor
				temp_row_due_date[dd].value = set_due_date;
			else if(type==2)
			{
				temp_row_due_date[dd].value = set_due_date;	
				<cfif not listfindnocase(display_list,'number_of_installment')>
				/*taksitli satıs secili degilse vade degistiginde fiyat tekrar hesaplanır, fiyat degisiyorsa set_basket_duedate_price icinde yeniden hesapla calıstırılıyor */
					eval('set_basket_duedate_price(form_basket.duedate['+dd+'].parentNode.parentNode.rowIndex-1)');
				</cfif>
			}
			<cfif not listfindnocase(display_list,'duedate')>
				if(type==1)
					temp_row_due_date[dd].value = set_due_date;
			</cfif>
		}
		if(type!=1)
			set_paper_duedate();//satır vadelerine baglı olarak belge ortalama vadesini hesaplar
	}
	else if(rowCount == 1){<!--- baskette tek satir varsa --->
		if(type==1 && temp_row_due_date.value=='')//change_paper_duedate fonksiyonundan type 1 gonderilerek cagrılıyor ve sadece bos olan vadeler degistiriliyor
			temp_row_due_date.value = set_due_date;
		else if(type==2)
		{
			temp_row_due_date.value = set_due_date;	
			<cfif not listfindnocase(display_list,'number_of_installment')>/*taksitli satıs secili degilse vade degistiginde fiyat tekrar hesaplanır*/
				set_basket_duedate_price(form_basket.duedate.parentNode.parentNode.rowIndex-1);
			</cfif>
		}
		<cfif not listfindnocase(display_list,'duedate')>
			if(type==1)
				temp_row_due_date.value = set_due_date;
		</cfif>
		if(type!=1)
			set_paper_duedate();//satır vadelerine baglı olarak belge ortalama vadesini hesaplar
		}
	else return true;
}
function change_paper_duedate(field_name,type,is_row_parse) 
{
	if(field_name == undefined || field_name=='')
		field_name = document.all.search_process_date.value;
		
	paper_date_ = document.getElementById(field_name).value;
	
	if(document.getElementById("paymethod_id") != undefined && document.getElementById("paymethod_id").value != "")
	{
		var get_paymethod = wrk_query("SELECT IS_DUE_ENDOFMONTH,ISNULL(DUE_DAY,0) DUE_DAY FROM SETUP_PAYMETHOD WHERE IS_DUE_ENDOFMONTH = 1 AND PAYMETHOD_ID = " + document.getElementById("paymethod_id").value,"dsn",1);
		if(get_paymethod.recordcount != 0)
		{
			var date_diff_today = (parseInt(new Date(paper_date_.split("/")[2], paper_date_.split("/")[1], 0).getDate())-paper_date_.split("/")[0]);                                         
			document.all.basket_due_value.value = parseInt(get_paymethod.DUE_DAY);
			paper_date_ = (new Date(paper_date_.split("/")[2], paper_date_.split("/")[1], 0).getDate()) + "/" + paper_date_.split("/")[1] + "/" + paper_date_.split("/")[2];
		}
		/* Sevim Çelik */
	}
	
	if(type!=undefined && type==1)
	{
		document.all.basket_due_value.value = datediff(paper_date_,document.all.basket_due_value_date_.value,0);
	}
	else
	{
		if(isNumber(document.all.basket_due_value)!= false && (document.all.basket_due_value.value != 0))
		{
			document.all.basket_due_value_date_.value = date_add('d',+document.all.basket_due_value.value,paper_date_);
		}
		else
		{
			document.all.basket_due_value_date_.value =paper_date_;
			if(document.all.basket_due_value.value == '')
			{
				document.all.basket_due_value.value = datediff(paper_date_,document.all.basket_due_value_date_.value,0);
			}
		}
	}
	paper_due_day = document.all.basket_due_value.value;
	//vade gun sayısı vadesi bos olan basket satırlarına yansıtılır
	if(is_row_parse==undefined || is_row_parse==1) //apply_duedate > set_paper_duedate >change_paper_duedate zincirinde cagrılmıssa satırlar tekrar kontrol edilmez
	{
		apply_duedate(1,document.all.basket_due_value.value);
	}
}
<cfif ListFindNoCase(display_list,'duedate')>
function set_paper_duedate() //satır vadelerine baglı olarak belge ortalama vadesini hesaplar
{
	//alert('set_paper_duedate');
	if(rowCount > 1)  // belgenin vadesi degistiriliyor
	{
		var general_total_ = 0;
		var row_totals_=0
		for(var counter_i=0; counter_i < rowCount; counter_i++) 
		{
			row_due_date_ = filterNumBasket(document.all.duedate[counter_i].value,0);
			temp_row_total_ = filterNumBasket(document.all.row_lasttotal[counter_i].value,price_round_number);
			general_total_ = general_total_+ (row_due_date_*temp_row_total_);
			row_totals_ = row_totals_ + temp_row_total_;
		}
		if(row_totals_ != 0 && form_basket.basket_due_value != undefined)
		{
			form_basket.basket_due_value.value = wrk_round((general_total_/row_totals_),0);
		}
	}
	else
	{
		if(document.all.duedate != undefined && document.all.duedate.value!= '' && document.all.basket_due_value != undefined)
		{
			form_basket.basket_due_value.value =  filterNumBasket(document.all.duedate.value);
		}
	}
	<cfif listfind('4,6',attributes.basket_id)>
		field_name_info_ = 'order_date';
	<cfelse>
		field_name_info_ = '';
	</cfif>
	if(document.all.basket_due_value_date_ != undefined && document.all.basket_due_value_date_.value!='' && typeof change_due_date != "undefined") //vade tarih inputu varsa ve change_due_date fonksyionu sayfada tanımlı ise
	{
		change_due_date();
	}
	else if(document.all.basket_due_value_date_ != undefined && document.all.basket_due_value_date_.value!='' && typeof change_paper_duedate != "undefined") //vade tarih inputu varsa ve change_due_date fonksyionu sayfada tanımlı ise
		change_paper_duedate(field_name_info_,2,0);
	//alert('/set_paper_duedate');
}	
</cfif>
<cfif isdefined('use_basket_project_discount_') and use_basket_project_discount_ eq 1> <!--- proje baglantı kontrolleri --->
	function check_member_project_risk(project_id_)
	{
		if(document.form_basket.order_id != undefined && document.form_basket.order_id.value!='')
			var chck_order_id_ = document.form_basket.order_id.value;
		else
			var chck_order_id_ = 0;
		if(project_id_!=undefined && project_id_ !='')
		{
			var prj_total_risk_=0;
			<cfif attributes.basket_id eq 6><!--- Satınalma siparişi ise satınalma işlemlerinden çalışacak --->
				if(document.all.company_id!=undefined && document.all.company_id.value!='')
				{
					var str_member_prj_risk_ = 'SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE COMPANY_ID = '+document.form_basket.company_id.value+' AND PROJECT_ID='+project_id_;
					
					var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					str_prj_order_risk_=str_prj_order_risk_+' AND ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=0 AND IS_PAID<>1 AND COMPANY_ID='+form_basket.company_id.value+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+chck_order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
			
					var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 0 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID='+form_basket.company_id.value+' AND S.PROJECT_ID='+project_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					if(chck_order_id_ > 0)
						str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+chck_order_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				}
				else if(document.all.consumer_id!=undefined && document.all.consumer_id.value!='')
				{
					var str_member_prj_risk_ = 'SELECT * FROM CONSUMER_REMAINDER_PROJECT WHERE CONSUMER_ID = '+document.form_basket.consumer_id.value+' AND PROJECT_ID='+project_id_;
					
					var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					str_prj_order_risk_=str_prj_order_risk_+' AND ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=0 AND IS_PAID<>1 AND CONSUMER_ID='+form_basket.consumer_id.value+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+chck_order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
	
					var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES = 0 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID='+form_basket.consumer_id.value+' AND S.PROJECT_ID='+project_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					if(chck_order_id_ > 0)
						str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+chck_order_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				}
				if(str_member_prj_risk_!=undefined)
				{
					var get_member_prj_risk = wrk_query(str_member_prj_risk_,'dsn2');
					if(get_member_prj_risk.recordcount!= 0 && get_member_prj_risk.BAKIYE!='')
						prj_total_risk_=parseFloat(get_member_prj_risk.BAKIYE);
				}
			<cfelse>
				if(document.all.company_id!=undefined && document.all.company_id.value!='')
				{
					var str_member_prj_risk_ = 'SELECT * FROM COMPANY_REMAINDER_PROJECT WHERE COMPANY_ID = '+document.form_basket.company_id.value+' AND PROJECT_ID='+project_id_;
					
					var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					str_prj_order_risk_=str_prj_order_risk_+' AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND COMPANY_ID='+form_basket.company_id.value+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+chck_order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
			
					var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.PURCHASE_SALES = 1 AND S.SHIP_ID=SR.SHIP_ID AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.COMPANY_ID='+form_basket.company_id.value+' AND S.PROJECT_ID='+project_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					if(chck_order_id_ > 0)
						str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+chck_order_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				}
				else if(document.all.consumer_id!=undefined && document.all.consumer_id.value!='')
				{
					var str_member_prj_risk_ = 'SELECT * FROM CONSUMER_REMAINDER_PROJECT WHERE CONSUMER_ID = '+document.form_basket.consumer_id.value+' AND PROJECT_ID='+project_id_;
					
					var str_prj_order_risk_='SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					str_prj_order_risk_=str_prj_order_risk_+' SELECT ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*'
					str_prj_order_risk_=str_prj_order_risk_+' (((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL FROM <cfoutput>#dsn3_alias#</cfoutput>.ORDERS,<cfoutput>#dsn3_alias#</cfoutput>.ORDER_ROW ORD_ROW WHERE ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND ISNULL(IS_MEMBER_RISK,1)=1 AND ORDER_STATUS=1'
					str_prj_order_risk_=str_prj_order_risk_+' AND ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND IS_PAID<>1 AND CONSUMER_ID='+form_basket.consumer_id.value+' AND PROJECT_ID='+project_id_+' AND ORDERS.ORDER_ID<>'+chck_order_id_+' AND ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT))>0 AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)) AS A1';
	
					var str_prj_ship_total_ = 'SELECT ISNULL(SUM(NETTOTAL),0) NETTOTAL FROM ('
					var str_prj_ship_total_ = str_prj_ship_total_+' SELECT ((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR,INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR WHERE S.SHIP_ID=SR.SHIP_ID AND S.PURCHASE_SALES = 1 AND S.IS_WITH_SHIP=0 AND ISNULL(S.IS_SHIP_IPTAL,0)=0 AND S.CONSUMER_ID='+form_basket.consumer_id.value+' AND S.PROJECT_ID='+project_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+' AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM <cfoutput>#dsn2_alias#</cfoutput>.INVOICE_ROW IR,<cfoutput>#dsn2_alias#</cfoutput>.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0';
					if(chck_order_id_ > 0)
						str_prj_ship_total_ = str_prj_ship_total_+' AND SR.ROW_ORDER_ID <> '+chck_order_id_;
					var str_prj_ship_total_ = str_prj_ship_total_+') A1';
				}
				if(str_member_prj_risk_!=undefined)
				{
					var get_member_prj_risk = wrk_query(str_member_prj_risk_,'dsn2');
					if(get_member_prj_risk.recordcount!= 0 && get_member_prj_risk.BAKIYE!='')
						prj_total_risk_=parseFloat(get_member_prj_risk.BAKIYE)*(-1);
				}
			</cfif>
			if( str_prj_order_risk_!=undefined)
			{
				var get_prj_order_risk_=wrk_query(str_prj_order_risk_,'dsn2');
				if(get_prj_order_risk_.recordcount!= 0 && get_prj_order_risk_.NETTOTAL!='')
					prj_total_risk_=parseFloat(prj_total_risk_)-parseFloat(get_prj_order_risk_.NETTOTAL);
			}
			if(str_prj_ship_total_!=undefined)
			{
				var get_prj_ship_total_=wrk_query(str_prj_ship_total_,'dsn2');
				if(get_prj_ship_total_.recordcount!= 0 && get_prj_ship_total_.NETTOTAL!='' )
					prj_total_risk_=parseFloat(prj_total_risk_)-parseFloat(get_prj_ship_total_.NETTOTAL);
			}
			if(prj_total_risk_<=0 || (prj_total_risk_ < parseFloat(form_basket.basket_net_total.value) ) )
			{
				alert("<cf_get_lang dictionary_id='34370.Cari Alacak Bakiyesi Siparişi Kaydetmek İçin Yeterli Değil.'>\n <cf_get_lang dictionary_id='34371.Siparişi Kaydedemezsiniz'> \n <cf_get_lang dictionary_id='34373.Proje Bakiyesi'>:" +commaSplit(prj_total_risk_));
				return false;
			}
			else return true;
		}
	}
	function check_project_discount_conditions(prj_id_,prj_name_)
	{
		if(prj_id_==undefined) var prj_id_='';
		if(prj_name_==undefined) var prj_name_='';
		if(prj_id_=='' && document.form_basket.project_id!=undefined)
			var prj_id_=document.form_basket.project_id.value;
		if(prj_name_=='' && document.form_basket.project_head!=undefined)
			var prj_name_=document.form_basket.project_head.value;
		
		var paper_date_ = js_date( eval('form_basket.'+document.all.search_process_date.value+'.value').toString() );

		if(prj_id_!='' && prj_name_!='')
		{
			var str_prj_discnt="SELECT COMPANY_ID,CONSUMER_ID,FINISH_DATE,START_DATE,PRICE_CATID,PD.PRO_DISCOUNT_ID,IS_CHECK_RISK,IS_CHECK_PRJ_LIMIT,IS_CHECK_PRJ_PRODUCT,IS_CHECK_PRJ_MEMBER,IS_CHECK_PRJ_PRICE_CAT,BRAND_ID,PRODUCT_CATID,PRODUCT_ID FROM PROJECT_DISCOUNTS PD,PROJECT_DISCOUNT_CONDITIONS PDC ";
			str_prj_discnt=str_prj_discnt+" WHERE PD.PRO_DISCOUNT_ID=PDC.PRO_DISCOUNT_ID AND PD.PROJECT_ID="+prj_id_+" AND FINISH_DATE >="+paper_date_+" AND START_DATE<="+paper_date_;
			
			var get_prj_discnt=wrk_query(str_prj_discnt,"dsn3");
			
			if(get_prj_discnt.recordcount != undefined && get_prj_discnt.recordcount != 0)
			{
				if(get_prj_discnt.recordcount > 1)
				{
					var control_comp_info=get_prj_discnt.COMPANY_ID[1];
					var control_cons_info=get_prj_discnt.CONSUMER_ID[1];
					var control_price_cat_info=get_prj_discnt.PRICE_CATID[1];
					var is_chck_prj_prods_=get_prj_discnt.IS_CHECK_PRJ_PRODUCT[1];
					var is_chck_prj_risk_=get_prj_discnt.IS_CHECK_PRJ_LIMIT[1];
					var is_chck_prj_member_=get_prj_discnt.IS_CHECK_PRJ_MEMBER[1];
					var is_chck_prj_pricecat_=get_prj_discnt.IS_CHECK_PRJ_PRICE_CAT[1];
				}
				else
				{
					var control_comp_info=get_prj_discnt.COMPANY_ID;
					var control_cons_info=get_prj_discnt.CONSUMER_ID;
					var control_price_cat_info=get_prj_discnt.PRICE_CATID;
					var is_chck_prj_prods_=get_prj_discnt.IS_CHECK_PRJ_PRODUCT;
					var is_chck_prj_risk_=get_prj_discnt.IS_CHECK_PRJ_LIMIT;
					var is_chck_prj_member_=get_prj_discnt.IS_CHECK_PRJ_MEMBER;
					var is_chck_prj_pricecat_=get_prj_discnt.IS_CHECK_PRJ_PRICE_CAT;
			}
				if(is_chck_prj_member_ ==1 && (document.form_basket.company_id!=undefined && document.form_basket.company_id.value !=control_comp_info) || (document.form_basket.consumer_id!=undefined && document.form_basket.consumer_id.value !=control_cons_info))
				{
					alert("<cf_get_lang dictionary_id='60052.Seçilen Cari İle Proje Bağlantı Carisi Aynı Değil'>!");
					return false;
				}
				var price_cat_row=0;
				var cntrl_prj_prods_=0;
				if(is_chck_prj_risk_==1)  /*baglantı kapsamında proje limit kontrolu yapılacaksa*/
				{
					<cfif not (isdefined("x_check_prj_bakiye_for_process") and len(x_check_prj_bakiye_for_process))>
						if(!check_member_project_risk(prj_id_)) return false;
					<cfelse>
						var control_process_ids = "<cfoutput>#x_check_prj_bakiye_for_process#</cfoutput>";
						if(! list_find(control_process_ids,document.form_basket.process_stage.value))
						{
							if(!check_member_project_risk(prj_id_)) return false;
						}
					</cfif>
				}
				if(rowCount > 1)
				{
					for(var roww_ii=0; roww_ii < rowCount; roww_ii++)
						if(is_chck_prj_pricecat_==1 && document.all.price_cat[roww_ii].value != control_price_cat_info)
						{
							price_cat_row=roww_ii+1;
							break;
						}
						else
							cntrl_prj_prods_=cntrl_prj_prods_+','+document.all.product_id[roww_ii].value;
				}
				else
				{
					if(document.all.product_id[0]!= undefined)
						cntrl_prj_prods_=cntrl_prj_prods_+','+document.all.product_id[0].value;
					else if(document.all.product_id!= undefined)
						cntrl_prj_prods_=cntrl_prj_prods_+','+document.all.product_id.value;
						
					if(is_chck_prj_pricecat_==1) //fiyat liatesi kontrolu yapılacaksa
					{
						if(document.all.price_cat[0] != undefined && document.all.price_cat[0].value != control_price_cat_info)
							price_cat_row=1;
						else if(document.all.price_cat != undefined && document.all.price_cat.value != control_price_cat_info)
							price_cat_row=1;
					}
				
				}
				if(price_cat_row > 0)
				{
					alert(price_cat_row+ "<cf_get_lang dictionary_id='60053.Satırdaki ürünün eklendiği fiyat listesi ile proje bağlantısında seçilen fiyat listesi farklı!'>");
					return false;
				}
				if(is_chck_prj_prods_==1 && list_len(cntrl_prj_prods_,',')>1) /*baglantı kapsamında urun kontrolu yapılacaksa*/
				{
					var prj_prod_list_=0;
					var prj_brand_list_=0;
					var prj_prod_cat_list=0;
					for(var prj_dis_ii=0;prj_dis_ii<get_prj_discnt.recordcount;prj_dis_ii++)
					{
						if(get_prj_discnt.PRODUCT_ID[prj_dis_ii]!='')
							prj_prod_list_=prj_prod_list_+','+get_prj_discnt.PRODUCT_ID[prj_dis_ii];
						if(get_prj_discnt.BRAND_ID[prj_dis_ii]!='')
							prj_brand_list_=prj_brand_list_+','+get_prj_discnt.BRAND_ID[prj_dis_ii];
						if(get_prj_discnt.PRODUCT_CATID[prj_dis_ii]!='')
							prj_prod_cat_list=prj_prod_cat_list+','+get_prj_discnt.PRODUCT_CATID[prj_dis_ii];
					}
					
					var str_prod_list_="SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (" + cntrl_prj_prods_ + ") AND (";
					if(prj_brand_list_!=0 && list_len(prj_brand_list_ )>1)
					{
						str_prod_list_=str_prod_list_+"	 ISNULL(BRAND_ID,0) NOT IN ("+prj_brand_list_+") ";
						if((prj_prod_cat_list!=0 && list_len(prj_prod_cat_list )>1) || (prj_prod_list_!=0 && list_len(prj_prod_list_ )>1))
							str_prod_list_=str_prod_list_+"	OR ";	
					}
					if(prj_prod_cat_list!=0 && list_len(prj_prod_cat_list )>1)
					{
						str_prod_list_=str_prod_list_+"	ISNULL(PRODUCT_CATID,0) NOT IN ("+prj_prod_cat_list+")";
						if(prj_prod_list_!=0 && list_len(prj_prod_list_ )>1)
							str_prod_list_=str_prod_list_+"	OR ";	
					}	
					if(prj_prod_list_!=0 && list_len(prj_prod_list_ )>1)
						str_prod_list_=str_prod_list_+" PRODUCT_ID NOT IN ("+prj_prod_list_+")";
					str_prod_list_=str_prod_list_+" )";
					var get_prod_list_=wrk_query(str_prod_list_,"dsn3");
					if(get_prod_list_.recordcount!=undefined && get_prod_list_.recordcount!=0)
					{
						var alert_str = 'Bağlantı Kapsamında Olmayan Ürünler :\n'
						for(var pr_ii=0;pr_ii<get_prod_list_.recordcount;pr_ii++)
							alert_str=alert_str+' '+get_prod_list_.PRODUCT_NAME[pr_ii] + '\n';

						alert(alert_str);
						return false;
					}
				}
			}
			else
			{
				alert("<cf_get_lang dictionary_id='60024.İşlem Tarihinde Geçerli Proje Bağlantısı Yok'>!");
				return false;
			}
		}
		else
		{
			<cfif ListFindNoCase(display_list, "is_project_selected")> 
				alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>");
				return false;
			<cfelse>
				return true;
			</cfif>
		}
		return true;
		
	}
</cfif>
function control_prod_discount(cntrl_row) 
{//sadece taksitli satıs (52) basketinde calısıyor. urun 1.kosulu ile basketteki 1. iskontosunu karsilastirip kullanıcıyı uyarıyor.
	if(form_basket.paymethod_id != undefined && form_basket.paymethod_id.value != '')
	{
		if(rowCount > 1)
		{
			var cntrl_product_id_ = document.all.product_id[cntrl_row].value;
			var cntrl_row_discount_ = filterNumBasket(document.all.indirim1[cntrl_row].value);
		}
		else
		{
			var cntrl_product_id_ = document.all.product_id.value;
			var cntrl_row_discount_ = filterNumBasket(document.all.indirim1.value);
		}
		if(cntrl_product_id_ !='')
		{
			var disc_valid_date = js_date( eval('form_basket.'+document.all.search_process_date.value+'.value').toString() );
			var listParam = cntrl_product_id_ + "*" + form_basket.paymethod_id.value + "*" + disc_valid_date ;
			var get_prod_max_discount = wrk_safe_query("obj_get_prod_max_discount","dsn3",0,listParam);
			if(get_prod_max_discount.recordcount != undefined && get_prod_max_discount.recordcount != 0 && get_prod_max_discount.DISCOUNT1 < cntrl_row_discount_)
				alert(parseInt(cntrl_row+1) +'.Satırdaki Ürün İçin Geçerli Max. İskonto Oranı :'+ get_prod_max_discount.DISCOUNT1 + ' dir.');
		}
	}
}
<cfif ListFindNoCase(display_list, "check_row_discounts")><!--- şube iskonto yetki tanımlarını kontrol ediyor --->
function check_branch_discount_rates()
{
	var alert_list='';
	var cntrl_disc_prod_list=0;
	if(rowCount > 1)
	{
		for(var roww_dd=0; roww_dd < rowCount; roww_dd++)
		{
			if(document.all.indirim1[roww_dd]!=undefined && document.all.indirim1[roww_dd].value !=0 )
				cntrl_disc_prod_list=cntrl_disc_prod_list+','+document.all.product_id[roww_dd].value;
		}
	}
	else
	{
		if(document.all.indirim1[0]!= undefined)
		{
			if(document.all.indirim1[0].value !=0)
				cntrl_disc_prod_list=cntrl_disc_prod_list+','+document.all.product_id[0].value;
		}
		else if(document.all.indirim1!= undefined)
		{
			if(document.all.indirim1.value !=0)
				cntrl_disc_prod_list=cntrl_disc_prod_list+','+document.all.product_id.value;
		}
	}
	if(form_basket.paymethod_id != undefined && list_len(cntrl_disc_prod_list)>1)
	{
		var listParam = cntrl_disc_prod_list + "*" + document.form_basket.paymethod_id.value;
		var str_branch_disc= "obj_get_branch_disc"
		if(document.form_basket.paymethod_id != undefined && document.form_basket.paymethod_id.value != '')
			str_branch_disc= "obj_get_branch_disc_2";
		else if(form_basket.card_paymethod_id != undefined && form_basket.card_paymethod_id.value != '')
			str_branch_disc="obj_get_branch_disc_3";
		var get_branch_disc=wrk_safe_query(str_branch_disc,"dsn3",0,listParam);
		if(get_branch_disc.recordcount!=undefined && get_branch_disc.recordcount!=0)
		{
			//document.form_basket.detail.value=str_branch_disc;
			var prod_list_disc = '';
			for(var pr_tt=0;pr_tt<get_branch_disc.recordcount;pr_tt++)
			{
				if(prod_list_disc=='')
					prod_list_disc=get_branch_disc.PRODUCT_ID[pr_tt];
				else
					prod_list_disc=prod_list_disc+','+get_branch_disc.PRODUCT_ID[pr_tt];
			}
			if(rowCount > 1)
			{
				var alert_add_prod_list='0';
				for(var roww_aa=0; roww_aa < rowCount; roww_aa++)
				{
					temp_row_discount=filterNumBasket(document.all.indirim1[roww_aa].value);
					if(temp_row_discount !=0 && list_find(prod_list_disc,document.all.product_id[roww_aa].value) && get_branch_disc.MAX_DISCOUNT[list_find(prod_list_disc,document.all.product_id[roww_aa].value)-1] < temp_row_discount)
					{	
						if(list_find(alert_add_prod_list,document.all.product_id[roww_aa].value)==0)
						{
							alert_list=alert_list+' '+get_branch_disc.PRODUCT_NAME[list_find(prod_list_disc,document.all.product_id[roww_aa].value)-1] + ' ürünü için max. iskonto miktarı '+get_branch_disc.MAX_DISCOUNT[0]+' olmalıdır. \n';
							alert_add_prod_list=alert_add_prod_list+','+document.all.product_id[roww_aa].value;
						}
					}
				}
			}
			else
			{
				if(document.all.product_id[0]!= undefined)
				{
					temp_row_discount=filterNumBasket(document.all.indirim1[0].value);
					if(temp_row_discount !=0 && list_find(prod_list_disc,document.all.product_id[0].value) && get_branch_disc.MAX_DISCOUNT[0] < temp_row_discount)
						alert_list=get_branch_disc.PRODUCT_NAME[0] + ' ürünü için max. iskonto miktarı '+get_branch_disc.MAX_DISCOUNT[0]+' olmalıdır. \n';
				}
				else if(document.all.product_id!= undefined)
				{
					temp_row_discount=filterNumBasket(document.all.indirim1.value);
					if(temp_row_discount !=0 && list_find(prod_list_disc,document.all.product_id.value) && get_branch_disc.MAX_DISCOUNT[0] < temp_row_discount)
						alert_list=get_branch_disc.PRODUCT_NAME[0] + ' ürünü için max. iskonto miktarı '+get_branch_disc.MAX_DISCOUNT[0]+' olmalıdır. \n';
				}
			}
		}
	}
	if(alert_list!='')
	{
		alert("<cf_get_lang dictionary_id='60054.Aşağıda Belirtilen Ürünlerin İskonto Oranlarını Kontrol Ediniz'>!" \n\n + alert_list);
		return false;
	}
	else
		return true;
}
</cfif>
function set_basket_duedate_price(from_row) 
{//basket satırındaki vade degistiginde vade farkı oranlarına gore yeni fiyatı hesaplar. baskette taksit alanı seciliyse öncelik taksitten fiyat hesaplama (basket_taksit_hesapla) fonksiyonundadır
	if(rowCount > 1)
	{
		var row_duedate_= filterNumBasket(document.all.duedate[from_row].value,0);
		var row_list_price_ = filterNumBasket(document.all.list_price[from_row].value,price_round_number);
		var row_price_cat_ = document.all.price_cat[from_row].value;
	}
	else
	{
		var row_duedate_ = filterNumBasket(document.all.duedate.value,0);
		var row_list_price_ = filterNumBasket(document.all.list_price.value,price_round_number);
		var row_price_cat_ = document.all.price_cat.value;
	}
	if(row_duedate_!='' && row_price_cat_ != undefined && row_price_cat_ != '')
	{
		var get_price_cat_detail_ = wrk_safe_query('obj_get_price_cat_detail',"dsn3",0,row_price_cat_);
		
		if(get_price_cat_detail_.recordcount != undefined && get_price_cat_detail_.recordcount != 0 && get_price_cat_detail_.AVG_DUE_DAY != '' && get_price_cat_detail_.DUE_DIFF_VALUE != '')
		{
			if(get_price_cat_detail_.AVG_DUE_DAY> row_duedate_) //erken vade oranını kullanarak indirimli fiyatı hesaplayacak, fiyat listelerinde erken vade oranı aylık bazda tutuldugundan gune cevirip hesaplanıyor
				var new_price_ = (row_list_price_- ( (row_list_price_*parseInt(get_price_cat_detail_.AVG_DUE_DAY-row_duedate_)*(get_price_cat_detail_.EARLY_PAYMENT/30) ) /100)) ;
			else if(get_price_cat_detail_.AVG_DUE_DAY < row_duedate_) //vade farkı oranını kullanarak yeni fiyatı hesaplayacak
				var new_price_ = (row_list_price_+( (row_list_price_*parseInt(row_duedate_-get_price_cat_detail_.AVG_DUE_DAY)*(get_price_cat_detail_.DUE_DIFF_VALUE/30) ) /100)) ;
			else if(get_price_cat_detail_.AVG_DUE_DAY == row_duedate_)
				var new_price_ = row_list_price_;
			if(new_price_ != undefined && new_price_ != '' && ! isNaN(new_price_))
			{
				setFieldValue('price', from_row, wrk_round(new_price_,price_round_number),3); //fiyat degistiriliyor
				hesapla('price',from_row+1); //satır yeniden hesaplanıyor
			}
		}
	}
}
<cfif ListFindNoCase(display_list, "number_of_installment")>
function basket_taksit_hesapla(from_row)
{//basket satırındaki taksit degistiginde taksit oranlarına gore yeni fiyatı hesaplar.
	if(form_basket.paymethod_vehicle != undefined && form_basket.paymethod_vehicle.value != '')
	{
		var price_list_inst_number = 0;
		if(rowCount > 1)
		{
			var new_installment_number_ =  filterNumBasket(document.all.number_of_installment[from_row].value,0);
			var row_price_cat_ = document.all.price_cat[from_row].value;
			var row_list_price_ = filterNumBasket(document.all.list_price[from_row].value,price_round_number);
			var row_product_id_ = document.all.product_id[from_row].value;
		}
		else
		{
			var new_installment_number_ = filterNumBasket(document.all.number_of_installment.value,0);
			var row_price_cat_ = document.all.price_cat.value;
			var row_list_price_ = filterNumBasket(document.all.list_price.value,price_round_number);
			var row_product_id_ = document.all.product_id.value;
		}
		if(new_installment_number_ != 0 )
			var avg_due_day = (30+(new_installment_number_*30))/2;
		else
			var avg_due_day = 0;
		setFieldValue('duedate', from_row, avg_due_day,0); //satırın vadesi degistiriliyor
		if(row_price_cat_ !='')
		{
			var new_sql = 'SELECT PRICE_CATID,NUMBER_OF_INSTALLMENT FROM PRICE_CAT WHERE PRICE_CATID ='+ row_price_cat_;
			var get_price_cat_month = wrk_safe_query('obj_get_price_cat_month',"dsn3",0,row_price_cat_);
			if(get_price_cat_month.recordcount) 
				price_list_inst_number = get_price_cat_month.NUMBER_OF_INSTALLMENT;
		}

		if(new_installment_number_ == price_list_inst_number)
			var new_price_ =row_list_price_;
		else
		{ //dövizli fiyat hesaplaması eksik, tamamlanacak...
			var paper_date = js_date( eval('form_basket.'+form_basket.search_process_date.value+'.value').toString() );
			var listParam = new_installment_number_ + "*" + row_product_id_ + "*" + paper_date ;
			var get_new_pricecat_ = wrk_safe_query("obj_get_new_pricecat","dsn3",0,listParam);
			if(get_new_pricecat_.recordcount != undefined && get_new_pricecat_.recordcount != 0)
			{
				setFieldValue('price', from_row, wrk_round(get_new_pricecat_.PRICE,price_round_number),3);
				//setFieldValue('price_cat', from_row,get_new_pricecat_.PRICE_CATID,0); yeni bulunan fiyat listesi id'si satıra set ediliyordu.
				hesapla('price',from_row+1);
			}
			else
			{
				if(new_installment_number_ != 0) 
				{
					var get_installment_rate_ = wrk_safe_query('obj_get_installment_rate', "dsn3",0,new_installment_number_);
				}
				else if(new_installment_number_ == 0 && price_list_inst_number != 0)
				{
					var get_installment_rate_ = wrk_safe_query('obj_get_installment_rate', "dsn3",0,price_list_inst_number);
				}
				//vade oranları alınıyor
				if(get_installment_rate_ != undefined && get_installment_rate_.recordcount != undefined && get_installment_rate_.recordcount != 0)
				{
					if(new_installment_number_ > price_list_inst_number) //taksit sayısı fiyat listesine gore artmıssa
					{
						if(form_basket.paymethod_vehicle.value == -1)
							var installment_rate_ =get_installment_rate_.CREDITCARD_RATE;
						else if(form_basket.paymethod_vehicle.value == 1) //Çek
							var installment_rate_ =get_installment_rate_.CHEQUE_RATE;
						else if(form_basket.paymethod_vehicle.value == 2) //Senet
							var installment_rate_ =get_installment_rate_.VOUCHER_RATE;
						else if(form_basket.paymethod_vehicle.value == 3) //Havale
							var installment_rate_ =get_installment_rate_.BANKPAYMENT_RATE;
					}
					else if(new_installment_number_ < price_list_inst_number) //taksit sayısı fiyat listesine gore azalmıssa
					{
						if(form_basket.paymethod_vehicle.value == -1)
							var installment_rate_ =get_installment_rate_.CREDITCARD_RATE_DISCOUNT;
						else if(form_basket.paymethod_vehicle.value == 1) //Çek
							var installment_rate_ =get_installment_rate_.CHEQUE_RATE_DISCOUNT;
						else if(form_basket.paymethod_vehicle.value == 2) //Senet
							var installment_rate_ =get_installment_rate_.VOUCHER_RATE_DISCOUNT;
						else if(form_basket.paymethod_vehicle.value == 3) //Havale
							var installment_rate_ =get_installment_rate_.BANKPAYMENT_RATE_DISCOUNT;
					}
					if(installment_rate_ != undefined && installment_rate_ != '' && price_list_inst_number != undefined && price_list_inst_number != '')
						var new_price_ = ((new_installment_number_-price_list_inst_number)*(installment_rate_/100)*row_list_price_) +row_list_price_;
				}
			}
		}	
		if(new_price_ != undefined && new_price_ != '')
		{
			setFieldValue('price', from_row, wrk_round(new_price_,price_round_number),3); //fiyat degistiriliyor
			hesapla('price',from_row+1); //satır yeniden hesaplanıyor
		}
		else
			toplam_hesapla(0);
	}
}
</cfif>
<cfif ListFindNoCase(display_list, "is_promotion")>
function control_row_prom(from_row)
{ 
/*satır promosyon bilgilerini kontrol edip, bedava urun miktarını edit eder.OZDEN20071018*/
	var row_prom_relation_id = '';
	var control_prom =0;
	if(rowCount > 1)
	{
		if(document.all.row_promotion_id[from_row].value !='' && document.all.is_promotion[from_row].value == 0) //satır bazlı promosyon varsa
		{
			var prom_stock_id = document.all.stock_id[from_row].value;
			var row_prom_id = document.all.row_promotion_id[from_row].value;
			row_prom_relation_id = document.all.prom_relation_id[from_row].value;
			var row_stock_amount =filterNumBasket(document.all.amount[from_row].value,amount_round);
			control_prom =1;
		}
	}
	else
	{
		if(document.all.row_promotion_id.value !='' && document.all.is_promotion.value == 0) //satır bazlı promosyon varsa
		{
			var prom_stock_id =document.all.stock_id.value;
			var row_prom_id =document.all.row_promotion_id.value;
			row_prom_relation_id = document.all.prom_relation_id.value;
			var row_stock_amount =filterNumBasket(document.all.amount.value,amount_round);
			control_prom =1;
		}
	}
	if(control_prom) //satır bazlı promosyon varsa
	{
		var free_prom_row=0;
		var prom_comp_id = form_basket.company_id.value;
		/*uyenin fiyat listesi varsa alınır yoksa standart satısa bakılır*/
		if(form_basket.basket_member_pricecat != undefined && form_basket.basket_member_pricecat.value!='')
			var member_price_cat = form_basket.basket_member_pricecat.value;
		else
			var member_price_cat = '-2';
		
		if(rowCount > 1) //tek satır varsa o promosyon satırı olamaz.
		{
		for(var counter_i=0; counter_i < rowCount; counter_i++) //promosyon urun satırı aranıyor
			if(document.all.is_promotion[counter_i].value ==1 && document.all.row_promotion_id[counter_i].value==row_prom_id && document.all.prom_relation_id[counter_i].value==row_prom_relation_id) //urunun promosyon satırı bulunuyor
				free_prom_row=counter_i;
		}
		if(form_basket.company_id.value.length)
		{
			var prom_date = js_date( eval('form_basket.'+form_basket.search_process_date.value+'.value').toString() );
			var listParam = row_stock_amount  + "*" + form_basket.company_id.value + "*" + member_price_cat + "*" + prom_stock_id + "*" + prom_date + "*" + row_prom_id;
			//var new_row_sql = 'SELECT FREE_STOCK_ID,PROM_ID,FREE_STOCK_PRICE,AMOUNT_1_MONEY,LIMIT_VALUE, AMOUNT_1, FREE_STOCK_AMOUNT FROM PROMOTIONS WHERE PROM_ID = '+row_prom_id+' AND PROM_STATUS = 1 AND PROM_TYPE = 1 AND LIMIT_TYPE =1 AND LIMIT_VALUE < = ' + row_stock_amount + ' AND (COMPANY_ID IS NULL OR COMPANY_ID = '+form_basket.company_id.value+') AND (PRICE_CATID =-2 OR PRICE_CATID IN ('+ member_price_cat +')) AND STOCK_ID = '+prom_stock_id +' AND '+prom_date+' BETWEEN STARTDATE AND FINISHDATE ORDER BY STARTDATE ASC, LIMIT_VALUE DESC';
			//form_basket.order_detail.value =new_row_sql;
			var get_row_proms = wrk_safe_query("obj_get_row_proms",'dsn3',"1",listParam);
		}
		else
		{
			var prom_date = js_date( eval('form_basket.'+form_basket.search_process_date.value+'.value').toString() );
			var listParam = row_stock_amount  + "*" + 0 + "*" + member_price_cat + "*" + prom_stock_id + "*" + prom_date + "*" + row_prom_id;
			//var new_row_sql = 'SELECT FREE_STOCK_ID,PROM_ID,FREE_STOCK_PRICE,AMOUNT_1_MONEY,LIMIT_VALUE, AMOUNT_1, FREE_STOCK_AMOUNT FROM PROMOTIONS WHERE PROM_ID = '+row_prom_id+' AND PROM_STATUS = 1 AND PROM_TYPE = 1 AND LIMIT_TYPE =1 AND LIMIT_VALUE < = ' + row_stock_amount + ' AND (COMPANY_ID IS NULL OR COMPANY_ID = '+form_basket.company_id.value+') AND (PRICE_CATID =-2 OR PRICE_CATID IN ('+ member_price_cat +')) AND STOCK_ID = '+prom_stock_id +' AND '+prom_date+' BETWEEN STARTDATE AND FINISHDATE ORDER BY STARTDATE ASC, LIMIT_VALUE DESC';
			//form_basket.order_detail.value =new_row_sql;
			var get_row_proms = wrk_safe_query("obj_get_row_proms",'dsn3',"1",listParam);
		}
		if(get_row_proms.recordcount)
		{ 
			var free_stock_multiplier = parseInt(row_stock_amount/get_row_proms.LIMIT_VALUE);
			
			if(get_row_proms.PROM_ID != row_prom_id) //yeni promosyon bulunmussa is_promotion=0 olan satırın promosyon bilgisi guncelleniyor
			{
				if(rowCount > 1)
					document.all.row_promotion_id[from_row].value = get_row_proms.PROM_ID;
				else
					document.all.row_promotion_id.value = get_row_proms.PROM_ID;
			}
			if(free_prom_row != 0 ) //bedava urun satırı var ve guncellenecek
				add_free_prom(get_row_proms.FREE_STOCK_ID,get_row_proms.PROM_ID,get_row_proms.FREE_STOCK_PRICE,get_row_proms.AMOUNT_1_MONEY,(free_stock_multiplier*get_row_proms.FREE_STOCK_AMOUNT),'',get_row_proms.AMOUNT_1,free_prom_row+1,1,row_prom_relation_id)
			else //bedava urun satırı yok, eklenecek
				add_free_prom(get_row_proms.FREE_STOCK_ID,get_row_proms.PROM_ID,get_row_proms.FREE_STOCK_PRICE,get_row_proms.AMOUNT_1_MONEY,(free_stock_multiplier*get_row_proms.FREE_STOCK_AMOUNT),'',get_row_proms.AMOUNT_1,0,0,row_prom_relation_id)
		}
		else if(free_prom_row != 0 ) //promosyon bulamadıgı zaman ilk satırı silmemesi icin
			del_row(free_prom_row+1); //bedava urun satırı siliniyor
	}	
}
</cfif>
<cfif ListFindNoCase(display_list, "is_parse")>
	assortmentArray = new Array(1);
	<cfoutput>
	<cfloop from="1" to="#ArrayLen(sepet.satir)#" index="ai">
		assortmentArray[#ai#] = new Array(1);
		<cfset temp_row = sepet.satir[ai]>
		<cfif isdefined("temp_row.assortment_array")>
		<cfloop from="1" to="#ArrayLen(sepet.satir[ai].assortment_array)#" index="aj">
			assortmentArray[#ai#][#aj#] = new Array(1);
			assortmentArray[#ai#][#aj#][1] = #sepet.satir[ai].assortment_array[aj].property_id#;  <!--- // Property 1 --->
			assortmentArray[#ai#][#aj#][2] = #sepet.satir[ai].assortment_array[aj].property_detail_id#;  <!--- // Property 2 --->
			assortmentArray[#ai#][#aj#][3] = #sepet.satir[ai].assortment_array[aj].property_amount#;  <!--- // Amount --->
		</cfloop>
		</cfif>
	</cfloop>
	</cfoutput>
</cfif>
<cfif ListFindNoCase(display_list, "spec")>
function open_spec(satir)
{
	var opener_basket_id = document.form_basket.basket_id.value;
	if(form_basket.stock_id.length != undefined)
	{
		var row_id=satir;
		var field_id = 'document.all.spect_id['+(satir-1)+']';
		var money_ = document.all.other_money_[satir-1].value;
		var stock_id = document.all.stock_id[satir-1].value;
		var price_catid_ = document.all.price_cat[satir-1].value;
		var price_ = document.all.price[satir-1].value;
		var main_stock_amount = filterNumBasket(document.all.amount[satir-1].value,4);
	}
	else
	{
		var row_id=0
		var field_id = 'document.all.spect_id';
		var money_ = document.all.other_money_.value;
		var stock_id = document.all.stock_id.value;
		var price_catid_ = document.all.price_cat.value;
		var price_ = document.all.price.value;
		var main_stock_amount = filterNumBasket(document.all.amount.value,4);
	}
	var aranan_tarih="";
	try{
		if(form_basket.search_process_date.value != "")
			aranan_tarih = eval("form_basket." + form_basket.search_process_date.value + ".value").toString();
	}
	catch(e)
	{}
	if(eval(field_id).value == "")
	{
		url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_spect_list&basket_id='+opener_basket_id;
		<!--- // process_type değişkeni --->
		sepet_process_obj = findObj("process_cat");
		if(sepet_process_obj != null)
			url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		else
			url_str = url_str + '&sepet_process_type=-1';
		<!--- // process_type değişkeni --->
		if(form_basket.company_id!=undefined)url_str=url_str+'&company_id='+form_basket.company_id.value;
		if(form_basket.consumer_id != undefined)url_str = url_str + '&consumer_id=' + form_basket.consumer_id.value;
		windowopen(url_str+'&row_id='+row_id+'&stock_id='+stock_id+'&money_='+money_+'&price='+filterNum(price_)+'&price_catid='+price_catid_+'<cfoutput query="get_money_bskt">&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4))+'</cfoutput>&search_process_date=' + aranan_tarih+'&main_stock_amount='+main_stock_amount,'wide');	
	}
	else
	{
		url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_upd_spect&basket_id='+opener_basket_id;
		//lokasyon ve department
		if(document.form_basket.location_id != undefined)
			var paper_location = document.form_basket.location_id.value;
		else
			var paper_location = '';
		
		if(document.form_basket.department_id != undefined)
			var paper_department = document.form_basket.department_id.value;
		else if(document.form_basket.DEPARTMENT_ID != undefined)//burda eger stok emirden sipars israsliyeye cekilirken duzenlerseniz kaldıralım
			var paper_department = document.form_basket.DEPARTMENT_ID.value;
		else
			var paper_department = '';
		<!--- // process_type değişkeni --->
		sepet_process_obj = findObj("process_cat");
		if(sepet_process_obj != null)
			url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		else
			url_str = url_str + '&sepet_process_type=-1';
		<!--- // process_type değişkeni --->
		if(form_basket.company_id!=undefined)url_str=url_str+'&company_id='+form_basket.company_id.value;
		if(form_basket.consumer_id != undefined)url_str = url_str + '&consumer_id=' + form_basket.consumer_id.value;
		windowopen(url_str+'&id='+eval(field_id).value+'&row_id='+row_id+'&money_='+money_+'&price='+filterNum(price_)+'&stock_id='+stock_id+'&price_catid='+price_catid_+'<cfoutput query="get_money_bskt">&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4))+'</cfoutput>&search_process_date=' + aranan_tarih+'&main_stock_amount='+main_stock_amount+'&paper_location='+paper_location+'&paper_department='+paper_department,'wide');
	}
}
</cfif>
<cfif ListFindNoCase(display_list, "is_parse")>
function open_assort(satir)
{
	url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_textile_assortment_js';
	if(form_basket.product_id.length != undefined)
		{
		stock_id = form_basket.stock_id[satir-1].value;
		product_id = form_basket.product_id[satir-1].value;
		product_name = form_basket.product_name[satir-1].value;
		amount = form_basket.amount[satir-1].value;
		}
	else
		{
		stock_id = form_basket.stock_id.value;
		product_id = form_basket.product_id.value;
		product_name = form_basket.product_name.value;
		amount = form_basket.amount.value;
		}
	windowopen(url_str+'&stock_id='+stock_id+'&product_id='+product_id+'&product_name='+product_name.replace("#","")+'&quantity='+amount+'&row_id='+(satir+1),'medium');
}
</cfif>
<cfif ListFindNoCase(display_list, "shelf_number") or ListFindNoCase(display_list, "shelf_number_2")>
function open_shelf_list(satir,satir_sayisi,list_type,field_id,field_name)
{
	url_str = '';
	shelf_dept_name = '';
	shelf_loc_name = '';
	if(field_id=='to_shelf_number') //depo sevk ve ambar fişindeki giriş depo,basketteki raf_no_2 alanıyla kontrol ediliyor
	{
		<cfif listfind('31,49',attributes.basket_id)> //depo_sevk ve ithal mal girşi
			shelf_dept_name = 'department_in_id';
			shelf_loc_name = 'location_in_id';
		<cfelseif listfind('12,13',attributes.basket_id)>
			sepet_process_obj = findObj("process_cat");
			if(sepet_process_obj != null)
				control_process_type=process_type_array[sepet_process_obj.selectedIndex];
			else
				control_process_type='-1';
			if(control_process_type!=undefined && list_find('113',control_process_type)) //sarf ve fire fisi icin cıkıs deposu
			{
				shelf_dept_name = 'department_in';
				shelf_loc_name = 'location_in';
			}
		</cfif>
	}
	else
	{
		<cfif listfind('4,6',attributes.basket_id)>
			shelf_dept_name = 'deliver_dept_id';
			shelf_loc_name = 'deliver_loc_id';
		<cfelseif listfind('14,15',attributes.basket_id)>
			shelf_dept_name = 'department_id';
			shelf_loc_name = 'location_id';
		<cfelseif listfind('12,13',attributes.basket_id)>
			sepet_process_obj = findObj("process_cat");
			if(sepet_process_obj != null)
				control_process_type=process_type_array[sepet_process_obj.selectedIndex];
			else
				control_process_type='-1';
			if(control_process_type!=undefined && list_find('111,112,113',control_process_type)) //sarf ve fire fisi icin cıkıs deposu
			{
				shelf_dept_name = 'department_out';
				shelf_loc_name = 'location_out';
			}
			else
			{
				shelf_dept_name = 'department_in';
				shelf_loc_name = 'location_in';
			}
		<cfelse>
			shelf_dept_name = 'department_id';
			shelf_loc_name = 'location_id';
		</cfif>
	}
	
	if(shelf_dept_name!='' && shelf_loc_name!='' && eval('form_basket.'+shelf_dept_name+'.value') != '' && eval('form_basket.'+shelf_loc_name+'.value') != '')
	{
		if(form_basket.stock_id.length != undefined)
		{
			var shelf_prod_id = document.all.product_id[satir-1].value;
			var shelf_stock_id = document.all.stock_id[satir-1].value;
			var shelf_stock_amount = filterNumBasket(document.all.amount[satir-1].value,4);
		}
		else
		{
			var shelf_prod_id = document.all.product_id.value;
			var shelf_stock_id = document.all.stock_id.value;
			var shelf_stock_amount = filterNumBasket(document.all.amount.value,4);
		}
		sepet_process_obj = findObj("process_cat");
		if(sepet_process_obj != null)
			control_process_type=process_type_array[sepet_process_obj.selectedIndex];
		else
			control_process_type='-1';
		kontrol_out = 0;
		if(list_find('111,112,113,81',control_process_type))kontrol_out = 1;
		if(list_type == 0) //basket satırında acılan raf listesi
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_shelves&kontrol_out='+kontrol_out+'&is_basket_kontrol=1&shelf_product_id='+shelf_prod_id+'&shelf_stock_id='+shelf_stock_id+'&form_name=form_basket&field_code='+field_name+'&field_id='+field_id+'&department_id='+eval('form_basket.'+shelf_dept_name+'.value')+'&location_id='+eval('form_basket.'+shelf_loc_name+'.value')+'&row_id='+satir+'&row_count='+satir_sayisi,'small','shelf_list_page');
		else if(list_type ==1) //stok raf dagılım listesi, satır cogaltarak raflara gore dagıtım yapıyor.
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stock_shelf_distribution&form_name=form_basket&prod_id='+shelf_prod_id+'&stock_id='+shelf_stock_id+'&prod_amount='+shelf_stock_amount+'&department_id='+eval('form_basket.'+shelf_dept_name+'.value')+'&location_id='+eval('form_basket.'+shelf_loc_name+'.value')+'&bskt_row_id='+satir+'&bskt_row_count='+satir_sayisi,'medium','shelf_list_page');
		}
	}
	else
		alert("<cf_get_lang_main no='311.Önce depo seçmelisiniz'>");
}
</cfif>
<cfif ListFindNoCase(display_list, "lot_no")>
	function open_lot_no_list(satir)
	{    
		if(form_basket.stock_id.length != undefined)
			{
				form_stock_code =document.all.stock_code[satir-1].value;
				product_id = document.all.product_id[satir-1].value;
				stock_id = document.all.stock_id[satir-1].value;
			}
			else
			{
				form_stock_code =document.all.stock_code.value;
				product_id = document.all.product_id.value;
				stock_id = document.all.stock_id.value;
			}
			sepet_process_obj = findObj("process_cat");
		var is_cost=<cfif ListFindNoCase(display_list, "net_maliyet")>1<cfelse>0</cfif>; 
		var is_price = <cfif ListFindNoCase(display_list, "price")>1<cfelse>0</cfif>;
		var is_price_other = <cfif ListFindNoCase(display_list, "price_other")>1<cfelse>0</cfif>;
		<cfif listfind("1,2,4,6,10,11,17,18,20,21",attributes.basket_id)>/*listfind("1,6,11,17,20",attributes.basket_id) and not sale_product*/
			var str_tlp_comp = "&branch_id=" + form_basket.branch_id.value;
		<cfelse>
			var str_tlp_comp="";
		</cfif>
		var aranan_tarih="";
		var department_str = ""
		var temp_project_id = ""
		url_str='<cfoutput>&int_basket_id=#attributes.basket_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput><cfif listgetat(attributes.fuseaction,2,'.') contains 'internaldemand'>&demand_type=0</cfif>&update_product_row_id='+satir+'<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle+'</cfif><cfoutput query="get_money_bskt">&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4))+'</cfoutput>&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other=" +is_price_other + "&is_cost=" + is_cost + str_tlp_comp + department_str + "&search_process_date=" + aranan_tarih+"&project_id="+temp_project_id;
		if(sepet_process_obj != null)
			url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
		else
			url_str = url_str + '&sepet_process_type=-1';
		url_str = url_str+ '&pid='+ product_id + '&sid='+stock_id+'&keyword=' + form_stock_code;
		url_str = url_str+ '&sort_type=1';
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str,'list');
	
	}
</cfif>
<cfif ListFindNoCase(display_list, "pbs_code")>
function open_pbs_list(satir,satir_sayisi,list_type,field_id,field_name)
{
	if(form_basket.stock_id.length != undefined)
	{
		var pbs_prod_id = document.all.product_id[satir-1].value;
		var pbs_stock_id = document.all.stock_id[satir-1].value;
	}
	else
	{
		var pbs_prod_id = document.all.product_id.value;
		var pbs_stock_id = document.all.stock_id.value;
	}
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pbs_code&is_single&row_id='+satir+'&form_name=form_basket&field_name='+field_name+'&field_id='+field_id+'&is_from_basket=1&row_count='+satir_sayisi,'list','pbs_list_page');
}
</cfif>
<cfif ListFindNoCase(display_list, "product_name")>
<cfif get_module_user(5)>
	function open_product_price_history(satir)
	{
		url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_std_sale&price_type=purc';
		if(document.all.product_id.length != undefined)	{
				product_id = document.all.product_id[satir-1].value;
		}
		else
		{
				product_id = document.all.product_id.value;
		}
		if(form_basket.company_id !=undefined)
			url_str=url_str + '&company_id=' + form_basket.company_id.value;
		
		if(form_basket.branch_id !=undefined)
			url_str=url_str + '&branch_id=' + form_basket.branch_id.value;
			
		if(product_id != "")
			windowopen(url_str + '&pid='+ product_id ,'project');
	}
</cfif>	
function open_product_popup(satir)
{
	url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product';
	if(document.all.product_id.length != undefined)	{
		product_id = document.all.product_id[satir-1].value;
		stock_id = document.all.stock_id[satir-1].value;
		if(document.all.spect_id[satir-1] != undefined && document.all.spect_id[satir-1].value!='' && document.all.spect_name[satir-1].value!='')
			url_str = url_str+'&spec_id='+document.all.spect_id[satir-1].value;
	}
	else
	{
		product_id = document.all.product_id.value;
		stock_id = document.all.stock_id.value;
		if(document.all.spect_id != undefined && document.all.spect_id.value!='' && document.all.spect_name.value!='')
			url_str = url_str+'&spec_id='+document.all.spect_id.value;
	}
	<cfif session.ep.isBranchAuthorization>
		url_str = url_str + '&is_store_module=1';
	</cfif>
	if(product_id != "")
		windowopen(url_str + '&pid='+ product_id + '&sid='+stock_id,'list');
}
function open_product_purchase_condition(satir)
{
	url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_contract';
	if(document.all.product_id.length != undefined)	{
			product_id = document.all.product_id[satir-1].value;
			stock_id = document.all.stock_id[satir-1].value;
	}
	else
	{
			product_id = document.all.product_id.value;
			stock_id = document.all.stock_id.value;
	}
	if(product_id != "")
	windowopen(url_str + '&pid='+ product_id,'list');	
}
</cfif>
<cfif ListFindNoCase(display_list, "basket_employee")>
	function open_basket_employee_popup(satir)
	{
		if(rowCount ==1)
			{
			var field_basket_emp_name_ = 'form_basket.basket_employee';
			var field_basket_emp_id_ ='form_basket.basket_employee_id';
			}
		else
			{
			var field_basket_emp_name_ = 'form_basket.basket_employee['+ satir + ']';
			var field_basket_emp_id_ = 'form_basket.basket_employee_id['+ satir + ']';
			}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1&field_emp_id='+field_basket_emp_id_+'&field_name='+field_basket_emp_name_,'list');
	}
	
</cfif>
<cfif ListFindNoCase(display_list, "basket_project")>
	function open_basket_project_popup(satir)
	{
		if(rowCount ==1)
		{
			var field_project_name_ = 'form_basket.row_project_name';
			var field_project_id_ ='form_basket.row_project_id';
		}
		else
		{
			var field_project_name_ = 'form_basket.row_project_name['+ satir + ']';
			var field_project_id_ = 'form_basket.row_project_id['+ satir + ']';
		}
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id='+field_project_id_+'&project_head='+field_project_name_);
	}
</cfif>
<cfif ListFindNoCase(display_list, "basket_work")>
	function open_basket_work_popup(satir)
	{
		var field_project_id_ = '';
		var field_project_name_ = '';
		if(rowCount ==1)
		{
			var field_work_name_ = 'form_basket.row_work_name';
			var field_work_id_ ='form_basket.row_work_id';
			<cfif ListFindNoCase(display_list, "basket_project")>
				var field_project_name_ = form_basket.row_project_name.value;
				var field_project_id_ =form_basket.row_project_id.value;
			</cfif>
		}
		else
		{
			var field_work_name_ = 'form_basket.row_work_name['+ satir + ']';
			var field_work_id_ = 'form_basket.row_work_id['+ satir + ']';
			<cfif ListFindNoCase(display_list, "basket_project")>
				var field_project_name_ = eval('form_basket.row_project_name['+ satir + ']').value;
				var field_project_id_ = eval('form_basket.row_project_id['+ satir + ']').value;
			</cfif>
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id='+field_work_id_+'&field_name='+field_work_name_+'&project_id='+field_project_id_+'&project_head='+field_project_name_,'list');
	}
</cfif>
//masraf merkezi (alis faturasi)
<cfif ListFindNoCase(display_list, "basket_exp_center")>
	function open_basket_exp_center_popup(satir)
	{
		if(rowCount ==1)
		{
			var field_exp_center_name_ = 'form_basket.row_exp_center_name';
			var field_exp_center_id_ ='form_basket.row_exp_center_id';
		}
		else
		{
			var field_exp_center_name_ = 'form_basket.row_exp_center_name['+ satir + ']';
			var field_exp_center_id_ = 'form_basket.row_exp_center_id['+ satir + ']';
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id='+field_exp_center_id_+'&field_name='+field_exp_center_name_,'list');
	}
</cfif>
//butce kalemi (alis faturasi)
<cfif ListFindNoCase(display_list, "basket_exp_item")>
	function open_basket_exp_item_popup(satir)
	{
		if(rowCount ==1)
		{
			var field_exp_item_name_ = 'form_basket.row_exp_item_name';
			var field_exp_item_id_ ='form_basket.row_exp_item_id';
			<cfif ListFindNoCase(display_list, "basket_acc_code")>
				var field_acc_code_ = 'form_basket.row_acc_code';
			</cfif>
		}
		else
		{
			var field_exp_item_name_ = 'form_basket.row_exp_item_name['+ satir + ']';
			var field_exp_item_id_ = 'form_basket.row_exp_item_id['+ satir + ']';
			<cfif ListFindNoCase(display_list, "basket_acc_code")>
				var field_acc_code_ = 'form_basket.row_acc_code['+ satir + ']';
			</cfif>
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id='+field_exp_item_id_+'&field_name='+field_exp_item_name_+'&field_account_no='+field_acc_code_,'list');
	}
</cfif>
//muhasebe kodu (alis faturasi)
<cfif ListFindNoCase(display_list, "basket_exp_item")>
	function open_basket_acc_code_popup(satir)
	{
		if(rowCount ==1)
			var field_acc_code_ = 'form_basket.row_acc_code';
		else
			var field_acc_code_ = 'form_basket.row_acc_code['+ satir + ']';
			
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id='+field_acc_code_,'list');
	}
</cfif>

<cfif ListFindNoCase(display_list, "price")>
function open_price(satir)
{
	url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_price_history_js';
	if(document.all.product_id.length != undefined)
		{
		product_id = document.all.product_id[satir-1].value;
		stock_id = document.all.stock_id[satir-1].value;
		product_name = '';
		unit_ = document.all.unit[satir-1].value;
		}
	else
		{
		product_id = document.all.product_id.value;
		stock_id = document.all.stock_id.value;
		product_name = '';
		unit_ = document.all.unit.value;
		}
	<!--- // process_type değişkeni --->
	sepet_process_obj = findObj("process_cat");
	if(sepet_process_obj != null)
		url_str = url_str + '&sepet_process_type='+process_type_array[sepet_process_obj.selectedIndex];
	else
		url_str = url_str + '&sepet_process_type=-1';
	<!--- // process_type değişkeni --->
	url_str = url_str + '&product_id=' + product_id + '&stock_id=' + stock_id + '&pid=' + product_id + '&product_name=' + product_name + '&unit=' + unit_ + '&row_id=' + satir;
	if(form_basket.company_id != undefined)
		url_str = url_str + '&company_id=' + form_basket.company_id.value;
	if(form_basket.consumer_id != undefined)
		url_str = url_str + '&consumer_id=' + form_basket.consumer_id.value;
	<cfif session.ep.isBranchAuthorization>
		url_str = url_str + '&is_store_module=1';
	</cfif>
	<cfloop query="get_money_bskt">
		url_str = url_str + '&<cfoutput>#money_type#=#rate2/rate1#</cfoutput>';
	</cfloop>
	if(product_id != "")
		windowopen(url_str,'medium');
}
</cfif>

function formatFieldValue(alan, sira, function_no,round_value_) <!--- // verilen alanı istenen formatda formatlar --->
{	
	var f_value = eval('document.all.' + alan);
	if(f_value.length != undefined) f_value = eval('document.all.' + alan + '[' + sira + ']');
	if(function_no == 1){
		if(round_value_!= undefined && round_value_ != '')
			f_value.value = filterNumBasket(f_value.value,round_value_);
		else
			f_value.value = filterNumBasket(f_value.value,price_round_number);
		}
	else if(function_no == 2) f_value.value = f2(f_value.value);
	else if(function_no == 3){
		if(!isNaN(round_value_))
			f_value.value = commaSplit(f_value.value,round_value_);
		else
			f_value.value = commaSplit(f_value.value,price_round_number);
	}
	return true;
}

function setFieldValue(alan, sira, deger, function_no) <!--- // verilen degeri istenen alana istenen formatda yazar --->
{
	var f_value = eval('document.all.' + alan);
	if(f_value.length != undefined) f_value = eval('document.all.' + alan + '[' + sira + ']');
	if(function_no == 0) f_value.value = deger;
	else if(function_no == 1) f_value.value = filterNumBasket(deger);
	else if(function_no == 2) f_value.value = f2(deger);
	else if(function_no == 3)
		if(list_find('amount,dara,darali',alan))
			f_value.value = commaSplit(deger,amount_round);
		else if(list_find('tax,otv_oran,number_of_installment,duedate',alan))
			f_value.value = commaSplit(deger,0);
		else if(alan.indexOf('indirim')==0 || list_find('promosyon_yuzde,marj,extra_cost_rate,ek_tutar_marj',alan))/*indirim yerine kullaniyoruz*/
		{
			f_value.value = commaSplit(deger,2);
		}
		else
			f_value.value = commaSplit(deger,price_round_number);
	return true;
}

function getFieldValue(alan, sira, function_no) <!--- // verilen alan içeriğini istenen formatda döndürür --->
{
	var f_value = eval('document.all.' + alan);
<!---	alert(sira);--->
	if(f_value.length != undefined)
		f_value = eval('document.all.' + alan + '[' + sira + '].value');
	else
		f_value = eval('document.all.' + alan + '.value');

	if(function_no == 1)
		{
		if(list_find('amount,dara,darali',alan)) return filterNumBasket(f_value,amount_round);
		else if(list_find('tax,otv_oran,number_of_installment,duedate',alan)) return filterNumBasket(f_value,0);
		else if(alan.indexOf('indirim')==0 || list_find('promosyon_yuzde,marj,extra_cost_rate,ek_tutar_marj',alan)) return filterNumBasket(f_value,2);
		else return filterNumBasket(f_value,price_round_number);
		}
	else return f_value;
}
function get_basket_date(field_name,field_row_)
{
	if(rowCount ==1)
		var basket_date_field_ = 'document.all.'+field_name;
	else
		var basket_date_field_ = 'document.all.'+field_name +'['+ field_row_ + ']';
	
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan='+basket_date_field_,'date');
}

function getSelectedIndex(alan, sira)
{
	if(document.all.product_id.length != undefined && sira != undefined) return eval('document.all.' + alan + '[' + sira + '].selectedIndex');
	else return eval('document.all.' + alan + '.selectedIndex');
}

function setSelectedIndex(alan, sira, deger)
{
	if(document.all.product_id.length != undefined) f_value = eval('document.all.' + alan + '[' + sira + ']');
	else f_value = eval('document.all.' + alan);
	f_value.selectedIndex = deger;
	return true;
}

function getIndexValue(alan, sira, deger)
{
	if(document.all.product_id.length != undefined) 
		return eval('document.all.' + alan + '[' + sira + '].options[' + deger + '].text');
	else  
		return eval('document.all.' + alan + '.options[' + deger + '].text');
}
<cfif isdefined('attributes.is_retail') or ListFindNoCase(display_list, "basket_cursor")> 
//perakende ve barkoddan urun ekle secilmisse gelir. cari, islem tipi, odeme yontemine gore secilebilecek fiyat listelerini add_bsket_row_from_barkod.cfm dosyasına ekler
function set_price_catid_options()
{
	add_prod_no = 0;
	var frameler = window.frames;
	for (var fm = 0; fm < frameler.length; fm++)
	{   
		if(frameler[fm].name == '_add_prod_')
			 add_prod_no = fm;
	}
	<cfif session.ep.isBranchAuthorization>var is_store_module=1; <cfelse>	var is_store_module=0;</cfif>
	if(document.form_basket.sale_product.value!='') is_sale_product=document.form_basket.sale_product.value; else is_sale_product=0;
	var sepet_process_obj = findObj("process_cat");
	if(sepet_process_obj != null) selected_process_type = process_type_array[sepet_process_obj.selectedIndex]; else	selected_process_type = -1;

	if(list_find('1,2,4,6,18,20,33,51',document.form_basket.basket_id.value))
	{
		if(document.form_basket.card_paymethod_id != undefined) var temp_card_paymethod =document.form_basket.card_paymethod_id.value; else var temp_card_paymethod = '';
		if(document.form_basket.paymethod_vehicle != undefined)
			var temp_paymethod_vehicle =document.form_basket.paymethod_vehicle.value;
		if(document.form_basket.paymethod_id != undefined && document.form_basket.paymethod_id.value!='' )
		{
			var get_pymthd_vehicle_ = wrk_safe_query('obj_get_pymthd_vehicle',"dsn",0, document.form_basket.paymethod_id.value);
			if(get_pymthd_vehicle_.recordcount!=0 && get_pymthd_vehicle_.PAYMENT_VEHICLE != '')
				var temp_paymethod_vehicle=get_pymthd_vehicle_.PAYMENT_VEHICLE;
			else
				var temp_paymethod_vehicle='';
		}
		else 
			var temp_paymethod_vehicle = '';
	}
	else { var temp_card_paymethod = '';temp_paymethod_vehicle = '';}
		
	if(is_sale_product == 1) //satıs 
	{
		<cfif not isdefined('attributes.is_retail')> //perakende fat. degilse
		{
			if(document.form_basket.company_id != undefined && document.form_basket.company_id.value != '')
			{
				var get_credit_limit = wrk_safe_query('obj_get_credit_limit',"dsn",0,document.form_basket.company_id.value);
		
				var get_comp_cat = wrk_safe_query('obj_get_comp_cat',"dsn",0,document.form_basket.company_id.value);
	
				var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE ";

				if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_sales.value == 1) //sadece risk tanımında gecerli fiyat listesi gelsin
				{
					if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
						str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID ='+document.form_basket.company_id.value+' AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 1) ) ';
					else
						str_price_cat_ = str_price_cat_+' 1=2 ';
					str_price_cat_ = str_price_cat_	+' ORDER BY PRICE_CAT';
				}
				else
				{
					if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
						str_price_cat_ = str_price_cat_+'  (PRICE_CAT_STATUS = 1 AND IS_SALES = 1 AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID ='+document.form_basket.company_id.value+' AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 1) ) OR ';
					str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
					if(window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value != 13)
						str_price_cat_ = str_price_cat_+' AND COMPANY_CAT LIKE \'%,' +get_comp_cat.COMPANYCAT_ID +',%\'';
					else 
					{
						if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
							str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
						else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
							str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
						if(is_store_module != undefined && is_store_module==1)
							str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		
					}
					str_price_cat_ = str_price_cat_	+') ORDER BY PRICE_CAT';
				}
				var get_price_cat = wrk_query(str_price_cat_,"dsn3");
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != 0)
					var selected_price_catid = get_credit_limit.PRICE_CAT;
				else if(get_price_cat.recordcount != 0)
					var selected_price_catid=get_price_cat.PRICE_CATID;
			}
			else if(document.form_basket.consumer_id != undefined && document.form_basket.consumer_id.value != '')
			{
				var get_credit_limit = wrk_safe_query('obj_get_credit_limit_2',"dsn",0,document.form_basket.consumer_id.value);
				
				var get_comp_cat = wrk_safe_query('obj_get_comp_cat_2',"dsn",0,document.form_basket.consumer_id.value);
				
				var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE";
				if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_sales.value == 1)
				{
					if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
						var str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND PRICE_CATID = ' +get_credit_limit.PRICE_CAT+ ')';
					else
						var str_price_cat_ = str_price_cat_+' 1=2 ';
					str_price_cat_ = str_price_cat_	+'ORDER BY PRICE_CAT';
				}
				else
				{
					if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
						var str_price_cat_ = str_price_cat_+' (PRICE_CAT_STATUS = 1 AND PRICE_CATID = ' +get_credit_limit.PRICE_CAT+ ') OR ';
					str_price_cat_ = str_price_cat_+'(PRICE_CAT_STATUS = 1 ';
					if(window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value != 13)
						str_price_cat_ = str_price_cat_+' AND CONSUMER_CAT LIKE \'%,' +get_comp_cat.CONSUMER_CAT_ID +',%\'';
					else 
					{
						if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
							str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
						else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
							str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
						if(is_store_module != undefined && is_store_module==1)
							str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		
					}
					str_price_cat_ = str_price_cat_	+' ) ORDER BY PRICE_CAT';
				}
				var get_price_cat = wrk_query(str_price_cat_,"dsn3");
				
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != 0)
					var selected_price_catid = get_credit_limit.PRICE_CAT;
				else if(get_price_cat.recordcount != 0)
				{
					if(is_sale_product == 1)
						var selected_price_catid=-2;
					else
						var selected_price_catid=-1;
				}
			}
			else if(document.form_basket.employee_id != undefined && document.form_basket.employee_id.value != '')
			{
				var str_price_cat_ = "SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_SALES = 1 ORDER BY PRICE_CAT";
				var get_price_cat = wrk_query(str_price_cat_,"dsn3");
				var selected_price_catid=get_price_cat.PRICE_CATID;
			}
		}
		<cfelse> //perakende faturası
		{
			var str_price_cat_ ='obj_get_price_cat_3'
			if(window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value != 13)
			{
				if(is_store_module != undefined && is_store_module==1)
					str_price_cat_ = 'obj_get_price_cat_4';		
			}
			var get_price_cat = wrk_safe_query(str_price_cat_,"dsn3");
			if(get_price_cat.recordcount != 0)
				var selected_price_catid='-2';
		}
		</cfif>
	}
	else //alıs tipli islemler
	{
			var str_price_cat_ ='SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND IS_PURCHASE = 1';
			if(document.form_basket.company_id != undefined && document.form_basket.company_id.value != '' && window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_purchase.value == 1)
			{
				var get_credit_limit = wrk_safe_query("obj_get_credit_limit","dsn",0,document.form_basket.company_id.value);
				if(get_credit_limit.recordcount != 0 && get_credit_limit.PRICE_CAT != '' )
				
					str_price_cat_ = str_price_cat_+' AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID ='+document.form_basket.company_id.value+' AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 0) ';
			}
			if(window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value != 13)
			{
				if(is_store_module != undefined && is_store_module==1 && selected_process_type != undefined && list_find('49,51,52,54,55,59,60,601,63,591',selected_process_type))
					str_price_cat_ = str_price_cat_+'AND BRANCH LIKE \'%,<cfoutput>#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#</cfoutput>,%\'';		
			}
			else
			{
				if(temp_card_paymethod != undefined && temp_card_paymethod != '') 
					str_price_cat_ = str_price_cat_+'AND PAYMETHOD = 4';
				else if(temp_paymethod_vehicle != undefined && temp_paymethod_vehicle != '') 
					str_price_cat_ = str_price_cat_+'AND PAYMETHOD ='+temp_paymethod_vehicle;
			}
			var get_price_cat = wrk_query(str_price_cat_,"dsn3");
			if(get_price_cat.recordcount != 0)
				var selected_price_catid='-1';
	}
	var price_cat_len = window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options.length;
	if(price_cat_len!='') //fiyat listesi selectboxının içerigi silinip yeniden oluşturuluyor
	{ 
	  for (var i = price_cat_len- 1; i>0; i--)
		  window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options.remove(i);
	}
	if(is_sale_product == 1)
	{
		if(window.frames[add_prod_no].document.add_speed_prod.dsp_only_member_price_cat_sales.value != 1 && list_find('2,13',window.frames[add_prod_no].document.add_speed_prod.basket_product_list_type.value)==0)
			window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option("<cf_get_lang dictionary_id='58721.Standart Satış'>",-2);
		else
			window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
	}
	else
		window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[0]=new Option("<cf_get_lang dictionary_id='58722.Standart Alış'>",-1);
	if(get_price_cat != undefined && get_price_cat.recordcount!=0)
	{
		for(var jj=0;jj<get_price_cat.recordcount;jj++)
		{
			window.frames[add_prod_no].document.add_speed_prod.price_catid_for_speed_.options[jj+1]=new Option(get_price_cat.PRICE_CAT[jj],get_price_cat.PRICE_CATID[jj],false,(get_price_cat.PRICE_CATID[jj]==selected_price_catid)? true : false); //new Option(text, value, defaultSelected, selected)
		}
	}
}
</cfif>
function add_seri_no(row_no)
{
	<cfoutput>
		if(form_basket.stock_id.length != undefined)
		{
			amount = filterNum(document.all.amount[row_no-1].value);
			product_id = document.all.product_id[row_no-1].value;
			stock_id = document.all.stock_id[row_no-1].value;
			wrk_row_id = document.all.wrk_row_id[row_no-1].value;
		}
		else
		{
			amount = filterNum(document.all.amount.value);
			product_id = document.all.product_id.value;
			stock_id = document.all.stock_id.value;
			wrk_row_id = document.all.wrk_row_id.value;
		}
		if(form_basket.is_delivered != undefined && form_basket.is_delivered.checked == true)
		is_delivered = 1;
		else
		is_delivered = 0;
		
		process_date = eval("form_basket." + form_basket.search_process_date.value + ".value").toString();
		var sepet_process_obj = findObj("process_cat");
		process_cat = process_type_array[sepet_process_obj.selectedIndex];
		var location_out_id_ = '';
		var department_out_id_ = '';
		if(process_cat == 811)
			{
				if(document.form_basket.location_in_id != undefined)
				{
					var location_id_ = document.form_basket.location_in_id.value;
					var department_id_ = document.form_basket.department_in_id.value;
				}
				else
				{
					var location_id_ = '';
					var department_id_ = '';
				}	
				if(document.form_basket.location_id != undefined)
				{
					if(document.form_basket.location_id.value == '')
					{
						alert('Çıkış Depo Seçmelisiniz!');
						return false;
					}
					else{
					var location_out_id_ = document.form_basket.location_id.value;
					var department_out_id_ = document.form_basket.department_id.value;}
				}
				else
				{
					var location_out_id_ = '';
					var department_out_id_ = '';
				}
			}
		else if (process_cat == 81)
			{
				if(document.form_basket.location_id != undefined)
				{
					var location_out_id_ = document.form_basket.location_id.value;
					var department_out_id_ = document.form_basket.department_id.value;
				}
				else
				{
					var location_out_id_ = '';
					var department_out_id_ = '';
				}
				if(document.form_basket.location_in_id != undefined)
				{
					var location_id_ = document.form_basket.location_in_id.value;
					var department_id_ = document.form_basket.department_in_id.value;
				}
				else
				{
					var location_id_ = '';
					var department_id_ = '';
				}
			}
		else if (process_cat == 111 || process_cat == 112 || process_cat == 113)
			{
				if(document.form_basket.location_out != undefined)
				{
					var location_out_id_ = document.form_basket.location_out.value;
					var department_out_id_ = document.form_basket.department_out.value;
				}
				else
				{
					var location_out_id_ = '';
					var department_out_id_ = '';
				}
				if(document.form_basket.location_in != undefined)
				{
					var location_id_ = document.form_basket.location_in.value;
					var department_id_ = document.form_basket.department_in.value;
				}
				else
				{
					var location_id_ = '';
					var department_id_ = '';
				}
			}
		else
			{
				if(document.form_basket.location_id != undefined)
				{
					var location_id_ = document.form_basket.location_id.value;
					var department_id_ = document.form_basket.department_id.value;
				}
				else
				{
					var location_id_ = '';
					var department_id_ = '';
				}
				if(document.form_basket.location_id != undefined)
				{
					var location_out_id_ = document.form_basket.location_id.value;
					var department_out_id_ = document.form_basket.department_id.value;
				}
				else
				{
					var location_out_id_ = '';
					var department_out_id_ = '';
				}
			}
		if(form_basket.company_id != undefined && form_basket.company_id.value != undefined)
			company_id_ = form_basket.company_id.value;
		else
			company_id_ = '';
		if(form_basket.consumer_id!= undefined && form_basket.consumer_id.value != undefined)
			consumer_id_ = form_basket.consumer_id.value;
		else
			consumer_id_ = '';
		<cfif attributes.basket_id eq 11>
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 12>
			paper_number_ = form_basket.fis_no_.value;
		<cfelseif attributes.basket_id eq 47>
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 48>
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 1><!--- Alis faturasi --->
			paper_number_ = form_basket.serial_no.value;
		<cfelseif attributes.basket_id eq 20><!--- Sube Alis faturasi --->
			paper_number_ = form_basket.serial_no.value;
		<cfelseif attributes.basket_id eq 2><!--- Satis faturasi --->
			paper_number_ = form_basket.serial_no.value;
		<cfelseif attributes.basket_id eq 18><!--- Sube Satis faturasi --->
			paper_number_ = form_basket.serial_no.value;
		<cfelseif attributes.basket_id eq 31><!--- Depolararasi Sevk Irsaliyesi --->
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 32><!--- Depolararasi Sevk Irsaliyesi Sube--->
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 47><!--- servis modulunden alis irsaliyesi --->
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 15><!--- Stok Emirlerden Alis Irsaliyesi --->
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 17><!--- Sube Alis Irsaliyesi --->
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 11><!--- Alis Irsaliyesi --->
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 49><!--- Ithal Mal Girisi --->
			paper_number_ = form_basket.ship_number.value;
		<cfelseif attributes.basket_id eq 10><!--- Satış İrsaliye --->
			paper_number_ = form_basket.ship_number.value;
		</cfif>
		windowopen('#request.self#?fuseaction=stock.list_serial_operations&event=det&popup_page=1&is_line=1&is_delivered='+is_delivered+'&process_number='+paper_number_+'&product_amount='+amount+'&product_id='+product_id+'&stock_id='+stock_id+'&process_date='+process_date+'&process_cat='+process_cat+'&process_id=0&wrk_row_id='+wrk_row_id+'&sale_product=0&company_id='+company_id_+'&con_id='+consumer_id_+'&location_out='+location_out_id_+'&department_out='+department_out_id_+'&location_in='+location_id_+'&department_in='+department_id_+'&is_serial_no=1&guaranty_cat=&guaranty_startdate=&spect_id=<cfif session.ep.isBranchAuthorization>&is_store=1</cfif>','list');
	</cfoutput>
}
function control_comp_selected(update_product_row_id)
{
	<cfif listfind("1,11,17,6,10,20,33",attributes.basket_id)>
		if(form_basket.branch_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!");
			return false;
		}
	</cfif>
	<cfif listfind("4,51",attributes.basket_id)>
		if(form_basket.x_required_dep.value == 1 && form_basket.deliver_dept_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!");
			return false;
		}
	</cfif>
	var is_cost=<cfif ListFindNoCase(display_list, "net_maliyet")>1<cfelse>0</cfif>; 
	var is_price = <cfif ListFindNoCase(display_list, "price")>1<cfelse>0</cfif>;
	var is_price_other = <cfif ListFindNoCase(display_list, "price_other")>1<cfelse>0</cfif>;
	<cfif listfind("1,2,4,6,10,11,17,18,20,21",attributes.basket_id)>/*listfind("1,6,11,17,20",attributes.basket_id) and not sale_product*/
		var str_tlp_comp = "&branch_id=" + form_basket.branch_id.value;
	<cfelse>
		var str_tlp_comp="";
	</cfif>
	var aranan_tarih="";
	try{
		if(form_basket.search_process_date.value != ""){
			aranan_tarih = eval("form_basket." + form_basket.search_process_date.value + ".value").toString();
		<cfif listfind("1,5,6,11,15,17,20,37",attributes.basket_id,",")>
			if(aranan_tarih == "")
			{
				alert("<cf_get_lang dictionary_id='57714.Satınalma İndirimleri için Tarih Bilgisini Ekleyiniz'>!");
				return false;
			}
		</cfif>		
		}
	}
	catch(e)
	{}
	<!--- // process_type değişkeni --->
	var sepet_process_obj = findObj("process_cat");
	if(sepet_process_obj != null)
		sepet_process_type = process_type_array[sepet_process_obj.selectedIndex];
	else
		sepet_process_type = -1;
	if (sepet_process_obj != null && sepet_process_type == -1)
		{
		alert("<cf_get_lang dictionary_id='57733.Önce İşlem Tipi Seçiniz'>!");
		return false;
		}
	<!--- // process_type değişkeni --->
	<cfif ListFindNoCase(display_list, "is_member_selected")> 
		if(sepet_process_type!=52 )<!--- 52:perakende satış faturası --->
		{
			if(form_basket.company_id!=undefined && form_basket.company_id.value.length==0 && form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length==0)
			{
				if(form_basket.partner_name!=undefined && form_basket.partner_name.value.length==0)//Yetkili kismi da bossa
				{
					alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
					return false;
				}
			}
		}
	</cfif>
	<!--- // proje bilgisi --->
	var temp_project_id='';
	if((sepet_process_type=='-1' || sepet_process_type!=52) && sepet_process_type != 115)<!--- 52:perakende satış faturası --->
	{
		if((document.form_basket.project_id!=undefined && document.form_basket.project_head!=undefined) || (document.form_basket.project_id_in!=undefined && document.form_basket.project_head_in!=undefined))
		{
			if (((document.form_basket.project_id.value.length==0 || document.form_basket.project_head.value.length==0) && document.form_basket.project_id_in ==undefined) || ((document.form_basket.project_id.value.length==0 || document.form_basket.project_head.value.length==0) && (document.form_basket.project_id_in!=undefined && (document.form_basket.project_id_in.value.length==0 || document.form_basket.project_head_in.value.length==0))))
			{
				<cfif ListFindNoCase(display_list, "is_project_selected")> 
					alert("<cf_get_lang dictionary_id='58848.Önce Proje Seçiniz'>!");
					return false;
				</cfif>
			}
			else
			{
				if(document.form_basket.project_id.value.length!=0)
					temp_project_id=form_basket.project_id.value;		
				else if(document.form_basket.project_id_in!=undefined && document.form_basket.project_id_in.value.length!=0)
					temp_project_id=form_basket.project_id_in.value;
			}
		}
	}
	<cfif attributes.basket_id eq 51>
		if(form_basket.paymethod_id != undefined && form_basket.paymethod_id.value == '' & form_basket.card_paymethod_id != undefined && form_basket.card_paymethod_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='58027.Ödeme Yöntemi Seçiniz!'>");
			return false;
		}
	</cfif>
	<!---// depo sevk irs ve ambar fislerinde cıkıs lokasyonuna gore urun miktarı kontrolu yapılacagı icin önce lokasyon secilmesi zorunlu --->
	var department_str = '';
	if(sepet_process_type == 81) <!---//81:depo sevk irs --->
	{
		if(form_basket.location_id != undefined && form_basket.location_id.value.length==0)
		{ 
			alert("<cf_get_lang dictionary_id='58782.Çıkış Lokasyonu Seçiniz'>");
			return false;
		}
		else
			department_str = '&department_out=' + form_basket.department_id.value + '&location_out=' + form_basket.location_id.value;
	}
	
	if(sepet_process_type == 76) <!---//76 alış irsaliyesi --->
	{
		if(form_basket.location_id != undefined && form_basket.location_id.value.length==0)
		{ 
			alert("<cf_get_lang dictionary_id='58782.Çıkış Lokasyonu Seçiniz'>");
			return false;
		}
		else
			department_str = '&department_out=' + form_basket.department_id.value + '&location_out=' + form_basket.location_id.value;
	}
	
	if(list_find('111,112,113',sepet_process_type)) <!---//111:sarf fisi, 112:fire fisi, 113:ambar fisi --->
	{
		if(form_basket.location_out != undefined && form_basket.location_out.value.length==0 )
		{ 
			alert("<cf_get_lang dictionary_id='58782.Çıkış Lokasyonu Seçiniz'>");
			return false;
		}
		else if(form_basket.location_out != undefined)
			department_str = '&department_out=' + form_basket.department_out.value + '&location_out=' + form_basket.location_out.value;
	}
	else if(list_find('115',sepet_process_type)) <!---//115:sayim fisi --->
	{
		if(form_basket.location_in != undefined && form_basket.location_in.value.length==0 )
		{ 
			alert("<cf_get_lang dictionary_id='30121.Giriş Lokasyonu Seçiniz'>");
			return false;
		}
		else if(form_basket.location_in != undefined)
			department_str = '&department_in=' + form_basket.department_in.value + '&location_in=' + form_basket.location_in.value;
	}
	<cfif listfind('2,10,18,21,48',attributes.basket_id)> <!---//satıs ve servis cıkıs irsaliyesi  --->
		if(form_basket.location_id != undefined && form_basket.location_id.value.length==0)
		{ 
			alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>");
			return false;
		}
		else
			department_str = '&department_out=' + form_basket.department_id.value + '&location_out=' + form_basket.location_id.value;
	</cfif>
	<cfif listfind('4,51',attributes.basket_id)> <!---//satıs siparişi  --->
		if(form_basket.deliver_dept_id != undefined && form_basket.deliver_dept_id.value.length!=0)
		{ 
			department_str = '&department_out=' + form_basket.deliver_dept_id.value + '&location_out=' + form_basket.deliver_loc_id.value;
		}
	</cfif>
	<cfif listfind('7',attributes.basket_id)> <!---//iç talep  --->
		if(form_basket.department_id != undefined && form_basket.department_id.value.length!=0)
		{ 
			department_str = '&department_out=' + form_basket.department_id.value + '&location_out=' + form_basket.location_id.value;
		}
	</cfif>
	<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>
		if(form_basket.paymethod_id != undefined) //perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
			temp_paymethod =form_basket.paymethod_id.value ;
		else
			temp_paymethod = '';
		if(form_basket.card_paymethod_id != undefined) //perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
			temp_card_paymethod =form_basket.card_paymethod_id.value ;
		else
			temp_card_paymethod = '';
		if(form_basket.paymethod_vehicle != undefined) //perakende ile satıs fat aynı basketi kullanıyor ama perakendede odeme yontemi yok, kontrol icin eklendi.
			temp_paymethod_vehicle =form_basket.paymethod_vehicle.value ;
		else
			temp_paymethod_vehicle = '';
	</cfif>
	if(update_product_row_id != '-1') //barkoddan urun ekleden cagrılmıyorsa popup acılmıyor
	{
		if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&int_basket_id=#attributes.basket_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput><cfif listgetat(attributes.fuseaction,2,'.') contains 'internaldemand'>&demand_type=0</cfif>&update_product_row_id='+update_product_row_id+'&sepet_process_type='+sepet_process_type+'<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle+'</cfif>&company_id='+form_basket.company_id.value+'<cfoutput query="get_money_bskt">&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4))+'</cfoutput>&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other="+is_price_other+"&is_cost=" +is_cost + str_tlp_comp + department_str+"&search_process_date="+aranan_tarih+"&project_id="+temp_project_id,'page_horizantal',basket_unique_code);
		else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&int_basket_id=#attributes.basket_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput><cfif listgetat(attributes.fuseaction,2,'.') contains 'internaldemand'>&demand_type=0</cfif>&update_product_row_id='+update_product_row_id+'&sepet_process_type='+sepet_process_type+'<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle+'</cfif>&consumer_id='+form_basket.consumer_id.value+'<cfoutput query="get_money_bskt">&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4))+'</cfoutput>&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other=" +is_price_other + "&is_cost=" + is_cost + str_tlp_comp + department_str + "&search_process_date="+aranan_tarih+"&project_id="+temp_project_id,'page_horizantal',basket_unique_code);
		else if(form_basket.employee_id!=undefined && form_basket.employee_id.value.length)
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&int_basket_id=#attributes.basket_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput><cfif listgetat(attributes.fuseaction,2,'.') contains 'internaldemand'>&demand_type=0</cfif>&update_product_row_id='+update_product_row_id+'&sepet_process_type='+sepet_process_type+'<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle+'</cfif>&employee_id='+form_basket.employee_id.value+'<cfoutput query="get_money_bskt">&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4))+'</cfoutput>&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other=" +is_price_other + "&is_cost=" + is_cost + str_tlp_comp + department_str + "&search_process_date="+aranan_tarih+"&project_id="+temp_project_id,'page_horizantal',basket_unique_code);
		else
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&int_basket_id=#attributes.basket_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput><cfif listgetat(attributes.fuseaction,2,'.') contains 'internaldemand'>&demand_type=0</cfif>&update_product_row_id='+update_product_row_id+'&sepet_process_type='+sepet_process_type+'<cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle+'</cfif><cfoutput query="get_money_bskt">&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4))+'</cfoutput>&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other=" +is_price_other + "&is_cost=" + is_cost + str_tlp_comp + department_str + "&search_process_date=" + aranan_tarih+"&project_id="+temp_project_id,'page_horizantal',basket_unique_code);
	}
	else
	{
		var url_info='';
		url_info='&int_basket_id='+<cfoutput>#attributes.basket_id#</cfoutput><cfif session.ep.isBranchAuthorization>+'&is_store_module=1'</cfif>+'&sepet_process_type='+sepet_process_type <cfif listfind("1,2,4,6,18,20,33,51",attributes.basket_id,",")>+'&paymethod_id='+temp_paymethod+'&card_paymethod_id='+temp_card_paymethod+'&paymethod_vehicle='+temp_paymethod_vehicle</cfif>;
		<cfoutput query="get_money_bskt">
		url_info=url_info+'&'+eval("form_basket.hidden_rd_money_"+#currentrow#+".value")+'='+(filterNumBasket(eval("form_basket.txt_rate2_"+#currentrow#+".value"),4)/filterNumBasket(eval("form_basket.txt_rate1_"+#currentrow#+".value"),4));
		</cfoutput>
		url_info=url_info+'&rowCount='+rowCount+'&is_sale_product='+sale_product+'&is_price='+is_price + "&is_price_other=" +is_price_other + "&is_cost=" + is_cost + str_tlp_comp + department_str + "&search_process_date=" + aranan_tarih + "&project_id=" +temp_project_id;
		if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
			url_info=url_info+'&company_id='+form_basket.company_id.value;
		else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
			url_info=url_info+'&consumer_id='+form_basket.consumer_id.value;
		else if(form_basket.employee_id!=undefined && form_basket.employee_id.value.length)
			url_info=url_info+'&employee_id='+form_basket.employee_id.value;
		window.frames[add_prod_no].document.add_speed_prod.url_info.value='';
		window.frames[add_prod_no].document.add_speed_prod.url_info.value=url_info;
		window.frames[add_prod_no].document.add_speed_prod.paper_process_type.value='';
		window.frames[add_prod_no].document.add_speed_prod.paper_process_type.value=sepet_process_type;
		return true;
		
	}
}

function kdvdahildenhesapla(satir,field_name)
{//row_lasttotal veya tax_price alanlarından fiyatı hesaplar. fieldname gonderilmisse kdvdahil fiyattan yoksa satır son toplamından fiyat hesaplanır
	new_price_kdv = -1;
	satir = satir - 1;
	if(rowCount == 1)
	{
		if(field_name == 'amount')
			field_changed_value = filterNumBasket(eval('document.all.'+field_name+'.value'),amount_round);
		else
			field_changed_value = filterNumBasket(eval('document.all.'+field_name+'.value'),price_round_number);
	}
	else
	{
		if(field_name == 'amount')
			field_changed_value = filterNumBasket(eval('document.all.'+field_name+'[satir].value'),amount_round);
		else
			field_changed_value = filterNumBasket(eval('document.all.'+field_name+'[satir].value'),price_round_number);
	}
	
	if(form_basket.control_field_value != undefined && field_changed_value == form_basket.control_field_value.value) //alanın eski ve yeni degeri aynı oldugundan hesaplamaya gerek yok.
	{
		return true;
	}
	else
	{
		var amount_ = parseFloat(getFieldValue('amount', satir,1));
		if(isNaN(amount_)) amount_ = 1;
		var promosyon_yuzde = parseFloat(getFieldValue('promosyon_yuzde', satir,1));
		if(isNaN(promosyon_yuzde)) promosyon_yuzde = 0;
		var iskonto_tutar = parseFloat(getFieldValue('iskonto_tutar', satir,1));
		if(isNaN(iskonto_tutar)) iskonto_tutar = 0;
		var ek_tutar = parseFloat(getFieldValue('ek_tutar', satir,1));
		if(isNaN(ek_tutar)) ek_tutar = 0;
		var rate1,rate2,other_money_index;
		if(rowCount == 1)
			other_money_index = getSelectedIndex('other_money_');
		else
			other_money_index = getSelectedIndex('other_money_',satir);
		rate1 = rate1Array[other_money_index];
		rate2 = rate2Array[other_money_index];
		if(rate1 == undefined && rate2 == undefined)
		{
			rate1 = 1;	
			rate2 = 1;
		}
		var tax_ = parseFloat(getFieldValue('tax', satir,1));
		var otv_oran_ = parseFloat(getFieldValue('otv_oran', satir,1));
		if(isNaN(otv_oran_)) otv_oran_ = 0;
		if(field_name!= undefined && field_name == 'tax_price') 
			var from_price = parseFloat(getFieldValue('tax_price', satir,1));
		else
			var from_price = parseFloat(getFieldValue('row_lasttotal', satir,1));
			
		var d1 = parseFloat(getFieldValue('indirim1', satir,1));
		var d2 = parseFloat(getFieldValue('indirim2', satir,1));
		var d3 = parseFloat(getFieldValue('indirim3', satir,1));
		var d4 = parseFloat(getFieldValue('indirim4', satir,1));
		var d5 = parseFloat(getFieldValue('indirim5', satir,1));
		var d6 = parseFloat(getFieldValue('indirim6', satir,1));
		var d7 = parseFloat(getFieldValue('indirim7', satir,1));
		var d8 = parseFloat(getFieldValue('indirim8', satir,1));
		var d9 = parseFloat(getFieldValue('indirim9', satir,1));
		var d10= parseFloat(getFieldValue('indirim10', satir,1));
		var indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
		if(amount_ != 0) /*silinen satırdaki row_lasttotala focus olundugunda sorun olmaması icin*/
		{
			<cfif ListFindNoCase(display_list, "otv_from_tax_price")>
				var new_price =  (from_price*100)/(100+tax_); //kdv matrahı dahil otv hesaplamasından geri gidiliyor
				if(field_name!= undefined && (field_name == 'tax_price'))
					var new_price = ((new_price*100*100000000000000000000)/(indirim_carpan*(100+otv_oran_)));
				else	
					var new_price = ((new_price*100*100000000000000000000)/(indirim_carpan*(100+otv_oran_)*amount_));
			<cfelse>
				if(field_name!= undefined && (field_name == 'tax_price'))
				{
					if(indirim_carpan == 100000000000000000000)
						{
						last_price_info = (from_price*100);
						last_disc_info= ((100+tax_+otv_oran_));
						new_price = wrk_round(last_price_info/last_disc_info,price_round_number);
						new_price_kdv = wrk_round(new_price * (tax_+otv_oran_) / 100,price_round_number);
						}
					else
						{
						last_price_info = (from_price*100*100000000000000000000);
						last_disc_info= (indirim_carpan*(100+tax_+otv_oran_));
						var new_price = (last_price_info/last_disc_info);
						}
				}
				else
					var new_price = (from_price*100*100000000000000000000)/(indirim_carpan*(100+tax_+otv_oran_)*amount_);
			</cfif>
		}
		else
			var new_price =0;
		new_price *= 100/(100-promosyon_yuzde);
		//new_price += iskonto_tutar*rate2/rate1;
		new_price += (iskonto_tutar*rate2/rate1);
		new_price -= (ek_tutar*rate2/rate1);
		setFieldValue('price',satir,new_price,3);
		if(new_price_kdv > 0)
			{
			new_price_kdv = new_price_kdv * amount_;
			if(field_name == 'tax_price')
				hesapla('tax_price',satir+1,1);
			else
				hesapla('price',satir+1,1,new_price_kdv);
			}
		else
			{
				if(field_name == 'tax_price')
					hesapla('tax_price',satir+1,1);
				else
					hesapla('price',satir+1,1);
			}
	}
}
function hesapla_amount(field_name,satir)
{
	<cfif ListFindNoCase(display_list, "is_use_add_unit")>
	if(rowCount > 1)
	{
		product_id_ = row_value['product_id'];		
		amount_ = filterNumBasket(row_value['amount'],amount_round);
		amount_other_ = filterNumBasket(row_value['amount_other'],price_round_number);
		unit_other_ = row_value['unit_other'];
		if(unit_other_ != '')
		{
			get_multiplier = wrk_query("SELECT ISNULL(MULTIPLIER,1) MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_STATUS = 1 AND PRODUCT_ID ="+product_id_+" AND ADD_UNIT = '" + unit_other_ + "'","dsn3");
			row_multiplier = get_multiplier.MULTIPLIER;
			if(field_name == 'amount' && row_multiplier!= undefined)
				row_value['amount_other'] = commaSplit(amount_/row_multiplier,price_round_number);
			else if(field_name == 'amount_other' && row_multiplier!= undefined)
				row_value['amount'] = commaSplit(amount_other_*row_multiplier,amount_round);
		}
	}
	else if(rowCount == 1)<!--- baskette tek satir varsa --->
	{
		product_id_ = document.all.product_id.value;
		amount_ = filterNumBasket(document.all.amount.value,amount_round);
		amount_other_ = filterNumBasket(document.all.amount_other.value,price_round_number);
		unit_other_ = document.all.unit_other.value;
		if(unit_other_ != '')
		{
			get_multiplier = wrk_query("SELECT ISNULL(MULTIPLIER,1) MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_STATUS = 1 AND PRODUCT_ID ="+product_id_+" AND ADD_UNIT = '" + unit_other_ + "'","dsn3");
			row_multiplier = get_multiplier.MULTIPLIER;
			if(field_name == 'amount' && row_multiplier!= undefined)
				document.all.amount_other.value = commaSplit(amount_/row_multiplier,price_round_number);
			else if(field_name == 'amount_other' && row_multiplier!= undefined)
				document.all.amount.value = commaSplit(amount_other_*row_multiplier,amount_round);
		}
	}
	</cfif>
}
var row_value = new Array(0);
var tr = document.getElementById('table_list').children[0].children;
var changeable_value = new Array();
load_all_row_values();
var d1=0, d2=0, d3=0, d4=0, d5=0, d6=0, d7=0, d8=0, d9=0, d10=0;
function hesapla(field_name,satir,toplam_hesap,satir_kdv_tutar)
{<!--- her satir icin islemler yapilacak --->
	ayir(satir);	//row_value ler alındı
	satir = satir-1;
	
	//gelen deger geri alma icin saklanir
	if(rowCount == 1)
		gelen_deger_ = eval('document.all.'+field_name+'.value');
	else
		gelen_deger_ = eval('document.all.'+field_name+'[satir].value');
	
	if(rowCount == 1)
	{
		if(field_name == 'amount')
			field_changed_value = filterNumBasket(eval('document.all.'+field_name+'.value'),amount_round);
		else
			field_changed_value = filterNumBasket(eval('document.all.'+field_name+'.value'),price_round_number);
	}
	else
	{
		if(field_name == 'amount')
			field_changed_value = filterNumBasket(eval('document.all.'+field_name+'[satir].value'),amount_round);
		else
			field_changed_value = filterNumBasket(eval('document.all.'+field_name+'[satir].value'),price_round_number);
	}
	
	if(field_name == 'amount' || field_name == 'amount_other')//Eğer miktar veya miktar 2 ise miktar hesapla fonksiyonu çalışacak
	{
		hesapla_amount(field_name,satir);
	}
	if(toplam_hesap!= 1 && form_basket.control_field_value != undefined && field_changed_value == form_basket.control_field_value.value) //alanın eski ve yeni degeri aynı oldugundan hesaplamaya gerek yok.
	{
		return true;
	}
	else
	{
	/* yunusun kismi */
	if(rowCount == 1)
		{
		var i_b_satir_row_total_ = document.all.row_total.value;
		var i_b_satir_row_nettotal_= document.all.row_nettotal.value;
		var i_b_satir_row_otvtotal_= document.all.row_otvtotal.value;
		var i_b_satir_row_taxtotal_= document.all.row_taxtotal.value;
		var i_b_satir_row_otv_ = document.all.otv_oran.value;
		var i_b_satir_row_tax_ = document.all.tax.value;
		var i_b_satir_is_commission = document.all.is_commission.value;
		}
	else
		{
		var i_b_satir_row_total_= row_value['row_total'];
		var i_b_satir_row_nettotal_= row_value['row_nettotal'];
		var i_b_satir_row_otvtotal_= row_value['row_otvtotal'];
		var i_b_satir_row_taxtotal_= row_value['row_taxtotal'];
		var i_b_satir_row_otv_ = row_value['otv_oran'];
		var i_b_satir_row_tax_ =row_value['tax'];
		var i_b_satir_is_commission = row_value['is_commission'];
		}
	
		if(toplam_hesap==undefined) toplam_hesap = 1;
		<!--- 20041208 toplam_hesap : toplu indirim gibi yerlerde sadece bir kez toplam_hesapla calistirilsin diye 
			toplam_hesap parametresi aliniyor default tanımsiz ve hesabi yapiyor,
			gonderilirse hesaplamak icin 1 hesaplamamak icin 0 bekleniyor --->
		var amount_ = 1; var price_ = 0;//altta mutlaka set edilecekler
		var tax_ = 0; var row_total_ = 0;
		var otv_oran_ = 0; var row_otvtotal_= 0; var ek_tutar=0;
		var row_taxtotal_ = 0; 
		var row_lasttotal_ = 0;
		var iskonto_tutar = 0;
		var promosyon_yuzde = 0;
		var indirim_carpan,price_other_,row_nettotal_,price_net_,price_net_doviz_,row_total_,price_other_;
		var other_money_tax_total,other_money_value_,other_money_gross_total_,ek_tutar_other_total_;
		var d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,indirim_carpan;
	
		var rate1,rate2,other_money_index;
		
		<!--- miktar - fiyat - satır toplamı değişimleri hesabı --->
		if(rowCount == 1)
			{
			for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
				if(moneyArray[mon_i]==document.all.other_money_.value)
				{
					rate1 = rate1Array[mon_i];
					rate2 = rate2Array[mon_i];
				}			
			if(field_name.indexOf('indirim')==0)
				{//indirim gelmisse filteNum dan gecirmeden d1,d2.. degerleri ile formatla
				d1 = filterNumBasket(document.all.indirim1.value);
				if( (d1 > 100) || (d1 < 0) )
					{
					alert("1. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim1', satir,0,0);
					return false;
					}
				d2 = filterNumBasket(document.all.indirim2.value);
				if( (d2 > 100) || (d2 < 0) )
					{
					alert("2. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim2', satir,0,0);
					return false;
					}
				d3 = filterNumBasket(document.all.indirim3.value);
				if( (d3 > 100) || (d3 < 0) )
					{
					alert("3. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim3', satir,0,0);
					return false;
					}
				d4 = filterNumBasket(document.all.indirim4.value);
				if( (d4 > 100) || (d4 < 0) )
					{
					alert("4. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim4', satir,0,0);
					return false;
					}
				d5 = filterNumBasket(document.all.indirim5.value);
				if( (d5 > 100) || (d5 < 0) )
					{
					alert("5. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim5', satir,0,0);
					return false;
					}
				d6 = filterNumBasket(document.all.indirim6.value);
				if( (d6 > 100) || (d6 < 0) )
					{
					alert("6. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim6', satir,0,0);
					return false;
					}
				d7 = filterNumBasket(document.all.indirim7.value);
				if( (d7 > 100) || (d7 < 0) )
					{
					alert("7. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim7', satir,0,0);
					return false;
					}
				d8 = filterNumBasket(document.all.indirim8.value);
				if( (d8 > 100) || (d8 < 0) )
					{
					alert("8. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim8', satir,0,0);
					return false;
					}
				d9 = filterNumBasket(document.all.indirim9.value);
				if( (d9 > 100) || (d9 < 0) )
					{
					alert("9. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim9', satir,0,0);
					return false;
					}
				d10= filterNumBasket(document.all.indirim10.value);
				if( (d10 > 100) || (d10 < 0) )
					{
					alert("10. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim10', satir,0,0);
					return false;
					}
				indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
				document.all.indirim_total.value = indirim_carpan;
				eval('document.all.'+field_name+'.value = commaSplit('+ eval('d'+field_name.replace('indirim','')) +')');
				}
			else
				indirim_carpan = document.all.indirim_total.value;
	
			if( filterNumBasket(document.all.amount.value,amount_round) < 0 )
				{
				alert("<cf_get_lang dictionary_id='57728.Miktar Değeri Hatalı'> ! (1)");
				setFieldValue('amount', satir,1,0);
				return false;
				}
			if( filterNumBasket(document.all.price.value,price_round_number) < 0 )
				{
				alert("<cf_get_lang dictionary_id='57729.Fiyat Değeri Hatalı'> ! (1)");
				setFieldValue('price', satir,0,0);
				return false;
				}
			amount_ = filterNumBasket(document.all.amount.value,amount_round);
			price_ = filterNumBasket(document.all.price.value,price_round_number);
			price_other_ = filterNumBasket(document.all.price_other.value,price_round_number);
			tax_ = filterNumBasket(document.all.tax.value);
			otv_oran_ = filterNumBasket(document.all.otv_oran.value);
			promosyon_yuzde = filterNumBasket(document.all.promosyon_yuzde.value);
			iskonto_tutar = wrk_round(filterNumBasket(document.all.iskonto_tutar.value,price_round_number)*rate2/rate1,price_round_number); <!--- //satirin para birimine gore sisteme cevirme --->
			if(field_name == 'ek_tutar' || field_name == 'amount')
			{
				ek_tutar = filterNumBasket(document.all.ek_tutar.value,price_round_number);
				ek_tutar_other_total_ = wrk_round((ek_tutar*amount_),price_round_number);  
				ek_tutar = wrk_round(ek_tutar*rate2/rate1,price_round_number); <!--- //satirin para birimine gore sisteme cevirme --->
			}
			else
			{
				ek_tutar = wrk_round((document.all.ek_tutar_total.value/amount_),price_round_number); <!--- //ek_tutar isleminin sırası degistirilmemeli--->
				ek_tutar_other_total_ = wrk_round((ek_tutar*(rate1/rate2)*amount_),price_round_number);  <!--- //ek_tutar_other_total_, satır ek tutar toplamını satırda secili olan doviz biriminden tutar.ek_tutar_total ise sistem para birimi cinsinden ek tutar satır toplamnı tutar --->
			}
			<!--- fiyat - satir toplami - doviz degisiklikleri --->
			if(field_name == 'row_total')<!--- // satır toplamı degismisse --->
				{ 
				row_total_ = filterNumBasket(document.all.row_total.value,price_round_number);
				if(amount_ !=0) <!--- //satırı sildikten sonra hesapla function calıstıgında degerlerin dagılmaması icin--->
					price_ = (row_total_ -(ek_tutar*amount_)) / amount_;
				else
					price_ =0;
				price_other_ = wrk_round(price_*rate1/rate2,price_round_number);
				
				}
			else if(field_name == 'price_other')
				{
				price_other_ = filterNumBasket(document.all.price_other.value,price_round_number);
				price_ = wrk_round( price_other_*rate2/rate1,price_round_number);
				}
			else if(field_name == 'other_money_value_')
				{
				other_money_value_ = filterNumBasket(document.all.other_money_value_.value,price_round_number);
				if(amount_ !=0)  <!--- //satırı sildikten sonra hesapla function calıstıgında degerlerin dagılmaması icin--->
					price_other_ = (other_money_value_/amount_)*100000000000000000000/indirim_carpan;
				else
					price_other_ = 0;
				price_other_ *= 100/(100-promosyon_yuzde);
				price_other_ += filterNumBasket(document.all.iskonto_tutar.value,price_round_number);
				price_other_ -= filterNumBasket(document.all.ek_tutar.value,price_round_number);
				price_ = wrk_round( price_other_*rate2/rate1 ,price_round_number);
				}
			else if(field_name == 'ek_tutar_other_total')
				{
				if(document.all.ek_tutar_other_total.value == '')
					ek_tutar_other_total_ = 0;
				else
					ek_tutar_other_total_ = filterNumBasket(document.all.ek_tutar_other_total.value,price_round_number);
				if(amount_ != 0) <!--- satır silindiginde miktar 0 set ediliyor. miktar sıfırken sorun cıkmaması icin kontrol ediliyor --->
					ek_tutar = wrk_round((ek_tutar_other_total_* (rate2/rate1))/amount_,price_round_number);
				else
					ek_tutar = 0;
				}
			else
				price_other_ = wrk_round( price_*rate1/rate2 ,price_round_number);
			
			if(iskonto_tutar>price_)
				iskonto_tutar = 0;
			row_total_ = wrk_round((price_+ek_tutar)* amount_,basket_total_round_number);
			document.all.amount.value = commaSplit(amount_,amount_round);
			document.all.price.value = commaSplit(price_,price_round_number);
			document.all.price_other.value = commaSplit(price_other_,price_round_number);
			document.all.iskonto_tutar.value = commaSplit(iskonto_tutar*rate1/rate2,price_round_number);<!--- yerel para birimine cevrilen prom tutar iskontosu satirda secili olan dovize donuyor --->
			document.all.ek_tutar_total.value = wrk_round((ek_tutar*amount_),price_round_number);<!--- yerel para birimine cevrilen ek tutar satır toplamını gosteriyor,hidden alanda tutuldugundan commaSplit ten gecirilmiyor, set etme sıralaması degistirilmemeli--->
			document.all.ek_tutar.value = commaSplit(ek_tutar*rate1/rate2,price_round_number);
			document.all.ek_tutar_other_total.value = commaSplit(ek_tutar_other_total_,price_round_number);
			document.all.promosyon_yuzde.value = commaSplit(promosyon_yuzde,2);
			document.all.row_total.value = commaSplit(row_total_,basket_total_round_number);
			price_ += ek_tutar;
			price_ -= iskonto_tutar;
			price_ -= price_*promosyon_yuzde/100;
			price_net_ = wrk_round( price_*indirim_carpan/100000000000000000000 ,price_round_number);
			document.all.price_net.value = commaSplit(price_net_,price_round_number);
			row_nettotal_ = wrk_round(price_net_*amount_,basket_total_round_number);
			document.all.row_nettotal.value = commaSplit(row_nettotal_,basket_total_round_number);
			
			if(field_name != 'row_otvtotal')
				row_otvtotal_ = wrk_round((row_nettotal_*otv_oran_) / 100,basket_total_round_number);
			else
				row_otvtotal_ = filterNumBasket(document.all.row_otvtotal.value,basket_total_round_number);
			
			
			if(field_name != 'row_taxtotal')
			{
				<cfif ListFindNoCase(display_list, "otv_from_tax_price")> //kdv matrahına otv toplam ekleniyor
					if(basket_total_round_number==2)
						{
						pre_tax_t=	wrk_round( ((row_nettotal_+row_otvtotal_)* tax_),basket_total_round_number);			
						row_taxtotal_ = wrk_round((pre_tax_t / 100),basket_total_round_number);
						}
					else
						{
						pre_tax_t=	wrk_round( ((row_nettotal_+row_otvtotal_)/100),basket_total_round_number);			
						row_taxtotal_ = wrk_round((pre_tax_t * tax_),basket_total_round_number);
						}
				<cfelse>
					if(satir_kdv_tutar!=undefined)
						row_taxtotal_ = satir_kdv_tutar;
					else
						{
						if(basket_total_round_number==2)
							{
							pre_tax_t =	wrk_round((row_nettotal_* tax_),basket_total_round_number);			
							row_taxtotal_ = wrk_round((pre_tax_t / 100),basket_total_round_number);
							}
						else
							{
							pre_tax_t=	wrk_round((row_nettotal_/ 100),basket_total_round_number);			
							row_taxtotal_ = wrk_round((pre_tax_t * tax_),basket_total_round_number);
							}
						}
				</cfif>
			}
			else
				row_taxtotal_ = filterNumBasket(document.all.row_taxtotal.value,basket_total_round_number);
			
			document.all.row_taxtotal.value = commaSplit(row_taxtotal_,basket_total_round_number);
			
			document.all.row_otvtotal.value = commaSplit(row_otvtotal_,basket_total_round_number);
			
			row_lasttotal_ = row_nettotal_+row_taxtotal_+row_otvtotal_;
			if(amount_ > 0 && field_name == 'tax_price')
				document.all.tax_price.value = commaSplit(filterNumBasket(document.all.tax_price.value),price_round_number);
			else if (amount_ > 0)
				document.all.tax_price.value = commaSplit((row_lasttotal_/amount_),price_round_number);
			else
				document.all.tax_price.value = commaSplit(0,price_round_number);
			document.all.row_lasttotal.value = commaSplit(row_lasttotal_,basket_total_round_number);
	
				price_net_doviz_ = price_net_ * rate1 / rate2;
				document.all.price_net_doviz.value = commaSplit(price_net_doviz_,price_round_number);
		
				other_money_value_ = wrk_round(amount_ * wrk_round(price_net_doviz_,price_round_number),price_round_number);
				//eski halinde yuvarlamayinca sorun cikti other_money_value_ = wrk_round(amount_ * price_net_doviz_,price_round_number);
				
				other_money_gross_value_ = row_lasttotal_ * rate1/rate2;
				if(row_taxtotal_ == 0 && row_otvtotal_ == 0)
					other_money_gross_value_ = other_money_value_;
				else	
					other_money_gross_value_ = row_lasttotal_ * rate1/rate2;
				document.all.other_money_value_.value = commaSplit(other_money_value_,price_round_number);
				document.all.other_money_gross_total.value = commaSplit(other_money_gross_value_,price_round_number);
			}
		else{
			for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
				if(moneyArray[mon_i]==row_value['other_money_'])
				{
					rate1 = rate1Array[mon_i];
					rate2 = rate2Array[mon_i];
				}	
			if(field_name.indexOf('indirim')==0)
				{//indirim gelmisse filteNum dan gecirmeden d1,d2.. degerleri ile formatla
				d1 = filterNumBasket(row_value['indirim1']);
				if( (d1 > 100) || (d1 < 0) )
					{
					alert("1. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim1', satir,0,0);
					return false;
					}
				d2 = filterNumBasket(row_value['indirim2']);
				if( (d2 > 100) || (d2 < 0) )
					{
					alert("2. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim2', satir,0,0);
					return false;
					}
				d3 = filterNumBasket(row_value['indirim3']);
				if( (d3 > 100) || (d3 < 0) )
					{
					alert("3. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim3', satir,0,0);
					return false;
					}
				d4 = filterNumBasket(row_value['indirim4']);
				if( (d4 > 100) || (d4 < 0) )
					{
					alert("4. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'>  ! ("+(satir+1)+")");
					setFieldValue('indirim4', satir,0,0);
					return false;
					}
				d5 = filterNumBasket(row_value['indirim5']);
				if( (d5 > 100) || (d5 < 0) )
					{
					alert("5. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'>  ! ("+(satir+1)+")");
					setFieldValue('indirim5', satir,0,0);
					return false;
					}
				d6 = filterNumBasket(row_value['indirim6']);
				if( (d6 > 100) || (d6 < 0) )
					{
					alert("6. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'>  ! ("+(satir+1)+")");
					setFieldValue('indirim6', satir,0,0);
					return false;
					}
				d7 = filterNumBasket(row_value['indirim7']);
				if( (d7 > 100) || (d7 < 0) )
					{
					alert("7. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim7', satir,0,0);
					return false;
					}
				d8 = filterNumBasket(row_value['indirim8']);
				if( (d8 > 100) || (d8 < 0) )
					{
					alert("8. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim8', satir,0,0);
					return false;
					}
				d9 = filterNumBasket(row_value['indirim9']);
				if( (d9 > 100) || (d9 < 0) )
					{
					alert("9. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim9', satir,0,0);
					return false;
					}
				d10= filterNumBasket(row_value['indirim10']);
				if( (d10 > 100) || (d10 < 0) )
					{
					alert("10. <cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'> ! ("+(satir+1)+")");
					setFieldValue('indirim10', satir,0,0);
					return false;
					}
				indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
				document.all.indirim_total[satir].value = indirim_carpan;
				row_value['indirim_total'] = indirim_carpan;
				eval('document.all.'+field_name+'['+satir+'].value = commaSplit('+ eval('d'+field_name.replace('indirim','')) +')');
				}
			else
				indirim_carpan = row_value['indirim_total'];
			
	
			if( filterNumBasket(row_value['amount'],amount_round) < 0 )
				{
				alert("<cf_get_lang dictionary_id='57728.Miktar Değeri Hatalı'> !("+(satir+1)+")");
				setFieldValue('amount', satir,1,0);
				return false;
				}
			if( filterNumBasket(row_value['price'],price_round_number) < 0 )
				{
				alert("<cf_get_lang dictionary_id='57729.Fiyat Değeri Hatalı'> !("+(satir+1)+")");
				setFieldValue('price', satir,0,0);
				return false;
				}
			amount_ = filterNumBasket(row_value['amount'],amount_round);
			price_ = filterNumBasket(row_value['price'],price_round_number);
			price_other_ = filterNumBasket(row_value['price_other'],price_round_number);
			tax_ = filterNumBasket(row_value['tax']);
			otv_oran_ = filterNumBasket(row_value['otv_oran']);
			promosyon_yuzde = filterNumBasket(row_value['promosyon_yuzde']);
			iskonto_tutar = wrk_round(filterNumBasket(row_value['iskonto_tutar'],price_round_number)*rate2/rate1,price_round_number);<!--- satirin para birimine gore sisteme cevirme --->
			if(field_name == 'ek_tutar' || field_name == 'amount')
			{
				ek_tutar = filterNumBasket(row_value['ek_tutar'],price_round_number);
				ek_tutar_other_total_ = wrk_round((ek_tutar*amount_),price_round_number);  <!--- //ek_tutar_other_total, satır ek tutar toplamını satırda secili olan doviz biriminden tutar.ek_tutar_total ise sistem para birimi cinsinden ek tutar satır toplamnı tutar --->
				ek_tutar = wrk_round(ek_tutar*rate2/rate1,price_round_number); <!--- //satirin para birimine gore sisteme cevirme --->
			}
			else
			{
				if(amount_ != '' && amount_ !=0)
					ek_tutar = wrk_round((row_value['ek_tutar_total']/amount_),price_round_number);  <!--- //ek_tutar isleminin sırası degistirilmemeli,satır ek tutar toplamı sistem para birimi cinsinden tutuluyor --->
				ek_tutar_other_total_ = wrk_round((ek_tutar*(rate1/rate2)*amount_),price_round_number); 
			}
			<!--- fiyat - satir toplami - doviz degisiklikleri --->
			if(field_name == 'row_total')<!--- // satır toplamı degismisse --->
				{
				row_total_ = filterNumBasket(row_value['row_total'],price_round_number);
				if(amount_ !=0)
					price_ = (row_total_ - (ek_tutar*amount_)) / amount_;
				else
					price_ = 0;
				
				price_other_ = wrk_round( price_*rate1/rate2 ,price_round_number);
				}
			else if(field_name == 'price_other')
				{
				price_other_ = filterNumBasket(row_value['price_other'],price_round_number);
				price_ = wrk_round( price_other_*rate2/rate1,price_round_number);
				}
			else if(field_name == 'other_money_value_')
				{
				other_money_value_ = filterNumBasket(row_value['other_money_value_'],price_round_number);
				if(amount_ !=0)
					price_other_ = (other_money_value_/amount_)*100000000000000000000/indirim_carpan;
				else
					price_other_ = 0;
				price_other_ *= 100/(100-promosyon_yuzde);
				price_other_ += filterNumBasket(row_value['iskonto_tutar'],price_round_number);
				price_other_ -= filterNumBasket(row_value['ek_tutar'],price_round_number);
				price_ = wrk_round( price_other_*rate2/rate1,price_round_number);
				}
			else if(field_name == 'ek_tutar_other_total')
				{
				if(document.all.ek_tutar_other_total[satir].value == '')
					ek_tutar_other_total_ = 0;
				else
					ek_tutar_other_total_ = filterNumBasket(row_value['ek_tutar_other_total'],price_round_number);
				if(amount_ != 0) <!--- satır silindiginde miktar 0 set ediliyor. miktar sıfırken sorun cıkmaması icin kontrol ediliyor --->
					ek_tutar = wrk_round((ek_tutar_other_total_* (rate2/rate1))/amount_,price_round_number);
				else
					ek_tutar = 0;
				}
			else
				price_other_ = wrk_round(price_*rate1/rate2 ,price_round_number);
	
			if(iskonto_tutar>price_)
				iskonto_tutar = 0;
			
			row_total_ = wrk_round((price_+ek_tutar)* amount_,basket_total_round_number);
			
			
			row_value['amount'] = commaSplit(amount_,amount_round);
			row_value['price'] = commaSplit(price_,price_round_number);
			row_value['price_other'] = commaSplit(price_other_,price_round_number);
			row_value['iskonto_tutar'] = commaSplit(iskonto_tutar*rate1/rate2,price_round_number);
			row_value['ek_tutar_total'] = wrk_round((ek_tutar*amount_),price_round_number);
			row_value['ek_tutar'] = commaSplit(ek_tutar*rate1/rate2,price_round_number);
			row_value['ek_tutar_other_total'] = commaSplit(ek_tutar_other_total_,price_round_number);
			row_value['promosyon_yuzde'] = commaSplit(promosyon_yuzde,2);
			row_value['row_total'] = commaSplit(row_total_,basket_total_round_number);
			
			<!--- // fiyat - satir toplami - doviz degisiklikleri --->
			
			<!--- netler kdv ler vs... --->
			price_ += ek_tutar;
			price_ -= iskonto_tutar;
			price_ -= price_*promosyon_yuzde/100;
			price_net_ = wrk_round( price_*indirim_carpan/100000000000000000000 ,price_round_number);
			row_value['price_net'] = commaSplit(price_net_,price_round_number);
			row_nettotal_ = wrk_round(price_net_*amount_ ,basket_total_round_number);
			
			
			row_value['row_nettotal'] = commaSplit(row_nettotal_,basket_total_round_number);
	
			if(field_name != 'row_otvtotal')
				row_otvtotal_ = wrk_round( (row_nettotal_*otv_oran_) / 100,basket_total_round_number);
			else
				row_otvtotal_ = filterNumBasket(row_value['row_otvtotal'],basket_total_round_number);
			
			if(field_name != 'row_taxtotal')
			{
				<cfif ListFindNoCase(display_list, "otv_from_tax_price")>//kdv matrahına otv eklenerek kdv hesaplanıyor
					if(basket_total_round_number==2)
						{
						pre_tax_t=	wrk_round( ((row_nettotal_+row_otvtotal_)* tax_),basket_total_round_number);			
						row_taxtotal_ = wrk_round((pre_tax_t / 100),basket_total_round_number);
						}
					else
						{
						pre_tax_t=	wrk_round( ((row_nettotal_+row_otvtotal_)/100),basket_total_round_number);			
						row_taxtotal_ = wrk_round((pre_tax_t * tax_),basket_total_round_number);
						}
				<cfelse>
					if(satir_kdv_tutar!=undefined)
						row_taxtotal_ = satir_kdv_tutar;
					else
						{
						if(basket_total_round_number==2)
							{
							pre_tax_t=	wrk_round((row_nettotal_* tax_),basket_total_round_number);			
							row_taxtotal_ = wrk_round((pre_tax_t / 100),basket_total_round_number);
							}
						else
							{
							pre_tax_t=	wrk_round( (row_nettotal_/100),basket_total_round_number);			
							row_taxtotal_ = wrk_round((pre_tax_t * tax_),basket_total_round_number);
							}
						}
				</cfif>
			}
			else
				row_taxtotal_ = filterNumBasket(row_value['row_taxtotal'],basket_total_round_number);
							
			row_value['row_taxtotal'] = commaSplit(row_taxtotal_,basket_total_round_number);
			row_value['row_otvtotal'] = commaSplit(row_otvtotal_,basket_total_round_number);
			row_lasttotal_ = row_nettotal_+row_taxtotal_+row_otvtotal_;
			if(amount_ > 0 && field_name == 'tax_price')
				row_value['tax_price'] = commaSplit(filterNumBasket(row_value['tax_price']),price_round_number);
			else if(amount_ > 0)
				row_value['tax_price'] = commaSplit((row_lasttotal_/amount_),price_round_number);
			else
				row_value['tax_price'] = commaSplit(0,price_round_number);
			row_value['row_lasttotal'] = commaSplit(row_lasttotal_,price_round_number);
	
			price_net_doviz_ = price_net_*rate1/rate2;
			row_value['price_net_doviz'] = commaSplit(price_net_doviz_,price_round_number);
	
			other_money_value_ = wrk_round(amount_*price_net_doviz_,price_round_number);
			row_value['other_money_value_'] = commaSplit(other_money_value_,price_round_number);
			row_value['other_money_gross_total'] = commaSplit(row_lasttotal_*rate1/rate2,price_round_number);
			<!--- // netler kdv ler vs... --->
			}
			<cfif ListFindNoCase(display_list, "is_promotion")>
				if(field_name == 'amount') /*promosyon seciliyse ve miktar edit edilmisse, promosyon satırı kontrol ediliyor*/
					control_row_prom(satir);
			</cfif>
		
		/* yunusun kismi */
		if(rowCount == 1)
			{
			var s_b_satir_row_total_ = document.all.row_total.value;
			var s_b_satir_row_nettotal_= document.all.row_nettotal.value;
			var s_b_satir_row_otvtotal_= document.all.row_otvtotal.value;
			var s_b_satir_row_taxtotal_= document.all.row_taxtotal.value;
			var s_b_satir_row_otv_ = document.all.otv_oran.value;
			var s_b_satir_row_tax_ = document.all.tax.value;
			var s_b_satir_is_commission = document.all.is_commission.value;
			}
		else
			{
			var s_b_satir_row_total_= row_value['row_total'];
			var s_b_satir_row_nettotal_= row_value['row_nettotal'];
			var s_b_satir_row_otvtotal_= row_value['row_otvtotal'];
			var s_b_satir_row_taxtotal_= row_value['row_taxtotal'];
			var s_b_satir_row_otv_ = row_value['otv_oran'];
			var s_b_satir_row_tax_ = row_value['tax'];
			var s_b_satir_is_commission = row_value['is_commission'];
			}
		
		mes_ = 'i_b_satir_row_tax_ : ' + i_b_satir_row_tax_ + ' s_b_satir_row_tax_ :' + s_b_satir_row_tax_;
		mes_ +=  '\ni_b_satir_row_taxtotal_ : ' + i_b_satir_row_taxtotal_ + ' s_b_satir_row_taxtotal_ :' + s_b_satir_row_taxtotal_;
		mes_ +=  '\ni_b_satir_row_total_ : ' + i_b_satir_row_total_ + ' s_b_satir_row_total_ :' + s_b_satir_row_total_;
		mes_ +=  '\ni_b_satir_row_nettotal_ : ' + i_b_satir_row_nettotal_ + ' s_b_satir_row_nettotal_ :' + s_b_satir_row_nettotal_;
		mes_ +=  '\ni_b_satir_row_otvtotal_ : ' + i_b_satir_row_otvtotal_ + ' s_b_satir_row_otvtotal_ :' + s_b_satir_row_otvtotal_;
		mes_ +=  '\ni_b_satir_row_otv_ : ' + i_b_satir_row_otv_ + ' s_b_satir_row_otv_ :' + s_b_satir_row_otv_;
		mes_ +=  '\ni_b_satir_is_commission : ' + i_b_satir_is_commission + ' s_b_satir_is_commission :' + s_b_satir_is_commission;

		if(rowCount == 1)
			{
			//islem yok
			}
		else
			ayir_ters(satir+1);//row_value geri inputlara aktarildi
			if(toplam_hesap)
				toplam_hesapla(0);
			
		return true;
	}
}
function zero_stock_control(dep_id,loc_id,is_update,process_type,stock_type,is_del_,is_purchase_,is_deliver_)
{
	var hata = '';
	var lotno_hata = '';
	var stock_id_list='0';
	var stock_amount_list='0';
	var spec_id_list='0';
	var spec_amount_list='0';
	var main_spec_id_list='0';
	var main_spec_amount_list='0';
	var tree_stock_id_list='';//spec secilmemeis uretilen urunlerin sb lerini almak icin ayrı bir listede tutum  ****** 0 stok id si ürün ağacından gereksiz kayıt döndürüyordu listeyi boşalttım PY
	var tree_stock_amount_list='0';
	var not_stock_id_list='0';//urun agacina uygun specti bulunmayan urunler listesi
	var popup_spec_type=1;
	if(isNaN(is_del_)) var is_del_=0; //alış islemlerinde silme yapılırken, is_del_ 1 olarak gonderilir
	if(isNaN(is_purchase_)) var is_purchase_=0; //alış islemlerinde günceleme yapılırken depo sevk ve ithal mal girişinde 1 gelir, is_purchase_ 1 olarak gonderilir
	if(isNaN(is_deliver_)) var is_deliver_=1; //depo sevk ve ithal mal girişinde teslim alma seçeneği bilgisi gönderilir. 0 ise belgedeki tutar dikkate alınmaz
	//eger baskete secilen popup specli ise stok kontrolleri specli yapılıyor
	<cfif isdefined('attributes.basket_id')>
		var att_bskt_id = <cfoutput>#attributes.basket_id#</cfoutput>;
	<cfelse>
		var att_bskt_id = 1;
	</cfif> 
	<cfif isdefined('attributes.basket_id')>
	var att_bskt_id = <cfoutput>#attributes.basket_id#</cfoutput>;
	<cfelse>
	var att_bskt_id = 1;
	</cfif> 
	var get_basket_rows_ = wrk_safe_query("obj_get_basket_rows",'dsn3',0,att_bskt_id);
	
	if(get_basket_rows_.recordcount && get_basket_rows_.IS_SELECTED == 1)
		paper_date_kontrol = js_date( eval('form_basket.'+document.all.search_process_date.value+'.value').toString() );
	else
		paper_date_kontrol = form_basket.today_date_.value;

	is_update = is_update.toString();	
	
	row_count = document.form_basket.product_id.length;
	try{
		<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
			if(check_lotno('form_basket') != undefined && check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
			{
				if(row_count != undefined)
				{
					for(i=0;i<row_count;i++)
					{
						varName = "lot_no_" + document.form_basket.stock_id[i].value + document.form_basket.lot_no[i].value.replace(/-/g, '_').replace(/\./g, '_');
						this[varName] = 0;
					} 
					for(i=0;i<row_count;i++)
					{
						if(document.form_basket.stock_id[i].value != '' )
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.form_basket.stock_id[i].value);
							if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise
							{
								varName = "lot_no_" + document.form_basket.stock_id[i].value + document.form_basket.lot_no[i].value.replace(/-/g, '_').replace(/\./g, '_');
								var xxx = String(this[varName]);
								var yyy = document.form_basket.amount[i].value;
								this[varName] = parseFloat( filterNum(xxx,price_round_number) ) + parseFloat( filterNum(yyy,price_round_number) );
							}
						}
					} 
					for(i=0;i<row_count;i++)
					{
						if(document.form_basket.stock_id[i].value != '' )
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.form_basket.stock_id[i].value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.form_basket.lot_no[i].value == '')
								{
									alert((i+1)+'. satırdaki '+ document.form_basket.product_name[i].value + ' ürünü için lot no takibi yapılmaktadır!');
									return false;
								}
							}
							if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
							{
								var stock_id_ = document.form_basket.stock_id[i].value;
								var lot_no_ = document.form_basket.lot_no[i].value;
								varName = "lot_no_" + document.form_basket.stock_id[i].value + document.form_basket.lot_no[i].value.replace(/-/g, '_').replace(/\./g, '_');
								/*var xxx = String(this[varName]);
								var yyy = document.form_basket.amount[i].value;
								this[varName] = parseFloat( filterNum(xxx,price_round_number) ) + parseFloat( filterNum(yyy,price_round_number) );*/
								if(dep_id==undefined || dep_id=='' || loc_id==undefined || loc_id=='')
								{
									if(stock_type==undefined || stock_type==0)
									{
										if(is_update != 0)
										{
											url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
										}
										else
										{
											url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
										}
									}
									else
									{
										url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_;
									}
								}
								else
								{
									if(stock_type==undefined || stock_type==0)
									{
										if(is_update != 0)
										{
											url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
										}
										else
										{
											url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
										}
									}
									else /* depoya gore kontrol yapılacaksa*/
									{
										url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_6&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
									}
								}
								$.ajax({
										
										url: url_,
										dataType: "text",
										cache:false,
										async: false,
										success: function(read_data) {
										data_ = jQuery.parseJSON(read_data);
										if(data_.DATA.length != 0)
										{
											$.each(data_.DATA,function(i){
												
												var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
												var STOCK_ID = data_.DATA[i][1];
												var STOCK_CODE = data_.DATA[i][2];
												var PRODUCT_NAME = data_.DATA[i][3];
												if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1) // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
												{// alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
													if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(PRODUCT_TOTAL_STOCK) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(PRODUCT_TOTAL_STOCK)+ parseFloat(eval(varName)))< 0) )
														lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
												}
												else
												{
													if(eval(varName) > PRODUCT_TOTAL_STOCK)
														lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
												}
											});
										}
										else if(list_find('113,81,811',process_type) && is_purchase_ == 0)
											lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										else if (!list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,113,81,811',process_type))
											lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
									}
								});
							}
						}
					}
				}
				else
				{
					if(document.form_basket.stock_id.value != '' )
					{
						get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.form_basket.stock_id.value);
						if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
						{
							if(document.form_basket.lot_no.value == '')
							{
								alert((1)+'. satırdaki '+ document.form_basket.product_name.value + ' ürünü için lot no takibi yapılmaktadır!');
								return false;
							}
						}
						if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
						{
							var stock_id_ = document.form_basket.stock_id.value;
							var lot_no_ = document.form_basket.lot_no.value;
							varName = "lot_no_" + stock_id_ + lot_no_.replace(/-/g, '_').replace(/\./g, '_');
							var yyy = document.form_basket.amount.value;
							this[varName] = parseFloat(filterNum(yyy,price_round_number) );
							//this[varName] = parseFloat(this[varName]) + parseFloat(document.form_basket.amount.value)
							if(dep_id==undefined || dep_id=='' || loc_id==undefined || loc_id=='')
							{
								if(stock_type==undefined || stock_type==0)
								{
									if(is_update != 0)
									{
										url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
									}
									else
									{
										url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
									}
								}
								else
								{
									url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_;
								}
							}
							else
							{
								if(stock_type==undefined || stock_type==0)
								{
									if(is_update != 0)
									{
										url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
									}
									else
									{
										url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
									}
								}
								else /*uretim rezerve ve stoklarda depoya gore kontrol yapılacaksa*/
								{
									url_= '/V16/objects/cfc/get_stock_detail.cfc?method=obj_get_total_lot_no_stock_6&lot_no='+ encodeURIComponent(lot_no_) +'&stock_id='+ stock_id_ +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
								}
							}
							$.ajax({
									url: url_,
									dataType: "text",
									cache:false,
									async: false,
									success: function(read_data) {
									// console.log(data_.DATA.length);return false;
									data_ = jQuery.parseJSON(read_data);
									if(data_.DATA.length != 0)
									{
										$.each(data_.DATA,function(i){
											var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
											var STOCK_ID = data_.DATA[i][1];
											var STOCK_CODE = data_.DATA[i][2];
											var PRODUCT_NAME = data_.DATA[i][3];
											if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1) // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
											{// alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
												if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(PRODUCT_TOTAL_STOCK) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(PRODUCT_TOTAL_STOCK)+ parseFloat(eval(varName)))< 0) )
													lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
											}
											else
											{
												if(eval(varName) > PRODUCT_TOTAL_STOCK)
													lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
											}
										});
									}
									else if(list_find('113,81,811',process_type) && is_purchase_ == 0)
										lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
									else if (!list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,113,81,811',process_type))
										lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
								}
							});
						}
					}
				}
			}
		</cfif>
	}
	catch(e)
	{}
	if(is_update.indexOf(';') >= 0)	is_update = list_getat(is_update,1,';');
	if( (is_update == 0 && (form_basket.irsaliye_id_listesi==undefined || ( form_basket.irsaliye_id_listesi!=undefined && form_basket.irsaliye_id_listesi.value == ''))) || (is_update!= 0 )) //faturaya irsaliye cekilerek baskete eklenmis urunler haricinde olanlar aliniyor
	{
		if(rowCount > 1)
		{
			for (var counter_=0; counter_ < rowCount; counter_++)
			{
				if(! list_find('4,6',att_bskt_id)|| document.all.order_currency[counter_].value != -3)//satır asaması kapalıysa stok kontrolu yapılmaz
				{
					if( (list_getat(document.all.row_ship_id[counter_].value,1,';') ==0 || document.all.row_ship_id[counter_].value =='') || list_find('70,71,72,73,74,75,76,77,78,79,80,81,83,85,87,88,811,114,761,115,110,113,111',process_type) )
					{
						if(document.all.is_inventory[counter_].value == 1)
						{
							if(document.all.spect_id[counter_]!= undefined && document.all.spect_id[counter_].value!='' && document.all.spect_id[counter_].value!=0) //satırda secilen spec varsa
							{
								var yer=list_find(spec_id_list,document.all.spect_id[counter_].value,',');//aynı olması kucuk bir ihtimal ama koyalım cunku spec idler farklidir ama main ler ayni olabilir
								if(yer)
								{
									top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNumBasket(document.all.amount[counter_].value,amount_round));
									spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
								}else{
									spec_id_list=spec_id_list+','+document.all.spect_id[counter_].value;
									spec_amount_list=spec_amount_list+','+filterNumBasket(document.all.amount[counter_].value,amount_round);
								}
							}
							//artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
							var yer=list_find(stock_id_list,document.all.stock_id[counter_].value,',');
							if(yer)
							{
								top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(document.all.amount[counter_].value,amount_round));
								stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
							}
							else
							{
								stock_id_list=stock_id_list+','+document.all.stock_id[counter_].value;
								stock_amount_list=stock_amount_list+','+filterNumBasket(document.all.amount[counter_].value,amount_round);
							}
							//specli stok bakılacak ise spec secilmeyen satırların main_specleri bulunuyor
							if(document.all.is_production[counter_].value == 1 && (document.all.spect_id[counter_]== undefined || document.all.spect_id[counter_].value==''))
							{
								var get_main_spec = wrk_safe_query("obj_get_main_spec_3",'dsn3',0,document.all.stock_id[counter_].value);
								if(get_main_spec.recordcount)
								{
									var spec_amount=filterNumBasket(document.all.amount[counter_].value,amount_round);
									var yer=list_find(main_spec_id_list,get_main_spec.SPECT_MAIN_ID,',');
									if(yer)
									{
										var top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(spec_amount);
										main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
									}
									else{
										main_spec_id_list=main_spec_id_list+','+get_main_spec.SPECT_MAIN_ID;
										main_spec_amount_list=main_spec_amount_list+','+spec_amount;
									}
								}else//urune ait main spec yoksa zaten stokta yoktur...
									not_stock_id_list=not_stock_id_list+','+document.all.stock_id[counter_].value;
								get_main_spec='';
							}
							if(document.all.is_production[counter_].value==1 && (document.all.spect_id[counter_]==undefined || document.all.spect_id[counter_].value==''))
							{
								var yer=list_find(tree_stock_id_list,document.all.stock_id[counter_].value,',');
								if(yer)
								{
									top_stock_miktar=parseFloat(list_getat(tree_stock_amount_list,yer,','))+parseFloat(filterNumBasket(document.all.amount[counter_].value,amount_round));
									tree_stock_amount_list=list_setat(tree_stock_amount_list,yer,top_stock_miktar,',');
								}
								else{
									tree_stock_id_list=tree_stock_id_list+','+document.all.stock_id[counter_].value;
									tree_stock_amount_list=tree_stock_amount_list+','+filterNumBasket(document.all.amount[counter_].value,amount_round);
								}
							}
						}
					}
				}
			}
		}
		else if(rowCount == 1) 
		{ 
			if(! list_find('4,6',att_bskt_id) || document.all.order_currency.value != -3)//satır asaması kapalıysa stok kontrolu yapılmaz
			{
				if( (list_getat(document.all.row_ship_id.value,1,';') == 0 || document.all.row_ship_id.value == '') || list_find('70,71,72,73,74,75,76,77,78,79,80,81,83,85,87,88,811,114,761,115,110,113,111',process_type))
				{
					if(document.all.is_inventory.value == 1)
					{
						if(document.all.spect_id!= undefined && document.all.spect_id.value!='') //satırda secilen spec varsa
						{
							var yer=list_find(spec_id_list,document.all.spect_id.value,',');
							if(yer)
							{
								top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNumBasket(document.all.amount.value,amount_round));
								spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
							}else{
								spec_id_list=spec_id_list+','+document.all.spect_id.value;
								spec_amount_list=spec_amount_list+','+filterNumBasket(document.all.amount.value,amount_round);
							}
						}
						var yer=list_find(stock_id_list,document.all.stock_id.value,',');
						if(yer)
						{
							top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(document.all.amount.value,amount_round));
							stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
						}
						else{
							stock_id_list=stock_id_list+','+document.all.stock_id.value;
							stock_amount_list=stock_amount_list+','+filterNumBasket(document.all.amount.value,amount_round);
						}
						if(popup_spec_type==1 && document.all.is_production.value == 1 && (document.all.spect_id== undefined || document.all.spect_id.value==''))
						{
							var get_main_spec = wrk_safe_query("obj_get_main_spec_3",'dsn3',0,document.all.stock_id.value);
							if(get_main_spec.recordcount)
							{
								var spec_amount=filterNumBasket(document.all.amount.value,amount_round);
								var yer=list_find(main_spec_id_list,get_main_spec.SPECT_MAIN_ID,',');
								if(yer)
								{
									var top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(spec_amount);
									main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
								}
								else{
									main_spec_id_list=main_spec_id_list+','+get_main_spec.SPECT_MAIN_ID;
									main_spec_amount_list=main_spec_amount_list+','+spec_amount;
								}
							}else//urune ait main spec yoksa zaten stokta yoktur...
								not_stock_id_list=not_stock_id_list+','+document.all.stock_id.value;
							get_main_spec='';
						}
						if(document.all.is_production.value==1 && (document.all.spect_id==undefined || document.all.spect_id.value==''))
						{
							var yer=list_find(tree_stock_id_list,document.all.stock_id.value,',');
							if(yer)
							{
								top_stock_miktar=parseFloat(list_getat(tree_stock_amount_list,yer,','))+parseFloat(filterNumBasket(document.all.amount.value,amount_round));
								tree_stock_amount_list=list_setat(tree_stock_amount_list,yer,top_stock_miktar,',');
							}
							else{
								tree_stock_id_list=tree_stock_id_list+','+document.all.stock_id.value;
								tree_stock_amount_list=tree_stock_amount_list+','+filterNumBasket(document.all.amount.value,amount_round);
							}
						}
					}
				}
			}
		}
		if(list_len(spec_id_list,',')>1) //satırda secilen spect in sevkte birlestir urunleri
		{
			if(!list_find('81,113', process_type))//depo sevk ve ambar fisinde spect bilesenlerine bakılmıyor
			{
				//spect satirladındaki sbler için	
				var get_spect_row = wrk_safe_query('obj_get_spect_row','dsn3',0,spec_id_list);
				if(get_spect_row.recordcount)
				{
					for (var counter_1=0; counter_1 < get_spect_row.recordcount; counter_1++)
					{
						var spect_carpan=list_getat(spec_amount_list,list_find(spec_id_list,get_spect_row.SPECT_ID[counter_1],','),',');
						var yer=list_find(stock_id_list,get_spect_row.STOCK_ID[counter_1],',');
						if(yer)
						{
							top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],amount_round)*spect_carpan);
							stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
						}
						else
						{
							stock_id_list=stock_id_list+','+get_spect_row.STOCK_ID[counter_1];
							stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],amount_round)*spect_carpan);
						}
					}
					get_spect_row='';
				}
			}
			if(popup_spec_type==1)//specli stok bakılacaksa 
			{
				//main spec idsini alıyor cunku bunlarında stokları varmı bakılacak
				var get_spect = wrk_safe_query('obj_get_spect','dsn3',0,spec_id_list);
				for (var counter=0; counter < get_spect.recordcount; counter++)
				{
					var yer_1=list_find(spec_id_list,get_spect.SPECT_VAR_ID[counter],',');
					var spec_amount=list_getat(spec_amount_list,yer_1,',');
					var yer=list_find(main_spec_id_list,get_spect.SPECT_MAIN_ID[counter],',');
					if(yer)
					{
						var top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(spec_amount);
						main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
					}
					else{
						main_spec_id_list=main_spec_id_list+','+get_spect.SPECT_MAIN_ID[counter];
						main_spec_amount_list=main_spec_amount_list+','+spec_amount;
					}
				}
				get_spect='';
			}
		}
		
		var stock_id_count=list_len(stock_id_list,',');
		//karma koli bilesenleri
		if(stock_id_count >1)
		{
			var karma_koli_main_spec_list='';
			var karmakoli_main_spec_amount_list='';
			var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list;
			var get_karma_koli = wrk_safe_query("obj_get_karma_koli",'dsn1',0,listParam);
			if(get_karma_koli.recordcount)
			{
				for (var counter_1=0; counter_1 < get_karma_koli.recordcount; counter_1++)
				{
					var stock_amount=list_getat(stock_amount_list,list_find(stock_id_list,get_karma_koli.KARMA_STOCK_ID[counter_1],','),',');
					if(popup_spec_type==1 && get_karma_koli.IS_PRODUCTION ==1 && get_karma_koli.SPEC_MAIN_ID!='' ) //satırda main spec secilmisse ve specli stok bakılacaksa 
					{
						karmakoli_main_spec_list=karma_koli_main_spec_list+','+get_karma_koli.SPEC_MAIN_ID[counter_1]; //karma koli spec
						karmakoli_main_spec_amount_list=karmakoli_main_spec_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount); //karma koli specli miktar
						
						var yer=list_find(main_spec_id_list,get_karma_koli.SPEC_MAIN_ID[counter_1],',');
						if(yer)
						{
							top_stock_miktar=parseFloat(list_getat(main_spec_amount_list,yer,','))+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
							main_spec_amount_list=list_setat(main_spec_amount_list,yer,top_stock_miktar,',');
						}
						else{
							main_spec_id_list=main_spec_id_list+','+get_karma_koli.SPEC_MAIN_ID[counter_1];
							main_spec_amount_list=main_spec_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
						}
					}
					var yer=list_find(stock_id_list,get_karma_koli.STOCK_ID[counter_1],',');
					if(yer)
					{
						top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
						stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					}
					else
					{
						stock_id_list=stock_id_list+','+get_karma_koli.STOCK_ID[counter_1];
						stock_amount_list=stock_amount_list+','+parseFloat(get_karma_koli.PRODUCT_AMOUNT[counter_1]*stock_amount);
					}
				}
				if( karma_koli_main_spec_list!='' && list_len(karma_koli_main_spec_list)>1) //karma koli icerigindeki specli urunlerin sb icerikleri alınıyor
				{
					if(!list_find('81,113', process_type))//depo sevk ve ambar fisinde spect bilesenlerine bakılmıyor
					{
						//spect satirlarındaki sevte birleştirilen urunler için	
						var get_spect_row = wrk_safe_query('obj_get_spect_row_2','dsn3',0,karma_koli_main_spec_list);
						if(get_spect_row.recordcount)
						{
							for (var counter_1=0; counter_1 < get_spect_row.recordcount; counter_1++)
							{
								var spect_carpan=list_getat(karmakoli_main_spec_amount_list,list_find(karma_koli_main_spec_list,get_spect_row.SPECT_ID[counter_1],','),',');
								var yer=list_find(stock_id_list,get_spect_row.STOCK_ID[counter_1],',');
								
								if(yer)
								{
									top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],amount_round)*spect_carpan);
									stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
								}
								else
								{
									stock_id_list=stock_id_list+','+get_spect_row.STOCK_ID[counter_1];
									stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_spect_row.AMOUNT_VALUE[counter_1],amount_round)*spect_carpan);
								}
							}
							get_spect_row='';
						}
					}
				}
				get_karma_koli='';
			}
		}
		//agactaki sevkte birlestirler
		if(list_len(tree_stock_id_list,',')>1)
		{
			var get_tree = wrk_safe_query('obj_get_tree','dsn3',0,tree_stock_id_list);
			if(get_tree.recordcount)
			{
				for (var counter_1=0; counter_1 < get_tree.recordcount; counter_1++)
				{
					var stock_amount=list_getat(tree_stock_amount_list,list_find(tree_stock_id_list,get_tree.STOCK_ID[counter_1],','),',');
					var yer=list_find(stock_id_list,get_tree.RELATED_ID[counter_1],',');
					if(yer)
					{
						top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNumBasket(get_tree.AMOUNT[counter_1],amount_round)*stock_amount);
						stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					}
					else{
						stock_id_list=stock_id_list+','+get_tree.RELATED_ID[counter_1];
						stock_amount_list=stock_amount_list+','+parseFloat(filterNumBasket(get_tree.AMOUNT[counter_1],amount_round)*stock_amount);
					}
				}
				get_tree='';
			 }
		}
		//stock kontrolleri
		if(stock_id_count >1)
		{/*sipariste depo bilgisi gonderilmiyor, satılabilir stok kontrol ediliyor , stock_type=1 olarak gonderiliyor*/
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
			{
				if(stock_type==undefined || stock_type==0)
				{
					if(is_update != 0)
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +is_update;
						var new_sql = 'obj_get_total_stock';
					}
					else
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + paper_date_kontrol;
						var new_sql = 'obj_get_total_stock_2';			
					}
				}
				else
				{
					if(is_update != 0)
					{
						var listParam = stock_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + paper_date_kontrol+ "*" +is_update;
						var new_sql='obj_get_total_stock_3';
					}						
					else
					{
						var listParam = stock_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + paper_date_kontrol;
						var new_sql='obj_get_total_stock_4';
					}
				}
			}
			else
			{
				if(stock_type==undefined || stock_type==0)
				{
					if(is_update != 0)
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +loc_id + "*" +  dep_id + "*" + is_update;
						var new_sql = 'obj_get_total_stock_5';
					}
					else
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + paper_date_kontrol + "*" +loc_id + "*" +  dep_id;
						var new_sql = 'obj_get_total_stock_6';
					}
				}
				else /*satıs siparisinde depoya gore kontrol yapılacaksa*/
				{
					var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + dep_id + "*" + loc_id + "*" + paper_date_kontrol + "*" + is_update + "*" + "<cfoutput>#dsn_alias#</cfoutput>";
					var new_sql='obj_get_total_stock_7';
					if(is_update != 0)
						new_sql= 'obj_get_total_stock_8';				
				}
			}
			//form_basket.detail.value=new_sql;
			
			var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			if(get_total_stock.recordcount)
			{
				var query_stock_id_list='0';
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
					if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1) // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
					{// alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
						if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt])+ parseFloat(list_getat(stock_amount_list,yer,',')) )< 0) )
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
					}
					else
					{
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < wrk_round(parseFloat(list_getat(stock_amount_list,yer,',')),8))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
					}
				}
			}
			var diff_stock_id='0';
			if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type)==0 && is_purchase_ == 0) //alış tipli işlemlerde bu kontrole gerek yok
			{
				for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
				{
					var stk_id=list_getat(stock_id_list,lst_cnt,',')
					if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
						diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
				}
				if(list_len(diff_stock_id,',')>1)
				{
				//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
					
					var new_sql = 'obj_get_stock_4';
					if(stock_type!=undefined && stock_type==1) //satılabilir stoguna bakılmıssa ve kayıt yoksa stoklarla sınırlı olup olmadıgı kontrol ediliyor
						new_sql = 'obj_get_stock_5"';
					var get_stock = wrk_safe_query(new_sql,'dsn3',0,diff_stock_id);
					for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
				}
			}
			get_total_stock='';
		}
		//agac ile ayni bir spec hic olusmadı ise
		if(list_len(not_stock_id_list,',')>1)
		{
			var new_sql = 'obj_get_stock_4';
			if(stock_type!=undefined && stock_type==1)
				new_sql = 'obj_get_stock_5';
			var get_stock = wrk_safe_query(new_sql,'dsn3',0,not_stock_id_list);
			for(var cnt=0; cnt < get_stock.recordcount; cnt++)
				hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
			get_stock='';
		}
		//specli stok kontrolleri
		if(popup_spec_type==1 && list_len(main_spec_id_list,',') >1)//sepcli stok bakılacaksa 
		{
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
			{
				if(stock_type==undefined || stock_type==0)
				{
					if(is_update != 0)
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + paper_date_kontrol;
						var new_sql = 'obj_get_total_stock_9';
					}
					else
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + paper_date_kontrol;
						var new_sql = 'obj_get_total_stock_10';
					}
				}
				else
				{
					if(is_update != 0)
					{
						var listParam = main_spec_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + is_update + "*" + paper_date_kontrol;
						var new_sql='obj_get_total_stock_11';
					}
					else
					{			
						var listParam = main_spec_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + paper_date_kontrol;
						var new_sql='obj_get_total_stock_12';
					}
				}
			}
			else
			{
				if(stock_type==undefined || stock_type==0)
				{
					if(is_update != 0)
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol;
						var new_sql = 'obj_get_total_stock_13';
					}
					else
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol;
						var new_sql = 'obj_get_total_stock_14';
					}
				}
				else /*satıs siparisinde depoya gore kontrol yapılacaksa*/
				{
					var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + dep_id + "*" + loc_id + "*"+ paper_date_kontrol + "*" + is_update;
					var new_sql='obj_get_total_stock_15';
					if(is_update != 0)
						new_sql='obj_get_total_stock_16';
				}
					//form_basket.detail.value=new_sql;
			}
			var get_total_stock = wrk_safe_query(new_sql,'dsn2','0',listParam);
			var query_spec_id_list='0';
			if(get_total_stock.recordcount)
			{
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
					if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type) || is_purchase_ == 1) // alış tipli işlemde sıfır stok kontrolu calıstırılıyorsa
					{// alış tipli islem siliniyorsa ve silme işleminden sonra geriye kalan stok eksiye düşüyorsa veya alış tipli işlem guncelleniyor ve (satırdaki miktar+toplam stok miktarı) eksiye düşüyorsa
						if( (((is_update != 0 && is_del_!=0) || is_deliver_ == 0) && parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) <0 ) || (is_update != 0 && is_del_==0 &&( parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt])+ parseFloat(list_getat(main_spec_amount_list,yer,',')) )< 0) )
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+') (main spec id:'+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
					}
					else
					{
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+') (main spec id:'+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
					}
				}
			}
			var diff_spec_id='0';
			if(list_find('73,74,75,76,77,80,761,82,84,86,87,114,761,115,110,140',process_type)==0 && is_purchase_ == 0) //alış tipli işlemlerde bu kontrole gerek yok
			{
				for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
				{
					var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
					if(!list_find(query_spec_id_list,spc_id,','))
						diff_spec_id=diff_spec_id+','+spc_id;//kayıt gelmeyen urunler
				}
				if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)
				{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
					var new_sql = 'obj_get_stock_6';
					if(stock_type!=undefined && stock_type==1) //satılabilir stoguna bakılmıssa ve kayıt yoksa stoklarla sınırlı olup olmadıgı kontrol ediliyor
						new_sql = 'obj_get_stock_7'; //main specte secilmis mi
					var get_stock = wrk_safe_query(new_sql,'dsn3',0,diff_spec_id);
					for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+') (main spec id:'+get_stock.SPECT_MAIN_ID[cnt]+')\n';
				}
			}
			get_total_stock='';
		}
	}
	if(lotno_hata != '')
	{
		if(stock_type==undefined || stock_type==0)
			alert(lotno_hata+'\n\n Yukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz !');
		else
			alert(lotno_hata+'\n\nYukarıdaki ürünlerde lot no bazında satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz !');
		lotno_hata='';
		return false;
	
	}
	else if(hata!='')
	{
		if(stock_type==undefined || stock_type==0)
			alert(hata+"\n\n <cf_get_lang dictionary_id='45636.Yukarıdaki ürünlerde stok miktarı yeterli değildir. Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz'>!");
		else
			alert(hata+"\n\n <cf_get_lang dictionary_id='33758.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir. Lütfen miktarları kontrol ediniz'> !");
		hata='';
		return false;
	}
	else
		return true;
}
function toplam_hesapla(from_sa_amount,from_new_row_,is_from_upd)
{
	var toplam_ = 0;
	var indirim_ = 0;
	var vergi_ = 0;
	var otv_vergisi_ = 0;
	var net_ = 0;
	var re_toplam_hesapla = 0;
	var prom_display='<font color="FF0000">Promosyon!</font>';
	taxArray = new Array(0);
	taxTotalArray = new Array(0);
	otvArray = new Array(0);
	otvTotalArray = new Array(0);
	var rate_flag = false;
	var commission_row = 0;

	function toplam_hesapla_in(is_take_commission,new_row_)
	{	
		toplam_ = 0;
		vergi_ = 0;
		otv_vergisi_ = 0;
		net_ = 0;
		var tax_flag = false;
		var otv_flag = false;
		taxArray = new Array(0);
		taxTotalArray = new Array(0);
		unitArray = new Array(0);
		unitTotalArray = new Array(0);
		otvArray = new Array(0);
		otvTotalArray = new Array(0);
		if(rowCount > 1)
		{
			if(new_row_!=undefined && new_row_!='') // Yeni Kayıt Eklenince bu kısım işler
			{
				toplam_ = document.all.basket_gross_total.value;
				net_ = document.all.basket_net_total.value-document.all.basket_tax_total.value-document.all.basket_otv_total.value;								
				if(is_take_commission)
					{
					toplam_ = wrk_round(toplam_)+filterNumBasket(document.all.row_total[new_row_].value,basket_total_round_number);
					net_ = wrk_round(net_)+filterNumBasket(document.all.row_nettotal[new_row_].value,basket_total_round_number);
					if(generaltaxArray.length != 0)
					{
						var gnArrayLen = generaltaxArray.length;				
						for (var gn=0; gn < gnArrayLen; gn++)
						{
							taxArray[gn] = generaltaxArray[gn];
							if(taxArray[gn]==document.all.tax[new_row_].value)//yeni satırın kdvsi onceden varsa toplama eklenir
							{	
								tax_flag = true;
								taxTotalArray[gn] = wrk_round(generaltaxArrayTotal[gn],basket_total_round_number)+filterNumBasket(document.all.row_taxtotal[new_row_].value,basket_total_round_number);
							}
							else
								taxTotalArray[gn] = generaltaxArrayTotal[gn];
						}
					}
					else
					{
						<cfif StructKeyExists(sepet,'kdv_array') and IsArray(sepet.kdv_array)>
							<cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="tt">
							{
								taxArray[taxArray.length] = '<cfoutput>#sepet.kdv_array[tt][1]#</cfoutput>';
								//taxTotalArray[taxArray.length-1] = '0';
								//taxMatrahArray[taxArray.length-1] = '<cfoutput>#sepet.kdv_array[tt][3]#</cfoutput>';
								if('<cfoutput>#sepet.kdv_array[tt][1]#</cfoutput>'==document.all.tax[new_row_].value)
								{
									tax_flag = true;
									taxTotalArray[taxArray.length-1] = '<cfoutput>#sepet.kdv_array[tt][2]#</cfoutput>';
									//taxTotalArray[taxArray.length-1] = 0;
									taxTotalArray[taxArray.length-1] = wrk_round(taxTotalArray[taxArray.length-1],basket_total_round_number)+filterNumBasket(document.all.row_taxtotal[new_row_].value,basket_total_round_number);
									//taxMatrahArray[taxArray.length-1] = wrk_round(taxMatrahArray[taxArray.length-1],basket_total_round_number)+filterNumBasket(changeable_value['row_taxtotal'][new_row_].value,basket_total_round_number);
								}
							}
							</cfloop>
						</cfif>
					}

					if(!tax_flag){ //yeni kdv oranıysa
						taxArray[taxArray.length] = changeable_value['tax'][new_row_];
						taxTotalArray[taxTotalArray.length] = filterNumBasket(changeable_value['row_taxtotal'][new_row_],basket_total_round_number);
						}
					
					if(generalotvArray.length != 0)
					{	
						var gnotvArrayLen = generalotvArray.length;
						for (var gg=0; gg < gnotvArrayLen; gg++)
						{	
							otvArray[gg] = generalotvArray[gg];
							if(otvArray[gg]==changeable_value['otv_oran'][new_row_]) //yeni satırın kdvsi onceden varsa toplama eklenir
							{	
								otv_flag = true;
								otvTotalArray[gg] = wrk_round(generalotvArrayTotal[gg],basket_total_round_number)+filterNumBasket(changeable_value['row_otvtotal'][new_row_].value,basket_total_round_number);
							}
							else
								otvTotalArray[gg] = generalotvArrayTotal[gg];
						}
					}
					else
					{
						
							{	
								otvArray[otvArray.length] = '0';
								otvTotalArray[otvTotalArray.length] = '0';
								if(otvArray[otvArray.length-1]==changeable_value['otv_oran'][new_row_]);
								{
									otv_flag = true;
									otvTotalArray[otvArray.length-1] = wrk_round(otvTotalArray[otvArray.length-1],basket_total_round_number)+filterNumBasket(changeable_value['row_otvtotal'][new_row_],basket_total_round_number);
								}
							}
							
					}

					if(!otv_flag){
						otvArray[otvArray.length] = changeable_value['otv_oran'][new_row_];
						otvTotalArray[otvTotalArray.length] = filterNumBasket(changeable_value['row_otvtotal'][new_row_],basket_total_round_number);
					}
				}
			}
			else
			{
				for (var counter_=1; counter_ <= rowCount; counter_++)
					{
					if(document.all.is_commission[counter_-1].value == 1)
						commission_row = counter_;
					
					if(document.all.is_commission[counter_-1].value!=1 || is_take_commission )
						{
						toplam_ += filterNumBasket(document.all.row_total[counter_-1].value,basket_total_round_number);
						net_ += filterNumBasket(document.all.row_nettotal[counter_-1].value,basket_total_round_number);
						tax_flag = false;
						if(taxArray.length != 0)
						{
							var taxArrayLen= taxArray.length;
							for (var m=0; m < taxArrayLen; m++)
							{
								if(taxArray[m] == document.all.tax[counter_-1].value){
									tax_flag = true;
									taxTotalArray[m] += filterNumBasket(document.all.row_taxtotal[counter_-1].value,price_round_number);
									break;
									}
							}
						}
						if(!tax_flag){
							taxArray[taxArray.length] = document.all.tax[counter_-1].value;
							taxTotalArray[taxTotalArray.length] = filterNumBasket(document.all.row_taxtotal[counter_-1].value,price_round_number);
							}
						
						otv_flag = false;
						if(otvArray.length != 0)
						{
							var otvArrayLen= otvArray.length;
							for (var nn=0; nn < otvArrayLen; nn++)
								if(otvArray[nn] == document.all.otv_oran[counter_-1].value){
									otv_flag = true;
									otvTotalArray[nn] += filterNumBasket(document.all.row_otvtotal[counter_-1].value,price_round_number);
									break;
									}
						}
						if(!otv_flag){
							otvArray[otvArray.length] = document.all.otv_oran[counter_-1].value;
							otvTotalArray[otvTotalArray.length] = filterNumBasket(document.all.row_otvtotal[counter_-1].value,price_round_number);
							}
						}
					}
			}
			
		}
		else if(rowCount == 1)
			{
			try{
				toplam_ = filterNumBasket(document.all.row_total[0].value,basket_total_round_number);}
			catch(e){
				toplam_ = filterNumBasket(document.all.row_total.value,basket_total_round_number);}
			try{
				net_ = filterNumBasket(document.all.row_nettotal[0].value,basket_total_round_number);}
			catch(e){
				net_ = filterNumBasket(document.all.row_nettotal.value,price_round_number);}
			try{
				taxArray[0] = filterNumBasket(document.all.tax[0].value);}
			catch(e){
				taxArray[0] = filterNumBasket(document.all.tax.value);}
			try{
				taxTotalArray[0] = filterNumBasket(document.all.row_taxtotal[0].value,price_round_number);}
			catch(e){
				taxTotalArray[0] = filterNumBasket(document.all.row_taxtotal.value,price_round_number);}
		
			try{
				otvArray[0] = filterNumBasket(document.all.otv_oran[0].value);}
			catch(e){
				otvArray[0] = filterNumBasket(document.all.otv_oran.value);}
			try{
				otvTotalArray[0] = filterNumBasket(document.all.row_otvtotal[0].value,price_round_number);}
			catch(e){
				otvTotalArray[0] = filterNumBasket(document.all.row_otvtotal.value,price_round_number);}
			}
		var taxlen= taxArray.length;
		if(taxlen != 0)
		{
			if(from_new_row_ == undefined || (from_new_row_ != undefined && from_new_row_== ''))
			{
				generaltaxArray= new Array(0);
				generaltaxArrayTotal= new Array(0);
			}
		
			for (var m=0; m < taxlen; m++)
			{
				generaltaxArray[m]= taxArray[m]; //genel basket tax array  degerleri aktarıyor EN SONA TASINACAK
				generaltaxArrayTotal[m] = taxTotalArray[m];
				
				vergi_+=wrk_round(taxTotalArray[m],price_round_number);
			}
		}
		var otvlen= otvArray.length;
		if(otvlen != 0)
		{		
			if(from_new_row_ == undefined || (from_new_row_ != undefined && from_new_row_== ''))
			{
				generalotvArray= new Array(0);
				generalotvArrayTotal= new Array(0);
			}
			for (var z=0; z < otvlen; z++)
			{
				generalotvArray[z]= otvArray[z]; //genel basket otv array degerleri aktarıyor
				generalotvArrayTotal[z] = otvTotalArray[z];
				otv_vergisi_+=wrk_round(otvTotalArray[z],price_round_number);
			}
		}
		toplam_ = wrk_round(toplam_,basket_total_round_number);
		net_ = wrk_round(net_,basket_total_round_number);
		indirim_ = wrk_round((toplam_ - net_),basket_total_round_number);
		vergi_ = wrk_round(vergi_,price_round_number);
		otv_vergisi_ = wrk_round(otv_vergisi_,basket_total_round_number);
	}
	
	if(from_new_row_ != undefined && from_new_row_!= ''){
		toplam_hesapla_in(0,from_new_row_);
	}
	else
	{
		toplam_hesapla_in(0);
	}
	<cfif fusebox.circuit eq 'invoice' or listfind("1,2,3,4,10,14,18,20,21,33,38,42,43,46,51,52",attributes.basket_id,",")>
		<cfif ListFindNoCase(display_list, "is_promotion")>
		function toplam_hesapla_prom(from_sa_amount)
		{
		<!--- proms ind hesabi --->
		prom_display='<font color="FF0000">Promosyon!</font>';
		if(!from_sa_amount){
			var old_general_prom_discount_ = wrk_round(document.all.old_general_prom_amount.value,basket_total_round_number);
			var old_genel_indirim_ =filterNumBasket(document.all.genel_indirim_.value,basket_total_round_number);
			if(isNaN(old_general_prom_discount_) || old_general_prom_discount_ == '')old_general_prom_discount_ =0;
			if(isNaN(old_genel_indirim_) || old_genel_indirim_ == '') old_genel_indirim_ =0;
			if(document.all.is_general_prom.value==1)
			{
				var general_prom_limit = parseFloat(document.all.general_prom_limit.value,price_round_number);
				if(net_ >= general_prom_limit ){
					document.all.general_prom_amount.value = wrk_round(net_*filterNumBasket(document.all.general_prom_discount.value,basket_total_round_number)/100,basket_total_round_number);
					var new_genel_indirim_ = (parseFloat(old_genel_indirim_,basket_total_round_number)-parseFloat(old_general_prom_discount_,basket_total_round_number)+parseFloat(document.all.general_prom_amount.value,basket_total_round_number));
					document.all.genel_indirim_.value = commaSplit(new_genel_indirim_,basket_total_round_number);
					}
				else{
					document.all.general_prom_amount.value = wrk_round(0);
					document.all.genel_indirim_.value = commaSplit((old_genel_indirim_-old_general_prom_discount_),basket_total_round_number);
					}
	
				var free_prom_limit = parseFloat(document.all.free_prom_limit.value);
				var free_prom_found=0;
				var id = document.all.free_prom_stock_id;
				if(document.all.free_prom_stock_id != undefined)
				{
					var v = document.all.free_prom_stock_id.value;
					for (var counter_=1; counter_ <= rowCount; counter_++)
						if(changeable_value['is_promotion'][counter_] && id != undefined && changeable_value['stock_id'][counter_]==v)
							free_prom_found=counter_;
					if(net_ >= free_prom_limit && document.all.free_prom_stock_id != undefined && document.all.free_prom_stock_id.value.length)
						{
						var free_price;
						if(!free_prom_found)
							{
							add_free_prom(document.all.free_prom_stock_id.value,document.all.free_prom_id.value,document.all.free_stock_price.value,document.all.free_stock_money.value,document.all.free_prom_amount.value,1,document.all.free_prom_cost.value);
							re_toplam_hesapla =1;
							}
						}
					else{
						if(free_prom_found>0)
							{
							del_row(free_prom_found+1);
							re_toplam_hesapla =1;
							}
						}
					for (var counter_=1; counter_ <= rowCount; counter_++){
						if(changeable_value['is_promotion'][counter_]!=0)
							prom_display += '<br/>'+changeable_value['amount'][counter_]+' '+changeable_value['unit'][counter_]+' '+changeable_value['product_name'][counter_];
					}
				}
			}else{
				document.all.general_prom_amount.value = wrk_round(0);
				document.all.genel_indirim_.value = commaSplit((old_genel_indirim_-old_general_prom_discount_),basket_total_round_number);
				if(document.all.free_prom_id != undefined && document.all.free_prom_id.value != '')
				{
					for (var counter_=1; counter_ <= rowCount; counter_++)
						if(changeable_value['is_promotion'][counter_] && changeable_value['prom_stock_id'][counter_].length==0 && eval(document.all.prom_id[counter_].value) == document.all.free_prom_id.value)
						{	
							del_row(counter_+1);
							re_toplam_hesapla =1;
						}
				}
				prom_display ='';
				}
			}
			document.all.old_general_prom_amount.value=document.all.general_prom_amount.value;		
	}	
		toplam_hesapla_prom(from_sa_amount);
		</cfif>
		
		if(findObj('commission_rate') && document.all.commission_rate.value.length && document.all.commission_rate.value != 0)
		{
			toplam_hesapla_in(0);
			if(from_new_row_!=undefined && from_new_row_!='') //seri urun eklemeden cagrılmıssa komisyon satırını bu asamada arar.
			{
				var temp_iscomsn =eval('document.all.is_commission');
				if(rowCount > 1){
				for (var counter_=1; counter_ <= rowCount; counter_++){
				if(document.all.is_commission[counter_-1].value==1)
						commission_row = counter_;
				} }
			}
			
			not_com_total = 0;

			if(rowCount > 1)
			{
				for (var counter_=1; counter_ <= rowCount; counter_++)
				{
					if(document.all.is_commission[counter_-1].value == 0)
					{
						
						var get_prod_control = wrk_safe_query('obj_get_prod_control','dsn3',0,document.all.product_id[counter_-1].value);
						if(get_prod_control.COM_CONTROL == 0)
						{
							not_com_total = parseFloat(not_com_total + filterNumBasket(document.all.row_lasttotal[counter_-1].value,price_round_number));
						}
						
					}
				}
			}
			else
			{
				if(document.all.is_commission.value == 0)
				{
					var get_prod_control = wrk_safe_query('obj_get_prod_control','dsn3',0,form_basket.product_id.value);
					if(get_prod_control.COM_CONTROL == 0)
					{
						not_com_total = parseFloat(not_com_total + filterNumBasket(form_basket.row_lasttotal.value,price_round_number));
					}
				}
			}
		
		var new_com_total = wrk_round(parseFloat((net_ + vergi_ + otv_vergisi_) - not_com_total),price_round_number);
		var commission_price = wrk_round(new_com_total*parseFloat(document.all.commission_rate.value)/100,price_round_number);
		if(commission_price) //komisyon bedeli sıfırdan buyukse komisyon satırı ekleniyor
		{
			if(commission_row)
				{
				add_commission_row(commission_price,1,commission_row); //olan komisyon satırını update eder odeme yontemindeki komisyon bilgilerine gore
				}
			else
				{
				add_commission_row(commission_price); //yeni komisyon satırı ekler
				}
		}
		else
		{
			if(commission_row)
				del_row(commission_row+1);
		}
		re_toplam_hesapla=1;
	}
	else if(commission_row)
	{
		del_row(commission_row+1);
		re_toplam_hesapla=1;
	}
	
	
	if(re_toplam_hesapla!= undefined && re_toplam_hesapla == 1)
		toplam_hesapla_in(1);
		
	var sa_percent = 0;
	var sa_amount = filterNumBasket(document.all.genel_indirim_.value,basket_total_round_number);
	if(toplam_)	{
		if(document.all.genel_indirim_.value.length > 0 && sa_amount > 0 && net_ >= sa_amount){
			sa_percent = ( sa_amount/net_ ) * 100;
			vergi_ = wrk_round((vergi_ * (100-sa_percent)) / 100,basket_total_round_number);
			otv_vergisi_ = wrk_round((otv_vergisi_ * (100-sa_percent)) / 100,basket_total_round_number);
			indirim_ = indirim_ + sa_amount;
			document.all.genel_indirim.value = wrk_round(sa_amount,basket_total_round_number);
			document.all.genel_indirim_.value = commaSplit(sa_amount,basket_total_round_number);
			net_ = net_ - sa_amount; 
			for (var mm=0; mm < taxArray.length; mm++)
				taxTotalArray[mm] = wrk_round((taxTotalArray[mm] * (100-sa_percent)) / 100,basket_total_round_number);
			for (var zz=0; zz < otvArray.length; zz++)
				otvTotalArray[zz] = wrk_round((otvTotalArray[zz] * (100-sa_percent)) / 100,basket_total_round_number);
		}else{
			document.all.genel_indirim_.value = commaSplit(0);
			document.all.genel_indirim.value = 0;
	}
	}	</cfif>
	<cfif fusebox.circuit eq 'invoice' or listfind("1,2,18,20,33,42,43",attributes.basket_id,",")>
		var bey_kdv=0;
		if(document.getElementById('tevkifat_oran')!= undefined)
		{
			var tev_oran = parseFloat(filterNumBasket(document.all.tevkifat_oran.value,8));
			if(document.all.tevkifat_box.checked && !isNaN(tev_oran) && tev_oran>=0 && tev_oran<=100){
				vergi_ = 0;
				tev_kdv_list.innerHTML = 'Tevkifat ';
				tev_kdv_list.style.fontWeight = 'bold';
				bey_kdv_list.innerHTML = 'Beyan Edilen ';
				bey_kdv_list.style.fontWeight = 'bold';
				for (var m=0; m < taxArray.length; m++){
					bey_kdv = wrk_round((taxTotalArray[m]*tev_oran),basket_total_round_number);
					vergi_ += bey_kdv;
					tev_kdv_list.innerHTML += '%'+taxArray[m]+' :'+commaSplit(taxTotalArray[m]-bey_kdv,basket_total_round_number)+' ';
					bey_kdv_list.innerHTML += '%'+taxArray[m]+' :'+commaSplit(bey_kdv,basket_total_round_number)+' ';
				}
			}
			else{
				document.all.tevkifat_oran.value = '';
				tev_kdv_list.innerHTML = '';
				bey_kdv_list.innerHTML = '';
			}
		}
	</cfif>
	<cfif listfind('form_copy_bill,form_add_bill,detail_invoice_sale,add_sale_invoice_from_order,form_add_bill_from_ship,form_add_bill_other,detail_invoice_other,form_add_bill_purchase,detail_invoice_purchase,form_copy_bill_purchase,add_purchase_invoice_from_order',fusebox.fuseaction)>
	    stopaj_yuzde_ = parseFloat(filterNum($('#stopaj_yuzde').val()));
		if( (stopaj_yuzde_ < 0) || (stopaj_yuzde_ > 99.99) )
			{
			alert("<cf_get_lang dictionary_id='32930.Stopaj Oranı'>!");
			stopaj_yuzde_ = 0;
			}
		//stopaj_ = Math.round(net_ * stopaj_yuzde_) / 100;
		stopaj_ = wrk_round((net_ * stopaj_yuzde_ / 100),basket_total_round_number);
		document.all.stopaj_yuzde.value = commaSplit( stopaj_yuzde_ );
		document.all.stopaj.value = commaSplit( stopaj_ ,basket_total_round_number);
	<cfelse>
		stopaj_ = 0;
	</cfif>
	net_ += vergi_;
	net_ += otv_vergisi_;
	
	total_default.innerHTML = commaSplit(toplam_ ,basket_total_round_number);
	total_discount_default.innerHTML = commaSplit( indirim_ ,basket_total_round_number);
	total_tax_default.innerHTML = commaSplit( vergi_,basket_total_round_number );
	<cfif ListFindNoCase(display_list, "OTV")>
		total_otv_default.innerHTML = commaSplit(otv_vergisi_,basket_total_round_number);
	</cfif>
	<cfif listfind('form_copy_bill,form_add_bill,detail_invoice_sale,add_sale_invoice_from_order,form_add_bill_from_ship,form_add_bill_other,detail_invoice_other,form_add_bill_purchase,detail_invoice_purchase,form_copy_bill_purchase,add_purchase_invoice_from_order',fusebox.fuseaction)>
		net_total_default.innerHTML = commaSplit( (net_-stopaj_),basket_total_round_number);
	<cfelse>
		net_total_default.innerHTML = commaSplit( net_,basket_total_round_number);
	</cfif>
	document.all.basket_gross_total.value = wrk_round(toplam_,basket_total_round_number);
	document.all.basket_tax_total.value =  wrk_round(vergi_,basket_total_round_number);
	document.all.basket_otv_total.value =  wrk_round(otv_vergisi_,basket_total_round_number);
	document.all.basket_net_total.value = wrk_round(net_,basket_total_round_number);
	document.all.basket_discount_total.value = wrk_round(indirim_,basket_total_round_number);
		for (var counter_=0; counter_ <= <cfoutput>#get_money_bskt.recordcount-1#</cfoutput>; counter_++)	
		{
		<cfif get_money_bskt.recordcount eq 1> //sistem para birimi haricinde kur bilgisi tanımlanmamıssa
			if(eval('form_basket.rd_money.checked'))
		<cfelse>
			if(eval('form_basket.rd_money['+counter_+'].checked'))
		</cfif>
			{
				rate_flag = true;
				rate1 = rate1Array[counter_];
				rate2 = rate2Array[counter_];
				money_ = moneyArray[counter_];
			}
		}
	if(!rate_flag){
		rate1 = 1;
		rate2 = 1;
		money_ = '<cfoutput>#session_base.money#</cfoutput>';
		}

	form_basket.basket_money.value = money_;
	form_basket.basket_rate1.value = rate1;
	form_basket.basket_rate2.value = rate2;

	if(rate2 != 0){<!--- dovizli rakamlar set ediliyor ayni degiskenler ustune --->
		toplam_ = wrk_round(toplam_* rate1/rate2,basket_total_round_number);
		indirim_ = wrk_round(indirim_*rate1/rate2,basket_total_round_number);
		vergi_ = wrk_round(vergi_*rate1/rate2,basket_total_round_number);
		otv_vergisi_ = wrk_round(otv_vergisi_*rate1/rate2,basket_total_round_number);
		<cfif listfind('form_copy_bill,form_add_bill,detail_invoice_sale,add_sale_invoice_from_order,form_add_bill_from_ship,form_add_bill_other,detail_invoice_other,form_add_bill_purchase,detail_invoice_purchase,form_copy_bill_purchase,add_purchase_invoice_from_order',fusebox.fuseaction)>
			net_ = wrk_round( (net_-stopaj_)*rate1/rate2,basket_total_round_number );
		<cfelse>
			net_ = wrk_round( net_*rate1/rate2 ,basket_total_round_number);
		</cfif>
		}
	else{
		toplam_ = 0;
		indirim_ = 0;
		vergi_ = 0;
		otv_vergisi_ = 0;
		net_ = 0;
		}
	total_wanted.innerHTML = commaSplit( toplam_,basket_total_round_number );
	total_tax_wanted.innerHTML = commaSplit( vergi_,basket_total_round_number );
	<cfif ListFindNoCase(display_list, "OTV")>
		total_otv_wanted.innerHTML = commaSplit( otv_vergisi_,basket_total_round_number );
	</cfif>
	total_discount_wanted.innerHTML = commaSplit( indirim_ ,basket_total_round_number);
	net_total_wanted.innerHTML = commaSplit( net_ ,basket_total_round_number);
	td_kdv_list.style.fontWeight = 'bold';

	td_kdv_list.innerHTML = '';
	for (var m=0; m < taxArray.length; m++)
		td_kdv_list.innerHTML += '<cf_get_lang_main no="227.KDV"> % ' + taxArray[m] + ' : ' + commaSplit( taxTotalArray[m],basket_total_round_number) + ' ';
	<cfif ListFindNoCase(display_list, "OTV")>
		td_otv_list.style.fontWeight = 'bold';
		td_otv_list.innerHTML = '';
		for (var jj=0; jj < otvArray.length; jj++)
			td_otv_list.innerHTML += 'ÖTV % ' + otvArray[jj] + ' : ' + commaSplit( otvTotalArray[jj],basket_total_round_number) + ' ';
	</cfif>
	<cfif listfind("1,2,20,42,43",attributes.basket_id,",")>
		if(form_basket.yuvarlama == undefined) basket_yuvarlama_ = 0; else basket_yuvarlama_=form_basket.yuvarlama.value;
		<!--- //Eger yuvarlama islemi var ise. --->
		if(form_basket.basket_net_total.value  !=''){
			var flt_value = parseFloat( form_basket.basket_net_total.value-stopaj_,basket_total_round_number);
			if(form_basket.yuvarlama != undefined)
				flt_value += filterNumBasket( basket_yuvarlama_,basket_total_round_number);
			net_total_default.innerHTML = commaSplit(flt_value,basket_total_round_number);
			form_basket.basket_net_total.value=flt_value;
			net_total_wanted.innerHTML = commaSplit(flt_value*rate1/rate2,basket_total_round_number);
			if(form_basket.yuvarlama != undefined)
				form_basket.yuvarlama.value = commaSplit( filterNumBasket(form_basket.yuvarlama.value,basket_total_round_number),basket_total_round_number );
		}else{form_basket.yuvarlama.value=0;}
	</cfif>
	<cfif ListFindNoCase(display_list, "is_promotion")>
		if(!from_sa_amount) basket_proms.innerHTML = prom_display;
	</cfif>
	<cfif ListFindNoCase(display_list,'duedate')>
		set_paper_duedate();//satır vadelerine baglı olarak belge ortalama vadesini hesaplar
	</cfif>
	<cfif attributes.basket_id eq 51 and (not isdefined("kontrol_form_update") or (isdefined("kontrol_form_update") and kontrol_form_update eq 0))><!--- kontrol_form_update tahsilatı değişen siparişlerin sadece sipariş kısmını güncellemek için eklendi 1 ise senet oluşmuyor --->
		add_voucher_row(is_from_upd);
	</cfif>
	<cfif attributes.basket_id eq 52>
		toplam_tahsilat();
	</cfif>
	<cfif ListFindNoCase(display_list,'is_risc')> //display_member_risk.cfm 'de olan bi function, risk bilgisi seciliyse dosya include ediliyor
		toplam_limit_hesapla();
	</cfif>
	<cfif isdefined('attributes.is_retail')>
		if(typeof(genel_kontrol) != 'undefined') //perakende faturası icin tanımlı geliyor
			genel_kontrol();
	</cfif>
	if(from_sa_amount == 0)
	{
		kdvsiz_doviz_indirim_hesapla();
		kdvli_doviz_indirim_hesapla();
	}
	//kdvsiz toplam hesabi 08012013 YO YO
	dusulecek_vergi_default = filterNumBasket(total_tax_default.innerHTML,basket_total_round_number);
	dusulecek_vergi_wanted = filterNumBasket(total_tax_wanted.innerHTML,basket_total_round_number);
	brut_basket_toplam_default = filterNumBasket(net_total_default.innerHTML,basket_total_round_number);
	brut_basket_toplam_wanted = filterNumBasket(net_total_wanted.innerHTML,basket_total_round_number);
	<cfif ListFindNoCase(display_list, "OTV")>
		dusulecek_vergi_default = dusulecek_vergi_default + filterNumBasket(total_otv_default.innerHTML,basket_total_round_number);
		dusulecek_vergi_wanted = dusulecek_vergi_wanted + filterNumBasket(total_otv_wanted.innerHTML,basket_total_round_number);
	</cfif>
	brut_basket_toplam_default = brut_basket_toplam_default - dusulecek_vergi_default;
	brut_basket_toplam_wanted = brut_basket_toplam_wanted - dusulecek_vergi_wanted;
	
	brut_total_default.innerHTML = commaSplit(brut_basket_toplam_default,basket_total_round_number);
	brut_total_wanted.innerHTML = commaSplit(brut_basket_toplam_wanted,basket_total_round_number);
	//	
	return true;	
}
/*
function kur_degistir(gelen)
{	
	if(gelen != undefined) //tekli kur degistirildiginde cagrılmıssa
	{
		var eleman = eval('form_basket.txt_rate2_' + gelen);
		rate2Array[gelen-1] = filterNumBasket(eleman.value,basket_rate_round_number);
	}
	for( var satir_index = 1 ; satir_index <= rowCount ; satir_index++)
	{
		if(satir_index < rowCount)
			hesapla('price_other',satir_index,0);
		else
			hesapla('price_other',satir_index,1);
	}
	kdvsiz_doviz_indirim_hesapla();
	kdvli_doviz_indirim_hesapla();
	return true;
}*/
function kur_degistir(gelen)
{
	not_change = 0;
	old_gelen = gelen;
	try
	{
		old_currency = rate2Array[gelen-1];
		for(i=1;i<=document.form_basket.rd_money.length;i++)
		{
			gelen=i;
			if(gelen != undefined) //tekli kur degistirildiginde cagrılmıssa
			{
				var eleman = eval('form_basket.txt_rate2_' + gelen);
				rate2Array[gelen-1] = filterNumBasket(eleman.value,basket_rate_round_number);
			}
			if(i == old_gelen)
			{
				if(commaSplit(filterNumBasket(eleman.value,basket_rate_round_number),8) == commaSplit(old_currency,8))
				{
					not_change = 1;
					//alert('burada');
				}
			}
		}
	}
	catch(e)
	{
		if(gelen != undefined) //tekli kur degistirildiginde cagrılmıssa
		{
			old_currency = rate2Array[gelen-1];
			var eleman = eval('form_basket.txt_rate2_' + gelen);
			rate2Array[gelen-1] = filterNumBasket(eleman.value,basket_rate_round_number);
			if(commaSplit(filterNumBasket(eleman.value,basket_rate_round_number),8) == commaSplit(old_currency,8))
			{
				//alert('burada2');
				not_change = 1;
			}
		}
	}
	if(not_change == 0)
	{
		for( var satir_index = 1 ; satir_index <= rowCount ; satir_index++)
		{
			if(satir_index < rowCount)
				hesapla('price_other',satir_index,0);
			else <!--- sadece son satirda toplam hesaplansin  --->
				hesapla('price_other',satir_index,1);
		}
		kdvsiz_doviz_indirim_hesapla();
		kdvli_doviz_indirim_hesapla();
	}
	return true;
}
<cfif (isdefined('attributes.basket_id') and listfind('4,5', attributes.basket_id) and isdefined("attributes.offer_id")) or (isdefined('attributes.basket_id') and listfind('14,15', attributes.basket_id)) or (isdefined('attributes.basket_sub_id') and listfind('1,2,7',attributes.basket_sub_id))>
	/*siparis emirlerinden irsaliye olusturma, irsaliye emirlerden fatura olusturma ekranlarında kur farklılıkları olmaması icin yeniden hesaplanıyor*/
	kur_degistir();
</cfif>
function apply_discount(col_no)
{	
	form_basket.control_field_value.value = -1;
	var to_count = rowCount-1;
	eval('document.all.set_row_disc_ount'+col_no+'.value=commaSplit(filterNumBasket(document.all.set_row_disc_ount'+col_no+'.value))');
	if(rowCount > 1)<!--- baskette cok satir yani array varsa --->
		for(var k=0;k<=to_count;k++)
		{
			/*div=working sadece fatura ve irsaliye de (formlarinda search oldugu ve working oldugu icin) calisabiliyor, hepsinde calismais icin ayrica bir div etiketi yapilacak*/
			if(findObj('working') && k > 10)
			{
				working.style.left=(document.body.clientWidth-400)/2;
				working.style.top=(document.body.clientHeight-120)/2;
				working.style.zIndex=2;
				gizle_goster(working);
			}
			document.getElementById('sepetim').scrollTop = document.getElementById('sepetim').scrollTop+21;/*20051027 ellemeyin 20 pixel olarak satirlara bakarak calisiyor*/
			eval('document.all.indirim'+col_no+'['+k+'].value=document.all.set_row_disc_ount'+col_no+'.value');
			if(k < to_count)
				eval('hesapla("indirim'+col_no+'",document.all.indirim'+col_no+'['+k+'].parentNode.parentNode.rowIndex,0)');
			else<!--- sadece son satir da degistikten sonra toplam hesaplansin --->
				eval('hesapla("indirim'+col_no+'",document.all.indirim'+col_no+'['+k+'].parentNode.parentNode.rowIndex,1)');
			
			<cfif attributes.basket_id eq 51> /*sadece taksitli satıs basketinde calısacak*/
				eval('control_prod_discount(document.all.indirim'+col_no+'['+k+'].parentNode.parentNode.rowIndex-1)');
			</cfif>
			if(findObj('working') && k == to_count && working.style.display.length==0)
				gizle_goster(working);
		}
	else if(rowCount == 1)
	{<!--- baskette tek satir varsa --->
		eval('document.all.indirim'+col_no+'.value=document.all.set_row_disc_ount'+col_no+'.value');
		<cfif attributes.basket_id eq 51> //sadece taksitli satıs basketinde calısacak
			eval('control_prod_discount(document.all.indirim'+col_no+'.parentNode.parentNode.rowIndex-1)');
		</cfif>
		eval('hesapla("indirim'+col_no+'",document.all.indirim'+col_no+'.parentNode.parentNode.rowIndex)');
	}
	else return true;
}
function reset_basket_kdv_rates()  //ithalat ve ihracat faturalarından cagılıyor ve kdv oranları sıfırlanıyor
{
	reset_kdv =0;
	if(rowCount != 0)
	{
		var to_count = rowCount-1;
		if(rowCount > 1)
		{
			for(var k_i=0; k_i<=to_count; k_i++)
				if(eval('document.all.tax['+k_i+'].value') != 0)
					reset_kdv=1; //sıfırlanacak kdv var mı kontrol ediliyor
		}
		else if(rowCount == 1)
		{
			if(document.all.tax.value !=0)
				reset_kdv=1;
		}
		if(reset_kdv == 1)
		{
			if(confirm("<cf_get_lang dictionary_id='60056.Ürünlerin KDV Oranları Sıfırlanacaktır'>"))
			{
				if(rowCount > 1)
				{
					for(var k_i=0; k_i<=to_count; k_i++)
					{
						form_basket.control_field_value.value=eval('document.all.tax['+k_i+']').value;
						eval('document.all.tax['+k_i+']').value=0;
						if(k_i < to_count)
							eval('hesapla("tax",document.all.tax['+k_i+'].parentNode.parentNode.rowIndex,0)');
						else
							eval('hesapla("tax",document.all.tax['+k_i+'].parentNode.parentNode.rowIndex,1)');
					}
				}
				else if(rowCount == 1)
				{
					form_basket.control_field_value.value=document.all.tax.value;
					document.all.tax.value=0;
					eval('hesapla("tax",document.all.tax.parentNode.parentNode.rowIndex,1)');
				}
			
			}
		}
		return true;
	}
	else return true;
}
function add_general_prom(basket_net_val_)
{<cfif fusebox.circuit eq 'invoice' or listfind("1,2,3,4,10,14,18,20,21,33,42,43,51,52",attributes.basket_id,",")>
	var is_general_prom_found=true;
	var is_free_prom_found=true;
	var general_prom_limit=0;
	var free_prom_limit=0;
	if(form_basket.company_id.value.length){
		var prom_date = js_date( eval('document.all.'+form_basket.search_process_date.value+'.value').toString() );
		var listParam = prom_date + "*" + basket_net_val_;
		var new_sql = 'obj_get_comp_proms_2';
		if(basket_net_val_!=undefined && basket_net_val_!='' && basket_net_val_!=0) /*toplam hesapla icinden basket toplamı gonderilmisse*/
			new_sql = 'obj_get_comp_proms_3';
		var get_comp_proms = wrk_safe_query(new_sql,'dsn3',0,listParam);
		<cfif session.ep.username is 'admin'>
			general_prom_inputs.style.display='block';
			general_prom_inputs.innerHTML += '<br/>Sorgu:<br/>'+new_sql;
		</cfif>
		}
	else
		{get_comp_proms = new Object();get_comp_proms.recordcount = 0;}

	if(get_comp_proms.recordcount){
		document.all.is_general_prom.value=1;
		general_prom_inputs.style.display='block';
		for(var prom_i=0;prom_i<get_comp_proms.recordcount;prom_i++){
			if(is_general_prom_found && get_comp_proms.DISCOUNT[prom_i].length){
				is_general_prom_found=false;
				for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
					if(moneyArray[mon_i]==get_comp_proms.LIMIT_CURRENCY[prom_i])
						general_prom_limit = get_comp_proms.LIMIT_VALUE[prom_i]*rate2Array[mon_i]/rate1Array[mon_i];
				general_prom_inputs_1.innerHTML = '<a href="javascript:windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_promotion_unique&prom_id='+get_comp_proms.PROM_ID[prom_i]+'\',\'medium\')"><b>Toplama İndirim</b></a>';
				general_prom_inputs_1.innerHTML += '<input type="hidden" name="general_prom_id" value="' + get_comp_proms.PROM_ID[prom_i] + '"><br/>';
				general_prom_inputs_1.innerHTML += 'Alışveriş Miktarı<input type="text" style="width:75px;" name="general_prom_limit" value="' + general_prom_limit + '" readonly class="box"><br/>';
				general_prom_inputs_1.innerHTML += 'İndirim % <input type="text" name="general_prom_discount" style="width:98px;" value="' + get_comp_proms.DISCOUNT[prom_i] + '" readonly class="box"><br/>';
				general_prom_inputs_1.innerHTML += 'Toplam İndirim<input type="text" style="width:80px;" name="general_prom_amount" value="" readonly class="box">';
				}
			else if(is_free_prom_found && get_comp_proms.FREE_STOCK_ID[prom_i].length){
				is_free_prom_found=false;
				for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
					if(moneyArray[mon_i]==get_comp_proms.LIMIT_CURRENCY[prom_i])
						free_prom_limit = get_comp_proms.LIMIT_VALUE[prom_i]*rate2Array[mon_i]/rate1Array[mon_i];
				general_prom_inputs_2.innerHTML = '<a href="javascript:windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_promotion_unique&prom_id='+get_comp_proms.PROM_ID[prom_i]+'\',\'medium\')"><b>Toplama Bedava Ürün</b></a><br/>';
				general_prom_inputs_2.innerHTML += '<input type="hidden" name="free_prom_id" value="' + get_comp_proms.PROM_ID[prom_i] + '"><input type="hidden" name="free_prom_cost" value="'+get_comp_proms.TOTAL_PROMOTION_COST[prom_i]+'" readonly class="box">';
				general_prom_inputs_2.innerHTML += 'Alışveriş Miktarı<input type="text" name="free_prom_limit" style="width:75px;" value="' + free_prom_limit + '" readonly class="box"><br/>';
				general_prom_inputs_2.innerHTML += 'Kazanılan Ürün ID<input type="text" name="free_prom_stock_id" style="width:63px;" value="'+get_comp_proms.FREE_STOCK_ID[prom_i]+'" readonly class="box"><br/>';
				general_prom_inputs_2.innerHTML += 'Ürün Miktarı<input type="text" name="free_prom_amount" style="width:91px;" value="'+get_comp_proms.FREE_STOCK_AMOUNT[prom_i]+'" readonly class="box"><br/>';
				general_prom_inputs_2.innerHTML += 'Ürün Fiyatı<input type="text" style="width:97px;" name="free_stock_price" value="'+get_comp_proms.FREE_STOCK_PRICE[prom_i]+'" readonly class="box"><input type="text" name="free_stock_money" style="width:40px;" value="'+get_comp_proms.AMOUNT_1_MONEY[prom_i]+'" readonly class="boxtext">';
				}
			}
			if(is_general_prom_found)
				general_prom_inputs_1.innerHTML = '<input type="hidden" name="general_prom_limit" value="0"><input type="hidden" name="general_prom_amount" value="0"><input type="hidden" name="general_prom_discount" value="0">';
			if(is_free_prom_found)
				general_prom_inputs_2.innerHTML = '<input type="hidden" name="free_prom_limit" value="0">';
			toplam_hesapla(0);
		}
	else if(eval(document.all.is_general_prom.value)){
		general_prom_inputs.style.display='none';
		document.all.is_general_prom.value=0;
		general_prom_inputs_1.innerHTML = '<input type="hidden" name="general_prom_limit" value="0"><input type="hidden" name="general_prom_amount" value="0"><input type="hidden" name="general_prom_discount" value="0">';
		general_prom_inputs_2.innerHTML = '<input type="hidden" name="free_prom_limit" value="0">';
		toplam_hesapla(0);
		}
	else return true;<!--- eger kayit yoksa ve daha once de gelmemisse  --->
</cfif>
}

function add_commission_row(commission_price,is_upd,upd_row_no)
{
	if(!form_basket.card_paymethod_id.value.length)
		return false;
	if(form_basket.commethod_id != undefined && form_basket.commethod_id.value == 6) //ww den gelen siparisler icin
		var new_sql = 'obj_get_card_comms';
	else //pp ve ep den gelen siparisler icin
		var new_sql = 'obj_get_card_comms_2';
	var get_card_comms = wrk_safe_query(new_sql,'dsn3',0,form_basket.card_paymethod_id.value);
	if(get_card_comms.recordcount)
	{
		var product_id = get_card_comms.PRODUCT_ID;
		var stock_id = get_card_comms.STOCK_ID;
		var stock_code  = get_card_comms.STOCK_CODE;
		var special_code  = get_card_comms.STOCK_CODE_2;
		var barcod  = get_card_comms.BARCOD;
		var manufact_code  = get_card_comms.MANUFACT_CODE;
		var product_name  = get_card_comms.PRODUCT_NAME+get_card_comms.PROPERTY;
		var unit_id_  = get_card_comms.PRODUCT_UNIT_ID;
		var unit_  = get_card_comms.ADD_UNIT;
		var spect_id  = '';
		var spect_name  = '';
		var row_promotion_id = '';
		var promosyon_yuzde = '';
		var promosyon_maliyet = '';
		var is_promotion = '0';
		var prom_stock_id = '';<!--- genel ise bos satirdan ise dolu --->
		var iskonto_tutar=0;
		var tax  = get_card_comms.TAX;
		commission_price = wrk_round((commission_price * 100) / (100 + parseFloat(tax)),price_round_number);
		var price  = commission_price;
		for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
			if(moneyArray[mon_i]==money)
				price  = commission_price*rate2Array[mon_i]/rate1Array[mon_i];
		var price_other  = commission_price;
		var is_inventory = get_card_comms.IS_INVENTORY;
		var is_production = get_card_comms.IS_PRODUCTION;
		var net_maliyet = '';
		var marj = '';
		var extra_cost=0;
		var money  = money;
		
		var amount_ = 1;
		var get_prod_acc = wrk_safe_query("obj_get_prod_acc_3",'dsn3',0,get_card_comms.PRODUCT_ID);
		if(get_prod_acc.recordcount)
			var product_account_code = get_prod_acc.ACCOUNT_CODE;
		else
			var product_account_code = '';
		var row_unique_relation_id = '';
		
		var toplam_hesap=0;
		var is_commission=1;		
		if(is_upd!=undefined && is_upd==1 && upd_row_no != undefined)
		{
			if(document.all.order_currency[upd_row_no-1] != undefined)
			{
				var order_currency_ = document.all.order_currency[upd_row_no-1].value;
				var reserve_type_ = document.all.reserve_type[upd_row_no-1].value;
				var row_ship_id  = document.all.row_ship_id[upd_row_no-1].value;
				var duedate = document.all.duedate[upd_row_no-1].value;
				upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, row_ship_id, amount_, product_account_code, is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,0,upd_row_no,is_commission,'',row_unique_relation_id,'','','',0,'','','','',order_currency_,0)
			}
		}
		else
		{
			var row_ship_id  = 0;
			var duedate = 0;
			add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, row_ship_id, amount_, product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,0,'','','',0,'',row_unique_relation_id,'',toplam_hesap,is_commission,'','','','','',0,'','','','','',0,'','','','','','','','','',special_code);
		}
	}
}
function add_free_prom(stock_id,promotion_id,free_stock_price,money,free_stock_amount,is_general,free_prom_cost,upd_row_no,is_upd,prom_relation_id)
{
<cfif fusebox.circuit eq 'invoice' or listfind("1,2,4,10,14,18,20,21,33,42,43,51,52",attributes.basket_id,",")>
	var get_stock_proms = wrk_safe_query("obj_get_stock_proms_2",'dsn3',0,stock_id);
	if(get_stock_proms.recordcount)
	{
		var prom_date = js_date( date_add('d',1,eval('form_basket.'+form_basket.search_process_date.value+'.value').toString()) );
		if(get_stock_proms.IS_COST)
		{
			var listParam = "<cfoutput>#dsn2_alias#</cfoutput>"+ "*" + prom_date + "*"+ stock_id;
			var get_stock_cost = wrk_safe_query("obj_get_stock_cost",'dsn3',"1",listParam);
		}
		<cfif fusebox.circuit eq 'invoice' or listfind("1,2,33,42",attributes.basket_id,",")> //sadece fatura islemlerinde muhasebe kodu alınıyor
			var get_prod_acc = wrk_safe_query("obj_get_prod_acc",'dsn3',0,get_stock_proms.PRODUCT_ID);
			if(get_prod_acc.recordcount)
				var product_account_code = get_prod_acc.ACCOUNT_CODE;
			else
				var product_account_code = '';
		<cfelse>
			var product_account_code = '';
		</cfif>
		var product_name = get_stock_proms.PRODUCT_NAME+get_stock_proms.PROPERTY;
		var row_promotion_id = promotion_id;
		var promosyon_maliyet = free_prom_cost;
		var prom_stock_id = is_general ? '' : get_stock_proms.STOCK_ID;<!--- genel ise bos satirdan ise dolu --->
		var iskonto_tutar = free_stock_price;
		var price = free_stock_price;
		for(var mon_i=0;mon_i<moneyArray.length;mon_i++)
			if(moneyArray[mon_i]==money)
				price = free_stock_price*rate2Array[mon_i]/rate1Array[mon_i];
		var price_other = free_stock_price;
		if(get_stock_proms.IS_COST == 1 && get_stock_cost.recordcount){
			var net_maliyet = get_stock_cost.PURCHASE_NET_SYSTEM;
			var extra_cost=get_stock_cost.PURCHASE_EXTRA_COST_SYSTEM;
			}
		else{
			var net_maliyet = '';
			var extra_cost=0;
			}
		var money = money;
		var amount_ = free_stock_amount;
		var row_unique_relation_id = '';
		if(prom_relation_id != undefined)
			var prom_relation = prom_relation_id;
		else
			var prom_relation = '';
		var toplam_hesap = is_general ? 0 : 1;
		if(is_upd == undefined || is_upd ==0)
			add_basket_row(get_stock_proms.PRODUCT_ID, get_stock_proms.STOCK_ID, get_stock_proms.STOCK_CODE, get_stock_proms.BARCOD, get_stock_proms.MANUFACT_CODE, product_name, get_stock_proms.PRODUCT_UNIT_ID, get_stock_proms.ADD_UNIT, '', '', price, price_other, get_stock_proms.TAX, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, 0, amount_, product_account_code,get_stock_proms.IS_INVENTORY,get_stock_proms.IS_PRODUCTION,net_maliyet,'',extra_cost,row_promotion_id,'',promosyon_maliyet,iskonto_tutar,1,prom_stock_id,0,'','','',0,'',row_unique_relation_id,'',toplam_hesap,0,'',prom_relation);
		else
			upd_row(get_stock_proms.PRODUCT_ID, get_stock_proms.STOCK_ID, get_stock_proms.STOCK_CODE, get_stock_proms.BARCOD, get_stock_proms.MANUFACT_CODE, product_name, get_stock_proms.PRODUCT_UNIT_ID, get_stock_proms.ADD_UNIT, '', '', price, price_other, get_stock_proms.TAX, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', money, 0, amount_, product_account_code, get_stock_proms.IS_INVENTORY,get_stock_proms.IS_PRODUCTION,net_maliyet,'',extra_cost,row_promotion_id,'',promosyon_maliyet,iskonto_tutar,1,prom_stock_id,0,upd_row_no,0,'',row_unique_relation_id,'','','',0,'','',prom_relation);
	}
</cfif>
}
function kdvli_net_indirim_hesapla()
	{
		if(document.form_basket.genel_indirim_kdvli_hesap_.value != '')
			{
				genel_t_ = filterNumBasket(document.getElementById('net_total_default').innerHTML,basket_total_round_number);
				yazilan_ = filterNumBasket(document.form_basket.genel_indirim_kdvli_hesap_.value,basket_total_round_number);
				total_ = 0;
				toplam_hesapla(1);
				if(taxArray.length != 0)
					{
						var taxArrayLen= taxArray.length;
						for (var m=0; m < taxArrayLen; m++)
						{
							if(taxTotalArray[m] != '' && taxArray[m] > 0)
							{
								oran_deger_ = ((taxTotalArray[m] * 100) / taxArray[m]) + taxTotalArray[m];
								oran_son_ = ((oran_deger_ * 100 / genel_t_) * yazilan_ / 100) / (1 + taxArray[m] / 100);
								total_ += oran_son_;
							}
						}
					}
				document.form_basket.genel_indirim_.value = commaSplit(total_,basket_total_round_number);
				document.form_basket.genel_indirim.value = filterNumBasket(commaSplit(total_,basket_total_round_number),basket_total_round_number);
				toplam_hesapla(1);
			}
	}
function kdvsiz_doviz_indirim_hesapla()
	{
		if(document.form_basket.genel_indirim_doviz_net_hesap != undefined && document.form_basket.genel_indirim_doviz_net_hesap.value != '')
			{
				yazilan_ = filterNumBasket(document.form_basket.genel_indirim_doviz_net_hesap.value,basket_total_round_number);
				total_ = 0;
				toplam_hesapla(1);
				total_ = yazilan_ * rate2;
				document.form_basket.genel_indirim_.value = commaSplit(total_,basket_total_round_number);
				document.form_basket.genel_indirim.value = filterNumBasket(commaSplit(total_,basket_total_round_number),basket_total_round_number);
				toplam_hesapla(1);
			}
	}
function kdvli_doviz_indirim_hesapla()
	{
		if(document.form_basket.genel_indirim_doviz_net_hesap != undefined && document.form_basket.genel_indirim_doviz_brut_hesap.value != '')
			{
				yazilan_ = filterNumBasket(document.form_basket.genel_indirim_doviz_brut_hesap.value,basket_total_round_number);
				total_ = 0;
				toplam_hesapla(1);
				total_ = yazilan_ * rate2;
				document.form_basket.genel_indirim_kdvli_hesap_.value = commaSplit(total_,basket_total_round_number);
				kdvli_net_indirim_hesapla();
				toplam_hesapla(1);
			}
	}
function yuvarlama_doviz_hesapla()
	{
		if(document.form_basket.yuvarlama_doviz.value != '')
			{
				yazilan_ = filterNumBasket(document.form_basket.yuvarlama_doviz.value,basket_total_round_number);
				total_ = 0;
				toplam_hesapla(1);
				total_ = yazilan_ / rate2;
				document.form_basket.yuvarlama.value = commaSplit(total_,basket_total_round_number);
				toplam_hesapla(1);
			}
	}
	

function ayir(row_)
{
	var obj = document.getElementById('table_list').children[0].children[row_];
	var inpts = obj.getElementsByTagName('input');
	var str = "";	
	for (var i=0;i<inpts.length;i++)
	{
		row_value[inpts[i].name] = inpts[i].value;
		//str += inpts[i].name + ' = ' + inpts[i].value + '\n';
	}	
	var inpts = obj.getElementsByTagName('select');
	var str = "";
	for (var i=0;i<inpts.length;i++)
	{
		row_value[inpts[i].name] = inpts[i].value;
		//str += inpts[i].name + ' = ' + inpts[i].value + '\n';
	}	
}

function ayir_ters(row_)
{
	var obj = document.getElementById('table_list').children[0].children[row_];
	var inpts = obj.getElementsByTagName('input');
	var str = "";
	for (var i=0;i<inpts.length;i++)
	{
		inpts[i].value = row_value[inpts[i].name];
		//str += inpts[i].name + ' = ' + inpts[i].value + '\n';
	}
	var inpts = obj.getElementsByTagName('select');
	var str = "";
	for (var i=0;i<inpts.length;i++)
	{
		if(arguments[1]==null)
			inpts[i].value = row_value[inpts[i].name];
		//str += inpts[i].name + ' = ' + inpts[i].value + '\n';
	}
}

function load_all_row_values(){
	changeable_value['is_commission'] = new Array(0);
	changeable_value['row_total'] = new Array(0);
	changeable_value['row_nettotal'] = new Array(0);
	changeable_value['tax'] = new Array(0);
	changeable_value['row_taxtotal'] = new Array(0);
	changeable_value['otv_oran'] = new Array(0);
	changeable_value['row_otvtotal'] = new Array(0);
	
	changeable_value['stock_id'] = new Array(0);
	changeable_value['is_promotion'] = new Array(0);
	changeable_value['amount'] = new Array(0);
	changeable_value['unit'] = new Array(0);
	changeable_value['amount_other'] = new Array(0);
	changeable_value['unit_other'] = new Array(0);

	changeable_value['prom_stock_id'] = new Array(0);
	changeable_value['prom_id'] = new Array(0);
	
	changeable_value['row_lasttotal'] = new Array(0);
	changeable_value['rd_money'] = new Array(0);
	changeable_value['product_id'] = new Array(0);
	
	changeable_value['duedate'] = new Array(0);
	changeable_value['product_name'] = new Array(0);
	
	changeable_value['row_unique_relation_id'] = new Array(0);
	changeable_value['prom_relation_id'] = new Array(0);		
	
	// i = 0 başlıklar
	// i = 1 inputlar
	// i = 2 row <td>1</td>
<!---	for (var i = 1;i<tr.length;i++){
		ayir(i);
		change_row_values(i);
	}--->
	
	if(tr.length > 1)
	{
		for (var i=1;i<tr.length;i++)
		{
			ayir(i);
			change_row_values(i);
		}
	}
	
	//alert(changeable_value['is_commission'][101].value);
}
<!---
function change_row_values(sira){	

	changeable_value['is_commission'][sira] = row_value['is_commission'];
	changeable_value['row_total'][sira] = row_value['row_total'];
	changeable_value['row_nettotal'][sira] = row_value['row_nettotal'];

	changeable_value['tax'][sira] = row_value['tax'];
	changeable_value['row_taxtotal'][sira] = row_value['row_taxtotal'];
	changeable_value['otv_oran'][sira] = row_value['otv_oran'];
	changeable_value['row_otvtotal'][sira] = row_value['row_otvtotal'];

	changeable_value['stock_id'][sira] = row_value['stock_id'];
	changeable_value['is_promotion'][sira] = row_value['is_promotion'];
	changeable_value['amount'][sira] = row_value['amount'];
	changeable_value['unit'][sira] = row_value['unit'];

	changeable_value['prom_stock_id'][sira] = row_value['prom_stock_id'];
	//changeable_value['prom_id'][sira] = row_value['prom_id'].value;
	
	changeable_value['row_lasttotal'][sira] = row_value['row_lasttotal'];
	//changeable_value['rd_money'][sira] = row_value['rd_money'].value;
		
	changeable_value['product_id'][sira] = row_value['product_id'];
	changeable_value['duedate'][sira] = row_value['duedate'];
	
	changeable_value['product_name'][sira] = row_value['product_name'];
	changeable_value['row_unique_relation_id'][sira] = row_value['row_unique_relation_id']
	changeable_value['prom_relation_id'][sira] = row_value['prom_relation_id'];		
}
--->
function change_row_values(sira){	
	real_sira = sira - 1;
	if(rowCount > 1)
	{
		changeable_value['is_commission'][sira] = eval('document.all.is_commission['+real_sira+']').value;	
		changeable_value['row_total'][sira] = eval('document.all.row_total['+real_sira+'].value');
		changeable_value['row_nettotal'][sira] = eval('document.all.row_nettotal['+real_sira+']').value;
	
		changeable_value['tax'][sira] = eval('document.all.tax['+real_sira+']').value;
		changeable_value['row_taxtotal'][sira] = eval('document.all.row_taxtotal['+real_sira+']').value;
		changeable_value['otv_oran'][sira] = eval('document.all.otv_oran['+real_sira+']').value;
		changeable_value['row_otvtotal'][sira] = eval('document.all.row_otvtotal['+real_sira+']').value;
	
		changeable_value['stock_id'][sira] = eval('document.all.stock_id['+real_sira+']').value;
		changeable_value['is_promotion'][sira] = eval('document.all.is_promotion['+real_sira+']').value;
		changeable_value['amount'][sira] = eval('document.all.amount['+real_sira+']').value;
		changeable_value['unit'][sira] = eval('document.all.unit['+real_sira+']').value;
		changeable_value['amount_other'][sira] = eval('document.all.amount_other['+real_sira+']').value;
		changeable_value['unit_other'][sira] = eval('document.all.unit_other['+real_sira+']').value;
	
		changeable_value['prom_stock_id'][sira] = eval('document.all.prom_stock_id['+real_sira+']').value;
		
		changeable_value['row_lasttotal'][sira] = eval('document.all.row_lasttotal['+real_sira+']').value;
			
		changeable_value['product_id'][sira] = eval('document.all.product_id['+real_sira+']').value;
		changeable_value['duedate'][sira] = eval('document.all.duedate['+real_sira+']').value;
		
		changeable_value['product_name'][sira] = eval('document.all.product_name['+real_sira+']').value;
		changeable_value['row_unique_relation_id'][sira] = eval('document.all.row_unique_relation_id['+real_sira+']').value;
		changeable_value['prom_relation_id'][sira] = eval('document.all.prom_relation_id['+real_sira+']').value;
	}
	else
	{
		changeable_value['is_commission'][sira] = document.all.is_commission.value;	
		changeable_value['row_total'][sira] = document.all.row_total.value;
		changeable_value['row_nettotal'][sira] = document.all.row_nettotal.value;
	
		changeable_value['tax'][sira] = document.all.tax.value;
		changeable_value['row_taxtotal'][sira] = document.all.row_taxtotal.value;
		changeable_value['otv_oran'][sira] = document.all.otv_oran.value;
		changeable_value['row_otvtotal'][sira] = document.all.row_otvtotal.value;
	
		changeable_value['stock_id'][sira] = document.all.stock_id.value;
		changeable_value['is_promotion'][sira] = document.all.is_promotion.value;
		changeable_value['amount'][sira] = document.all.amount.value;
		changeable_value['unit'][sira] = document.all.unit.value;
		changeable_value['amount_other'][sira] = document.all.amount_other.value;
		changeable_value['unit_other'][sira] = document.all.unit_other.value;
	
		changeable_value['prom_stock_id'][sira] = document.all.prom_stock_id.value;
		
		changeable_value['row_lasttotal'][sira] = document.all.row_lasttotal.value;
			
		changeable_value['product_id'][sira] = document.all.product_id.value;
		changeable_value['duedate'][sira] = document.all.duedate.value;
		
		changeable_value['product_name'][sira] = document.all.product_name.value;
		changeable_value['row_unique_relation_id'][sira] = document.all.row_unique_relation_id.value;
		changeable_value['prom_relation_id'][sira] = document.all.prom_relation_id.value;
	}	
}	
	
</script>