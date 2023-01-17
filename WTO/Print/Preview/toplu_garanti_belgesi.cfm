<cfquery name="get_serials" datasource="#dsn3#">
	SELECT 
		SGN.SERIAL_NO,
		S.PRODUCT_NAME,
		S.PROPERTY,
		S.BRAND_ID,
		S.PRODUCT_ID,
        S.STOCK_ID
	FROM
		SERVICE_GUARANTY_NEW SGN,
		STOCKS S
	WHERE
		SGN.PERIOD_ID = #session.ep.period_id# AND
		SGN.STOCK_ID = S.STOCK_ID
		<cfif isdefined("attributes.action_row_id") and len(attributes.action_row_id)>
			AND SGN.STOCK_ID=#attributes.action_row_id#
		</cfif>
	ORDER BY 
		SGN.SERIAL_NO
</cfquery>
<cfif len(get_serials.product_id)>
    <cfquery name="get_guaranty" datasource="#dsn3#">
        SELECT 
            * 
        FROM 
            PRODUCT_GUARANTY 
        WHERE 
            PRODUCT_ID=#get_serials.product_id#
    </cfquery>
<cfelse>
	<cfset get_serials.recordcount = 0>
</cfif>

<cfquery name="GET_GUARANTY_DETAIL" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_GUARANTY_NEW
	WHERE
		GUARANTY_ID=#attributes.action_id#
</cfquery>

<cfset basilacak_sayi = get_serials.recordcount>
<!--- <cfif basilacak_sayi gte 50 and not isdefined("attributes.yazdir")>
	<cfform name="formexport" method="post" action="#request.self#?fuseaction=objects.popupflush_print_files_inner">
	<input type="hidden" name="yazdir" value="1">
	<input type="hidden" name="print_type" value="<cfoutput>#attributes.print_type#</cfoutput>">
	<input type="hidden" name="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
	<cfif isdefined("attributes.action_row_id") and len(attributes.action_row_id)>
		<input type="hidden" name="action_row_id" value="<cfoutput>#attributes.action_row_id#</cfoutput>">
	</cfif>
	<input type="hidden" name="form_type" value="<cfoutput>#attributes.form_type#</cfoutput>">
	<input type="hidden" name="is_special" value="1">
	<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
	  <td align="center" valign="top">
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
		  <tr>
			<td class="color-border">
			  <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0" height="100%">
				<tr height="35" class="color-list">
				  <td class="headbold">&nbsp;Garanti Belgesi Toplu Print</td>
				</tr>
				<tr class="color-row">
				  <td valign="top">
				  	<table>
					  <tr>
						<td>Basılacak Seri Adedi</td>
						<td><cfoutput>#basilacak_sayi#</cfoutput></td>
					  </tr>
					  <tr>
						<td>Başlangıç Seri</td>
						<td><cfinput type="text" name="baslangic" value="1" validate="integer" range="1," message="Baslangiç Seri Sayısını Giriniz!"></td>
					  </tr>
					  <tr>
						<td>Bitiş Seri</td>
						<td><cfinput type="text" name="bitis" value="#basilacak_sayi#" validate="integer" range="1,#basilacak_sayi#" message="Bitis Seri Sayısını Giriniz!"></td>
					  </tr>
					  <tr>
						<td></td>
						<td height="35"><cf_workcube_buttons is_upd='0' insert_info='Çalıştır'> </td>
					  </tr>
					</table>
				  </td>
				</tr>
			  </table>
			</td>
		  </tr>
		</table>
		</cfform>
	  <td> 
	</tr>
	<table>
<cfelse>
	<cfif not isdefined("attributes.bitis")>
		<cfset attributes.baslangic=1>
		<cfset attributes.bitis=basilacak_sayi>
		<cfset attributes.yazdir=1>
	</cfif>
</cfif> --->

<cfif not isdefined("attributes.bitis")>
	<cfset attributes.baslangic=1>
    <cfset attributes.bitis=basilacak_sayi>
    <cfset attributes.yazdir=1>
</cfif>

<cfif isdefined("attributes.yazdir") and len(attributes.yazdir)>
	<cfset fark=attributes.bitis-attributes.baslangic + 1>
<cfoutput>

<cfquery name="GET_PRO_NAME" datasource="#DSN3#">
	SELECT 
		P.PRODUCT_NAME,
		S.PROPERTY
	FROM 
		PRODUCT P, 
		STOCKS S
	WHERE 
		S.STOCK_ID = #GET_GUARANTY_DETAIL.STOCK_ID# 
		AND S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<cfquery name="get_brand" datasource="#dsn3#">
	SELECT 
		BRAND_NAME
	FROM 
		PRODUCT_BRANDS P,
		STOCKS S 
	WHERE 
		S.STOCK_ID = #GET_GUARANTY_DETAIL.STOCK_ID# 
		AND P.BRAND_ID = S.BRAND_ID
</cfquery>

