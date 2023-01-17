<cfinclude template="../query/get_purchase_general.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_units.cfm">
<cfset ROW=GET_PURCHASE_GENERAL_PREMIUM.RecordCount>
<cfform method="POST" name="form_basket" action="#request.self#?fuseaction=contract.emptypopup_upd_purchase_general&contract_id=#attributes.contract_id#">
<cfoutput><input name="CONTRACT_ID" id="CONTRACT_ID" type="hidden" value="#attributes.CONTRACT_ID#"></cfoutput>
<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#row#</cfoutput>">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr class="color-border">
      <td valign="top"> 
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
  <tr class="color-list">
    <td class="headbold" height="35">&nbsp;<cf_get_lang no='9.Genel Koşullar'></td>
  </tr>
  <tr class="color-row">
    <td valign="top">
		<table name="table1" id="table1">
			<tr>
				<td colspan="6" class="txtboldblue"><cf_get_lang no='30.Satınalma Genel Ciro Primleri (ay, 3 ay ve yıl olmak üzere ciro primi fatura emri oluşur)'></td>
			</tr>
			<tr class="txtbold">
				<td><input type="button" class="eklebuton" title="" onClick="add_row();"></td>
				<td><cf_get_lang no='17.Periyod'></td>
				<td><cf_get_lang no='193.Koşul/Ciro'></td>
				<td><cf_get_lang_main no='77.Para Birimi'></td>
				<td><cf_get_lang dictionary_id="48240.Prim Tipi"></td>
				<td><cf_get_lang no='20.Prim'></td>
			</tr>
			<cfoutput query="GET_PURCHASE_GENERAL_PREMIUM">
				<input  type="hidden"  value="1"  name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
				<cfset GET_PURCHASE_GENERAL_PREMIUM_MONEY = MONEY>
				<tr id="frm_row#currentrow#">
				  <td style="cursor:pointer"><a style="cursor:pointer" onclick="sil(#currentrow#);" ><img  src="images/delete_list.gif" border="0"></a></td>
				  <td>
					<select name="PERIOD#currentrow#" id="PERIOD#currentrow#" style="width:60" >
					  <option value="1" <cfif PERIOD IS 1>selected</cfif>><cf_get_lang_main no='1312.Ay'></option>
					  <option value="2" <cfif PERIOD IS 2>selected</cfif>>3 <cf_get_lang_main no='1312.Ay'></option>
					  <option value="3" <cfif PERIOD IS 3>selected</cfif>><cf_get_lang_main no='1043.Yıl'></option>
					</select>
				  </td>
				  <td><input type="text" name="TUTAR1#currentrow#"  id="number#currentrow#" style="width:125px;" value="#TLFormat(TUTAR1)#" onkeyup="return(FormatCurrency(this,event));"></td>
				  <td>
					<select name="MONEY#currentrow#" id="MONEY#currentrow#" style="width:60" >
					  <cfloop query="get_moneys">
						<option value="#get_moneys.MONEY#" <cfif GET_PURCHASE_GENERAL_PREMIUM_MONEY IS get_moneys.MONEY>selected</cfif>>#get_moneys.MONEY#
					  </cfloop>
					</select>
				  </td>
				  <td>
					<select name="PREMIUM_TYPE_RATE_AMOUNT#currentrow#" id="PREMIUM_TYPE_RATE_AMOUNT#currentrow#" style="width:60" >
					  <option value="0" <cfif PREMIUM_TYPE_RATE_AMOUNT IS 0>selected</cfif>><cf_get_lang dictionary_id="47476.Yüzde"></option>
					  <option value="1" <cfif PREMIUM_TYPE_RATE_AMOUNT IS 1>selected</cfif>><cf_get_lang dictionary_id="57673.Tutar"></option>
					</select>
				  </td>
				  <td>
					<input type="text" name="PREMIUM#currentrow#" id="PREMIUM#currentrow#" style="width:70px;" value="#TLFormat(PREMIUM)#" onkeyup="return(FormatCurrency(this,event));" >
				  </td>
				</tr>
			</cfoutput>
		</table>
