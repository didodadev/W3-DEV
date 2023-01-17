<cfsetting showdebugoutput="no">
<cfinclude template="get_purchases.cfm">
<cf_flat_list>
	<cfif purchases.recordcount>
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default=20>
        <cfparam name="attributes.totalrecords" default="#purchases.recordcount#">
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfset company_list = "">
        <cfset consumer_list = "">
        <cfoutput query="purchases" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(company_id) and not listfind(company_list,company_id)>
                <cfset company_list=listappend(company_list,company_id)>
            </cfif>
            <cfif len(consumer_id) and not listfind(consumer_list,consumer_id)>
                <cfset consumer_list=listappend(consumer_list,consumer_id)>
            </cfif>
        </cfoutput>
        <cfif len(company_list)>
            <cfset company_list = listsort(company_list,"numeric","ASC",',')>
            <cfquery name="get_company_name" datasource="#dsn#">
                SELECT COMPANY_ID, NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
            </cfquery>
            <cfset company_list = listsort(listdeleteduplicates(valuelist(get_company_name.company_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(consumer_list)>
            <cfset consumer_list = listsort(consumer_list,"numeric","ASC",',')>
            <cfquery name="get_consumer_name" datasource="#dsn#">
                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME, COMPANY FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.consumer_id,',')),'numeric','ASC',',')>
        </cfif>
       <thead>
            <tr>
				<th><cf_get_lang_main no="225.seri no"></th>
				<th><cf_get_lang_main no="107.cari hesap"></th>	
				<th style="text-align:right; width:180px;"><cf_get_lang_main no="230.net toplam"></th>
            </tr>
       </thead>
       <tbody>
			<cfoutput query="purchases" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="100">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&ship_id=#ship_id#','list');" class="tableyazi">#ship_number#</a>
					</td>
					<td>
						<cfif len(company_id) and company_id neq 0>
							<a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_company_name.company_id[listfind(company_list,company_id,',')]#','medium');">#get_company_name.nickname[listfind(company_list,company_id,',')]#</a>
						<cfelseif len(consumer_id)>
							<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_consumer_name.consumer_id[listfind(consumer_list,consumer_id,',')]#','medium');" class="tableyazi">#get_consumer_name.consumer_name[listfind(consumer_list,consumer_id,',')]##get_consumer_name.consumer_surname[listfind(consumer_list,consumer_id,',')]#</a>
						</cfif>
					</td>                
					<td width="180" style="text-align:right;">#TLFormat(nettotal)# #session.ep.money#</td>
				</tr>
			</cfoutput>
       </tbody>
    <cfelse>
		<tbody>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody>
    </cfif>
</cf_flat_list>
