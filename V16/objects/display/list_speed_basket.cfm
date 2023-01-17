<cfquery name="get_product_" datasource="#dsn#">
	SELECT
		SUM(QUANTITY) AS MIKTAR,
		PRODUCT_ID,
		STOCK_ID,
		PRODUCT_NAME
	FROM
		ORDER_PRE_ROWS
	WHERE
		EMPLOYEE_ID = #session.ep.userid#
	GROUP BY
		PRODUCT_ID,
		STOCK_ID,
		PRODUCT_NAME
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32680.Hızlı Sepet'></cfsavecontent>
<cf_popup_box title="#message#">
    <table class="form_list" width="99%">
        <thead>
            <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
            <th width="60">&nbsp;<cf_get_lang dictionary_id='57635.Miktar'></th>
            <th width="15">&nbsp;<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_del_speed_basket&is_all=1"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id='60140.Tüm Ürünleri Temizle'>"></a></th>
            <cfif not isdefined("attributes.no_add")>
                <th width="15">
                    <cfif get_product_.recordcount>
                        <input type="checkbox" name="stock_list_all" id="stock_list_all" value="1" onclick="wrk_select_all('stock_list_all','stock_list');">
                    </cfif>
                </th>
            </cfif>
        </thead>
        <tbody>
            <cfif get_product_.recordcount>
                <cfform action="#request.self#?fuseaction=objects.emptypopup_add_speed_basket_to_basket" name="speed_form" method="post">
					<cfoutput query="get_product_">
                        <tr>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','large','speed_basket_product');" class="tableyazi">#PRODUCT_NAME#</a></td>
                            <td>
                            <input type="text" name="amount_#stock_id#" id="amount_#stock_id#" value="#MIKTAR#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,0));"/></td>
                            <td><div id="td_islem_#stock_id#"><a href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_del_speed_basket&stock_id=#stock_id#','td_islem_#stock_id#','Siliniyor!',1);"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id='50765.Ürün Sil'>"></a></div></td>
                            <cfif not isdefined("attributes.no_add")>
                                <td width="15">
                                	<input type="checkbox" name="stock_list" id="stock_list" value="#stock_id#">
                                </td>
                            </cfif>
                        </tr>
					</cfoutput>
					<cfif not isdefined("attributes.no_add")>
                        <tr>
                            <td height="30" colspan="5" style="text-align:right;"><cf_workcube_buttons insert_info='Sepete Gönder' is_cancel='0' add_function='kontrol()'></td>
                        </tr>
                    </cfif>
                </cfform>
            <cfelse>
                <tr>
                	<td colspan="4" height="20"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
        </tbody>
    </table>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	is_check_ = '0';
	<cfoutput query="get_product_">
		<cfif get_product_.recordcount eq 1>
			if(document.speed_form.stock_list.checked == true)
				{
				if(document.speed_form.amount_#stock_id#.value == '')
					{
					alert("<cf_get_lang dictionary_id='54409.Miktar Girmelisiniz'>!");
					return false;
					}
				is_check_ = '1';
				}
		<cfelse>
			if(document.speed_form.stock_list[#currentrow-1#].checked == true)
				{
				if(document.speed_form.amount_#stock_id#.value == '')
					{
					alert("<cf_get_lang dictionary_id='54409.Miktar Girmelisiniz'>!");
					return false;
					}
				is_check_ = '1';
				}
		</cfif>
	</cfoutput>
	if(is_check_=='0')
		{
		alert("<cf_get_lang dictionary_id='57725.Ürün Seçiniz'>!");
		return false;
		}
}
</script>
