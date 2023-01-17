<!--- 
	Amaç            : Şube id verilerek şube ye bağlı departmanlara ulaşılabilir..
	parametre adi   : branch_id_
		ayirma isareti  : 
		kac parametreli : 1
		1. parametre: Branch_Id
	kullanim        : 
	Yazan           : Cengiz Hark
	Tarih           : 05.03.2008
	Guncelleme      :  
 --->
<cffunction name="get_department" access="public" returnType="query" output="no">
	<cfargument name="department_head" required="yes" type="string">
	<cfquery name="get_department" datasource="#dsn#">
		SELECT 
			DEPARTMENT_HEAD,
			DEPARTMENT_ID
		FROM 
			DEPARTMENT
		WHERE 
			DEPARTMENT_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.department_head#">
	</cfquery>
	<cfreturn get_department>
</cffunction>
	
