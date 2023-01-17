<cfif attributes.is_mini_basket_prices eq 1>
	<iframe src="<cfoutput>#request.self#?fuseaction=objects2.popup_iframe_list_basket_camp&basket_price=1</cfoutput>" name="basketww_camp" id="basketww_camp" scrolling="auto" frameborder="0" width="100%" height="200"></iframe>
<cfelse>
	<iframe src="<cfoutput>#request.self#?fuseaction=objects2.popup_iframe_list_basket_camp</cfoutput>" name="basketww_camp" id="basketww_camp" scrolling="auto" frameborder="0" width="100%" height="200"></iframe>
</cfif>
