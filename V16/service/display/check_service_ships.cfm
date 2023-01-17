<cfset this_year = session.ep.period_year>
<cfset last_year = session.ep.period_year-1>
<cfset next_year = session.ep.period_year+1>
<cfscript>
	if (database_type is 'MSSQL') 
		{
		last_year_dsn2 = '#dsn#_#this_year-1#_#session.ep.company_id#';
		next_year_dsn2 = '#dsn#_#this_year+1#_#session.ep.company_id#';
		}
	else if (database_type is 'DB2') 
		{
		last_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year-1#';
		next_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year+1#';
		}	
</cfscript>
<cfquery name="GET_PERIODS" datasource="#DSN#">
	SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfquery name="CONTROL_LAST_YEAR" dbtype="query" maxrows="1">
	SELECT PERIOD_YEAR FROM GET_PERIODS WHERE PERIOD_YEAR = #last_year#
</cfquery>

<cfif control_last_year.recoRDCOUNT>
	<CFQUERy name="get_last_year_ship" datasource="#last_year_dsn2#">
		SELECT DISTINCT
			S.SHIP_ID,
			S.SHIP_TYPE,
			S.SHIP_NUMBER,
			S.COMPANY_ID,
			S.CONSUMER_ID,
			S.SHIP_DATE
		FROM 
			SHIP S,
			SHIP_ROW SR
		WHERE 
			S.SHIP_ID = SR.SHIP_ID AND
			SR.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
<cfelse>
	<cfset get_last_year_ship.recordcount = 0>
</cfif>

<cfquery name="GET_NEW_SHIP" datasource="#DSN2#">
	SELECT DISTINCT
		S.SHIP_ID,
		S.SHIP_TYPE,
		S.SHIP_NUMBER,
		S.COMPANY_ID,
		S.CONSUMER_ID,
		S.SHIP_DATE
	FROM 
		SHIP S,
		SHIP_ROW SR
	WHERE 
		S.SHIP_ID = SR.SHIP_ID AND
		SR.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>

<cfquery name="CONTROL_NEXT_YEAR" dbtype="query">
	SELECT PERIOD_YEAR FROM GET_PERIODS WHERE PERIOD_YEAR = #next_year#
</cfquery>
<cfif control_next_year.recordcount>
	<cfquery name="GET_NEXT_YEAR_SHIP" datasource="#next_year_dsn2#" maxrows="1">
		SELECT DISTINCT
			S.SHIP_ID,
			S.SHIP_TYPE,
			S.SHIP_NUMBER,
			S.COMPANY_ID,
			S.CONSUMER_ID,
			S.SHIP_DATE 
		FROM 
			SHIP S,
			SHIP_ROW SR
		WHERE 
			S.SHIP_ID = SR.SHIP_ID AND
			SR.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
