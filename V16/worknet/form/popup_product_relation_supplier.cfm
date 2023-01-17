<cfset cmp = createObject("component","V16.worknet.cfc.product")>
<cfif isDefined("attributes.pid") and len(attributes.pid)> 
    <cfset get_all_supplier = cmp.getRelationSupplier(
        pid :   attributes.pid
    )>
<cfelseif isDefined("attributes.cpid") and len(attributes.cpid)>
    <cfset get_all_supplier = cmp.getRelationSupplier(
        cpid :   attributes.cpid
    )>
</cfif>

<cfparam name="attributes.totalrecords" default='#get_all_supplier.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div id="list_supplier">
    <cf_ajax_list>
        <thead>
            <tr>
                <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                <cfif isDefined("attributes.pid") and len(attributes.pid)>
                    <th><cf_get_lang dictionary_id='29528.Tedarikçiler'></th>
                <cfelseif isDefined("attributes.cpid") and len(attributes.cpid)>
                    <th><cf_get_lang dictionary_id='57564.Ürünler'></th>
                </cfif>
            </tr>       
        </thead>
        <tbody>
            <cfif attributes.totalrecords>
                <cfoutput query="get_all_supplier" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>
                            <cfif isDefined("attributes.pid") and len(attributes.pid)>
                                #FULLNAME#
                            <cfelseif isDefined("attributes.cpid") and len(attributes.cpid)>
                                #PRODUCT_NAME#
                            </cfif>                            
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td></td>
                    <td><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
                </tr>
            </cfif>
        </tbody>
    </cf_ajax_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <table width="99%" align="center" cellpadding="0" cellspacing="0" height="35">
            <cfif isDefined("attributes.pid")>
                <cfset adrs="worknet.popupajax_product_relation_supplier&pid=#attributes.pid#">
            <cfelseif isDefined("attributes.cpid")>
                <cfset adrs="worknet.popupajax_product_relation_supplier&cpid=#attributes.cpid#">
            </cfif>
            <tr>
                <td>
                    <cf_paging
                        page="#attributes.page#"
                        maxrows="#attributes.maxrows#"
                        totalrecords="#attributes.totalrecords#"
                        startrow="#attributes.startrow#"
                        isAjax="true"
                        target="list_supplier"
                        adres="#adrs#">
                </td>
            </tr>
        </table>
    </cfif>
</div>