<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
		
	<cfargument name="other_parameters" default="">
	<cfset parameter_name_list = ''>
	<cfset parameter_value_list = ''>
	
	<cfif len(arguments.other_parameters)>
		<cfloop list="#arguments.other_parameters#" delimiters="/" index="opind">
			<cfset parameter_name_list = listappend(parameter_name_list,ListGetAt(opind,1,'*'))>
			<cfif listlen(opind,'*') eq 2>
				<cfset parameter_value_list = listappend(parameter_value_list,ListGetAt(opind,2,'*'))>
			<cfelse>
				<cfset parameter_value_list = listappend(parameter_value_list,'*-*')>
			</cfif>
		</cfloop>
	</cfif>
		
        <cfquery name="getProductModel_" datasource="#dsn#_product">
           SELECT
                MODEL_ID,
                MODEL_NAME,
				MODEL_CODE
            FROM
                PRODUCT_BRANDS_MODEL
            WHERE
              	<cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'brand_id')>
					<cfset sira_ = listfindnocase(parameter_name_list,'brand_id')>
					<cfset deger_ = listgetat(parameter_value_list,sira_)>
					BRAND_ID = #deger_# AND
				</cfif>
				MODEL_NAME LIKE '%#arguments.keyword#%'
            ORDER BY 
				MODEL_NAME
        </cfquery>
        <cfreturn getProductModel_>
    </cffunction>
</cfcomponent>

