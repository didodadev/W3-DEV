<cfquery name="GET_DUTY_TYPE" datasource="#DSN#">
	SELECT * FROM SETUP_DUTY_TYPE WHERE DUTY_TYPE_ID = #url.id#
</cfquery>
<cfquery name="GET_DUTY_UNIT_CATS" datasource="#DSN#">
	SELECT DUTY_UNIT_CAT_ID,DUTY_UNIT_CAT FROM SETUP_DUTY_UNIT_CAT ORDER BY DUTY_UNIT_CAT
</cfquery>

<cfquery name="GET_CUSTOMER_TYPE" datasource="#DSN#">
	SELECT 
		CUSTOMER_TYPE_ID,
		CUSTOMER_TYPE
	FROM 
		SETUP_CUSTOMER_TYPE
	WHERE
	<cfloop from="1" to="#listlen(get_duty_type.customer_type_id)#" index="k">		
		CUSTOMER_TYPE_ID = #listgetat(get_duty_type.customer_type_id,k)# <cfif k neq listlen(get_duty_type.customer_type_id)>OR</cfif>
	</cfloop>
</cfquery>

<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
		<td class="headbold"><cf_get_lang no='1875.Hizmet Tipi Guncelle'></td>
		<td align="right" class="headbold" style="text-align:right;">
			<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_crm_contracts_history&id=#url.id#&duty_type=1</cfoutput>','list','popup_customer_type_history');"><img src="/images/history.gif" alt="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_duty_type"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
		</td>
  	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_duty_type.cfm"></td>
		<td valign="top">
		<table border="0">
		<cfform name="upd_duty_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_duty_type">
			<input type="hidden" name="duty_type_id" id="duty_type_id" value="<cfoutput>#url.id#</cfoutput>">
			<input type="hidden" name="old_is_active" id="old_is_active" value="<cfoutput>#get_duty_type.is_active#</cfoutput>">
			<input type="hidden" name="old_duty_type" id="old_duty_type" value="<cfoutput>#get_duty_type.duty_type#</cfoutput>">
			<input type="hidden" name="old_detail" id="old_detail" value="<cfoutput>#get_duty_type.detail#</cfoutput>">
			<input type="hidden" name="old_duty_unit_cat" id="old_duty_unit_cat" value="<cfoutput>#get_duty_type.duty_unit_cat_id#</cfoutput>">
			<cfset customer_type_ = "">
			<cfloop from="1" to="#listlen(get_duty_type.customer_type_id)#" index="k">		
				<cfset customer_type_ = listappend(customer_type_,listgetat(get_duty_type.customer_type_id,k),',')>
			</cfloop>
			<input type="hidden" name="old_customer_type" id="old_customer_type" value="<cfoutput>#customer_type_#</cfoutput>">
			<input type="hidden" name="old_cost_id" id="old_cost_id" value="<cfoutput>#get_duty_type.cost_id#</cfoutput>">
			<input type="hidden" name="old_cost_amount" id="old_cost_amount" value="<cfoutput>#get_duty_type.cost_amount#</cfoutput>">
			<input type="hidden" name="old_calculate_method" id="old_calculate_method" value="<cfoutput>#get_duty_type.calculate_method#</cfoutput>">
			<input type="hidden" name="old_calculate_amount" id="old_calculate_amount" value="<cfoutput>#get_duty_type.calculate_amount#</cfoutput>">
			<input type="hidden" name="old_is_target" id="old_is_target" value="<cfoutput>#get_duty_type.is_target#</cfoutput>">
			<input type="hidden" name="old_is_value" id="old_is_value" value="<cfoutput>#get_duty_type.is_value#</cfoutput>">
			<input type="hidden" name="old_is_category" id="old_is_category" value="<cfoutput>#get_duty_type.is_category#</cfoutput>">
			<tr>
				<td width="130"><cf_get_lang_main no='81.Aktif'></td>
				<td><input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_duty_type.is_active eq 1>checked</cfif>></td>
			</tr>		
			<tr>
				<td><cf_get_lang no='1685 .Hizmet Adı'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no='1686.Hizmet Adı Girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="duty_type" value="#get_duty_type.duty_type#" maxlength="25" required="Yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:150px;height:60px;"><cfoutput>#get_duty_type.detail#</cfoutput></textarea></td>
			</tr>	
			<tr>
				<td><cf_get_lang no='1687.Hizmet Birimi'> *</td>
				<td>
					<select name="duty_unit_cat" id="duty_unit_cat" style="width:150px;">
					<option value=""><cf_get_lang_main no='322.Seciniz'></option>
					<cfoutput query="get_duty_unit_cats">
						<option value="#duty_unit_cat_id#" <cfif duty_unit_cat_id eq get_duty_type.duty_unit_cat_id> selected</cfif>>#duty_unit_cat#</option>
					</cfoutput>
					</select>
				</td>
			</tr>					
			<tr>
				<td valign="top"><cf_get_lang_main no='45.Musteri'> <cf_get_lang no='1627.Tipi'> *</td>
				<td><select name="customer_type" id="customer_type" style="width:150px;height:85px" multiple>
					<cfoutput query="get_customer_type">
				  		<option value="#customer_type_id#">#customer_type#</option>
					</cfoutput>
				  	</select>
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_customer_type&field_name=upd_duty_type.customer_type','medium');"><img src="/images/plus_thin.gif" border="0" align="top"></a>
					<a href="javascript://" onClick="remove_field('customer_type');"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang_main no='51.Sil'>" style="cursor=hand" align="top"></a>
				</td>
				<td></td>				
			</tr>
			<tr>
				<td><cf_get_lang_main no='846.Maliyet'> *</td>
				<td>
					<input name="cost_id" id="cost_id" type="radio" value="1" <cfif get_duty_type.cost_id eq 1>checked</cfif> onClick="goster(calculate_method_span);gizle(cost_amount_span);"><cf_get_lang_main no='1586.Hesapla'>
					<input name="cost_id" id="cost_id" type="radio" value="0" <cfif get_duty_type.cost_id eq 0>checked</cfif> onClick="goster(cost_amount_span);gizle(calculate_method_span);gizle(duty_tutar);document.upd_duty_type.calculate_method[0].checked = false;document.upd_duty_type.calculate_method[1].checked = false;"><cf_get_lang no='1689 .Tutar Belli'>
				</td>
				<td><span id="cost_amount_span" <cfif get_duty_type.cost_id eq 1>style="display:none;"</cfif>><cf_get_lang_main no='261.Tutar'> *&nbsp;<input type="text" name="cost_amount" id="cost_amount" value="<cfoutput>#tlformat(get_duty_type.cost_amount)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;"></span></td>
			</tr>						
			<tr>
				<td></td>
				<td>
					<span id="calculate_method_span" <cfif not len(get_duty_type.calculate_method)>style="display:none;"</cfif>>
						<input name="calculate_method" id="calculate_method" type="radio" value="1" <cfif get_duty_type.calculate_method eq 1>checked</cfif> onClick="gizle(duty_tutar);"><cf_get_lang no='1695.Toplam Cirodan'>
						<input name="calculate_method" id="calculate_method" type="radio" value="2" <cfif get_duty_type.calculate_method eq 2>checked</cfif> onClick="gizle(duty_tutar);"><cf_get_lang no='1697. 4-5 Kademe Hariç Cirodan'>
						<input name="calculate_method" id="calculate_method" type="radio" value="3" <cfif get_duty_type.calculate_method eq 3>checked</cfif> onClick="goster(duty_tutar);"><cf_get_lang no='1696.Diğer Tutar'>				
					</span>
				</td>
				<td><span id="duty_tutar" <cfif not len(get_duty_type.calculate_method) or get_duty_type.calculate_method neq 3>style="display:none;"</cfif>><cf_get_lang_main no='261.Tutar'> *&nbsp;<input type="text" name="calculate_amount" id="calculate_amount" value="<cfoutput>#tlformat(get_duty_type.calculate_amount)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:100px;"></span></td>
			</tr>
			<tr>
				<td><cf_get_lang no='1690.Hizmet İçin Deger Girişi'> *</td>
				<td>
					<input name="is_value" id="is_value" type="radio" value="1" <cfif get_duty_type.is_value eq 1>checked</cfif>><cf_get_lang_main no='1152.Var'>	
					<input name="is_value" id="is_value" type="radio" value="0" <cfif get_duty_type.is_value eq 0>checked</cfif>><cf_get_lang_main no='1134.Yok'>				
				</td>
			</tr>			
			<tr>
				<td><cf_get_lang no='1691.Hizmet İçin Hedef Tanımı'> *</td>
				<td>
					<input name="is_target" id="is_target" type="radio" value="1" <cfif get_duty_type.is_target eq 1>checked</cfif>><cf_get_lang_main no='1152.Var'>	
					<input name="is_target" id="is_target" type="radio" value="0" <cfif get_duty_type.is_target eq 0>checked</cfif>><cf_get_lang_main no='1134.Yok'>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='1624 .Kategorisi'> *</td>
				<td>
					<input name="is_category" id="is_category" type="radio" value="1" <cfif get_duty_type.is_category eq 1>checked</cfif>><cf_get_lang no='1693.Ek Hizmet'>
					<input name="is_category" id="is_category" type="radio" value="0" <cfif get_duty_type.is_category eq 0>checked</cfif>><cf_get_lang no='1694 .Standart'>
				</td>	
			</tr>					
			<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
			</tr>
			<tr>
				<td colspan="2">
					<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_duty_type.record_emp,0,0)# - #dateformat(get_duty_type.record_date,dateformat_style)#<br/>
					<cfif len(get_duty_type.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_duty_type.update_emp,0,0)# - #dateformat(get_duty_type.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				</td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function remove_field(field_option_name)
{
	field_option_name_value = eval('document.upd_duty_type.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
			field_option_name_value.options.remove(i);
	}
}

