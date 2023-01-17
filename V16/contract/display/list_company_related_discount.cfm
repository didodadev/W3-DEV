<cf_get_lang_set module_name="contract">
<cf_grid_list>
    <thead>
        <tr>
            <cfif get_module_user(17)><th width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=contract.popup_purchase_general_discount&company_id=#url.company_id#</cfoutput>','','ui-draggable-box-small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></a></i></th></cfif>
            <th width="150"><cf_get_lang dictionary_id='57630.Tip'></th>
            <th width="250"><cf_get_lang dictionary_id='57629.Açıklama'></th>
            <th width="200"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
            <th width="200"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
            <th width="200"><cf_get_lang dictionary_id='57641.İskonto'> %</th>
            <th width="300"><cf_get_lang dictionary_id='50965.Geçerli Şubeler'></th>
        </tr>
    </thead>
    <tbody>
        <cfquery name="get_purchase_sales_discount" datasource="#DSN3#"><!--- 1=Satınalma ve 2=satış  iskontaları--->
            SELECT 
                1 TYPE,
                GENERAL_DISCOUNT_ID,
                DISCOUNT_HEAD,
                START_DATE,
                FINISH_DATE,
                DISCOUNT,
                GENERAL_DISCOUNT_ID,
                COMPANY_ID
            FROM
                CONTRACT_PURCHASE_GENERAL_DISCOUNT
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        UNION ALL
            SELECT 
                2 TYPE,
                GENERAL_DISCOUNT_ID,
                DISCOUNT_HEAD,
                START_DATE,
                FINISH_DATE,
                DISCOUNT,
                GENERAL_DISCOUNT_ID,
                COMPANY_ID
            FROM
                CONTRACT_SALES_GENERAL_DISCOUNT
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfquery>
        <cfif get_purchase_sales_discount.recordcount>
            <cfinclude template="../query/get_branches.cfm">
            <cfoutput query="get_purchase_sales_discount">
                <tr>
                    <cfif get_module_user(17)><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=contract.popup_purchase_general_discount_detail&company_id=#attributes.company_id#&general_discount_id=#GENERAL_DISCOUNT_ID#&TYPE=#TYPE#','','ui-draggable-box-small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td></cfif>
                    <td><cfif TYPE eq 1><cf_get_lang dictionary_id='57449.Satın Alma'><cfelse><cf_get_lang dictionary_id='57448.Satış'></cfif></td>
                    <td>#DISCOUNT_HEAD#</td>
                    <td>#dateformat(START_DATE,dateformat_style)#</td>
                    <td>#dateformat(FINISH_DATE,dateformat_style)#</td>
                    <td>%#DISCOUNT#</td>
                    <td>
                    <cfif TYPE eq 1>
                        <cfset TABLO_SUBE = 'CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES'>
                    <cfelseif TYPE eq 2>
                        <cfset TABLO_SUBE = 'CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES'>
                    </cfif>
                    <cfquery name="get_discount_branches" datasource="#DSN3#">
                        SELECT 
                            * 
                        FROM 
                            #TABLO_SUBE# 
                        WHERE 
                            GENERAL_DISCOUNT_ID = #get_purchase_sales_discount.GENERAL_DISCOUNT_ID#
                    </cfquery>
                    <cfset sayac=0>
                    <cfloop query="get_discount_branches">
                        <cfset sube_id = BRANCH_ID>
                        <cfloop query="get_branches">
                            <cfif sube_id eq BRANCH_ID>
                                <cfset sayac = sayac+1>
                                #BRANCH_NAME#,
                                <cfif sayac mod 6 eq 0><br/></cfif>
                            </cfif>	
                        </cfloop>
                    </cfloop>
                    </td>
                </tr>
            </cfoutput>
        </cfif>
    </tbody>
</cf_grid_list>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
