<cfquery name="GET_DUTY_UNIT_CATS" datasource="#DSN#">
	SELECT DUTY_UNIT_CAT_ID,DUTY_UNIT_CAT FROM SETUP_DUTY_UNIT_CAT ORDER BY DUTY_UNIT_CAT
</cfquery>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td  class="headbold"><cf_get_lang no='1876.Hizmet Tipi Ekle'></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_duty_type.cfm"></td>
		<td valign="top" >
		<table>
		<cfform name="add_duty_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_duty_type">
			<tr>
				<td width="130"><cf_get_lang_main no='81.Aktif'></td>
				<td><input type="checkbox" value="1" name="is_active" id="is_active" checked></td>
			</tr>
			<tr>
				<td><cf_get_lang no='1685 .Hizmet Adı'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no ='1686.Hizmet Adı Girmelisiniz'> !</cfsavecontent>
					<cfinput type="text" name="duty_type" value="" maxlength="25" required="yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:150px;height:60px;"></textarea>
			</td>			
			<tr>
				<td><cf_get_lang no='1687 .Hizmet Birimi'> *</td>
				<td>
					<select name="duty_unit_cat" id="duty_unit_cat" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seciniz'></option>
					<cfoutput query="get_duty_unit_cats">
						<option value="#duty_unit_cat_id#">#duty_unit_cat#</option>
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='45.Musteri'> <cf_get_lang no='1627.Tipi'> *</td>
				<td>
					<select name="customer_type" id="customer_type" style="width:150px;height:85px" multiple></select>
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_customer_type&field_name=add_duty_type.customer_type','medium');"><img src="/images/plus_thin.gif" border="0" align="top"></a>
					<a href="javascript://" onClick="remove_field('customer_type');"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang_main no='51.Sil'>" style="cursor=hand" align="top"></a>
				</td>
				<td>&nbsp;</td>				
			</tr>
			<tr>
				<td><cf_get_lang_main no='846.Maliyet'> *</td>
				<td>
					<input name="cost_id" id="cost_id" type="radio" value="1" onClick="goster(calculate_method_span);gizle(cost_amount_span);"><cf_get_lang_main no='1586.Hesapla'>
					<input name="cost_id" id="cost_id" type="radio" value="0" onClick="goster(cost_amount_span);gizle(calculate_method_span);gizle(duty_tutar);document.add_duty_type.calculate_method[0].checked = false;document.add_duty_type.calculate_method[1].checked = false;"><cf_get_lang no='1689.Tutar Belli'>
				</td>
				<td><span id="cost_amount_span" style="display:none;"><cf_get_lang_main no='261.Tutar'> *&nbsp;<input type="text" name="cost_amount" id="cost_amount" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;"></span></td>
			</tr>
			<tr>
				<td></td>
				<td>
					<span id="calculate_method_span" style="display:none;">
						<input name="calculate_method" id="calculate_method" type="radio" value="1" onClick="gizle(duty_tutar);"><cf_get_lang no ='1695.Toplam Cirodan'>
						<input name="calculate_method" id="calculate_method" type="radio" value="2" onClick="gizle(duty_tutar);"><cf_get_lang no ='1697.Kademe Hariç Cirodan'> 
						<input name="calculate_method" id="calculate_method" type="radio" value="3" onClick="goster(duty_tutar);"><cf_get_lang no ='1696.Diğer Tutar'>				
					</span>				
				</td>
				<td><span id="duty_tutar" style="display:none;"><cf_get_lang_main no='261.Tutar'> *&nbsp;<input type="text" name="calculate_amount" id="calculate_amount" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;"></span>&nbsp;</td>
			</tr>
			<tr>
				<td><cf_get_lang no='1690 .Hizmet İçin Deger Girişi'> *</td>
				<td>
					<input name="is_value" id="is_value" type="radio" value="1"><cf_get_lang_main no='1152.Var'>
					<input name="is_value" id="is_value" type="radio" value="0"><cf_get_lang_main no='1134.Yok'>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='1691.Hizmet İçin Hedef Tanımı'>*</td>
				<td>
					<input name="is_target"  id="is_target"type="radio" value="1"><cf_get_lang_main no='1152.Var'>
					<input name="is_target" id="is_target" type="radio" value="0"><cf_get_lang_main no='1134.Yok'>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='1624.Kategorisi'> *</td>
				<td>
					<input name="is_category" id="is_category" type="radio" value="1"><cf_get_lang no='1693 .Ek Hizmet'>
					<input name="is_category" id="is_category" type="radio" value="0"><cf_get_lang no='1694.Standart'>
				</td>
			</tr>					
		  	<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>		
