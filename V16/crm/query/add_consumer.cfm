<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.CONSUMER_NAME=replacelist(form.CONSUMER_NAME,list,list2)>
<cfset attributes.CONSUMER_SURNAME=replacelist(form.CONSUMER_SURNAME,list,list2)>

<cfset a = "">
<cfloop from="1" to="#listlen(attributes.CONSUMER_NAME,' ')#" index="i">
	<cfif len(listgetat(attributes.CONSUMER_NAME,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.CONSUMER_NAME,i,' '),1)) & lcase(right(listgetat(attributes.CONSUMER_NAME,i,' '),len(listgetat(attributes.CONSUMER_NAME,i,' '))-1))>
	<cfelse>
		<cfset b = ucase(left(listgetat(attributes.CONSUMER_NAME,i,' '),1))>
	</cfif>
	<cfset a = '#a# #b#'>	
</cfloop>
<cfset attributes.CONSUMER_NAME = trim(a)>

<cfset a = "">
<cfloop from="1" to="#listlen(attributes.CONSUMER_SURNAME,' ')#" index="i">
	<cfif len(listgetat(attributes.CONSUMER_SURNAME,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.CONSUMER_SURNAME,i,' '),1)) & lcase(right(listgetat(attributes.CONSUMER_SURNAME,i,' '),len(listgetat(attributes.CONSUMER_SURNAME,i,' '))-1))>
	<cfelse>
		<cfset b = ucase(left(listgetat(attributes.CONSUMER_SURNAME,i,' '),1))>
	</cfif>
	<cfset a = '#a# #b#'>	
</cfloop>
<cfset attributes.CONSUMER_SURNAME = trim(a)>


<cfif len(FORM.CONSUMER_PASSWORD)>
	<CF_CRYPTEDPASSWORD	PASSWORD='#FORM.CONSUMER_PASSWORD#' OUTPUT='PASS' MOD=1>
</cfif>


<cfif len(form.CONSUMER_USERNAME) and len(FORM.CONSUMER_PASSWORD)>
	<cfquery name="CHECK_CONSUMER" datasource="#DSN#">
		SELECT 
			CONSUMER_USERNAME 
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_USERNAME = '#form.CONSUMER_USERNAME#' AND CONSUMER_PASSWORD = '#PASS#'
	</cfquery>
	<cfif check_consumer.recordcount>
		<script type="text/javascript">
		alert("<cf_get_lang no='31.Girdiğiniz Kullanıcı Adı ve Şifre Kullanılıyor Lütfen Geri Dönüp Kontrol Ediniz !'>");
		window.history.go(-1);
		</script>	
	<CFABORT>
</cfif>
</cfif>
<cfif len(form.picture)>
	<CFTRY>
		<cfset file_name = createUUID()>
		<CFFILE action="UPLOAD" 
				destination="#upload_folder#member#dir_seperator#consumer#dir_seperator#" 
				filefield="picture" 
				nameconflict="MAKEUNIQUE" accept="image/*"> 
		<CFFILE 
			action="rename" 
			source="#upload_folder#member#dir_seperator#consumer#dir_seperator##cffile.serverfile#" 
			destination="#upload_folder#member#dir_seperator#consumer#dir_seperator##file_name#.#cffile.serverfileext#">
		<CFCATCH>
			<font face="Verdana" size="1" color="#ff0000"><STRONG>Bu dosya adı ile bir dosya sistemede mevcut lütfen kontrol ediniz..</STRONG></font><br/>		
			<CFABORT>
		</CFCATCH>
	</CFTRY>	
<cfscript>
	form.picture = file_name &"." & cffile.serverfileext;
