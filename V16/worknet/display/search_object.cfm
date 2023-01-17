<cfsetting showdebugoutput="no">
<cfif attributes.searchtype eq 1> 
	<cfform name="search_company" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_company" method="post">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<cf_get_lang_main no='48.Filtre'>
		<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:400px;">
		<cfsavecontent variable="text"><cf_get_lang_main no='167.Sektör'></cfsavecontent>
		<cf_wrk_selectlang 
			name="sector"
			option_name="sector_cat"
			option_value="sector_cat_id"
			width="150"
			table_name="SETUP_SECTOR_CATS"
			option_text="#text#" value=#attributes.sector#>
		<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		<cf_wrk_search_button is_excel="0" button_type="1"  search_function="searchControl()">
	</cfform>
<cfelseif attributes.searchtype eq 2>
	<div style="position:absolute; margin-top:30px;" id="showCategory"></div>
	<cfform name="search_product" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product" method="post">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<cf_get_lang_main no='48.Filtre'>
		<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:300px;">
		<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>" />
		<input type="text" name="product_cat" id="product_cat" style="width:300px;" value="<cfoutput>#attributes.product_cat#</cfoutput>" onfocus="goster(showCategory);openProductCat();" readonly="" />
		<a href="javascript://" onClick="goster(showCategory);openProductCat();" class="tableyazi" title="Yeni kategori Seç">Yeni kategori Seç</a>
		<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		<cf_wrk_search_button is_excel="0" button_type="1"  search_function="searchControl()">
	</cfform>
	<script language="javascript">
		function openProductCat()
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
		}
	</script>
<cfelse>
	<cfform name="search_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_demand" method="post">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<cf_get_lang_main no='48.Filtre'>:
		<cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:200px;">
		
		<cf_get_lang_main no ='246.Üye'>
		<input type="text" name="member_name" id="member_name" value="<cfif isdefined('attributes.member_name') and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" style="width:125px;">
		
		<cfsavecontent variable="text"><cf_get_lang_main no='167.Sektör'></cfsavecontent>
		<cfif isdefined("attributes.sector") and len(attributes.sector)><cfset attributes.sector = attributes.sector><cfelse><cfset attributes.sector = ''></cfif>
		<cf_wrk_selectlang 
			name="sector"
			option_name="sector_cat"
			option_value="sector_cat_id"
			width="150"
			table_name="SETUP_SECTOR_CATS"
			option_text="#text#" value="#attributes.sector#">

			<select name="demand_type">
				<option value="0" <cfif isdefined("attributes.demand_type") and attributes.demand_type eq 0>selected</cfif>><cf_get_lang_main no ='296.Tümü'></option>
				<option value="1" <cfif isdefined("attributes.demand_type") and attributes.demand_type eq 1>selected</cfif>><cf_get_lang no ='79.Alım'></option>
				<option value="2" <cfif isdefined("attributes.demand_type") and attributes.demand_type eq 2>selected</cfif>><cf_get_lang no ='80.Satım'></option>
			</select>
			
		<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		<cf_wrk_search_button is_excel="0" button_type="1"  search_function="searchControl()">
	</cfform>
</cfif>

<script language="javascript">
	function searchControl()
	{
		/*if(document.getElementById('keyword').value == '' || document.getElementById('keyword').value.length < 3)
		{
			alert('Lütfen filtre alanını giriniz !');
			return false;
		}
		else*/
			return true;
	}
</script>
