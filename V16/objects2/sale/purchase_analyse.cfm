<!--- 
20060504 Bu rapor : islem kategorileri -multiple- bazinda (tipleri degil !!!), ve depolar bazında -multiple- 
kategori, urun ve stok bazinda alislarin toplamini alir (secilirse iadeleri de duserek -verilen fiyat farki 62 ve alim iade 58-).
müsteri kategorileri de eklendi -multiple- FB 20080214
 --->
<cfinclude template="../login/send_login.cfm">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.max_rows" default='#session.pp.maxrows#'>
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.is_return" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_other_money" default="0">
<cfparam name="attributes.is_money2" default="0">
<cfparam name="attributes.is_discount" default="0">
<cfparam name="attributes.date1" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.date2" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.kdv_dahil" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.invoice_count" default="">
<cfparam name="attributes.kontrol_type" default="0">
<cfparam name="attributes.is_excel" default="">
<script type="text/javascript">
function degistir_action()
{
	if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=objects2.purchase_analyse</cfoutput>"
		}
	else
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_purchase_analyse_report</cfoutput>"
		}	
}
</script>
<cfif attributes.is_other_money eq 1 and attributes.is_money2 eq 1>
	<cfset attributes.is_money2 = 0>
</cfif>
<cfquery name="get_product_units" datasource="#dsn#">
	SELECT * FROM SETUP_UNIT
</cfquery>
<cfoutput query="get_product_units">
	<cfset unit_2=REPLACE(UNIT,'/','_',"ALL")>
	<cfset unit_2=REPLACE(unit_2,' ','_',"ALL")>
	<cfset unit_2=REPLACE(unit_2,'.','_',"ALL")>
	<cfset unit_2=REPLACE(unit_2,'%','_',"ALL")>
	<cfset 'toplam_#unit_2#' = 0>
</cfoutput>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (51,54,55,59,60,61,62,63,64,65,68,690,691,591,592,601,49) ORDER BY PROCESS_TYPE
</cfquery>
<cfset process_type_list= valuelist(get_process_cat.process_cat_id)>

