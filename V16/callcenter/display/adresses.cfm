<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isDefined("attributes.w_is_submit")>
	<cfinclude template="../../correspondence/query/get_address.cfm">
<cfelse>
	<cfset get_address.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_address.recordcount#">
<cfform name="address_form" id="address_form" action="#request.self#?fuseaction=objects.phone_book" method="post">
    <input type="hidden" name="w_is_submit" id="w_is_submit" value="1">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box_search more="0" id="addresses">            
            <div class="form-group xxlarge">
                <input type="text" id="keyword" name="keyword" placeholder="<cf_get_lang dictionary_id='62338.Şirket, Kişi veya Telefon girin'>" value="<cfif isdefined('attributes.keyword')><cfoutput>#attributes.keyword#</cfoutput></cfif>">
            </div>
            <div class="form-group small">
                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#"  validate="integer" range="1,255" maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="submit()">
            </div>
            <div class="form-group">
                <a href="javascript://" onclick="<cfoutput>openBoxDraggable('#request.self#?fuseaction=correspondence.addressbook&draggable=1&phone_list=1&is_form_submitted=1')</cfoutput>" class="ui-btn ui-btn-gray2"><i class="fa fa-address-book-o"></i></a>
            </div>
        </cf_box_search>
        <cfif isdefined('attributes.w_is_submit')>
            <cf_grid_list>                            
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th><cf_get_lang dictionary_id='57499.Phone'></th>
                        <th><cf_get_lang dictionary_id='58813.Mobile No.'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_address.recordcount eq 0>                                
                        <tr>
                            <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                        </tr> 
                    <cfelse>
                        <cfoutput query="get_address" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif len(ab_name)>
                                <tr>
                                    <td>#ab_name# #ab_surname#</td>
                                    <td>
                                        <cf_santral tel="#iif(len(AB_TEL1),DE('#AB_TELCODE##AB_TEL1#'),DE(''))#" tel2="#iif(len(AB_TEL2),DE('#AB_TELCODE##AB_TEL2#'),DE(''))#" is_iframe="1">
                                    </td>
                                    <td>
                                        <cf_santral mobil="#iif(len(AB_MOBILCODE) and len(AB_MOBIL),DE('#AB_MOBILCODE##AB_MOBIL#'),DE(''))#" is_iframe="1">
                                    </td>
                                </tr>
                            </cfif>                                            
                        </cfoutput>
                    </cfif>
                </tbody>                            
            </cf_grid_list>
        </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfscript>
                url_string = '';
                if (isdefined('attributes.keyword')) url_string = '#url_string#&keyword=#attributes.keyword#';
            </cfscript>
            <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="objects.phone_book&w_is_submit=1#url_string#"
            target="phone-book"
            isAjax="1">
        </cfif>
    </div>
</cfform>
<script>
    $("input").keydown(function (e) {
        if (e.keyCode == 13) {
            $("#wrk_search_button").click();
        }
    });
    function submit(){
        key= $("#keyword").val();
        maxr= $("#maxrows").val();
        if($("#maxrows").val() == ""){
            alert("<cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'>");
            return false;
        }
        var url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone_book&w_is_submit=1&keyword=' + key + '&maxrows=' + maxr +'';
        AjaxPageLoad(url_str,'phone-book',1);
    }
</script>