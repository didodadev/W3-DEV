<cfset newDsn = ( IsDefined("dsn") ) ? dsn : attributes.datasource />
<cflock name="#CreateUUID()#" timeout="500">
	<cftransaction>
		<cfset acilis_codu_ = '<cfquery name="CREATE_MAIN_DB" datasource="#newDsn#">'>
		<cfset kapanis_codu_ = '</cfquery>'>
		<cfsavecontent variable="product_db_tables_icerik"><cfinclude template="db_tables.txt"></cfsavecontent>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'SET ANSI_NULLS ON GO SET QUOTED_IDENTIFIER ON GO','','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'ON [PRIMARY] GO','ON [PRIMARY]','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'CREATE TABLE','#kapanis_codu_##acilis_codu_# CREATE TABLE','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'CREATE TRIGGER','#kapanis_codu_##acilis_codu_# CREATE TRIGGER','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'CREATE PROCEDURE','#kapanis_codu_##acilis_codu_# CREATE PROCEDURE','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'v16_catalyst','#attributes.datasource#','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'v16_catalyst_product','#attributes.datasource#_product','all')>
		<cfset product_db_tables_icerik = '#product_db_tables_icerik##kapanis_codu_#'>
		<cfset product_db_tables_icerik = '#replace(product_db_tables_icerik,'</cfquery>','','one')#'>
		<cffile action="write" output="#product_db_tables_icerik#" addnewline="yes" file="#index_folder_ilk_#/DB/islem_yap_1.cfm" charset="utf-8">
		<cfinclude template="islem_yap_1.cfm">
		<cffile action="delete" file="#index_folder_ilk_#/DB/islem_yap_1.cfm" charset="utf-8">
	</cftransaction>
</cflock>
<cflock name="#CreateUUID()#" timeout="500">
	<cftransaction>
		<cfset acilis_codu_ = '<cfquery name="CREATE_MAIN_DB" datasource="#newDsn#">'>
		<cfset kapanis_codu_ = '</cfquery>'>
		<cfsavecontent variable="product_db_tables_icerik"><cfinclude template="db_views.txt"></cfsavecontent>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'SET ANSI_NULLS ON GO SET QUOTED_IDENTIFIER ON GO','','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'ON [PRIMARY] GO','ON [PRIMARY]','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'CREATE','#kapanis_codu_##acilis_codu_# CREATE','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'v16_catalyst','#attributes.datasource#','all')>
		<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'v16_catalyst_product','#attributes.datasource#_product','all')>
		<cfset product_db_tables_icerik = '#product_db_tables_icerik##kapanis_codu_#'>
		<cfset product_db_tables_icerik = '#replace(product_db_tables_icerik,'</cfquery>','','one')#'>
		<cffile action="write" output="#product_db_tables_icerik#" addnewline="yes" file="#index_folder_ilk_#/DB/islem_yap_2.cfm" charset="utf-8">
		<cfinclude template="islem_yap_2.cfm">
		<cffile action="delete" file="#index_folder_ilk_#/DB/islem_yap_2.cfm" charset="utf-8">
	</cftransaction>
</cflock>
<cfif not IsDefined("dsn")><!---- Sadece yeni kurulumlarda çalışır ---->
	<cflock name="#CreateUUID()#" timeout="500">
		<cftransaction>
			<cfset acilis_codu_ = '<cfquery name="CREATE_FUNCTIONS" datasource="#newDsn#">'>
			<cfset kapanis_codu_ = '</cfquery>'>
			<cfsavecontent variable="product_db_tables_icerik"><cfinclude template="db_functions.txt"></cfsavecontent>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'SET ANSI_NULLS ON GO SET QUOTED_IDENTIFIER ON GO','','all')>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'ON [PRIMARY] GO','ON [PRIMARY]','all')>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'CREATE','#kapanis_codu_##acilis_codu_# CREATE','all')>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'v16_catalyst','#attributes.datasource#','all')>
			<cfset product_db_tables_icerik = '#product_db_tables_icerik##kapanis_codu_#'>
			<cfset product_db_tables_icerik = '#replace(product_db_tables_icerik,'</cfquery>','','one')#'>
			<cffile action="write" output="#product_db_tables_icerik#" addnewline="yes" file="#index_folder_ilk_#/DB/islem_yap_3.cfm" charset="utf-8">
			<cfinclude template="islem_yap_3.cfm">
			<cffile action="delete" file="#index_folder_ilk_#/DB/islem_yap_3.cfm" charset="utf-8">
		</cftransaction>
	</cflock>
	<cflock name="#CreateUUID()#" timeout="500">
		<cftransaction>
			<cfset acilis_codu_ = '<cfquery name="CREATE_JOBS" datasource="master">'>
			<cfset kapanis_codu_ = '</cfquery>'>
			<cfsavecontent variable="product_db_tables_icerik"><cfinclude template="db_jobs.txt"></cfsavecontent>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'SET ANSI_NULLS ON GO SET QUOTED_IDENTIFIER ON GO','','all')>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'ON [PRIMARY] GO','ON [PRIMARY]','all')>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'BEGIN TRANSACTION','#kapanis_codu_##acilis_codu_# BEGIN TRANSACTION','all')>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'v16_catalyst','#attributes.datasource#','all')>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'loginName','#attributes.datasource#','all')>
			<cfset product_db_tables_icerik = replace(product_db_tables_icerik,'delete_passive_sessions','#attributes.datasource#_delete_passive_sessions','all')>
			<cfset product_db_tables_icerik = '#product_db_tables_icerik##kapanis_codu_#'>
			<cfset product_db_tables_icerik = '#replace(product_db_tables_icerik,'</cfquery>','','one')#'>
			<cffile action="write" output="#product_db_tables_icerik#" addnewline="yes" file="#index_folder_ilk_#/DB/islem_yap_4.cfm" charset="utf-8">
			<cfinclude template="islem_yap_4.cfm">
			<cffile action="delete" file="#index_folder_ilk_#/DB/islem_yap_4.cfm" charset="utf-8">
		</cftransaction>
	</cflock>
</cfif>