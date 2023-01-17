<cfif len(attributes.fatura_no)>
	<cfquery name="get_invoice" datasource="#DSN2#">
		SELECT 
			INVOICE_ID,
			PURCHASE_SALES 
		FROM 
			INVOICE 
		WHERE 
			INVOICE_NUMBER = '#attributes.fatura_no#'
			<cfif session.ep.isBranchAuthorization>
			AND DEPARTMENT_ID IN
				(
					SELECT 
						DEPARTMENT_ID
					FROM 
						#dsn_alias#.DEPARTMENT D
					WHERE
						D.BRANCH_ID=#listgetat(session.ep.user_location,2,'-')#
				)
			</cfif>
	</cfquery>
	<cfif get_invoice.recordcount>
		<cfif get_invoice.PURCHASE_SALES >
			<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_invoice_sale&iid=#get_invoice.INVOICE_ID#" addtoken="no">
		<cfelse>
			<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_invoice_purchase&iid=#get_invoice.INVOICE_ID#" addtoken="no">	
		</cfif>
	<cfelse>
		<script type="text/javascript">
			history.back();
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		history.back();
	</script>
</cfif>
