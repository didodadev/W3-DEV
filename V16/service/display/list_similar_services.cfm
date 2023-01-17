<cfif isdefined("attributes.is_submit")>
	<cfset attributes.keyword = URLencodedformat(attributes.keyword)>
<cfelse>
	 <cfset attributes.keyword = "">   
</cfif>
<cfinclude template="../query/get_similar_services.cfm">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_similar_services.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('service',56)#">
        <cfform name="search" method="post" action="#request.self#?fuseaction=service.popup_list_similar_services">
            <cf_box_search more="0">
                <input type="hidden" name="is_submit" id="is_submit" value="1">
                <div class="form-group">
                    <cfsavecontent  variable="message"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" value="#URLDecode(attributes.keyword)#" maxlength="255" placeholder="#message#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cfif isdefined("attributes.id") and len(attributes.id)>
                        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                    </cfif>
                    <cfif isdefined("attributes.service_product_id") and len(attributes.service_product_id)>
                        <input type="hidden" name="service_product_id" id="service_product_id" value="<cfoutput>#attributes.service_product_id#</cfoutput>">
                    </cfif>
                </div>
            </cf_box_search>
        </cfform>
        <cf_flat_list>
            <thead>				
                <tr>
                    <th><cf_get_lang no='57.Başvuru'></th>
                    <th><cf_get_lang_main no='74.Kategori'></th>
                    <th style="width:100px;"><cf_get_lang_main no='330.Tarih'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_similar_services.recordcount>
                    <cfoutput query="get_similar_services" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><a href="#request.self#?fuseaction=service.popup_detail_similar_service&service_id=#service_id#"> <font color="#COLOR#">#service_head#</font></a> </td>
                            <td>#servicecat#</td>
                            <td>#dateformat(apply_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,apply_date),timeformat_style)#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset adres="service.popup_list_similar_services">
            <cfif len(attributes.keyword)>
                <cfset adres="#adres#&keyword=#URLEncodedFormat(attributes.keyword)#">
            </cfif>
            <cfif isdefined("attributes.form_submitted")>
                <cfset adres="#adres#&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cfif isdefined("attributes.vergi_no") and len(attributes.vergi_no)>
                <cfset adres="#adres#&vergi_no=#attributes.vergi_no#">
            </cfif>
            <cfif isdefined("attributes.id") and len(attributes.id)>
                <cfset adres="#adres#&id=#attributes.id#">
            </cfif>
            <cfif isdefined("attributes.service_product_id") and len(attributes.service_product_id)>
                <cfset adres="#adres#&service_product_id=#attributes.service_product_id#">
            </cfif>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	function open_detail(id)
	{
		opener.location.href="<cfoutput>#request.self#?fuseaction=service.list_service&event=upd&service_id=</cfoutput>"+id;
		return false;
	}
</script>
