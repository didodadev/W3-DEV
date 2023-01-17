<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.start_date" default="#now()#" >
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfif isdefined("attributes.is_submitted")>
	<cf_date tarih = "attributes.start_date">
	<cfquery name="get_fileimports_total_sayim" datasource="#DSN2#">
		SELECT 
			(SELECT PC.PRODUCT_CAT FROM #dsn3_alias#.PRODUCT_CAT PC WHERE PC.PRODUCT_CATID=FITS.PRODUCT_CATID) PRODUCT_CAT,
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
			FITS.PROCESS_DATE =  #attributes.start_date# AND
			ISNULL(FITS.IS_ALL,0)=1
			<cfif len(attributes.product_catid) and len(attributes.product_cat)>
				AND FITS.PRODUCT_CATID = #attributes.product_catid#
			</cfif>
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
	<cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")>
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
<cfform name="list_file_import" method="post" action="">
<input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <cf_big_list_search title="Sayımları Sıfırla"> 
        <cf_big_list_search_area>
            <table>
                <tr>		  
                    <td><cf_get_lang_main no ='467.İşlem Tarihi'></td>
                        <cfsavecontent variable="message"><cf_get_lang_main no ='641.Başlangıç Tarihi'></cfsavecontent>
                    <td><cfinput type="text" name="start_date" value="#attributes.start_date#" style="width:65px;" validate="eurodate" maxlength="10" message="#message#" required="yes">
                        <cf_wrk_date_image date_field="start_date"> </td>
                    <td><cf_get_lang_main no='1351.Depo'></td>
                    <td>
                        <select name="department_id" id="department_id" style="width:250;">
                            <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                            <cfoutput query="get_all_location" group="department_id">
                                <option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
                            <cfoutput>
                                <option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#<cfif not status> - <cf_get_lang_main no='82.Pasif'></cfif></option>
                            </cfoutput>
                            </cfoutput>
                        </select>	
                    </td>
					<td>Kategori</td>
					<td>
						<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
						<input type="text" name="product_cat" id="product_cat" value="<cfoutput>#attributes.product_cat#</cfoutput>" style="width:135px;">
						<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=product_catid&field_name=list_sayimlar.product_cat','list');"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang no='146.Ürün Kategorisi Ekle'>!" align="absbottom"></a>
					</td>
                    <td><cf_wrk_search_button ></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list> 
    <thead>
        <tr>
            <th width="75"><cf_get_lang_main no ='330.Tarih'></th>
            <th><cf_get_lang_main no='1351.Depo'></th>
			<th width="100">Kategori</th>
            <th><cf_get_lang_main no ='71.Kayıt'></th>
            <th class="header_icn_none"></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_fileimports_total_sayim.recordcount>	
            <cfoutput query="get_fileimports_total_sayim" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
              <tr>
                <td>#dateformat(PROCESS_DATE,"dd/mm/yyyy")#</td>
                <td>#DEPARTMENT_HEAD# (#COMMENT#)</td>
				<td>#product_cat#</td>
                <cfif IS_INITIALIZED eq 0>
                    <td>Sayımları Birleştiren : #get_emp_info(record_emp,0,0)#</td>
                    <td style="text-align:right;">
                        <a href="javascript://" onClick="sayim_sifirla('#file_imports_total_sayim_id#','#department_id#','#department_location#','#dateformat(PROCESS_DATE,"dd/mm/yyyy")#','#PRODUCT_CATID#');"> <img src="/images/update_list.gif" border="0" title="Sayım Sıfırla"></a>
                    </td>
                <cfelse>
                    <td>Sayımları Sıfırlayan : #get_emp_info(update_emp,0,0)#</td>
                    <td style="text-align:right;">
                        <a href="javascript://" onClick="sifirlama_silme('#file_imports_total_sayim_id#','#department_id#','#department_location#','#dateformat(PROCESS_DATE,"dd/mm/yyyy")#');"> <img src="/images/delete_list.gif" border="0" title="Sayım Sıfırlama İşlemini Silme"></a>
                    </td>
                </cfif>
              </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="9"><cfif arama_yapilmali neq 1><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no ='289.Filtre Ediniz'>!</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list> 
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
	<cfset url_string = ''>
	<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
		<cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
	</cfif>
	<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
		<cfset url_string = '#url_string#&department_id=#dateformat(attributes.department_id,"dd/mm/yyyy")#'>
	</cfif>
	<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
		<cfset url_string = '#url_string#&product_catid=#attributes.product_catid#'>
	</cfif>
	<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
		<cfset url_string = '#url_string#&product_cat=#attributes.product_cat#'>
	</cfif>
    <table width="99%" align="center">
        <tr>
            <td>
            <cf_pages page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="pos.list_fileimports_total_sayim#url_string#">
            </td>
            <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
        </tr>
    </table>
</cfif>
<script type="text/javascript">
	function sayim_sifirla(file_imports_total_sayim_id,department_id,location_id,process_date,product_catid)
	{
		if(confirm("Sayımları Sıfırlamak İstediğinizden Emin Misiniz? Lokasyondaki Sayılmayan Ürünler Sıfırlanacaktır"))
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.emptypopup_file_import_total_initialize&product_catid='+product_catid +'&file_imports_total_sayim_id='+file_imports_total_sayim_id +'&store='+department_id+'&location_id='+location_id+'&process_date='+process_date,'small'); 
		}
	}
	function sifirlama_silme(file_imports_total_sayim_id,department_id,location_id,process_date)
	{
		if(confirm("Sayım Sıfırlama İşlemini Silmek İstediğinizden Emin Misiniz?"))
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.emptypopup_del_total_sayim&file_imports_total_sayim_id='+file_imports_total_sayim_id +'&store='+department_id+'&location_id='+location_id+'&process_date='+process_date,'small'); 
		}
	}
</script>