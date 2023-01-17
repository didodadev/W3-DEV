<cfparam name="attributes.branch" default="">
<style type="text/css">
    #chartdiv {
        width: 100%;
        height: 500px
    }
</style>

<script src="JS/holisticJs/core.js"></script>
<script src="JS/holisticJs/maps.js"></script>
<script src="JS/holisticJs/geodata/turkeyHigh.js"></script>
<script src="JS/holisticJs/themes/animated.js"></script>

<cfif isdefined('attributes.date1') and len(attributes.date1)>
	<cf_date tarih='attributes.date1'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST eq 1>
		<cfset attributes.date1=''>
	<cfelse>
        <cfset attributes.date1 = date_add('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif  isdefined('attributes.date2') and len(attributes.date2)>
	<cf_date tarih='attributes.date2'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.date2=''>
	<cfelse>
        <cfset attributes.date2 = wrk_get_today()>
	</cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Satış Haritası','62755')#">
        <cfform name="order_form" method="post" action="">
            <cf_box_search more="0"> 
                <div class="form-group">
                    <select name="map_type" id="map_type" tabindex="12">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <option value="1" <cfif isDefined('attributes.map_type') and attributes.map_type eq 1> selected</cfif> selected="selected "><cf_get_lang dictionary_id='63000.Ülke Bazlı'></option>
                        <option value="2" <cfif isDefined('attributes.map_type') and attributes.map_type eq 2> selected</cfif>><cf_get_lang dictionary_id='63001.İl Bazlı'></option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="date1" id="date1" value="#dateformat(attributes.date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="date2" id="date2" value="#dateformat(attributes.date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                        </div>
                    </div>
                </div>
                <!--- <div class="form-group">
                    <select name="branch" id="branch" tabindex="12">
                        <option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
                        <cfoutput query="branch">
                            <option value="#branch.BRANCH_ID#" <cfif attributes.branch eq branch.BRANCH_ID>selected</cfif>>#branch.BRANCH_NAME#</option>
                        </cfoutput>
                    </select>
                </div> --->
                <div class="form-group">
                    <cf_wrk_search_button button_type='1' is_excel="1" search_function="input_control()"> 
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfif isDefined('attributes.map_type') and attributes.map_type eq 2>
        <cfquery name="get_satis" datasource="#dsn2#">
            SELECT
                SC.PLATE_CODE,
                SUM(NETTOTAL) TOPLAM
            FROM
                INVOICE I
            LEFT JOIN #DSN#.COMPANY C ON I.COMPANY_ID = C.COMPANY_ID
            LEFT JOIN #DSN#.DEPARTMENT D ON I.DEPARTMENT_ID = D.DEPARTMENT_ID
            LEFT JOIN #DSN#.SETUP_CITY SC ON C.CITY = SC.CITY_ID
            WHERE   C.CITY IS NOT NULL AND
                    PURCHASE_SALES = 1 AND
                    IS_IPTAL = 0
                    <cfif len(attributes.branch)>
                        AND D.BRANCH_ID = #attributes.branch#
                    </cfif>
                    <cfif len(attributes.date1)>AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"></cfif>
                <cfif len(attributes.date2)>AND I.INVOICE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,attributes.date2)#"></cfif> 
            GROUP BY SC.PLATE_CODE
        </cfquery>
        <cfquery name="branch" datasource="#dsn#">
            SELECT 
                BRANCH_ID, 
                BRANCH_NAME
            FROM 
                BRANCH
            WHERE 
                COMPANY_ID = #session.ep.COMPANY_ID# 
                AND BRANCH_STATUS = 1
                /* AND BRANCH_ID NOT IN (6,8,10,14) */
            ORDER BY BRANCH_NAME ASC
        </cfquery>
    </cfif>
    <cfif isDefined('map_type')>
        <cf_box>
            <cfif attributes.map_type eq 2>
                <div id="chartdiv"></div>
            <cfelseif attributes.map_type eq 1>
                <cfinclude template="../../sales/display/map_sales_world_map.cfm">
            </cfif>
        </cf_box>
    </cfif>
</div>
<script>
function input_control() {
        if(document.getElementById('map_type').value == "")
                {
                    alert("<cf_get_lang dictionary_id='63006.Harita Tipi Seçiniz'>!")
                    return false;
                }
            
    };
    am4core.ready(function() {       
        am4core.useTheme(am4themes_animated);
        
        var chart = am4core.create("chartdiv", am4maps.MapChart);
        
        chart.geodata = am4geodata_turkeyHigh;
       
        var polygonSeries = chart.series.push(new am4maps.MapPolygonSeries());
        
        polygonSeries.heatRules.push({
            property: "fill",
            target: polygonSeries.mapPolygons.template,
            min: chart.colors.getIndex(1).brighten(1.8), //Bar rengi Az olan Kısım
            max: chart.colors.getIndex(5).brighten(-0.6) // Bar rengi Çok olan Kısım
        });
        <cfif isDefined('attributes.map_type') and attributes.map_type eq 2>
        polygonSeries.useGeodata = true;
        
        polygonSeries.data = [
            <cfoutput query="get_satis">
                {
                    <cfset sehirBakiye = 0>
                    id: "TR-#PLATE_CODE#",
                    value: #TOPLAM#
                   
                }<cfif get_satis.currentrow neq get_satis.RecordCount>, </cfif>
            </cfoutput>
            ];
        </cfif>
        
        
        let heatLegend = chart.createChild(am4maps.HeatLegend);
        heatLegend.series = polygonSeries;
        heatLegend.align = "right";
        heatLegend.valign = "bottom";
        heatLegend.width = am4core.percent(20); //Az-Çok barın uzuluğu
        heatLegend.marginRight = am4core.percent(4); //Az-Çok barın konumu
        heatLegend.minValue = 0;
        heatLegend.maxValue = 40000000;
        
        var minRange = heatLegend.valueAxis.axisRanges.create();
        minRange.value = heatLegend.minValue;
        minRange.label.text = "<cf_get_lang dictionary_id='65335.Az'>";
        var maxRange = heatLegend.valueAxis.axisRanges.create();
        maxRange.value = heatLegend.maxValue;
        maxRange.label.text = "<cf_get_lang dictionary_id='65334.Çok'>";
        
        heatLegend.valueAxis.renderer.labels.template.adapter.add("text", function(labelText) {
            return "";
        });
        
        var polygonTemplate = polygonSeries.mapPolygons.template;
        polygonTemplate.tooltipText = "{name}: {value} - {sehirTotal} {sehir}";
        polygonTemplate.nonScalingStroke = true;
        polygonTemplate.strokeWidth = 0.7; //Şehirlerin sınırlarının kalınlığı
        
        var hs = polygonTemplate.states.create("hover");
        hs.properties.fill = am4core.color("#3c5bdc");
    });
    
</script>