<cfsetting showdebugoutput="no">
<cfset attributes.serial_nos = "">
<cfif isdefined("attributes.all_delete") and attributes.all_delete eq 1>
	<cfif isDefined('xml_control_del_seril_no') and xml_control_del_seril_no eq 1>
        <cfquery name="get_seri" datasource="#dsn3#">
            SELECT 
                SERIAL_NO,GUARANTY_ID 
            FROM 
                SERVICE_GUARANTY_NEW 
            WHERE 
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
                <cfif len(attributes.process_id)>
                    PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
                <cfelse>
                    PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_number#"> AND
                </cfif>
                <cfif isDefined('session.ep.userid')>
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                <cfelseif isDefined('session.pp.userid')>
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
                </cfif>
				WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.wrk_row_id#"> AND
                PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
        </cfquery>
        <cfloop query="get_seri">
            <cfquery name="get_other_Seri" datasource="#dsn3#">
                SELECT 
                    TOP 1 GUARANTY_ID 
                FROM 
                    SERVICE_GUARANTY_NEW 
                WHERE 
                    SERIAL_NO = '#get_seri.SERIAL_NO#' 
               ORDER BY GUARANTY_ID DESC
            </cfquery>
        </cfloop>
        <cfif get_seri.GUARANTY_ID neq get_other_Seri.GUARANTY_ID>
            <script type="text/javascript">
                alert("Seriyi Girilen Son Belgeden İtibaren Silebilirsiniz.");
                window.close();
            </script>
            <cfabort>
        <cfelse>
            <cfquery name="DEL_SERIAL_INFO" datasource="#DSN3#">
                DELETE FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
                    <cfif len(attributes.process_id)>
                        PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
                    <cfelse>
                        PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_number#"> AND
                    </cfif>
                    <cfif isDefined('session.ep.userid')>
                        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                    <cfelseif isDefined('session.pp.userid')>
                        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
                    </cfif>
                    PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"> AND
					WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.wrk_row_id#">
            </cfquery>
            <script type="text/javascript">
                <cfif not isdefined("attributes.is_line")>
					location.href = document.referrer;
					<cfelse>
						window.close();
                </cfif>
            </script>
        </cfif>
    <cfelse>
     	<cfquery name="DEL_SERIAL_INFO" datasource="#DSN3#">
                DELETE FROM
                    SERVICE_GUARANTY_NEW
                WHERE
                    STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
                    <cfif len(attributes.process_id)>
                        PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
                    <cfelse>
                        PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_number#"> AND
                    </cfif>
                    <cfif isDefined('session.ep.userid')>
                        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                    <cfelseif isDefined('session.pp.userid')>
                        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
                    </cfif>
                    PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"> AND
					WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.wrk_row_id#">
            </cfquery>
    	<script type="text/javascript">
                <cfif not isdefined("attributes.is_line")>
					location.href = document.referrer;
					<cfelse>
					window.close();
                </cfif>
			</script> 
    </cfif>
<cfelseif isdefined("attributes.is_only_one") and attributes.is_only_one eq 1>
	<cfif len(attributes.seri_no) and attributes.sale_product eq 0>
		<cfquery name="SERINO_CONTROL_ALIS" datasource="#DSN3#">
			SELECT
				GUARANTY_ID
                IS_PURCHASE
			FROM
				SERVICE_GUARANTY_NEW
			WHERE
				STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
				SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#seri_no#"> AND
				GUARANTY_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guaranty_id#">
            ORDER BY GUARANTY_ID DESC
		</cfquery>
		<cfif serino_control_alis.recordcount and SERINO_CONTROL_ALIS.IS_PURCHASE EQ 1>
			<script type="text/javascript">
				info_alani.innerHTML = '<b><cfoutput>#attributes.satir_#</cfoutput>. satır seri işlemi :</b> <font color="red">Güncellenemedi! - <b><cfoutput>#seri_no#</cfoutput> için daha önce alış işlemi yapılmış!</b></font>';
				document.add_guaranty.start_no_<cfoutput>#attributes.satir_#</cfoutput>.value = '<cfoutput>#attributes.old_seri_no#</cfoutput>';
				document.add_guaranty.lot_no_<cfoutput>#attributes.satir_#</cfoutput>.value = '<cfoutput>#attributes.old_lot_no#</cfoutput>';
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfquery name="UPDATE_SERIAL_INFO" datasource="#DSN3#">
		UPDATE
			SERVICE_GUARANTY_NEW
		SET
			<cfif isdefined("attributes.rma_no")>
				RMA_NO = '#attributes.rma_no#',
			</cfif>
            <cfif isdefined("attributes.reference_no")>
				REFERENCE_NO = '#attributes.reference_no#',
			</cfif> 
			<cfif isdefined("attributes.unit_row_quantity")>
				UNIT_ROW_QUANTITY = #attributes.unit_row_quantity#,
			</cfif>
			SERIAL_NO = '#attributes.seri_no#',
			LOT_NO = '#attributes.lot_no#'
		WHERE
			GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guaranty_id#">
	</cfquery>
	<script type="text/javascript">
		info_alani.innerHTML = '<b><cfoutput>#attributes.satir_#</cfoutput>. satır seri işlemi :</b> <font color="red">Güncellendi!</font>';
	</script>
