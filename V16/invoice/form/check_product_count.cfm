<style>
#modalContainer {
	background-color:transparent;
	position:absolute;
	width:100%;
	height:100%;
	top:0px;
	left:0px;
	z-index:10000;
}

#alertBox {
	position:relative;
	width:300px;
	min-height:100px;
	margin-top:50px;
	border:2px solid 000;
	background-color:F2F5F6;
	background-image:url(alert.png);
	background-repeat:no-repeat;
	background-position:20px 30px;
}

#modalContainer > #alertBox {
	position:fixed;
}

#alertBox h1 {
	margin:0;
	font:bold 2em verdana,arial;
	background-color:78919B;
	color:FFF;
	border-bottom:1px solid #000;
	padding:2px 0 2px 5px;
}

#alertBox p {
	font:2em verdana,arial;
	height:50px;
	padding-left:5px;
	margin-left:55px;
}

#alertBox #closeBtn {
	display:block;
	position:relative;
	margin:5px auto;
	padding:3px;
	border:1px solid 000;
	width:70px;
	font:1em verdana,arial;
	text-transform:uppercase;
	text-align:center;
	color:FFF;
	background-color:78919B;
	text-decoration:none;
}
</style>

<cfparam name="attributes.remain_count" default="">
<cfsetting enablecfoutputonly="no">
<cfquery name="GET_ORDER_DETAIL" datasource="#DSN3#">
	SELECT DISTINCT
		ORW.PRODUCT_NAME,
		S.PRODUCT_CODE_2,
		S.BARCOD,
		ORW.STOCK_ID,
		PU.MAIN_UNIT
	FROM 
		ORDER_ROW ORW,
		STOCKS S, 
		PRODUCT_UNIT PU
	WHERE 
		S.STOCK_ID = ORW.STOCK_ID AND
		S.PRODUCT_ID = PU.PRODUCT_ID AND
		ORW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.oid#"> AND
		ORW.ORDER_ROW_CURRENCY = -6 
</cfquery>
<cf_popup_box>
	<form name="check_product_count">
		<cf_medium_list name="table1" id="table1">
			<thead>
				<tr>
					<th width="10"><cf_get_lang dictionary_id ='57487.No'></th>
					<th align="center"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th align="center"><cf_get_lang dictionary_id='57789.Ozel Kod'></th>
					<th align="center"><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
					<th align="center"><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id ='57635.Miktar'></th>
					<th align="center" nowrap="nowrap"><cf_get_lang dictionary_id="59864.İşlenen"></th>
					<th align="center" nowrap="nowrap"><cf_get_lang dictionary_id ='58444.Kalan'></th>
					<th width="5"></th>
					<th align="center" ><cf_get_lang dictionary_id ='57636.Birim'></th>
				</tr>
			</thead>
			<tbody>
		<cfif get_order_detail.recordcount>
				<cfoutput query="get_order_detail">
					<cfquery name="GET_PRODUCT_COUNT" datasource="#DSN3#">
						SELECT 
							SUM(QUANTITY) QUANTITY 
						FROM 
							ORDER_ROW 
						WHERE 
							ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.oid#"> AND
							STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.stock_id#">
					</cfquery>
					<input type="hidden" name="recordcount" id="recordcount" value="#get_order_detail.recordcount#">
					<tr id="frm_row#currentrow#" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
						<td align="center">#currentrow#</td>
						<td style="text-align:right;">#stock_id#&nbsp;</td><input type="hidden" name="stock_id" id="stock_id" value="#stock_id#">
						<td style="text-align:right;">#product_code_2#&nbsp;</td>
						<td style="text-align:right;">&nbsp;#product_name#</td><input type="hidden" name="product_name" id="product_name" value="#product_name#">
						<td style="text-align:right;">#barcod#&nbsp;</td><input type="hidden" name="barcod" id="barcod" value="#barcod#">
						<td align="center">#get_product_count.quantity#</td><input type="hidden" name="total_quantity" id="total_quantity" value="#get_product_count.quantity#" style="font-size:14px;">
						<td style="text-align:right;" width="50" style="color:FF0000"><input type="text" name="process_count" id="process_count" value="0" class="box" readonly="true" style="width:50px;font-size:14px;"></td>
						<td width="50" style="text-align:right;"><input type="text" name="remain_count" id="remain_count" value="#get_product_count.quantity#" class="box" readonly="true" style="width:50px;font-size:14px;"></td>
						<td align="center" valign="middle">
							<img src="images/plus_16.png" border="0" onclick="add_product(#currentrow#)">
							<img src="images/minus_16.png" border="0" onclick="del_product(#currentrow#)">
						</td>
						<td align="center">#main_unit#</td>
					</tr>
				</cfoutput>
			</tbody>
			<table name="table1" id="table1" width="98%" align="center" class="color-border" border="0" cellpadding="0" cellspacing="1">
				<tr class="color-row">
					<td width="81">&nbsp;<cf_get_lang dictionary_id="57633.BARKOD"></td>
					<td>&nbsp;<input type="text" name="barcod_no" id="barcod_no" value=""  onkeydown="if(event.keyCode == 13) {check_barkod();}" style="text-align:right;"></td>
				</tr>
			</table>
		</cfif>
		</cf_medium_list>
	</form>
	<cf_popup_box_footer>
		<table name="table1" id="table1" width="98%" align="center" border="0" cellpadding="0" cellspacing="1">
			<tr>
				 <td style="text-align:right;"><cf_workcube_buttons type_format='1' is_delete='1' is_upd='1' add_function='check_count()' del_function='clear_count()' del_info='Temizle' insert_info='Kaydet'></td> 
			</tr>
		</table>
	</cf_popup_box_footer>
