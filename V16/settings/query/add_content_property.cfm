<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfquery name="INS_CONTENT_PROPERTY" datasource="#DSN#" result="MAX_ID">
	INSERT INTO 
		CONTENT_PROPERTY
	(
		NAME,
		DESCRIPTION,
		RECORD_IP,
		RECORD_DATE,
		RECORD_EMP
	) 
	VALUES 
	(
		#sql_unicode()#'#NAME#',
		#sql_unicode()#'#DESCRIPTION#',
		'#cgi.remote_addr#',
		#now()#,
		#session.ep.userid#
	)
    SELECT SCOPE_IDENTITY() MAX_ID
</cfquery>
<cfscript>
	if(isdefined("attributes.to_pos_codes")) s_PCODES =ListSort(ListDeleteDuplicates(attributes.to_pos_codes),"Numeric", "Desc") ; else s_PCODES ='';
</cfscript>
<cfif ListLen(s_PCODES)>
	<cfloop list="#s_PCODES#" index="I" delimiters=",">
		<cfquery name="ADD_PRO_EMP_PERM" datasource="#DSN#">
        INSERT INTO 
            CONTENT_PROPERTY_PERM
            (
                CONTENT_PROPERTY_ID,
                POSITION_CODE
            )
            VALUES
            (
                #INS_CONTENT_PROPERTY.MAX_ID#,
                #I#
            )
		</cfquery>	
	</cfloop>
</cfif>
<script>
	location.href= document.referrer;
</script>

