<cfset attributes.CLASS_ID = attributes.ID>
<cfinclude template="../query/get_class_eval_note.cfm">
<cfinclude template="../display/view_class.cfm">
<table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="35" class="headbold">&nbsp;<cf_get_lang no='215.Eğitim Katılım Formu Görüşler'></td>
	</tr>
</table>
<table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="color-border">
    <td>
		<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
			  <tr class="color-row">
			<td valign="top">
					<table border="0" width="100%">
                      <tr height="25" class="formbold">
                        <td><cf_get_lang_main no='158.Ad Soyad'></td>
                        <td><cf_get_lang no='249.Görüşleri'></td>
                      </tr>
					  <cfoutput query="get_note">
						  <tr class="COLOR-LIST">
							<td width="100" height="20" class="txtboldblue">#AD#</td>
							<td>#DETAIL#</td>
						  </tr>
					  </cfoutput>
                    </table>
				 </td>
			  </tr>
		</table>
	</td>
  </tr>
</table>
