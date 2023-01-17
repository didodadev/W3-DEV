<cfset cfc= createObject("component","V16.objects.cfc.get_list_content_relation")>
<cfset get_language =cfc.GetLanguage()> 
<cfset get_content_property =cfc.GetContentProperty()> 
<cfset get_chapter_hier =cfc.GetChapterHier()> 
<cfparam name="attributes.content_property_id" default="">
<cfparam name="attributes.language_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.order_list" default="4">
<cfif isdefined("attributes.form_submitted")>
    <cfinclude template="../query/get_content_relation.cfm">
<cfelse>
	<cfset get_content_relation.recordcount = 0>
</cfif>
<cfif isdefined("attributes.content")>
	<script type="text/javascript">
	function yolla(id,alan)
	{
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.content#</cfoutput>.value  = id;
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.content_name#</cfoutput>.value = alan;
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	</script>
</cfif>
<cfif isdefined("attributes.cid")>
    <cfif isdefined("attributes.form_submitted")>
        <cfset get_add_content_relation=cfc.GetAddContentRelation(action_type:attributes.action_type,action_type_id:attributes.action_type_id,cid:attributes.cid)> 
	<cfelse>
		<cfset get_content_relation.recordcount = 0>
	</cfif>
	<script type="text/javascript">
		//ek function gonderilmek istenirse diye eklendi fbs 20100628
		//hataya neden oldugu icin kapatildi 20120828
		<!--- <cfif isDefined("attributes.call_function") and Len(attributes.call_function)>
			window.opener.<cfoutput>#attributes.call_function#</cfoutput>; --->
		<cfif isdefined("attributes.cid")>
            <cfif not isdefined("attributes.draggable")>
                window.close();
			    opener.location.reload();
            <cfelse>
                closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
                location.reload();
            </cfif>
			
		<cfelseif not isDefined("attributes.no_function")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.list_content_id_yukle();
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
	<cfabort>
</cfif>
<cfif not isdefined("url.poz")>
	<cfset start=1>
<cfelse>
	<cfset start = url.poz>
</cfif>
<cfset sayac=0>
<cfset adres = "">
<cfif isDefined('attributes.form_submitted') and len(attributes.form_submitted)>
	<cfset adres = adres&"&form_submitted="&attributes.form_submitted>
</cfif>
<cfif isDefined('attributes.content') and len(attributes.content)>
	<cfset adres = adres&"&content="&attributes.content>
</cfif>
<cfif isDefined('attributes.content_name') and len(attributes.content_name)>
	<cfset adres = adres&"&content_name="&attributes.content_name>
</cfif>
<cfif isDefined('attributes.action_type_id') and len(attributes.action_type_id)>
	<cfset adres = adres&"&action_type_id="&attributes.action_type_id>
	<cfset adres = adres&"&action_type="&attributes.action_type>
</cfif>
<cfif isDefined('attributes.call_function') and len(attributes.call_function)>
	<cfset adres = adres&"&call_function="&attributes.call_function>
</cfif>
<cfif isDefined('attributes.no_function') and len(attributes.no_function)>
	<cfset adres = adres&"&no_function="&attributes.no_function>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_content_relation.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','İçerikler',58045)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="form_content_relation" action="#request.self#?fuseaction=objects.popup_list_content_relation#adres#" method="post">
            <cf_box_search>
                <div class="form-group" id="form_submitted">
                    <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                    <cfinput type="text" name="keyword" placeholder="#getLang('','Konu',57480)#" value="#attributes.keyword#" maxlength="255">
                </div>
                <div class="form-group" id="order_list">
                    <select name="order_list" id="order_list">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <option value="1" <cfif attributes.order_list eq 1>selected</cfif>><cf_get_lang dictionary_id='29735.Konuya Göre'><cf_get_lang dictionary_id='29459.Artan No'></option>
                        <option value="2" <cfif attributes.order_list eq 2>selected</cfif>><cf_get_lang dictionary_id='29735.Konuya Göre'><cf_get_lang dictionary_id='29458.Azalan No'></option>
                        <option value="3" <cfif attributes.order_list eq 3>selected</cfif>><cf_get_lang dictionary_id='58925.Tarihe Göre'><cf_get_lang dictionary_id='29459.Artan No'></option>
                        <option value="4" <cfif attributes.order_list eq 4>selected</cfif>><cf_get_lang dictionary_id='58925.Tarihe Göre'><cf_get_lang dictionary_id='29458.Azalan No'></option>
                    </select>
                </div>
                <div class="form-group" id="language_id">
                    <select name="language_id" id="language_id">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_language">
                            <option value="#language_short#"<cfif attributes.language_id is language_short>selected</cfif>>#language_set#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_content_relation' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
            <cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_content_relation' , #attributes.modal_id#)"),DE(""))#"> 
                <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                    <select name="content_property_id" id="content_property_id">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_content_property">
                            <option value="#content_property_id#" <cfif attributes.content_property_id eq content_property_id>selected</cfif>>#name# </option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12">
                    <select name="cat" id="cat">
                        <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_chapter_hier">
                            <cfif currentrow is 1>
                                <option value="cat-#contentcat_id#" <cfif isdefined("attributes.cat") and attributes.cat is "cat-#contentcat_id#">selected</cfif> >#contentcat#</option>
                                <option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#</option>
                                <cfelse>
                                <cfset old_row = currentrow -1>
                                <cfif contentcat_id is contentcat_id[old_row]>
                                    <option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#</option>
                                <cfelse>
                                    <option value="cat-#contentcat_id#" <cfif isdefined("attributes.cat") and attributes.cat is "cat-#contentcat_id#">selected</cfif>>#contentcat#</option>
                                    <option value="ch-#chapter_id#" <cfif isdefined("attributes.cat") and attributes.cat is "ch-#chapter_id#">selected</cfif>>&nbsp;&nbsp;#chapter#</option>					  
                                </cfif>							  
                            </cfif>
                        </cfoutput>
                    </select>
                </div>
            </cf_box_search_detail>
        </cfform>
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Line'></th>
                    <th><cf_get_lang dictionary_id='57480.Konu'></th>
                    <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th><cf_get_lang dictionary_id='57995.Bölum'></th>
                    <th><cf_get_lang dictionary_id='57630.Tip'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20"><a href="javascript://"><i class="fa fa-cube"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_content_relation.recordcount>
                    <cfoutput query="get_content_relation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                                <cfset baslik = Replace(cont_head,"'"," ","all")>
                                <cfset baslik2 = Replace(baslik,"<b>"," ","all")>
                                <cfset baslik3 = Replace(baslik2,'"'," ","all")>
                                <cfif isdefined("attributes.content")>
                                    <a href="##" onClick="yolla('#content_id#','#baslik3#')">#baslik3#</a>
                                <cfelse>
                                    <a href="javascript://" onclick="addListContent(#content_id#)">#baslik2#</a>
                                </cfif>
                            </td>
                            <td>#CONTENTCAT#</td>
                            <td>#CHAPTER#</td>
                            <td><cfif len(get_content_relation.CONTENT_PROPERTY_ID)>
                                    <cfset get_cont_property =cfc.GetContProperty()> 
                                    #get_cont_property.NAME#
                                </cfif>
                            </td>
                            <td><a href="mailto:#employee_email#">#employee_name# #employee_surname#</a></td>
                            <td>#dateformat(record_date,dateformat_style)#</td>
                            <td>
                                <a href="javascript://" onClick="window.open('#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#');"><i class="fa fa-cube"></i></a>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
                    </tr> 
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                <cfset adres = adres&"&keyword="&attributes.keyword>
            </cfif>
            <cfif isDefined('attributes.cat') and len(attributes.cat)>
                <cfset adres = adres&"&cat="&attributes.cat>
            </cfif>
            <cfif isDefined('attributes.language_id') and len(attributes.language_id)>
                <cfset adres = adres&"&language_id="&attributes.language_id>
            </cfif>
            <cfif isDefined('attributes.no_function') and len(attributes.no_function)>
                <cfset adres = adres&"&no_function=#attributes.no_function#">
            </cfif>
            <cfif isdefined("attributes.order_list") and len(attributes.order_list)>
                <cfset adres=adres&"&order_list=#attributes.order_list#">	
            </cfif>
            <cfset adres="objects.popup_list_content_relation"&adres>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){
        $( "#keyword" ).focus();
    });

    function addListContent(content_id) {
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_content_relation&cid='+content_id+'&#adres#</cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
    } 
</script>
