<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
    <cf_date tarih = "attributes.start_date">
    <cfset attributes.start_date = dateadd("n",attributes.start_m,dateadd("h",attributes.start_h ,attributes.start_date))>
<cfelse>
    <cfset attributes.start_date =''>
</cfif>
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
    <cf_date tarih = "attributes.finish_date">
    <cfset attributes.finish_date = dateadd("n",attributes.finish_m,dateadd("h",attributes.finish_h ,attributes.finish_date))>
<cfelse>
    <cfset attributes.finish_date =''>
</cfif>
<cflock name="#CREATEUUID()#" timeout="90">
	<cftransaction>
		<cfquery name="upd_master_plan" datasource="#dsn3#">
			UPDATE  
          		EZGI_IFLOW_MASTER_PLAN
          	SET
            	GROSSTOTAL = #attributes.ara_stok#,
				MASTER_PLAN_START_DATE = #attributes.start_date#,
				MASTER_PLAN_FINISH_DATE = #attributes.finish_date#,
				MASTER_PLAN_DETAIL = <cfif isdefined('attributes.detail') and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>, 
				MASTER_PLAN_STATUS = <cfif isdefined('attributes.master_plan_status') and len(attributes.master_plan_status)>#attributes.master_plan_status#<cfelse>0</cfif>, 
				MASTER_PLAN_STAGE = #attributes.process_stage#,
				UPDATE_EMP = #session.ep.userid#, 
				UPDATE_IP = '#cgi.remote_addr#', 
				UPDATE_DATE = #now()#				
          	WHERE
            	MASTER_PLAN_ID = #attributes.master_plan_id#
		</cfquery>
        <cfquery name="get_master_plan" datasource="#dsn3#">
        	SELECT IFLOW_P_ORDER_ID FROM EZGI_IFLOW_PRODUCTION_ORDERS WHERE MASTER_PLAN_ID = #attributes.master_plan_id#
        </cfquery>
        <cfif get_master_plan.recordcount>
        	<cfset tur = get_master_plan.recordcount>
            <cfset satirlar = queryNew("id, old_currentrow, new_currentrow","integer, integer, integer") />
            <cfloop from="1" to="#tur#" index="i">
            	<cfloop query="get_master_plan">
                	<cfif isdefined('sira_#i#_#get_master_plan.IFLOW_P_ORDER_ID#')>
						<cfset Temp = QueryAddRow(satirlar)>
                        <cfset Temp = QuerySetCell(satirlar, "id",get_master_plan.IFLOW_P_ORDER_ID)>
                        <cfset Temp = QuerySetCell(satirlar, "old_currentrow",i)>
                        <cfset Temp = QuerySetCell(satirlar, "new_currentrow",Evaluate('sira_#i#_#get_master_plan.IFLOW_P_ORDER_ID#'))>
                    </cfif>
                </cfloop>
            </cfloop>
            <cfquery name="satirlar" dbtype="query">
            	SELECT * FROM satirlar ORDER BY new_currentrow
            </cfquery>
            <cfloop query="satirlar">
            	<cfquery name="upd_prod_order" datasource="#dsn3#">
                	UPDATE       
                    	EZGI_IFLOW_PRODUCTION_ORDERS
					SET                
                    	DP_ORDER_ID = #satirlar.currentrow#
					WHERE        
                    	MASTER_PLAN_ID = #attributes.master_plan_id# AND 
                        IFLOW_P_ORDER_ID = #satirlar.id#
                </cfquery>
            </cfloop>
        </cfif>
 	</cftransaction>
</cflock>
<cfinclude template="upd_ezgi_iflow_master_plan_operation.cfm">
<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_iflow_master_plan&master_plan_id=#attributes.master_plan_id#" addtoken="no">
