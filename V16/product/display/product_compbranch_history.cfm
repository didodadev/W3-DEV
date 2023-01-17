<!---
	FBS 20080703 Urun Subelerinin history kayitlarini goruntulemek icin olusturuldu
	product_id   --> required
	Ornek Link : <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_product_compbranch_history&product_id=#attributes.pid#</cfoutput>','medium','popup_product_compbranch_history');"><img src="/images/history.gif" title="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
--->

<cfquery name="get_history" datasource="#dsn1#">
	SELECT * FROM PRODUCT_COMPANY_BRANCH_HISTORY WHERE PRODUCT_ID = #attributes.product_id# ORDER BY HISTORY_TYPE_ID DESC,OUR_COMPANY_ID
</cfquery>

<cfset branch_id_list = "">
<cfset record_emp_list = "">
<cfif get_history.recordcount>
	<cfquery name="get_company_branch_name" datasource="#dsn#">
		SELECT
			B.BRANCH_ID,
			B.BRANCH_NAME,
			OC.NICK_NAME
		FROM
			OUR_COMPANY OC,
			BRANCH B
		WHERE
			B.COMPANY_ID = OC.COMP_ID AND
			B.BRANCH_ID IN (#valuelist(get_history.branch_id,',')#)
		ORDER BY
			B.BRANCH_ID
	</cfquery>
	<cfset branch_id_list = listsort(listdeleteduplicates(valuelist(get_company_branch_name.branch_id,',')),'numeric','ASC',',')>
	<cfquery name="get_emp_name" datasource="#dsn#">
		SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#valuelist(get_history.record_emp,',')#)
	</cfquery>
	<cfset record_emp_list = listsort(listdeleteduplicates(valuelist(get_emp_name.employee_id,',')),'numeric','ASC',',')>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57473.Tarihçe'></cfsavecontent>
<cf_popup_box title="#message#">
<table width="98%">
    <cfif get_history.recordcount>
        <cfoutput query="get_history" group="history_type_id">
            <cfoutput group="our_company_id">
                <cfset satir_ = 0>
                <tr>
                    <td width="120" class="txtbold">#get_company_branch_name.nick_name[listfind(branch_id_list,branch_id,',')]#</td>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <cfoutput>
                        <cfif satir_ mod 4 eq 0><td>&nbsp;</td></cfif>
                        <cfset satir_ = satir_ + 1>
                        <td width="90"><cfif branch_id neq 0>#get_company_branch_name.branch_name[listfind(branch_id_list,branch_id,',')]#<cfelse><strong><cf_get_lang dictionary_id='60438.Seçili Şube Yok'> !</strong></cfif></td>
                    <cfif satir_ mod 4 eq 0></tr></cfif>
                    </cfoutput>
                    <cfif satir_ mod 4 neq 0></tr></cfif>
                </cfoutput>
            <tr height="30">
                <td colspan="5">
                	<cf_get_lang dictionary_id='58050.Son Güncelleyen'>: #get_emp_name.employee_name[listfind(record_emp_list,record_emp,',')]# #get_emp_name.employee_surname[listfind(record_emp_list,record_emp,',')]# - #Dateformat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#
                </td>
            </tr>
            <tr>
                <td colspan="5"><hr></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr height="20">
            <td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
</cf_popup_box>