<br/>
<table >
  <tr>
    <td colspan="3" class="txtboldblue"><cf_get_lang no='192.Satınalma Standart Ödemeler(yıllık sistem ve genel katılım ilk anlaşma ve her yıl fatura emrine dönüşür)'></td>
  </tr>
  <tr class="txtbold">
    <td></td>
    <td><cf_get_lang no='24.Bedel'></td>
    <td><cf_get_lang_main no='77.Para Birimi'></td>
  </tr>
  <tr>
    <td><cf_get_lang no='25.Genel Katılım Bedeli'></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='25.Genel Katılım Bedeli !'></cfsavecontent>
	<cfinput type="text" name="GENERAL_JOIN" validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" style="width:110px;" value="#TLFormat(GET_PURCHASE_RETAIL.GENERAL_JOIN)#"></td>
    <td><select name="GENERAL_JOIN_MONEY" id="GENERAL_JOIN_MONEY" style="width:60">
		<cfoutput query="get_moneys">
		<option value="#MONEY#" <cfif GET_PURCHASE_RETAIL.recordCount>
			<cfif GET_PURCHASE_RETAIL.GENERAL_JOIN_MONEY IS MONEY>selected</cfif>
			<cfelse>
			<cfif session.ep.MONEY IS MONEY>selected</cfif>
			</cfif>>#MONEY#
		</cfoutput>
    </select></td>
  </tr>
  <tr>
    <td><cf_get_lang no='26.Yıllık Sistem Kullanım Bedeli'></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='26.Yıllık Sistem Kullanım Bedeli !'></cfsavecontent>
	<cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" type="text" name="YEARLY_USE" style="width:110px;" value="#TLFormat(GET_PURCHASE_RETAIL.YEARLY_USE)#"></td>
    <td><select name="YEARLY_USE_MONEY" id="YEARLY_USE_MONEY" style="width:60">
		<cfoutput query="get_moneys">
		<option value="#MONEY#" <cfif GET_PURCHASE_RETAIL.recordCount> 
									<cfif GET_PURCHASE_RETAIL.YEARLY_USE_MONEY IS MONEY>selected</cfif>
								<cfelse>
									<cfif session.ep.MONEY IS MONEY>selected</cfif>
								</cfif>>#MONEY#
		</cfoutput>
    </select></td>
  </tr>
  <tr>
    <td><cf_get_lang no='27.Mağaza Giriş Bedeli'></td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='27.Mağaza Giriş Bedeli !'></cfsavecontent>
	<cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" type="text" name="ENTRANCE" style="width:110px;" value="#TLFormat(GET_PURCHASE_RETAIL.ENTRANCE)#"></td>
    <td><select name="ENTRANCE_MONEY" id="ENTRANCE_MONEY" style="width:60">
		<cfoutput query="get_moneys">
		<option value="#MONEY#" <cfif GET_PURCHASE_RETAIL.recordCount>  		
			<cfif GET_PURCHASE_RETAIL.ENTRANCE_MONEY IS MONEY>selected</cfif>
		<cfelse>
			<cfif session.ep.MONEY IS MONEY>selected</cfif>
		</cfif>>#MONEY#
		</cfoutput>
    </select></td>
  </tr>
</table>
<br/>
<table >
  <tr>
    <td colspan="2" class="txtboldblue">
	<cf_get_lang no='190.Satınalma Vade ve Süre Koşulları (ödemelerle ilişkilendirilecek)'></td>
  </tr>
    <tr>
    <td></td>
  </tr>
  <tr>
    <td><cf_get_lang no='189.Normal Vade (gün)'></td>
    <td><input type="text" name="NORMAL_DUE" id="NORMAL_DUE" style="width:70" value="<cfoutput>#GET_PURCHASE_DUE.NORMAL_DUE#</cfoutput>">
    </td>
  </tr>
  <tr>
    <td><cf_get_lang no='188.Ek Vade (gün)'></td>
    <td><input type="text" name="EXTRA_DUE" id="EXTRA_DUE" style="width:70" value="<cfoutput>#GET_PURCHASE_DUE.EXTRA_DUE#</cfoutput>">
    </td>
  </tr>
  <tr>
    <td><cf_get_lang no='187.Peşine Mal Alım Vadesi (gün)'></td>
    <td><input type="text" name="CASH_PROPERTY_DUE" id="CASH_PROPERTY_DUE" style="width:70" value="<cfoutput>#GET_PURCHASE_DUE.CASH_PROPERTY_DUE#</cfoutput>">
    </td>
  </tr>
  <tr>
    <td><cf_get_lang no='186.Açılış Vadesi (gün)'></td>
    <td><input type="text" name="OPENING_DUE" id="OPENING_DUE" style="width:70" value="<cfoutput>#GET_PURCHASE_DUE.OPENING_DUE#</cfoutput>"></td>
  </tr>
  <tr>
    <td><cf_get_lang no='184.Yeni Liste Uygulama Süresi (gün sonra)'></td>
    <td><input type="text" name="NEW_LIST_DUE" id="NEW_LIST_DUE" style="width:70" value="<cfoutput>#GET_PURCHASE_DUE.NEW_LIST_DUE#</cfoutput>"></td>
  </tr>
