<cfif isDefined('xml_control_del_seril_no') and xml_control_del_seril_no eq 1>
	<cfquery name="get_seri" datasource="#dsn3#">
        SELECT SERIAL_NO,GUARANTY_ID FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guaranty_id#">
    </cfquery>
    <cfquery name="get_other_Seri" datasource="#dsn3#">
        SELECT 
        	TOP 1 GUARANTY_ID 
        FROM 
        	SERVICE_GUARANTY_NEW 
        WHERE 
        	SERIAL_NO = '#get_seri.SERIAL_NO#' 
       ORDER BY GUARANTY_ID DESC
    </cfquery>
    <cfif get_seri.GUARANTY_ID neq get_other_Seri.GUARANTY_ID>
    	<script type="text/javascript">
			alert("Seriyi Girilen Son Belgeden İtibaren Silebilirsiniz.");
			window.location.reload()
		</script>
        <cfabort>
    <cfelse>
    	<cfquery name="RECORD_DEL_FROM_SGN" datasource="#DSN3#">
            DELETE FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guaranty_id#">
        </cfquery>
        <script type="text/javascript">
			window.location.reload()
		</script>
    </cfif>
<cfelse>	
    <cfif isdefined("attributes.process_cat") and listfind("81,811,113",attributes.process_cat)>
        <cfloop list="#valueList(GET_SERIAL_INFO_ADD.GUARANTY_ID)#" index="item">
            <cfquery name="get_seri" datasource="#dsn3#">
                SELECT SERIAL_NO,PROCESS_CAT,PERIOD_ID,PROCESS_ID,IN_OUT FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#item#">
            </cfquery>
            <cfquery name="get_other_Seri" datasource="#dsn3#">
                SELECT 
                    GUARANTY_ID 
                FROM 
                    SERVICE_GUARANTY_NEW 
                WHERE 
                    SERIAL_NO = '#get_seri.SERIAL_NO#' 
                    AND PROCESS_CAT = #get_seri.PROCESS_CAT# 
                    AND PERIOD_ID = #get_seri.PERIOD_ID# 
                    AND PROCESS_ID = #get_seri.PROCESS_ID# 
                    --AND IN_OUT <> #get_seri.IN_OUT#  
            </cfquery>
            <cfif get_other_Seri.recordcount>
                <cfquery name="del_other_seri" datasource="#dsn3#">
                    DELETE FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_other_Seri.guaranty_id#">
                </cfquery>
            </cfif>
        </cfloop>
    </cfif>
    <cfquery name="RECORD_DEL_FROM_SGN" datasource="#DSN3#">
        DELETE FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guaranty_id#">
    </cfquery>
</cfif>
