<cf_xml_page_edit fuseact="objects.popup_export_terazi">
<cfquery name="PRICE_CATS" datasource="#DSN3#">
	SELECT
		PRICE_CATID,
		PRICE_CAT
	FROM
		PRICE_CAT
	WHERE
		PRICE_CAT_STATUS = 1
	<cfif isdefined("attributes.var_") and (session.ep.isBranchAuthorization)>
		AND PRICE_CAT.BRANCH LIKE '%,#listgetat(session.ep.user_location,2,"-")#,%'
	</cfif>
	ORDER BY 
		PRICE_CAT
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33145.Terazi Belgesi Oluştur'></cfsavecontent>
<cf_popup_box title="#message#">
    <cfform name="formexport" method="post" action="#request.self#?fuseaction=objects.emptypopup_export_terazi">
    <input type="hidden" name="xml_price_discount_show" id="xml_price_discount_show" value="<cfoutput>#xml_price_discount_show#</cfoutput>">
	<div class="row">
    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-price_cat_id">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
			<div class="col col-8 col-xs-12">
			  		<select name="price_cat_id" id="price_cat_id">
			  		<cfif not isdefined("attributes.var_")>
						<option value="-1"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
			  		</cfif><!--- Sube icin --->
			  		<cfoutput query="price_cats">
						<option value="#price_cats.price_catid#">#price_cats.price_cat#</option>
			  		</cfoutput>
			  		</select>
		  		</div>
			</div>	  
		<div class="form-group" id="item-product_code">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
				<div class="col col-8 col-xs-12">
				<div class="input-group">
			 		<input type="hidden" name="product_code" id="product_code" value="">
			  		<cfinput type="text" name="product_cat" value="" readonly="yes">
			 		<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_code=formexport.product_code&field_name=formexport.product_cat&is_sub_category=1</cfoutput>');"></span>
				</div>
		  	</div>
		</div>	  
		<div class="form-group" id="item-ext">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57691.Dosya Adı'> *</label>
				<div class="col col-4 col-xs-12">
			 		<cfsavecontent variable="message"><cf_get_lang dictionary_id='33074.Dosya girmelisiniz'></cfsavecontent>
			  		<cfinput type="text" name="file_name" required="yes" message="#message#" style="width:150px;">
				</div>
				<div class="col col-4 col-xs-12">	  
					  <select name="ext" id="ext" style="width:102px;">
						<option value="-1">Mettler.txt</option>
						<option value="-2">Bizerba.dat</option>
						<option value="-3">Digi.dat</option>
						<option value="-4">Epelsa.dat</option>
						<option value="-5">Cas.txt</option>o
						<option value="-6">Cas.plu</option>
						<option value="-7">AveryBerkel.txt</option>
			  		</select>
			</div>
		</div>		
		<div class="form-group" id="item-ext">
			<div class="col col-8 col-xs-12">	
				<div class="input-group x-12">
					<input type="checkbox" value="1" name="is_daily" id="is_daily" style="margin-left:-3px;"><cf_get_lang dictionary_id='34246.Sadece Bugun Fiyati Degisen Urunler'>
				</div>
			</div>
		</div>
	</div>
</div>		
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if(document.formexport.price_cat_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='34316.Fiyat Listesi Girmelisiniz'>!");
		return false;
	}
	return true;
}
</script>
