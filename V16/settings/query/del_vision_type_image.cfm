<cfquery name="GET_" datasource="#DSN#">
	SELECT
		VISION_TYPE_IMAGE,
		VISION_TYPE_IMAGE_SERVER_ID
	FROM
		SETUP_VISION_TYPE
	WHERE
		VISION_TYPE_ID=#attributes.vision_type_id#
</cfquery>

<cf_del_server_file output_file="settings/#GET_.VISION_TYPE_IMAGE#" output_server="#GET_.VISION_TYPE_IMAGE_SERVER_ID#">

<cfquery name="UPD_CREDIT_PAYMENT" datasource="#DSN#">
	UPDATE
		SETUP_VISION_TYPE
	SET
		VISION_TYPE_IMAGE = NULL,
		VISION_TYPE_IMAGE_SERVER_ID = NULL
	WHERE
		VISION_TYPE_ID=#attributes.vision_type_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
