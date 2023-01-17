<cf_date tarih='attributes.give_date'>
<cfquery name="get_z_numbers" datasource="#dsn_dev#">
	SELECT DISTINCT
    	ZNO
    FROM
    	GENIUS_ACTIONS
    WHERE
    	KASA_NUMARASI = #attributes.kasa_id# AND
        YEAR(FIS_TARIHI) = #year(attributes.give_date)# AND
        MONTH(FIS_TARIHI) = #month(attributes.give_date)# AND
        DAY(FIS_TARIHI) = #day(attributes.give_date)#
</cfquery>

<select name="z_number" id="z_number" onChange="get_znumber_inner();">
    <option value="">Seçiniz</option>
    <cfoutput query="get_z_numbers">
    	<option value="#ZNO#">#ZNO#</option>
    </cfoutput>
</select>