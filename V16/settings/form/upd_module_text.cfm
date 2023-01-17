<cfparam name="attributes.language" default="tr">
<cfset attributes.upload_folder = '#server.coldfusion.rootdir##dir_seperator#CustomTags#dir_seperator#'>
<cffile action="read" file="#attributes.upload_folder#language.xml" variable="xmldosyam" charset = "UTF-8">
<cfscript>
	dosyam = XmlParse(xmldosyam);
	xml_dizi = dosyam.LANG.XmlChildren;
	d_boyut = ArrayLen(xml_dizi);
</cfscript>	

<cfform name="add_new_text" action="#request.self#?fuseaction=settings.emptypopup_upd_new_text" method="post" >
        <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
		<tr class="color-list">
      <td class="headbold" height="35">&nbsp;<cf_get_lang no='618.Kelime Güncelle'></td>
    </tr>
          <tr>
            <td class="color-row" valign="top">
              <table>
                <tr>
                  <td width="100"><cf_get_lang no='195.Modül'></td>
                  <td>
					  <input type="hidden" name="module_name" id="module_name"  value="<cfoutput>#attributes.module_name#</cfoutput>">
					    <input type="hidden" name="id" id="id"  value="<cfoutput>#attributes.id#</cfoutput>">
					  <cfoutput>#attributes.module_name#</cfoutput>
                   </td>
                </tr>
                <tr>
                  <td><cf_get_lang no='52.Türkçe'></td>
                  <td>
				  <cfscript>
						search_text="LANG/tr/#attributes.module_name#/";
						selectedElements = XmlSearch(dosyam,search_text);
				  </cfscript>
                    <input type="text" name="sub_modulename_1" id="sub_modulename_1" value="<cfoutput>#selectedElements[attributes.id].ITEM.XmlText#</cfoutput>" style="width:250px;" >
 				  </td>
                </tr>
                <tr>
                  <td><cf_get_lang no='53.İngilizce'></td>
                  <td>
					  <cfscript>
						   search_text="LANG/eng/#attributes.module_name#/";
						   selectedElements = XmlSearch(dosyam,search_text);
					  </cfscript>				  
                     <input type="text" name="sub_modulename_2" id="sub_modulename_2" value="<cfoutput>#selectedElements[attributes.id].ITEM.XmlText#</cfoutput>" style="width:250px;" >
					 
 				  </td>
                </tr>				
				<tr>
					<td colspan="2" align="right" style="text-align:right;">
						 <cf_workcube_buttons is_upd='0'> 
					</td>
				</tr>
              </table>
            </td>
          </tr>
        </table>
</cfform>

