<!--- krediler coklu satir ekleme --->
<script type="text/javascript">
	no = <cfoutput>#attributes.row_number#</cfoutput>;
	type = <cfoutput>#attributes.type#</cfoutput>;
	period = <cfoutput>#attributes.period#</cfoutput>;
	repetition = <cfoutput>#attributes.repetition_number#</cfoutput>;
	<cfif isdefined("attributes.day_number") and len(attributes.day_number)>
		day_number = <cfoutput>#attributes.day_number#</cfoutput>;
	</cfif>
	
	if (type == 1)
	{ 
	
		payment_date = window.top.document.getElementById('payment_date'+no).value;
		payment_capital_price = window.top.document.getElementById('payment_capital_price'+no).value;
		payment_interest_price = window.top.document.getElementById('payment_interest_price'+no).value;
		payment_tax_price = window.top.document.getElementById('payment_tax_price'+no).value;
		payment_total_price = window.top.document.getElementById('payment_total_price'+no).value;
		payment_detail = window.top.document.getElementById('payment_detail'+no).value;
		expense_center_id = window.top.document.getElementById('expense_center_id'+no).value;
		expense_item_id = window.top.document.getElementById('expense_item_id'+no).value;
		expense_item_name = window.top.document.getElementById('expense_item_name'+no).value;
		interest_account_id = window.top.document.getElementById('interest_account_id'+no).value;
		interest_account_code = window.top.document.getElementById('interest_account_code'+no).value;
		total_expense_item_id = window.top.document.getElementById('total_expense_item_id'+no).value;
		total_expense_item_name = window.top.document.getElementById('total_expense_item_name'+no).value;
		total_account_id = window.top.document.getElementById('total_account_id'+no).value;
		total_account_code = window.top.document.getElementById('total_account_code'+no).value;
		if(window.top.document.getElementById('borrow_id'+no) != undefined || window.top.document.getElementById('borrow_code'+no) != undefined)
			{
				borrow_id = window.top.document.getElementById('borrow_id'+no).value;
				borrow_code = window.top.document.getElementById('borrow_code'+no).value;
			}
		else
			{
				borrow_id = '';
				borrow_code = '';
			}
		if(window.top.document.getElementById('total_payment_price'+no) != undefined) 
			total_payment_price = window.top.document.getElementById('total_payment_price'+no).value;
		else
			total_payment_price = '';
		
		if(window.top.document.getElementById('capital_account_id' + no) != undefined)
		{
			capital_account_id = window.top.document.getElementById('capital_account_id' + no).value;
			capital_account_code = window.top.document.getElementById('capital_account_code' + no).value;
			capital_expense_item_id = window.top.document.getElementById('capital_expense_item_id' + no).value;
			capital_expense_item_name = window.top.document.getElementById('capital_expense_item_name' + no).value;
			
		}
		else
		{
			capital_account_code = '';
			capital_account_id = '';
			capital_expense_item_id = '';
			capital_expense_item_name = '';
		}
	}
	else 
	{
		payment_date = window.top.document.getElementById('revenue_date'+no).value;
		payment_capital_price = window.top.document.getElementById('revenue_capital_price'+no).value;
		payment_interest_price = window.top.document.getElementById('revenue_interest_price'+no).value;
		payment_tax_price = window.top.document.getElementById('revenue_tax_price'+no).value;
		payment_total_price = window.top.document.getElementById('revenue_total_price'+no).value;
		payment_detail = window.top.document.getElementById('revenue_detail'+no).value;
		total_payment_price = '';
		
		if(window.top.document.getElementById('revenue_expense_center_id' + no) != undefined)
		{	
			expense_center_id = window.top.document.getElementById('revenue_expense_center_id' + no).value;
			expense_item_id = window.top.document.getElementById('revenue_expense_item_id' + no).value;
			expense_item_name = window.top.document.getElementById('revenue_expense_item_name' + no).value;
			interest_account_id = window.top.document.getElementById('revenue_interest_account_id' + no).value;
			interest_account_code = window.top.document.getElementById('revenue_interest_account_code' + no).value;
			total_expense_item_id = window.top.document.getElementById('revenue_total_expense_item_id' + no).value;
			total_expense_item_name = window.top.document.getElementById('revenue_total_expense_item_name' + no).value;
			total_account_id = window.top.document.getElementById('revenue_total_account_id' + no).value;
			total_account_code = window.top.document.getElementById('revenue_total_account_code' + no).value;
			if(window.top.document.getElementById('borrow_id'+no) != undefined || window.top.document.getElementById('borrow_code'+no) != undefined)
			{
				borrow_id = window.top.document.getElementById('borrow_id'+no).value;
				borrow_code = window.top.document.getElementById('borrow_code'+no).value;
			}
		else
			{
				borrow_id = '';
				borrow_code = '';
			}
			capital_expense_item_id = window.top.document.getElementById('revenue_capital_expense_item_id' + no).value;
			capital_expense_item_name = window.top.document.getElementById('revenue_capital_expense_item_name' + no).value;
			capital_account_id = window.top.document.getElementById('revenue_capital_account_id' + no).value;
			capital_account_code = window.top.document.getElementById('revenue_capital_account_code' + no).value;
			
		}
		else
		{
			expense_center_id = '';
			expense_item_id = '';
			expense_item_name = '';
			interest_account_id = '';
			interest_account_code = '';
			total_expense_item_id = '';
			total_expense_item_name = '';
			total_account_id = '';
			total_account_code = '';
			borrow_id = '';
			borrow_code = '';
			capital_expense_item_id = '';
			capital_expense_item_name = '';
			capital_account_id = '';
			capital_account_code = '';
		}
	}

	if(payment_date != '') new_payment_date = payment_date;
	for(i=1; i<=repetition; i++)
	{
		if (period == 1 && payment_date != '')
			new_payment_date = date_add('m',1,new_payment_date);
		else if (period == 2 && payment_date != '')
			new_payment_date = date_add('d',parseFloat(i*day_number),payment_date);
		else
			new_payment_date = '';
			
		window.top.add_row(type,new_payment_date,payment_capital_price,payment_interest_price,payment_tax_price,payment_total_price,payment_detail,total_payment_price,expense_center_id,expense_item_id,expense_item_name,interest_account_id,interest_account_code,total_expense_item_id,total_expense_item_name,capital_expense_item_id,capital_expense_item_name,capital_account_id,capital_account_code,total_account_id,total_account_code,borrow_id,borrow_code);
	}
	
	function date_add(dpart,number,d,first_date,kontrol_month)
	{
		if(number == 0) return d;
		if(kontrol_month == undefined) kontrol_month = 0;
		if(!d || !dpart || !number) return false;
		if(d.split('/').length==3) d = d.split('/');
		else if(d.split('.').length==3) d = d.split('.');
		else return false;
		if(first_date != undefined && first_date != '')
		{
			if(first_date.split('/').length==3) first_date = first_date.split('/');
			else if(first_date.split('.').length==3) first_date = first_date.split('.');
			var first_date = new Date(first_date[2],first_date[1]-1,first_date[0]);//javascript aylari 0-11 araliginda tutuyor
		}
		if(d[2].length == 2){
			var y = new Date();
			d[2] = y.getFullYear().toString().substr(0,2) + d[2];//yil 2 hane girilirse basina bu yilin ilk iki karakterini aliyoruz
			}
		var d = new Date(d[2],d[1]-1,d[0]);//javascript aylari 0-11 araliginda tutuyor
		if(dpart == 'd')
			d.setDate(d.getDate()+number);//gun eklenmek istenmis
		else if(dpart == 'm')
		{
			if(first_date == undefined || first_date == '')
			{
				if(d.getDate() > 28 && (d.getMonth() == 0) && number==1){//gün 28den büyük girilmiş ise... ve aylardan ocak ise 1 ay eklendiğinde sapıtıyordu o yüzden gün olarak ekleme yapıyoruz.
				if(d.getFullYear() % 4 == 0)
					d.setDate(d.getDate()+29);
				else
					d.setDate(d.getDate()+28);
				d = d.getDate()+'/'+(d.getMonth()+1)+'/'+d.getFullYear();return d;}
				d.setMonth(d.getMonth()+number);//ay eklenmek istenmis
		   }
		   else if(first_date != undefined && first_date != '' && (first_date.getDate() > 28 || kontrol_month == 1))
		   {
				if(d.getMonth() == 11)
					day_count = daysInMonth(1,d.getFullYear()+1);
				else
					day_count = daysInMonth((d.getMonth()+2),d.getFullYear()); 
					
				first_day_count = first_date.getDate();
				
				if(d.getMonth() == 11)
				{
					new_month = 1;
					new_year=d.getFullYear()+1;
				}
				else
				{
					new_month = d.getMonth()+2;
					new_year=d.getFullYear();
				}
				if(kontrol_month == 1 )
				{
					if(isDate(new_year,new_month,first_day_count) == 0 && first_day_count != daysInMonth((d.getMonth()+1),d.getFullYear()))
						var new_date = first_day_count+'/'+new_month+'/'+new_year;
					else
						var new_date = day_count+'/'+new_month+'/'+new_year;
				}
				else
				{
					if(isDate(new_year,new_month,first_day_count) == 0)
						var new_date = first_day_count+'/'+new_month+'/'+new_year;
					else
						var new_date = day_count+'/'+new_month+'/'+new_year;
				}
				return new_date;
			}
			else
				d.setMonth(d.getMonth()+number); 
		} 
		d = d.getDate()+'/'+(d.getMonth()+1)+'/'+d.getFullYear();
		return d;
	}
</script>


