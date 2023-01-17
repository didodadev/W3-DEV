<cfquery name="get_table_column" datasource="#dsn#">
    SELECT * FROM 
    (
    SELECT * FROM 		
    INFORMATION_SCHEMA.COLUMNS
    UNION ALL
    SELECT * FROM 		
    workcube_cf_1.INFORMATION_SCHEMA.COLUMNS 
    UNION ALL
    SELECT * FROM 		
    workcube_cf_2013_1.INFORMATION_SCHEMA.COLUMNS
    UNION ALL
    SELECT * FROM 		
    workcube_cf_product.INFORMATION_SCHEMA.COLUMNS
	) as c
    WHERE COLUMN_NAME = '#attributes.column_name#' 
    <cfif len (attributes.chr_max)>
    and CHARACTER_MAXIMUM_LENGTH = #attributes.chr_max# 
    </cfif> 
    AND DATA_TYPE='#attributes.data_type#'
</cfquery>
<cf_medium_list>
	<thead>
        <tr>
            <th>No</th>
            <th>Veri Tabanı</th>
            <th>Tablo Adı</th>
            <th>Kolon Adı</th>
            <th>Veri Türü</th>
            <th>Uzunluk</th>
        </tr>
    </thead>
    <tbody>
		<cfoutput query="get_table_column">
            <tr>
                <td>#currentrow#</td>
                <td>#TABLE_CATALOG#</td>
                <td>#TABLE_NAME#</td>
                <td>#COLUMN_NAME#</td>
                <td>#DATA_TYPE#</td>
                <td>#CHARACTER_MAXIMUM_LENGTH#</td>
            </tr>    
    </cfoutput>
    </tbody>
</cf_medium_list>

