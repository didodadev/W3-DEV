<table border="0" width="98%" class="headbold" cellpadding="0" cellspacing="0" align="center">
  <tr>
	<td height="35">Talep Ekle</td>
  </tr>
</table>
<cfform name="add_demand" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=worknet.emptypopup_add_demand">
<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0">
	<tr>
		<td> 
			<cf_box id="add_demand" closable="0" collapsable="0">
				<table>	
					<tr>
						<td>Durum </td>
						<td><input type="checkbox" value="1" name="is_status" id="is_status" checked="checked" class="kutu_ckb_1"  /> <cf_get_lang_main no='81.Aktif'>
						</td>
					</tr>
					<tr>
						<td>Talep Türü *</td>
						<td>
							<input type="radio" value="1" name="demand_type" id="demand_type" checked="checked" /> Alış Talebi
							<input type="radio" value="2" name="demand_type" id="demand_type" /> Satış Talebi
						</td>
					</tr>
					<tr>
						<td>Yetkilendirme *</td>
						<td>
							<input type="radio" value="1" name="order_member_type" id="order_member_type" checked="checked" /> Herkese Açık 
							<input type="radio" value="2" name="order_member_type" id="order_member_type" /> Üyelerime Açık
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='246.Üye'> *</td>
						<td>
							<input type="hidden" name="company_id" id="company_id" value="">
							<input name="company_name" type="text" id="company_name" style="width:300px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1\'','MEMBER_PARTNER_NAME2,PARTNER_ID,COMPANY_ID','partner_name,partner_id,company_id','','3','250');" value="" autocomplete="off">
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=add_demand.company_id&field_comp_name=add_demand.company_name&field_id=add_demand.partner_id&field_name=add_demand.partner_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(add_demand.company_name.value),'list','popup_list_pars');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='166.Yetkili'></td>
						<td>
							<input type="hidden" name="partner_id" id="partner_id" value="">
							<input type="text" name="partner_name" id="partner_name" style="width:200px;"  value="" readonly>
						</td>
					</tr>
					<tr>
						<td width="120"><cf_get_lang_main no='70.Aşama'> *</td>
						<td><cf_workcube_process is_upd='0' process_cat_width='205' is_detail='0'>
						</td>
					</tr>
					<tr>
						<td>Talep *</td>
						<td><input type="text" name="demand_head" id="demand_head" value="" maxlength="200" style="width:400px;"/></td>
					</tr>
					<tr>
						<td valign="top"><cf_get_lang_main no='155.Ürün Kategorileri'> *</td>
						<td valign="top">
							<select name="product_category" id="product_category" style="width:405px; height:60px;" multiple></select>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.add_demand.product_category','medium');"><img src="/images/plus_list.gif" border="0" align="top" title="<cf_get_lang_main no='170.Ekle'>"></a>
							<a href="javascript://" onClick="remove_field('product_category');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top" title="<cf_get_lang_main no='51.Ekle'>"></a>
						</td>
					 </tr>
					
					<tr>
						<td>Talep Anahtar Kelime *</td>
						<td><input type="text" name="demand_keyword" id="demand_keyword" maxlength="250" value="" style="width:400px;"/></td>
					</tr>
					<tr>
						<td valign="top"><cf_get_lang_main no='217.Açıklama'> *</td>
						<td>
							<cfmodule
								template="/fckeditor/fckeditor.cfm"
								toolbarSet="mailcompose"
								basePath="/fckeditor/"
								instanceName="demand_detail"
								valign="top"
								value=""
								width="580"
								height="180">
						</td>
					</tr>
					<tr>
						<td>Yayın Tarihi *</td>
						<td><input type="text" name="start_date" id="start_date" value="" maxlength="10" style="width:70px;">
							<cf_wrk_date_image date_field="start_date"> /
						
							<input type="text" name="finish_date" id="finish_date" value="" maxlength="10" style="width:70px;">
							<cf_wrk_date_image date_field="finish_date">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='167.Sektör'> *</td>
						<td><cfsavecontent variable="text"><cf_get_lang_main no='322.Seçiniz'></cfsavecontent>
							<cf_wrk_selectlang 
								name="sector_cat_id"
								option_name="sector_cat"
								option_value="sector_cat_id"
								width="200"
								table_name="SETUP_SECTOR_CATS"
								option_text="#text#">
						</td>
					</tr>
				</table>
			</cf_box>
			<cf_box id="add_demand_2" closable="0" collapsable="0">
				<table>
					<tr>
						<td width="120">Fiyat</td>
						<td>
							<cfinput type="text" name="total_amount" id="total_amount" style="width:90px;" passThrough="onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
							<cfquery name="GET_MONEYS" datasource="#DSN#">
								SELECT MONEY_ID,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session_base.period_id#
							</cfquery>
							<select name="MONEY" style="width:50px;">
							  <cfoutput query="get_moneys">
								<option value="#money#"<cfif money eq session_base.money>selected</cfif>>#money#</option>
							  </cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td>Teslim Tarihi</td>
						<td><input type="text" name="deliver_date" id="deliver_date" value="" maxlength="10" style="width:70px;">
							<cf_wrk_date_image date_field="deliver_date">
						</td>
					</tr>
					<tr>
						<td>Teslim Yeri</td>
						<td><input type="text" name="deliver_addres" id="deliver_addres" value="" style="width:300px;" maxlength="250"> </td>
					</tr>
					<tr>
						<td>Ödeme Yöntemi</td>
						<td><input type="text" name="paymethod" id="paymethod" value="" style="width:300px;" maxlength="250"></td>
					</tr>
					<tr>
						<td>Sevk Yöntemi</td>
						<td><input type="text" name="ship_method" id="ship_method" value="" style="width:300px;" maxlength="250"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
					</tr>
				</table>
			</cf_box>
		</td>
	</tr>
