<cfset url_string = "">
<cfif isdefined("attributes.company_brands")>
	<cfset url_string = "#url_string#&company_brands=1">
</cfif>
<cfif isdefined("attributes.brand_name")>
	<cfset url_string = "#url_string#&brand_name=#attributes.brand_name#">
</cfif>
<cfif isdefined("attributes.brand_id")>
	<cfset url_string = "#url_string#&brand_id=#attributes.brand_id#">
</cfif>
<cfif isdefined("attributes.brand_code")>
	<cfset url_string = "#url_string#&brand_code=#attributes.brand_code#">
</cfif>
<cfparam name="attributes.keyword" default=''>
<cfquery name="GET_MARK_NAMES" datasource="#DSN1#">
	SELECT
		PB.BRAND_ID,
		PB.BRAND_NAME,
		PB.BRAND_CODE
	FROM
		PRODUCT_BRANDS PB
		<cfif isdefined("attributes.company_brands")>,PRODUCT_BRANDS_OUR_COMPANY PBO</cfif>
	WHERE
		PB.BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		<cfif isdefined("attributes.company_brands")>
			AND PB.BRAND_ID = PBO.BRAND_ID
			AND PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
		</cfif>
	ORDER BY BRAND_NAME
</cfquery>
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_mark_names.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%; height:35px;">
  	<tr>
		<td clasS="headbold"><cf_get_lang no='46.Ürün Markaları'></td>
		<td align="right">
      		<table>
        		<cfform name="search_brand" action="#request.self#?fuseaction=objects2.popup_product_brands&#url_string#" method="post">
          		<tr>
            		<td><cf_get_lang_main no='48.Filtre'>:</td>
            		<td><input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" style="width:100px;"></td>
            		<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
					<td><cf_wrk_search_button></td>
         	 	</tr>
        		</cfform>
      		</table>
    	</td>
  	</tr>
</table>
<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%">
  	<tr clasS="color-border">
    	<td>
      		<table cellpadding="2" cellspacing="1" border="0" style="width:100%">
        		<tr clasS="color-header" style="height:22px;">
          			<td class="form-title" style="width:30px;"><cf_get_lang_main no='75.No'></td>
          			<td class="form-title"><cf_get_lang no='227.Marka'></td>
		  			<td class="form-title"><cf_get_lang no='474.Web'></td>
		  			<td style="width:15px;"><a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_add_product_brands&#url_string#</cfoutput>','small');"><img src="/images/plus_square.gif" border="0"></a></td>
        		</tr>
				<cfif get_mark_names.recordcount>
			  		<cfoutput query="get_mark_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
					  		<td>#currentrow#</td>
					  		<td><a href="##" class="tableyazi"  onClick="add_brand('#brand_id#','#brand_name#','#brand_code#')">#brand_name#</a></td>
					  		<td><cfif is_internet eq 1>Web'de Görünür</cfif></td>
					  		<td><a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_product_brands&id=#brand_id#&#url_string#','small');"><img src="/images/update_list.gif" border="0"></a></td>
						</tr>
			  		</cfoutput>
			  	<cfelse>
			  		<tr class="color-row" style="height:20px;">
						<td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			  		</tr>
				</cfif>
      		</table>
    	</td>
  	</tr>
</table>
<cfif isdefined("attributes.keyword")>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:35px;">
    	<tr>
      		<td><cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_product_brands&#url_string#">
			</td>
      		<!-- sil -->
			<td align="right"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
    	</tr>
	</table>
</cfif>
<script language="JavaScript">
document.getElementById('keyword').focus();
function add_brand(id,brand_name,code)
{
	<cfif isdefined("attributes.brand_name")>
		opener.<cfoutput>#brand_name#</cfoutput>.value = brand_name;
	</cfif>
	<cfif isdefined("attributes.brand_id")>
		opener.<cfoutput>#brand_id#</cfoutput>.value = id;
	</cfif>
	window.close();
}
</script>

