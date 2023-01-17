<cfsetting showdebugoutput="no">

<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>

<cfquery name="GET_OPP" datasource="#DSN3#">
	SELECT
		OPP.OPP_CURRENCY_ID,
        OPP.PARTNER_ID,
        OPP.OPP_ID,
        OPP.OPP_HEAD,
		C.FULLNAME
	FROM
		OPPORTUNITIES OPP,
		#dsn_alias#.COMPANY C,
		#dsn_alias#.WORKGROUP_EMP_PAR WEP
	WHERE
		OPP.COMPANY_ID = C.COMPANY_ID AND
		C.COMPANY_ID = WEP.COMPANY_ID AND
		WEP.IS_MASTER = 1 AND
		WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND 
		WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> 
		<cfif len(attributes.opportunity_type_id)>
			AND OPP.OPPORTUNITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opportunity_type_id#">
		</cfif>
		<cfif len(attributes.opp_currency_id)>
			AND OPP.OPP_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_currency_id#">
		</cfif>
		<cfif len(attributes.ref_company_id)>
            AND 
            (
                OPP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ref_company_id#">
                <cfif len(attributes.ref_partner_id)>
                	OR OPP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ref_partner_id#">
                </cfif>
            )
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND OPP.OPP_DATE >= #attributes.start_date#
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			AND OPP.OPP_DATE <= #attributes.finish_date#
		</cfif>
	ORDER BY	
		OPP.OPP_DATE DESC, 
        OPP.OPP_ID DESC
</cfquery> 

<cf_box title="Fırsatlar" body_style="overflow-y:scroll;height:100px;">
    <table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%;">
    	<tr class="color-border">
    		<td>
    			<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
				    <tr class="color-header" style="height:22px;">		
                        <td class="form-title">Başlık</td>
                        <td class="form-title">Unvan</td>
                        <td class="form-title">Aşama</td>
    				</tr>
    				<cfif get_opp.recordcount>
						<cfoutput query="get_opp">		
							<cfif len(partner_id)>
                                <cfquery name="GET_PARTNER" datasource="#DSN#">
                                    SELECT 
                                        COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME
                                    FROM 
                                        COMPANY_PARTNER
                                    WHERE 
                                        PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#">
                                </cfquery>
                            </cfif>
                            <cfif len(opp_currency_id)>
                                <cfquery name="GET_OPP_CURRENCY" datasource="#DSN3#">
                                    SELECT OPP_CURRENCY FROM OPPORTUNITY_CURRENCY WHERE OPP_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#opp_currency_id#">							
                                </cfquery>
                            </cfif>
                            <tr class="color-row" style="height:20px;"><!--- onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" --->
                                <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_opportunity&opp_id=#opp_id#" class="tableyazi">#opp_head#</a></td>
                                <td>
                                    <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_opportunity&opp_id=#opp_id#" class="tableyazi">#fullname#</a>
                                    <cfif len(partner_id)><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_opportunity&opp_id=#opp_id#" class="tableyazi">- #get_partner.company_partner_name# #get_partner.company_partner_surname#</a></cfif>
                                </td>
                                <td><cfif len(opp_currency_id)><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_opportunity&opp_id=#opp_id#" class="tableyazi">#get_opp_currency.opp_currency#</a></cfif></td>
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