function select_all(selected_field,isview)
{
	var m = eval("document.upd_duty_type." + selected_field + ".length");
	for(i=0;i<m;i++)
		eval("document.upd_duty_type."+selected_field+"["+i+"].selected=true")
}

function kontrol()
{	
	if(document.upd_duty_type.detail.value.length>100)
	{
		alert("<cf_get_lang no ='1792.Açıklama 100 Karakterden Uzun Olamaz'> !");
		return false;
	}
	
	if(document.upd_duty_type.duty_unit_cat.value=="")
	{
		alert("<cf_get_lang no ='1866.Hizmet Birimi Seçmelisiniz'> !");
		return false;
	}
	
	select_all('customer_type',0);
	if(document.upd_duty_type.customer_type.value.length==0)
	{
		alert("<cf_get_lang no ='1867.En Az Bir Müşteri Tipi Seçmelisiniz '>!");
		return false;
	}
	
	if(document.upd_duty_type.cost_id[0].checked == false && document.upd_duty_type.cost_id[1].checked == false)
	{
		alert("<cf_get_lang no ='1868.Maliyet Seçiniz'>!");
		return false;
	}
	
	if(document.upd_duty_type.cost_id[1].checked == true)
	{
		if(document.upd_duty_type.cost_amount.value =="")
		{
			alert("<cf_get_lang no ='1869.Maliyet İçin Tutar Giriniz'>!");
			return false;
		}
	}
	else
	{
		if(document.upd_duty_type.calculate_method[0].checked == false && document.upd_duty_type.calculate_method[1].checked == false && document.upd_duty_type.calculate_method[2].checked == false)
		{
			alert("<cf_get_lang no ='1870.Tutar Belli  45 Kademe Hariç Diğer Tutar Birisini Seçiniz'>!");
			return false;
		}
		
		if(document.upd_duty_type.calculate_method[2].checked == true)
		{
			if(document.upd_duty_type.calculate_amount.value =="")
			{
				alert("<cf_get_lang no ='1871.Diğer Tutar İçin Tutar Giriniz'>!");
				return false;		
			}
		}		
	}
			
	if(document.upd_duty_type.is_target[0].checked == false && document.upd_duty_type.is_target[1].checked == false)
	{
		alert("<cf_get_lang no ='1872.Hizmet İçin Hedef Tanımı Seçiniz'>!");
		return false;
	}	
		
	if(document.upd_duty_type.is_value[0].checked == false && document.upd_duty_type.is_value[1].checked == false)
	{
		alert("<cf_get_lang no ='1873.Hizmet İçin Değer Girişi Seçiniz'>!");
		return false;
	}	
	
	if(document.upd_duty_type.is_category[0].checked == false && document.upd_duty_type.is_category[1].checked == false)
	{
		alert("<cf_get_lang no ='1874.Kategori Bilgisini Seçiniz'>!");
		return false;
	}
	
	document.upd_duty_type.cost_amount.value = filterNum(document.upd_duty_type.cost_amount.value);
	document.upd_duty_type.calculate_amount.value = filterNum(document.upd_duty_type.calculate_amount.value);
	return true;
}
</script>