</cfscript>	
<cfelse>
</cfif>
<cf_date tarih = "form.birthday">
<CFLOCK name="#createUUID()#" timeout="20">
	<CFTRANSACTION>		
		<cfquery name="ADD_CONSUMER" datasource="#DSN#">
		INSERT 
			INTO CONSUMER (
							  CONSUMER_CAT_ID,
							  <cfif isdefined("attributes.BIRTHDATE") and len(attributes.BIRTHDATE)>
							  BIRTHDATE,
							  </cfif>
							  <cfif isdefined("attributes.BIRTHPLACE") and len(attributes.BIRTHPLACE)>
							  BIRTHPLACE,
							  </cfif>
							  <cfif isdefined("attributes.CHILD") and len(attributes.CHILD)>
							  CHILD,
							  </cfif>
							  <cfif isdefined("attributes.COMPANY") and len(attributes.COMPANY)>
							  COMPANY,
							  </cfif>
							  <cfif isdefined("attributes.COMPANY_SIZE_CAT_ID") and #attributes.COMPANY_SIZE_CAT_ID# neq 0>
							  COMPANY_SIZE_CAT_ID,
							  </cfif>
							  <cfif isdefined("attributes.CONSUMER_EMAIL") and len(attributes.CONSUMER_EMAIL)>
							  CONSUMER_EMAIL,
							  </cfif>
							  <cfif isdefined("attributes.CONSUMER_FAX") and len(attributes.CONSUMER_FAX)>
							  CONSUMER_FAX,
							  </cfif>
							  <cfif isdefined("attributes.CONSUMER_FAXCODE")and len(attributes.CONSUMER_FAXCODE)>
							  CONSUMER_FAXCODE,
							  </cfif>
							  <cfif isdefined("attributes.CONSUMER_HOMETEL")and len(attributes.CONSUMER_HOMETEL)>
							  CONSUMER_HOMETEL,
							  </cfif>
							  <cfif isdefined("attributes.CONSUMER_HOMETELCODE")and len(attributes.CONSUMER_HOMETELCODE)>
							  CONSUMER_HOMETELCODE,
							  </cfif>
							  CONSUMER_NAME,
							  <cfif len(FORM.CONSUMER_PASSWORD)>CONSUMER_PASSWORD,</cfif>
							  CONSUMER_SURNAME,
							  <cfif isdefined("attributes.CONSUMER_TEL_EXT") and len(attributes.CONSUMER_TEL_EXT)>
							  CONSUMER_TEL_EXT,
							  </cfif>
							  <cfif len(form.CONSUMER_USERNAME)>CONSUMER_USERNAME,</cfif>
							  <cfif isdefined("attributes.CONSUMER_WORKTEL") and len(attributes.CONSUMER_WORKTEL)>
							  CONSUMER_WORKTEL,
							  </cfif>
							  <cfif isdefined("attributes.CONSUMER_WORKTELCODE") and len(attributes.CONSUMER_WORKTELCODE)>
							  CONSUMER_WORKTELCODE,
							  </cfif>
							  <cfif isdefined("attributes.COUNTY") and len(attributes.COUNTY)>
							  COUNTY,
							  </cfif>
							  <cfif isdefined("attributes.EDUCATION") and len(attributes.EDUCATION)>
							  EDUCATION,
							  </cfif>
							  <cfif isdefined("attributes.HOMEADDRESS") and len(attributes.HOMEADDRESS)>
							  HOMEADDRESS,
							  </cfif>
							  <cfif isdefined("attributes.HOMECITY") and len(attributes.HOMECITY)>
							  HOMECITY,
							  </cfif>
							  <cfif isdefined("attributes.HOMECOUNTY") and len(attributes.HOMECOUNTY)>
							  HOMECOUNTY,
							  </cfif>
							  <cfif isdefined("attributes.HOMEPAGE") and len(attributes.HOMEPAGE)>
							  HOMEPAGE,
							  </cfif>
							  <cfif isdefined("attributes.HOMEPOSTCODE") and len(attributes.HOMEPOSTCODE)>
							  HOMEPOSTCODE,
							  </cfif>
							  <cfif isdefined("attributes.IDENTYCARD_CAT") and #attributes.IDENTYCARD_CAT# neq 0>
							  IDENTYCARD_CAT,
							  </cfif>
							  <cfif isdefined("attributes.IDENTYCARD_NO") and len(attributes.IDENTYCARD_NO)>
							  IDENTYCARD_NO,
							  </cfif>
							  <cfif isdefined("attributes.IM") and len(attributes.IM)>
							  IM,
							  </cfif>
							  <cfif isdefined("attributes.IMCAT_ID") and #attributes.IMCAT_ID# neq 0>
							  IMCAT_ID,
							  </cfif>
							  ISPOTANTIAL,
							  <cfif len(attributes.department)>DEPARTMENT,</cfif>
							  TITLE,
							  <cfif len(attributes.mission)>MISSION,</cfif>
							  <cfif isdefined("attributes.MOBILCAT_ID") AND #attributes.MOBILCAT_ID# NEQ 0>
							  MOBIL_CODE,
							  </cfif>
							  <cfif isdefined("attributes.MOBILTEL") AND len(attributes.MOBILTEL)>
							  MOBILTEL,
							  </cfif>
							  <cfif isdefined("attributes.PICTURE") AND len(attributes.PICTURE)>
							  PICTURE,
							  PICTURE_SERVER_ID,
							  </cfif>
							  <cfif isdefined("attributes.SECTOR_CAT_ID") and #attributes.SECTOR_CAT_ID# neq 0>
							  SECTOR_CAT_ID,
							  </cfif>
							  SEX,
							  <cfif isdefined("attributes.TAX_ADRESS") AND len(attributes.TAX_ADRESS)>
							  TAX_ADRESS,
							  </cfif>
							  <cfif isdefined("attributes.TAX_NO") AND len(attributes.TAX_NO)>
							  TAX_NO,
							  </cfif>
							  <cfif isdefined("attributes.WORKADDRESS") AND len(attributes.WORKADDRESS)>
							  WORKADDRESS,
							  </cfif>
							  <cfif isdefined("attributes.WORKCITY") AND len(attributes.WORKCITY)>
							  WORKCITY,
							  </cfif>
							  <cfif isdefined("attributes.WORKCOUNTY") AND len(attributes.WORKCOUNTY)>
							  WORKCOUNTY,
							  </cfif>
							  <cfif isdefined("attributes.WORKPOSTCODE") AND len(attributes.WORKPOSTCODE)>
							  WORKPOSTCODE,
							  </cfif>							  
							  IS_CARI,
							  MARRIED,
							  RECORD_DATE,
							  SALES_COUNTY,
							  POS_CODE,
							  HIERARCHY_ID,
							  RECORD_MEMBER,
							  OZEL_KOD,
							  TC_IDENTY_NO,
							  SOCIAL_SOCIETY_ID,
							  SOCIAL_SECURITY_NO
							  )
					VALUES 	 
							(
							  #FORM.CONSUMER_CAT_ID#,
							  <cfif isdefined("attributes.BIRTHDATE") and len(attributes.BIRTHDATE)>#FORM.BIRTHDATE#,</cfif>
							  <cfif isdefined("attributes.BIRTHPLACE") and len(attributes.BIRTHPLACE)>'#FORM.BIRTHPLACE#',</cfif>
							  <cfif isdefined("attributes.CHILD") and len(attributes.CHILD)>'#FORM.CHILD#',</cfif>
							  <cfif isdefined("attributes.COMPANY") and len(attributes.COMPANY)>'#FORM.COMPANY#',</cfif>
							  <cfif isdefined("attributes.COMPANY_SIZE_CAT_ID") and #attributes.COMPANY_SIZE_CAT_ID# neq 0>#FORM.COMPANY_SIZE_CAT_ID#,
							   </cfif>
							 <cfif isdefined("attributes.CONSUMER_EMAIL") and len(attributes.CONSUMER_EMAIL)>
							  '#FORM.CONSUMER_EMAIL#',
							   </cfif>
							  <cfif isdefined("attributes.CONSUMER_FAX") and len(attributes.CONSUMER_FAX)>
							  '#FORM.CONSUMER_FAX#',
							   </cfif>
							  <cfif isdefined("attributes.CONSUMER_FAXCODE")and len(attributes.CONSUMER_FAXCODE)>
							  '#FORM.CONSUMER_FAXCODE#',
							   </cfif>
							  <cfif isdefined("attributes.CONSUMER_HOMETEL")and len(attributes.CONSUMER_HOMETEL)>
							  '#FORM.CONSUMER_HOMETEL#',
							   </cfif>
							   <cfif isdefined("attributes.CONSUMER_HOMETELCODE")and len(attributes.CONSUMER_HOMETELCODE)>
							  '#FORM.CONSUMER_HOMETELCODE#',
							   </cfif>
							  '#attributes.CONSUMER_NAME#',
							  <cfif len(FORM.CONSUMER_PASSWORD)>'#pass#',</cfif>
							  '#attributes.CONSUMER_SURNAME#',
							  <cfif isdefined("attributes.CONSUMER_TEL_EXT") and len(attributes.CONSUMER_TEL_EXT)>
							  '#FORM.CONSUMER_TEL_EXT#',
							   </cfif>
							  <cfif len(form.CONSUMER_USERNAME)>'#form.CONSUMER_USERNAME#',</cfif>
							  <cfif isdefined("attributes.CONSUMER_WORKTEL") and len(attributes.CONSUMER_WORKTEL)>
							  '#FORM.CONSUMER_WORKTEL#',
							   </cfif>
							  <cfif isdefined("attributes.CONSUMER_WORKTELCODE") and len(attributes.CONSUMER_WORKTELCODE)>
							  '#FORM.CONSUMER_WORKTELCODE#',
							   </cfif>
							  <cfif isdefined("attributes.COUNTY") and len(attributes.COUNTY)>
							  '#FORM.COUNTY#',
							   </cfif>
							  <cfif isdefined("attributes.EDUCATION") and len(attributes.EDUCATION)>
							  '#FORM.EDUCATION#',
							   </cfif>
							  <cfif isdefined("attributes.HOMEADDRESS") and len(attributes.HOMEADDRESS)>
							  '#FORM.HOMEADDRESS#',
							   </cfif>
							  <cfif isdefined("attributes.HOMECITY") and len(attributes.HOMECITY)>
							  '#FORM.HOMECITY#',
							   </cfif>
							  <cfif isdefined("attributes.HOMECOUNTY") and len(attributes.HOMECOUNTY)>
							  '#FORM.HOMECOUNTY#',
							   </cfif>
							  <cfif isdefined("attributes.HOMEPAGE") and len(attributes.HOMEPAGE)>
							  '#FORM.HOMEPAGE#',
							   </cfif>
							  <cfif isdefined("attributes.HOMEPOSTCODE") and len(attributes.HOMEPOSTCODE)>
							  '#FORM.HOMEPOSTCODE#',
							   </cfif>
							  <cfif isdefined("attributes.IDENTYCARD_CAT") and #attributes.IDENTYCARD_CAT# neq 0>
							  '#FORM.IDENTYCARD_CAT#',
							   </cfif>
							  <cfif isdefined("attributes.IDENTYCARD_NO") and len(attributes.IDENTYCARD_NO)>
							  '#FORM.IDENTYCARD_NO#',
							   </cfif>
							  <cfif isdefined("attributes.IM") and len(attributes.IM)>
							  '#FORM.IM#',
							   </cfif>
							  <cfif isdefined("attributes.IMCAT_ID") and #attributes.IMCAT_ID# neq 0>
							  #FORM.IMCAT_ID#,
							   </cfif>
							  <cfif isDefined("FORM.ISPOTENTIAL")>
							  1,
							  <cfelse>
							  0,
							  </cfif>
							 <cfif len(attributes.department)>#FORM.DEPARTMENT#,</cfif>
							 '#FORM.TITLE#',
							 <cfif len(attributes.mission)>#FORM.mission#,</cfif>
							  <cfif isdefined("attributes.MOBILCAT_ID") AND #attributes.MOBILCAT_ID# NEQ 0>
							  '#FORM.MOBILCAT_ID#',
							   </cfif>
							 <cfif isdefined("attributes.MOBILTEL") AND len(attributes.MOBILTEL)>
							  '#FORM.MOBILTEL#',
							   </cfif>
							  <cfif isdefined("attributes.PICTURE") AND len(attributes.PICTURE)>
							  '#FORM.PICTURE#',
							  #fusebox.server_machine#, 
							  </cfif>
							   <cfif isdefined("attributes.SECTOR_CAT_ID") and #attributes.SECTOR_CAT_ID# neq 0>
							  #FORM.SECTOR_CAT_ID#,
							   </cfif>
							  <cfif isDefined("FORM.SEX")>
							   1,
							  <cfelse>
							  0,
							  </cfif>
							  <cfif isdefined("attributes.TAX_ADRESS") AND len(attributes.TAX_ADRESS)>
							  '#FORM.TAX_ADRESS#',
							   </cfif>
							  <cfif isdefined("attributes.TAX_NO") AND len(attributes.TAX_NO)>
							  '#FORM.TAX_NO#',
							   </cfif>
							  <cfif isdefined("attributes.WORKADDRESS") AND len(attributes.WORKADDRESS)>
							  '#FORM.WORKADDRESS#',
							   </cfif>
							  <cfif isdefined("attributes.WORKCITY") AND len(attributes.WORKCITY)>
							  '#FORM.WORKCITY#',
							   </cfif>
							  <cfif isdefined("attributes.WORKCOUNTY") AND len(attributes.WORKCOUNTY)>
							  '#FORM.WORKCOUNTY#',
							   </cfif>
							   <cfif isdefined("attributes.WORKPOSTCODE") AND len(attributes.WORKPOSTCODE)>
							  '#FORM.WORKPOSTCODE#',
							   </cfif>
							  <cfif isDefined("FORM.IS_CARI")>
							  1,
							  <cfelse>
							  0,
							  </cfif>
							  <cfif isDefined("attributes.MARRIED")>
							  1,
							  <cfelse>
							  0,
							  </cfif>
							  #NOW()#,
							  <cfif LEN(attributes.SALES_COUNTY)>#attributes.SALES_COUNTY#,<cfelse>NULL,</cfif>
							  <cfif LEN(attributes.POS_CODE)>#attributes.POS_CODE#,<cfelse>NULL,</cfif>
							  <cfif LEN(attributes.HIERARCHY_ID)>#attributes.HIERARCHY_ID#<cfelse>NULL</cfif>,						  
							  #session.ep.userid#,
							  '#attributes.OZEL_KOD#',
							  '#attributes.TC_IDENTY_NO#',
							  <cfif len(attributes.SOCIAL_SOCIETY_ID)>#SOCIAL_SOCIETY_ID#,<cfelse>NULL,</cfif>
							  '#SOCIAL_SECURITY_NO#'
							   )
		</cfquery>
