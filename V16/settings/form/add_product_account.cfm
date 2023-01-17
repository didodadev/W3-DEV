<cf_get_lang_set module_name="settings">
<cfquery name="get_acc_cat" datasource="#dsn3#">
	SELECT PRO_CODE_CATID,PRO_CODE_CAT_NAME FROM SETUP_PRODUCT_PERIOD_CAT ORDER BY PRO_CODE_CAT_NAME
</cfquery>
<cfquery name="GET_KDV" datasource="#dsn2#">
	SELECT TAX FROM SETUP_TAX ORDER BY TAX
</cfquery>
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','Toplu Muhasebe Kodu Seç',42987)#" closable="0" resize="0">
		<cf_box_elements>
			<cf_form_box id="add_account_box">
				<cfform name="add_acount" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_pro_account" enctype="multipart/form-data">
					<div class="col col-12 col-xs-12">
						<cf_area width="400">
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='42988.Kod Kategorisi'></label>
								<div class="col col-8">
									<select name="product_acc_cat" id="product_acc_cat">
										<cfoutput query="get_acc_cat">
											<option value="#PRO_CODE_CATID#">#PRO_CODE_CAT_NAME#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='42990.Aktarım Tipi'></label>
								<div class="col col-8">
									<div class="input-group">
										<input type="radio" name="cat_type" id="cat_type" value="1" onClick="kontrol();" checked><cf_get_lang dictionary_id='42991.KDV lere Göre'><br/>
										<input type="radio" name="cat_type" id="cat_type" value="2" onClick="kontrol();"><cf_get_lang dictionary_id='42992.Kategorisine Göre ve Satış Kdv'><br/>
										<input type="radio" name="cat_type" id="cat_type" value="3" onClick="kontrol();"><cf_get_lang dictionary_id='43657.Kategori ve Satış Alış KDV sine Göre'><br/>
										<input type="radio" name="cat_type" id="cat_type" value="4" onClick="kontrol();"><cf_get_lang dictionary_id='62477.Kategorisine Göre'>
									</div>
								</div>
							</div>
							<div class="form-group" id="tr_purchase">
								<label class="col col-4"></label>
								<div class="col col-8">
									<select name="tax_purchase" id="tax_purchase">
										<option value=""><cf_get_lang dictionary_id='42993.Alış KDV'></option>
										<cfoutput query="get_kdv">
											<option value="#tax#">#tax#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="tr_sale">
								<label class="col col-4"></label>
								<div class="col col-8">
									<select name="tax_sale" id="tax_sale">
										<option value=""><cf_get_lang dictionary_id='42994.Satış KDV'></option>
										<cfoutput query="get_kdv">
											<option value="#tax#">#tax#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="tr_pcat" style="display:none;">
								<label class="col col-4"><cf_get_lang dictionary_id='57486.Kategori'></label>
								<div class="col col-8">
									<a style="cursor:pointer;" onClick="open_product_cat();"><img src="/images/plus_list.gif" border="0" alt="<cf_get_lang dictionary_id='42989.Ürün Kategorisi Ekle'>!" align="absmiddle"></a>
									<script type="text/javascript">
										var row_count = 0;
										function add_row_p_catid(no,p_cat_id,p_cat,p_code)
										{
											row_count = no;
											var newRow = document.getElementById('myTable').insertRow(1);
											newCell = newRow.insertCell('+row_count+');
											newCell.innerHTML = '<input type="hidden" name="product_catid'+row_count+'" value="'+p_cat_id+'"><input type="hidden" name="product_code'+row_count+'" value="'+p_code+'"><cfinput type="text" name="product_cat'+row_count+'" style="width:200px;" value="'+p_cat+'" passthrough="readonly=yes">';
											newCell = newRow.insertCell('+row_count+');
											newCell.innerHTML = '<a style="cursor:pointer" onclick="delete_Row(this);"><img src="images/delete_list.gif" border="0"></a>';
										}
										function delete_Row(r)
										{	
											document.getElementById('myTable').deleteRow(r.parentNode.parentNode.rowIndex);
										}
									</script>
									<input type="hidden" name="row_count" id="row_count" value="0">
								</div>
							</div>
							<div class="form-group" id="tr_pcat_row" style="display:none">
								<label class="col col-4"></label>
								<div class="col col-8">
									<table id="myTable" cellpadding="1" cellspacing="0">
										<tr>
											<td valign="top" colspan="2"></td>
										</tr>
									</table>
								</div>
							</div>
						</cf_area>
						<cf_area>        
							<table>
								<tr>
									<td>
										<cf_get_lang dictionary_id='44830.Bu sayfa seçilen muhasebe kod kategorisine göre belirlenen kriterlerdeki ürünlerin mevcut dönemdeki muhasebe kodlarını günceller'><br/><br/>
										<cf_get_lang dictionary_id='58599.Dikkat'> : <cf_get_lang dictionary_id='44831.KDV lere göre seçeneği işaretlenirse'>;<br/>
										* <cf_get_lang dictionary_id='44832.Seçilen Alış ve Satış KDV oranlarına bağlı bütün ürünler'> (<cf_get_lang dictionary_id='58967.Örnek'> : <cf_get_lang dictionary_id='44834.Alış KDV=8 ve Satış KDV=8 olan ürünler'>),<br/><br/>
										<cf_get_lang dictionary_id='44835.Kategorisine göre seçeneği işretlenirse'>;<br/>
										* <cf_get_lang dictionary_id='44836.Seçilen ürün kategorisine bağlı bütün ürünler güncellenir'><br/><br/>
										<cf_get_lang dictionary_id='44837.Kategori ve KDV ye Göre seçeneği işaretlernirse'>;<br/>
										*<cf_get_lang dictionary_id='44838.Seçilen ürün kategorisine bağlı ürünler Alış ve Satış KDV sine göre günccellenir.'><br/><br/>
									</td>
								</tr>
							</table>
						</cf_area>
						<cf_form_box_footer>
							<cf_workcube_buttons is_upd='0' add_function="gonderi()">
						</cf_form_box_footer>
					</div>
				</cfform>
			</cf_form_box>
		</cf_box_elements>
	</cf_box>