<cfelseif isdefined("form.start_no")>
	<cfloop from="1" to="#ListLen(form.start_no)#" index="i">
		<cfset seri_no = ListGetAt(form.start_no,i,",")>
		<cfset old_seri_no = ListGetAt(form.old_start_no,i,",")>		
		<cfif old_seri_no neq seri_no>
			<cfquery name="SERINO_CONTROL_ALIS" datasource="#DSN3#">
				SELECT
					GUARANTY_ID
				FROM
					SERVICE_GUARANTY_NEW
				WHERE
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
					SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#seri_no#"> AND
					IS_PURCHASE = 1
			</cfquery>			
			<cfif (attributes.sale_product eq 0) and (serino_control_alis.recordcount)>
				<script type="text/javascript">
					alert("<cfoutput>#seri_no#</cfoutput> için daha önce alış işlemi yapılmış!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
		<cfif not listfind(attributes.serial_nos,seri_no,',')>
			<cfset attributes.serial_nos = listappend(attributes.serial_nos,seri_no, ',')>
		</cfif>
	</cfloop>
	<cfloop from="1" to="#attributes.serial_rows_#" index="i">
		<cfif isDefined('attributes.is_active_#i#')>
			<cfif evaluate("attributes.is_active_#i#") eq 1>
				<cfquery name="UPDATE_SERIAL_INFO" datasource="#DSN3#">
					UPDATE
						SERVICE_GUARANTY_NEW
					SET
						SERIAL_NO = '#ListGetAt(attributes.start_no,i)#',
						LOT_NO = '#wrk_eval("attributes.lot_no_#i#")#'
					WHERE
						GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.guaranty_id_#i#")#">
				</cfquery>
			<cfelse>
				<cfquery name="DEL_SERIAL_INFO" datasource="#DSN3#">
					DELETE FROM
						SERVICE_GUARANTY_NEW
					WHERE
						GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.guaranty_id_#i#")#">
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<script type="text/javascript">
		<cfif not isdefined("attributes.is_line")>
			location.href = document.referrer;
			<cfelse>
				window.close();
		</cfif>
	</script>
<!--- Satırlardaki 2. miktar update ERU--->
<cfelseif isdefined("attributes.unit_row_quantity") and attributes.unit_row_quantity eq 1>
	<cfloop from="1" to="#attributes.serial_rows_#" index="i">
		<cfif isDefined('attributes.UNIT_ROW_QUANTITY_#i#')>
			<cfquery name="UPDATE_SERIAL_INFO" datasource="#DSN3#">
				UPDATE
					SERVICE_GUARANTY_NEW
				SET
					UNIT_ROW_QUANTITY = <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.UNIT_ROW_QUANTITY_#i#')#">			
				WHERE
					GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.guaranty_id_#i#")#">
			</cfquery>
		</cfif>
	</cfloop>
	<script type="text/javascript">
	<cfif not isdefined("attributes.is_line")>
		location.reload();
			<cfelse>
			window.close();
		</cfif>
	</script>
<cfelse>
	<cfquery name="DEL_SERIAL_INFO" datasource="#DSN3#">
		DELETE FROM
			SERVICE_GUARANTY_NEW
		WHERE
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
			<cfif len(attributes.process_id)>
				PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
			<cfelse>
				PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_number#"> AND
			</cfif>
            <cfif isDefined('session.ep.userid')>
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
            <cfelseif isDefined('session.pp.userid')>
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
			</cfif>
			PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
	</cfquery>
	<script type="text/javascript">
		<cfif not isdefined("attributes.is_line")>
			location.reload();
			<cfelse>
			window.close();
		</cfif>
	</script>
</cfif>