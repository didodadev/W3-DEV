<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_form_submitted" default="0">
<cfif isDefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
	<cfquery name="GET_BRANDS" datasource="#DSN1#">
		SELECT
			PB.BRAND_ID,
            PB.BRAND_NAME,
            PB.BRAND_CODE,
            PB.IS_INTERNET
		FROM
			PRODUCT_BRANDS PB,
			PRODUCT_BRANDS_OUR_COMPANY PBO
		WHERE
        	PB.IS_INTERNET = 1 AND
			PB.BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND 
            PB.BRAND_ID = PBO.BRAND_ID AND 
            PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
		ORDER BY 
        	PB.BRAND_NAME
	</cfquery>
<cfelse>
	<cfset get_brands.recordcount = 0>
</cfif>
<cfset url_string = "">
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_code")>
	<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
</cfif>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_brands.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="search_brand" action="#request.self#?fuseaction=#attributes.fuseaction#&#url_string#" method="post">
    <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
    <table cellpadding="0" cellspacing="0" align="center" class="color-border" style="width:98%; height:35px;">
        <tr>
            <td class="headbold">Markalar</td>
            <td>
                <table style="text-align:right;">
                    <tr>
                        <td><cf_get_lang_main no='48.Filtre'></td>
                        <td><input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="50" style="width:100px;"></td>
                        <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" maxlength="3" required="yes" onKeyUp="isNumber(this);" range="1,999" message="#message#" style="width:25px;"></td>
                        <td><cf_wrk_search_button></td>
                    </tr>
                </table>        
            </td>
        </tr>
    </table>
</cfform>
<table border="0" align="center" cellpadding="0" cellspacing="0" style="width:98%;">
	<thead>
        <tr class="color-header" style="height:22px;">
            <th class="form-title" style="width:150px;">No</th>
            <th class="form-title">Marka</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
    <cfif get_brands.recordcount>
        <cfoutput query="get_brands" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr class="color-row" style="height:20px;">
                <td>#currentrow#</td>
                <td><a href="##" class="tableyazi"  onClick="add_brand('#brand_id#','#brand_name#','#brand_code#');">#brand_name#</a></td>
                <td><cfif is_internet eq 1>Webde Görünür</cfif></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr style="height:20px;">
            <td colspan="2"><cfif isDefined('attributes.is_form_submitted') and attributes.is_form_submitted eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayit Bulunamadi'>!</cfif></td>
        </tr>
    </cfif>
    </tbody>
</table>

<cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:99%; height:35px;">
		<tr>
	  		<td>
            	<cfset adres = attributes.fuseaction>
                <cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
				<cfif isdefined("attributes.keyword")>
                    <cfset adres = "#adres#&keyword=#attributes.keyword#">
                </cfif>
		  		<cfif len(url_string)>
					<cfset adres = "#adres##url_string#">
		  		</cfif>
            	<cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#adres#">
            </td>
	 		<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
  	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function add_brand(id,brand_name,code)
	{
		<cfif isdefined("attributes.field_id")>
			opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_code")>
			opener.document.<cfoutput>#attributes.field_code#</cfoutput>.value = code;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			x = opener.document.<cfoutput>#attributes.field_name#</cfoutput>.length;
			if(x != undefined)
			{
				opener.document.<cfoutput>#attributes.field_name#</cfoutput>.length = parseInt(x + 1);
				opener.document.<cfoutput>#attributes.field_name#</cfoutput>.options[x].value = id;
				opener.document.<cfoutput>#attributes.field_name#</cfoutput>.options[x].text = brand_name;
			}
			else
			{
				opener.<cfoutput>#attributes.field_name#</cfoutput>.value = brand_name;
				window.close();
			}
		</cfif>		
	}
</script>
