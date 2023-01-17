<cfif isdefined("attributes.p_order_id")>
	<cfscript>
		related_production_list=attributes.p_order_id;
		function WriteRelatedProduction(P_ORDER_ID)
			{
				var i = 1;
				QueryText = '
						SELECT 
							P_ORDER_ID
						FROM 
							PRODUCTION_ORDERS
						WHERE 
							PO_RELATED_ID = #P_ORDER_ID#';
				'GET_RELATED_PRODUCTION#P_ORDER_ID#' = cfquery(SQLString : QueryText, Datasource : dsn3);
				if(Evaluate('GET_RELATED_PRODUCTION#P_ORDER_ID#').recordcount) 
				{
					for(i=1;i lte Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").recordcount;i=i+1)
					{
						related_production_list = ListAppend(related_production_list,Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i],',');
						WriteRelatedProduction(Evaluate("GET_RELATED_PRODUCTION#P_ORDER_ID#").P_ORDER_ID[i]);
					}
				}
			}
		WriteRelatedProduction(attributes.p_order_id);
	</cfscript>
	<cfset attributes.p_order_id = related_production_list>
    <cfquery name="GET_RELATED_PRODUCTION_RESULT" datasource="#dsn3#">
        SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE P_ORDER_ID IN (#attributes.p_order_id#)
    </cfquery>
    <cfif GET_RELATED_PRODUCTION_RESULT.recordcount>
        <script type="text/javascript">
            alert("<cf_get_lang no ='633.Bu Üretim Emrinin İlişkili Olduğu Üretimlerden Sonuç Girilenler Var,Öncelikle İlişkili Üretim Emirlerinin Sonuçlarını Siliniz'>!");
            history.go(-1);
        </script>
        <cfabort>
    </cfif>
	<cfquery name="get_process" datasource="#dsn3#">
		SELECT P_ORDER_NO, PROD_ORDER_STAGE FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN(#attributes.p_order_id#)
	</cfquery>
    <cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="DEL_ROW" datasource="#dsn3#">
				DELETE FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDER_ID IN(#attributes.p_order_id#)
			</cfquery>        
			<cfquery name="DEL_PROD_ORDER" datasource="#dsn3#">
				DELETE FROM PRODUCTION_OPERATION WHERE P_ORDER_ID IN(#attributes.p_order_id#)
			</cfquery>
			<cfquery name="DEL_PROD_ORDER" datasource="#dsn3#">
				DELETE FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN(#attributes.p_order_id#)
			</cfquery>
			<cfquery name="DEL_PROD_ORDER_STOCKS" datasource="#dsn3#">
				DELETE FROM PRODUCTION_ORDERS_STOCKS WHERE P_ORDER_ID IN(#attributes.p_order_id#)
			</cfquery>
            <cfif isdefined("attributes.is_generate_serial_nos") and attributes.is_generate_serial_nos eq 1>
            	<cfquery name="dlt_seri" datasource="#dsn3#">
                    DELETE FROM SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #ListGetAt(attributes.p_order_id,1,',')# AND PROCESS_CAT = 1194
                </cfquery>
            </cfif>
			<cfloop from="1" to="#ListLen(attributes.p_order_id,',')#" index="por">
				<cf_add_log  log_type="-1" action_id="#ListGetAt(attributes.p_order_id,por,',')#" action_name="#attributes.name#" paper_no="#get_process.p_order_no#" process_stage="#get_process.PROD_ORDER_STAGE#" data_source="#dsn3#">
			</cfloop>
		</cftransaction>
    </cflock>
</cfif>
<script type="text/javascript">
	<cfif isdefined('attributes.PO_RELATED_ID') and len(attributes.PO_RELATED_ID)><!--- Silinen üretimin üst üretim emri varsa üst üretim emrine yönlendirme yapılıyor --->
		window.location.href="<cfoutput>#request.self#?fuseaction=prod.order&event=upd&upd=#attributes.PO_RELATED_ID#</cfoutput>";
	<cfelse>
		window.location.href="<cfoutput>#request.self#?fuseaction=prod.order</cfoutput>";
	</cfif>
</script>