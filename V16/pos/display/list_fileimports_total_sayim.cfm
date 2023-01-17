<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.start_date" default="#now()#" >
<cfparam name="attributes.page" default=1>
<cfif isdefined("attributes.is_submitted")>
	<cf_date tarih = "attributes.start_date">
	<cfquery name="get_fileimports_total_sayim" datasource="#DSN2#">
		SELECT 
			FITS.*,
			D.DEPARTMENT_HEAD,
			SL.COMMENT
		FROM
			FILE_IMPORTS_TOTAL_SAYIMLAR FITS,
			#dsn_alias#.DEPARTMENT D,
			#dsn_alias#.STOCKS_LOCATION SL
		WHERE 
			D.DEPARTMENT_ID = FITS.DEPARTMENT_ID AND
			D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
			SL.LOCATION_ID = FITS.DEPARTMENT_LOCATION AND
			FITS.PROCESS_DATE =  #attributes.start_date#
			<cfif isdefined("attributes.department_id") and listlen(attributes.department_id,'-') eq 1>
				AND FITS.DEPARTMENT_ID = #attributes.department_id#
			<cfelseif isdefined("attributes.department_id") and listlen(attributes.department_id,'-') eq 2>
				AND FITS.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
				AND FITS.DEPARTMENT_LOCATION = #listlast(attributes.department_id,'-')#
			<cfelse>
				<cfif session.ep.our_company_info.is_location_follow eq 1>
					AND
					(
						CAST(FITS.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(FITS.DEPARTMENT_LOCATION AS NVARCHAR) IN (SELECT LOCATION_CODE FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
						OR
						FITS.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
					)
				</cfif>
			</cfif>
	</cfquery>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset get_fileimports_total_sayim.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_fileimports_total_sayim.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
</cfif>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_HEAD,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		SL.STATUS,
		SL.COMMENT
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.IS_STORE <> 2 AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif session.ep.our_company_info.is_location_follow eq 1>
			AND
			(
				CAST(D.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(SL.LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
				OR
				D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
			)
		</cfif>
	ORDER BY
		D.DEPARTMENT_HEAD,
		COMMENT
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_file_import" method="post" action="">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1"> 
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='36055.Sayımları Sıfırla'></cfsavecontent>
                <cf_box_search>
                    <div class="form-group">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
                            <cfinput type="text" name="start_date" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
                            <span class="input-group-addon"> <cf_wrk_date_image date_field="start_date"> </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <select name="department_id" id="department_id" style="width:250;">
                            <option value=""><cf_get_lang dictionary_id='58763.Depo'></option>
                            <cfoutput query="get_all_location" group="department_id">
                                <option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
                                <cfoutput>
                                    <option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
                                </cfoutput>
                            </cfoutput>
                        </select>	
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                    </div> 
                </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='36055.Sayımları Sıfırla'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
            <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id ='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='58763.Depo'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th class="header_icn_none"></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_fileimports_total_sayim.recordcount>	
                    <cfoutput query="get_fileimports_total_sayim" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                      <tr>
                        <td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
                        <td>#DEPARTMENT_HEAD# (#COMMENT#)</td>
                        <cfif IS_INITIALIZED eq 0>
                            <td><cf_get_lang dictionary_id ='36104.Sayımları Birleştiren'> : #get_emp_info(record_emp,0,0)#</td>
                            <td style="text-align:right;">
                                <a href="javascript://" onClick="sayim_sifirla('#file_imports_total_sayim_id#','#department_id#','#department_location#','#dateformat(PROCESS_DATE,dateformat_style)#');"> <img src="/images/update_list.gif" border="0" title="<cf_get_lang dictionary_id ='36055.Sayım Sıfırla'>"></a>
                            </td>
                        <cfelse>
                            <td><cf_get_lang dictionary_id ='36105.Sayımları Sıfırlayan'> : #get_emp_info(update_emp,0,0)#</td>
                            <td style="text-align:right;">
                                <a href="javascript://" onClick="sifirlama_silme('#file_imports_total_sayim_id#','#department_id#','#department_location#','#dateformat(PROCESS_DATE,dateformat_style)#');"> <i class="fa fa-minus" border="0" title="<cf_get_lang dictionary_id ='36096.Sayım Sıfırlama İşlemini Silme'>"></a>
                            </td>
                        </cfif>
                      </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif arama_yapilmali neq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
                <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.department_id") and len(attributes.department_id)>
                <cfset url_string = '#url_string#&department_id=#dateformat(attributes.department_id,dateformat_style)#'>
            </cfif>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="pos.list_sayim#url_string#">   
            </cfif>
    </cf_box>
    </div>


<script type="text/javascript">
function sayim_sifirla(file_imports_total_sayim_id,department_id,location_id,process_date)
{
	if(confirm("<cf_get_lang dictionary_id ='36103.Sayımları Sıfırlamak İstediğinizden Emin Misiniz? Lokasyondaki Sayılmayan Ürünler Sıfırlanacaktır'>"))
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=pos.emptypopup_file_import_total_initialize&file_imports_total_sayim_id='+file_imports_total_sayim_id +'&store='+department_id+'&location_id='+location_id+'&process_date='+process_date,'small'); 
	}
}
function sifirlama_silme(file_imports_total_sayim_id,department_id,location_id,process_date)
{
	if(confirm("<cf_get_lang dictionary_id ='36097.Sayım Sıfırlama İşlemini Silmek İstediğinizden Emin Misiniz'>?"))
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=pos.emptypopup_del_total_sayim&file_imports_total_sayim_id='+file_imports_total_sayim_id +'&store='+department_id+'&location_id='+location_id+'&process_date='+process_date,'small'); 
	}
}
</script>