</cf_popup_box>
<script type="text/javascript">
document.getElementById('barcod_no').focus();
	// constants to define the title of the alert and button text.
	var ALERT_TITLE = "Hata!";
	var ALERT_BUTTON_TEXT = "Kapat";
	
	// over-ride the alert method only if this a newer browser.
	// Older browser will see standard alerts
	if(document.getElementById) {
	  window.alert = function(txt) {
		createCustomAlert(txt);
	  }
	}
	
	function createCustomAlert(txt) {
	document.getElementById("barcod_no").disabled = true;

	  // shortcut reference to the document object
	  d = document;
	
	  // if the modalContainer object already exists in the DOM, bail out.
	  if(d.getElementById("modalContainer")) return;
	
	  // create the modalContainer div as a child of the BODY element
	  mObj = d.getElementsByTagName("body")[0].appendChild(d.createElement("div"));
	  mObj.id = "modalContainer";
	   // make sure its as tall as it needs to be to overlay all the content on the page
	  mObj.style.height = document.documentElement.scrollHeight + "px";
	
	  // create the DIV that will be the alert 
	  alertObj = mObj.appendChild(d.createElement("div"));
	  alertObj.id = "alertBox";
	  // MSIE doesnt treat position:fixed correctly, so this compensates for positioning the alert
	  if(d.all && !window.opera) alertObj.style.top = document.documentElement.scrollTop + "px";
	  // center the alert box
	  alertObj.style.left = (d.documentElement.scrollWidth - alertObj.offsetWidth)/2 + "px";
	
	  // create an H1 element as the title bar
	  h1 = alertObj.appendChild(d.createElement("h1"));
	  h1.appendChild(d.createTextNode(ALERT_TITLE));
	
	  // create a paragraph element to contain the txt argument
	  msg = alertObj.appendChild(d.createElement("p"));
	  msg.innerHTML = txt;
	  
	  // create an anchor element to use as the confirmation button.
	  btn = alertObj.appendChild(d.createElement("a"));
	  btn.id = "closeBtn";
	  btn.appendChild(d.createTextNode(ALERT_BUTTON_TEXT));
	  btn.href = "#";
	  // set up the onclick event to remove the alert when the anchor is clicked
	  btn.onclick = function() { removeCustomAlert();return false; }
	}
	
	// removes the custom alert from the DOM
	function removeCustomAlert() 
	{
		document.getElementsByTagName("body")[0].removeChild(document.getElementById("modalContainer"));
		document.getElementById("barcod_no").disabled = false;
		document.getElementById("barcod_no").select();
	}
	
	function clear_count()
	{
		var loopcount =document.getElementById("recordcount").value;
		var row = 0	
		
		if(loopcount == 1)
		{
			document.getElementById('process_count').value = 0;
		}
		else
		{
			for(var k=0;k<loopcount;k++)
			{
				document.check_product_count.process_count[k].value = 0;
				document.check_product_count.remain_count[k].value = document.check_product_count.total_quantity[k].value;
			}
		}
	}
	
	function add_product(row_id)
	{
		var loopcount =document.getElementById("recordcount").value;
		var row_ = row_id-1	
		
		if(loopcount == 1)
		{
			document.getElementById('barcod_no').value = document.getElementById('barcod').value;
		}
		else
		{
			document.getElementById('barcod_no').value = document.check_product_count.barcod[row_].value;
		}
		check_barkod();
	}
	function del_product(row_id)
	{
		var loopcount =document.getElementById("recordcount").value;
		var row_ = row_id-1	
		
		if(loopcount == 1)
		{
			if(document.check_product_count.remain_count.value == 0)
			{
				document.getElementById('frm_row1').style.backgroundColor = 'F4F9FD';
			}
			document.getElementById('process_count').value = --document.getElementById('process_count').value;
			document.getElementById('remain_count').value = ++document.getElementById('remain_count').value;
			if(document.getElementById('process_count').value < 0)
			{
				document.getElementById('process_count').value = ++document.getElementById('process_count').value;
				document.getElementById('remain_count').value = --document.getElementById('remain_count').value;
			}
		}
		else
		{
			if(document.check_product_count.remain_count[row_].value == 0)
			{
				document.getElementById('frm_row'+row_id).style.backgroundColor = 'F4F9FD';
			}
			document.check_product_count.process_count[row_].value = --document.check_product_count.process_count[row_].value;
			document.check_product_count.remain_count[row_].value = ++document.check_product_count.remain_count[row_].value;
			if(document.check_product_count.process_count[row_].value < 0)
			{
				document.check_product_count.process_count[row_].value = ++document.check_product_count.process_count[row_].value;
				document.check_product_count.remain_count[row_].value = --document.check_product_count.remain_count[row_].value;
			}
		}
	}

	function check_barkod()
	{
		document.check_product_count.barcod_no.focus();
		var loopcount = document.getElementById("recordcount").value;
		var row = 0	
		
		if(loopcount == 1)
		{
			if(document.getElementById("barcod_no").value == document.check_product_count.barcod.value)
				{
					var row = 1
					document.check_product_count.process_count.value = ++document.check_product_count.process_count.value;
	
					document.check_product_count.remain_count.value = --document.check_product_count.remain_count.value;
					if(document.check_product_count.remain_count.value <0)
					{
						alert("<cf_get_lang dictionary_id='59865.Sepete Fazla Ürün Eklediniz'>");
						document.check_product_count.remain_count.value = ++document.check_product_count.remain_count.value;
						document.check_product_count.process_count.value = --document.check_product_count.process_count.value;
					}
					if(document.check_product_count.remain_count.value == 0)
					{
						document.getElementById('frm_row1').style.backgroundColor = '33CC00';
					}
				}
		}
		else
		{
			for(var k=0;k<loopcount;k++)
			{
				if(document.getElementById("barcod_no").value == document.check_product_count.barcod[k].value)
				{
					var row = 1
					document.check_product_count.process_count[k].value = ++document.check_product_count.process_count[k].value;
	
					document.check_product_count.remain_count[k].value = --document.check_product_count.remain_count[k].value;
					if(document.check_product_count.remain_count[k].value <0)
					{
						alert("<cf_get_lang dictionary_id='59865.Sepete Fazla Ürün Eklediniz'>");
						document.check_product_count.remain_count[k].value = ++document.check_product_count.remain_count[k].value;
						document.check_product_count.process_count[k].value = --document.check_product_count.process_count[k].value;
					}
					if(document.check_product_count.remain_count[k].value == 0)
					{
						var r = k+1;
						document.getElementById('frm_row'+r).style.backgroundColor = '33CC00';
					}
					
				}
			}
		}
		if(row == 0)
		{
			alert("<cf_get_lang dictionary_id='59866.Siparişte Olmayan bir Ürün Eklediniz'> !");
		}
		
		document.getElementById("barcod_no").value = '';
		document.getElementById('barcod_no').focus();
	}
	
	function check_count()
	{
		var loopcount =document.getElementById("recordcount").value;
		var remain_count =',';
		var stock_id_ = ',';
		var submit_ = 1;
		if(loopcount == 1)
		{
			if(document.check_product_count.process_count.value != document.check_product_count.total_quantity.value)
				{
				if(confirm("<cf_get_lang dictionary_id='59867.Sepete Eksik Ürün Eklediniz'> !! \n <cf_get_lang dictionary_id='59868.Eksik Ürünleri Sonraki Siparişe Eklemek İstiyormusunuz'> ?")) 
					{	
					document.check_product_count.remain_count.disabled = false;
					return true; 
					}
				else 
					return false;
				}
		}
		else
		{
			for(var i=0;i<loopcount;i++)
			{
				
				if(document.check_product_count.process_count[i].value != document.check_product_count.total_quantity[i].value)
					{
					if(confirm(document.check_product_count.product_name[i].value+ "<cf_get_lang dictionary_id='59867.Ürünü Eksik Eklediniz'> !! \n <cf_get_lang dictionary_id='59868.Eksik Ürünleri Sonraki Siparişe Eklemek İstiyormusunuz'> ?")) 
						{	
						document.check_product_count.remain_count[i].disabled = false;
						remain_count = remain_count + document.check_product_count.remain_count[i].value + ',';
						stock_id_ = stock_id_ + document.check_product_count.stock_id[i].value + ',';
						submit_ = 1;
						}
					else 
						return false;
					}
			}
		}
		if(submit_ == 1)
			{		
			document.location = "<cfoutput>#request.self#?fuseaction=invoice.emptypopup_check_product_count&remain="+ remain_count + "&stcid=" + stock_id_ + "+&oid=#attributes.oid#</cfoutput>";
			return true; 
			}
		else
			return false;
	}
</script>
