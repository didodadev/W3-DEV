<cfif not isdefined("attributes.row_id")>
	<!--- Pda Secimi Icin Kendi Klasorundeki Veriler Kullanilacagindan Folder Tanimi Yapildi FBS 20111001 --->
	<cfif isdefined("attributes.is_pda") and Len(attributes.is_pda)> 
		<cfset folder_ = "workcube_pda">
		<cfset faction_ = "faction_list_pda.xml">
	<cfelse>
		<cfset folder_ = "objects2">
		<cfset faction_ = "faction_list.xml">
	</cfif>
	<cffile action="read" file="#GetDirectoryFromPath(GetTemplatePath())#V16#dir_seperator##folder_##dir_seperator#xml#dir_seperator##faction_#" variable="xmldosyam" charset="UTF-8">
	<cfscript>
		dosyam = XmlParse(xmldosyam);
		xml_dizi = dosyam.SETUP_SITE.XmlChildren;
		d_boyut = ArrayLen(xml_dizi);
	</cfscript>
	<cffile action="read" file="#GetDirectoryFromPath(GetTemplatePath())#V16#dir_seperator#add_options#dir_seperator#xml#dir_seperator##faction_#" variable="xmldosyam2" charset="UTF-8">
	<cfscript>
		dosyam2 = XmlParse(xmldosyam2);
		xml_dizi2 = dosyam2.SETUP_SITE.XmlChildren;
		d_boyut2 = ArrayLen(xml_dizi2);
	</cfscript>
	<cfset folder_list = "">
	<cfset selectedElements = XmlSearch(dosyam,"/SETUP_SITE/SETUPSITE/LINK_FOLDER/")>
	<cfscript>
		for (dl = 1; dl LTE ArrayLen(selectedElements); dl = dl + 1)
			if(not listfindnocase(folder_list,selectedElements[dl].XmlText))
				folder_list = listappend(folder_list,selectedElements[dl].XmlText);
	</cfscript>
	
	<cfset folder_list2 = "">
	<cfset selectedElements2 = XmlSearch(dosyam2,"/SETUP_SITE/SETUPSITE/LINK_FOLDER/")>
	<cfscript>
		for (fl = 1; fl LTE ArrayLen(selectedElements2); fl = fl + 1)
			if(not listfindnocase(folder_list2,selectedElements2[fl].XmlText))
				folder_list2 = listappend(folder_list2,selectedElements2[fl].XmlText);
	</cfscript>	

</cfif>
<cfquery name="get_menu_name" datasource="#dsn#">
	SELECT MENU_NAME FROM MAIN_MENU_SETTINGS WHERE MENU_ID = #attributes.menu_id#