<cfquery name="GET_MAX_CONS" datasource="#DSN#">
	SELECT 
		MAX(CONSUMER_ID) AS MAX_CONS 
	FROM 
		CONSUMER
</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
	UPDATE 
		CONSUMER 
	SET 
		MEMBER_CODE = 'C#GET_MAX_CONS.MAX_CONS#'
	WHERE 
		CONSUMER_ID = #GET_MAX_CONS.MAX_CONS#
</cfquery>
<cfif isdefined("url.service") and url.service eq 1>
	<cflocation url="#request.self#?fuseaction=service.add_service2&consumer_id=#get_max_cons.max_cons#" addtoken="no">
</cfif>
<!---call center dan --->
<cfif isdefined("url.cc")> 
	<cflocation url="#request.self#?fuseaction=call.detail_consumer&cid=#get_max_cons.max_cons#" addtoken="No">
</cfif>
<!--- siparişten geliyorsa --->
<cfif isdefined("url.add_order")>
	<cfif add_order eq 1>
		<cflocation url="#request.self#?fuseaction=sales.form_add_order_simple&consumer_id=#get_max_cons.max_cons#" addtoken="No">
	<cfelseif add_order eq 2>
		<cflocation url="#request.self#?fuseaction=sales.form_add_order_product&consumer_id=#get_max_cons.max_cons#" addtoken="No">
	</cfif>
