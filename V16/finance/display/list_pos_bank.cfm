<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfquery name="get_branch" datasource="#dsn#">
	SELECT
		BRANCH_ID, 
		BRANCH_NAME 
	FROM
		BRANCH
	WHERE
		COMPANY_ID = #session.ep.company_id#	
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfif isdefined('attributes.is_submitted')>
	<cfinclude template="../query/get_pos_bank.cfm">
<cfelse>
	<cfset get_pos_equipment_bank.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_pos_equipment_bank.recordcount#'>
<cf_box title="#getLang('finance',400)#"> 
    <cfform action="#request.self#?fuseaction=finance.list_bank_pos" method="post" name="get_">
        <input type="hidden" name="is_submitted" id="is_submitted" value="1">
        <cf_box_search>
            <div class="form-group">
                <cfinput type="text" name="keyword" attributes value="#attributes.keyword#" placeholder="#getLang('main',48)#" maxlength="50">
            </div>
            <div class="form-group">
                <select name="branch_id" id="branch_id" attributes>
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_branch">
                        <option value="#BRANCH_ID#"<cfif attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                    </cfoutput>
                </select>            
            </div>
            <div class="form-group small">
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#"  maxlength="3">
            </div> 
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div> 
        </cf_box_search>
    
    </cfform>
    <cf_grid_list>
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th width="100"><cf_get_lang dictionary_id='54804.Cihaz Kodu'></th>
                <th><cf_get_lang dictionary_id='54576.Cihaz'></th>
                <th><cf_get_lang dictionary_id='54806.İşyeri Kodu'></th>
                <th><cf_get_lang dictionary_id='57652.Hesap'></th>
                <th><cf_get_lang dictionary_id='57453.Şube'></th>
                <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                <th width="35"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_bank_pos&event=add')"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil --><!-- sil -->
            </tr>
        </thead>
        <tbody>
            <cfif get_pos_equipment_bank.recordcount>
                <cfset branch_id_list=''>
                <cfset account_id_list = ''>
                <cfoutput query="get_pos_equipment_bank" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <cfif len(BRANCH_ID) and not listfind(branch_id_list,BRANCH_ID)>
                        <cfset branch_id_list=listappend(branch_id_list,BRANCH_ID)>
                    </cfif>
                    <cfif len(account_id) and not listfind(account_id_list,account_id)>
                        <cfset account_id_list=listappend(account_id_list,ACCOUNT_ID,',')>
                    </cfif>
                </cfoutput>
                <cfif len(branch_id_list)>
                    <cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
                    <cfquery name="get_branch_detail" datasource="#dsn#">
                        SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
                    </cfquery>
                </cfif>
                <cfif len(account_id_list)>
                    <cfset account_id_list = listsort(account_id_list,"numeric","ASC",",")>
                    <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
                        SELECT
                            ACCOUNTS.ACCOUNT_NAME,
                            ACCOUNTS.ACCOUNT_ID
                        FROM
                            ACCOUNTS,
                            BANK_BRANCH
                        WHERE
                            ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND 
                            <cfif session.ep.period_year lt 2009>
                                (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') AND
                            <cfelse>
                                ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) AND
                            </cfif>
                            ACCOUNTS.ACCOUNT_ID IN (#account_id_list#) 
                        ORDER BY
                            ACCOUNTS.ACCOUNT_ID
                    </cfquery>
                    <cfset main_account_id_list = listsort(listdeleteduplicates(valuelist(GET_ACCOUNTS.ACCOUNT_ID,',')),'numeric','ASC',',')>			
                </cfif>
                <cfoutput query="get_pos_equipment_bank" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#POS_CODE#</td>                
                        <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=finance.list_bank_pos&event=upd&pos_id=#pos_id#');" class="tableyazi">#EQUIPMENT#</a></td>
                        <td>#SELLER_CODE#</td>
                        <td><cfif len(account_id)>#get_accounts.account_name[listfind(main_account_id_list,account_id,',')]#</cfif></td>
                        <td><cfif len(BRANCH_ID)>#get_branch_detail.BRANCH_NAME[listfind(branch_id_list,BRANCH_ID,',')]#</cfif></td>
                        <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                        <!-- sil --><td width="15"><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=finance.list_bank_pos&event=upd&pos_id=#pos_id#')"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                    </tr>            
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="10"><cfif isdefined('attributes.is_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
            </cfif>
        </tbody>
    </cf_grid_list>
    <cfset adres='finance.list_bank_pos'>
    <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
    <cfset adres = "#adres#&keyword=#attributes.keyword#">
    </cfif>
    <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
    <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif isDefined("attributes.is_submitted")>
    <cfset adres = "#adres#&is_submitted=#attributes.is_submitted#">
    </cfif>
    <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#adres#">
</cf_box>
    <script type="text/javascript">
        document.getElementById('keyword').focus();
    </script>

