<!--- E-Fatura Tevkifat Kodlari icin duzenlendi AP 20150907 --->
<cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#tevkifat_code.xml" variable="xmldosyam" charset="UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.TEVKIFAT_KODLARI.XmlChildren>
<cfset jsonData = serializeJSON(xmldosyam)>

<cfinclude template="../../objects/query/tax_type_code.cfm">

<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id="43463.Tevkifat Oranları"></cfsavecontent>
	<cf_box title="#head#" collapsable="0" resize="0">
		<div class="ui-row">
			<cfinclude template="../display/list_tevkifat.cfm">
		</div>
	</cf_box>
</div>
<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
	<cf_box title="#getLang('settings',1481)#" collapsable="0" resize="0"><!--- Tevkifat Ekle --->
		<cfform name="tax" method="post" action="#request.self#?fuseaction=settings.emptypopup_tevkifat_add" onsubmit="newRows()">
			<cfquery name="TAXS" datasource="#DSN2#">
				SELECT TAX_ID,TAX FROM SETUP_TAX  WHERE TAX > 0 ORDER BY TAX
			</cfquery>
			<div class="ui-row">
				<div class="ui-form-list">
					<input type="hidden" name="record_num" id="record_num" value="0">
					<input type="hidden" name="counter" id="counter" value="0">
					<div class="col col-6 col-md-6 col-sm-8 col-xs-12">
						<div class="form-group">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id="57493.Aktif"></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_active" id="is_active" value="1"/>
							</div>
						</div>
						<div class="form-group">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id="50734.Tevkifat Oranı">*</label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="statement_rate" id="statement_rate" onkeypress="return SadeceRakam(event);" onkeyup="return control_statement_rate(this,event);" onblur="SadeceRakam(event,false)" >
								<cfinput type="hidden" name="statement_rate_numerator" id="statement_rate_numerator"/>
								<cfinput type="hidden" name="statement_rate_denominator" id="statement_rate_denominator"/>
							</div>
						</div>
						<div class="form-group">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id="60231.Tevkifat Kodu"><cfif session.ep.our_company_info.is_efatura> *</cfif></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="tevkifat_code" id="tevkifat_code">
									<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id="30006.Vergi Kodu"> <cfif session.ep.our_company_info.is_efatura>*</cfif></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="tax_code" id="tax_code">
									<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
									<cfoutput query="tax_codes">
										<option value="#TAX_CODE_ID#,#TAX_CODE_NAME#" title="#detail#">#TAX_CODE_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id="57629.Açıklama"></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="detail" id="detail" ></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="ui-scroll">
					<cf_grid_list>
						<thead>
							<tr>
								<th width="20"><a href="javascript://" onclick="add_row();"><i class="fa fa-plus"></i></a></th>
								<th width="70"><cf_get_lang dictionary_id="42533.KDV Oranı">*</th>
								<th><cf_get_lang dictionary_id="42998.Tevkifat Beyan Kodu">*</th>
								<th><cf_get_lang dictionary_id="42997.Tevkifat Muhasebe Kodu"></th>
								<th><cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id="42997.Tevkifat Muhasebe Kodu"> *</th>
								<th><cf_get_lang dictionary_id='58176.Alış'> <cf_get_lang dictionary_id="42998.Tevkifat Beyan Kodu">*</th>
							</tr>
						</thead>
						<tbody name="table1" id="table1">
						</tbody>
					</cf_grid_list>
				</div>
				<div class="ui-form-list-btn">
					<cf_workcube_buttons is_upd='0' add_function='form_kontrol()'>
				</div>
			</div>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	var __xml = '<cfoutput>#jsonData#</cfoutput>';
	var str = $.parseJSON(JSON.stringify(__xml)).replace('//','').slice(1,-1);
	var xmlDoc = $.parseXML(str);
	var $xml = $(xmlDoc);
	var $Name = $($xml).find('TEVKIFAT_KODLARI').children();	
	var object = {"Tevkifat":[]}; // global Object

		$.each($Name,function(key,value){
			
			var tevkifatAdı = $(value).children().eq(0).text();
			var tevkifatKodu = $(value).children().eq(1).text();
			var tevkifatOran = $(value).children().eq(2).text();

				object.Tevkifat.push({
						'code' : tevkifatKodu,
						'name' : tevkifatAdı,
						'rate' : tevkifatOran
					});//pushh

		});//each

	$(function(){
		
		var __input = $('input[id="statement_rate"]');
		var __select = $('select[id="tevkifat_code"]');
			__input.bind('change',function(){
				__select.empty();
				$('<option>')
					.text('Seçiniz')
					.appendTo( __select );	
				 var inputVal = $(this).val();
				 
				 $.each(object.Tevkifat,function(key,value){
					
						if ( value.rate === inputVal ) {
								$('<option>')
									.attr('value',value.code+';'+value.name)
									.text(value.code+'-'+value.name)
									.appendTo( __select );					
							}
					});
			});
	})


	var row_count=0;
	function SadeceRakam(e, allowedchars)
	{
		var key = e.charCode == undefined ? e.keyCode : e.charCode;// 44 = ',' kaldırdım
		if ( (/^[0-9]+$/.test(String.fromCharCode(key))) || key==0 || key==47 || key==13 || isPassKey(key,allowedchars) )
		{ 
			return true;
		}
		else 
		{ 
			return false;
		}
	}
	function isPassKey(key,allowedchars)
	{
		if (allowedchars != null) 
		{
			for (var i = 0; i < allowedchars.length; i++) 
			{
				if (allowedchars[i]  == String.fromCharCode(key))			 
					return true;
			}
		}
		return false;
	}
	function control_statement_rate(fld,e)
	{
		if(fld.value.indexOf('/')>0 && fld.value.indexOf(',')>0)
		{
			var inputstr = fld.value;
			alert('Doğru formatta yazınız!');
			document.getElementById('statement_rate').value = '';
			document.getElementById('statement_rate_numerator').value = '';
			document.getElementById('statement_rate_denominator').value = '';
			return false;
		}
		else if(fld.value.indexOf('/')<=0)
		{
			return FormatCurrency(fld,e,8);
		}
	}
	function sil(sy)
	{
		var my_element = document.getElementById('row_kontrol'+sy);
		
		my_element.value=0;
		document.getElementById('counter').value = filterNum(document.getElementById('counter').value)-1;
		var my_element=document.getElementById('frm_row'+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		document.tax.counter.value=filterNum(document.tax.counter.value)+1;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
					
		document.tax.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol'+row_count+'" id="row_kontrol'+row_count+'" value="1"> <a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="tax'+row_count+'" id="tax'+row_count+'"><cfoutput query="TAXS"><option value="#TAX#">#TAX#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="tevkifat_beyan_code'+row_count+'" id="tevkifat_beyan_code'+row_count+'" readonly> <span class="input-group-addon btnPointer icon-ellipsis" href="##" onClick=pencere_ac("tevkifat_beyan_code'+row_count+'");></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="tevkifat_code'+row_count+'" id="tevkifat_code'+row_count+'" > <span class="input-group-addon btnPointer icon-ellipsis" href="##" onClick=pencere_ac("tevkifat_code'+row_count+'");></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="tevkifat_code_pur'+row_count+'" id="tevkifat_code_pur'+row_count+'" readonly> <span class="input-group-addon btnPointer icon-ellipsis" href="##" onClick=pencere_ac("tevkifat_code_pur'+row_count+'");></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="tevkifat_beyan_code_pur'+row_count+'" id="tevkifat_beyan_code_pur'+row_count+'" readonly> <span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick=pencere_ac("tevkifat_beyan_code_pur'+row_count+'");></span></div></div>';
	}
	function form_kontrol()
	{
		<cfif session.ep.our_company_info.is_efatura>
			if(document.getElementById('tax_code').value == '')
			{
				alert('Vergi Kodu Seçiniz !');
				return false;
			}
			if(document.getElementById('tevkifat_code').value == '')
			{
				alert('Tevkifat Kodu Seçiniz !');
				return false;
			}	
		</cfif>
		
		var rowcount = document.getElementById('record_num').value;
		if(document.getElementById('counter').value<=0)
		{
			alert("<cf_get_lang no='1515.Önce Satır Kaydı Yapınız'>")
			return false;
		}
		
		if(document.getElementById('statement_rate').value != "")
		{
			var get_tevkifat = wrk_safe_query('set_get_tevf','dsn3',0,filterNum(document.getElementById('statement_rate').value));
			if(get_tevkifat.STATEMENT_RATE != undefined)
			{
				alert("<cf_get_lang no ='1855.Tevkifat Kayıtları Arasında Bu Beyan Oranı Kaydedilmiştir Aynı Beyan Oranını Seçemezsiniz'>");
				return false;
			}
		}
		
		if(document.getElementById('statement_rate').value == "")
		{
			alert("<cf_get_lang no='1517.Lütfen Tevkifat Çarpanı Giriniz'>");
			return false;
		}
		
		for (i=1;i<=rowcount;i++)
		{
			if(eval("document.getElementById('row_kontrol" + i + "')").value == 1)//Silinmemiş ise
			{
				for (y=i+1;y<=rowcount;y++)//KDV satırlarının birbirinden farklı olup olmadığını kontrol ediyor.
				{
					if(eval("document.getElementById('row_kontrol" + y + "')").value == 1)//Karşılatırılan satır silinmemiş ise
					{
						if(eval("document.getElementById('tax" + i + "')").value == eval("document.getElementById('tax" + y + "')").value)
						{
							alert("<cf_get_lang no ='1854.Tevkifat kaydı için her satırda farklı KDV seçilmelidir'>");
							return false;
						}
					}	
				}
				if(eval("document.getElementById('tevkifat_beyan_code" + i + "')").value == "")
				{
					alert("<cf_get_lang no ='1842.Lütfen Tevkifat Beyan Kodu Giriniz'>");
					return false;
				}
				if(eval("document.getElementById('tevkifat_code_pur" + i + "')").value == "")
				{
					alert("<cf_get_lang no ='1841.Lütfen Alış Tevkifat Muhasebe Kodu Giriniz'>");
					return false;
				}
				if(eval("document.getElementById('tevkifat_beyan_code_pur" + i + "')").value=="")
				{
					alert("<cf_get_lang no ='1852.Lütfen Alış Tevkifat Beyan Kodu Giriniz'>");
					return false;
				}
			}
			
			if(eval("document.getElementById('tax" + i + "')").length==0)
			{
				alert("<cf_get_lang no ='1315.KDV Oranlarını Tanımlamadan İşlem Yapamazsınız'>!");
				return false;
			}

		}
		
		x = (50 - document.tax.detail.value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang_main no='1843.Açıklama Bölümüne En Fazla 50 Karakter Girmelisiniz'>");
			return false;
		}
		
		if(document.getElementById('statement_rate').value != '')
		{
			inputstr=document.getElementById('statement_rate').value;
			if(document.getElementById('statement_rate').value.indexOf('/')>0)
			{
					var i = document.getElementById('statement_rate').value.indexOf('/');
					
						//var oneChar = inputstr.substring(i,i+1);
						var temp_ =inputstr-i;
						document.getElementById('statement_rate_numerator').value = inputstr.substring(0,i);
						document.getElementById('statement_rate_denominator').value =  inputstr.substring(i+1,inputstr.length);
			}
			else
			{
				document.tax.statement_rate.value=filterNum(document.tax.statement_rate.value,8);
				document.getElementById('statement_rate_numerator').value = '';
				document.getElementById('statement_rate_denominator').value = '';
				
			}
		}	
	}
	
	function pencere_ac(isim)
	{
		if(document.getElementById(isim).value.length != 0)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id='+isim+'&account_code=' + document.getElementById(isim).value, 'list');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id='+isim, 'list');
	}
</script>
