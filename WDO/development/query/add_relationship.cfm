<cfset myList=attributes.insert_relation>
<cfquery datasource="#dsn#" name="find_column_name">
	SELECT COLUMN_NAME,TABLE_NAME FROM WRK_COLUMN_INFORMATION WHERE COLUMN_NAME='#attributes.primary_key_#' AND TABLE_ID = '#attributes.TABLE_ID_#'
</cfquery>
<cfloop list="#mylist#" index="i">
<!---	<cfquery datasource="#dsn#" name="find_column_name_foreign">
		SELECT COLUMN_NAME,TABLE_NAME FROM WRK_COLUMN_INFORMATION WHERE COLUMN_NAME='' AND TABLE_NAME <> '#attributes.TABLE_ID_#'
	</cfquery>--->
	<cfquery datasource="#dsn#" name="insert_relationship">
		INSERT INTO 
            WRK_TABLE_RELATION_SHIP 
            (
                PRIMARY_KEY_COLUMN_NAME,
                FOREIGN_KEY_COLUMN_NAME,
                PRIMARY_KEY_TABLE_NAME,
                FOREIGN_KEY_TABLE_NAME,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
            )
            VALUES			
            (
                '#find_column_name.COLUMN_NAME#',
                '#listgetAt(i,2,'-')#',
                '#find_column_name.TABLE_NAME#',
                '#listgetAt(i,1,'-')#',
                '#cgi.remote_addr#',
                #now()#,
                #session.ep.userid#
            )	 
	</cfquery>
</cfloop>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


