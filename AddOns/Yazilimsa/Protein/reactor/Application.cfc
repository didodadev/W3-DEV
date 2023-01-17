<cfcomponent displayname="Application" output="true">	
	<cfset this.name = 'PROTEIN'>
	<cfset this.version = '1.0.0'>
	<cfset this.sessionManagement = True>
	<cfset this.sessionTimeout = CreateTimeSpan(0,2,0,0)>
	<cfset this.setClientCookies = True>
	<cfset this.secureJSON = True>
	<cfset this.secureJSONPrefix = "//">	
	<cfscript>
		this.currentPath = getDirectoryFromPath( getCurrentTemplatePath() );
		this.customtagpaths = this.currentPath & "CustomTags";
		THIS.mappings = StructNew();

		/* windows maping 
		mappingname = "/catalyst";
		mappingpath = replace(getDirectoryFromPath( getCurrentTemplatePath() ), "\AddOns\Yazilimsa\Protein\reactor\", "");
		mappingnV16 = "/V16";
		mappingpathV16 = replace(getDirectoryFromPath( getCurrentTemplatePath() ), "\AddOns\Yazilimsa\Protein\reactor\", "\V16");
		*/
		/* linux */
		mappingname = "/catalyst";
		mappingpath = "/var/www/networg/public_html/";
		mappingnV16 = "/V16";
		mappingpathV16 = "/var/www/networg/public_html/V16/";
		

    	THIS.mappings[mappingname] = mappingpath;
		THIS.mappings[mappingnV16] = mappingpathV16;
	</cfscript>
	<!--- Sayfa request özellikleri --->
	<cfsetting requesttimeout="99999" showdebugoutput="false" enablecfoutputonly="false" />
	<!------------------------ on Application Start -------------------------
        Functions:params, langs, functions, protein
	------------------------------------------------------------------------>
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="The codes that will be run once at the time the application starts.">
		<cfscript>
            application.serviceManager = new WMO.Services.ApplicationServiceManager();
            application.serviceManager.initialize( ApplicationVariableScope: variables );
            application.serviceManager.ConfigurationService.RegisterComponentConfiguration( "WMO.params" );
			application.serviceManager.Register( "WMO.Services.V16CompatibilityService" );
			
		</cfscript>
			<cfset application.langSet = createObject("component", "WMO.langs")>
			<cfset structAppend(variables,application.langSet.langSet('#application.systemparam.DSN#'))/>
			<!---<cfset application.functions = createObject("component", "WMO.functions")>
			<cfset structAppend(variables,application.functions)/>			
			 <cfset application.faFunctions = createObject("component", "cfc.faFunctions")>
			<cfset structAppend(variables,application.faFunctions)/>
			<cfset application.hrFunctions = createObject("component", "cfc.hrFunctions")>
			<cfset structAppend(variables,application.hrFunctions)/>
			<cfset application.sdFunctions = createObject("component", "cfc.sdFunctions")>
			<cfset structAppend(variables,application.sdFunctions)/>
			<cfset application.mmFunctions = createObject("component", "cfc.mmFunctions")>
			<cfset structAppend(variables,application.mmFunctions)/>
			<cfset application.GeneralFunctions = createObject("component", "WMO.GeneralFunctions")>
			<cfset structAppend(variables,application.GeneralFunctions)/> --->
			
		<cfreturn true />
	</cffunction>
	<cffunction name="onRequest" returnType="void">
		<cfif isdefined("url.heart") and url.heart eq "restart">
			heart start....
			<cfset applicationStop()>
		<cfelse>
			
			<!--- Sanal poslarda threeDGate token varsa sessionu bu token ile diriltir. Sanal poslarda return url e eklenmesi yeterlidir. --->
			<cfif isDefined('url.threeDGate') and len(url.threeDGate)>
				<cfset METHODS = createObject('component','cfc.SYSTEM.LOGIN')>
				<cfset threeDGateLogın = METHODS.LOGIN_threeDGate(threeDGate:url.threeDGate)>
			</cfif>		
				
			<cfset http_status = cgi.HTTPS eq 'on' ? "https://" : "http://">
			<cfset moneyformat_style = 1> 
			
			<cfset SESSION_SERVICE = createObject('component','cfc.SYSTEM.SESSIONS')>

			<!--- Online ödeme dönüşlerinde session kaybolduğundan session_storage dosyasından okuyarak tekrar sessiona doldurur --->
			<cfif isDefined("url.pc") and len(url.pc)>
				<cfset upload_folder = application.systemParam.systemParam().upload_folder />
				<cfif fileExists("#upload_folder#session_storage/#url.pc#.json")>
					<cffile action = "read" file = "#upload_folder#session_storage/#url.pc#.json" variable = "session_storage" charset = "utf-8">
					<cfset session = structAppend(session, deserializeJson( session_storage )) />
					<cfloop list="#session.urltoken#" item="item" delimiters="&">
						<cfset "#listFirst(item,'=')#" = listLast(item,'=') />
					</cfloop>
					<cfset SESSION_SERVICE.UPDATE_SESSION( token: cftoken, id: cfid ) />
					<cfif not (isDefined("session.pp") and isDefined("session.ww"))>
						<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#url.pc#" expires="1">
					</cfif>
				</cfif>
			</cfif>

			<cfset GET_SESSION = SESSION_SERVICE.GET_SESSION()>
			
			<!--- Kullanıcı yaşam belirtisi varsa session tablosunda güncelleme yap--->
			<cfset SIGN_OF_LIFE = SESSION_SERVICE.SIGN_OF_LIFE_UPDATE()>

			<cfif structKeyExists(session, "qq") EQ false>
				<cfset GET_BASE_SESSION = SESSION_SERVICE.GET_BASE_SESSION()>
				<cfif not isdefined('session_base')>
					<cfset session_base = GET_BASE_SESSION>
					<cfset session.qq = GET_BASE_SESSION>
				</cfif>
			</cfif>
			<cfset application.functions = createObject("component", "WMO.functions")>
			<cfset structAppend(variables,application.functions)/>
			<cfset application.protein_functions = createObject("component", "cfc.SYSTEM.PROTEIN_FUNCTIONS")>
			<cfset structAppend(variables,application.protein_functions)/>
			<cfset application.GeneralFunctions = createObject("component", "WMO.GeneralFunctions")>
			<cfset structAppend(variables,application.GeneralFunctions)/>
			<cfset application.faFunctions = createObject("component", "WMO.faFunctions")>
			<cfset structAppend(variables,application.faFunctions)/>	
			<cfinclude  template="home.cfm">
		</cfif>
	</cffunction>
</cfcomponent>