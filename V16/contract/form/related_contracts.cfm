<cfquery name="GET_RELATED_CONTRACT" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		RELATED_CONTRACT
	WHERE 
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		<cfelse>
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
		</cfif>
		<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>	
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfif>	
</cfquery>
<cfset acik_toplam=0>
<cfset vadeli_toplam=0>
<cfset company_list = ''>
<cfset consumer_list = ''>
<cf_grid_list>
    <thead>
        <tr> 
            <th width="20"><cfoutput><a href="#request.self#?fuseaction=contract.list_related_contracts&event=add&is_popup=1<cfif isdefined("attributes.company_id") and len(attributes.company_id)>&company_id=#attributes.company_id#<cfelse>&consumer_id=#attributes.consumer_id#</cfif>&our_comp_id=#session.ep.company_id#" target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput></th>
            <th width="300"><cf_get_lang dictionary_id='29522.Sözleşme'></th>
            <th width="300"><cf_get_lang dictionary_id='50706.Taraflar'></th>
            <th width="200"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></th>
            <th width="300"><cf_get_lang dictionary_id='51011.İlişkili Projeler'></th>
        </tr>
    </thead>
    <tbody>
        <cfif GET_RELATED_CONTRACT.recordcount>
            <cfoutput query="GET_RELATED_CONTRACT">
                <cfloop from="1" to="#listlen(company)#" index="sayac">
                    <cfif len(ListGetAt(COMPANY,sayac,',')) and not listfind(company_list,ListGetAt(COMPANY,sayac,','))>
                        <cfset company_list = ListAppend(company_list,ListGetAt(COMPANY,sayac,','))>
                    </cfif>
                </cfloop>
                <cfloop from="1" to="#listlen(consumers)#" index="sayac">
                    <cfif len(ListGetAt(CONSUMERS,sayac,',')) and not listfind(consumer_list,ListGetAt(CONSUMERS,sayac,','))>
                        <cfset consumer_list = ListAppend(consumer_list,ListGetAt(CONSUMERS,sayac,','))>
                    </cfif>	
                </cfloop>
                <cfif len(company_list)>
                    <cfset company_list=listsort(company_list,"numeric","ASC",",")>
                    <cfquery name="GET_PARTNER" datasource="#dsn#">
                        SELECT FULLNAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
                    </cfquery>
                    <cfset company_list = listsort(listdeleteduplicates(valuelist(GET_PARTNER.COMPANY_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(consumer_list)>
                    <cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
                    <cfquery name="get_consumer" datasource="#dsn#">
                        SELECT CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
                    </cfquery>
                    <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
                </cfif>
            </cfoutput>
            <cfset deger_ = 0>
            <cfoutput query="GET_RELATED_CONTRACT">  
                <tr>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=contract.list_related_contracts&event=upd<cfif isdefined("attributes.company_id") and len(attributes.company_id)>&company_id=#attributes.company_id#<cfelse>&consumer_id=#attributes.consumer_id#</cfif>&contract_id=#CONTRACT_ID#','wwide');"><i class="fa fa-pencil" title="Güncelle"></i></a></td>
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=contract.popup_dsp_member_contracts&contract_id=#contract_id#','wide2');">#Left(CONTRACT_HEAD,75)#</a></td>
                <td>
                    <cfloop from="1" to="#listlen(COMPANY)#" index="sayac">
                        - #GET_PARTNER.FULLNAME[listfind(company_list,ListGetAt(COMPANY,sayac,','),',')]#<br/>
                    </cfloop>
                    <cfloop from="1" to="#listlen(consumers)#" index="sayac">
                        - #get_consumer.FULLNAME[listfind(consumer_list,ListGetAt(consumers,sayac,','),',')]#<br/>
                    </cfloop>
                </td>
                <td>#DateFormat(STARTDATE,dateformat_style)# - #DateFormat(FINISHDATE,dateformat_style)#</td>
                <td><cfloop from="1" to="#listlen(PROJECT_ID)#" index="sayac2">
                        #GET_PROJECT_NAME(ListGetAt(PROJECT_ID,sayac2,','))#<br/>
                    </cfloop>
                </td>
                </tr>
            </cfoutput> 		
        <cfelse>
            <tr>
                <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>