</table>
<br/>
<table>
  <tr>
    <td colspan="3" class="txtboldblue"><cf_get_lang no='183.Satınalma Fiziki ve Teslimat Koşullar(satınalma alış emrinde kullanıcıya gösterilecek)'></td>
  </tr>
  <tr>
    <td width="150"><cf_get_lang_main no='1037.Teslim Yeri'></td>
    <td><input type="checkbox" name="IS_CENTRAL_STORE" id="IS_CENTRAL_STORE" value="checkbox" <cfif GET_PURCHASE_PHYSICAL.IS_CENTRAL_STORE IS 1>checked</cfif>>
      <cf_get_lang no='182.Merkez Depo'></td>
    <td><input type="checkbox" name="IS_ALL_STORE" id="IS_ALL_STORE" value="checkbox" <cfif GET_PURCHASE_PHYSICAL.IS_ALL_STORE IS 1>checked</cfif>>
      <cf_get_lang_main no='1698.Tüm Şubeler'></td>
  </tr>
  <tr>
    <td><cf_get_lang no='180.Teslim Süresi (siparişten sonra)'></td>
    <td><input type="text" name="DELIVERY_DATE" id="DELIVERY_DATE" style="width:60" value="<cfoutput>#GET_PURCHASE_PHYSICAL.DELIVERY_DATE#</cfoutput>">
      <cf_get_lang_main no='78.Gün'> </td>
    <td><input type="text" name="DELIVERY_TIME" id="DELIVERY_TIME" style="width:60" value="<cfoutput>#GET_PURCHASE_PHYSICAL.DELIVERY_TIME#</cfoutput>">
      <cf_get_lang_main no='79.Saat'></td>
  </tr>
  <tr>
    <td><cf_get_lang no='178.Tatil ve Özel Günlerde Sipariş ve Teslimat'></td>
    <td><input type="radio" name="IS_ORDER_ACCEPTABLE" id="IS_ORDER_ACCEPTABLE" value="1" <cfif GET_PURCHASE_PHYSICAL.IS_ORDER_ACCEPTABLE IS 1>checked</cfif>>
      <cf_get_lang no='37.Sipariş Kabul Edilir'><br/>
      <input type="radio" name="IS_ORDER_ACCEPTABLE" id="IS_ORDER_ACCEPTABLE" value="0"  <cfif GET_PURCHASE_PHYSICAL.IS_ORDER_ACCEPTABLE IS 0>checked</cfif>>
      <cf_get_lang no='38.Sipariş Kabul Edilmez'></td>
    <td><input type="radio" name="IS_SHIPPING_ACCEPTABLE" id="IS_SHIPPING_ACCEPTABLE" value="1" <cfif GET_PURCHASE_PHYSICAL.IS_SHIPPING_ACCEPTABLE IS 1>checked</cfif>>
      <cf_get_lang no='39.Sevkiyat Yapılır'><br/>
      <input type="radio" name="IS_SHIPPING_ACCEPTABLE" id="IS_SHIPPING_ACCEPTABLE" value="0" <cfif GET_PURCHASE_PHYSICAL.IS_SHIPPING_ACCEPTABLE IS 0>checked</cfif>>
      <cf_get_lang no='40.Sevkiyat Yapılmaz'></td>
  </tr>
  <tr>
    <td><cf_get_lang_main no='1621.İade'></td>
    <td><input type="checkbox" name="IS_CUSTOMER_COMPLAINT" id="IS_CUSTOMER_COMPLAINT" value="checkbox" <cfif GET_PURCHASE_PHYSICAL.IS_CUSTOMER_COMPLAINT IS 1>checked</cfif>>
      <cf_get_lang no='177.Müşteri Şikayeti'></td>
    <td><input type="checkbox" name="IS_PRODUCTION_FAULT" id="IS_PRODUCTION_FAULT" value="checkbox" <cfif GET_PURCHASE_PHYSICAL.IS_PRODUCTION_FAULT IS 1>checked</cfif>>
      <cf_get_lang no='176.Üretim Hataları'></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="checkbox" name="IS_RETURN_INVOICE" id="IS_RETURN_INVOICE" value="checkbox" <cfif GET_PURCHASE_PHYSICAL.IS_RETURN_INVOICE IS 1>checked</cfif>>
      <cf_get_lang no='175.İade Faturası ile'></td>
    <td>&nbsp;</td>
  </tr>