</cfquery>
<table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%" class="color-border">
  <tr class="color-list">
    <td height="35" class="headbold" colspan="3"><cfoutput>#getLang('settings',2498)# : #get_menu_name.menu_name#</cfoutput></td>
  </tr>
  <tr class="color-row">
  	<cfif not isdefined("attributes.row_id")>
	<td width="220" valign="top">
		<div id="cont" style="width:220px;height:520px;z-index:1;overflow:auto;">
			<cfoutput>
			<table width="98%" align="center">
				<cfset count_ = 0>
				<cfloop list="#folder_list#" index="mmk">
					<cfset count_ = count_ + 1>
					<tr class="color-list" height="20"><td onMouseOver="style.cursor='hand';" onClick="hepsini_gizle('#count_#');">>> #mmk#</td></tr>
					<tr style="display:none;" id="klasor_#count_#">
						<td><cfloop index="i" from="1" to="#d_boyut#">
								<cfif selectedElements[i].XmlText is '#mmk#'>
									<cfset name = dosyam.SETUP_SITE.SETUPSITE[i].LINK_NAME.XmlText>
									<cfset folder_name = dosyam.SETUP_SITE.SETUPSITE[i].LINK_FOLDER.XmlText>
									<cfset file_name = dosyam.SETUP_SITE.SETUPSITE[i].LINK_FILE.XmlText>
									<cfset link_detail = dosyam.SETUP_SITE.SETUPSITE[i].LINK_DETAIL.XmlText>
									<cfset link_xml = dosyam.SETUP_SITE.SETUPSITE[i].LINK_XML.XmlText>
									<cfoutput>
										<li><a href="#request.self#?fuseaction=protein.popup_change_object_property&link_xml=#link_xml#&object_folder=#folder_name#&file_name=#file_name#&name=#name#&menu_id=#attributes.menu_id#&faction=#attributes.faction#<cfif isDefined("attributes.is_pda")>&is_pda=1</cfif>&col_id=#attributes.col_id#" title="#link_detail#" class="tableyazi" target="change_window">#name#</a></li><br>
									</cfoutput>
								</cfif>
							 </cfloop>
						</td>
					</tr>
				</cfloop>
				<tr>
					<td class="formbold"><cfoutput>#getLang('settings',1647)#</cfoutput></td>
				</tr>
                <cfif len(folder_list2)>
                    <cfloop list="#folder_list2#" index="mmk">
                    <cfset count_ = count_ + 1>
                        <tr class="color-list" height="20"><td onMouseOver="style.cursor='hand';" onClick="hepsini_gizle('#count_#');">>> #mmk#</td></tr>
                        <tr style="display:none;" id="klasor_#count_#">
                            <td><cfloop index="i" from="1" to="#d_boyut2#">
                                    <cfif selectedElements2[i].XmlText is '#mmk#'>
                                        <cfset name = dosyam2.SETUP_SITE.SETUPSITE[i].LINK_NAME.XmlText>
                                        <cfset folder_name = dosyam2.SETUP_SITE.SETUPSITE[i].LINK_FOLDER.XmlText>
                                        <cfset file_name = dosyam2.SETUP_SITE.SETUPSITE[i].LINK_FILE.XmlText>
                                        <cfset link_detail = dosyam2.SETUP_SITE.SETUPSITE[i].LINK_DETAIL.XmlText>
                                        <cfset link_xml = dosyam2.SETUP_SITE.SETUPSITE[i].LINK_XML.XmlText>
                                        <cfoutput>
                                            <li><a href="#request.self#?fuseaction=protein.popup_change_object_property&link_xml=#link_xml#&object_folder=#folder_name#&file_name=#file_name#&name=#name#&menu_id=#attributes.menu_id#&faction=#attributes.faction#<cfif isDefined("attributes.is_pda")>&is_pda=1</cfif>&col_id=#attributes.col_id#" title="#link_detail#" class="tableyazi" target="change_window">#name#</a></li><br>
                                        </cfoutput>
                                    </cfif>
                                 </cfloop>
                            </td>
                        </tr>
                    </cfloop>
                <cfelse>
                	 <tr class="color-list" style="height:20px;">
                     	<td><cf_get_lang_main no='72.Kayıt Yok'></td>
                     </tr>
                </cfif>                 
			</table> 
			</cfoutput>
		</div>
	</td>
	</cfif>
	<td valign="top" width="460"colspan="2">
		<iframe frameborder="0" src="<cfoutput>#request.self#?fuseaction=protein.popup_change_object_property<cfif isdefined("attributes.row_id")>&row_id=#attributes.row_id#</cfif><cfif isDefined("attributes.is_pda")>&is_pda=1</cfif>&col_id=#attributes.col_id#</cfoutput>" width="100%" height="500" name="change_window" id="change_window" scrolling="auto"></iframe>
	</td>
  </tr>
</table>
<cfif not isdefined("attributes.row_id")>
	<script type="text/javascript">
	function hepsini_gizle(c)
	{
	<cfset count_ = 0>
	<cfoutput>
	<cfloop list="#folder_list#" index="mmk">
	<cfset count_ = count_ + 1>
		if(#count_#!=c)
			gizle(klasor_#count_#);
	</cfloop>
		gizle_goster(eval("klasor_"+c));
	</cfoutput>
	}
	</script>
</cfif>
