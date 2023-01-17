<cfinclude template="../query/get_rival_price.cfm">
<cfset attributes.pid = get_rival_price.product_id>
<cfinclude template="../query/get_rivals.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_product_unit.cfm">
<cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#?fuseaction=product.popup_form_add_rival_price&pid=#attributes.pid#</cfoutput>"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37328.Rakip Fiyat'></cfsavecontent>
<cf_popup_box title="#message#" right_images="#txt#">
	<cfform action="#request.self#?fuseaction=product.emptypopup_upd_rival_price" method="post" name="price">
	<input type="hidden" name="PR_ID" id="PR_ID" value="<cfoutput>#PR_ID#</cfoutput>">
		<table border="0">
			<tr>
				<td><cf_get_lang dictionary_id='57657.Ürün'></td>
				<td><cfoutput>#get_rival_price.product_name#</cfoutput> </td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58779.Rakip'></td>
				<td colspan="3">
					<select name="r_id" id="r_id" style="width:192px;">
						<cfoutput query="get_rivals"> 
							<option value="#R_ID#" <cfif get_rival_price.r_id eq r_id>selected</cfif>>#rival_name# 
						</cfoutput> 
					</select>
				</td>
			</tr> 
			<tr> 
				<td width="75"><cf_get_lang dictionary_id='58084.Fiyat'></td>
				<td> 
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='37416.Fiyat girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="price" value="#get_rival_price.price#" style="width:130px;" required="yes" message="#message#" validate="float">
					<select name="money" id="money" style="width:55px;">
						<cfoutput query="get_money"> 
							<option value="#money#" <cfif get_rival_price.money is money>selected</cfif>>#money# 
						</cfoutput> 
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='37307.Ürün Birimi'></td>
				<td colspan="3">
					<select name="unit_id" id="unit_id" style="width:100px;">
						<cfoutput query="get_product_unit"> 
							<option value="#PRODUCT_UNIT_ID#" <cfif get_rival_price.unit_id eq product_unit_id>selected</cfif>>#add_unit# 
						</cfoutput> 
					</select>
				</td>
			</tr> 
			<tr> 
				<td><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></td>
				<td> 
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi girmelisiniz'></cfsavecontent>
					<cfinput value="#dateformat(get_rival_price.startdate,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:75px;" maxlength="10">
					<cf_wrk_date_image date_field="startdate">
				</td>
			</tr> 
			<tr>
				<td width="65"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
				<td> 
					<cfif len(get_rival_price.finishdate)>
						<cfset date2=dateformat(get_rival_price.finishdate,dateformat_style)>
					<cfelse>
						<cfset date2="">
					</cfif>
					<cfinput value="#date2#" validate="#validate_style#"  type="text" name="finishdate" style="width:75px;" maxlength="10">
					<cf_wrk_date_image date_field="finishdate">
				</td>
			</tr>
		</table>
		<cf_popup_box_footer>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
				<cf_workcube_buttons type_format='1' is_upd='1' add_function='kontrol()' insert_info='#message#' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_rival_price&pr_id=#pr_id#&head=#get_rival_price.product_name#'> 
		</cf_popup_box_footer>
	</cfform>   
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.price.money.value == 0)
		{
			window.alert("<cf_get_lang dictionary_id='41991.Para Birimi Girmelisiniz'>!");
			return false;
		}
		return true;
	}
</script>
