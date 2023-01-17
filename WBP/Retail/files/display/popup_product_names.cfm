<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cf_box_elements>
			<div class="form-group" id="item-promotion_head">
				<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
				<div class="col col-8 col-sm-12">
					<input type="text" name="keyword" id="keyword" style="width:250px;" onkeyup="islem_yap();"/>
				</div>
			</div>
		</cf_box_elements>
	</cf_box>
</div>
<script>
function islem_yap()
{
	deger_ = document.getElementById('keyword').value.replace("%"," ");
	
	if(deger_.length >= 3)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.emptypopup_product_names&type=1&keyword=</cfoutput>' + deger_,'action_div',1);	
	}
}
document.getElementById('keyword').focus();
</script>