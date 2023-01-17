<cf_get_lang_set module_name="account">
<cfquery name="get_account_refl_def" datasource="#dsn2#">
	SELECT
    	*
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">  
        AND CLOSED_ACCOUNT_CODE IS NOT NULL
</cfquery>
<cfquery name="get_account_closed_def" datasource="#dsn2#">
	SELECT
    	*
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">  
        AND CLOSED_ACCOUNT_CODE IS NULL 
        AND INCOME = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
</cfquery>
<cfquery name="get_account_closed_def1" datasource="#dsn2#">
	SELECT
    	*
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">  
        AND CLOSED_ACCOUNT_CODE IS NULL  
        AND INCOME = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>
<script type="text/javascript">
	$(document).ready(function(){
		rowCount1 = 10;
		rowCount2 = 10;
		rowCount3 = 10;		
	});
	function kontrol()
	{		
		//gider hesaplarının yansıtmaları
		var myArray_closed1 = [];
		var myArray_claim1 = [];	
		for(var m = 1; m <= rowCount1; m++)
		{
			var closed1 = document.getElementById('acc_code1_closed_'+m).value;
			var claim1 = document.getElementById('acc_code1_claim_'+m).value;
			var debt1 = document.getElementById('acc_code1_debt_'+m).value;
			if((closed1 != '' || claim1 != '' || debt1 != '') && (closed1 == '' || claim1 == '' || debt1 == '')) //bir tanesi doluysa ama hepsi dolu değilse
			{
				alert('Eksik alan !');	
				return false;
			}
			if(closed1 != '')
				myArray_closed1.push(closed1);
			if(claim1 != '')
				myArray_claim1.push(claim1);	
		}
		
		uniqueArray_closed1 = myArray_closed1.filter(function(elem, pos) {
    		return myArray_closed1.indexOf(elem) == pos;})	


		uniqueArray_claim1 = myArray_claim1.filter(function(elem, pos) {
    		return myArray_claim1.indexOf(elem) == pos;})		

		
		//yansıtmaların kapatılması
		var myArray_claim2 = [];	
		for(var n = 1; n <= rowCount2; n++)
		{
			var claim2 = document.getElementById('acc_code2_claim_'+n).value;
			var debt2 = document.getElementById('acc_code2_debt_'+n).value;
			if((claim2 != '' || debt2 != '') && (claim2 == '' || debt2 == '')) //bir tanesi doluysa ama hepsi dolu değilse
			{
				alert('Eksik alan !');	
				return false;
			}
			if(claim2 != '')
				myArray_claim2.push(claim2);
		}
		uniqueArray_claim2 = myArray_claim2.filter(function(elem, pos) {
    		return myArray_claim2.indexOf(elem) == pos;})		
			
		//gider hesaplarının yansıtmalarında alt hesabı olan alacaklı ve borçlu hesaplar seçilemez
		
		for(var k = 1; k <= rowCount1; k++)
		{
			get_claim_subaccount_1 = wrk_query("SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE LIKE '" +document.getElementById('acc_code1_claim_'+k).value+ ".%'","dsn2");
			if(get_claim_subaccount_1.recordcount)	
			{
				alert('Gider hesaplarının yansıtmalarında alt hesabı olan alacaklı hesap seçilemez : ' + document.getElementById('acc_code1_claim_'+k).value);
				return false;	
			}
			get_debt_subaccount_1 = wrk_query("SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE LIKE '" +document.getElementById('acc_code1_debt_'+k).value+ ".%'","dsn2");
			if(get_debt_subaccount_1.recordcount)	
			{ 
				alert('Gider hesaplarının yansıtmalarında alt hesabı olan borçlu hesap seçilemez : ' + document.getElementById('acc_code1_debt_'+k).value);
				return false;	
			}
			
		}
		for(var j = 1; j <= rowCount2; j++)
		{
			get_claim_subaccount_2 = wrk_query("SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE LIKE '" +document.getElementById('acc_code2_claim_'+j).value+ ".%'","dsn2");
			if(get_claim_subaccount_2.recordcount)	
			{
				alert('Yansıtmaların kapanmasında alt hesabı olan alacaklı hesap seçilemez : ' + document.getElementById('acc_code2_claim_'+j).value);
				return false;	
			}
		}
		return true;
	}

	function addRow1()
	{
		rowCount1++;
		add_acc.rowCount1.value = rowCount1;
		var newRow1;
		var newCell1;
		newRow1 = document.getElementById("table_list_1").insertRow(document.getElementById("table_list_1").rows.length);
		newRow1.setAttribute("id", "myRow1_"+rowCount1);
		
		newCell1 = newRow1.insertCell(newRow1.cells.length);
		newCell1.innerHTML = '<a href="javascript://" onClick="delRow1(' + rowCount1 + ');"><img src="/images/delete_list.gif"></a>';

		newCell1 = newRow1.insertCell(newRow1.cells.length);
		newCell1.innerHTML =  '<input type="text" style="width:92%;" class="kapanis" name="acc_code1_closed_' + rowCount1 + '" id="acc_code1_closed_' + rowCount1 + '" onFocus="auto_acc_code(' + rowCount1 + ',1,\'closed\');" onblur="deneme2('+rowCount1+');" autocomplete="off" onchange="kapanisFunction(\'acc_code1_closed_' + rowCount1+');"> <a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_closed_'+rowCount1+'&field_id2=add_acc.acc_code1_claim_'+rowCount1+'&changeFunction=kapanisFunction&changeFunctionParam=acc_code1_closed_'+rowCount1+'&changeFunctionParam2='+rowCount1+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0"></a>';   

		newCell1 = newRow1.insertCell(newRow1.cells.length);
		newCell1.innerHTML =  '<input type="text" style="width:92%;" class="alacaklar" name="acc_code1_claim_' + rowCount1 + '" id="acc_code1_claim_' + rowCount1 + '" onFocus="auto_acc_code(' + rowCount1 + ',1,\'claim\');" autocomplete="off" onchange="alacakFunction(\'acc_code1_claim_' + rowCount1+');"> <a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code1_claim_'+rowCount1+'&changeFunction=kapanisFunction&changeFunctionParam=acc_code1_claim_'+rowCount1+'&changeFunctionParam2='+rowCount1+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0"></a>';   

		newCell1 = newRow1.insertCell(newRow1.cells.length);
		newCell1.innerHTML =  '<input type="text" style="width:92%;" name="acc_code1_debt_' + rowCount1 + '" id="acc_code1_debt_' + rowCount1 + '" onFocus="auto_acc_code(' + rowCount1 + ',1,\'debt\');" onblur="deneme('+rowCount1+');" autocomplete="off"> <a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc.acc_code1_debt_'+rowCount1+'&field_id2=add_acc.acc_code2_claim_'+rowCount1+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0"></a>';   
		
		
		rowCount2++;
		add_acc.rowCount2.value = rowCount2;
		var newRow2;
		var newCell2;
		newRow2 = document.getElementById("table_list_2").insertRow(document.getElementById("table_list_2").rows.length);
		newRow2.setAttribute("id", "myRow2_"+rowCount2);
		
		newCell2 = newRow2.insertCell(newRow2.cells.length);
		newCell2.innerHTML = '<a href="javascript://" onClick="delRow2(' + rowCount2 + ');"><img src="/images/delete_list.gif"></a>';
		
		newCell2 = newRow2.insertCell(newRow2.cells.length);
		newCell2.innerHTML =  '<input type="text" style="width:95%;" name="acc_code2_claim_' + rowCount2 + '" id="acc_code2_claim_' + rowCount2 + '" onFocus="auto_acc_code(' + rowCount2 + ',2,\'claim\');" autocomplete="off"> <a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code2_claim_'+rowCount2+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0"></a>';

		newCell2 = newRow2.insertCell(newRow2.cells.length);
		newCell2.innerHTML =  '<input type="text" style="width:96%;" name="acc_code2_debt_' + rowCount2 + '" id="acc_code2_debt_' + rowCount2 + '" onblur="deneme1('+rowCount2+');" onFocus="auto_acc_code(' + rowCount2 + ',2,\'debt\');" autocomplete="off"><a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc.acc_code2_debt_'+rowCount2+'&field_id2=add_acc.acc_code3_claim_'+rowCount2+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0"></a>';
		
		
		rowCount3++;
		add_acc.rowCount3.value = rowCount3;
		var newRow3;
		var newCell3;
		newRow3 = document.getElementById("table_list_3").insertRow(document.getElementById("table_list_3").rows.length);
		newRow3.setAttribute("id", "myRow3_"+rowCount3);
		
		newCell3 = newRow3.insertCell(newRow3.cells.length);
		newCell3.innerHTML = '<a href="javascript://" onClick="delRow3(' + rowCount3 + ');"><img src="/images/delete_list.gif"></a>';
		
		newCell3 = newRow3.insertCell(newRow3.cells.length);
		newCell3.innerHTML =  '<input type="text" style="width:95%;" name="acc_code3_claim_' + rowCount3 + '" id="acc_code3_claim_' + rowCount3 + '" onFocus="auto_acc_code(' + rowCount3 + ',3,\'claim\');" autocomplete="off"> <a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=add_acc.acc_code3_claim_'+rowCount3+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0"></a>';

		newCell3 = newRow3.insertCell(newRow3.cells.length);
		newCell3.innerHTML =  '<input type="text" style="width:95%;" name="acc_code3_debt_' + rowCount3 + '" id="acc_code3_debt_' + rowCount3 + '" onFocus="auto_acc_code(' + rowCount3 + ',3,\'debt\');" autocomplete="off">  <a href="javascript://" onclick="windowopen(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_acc.acc_code3_debt_'+rowCount3+'\',\'list\');"><img src="/images/plus_thin.gif" align="top" border="0"></a>';
		
	}
	function delRow1(row)
	{
		document.getElementById('acc_code1_closed_'+row).value = '';
		document.getElementById('acc_code1_claim_'+row).value = '';
		document.getElementById('acc_code1_debt_'+row).value = '';
		document.getElementById('myRow1_'+row).style.display = 'none';
		//rowCount1--;
	}
	function delRow2(row)
	{
		document.getElementById('acc_code2_claim_'+row).value = '';
		document.getElementById('acc_code2_debt_'+row).value = '';
		document.getElementById('myRow2_'+row).style.display = 'none';
		//rowCount2--;
	}
	function delRow3(row)
	{
		document.getElementById('acc_code3_claim_'+row).value = '';
		document.getElementById('acc_code3_debt_'+row).value = '';
		document.getElementById('myRow3_'+row).style.display = 'none';
		//rowCount3--;
	}
	function auto_acc_code(no,table,num)
	{	
		/*if((table == 1 && (num == 'claim' || num == 'debt')) || (table == 2 && num == 'claim'))
			AutoComplete_Create('acc_code'+table+'_'+num+'_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','CODE_NAME','','','3','250');
		else*/
			AutoComplete_Create('acc_code'+table+'_'+num+'_'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','CODE_NAME','','','3','250');
	}
	
	function deneme(row)
	{
		document.getElementById("acc_code2_claim_"+row).value = document.getElementById("acc_code1_debt_"+row).value;
	}
	
	function deneme1(row)
	{
		document.getElementById("acc_code3_claim_"+row).value = document.getElementById("acc_code2_debt_"+row).value;
	}
	function deneme2(row)
	{
		document.getElementById("acc_code1_claim_"+row).value = document.getElementById("acc_code1_closed_"+row).value;
	}
	
	function kapanisFunction(inputID,satir){
		inputValue = $("#"+inputID).val();
		$(".kapanis").each(function(index) {
			if($(this).val() == inputValue && satir!=(index+1))
			{
				alert('Seçmiş olduğunuz değer '+(index+1)+'.satırda mevcuttur. Seçiminizi yenileyiniz.');
				$("#"+inputID).val('');
				$("#acc_code1_claim_"+satir).val('');
				return false;
			}
		});
		
	}
	function alacakFunction(inputID,satir){
		inputValue = $("#"+inputID).val();
		$(".alacaklar").each(function(index) {
			if($(this).val() == inputValue && satir!=(index+1))
			{
				alert('Seçmiş olduğunuz değer '+(index+1)+'.satırda mevcuttur. Seçiminizi yenileyiniz.');
				$("#"+inputID).val('');
				return false;
			}
		});
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'addUpd';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['addUpd'] = structNew();
	WOStruct['#attributes.fuseaction#']['addUpd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addUpd']['fuseaction'] = 'account.form_add_reflecting_acc_def';
	WOStruct['#attributes.fuseaction#']['addUpd']['filePath'] = 'account/form/form_add_reflecting_account_definition.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['queryPath'] = 'account/query/add_reflecting_account_definition.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['nextEvent'] = 'account.form_add_reflecting_acc_def';
	WOStruct['#attributes.fuseaction#']['addUpd']['Identity'] = '';
	
</cfscript>
