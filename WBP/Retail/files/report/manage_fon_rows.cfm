<cfquery name="del_" datasource="#dsn_dev#">
	DELETE FROM FON_ROWS WHERE KOLON_AD = '#alan#'
</cfquery>

<cfquery name="add_" datasource="#dsn_dev#">
	INSERT INTO
    	FON_ROWS
        (
        KOLON_AD,
        KOLON_DEGER
        )
        VALUES
        (
        '#attributes.alan#',
        '#attributes.deger#'
        )
</cfquery>