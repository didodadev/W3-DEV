<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="production.welcome">
	<cfif isdefined("is_show_menu") and is_show_menu eq 1>
    	<cfquery name="get_company_logo" datasource="#dsn#">
			SELECT * FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
    <cfelse>
        <cfparam name="attributes.is_submitted" default="">
        <cfparam name="attributes.station_id" default="">
        <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
            <cf_date tarih='attributes.start_date'>
        <cfelse>
            <cfset attributes.start_date= wrk_get_today()>
        </cfif>
        <cfquery name="GET_W" datasource="#dsn3#">
            SELECT 
                * 
            FROM 
                WORKSTATIONS W
            WHERE 
                W.DEPARTMENT = #listgetat(session.ep.user_location,1,'-')#
            ORDER BY 
                STATION_NAME
        </cfquery>
        <cfif len(attributes.is_submitted)>
            <cfquery name="get_production_orders_lots" datasource="#dsn3#">
                SELECT
                    CAST(COUNT(LOT_NO) AS NVARCHAR(2500)) AS TOPLU_URETIM,
                    LOT_NO,
                    START_DATE,
                    FINISH_DATE,
                    DETAIL,
                    STATION_ID,
                    IS_STAGE
                FROM
                    PRODUCTION_ORDERS
                WHERE
                    1=1
                    <cfif len(attributes.station_id)>
                        AND STATION_ID = #attributes.station_id#
                    </cfif>
                    <cfif len(attributes.start_date) and isdate(start_date)>
                        AND START_DATE >= #DATEADD('D',-1,CreateODBCDateTime(attributes.start_date))#
                        AND START_DATE <= #DATEADD('D',1,CreateODBCDateTime(attributes.start_date))#
                    </cfif>                  
                    AND IS_GROUP_LOT = 1
                    AND IS_STAGE IS NOT NULL
                GROUP BY
                    LOT_NO,
                    START_DATE,
                    FINISH_DATE,
                    DETAIL,
                    STATION_ID,
                    IS_STAGE
                UNION ALL
                SELECT
                    P_ORDER_NO AS TOPLU_URETIM,
                    LOT_NO,
                    START_DATE,
                    FINISH_DATE,
                    DETAIL,
                    STATION_ID,
                    IS_STAGE
                FROM
                    PRODUCTION_ORDERS
                WHERE
                    1=1
                    <cfif len(attributes.station_id)>
                        AND STATION_ID = #attributes.station_id#
                    </cfif>
                    <cfif len(attributes.start_date) and isdate(start_date)>
                        AND START_DATE >= #DATEADD('D',-1,CreateODBCDateTime(attributes.start_date))#
                        AND START_DATE <= #DATEADD('D',1,CreateODBCDateTime(attributes.start_date))#
                    </cfif>
                    AND IS_GROUP_LOT = 0
                    AND IS_STAGE IS NOT NULL  
            </cfquery>
        </cfif>
     </cfif>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isdefined("is_show_menu") and is_show_menu eq 1>
    <cfelse>
		<script language="javascript" type="text/javascript">		
            $( document ).ready(function() {
                document.getElementById('lot_number').value="";
                document.getElementById('lot_number').focus();
            });
        </script>
        <script type="text/javascript">
            function location_production_detail(lot_no)
            {
                if(document.getElementById(lot_no))
                    window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=production.order_operator"+document.getElementById(lot_no).value+""
                else
                    alert("<cf_get_lang no='3.Lot No İle Uyuşan Üretim Yok'>!");	
            }
        </script>
     </cfif>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'production.welcome';
	if (isdefined("is_show_menu") and is_show_menu eq 1)
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production/display/production_menu.cfm';
	else
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production/display/list_production_orders_lot.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
		
</cfscript>
