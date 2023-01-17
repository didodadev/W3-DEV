<!--- 
	Botan Kayğan
	botankaygan@workcube.com
	16.04.2021
		Örnek Kullanım :
		<cf_add_data_source mod="add" dsn="workcube_dev" db="workcube_dev" host="workcube" driver="MSSQLServer" username="workcube" password="12345" admin_password="12345">
		<cf_add_data_source mod="del" dsn="workcube_dev" admin_password="12345">
			Mod : add or del ; Add dsn üzerinde ekleme veya güncelleme işlemlerini yapar. del ise mevcut dsni siler.
--->

<cfparam name="attributes.mod" default="add">
<cfparam name="attributes.port" default="1433">
<cfparam name="attributes.driver" default="MSSQLServer">

<cfif attributes.mod eq 'add'>
	<cfif not isdefined("attributes.dsn")>
		<cfoutput>&lt;cf_Add_data_source&gt;</cfoutput><cf_get_lang dictionary_id="57541.Hata"> <cf_get_lang dictionary_id="51863.DSN Parametresi Eksik">
		<cfexit method="exittemplate">
	</cfif>
	<cfif not isdefined("attributes.db")>
		<cfoutput>&lt;cf_Add_data_source&gt;</cfoutput><cf_get_lang dictionary_id="51872.Database Parametresi Eksik">
		<cfexit method="exittemplate">
	</cfif>
	<cfif not isdefined("attributes.host")>
		<cfoutput>&lt;cf_Add_data_source&gt;</cfoutput> <cf_get_lang dictionary_id="51881.Host Parametresi Eksik">
		<cfexit method="exittemplate">
	</cfif>
	<cfif not isdefined("attributes.username")>
		<cfoutput>&lt;cf_Add_data_source&gt; </cfoutput><cf_get_lang dictionary_id="51883.Kullanıcı Adı Parametresi Eksik !">
		<cfexit method="exittemplate">
	</cfif>
	<cfif not isdefined("attributes.password")>
		<cfoutput>&lt;cf_Add_data_source&gt; </cfoutput><cf_get_lang dictionary_id="51886.Şifre Parametresi Eksik ! !">
		<cfexit method="exittemplate">
	</cfif>
</cfif>

<cfset class = {
    "MSSQLServer":"macromedia.jdbc.MacromediaDriver",
    "MySQL5":"com.mysql.jdbc.Driver",
    "Oracle":"macromedia.jdbc.MacromediaDriver",
    "PostgreSQL":"org.postgresql.Driver"
} />

