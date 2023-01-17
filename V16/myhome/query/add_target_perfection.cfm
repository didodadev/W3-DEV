<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY_TARGET WHERE COMPANY_ID = #attributes.company_id# AND PERIOD = #attributes.period#
</cfquery>
<cfif get_target.recordcount>
	<script language="javascript">
		alert("Bu Döneme Ait Hedef Bulunmakta ! ");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_TARGET" datasource="#dsn#" result="MAX_ID">
	INSERT 
	INTO
		OUR_COMPANY_TARGET 
		(
			COMPANY_ID,
			PERIOD,
			VIZYON,
			DETAIL,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			TARGET_SIZE
		)
		VALUES
		(
			#attributes.company_id#,
			#attributes.period#,
		   '#attributes.vizyon#',
		   '#attributes.detail#',
			#session.ep.userid#,
		   '#cgi.remote_addr#',
			#now()#,
			#attributes.target_size#
		)
</cfquery>
<cflocation url="#request.self#?fuseaction=myhome.detail_target_perfection&target_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
