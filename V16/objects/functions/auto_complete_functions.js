<script type="text/javascript">
	/*
		Auto Complete
		Mahmut ER
		Amaç:Her autocomplete için bir fonksiyon yapmanın engellenmesi,sadece workdata 
		klasörünün içine query syfasınızı koyup ona göre her yerde kullanabiliyorsunuz.Ayrıca OK tuşları ile harakete izin veriyor.
		Tarih : 15.03.2007
	*/
	function get_auto_complete(query_name,fn_1,fn_1_query_fields,fi_1,fi_1_query_fields,divid,maxrows,query_where_parameter,maxlength,function_name,function_paramater,function_values)
	{
		if(event.keyCode==27)//esc'e basılmış ise
		{
			document.getElementById(divid).style.display = 'none';
			document.getElementById(divid).innerHTML = '';
			document.getElementById(fn_1).value = '';
			document.getElementById(fi_1).value = '';
		}
		else
		{
			var auto_complete_div_genislik = parseInt(eval("document.getElementById('fn_1')").style.width);//fiel_name inputunun uzunluğu kadar yapıyoruz.
			document.getElementById(divid).style.width = auto_complete_div_genislik;//burada div'in ölçüsü field_name'in ki ile aynı yapılıyor burası tek satıra düşürülebilir
			if(document.getElementById(fn_1).value.length > maxlength)
			{
				var get_auto_complete_workdata = workdata(query_name,eval("document.getElementById('fn_1')").value,maxrows,query_where_parameter);
				var total_records = maxrows;
				if(get_auto_complete_workdata.recordcount)
				{
					document.getElementById(divid).style.display = '';
					if(get_auto_complete_workdata.recordcount < total_records)
					total_records = get_auto_complete_workdata.recordcount;
					var auto_complete_div_yukseklik =(maxrows*10)-100;
					if(auto_complete_div_yukseklik > 250) auto_complete_div_yukseklik = 250;
					var xxx = 'add_auto_comlete(list_getat(this.value,1,\'|@|\'),list_getat(this.value,2,\'|@|\'),\''+fi_1+'\',\''+fn_1+'\',\''+divid+'\',\''+function_name+'\',\''+function_paramater+'\',\''+function_values+'\');'
					var _fields_ = '<select name="auto_complete_fields'+fi_1+'" id="auto_complete_fields'+fi_1+'" ondblclick="'+xxx+'" onKeyPress="'+xxx+'return false;" style="width:'+auto_complete_div_genislik+'px;height:'+auto_complete_div_yukseklik+'px;" multiple>';
					for(i=0;i<total_records;i++)
					{
						var q_name = eval('get_auto_complete_workdata.'+fn_1_query_fields+'[i]');
						var q_id = eval('get_auto_complete_workdata.'+fi_1_query_fields+'[i]');
						_fields_ = _fields_+ '<option value="'+q_id+'|@|'+q_name+'">'+q_name+'</option>';
					}
					_fields_ = _fields_+'</select>'
					document.getElementById(divid).innerHTML = _fields_;
					if(event.keyCode==40){document.getElementById('auto_complete_fields'+fi_1).focus();document.getElementById('auto_complete_fields'+fi_1).selectedIndex=0;}
				}
				else//kayıt yoksa div'i kapatıyoruz ve içini boşaltıyoruz.
				{
					document.getElementById(divid).style.display = 'none';
					document.getElementById(divid).innerHTML = '';
				}
			}		
			else
			{
				if(document.getElementById(fn_1).value.length == 0 && document.getElementById(divid).style.display != 'none')
					document.getElementById('auto_complete_fields'+fi_1).focus();
				else if(document.getElementById(fn_1).value.length == 0)
					document.getElementById(fi_1).value = '';
			}
		}
	}
	function add_auto_comlete(field_id_value,field_name_value,fi_1,fn_1,divid,function_name,function_paramater,function_values)
	{
		if(event.keyCode==13 || event.keyCode==0)//enter'a basılmışsa yada mouse ile  çift tıklanmışsa
		{
			if(function_name && function_name.length != '' && function_paramater.length =='')
				{var func_name = eval(function_name); func_name();}
			else if(eval(function_name)!= undefined && function_name.length != '' && function_paramater.length !='')	
				{var func_name = eval(function_name); func_name(function_paramater);}
			document.getElementById(fi_1).value = field_id_value;
			document.getElementById(fn_1).value = field_name_value;
			document.getElementById(divid).style.display = 'none';
		}
		else
		{
			document.getElementById(fn_1).value+=String.fromCharCode(event.keyCode);
			eval(document.getElementById(function_values).value);
			if(document.getElementById('auto_complete_fields'+fi_1))
				document.getElementById('auto_complete_fields'+fi_1).focus();
			else
				document.getElementById(fn_1).focus();
		}
		//document.execCommand('Stop');
		return true;
	}

</script>