<cfquery name="check_table" datasource="#dsn#">
	IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME ='####TEMP_2')
    DROP TABLE ####TEMP_2
</cfquery>
<cfquery name="REPAET_COLUMN" datasource="#DSN#">
SELECT   COUNT(COLUMN_NAME) AS SAYAC,
         COLUMN_NAME
INTO     ####TEMP_2
FROM     (SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          UNION ALL
          SELECT *
          FROM   workcube_cf_1.INFORMATION_SCHEMA.COLUMNS
          UNION ALL
          SELECT *
          FROM   workcube_cf_2013_1.INFORMATION_SCHEMA.COLUMNS
          UNION ALL
          SELECT *
          FROM   workcube_cf_product.INFORMATION_SCHEMA.COLUMNS) AS c
WHERE    COLUMN_NAME NOT IN ('RECORD_DATE', 'RECORD_IP', 'RECORD_EMP', 'UPDATE_DATE', 'UPDATE_IP', 'UPDATE_EMP', 'ID')
         AND COLUMN_NAME NOT LIKE '[_]%'
GROUP BY COLUMN_NAME
HAVING   COUNT(COLUMN_NAME) > 1;
</cfquery>
<cfquery name="REPAET_COLUMN2" datasource="#DSN#">
SELECT   T2.*,
         XXX.*
FROM     ####TEMP_2 AS T2 OUTER APPLY (SELECT   COUNT(COLUMN_NAME) AS SAYAC2,
                                                COLUMN_NAME AS COLUMN_NAME2 ,
                                                DATA_TYPE,
                                                CHARACTER_MAXIMUM_LENGTH
                                       FROM     
                                       
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
                                                ) AS C
                                       WHERE    C.COLUMN_NAME = T2.COLUMN_NAME
                                       GROUP BY COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH) AS XXX
WHERE    SAYAC2 <> SAYAC
ORDER BY T2.SAYAC DESC;
</cfquery>
<cf_big_list_search title="Kolon Tekrar">
	<cf_big_list_search_area>
    	<table>
        	<tr>
            	<td><cf_get_lang_main no='48.Filtre'></td>
                <td><input type="text" id="" name="" value="" style="width:100px;" /></td>
                <td><cf_wrk_search_button is_excel="0"></td>
            </tr>
        </table>
    </cf_big_list_search_area>
</cf_big_list_search>
<cf_medium_list>
    <thead>
        <tr>
            <th width="100">Total Kullanım</th>
            <th>Kolon Adı</th>
            <th>Kullanım</th>
            <th>Kolon Adı</th>
            <th>Veri Türü</th>
            <th>uzunluk</th>
            <th class="header_icn_none">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="REPAET_COLUMN2">	
            <tr>
                <td>#SAYAC#</td>
                <td>#COLUMN_NAME#</td>
                <td>#SAYAC2#</td>
                <td>#COLUMN_NAME2#</td>
                <td>#DATA_TYPE#</td>
                <td>#CHARACTER_MAXIMUM_LENGTH#</td>
                <td> <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=dev.popup_column_table&column_name=#COLUMN_NAME2#&data_type=#DATA_TYPE#&chr_max=#CHARACTER_MAXIMUM_LENGTH#','list');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a></td>
            </tr> 
        </cfoutput>
    </tbody>
</cf_medium_list>

