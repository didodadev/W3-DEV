<cfparam name="attributes.modal_id" default="">
<cfif isDefined('attributes.field_id') and isDefined('attributes.field_name') and isDefined('attributes.field_module_id')>
	<script type="text/javascript">
		function ekle(process_type,process_cat,module_id,details)
			{
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=process_type;
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=process_cat;
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_module_id#</cfoutput>.value=module_id;
                <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.detail#</cfoutput>.value=details;				
                <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
            }
	</script>
</cfif>
<cfset upload_folder = '#GetDirectoryFromPath(GetCurrentTemplatePath())#..#dir_seperator#..#dir_seperator#admin_tools#dir_seperator#'>
<cffile action="read" variable="xmldosyam" file="#upload_folder#xml#dir_seperator#setup_main_process_cat.xml" charset = "UTF-8">

<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.workcube_main_process_types.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#d_boyut#>  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','İşlemler','57777')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    	<cfform name="main_process_type" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
            <cf_box_search>
                    <div class="form-group">
                        <input name="detail" id="detail" type="hidden" <cfif isdefined("attributes.detail")>value="<cfoutput>#attributes.detail#</cfoutput>"</cfif>>			
                    </div>
                    <div class="form-group">
                        <input name="field_name" id="field_name" type="hidden" <cfif isdefined("attributes.field_name")>value="<cfoutput>#attributes.field_name#</cfoutput>"</cfif>>
                    </div>
                    <div class="form-group">
                        <input name="field_id" id="field_id" type="hidden" <cfif isdefined("attributes.field_id")>value="<cfoutput>#attributes.field_id#</cfoutput>"</cfif>>
                    </div>
                    <div class="form-group">
                        <input name="field_module_id" id="field_module_id" type="hidden" <cfif isdefined("attributes.field_module_id")>value="<cfoutput>#attributes.field_module_id#</cfoutput>"</cfif>>								
                    </div>
                    <div class="form-group small">
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayı Hatası Mesaj','34135')#" maxlength="3">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('main_process_type' , #attributes.modal_id#)"),DE(""))#">
                    </div>
            </cf_box_search>	
        </cfform>
        <cf_flat_list>
            <thead>
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                <th><cf_get_lang dictionary_id='42781.İşlem ID'></th>
                <th><cf_get_lang dictionary_id='141.Modül'></th>
            </thead>
            <tbody>
                <cfif isDefined('d_boyut')>
                    <cfloop from='#attributes.startrow#' to='#iif(attributes.totalrecords gt (attributes.maxrows+attributes.startrow),attributes.maxrows+attributes.startrow-1,attributes.totalrecords)#' index='i'>
                      <cfoutput>
                          <tr>
                              <td>
                                  <cfset alan_1 = dosyam.workcube_main_process_types.process[i].process_type.XmlText>
                                  <cfset alan_2 = dosyam.workcube_main_process_types.process[i].process_cat.XmlText>
                                  <cfset alan_3 = dosyam.workcube_main_process_types.process[i].process_module_id.XmlText>
                                  <cfset alan_4 = dosyam.workcube_main_process_types.process[i].process_fuseaction.XmlText>
                                  <cfset rm = '#chr(13)#' >
                                  <cfset alan_2 = ReplaceList(alan_2,rm,'') >
                                  <cfset rm = '#chr(10)#' >
                                  <cfset alan_2 = ReplaceList(alan_2,rm,'') >						
                                  <a href="javascript://" onClick="javascript:ekle('#alan_1#','#alan_2#','#alan_3#','#alan_4#');" class="tableyazi" >#i#</a>
                              </td>
                              <td><a href="javascript://" onClick="javascript:ekle('#alan_1#','#alan_2#','#alan_3#','#alan_4#');" class="tableyazi" >#dosyam.workcube_main_process_types.process[i].process_cat.XmlText#</a></td>
                              <td>#dosyam.workcube_main_process_types.process[i].process_type.XmlText#</td>
                              <td>#dosyam.workcube_main_process_types.process[i].process_module_name.XmlText#</td>						
                          </tr>
                      </cfoutput>
                     </cfloop>
                  <cfelse>
                      <tr>
                          <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                      </tr>
                  </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
<cfif attributes.totalrecords gt attributes.maxrows>
    <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
        <tr> 
            <td>
                <cfset adres = attributes.fuseaction>
                <cfif isDefined('attributes.field_name')>
                    <cfset adres = '#adres#&field_name=#attributes.field_name#'>
                </cfif>
                <cfif isDefined('attributes.field_id')>
                    <cfset adres = '#adres#&field_id=#attributes.field_id#'>
                </cfif>
                <cfif isDefined('attributes.field_module_id')>
                    <cfset adres = '#adres#&field_module_id=#attributes.field_module_id#'>
                </cfif>
                <cfif isDefined('attributes.detail')>
                    <cfset adres = '#adres#&detail=#attributes.detail#'>
                </cfif>		
                <cf_pages page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#">
            </td>
            <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang_main no='169.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
        </tr>
    </table>
</cfif>
