<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.credit_type" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_credit_limit" datasource="#dsn3#">
		SELECT 
			CR.*,
			A.ACCOUNT_NAME,
			SCT.CREDIT_TYPE CREDIT_TYPE_NAME
		FROM
			CREDIT_LIMIT CR,
			ACCOUNTS A,
			#dsn_alias#.SETUP_CREDIT_TYPE SCT
		WHERE
			A.ACCOUNT_ID = CR.ACCOUNT_ID
			AND CR.CREDIT_TYPE = SCT.CREDIT_TYPE_ID
			<cfif len(attributes.credit_type)>
				AND CR.CREDIT_TYPE = #attributes.credit_type#
			</cfif>
			<cfif len(attributes.account_id)>
				AND CR.ACCOUNT_ID = #attributes.account_id#
			</cfif>
		UNION ALL
			SELECT 
				CR.*,
				'' ACCOUNT_NAME,
				SCT.CREDIT_TYPE CREDIT_TYPE_NAME
			FROM
				CREDIT_LIMIT CR,
				#dsn_alias#.SETUP_CREDIT_TYPE SCT
			WHERE
				CR.ACCOUNT_ID IS NULL
				AND CR.CREDIT_TYPE = SCT.CREDIT_TYPE_ID
				<cfif len(attributes.credit_type)>
					AND CR.CREDIT_TYPE = #attributes.credit_type#
				</cfif>
				<cfif len(attributes.account_id)>
					AND CR.ACCOUNT_ID = #attributes.account_id#
				</cfif>
		ORDER BY
			RECORD_DATE
	</cfquery>
<cfelse> 
	<cfset get_credit_limit.recordcount = 0>
</cfif>
<cfquery name="get_credit_type" datasource="#dsn#">
	SELECT * FROM SETUP_CREDIT_TYPE
</cfquery>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_credit_limit.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = ''>
<cfif isdefined("credit_limit_id")>
	<cfset url_string = "#url_string#&credit_limit_id=#credit_limit_id#">
</cfif>
<cfif isdefined("limit_head")>
	<cfset url_string = "#url_string#&limit_head=#limit_head#">