<cf_date tarih='attributes.date1'>
<cf_date tarih='attributes.date2'>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_total_purchase" datasource="#DSN2#">
		SELECT
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				<cfif attributes.kdv_dahil eq 1>
					SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS ISKONTO,
					SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
					SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
					SUM( ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2 ) AS PRICE_DOVIZ
				<cfelse>
					SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS ISKONTO,
					SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
					SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) AS PRICE,
					SUM( ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) / INVM.RATE2 ) AS PRICE_DOVIZ
				</cfif>
			<cfelse>
				<cfif attributes.kdv_dahil eq 1>
					SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS ISKONTO,
					SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE
				<cfelse>
					SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS ISKONTO,
					SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) AS PRICE
				</cfif>
			</cfif>
			<cfif attributes.is_other_money eq 1>
				,IR.OTHER_MONEY
			</cfif>
			<cfif attributes.report_type eq 1>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,SUM(IR.AMOUNT) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 2>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,P.PRODUCT_ID
			,P.PRODUCT_NAME
			,P.BARCOD
			,SUM(IR.AMOUNT) AS PRODUCT_STOCK
			,IR.UNIT AS BIRIM
			<cfelseif attributes.report_type eq 3>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,P.PRODUCT_ID
			,P.PRODUCT_NAME
			,S.BARCOD
			,S.PROPERTY,
			IR.STOCK_ID
			,SUM(IR.AMOUNT) AS PRODUCT_STOCK
			,IR.UNIT AS BIRIM
			<cfelseif attributes.report_type eq 4>
			,C.NICKNAME
			,C.COMPANY_ID
			,SUM(IR.AMOUNT) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 5>
			,I.INVOICE_NUMBER
			,I.DEPARTMENT_ID
			,I.DEPARTMENT_LOCATION
			,C.NICKNAME AS MUSTERI
			,C.COMPANY_ID
			,I.INVOICE_DATE
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,S.PRODUCT_ID
			,P.PRODUCT_NAME
			,P.PRODUCT_CODE
			,P.MANUFACT_CODE
			,SUM(IR.AMOUNT) AS PRODUCT_STOCK
			,IR.UNIT AS BIRIM
			,SUM(IR.PRICE) AS BIRIM_FIYAT
			<cfelseif attributes.report_type eq 6>
			,PB.BRAND_NAME
			,P.BRAND_ID
			,SUM(IR.AMOUNT) AS PRODUCT_STOCK
			</cfif>
		FROM
			INVOICE I,
			INVOICE_ROW IR,		
			#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.PRODUCT P
			<cfif attributes.report_type eq 4 or attributes.report_type eq 5>,#dsn_alias#.COMPANY C</cfif>
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				,INVOICE_MONEY INVM
			</cfif>
			<cfif attributes.report_type eq 6>
				,#dsn3_alias#.PRODUCT_BRANDS PB
			</cfif>
		WHERE
			I.IS_IPTAL = 0 AND
			I.GROSSTOTAL > 0 AND
			I.NETTOTAL > 0 AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			S.PRODUCT_ID = P.PRODUCT_ID AND
			IR.STOCK_ID = S.STOCK_ID AND
			I.INVOICE_ID = IR.INVOICE_ID AND
			I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
			S.PRODUCT_ID = IR.PRODUCT_ID AND
            I.INVOICE_CAT NOT IN (62)
			<cfif len(attributes.process_type)>
			AND I.PROCESS_CAT IN (#attributes.process_type#)
			<cfelseif len(process_type_list)>
			AND I.PROCESS_CAT IN (#process_type_list#)	
			</cfif>
			<cfif attributes.report_type eq 4>
				AND I.COMPANY_ID = C.COMPANY_ID
			<cfelseif attributes.report_type eq 5>
				AND	I.COMPANY_ID = C.COMPANY_ID 
				AND PC.PRODUCT_CATID = P.PRODUCT_CATID
			<cfelseif attributes.report_type eq 6>
				AND P.BRAND_ID = PB.BRAND_ID 
			</cfif>
			<cfif attributes.is_other_money eq 1>
				AND INVM.ACTION_ID = I.INVOICE_ID 
				AND INVM.MONEY_TYPE = IR.OTHER_MONEY
			<cfelseif attributes.is_money2 eq 1>
				AND INVM.ACTION_ID = I.INVOICE_ID
				AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money2#">
			</cfif>
			<cfif isdefined("session.pp.userid")>AND P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"></cfif>
		GROUP  BY	
			<cfif attributes.is_other_money eq 1>
				IR.OTHER_MONEY,
			</cfif>
			<cfif attributes.report_type eq 1>
			PC.PRODUCT_CAT,
			PC.PRODUCT_CATID,			
			PC.HIERARCHY
			<cfelseif attributes.report_type eq 2>
			PC.PRODUCT_CAT,
			PC.PRODUCT_CATID,
			PC.HIERARCHY,
			P.PRODUCT_ID,
			P.BARCOD,
			P.PRODUCT_NAME,
			IR.PRODUCT_ID,
			IR.UNIT
			<cfelseif attributes.report_type eq 3>
			PC.PRODUCT_CAT,
			PC.PRODUCT_CATID,
			PC.HIERARCHY,
			IR.STOCK_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			S.PROPERTY,
			S.BARCOD,
			IR.UNIT
			<cfelseif attributes.report_type eq 4>
			C.NICKNAME,
			C.COMPANY_ID
			<cfelseif attributes.report_type eq 5>
			I.INVOICE_NUMBER,
			I.DEPARTMENT_ID,
			I.DEPARTMENT_LOCATION,
			C.NICKNAME,
			C.COMPANY_ID,
			I.INVOICE_DATE,
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			P.MANUFACT_CODE,
			IR.UNIT
			<cfelseif attributes.report_type eq 6>
				PB.BRAND_NAME,
				P.BRAND_ID
			</cfif>
		ORDER  BY 
			<cfif attributes.kontrol_type eq 1 and attributes.report_type eq 5>
				INVOICE_NUMBER
			<cfelseif attributes.report_sort eq 1>
				PRICE DESC
			<cfelse>
				<cfif attributes.report_type neq 1>
					PRODUCT_STOCK DESC
				<cfelse>
					PRODUCT_CAT, PRICE DESC
				</cfif>				
			</cfif>
	</cfquery>
	<cfif isdefined("attributes.is_return") and attributes.is_return eq 1>
		<cfquery name="get_total_purchase_2"  datasource="#DSN2#">
			SELECT
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<cfif attributes.kdv_dahil eq 1>
						-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS ISKONTO,
						-1*SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
						-1*SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
						-1*SUM( ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2 ) AS PRICE_DOVIZ
					<cfelse>
						-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS ISKONTO,
						-1*SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
						-1*SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) AS PRICE,
						-1*SUM( ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) / INVM.RATE2 ) AS PRICE_DOVIZ
					</cfif>
				<cfelse>
					<cfif attributes.kdv_dahil eq 1>
						-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS ISKONTO,
						-1*SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE
					<cfelse>
						-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) AS ISKONTO,
						-1*SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) AS PRICE
					</cfif>
				</cfif>
				<cfif attributes.is_other_money eq 1>
					,IR.OTHER_MONEY
				</cfif>
				<cfif attributes.report_type eq 1>
				,PC.PRODUCT_CAT
				,PC.HIERARCHY
				,PC.PRODUCT_CATID
				,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 2>
				,PC.PRODUCT_CAT
				,PC.HIERARCHY
				,PC.PRODUCT_CATID

				,P.PRODUCT_ID
				,P.PRODUCT_NAME
				,P.BARCOD
				,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
				,IR.UNIT AS BIRIM
				<cfelseif attributes.report_type eq 3>
				,PC.PRODUCT_CAT
				,PC.HIERARCHY
				,PC.PRODUCT_CATID
				,P.PRODUCT_ID
				,P.PRODUCT_NAME
				,S.BARCOD
				,S.PROPERTY
				,IR.STOCK_ID
				,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
				,IR.UNIT AS BIRIM
				<cfelseif attributes.report_type eq 4>
				,C.NICKNAME
				,C.COMPANY_ID
				,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 5>
				,I.INVOICE_NUMBER
				,I.DEPARTMENT_ID
				,I.DEPARTMENT_LOCATION
				,C.NICKNAME AS MUSTERI
				,C.COMPANY_ID
				,I.INVOICE_DATE
				,PC.PRODUCT_CAT
				,PC.HIERARCHY
				,PC.PRODUCT_CATID
				,S.PRODUCT_ID
				,P.PRODUCT_NAME
				,P.PRODUCT_CODE
				,P.MANUFACT_CODE
				,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
				,IR.UNIT AS BIRIM
				,IR.PRICE AS BIRIM_FIYAT
				<cfelseif attributes.report_type eq 6>
				,PB.BRAND_NAME
				,P.BRAND_ID
				,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
				</cfif>
			FROM
				INVOICE I,
				INVOICE_ROW IR,
				#dsn3_alias#.STOCKS S,
				#dsn3_alias#.PRODUCT_CAT PC,
				#dsn3_alias#.PRODUCT P
				<cfif attributes.report_type eq 4 or attributes.report_type eq 5>,#dsn_alias#.COMPANY C</cfif>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					,INVOICE_MONEY INVM
				</cfif>
				<cfif attributes.report_type eq 6>
					,#dsn3_alias#.PRODUCT_BRANDS PB
				</cfif>
			WHERE
				I.PURCHASE_SALES = 1 AND
				PC.PRODUCT_CATID = P.PRODUCT_CATID AND
				S.PRODUCT_ID = P.PRODUCT_ID AND
				S.PRODUCT_ID = IR.PRODUCT_ID AND
				IR.STOCK_ID = S.STOCK_ID AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				I.GROSSTOTAL > 0 AND
				I.NETTOTAL > 0 AND
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">  AND
				I.INVOICE_CAT IN (62)<!--- 20060504 iade tipleri : alim aide ve verilen fiyat farki fats --->
				<cfif attributes.report_type eq 4>
					AND P.COMPANY_ID = C.COMPANY_ID
				<cfelseif attributes.report_type eq 5>
					AND	I.COMPANY_ID = C.COMPANY_ID 
					AND PC.PRODUCT_CATID = P.PRODUCT_CATID
				<cfelseif attributes.report_type eq 6>
					AND P.BRAND_ID = PB.BRAND_ID 
				</cfif>
				<cfif attributes.is_other_money eq 1>
					AND INVM.ACTION_ID = I.INVOICE_ID 
					AND INVM.MONEY_TYPE = IR.OTHER_MONEY
				<cfelseif attributes.is_money2 eq 1>
					AND INVM.ACTION_ID = I.INVOICE_ID
					AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money2#">
				</cfif>
				<cfif isdefined("session.pp.userid")>AND P.COMPANY_ID=	#session.pp.company_id#</cfif>
			GROUP BY
				<cfif attributes.is_other_money eq 1>
					IR.OTHER_MONEY,
				</cfif>
				<cfif attributes.report_type eq 1>
				PC.PRODUCT_CAT,
				PC.PRODUCT_CATID,
				PC.HIERARCHY
				<cfelseif attributes.report_type eq 2>
				PC.PRODUCT_CAT,
				PC.PRODUCT_CATID,
				PC.HIERARCHY,
				P.PRODUCT_ID,
				P.PRODUCT_NAME,
				P.BARCOD,
				IR.PRODUCT_ID,
				IR.UNIT,
				IR.PRICE
				<cfelseif attributes.report_type eq 3>
				PC.PRODUCT_CAT,
				PC.PRODUCT_CATID,
				PC.HIERARCHY,
				P.PRODUCT_NAME,
				P.PRODUCT_ID,
				S.PROPERTY,
				S.BARCOD,
				IR.STOCK_ID,
				IR.UNIT,
				IR.PRICE
				<cfelseif attributes.report_type eq 4>
				C.NICKNAME,
				C.COMPANY_ID
				<cfelseif attributes.report_type eq 5>
				I.INVOICE_NUMBER,
				I.DEPARTMENT_ID,
				I.DEPARTMENT_LOCATION,
				C.NICKNAME,
				C.COMPANY_ID,
				I.INVOICE_DATE,
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				PC.PRODUCT_CATID,
				S.PRODUCT_ID,
				P.PRODUCT_NAME,
				P.PRODUCT_CODE,
				P.MANUFACT_CODE,
				IR.UNIT,
				IR.PRICE
				<cfelseif attributes.report_type eq 6>
				PB.BRAND_NAME,
				P.BRAND_ID
				</cfif>
		</cfquery>
		<cfquery name="get_total_purchase_3" dbtype="query">
			SELECT * FROM get_total_purchase
			UNION 
			SELECT * FROM get_total_purchase_2
		</cfquery>
		<cfquery name="get_total_purchase" dbtype="query">
			SELECT 
				SUM(PRICE) AS PRICE,
				SUM(ISKONTO) AS ISKONTO
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				,SUM(PRICE_DOVIZ) AS PRICE_DOVIZ
				,SUM(ISKONTO_DOVIZ) AS ISKONTO_DOVIZ
			</cfif>
			<cfif attributes.report_type eq 1>
				,PRODUCT_CAT,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 2>
				,PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,BARCOD,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 3>
				,PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,BARCOD
				,PROPERTY,STOCK_ID,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 4>
				,NICKNAME,COMPANY_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 5>
				,INVOICE_NUMBER,I.DEPARTMENT_ID,
				I.DEPARTMENT_LOCATION,MUSTERI,COMPANY_ID,BIRIM_FIYAT,INVOICE_DATE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,MANUFACT_CODE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,BIRIM
			<cfelseif attributes.report_type eq 6>
				,BRAND_NAME,BRAND_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			</cfif>		
			FROM 
				get_total_purchase_3
			GROUP BY 
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			<cfif attributes.report_type eq 1>	
				PRODUCT_CAT
			<cfelseif attributes.report_type eq 2>
				PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,BIRIM,BARCOD
			<cfelseif attributes.report_type eq 3>
				PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,PROPERTY,STOCK_ID,BIRIM,BARCOD
			<cfelseif attributes.report_type eq 4>
				NICKNAME,COMPANY_ID
			<cfelseif attributes.report_type eq 5>
				INVOICE_NUMBER,
				I.DEPARTMENT_ID,
				I.DEPARTMENT_LOCATION,
				INVOICE_DATE,
				COMPANY_ID,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				MANUFACT_CODE,
				BIRIM,
				MUSTERI,
				BIRIM_FIYAT
			<cfelseif attributes.report_type eq 6>
				BRAND_NAME,BRAND_ID
			</cfif>	
			ORDER  BY 
			<cfif attributes.kontrol_type eq 1>
				INVOICE_NUMBER
			<cfelseif attributes.report_sort eq 1>
				PRICE DESC
			<cfelse>
				<cfif attributes.report_type neq 1>
					PRODUCT_STOCK DESC
				<cfelse>
					PRODUCT_CAT, PRICE DESC
				</cfif>				
			</cfif>
		</cfquery>
	</cfif>
	<cfquery name="get_all_total" dbtype="query">
		SELECT SUM(PRICE) AS PRICE FROM get_total_purchase
	</cfquery>
	<cfif len(get_all_total.PRICE)>
		<cfset butun_toplam=get_all_total.PRICE>
	<cfelse>
		<cfset butun_toplam=1>
	</cfif>	
	<cfif attributes.report_type eq 4 and attributes.invoice_count eq 1>
		<cfquery name="get_count" datasource="#dsn2#">
			SELECT  
				C.NICKNAME,
				C.COMPANY_ID,
				COUNT(C.COMPANY_ID) AS ISLEM_SAYISI
			FROM
				INVOICE I,
				#dsn_alias#.COMPANY C
			WHERE
				<cfif len(attributes.process_type)>I.PROCESS_CAT IN (#attributes.process_type#) AND</cfif>
				I.PURCHASE_SALES = 0 AND
				I.IS_IPTAL = 0 AND
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
				I.COMPANY_ID = C.COMPANY_ID  
			GROUP  BY	
				C.NICKNAME,
				C.COMPANY_ID
		</cfquery>
		<cfset company_id_list = valuelist(get_count.company_id,',')>
	</cfif>
</cfif>
<cfset toplam_satis=0>
<cfset toplam_satis2=0>
<cfset toplam_iskonto=0>
<cfset toplam_iskonto2=0>
<cfset toplam_birim=0>
<cfset toplam_miktar=0>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr id="gizli">	
	<td class="color-border" colspan="2">
	<table width="100%" border="0" cellpadding="2" cellspacing="1" height="100%">        	
	<tr>
	<td class="color-row" height="100" valign="top">
		<table border="0">
        <cfform name="rapor" method="post" action="#request.self#?fuseaction=objects2.purchase_analyse">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<tr>
			<td class="txtbold" width="100"><cf_get_lang_main no='162.Şirket'></td>
			<td width="235"><cfoutput>#session.pp.company#</cfoutput></td>
			<td><input type="hidden" name="kontrol_type" id="kontrol_type" value="0">
				<input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1 and attributes.kontrol_type eq 0>checked</cfif>>Ciro
				<input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2 and attributes.kontrol_type eq 0>checked</cfif>>Miktar
				<input name="is_other_money" id="is_other_money" value="1" type="checkbox" <cfif attributes.is_other_money eq 1 >checked</cfif>> İşlem Dovizli
				<cfif isdefined("session.pp.money2")><input name="is_money2" id="is_money2" value="1" type="checkbox" <cfif attributes.is_money2 eq 1 >checked</cfif>><cfoutput> #session.pp.money2#</cfoutput> Göster&nbsp;</cfif>
				<input type="checkbox" value="1" onClick="degistir_action();" name="is_excel" id="is_excel"<cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang_main no='446.Excel Getir'>
			</td>
		</tr>
		<tr>
			<td width="80" height="22">Tarih Aralığı</td>
			<td width="210">
				<cfinput value="#dateformat(attributes.date1,'dd/mm/yyyy')#" type="text" maxlength="10" name="date1" style="width:65px;" required="yes" message="Tarih Formatını Kontrol Ediniz!" validate="eurodate">
				<cf_wrk_date_image date_field="date1"> /
				<cfinput value="#dateformat(attributes.date2,'dd/mm/yyyy')#"  type="text" maxlength="10" name="date2" style="width:65px;" required="yes" message="Tarih Formatını Kontrol Ediniz!" validate="eurodate">
				<cf_wrk_date_image date_field="date2">
			</td>
			<td><input type="checkbox" name="kdv_dahil" id="kdv_dahil" value="1" <cfif isdefined("attributes.kdv_dahil") and (attributes.kdv_dahil eq 1)>checked</cfif>>Kdv Dahil&nbsp;
				<input type="checkbox" name="is_return" id="is_return" value="1" <cfif attributes.is_return eq 1>checked</cfif>>İadeler Düşsün
				<input name="is_discount" id="is_discount" value="1" type="checkbox" <cfif attributes.is_discount eq 1 >checked</cfif>> İskonto Göster
			</td>
		</tr>
		<tr>
			<td width="70">Rapor Tipi</td>
			<td width="280">
			<select name="report_type" id="report_type" style="width:175px;" onChange="kontrol();">
				<option value="1" <cfif attributes.report_type eq 1>selected</cfif>>Kategori Bazında</option>
				<option value="2" <cfif attributes.report_type eq 2>selected</cfif>>Ürün Bazında</option>
				<option value="3" <cfif attributes.report_type eq 3>selected</cfif>>Stok Bazında</option>
				<option value="6" <cfif attributes.report_type eq 6>selected</cfif>>Marka Bazında</option>
				<option value="4" <cfif attributes.report_type eq 4>selected</cfif>>Cari Bazında</option>
				<option value="5" <cfif attributes.report_type eq 5>selected</cfif>>Belge ve Stok Bazında</option>
			</select>
			</td>
			<td>
				<select name="graph_type" id="graph_type" style="width:100px;">
					<option value="" selected>Grafik Format</option>
					<option value="cylinder" <cfif attributes.graph_type eq 'cylinder'> selected</cfif>>Cylinder</option>
					<option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>>Pasta</option>
					<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang_main no='251.Bar'></option>
				</select>
				<input name="max_rows" id="max_rows" style="width:30px;" value="<cfoutput>#attributes.max_rows#</cfoutput>"> Görüntüleme Sayısı <cf_wrk_search_button button_type='1' search_function='satir_kontrol()'>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<div <cfif attributes.report_type neq 4>style="display:none"</cfif> id="gizli1">
				<input type="checkbox" name="invoice_count" id="invoice_count" value="1" <cfif attributes.invoice_count eq 1>checked</cfif>>İşlem Sayısı
				</div>
			</td>
		</tr>
		</cfform>
		</table>			
	</td>
	</tr>	
</table>	
</td>
</tr>
<!-- sil -->
</table><br/>
<cfif isdefined("attributes.form_submitted")>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</cfif>
		<table width="98%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.max_rows)+1>
		<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
			<cfset attributes.startrow=1>
			<cfset attributes.max_rows=get_total_purchase.recordcount>
		</cfif>
		<cfif get_total_purchase.recordcount>
			<cfif attributes.page neq 1>
				<cfoutput query="get_total_purchase"  startrow="1" maxrows="#attributes.startrow-1#">
					<cfset toplam_satis=ISKONTO+toplam_satis>
					<cfif attributes.is_money2 eq 1>
						<cfset toplam_satis2=ISKONTO_DOVIZ+toplam_satis2>
					</cfif>
					<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
					<cfif attributes.is_money2 eq 1>
						<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
					</cfif>
					<cfif attributes.report_type eq 5>
						<cfset toplam_birim=BIRIM_FIYAT+toplam_birim>
					</cfif>
					<cfif listfind('2,3,5',attributes.report_type)>				
						<cfif len(PRODUCT_STOCK)>
							<cfset unit_2=REPLACE(birim,'/','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,' ','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,'.','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,'%','_',"ALL")>
							<cfset 'toplam_#unit_2#' = evaluate('toplam_#unit_2#') +PRODUCT_STOCK>
						</cfif>
					<cfelse>
						<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
					</cfif>
				</cfoutput>
			</cfif>				  
			<cfif attributes.report_type eq 1>
				<tr class="color-list">
					<td height="22" class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
					<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
					<cfif attributes.is_discount eq 1>
						<td width="150" align="right" class="txtbold" style="text-align:right;">İskonto Tutar</td>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td width="150" align="right" class="txtbold" style="text-align:right;">İskonto Döviz</td>
						</cfif>
				    </cfif>
					<td width="150" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="150" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Döviz'></td>
				    </cfif>
					<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
				</tr>
				<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
					<cfset toplam_satis=PRICE+toplam_satis>
					<cfif attributes.is_money2 eq 1>
						<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
					</cfif>
					<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
					<cfif attributes.is_money2 eq 1>
						<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
					</cfif>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#PRODUCT_CAT#</td>
						<td align="right" style="text-align:right;">#TLFormat(product_stock,4)#
						<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
						</td>
						<cfif attributes.is_discount eq 1>
							<td align="right" style="text-align:right;">#TLFormat(ISKONTO)# #SESSION.pp.money#</td>
							<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<td align="right" style="text-align:right;">#TLFormat(ISKONTO_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
							</cfif>
						</cfif>
						<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.pp.money#</td>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
						</cfif>
						<td align="right" style="text-align:right;"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
					</tr>
				</cfoutput>
				<cfoutput>
				<tr height="20" class="color-list">
					<td class="txtbold"><cf_get_lang_main no='80.Toplam'></td>
					<td align="right" class="txtbold" style="text-align:right;"><cfif toplam_miktar gt 0>#TLFormat(toplam_miktar)#</cfif></td> 
					<cfif attributes.is_discount eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto)# #SESSION.pp.money# </td>
						<cfif attributes.is_money2 eq 1>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto2)# #SESSION.pp.money2#</td>
						<cfelseif attributes.is_other_money eq 1>
							<td></td>
						</cfif>
					</cfif>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# #SESSION.pp.money# </td>
					<cfif attributes.is_money2 eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis2)# #SESSION.pp.money2#</td>
					</cfif>
					<td colspan="2"></td>
				</tr>
				</cfoutput>	  
			<cfelseif attributes.report_type eq 4>
				<tr  class="color-list">
					<td height="22" class="txtbold">Firma</td>
					<cfif attributes.invoice_count eq 1><td width="75" align="right" class="txtbold" style="text-align:right;">İşlem Sayısı</td></cfif>
					<td width="50" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
					<cfif attributes.is_discount eq 1>
						<td width="150" align="right" class="txtbold" style="text-align:right;">İskonto Tutar</td>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td width="150" align="right" class="txtbold" style="text-align:right;">İskonto Döviz</td>
						</cfif>
				    </cfif>
					<td width="150" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="150" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Döviz'></td>
				    </cfif>
					<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
				</tr>
				<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
					<cfset toplam_satis=PRICE+toplam_satis>
					<cfif attributes.is_money2 eq 1>
						<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
					</cfif>
					<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
					<cfif attributes.is_money2 eq 1>
						<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
					</cfif>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#NICKNAME#</td>
						<cfif isdefined('attributes.invoice_count') and attributes.invoice_count eq 1>
						<td align="center">
						<cfquery name="get_islem" dbtype="query">
							SELECT ISLEM_SAYISI FROM get_count WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_total_purchase.company_id#">
						</cfquery>
						#get_islem.islem_sayisi#
						</td></cfif>
						<td align="right" style="text-align:right;">#TLFormat(product_stock,4)#
						<cfset toplam_miktar=product_stock+toplam_miktar>
						</td>
						<cfif attributes.is_discount eq 1>
							<td align="right" style="text-align:right;">#TLFormat(ISKONTO)# #SESSION.pp.money#</td>
							<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<td align="right" style="text-align:right;">#TLFormat(ISKONTO_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
							</cfif>
						</cfif>
						<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.pp.money#</td>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
						</cfif>
						<td align="right" style="text-align:right;"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
					</tr>
				</cfoutput>
				<cfoutput>
				<tr height="20" class="color-list">
				    <td class="txtbold" colspan="<cfif attributes.invoice_count eq 1>4<cfelseif attributes.invoice_count eq 1>3</cfif>"><cf_get_lang_main no='80.Toplam'></td>
					<td align="right" class="txtbold" style="text-align:right;">
					<cfif toplam_miktar gt 0>#TLFormat(toplam_miktar)#</cfif>
					</td>
					<cfif attributes.is_discount eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto)# #SESSION.pp.money# </td>
						<cfif attributes.is_money2 eq 1>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto2)# #SESSION.pp.money2#</td>
						<cfelseif attributes.is_other_money eq 1>
							<td></td>
						</cfif>
					</cfif>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# #SESSION.pp.money# </td>
					<cfif attributes.is_money2 eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis2)# #SESSION.pp.money2#</td>
					</cfif>
					<td colspan="2"></td>
				</tr>
				</cfoutput>	
			<cfelseif get_total_purchase.recordcount and attributes.report_type eq 5>
			<tr class="color-header" height="22">
				<td class="txtbold">Fatura No</td>
				<td class="txtbold">Fatura Tarihi</td>
				<td class="txtbold">Depo</td>
				<td class="txtbold">Müşteri</td>
				<td class="txtbold">Ürün Kod</td>
				<td class="txtbold"><cf_get_lang_main no='222.Üretici Kodu'></td>
				<td class="txtbold"><cf_get_lang_main no='245.Ürün'> </td>
				<td width="50" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
				<td width="100" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='226.Birim Fiyat'></td>
				<cfif attributes.is_discount eq 1>
					<td width="120" align="right" class="txtbold" style="text-align:right;">İskonto Tutar</td>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						<td width="120" align="right" class="txtbold" style="text-align:right;">İskonto Döviz</td>
					</cfif>
				</cfif>
				<td width="120" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				<td width="75" align="right" class="txtbold" style="text-align:right;">Döviz</td>
				</cfif>
				<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
			</tr>
			<cfset department_name_list = "">
			<cfset department_location_list = "">
			<cfoutput query="get_total_purchase">
				<cfif len(department_id) and not listfind(department_name_list,department_id)>
					<cfset department_name_list=listappend(department_name_list,department_id)>
				</cfif>
			</cfoutput>
			<cfif len(department_name_list)>
				<cfset department_name_list = listsort(department_name_list,"numeric","ASC",",")>
				<cfquery name="get_departman_name" datasource="#dsn#">
					SELECT 
						DEPARTMENT_ID,
						DEPARTMENT_HEAD
					FROM
						BRANCH B,
						DEPARTMENT D
					WHERE
						D.DEPARTMENT_ID IN (#department_name_list#) AND
						B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
						B.BRANCH_ID = D.BRANCH_ID AND
						D.IS_STORE <> 2
					ORDER BY
						D.DEPARTMENT_ID
				</cfquery>
				<cfset department_name_list = listsort(listdeleteduplicates(valuelist(get_departman_name.department_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
			<cfset toplam_satis=PRICE+toplam_satis>
			<cfif attributes.is_money2 eq 1>
				<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
			</cfif>
			<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
			<cfif attributes.is_money2 eq 1>
				<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
			</cfif>				
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#INVOICE_NUMBER#</td>
				<td>#dateformat(INVOICE_DATE,'dd/mm/yyyy')#</td>
				<td><cfif len(department_id) and len(department_location)>
					<cfquery name="get_lokasyon_name" datasource="#dsn#">
						SELECT COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#"> AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_location#">
					</cfquery>
					#get_departman_name.department_head[listfind(department_name_list,department_id,',')]#- #get_lokasyon_name.comment#
					</cfif>
				</td>
				<td>#MUSTERI#</td>
				<td>#PRODUCT_CODE#</td><td>#MANUFACT_CODE#</td><td>
					#PRODUCT_NAME#
				</td>
				<td align="right" style="text-align:right;">
					#TLFormat(PRODUCT_STOCK,4)# #BIRIM#
					<cfif len(PRODUCT_STOCK)>
						<cfset unit_2=REPLACE(birim,'/','_',"ALL")>
						<cfset unit_2=REPLACE(unit_2,' ','_',"ALL")>
						<cfset unit_2=REPLACE(unit_2,'.','_',"ALL")>
						<cfset unit_2=REPLACE(unit_2,'%','_',"ALL")>
						<cfset 'toplam_#unit_2#' = evaluate('toplam_#unit_2#') + PRODUCT_STOCK>
					 </cfif>
				</td>
				<td align="right" style="text-align:right;">#TLFormat(BIRIM_FIYAT)# #SESSION.pp.money#</td><cfset toplam_birim=BIRIM_FIYAT+toplam_birim>
				<cfif attributes.is_discount eq 1>
					<td align="right" style="text-align:right;">#TLFormat(ISKONTO)# #SESSION.pp.money#</td>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						<td align="right" style="text-align:right;">#TLFormat(ISKONTO_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.pp.money#</td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
				</cfif>
				<td align="right" style="text-align:right;"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
			</tr>
			</cfoutput> 
			<cfoutput>
				<tr height="20" class="color-list">
					<td class="txtbold" colspan="7"><cf_get_lang_main no='80.Toplam'></td>
					<td align="right" class="txtbold" style="text-align:right;">
						<cfloop query="get_product_units">
							<cfset unit_2=REPLACE(get_product_units.unit,'/','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,' ','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,'.','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,'%','_',"ALL")>
							<cfif evaluate('toplam_#unit_2#') gt 0>
								#Tlformat(evaluate('toplam_#unit_2#'))# #get_product_units.unit#<br/>
							</cfif>
						</cfloop>
					</td>
					<td align="right" class="txtbold" style="text-align:right;"> #TLFormat(toplam_birim)# #SESSION.pp.money#</td>
					<cfif attributes.is_discount eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto)# #SESSION.pp.money# </td>
						<cfif attributes.is_money2 eq 1>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto2)# #SESSION.pp.money2#</td>
						<cfelseif attributes.is_other_money eq 1>
							<td></td>
						</cfif>
					</cfif>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# #SESSION.pp.money# </td>
					<cfif attributes.is_money2 eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis2)# #SESSION.pp.money2#</td>
					</cfif>
					<td colspan="2"></td>
				</tr>
			</cfoutput>	
			<cfelseif attributes.report_type eq 6>
				<tr  class="color-list">
					<td height="22" class="txtbold">Marka</td>
					<td width="50" align="right" class="txtbold" style="text-align:right;">Miktar</td>
					<cfif attributes.is_discount eq 1>
						<td width="150" align="right" class="txtbold" style="text-align:right;">İskonto Tutar</td>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td width="150" align="right" class="txtbold" style="text-align:right;">İskonto Döviz</td>
						</cfif>
				    </cfif>
					<td width="150" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="150" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Döviz'></td>
				    </cfif>
					<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
				</tr>
				<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
					<cfset toplam_satis=PRICE+toplam_satis>
					<cfif attributes.is_money2 eq 1>
						<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
					</cfif>
					<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
					<cfif attributes.is_money2 eq 1>
						<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
					</cfif>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#brand_name#</td>
						<td align="right" style="text-align:right;">#TLFormat(product_stock,4)#
						<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
						</td>
						<cfif attributes.is_discount eq 1>
							<td align="right" style="text-align:right;">#TLFormat(ISKONTO)# #SESSION.pp.money#</td>
							<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<td align="right" style="text-align:right;">#TLFormat(ISKONTO_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
							</cfif>
						</cfif>
						<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.pp.money#</td>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
						</cfif>
						<td align="right" style="text-align:right;"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
					</tr>
				</cfoutput>
				<cfoutput>
				<tr height="20" class="color-list">
					<td class="txtbold"><cf_get_lang_main no='80.Toplam'></td>
					<td align="right" class="txtbold" style="text-align:right;">
					<cfif toplam_miktar gt 0>#TLFormat(toplam_miktar)#</cfif>
					</td> 
					<cfif attributes.is_discount eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto)# #SESSION.pp.money# </td>
						<cfif attributes.is_money2 eq 1>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto2)# #SESSION.pp.money2#</td>
						<cfelseif attributes.is_other_money eq 1>
							<td></td>
						</cfif>
					</cfif>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# #SESSION.pp.money# </td>
					<cfif attributes.is_money2 eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis2)# #SESSION.pp.money2# </td>
					</cfif>
					<td colspan="2"></td>
				</tr>
				</cfoutput>	
			<cfelse>
				<tr class="color-list">
					<td height="22" class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
					<td class="txtbold">Barkod</td>
					<td class="txtbold"><cf_get_lang_main no='245.Ürün'> </td>
					<td width="30" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
					<cfif attributes.is_discount eq 1>
						<td width="150" align="right" class="txtbold" style="text-align:right;">İskonto Tutar</td>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td width="150" align="right" class="txtbold" style="text-align:right;">İskonto Döviz</td>
						</cfif>
				    </cfif>
					<td width="200" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;"><cf_get_lang_main no='265.Döviz'></td>
					</cfif>
					<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
				</tr>  
				<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<cfset toplam_satis=PRICE+toplam_satis>
				<cfif attributes.is_money2 eq 1>
					<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
				</cfif>
				<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
				<cfif attributes.is_money2 eq 1>
					<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
				</cfif>
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td>#PRODUCT_CAT#</td>
					<cfif attributes.report_type eq 2>
						<td>#BARCOD#</td>
						<td>#PRODUCT_NAME#</td>
					<cfelseif attributes.report_type eq 3>
						<td>#BARCOD#</td>
						<td>#PRODUCT_NAME# #PROPERTY#</td>
					</cfif>
					<td align="right" style="text-align:right;">
						#TLFormat(PRODUCT_STOCK,4)# #BIRIM# 
						<cfif len(PRODUCT_STOCK)>
							<cfset unit_2=REPLACE(birim,'/','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,' ','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,'.','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,'%','_',"ALL")>
							<cfset 'toplam_#unit_2#' = evaluate('toplam_#unit_2#') + PRODUCT_STOCK>
						 </cfif>
					</td>
					<cfif attributes.is_discount eq 1>
						<td align="right" style="text-align:right;">#TLFormat(ISKONTO)# #SESSION.pp.money#</td>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td align="right" style="text-align:right;">#TLFormat(ISKONTO_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
						</cfif>
					</cfif>
					<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.pp.MONEY#</td>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif></td>
					</cfif>
					<td align="right" style="text-align:right;"><cfif butun_toplam gt 0>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
				</tr>
				</cfoutput>
				<cfoutput>
				<tr height="20" class="color-list">
					<td colspan="3" class="txtbold" align="left"> <cf_get_lang_main no='80.Toplam'> </td>
					<td align="right" class="txtbold" style="text-align:right;">
						<cfloop query="get_product_units">
							<cfset unit_2=REPLACE(get_product_units.unit,'/','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,' ','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,'.','_',"ALL")>
							<cfset unit_2=REPLACE(unit_2,'%','_',"ALL")>
							<cfif evaluate('toplam_#unit_2#') gt 0>
								#Tlformat(evaluate('toplam_#unit_2#'))# #get_product_units.unit#<br/>
							</cfif>
						</cfloop>
					</td>
					<cfif attributes.is_discount eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto)# #SESSION.pp.money# </td>
						<cfif attributes.is_money2 eq 1>
							<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_iskonto2)# #SESSION.pp.money2#</td>
						<cfelseif attributes.is_other_money eq 1>
							<td></td>
						</cfif>
					</cfif>
					<td align="right" class="txtbold" style="text-align:right;"> #TLFormat(toplam_satis)# #SESSION.pp.MONEY#</td>
					<cfif attributes.is_money2 eq 1>
						<td align="right" class="txtbold" style="text-align:right;"> #TLFormat(toplam_satis2)# #SESSION.pp.MONEY2#</td>
					</cfif>
					<td colspan="2"></td>
				</tr>
				</cfoutput>  
			</cfif>
		</cfif>
		</table>
	<cfif  isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.max_rows>
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
		<tr> 
			<td>
			<cfscript>
				str_link = "form_submitted=1";				
				str_link = "#str_link#&graph_type=#attributes.graph_type#";
				str_link = "#str_link#&max_rows=#attributes.max_rows#&process_type=#attributes.process_type#&report_sort=#attributes.report_sort#&product_employee_id=#attributes.product_employee_id#";
				str_link = "#str_link#&product_name=#attributes.product_name#&product_id=#attributes.product_id#&is_return=#attributes.is_return#&employee_name=#attributes.employee_name#";
				str_link = "#str_link#&keyword=#attributes.keyword#&employee=#attributes.employee#&employee_id=#attributes.employee_id#&product_id=#attributes.product_id#";
				str_link = "#str_link#&department_id=#attributes.department_id#&department_name=#attributes.department_name#&consumer_id=#attributes.consumer_id#";
				str_link = "#str_link#&company=#attributes.company#&company_id=#attributes.company_id#";
				str_link = "#str_link#&invoice_count=#attributes.invoice_count#";
				str_link = "#str_link#&kdv_dahil=#attributes.kdv_dahil#&date1=#dateformat(attributes.date1,'dd/mm/yyyy')#";
				str_link = "#str_link#&date2=#dateformat(attributes.date2,'dd/mm/yyyy')#&report_type=#attributes.report_type#";
				str_link = "#str_link#&kontrol_type=#attributes.kontrol_type#";
				str_link = "#str_link#&brand_id=#attributes.brand_id#";
				str_link = "#str_link#&brand_name=#attributes.brand_name#";
				str_link = "#str_link#&is_money2=#attributes.is_money2#";
				str_link = "#str_link#&is_other_money=#attributes.is_other_money#";
				str_link = "#str_link#&is_discount=#attributes.is_discount#";
				str_link = "#str_link#&member_cat_type=#attributes.member_cat_type#";
			</cfscript>
			<cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.max_rows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="report.purchase_analyse_report&#str_link#"> 
			</td> 
		<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
	</cfif>	
