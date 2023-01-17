<!--- 
	amac            : gelen DRUG_MEDICINE parametresine göre DRUG_ID,DRUG_MEDICINE bilgisini getirmek
	parametre adi   : DRUG_MEDICINE
	Yazan           : Melek KOCABEY
	Tarih           : 20192112
 --->
<cffunction name="Get_SetupMedicineDrug" access="public" returnType="query" output="no">
	<cfargument name="drug_medicine" required="yes" type="string">
		<cfquery name="Get_SetupMedicineDrug" datasource="#DSN#">
			SELECT
                DRUG_MEDICINE,
                DRUG_ID
			FROM
                SETUP_DECISIONMEDICINE
			WHERE
            	1=1 AND				
				DRUG_MEDICINE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.drug_medicine#%"> 
			ORDER BY
                DRUG_MEDICINE
		</cfquery>
	<cfreturn Get_SetupMedicineDrug>
</cffunction>
