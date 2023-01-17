<cfquery name="get_alternative_product_except" datasource="#dsn3#">
	SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID = #attributes.anative_product_id#
</cfquery>
<cfif get_alternative_product_except.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1962.Ilgili Urun Secilmistir'>");
	</script>
<cfelse>
	<cfquery name="add_alternative_product_except" datasource="#dsn3#">
		INSERT INTO ALTERNATIVE_PRODUCTS_EXCEPT
		(
			PRODUCT_ID,
			ALTERNATIVE_PRODUCT_ID
		)
		VALUES
		(
			#attributes.pid#,
			#attributes.anative_product_id#
		)
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique__dsp_product_anti_alternatives_');
	</cfif>
</script>
