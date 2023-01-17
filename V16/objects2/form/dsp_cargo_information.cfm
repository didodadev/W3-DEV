<div id="cargo_info_div"></div>
<cfif isdefined("attributes.product_id")>
	<cfset cargo_product_id = attributes.product_id>
<cfelse>
	<cfset cargo_product_id = ''>
</cfif>
<script type="text/javascript">
	function gonder_city()
	{   
		var city_ = document.getElementById('city_id').value;
		if(city_ == '')
		{
			alert('Şehir Seçiniz!');
			return false;
		}
		else
		{
			var adres = '<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_cargo_information&cargo_product_id=#cargo_product_id#</cfoutput>';
			var adres = adres + '&city_id=' + city_;
			AjaxPageLoad(adres,'cargo_info_div',1,'Yükleniyor!');
		}
	}
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_cargo_information&cargo_product_id=#cargo_product_id#</cfoutput>','cargo_info_div',1,'Yükleniyor!');
</script>
