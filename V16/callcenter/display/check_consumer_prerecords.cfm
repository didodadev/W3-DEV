<!--- 
	Bu sayfanın aynısı CalCenter modulu altında bulunmaktadır. 
	Burada yapılan degisiklikler oraya da yansıtılmalıdır.
	Not: Burada member modülüne yetkisi yoksa link gelmiyor. Memberden farklı olarak.
	BK 051026
 --->
<cfscript>
	attributes.consumer_name = trim(attributes.consumer_name);
	attributes.consumer_surname = trim(attributes.consumer_surname);
	attributes.tax_no = trim(attributes.tax_no);
</cfscript>
<cfquery name="GET_CONSUMER" datasource="#dsn#">
	SELECT 
		CONSUMER.CONSUMER_ID,
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME,
		CONSUMER.COMPANY,
		CONSUMER.TAX_NO,
		CONSUMER.CONSUMER_WORKTELCODE,
		CONSUMER.CONSUMER_WORKTEL,
		CONSUMER_CAT.CONSCAT
	FROM
		CONSUMER,
		CONSUMER_CAT
	WHERE
		CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID AND
		(
			CONSUMER.CONSUMER_ID IS NULL
			<cfif len(attributes.consumer_name) or len(attributes.consumer_surname)>
				<cfif database_type is "MSSQL">
					OR CONSUMER.CONSUMER_NAME + ' '+ CONSUMER.CONSUMER_SURNAME = '#attributes.consumer_name# #attributes.consumer_surname#'
				<cfelseif database_type is "DB2">
					OR CONSUMER.CONSUMER_NAME ||' '|| CONSUMER.CONSUMER_SURNAME = '#attributes.consumer_name# #attributes.consumer_surname#'
				</cfif>
			</cfif>
			<cfif len(attributes.tax_no)>OR CONSUMER.TAX_NO = '#attributes.tax_no#'</cfif>
		)
</cfquery>
<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr>
	<td height="35" class="headbold"><cf_get_lang dictionary_id="55473.Benzer Kriterlerde Kayitlar Bulundu">!</td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr height="22" class="color-header">
            <td class="form-title" width="25"><cf_get_lang_main no='75.No'></td>
			<td class="form-title" nowrap><cf_get_lang_main no='158.Ad Soyad'></td>
			<td class="form-title" nowrap><cf_get_lang_main no='74.Kategori'></td>
			<td class="form-title" nowrap width="120"><cf_get_lang dictionary_id="57750.İşyeri Adı"></td>
            <td class="form-title" width="80"><cf_get_lang dictionary_id="57752.Vergi No"></td>
            <td class="form-title" nowrap width="80"><cf_get_lang_main no='87.Telefon'></td>
		  </tr>
		  <form name="search_" id="search_" method="post" action="">
		  <cfif get_consumer.recordcount>
			  <cfoutput query="get_consumer">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#currentrow#</td>
				<cfif get_module_user(4)>
					<td nowrap><a href="://javascript" onClick="control(1,#consumer_id#);" class="tableyazi">#consumer_name# #consumer_name#</a></td>
				<cfelse>
					<td nowrap>#consumer_name# #consumer_name#</td>				
				</cfif>
				<td>#conscat#</td>
				<td>#company#</td>
				<td>#tax_no#</td>
				<td>#consumer_worktelcode# #consumer_worktel#</td>
			</tr>
			</cfoutput>
			<tr class="color-row">
			<td height="35" colspan="8" style="text-align:right;"><input type="submit" name="Devam" id="Devam" value=" Varolan Kayıtları Gözardi Et " onClick="control(2,0);"></td>
			</tr>
			<cfelse>
				<tr class="color-row">
					<td height="20" colspan="8"><cf_get_lang_main no='72.Kayit Bulunamadi'> !</td>
				</tr>
			</cfif>
			</form>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
<cfif not get_consumer.recordcount>
	opener.add_consumer.submit();
	window.close();
</cfif>
function control(id,value)
{
	if(id==1)
	{
		opener.location.href='<cfoutput>#request.self#?fuseaction=member.consumer_list&event=det&is_search=1&cid=</cfoutput>' + value;
		window.close();
	}
	if(id==2)
	{
		
		opener.add_consumer.submit();
		window.close();
	}
}
</script>
