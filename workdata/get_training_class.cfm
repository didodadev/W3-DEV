<!--- 
	amac            : gelen training_name parametresine göre CLASS_NAME,CLASS_ID bilgisini getirmek
	parametre adi   : training_class_name
	kullanim        : get_training_class 
 --->
<cffunction name="get_training_class" access="public" returnType="query" output="no">
	<cfargument name="training_class_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1"><!--- -1 (All) yerine kullanilabilir FBS --->
		<cfquery name="get_training_class_" datasource="#dsn#" maxrows="-1"><!--- maxrows="#arguments.maxrows#" --->
			SELECT
				CLASS_ID,
				CLASS_NAME
			FROM 
				TRAINING_CLASS
			WHERE
				CLASS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.training_class_name#%">
			ORDER BY CLASS_NAME
		</cfquery>
	<cfreturn get_training_class_>
</cffunction>
