<cfcomponent displayname="Application" output="true" hint="Uygulamayı yönetir.">	
	<cfscript>
		this.name = hash(getCurrentTemplatePath()) & 'WORKCUBE';
		this.sessionManagement = True;
		this.sessionTimeout = CreateTimeSpan(0,2,0,0);
		this.setClientCookies = True;
		this.clientManagement = True;
		this.secureJSON = "True";
		this.secureJSONPrefix = "//";
		customtagpaths_  = getDirectoryFromPath(getCurrentTemplatePath()) & "CustomTags";
		this.customtagpaths  = replace(customtagpaths_,'WBP/Retail/install/workcloud/','','all');
	</cfscript>
    
    <!--- Sayfa request özellikleri --->
	<cfsetting requesttimeout="99999" showdebugoutput="false" enablecfoutputonly="false" />
    
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="Uygulama başladığı anda çalıştırılacak kodlar. Tek defa çalıştırır.">
		<!--- Bu alanda özellikle Application scope tanımına ihtiyaç duyulacak kodlar gelecek. --->
		<cfreturn true />
	</cffunction>

	<cffunction name="OnSessionStart" access="public" returntype="void" output="false" hint="Kullanıcı oturumu başladığında çalıştırılacak kodlar.">
 		<!--- Bu alanda özellikle Session scope tanımına ihtiyaç duyulacak kodlar gelecek. --->
		<cfreturn />
	</cffunction>

	<!--- TODO: OnRequestStart sonradan kullanılacak. OD 20131123 --->
    <!--- 
	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false" hint="Fires at first part of page processing.">
		<cfargument name="TargetPage" type="string" required="true" />
 
		<cfreturn true />
	</cffunction>
	--->
    
	<cffunction name="onRequest" returnType="void">
		<cfargument name="targetPage" type="string" required="true" />
		<!--- 
			Eski Application.cfm 
			TODO: Zamanla Application.cfm içerisindeki ayarlar Application.CFC içerisine taşınıp bu satır kaldırılacak. 
		--->
		<cfinclude template="Application.cfm" />
		<cfinclude template="#ARGUMENTS.targetPage#" />
        <cfreturn />
	</cffunction>
    
	<cffunction name="OnRequestEnd" access="public" returntype="void" output="true" hint="Request sonrası çalışır.">
 		<cfreturn />
	</cffunction>
    
    <cffunction name="OnSessionEnd" access="public" returntype="void" output="false" hint="Session kapanırken çalışır.">
		<cfargument name="SessionScope" type="struct" required="true" />
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#"	/>
		<cfreturn />
	</cffunction>
     
	<cffunction name="OnApplicationEnd" access="public" returntype="void" output="false" hint="Uygulama sonlandığında çalışır.">
 		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" 	/>
		<cfreturn />
	</cffunction>
    
	<!--- TODO: onError kodu daha sonra aktif hale getirilecek.  --->
    <!--- 
    <cffunction name="OnError" access="public" returntype="void" output="true" hint="Hataları raporlar.">
		<cfargument name="Exception" type="any" required="true" />
 		<cfargument name="EventName" type="string" required="false" default="" 	/>
		<cfreturn />
	</cffunction>
	--->     
    
</cfcomponent>