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
<cfif (len(FORM.CONSUMER_USERNAME)) and (len(FORM.CONSUMER_PASSWORD))>
<cfquery name="GET_CONS_NAME" datasource="#dsn#">
	SELECT 
		CONSUMER_ID, 
		CONSUMER_USERNAME 
	FROM 
		CONSUMER 
	WHERE 
		CONSUMER_USERNAME = '#FORM.CONSUMER_USERNAME#' 
	AND 
		CONSUMER_PASSWORD ='#PASS#' 
	AND 
		CONSUMER_ID <> #FORM.CONSUMER_ID# 
</cfquery>
<cfif get_cons_name.recordcount>
	<script type="text/javascript">
	alert("<cf_get_lang no='31.Girdiğiniz Kullanıcı Adı ve Şifre Kullanılıyor Lütfen Geri Dönüp Kontrol Ediniz'>");
	window.history.go(-1);
	</script>	
	<cfabort>
</cfif> 
</cfif> 
<cfif isdefined("form.del_photo")>
	<CFLOCK name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="GET_DET" datasource="#dsn#">
			SELECT 
				PICTURE, 
				PICTURE_SERVER_ID,
				CONSUMER_USERNAME 
			FROM 
				CONSUMER 
			WHERE 
				CONSUMER_ID = #FORM.CONSUMER_ID#
			</cfquery>
			<cfquery name="UPD_PHOTO" datasource="#dsn#">
			UPDATE 
				CONSUMER 
			SET 
				PICTURE = '',
				PICTURE_SERVER_ID = NULL
			WHERE 
				CONSUMER_ID = #FORM.CONSUMER_ID#
			</cfquery>
		</cftransaction>
	</CFLOCK>
	
	 <cfif len(get_det.picture)>
			<cfx_WorkcubeImage NAME="image"                         
			                   ACTION="rotate"
			                   SRC="#upload_folder#temp#dir_seperator#temp1.jpg" 
							   DST="#upload_folder#temp#dir_seperator#temp1.jpg" 
							   PARAMETERS="0">	    
		<!--- <cffile action="DELETE" file="#upload_folder#member#dir_seperator#consumer#dir_seperator##GET_DET.PICTURE#"> --->
		<cf_del_server_file output_file="member/consumer/#GET_DET.PICTURE#" output_server="#GET_DET.PICTURE_SERVER_ID#">
	</cfif> 
</cfif>


<cfif isdefined("form.picture") and len(form.picture)>
			<cfset file_name = createUUID()>
			<cffile action="UPLOAD" 					 
					nameconflict="MAKEUNIQUE" 
					destination="#upload_folder#member#dir_seperator#consumer#dir_seperator#"
					filefield="picture" accept="image/*">
			<cffile action="rename" source="#upload_folder#member#dir_seperator#consumer#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator#consumer#dir_seperator##file_name#.#cffile.serverfileext#">
				<!---Script dosyalarını engelle  02092010 ND --->
				<cfset assetTypeName = listlast(cffile.serverfile,'.')>
				<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
				<cfif listfind(blackList,assetTypeName,',')>
					<cffile action="delete" file="#upload_folder#member#dir_seperator#consumer#dir_seperator##file_name#.#cffile.serverfileext#">
					<script type="text/javascript">
						alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
						history.back();
					</script>
					<cfabort>
				</cfif>
			<cfset cffile.serverfile = "#file_name#.#cffile.serverfileext#">
			<cfset path = "#upload_folder#member#dir_seperator##CFFILE.ServerFile#">
			<cfif ( findnocase("gif","#path#",1) neq 0) and (session.resim eq 1)>  			
	<cfx_WorkcubeImage NAME="image"
					   ACTION="rotate"
					   SRC="#path#"
					   DST="#path#"
					   PARAMETERS="0">
		<cfx_WorkcubeImage NAME="image"                         
						   ACTION="rotate"
						   SRC="#upload_folder#temp#dir_seperator#temp1.jpg" 
						   DST="#upload_folder#temp#dir_seperator#temp1.jpg" 
						   PARAMETERS="0">
							<cfset session.resim = 2>
							<cfscript>
							cffile.serverFileExt = "jpg";
							</cfscript>	
							</cfif>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="UPD_PHOTO" datasource="#dsn#">
				UPDATE 
					CONSUMER 
				SET 
					PICTURE = '#CFFILE.SERVERFILENAME#.#CFFILE.SERVERFILEEXT#',
					PICTURE_SERVER_ID = #fusebox.server_machine#
				WHERE 
					CONSUMER_ID = #FORM.CONSUMER_ID#
			</cfquery>
		</cftransaction>
	</cflock>	
