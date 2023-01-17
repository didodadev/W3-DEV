<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfparam name="attributes.is_form_submitted" default="0">

<cfif isDefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
    <cfquery name="GET_SHIP_METHODS" datasource="#DSN#">
        SELECT 
            SHIP_METHOD_ID, 
            SHIP_METHOD,
            IS_OPPOSITE 
        FROM 
            SHIP_METHOD 
            <cfif len(attributes.keyword)>
                WHERE SHIP_METHOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif> 
        ORDER BY 
            SHIP_METHOD
    </cfquery>
<cfelse>
	<cfset get_ship_methods.recordcount = 0>
</cfif>

<cfset url_str = "">
<cfif isdefined('attributes.field_id') and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined('attributes.field_name') and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_ship_methods.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_brand_type_cat" method="post" action="#request.self#?fuseaction=objects.popup_list_ship_methods&#url_str#"> 
    <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
    <table cellpadding="0" cellspacing="0" align="center" style="width:98%; height:35px;">
        <tr>
            <td class="headbold">Sevk Yöntemleri</td>
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
            <th class="form-title">Sevk Yöntemi</th>
        </tr>
    </thead>
    <tbody>
		<cfif get_ship_methods.recordcount>
			<cfoutput query="get_ship_methods" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr class="color-row" style="height:20px;">
                    <td><a href="javascript://" onClick="add_ship_method('#ship_method_id#','#ship_method#');" class="tableyazi">#ship_method#</a>		
                    <cfif is_opposite eq 1> - Karşı Ödemeli</cfif>
                    </td>
                </tr>
            </cfoutput>
		<cfelse>
		  	<tr>
				<td colspan="3"><cfif isDefined('attributes.is_form_submitted') and attributes.is_form_submitted eq 0><cf_get_lang_main no='289.Filtre Ediniz'><cfelse><cf_get_lang_main no='72.Kayıt Yok'></cfif></td>
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
				<cfif len(attributes.keyword)>
                    <cfset adres = "#adres#&keyword=#attributes.keyword#">
                </cfif>
                <cfif isdefined("attributes.call_function") and len(attributes.keyword)>
                    <cfset adres = "#adres#&call_function=#attributes.call_function#">
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
	function add_ship_method(field_id,field_name)
	{
		<cfif isdefined("attributes.field_id")>
			opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = field_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = field_name;
		</cfif>
		<cfif isdefined("attributes.call_function")>
			try{opener.document.<cfoutput>#attributes.call_function#</cfoutput>;}
				catch(e){};
		</cfif>
		window.close();
	}
</script>
