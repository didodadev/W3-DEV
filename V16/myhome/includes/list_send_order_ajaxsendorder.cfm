<cfsetting showdebugoutput="no">
<cfset listall =1>
<cfinclude template="get_send_order_list.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=20>
<cfif get_order_list.recordcount>
	<cfparam name="attributes.totalrecords" default="#get_order_list.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <div id="SevksWidget">
    <cf_flat_list>
            <cfif get_order_list.recordcount>
                <thead>
                    <tr>
                        <th><cf_get_lang_main no="799.Sipariş No"></th>
                        <th><cf_get_lang_main no="1408.Başlık"></th>
                        <th><cf_get_lang_main no="107.Cari Hesap"></th>
                        <!--- <th style="text-align:right;"><cfoutput>#session.ep.money#</cfoutput></th>
                        <th style="text-align:right;">2. <cf_get_lang_main no="265.Döviz"></th> --->
                        <th>Depo</th>
                    </tr>
                </thead>
                <cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>
                            <cfif get_order_list.purchase_sales eq 1>
                                <a href="#request.self#?fuseaction=stock.list_command&event=det&order_id=#order_id#" class="tableyazi">#ORDER_NUMBER#</a>
                            <cfelse>
                                <a href="#request.self#?fuseaction=stock.list_command&event=detp&order_id=#order_id#" class="tableyazi">#ORDER_NUMBER#</a>
                            </cfif>
                        </td>
                        <td width="30%">#order_head#</td>
                        <!--- şirketi al --->
                        <cfif len(get_order_list.partner_id)>
                            <cfset attributes.partner_id = get_order_list.partner_id>
                            <cfinclude template="get_partner_name.cfm">
                            <td>#get_partner_name.nickname# - <a class="tableyazi" href="mailto:#get_partner_name.company_partner_email#">#get_partner_name.company_partner_name# #get_partner_name.company_partner_surname#</a></td>
                        <cfelseif len(consumer_id)>
                            <cfset attributes.consumer_id = consumer_id>
                            <cfinclude template="get_consumer_name.cfm">
                            <td>#get_consumer_name.consumer_name# - <a class="tableyazi" href="mailto:#get_consumer_name.consumer_email#">#get_consumer_name.consumer_name# #get_consumer_name.consumer_surname#</a></td>
                        </cfif>
                        <!--- <td width="20%" style="text-align:right;">#TLFormat(NETTOTAL)# #session.ep.money#</td>
                        <td width="20%" style="text-align:right;">#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td> --->
                        <td>#DEPARTMENT_HEAD#-#COMMENT#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </cfif>
    </cf_flat_list>
    <cfset adres="#fusebox.circuit#.emptypopup_list_send_order_ajaxsendorder">
    <cf_paging 
            name="order_ajaxsendorder"
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#" 
            isAjax="1"
            target="SevksWidget">
</div>