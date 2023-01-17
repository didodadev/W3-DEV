<!---TolgaS 20080722
Autocomplate için yapıldı aranan kritere uygun tüm aktif üyeleri getirir
select_list ifadesi 1 ise kurumsal,2 ise bireysel,3 ise calisanlar listelenir
is_store_module subeden listelenecekse 1 olarak gonderilir
is_potantial_1 değeri 0 ise kurumsal uye caridir 1 ise potansiyeldir bos gelirse tum kurumsal uyeler listelenir
is_potantial_2 değeri 0 ise bireysel uye caridir 1 ise potansiyeldir bos gelirse tum bireysel uyeler listelenir
is_buyer_seller uyelerin alıcı mı satici mı oldugunu belirtir
member_status uyelerin durumunu belirtir 0 ise pasif,1 ise aktif
is_company_info partnerlar gelsin mi gelmesin mi
1,0,0
--->
<cffunction name="get_addressbook" access="public" returnType="query" output="no">
	<cfargument name="keyword" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">

	<cfquery name="get_addressbook_" datasource="#dsn#">
		SELECT 
			AB_EMAIL,
			CASE
				WHEN CONSUMER_ID<>'' THEN 'con-' + CONVERT(varchar, CONSUMER_ID) 	
				WHEN PARTNER_ID<>''  THEN 'par-' + CONVERT(varchar, PARTNER_ID) 
				WHEN EMPLOYEE_ID<>'' THEN 'emp-' + CONVERT(varchar, EMPLOYEE_ID) 
				ELSE 'adr-' + CONVERT(varchar, AB_ID) 
			END AS ID_KEY,
			AB_NAME + ' ' +	AB_SURNAME+ '  ' + AB_EMAIL AS NAME_SURNAME		
		FROM 
			ADDRESSBOOK 
		WHERE 
			(
				AB_NAME +' '+ AB_SURNAME LIKE '<cfif len(keyword) gt 2>%</cfif>#keyword#%' OR
				AB_EMAIL LIKE '<cfif len(keyword) gt 2>%</cfif>#keyword#%' OR
				AB_COMPANY LIKE '<cfif len(keyword) gt 2>%</cfif>#keyword#%'
			) 
			AND AB_EMAIL <> '' 
			AND IS_ACTIVE = 1
		ORDER 
			BY AB_NAME
	</cfquery>
	<cfreturn get_addressbook_>
</cffunction>