</cfif>
<cf_box title="#getLang('','Kredi Limiti',58963)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="list_credit_contract" method="post" action="#request.self#?fuseaction=objects.popup_list_credit_limit&#url_string#">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
        <cf_box_search more="0">
            <div class="form-group" id="credit_type">
                <select name="credit_type" id="credit_type">
                    <option value=""><cf_get_lang dictionary_id='34283.Kredi Türü'></option>
                    <cfoutput query="get_credit_type">
                        <option value="#credit_type_id#" <cfif attributes.credit_type eq credit_type_id>selected</cfif>>#credit_type#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group" id="">
                <cf_wrkBankAccounts width='185' selected_value='#attributes.account_id#'>
            </div>
            <div class="form-group small">
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_credit_contract' , #attributes.modal_id#)"),DE(""))#">
            </div>
        </cf_box_search>
    </cfform>
    <cf_flat_list>
        <thead>
            <tr>
                <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                <th width="200"><cf_get_lang dictionary_id='58820.Başlık'></th>
                <th width="200"><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
                <th width="200"><cf_get_lang dictionary_id='34283.Kredi Türü'></th>
                <th width="150" class="text-right"><cf_get_lang dictionary_id='58963.Kredi Limiti'></th>
                <th width="120" class="text-right"><cf_get_lang dictionary_id='34286.Tahsilatlar'></th>
                <th width="120" class="text-right"><cf_get_lang dictionary_id='58658.Ödemeler'></th>
                <th width="120" class="text-right"><cf_get_lang dictionary_id='57878.Kullanılabilir Limit'></th>
                <th width="100"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
            </tr>
        </thead>
        <tbody>
            <cfif get_credit_limit.recordcount>
                <cfset credit_limit_list=''>
                <cfoutput query="get_credit_limit" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif not listfind(credit_limit_list,credit_limit_id)>
                        <cfset credit_limit_list=listappend(credit_limit_list,credit_limit_id)>
                    </cfif>		
                </cfoutput>
                <cfif len(credit_limit_list)>
                    <cfset credit_limit_list=listsort(credit_limit_list,"numeric")>
                    <cfquery name="get_revenue" datasource="#dsn3#">
                        SELECT
                            ISNULL(SUM(CAPITAL_PRICE),0) REVENUE_TOTAL,
                            CC.CREDIT_LIMIT_ID
                        FROM
                            CREDIT_CONTRACT CC,
                            #dsn2_alias#.CREDIT_CONTRACT_PAYMENT_INCOME CCI
                        WHERE
                            CC.CREDIT_CONTRACT_ID = CCI.CREDIT_CONTRACT_ID
                            AND CC.CREDIT_LIMIT_ID IN(#credit_limit_list#)
                            AND CCI.PROCESS_TYPE = 292
                        GROUP BY
                            CC.CREDIT_LIMIT_ID
                        ORDER BY
                            CC.CREDIT_LIMIT_ID
                    </cfquery>
                    <cfset credit_limit_list1 = listsort(listdeleteduplicates(valuelist(get_revenue.CREDIT_LIMIT_ID,',')),'numeric','ASC',',')>
                    <cfquery name="get_payment" datasource="#dsn3#">
                        SELECT
                            ISNULL(SUM(CAPITAL_PRICE),0) PAYMENT_TOTAL,
                            CC.CREDIT_LIMIT_ID
                        FROM
                            CREDIT_CONTRACT CC,
                            #dsn2_alias#.CREDIT_CONTRACT_PAYMENT_INCOME CCI
                        WHERE
                            CC.CREDIT_CONTRACT_ID = CCI.CREDIT_CONTRACT_ID
                            AND CC.CREDIT_LIMIT_ID IN(#credit_limit_list#)
                            AND CCI.PROCESS_TYPE = 291
                        GROUP BY
                            CC.CREDIT_LIMIT_ID
                        ORDER BY
                            CC.CREDIT_LIMIT_ID
                    </cfquery>
                    <cfset credit_limit_list2 = listsort(listdeleteduplicates(valuelist(get_payment.CREDIT_LIMIT_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfoutput query="get_credit_limit" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfset revenue = get_revenue.REVENUE_TOTAL[listfind(credit_limit_list1,credit_limit_id,',')]>
                    <cfset payment = get_payment.PAYMENT_TOTAL[listfind(credit_limit_list2,credit_limit_id,',')]>
                    <cfif not len(revenue)><cfset revenue = 0></cfif>
                    <cfif not len(payment)><cfset payment = 0></cfif>
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="javascript://" class="tableyazi"  onClick="gonder('#credit_limit_id#','#limit_head#')">#limit_head#</td> 
                        <td>#account_name#</td> 
                        <td>#credit_type_name#</td> 
                        <td class="text-right">#tlformat(credit_limit)#</td> 
                        <td class="text-right">#tlformat(revenue)#</td> 
                        <td class="text-right">#tlformat(payment)#</td> 
                        <td class="text-right">#tlformat(credit_limit-(revenue-payment))#</td>
                        <td>#money_type#</td> 
                    </tr> 
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfset adres="objects.popup_list_credit_limit&#url_string#">
        <cfif len(attributes.credit_type)>
            <cfset adres = "#adres#&credit_type=#attributes.credit_type#">
        </cfif>
        <cfif len(attributes.account_id)>
            <cfset adres = "#adres#&account_id=#attributes.account_id#">
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#"  
            startrow="#attributes.startrow#" 
            adres="#adres#&form_submitted=1"
            isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cfif>
</cf_box>
<script type="text/javascript">
	function gonder(id,name)
	{
		<cfif isDefined("attributes.credit_limit_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.credit_limit_id#</cfoutput>.value=id;
		</cfif>
		<cfif isDefined("attributes.limit_head")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.limit_head#</cfoutput>.value=name;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
