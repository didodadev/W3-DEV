<cfsetting showdebugoutput="no">
<cfoutput>
<script type="text/javascript">
	function add_fav_b2b_#this_row_id_#()
	{   
	 	AjaxPageLoad('#request.self#?fuseaction=objects2.add_my_favourites&product_id='+#attributes.product_id#+'&stock_id='+#attributes.stock_id#+'&myType=1','_message_');
	}
</script>
<input type="button" value="Favorilerime Ekle" onclick="add_fav_b2b_#this_row_id_#();" />
</cfoutput>
