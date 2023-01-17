<cfsetting showdebugoutput="no">
<cfparam name="attributes.order_number" default="1">

<!--- Pda Secimi Icin Kendi Klasorundeki Veriler Kullanilacagindan Folder Tanimi Yapildi FBS 20111001 --->
<cfif isdefined("attributes.is_pda") and Len(attributes.is_pda)> 
	<cfset folder_ = "workcube_pda">
	<cfset faction_ = "faction_list_pda.xml">
<cfelse>
	<cfset folder_ = "objects2">
	<cfset faction_ = "faction_list.xml">
</cfif>
<cfif isdefined("attributes.row_id")>
	<cfquery name="GET_ROW" datasource="#DSN#">
		SELECT 
    	    ROW_ID, 
            OBJECT_POSITION, 
            OBJECT_NAME, 
            FACTION, 
            ORDER_NUMBER, 
            OBJECT_FOLDER, 
            OBJECT_FILE_NAME, 
            MENU_ID, 
            DESIGN_ID, 
            CLASS_CSS_NAME,
			VIEW_TITLE
        FROM 
	        MAIN_SITE_LAYOUTS_SELECTS 
        WHERE 
        	ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
	</cfquery>
	
	<cfquery name="GET_ROW_PROPERTIES" datasource="#DSN#">
		SELECT 
            ROW_ID, 
            PROPERTY_NAME, 
            PROPERTY_VALUE 
        FROM 
    	    MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES 
        WHERE 
	        ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_id#">
	</cfquery>
	<cfset attributes.menu_id = get_row.menu_id>
	<cfset attributes.faction = get_row.faction>
	<cfset attributes.object_folder = get_row.object_folder>
	<cfset attributes.file_name = get_row.object_file_name>
	<cfset attributes.name = get_row.object_name>
	<cfset attributes.order_number = get_row.order_number>
	<cfset attributes.object_position = get_row.object_position>
	<cfset attributes.design_id = get_row.design_id>
	

	
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
	
	<cfset selectedElements = XmlSearch(dosyam,"/SETUP_SITE/SETUPSITE/LINK_FILE/")>
	<cfscript>
		for (dl = 1; dl lte ArrayLen(selectedElements); dl = dl + 1)
			if(selectedElements[dl].XmlText is '#trim(attributes.file_name)#')
				attributes.link_xml = dosyam.SETUP_SITE.SETUPSITE[dl].LINK_XML.XmlText;
	</cfscript>

	<cfset selectedElements2 = XmlSearch(dosyam2,"/SETUP_SITE/SETUPSITE/LINK_FILE/")>
	<cfscript>
		for (dl = 1; dl lte ArrayLen(selectedElements2); dl = dl + 1)
			if(selectedElements2[dl].XmlText is '#trim(attributes.file_name)#')
				attributes.link_xml = dosyam2.SETUP_SITE.SETUPSITE[dl].LINK_XML.XmlText;
	</cfscript>
