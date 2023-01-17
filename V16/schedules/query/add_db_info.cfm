<cflock timeout="60">
	<cftransaction>
		<cfquery name="get_databases" datasource="#DSN#">
			sp_databases
		</cfquery>
		<cfscript>toplam=0;</cfscript>
		<cfloop query="GET_DATABASES">
			<cfscript>
				toplam=toplam+get_databases.database_size;
			</cfscript>
		</cfloop>
		<cfquery name="get_servername" datasource="#dsn#">
			select @@servername as server_name
		</cfquery>
		<cfquery name="ADD_SERVER_INFO" datasource="#dsn#" result="MAX_ID">
			INSERT
			INTO
				CALISMA.VT_SERVER_INFO
				(
					DB_SERVER_NAME,
					DB_SERVER_SIZE
				)
				VALUES
				(
					'#get_servername.server_name#',
					#toplam#
				)
		</cfquery>
		<cfloop query="GET_DATABASES">
			<cfquery name="ADD_DATABASE_INFO" datasource="#DSN#">
				INSERT
				INTO
					CALISMA.VERITABANI_INFO
					(
						SERVER_ID,
						VERITABANI_NAME,
						VERITABANI_SIZE
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						'#get_databases.database_name#',
						#get_databases.database_size#
					)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
İşlem Başarı İle Halledildi !!!
