<cfif not isdefined("session_base.our_company_id")><cfset session_base.our_company_id = session.ep.company_id></cfif>
<cfif (isdefined('attributes.company_id') and len(attributes.company_id)) or (isdefined('attributes.consumer_id') and len(attributes.consumer_id)) or (isdefined('attributes.employee_id') and len(attributes.employee_id))>
	<!--- Acik siparis ve irsaliyeler --->
	<cfscript>
		if( not (isdefined('attributes.company_id') and len(attributes.company_id)))
			comp_id='';
		else
			comp_id=attributes.company_id;
			
		if( not (isdefined('attributes.consumer_id') and len(attributes.consumer_id)))
			cons_id='';
		else
			cons_id=attributes.consumer_id;
			
		if( not (isdefined('attributes.employee_id') and len(attributes.employee_id)))
			emp_id='';
		else
			emp_id=attributes.employee_id;
			
		CreateCompenent = CreateObject("component","/../workdata/get_open_order_ships");
		get_open_order_ships = CreateCompenent.getCompenentFunction(company_id:comp_id,consumer_id:cons_id,employee_id:emp_id);
	</cfscript>
</cfif>
<cfquery name="GET_REMAINDER" datasource="#DSN2#">
	SELECT
		BORC,
		ALACAK,
		BAKIYE,
		ISNULL(BORC2,0) BORC2,
		ISNULL(ALACAK2,0) ALACAK2
	FROM
	<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
		COMPANY_REMAINDER WITH (NOLOCK)
	<cfelseif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
		CONSUMER_REMAINDER WITH (NOLOCK)
	<cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
		EMPLOYEE_REMAINDER WITH (NOLOCK)
	</cfif>
	WHERE
    1=1
	<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
		AND COMPANY_REMAINDER.COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfif>
	<cfif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
		AND CONSUMER_REMAINDER.CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
	</cfif>
	<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
		AND EMPLOYEE_REMAINDER.EMPLOYEE_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
	</cfif>
</cfquery>
<cfquery name="GET_REMAINDER_MONEY" datasource="#DSN2#">
	SELECT
		BORC3,
		ALACAK3,
		BAKIYE3,
		VADE_BORC3,
		VADE_ALACAK3,
		OTHER_MONEY
	FROM
	<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id))))or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
		COMPANY_REMAINDER_MONEY WITH (NOLOCK)
	<cfelseif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
		CONSUMER_REMAINDER_MONEY WITH (NOLOCK)
	<cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
		EMPLOYEE_REMAINDER_MONEY WITH (NOLOCK)
	</cfif>
	WHERE
    1=1
	<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
	 AND COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfif>
	<cfif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
	AND CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
	</cfif>
	<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
		EMPLOYEE_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfif>
</cfquery>
<cfquery name="GET_PROJECT_REMAINDER" datasource="#DSN2#">
	SELECT
		BAKIYE3,
		BAKIYE2,
		BAKIYE,
		OTHER_MONEY,
		PROJECT_ID
	FROM
		<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
            COMPANY_REMAINDER_MONEY_PROJECT WITH (NOLOCK)
        <cfelseif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
            CONSUMER_REMAINDER_MONEY_PROJECT WITH (NOLOCK)
        <cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
            EMPLOYEE_REMAINDER_MONEY_PROJECT WITH (NOLOCK)
        </cfif>
	WHERE
    1=1
		<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
           AND COMPANY_REMAINDER_MONEY_PROJECT.COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfif>
        <cfif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
           AND CONSUMER_REMAINDER_MONEY_PROJECT.CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        </cfif>
        <cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
           AND EMPLOYEE_REMAINDER_MONEY_PROJECT.EMPLOYEE_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
        </cfif>
</cfquery>
<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
	<cfset member_id_ = "&company_id=#attributes.company_id#">
	<cfset member_type = 'partner'>