</table>
</cfform>
<script language="javascript">
	function select_all(selected_field)
	{
		var m = eval("document.add_demand." + selected_field + ".length");
		for(i=0;i<m;i++)
		{
			eval("document.add_demand."+selected_field+"["+i+"].selected=true");
		}
	}
	function remove_field(field_option_name)
	{
		field_option_name_value = document.getElementById(field_option_name);
		for (i=field_option_name_value.options.length-1;i>-1;i--)
		{
			if (field_option_name_value.options[i].selected==true)
			{
				field_option_name_value.options.remove(i);
			}	
		}
	}
	
	function kontrol()
	{
		select_all('product_category');
		document.getElementById('total_amount').value = filterNum(document.getElementById('total_amount').value);

		if(document.getElementById('company_id').value == '' || document.getElementById('company_name').value == '' )
		{
			alert('Lütfen üye seçiniz !');
			document.getElementById('company_name').focus();
			return false;
		}
		if(document.getElementById('demand_head').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='88.Talep'>");
			document.getElementById('demand_head').focus();
			return false;
		}
		if(document.getElementById('product_category').value == '' )
		{
			alert("<cf_get_lang_main no='1535.Lütfen Kategori Seçiniz'> !");
			document.getElementById('product_category').focus();
			return false;
		}
		if(document.getElementById('demand_keyword').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='11.Anahtar Kelime'>");
			document.getElementById('demand_keyword').focus();
			return false;
		}
		if(FCKeditorAPI.GetInstance('demand_detail').GetHTML(true) == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='217.Açıklama'>!");
			document.getElementById('demand_detail').focus();
			return false;
		}
		
		if(document.getElementById('start_date').value == '' || document.getElementById('finish_date').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='84.Yayın Tarihi'>");
			document.getElementById('start_date').focus();
			return false;
		}
		
		if (!date_check(document.getElementById('start_date'),document.getElementById('finish_date'),"Yayın bitiş tarihi başlangıç tarihinden önce olamaz !"))
		return false;
				
		if(document.getElementById('sector_cat_id').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='167.Sektör'>");
			document.getElementById('sector_cat_id').focus();
			return false;
		}
	}
</script>

