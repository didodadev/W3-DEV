<cfsetting showdebugoutput="no">
<cfparam name="attributes.ref_company_id" default="">
<cfparam name="attributes.ref_partner_id" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>

<cfif isDefined('xml_order_type') and xml_order_type eq 1>
    <cfquery name="GET_EMPS" datasource="#DSN#">
            SELECT 
                EMPLOYEE_ID,
                POSITION_CODE
            FROM 
                EMPLOYEE_POSITIONS 
            WHERE 
                UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> 
        UNION 
            SELECT 
                EMPLOYEE_ID,
                POSITION_CODE
            FROM 
                EMPLOYEE_POSITIONS 
            WHERE 
                UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">         
    </cfquery>
</cfif>

<cfquery name="GET_ORDER" datasource="#DSN3#">
	SELECT
		ORDERS.ORDER_ID,
		ORDERS.PARTNER_ID,
		ORDERS.ORDER_HEAD,
		ORDERS.ORDER_DATE,
		C.FULLNAME
	FROM
		ORDERS,
		#dsn_alias#.COMPANY C,
        ORDER_ROW,
        STOCKS_BARCODES SB
       	<cfif isDefined('attributes.is_my') and attributes.is_my eq 1>
			,#dsn_alias#.WORKGROUP_EMP_PAR WEP
        </cfif>
	WHERE
		ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID AND
		ORDERS.PURCHASE_SALES = 1 AND
		SB.STOCK_ID = ORDER_ROW.STOCK_ID AND
        ORDERS.COMPANY_ID=C.COMPANY_ID 
        <cfif isDefined('attributes.is_my') and attributes.is_my eq 1>
			AND C.COMPANY_ID=WEP.COMPANY_ID 
        </cfif>
        <cfif isDefined('attributes.order_status') and len(attributes.order_status)>
        	AND ORDERS.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_status#">
        </cfif>
        <cfif isDefined('attributes.is_my') and attributes.is_my eq 1>
			<cfif isDefined('session.pda.admin') and isDefined('session.pda.power_user') and session.pda.admin eq 0 and session.pda.power_user eq 0>
                <cfif isDefined('attributes.my_members') and len(attributes.my_members)>
                    AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.my_members#">
                    AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.my_members#"> 			
                <cfelse>
                    AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
                    AND WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> ,
                </cfif>
            </cfif>
        </cfif>
		<cfif isDefined('attributes.ref_company_id') and len(attributes.ref_company_id)>
			AND 
			(
				ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ref_company_id#">
				<cfif isDefined('attributes.ref_partner_id') and len(attributes.ref_partner_id)>
					OR ORDERS.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ref_partner_id#">
				</cfif>
			)
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND ORDERS.ORDER_DATE >= #attributes.start_date#
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			AND ORDERS.ORDER_DATE <= #attributes.finish_date#
		</cfif>
        <cfif isDefined('get_emps') and get_emps.recordcount>
            SELECT
                ORDERS.ORDER_ID,
                ORDERS.PARTNER_ID,
                ORDERS.ORDER_HEAD,
                ORDERS.ORDER_DATE,
                C.FULLNAME
            FROM
                ORDERS,
                #dsn_alias#.COMPANY C,
                ORDER_ROW,
                STOCKS_BARCODES SB
        		<cfif isDefined('attributes.is_my') and attributes.is_my eq 1>                
                	,#dsn_alias#.WORKGROUP_EMP_PAR WEP
            	</cfif>
            WHERE
                ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID AND
                SB.STOCK_ID = ORDER_ROW.STOCK_ID AND
                ORDERS.COMPANY_ID=C.COMPANY_ID AND
        		<cfif isDefined('attributes.is_my') and attributes.is_my eq 1>    
                	C.COMPANY_ID=WEP.COMPANY_ID 
                </cfif>
        		<cfif isDefined('attributes.is_my') and attributes.is_my eq 1>  
					<cfif session.pda.admin eq 0 and session.pda.power_user eq 0><!---  and session.pda.member_view_control --->
                        AND WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
                        AND WEP.POSITION_CODE IN (#ValueList(get_emps.position_code,',')#)
                    </cfif>
                </cfif>
                <cfif isDefined('attributes.ref_company_id') and len(attributes.ref_company_id)>
                    AND 
                    (
                        ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ref_company_id#">
                        <cfif isDefined('attributes.ref_partner_id') and len(attributes.ref_partner_id)>
							OR ORDERS.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ref_partner_id#">
                        </cfif>
                    )
                </cfif>
                <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                    AND ORDERS.ORDER_DATE >= #attributes.start_date#
                </cfif>
                <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                    AND ORDERS.ORDER_DATE <= #attributes.finish_date#
                </cfif>       
        </cfif>
	ORDER BY	
		ORDERS.ORDER_DATE DESC, ORDERS.ORDER_ID DESC
</cfquery>
<cf_box title="Siparişler" body_style="overflow-y:scroll;height:100px;" call_function='gizle(kontrol_prerecord_div);'>
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
	  	<tr class="color-border">
			<td>
				<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
					<tr class="color-header" style="height:22px;">		
						<td class="form-title">Sipariş Tarihi</td>
						<td class="form-title">Başlık</td>
						<td class="form-title">Ünvan</td>
					</tr>
					<cfif get_order.recordcount>
						<cfoutput query="get_order">		
							<cfif len(partner_id)>
								<cfquery name="GET_PARTNER" datasource="#DSN#">
									SELECT 
										COMPANY_PARTNER_NAME,
										COMPANY_PARTNER_SURNAME
									FROM 
										COMPANY_PARTNER
									WHERE 
										PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#">
								</cfquery>
							</cfif>
							<tr class="color-row" style="height:20px;">
								<td>
									<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_order&order_id=#order_id#" class="tableyazi">#dateformat(order_date,'dd/mm/yyyy')#</a>
								</td>
								<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_order&order_id=#order_id#" class="tableyazi">#order_head#</a></td>
								<td>
									<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_order&order_id=#order_id#" class="tableyazi">#fullname#</a>
									<cfif len(partner_id)><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_order&order_id=#order_id#" class="tableyazi">- #get_partner.company_partner_name# #get_partner.company_partner_surname#</a></cfif>
								</td>
							</tr>		
						</cfoutput>
					<cfelse>
						<tr class="color-row" style="height:20px;">
							<td colspan="3">Kayıt Bulunamadı !</td>
						</tr>
					</cfif>
		  		</table>
			</td>
	  	</tr>
	</table>
</cf_box>