</cfif> 
<!--- Grafik Başlangıç --->
<cfif isdefined("attributes.form_submitted") and len(attributes.graph_type)>
<table width="98%" cellpadding="2" cellspacing="1" border="0" align="center" class="color-border">
		<tr class="color-row">
			<td align="center">
			<cfif isDefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "cylinder">
			</cfif>
			 <cfchart
				show3d="yes"
				backgroundcolor="#colorrow#"
				tipbgcolor="#colorrow#"
				labelformat="number"
				pieslicestyle="solid"
				format="flash"
				chartwidth="800"
				chartheight="400"
				scalefrom="100000"
				seriesplacement="default">
				<cfchartseries type="#graph_type#" paintstyle="light">	
				<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
					<cfset 'sum_of_total#currentrow#' =  NumberFormat(PRICE*100/butun_toplam,'00.00')>
					<!--- Kategori Bazında ise --->
					<cfif attributes.REPORT_TYPE eq 1>
						<cfset item_value = left(PRODUCT_CAT,30) >
					<!--- Ürün Bazında ise --->	
					<cfelseif attributes.REPORT_TYPE eq 2>
						<cfset item_value = left(PRODUCT_NAME,30)>
					<!--- Stok Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 3>
						<cfset item_value = left('#PRODUCT_NAME#&nbsp;#PROPERTY#',30)>
					<!--- Marka Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 6>	
						<cfset item_value = left(BRAND_NAME,30)>
					<!--- Cari Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 4>	
						<cfset item_value = left(NICKNAME,30)>
					<!---Belge ve Stok Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 5>	
						<cfset item_value = left(INVOICE_NUMBER,30)>
					</cfif>
					<cfchartdata item="#item_value#" value="#Evaluate("sum_of_total#currentrow#")#">
				</cfoutput>	
				</cfchartseries>
			</cfchart>
			</td>
		</tr>
</table>
</cfif>				
<!--- Grafik Bitiş --->			  
<br/>
<script type="text/javascript">
function set_the_report()
	{
		rapor.report_type.checked = false;
	}
function satir_kontrol()
	{
		if(document.rapor.is_excel.checked == false)
		 if(document.rapor.max_rows.value > 250)
		 	{
				alert ("Görüntüleme Sayısı 250 den fazla olamaz!");
				return false;
			}
		return true;
	}
function kontrol()
{
	deger = rapor.report_type.options[rapor.report_type.selectedIndex].value;
	if (deger != 4  && rapor.form_submitted.value == 1)
	{
		gizli1.style.display = 'none';
	}
	else
	{
		gizli1.style.display = '';
	}
	if (deger == 5)
		rapor.kontrol_type.value = 1;
	else
		rapor.kontrol_type.value = 0;
}
</script>