</table>
<table width="100%">
   <tr>
    <td width="194"><cf_get_lang no='42.Ambalaj'></td>
    <td colspan="2">
		<cfoutput query="get_units">
		&nbsp;<input type="checkbox" name="PACKAGE_UNIT" id="PACKAGE_UNIT" value="#UNIT_ID#" <cfif ListFind(GET_PURCHASE_PHYSICAL.PACKAGE_UNIT,UNIT_ID) neq 0>checked</cfif>>#UNIT#
		</cfoutput>
	</td>
  </tr>
    <tr>
    <td height="35">&nbsp;</td>
    <td colspan="3" align="center">
	<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
	</td>
  </tr>
</table>
	</td>
  </tr>
</table>
	</td>
  </tr>
</table>
</cfform>
<script type="text/javascript">
	row_count=<cfoutput>#ROW#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol"+sy);
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
			row_count++;
			var newRow;
			var newCell;
			
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
						
			document.form_basket.record_num.value=row_count;
			
			newCell = newRow.insertCell();
			newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';	
			newCell = newRow.insertCell();
			newCell.innerHTML = '<select name="PERIOD' + row_count + '"  style="width:60px;"><option value="1"><cf_get_lang_main no='1312.Ay'></option><option value="2">3 <cf_get_lang_main no='1312.Ay'></option><option value="3"><cf_get_lang_main no='1043.Yıl'></option></select>';
			newCell = newRow.insertCell();
			newCell.innerHTML = '<input type="text" name="TUTAR1' + row_count + '" onkeyup="return(FormatCurrency(this,event));" style="width:125px;">';
			newCell = newRow.insertCell();
			newCell.innerHTML = '<select name="MONEY' + row_count + '" style="width:60px;"><cfoutput query="get_moneys"><option value="#MONEY#">#money#</option></cfoutput></select>';
			newCell = newRow.insertCell();
			newCell.innerHTML = '<select name="PREMIUM_TYPE_RATE_AMOUNT' + row_count + '"  style="width:60px;"><option value="0">Yüzde</option><option value="1">Tutar</option></select>';
			newCell = newRow.insertCell();
			newCell.innerHTML = '<input type="text" name="PREMIUM' + row_count + '" onkeyup="return(FormatCurrency(this,event));" style="width:70px;">';
	}		
	function kontrol()
	{
		for(var i=1; i<=row_count; i++)
		{
			var str_me=eval("form_basket.TUTAR1"+i);
			if(str_me!= null)
				str_me.value=f1(str_me.value);
		}
		for(var i=1; i<=row_count; i++)
		{
			var str_me=eval("form_basket.PREMIUM"+i);
			if(str_me!= null)
				str_me.value=f1(str_me.value);
		}
		form_basket.GENERAL_JOIN.value = f1(form_basket.GENERAL_JOIN.value);
		form_basket.YEARLY_USE.value = f1(form_basket.YEARLY_USE.value);
		form_basket.ENTRANCE.value = f1(form_basket.ENTRANCE.value);
		
		return true;
	}
</script>
