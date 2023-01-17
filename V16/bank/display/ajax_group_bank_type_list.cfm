<cfquery name="get_bank_with_type" datasource="#dsn3#">
    SELECT
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_TYPE,
		ACCOUNTS.ACCOUNT_NAME,
		ACCOUNTS.ACCOUNT_NO,
		ACCOUNTS.ACCOUNT_CREDIT_LIMIT,
		ACCOUNTS.ACCOUNT_BLOCKED_VALUE,
		BANK_BRANCH.BANK_BRANCH_ID,
        BANK_BRANCH.BANK_ID,
		BANK_BRANCH.BANK_BRANCH_NAME,
		BANK_BRANCH.BANK_NAME,
		ACCOUNTS.ACCOUNT_STATUS,
		ACCOUNTS.ACCOUNT_OWNER_CUSTOMER_NO,
		SETUP_BANK_TYPE_GROUPS.BANK_TYPE
	FROM
		ACCOUNTS LEFT JOIN BANK_BRANCH ON ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID	
		LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES ON SETUP_BANK_TYPES.BANK_ID = BANK_BRANCH.BANK_ID
		LEFT JOIN #dsn_alias#.SETUP_BANK_TYPE_GROUPS ON SETUP_BANK_TYPE_GROUPS.BANK_TYPE_ID = SETUP_BANK_TYPES.BANK_TYPE_GROUP_ID
	WHERE
        SETUP_BANK_TYPE_GROUPS.BANK_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_type_id#">
</cfquery>
<cfquery name="get_money_bskt" datasource="#DSN#">
    SELECT MONEY AS MONEY_TYPE,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfinclude template="../query/get_money_rate.cfm">
