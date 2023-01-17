<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
	SELECT 
		CC.*,
		OC.NICK_NAME
	FROM 
		COMPANY_CREDIT CC,
		OUR_COMPANY OC
	WHERE 
		<cfif isdefined("url.company_id") and len(url.company_id)>
			CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.COMPANY_ID#"> AND
		<cfelse>
			CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.CONSUMER_ID#"> AND
		</cfif>
		OC.COMP_ID = CC.OUR_COMPANY_ID
</cfquery>
<cfset acik_toplam=0>
<cfset vadeli_toplam=0>
<!--- <cfset grup_toplam=0> --->
<cf_grid_list table_width="750">
    <thead>
        <tr> 
            <th width="20"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.list_credits&event=add<cfif isdefined("attributes.company_id") and len(attributes.company_id)>&cpid=#attributes.company_id#<cfelse>&cid=#attributes.consumer_id#</cfif>&our_comp_id=#get_credit_limit.our_company_id#','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput></th>
            <th><cf_get_lang dictionary_id='50945.Şirketimiz'></th>
            <th width="130" class="text-right"><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></th>
            <th width="130" class="text-right"><cf_get_lang dictionary_id='50766.Vadeli Ödeme Limiti'></th>
            <th width="130" class="text-right"><cf_get_lang dictionary_id='57877.Toplam Limit'></th>
        </tr>
    </thead>
    <cfif get_credit_limit.recordcount>
        <tbody>
            <cfset YTL_ARA_TOPLAM = 0>
                <cfoutput query="get_credit_limit">  
                    <tr>
                        <cfif len(OPEN_ACCOUNT_RISK_LIMIT)>
                            <cfset OPEN_ACCOUNT_RISK_LIMIT_ = OPEN_ACCOUNT_RISK_LIMIT>
                        <cfelse>
                            <cfset OPEN_ACCOUNT_RISK_LIMIT_ = 0>
                        </cfif>
                        <cfif len(FORWARD_SALE_LIMIT)>
                            <cfset FORWARD_SALE_LIMIT_ = FORWARD_SALE_LIMIT>
                        <cfelse>
                            <cfset FORWARD_SALE_LIMIT_ = 0>
                        </cfif>
                        <cfset acik_toplam = acik_toplam + OPEN_ACCOUNT_RISK_LIMIT_>
                        <cfset vadeli_toplam = vadeli_toplam + FORWARD_SALE_LIMIT_>
                        <cfset ara_toplam = OPEN_ACCOUNT_RISK_LIMIT_ + FORWARD_SALE_LIMIT_>
                        <td><a href="#request.self#?fuseaction=contract.list_contracts&event=upd&company_id=#company_id#&consumer_id=#consumer_id#&our_company_id=#our_company_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        <td>#NICK_NAME#</td>
                        <td class="text-right">#tlformat(OPEN_ACCOUNT_RISK_LIMIT_)# #session.ep.money#</td>
                        <td class="text-right">#tlformat(FORWARD_SALE_LIMIT_)# #session.ep.money#</td>
                        <td class="text-right">#tlformat(ara_toplam)# #session.ep.money# <cfset YTL_ARA_TOPLAM = YTL_ARA_TOPLAM + ara_toplam></td>
                    </tr>
                </cfoutput> 
        </tbody>
        <tfoot>
            <cfoutput>
                <tr>
                    <td colspan="2" class="txtbold"><cf_get_lang dictionary_id='50969.Grup Toplam'></td>
                    <td class="text-right">#tlformat(acik_toplam)# #session.ep.money#</td>
                    <td class="text-right">#tlformat(vadeli_toplam)# #session.ep.money#</td>
                    <td class="text-right">#tlformat(YTL_ARA_TOPLAM)# #session.ep.money#</td>
                </tr>
            </cfoutput>
        </tfoot>
    <cfelse>
        <tbody>
            <tr>
                <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </tbody>
    </cfif>
</cf_grid_list>
