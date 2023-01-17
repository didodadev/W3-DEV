<cfif not isDefined("attributes.upd")>
	<cfquery name="ADD_DEF" datasource="#DSN3#">
		INSERT INTO SETUP_INVOICE_purchase
			(
			PERAKENDE_S_I_F,
			M_MAKBUZU,
			ALINAN_D_F
			<cfif len(attributes.a_disc)>,A_DISC</cfif>	
			,YUVARLAMA_GIDER
			,YUVARLAMA_GELIR
			,FARK_GIDER
			,FARK_GELIR
			)
		VALUES
			(
			'#attributes.perakende_s_i_f#',
			'#attributes.m_makbuzu#',
			'#attributes.alinan_d_f#'
			<cfif len(attributes.a_disc)>,'#attributes.a_disc#'</cfif>
			,'#attributes.yuvarlama_gider#'
			,'#attributes.yuvarlama_gelir#'
			,'#attributes.fark_gider#'
			,'#attributes.fark_gelir#'		
			)
	</cfquery>
<cfelse>
	<cfquery name="ADD_DEF" datasource="#DSN3#">
		UPDATE SETUP_INVOICE_purchase
		SET
			PERAKENDE_S_I_F='#attributes.perakende_s_i_f#',
			M_MAKBUZU='#attributes.m_makbuzu#',
			ALINAN_D_F='#attributes.alinan_d_f#'
			<cfif len(attributes.a_disc)>,A_DISC='#attributes.a_disc#'<cfelse>,A_DISC=NULL</cfif>
			,YUVARLAMA_GIDER='#attributes.yuvarlama_gider#'
			,YUVARLAMA_GELIR='#attributes.yuvarlama_gelir#'
			,FARK_GIDER='#attributes.fark_gider#'
			,FARK_GELIR='#attributes.fark_gelir#'
	</cfquery>
</cfif>
<script>
	window.location.href = "<cfoutput>#CGI.HTTP_REFERER#</cfoutput>";
</script>