<cfelse>
	<cfset get_next_year_ship.recordcount = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="right">
        <cfoutput>
            <li><a target="_blank" href="#request.self#?fuseaction=stock.form_add_purchase&service_id=#attributes.service_id#"><i class="catalyst-login" title="<cf_get_lang no ='284.Giriş İşlemi'>"></i></a> </li>
           <li><a target="_blank" href="#request.self#?fuseaction=stock.form_add_sale&service_ids=#attributes.service_id#"><i class="catalyst-logout" title="<cf_get_lang no ='285.Çıkış İşlemi'>"></i></a></li>
        </cfoutput>
    </cfsavecontent>
    <cf_box title="#getLang('service',38)#" right_images="#right#">    
        <cf_flat_list>
            <thead>
                <tr>
                    <th style="width:50px;"><cf_get_lang_main no='468.Belge No'></th>
                    <th style="width:120px;"><cf_get_lang_main no='388.İşlem Tipi'></th>
                    <th><cf_get_lang_main no ='107.Cari Hesap'></th>
                    <th style="width:65px;"><cf_get_lang_main no ='330.Tarih'></th>
                    <th><cf_get_lang_main no ='1060.Dönem'></th>
                    <th style="width:20px;"><a href="javascript://"><i class="fa fa-print"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_last_year_ship.recordcount>
                    <cfoutput query="get_last_year_ship">
                        <tr>
                            <td>
                                <cfif ship_type eq 141 or ship_type eq 85>
                                    <a href="javascript://" onclick="alert('İrsaliyenizi İlgili Döneme Geçtikten Sonra Görüntüleyebilirsiniz!');" class="tableyazi">#ship_number#</a>
                                <cfelse>
                                    <a href="javascript://" onclick="alert('İrsaliyenizi İlgili Döneme Geçtikten Sonra Görüntüleyebilirsiniz!');"  class="tableyazi">#ship_number#</a>
                                </cfif>
                            </td>
                            <td>#get_process_name(ship_type)#</td>
                            <td>
                                <cfif len(company_id)>
                                    #get_par_info(company_id,1,0,1)#
                                <cfelseif len(consumer_id)>
                                    #get_cons_info(consumer_id,0,0)#
                                </cfif>
                            </td>
                            <td>#dateformat(ship_date,dateformat_style)#</td>
                            <td>#last_year#</td>
                            <td><cfif ship_type eq 141>
                                    <a href="javascript://"  onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#ship_id#&print_type=30<cfif fuseaction contains 'service'>&keyword=service</cfif>','woc');"><i class="fa fa-print"></i></a>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </cfif>
                <cfif get_new_ship.recordcount>
                    <cfoutput query="get_new_ship">
                        <tr>
                            <td>
                                <cfif ship_type eq 141 or ship_type eq 85>
                                    <a  href="#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#ship_id#&service_id=#attributes.service_id#" class="tableyazi">#ship_number#</a>
                                <cfelse>
                                    <a  href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#ship_id#&service_id=#attributes.service_id#" class="tableyazi">#ship_number#</a>
                                </cfif>
                            </td>
                            <td>#get_process_name(ship_type)#</td>
                            <td>
                                <cfif len(company_id)>
                                    #get_par_info(company_id,1,0,1)#
                                <cfelseif len(consumer_id)>
                                    #get_cons_info(consumer_id,0,0)#
                                </cfif>
                            </td>
                            <td>#dateformat(ship_date,dateformat_style)#</td>
                            <td>#this_year#</td>
                            <td><cfif ship_type eq 141>
                                    <a href="javascript://"  onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#ship_id#&print_type=30<cfif fuseaction contains 'service'>&keyword=service</cfif>','woc');"><i class="fa fa-print"></i></a>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </cfif>
                <cfif get_next_year_ship.recordcount>
                    <cfoutput query="get_next_year_ship">
                    <tr>
                        <td>
                            <cfif ship_type eq 141 or ship_type eq 85>
                                <a href="javascript://" onclick="alert('İrsaliyenizi İlgili Döneme Geçtikten Sonra Görüntüleyebilirsiniz!');"  class="tableyazi">#ship_number#</a>
                            <cfelse>
                                <a href="javascript://" onclick="alert('İrsaliyenizi İlgili Döneme Geçtikten Sonra Görüntüleyebilirsiniz!');"  class="tableyazi">#ship_number#</a>
                            </cfif>
                        </td>
                        <td>#get_process_name(ship_type)#</td>
                        <td>
                            <cfif len(company_id)>
                                #get_par_info(company_id,1,0,1)#
                            <cfelseif len(consumer_id)>
                                #get_cons_info(consumer_id,0,0)#
                            </cfif>
                        </td>
                        <td>#dateformat(ship_date,dateformat_style)#</td>
                        <td>#next_year#</td>
                        <td>
                            <cfif ship_type eq 141>
                                <a href="javascript://"  onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#ship_id#&print_type=30','woc');"><i class="fa fa-print"></i></a>
                            </cfif>
                        </td>
                    </tr>
                    </cfoutput>
                </cfif>
                <cfif not get_last_year_ship.recordcount and not get_new_ship.recordcount and not get_next_year_ship.recordcount>
                    <tr>
                        <td colspan="6"><cf_get_lang_main no ='1074.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>