</cfif>
<cfscript>
	if (form.consumer_password contains "***")
	{
		structdelete(form,consumer_password);
	}
	if (isdefined("form.del_photo"))
	{
		structdelete(form,"del_photo");
	}
	
	if (isdefined("form.picture"))
		structdelete(form,"picture");
	
</cfscript>
<cf_date tarih = FORM.BIRTHDATE>
<cfquery name="UPD_CONSUMER" datasource="#dsn#">
		UPDATE CONSUMER 
		SET
		
		TAX_OFFICE = '#attributes.TAX_OFFICE#',
		CONSUMER_CAT_ID=#attributes.CONSUMER_CAT_ID#,
		<cfif isdefined("attributes.BIRTHDATE") and len(attributes.BIRTHDATE)>BIRTHDATE = #FORM.BIRTHDATE#,<cfelse>BIRTHDATE = NULL,</cfif>
		BIRTHPLACE='#attributes.BIRTHPLACE#',
		CHILD='#attributes.CHILD#',
		COMPANY='#attributes.COMPANY#',
		<cfif isdefined("attributes.COMPANY_SIZE_CAT_ID") and (attributes.COMPANY_SIZE_CAT_ID neq 0)>COMPANY_SIZE_CAT_ID=#attributes.COMPANY_SIZE_CAT_ID#,</cfif>
		CONSUMER_EMAIL='#attributes.CONSUMER_EMAIL#',
		CONSUMER_FAX='#attributes.CONSUMER_FAX#',
		<cfif isdefined("attributes.married")>MARRIED=1,<cfelse>MARRIED=0,</cfif>
		CONSUMER_FAXCODE='#attributes.CONSUMER_FAXCODE#',
		<cfif isdefined("attributes.CONSUMER_STATUS")>CONSUMER_STATUS=1,<cfelse>CONSUMER_STATUS=0,</cfif>
		CONSUMER_HOMETEL='#attributes.CONSUMER_HOMETEL#',
		CONSUMER_HOMETELCODE='#attributes.CONSUMER_HOMETELCODE#',
		CONSUMER_NAME='#attributes.CONSUMER_NAME#',
		<cfif len(FORM.CONSUMER_PASSWORD)>CONSUMER_PASSWORD='#PASS#',</cfif>
		CONSUMER_SURNAME='#attributes.CONSUMER_SURNAME#',
		CONSUMER_TEL_EXT='#attributes.CONSUMER_TEL_EXT#',
		<cfif len(attributes.CONSUMER_USERNAME)>CONSUMER_USERNAME='#attributes.CONSUMER_USERNAME#',</cfif>
		CONSUMER_WORKTEL='#attributes.CONSUMER_WORKTEL#',
		CONSUMER_WORKTELCODE='#attributes.CONSUMER_WORKTELCODE#',
		COUNTY='#attributes.COUNTY#',
		EDUCATION='#attributes.EDUCATION#',
		HOMEADDRESS='#attributes.HOMEADDRESS#',
		HOMECITY='#attributes.HOMECITY#',
		HOMECOUNTY='#attributes.HOMECOUNTY#',
		HOMEPAGE='#attributes.HOMEPAGE#',
		HOMEPOSTCODE='#attributes.HOMEPOSTCODE#',
		IDENTYCARD_CAT='#attributes.IDENTYCARD_CAT#',
		IDENTYCARD_NO='#attributes.IDENTYCARD_NO#',
		TC_IDENTY_NO='#attributes.TC_IDENTY_NO#',
		IM='#attributes.IM#',
		<cfif isdefined("attributes.IMCAT_ID") and attributes.IMCAT_ID neq 0>IMCAT_ID=#attributes.IMCAT_ID#,</cfif>
		<cfif isdefined("attributes.ISPOTANTIAL")>ISPOTANTIAL=1,<cfelse>ISPOTANTIAL=0,</cfif>
		<cfif isdefined("attributes.MOBILCAT_ID") AND attributes.MOBILCAT_ID NEQ 0>MOBIL_CODE='#attributes.MOBILCAT_ID#',</cfif>
		<cfif isdefined("attributes.MOBILTEL") AND len(attributes.MOBILTEL)>MOBILTEL='#attributes.MOBILTEL#',<cfelse>MOBILTEL = NULL,</cfif>
		<cfif isdefined("attributes.PICTURE") AND len(attributes.PICTURE)>PICTURE='#file_name#.#cffile.serverfileext#',</cfif>
		<cfif isdefined("attributes.PICTURE") AND len(attributes.PICTURE)>PICTURE_SERVER_ID=#fusebox.server_machine#,</cfif>
		<cfif isdefined("attributes.SECTOR_CAT_ID") and attributes.SECTOR_CAT_ID neq 0>SECTOR_CAT_ID=#attributes.SECTOR_CAT_ID#,</cfif>
		<cfif attributes.sex eq 1>SEX=1,<cfelse>SEX=0,</cfif>
		TAX_ADRESS='#attributes.TAX_ADRESS#',
		TAX_NO='#attributes.TAX_NO#',
		TITLE='#attributes.TITLE#',
		MISSION=<cfif len(attributes.mission)>#attributes.mission#,<cfelse>NULL,</cfif>
		DEPARTMENT=<cfif len(attributes.DEPARTMENT)>#attributes.DEPARTMENT#,<cfelse>NULL,</cfif>
		WORKADDRESS='#attributes.WORKADDRESS#',
		WORKCITY='#attributes.WORKCITY#',
		WORKCOUNTY='#attributes.WORKCOUNTY#',
		WORKPOSTCODE='#attributes.WORKPOSTCODE#',
		<cfif isdefined("attributes.IS_CARI")>IS_CARI=1,<cfelse>IS_CARI=0,</cfif>
		RECORD_DATE=#NOW()#,
		<cfif LEN(attributes.POS_CODE)>POS_CODE = #attributes.POS_CODE#,<cfelse>POS_CODE = NULL,</cfif>
		<cfif LEN(attributes.SALES_COUNTY)>SALES_COUNTY = #attributes.SALES_COUNTY#,<cfelse>SALES_COUNTY = NULL,</cfif>
		<cfif LEN(attributes.HIERARCHY_ID)>HIERARCHY_ID = #attributes.HIERARCHY_ID#,<cfelse>HIERARCHY_ID = NULL,</cfif>
		OZEL_KOD = '#attributes.OZEL_KOD#',
		SOCIAL_SOCIETY_ID = <cfif len(attributes.SOCIAL_SOCIETY_ID)>#SOCIAL_SOCIETY_ID#,<cfelse>NULL,</cfif>
		SOCIAL_SECURITY_NO ='#attributes.SOCIAL_SECURITY_NO#'		
		WHERE 
		CONSUMER_ID=#attributes.CONSUMER_ID#
	</cfquery>
<!--- Adres Defteri --->
<cfquery name="GET_POT" datasource="#DSN#">
	SELECT
		ISPOTANTIAL
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID=#attributes.CONSUMER_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=crm.detail_consumer&cid=#attributes.CONSUMER_ID#" addtoken="No">
