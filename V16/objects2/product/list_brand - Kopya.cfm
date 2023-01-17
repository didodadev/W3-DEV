<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfquery name="GET_BRANDS" datasource="#DSN#">
	SELECT
		BRAND_ID,
		BRAND_NAME
	FROM
		SETUP_BRAND
		<cfif len(attributes.keyword)>
            WHERE
                BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
        </cfif>
	ORDER BY
		BRAND_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_brands.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
  	<tr>
    	<td class="headbold"><cf_get_lang no='46.Markalar'></td>
        <td  style="text-align:right;">
            <cfform name="list_brand" method="post" action="#request.self#?fuseaction=objects.popup_list_brand">        
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'>:</td>
                    <input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
                    <input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
                    <td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#"></td>
                    <td><cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" style="width:25px;"></td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
            </cfform>
    	</td>
  	</tr>
</table>
<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:98%;">
  	<tr class="color-border">
    	<td>
      		<table border="0" cellspacing="1" cellpadding="2" style="width:100%;">
        		<tr class="color-header" style="height:22px;">
          			<td class="form-title"><cf_get_lang no='770.Marka'></td>
        		</tr>
		  		<cfif get_brands.recordcount>
          			<cfoutput query="get_brands" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            			<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
              				<td><a href="javascript://" onClick="gonder('#brand_name#','#brand_id#')" class="tableyazi">#brand_name#</a></td>
            			</tr>
          			</cfoutput>
          		<cfelse>
          			<tr class="color-row" style="height:20px;">
            			<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
          			</tr>
        		</cfif>
      		</table>
    	</td>
  	</tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif len(attributes.keyword)>
    	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.field_name)>
		<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
	</cfif>
	<cfif len(attributes.field_id)>
    	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
	</cfif>
	<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%; height:35px;">
	  	<tr>
			<td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects.popup_list_brand&#url_str#"></td>
			<!-- sil -->
			<td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
	  	</tr>
	</table>
</cfif>
<script type="text/javascript">
	function gonder(brand_name,brand_id)
	{
		opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = brand_name;
		opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = brand_id;
		window.close();
	}
</script>