<cfset money_list = ''>
<cfset money_list2 = ''>
<cfset useful_money_list = ''>
<cfset useful_money_list2 = ''>
<cfset acc_id_list = ''>
<cfset col_ = 13>
<cfset system_bakiye_top = 0>

    <cfoutput query="get_bank_with_type">
        <cfif len(ACCOUNT_ID) and not listfind(acc_id_list,ACCOUNT_ID)>
            <cfset acc_id_list=listappend(acc_id_list,ACCOUNT_ID)>
        </cfif>
    </cfoutput>
    <cfif len(acc_id_list)>
        <cfset acc_id_list=listsort(acc_id_list,"numeric","ASC",",")>
        <cfif isDefined("attributes.date1") and len(attributes.date1)>
            <cfquery name="GET_DATE_ACC" datasource="#dsn2#">
                SELECT
                    SUM(BORC-ALACAK) BAKIYE,
                    ACCOUNT_ID
                FROM
                    DAILY_ACCOUNT_REMAINDER
                WHERE
                    ACCOUNT_ID IN (#acc_id_list#) AND
                    ACTION_DATE <= #attributes.date1#							
                GROUP BY
                    ACCOUNT_ID
                ORDER BY
                    ACCOUNT_ID
            </cfquery>
            <cfset acc_id_list_date = valuelist(GET_DATE_ACC.ACCOUNT_ID)>
        </cfif>
        <cfquery name="GET_BAKIYE" datasource="#dsn2#">
            SELECT BAKIYE_SYSTEM,BAKIYE,TARIH,ACCOUNT_ID FROM ACCOUNT_REMAINDER_LAST WHERE ACCOUNT_ID IN (#acc_id_list#) ORDER BY ACCOUNT_ID
        </cfquery>
        <cfset acc_id_list2 = valuelist(GET_BAKIYE.ACCOUNT_ID)>
        <cfset acc_id_list3 = valuelist(GET_BAKIYE.ACCOUNT_ID)>
    </cfif>
<table width="100%">
    <tr>
        <td valign="top">
            <cf_medium_list>
                <thead>
                    <th><cf_get_lang no='16.Hesap Adı'></th>
                    <th><cf_get_lang_main no='41.Şube'></th>
                    <th><cf_get_lang_main no='766.Hesap No'></th>
                    <th width="120" style="text-align:right;"><cf_get_lang_main no='177.Bakiye'></th>
                    <th width="45"><cf_get_lang_main no='1886.B/A'></th>
                    <th width="120" style="text-align:right;" nowrap="nowrap"><cf_get_lang no='22.Kullanılabilir Bakiye'></th>
                    <th width="45"><cf_get_lang_main no='1886.B/A'></th>
                    <th width="45"><cf_get_lang_main no='77.Para birimi'></th>
                    <th>Sistem Bakiye</th>
                    <th><cf_get_lang_main no='1886.B/A'></th>
                    <th><cf_get_lang dictionary_id='33046.Sistem Para Birimi'></th>
                    <!--- <th><cf_get_lang dictionary_id='35580.Mevcut Oran'>%</th>
                    <th><cf_get_lang dictionary_id='35558.Planlanan Oran'>%</th> --->
                </thead>
                <tbody>
                    <cfoutput query="get_bank_with_type">
                        <cfif len(get_bank_with_type.ACCOUNT_CREDIT_LIMIT)>
                            <cfset useful_bakiye=get_bank_with_type.ACCOUNT_CREDIT_LIMIT>
                        <cfelse>
                            <cfset useful_bakiye=0>
                        </cfif>
                        <cfset bakiye_ = GET_BAKIYE.BAKIYE[listfind(acc_id_list2,ACCOUNT_ID,',')]>
                        <cfset system_bakiye = GET_BAKIYE.BAKIYE_SYSTEM[listfind(acc_id_list3,ACCOUNT_ID,',')]>
                        <cfif isDefined("attributes.date1") and len(attributes.date1)>
                            <cfif len(GET_DATE_ACC.BAKIYE[listfind(acc_id_list_date,ACCOUNT_ID,',')])>
                                <cfset bakiye_date = GET_DATE_ACC.BAKIYE[listfind(acc_id_list_date,ACCOUNT_ID,',')]>
                            <cfelse>
                                <cfset bakiye_date = 0>
                            </cfif>
                        </cfif>
                        <cfif len(bakiye_)>
                            <cfset useful_bakiye = bakiye_ + useful_bakiye>
                        <cfelse>
                            <cfset bakiye_ = 0>  
                        </cfif>	 
                            <cfset money = get_bank_with_type.ACCOUNT_CURRENCY_ID>
                            <cfset useful_money_ = #bakiye_#+#ACCOUNT_CREDIT_LIMIT#>
                        <cfif bakiye_ gt 0>
                            <cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
                            <cfset useful_money_list = listappend(useful_money_list,'#useful_money_#*#money#',',')>
                        <cfelse>
                            <cfset money_list = listappend(money_list,'#bakiye_#*#money#',',')>
                            <cfset useful_money_list = listappend(useful_money_list,'#useful_money_#*#money#',',')>
                        </cfif>
                        <cfif isDefined("attributes.date1") and len(attributes.date1)>
                            <cfset useful_money2_ = #bakiye_date#+#ACCOUNT_CREDIT_LIMIT#>
                            <cfif bakiye_date gt 0>
                                <cfset money_list2 = listappend(money_list2,'#bakiye_date#*#money#',',')>
                                <cfset useful_money_list2 = listappend(useful_money_list2,'#useful_money2_#*#money#',',')>
                            <cfelse>
                                <cfset money_list2 = listappend(money_list2,'#bakiye_date#*#money#',',')>
                                <cfset useful_money_list2 = listappend(useful_money_list2,'#useful_money2_#*#money#',',')>
                            </cfif>	
                        </cfif>
                    <tr>
                        <td>
                            <cfif not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.form_upd_bank_account') and (session.ep.admin eq 1 or get_module_power_user(19))>
                                <a href="#request.self#?fuseaction=bank.list_bank_account&event=upd&id=#ACCOUNT_ID#" class="tableyazi">#get_bank_with_type.ACCOUNT_NAME#</a>
                            <cfelse>
                                #get_bank_with_type.ACCOUNT_NAME#
                            </cfif>
                        </td>
                        <td>#BANK_NAME# / #BANK_BRANCH_NAME#</td>
                        <td>#ACCOUNT_NO#</td>
                        <td style="text-align:right;"><cfif bakiye_ gt 0><span style="color:black"><cfelse><span style="color:red"></cfif>#TLFormat(ABS(bakiye_))#</span></span></td>
                        <td><cfif bakiye_ gt 0><span style="color:black">(B)</span><cfelse><span style="color:red">(A)</span></cfif></td>
                        <td style="text-align:right;"><cfif useful_BAKIYE gt 0><span style="color:black"><cfelse><span style="color:red"></cfif>#TLFormat(ABS(useful_bakiye))#</span></span></td>
                        <td><cfif useful_BAKIYE gt 0><span style="color:black">(B)</span><cfelse><span style="color:red">(A)</span></cfif></td>
                        <td>&nbsp;#ACCOUNT_CURRENCY_ID#</td>
                        <td style="text-align:right;">
                            <cfif len(system_bakiye) and system_bakiye gt 0>
                                <span style="color:black">
                            <cfelse>
                                <span style="color:red">
                            </cfif> 
                            <cfif not len(system_bakiye)><cfset system_bakiye = 0></cfif>
                            #TLFormat(ABS(system_bakiye))#</span></span><cfset system_bakiye_top = system_bakiye + system_bakiye_top>
                        </td>
                        <td>
                            <cfif bakiye_ gt 0><span style="color:black">(B)</span><cfelse><span style="color:red">(A)</span></cfif>
                        </td>
                        <td><cfif get_money_bskt.MONEY_TYPE EQ session.ep.MONEY>#get_money_bskt.MONEY_TYPE#</cfif></td>
                       <!---  <td></td>
                        <td></td> --->
                    </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <tr>
                        <td class="txtbold" style="text-align:right;" colspan="<cfoutput>#col_#</cfoutput>">
                            <cf_get_lang_main no='80.Toplam'> :
                            <cfset count = 0>
                            <cfoutput query="get_money_rate">
                                <cfset toplam_ara = 0>
                                <cfset toplam_ara2 = 0>
                                    <cfloop list="#money_list#" index="i">
                                        <cfset tutar_ = listfirst(i,'*')>
                                        <cfset money_ = listlast(i,'*')>
                                            <cfif money_ eq money>
                                                <cfset toplam_ara = toplam_ara + tutar_>
                                            </cfif>
                                    </cfloop>
                                    <cfloop list="#money_list2#" index="i">
                                        <cfset tutar2_ = listfirst(i,'*')>
                                        <cfset money2_ = listlast(i,'*')>
                                            <cfif money2_ eq money>
                                                <cfset toplam_ara2 = toplam_ara2 + tutar2_>
                                            </cfif>
                                    </cfloop>
                                <cfset count = count+2>
                                <cfif isDefined("attributes.date1") and len(attributes.date1)>
                                    <cfif toplam_ara2 neq 0>
                                        #TLFormat(ABS(toplam_ara2))# #money# <cfif toplam_ara2 gt 0>(B)<cfelse>(A)</cfif><cfif count neq get_money_rate.recordcount>,</cfif>
                                    </cfif>
                                <cfelse>
                                    <cfif toplam_ara neq 0>
                                        #TLFormat(ABS(toplam_ara))# #money# <cfif toplam_ara gt 0>(B)<cfelse>(A)</cfif><cfif count neq get_money_rate.recordcount>,</cfif>
                                    </cfif>
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                    <tr>
                        <td class="txtbold" style="text-align:right;" colspan="<cfoutput>#col_#</cfoutput>">
                            <cf_get_lang no='43.Kullanılabilir Toplam'> :
                            <cfset count = 0>
                            <cfoutput query="get_money_rate">
                                <cfset kullan_toplam = 0>
                                <cfset kullan_toplam2 = 0>
                                  <cfloop list="#useful_money_list#" index="i">
                                    <cfset kullan_tutar_ = listfirst(i,'*')>
                                    <cfset kullan_money_ = listlast(i,'*')>
                                        <cfif kullan_money_ eq money>
                                            <cfset kullan_toplam = kullan_toplam + kullan_tutar_>
                                        </cfif>
                                </cfloop> 
                                <cfloop list="#useful_money_list2#" index="i">
                                    <cfset kullan_tutar2_ = listfirst(i,'*')>
                                    <cfset kullan_money2_ = listlast(i,'*')>
                                    <cfif kullan_money2_ eq money>
                                        <cfset kullan_toplam2 = kullan_toplam2 + kullan_tutar2_>
                                    </cfif>
                                </cfloop>
                                <cfset count = count+2>
                                <cfif isDefined("attributes.date1") and len(attributes.date1)>
                                    <cfif kullan_toplam2 neq 0>
                                        #TLFormat(ABS(kullan_toplam2))# #money# <cfif kullan_toplam2 gt 0>(B)<cfelse>(A)</cfif><cfif count neq get_money_rate.recordcount>,</cfif>
                                    </cfif>
                                <cfelse>
                                    <cfif kullan_toplam neq 0>
                                        #TLFormat(ABS(kullan_toplam))# #money# <cfif kullan_toplam gt 0>(B)<cfelse>(A)</cfif><cfif count neq get_money_rate.recordcount>,</cfif>
                                    </cfif>
                                </cfif>
                            </cfoutput>  
                            <cfoutput>#TLFormat(ABS(system_bakiye_top))# #session.ep.money#</cfoutput>
                        </td>
                    </tr>
                </tfoot>
            </cf_medium_list>
        </td>
    </tr>
</table>