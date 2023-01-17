<!--- Is Istasyonlari Gider Dagitim Tablosu FBS 20110906 --->
<cfparam name="attributes.module_id_control" default="35">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.workstation_status" default="1">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isDate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
    
<cfform name="rapor" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">    
    <cf_report_list_search title="#getLang('report',2038)#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <cfoutput>
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang_main no='1278.Tarih Aralığı'></label>
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                                                    <cfinput type="text" name="startdate" value="#DateFormat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                                    <span class="input-group-addon">
                                                        <cf_wrk_date_image date_field="startdate">
                                                    </span>    
                                                </div>
                                            </div> 
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfinput type="text" name="finishdate" value="#DateFormat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" >
                                                    <span class="input-group-addon">
                                                       <cf_wrk_date_image date_field="finishdate">
                                                    </span>    
                                                </div>
                                            </div>  
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang_main no="322.Seçiniz"></label>
                                            <div class="col col-12">
                                                <select name="workstation_status" id="workstation_status">
                                                    <option value="1"<cfif attributes.workstation_status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                                                    <option value="0"<cfif attributes.workstation_status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                                                    <option value=""<cfif attributes.workstation_status eq "">selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </cfoutput>    
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
				     	<div class="ReportContentFooter">
                            <label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>checked</cfif>></label>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                            <input type="hidden" name="submitted" id="submitted" value="1"/>  
                            <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
                        </div>
					</div>
				</div>          
            </div>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>

