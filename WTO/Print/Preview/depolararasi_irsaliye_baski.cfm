<!--- stok depolararası sevk irsaliyesi print şablonu --->
<cfset attributes.ship_id = attributes.action_id> 

<cfquery name="Ship" datasource="#dsn2#">
	SELECT
		SHIP.*,
		#dsn_alias#.DEPARTMENT.DEPARTMENT_HEAD
	FROM
		SHIP,
		#dsn_alias#.DEPARTMENT
	WHERE
		SHIP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND
		#dsn_alias#.DEPARTMENT.DEPARTMENT_ID = SHIP.DELIVER_STORE_ID
</cfquery>
<cfif Ship.Ship_Type neq 81>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='30018.Improper document type!'>!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="Get_Ship_Row" datasource="#dsn2#">
	SELECT 
		PRODUCT_ID,
        NAME_PRODUCT,
        AMOUNT,
        UNIT,
        NETTOTAL,
        PRICE,
        DISCOUNT,
        TAX
	FROM 
		SHIP_ROW
	WHERE 
		SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
	ORDER BY
		SHIP_ROW_ID
</cfquery>
<cfquery name="Get_My_Company" datasource="#dsn#">
	SELECT COMPANY_NAME,ADDRESS	FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="Get_Name_Of_Dep_Giris" datasource="#dsn#">
	SELECT 
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
		B.BRANCH_ADDRESS,
		B.BRANCH_COUNTY,
		B.BRANCH_CITY 
	FROM 
		DEPARTMENT D,
		BRANCH B 
	WHERE 
		D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship.Department_In#"> AND 
		D.BRANCH_ID = B.BRANCH_ID AND 
		D.IS_STORE <> 2
</cfquery>
<cfquery name="Get_Name_Of_Dep_Cikis" datasource="#dsn#">
	SELECT 
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
		B.BRANCH_ADDRESS,
		B.BRANCH_COUNTY,
		B.BRANCH_CITY 
	FROM 
		DEPARTMENT D,
		BRANCH B 
	WHERE 
		D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship.Deliver_Store_Id#"> AND 
		D.BRANCH_ID = B.BRANCH_ID AND 
		D.IS_STORE <> 2
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	    COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<table style="width:210mm">
    <tr>
        <td>
            <table style="width:100%">
                <tr class="row_border">
                    <td class="print-head"></td>
                    <td class="print_title"><cf_get_lang dictionary_id='39192.Depolararası Sevk İrsaliyesi'></td>
                    <td style="text-align:right;">
                        <cfif len(check.asset_file_name2)>
                        <cfset attributes.type = 1>
                        <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                        </cfif>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <cfset Row_Start = 1>
            <cfset Row_End = 30>
            <cfset Page_Count = ceiling(Get_Ship_Row.recordcount / Row_End)>
            <cfif Page_Count eq 0><cfset Page_Count = 1></cfif>
            <cfloop from="1" to="#Page_Count#" index="j">
                <table style="width:100%;" align="center">
                    <cfoutput>
                        <tr>
                            <td style="width:140px"><b><cf_get_lang dictionary_id='58138.İrsaliye No'></b></td>
                            <td style="width:170px">#Ship.Ship_Number#</td>
                            <td style="width:140px"><b><cf_get_lang dictionary_id='34797.Sevk Tarihi'></b></td>
                            <td style="width:170px">#dateformat(SHIP.ship_date,dateformat_style)#</td>
                        </tr>
                        <tr>
                            <td><b><cf_get_lang dictionary_id='33658.Giriş Depo'></b></td>
                            <td>
                                <cfif len(Ship.Department_In) and len(Ship.Location_In)>
                                <cfquery name="Get_In_Location" datasource="#dsn#">
                                    SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship.Location_In#"> AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship.Department_In#">
                                </cfquery>
                                #Get_In_Location.Comment#
                                </cfif>
                            </td>
                            <td><b><cf_get_lang dictionary_id='34140.Fiili Sevk Tarihi'></b></td>
                            <td>#dateformat(Ship.Deliver_Date,dateformat_style)#</td>
                        </tr>
                        <tr>
                            <td><b><cf_get_lang dictionary_id='57775.Teslim Alan'></b></td>
                            <td><cfif len(ship.deliver_emp)></cfif>#ship.deliver_emp#</td>
                        </tr>
                        <tr class="row_border">
                            <td valign="top"><b><cf_get_lang dictionary_id='29428.Çıkış Depo'></b></td>
                                <td colspan="3">#Get_Name_Of_Dep_Cikis.Branch_Name#-
                                    <cfif len(Ship.Deliver_Store_Id) and len(Ship.Location)>
                                        <cfquery name="Get_Out_Location" datasource="#dsn#">
                                            SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship.Location#"> AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship.Deliver_Store_Id#">
                                        </cfquery>
                                        #Get_Out_Location.Comment#
                                    </cfif>
                                    <br/>
                                        #Get_Name_Of_Dep_Giris.Branch_Address# #Get_Name_Of_Dep_Giris.Branch_County# #Get_Name_Of_Dep_Giris.Branch_City#
                                </td>
                        </tr>
                        <tr><td style="height:10mm;">&nbsp;</td></tr>
                </cfoutput>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <table class="print_border" style="width:100%;">
                <tr>
                    <td class="bold"><cf_get_lang dictionary_id='58800.Ürün Kodu'></td>
                    <td class="bold"><cf_get_lang dictionary_id='57657.Ürün'></td>
                    <td class="bold"><cf_get_lang dictionary_id='57635.Miktar'></td>
                    <td class="bold"><cf_get_lang dictionary_id='57636.Birim'></td>
                </tr>
                <cfoutput>
                    <cfloop from="#Row_Start#" to="#Row_End#" index="i">
                        <cfif i lte Get_Ship_Row.RecordCount>
                            <cfscript>
                                if(len(Get_Ship_Row.Discount[i]))indirim = Get_Ship_Row.Discount[i]; else indirim = 0;
                                adim_1 = Get_Ship_Row.Amount[i] * Get_Ship_Row.Price[i];
                                adim_2 = (adim_1/100)*(100-indirim);
                                adim_3 = adim_2*(Get_Ship_Row.Tax[i]/100);
                                adim_4 = adim_2+adim_3;
                            </cfscript>
                            <cfquery name="Get_Product" datasource="#dsn3#">
                                SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Ship_Row.product_id[i]#">
                            </cfquery>
                            <tr>
                                <td>#Get_Product.Product_Code#</td>
                                <td>#left(Get_Ship_Row.Name_Product[i],53)#</td>
                                <td style="text-align:right;">#Get_Ship_Row.Amount[i]#</td>
                                <td>#Get_Ship_Row.Unit[i]#</td>
                            </tr>
                        </cfif>
                    </cfloop>
                </cfoutput>
            </table>
        </td>
    </tr>
    <tr><td style="height:10mm;">&nbsp;</td></tr>
    <cfset Row_Start = Row_Start + 30>
    <cfset Row_End = Row_Start + 29>
            </cfloop>    
</table>   
<table>
	<tr class="fixed">
		<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
	</tr>
</table>

