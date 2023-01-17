<table cellspacing="0" cellpadding="0" align="center" style="width:100%">
	<tr style="height:20px;">
		<td>
			<cfif isdefined('attributes.is_mini_basket_view') and attributes.is_mini_basket_view eq 1>
				<a href="##" onclick="parent.window.location='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_add_orderww';"><font color="FF0000">>> <cf_get_lang no="130.Sepet Detaya Git"></font></a>
			<cfelse>
				<a href="##" onclick="parent.window.location='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_basket'"><font color="FF0000">>> <cf_get_lang no="130.Sepet Detaya Git"></font></a>
			</cfif>
		</td>
	</tr>
</table>
<iframe src="<cfoutput>#request.self#?fuseaction=objects2.popup_iframe_list_basket<cfif isDefined('attributes.x_is_order_type_') and len(attributes.x_is_order_type_)>&x_is_order_type_=#attributes.x_is_order_type_#</cfif><cfif attributes.is_mini_basket_prices eq 1>&basket_price=1</cfif><cfif isdefined('attributes.is_mini_basket_view') and attributes.is_mini_basket_view eq 1>&basket_view=1</cfif></cfoutput>" name="basket_ww" id="basket_ww" scrolling="auto" frameborder="0" width="100%" height="200"></iframe>
