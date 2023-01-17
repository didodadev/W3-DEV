<cfset kontrol_file = 0>
<cfset upload_folder = "#upload_folder#sales#dir_seperator#">
 <cftry> 
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	 <cfcatch type="Any">
		<cfset kontrol_file = 1>
	</cfcatch>
</cftry> 
<cfif len(attributes.sale_scope_) and attributes.sale_scope_ eq 1><!--- Satış Bölgesi Bazında --->
	<cfquery name="get_sz_name" datasource="#dsn#">
		SELECT SZ_NAME,SZ_ID FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
	</cfquery>
<cfelseif len(attributes.sale_scope_) and attributes.sale_scope_ eq 2><!--- Şube Bazında --->
	<cfquery name="get_sz_name" datasource="#dsn#">
		SELECT BRANCH_NAME SZ_NAME,BRANCH_ID SZ_ID FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# AND BRANCH_STATUS=1 ORDER BY BRANCH_NAME
	</cfquery>
<cfelseif len(attributes.sale_scope_) and attributes.sale_scope_ eq 3><!--- Satış Takımı Bazında--->
	<cfquery name="get_sz_name" datasource="#dsn#">
		SELECT DISTINCT SZT.TEAM_NAME SZ_NAME,SZT.TEAM_ID SZ_ID FROM SALES_ZONES_TEAM SZT WHERE SZT.SALES_ZONES = #attributes.zone_id_# ORDER BY SZT.TEAM_NAME
	</cfquery>
<cfelseif len(attributes.sale_scope_) and attributes.sale_scope_ eq 4><!--- Mikro Bölge Bazında--->
	<cfquery name="get_sz_name" datasource="#dsn#">
		SELECT DISTINCT SC.IMS_CODE_ID SZ_ID,SC.IMS_CODE_NAME SZ_NAME FROM SALES_ZONES_TEAM SZT,SALES_ZONES_TEAM_IMS_CODE IMC,SETUP_IMS_CODE SC WHERE SZT.TEAM_ID = IMC.TEAM_ID AND IMC.IMS_ID = SC.IMS_CODE_ID AND SZT.SALES_ZONES = #attributes.zone_id_# ORDER BY SC.IMS_CODE_NAME
	</cfquery>
<cfelseif len(attributes.sale_scope_) and attributes.sale_scope_ eq 5><!--- Çalışan Bazında--->
	<cfquery name="get_sz_name" datasource="#dsn#">
		SELECT DISTINCT EP.EMPLOYEE_NAME SZ_NAME,EP.EMPLOYEE_SURNAME SZ_NAME2,EP.EMPLOYEE_ID SZ_ID FROM SALES_ZONES_TEAM SZT,SALES_ZONES_TEAM_ROLES IMC,EMPLOYEE_POSITIONS EP WHERE SZT.TEAM_ID = IMC.TEAM_ID AND IMC.POSITION_CODE = EP.POSITION_CODE AND SZT.SALES_ZONES = #attributes.zone_id_# ORDER BY EP.EMPLOYEE_NAME,EP.EMPLOYEE_SURNAME
	</cfquery>
<cfelseif len(attributes.sale_scope_) and attributes.sale_scope_ eq 6><!--- Müşteri Bazında---><!---  ---><!---  --->
	<cfquery name="get_sz_name" datasource="#dsn#">
		SELECT SZ_NAME,SZ_ID FROM SALES_ZONES WHERE IS_ACTIVE = 1 ORDER BY SZ_NAME
	</cfquery>
