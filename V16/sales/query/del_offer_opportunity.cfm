<cfquery name="upd_offer" datasource="#DSN3#">
	UPDATE
		OFFER
	SET
		OPP_ID=NULL
	WHERE
		OFFER_ID=#attributes.OFFER_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
