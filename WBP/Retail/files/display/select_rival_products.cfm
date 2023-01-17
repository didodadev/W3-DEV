<cfparam name="attributes.type" default="0">
<cfparam name="attributes.op_f_name" default="">
<cf_box  title="#getlang('','Rakip Fiyatlar','32089')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_box_search>
			<div class="form-group">
				<input type="text" name="keyword_" placeholder="<cfoutput>#getLang('','Filtre',57460)#</cfoutput>" id="keyword_" onkeyup="islem_yap();"/>
				</div>
	</cf_box_search>
		<div id="action_div"></div>
	</cf_box>	
<script>
function islem_yap()
{
	deger_ = document.getElementById('keyword_').value.replace("%"," ");
	
	if(deger_.length >= 3)
	{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=retail.emptypopup_select_rival_products&<cfif isdefined("attributes.draggable")>draggable=1&</cfif>op_f_name=#attributes.op_f_name#&type=#attributes.type#&keyword=</cfoutput>' + deger_,'action_div',1);	
	}
}
document.getElementById('keyword').focus();
</script>