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
<cfset Row_Start = 1>
<cfset Row_End = 30>
<cfset Page_Count = ceiling(Get_Ship_Row.recordcount / Row_End)>
<cfif Page_Count eq 0><cfset Page_Count = 1></cfif>
<cfloop from="1" to="#Page_Count#" index="j">
    <table border="0" cellspacing="0" cellpadding="0" style="width:210mm;height:279.6mm;">
        <tr>
            <td style="width:2mm">&nbsp;</td>
            <td valign="top">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td>
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tr><td colspan="2" style="height:42mm;">&nbsp;</td></tr>
                                <tr>
                                    <td valign="top" style="width:140mm;height:62mm;">
                                        <table style="width:110mm;"  cellpadding="0" cellspacing="0">
                                        <cfoutput>
                                            <tr>
                                                <td valign="top" style="width:85mm;height:35mm;">
                                                    <b>#Get_My_Company.Company_Name#</b><br/>
                                                    <b><cf_get_lang no='1268.Giriş Depo'> : </b>&nbsp;#Get_Name_Of_Dep_Giris.Branch_Name#-
                                                    <cfif len(Ship.Department_In) and len(Ship.Location_In)>
                                                        <cfquery name="Get_In_Location" datasource="#dsn#">
                                                            SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship.Location_In#"> AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ship.Department_In#">
                                                        </cfquery>
                                                        #Get_In_Location.Comment#
                                                    </cfif><br/>
                                                    <b><cf_get_lang_main no='1631.Çıkış Depo'> : </b>&nbsp;#Get_Name_Of_Dep_Cikis.Branch_Name#-
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
                                            <tr>
                                                <td valign="bottom">
                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                        <tr><td colspan="4" class="txtbold">&nbsp;</td></tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </cfoutput>
                                        </table>
                                    </td>
                                    <td valign="top">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                        <cfoutput>
                                            <tr>
                                                <td style="height:36mm;">&nbsp;</td>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td style="width:24mm;height:5mm" class="txtbold">#dateformat(SHIP.ship_date,dateformat_style)#</td>
                                                <td><cf_get_lang_main no='726.İrs No'>:#Ship.Ship_Number#</td>
                                            </tr>
                                            <tr>
                                                <td style="height:5mm;">#dateformat(Ship.Deliver_Date,dateformat_style)#</td>
                                                <td>&nbsp;</td>
                                            </tr>
                                        </cfoutput>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="height:148mm;" valign="top">
                            <table>
                                <tr>
                                    <td class="bold"><cf_get_lang dictionary_id='58800.Product Code'></td>
                                    <td class="bold"><cf_get_lang dictionary_id='57657.Product'></td>
                                    <td class="bold"><cf_get_lang dictionary_id='57635.Quantity'></td>
                                    <td class="bold"><cf_get_lang dictionary_id='57636.Unit'></td>
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
                                            <td style="width:25mm;">#Get_Product.Product_Code#</td>
                                            <td style="width:110mm;">#left(Get_Ship_Row.Name_Product[i],53)#</td>
                                            <td style="width:10mm;" style="text-align:right;">#Get_Ship_Row.Amount[i]#</td>
                                            <td>#Get_Ship_Row.Unit[i]#</td>
                                        </tr>
                                    </cfif>
                                </cfloop>
                            </cfoutput>
                            </table>
                        </td>
                    </tr>	  
                    <tr>
                        <td valign="top">
                            <table>
                            <cfoutput>
                                <tr>
                                    <td style="width:140mm;">&nbsp;</td>
                                    <td style="width:20mm;text-align:right;"><cfif len(ship.deliver_emp)></cfif>#ship.deliver_emp#</td>
                                </tr>
                            </cfoutput>
                            </table>
                        </td>
                    </tr>		  
                </table>
            </td>
        </tr>
    </table>
	<cfset Row_Start = Row_Start + 30>
    <cfset Row_End = Row_Start + 29>
</cfloop>

