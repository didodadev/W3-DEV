<script type="text/javascript">
	function gonder(gelen)
	{
		opener.<cfoutput>#attributes.selected_link#</cfoutput>.value = gelen;
		self.close();
	}
</script>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="35" class="headbold">Dinamik Sayfa Başlıkları</td>
	</tr>
</table>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr class="color-border">
		<td valign="top">
		<table width="100%" cellpadding="2" cellspacing="1" border="0">
			<tr class="color-header" height="22">
				<td class="form-title">No</td>
				<td class="form-title"><cf_get_lang no ='2498.Obje'></td>
				<td class="form-title"><cf_get_lang_main no ='279.Dosya'></td>
				<td class="form-title"><cf_get_lang_main no ='217.Açıklama'></td>
			</tr>
			<cfif isDefined("attributes.is_pda") and attributes.is_pda eq 1>
				<cfquery name="Get_Wbo_Pda" datasource="#dsn#"><!--- DETAIL IS NOT NULL kosulu fuseaction iceriklerinde duzenleme yapildiktan sonra kaldirilacak --->
					SELECT HEAD,FUSEACTION,DETAIL FROM WRK_OBJECTS WHERE IS_ACTIVE = 1 AND MODUL = 'PDA' AND ISNULL(TYPE,0) <> 2 AND WINDOW <> 'emptypopup' AND DETAIL IS NOT NULL
				</cfquery>
				<cfoutput query="Get_Wbo_Pda">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td><a href="javascript://" class="tableyazi" onClick="gonder('#fuseaction#');">#head#</a></td>
						<td>#fuseaction#</td>
						<td>#detail#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<cffile action="read" file="#GetDirectoryFromPath(GetTemplatePath())#admin_tools#dir_seperator#xml#dir_seperator#wbo.xml" variable="xmldosyam" charset="UTF-8">
				<cfscript>
					dosyam = XmlParse(xmldosyam);
					xml_dizi = dosyam.SETUP_SWITCH.XmlChildren;
					d_boyut = ArrayLen(xml_dizi);
				</cfscript>
				<cfloop index="i" from="1" to="#d_boyut#">
					<cfoutput>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<cfset name = dosyam.SETUP_SWITCH.SETUPSWITCH[i].LINK_NAME.XmlText>
						<cfset file_name = dosyam.SETUP_SWITCH.SETUPSWITCH[i].LINK_SWITCH.XmlText>
						<cfset link_detail = dosyam.SETUP_SWITCH.SETUPSWITCH[i].LINK_DETAIL.XmlText>
						<td>#i#</td>
						<cfif isdefined("attributes.is_faction")>
							<td><a href="javascript://" class="tableyazi" onClick="gonder('#file_name#');">#name#</a></td>
						<cfelse>
							<td><a href="javascript://" class="tableyazi" onClick="gonder('objects2.#file_name#');">#name#</a></td>
						</cfif>
						<td>#file_name#</td>
						<td>#link_detail#</td>
					</tr>
					</cfoutput>
				</cfloop>
			</cfif>
		</table>
		</td>
	</tr>
</table>
<br/>
