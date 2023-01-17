<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfquery name="CHAPTER_CONTROL" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		CONTENT_CHAPTER
	WHERE 
		(CONTENTCAT_ID = #FORM.CONTENT_CAT#) 
	AND 
		(CHAPTER='#FORM.CHAPTER_NAME#')
</cfquery>
<cfif chapter_control.recordcount>
<cf_get_lang no='85.Girdiğiniz Bölüm Adı Şu An Kullanılıyor !'><br/>
<cfoutput>
<a href="#cgi.referer#"><cf_get_lang no='51.Lütfen Geri Dönüp Kontrol Ediniz !'></a>
</cfoutput>
<cfabort>
</cfif>
<cfif #isdefined("form.status")#>
<cfset #variables.durum# = 0>
<cfelse>
<cfset #variables.durum# = 1>
</cfif>
<cfquery name="BAK" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		CONTENT_CHAPTER
	ORDER BY 
		HIERARCHY
</cfquery>
<cfoutput>#bak.recordcount#</cfoutput>
<cfif bak.recordcount>
<cfoutput query="bak">
<cfif #listlen(HIERARCHY)# is 1>
	#chapter# #HIERARCHY#<br/>
	<cfset #variables.son_val# = #listgetat(HIERARCHY,1)# + 1>
	#variables.son_val#
</cfif>
</cfoutput>
<cfelse>
	<cfset #variables.son_val# = 1>
</cfif>
<cfquery name="INSERT_CHAPTER" datasource="#dsn#">
	INSERT INTO 
		CONTENT_CHAPTER 
	(
		CONTENT_CHAPTER_STATUS, 
		HIERARCHY, 
		CHAPTER, 
		RECORD_DATE, 
		<!---MEMBER_TYPE,---> 
		RECORD_MEMBER, 
		RECORD_IP, 
		CONTENTCAT_ID
	)
	VALUES 
	(
		#DURUM#, 
		'#VARIABLES.SON_VAL#', 
		#sql_unicode()#'#TRIM(FORM.CHAPTER_NAME)#', 
		'#dateformat(NOW())#', 
		<!---#SESSION.MEMBER_TYPE#, --->
		#SESSION.EP.USERID#, 
		'#REMOTE_ADDR#',
		#FORM.CONTENT_CAT#
	)
</cfquery>
<cfif #isdefined("form.image1")#>
<cfquery name="GELEN" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		CONTENT_CHAPTER 
	WHERE 
		CHAPTER='#TRIM(FORM.CHAPTER_NAME)#' 
	AND 
		CONTENTCAT_ID=#FORM.CONTENT_CAT#
</cfquery>
<cfquery name="UPDATE_PIC" datasource="#dsn#">
	UPDATE 
		CONTENT_CHAPTER 
	SET 
		CHAPTER_IMAGE1='#RESIM1#',
		SERVER_ID1=#fusebox.server_machine#
	WHERE 
		CHAPTER_ID=#GELEN.CHAPTER_ID#
</cfquery>
<cftry>
	<cffile action="UPLOAD" 
			filefield="image1"  nameconflict="OVERWRITE"
			destination="#upload_folder#Module_Content#dir_seperator#images#dir_seperator#chapter_images#dir_seperator##resim1#" 
			mode="777" accept="image/*">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
</cfif>
<cflocation url="#cgi.referer#" addtoken="no">