<cfelseif len(attributes.sale_scope_) and attributes.sale_scope_ eq 7><!--- Ürün kategorisi Bazında--->
	<cfquery name="get_sz_name" datasource="#dsn3#">
		SELECT PRODUCT_CAT SZ_NAME,PRODUCT_CATID SZ_ID FROM PRODUCT_CAT WHERE PRODUCT_CATID IN(SELECT PRODUCT_CATID FROM #dsn1_alias#.PRODUCT_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#) AND HIERARCHY NOT LIKE '%.%' ORDER BY PRODUCT_CAT
	</cfquery>
<cfelseif len(attributes.sale_scope_) and attributes.sale_scope_ eq 8><!--- Marka Bazında--->
	<cfquery name="get_sz_name" datasource="#dsn3#">
		SELECT  BRAND_NAME SZ_NAME,BRAND_ID  SZ_ID FROM PRODUCT_BRANDS WHERE BRAND_ID IN(SELECT BRAND_ID FROM #dsn1_alias#.PRODUCT_BRANDS_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#) AND IS_ACTIVE = 1 ORDER BY BRAND_NAME
	</cfquery>
<cfelseif len(attributes.sale_scope_) and attributes.sale_scope_ eq 9><!--- Üye Kategorisi Bazında--->
	<cfquery name="get_sz_name" datasource="#dsn#">
		SELECT COMPANYCAT SZ_NAME,COMPANYCAT_ID SZ_ID FROM COMPANY_CAT ORDER BY COMPANYCAT
	</cfquery>
<cfelse>
	<cfset sz_name = ''>
	<cfset sz_name2 = ''>
</cfif>

<cfif kontrol_file eq 0 and get_sz_name.recordcount>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	<cfif line_count gt get_sz_name.recordcount+1><!--- query den gelen satır sayisi ile cvs den gelen satir sayisi ayni degilse hata veriyordu --->
		<cfset line_count = get_sz_name.recordcount+1>
	<cfelseif line_count lt get_sz_name.recordcount+1>
		<cfset kontrol_file = 1>
	</cfif>
	
	<cfloop from="2" to="#line_count#" index="k">
		<cfset j= 1>
		<cfscript>
			revenue_tl_1 = Listgetat(dosya[k],j,";"); // Ciro TL(Ocak)
			revenue_tl_1 = trim(revenue_tl_1);
			j=j+1;
			
			revenue_usd_1 = Listgetat(dosya[k],j,";"); //Ciro USD(Ocak)
			revenue_usd_1 = trim(revenue_usd_1);
			j=j+1;
			
			amount_1 = Listgetat(dosya[k],j,";"); //Miktar(Ocak)
			amount_1 = trim(amount_1);
			j=j+1;
			
			profit_1 = Listgetat(dosya[k],j,";"); //Kar %(Ocak)
			profit_1 = trim(profit_1);
			j=j+1;
			
			bonus_1 = Listgetat(dosya[k],j,";"); //Prim %(Ocak)
			bonus_1 = trim(bonus_1);
			j=j+1;
			
			revenue_tl_2 = Listgetat(dosya[k],j,";"); // Ciro TL(Subat)
			revenue_tl_2 = trim(revenue_tl_2);
			j=j+1;
			
			revenue_usd_2 = Listgetat(dosya[k],j,";"); //Ciro USD(Subat)
			revenue_usd_2 = trim(revenue_usd_2);
			j=j+1;
			
			amount_2 = Listgetat(dosya[k],j,";"); //Miktar(Subat)
			amount_2 = trim(amount_2);
			j=j+1;
			
			profit_2 = Listgetat(dosya[k],j,";"); //Kar %(Subat)
			profit_2 = trim(profit_2);
			j=j+1;
			
			bonus_2 = Listgetat(dosya[k],j,";"); //Prim %(Subat)
			bonus_2 = trim(bonus_2);
			j=j+1;
			
			revenue_tl_3 = Listgetat(dosya[k],j,";"); // Ciro TL(Mart)
			revenue_tl_3 = trim(revenue_tl_3);
			j=j+1;
			
			revenue_usd_3 = Listgetat(dosya[k],j,";"); //Ciro USD(Mart)
			revenue_usd_3 = trim(revenue_usd_3);
			j=j+1;
			
			amount_3 = Listgetat(dosya[k],j,";"); //Miktar(Mart)
			amount_3 = trim(amount_3);
			j=j+1;
			
			profit_3 = Listgetat(dosya[k],j,";"); //Kar %(Mart)
			profit_3 = trim(profit_3);
			j=j+1;
			
			bonus_3 = Listgetat(dosya[k],j,";"); //Prim %(Mart)
			bonus_3 = trim(bonus_3);
			j=j+1;
			
			revenue_tl_4 = Listgetat(dosya[k],j,";"); // Ciro TL(Nisan)
			revenue_tl_4 = trim(revenue_tl_4);
			j=j+1;
			
			revenue_usd_4 = Listgetat(dosya[k],j,";"); //Ciro USD(Nisan)
			revenue_usd_4 = trim(revenue_usd_4);
			j=j+1;
			
			amount_4 = Listgetat(dosya[k],j,";"); //Miktar(Nisan)
			amount_4 = trim(amount_4);
			j=j+1;
			
			profit_4 = Listgetat(dosya[k],j,";"); //Kar %(Nisan)
			profit_4 = trim(profit_4);
			j=j+1;
			
			bonus_4 = Listgetat(dosya[k],j,";"); //Prim %(Nisan)
			bonus_4 = trim(bonus_4);
			j=j+1;
			
			revenue_tl_5 = Listgetat(dosya[k],j,";"); // Ciro TL(Mayıs)
			revenue_tl_5 = trim(revenue_tl_5);
			j=j+1;
			
			revenue_usd_5 = Listgetat(dosya[k],j,";"); //Ciro USD(Mayıs)
			revenue_usd_5 = trim(revenue_usd_5);
			j=j+1;
			
			amount_5 = Listgetat(dosya[k],j,";"); //Miktar(Mayıs)
			amount_5 = trim(amount_5);
			j=j+1;
			
			profit_5 = Listgetat(dosya[k],j,";"); //Kar %(Mayıs)
			profit_5 = trim(profit_5);
			j=j+1;
			
			bonus_5 = Listgetat(dosya[k],j,";"); //Prim %(Mayıs)
			bonus_5 = trim(bonus_5);
			j=j+1;
			
			revenue_tl_6 = Listgetat(dosya[k],j,";"); // Ciro TL(Haziran)
			revenue_tl_6 = trim(revenue_tl_6);
			j=j+1;
			
			revenue_usd_6 = Listgetat(dosya[k],j,";"); //Ciro USD(Haziran)
			revenue_usd_6 = trim(revenue_usd_6);
			j=j+1;
			
			amount_6 = Listgetat(dosya[k],j,";"); //Miktar(Haziran)
			amount_6 = trim(amount_6);
			j=j+1;
			
			profit_6 = Listgetat(dosya[k],j,";"); //Kar %(Haziran)
			profit_6 = trim(profit_6);
			j=j+1;
			
			bonus_6 = Listgetat(dosya[k],j,";"); //Prim %(Haziran)
			bonus_6 = trim(bonus_6);
			j=j+1;
			
			revenue_tl_7 = Listgetat(dosya[k],j,";"); // Ciro TL(Temmuz)
			revenue_tl_7 = trim(revenue_tl_7);
			j=j+1;
			
			revenue_usd_7 = Listgetat(dosya[k],j,";"); //Ciro USD(Temmuz)
			revenue_usd_7 = trim(revenue_usd_7);
			j=j+1;
			
			amount_7 = Listgetat(dosya[k],j,";"); //Miktar(Temmuz)
			amount_7 = trim(amount_7);
			j=j+1;
			
			profit_7 = Listgetat(dosya[k],j,";"); //Kar %(Temmuz)
			profit_7 = trim(profit_7);
			j=j+1;
			
			bonus_7 = Listgetat(dosya[k],j,";"); //Prim %(Temmuz)
			bonus_7 = trim(bonus_7);
			j=j+1;
			
			revenue_tl_8 = Listgetat(dosya[k],j,";"); // Ciro TL(Agustos)
			revenue_tl_8 = trim(revenue_tl_8);
			j=j+1;
			
			revenue_usd_8 = Listgetat(dosya[k],j,";"); //Ciro USD(Agustos)
			revenue_usd_8 = trim(revenue_usd_8);
			j=j+1;
			
			amount_8 = Listgetat(dosya[k],j,";"); //Miktar(Agustos)
			amount_8 = trim(amount_8);
			j=j+1;
			
			profit_8 = Listgetat(dosya[k],j,";"); //Kar %(Agustos)
			profit_8 = trim(profit_8);
			j=j+1;
			
			bonus_8 = Listgetat(dosya[k],j,";"); //Prim %(Agustos)
			bonus_8 = trim(bonus_8);
			j=j+1;
			
			revenue_tl_9 = Listgetat(dosya[k],j,";"); // Ciro TL(Eylul)
			revenue_tl_9 = trim(revenue_tl_9);
			j=j+1;
			
			revenue_usd_9 = Listgetat(dosya[k],j,";"); //Ciro USD(Eylul)
			revenue_usd_9 = trim(revenue_usd_9);
			j=j+1;
			
			amount_9 = Listgetat(dosya[k],j,";"); //Miktar(Eylul)
			amount_9 = trim(amount_9);
			j=j+1;
			
			profit_9 = Listgetat(dosya[k],j,";"); //Kar %(Eylul)
			profit_9 = trim(profit_9);
			j=j+1;
			
			bonus_9 = Listgetat(dosya[k],j,";"); //Prim %(Eylul)
			bonus_9 = trim(bonus_9);
			j=j+1;
			
			revenue_tl_10 = Listgetat(dosya[k],j,";"); // Ciro TL(Ekim)
			revenue_tl_10 = trim(revenue_tl_10);
			j=j+1;
			
			revenue_usd_10 = Listgetat(dosya[k],j,";"); //Ciro USD(Ekim)
			revenue_usd_10 = trim(revenue_usd_10);
			j=j+1;
			
			amount_10 = Listgetat(dosya[k],j,";"); //Miktar(Ekim)
			amount_10 = trim(amount_10);
			j=j+1;
			
			profit_10 = Listgetat(dosya[k],j,";"); //Kar %(Ekim)
			profit_10 = trim(profit_10);
			j=j+1;
			
			bonus_10 = Listgetat(dosya[k],j,";"); //Prim %(Ekim)
			bonus_10 = trim(bonus_10);
			j=j+1;
			
			revenue_tl_11 = Listgetat(dosya[k],j,";"); // Ciro TL(Kasim)
			revenue_tl_11 = trim(revenue_tl_11);
			j=j+1;
			
			revenue_usd_11 = Listgetat(dosya[k],j,";"); //Ciro USD(Kasim)
			revenue_usd_11 = trim(revenue_usd_11);
			j=j+1;
			
			amount_11 = Listgetat(dosya[k],j,";"); //Miktar(Kasim)
			amount_11 = trim(amount_11);
			j=j+1;
			
			profit_11 = Listgetat(dosya[k],j,";"); //Kar %(Kasim)
			profit_11 = trim(profit_11);
			j=j+1;
			
			bonus_11 = Listgetat(dosya[k],j,";"); //Prim %(Kasim)
			bonus_11 = trim(bonus_11);
			j=j+1;
			
			revenue_tl_12 = Listgetat(dosya[k],j,";"); // Ciro TL(Aralik)
			revenue_tl_12 = trim(revenue_tl_12);
			j=j+1;
			
			revenue_usd_12 = Listgetat(dosya[k],j,";"); //Ciro USD(Aralik)
			revenue_usd_12 = trim(revenue_usd_12);
			j=j+1;
			
			amount_12 = Listgetat(dosya[k],j,";"); //Miktar(Aralik)
			amount_12 = trim(amount_12);
			j=j+1;
			
			profit_12 = Listgetat(dosya[k],j,";"); //Kar %(Aralik)
			profit_12 = trim(profit_12);
			j=j+1;
			
			bonus_12 = Listgetat(dosya[k],j,";"); //Prim %(Aralik)
			bonus_12 = trim(bonus_12);
			j=j+1;
		</cfscript>
		<cfoutput>
			<cfset sz_name = get_sz_name.SZ_NAME[k-1]>
			<cfif isdefined("get_sz_name.SZ_NAME2")>
				<cfset sz_name2 = get_sz_name.SZ_NAME2[k-1]>
			<cfelse>
				<cfset sz_name2 = ''>
			</cfif>
			<cfset sz_id = get_sz_name.SZ_ID[k-1]>
			<script type="text/javascript">
				add_row("#sz_id#","#sz_name#","#attributes.sale_scope_#","#revenue_tl_1#","#revenue_usd_1#","#amount_1#","#profit_1#","#bonus_1#","#revenue_tl_2#","#revenue_usd_2#","#amount_2#","#profit_2#","#bonus_2#","#revenue_tl_3#","#revenue_usd_3#","#amount_3#","#profit_3#","#bonus_3#","#revenue_tl_4#","#revenue_usd_4#","#amount_4#","#profit_4#","#bonus_4#","#revenue_tl_5#","#revenue_usd_5#","#amount_5#","#profit_5#","#bonus_5#","#revenue_tl_6#","#revenue_usd_6#","#amount_6#","#profit_6#","#bonus_6#","#revenue_tl_7#","#revenue_usd_7#","#amount_7#","#profit_7#","#bonus_7#","#revenue_tl_8#","#revenue_usd_8#","#amount_8#","#profit_8#","#bonus_8#","#revenue_tl_9#","#revenue_usd_9#","#amount_9#","#profit_9#","#bonus_9#","#revenue_tl_10#","#revenue_usd_10#","#amount_10#","#profit_10#","#bonus_10#","#revenue_tl_11#","#revenue_usd_11#","#amount_11#","#profit_11#","#bonus_11#","#revenue_tl_12#","#revenue_usd_12#","#amount_12#","#profit_12#","#bonus_12#");
			</script>
		</cfoutput>
	</cfloop>
</cfif>
