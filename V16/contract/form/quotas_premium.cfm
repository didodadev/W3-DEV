<cfquery name="get_sales_quota"	datasource="#DSN3#">
	SELECT
		*
	FROM
		SALES_QUOTAS
	WHERE 
		SALES_QUOTA_ID IS NOT NULL
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.company_id#">
	ORDER BY
		PLAN_DATE
</cfquery>
<cfset get_stage_list=''>
<cfoutput query="get_sales_quota">
<cfif len(PROCESS_STAGE) and not listfind(get_stage_list,PROCESS_STAGE)>
	<cfset get_stage_list = Listappend(get_stage_list,PROCESS_STAGE)>
</cfif>
</cfoutput>
<cfif len(get_stage_list)>
<cfset get_stage_list=listsort(get_stage_list,"numeric","ASC",",")>
<cfquery name="GET_STAGE" datasource="#DSN#">
	SELECT 
		PROCESS_ROW_ID,
		STAGE 
	FROM 
		PROCESS_TYPE_ROWS 
	WHERE 
		PROCESS_ROW_ID IN (#get_stage_list#)	
	ORDER BY
		PROCESS_ROW_ID
</cfquery>
<cfset get_stage_list = listsort(listdeleteduplicates(valuelist(GET_STAGE.PROCESS_ROW_ID,',')),'numeric','ASC',',')>				
</cfif>
<cf_grid_list>
    <thead>
        <tr>
            <th width="20"><a href="<cfoutput>#request.self#?fuseaction=salesplan.list_sales_quotas&event=add&company_id=#attributes.company_id#&comp_name=#get_par_info(get_credit_limit.company_id,1,0,0)#</cfoutput>" target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
            <th><cf_get_lang dictionary_id='57880.Belge No'></th>
            <th><cf_get_lang dictionary_id='57756.Süreç'></th>
            <th><cf_get_lang dictionary_id='58053.Başlama'></th>
            <th><cf_get_lang dictionary_id='57700.Bitiş'></th>
            <th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
            <th class="text-right"><cf_get_lang dictionary_id='50720.Prim'><cf_get_lang dictionary_id='57673.Tutar'></th>
            <th class="text-right"><cf_get_lang dictionary_id='50964.Mal Fazlası'></th>
            <th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'> <cfoutput>#session.ep.money#</cfoutput></th>
            <th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'> <cf_get_lang dictionary_id='57677.Döviz'></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_sales_quota">
            <tr>
                <td><a href="#request.self#?fuseaction=salesplan.list_sales_quotas&event=upd&q_id=#SALES_QUOTA_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                <td>#PAPER_NO#</td>
                <td>
                    <cfif len(PROCESS_STAGE)>
                        #GET_STAGE.STAGE[listfind(get_stage_list,get_sales_quota.PROCESS_STAGE,',')]#
                    </cfif>
                </td>
                <td>#dateformat(PLAN_DATE,dateformat_style)#</td>
                <td>#dateformat(FINISH_DATE,dateformat_style)#</td>
                <td class="text-right">#TOTAL_QUANTITY#</td>
                <td class="text-right">#Tlformat(TOTAL_PREMIUM_AMOUNT,2)#</td>
                <td class="text-right">#TOTAL_EXTRA_STOCK#</td>
                <td class="text-right">#Tlformat(TOTAL_AMOUNT,2)#</td>
                <td class="text-right">#Tlformat(OTHER_TOTAL_AMOUNT,2)# #OTHER_MONEY#</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>