<script type="text/javascript">
function remove_field(field_option_name)
{
	field_option_name_value = eval('document.add_duty_type.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
			field_option_name_value.options.remove(i);
	}
}

function select_all(selected_field,isview)
{
	var m = eval("document.add_duty_type." + selected_field + ".length");
	for(i=0;i<m;i++)
		eval("document.add_duty_type."+selected_field+"["+i+"].selected=true")
}

function kontrol()
{	
	if(document.add_duty_type.detail.value.length>100)
	{
		alert("<cf_get_lang no ='1792.Açıklama 100 Karakterden Uzun Olamaz'> !");
		return false;
	}
	
	if(document.add_duty_type.duty_unit_cat.value=="")
	{
		alert("<cf_get_lang no ='1866.Hizmet Birimi Seçmelisiniz'> !");
		return false;
	}
	
	select_all('customer_type',0);
	if(document.add_duty_type.customer_type.value.length==0)
	{
		alert("<cf_get_lang no ='1867.En Az Bir Müşteri Tipi Seçmelisiniz '>!");
		return false;
	}
	
	if(document.add_duty_type.cost_id[0].checked == false && document.add_duty_type.cost_id[1].checked == false)
	{
		alert("<cf_get_lang no ='1868.Maliyet Seçiniz'>!");
		return false;
	}
	
	if(document.add_duty_type.cost_id[1].checked == true)
	{
		if(document.add_duty_type.cost_amount.value =="")
		{
			alert("<cf_get_lang no ='1869.Maliyet İçin Tutar Giriniz'>!");
			return false;
		}
	}
	else
	{
		if(document.add_duty_type.calculate_method[0].checked == false && document.add_duty_type.calculate_method[1].checked == false && document.add_duty_type.calculate_method[2].checked == false)
		{
			alert("<cf_get_lang no ='1870.Tutar Belli  45 Kademe Hariç Diğer Tutar Birisini Seçiniz'>!");
			return false;
		}
		
		if(document.add_duty_type.calculate_method[2].checked == true)
		{
			if(document.add_duty_type.calculate_amount.value =="")
			{
				alert("<cf_get_lang no ='1871.Diğer Tutar İçin Tutar Giriniz'> !");
				return false;		
			}
		}		
	}
			
	if(document.add_duty_type.is_target[0].checked == false && document.add_duty_type.is_target[1].checked == false)
	{
		alert("<cf_get_lang no ='1872.Hizmet İçin Hedef Tanımı Seçiniz'> !");
		return false;
	}	
		
	if(document.add_duty_type.is_value[0].checked == false && document.add_duty_type.is_value[1].checked == false)
	{
		alert("<cf_get_lang no ='1873.Hizmet İçin Değer Girişi Seçiniz'>!");
		return false;
	}	
	
	if(document.add_duty_type.is_category[0].checked == false && document.add_duty_type.is_category[1].checked == false)
	{
		alert("<cf_get_lang no ='1874.Kategori Bilgisini Seçiniz'>!");
		return false;
	}
	
	document.add_duty_type.cost_amount.value = filterNum(document.add_duty_type.cost_amount.value);
	document.add_duty_type.calculate_amount.value = filterNum(document.add_duty_type.calculate_amount.value);
	return true;
}
</script>
