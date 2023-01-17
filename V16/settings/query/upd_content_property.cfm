<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfquery name="UPD_CONTENT_PROPERTY" datasource="#dsn#">
	UPDATE 
		CONTENT_PROPERTY
	SET 
		NAME= #sql_unicode()#'#NAME#',
		DESCRIPTION= #sql_unicode()#'#DESCRIPTION#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		CONTENT_PROPERTY_ID = #CONTENT_PROPERTY_ID#
</cfquery>
<cfquery name="DEL_PERM" datasource="#DSN#">
	DELETE FROM CONTENT_PROPERTY_PERM WHERE CONTENT_PROPERTY_ID = #CONTENT_PROPERTY_ID#
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
                #CONTENT_PROPERTY_ID#,
                #I#
            )
		</cfquery>	
	</cfloop>
</cfif>
<script>
	location.href= document.referrer;
</script>