<cfelseif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
	<cfset member_id_ = "&consumer_id=#attributes.consumer_id#">
	<cfset member_type = 'consumer'>
<cfelse>
	<cfset member_id_ = "">
	<cfset member_type = 'employee'>
</cfif>
<cfset member_type_ = member_type>
<div class="ui-scroll">
    <div id="borc_alacak_summary">
        <cf_grid_list>
            <cfif get_remainder.recordcount>
                <cfoutput>
                    <thead>
                        <tr>
                            <th colspan="3"><cf_get_lang dictionary_id='57866.Borç Alacak Durumu'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                            <td class="text-right">(#session_base.money#)</td>
                            <td class="text-right"><cfif len(session_base.money2)>(#session_base.money2#)</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57587.Borç'></td>
                            <td nowrap="nowrap" class="text-right" width="100">#TLFormat(ABS(get_remainder.borc))#</td>
                            <td nowrap="nowrap" class="text-right" width="100"><cfif len(session_base.money2)>#TLFormat(ABS(get_remainder.borc2))#</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57588.Alacak'></td>
                            <td class="text-right">#TLFormat(ABS(get_remainder.alacak))#</td>
                            <td class="text-right"><cfif len(session_base.money2)>#TLFormat(ABS(get_remainder.alacak2))#</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57589.Bakiye'></td>
                            <cfif get_module_user(23)>
                            <td class="text-right"><cfif isdefined('session.ep')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ch.list_company_extre&form_submit=1&member_type=#member_type_#&company=#URLEncodedFormat(attributes.company)#<cfif isdefined('member_id_') and len(member_id_)>#member_id_#</cfif>&comp_name=#URLEncodedFormat(attributes.company)#','page')"><font color="FF0000"></cfif>#TLFormat(get_remainder.bakiye)#<cfif get_remainder.borc gte get_remainder.alacak>(B)<cfelse>(A)</cfif></font></a></td>
                            <td class="text-right"><cfif isdefined('session.ep')><cfif len(session_base.money2)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ch.list_company_extre&form_submit=1&member_type=#member_type_#&company=#URLEncodedFormat(attributes.company)#<cfif isdefined('member_id_') and len(member_id_)>#member_id_#</cfif>&list_type=3&comp_name=#URLEncodedFormat(attributes.company)#','page')"><font color="FF0000"></cfif>#TLFormat((ABS(get_remainder.borc2))-(ABS(get_remainder.alacak2)))# <cfif get_remainder.borc2 gte get_remainder.alacak2>(B)<cfelse>(A)</cfif></font></a></cfif></td>
                            <cfelse>
                            <td class="text-right">#TLFormat(get_remainder.bakiye)#<cfif get_remainder.borc gte get_remainder.alacak>(B)<cfelse>(A)</cfif></td>
                            <td class="text-right"><cfif len(session_base.money2)>#TLFormat((ABS(get_remainder.borc2))-(ABS(get_remainder.alacak2)))# <cfif get_remainder.borc2 gte get_remainder.alacak2>(B)<cfelse>(A)</cfif></cfif></td>
                            </cfif>
                        </tr>
                    </tbody>
                </cfoutput>
            </cfif>
        </cf_grid_list>
        <cf_grid_list>
            <cfif get_remainder_money.recordcount>
                <thead>
                    <tr>
                        <th colspan="3"><cf_get_lang dictionary_id='57920.Döviz Bakiyeleri'></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td width="100"><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                        <td class="text-right" width="100"><cf_get_lang dictionary_id='58082.Adet'></td>
                        <td class="text-right" width="100"><cf_get_lang dictionary_id='57868.Döviz Bakiye'></td>
                    </tr>
                    <cfoutput query="get_remainder_money">
                        <tr>
                            <td width="100">#other_money#</td>
                            <td class="text-right"><cfif abs(borc3) neq 0 or abs(alacak3) neq 0>#TLFormat(((abs(vade_borc3) * abs(borc3)) + (abs(vade_alacak3) * abs(alacak3)))/(abs(borc3)+abs(alacak3)),0)#</cfif></td>
                            <td class="text-right" nowrap="nowrap">#TLFormat(abs(bakiye3))#&nbsp;#other_money# <cfif borc3 gte alacak3>(B)<cfelse>(A)</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cfif>
        </cf_grid_list>
    </div>
    <cfif not(isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.company') and len(attributes.company) and member_type is 'employee')>	
        <cfquery name="GET_COMPANY_RISK" datasource="#DSN2#">
            SELECT 
                BAKIYE,
                ISNULL(BAKIYE2,0) BAKIYE2,
                CEK_ODENMEDI,
                CEK_ODENMEDI2,
                CEK_KARSILIKSIZ,
                CEK_KARSILIKSIZ2,
                SENET_ODENMEDI,
                SENET_ODENMEDI2,
                SENET_KARSILIKSIZ,
                SENET_KARSILIKSIZ2,
                ISNULL(FORWARD_SALE_LIMIT,0) FORWARD_SALE_LIMIT,
                ISNULL(OPEN_ACCOUNT_RISK_LIMIT,0) OPEN_ACCOUNT_RISK_LIMIT,
                PAYMENT_BLOKAJ,
                ISNULL(TOTAL_RISK_LIMIT,0) TOTAL_RISK_LIMIT,
                SECURE_TOTAL_TAKE,
                SECURE_TOTAL_TAKE2,
                SECURE_TOTAL_GIVE,
                SECURE_TOTAL_GIVE2,
            <cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
                COMPANY_ID
            <cfelseif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
                CONSUMER_ID
            </cfif>
            FROM 
            <cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
                COMPANY_RISK WITH (NOLOCK)
            <cfelseif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
                CONSUMER_RISK WITH (NOLOCK)
            </cfif>
            WHERE
            1=1 
            <cfif (isdefined('attributes.company_id') and len(attributes.company_id) and ((len(attributes.company) and member_type is 'partner') or (isdefined("attributes.partner_id") and len(attributes.partner_id)))) or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1)>
                AND COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            <cfelseif (isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer')or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
                AND CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfif>
        </cfquery>
        <cfif len(session_base.money2)>
            <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
                SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WITH (NOLOCK) WHERE MONEY = '#session_base.money2#'
            </cfquery>
        </cfif>
        <cfset order_amount = 0>
        <cfset ship_amount = 0>
        <cfset order_amount2 = 0>
        <cfset ship_amount2 = 0>
        <cfif isdefined("get_open_order_ships") and get_open_order_ships.recordcount and len(get_open_order_ships.order_total)>
            <cfset order_amount = get_open_order_ships.order_total>
            <cfif len(session_base.money2) and len(get_open_order_ships.order_total2)>
                <cfset order_amount2 = get_open_order_ships.order_total2>
            </cfif>
        </cfif>
        <cfif isdefined("get_open_order_ships") and get_open_order_ships.recordcount and len(get_open_order_ships.ship_total)>
            <cfset ship_amount = get_open_order_ships.ship_total>
            <cfif len(session_base.money2) and len(get_open_order_ships.ship_total2)>
                <cfset ship_amount2 = get_open_order_ships.ship_total2>
            </cfif>
        </cfif>
        <cfoutput>
            <cfif get_company_risk.recordcount>
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th colspan="3"><cf_get_lang dictionary_id='57869.Risk Durumu'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                            <td width="100" class="text-right">(#session_base.money#)</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>(#session_base.money2#)</cfif></td>
                        </tr>
                        <cfset start_date = date_add('d',1,now())>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='58977.Ödenmemiş Çek'></td>
                            <cfif get_module_user(21)>
                                <td width="100" nowrap="nowrap" class="text-right" width="100"><cfif isdefined('session.ep')><a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&member_type=#member_type#&company=#URLEncodedFormat(attributes.company)#<cfif len(member_id_)>#member_id_#</cfif><!--- &start_date=#dateformat(start_date,dateformat_style)# --->&status=1,2,4,13" target="_blank"><font color="FF0000"></cfif>#TLFormat(get_company_risk.cek_odenmedi)#</font></a></td>
                                <td width="100" nowrap="nowrap" class="text-right"><cfif isdefined('session.ep')><a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&member_type=#member_type#&company=#URLEncodedFormat(attributes.company)#<cfif len(member_id_)>#member_id_#</cfif><!--- &start_date=#dateformat(start_date,dateformat_style)# --->&status=1,2,4,13" target="_blank"><font color="FF0000"></cfif><cfif len(session_base.money2)>#TLFormat(get_company_risk.cek_odenmedi2)#</cfif></font></a></td>
                            <cfelse>
                                <td width="100" nowrap="nowrap" class="text-right" width="100">#TLFormat(get_company_risk.cek_odenmedi)#</td>
                                <td width="100" nowrap="nowrap" class="text-right"><cfif len(session_base.money2)>#TLFormat(get_company_risk.cek_odenmedi2)#</cfif></td>
                            </cfif>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='58978.Ödenmemiş Senet'></td>
                            <cfif get_module_user(21)>
                            <td width="100" nowrap="nowrap" class="text-right"><cfif isdefined('session.ep')><a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&member_type=#member_type#&company=#URLEncodedFormat(attributes.company)#<cfif Len(member_id_)>#member_id_#</cfif><!--- &due_start_date=#dateformat(start_date,dateformat_style)# --->&status=1,2,4,13" target="_blank"><font color="FF0000"></cfif>#TLFormat(get_company_risk.senet_odenmedi)#</font></a></td>
                            <td width="100" nowrap="nowrap" class="text-right"><cfif isdefined('session.ep')><a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&member_type=#member_type#&company=#URLEncodedFormat(attributes.company)#<cfif Len(member_id_)>#member_id_#</cfif><!--- &due_start_date=#dateformat(start_date,dateformat_style)# --->&status=1,2,4,13" target="_blank"><font color="FF0000"></cfif><cfif len(session_base.money2)>#TLFormat(get_company_risk.senet_odenmedi2)#</cfif></font></a></td>
                            <cfelse>
                            <td width="100" nowrap="nowrap" class="text-right">#TLFormat(get_company_risk.senet_odenmedi)#</td>
                            <td width="100" nowrap="nowrap" class="text-right"><cfif len(session_base.money2)>#TLFormat(get_company_risk.senet_odenmedi2)#</cfif></td>
                            </cfif>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='58979.Karşılıksız Çek'></td>
                            <cfif get_module_user(21)>
                                <td width="100" class="text-right"><cfif isdefined('session.ep')><a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&member_type=#member_type#&company=#URLEncodedFormat(attributes.company)#<cfif Len(member_id_)>#member_id_#</cfif>&status=5" target="_blank"><font color="FF0000"></cfif>#TLFormat(get_company_risk.cek_karsiliksiz)#</font></a></td>
                                <td width="100" class="text-right"><cfif isdefined('session.ep')><a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&member_type=#member_type#&company=#URLEncodedFormat(attributes.company)#<cfif Len(member_id_)>#member_id_#</cfif>&status=5" target="_blank"><font color="FF0000"></cfif><cfif len(session_base.money2)>#TLFormat(get_company_risk.cek_karsiliksiz2)#</cfif></font></a></td>
                            <cfelse>
                            <td width="100" class="text-right">#TLFormat(get_company_risk.cek_karsiliksiz)#</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>#TLFormat(get_company_risk.cek_karsiliksiz2)#</cfif></td>
                            </cfif>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='58980.Karşılıksız Senet'></td>
                            <cfif get_module_user(21)>
                                <td width="100" class="text-right"><cfif isdefined('session.ep')><a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&member_type=#member_type#&company=#URLEncodedFormat(attributes.company)#<cfif Len(member_id_)>#member_id_#</cfif>&status=5" target="_blank"><font color="FF0000"></cfif>#TLFormat(get_company_risk.senet_karsiliksiz)#</font></a></td>
                                <td width="100" class="text-right"><cfif isdefined('session.ep')><a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&member_type=#member_type#&company=#URLEncodedFormat(attributes.company)#<cfif Len(member_id_)>#member_id_#</cfif>&status=5" target="_blank"><font color="FF0000"></cfif><cfif len(session_base.money2)>#TLFormat(get_company_risk.senet_karsiliksiz2)#</cfif></font></a></td>
                            <cfelse>
                                <td width="100" class="text-right">#TLFormat(get_company_risk.senet_karsiliksiz)#</td>
                                <td width="100" class="text-right"><cfif len(session_base.money2)>#TLFormat(get_company_risk.senet_karsiliksiz2)#</cfif></td>
                            </cfif>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='58622.Açık Siparişler'></td>
                            <td width="100" class="text-right">#TLFormat(order_amount)#</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>#TLFormat(order_amount2)#</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='58955.Faturalanmamış İrsaliyeler'></td>
                            <td width="100" class="text-right">#TLFormat(ship_amount)#</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>#TLFormat(ship_amount2)#</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57872.Toplam Risk'></td>
                            <td width="100" class="text-right">#TLFormat(get_company_risk.bakiye + ship_amount + order_amount + (get_company_risk.cek_odenmedi + get_company_risk.senet_odenmedi + get_company_risk.cek_karsiliksiz + get_company_risk.senet_karsiliksiz))#</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>#TLFormat(get_company_risk.bakiye2 + ship_amount2 + order_amount2 + get_company_risk.cek_odenmedi2 + get_company_risk.senet_odenmedi2 + get_company_risk.cek_karsiliksiz2 + get_company_risk.senet_karsiliksiz2)#</cfif></td>
                        </tr>
                        <tr>
                            <td width="100" nowrap="nowrap"><cf_get_lang dictionary_id='57873.Toplam Teminat(Alınan-Verilen)'></td>
                            <td width="100" class="text-right"><cfif isdefined('session.ep')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_securefund<cfif Len(member_id_)>#member_id_#</cfif>','list');">
                            <font color="FF0000"></cfif>#TLFormat(wrk_round(get_company_risk.secure_total_take-get_company_risk.secure_total_give))#</font></a></td>
                            <td width="100" class="text-right"><cfif isdefined('session.ep')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_securefund<cfif Len(member_id_)>#member_id_#</cfif>','list');">
                            <font color="FF0000"></cfif><cfif len(session_base.money2)>#TLFormat(get_company_risk.secure_total_take2-get_company_risk.secure_total_give2)#</cfif></font></a></td>
                        </tr>
                    </tbody>
                </cf_grid_list>
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th colspan="3"><cf_get_lang dictionary_id='57874.Limit Durumu'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                            <td width="100" class="text-right" width="100">(#session_base.money#)</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>(#session_base.money2#)</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></td>
                            <td width="100" nowrap="nowrap" class="text-right">#TLFormat(get_company_risk.open_account_risk_limit)#</td>
                            <td width="100" nowrap="nowrap" class="text-right"><cfif len(session_base.money2)>#TLFormat(get_company_risk.open_account_risk_limit/get_money_info.rate)#</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57876.Çek Senet Limiti'></td>
                            <td width="100" class="text-right">#TLFormat(get_company_risk.forward_sale_limit)#</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>#TLFormat(get_company_risk.forward_sale_limit/get_money_info.rate)#</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57877.Toplam Limit'></td>
                            <td width="100" class="text-right">#TLFormat(get_company_risk.total_risk_limit)#</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>#TLFormat(get_company_risk.total_risk_limit/get_money_info.rate)#</cfif></td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='57878.Kullanılabilir Limit'></td>
                            <cfif len(session_base.money2)><cfset other_total_limit = get_company_risk.total_risk_limit/get_money_info.rate></cfif>
                            <td width="100" class="text-right">#TLFormat(get_company_risk.total_risk_limit - order_amount - ship_amount - (get_company_risk.bakiye  + (get_company_risk.cek_odenmedi + get_company_risk.senet_odenmedi + get_company_risk.cek_karsiliksiz + get_company_risk.senet_karsiliksiz)))#</td>
                            <td width="100" class="text-right"><cfif len(session_base.money2)>#TLFormat(other_total_limit - order_amount2 - ship_amount2 - (get_company_risk.bakiye2  + get_company_risk.cek_odenmedi2 + get_company_risk.senet_odenmedi2 + get_company_risk.cek_karsiliksiz2 + get_company_risk.senet_karsiliksiz2))#</cfif></td>
                        </tr>
                    </tbody>
                </cf_grid_list>
            </cfif>
        </cfoutput>
        <cfif (isdefined("session.ep") and session.ep.our_company_info.project_followup and get_project_remainder.recordcount) or not isdefined("session.ep")>
            <cfset project_list=''>
            <cfoutput query="get_project_remainder">
                <cfif len(project_id) and not listfind(project_list,project_id)>
                    <cfset project_list=listappend(project_list,project_id)>
                </cfif>
            </cfoutput> 
            <cfif listlen(project_list)>
                <cfset project_list=listsort(project_list,"numeric","ASC",',')>
                <cfquery name="GET_PROJECT" datasource="#DSN#">
                    SELECT
                        PROJECT_ID,
                        PROJECT_HEAD
                    FROM 
                        PRO_PROJECTS  WITH (NOLOCK)
                    WHERE
                        PROJECT_ID IN (#project_list#)
                    ORDER BY
                        PROJECT_ID
                </cfquery>
                <cfset main_project_list = listsort(listdeleteduplicates(valuelist(get_project.project_id,',')),'numeric','ASC',',')>
            </cfif>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th colspan="4"><cf_get_lang dictionary_id='57416.Proje'><cf_get_lang dictionary_id='57866.Borç Alacak Durumu'></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td width="100"><cf_get_lang dictionary_id='57416.Proje'></td>
                        <td width="100" class="text-right" width="100"><cfoutput>#session_base.money#</cfoutput> <cf_get_lang dictionary_id='57589.Bakiye'></td>
                        <cfif len(session_base.money2)><td class="text-right" width="100"><cfoutput>#session_base.money2#</cfoutput> <cf_get_lang dictionary_id='57589.Bakiye'></td></cfif>
                        <td width="100" class="text-right" nowrap="nowrap" width="100"><cf_get_lang dictionary_id='58121.İşlem Dövizi'><cf_get_lang dictionary_id='57589.Bakiye'></td>
                    </tr>
                    <cfoutput query="get_project_remainder">
                        <tr>
                            <td width="100"> 
                                <cfif len(project_id) and len(project_list)>
                                    #get_project.project_head[listfind(main_project_list,project_id,',')]#
                                <cfelse>
                                    <cf_get_lang dictionary_id ='58459.Projesiz'>
                                </cfif>
                            </td>
                            <td width="100" nowrap="nowrap" class="text-right">#TLFormat(bakiye)#</td>
                            <cfif len(session_base.money2)><td width="100" nowrap="nowrap" class="text-right">#TLFormat(bakiye2)#</td></cfif>
                            <td width="100" nowrap="nowrap" class="text-right">#TLFormat(bakiye3)# #other_money# <cfif bakiye3 gt 0>(B)<cfelse>(A)</cfif></td>
                        </tr>
                    </cfoutput>	
                </tbody>
            </cf_grid_list>
        <cfelse>
            <table>
                <tr>
                    <td colspan="3"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
                </tr>
            </table>
        </cfif>
    </cfif>
</div>