<cfquery name="GET_GUARANTY_CAT" datasource="#dsn#">
	SELECT 
		CURRENCY,
		GUARANTYCAT_ID,
		#dsn#.Get_Dynamic_Language(GUARANTYCAT_ID,'#session.ep.language#','SETUP_GUARANTY','GUARANTYCAT',NULL,NULL,GUARANTYCAT) AS GUARANTYCAT,
		GUARANTYCAT_TIME,
		MAX_GUARANTYCAT_TIME,
		DETAIL,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP
	FROM 
		SETUP_GUARANTY
	ORDER BY
		GUARANTYCAT
</cfquery>

<cfquery name="get_dep" datasource="#dsn#">
	SELECT * FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_guaranty_detail.department_id#">
</cfquery>

<cfquery name="get_loc" datasource="#dsn#">
	SELECT * FROM STOCKS_LOCATION WHERE LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_guaranty_detail.location_id#">
</cfquery>

<cfsavecontent variable="tmpby"><cf_get_lang dictionary_id='58176.Alış'></cfsavecontent>
<cfsavecontent variable="tmppro"><cf_get_lang dictionary_id ='33239.Üreticide'></cfsavecontent>
<cfsavecontent variable="tmpslb"><cf_get_lang dictionary_id ='33237.Satılabilir'></cfsavecontent>
<cfsavecontent variable="tmprtrn"><cf_get_lang dictionary_id='29418.İade'></cfsavecontent>
<cfsavecontent variable="tmpsale"><cf_get_lang dictionary_id ='57448.Satış'></cfsavecontent>
<cfsavecontent variable="tmpser"><cf_get_lang dictionary_id ='33240.Serviste'></cfsavecontent>
<cfsavecontent variable="tmpwas"><cf_get_lang dictionary_id='29471.Fire'></cfsavecontent>
<cfset liststatus = "">

<cf_woc_header>
	<cf_woc_elements>
		<cfif GET_GUARANTY_DETAIL.is_purchase is 1>
			<cfset liststatus = listAppend(liststatus, tmpby, " ")>
			<cfif GET_GUARANTY_DETAIL.is_rma eq 1><cfset liststatus = listAppend(liststatus, tmppro, ",")></cfif>
			<cfif GET_GUARANTY_DETAIL.IN_OUT is 1><cfset liststatus = listAppend(liststatus, tmpslb, ",")></cfif>
			<cfif GET_GUARANTY_DETAIL.is_return eq 1><cfset liststatus = listAppend(liststatus, tmprtrn, ",")></cfif>
		<cfelse>
			<cfset liststatus = listAppend(liststatus, tmpsale, " ")>
			<cfif GET_GUARANTY_DETAIL.is_service eq 1><cfset liststatus = listAppend(liststatus, tmpser, ",")></cfif>
			<cfif GET_GUARANTY_DETAIL.is_trash eq 1><cfset liststatus = listAppend(liststatus, tmpwas, ",")></cfif>
		</cfif>
		<cf_wuxi id="status" data="#liststatus#" label="57756" type="cell">
		<cf_wuxi id="serialno" data="#GET_GUARANTY_DETAIL.SERIAL_NO#" label="57637" type="cell">
		<cf_wuxi id="product" data="#GET_PRO_NAME.PRODUCT_NAME#" label="57657" type="cell">
		<cf_wuxi id="deploc" data="#get_dep.DEPARTMENT_HEAD# - #get_loc.COMMENT#" label="58524" type="cell">

		<cfif len(GET_GUARANTY_DETAIL.PURCHASE_GUARANTY_CATID)>
		<cfquery name="get_gpurc" datasource="#dsn#">
			SELECT * FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_GUARANTY_DETAIL.PURCHASE_GUARANTY_CATID#">
		</cfquery>
			<cf_wuxi id="purchase" data="#get_gpurc.GUARANTYCAT#" label="33244" type="cell">
		<cfelse><cf_wuxi id="purchase" label="33244" type="cell"></cfif>
		<cf_wuxi id="purc_start" data="#dateformat(GET_GUARANTY_DETAIL.PURCHASE_START_DATE,dateformat_style)#" label="33243" type="cell">
		<cf_wuxi id="purc_finish" data="#dateformat(GET_GUARANTY_DETAIL.PURCHASE_FINISH_DATE,dateformat_style)#" label="33856" type="cell">

		<cfif len(GET_GUARANTY_DETAIL.SALE_GUARANTY_CATID)>
		<cfquery name="get_gsales" datasource="#dsn#">
			SELECT * FROM SETUP_GUARANTY WHERE GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_GUARANTY_DETAIL.SALE_GUARANTY_CATID#">
		</cfquery>
			<cf_wuxi id="sale" data="#get_gsales.GUARANTYCAT#" label="33246" type="cell">
		<cfelse><cf_wuxi id="sale" label="33246" type="cell"></cfif>
		<cf_wuxi id="sale_start" data="#dateformat(GET_GUARANTY_DETAIL.SALE_START_DATE,dateformat_style)#" label="33245" type="cell">
		<cf_wuxi id="sale_finish" data="#dateformat(GET_GUARANTY_DETAIL.SALE_FINISH_DATE,dateformat_style)#" label="33857" type="cell">
	</cf_woc_elements>
<cf_woc_footer>
	
</cfoutput>
</cfif>
