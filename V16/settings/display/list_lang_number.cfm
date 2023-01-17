<!--- Created Filiz 20071206 Site Tasarımı icin olusturuldu --->
<cfset url_string = "">
<cfif isdefined("attributes.item")>
	<cfset url_string = "#url_string#&item=#attributes.item#">
</cfif>
<cfif isdefined("attributes.item_id")>
	<cfset url_string = "#url_string#&item_id=#attributes.item_id#">
</cfif>
<cfif isdefined("attributes.field_type")>
	<cfset url_string = "#url_string#&field_type=#attributes.field_type#">
</cfif>
<cfif isdefined("attributes.field_name2")>
	<cfset url_string = "#url_string#&field_name2=#attributes.field_name2#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.lang" default="tr">
<cfparam name="attributes.module_name" default="">
<cfquery name="get_language" datasource="#dsn#">
	SELECT * FROM SETUP_LANGUAGE
</cfquery>
<cfif isdefined("attributes.form_submit")>	
	<cfset db_name = "SETUP_LANGUAGE_#UCASE(attributes.lang)#">
    <cfquery name="get_val" datasource="#dsn#">
        SELECT
            *
        FROM
            #db_name#
        WHERE
            ( ITEM LIKE'%#attributes.keyword#%'
            <cfif isnumeric(attributes.keyword)>OR ITEM_ID = #attributes.keyword#</cfif> )
            <cfif len(attributes.module_name) and attributes.module_name is 'main'>
                AND MODULE_ID = 'main'
            <cfelseif  len(attributes.module_name) and attributes.module_name is 'objects2'>
                AND MODULE_ID = 'objects2'
            <cfelse>
                AND 
                (MODULE_ID = 'main' OR MODULE_ID = 'objects2')
            </cfif>
        ORDER BY
            MODULE_ID
    </cfquery>
<cfelse>
	<cfset get_val.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_val.recordcount#">
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfform name="form" action="#request.self#?fuseaction=settings.popup_list_lang_number#url_string#" method="post">
		<input type="hidden" name="form_submit" id="form_submit" value="1">
		<tr>
			<td class="headbold"><cf_get_lang_main no='520.Sözlük'></td>
			<td>
			<table align="right">
				<tr>
					<td><cf_get_lang_main no='48.Filtre'>:</td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                    <td>
                    	<select name="module_name" id="module_name">
							<option value=""><cf_get_lang no='195.Modül'></option>
							<option value="main"<cfif 'main' is attributes.module_name> selected</cfif>> Main</option>
							<option value="objects2"<cfif 'objects2' is attributes.module_name> selected</cfif>> Objects2</option>					   
						</select>
                    </td>
					<td><select name="lang" id="lang">
							<cfoutput query="get_language">
								<option value="#language_short#" <cfif attributes.lang eq language_short>selected</cfif>>#language_set#</option>
							</cfoutput>
						</select>
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>
			</td>
		</tr>	
	</cfform>
</table>
<table cellpadding="2" cellspacing="1" border="0" width="98%" class="color-border" align="center">
	<tr class="color-header" height="22">
		<td class="form-title" width="50" align="center"><cf_get_lang no='195.Modül'></td>
		<td class="form-title" width="50" align="center"><cf_get_lang no='1541.Dil No'></td>
		<td class="form-title"><cf_get_lang no='319.Kelime'></td>
		<td class="form-title" width="30" align="center"><cf_get_lang_main no='1584.Dil'></td>
	</tr>
	<cfif isdefined("attributes.form_submit") or len(attributes.keyword)>	
		<cfif get_val.recordcount>
			<cfoutput query="get_val" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
            	<cfif module_id is 'main'>
                	<cfset my_type = 1>
                <cfelse>
                	<cfset my_type = 2>
                </cfif>
				<tr class="color-row" height="20">
					<td align="center">#module_id#</td>
					<td align="center"><a href="##" onClick="add_language('#item_id#','#Replace(Replace(item,"'"," ","all"),'"',' ','all')#','#my_type#');" class="tableyazi">#item_id#</a></td>
					<td>#item#</td>						
					<td align="center">#ucase(attributes.lang)#</td>
				</tr>
			</cfoutput>
		<cfelse>
		  <tr class="color-row">
			<td height="20" colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		  </tr>
		</cfif>
	<cfelse>
		<tr class="color-row">
			<td height="20" colspan="4"><cf_get_lang_main no='289.Filtre Ediniz'>!</td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" width="99%">
		<tr> 																																																							
			<td>
				<cfset adres = "#attributes.fuseaction#">
				<cfif isdefined('attributes.form_submit')>
					<cfset adres = "#adres#&form_submit=1">
				</cfif>
				<cfif len(attributes.keyword)>
					<cfset adres = "#adres#&keyword=#attributes.keyword#"> 
				</cfif>
				<cfif isdefined("attributes.lang") and len(attributes.lang)>
					<cfset adres = "#adres#&lang=#attributes.lang#">
				</cfif>
				<cfif isdefined("attributes.module_name") and len(attributes.module_name)>
					<cfset adres = "#adres#&module_name=#attributes.module_name#">
				</cfif>
					<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres##url_string#"> 
			</td>
			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil --> 
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function add_language(id,isim,type)
	{
		<cfif isdefined("attributes.item")>
			opener.<cfoutput>#item#</cfoutput>.value = isim;
		</cfif>
		<cfif isdefined("attributes.item_id")>
			opener.<cfoutput>#item_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_type")>
			opener.<cfoutput>#field_type#</cfoutput>.value = type;
		</cfif>
		<cfif isdefined("attributes.field_name2")>
			opener.<cfoutput>#field_name2#</cfoutput>.value = '';
		</cfif>
		window.close();
	}
</script>
