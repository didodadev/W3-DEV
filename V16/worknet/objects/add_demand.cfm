<cfif isdefined('session.pp.userid')>
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang no="124.Talep Ekle"></h1></div>
		</div>
		<cfform name="add_demand" id="add_demand" method="post" action="#request.self#?fuseaction=worknet.emptypopup_add_demand" enctype="multipart/form-data">
			<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
			<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#session.pp.userid#</cfoutput>">
			<input type="hidden" name="company_name" id="company_name" value="<cfoutput>#session.pp.company#</cfoutput>">
            <input type="hidden" value="1" name="is_status" id="is_status" /> 
			<input type="hidden" name="type_" id="type_" value="1">
			<div class="talep_detay">
				<div class="talep_detay_1">
					<div class="talep_detay_12">
						<div class="td_kutu">
							<div class="td_kutu_1" style="width:598px;">
								<h2><cf_get_lang no="89.Talep Bilgileri"></h2>
							</div>
							<div class="td_kutu_2">
								<div style="display:none;"><cf_workcube_process is_upd='0' is_detail='0'></div>
								<table>	
									<tr height="25">
										<td><cf_get_lang no="81.Talep Türü">*</td>
										<td><div class="ftd_kutu_21">
												<input type="radio" value="1" name="demand_type" id="demand_type" checked="checked" class="kutu_ckb_1"  />
												<samp><cf_get_lang no='13.Alis Talebi'></samp>
												<input type="radio" value="2" name="demand_type" id="demand_type" class="kutu_ckb_1"  />
												<samp><cf_get_lang no='16.Satis Talebi'></samp>
											</div>
										</td>
									</tr>
									<tr height="25">
										<td><cf_get_lang no='6.Yetkilendirme'>*</td>
										<td><div class="ftd_kutu_21">
												<input type="radio" value="1" name="order_member_type" id="order_member_type" checked="checked" class="kutu_ckb_1" />
												<samp><cf_get_lang no='9.Herkese Acik'></samp>
												<input type="radio" value="2" name="order_member_type" id="order_member_type" class="kutu_ckb_1" /> 
												<samp><cf_get_lang no='10.Uyelerime Acik'></samp>
											</div>
										</td>
									</tr>
									<tr height="25">
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
									<tr height="25">
										<td><cf_get_lang no='88.Talep'>*</td>
										<td><input type="text" name="demand_head" id="demand_head" value="" maxlength="200" style="width:400px;"/></td>
									</tr>
									<tr height="25">
										<td valign="top"><cf_get_lang_main no='155.Ürün Kategorileri'> *</td>
										<td valign="top">
											<select name="product_category" id="product_category" style="width:400px; height:80px;" multiple></select>
											<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.popup_list_product_categories&field_name=document.add_demand.product_category','medium');">
												<img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
											</a>
											<a href="javascript://" onClick="remove_field('product_category');"><img src="../documents/templates/worknet/tasarim/icon_8.png" width="22" height="22" /></a>
										</td>
									 </tr>
									<tr height="25">
										<td><cf_get_lang no='11.Anahtar Kelime'> *</td>
										<td><input type="text" name="demand_keyword" id="demand_keyword" maxlength="250" value="" style="width:400px;"/></td>
									</tr>
									<tr>
										<td><cf_get_lang no='84.Yayın Tarihi'> *</td>
										<td>
											<div class="ftd_kutu_21">
												<input type="text" name="start_date" id="start_date" value="" maxlength="10" style="float:left; width:70px;margin-right:5px;"/>
												<cf_wrk_date_image date_field="start_date">
												<input type="text" name="finish_date" id="finish_date" value="" maxlength="10" style="display:inline; margin-left:10px;float:left;width:70px;margin-right:5px;" />
												<cf_wrk_date_image date_field="finish_date">
											</div>
										</td>
									</tr>
									<tr>
										<td valign="top"><cf_get_lang_main no='217.Açıklama'> *</td>
										<td><textarea 
												style="width:450px; height:200px;" 
												name="demand_detail" 
												id="demand_detail" ></textarea>
										</td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
				<div class="talep_detay_2">
					<div class="td_kutu">
						<div class="td_kutu_1" style="width:290px;">
							<h2><cf_get_lang no='12.Fiyat ve Teslimat'></h2>
						</div>
						<div class="td_kutu_2">
							<table>
								<tr>
									<td><cf_get_lang_main no='672.Fiyat'></td>
									<td>
										<cfinput type="text" name="total_amount" id="total_amount" style="float:left; width:90px;margin-right:5px;" passThrough="onkeyup=""return(FormatCurrency(this,event));""" class="moneybox">
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
									<td><cf_get_lang_main no='233.Teslim Tarihi'></td>
									<td><div class="ftd_kutu_21">
											<input type="text" name="deliver_date" id="deliver_date" value="" maxlength="10" style="float:left; width:70px;margin-right:5px;"/>
											<cf_wrk_date_image date_field="deliver_date">
										</div>
									</td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='1037.Teslim Yeri'></td>
									<td><input type="text" name="deliver_addres" id="deliver_addres" value="" style="width:200px;" maxlength="250"> </td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
									<td><input type="text" name="paymethod" id="paymethod" value="" style="width:200px;" maxlength="250"></td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
									<td><input type="text" name="ship_method" id="ship_method" value="" style="width:200px;" maxlength="250"></td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='223.Miktar'></td>
									<td><cfinput type="text" name="quantity" id="quantity" passThrough="onkeyup=""return(FormatCurrency(this,event));""" style="width:70px;" maxlength="50"></td>
								</tr>
								<tr>
									<td><cf_get_lang no='236.Renk'></td>
									<td><input type="text" name="colour" id="colour" value="" style="width:200px;" maxlength="150" ></td>
								</tr>
								<tr>
									<td><cf_get_lang_main no='519.Cins'></td>
									<td><input type="text" name="demand_kind" id="demand_kind" value="" style="width:200px;" maxlength="150" ></td>
								</tr>
							</table>
						</div>
					</div>
					<div style="margin-top:10px;">
						<cfsavecontent variable="message"><cf_get_lang_main no="49.Kaydet"></cfsavecontent>
						<input class="btn_1" type="button" onclick="kontrol()" value="<cfoutput>#message#</cfoutput>" />
					</div>
				</div>
			</div>
		</cfform>
	</div>
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
			document.getElementById('quantity').value = filterNum(document.getElementById('quantity').value);
	
			if(document.getElementById('sector_cat_id').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='167.Sektör'>");
				document.getElementById('sector_cat_id').focus();
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
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='155.Ürün Kategorileri'>");
				document.getElementById('product_category').focus();
				return false;
			}
			if(document.getElementById('demand_keyword').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='11.Anahtar Kelime'>");
				document.getElementById('demand_keyword').focus();
				return false;
			}
			if(document.getElementById('demand_detail').value == '')
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
			
			if (!date_check(document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang no='21.Yayın bitiş tarihi başlangıç tarihinden önce olamaz'>!"))
			return false;
			
			if (confirm("<cf_get_lang_main no='123.Kaydetmek istediğinizden eminmisiniz!'>")); else return false;
			document.getElementById('add_demand').submit();
			
		}
	</script>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
