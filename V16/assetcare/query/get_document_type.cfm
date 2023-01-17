<cfquery name="GET_DOCUMENT_TYPE" datasource="#DSN#">
	SELECT
    DISTINCT
		SDT.DOCUMENT_TYPE_ID,
		SDT.DOCUMENT_TYPE_NAME
	FROM
		SETUP_DOCUMENT_TYPE SDT,
		SETUP_DOCUMENT_TYPE_ROW SDTR
	WHERE
		SDTR.DOCUMENT_TYPE_ID =  SDT.DOCUMENT_TYPE_ID AND
		SDTR.FUSEACTION LIKE '%#fuseaction#'
	ORDER BY
		SDT.DOCUMENT_TYPE_NAME
</cfquery>
