<cfloop list="#attributes.invoice_row_list#" index="i">
	<cfif isdefined("attributes.is_check#i#")>
		<cfquery name="KONTROL_" datasource="#DSN3#">
			SELECT 
				SUM(AMOUNT) AS TOTAL_AMOUNT
			FROM 
				SERVICE_PROD_RETURN_ROWS SPRR,
				SERVICE_PROD_RETURN SPR 
			WHERE 
				SPRR.RETURN_ID = SPR.RETURN_ID AND 
				SPR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND
				SPR.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#"> AND
				SPRR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.stock_id#i#')#">
		</cfquery>
		<cfif kontrol_.recordcount and len(kontrol_.total_amount)>
			<cfset my_sayi_ = kontrol_.total_amount + evaluate('amount#i#')>
			<cfif my_sayi_ gt evaluate('invoice_amount#i#')>
				<script type="text/javascript">
					alert("<cf_get_lang no ='1502.İade etmek istediğiniz miktar alışınızdan fazla Veya daha önce iade başvurusu yapmışsınız'>!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
</cfloop>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
        <cfquery name="ADD_RETURN" datasource="#DSN3#">
            INSERT INTO
                SERVICE_PROD_RETURN
                (
                    INVOICE_ID,
                    PAPER_NO,
                    PERIOD_ID,
                    RETURN_TYPE,
                    SERVICE_COMPANY_ID,
                    SERVICE_PARTNER_ID,
                    SERVICE_CONSUMER_ID,				
                    RECORD_PAR,
                    RECORD_CONS,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    #attributes.invoice_id#,
                    '#attributes.paper_no#',
                    #attributes.period_id#,
                    <cfif isdefined("attributes.return_type") and len(attributes.return_type)>#attributes.return_type#<cfelse>NULL</cfif>,
                    <cfif isdefined("session.pp.company_id")>#session.pp.company_id#,<cfelse>NULL,</cfif>
                    <cfif isdefined("session.pp.userid")>#session.pp.userid#,<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.consumer_id")>#attributes.consumer_id#<cfelseif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                    <cfif isdefined("session.pp.userid")>#session.pp.userid#,<cfelse>NULL,</cfif>
                    <cfif isdefined("session.ww.userid")>#session.ww.userid#,<cfelse>NULL,</cfif>
                    <cfif isdefined("session.ep.userid")>#session.ep.userid#,<cfelse>NULL,</cfif>
                    #now()#,
                    '#cgi.REMOTE_ADDR#'
                )
        </cfquery>
        <cfquery name="GET_MAX" datasource="#DSN3#">
            SELECT MAX(RETURN_ID) AS MAX_ID FROM SERVICE_PROD_RETURN
        </cfquery>
        <cfloop list="#attributes.invoice_row_list#" index="s_tr">
            <cfif isdefined("attributes.is_check#s_tr#")>
                <cfset detail_ = evaluate('attributes.detail#s_tr#')>
                <cfquery name="ADD_RETURN_ROWS" datasource="#DSN3#">
                    INSERT INTO
                        SERVICE_PROD_RETURN_ROWS
                        (
                            RETURN_ID,
                            STOCK_ID,
                            RETURN_TYPE,
                            DETAIL,
                            ACCESSORIES,
                            PACKAGE,
                            AMOUNT,
                            INVOICE_ROW_ID,
                            RETURN_STAGE,
                            WRK_ROW_ID
                        )
                        VALUES
                        (
                            #get_max.max_id#,
                            #evaluate('attributes.stock_id#s_tr#')#,
                            #evaluate('attributes.returncat#s_tr#')#,
                            '#detail_#',
                            <cfif isdefined("attributes.accessories#s_tr#")>#evaluate('attributes.accessories#s_tr#')#<cfelse>NULL</cfif>,
                            #evaluate('attributes.package#s_tr#')#,
                            #evaluate('attributes.amount#s_tr#')#,
                            #s_tr#,
                            #attributes.process_stage#,
                            #evaluate('attributes.amount#s_tr#')#
                        )
                </cfquery>
            </cfif>
        </cfloop>
	</cftransaction>
</cflock>
<cfif not isdefined("attributes.consumer_id")>
	<cfset attributes.consumer_id = ''>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	data_source='#dsn3#'
	process_stage='#attributes.process_stage#' 
	record_member='#session_base.userid#' 
	record_date='#now()#' 
	action_table='SERVICE_PROD_RETURN'
	action_column='RETURN_ID'
	action_id='#get_max.max_id#'
	action_page='#request.self#?fuseaction=service.popup_upd_product_return&return_id=#get_max.max_id#' 
	warning_description='İade : #get_max.max_id#'>
<cflocation url="#request.self#?fuseaction=objects2.upd_return&return_id=#get_max.max_id#" addtoken="No">
