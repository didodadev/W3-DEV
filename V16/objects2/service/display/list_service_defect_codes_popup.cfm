<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_form_submitted" default="0">
<cfif isDefined('attributes.is_form_submitted') and attributes.is_form_submitted eq 1>
    <cfquery name="GET_SERVICE_CODES" datasource="#DSN3#">
        SELECT 
            SERVICE_CODE_ID,
            SERVICE_CODE,
            SERVICE_CODE_DETAIL
        FROM 
            SETUP_SERVICE_CODE 
            <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                WHERE
                    SERVICE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    SERVICE_CODE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_service_codes.recordcount = 0>
</cfif>
<cfset url_string = "">
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_code")>
	<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_service_codes.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1 >
<cfform name="search_product" action="#request.self#?fuseaction=#attributes.fuseaction#&#url_string#" method="post">
	<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
    <table cellpadding="0" cellspacing="0" align="center" class="color-border" style="width:98%; height:35px;">
        <tr>
        	<td class="headbold">Arıza Kodları</td>
            <td>
            	<table align="right">
                    <tr>
                        <td><cf_get_lang_main no='48.Filtre'></td>
                        <td><input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="50" style="width:100px;"></td>
                    	<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        	<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" maxlength="3" onKeyUp="isNumber(this);" range="1," required="yes" message="#message#" style="width:25px;"></td>
                    	<td><cf_wrk_search_button></td>
                    </tr>
				</table>        
            </td>
        </tr>
    </table>
</cfform>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<thead>
        <tr class="color-header" style="height:22px;">
            <th class="form-title" style="width:150px;"><cf_get_lang_main no='1522.Arıza Kodu'></th>
            <th class="form-title"><cf_get_lang_main no='217.Açıklama'></th>
        </tr>
    </thead>
    <tbody>
    <cfif get_service_codes.recordcount>
        <cfoutput query="get_service_codes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr class="color-row" style="height:20px;">
                <td><a href="javascript://" class="tableyazi" onclick="gonder('#service_code_id#','#service_code#');">#service_code#</a></td>
                <td>#service_code_detail#</td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr style="height:20px;">
            <td colspan="2"><cfif isDefined('attributes.is_form_submitted') and attributes.is_form_submitted eq 0><cf_get_lang_main no='289.Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</cfif></td>
        </tr>
    </cfif>
    </tbody>
</table>
<cfif attributes.maxrows lt attributes.totalrecords>
	<table cellpadding="2" cellspacing="0" border="0" style="text-align:center; width:98%">
  		<tr height="2">
			<td>
		  		<cfset adres = attributes.fuseaction>
                <cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
		  		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
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
    		<!-- sil -->
			<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
  		</tr>
  	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gonder(s_code_id,s_code)
	{
		<cfif isDefined('attributes.field_id')>
			opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = s_code_id;
		</cfif>
		<cfif isDefined('attributes.field_code')>
			opener.document.<cfoutput>#attributes.field_code#</cfoutput>.value = s_code;
		</cfif>
		<cfif isDefined('attributes.field_name')>
			opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = s_code;
		</cfif>
		//opener.bosalt();
		//opener.butonlari_goster();
		window.close();
	}
</script>
