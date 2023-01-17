<cfcomponent displayname="Application" output="true">	
	<cfscript>
		this.name = hash(getCurrentTemplatePath()) & 'WORKCUBE';
        this.version = '1.0.0';
		this.sessionManagement = True;
		this.sessionTimeout = CreateTimeSpan(0,2,0,0);
		this.clientManagement = True;
		this.setClientCookies = True;
		this.secureJSON = True;
		this.secureJSONPrefix = "//";
        this.customtagpaths = '';
        this.currentPath = replace(replace(getDirectoryFromPath( getCurrentTemplatePath() ),'\','/','all'), "/WBP/Whops/files/", "/");
        this.customtagpaths = this.currentPath & "CustomTags";

		mappingname = "/workcube";/* W3 main */
		mappingpath = replace(replace(getDirectoryFromPath( getCurrentTemplatePath() ),"\","/","all"), "/WBP/Whops/files/", "");
		mappingnV16 = "/V16";/* W3 v16 dizini */
		mappingpathV16 = replace(replace(getDirectoryFromPath( getCurrentTemplatePath() ),"\","/","all"), "/WBP/Whops/files/", "/V16");
        
        this.mappings = StructNew();
    	this.mappings[mappingname] = mappingpath;
		this.mappings[mappingnV16] = mappingpathV16;
		
    </cfscript>
    
	<!--- Sayfa request özellikleri --->
	<cfsetting requesttimeout="99999" showdebugoutput="false" enablecfoutputonly="false" />
	<!------------------------ on Application Start -------------------------
        Functions:params, langs, functions
	------------------------------------------------------------------------>
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="The codes that will be run once at the time the application starts.">
		
        <cfscript>
            application.serviceManager = new workcube.WMO.Services.ApplicationServiceManager();
            application.serviceManager.initialize( ApplicationVariableScope: variables );
            application.serviceManager.ConfigurationService.RegisterComponentConfiguration( "workcube.WMO.params" );
			application.serviceManager.Register( "workcube.WMO.Services.V16CompatibilityService" );
			systemObjects = createObject("component", "workcube.WMO.objects");
			systemObjects.workcubeObjects('#application.systemparam.DSN#');
			systemObjects.parametricObjects('#application.systemparam.DSN#');
			systemObjects.parametricObjectsSystem('#application.systemparam.DSN#');
			langSet = createObject("component", "workcube.WMO.langs").langSet('#application.systemparam.dsn#');
			application.functions = createObject("component", "workcube.WMO.functions");
			application.GeneralFunctions = createObject("component", "workcube.WMO.GeneralFunctions");
			application.faFunctions = createObject("component", "workcube.cfc.faFunctions");
			application.mmFunctions = createObject("component", "workcube.cfc.mmFunctions");

			return true;
        </cfscript>
	</cffunction>
	<cffunction name="onRequest" returnType="void">
		<cfargument name="targetPage" type="string" required="true" />
		<cfif isdefined("url.heart") and url.heart eq "restart">
			heart start....
			<cfset OnApplicationStart()>
		<cfelse>
			<cfinclude  template = "index.cfm" />
			<cfinclude template = "app.cfm" />
		</cfif>
	</cffunction>
	<cffunction name="OnError" access="public" returntype="void" output="true" hint="Hataları raporlar.">
		<cfargument name="Exception" type="any" required="true" />
        <cfargument name="EventName" type="string" required="false" default=""/>

        <cfdump var="#arguments.Exception#" abort>
        
        <cfreturn/>
          
    </cffunction>
</cfcomponent>