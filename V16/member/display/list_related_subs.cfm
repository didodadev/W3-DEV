<!--- yeni iliskili oldugu sistemleri listeler,burdan secilen sistemlerin kredi karti bilgisi set edilir.. Aysenur20070822 --->
<cfquery name="GET_SUBSCRIPTIONS" datasource="#DSN3#">
	SELECT 
		SUBSCRIPTION_ID,
		SUBSCRIPTION_NO,
		SUBSCRIPTION_HEAD,
		PAYMENT_TYPE_ID
	FROM 
		SUBSCRIPTION_CONTRACT
	WHERE 
	<cfif isdefined('attributes.inv_comp_id')>
		COMPANY_ID = #attributes.inv_comp_id#
	<cfelse>
		CONSUMER_ID = #attributes.inv_cons_id#
	</cfif>
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="30520.Sistemler"></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="provision_rows" method="post" action="#request.self#?fuseaction=member.emptypopup_upd_subs_cc_info">
<cf_medium_list>
<input type="hidden" name="member_cc_id" id="member_cc_id" value="<cfoutput>#attributes.member_cc_id#</cfoutput>">
   	<thead>
        <tr>
            <th><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='29502.Sistem No'></th>
            <th><cf_get_lang dictionary_id='58832.Abone'> <cf_get_lang dictionary_id='58233.Tanım'></th>
            <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
            <th></th>
        </tr>
    </thead>
    <tbody>
    <cfset pay_method_id_list=''>
    <cfif get_subscriptions.recordcount>
        <cfoutput query="get_subscriptions">
            <cfif len(PAYMENT_TYPE_ID) and not listfind(pay_method_id_list,PAYMENT_TYPE_ID)>
                <cfset pay_method_id_list=listappend(pay_method_id_list,PAYMENT_TYPE_ID)>
            </cfif>
        </cfoutput>
        <cfif len(pay_method_id_list)>
            <cfset pay_method_id_list=listsort(pay_method_id_list,"numeric","ASC",",")>
            <cfquery name="get_paymethod_detail" datasource="#dsn#">
                SELECT PAYMETHOD,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#pay_method_id_list#) ORDER BY PAYMETHOD_ID
            </cfquery>
        </cfif>
        <cfoutput query="get_subscriptions">
            <tr>
                <td>#currentrow#</td>
                <td>#SUBSCRIPTION_NO#</td>
                <td>#subscription_head#</td>
                <td>
                    <cfif len(PAYMENT_TYPE_ID)>#get_paymethod_detail.PAYMETHOD[listfind(pay_method_id_list,PAYMENT_TYPE_ID,',')]#</cfif>
                </td>
                <td width="5"><input type="checkbox" name="is_rel_subs" id="is_rel_subs" checked="checked" value="#SUBSCRIPTION_ID#"></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="9"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
        </tr>
    </cfif>
    </tbody>
</cf_medium_list>
<cf_popup_box_footer>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="59888.Kredi Karti Bilgisi Güncelle"></cfsavecontent>
	<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info = '#message#'>
</cf_popup_box_footer>
</cfform>
</cf_popup_box>
