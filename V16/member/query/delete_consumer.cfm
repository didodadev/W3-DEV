<cfquery name="get_periods" datasource="#dsn#">
	SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
</cfquery>
<cfset new_dsn = dsn>
<cfset new_dsn1 = dsn1>
<cfset datasource_list = "#dsn#,#dsn1#">
<cfloop query="get_periods">				
	<cfset new_dsn2 = '#dsn#_#get_periods.period_year#_#get_periods.our_company_id#'>
	<cfset new_dsn3 = '#dsn#_#get_periods.our_company_id#'>
	<cfset datasource_list = ListAppend(datasource_list,new_dsn2,',')>
	<cfset datasource_list = ListAppend(datasource_list,new_dsn3,',')>
</cfloop>
<cfset datasource_list = listdeleteduplicates(datasource_list) >
<cfset is_delete = 0 >
<cfloop list="#datasource_list#" index="data_sources">
	<cfquery name="SEARCH_CONSUMER_MAIN" datasource="#data_sources#">
		SELECT 
			TABLE_NAMES.NAME AS T_NAME,
			TABLE_COLS.NAME AS T_COL,
			TABLE_COLS.xtype TYPE,*
		FROM 
			sysobjects AS TABLE_NAMES
			JOIN sys.objects ON Sys.objects.object_id= TABLE_NAMES.id
			INNER JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id
			,
			syscolumns AS TABLE_COLS
		WHERE 
		sys.schemas.name = '#data_sources#' and
		TABLE_COLS.id = TABLE_NAMES.id AND
		TABLE_NAMES.xtype='U' AND  <!--- U OLMASI KULLANICI TABLOSU OLDUĞU ANLAMINA GELİYOR --->
		TABLE_NAMES.name <> 'dtproperties' AND 
		SUBSTRING(TABLE_NAMES.name,1,1) <> '_' AND<!--- Tablo kapatılmış ise gelmesin --->
		SUBSTRING(TABLE_COLS.name,1,1) <> '_' <!--- Alan kapatılmış ise gelmesin --->
		AND
		(
			TABLE_COLS.name LIKE '%CONSUMER%' OR 
			TABLE_COLS.name LIKE '%CONS%' OR 
			TABLE_COLS.name LIKE '%CON_ID%' OR 
			TABLE_COLS.name LIKE '%RECORD_CON%' OR
			TABLE_COLS.name LIKE '%UPDATE_CON%' 
		
		)
		AND NOT    (
			TABLE_COLS.name  = 'CONSUMER_CAT' OR
			TABLE_COLS.name  = 'CONSIGNMENT_NO' OR
			TABLE_COLS.name  = 'ICON_ID' OR
			TABLE_COLS.name  = 'CONSUMERS_VALID_NO' OR
			TABLE_COLS.name  = 'CONSIGNEER'
			)
		AND NOT TABLE_NAMES.name = 'CONSUMER'
		AND NOT TABLE_NAMES.name = 'CONSUMER_HISTORY'
		AND NOT TABLE_NAMES.name = 'CONSUMER_PERIOD'
		AND NOT TABLE_NAMES.name = 'COMPANY_CREDIT'
		AND NOT TABLE_NAMES.name = 'COMPANY_CREDIT_HISTORY'
		AND NOT TABLE_NAMES.name = 'COMPANY_CONSUMER_DOMAINS'
		AND NOT TABLE_NAMES.name = 'MEMBER_PERIODS_HISTORY'
		AND NOT TABLE_NAMES.name = 'WORKGROUP_EMP_PAR'
		AND NOT TABLE_NAMES.name = 'TARGET_MARKETS'
		AND NOT TABLE_NAMES.name = 'CONSUMER_BANK'
		AND NOT TABLE_NAMES.name = 'CONSUMER_CAT'
		AND NOT TABLE_NAMES.name = 'CONSUMER_CAT_OUR_COMPANY'
		AND NOT TABLE_NAMES.name = 'CONSUMER_CC'
		AND NOT TABLE_NAMES.name = 'CONSUMER_INFO'
		AND NOT TABLE_NAMES.name = 'CONTENT_BANNERS_USERS'
		AND NOT TABLE_NAMES.name = 'EVENT_RESULT'
		AND NOT TABLE_NAMES.name = 'FORUM_MAIN'
		AND NOT TABLE_NAMES.name = 'MAIN_MENU_SETTINGS'
		AND NOT TABLE_NAMES.name = 'WRK_SESSION'
		AND NOT TABLE_NAMES.name = 'WRK_LOGIN'
		AND NOT TABLE_NAMES.name = 'ADDRESSBOOK'
		AND NOT TABLE_NAMES.name = 'COMPANY_BRANCH_RELATED'
		AND NOT TABLE_NAMES.name = 'CUSTOMER_HELP'
		AND NOT TABLE_NAMES.name = 'ORDER_PRE_ROWS_LOG'	
		AND NOT TABLE_NAMES.name = 'G_SERVICE'			
		AND NOT TABLE_NAMES.name = 'G_SERVICE_HISTORY'
		AND NOT TABLE_NAMES.name = 'CALL_ENTEGRASYON'
		AND NOT TABLE_NAMES.name = 'CP_CONTROL'
		AND NOT TABLE_NAMES.name = 'SETUP_CONSCAT_SEGMENTATION'								
		AND NOT TABLE_NAMES.name = 'SMS_SEND_RECEIVE'
		AND NOT TABLE_NAMES.name = 'SETUP_CONSCAT_PREMIUM'
        AND NOT TABLE_NAMES.name = 'CONSUMER_EDUCATION_INFO'
        AND NOT TABLE_NAMES.name = 'SETUP_CONSCAT_SEGMENTATION_ROWS'   
        AND NOT TABLE_NAMES.name = 'CONSUMER_CAMP_STATUS'  
        AND NOT TABLE_NAMES.name = 'SEND_CONTENTS'
		AND NOT TABLE_NAMES.name = 'PROCESS_TYPE_ROWS_RECORD_INFO'       					
		AND TABLE_COLS.xtype IN (56,231,99) <!--- SADECE int,nvarchar ve ntext olanlar gelsin. --->
	ORDER BY
		T_NAME
	</cfquery>
	<cfoutput query="SEARCH_CONSUMER_MAIN">
		<cfif  TYPE eq 56><!--- Alan INTEGER ISE --->
			<cfquery name="IS_CONSUMER_RECORD" datasource="#data_sources#">
				SELECT TOP 1 #T_COL# FROM #T_NAME# WHERE #T_COL# = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfquery>
			<cfif IS_CONSUMER_RECORD.RECORDCOUNT><!--- Eğer Kayıt Varsa --->
				<script type="text/javascript">
					alert("<cf_get_lang no ='573.Bu üyeye ait kayıtlar bulunmaktadır Üyeyi Silemezsiniz'>.");
					history.back(-1);
				</script>
				<cfabort>
			</cfif>
		<cfelse><!--- NTEXT YADA NVARCHAR ise --->	
			<cfquery name="IS_CONSUMER_RECORD" datasource="#data_sources#">
				SELECT TOP 1 #T_COL# FROM #T_NAME# WHERE #T_COL# LIKE ',#attributes.consumer_id#,'
			</cfquery>
			<cfif IS_CONSUMER_RECORD.RECORDCOUNT><!--- Eğer Kayıt Varsa --->
				<script type="text/javascript">
					alert("<cf_get_lang no ='573.Bu üyeye ait kayıtlar bulunmaktadır Üyeyi Silemezsiniz'>.");
					history.back(-1);
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfoutput>
	<!--- Eğer buraya kadar gelirse,üyeye ait kayıt bulunamamış demektir onun için üye silinebilir. --->
	<cfset is_delete = 1 >
</cfloop>
<cfif is_delete eq 1>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="delete_consumer" datasource="#DSN#">
				DELETE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM CONSUMER_PERIOD WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM MEMBER_PERIODS_HISTORY WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM CONSUMER_HISTORY WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM WORKGROUP_EMP_PAR WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM COMPANY_BRANCH_RELATED WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM COMPANY_CONSUMER_DOMAINS WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM COMPANY_CREDIT WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM COMPANY_CREDIT_HISTORY WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM CUSTOMER_HELP WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM G_SERVICE WHERE SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM G_SERVICE_HISTORY WHERE SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM CALL_ENTEGRASYON WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">                
                DELETE FROM CONSUMER_EDUCATION_INFO WHERE CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				DELETE FROM SEND_CONTENTS WHERE SEND_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">                 
			</cfquery>
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		alert("<cf_get_lang no ='574.Üye Başarı İle Silinmiştir'>.");
		window.location.href='<cfoutput>#request.self#?fuseaction=member.consumer_list</cfoutput>';
	</script>
</cfif>