</cfif>
<!--- sales tekliften geliyorsa --->
<cfif isdefined("url.add_offer") and (add_offer eq 1)>
	<cflocation url="#request.self#?fuseaction=sales.form_add_consumer_offer&consumer_id=#get_max_cons.max_cons#" addtoken="No">
</cfif>
<!--- sales fırsattan geliyorsa --->
<cfif isdefined("url.add_opportunity") and (add_opportunity eq 1)>
	<cflocation url="#request.self#?fuseaction=sales.form_opportunity&consumer_id=#get_max_cons.max_cons#" addtoken="No">
</cfif>
<cfif (not isDefined("url.add_offer")) and (not isDefined("url.add_order")) and (not isDefined("url.service")) and (not isDefined("url.add_opportunity"))>
	<cflocation url="#request.self#?fuseaction=crm.detail_consumer&cid=#get_max_cons.max_cons#" addtoken="No">
</cfif>

<cfif (service eq 0) and (add_offer eq 0) and (add_order eq 0) and (add_opportunity eq 0)>
	<cfquery name="GET_POT" datasource="#DSN#">
		SELECT
			ISPOTANTIAL
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID=#GET_MAX_CONS.MAX_CONS#
	</cfquery>
	
	<cfif GET_POT.ISPOTANTIAL EQ 1>
		<cflocation url="#request.self#?fuseaction=crm.welcome" addtoken="No">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=crm.consumer_list" addtoken="No">
	</cfif>
</cfif>

