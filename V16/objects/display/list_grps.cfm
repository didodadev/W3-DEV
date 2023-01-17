<!--- 
açan penceredeki istenen alana seçilenleri kaydeder
	field_name : istenen tablo hücresine de değerler yazılabilir ama hücreye id tanımlaması yapılmalıdır
	field_id : id listesinin
--->
<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_groups.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default="#get_groups.recordcount#">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_user(id,name)
{
	<cfif isdefined("attributes.field_name")>
        <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
        <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cfif not isdefined("select_list")>
	<cfset select_list = "1,2,3,4,5,6">
</cfif>
<cfscript>
url_string = "";
if (isdefined('attributes.field_basket_due_value')) url_string = '#url_string#&field_basket_due_value=#field_basket_due_value#';
if (isdefined('attributes.field_paymethod_id')) url_string = '#url_string#&field_paymethod_id=#field_paymethod_id#';
if (isdefined('attributes.field_paymethod')) url_string = '#url_string#&field_paymethod=#field_paymethod#';
if (isdefined("attributes.field_comp_id")) url_string = "#url_string#&field_comp_id=#field_comp_id#";
if (isdefined("attributes.sett")) url_string = "#url_string#&sett=#sett#";
if (isdefined("attributes.field_comp_name")) url_string = "#url_string#&field_comp_name=#field_comp_name#";
if (isdefined("attributes.field_name")) url_string = "#url_string#&field_name=#field_name#";
if (isdefined("attributes.field_id")) url_string = "#url_string#&field_id=#field_id#";
if (isdefined("attributes.startdate")) url_string = "#url_string#&startdate=#startdate#";
if (isdefined("attributes.finishdate")) url_string = "#url_string#&finishdate=#finishdate#";
if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
</cfscript>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfsavecontent variable="head_">
	<cfoutput>
        <div class="ui-form-list flex-list">
            <div class="form-group">
                <select name="categories" id="categories" onChange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
                    <cfif listcontainsnocase(select_list,1)>
                        <option value="#request.self#?fuseaction=objects.popup_list_positions_multiuser#url_string#"><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,2)>
                        <option value="#request.self#?fuseaction=objects.popup_list_all_pars_multiuser#url_string#&is_priority_off=1">C.<cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,3)>
                        <option value="#request.self#?fuseaction=objects.popup_list_cons#url_string#">C.<cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,4)>
                        <option value="#request.self#?fuseaction=objects.popup_list_grps#url_string#" selected><cf_get_lang dictionary_id='32716.Gruplar'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,5)>
                        <option value="#request.self#?fuseaction=objects.popup_list_pot_cons#url_string#"><cf_get_lang dictionary_id='32963.P Bireysel Üyeler'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,6)>
                        <option value="#request.self#?fuseaction=objects.popup_list_pot_pars#url_string#&is_priority_off=1"><cf_get_lang dictionary_id='32964.P Kurumsal Üyeler'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,7)>
                        <option value="#request.self#?fuseaction=objects.popup_list_all_pars#url_string#&is_priority_off=1"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,8)>
                        <option value="#request.self#?fuseaction=objects.popup_list_all_cons#url_string#"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
                    </cfif>
                    <cfif listcontainsnocase(select_list,9)>
                        <option value="#request.self#?fuseaction=objects.popup_list_all_positions#url_string#"><cf_get_lang dictionary_id='47833.Tüm Çalışanlar'></option>
                    </cfif>
                </select>
            </div>
        </div>
	</cfoutput>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Gruplar',32716)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_grp" action="#request.self#?fuseaction=objects.popup_list_grps#url_string#" method="post">
            <cfinput type="hidden" name="is_form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="Text" maxlength="50" value="#attributes.keyword#" name="keyword" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_grp' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
        </cfif>
        <tbody><cfoutput>#head_#</cfoutput></tbody>
        <cf_flat_list>
            <thead>
                <tr>
                    <th colspan="2"><cf_get_lang dictionary_id='32715.Grup'></th>
                </tr>
            </thead>
            </tbody>
                <cfif get_groups.recordcount and form_varmi eq 1>
                    <cfoutput query="get_groups" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                        <td><a href="##" onClick="add_user('#group_id#','#group_name#')" class="tableyazi">#group_name#</a></td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                    <tr>
                        <td><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.maxrows lt attributes.totalrecords>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="objects.#fusebox.fuseaction##url_string#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
