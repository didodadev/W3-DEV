<cfif isdefined("session.ep.userid") and FileExists("#upload_folder##dir_seperator#widget#dir_seperator#widget.xml")>
	<cfscript>
		myXmlDoc= XmlParse("#upload_folder##dir_seperator#widget#dir_seperator#widget.xml");
		selectedElements = XmlSearch(myXmlDoc, "/widget_table/Widget/");
		for (i = 1; i LTE ArrayLen(selectedElements); i = i + 1)
		{			
			widget_id = selectedElements[i].XmlChildren[1].XmlText;
			widget_head = selectedElements[i].XmlChildren[2].XmlText;	
			widget_url = selectedElements[i].XmlChildren[3].XmlText;
			widget_script = selectedElements[i].XmlChildren[4].XmlText;	
			widget_show_image = selectedElements[i].XmlChildren[5].XmlText;
			widget_record_count = selectedElements[i].XmlChildren[6].XmlText;
			widget_category = selectedElements[i].XmlChildren[7].XmlText;										
		}
	</cfscript>
</cfif>
<cfset category_list = ''>
<cfloop index="aa" from="1" to="#ArrayLen(selectedElements)#">
	<cfif not find(selectedElements[aa].XmlChildren[7].XmlText,category_list)>
		<cfset category_list = listAppend(category_list,selectedElements[aa].XmlChildren[7].XmlText,',')>
    </cfif>
</cfloop>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29810.RSS Listeleri'></cfsavecontent>
<cf_box title="#message#" closable="0" collapsable="0" style="width:100%; margin-right:5px;">
	<table class="ajax_list">
       	<cfloop index="bb" from="1" to="#ListLen(category_list)#">
            <tr>
                <th>
					<cfoutput>
                        <a href="javascript://" onclick="gizle_goster(document.getElementById('kontrol_#bb#'));">#ListGetAt(category_list,bb)#</a>                            	
                   </cfoutput>
               </th>
            </tr>
            	<cfoutput>
                    <tr id="kontrol_#bb#" style="display:none">
                    	<td>
                        	<table width="100%">
								<cfloop index="aa" from="1" to="#ArrayLen(selectedElements)#">
									<cfif selectedElements[aa].XmlChildren[7].XmlText eq ListGetAt(category_list,bb)>
                                        <tr>
                                            <td>
                                                &nbsp;&nbsp;<a href="javascript://" class="tableyazi" onclick="gonder_wrk_widget('#selectedElements[aa].XmlChildren[1].XmlText#');">#selectedElements[aa].XmlChildren[2].XmlText#</a>
                                            </td>
                                        </tr>  
                                    </cfif> 
					            </cfloop>
                            </table>
                        </td>
                    </tr>
                </cfoutput>
		</cfloop>
	</table>
</cf_box>
<script>
	function gonder_wrk_widget(widget_id)
	{
		var adres_='<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_widget_xml</cfoutput>';
		adres_=adres_ + '&wid=' + widget_id ;  
		AjaxPageLoad(adres_,'widget_deneme',1,'Yükleniyor');	
		gizle(widget);
		alert("<cf_get_lang dictionary_id='60335.Seçim işlemi başarılı'>. <cf_get_lang dictionary_id='35615.Lütfen sayfayı yenileyin'>");
	}
</script>