</cfif>
<cfparam name="attributes.VIEW_TITLE" default="get_row.VIEW_TITLE">
<cfset ozellik_sayisi = 0>
<cfform action="#request.self#?fuseaction=protein.emptypopup_change_object_property" method="post" name="add_properties">
<table border="0" cellspacing="1" cellpadding="2" class="color-row" style="width:100%; height:100%;">
	<tr class="color-row">
	  	<td style="vertical-align:top;">
			<cfif isdefined("attributes.menu_id")>
                <input type="hidden" name="menu_id" id="menu_id" value="<cfoutput>#attributes.menu_id#</cfoutput>">
                <input type="hidden" name="faction" id="faction" value="<cfoutput>#attributes.faction#</cfoutput>">
				<input type="hidden" name="col_id" id="col_id" value="<cfoutput>#attributes.col_id#</cfoutput>">
                <cfif isdefined("attributes.row_id")>
                    <input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
                </cfif>
                <table>
                    <tr>
                        <td><cfoutput>#getlang('settings',317)#</cfoutput></td>
                        <td colspan="3"><input type="text" name="object_folder" id="object_folder" value="<cfoutput>#attributes.object_folder#</cfoutput>" style="width:150px;" readonly></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='279.Dosya'></td>
                        <td colspan="3"><input type="text" name="object_file_name" id="object_file_name" value="<cfoutput>#attributes.file_name#</cfoutput>" style="width:150px;" readonly></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='1408.Başlık'></td>
                        <td colspan="3">
                            <cfsavecontent variable="message"><cf_get_lang_main no='718.Başlık Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="object_name" id="object_name" value="#attributes.name#" style="width:150px;" required="yes" message="#message#">
                            <cfif isDefined('attributes.row_id')>
                                <cf_language_info 
                                    table_name="MAIN_SITE_LAYOUTS_SELECTS" 
                                    column_name="OBJECT_NAME" 
                                    column_id_value="#attributes.row_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="ROW_ID" 
                                    control_type="0">
                            </cfif>
                        </td>
                    </tr>
					<tr>
                        <td>Başlık görünsün mü?</td>
                        <td colspan="3">	
							<select name="object_title" id="object_title" style="width:62px;">
                                <option value="1" <cfif attributes.VIEW_TITLE eq 1>selected</cfif>>Evet</option>
                                <option value="0" <cfif attributes.VIEW_TITLE eq 0>selected</cfif>>Hayır</option>
                            </select>
						</td>
                    </tr>
                    <tr style="display:none;">
                        <td><cf_get_lang_main no='1165.Sıra'></td>
                        <td>
                            <cfsavecontent variable="message">#getlang('settings',1717)#</cfsavecontent>
                            <cfinput type="text" name="order_number" id="order_number" value="#attributes.order_number#" style="width:45px;" validate="integer" message="#message#"></td>
                        <td>#getlang('settings',324)#</td>
                        <td>
                            <select name="object_position" id="object_position" style="width:62px;">
                                <option value="1" <cfif isdefined("attributes.object_position") and attributes.object_position eq 1>selected</cfif>>#getlang('settings',1309)#</option>
                                <option value="2" <cfif isdefined("attributes.object_position") and attributes.object_position eq 2>selected</cfif>>#getlang('main',516)#</option>
                                <option value="3" <cfif isdefined("attributes.object_position") and attributes.object_position eq 3>selected</cfif>>#getlang('settings',1308)#</option>
                                <option value="4" <cfif isdefined("attributes.object_position") and attributes.object_position eq 4>selected</cfif>>#getlang('main',573)#</option>
                            </select>
                        </td>
                    </tr>
                    <cfquery name="GET_OBJECT_DESIGN_" datasource="#dsn#">
                        SELECT 
                            DESIGN_ID, 
                            DESIGN_NAME 
                        FROM 
                            MAIN_SITE_OBJECT_DESIGN 
                        ORDER BY 
                            DESIGN_ID
                    </cfquery>
                    <tr style="display:none;"
                        <td><cf_get_lang_main no='1995.Tasarım'></td>
                        <td colspan="3">
                            <select name="design_id" id="design_id" style="width:150px;">
                                <cfoutput query="get_object_design_">
                                    <option value="#design_id#" <cfif isdefined("attributes.design_id") and attributes.design_id eq get_object_design_.design_id>selected</cfif>>#design_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <cfif workcube_mode eq 0>
                            <td> CSS</td>
                            <td colspan="3"><input type="text" name="class_css_name" id="class_css_name" value="<cfif isdefined("attributes.row_id")><cfoutput>#get_row.class_css_name#</cfoutput></cfif>" style="width:150px;"></td>
                            <td><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_css_property&menu_id=#attributes.menu_id#</cfoutput>','medium');" class="tableyazi"> CSS</a></td>
                        </cfif>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="3" height="35"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                  </tr>
                </table>
			</cfif>
	  	</td>
	  	<td style="width:50%; vertical-align:top;">
			<cfif isdefined("attributes.menu_id")>
                <table>
                    <cfif isdefined("attributes.link_xml") and len(attributes.link_xml)>
                        <cfif FileExists("#GetDirectoryFromPath(GetTemplatePath())#V16#dir_seperator##folder_##dir_seperator#xml#dir_seperator##attributes.link_xml#")>
                            <cffile action="read" file="#GetDirectoryFromPath(GetTemplatePath())#V16#dir_seperator##folder_##dir_seperator#xml#dir_seperator##attributes.link_xml#" variable="xmldosyam" charset="UTF-8">
                        <cfelse>
                            <cffile action="read" file="#GetDirectoryFromPath(GetTemplatePath())#V16#dir_seperator#add_options#dir_seperator#xml#dir_seperator##attributes.link_xml#" variable="xmldosyam" charset="UTF-8">
                        </cfif>        
                        <cfscript>
                            dosyam = XmlParse(xmldosyam);
                            xml_dizi = dosyam.OBJECT_PROPERTIES.XmlChildren;
                            d_boyut = ArrayLen(xml_dizi);
                        </cfscript>
                        <cfloop index="i" from="1" to="#d_boyut#">
                            <cfset ozellik_sayisi = ozellik_sayisi + 1>
                            <cfset aciklama = dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_DETAIL.XmlText>
                            <cfset ozellik_ad = dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY.XmlText>
                            <cfset tip = dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_TYPE.XmlText>
                            <cfset degerler = dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_VALUES.XmlText>
                            <cfset degerler_isimler = dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_NAMES.XmlText>
                            <cfset varsayilan = dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_DEFAULT.XmlText>
                            <cfoutput>
                            <tr height="20">
                                <td>#aciklama#</td>
                                <td>
                                    <input type="hidden" name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" value="#ozellik_ad#">
                                    <cfif not isdefined("attributes.row_id") or not get_row_properties.recordcount>
                                        <cfif tip is 'select'>
                                            <select name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#">
                                                <cfset sira_ = 0>
                                                <cfloop list="#degerler#" index="k">
                                                    <cfset sira_ = sira_ + 1>
                                                    <option value="#k#" <cfif k is '#varsayilan#'>selected</cfif>>#listgetat(degerler_isimler,sira_)#</option>
                                                </cfloop>
                                            </select>
                                        <cfelseif tip is 'input'>
                                            <input type="hidden" name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" value="#varsayilan#">
                                            <cfinput type="text" name="sanal_property_#ozellik_sayisi#" value="#varsayilan#" style="width:50px;">
                                        <cfelseif tip is 'textarea'>
                                            <input type="hidden" name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" value="#varsayilan#">
                                            <textarea name="sanal_property_#ozellik_sayisi#" id="sanal_property_#ozellik_sayisi#" style="width:200px;height:80px;">#varsayilan#</textarea>
                                        </cfif>
                                    <cfelse>
                                        <cfquery name="GET_" dbtype="query">
                                            SELECT * FROM GET_ROW_PROPERTIES WHERE PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ozellik_ad#">
                                        </cfquery>
                                        <cfif tip is 'select'>
                                            <select name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#">
                                                <cfset sira_ = 0>
                                                <cfloop list="#degerler#" index="k">
                                                    <cfset sira_ = sira_ + 1>
                                                    <option value="#k#" <cfif (get_.recordcount and get_.PROPERTY_VALUE eq k) or (not get_.recordcount and k is '#varsayilan#')>selected</cfif>>#listgetat(degerler_isimler,sira_)#</option>
                                                </cfloop>
                                            </select>
                                        <cfelseif tip is 'input'>
                                            <cfif get_.recordcount>
                                                <input type="hidden" name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" value="#get_.property_value#">
                                                <input type="text" name="sanal_property_#ozellik_sayisi#" id="sanal_property_#ozellik_sayisi#" value="#get_.property_value#" style="width:50px;">
                                            <cfelse>
                                                <input type="hidden" name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" value="#varsayilan#">
                                                <input type="text" name="sanal_property_#ozellik_sayisi#" id="sanal_property_#ozellik_sayisi#" value="#varsayilan#" style="width:50px;">
                                            </cfif>
                                        <cfelseif tip is 'textarea'>
                                            <cfif get_.recordcount>
                                                <input type="hidden" name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" value="#get_.PROPERTY_VALUE#">
                                                <textarea name="sanal_property_#ozellik_sayisi#" id="sanal_property_#ozellik_sayisi#" style="width:200px;height:80px;">#get_.property_value#</textarea>
                                            <cfelse>
                                                <input type="hidden" name="property_#ozellik_sayisi#" id="property_#ozellik_sayisi#" value="#varsayilan#">
                                                <textarea name="sanal_property_#ozellik_sayisi#" id="sanal_property_#ozellik_sayisi#" style="width:200px;height:80px;">#varsayilan#</textarea>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </td>
                            </tr>
							</cfoutput>
                        </cfloop>
                    </cfif>
                </table>	
			</cfif>		
		</td>
	</tr>
	<input type="hidden" name="property_count" id="property_count" value="<cfoutput>#ozellik_sayisi#</cfoutput>">
</cfform>
</table>
<script type="text/javascript">
	function kontrol()
	{
		<cfif isdefined("attributes.menu_id") and isdefined("attributes.link_xml") and len(attributes.link_xml)>
			<cfoutput>
				<cfloop index="i" from="1" to="#d_boyut#">
					<cfset tip = dosyam.OBJECT_PROPERTIES.OBJECT_PROPERTY[i].PROPERTY_TYPE.XmlText>
					<cfif tip is 'input' or tip is 'textarea'>
						if(!(add_properties.sanal_property_#i#.value.length>0))
						{
							add_properties.property_#i#[1].value = 'EMPTY';
						}
						else
						{
							add_properties.property_#i#[1].value = add_properties.sanal_property_#i#.value;
						}
					</cfif>
				</cfloop>
			</cfoutput>
		</cfif>
		return true;
	}
</script>
