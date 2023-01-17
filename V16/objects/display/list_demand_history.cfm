<cfquery name="GET_HISTORY" datasource="#DSN3#">
	SELECT
		OD.*,
		S.PRODUCT_NAME
	FROM
		ORDER_DEMANDS_HISTORY OD,
		STOCKS S
	WHERE
		S.STOCK_ID = OD.STOCK_ID AND
		OD.DEMAND_ID = #attributes.act_id#
	ORDER BY
		UPDATE_DATE DESC
</cfquery>
<cfif get_history.recordcount>
	<cfset record_list = "">
	<cfset record_cons_list = "">
	<cfset partner_list = ''>
	<cfset consumer_list = ''>
	<cfoutput query="get_history">
		<cfif len(record_con) and not listfind(record_cons_list,record_con)>
			<cfset record_cons_list=listappend(record_cons_list,record_con)>
		</cfif>
		<cfif len(record_emp) and not listfind(record_list,record_emp)>
			<cfset record_list=listappend(record_list,record_emp)>
		</cfif>
		<cfif len(update_emp) and not listfind(record_list,update_emp)>
			<cfset record_list=listappend(record_list,update_emp)>
		</cfif>
		<cfif len(record_par) and not listfind(partner_list,record_par,',')>
			<cfset partner_list = listappend(partner_list,record_par)>
		</cfif>
		<cfif len(record_con) and not listfind(consumer_list,record_con,',')>
			<cfset consumer_list = listappend(consumer_list,record_con)>
		</cfif>
	</cfoutput>
	<cfif len(record_list)>
		<cfset record_list = listsort(record_list,'numeric','ASC',',')>
		<cfquery name="GET_RECORD" datasource="#DSN#">
			 SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_list#) ORDER BY EMPLOYEE_ID
		</cfquery>
		<cfset record_list = listsort(listdeleteduplicates(valuelist(get_record.employee_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(record_cons_list)>
		<cfset record_cons_list = listsort(record_cons_list,'numeric','ASC',',')>
		<cfquery name="GET_RECORD_CONS" datasource="#DSN#">
			 SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#record_cons_list#) ORDER BY CONSUMER_ID
		</cfquery>
		<cfset record_cons_list = listsort(listdeleteduplicates(valuelist(get_record_cons.consumer_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
	<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
	<cfif listlen(partner_list)>
		<cfquery name="GET_PARTNERS" datasource="#DSN#">
			SELECT 
				C.NICKNAME,
				C.MEMBER_CODE,
				CP.COMPANY_PARTNER_NAME,
				CP.COMPANY_PARTNER_SURNAME,
				CP.PARTNER_ID 
			FROM 
				COMPANY_PARTNER CP,
				COMPANY C
			WHERE 
				C.COMPANY_ID = CP.COMPANY_ID AND
				CP.PARTNER_ID IN (#partner_list#)
			ORDER BY
				CP.PARTNER_ID
		</cfquery>
        <cfset partner_list = listsort(listdeleteduplicates(valuelist(get_partners.partner_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif listlen(consumer_list)>
		<cfquery name="GET_CONSUMERS" datasource="#DSN#">
			SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
		</cfquery>
		<cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumers.consumer_id,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<style type="text/css">.wrk_history_body tr td {font-size:11px !important;}</style>
    <!---<table class="wrk_history_body" width="100%">--->
    <cfset temp_ = 0>
        <cfif get_history.recordcount>
            <cfoutput query="get_history">
            <cfset txt = "">
             <cfset temp_ = temp_ +1>
             <cfsavecontent variable="txt"><cfif len(update_date) and update_emp>#DateFormat(update_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)# - #get_record.employee_name[listfind(record_list,update_emp,',')]# #get_record.employee_surname[listfind(record_list,update_emp,',')]#<cfelseif len(record_date) and len(record_emp)>#DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#-#get_record.employee_name[listfind(record_list,record_emp,',')]# #get_record.employee_surname[listfind(record_list,record_emp,',')]#</cfif></cfsavecontent>
         <cf_seperator id="history_#temp_#" header="#txt#" is_closed="1">
        <table id="history_#temp_#" style="display:none;">
                <tr height="22">
                    <td class="txtboldblue" width="25"><cf_get_lang dictionary_id='57657.Ürün'></td>
                    <td colspan="3">#product_name#</td>
                </tr>
                <tr height="22">
                    <td class="txtboldblue"><cf_get_lang dictionary_id='57519.Cari Hesap'></td> 
                    <td colspan="3">
                        <cfif len(record_par)>
                            #get_partners.nickname[listfind(partner_list,record_par,',')]# - #get_partners.company_partner_name[listfind(partner_list,record_par,',')]# #get_partners.company_partner_surname[listfind(partner_list,record_par,',')]#
                        </cfif>
                        <cfif len(record_con)>
                            #get_consumers.consumer_name[listfind(consumer_list,record_con,',')]# #get_consumers.consumer_surname[listfind(consumer_list,record_con,',')]#
                        </cfif>
                    </td>
                </tr>
                <tr height="22">
                    <td class="txtboldblue"><cf_get_lang dictionary_id='57742.Tarih'></td>
                    <td colspan="3">#DateFormat(demand_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,demand_date),timeformat_style)#</td>
                </tr>
                <tr height="22">
                    <td class="txtboldblue"><cf_get_lang dictionary_id='32399.Takip türü'></td> 
                    <td><cfif demand_type eq 1><cf_get_lang dictionary_id ='32404.Fiyat Habercisi'><cfelseif demand_type eq 2><cf_get_lang dictionary_id='32410.Stok Habercisi'><cfelseif demand_type eq 3><cf_get_lang dictionary_id='32411.Ön Sipariş'></cfif></td>
                    <td class="txtboldblue"><cf_get_lang dictionary_id='57493.Aktif'></td>
                    <td><cfif demand_status eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                </tr>
                <tr height="22">
                    <td class="txtboldblue"><cf_get_lang dictionary_id ='57673.Tutar'></td> 
                    <td>#tlformat(price_kdv)#</td>
                    <td class="txtboldblue"><cf_get_lang dictionary_id ='58082.Adet'></td>
                    <td>#demand_amount#</td>
                </tr>
                <tr height="22">
                    <td class="txtboldblue"><cf_get_lang dictionary_id ='57629.Açıklama'></td> 
                    <td colspan="3">#demand_note#</td>
                </tr>
                <tr height="22">
                    <td class="txtboldblue"><cf_get_lang dictionary_id='57899.Kaydeden'></td>
                    <td colspan="3">
                        <cfif len(record_list) and len(update_emp)>
                            <strong>#get_record.employee_name[listfind(record_list,update_emp,',')]# #get_record.employee_surname[listfind(record_list,update_emp,',')]# - #DateFormat(update_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#</strong>
                        <cfelseif len(record_list) and len(record_emp)>
                            <strong>#get_record.employee_name[listfind(record_list,record_emp,',')]# #get_record.employee_surname[listfind(record_list,record_emp,',')]# - #DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</strong>
                        <cfelseif len(record_cons_list) and len(record_con)>
                            <strong>#get_record.employee_name[listfind(record_list,update_emp,',')]# #get_record.employee_surname[listfind(record_list,update_emp,',')]# - #DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</strong>
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td colspan="4"><hr></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr height="20">
                <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            </tr>
        </cfif>
    </table>