<cfif attributes.mod eq 'add'>
	<!--- her dbnin farklı bir urli mevcut tamamlanınca bu kısımda açılacak. BK-170421 --->
	<!--- <cfif listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') lte 8>
		<cfscript>
			factory = createObject("java","coldfusion.server.ServiceFactory");
			request.sqlexecutive = factory.getDataSourceService();
			
			newDSN = structNew();
			urlmap = structNew();
			connectionProps = structNew();
				
			attributes.password = request.sqlexecutive.encryptPassword(attributes.password);
			
			// set DSN values here
			newDSN.name = attributes.dsn;
			newDSN.class = "#class['#attributes.driver#']#";
			newDSN.driver = attributes.driver;
			newDSN.alter = "YES";
			newDSN.blob_buffer = 64000;
			newDSN.buffer = 64000;
			newDSN.create = "YES";
			newDSN.delete = "YES";
			newDSN.description = "";
			newDSN.disable = "NO";
			newDSN.disable_blob = "YES";
			newDSN.disable_clob = "NO";
			newDSN.drop = "YES";
			newDSN.grant = "YES";
			newDSN.insert = "YES";
			newDSN.interval = 420;
			newDSN.login_timeout = "YES";
			newDSN.password = attributes.password;
			newDSN.pooling = "YES";
			newDSN.revoke = "YES";
			newDSN.select = "YES";
			newDSN.storedproc = "YES";
			newDSN.timeout = 1200;
			newDSN.update = "YES";
		
			urlmap.host = attributes.host;
			urlmap.port = attributes.port;
			urlmap.selectMethod = "direct";
			urlmap.sendStringParametersAsUnicode = false;
		
			newDSN.url = "jdbc:macromedia:sqlserver://#urlmap.host#:#urlmap.port#;databaseName=#attributes.db#;SelectMethod=#urlmap.selectMethod#;sendStringParametersAsUnicode=#urlmap.sendStringParametersAsUnicode#";
			newDSN.username = attributes.username;
			newDSN.valid = "YES";		
			
			// set urlmap values here
			urlmap.SID = "";
			urlmap.UseTrustedConnection = false;
			urlmap.args = "";
			urlmap.database = attributes.db;
			urlmap.databasefile = "";
			urlmap.datasource = "";
			urlmap.defaultpassword = "";
			urlmap.defaultusername = "";
			urlmap.informixServer = "";
			urlmap.maxBufferSize = "";
			urlmap.pageTimeout = "";
			urlmap.systemDatabaseFile = "";		
			
			connectionProps.database = attributes.db;
			connectionProps.host = attributes.host;
			connectionProps.port = urlmap.port;
			connectionProps.selectmethod = "direct";
			connectionProps.SENDSTRINGPARAMETERSASUNICODE = false;
			
			urlmap["CONNECTIONPROPS"] =duplicate(connectionProps);
			newDSN["urlmap"] = duplicate(urlmap);
			
			request.sqlexecutive.datasources[attributes.dsn] = newDSN;
		</cfscript>
	<cfelse> --->
		<cfscript>
			adminObj=createObject("component","cfide.adminapi.administrator");
			adminObj.login("#attributes.admin_password#");
			myObj = createObject("component","cfide.adminapi.datasource"); 
			stDSN = structNew(); 
			stDSN.name="#attributes.dsn#";  
			stDSN.password = "#attributes.password#";
			stDSN.username = "#attributes.username#";
			stDSN.driver = attributes.driver; 
			stDSN.host = "#attributes.host#";

			if(attributes.driver eq 'Oracle')
				stDSN.sid = "#attributes.dsn#";
			
			stDSN.port = "#attributes.port#"; 
			stDSN.database ="#attributes.db#"; 
			if (listfirst(SERVER.COLDFUSION.PRODUCTVERSION,',') lte 10)
			{
				stDSN.login_timeout = "YES";
			}
			else
			{
				stDSN.login_timeout = 1200;
			}
			stDSN.timeout = 1200;  
			stDSN.interval = 420; 
			stDSN.buffer = 64000; 
			stDSN.blob_buffer = 64000; 
			stDSN.setStringParameterAsUnicode = "NO"; 
			stDSN.description = ""; 
			stDSN.pooling = "YES"; 
			stDSN.maxpooledstatements = 999;
			stDSN.enableMaxConnections = "YES"; 
			stDSN.maxConnections = "299"; 
			stDSN.enable_clob = "YES"; 
			stDSN.enable_blob = "NO"; 
			stDSN.disable = "NO"; 
			stDSN.storedProc = "YES"; 
			stDSN.alter = "YES"; 
			stDSN.grant = "YES"; 
			stDSN.select = "YES"; 
			stDSN.update = "YES"; 
			stDSN.create = "YES"; 
			stDSN.delete = "YES"; 
			stDSN.drop = "YES"; 
			stDSN.revoke = "YES";
			if(attributes.driver eq 'MSSQLServer')
				myObj.setMSSQL(argumentCollection=stDSN);
			else if(attributes.driver eq 'Oracle')
				myObj.setOracle(argumentCollection=stDSN);
			else if(attributes.driver eq 'MySQL5')
				myObj.setMySQL5(argumentCollection=stDSN);
			else if(attributes.driver eq 'PostgreSQL')
				myObj.setPostgreSQL(argumentCollection=stDSN);
		</cfscript>
	<!--- </cfif> --->
<cfelseif attributes.mod eq 'del'>
	<cfscript> 
		adminObj = createObject("component","cfide.adminapi.administrator"); 
		adminObj.login("#attributes.admin_password#");
		
		myObj = createObject("component","cfide.adminapi.datasource"); 
		myObj.deleteDatasource("#attributes.dsn#");
	</cfscript>
</cfif>