<cfif isdefined("attributes.submitted")>   
    <cfquery name="Get_Expense_Budget_Cat_Query" datasource="#dsn2#">
        SELECT
            SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
            EXPENSE_CENTER_ID,
            EXPENSE_CAT_ID,
            EXPENSE_CAT_NAME
        FROM
            (
                SELECT
                    SUM(EIR.QUANTITY*EIR.AMOUNT) TOTAL_AMOUNT,
                    EIR.EXPENSE_CENTER_ID,
                    EIC.EXPENSE_CAT_ID,
                    EIC.EXPENSE_CAT_NAME
                FROM
                    EXPENSE_CATEGORY EIC,
                    EXPENSE_ITEMS EI,
                    EXPENSE_ITEMS_ROWS EIR
                WHERE
                    EIR.IS_INCOME = 0 AND
                    EIR.EXPENSE_ITEM_ID IS NOT NULL AND
                    EIR.EXPENSE_CENTER_ID IN (SELECT EXPENSE_ID FROM EXPENSE_CENTER WHERE IS_PRODUCTION = 1) AND
                    <cfif Len(attributes.startdate)>
                        EIR.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                    </cfif>
                    <cfif Len(attributes.finishdate)>
                        EIR.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                    </cfif>
                    EI.EXPENSE_ITEM_ID = EIR.EXPENSE_ITEM_ID AND
                    EIC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
                GROUP BY
                    EIR.EXPENSE_CENTER_ID,
                    EIC.EXPENSE_CAT_ID,
                    EIC.EXPENSE_CAT_NAME
                
                UNION ALL
                
                SELECT
                    SUM(-1*EIR.QUANTITY*EIR.AMOUNT) TOTAL_AMOUNT,
                    EIR.EXPENSE_CENTER_ID,
                    EIC.EXPENSE_CAT_ID,
                    EIC.EXPENSE_CAT_NAME
                FROM
                    EXPENSE_CATEGORY EIC,
                    EXPENSE_ITEMS EI,
                    EXPENSE_ITEMS_ROWS EIR
                WHERE
                    EIR.IS_INCOME = 1 AND
                    EIR.EXPENSE_ITEM_ID IS NOT NULL AND
                    EIR.EXPENSE_CENTER_ID IN (SELECT EXPENSE_ID FROM EXPENSE_CENTER WHERE IS_PRODUCTION = 1) AND
                    <cfif Len(attributes.startdate)>
                        EIR.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                    </cfif>
                    <cfif Len(attributes.finishdate)>
                        EIR.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                    </cfif>

                    EI.EXPENSE_ITEM_ID = EIR.EXPENSE_ITEM_ID AND
                    EIC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
                GROUP BY
                    EIR.EXPENSE_CENTER_ID,
                    EIC.EXPENSE_CAT_ID,
                    EIC.EXPENSE_CAT_NAME
            ) AS MAIN_EXPENSE
        GROUP BY
            EXPENSE_CENTER_ID,
            EXPENSE_CAT_ID,
            EXPENSE_CAT_NAME
        ORDER BY
            EXPENSE_CAT_NAME
    </cfquery>
    <!--- Butce Kategorileri --->
    <cfquery name="Get_Expense_Item_Category" datasource="#dsn2#">
        SELECT EXPENSE_CAT_ID, EXPENSE_CAT_NAME FROM EXPENSE_CATEGORY <cfif ListLen(ValueList(Get_Expense_Budget_Cat_Query.Expense_Cat_Id))>WHERE EXPENSE_CAT_ID IN (#ListDeleteDuplicates(ValueList(Get_Expense_Budget_Cat_Query.Expense_Cat_Id))#)</cfif> ORDER BY EXPENSE_CAT_NAME
    </cfquery>
    <!--- Masraf Merkezleri --->
    <cfquery name="Get_Expense_Center" datasource="#dsn2#">
        SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER WHERE IS_PRODUCTION = 1 ORDER BY EXPENSE_CODE
    </cfquery>
    <cfif not (isDefined('attributes.is_excel') and attributes.is_excel eq 1)>
        <cfoutput query="Get_Expense_Budget_Cat_Query" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
            <cfif not isDefined("Row_Budget_Cat_Column_#Expense_Cat_Id#_#Expense_Center_Id#")><cfset "Row_Budget_Cat_Column_#Expense_Cat_Id#_#Expense_Center_Id#" = 0></cfif>
            <cfset "Row_Budget_Cat_Column_#Expense_Cat_Id#_#Expense_Center_Id#" = Evaluate("Row_Budget_Cat_Column_#Expense_Cat_Id#_#Expense_Center_Id#") + Get_Expense_Budget_Cat_Query.Total_Amount>
        </cfoutput>
    </cfif>
    <cfquery name="Get_Expense_Station_Query" datasource="#dsn2#">
        SELECT
            SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
            EXPENSE_ID,
            EXPENSE_SHIFT,
            EXPENSE_CODE,
            EXPENSE,
            STATION_ID
        FROM
            (
                SELECT
                    SUM(EIR.QUANTITY*EIR.AMOUNT*ISNULL(WP.EXPENSE_SHIFT/100,1)) TOTAL_AMOUNT,
                    EC.EXPENSE_ID,
                    EC.EXPENSE_CODE,
                    EC.EXPENSE,
                    WP.STATION_ID,
                    WP.EXPENSE_SHIFT
                FROM
                    #dsn3_alias#.WORKSTATION_PERIOD WP,
                    EXPENSE_CENTER EC,
                    EXPENSE_ITEMS_ROWS EIR
                WHERE
                    EIR.IS_INCOME = 0 AND
                    EC.IS_PRODUCTION = 1 AND
                    EIR.EXPENSE_CENTER_ID IS NOT NULL AND
                    <cfif Len(attributes.startdate)>
                        EIR.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                    </cfif>
                    <cfif Len(attributes.finishdate)>
                        EIR.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                    </cfif>
                    WP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                    WP.EXPENSE_ID = EIR.EXPENSE_CENTER_ID AND
                    EC.EXPENSE_ID = EIR.EXPENSE_CENTER_ID AND
                    EC.EXPENSE_ID = WP.EXPENSE_ID
                GROUP BY
                    EC.EXPENSE_ID,
                    EC.EXPENSE_CODE,
                    EC.EXPENSE,
                    WP.STATION_ID,
                    WP.EXPENSE_SHIFT
            
            UNION ALL
            
                SELECT
                    SUM(-1*EIR.QUANTITY*EIR.AMOUNT*ISNULL(WP.EXPENSE_SHIFT/100,1)) TOTAL_AMOUNT,
                    EC.EXPENSE_ID,
                    EC.EXPENSE_CODE,
                    EC.EXPENSE,
                    WP.STATION_ID,
                    WP.EXPENSE_SHIFT
                FROM
                    #dsn3_alias#.WORKSTATION_PERIOD WP,
                    EXPENSE_CENTER EC,
                    EXPENSE_ITEMS_ROWS EIR
                WHERE
                    EIR.IS_INCOME = 1 AND
                    EC.IS_PRODUCTION = 1 AND
                    EIR.EXPENSE_CENTER_ID IS NOT NULL AND
                    <cfif Len(attributes.startdate)>
                        EIR.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
                    </cfif>
                    <cfif Len(attributes.finishdate)>
                        EIR.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
                    </cfif>
                    WP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
                    WP.EXPENSE_ID = EIR.EXPENSE_CENTER_ID AND
                    EC.EXPENSE_ID = EIR.EXPENSE_CENTER_ID AND
                    EC.EXPENSE_ID = WP.EXPENSE_ID
                GROUP BY
                    EC.EXPENSE_ID,
                    EC.EXPENSE_CODE,
                    EC.EXPENSE,
                    WP.STATION_ID,
                    WP.EXPENSE_SHIFT
            ) AS MAIN_EXPENSE
        GROUP BY
            EXPENSE_ID,
            EXPENSE_CODE,
            EXPENSE,
            STATION_ID,
            EXPENSE_SHIFT
        ORDER BY
            EXPENSE_CODE
    </cfquery>
    <cfparam name="attributes.totalrecords" default='#Get_Expense_Station_Query.recordcount + Get_Expense_Budget_Cat_Query.recordcount#'>
    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset attributes.startrow=1>
        <cfset attributes.maxrows=Get_Expense_Station_Query.recordcount + Get_Expense_Budget_Cat_Query.recordcount>
    </cfif>
    <!--- Is Istasyonlari --->
    <cfquery name="Get_WorkStations" datasource="#dsn3#">
        SELECT 
            STATION_ID, 
            STATION_NAME 
        FROM 
            WORKSTATIONS 
        WHERE 
            1 = 1
            <cfif len(attributes.workstation_status) and attributes.workstation_status eq 1>
                AND ACTIVE = 1
            <cfelseif len(attributes.workstation_status) and attributes.workstation_status eq 0>
                AND ACTIVE = 0
            </cfif>
        ORDER BY STATION_NAME
    </cfquery>
    <!--- Is Istasyonlarina Ait Masraf Merkezleri --->
    <cfquery name="Get_Expense_Center_WorkStations" datasource="#dsn2#">
        SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER WHERE IS_PRODUCTION = 1 AND EXPENSE_ID IN (SELECT EXPENSE_ID FROM #dsn3_alias#.WORKSTATION_PERIOD WHERE PERIOD_ID = #session.ep.period_id# AND EXPENSE_SHIFT <> 100) ORDER BY EXPENSE_CODE
    </cfquery>
    <cfif not (isDefined('attributes.is_excel') and attributes.is_excel eq 1)>
        <cfoutput query="Get_Expense_Station_Query" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
            <cfif Get_Expense_Station_Query.Expense_Shift neq 100>
                <cfif not isDefined("Row_Station_Column_#Station_Id#_#Expense_Id#")><cfset "Row_Station_Column_#Station_Id#_#Expense_Id#" = 0></cfif>
                <cfset "Row_Station_Column_#Station_Id#_#Expense_Id#" = Evaluate("Row_Station_Column_#Station_Id#_#Expense_Id#") + Get_Expense_Station_Query.Total_Amount>
            <cfelse>
                <cfif not isDefined("Row_Station_Column_#Station_Id#_#0#")><cfset "Row_Station_Column_#Station_Id#_#0#" = 0></cfif>
                <cfset "Row_Station_Column_#Station_Id#_#0#" = Evaluate("Row_Station_Column_#Station_Id#_#0#") + Get_Expense_Station_Query.Total_Amount>
            </cfif>
        </cfoutput>
    </cfif>
    <cf_report_list>                    
        <!--- Masraf Merkezi ve Gider Kategorilerine Gore --->
        <thead>
            <tr> 
                <th colspan="11">&nbsp;</th>
                <cfloop query="Get_Expense_Center">
                    <th colspan="4"><cfoutput>#Expense_Code#<br />#Expense#</cfoutput></th>
                </cfloop>
                <th style="text-align:right" colspan="4"><cf_get_lang_main no='80.TOPLAM'></th>
            </tr>
        </thead>
        <tbody>
            <cfif Get_Expense_Item_Category.RecordCount>
                <cfparam name="attributes.totalrecords" default='#Get_Expense_Item_Category.recordcount#'>
                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                    <cfset attributes.startrow=1>
                    <cfset attributes.maxrows=Get_Expense_Item_Category.recordcount>
                </cfif>
                <cfset All_Total_Item = 0>
                <cfoutput query="Get_Expense_Item_Category" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
                    <tr> 
                        <td colspan="11">#Expense_Cat_Name#</td>
                        <cfif Get_Expense_Center.RecordCount>
                            <cfset Row_Total_Expense = 0>
                            <cfloop query="Get_Expense_Center">
                                <td colspan="4" style="text-align:right;">
                                    <cfif isDefined("Row_Budget_Cat_Column_#Get_Expense_Item_Category.Expense_Cat_Id#_#Get_Expense_Center.Expense_Id#") and Len(Evaluate("Row_Budget_Cat_Column_#Get_Expense_Item_Category.Expense_Cat_Id#_#Get_Expense_Center.Expense_Id#"))>
                                        #TLFormat(Evaluate("Row_Budget_Cat_Column_#Get_Expense_Item_Category.Expense_Cat_Id#_#Get_Expense_Center.Expense_Id#"))#
                                        <cfif not isDefined("Total_Budget_#Get_Expense_Center.Expense_Id#")>
                                            <cfset "Total_Budget_#Get_Expense_Center.Expense_Id#" = Evaluate("Row_Budget_Cat_Column_#Get_Expense_Item_Category.Expense_Cat_Id#_#Get_Expense_Center.Expense_Id#")>
                                        <cfelse>
                                            <cfset "Total_Budget_#Get_Expense_Center.Expense_Id#" = Evaluate("Total_Budget_#Get_Expense_Center.Expense_Id#") + Evaluate("Row_Budget_Cat_Column_#Get_Expense_Item_Category.Expense_Cat_Id#_#Get_Expense_Center.Expense_Id#")>
                                        </cfif>
                                        <cfset Row_Total_Expense = Row_Total_Expense + Evaluate("Row_Budget_Cat_Column_#Get_Expense_Item_Category.Expense_Cat_Id#_#Get_Expense_Center.Expense_Id#")>
                                    <cfelse>
                                        #TLFormat(0)#
                                    </cfif>
                                </td>
                            </cfloop>
                            <cfset All_Total_Item = All_Total_Item + Row_Total_Expense>
                            <td colspan="4" style="text-align:right;">#TLFormat(Row_Total_Expense)#</td>
                        <cfelse>
                            <td>&nbsp;</td>
                        </cfif>
                    </tr>
                </cfoutput>
                <tr>
                    <td colspan="11" style="text-align:right"><cf_get_lang_main no='80.TOPLAM'></td>
                    <cfoutput>
                        <cfloop query="Get_Expense_Center">
                            <td th colspan="4" style="text-align:right"><cfif isDefined("Total_Budget_#Get_Expense_Center.Expense_Id#")>#TLFormat(Evaluate("Total_Budget_#Get_Expense_Center.Expense_Id#"))#<cfelse>#TLFormat(0)#</cfif></td>
                        </cfloop>
                        <td colspan="4" style="text-align:right">#TLFormat(All_Total_Item)#</td>
                    </cfoutput>
                </tr>
            <cfelse>
                <tr> 
                    <td colspan="20"><cfif isdefined("attributes.submitted")><cf_get_lang_main no='72.Kayıt Yok'><cfelse></cfif>!</td>
                </tr>
            </cfif>
        
        </tbody>
        <!--- //Masraf Merkezi ve Gider Kategorilerine Gore --->
        <br />
        <!--- Masraf Merkezi ve Is Istasyonlarina Gore --->
        
        <thead>
            <tr>                                 
                <cfif Get_WorkStations.RecordCount>
                    <cfloop query="Get_WorkStations">
                        <th><cfoutput>#Station_Name#</cfoutput></th>
                    </cfloop>
                    <th style="text-align:right"><cf_get_lang_main no='80.TOPLAM'></th>
                </cfif>
            </tr>
        </thead>  
        <tbody>
            <cfif Get_Expense_Center_WorkStations.RecordCount>
                <cfparam name="attributes.totalrecords" default='#Get_Expense_Item_Category.recordcount#'>
                <cfset All_Total_Station = 0>
                <tr> 
                    <td>&nbsp;</td>
                    <cfif Get_WorkStations.RecordCount>
                        <cfset Row_Total_Stations = 0>
                        <cfoutput>
                        <cfloop query="Get_WorkStations">
                            <td style="text-align:right">
                                <cfif isDefined("Row_Station_Column_#Get_WorkStations.Station_Id#_#0#") and Len(Evaluate("Row_Station_Column_#Get_WorkStations.Station_Id#_#0#"))>
                                    #TLFormat(Evaluate("Row_Station_Column_#Get_WorkStations.Station_Id#_#0#"))#
                                    <cfset Toplam_ = Evaluate("Row_Station_Column_#Get_WorkStations.Station_Id#_#0#")>
                                    <cfif not isDefined("Total_Station_#Get_WorkStations.Station_Id#")>
                                        <cfset "Total_Station_#Get_WorkStations.Station_Id#" = Toplam_>
                                    <cfelse>
                                        <cfset "Total_Station_#Get_WorkStations.Station_Id#" = Evaluate("Total_Station_#Get_WorkStations.Station_Id#") + Toplam_>
                                    </cfif>
                                <cfelse>
                                    #TLFormat(0)#
                                    <cfset Toplam_ = 0>
                                </cfif>
                                <cfset Row_Total_Stations = Row_Total_Stations + Toplam_>
                            </td>
                        </cfloop>
                        <cfset All_Total_Station = All_Total_Station + Row_Total_Stations>
                        <td style="text-align:right;">#TLFormat(Row_Total_Stations)#</td>
                        </cfoutput>
                    </cfif>
                </tr>
                <cfoutput query="Get_Expense_Center_WorkStations" maxrows=#attributes.maxrows# startrow=#attributes.startrow#>
                    <tr> 
                        <td>#Expense#</td>
                        <cfset Row_Total_Stations2 = 0>
                        <cfif Get_WorkStations.RecordCount>
                            <cfset "Total_WorkStations_#Get_Expense_Center_WorkStations.Expense_Id#" = 0>
                            <cfloop query="Get_WorkStations">
                                <td style="text-align:right">
                                    <cfif isDefined("Row_Station_Column_#Get_WorkStations.Station_Id#_#Get_Expense_Center_WorkStations.Expense_Id#") and Len(Evaluate("Row_Station_Column_#Get_WorkStations.Station_Id#_#Get_Expense_Center_WorkStations.Expense_Id#"))>
                                        #TLFormat(Evaluate("Row_Station_Column_#Get_WorkStations.Station_Id#_#Get_Expense_Center_WorkStations.Expense_Id#"))#
                                        <cfset Toplam_ = Evaluate("Row_Station_Column_#Get_WorkStations.Station_Id#_#Get_Expense_Center_WorkStations.Expense_Id#")>
                                        <cfif not isDefined("Total_Station_#Get_WorkStations.Station_Id#")>
                                            <cfset "Total_Station_#Get_WorkStations.Station_Id#" = Toplam_>
                                        <cfelse>
                                            <cfset "Total_Station_#Get_WorkStations.Station_Id#" = Evaluate("Total_Station_#Get_WorkStations.Station_Id#") + Toplam_>
                                        </cfif>
                                    <cfelse>
                                        <cfset Toplam_ = 0>
                                        #TLFormat(0)#
                                    </cfif>
            
                                    <cfset Row_Total_Stations2 = Row_Total_Stations2 + Toplam_>
                                </td>
                            </cfloop>
                            <cfset All_Total_Station = All_Total_Station + Row_Total_Stations2>
                            <td style="text-align:right;">#TLFormat(Row_Total_Stations2)#</td>
                        </cfif>
                    </tr>
                </cfoutput>
                <tr>
                    <cfoutput>
                        <td style="text-align:right"><cf_get_lang_main no='80.TOPLAM'></td>
                        <cfloop query="Get_WorkStations">
                            <td style="text-align:right"><cfif isDefined("Total_Station_#Get_WorkStations.Station_Id#")>#TLFormat(Evaluate("Total_Station_#Get_WorkStations.Station_Id#"))#<cfelse>#TLFormat(0)#</cfif></td>
                        </cfloop>
                        <td style="text-align:right">#TLFormat(All_Total_Station)#</td>
                    </cfoutput>
                </tr>
            <cfelse>
                <tr> 
                    <td colspan="20"><cfif isdefined("attributes.submitted")><cf_get_lang_main no='72.Kayıt Yok'><cfelse></cfif>!</td>
                </tr>
            </cfif>
            <cfset attributes.totalrecords=Get_Expense_Item_Category.recordCount+Get_Expense_Center_WorkStations.recordCount>
        </tbody>
        <!--- //Masraf Merkezi ve Is Istasyonlarina Gore --->
    </cf_report_list>                 
        
    <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
        <cfset url_str = "#attributes.fuseaction#">
        <cfif isdefined("attributes.submitted") and len(attributes.submitted)>
          <cfset url_str = "#url_str#&submitted=#attributes.submitted#" >
        </cfif>
        <cfif isdefined("attributes.workstation_status") and len(attributes.workstation_status)>
            <cfset url_str = '#url_str#&workstation_status=#attributes.workstation_status#'>
        </cfif>
        <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
            <cfset url_str = '#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
        </cfif>
        <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
            <cfset url_str = '#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
        </cfif>
        <cf_paging
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#">	
    </cfif>	 
</cfif>

<script language="javascript">
	function control()
	{
        if ((document.rapor.startdate.value != '') && (document.rapor.finishdate.value != '') &&
	    !date_check(rapor.startdate,rapor.finishdate,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	    return false;

		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
		else
            document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_workstations_expense_seller_report</cfoutput>";
			

	}
</script>
