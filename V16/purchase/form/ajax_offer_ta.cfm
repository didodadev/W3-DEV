<cf_xml_page_edit fuseact="purchase.detail_offer_ta">
<cfquery name="get_related_offer" datasource="#dsn3#">
    SELECT OFFER_ID,OFFER_NUMBER,OFFER_HEAD,OFFER_TO, OFFER_TO_PARTNER,OTHER_MONEY,OTHER_MONEY_VALUE,REVISION_NUMBER FROM OFFER WHERE FOR_OFFER_ID = #attributes.offer_id# ORDER BY OFFER_TO_PARTNER, REVISION_OFFER_ID, REVISION_NUMBER
</cfquery>
<table class="ajax_list">
    <tbody>
    <cfoutput query="get_related_offer">
        <cfif Len(OFFER_TO)>
            <cfquery name="get_related_company" datasource="#dsn#">
                SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #Rereplace(OFFER_TO,',','','All')#
            </cfquery>
        </cfif>
        <cfset rel_offer_head_ = Replace(get_related_offer.offer_head,"'"," ","all")>
        <cfset rel_offer_head_ = Replace(rel_offer_head_,'"',' ','all')>
        <tr id="row_#currentrow#">
            <td><a style="cursor:pointer" onClick="del_relationship('#currentrow#','#get_related_offer.offer_id#','#rel_offer_head_#');"><i class="fa fa-minus"></i></a></td>
            <td>
                <cfif x_related_offer_view_type Eq 0>
                    #get_par_info(listdeleteduplicates(offer_to_partner),0,0,1)#
                <cfelseif x_related_offer_view_type Eq 1 And Len(OFFER_TO)>
                    <a href="javascript:void(0);" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&amp;company_id=#Rereplace(OFFER_TO,',','','All')#','list');">#get_related_company.NICKNAME#</a>
                </cfif>
                <td><a href="#request.self#?fuseaction=purchase.list_offer&event=add&for_offer_id=#attributes.offer_id#&revision_offer_id=#get_related_offer.offer_id#"><i class="fa fa-copy" title="<cf_get_lang dictionary_id ='34756.Ekle'>" border="0"></i></td>
            </td>
        </tr>
        <tr id="row_#currentrow#">
            <td>&nbsp;</td>
            <td colspan="2"><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_related_offer.offer_id#" target="_blank">#offer_number#<cfif REVISION_NUMBER neq ''>/R-#REVISION_NUMBER#</cfif></a> - #TLFormat(other_money_value)# #other_money#</td>        </tr>
    </cfoutput>
    </tbody>
</table>
<script>
    function del_relationship(row_count,id)//Satır silme fonksiyonu
    {
         if(confirm ("<cf_get_lang dictionary_id = '61542.seçilen ilişkili teklifi silmek istediğinize emin misiniz?'> ? "))
        {
            if(id != undefined)
            {
                var for_offer_id = <cfoutput>#attributes.offer_id#</cfoutput>;
                var formData = new FormData();
                formData.append("offer_id", id);
                formData.append("for_offer_id", for_offer_id);
                AjaxControlPostData('V16/purchase/cfc/offer_management.cfc?method=UPD_FOR_OFFER', formData, function ( response ) {});
            }
            $( "[id = 'row_"+row_count+"']" ).each(function( index ) {
                $( this ).remove();
            });
        }
        else return false;
    }
</script>