</div>
<script type="text/javascript">

$( "#add_account_box" ).parent().css( "width", "100%" );

function gonderi()
{
	if(document.add_acount.cat_type[3].checked == false)
	{
		if(document.add_acount.tax_purchase.value == "" && document.add_acount.tax_sale.value == "")
		{
			alert("<cf_get_lang dictionary_id ='43828.Satış veya Alış KDV Değerlerinden En Az Biri Dolu Olmalıdır'> !");
			return false;
		}
	}
	if(document.add_acount.cat_type[3].checked == true && document.getElementById("row_count").value == 0)
	{
		alert("<cf_get_lang dictionary_id ='34744.Ürün Kategorisi Seçmelisiniz'> !");
		return false;
	}
	return kontrol();
}

function kontrol()
{
	if (document.add_acount.cat_type[0].checked)
	{
		goster(tr_purchase);
		goster(tr_sale);
		gizle(tr_pcat);
		gizle(tr_pcat_row);
	}
	else if (document.add_acount.cat_type[1].checked)
	{
		gizle(tr_purchase);
		goster(tr_sale);
		goster(tr_pcat);
		goster(tr_pcat_row);
	}
	else if (document.add_acount.cat_type[2].checked)
	{
		goster(tr_purchase);
		goster(tr_sale);
		goster(tr_pcat);
		goster(tr_pcat_row);
	}
	else if (document.add_acount.cat_type[3].checked)
	{
		document.getElementById("tax_purchase").value = "";
		document.getElementById("tax_sale").value = "";
		gizle(tr_purchase);
		gizle(tr_sale);
		goster(tr_pcat);
		goster(tr_pcat_row);
	}
}
function open_product_cat()
{
	var url_add = "";
	if(document.add_acount.cat_type[3].checked == true)
		url_add = "&is_sub_category=1";
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&call_function=add_row_p_catid'+url_add);	
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">