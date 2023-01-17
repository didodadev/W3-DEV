<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_units.cfm">

<cfform method="POST" name="form_basket" action="#request.self#?fuseaction=contract.emptypopup_add_purchase_general&contract_id=#attributes.contract_id#">
  <cfoutput>
    <input name="CONTRACT_ID" id="CONTRACT_ID" type="hidden" value="#attributes.CONTRACT_ID#">
    <input name="record_num" id="record_num" type="hidden" value="">
  </cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr class="color-border">
      <td valign="top">
        <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
          <tr class="color-list">
            <td class="headbold" height="35">&nbsp;<cf_get_lang no='9.Genel Koşullar'></td>
          </tr>
          <tr class="color-row">
            <td valign="top">
              <table width="100%" border="0">
                <tr>
                  <td>
                    <table width="325" name="table1" id="table1">
                      <tr>
                        <td colspan="5" class="txtboldblue"><cf_get_lang no='30.Satınalma Genel Ciro Primleri (ay, 3 ay ve yıl olmak üzere ciro primi fatura emri oluşur)'></td>
                      </tr>
                      <tr class="txtbold">
                        <td><input type="button" class="eklebuton" title="" onClick="add_row();"></td>
                        <td><cf_get_lang no='17.Periyod'></td>
                        <td width="125"><cf_get_lang no='193.Koşul/Ciro'></td>
                        <td width="60" nowrap><cf_get_lang_main no='77.Para Birimi'></td>
						<td nowrap><cf_get_lang dictionary_id="48240.Prim Tipi"></td>
                        <td nowrap><cf_get_lang no='20.Prim'></td>
                      </tr>
                    </table>
                    <br/>
                    <table width="375">
                      <tr>
                        <td colspan="3" class="txtboldblue">
						<cf_get_lang no='192.Satınalma Standart 
						Ödemeler(yıllık sistem ve genel katılım ilk anlaşma 
						ve her yıl fatura emrine dönüşür)'></td>
                      </tr>
                      <tr class="txtbold">
                        <td width="200">&nbsp;</td>
                        <td width="125"><cf_get_lang no='24.Bedel'></td>
                        <td><cf_get_lang_main no='77.Para Birimi'></td>
                      </tr>
                      <tr>
                        <td width="130"><cf_get_lang no='25.Genel Katılım Bedeli'></td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='25.Genel Katılım Bedeli !'></cfsavecontent>
                          <cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" type="text" name="GENERAL_JOIN" style="width:125px;">
                        </td>
                        <td><select name="GENERAL_JOIN_MONEY" id="GENERAL_JOIN_MONEY" style="width:60">
                            <cfoutput query="get_moneys">
                              <option value="#MONEY#" <cfif session.ep.money IS get_moneys.MONEY>selected</cfif>>#MONEY# 
                            </cfoutput>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='26.Yıllık Sistem Kullanım Bedeli'></td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='26.Yıllık Sistem Kullanım Bedeli !'></cfsavecontent>
                          <cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" type="text" name="YEARLY_USE" style="width:125px;">
                        </td>
                        <td><select name="YEARLY_USE_MONEY" id="YEARLY_USE_MONEY" style="width:60">
                            <cfoutput query="get_moneys">
                              <option value="#MONEY#" <cfif session.ep.money IS get_moneys.MONEY>selected</cfif>>#MONEY# 
                            </cfoutput>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='27.Mağaza Giriş Bedeli'></td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang no='27.Mağaza Giriş Bedeli !'></cfsavecontent>
                          <cfinput validate="float" passThrough = "onkeyup=""return(FormatCurrency(this,event));""" message="#message#" type="text" name="ENTRANCE" style="width:125px;">
                        </td>
                        <td><select name="ENTRANCE_MONEY" id="ENTRANCE_MONEY" style="width:60">
                            <cfoutput query="get_moneys">
                              <option value="#MONEY#" <cfif session.ep.money IS get_moneys.MONEY>selected</cfif>>#MONEY# 
                            </cfoutput>
                          </select>
                        </td>
                      </tr>
                    </table>
                    <br/>
                    <table >
                      <tr>
                        <td colspan="2" class="txtboldblue">
						<cf_get_lang no='190.Satınalma Vade 
						ve Süre Koşulları (ödemelerle ilişkilendirilecek)'></td>
                      </tr>
                      <tr>
                        <td width="150"><cf_get_lang no='189.Normal Vade (gün)'></td>
                        <td><input type="text" name="NORMAL_DUE" id="NORMAL_DUE" style="width:70">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='188.Ek Vade (gün)'></td>
                        <td><input type="text" name="EXTRA_DUE" id="EXTRA_DUE" style="width:70">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='187.Peşine Mal Alım Vadesi (gün)'></td>
                        <td><input type="text" name="CASH_PROPERTY_DUE" id="CASH_PROPERTY_DUE" style="width:70">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='186.Açılış Vadesi (gün)'></td>
                        <td><input type="text" name="OPENING_DUE" id="OPENING_DUE" style="width:70">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='184.Yeni Liste Uygulama Süresi (gün sonra)'></td>
                        <td><input type="text" name="NEW_LIST_DUE" id="NEW_LIST_DUE" style="width:70">
                        </td>
                      </tr>
                    </table>
                    <br/>
                    <table>
                      <tr>
                        <td colspan="3" class="txtboldblue"><cf_get_lang no='183.Satınalma Fiziki ve Teslimat Koşullar(satınalma alış emrinde kullanıcıya gösterilecek)'></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='1037.Teslim Yeri'></td>
                        <td width="150"><input type="checkbox" name="IS_CENTRAL_STORE" id="IS_CENTRAL_STORE" value="checkbox">
                          <cf_get_lang no='182.Merkez Depo'> </td>
                        <td><input type="checkbox" name="IS_ALL_STORE" id="IS_ALL_STORE" value="checkbox">
                          <cf_get_lang_main no='1698.Tüm Şubeler'></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='180.Teslim Süresi (siparişten sonra)'></td>
                        <td><input type="text" name="DELIVERY_DATE" id="DELIVERY_DATE" style="width:60">
                          <cf_get_lang_main no='78.Gün'> </td>
                        <td><input type="text" name="DELIVERY_TIME" id="DELIVERY_TIME" style="width:60">
                          <cf_get_lang_main no='79.Saat'></td>
                      </tr>
                      <tr>
                        <td valign="baseline"><cf_get_lang no='178.Tatil ve Özel Günlerde Sipariş ve Teslimat'></td>
                        <td><input type="radio" name="IS_ORDER_ACCEPTABLE" id="IS_ORDER_ACCEPTABLE" value="1">
                          <cf_get_lang no='37.Sipariş Kabul Edilir'><br/>
                          <input type="radio" name="IS_ORDER_ACCEPTABLE" id="IS_ORDER_ACCEPTABLE" value="0" checked>
                          <cf_get_lang no='38.Sipariş Kabul Edilmez'></td>
                        <td><input type="radio" name="IS_SHIPPING_ACCEPTABLE" id="IS_SHIPPING_ACCEPTABLE" value="1">
                          <cf_get_lang no='39.Sevkiyat Yapılır'><br/>
                          <br/>
                          <input type="radio" name="IS_SHIPPING_ACCEPTABLE" id="IS_SHIPPING_ACCEPTABLE" value="0" checked>
                          <cf_get_lang no='40.Sevkiyat Yapılmaz'></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='1621.İade'></td>
                        <td><input type="checkbox" name="IS_CUSTOMER_COMPLAINT" id="IS_CUSTOMER_COMPLAINT" value="checkbox">
                          <cf_get_lang no='177.Müşteri Şikayeti'></td>
                        <td><input type="checkbox" name="IS_PRODUCTION_FAULT" id="IS_PRODUCTION_FAULT" value="checkbox">
                          <cf_get_lang no='176.Üretim Hataları'></td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td><input type="checkbox" name="IS_RETURN_INVOICE" id="IS_RETURN_INVOICE" value="checkbox">
                          <cf_get_lang no='175.İade Faturası ile'></td>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
                    <table>
                      <tr>
                        <td width="196"><cf_get_lang no='42.Ambalaj'></td>
                        <td colspan="2"> 
							<cfoutput query="get_units">
                                <input type="checkbox" name="PACKAGE_UNIT" id="PACKAGE_UNIT" value="#UNIT_ID#">
                                #UNIT# &nbsp; 
						  </cfoutput> 
						</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td height="35" colspan="2"> 
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
      </td>
    </tr>
  </table>
</cfform>

<script type="text/javascript">
	row_count=0;
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
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="PERIOD' + row_count + '"  style="width:60px;"><option value="1"><cf_get_lang_main no="1312.Ay"></option><option value="2">3 <cf_get_lang_main no='1312.Ay'></option><option value="3"><cf_get_lang_main no='1043.Yıl'></option></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="TUTAR1' + row_count + '" onkeyup="return(FormatCurrency(this,event));" style="width:125px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="MONEY' + row_count + '" style="width:60px;"><cfoutput query="get_moneys"><option value="#MONEY#">#money#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="PREMIUM_TYPE_RATE_AMOUNT' + row_count + '"  style="width:60px;"><option value="0">Yüzde</option><option value="1">Tutar</option></select>';
			newCell = newRow.insertCell(newRow.cells.length);
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
