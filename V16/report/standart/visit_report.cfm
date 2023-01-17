<cfquery name="kontrol" datasource="#dsn#" >
	SELECT COUNT(*) as TOTAL_COUNT_RAPORT FROM WRK_VISIT_GENERAL_REPORT
</cfquery>

<cfif kontrol.TOTAL_COUNT_RAPORT lt 1 >
    <div class="container error-404">
		<cfset hata = "13">
		<cfinclude template="../../dsp_hata.cfm">
        <h2>MongoDB NoSQL should be installed and to follow which pages the user can visit for implementation.</h2>
    </div>
<cfelse>
    <cfparam name="attributes.module_id_control" default="7">
    <cfinclude template="report_authority_control.cfm">
    <cfif isdefined ("form_submit") and (len(month) or len(year))>
        <cfquery datasource="#dsn#_report" name="get_visit_domains">
            SELECT 
                    COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                    CASE USER_TYPE 
                         WHEN '0' THEN 'Çalışan'
                         WHEN '1' THEN 'Partner'
                         WHEN '2' THEN 'Consumer'
                         WHEN '-1' THEN 'Ziyaretçi'
                        END AS USER_TYPE 
                FROM
                    WRK_VISIT_#attributes.YEAR#_#attributes.MONTH#
                GROUP BY
                    USER_TYPE
        </cfquery>
        <cfquery name="get_visit_total_domain_density" datasource="#dsn#_report">
            SELECT top 10 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                VISIT_SITE AS WEB_SITE
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH#
            GROUP BY 
                VISIT_SITE
            order by 
                VISIT_COUNT DESC		
        </cfquery>
        <cfquery name="get_visit_employee_density" datasource="#dsn#_report">
            SELECT  TOP 7 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                VISIT_MODULE
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH#
            GROUP BY 
                VISIT_MODULE
            ORDER BY 
                VISIT_COUNT DESC	
        </cfquery>
        <cfquery name="get_visit_employee_page_density" datasource="#dsn#_report" maxrows="15">
            SELECT 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                VISIT_MODULE + '.' + VISIT_FUSEACTION AS ACTION_PAGE
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH#
            GROUP BY 
                VISIT_MODULE,
                VISIT_FUSEACTION
            ORDER BY
                VISIT_COUNT DESC
        </cfquery>
        <cfquery name="get_visit_browser_density_ziyaretci" datasource="#dsn#_report">
            SELECT TOP 7 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH#
            WHERE 
                USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
            GROUP BY 
                BROWSER_INFO
            ORDER BY
                VISIT_COUNT DESC	
        </cfquery>
        <cfquery name="get_visit_browser_density_partner" datasource="#dsn#_report">
            SELECT TOP 7 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH#
            WHERE
                USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            GROUP BY 
                BROWSER_INFO
            ORDER BY
                VISIT_COUNT DESC		
        </cfquery>
        
        <cfquery name="get_visit_browser_density_consumer" datasource="#dsn#_report">
            SELECT  TOP 7 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH#
            WHERE
                USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
            GROUP BY 
                BROWSER_INFO
            ORDER BY
                VISIT_COUNT DESC		
        </cfquery>
        <cfquery name="get_visit_browser_density_employee" datasource="#dsn#_report">
            SELECT TOP 7 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH#
            WHERE 
                USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            GROUP BY 
                BROWSER_INFO
            ORDER BY
                VISIT_COUNT DESC		
        </cfquery>
        
        <!--- diger--->
        <cfquery name="get_10_modul" datasource="#dsn#_report">
            SELECT TOP 10 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                VISIT_MODULE	 
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH# 
            GROUP BY
                VISIT_MODULE
            ORDER BY VISIT_COUNT DESC
        </cfquery>
        <cfquery name="get_10_fuseaction" datasource="#dsn#_report">
            SELECT TOP 10
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                VISIT_FUSEACTION
            FROM 
            WRK_VISIT_#attributes.YEAR#_#attributes.MONTH# 
            GROUP BY 
                VISIT_FUSEACTION
            ORDER BY VISIT_COUNT DESC	
        </cfquery>
        <cfquery name="get_10_browser" datasource="#dsn#_report">
            SELECT TOP 10 
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH# 	
            GROUP BY 
                BROWSER_INFO
            ORDER BY VISIT_COUNT DESC	
        </cfquery>
        <cfquery name="get_10_employee" datasource="#dsn#_report">
            SELECT XXX.VISIT_COUNT AS VISIT_COUNT, E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS NAME  FROM(SELECT TOP 10
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                USER_ID
            FROM
                WRK_VISIT_#attributes.YEAR#_#attributes.MONTH# 
            GROUP BY 
                USER_ID ORDER BY VISIT_COUNT DESC) AS XXX	JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID=XXX.USER_ID 	
        </cfquery>
        <!---diger--->
    <cfelse>	
        <cfquery name="get_visit_domains" datasource="#dsn#">
            SELECT 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                CASE USER_TYPE 
                     WHEN '0' THEN 'Çalisan'
                     WHEN '1' THEN 'Partner'
                     WHEN '2' THEN 'Consumer'
                     WHEN '-1' THEN 'Ziyaretçi'
                    END AS USER_TYPE 
            FROM
                WRK_VISIT_GENERAL_REPORT
            GROUP BY
                USER_TYPE	 
        </cfquery>
    
        <cfquery name="get_visit_total_domain_density" datasource="#dsn#">
            SELECT top 10 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                VISIT_SITE AS WEB_SITE
            FROM 
                WRK_VISIT_GENERAL_REPORT
            GROUP BY 
                VISIT_SITE
            order by 
                VISIT_COUNT DESC		
        </cfquery>
        <cfquery name="get_visit_employee_density" datasource="#dsn#">
            SELECT  TOP 7 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                VISIT_MODULE
            FROM 
                WRK_VISIT_GENERAL_REPORT
            GROUP BY 
                VISIT_MODULE
            ORDER BY 
                VISIT_COUNT DESC	
        </cfquery>
        <cfquery name="get_visit_employee_page_density" datasource="#dsn#" maxrows="15">
            SELECT 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                VISIT_MODULE + '.' + VISIT_FUSEACTION AS ACTION_PAGE
            FROM 
                WRK_VISIT_GENERAL_REPORT
            GROUP BY 
                VISIT_MODULE,
                VISIT_FUSEACTION
            ORDER BY
                VISIT_COUNT DESC
        </cfquery>
        <cfquery name="get_visit_browser_density_ziyaretci" datasource="#dsn#">
            SELECT TOP 7 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_GENERAL_REPORT
            WHERE 
                USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
            GROUP BY 
                BROWSER_INFO
            ORDER BY
                VISIT_COUNT DESC	
        </cfquery>
        <cfquery name="get_visit_browser_density_employee" datasource="#dsn#">
            SELECT TOP 7 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_GENERAL_REPORT
            WHERE 
                USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            GROUP BY 
                BROWSER_INFO
            ORDER BY
                VISIT_COUNT DESC		
        </cfquery>
        <cfquery name="get_visit_browser_density_partner" datasource="#dsn#">
            SELECT TOP 7 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_GENERAL_REPORT
            WHERE
                USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            GROUP BY 
                BROWSER_INFO
            ORDER BY
                VISIT_COUNT DESC		
        </cfquery>
        <cfquery name="get_visit_browser_density_consumer" datasource="#dsn#">
            SELECT  TOP 7 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_GENERAL_REPORT
            WHERE
                USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
            GROUP BY 
                BROWSER_INFO
            ORDER BY
                VISIT_COUNT DESC		
        </cfquery>
        
        <!---diger --->
        <cfparam name="attributes.module_id_control" default="7">
        <cfquery name="get_10_modul" datasource="#dsn#">
            SELECT TOP 10 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                VISIT_MODULE	 
            FROM 
                WRK_VISIT_GENERAL_REPORT 
            GROUP BY
                VISIT_MODULE
            ORDER BY VISIT_COUNT DESC
        </cfquery>
        <cfquery name="get_10_fuseaction" datasource="#dsn#">
            SELECT TOP 10
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                VISIT_FUSEACTION
            FROM 
            WRK_VISIT_GENERAL_REPORT
            GROUP BY 
                VISIT_FUSEACTION
            ORDER BY VISIT_COUNT DESC	
        </cfquery>
        <cfquery name="get_10_browser" datasource="#dsn#">
            SELECT TOP 10 
                SUM(VISIT_COUNT) AS VISIT_COUNT,
                BROWSER_INFO
            FROM 
                WRK_VISIT_GENERAL_REPORT	
            GROUP BY 
                BROWSER_INFO
            ORDER BY VISIT_COUNT DESC	
        </cfquery>
        <cfquery name="get_10_employee" datasource="#dsn#">
            SELECT XXX.VISIT_COUNT AS VISIT_COUNT, E.EMPLOYEE_NAME+'_'+E.EMPLOYEE_SURNAME AS NAME  FROM(SELECT TOP 10
                COUNT(WRK_VISIT_ID) AS VISIT_COUNT,
                USER_ID
            FROM
                WRK_VISIT
            GROUP BY 
                USER_ID ORDER BY VISIT_COUNT DESC) AS XXX	JOIN EMPLOYEES E ON E.EMPLOYEE_ID=XXX.USER_ID 	
        </cfquery>
        <!---diger--->
    </cfif>	
        <cfset table_sayi_ = 4>
        <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td class="headbold" height="35"><cf_get_lang no='1995.Ziyaret Takip Raporu'></td>
            </tr>
            <tr>
                <td colspan="2">
                    <ul id="menu1" class="ajax_tab_menu" style="padding: 3px 0;margin-left: 0;margin-top: 1px;margin-bottom: 0; float:left;">
                        <li style="display:inline; cursor:pointer;" id="link1"><a style="padding: 3px 7px;" onclick="pageload(1);"><font class="txtboldblue"><cf_get_lang no='2012.Ziyaret Yoğunlukları'></font></a></li>
                        <li style="display:inline; cursor:pointer;" id="link2"><a style="padding: 3px 7px;" onclick="pageload(2);"><font class="txtboldblue"><cf_get_lang no='2013.Employee Portal Yoğunluğu'></font></a></li>
                        <li style="display:inline; cursor:pointer;" id="link3"><a style="padding: 3px 7px;" onclick="pageload(3);"><font class="txtboldblue"><cf_get_lang no='2014.Browser Yoğunluğu'></font></a></li>
                        <li style="display:inline; cursor:pointer;" id="link4"><a style="padding: 3px 7px;" onclick="pageload(4);"><font class="txtboldblue"><cf_get_lang_main no="744.Diğer"></font></a></li>
                    </ul>
                    <span style="background-color:FFFFFF; width:100%; height:20px;"></span>
                    <table class="color-border" cellpadding="2" cellspacing="1" width="100%" align="center" id="table_1">
                        <tr class="color-list">
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no='2015.Toplam Ziyaret Yoğunluğu'></td>
                            <td width="1"></td>
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no='2017.Tekil Domain Ziyaretçisi'></td>
                        </tr>
                        <tr class="color-row" style="text-align:center">
                            <td>
                                    <cfsavecontent variable="xaxis"><cf_get_lang no='2018.Ziyaret Tipi'></cfsavecontent>
                                    <cfsavecontent variable="yaxis"><cf_get_lang no='2019.Ziyaret Sayısı'></cfsavecontent>
                                    <!--- <cfsavecontent variable="tekil_ziyaret"><cf_get_lang no='2016.Tekil Ziyaretçi Sayısı'></cfsavecontent> --->
                                    <cfsavecontent variable="domain"><cf_get_lang_main no='480.Domain'></cfsavecontent>
                                    <script src="JS/Chart.min.js"></script>
                                        <canvas id="myChart" style="max-width:300px;max-height:300px;margin-top:0;"></canvas>
                                            <script>
                                            var ctx = document.getElementById("myChart");
                                            var myChart = new Chart(ctx, {
                                                type: 'bar',
                                                data: {
                                                    labels: [<cfloop from="1" to="#get_visit_domains.recordcount#" index="jj"><cfoutput>"#get_visit_domains.USER_TYPE[jj]#"</cfoutput>,</cfloop>],
                                                    datasets: [{
                                                        label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                                        data: [<cfloop from="1" to="#get_visit_domains.recordcount#" index="jj"><cfoutput>#get_visit_domains.VISIT_COUNT[jj]#</cfoutput>,</cfloop>],
                                                        backgroundColor: [<cfloop from="1" to="#get_visit_domains.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                        borderWidth: 1
                                                    }]
                                                },
                                                options: {
                                                    scales: {
                                                        yAxes: [{
                                                            ticks: {
                                                                beginAtZero:true
                                                            }
                                                        }]
                                                    }
                                                }
                                            });
                                        </script>
                            </td>
                            <td width="1"></td>
                            <td>
                                <canvas id="myChart2" style="max-width:500px;margin-top:0;"></canvas>
                                            <script>
                                            var ctx2 = document.getElementById("myChart2");
                                            var myChart2 = new Chart(ctx2, {
                                                type: 'bar',
                                                data: {
                                                    labels: [<cfloop from="1" to="#get_visit_total_domain_density.recordcount#" index="kk"><cfoutput>"#get_visit_total_domain_density.WEB_SITE[kk]#"</cfoutput>,</cfloop>],
                                                    datasets: [{
                                                        label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                                        data: [<cfloop from="1" to="#get_visit_total_domain_density.recordcount#" index="kk"><cfoutput>#get_visit_total_domain_density.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                                        backgroundColor: [<cfloop from="1" to="#get_visit_total_domain_density.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                        borderWidth: 1
                                                    } 
                                                    ]
                                                },
                                                options: {
                                                    scales: {
                                                        yAxes: [{
                                                            ticks: {
                                                                beginAtZero:true
                                                            }
                                                        }]
                                                    }
                                                }
                                            });
                                        </script>
                            </td>
                        </tr>
                    </table>
                    <table class="color-border" cellpadding="2" cellspacing="1" width="100%" align="center" id="table_2" style="display:none">
                        <tr class="color-list">
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no='2020.Çalışan Modül Ziyaret Yoğunluğu'></td>
                            <td width="1"></td>
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no='2021.Çalışan Sayfa Ziyaret Yoğunluğu'> (15)</td>
                        </tr>
                        <tr class="color-row" style="text-align:center">
                            <td>
                                <!--- <cfsavecontent variable="ziyaret_modulu"><cf_get_lang no='2022.Ziyaret Modülü'></cfsavecontent> --->
                                <canvas id="myChart3" style="max-width:500px;margin-top:0;"></canvas>
                                            <script>
                                            var ctx3 = document.getElementById("myChart3");
                                            var myChart3 = new Chart(ctx3, {
                                                type: 'bar',
                                                data: {
                                                    labels: [<cfloop from="1" to="#get_visit_employee_density.recordcount#" index="kk"><cfoutput>"#get_visit_employee_density.VISIT_MODULE[kk]#"</cfoutput>,</cfloop>],
                                                    datasets: [{
                                                        label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                                        data: [<cfloop from="1" to="#get_visit_employee_density.recordcount#" index="kk"><cfoutput>#get_visit_employee_density.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                                        backgroundColor: [<cfloop from="1" to="#get_visit_employee_density.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                        borderWidth: 1
                                                    } 
                                                    ]
                                                },
                                                options: {
                                                    scales: {
                                                        yAxes: [{
                                                            ticks: {
                                                                beginAtZero:true
                                                            }
                                                        }]
                                                    }
                                                }
                                            });
                                        </script>
                            </td>
                            <td width="1"></td>
                            <td>
                                <!--- <cfsavecontent variable="ziyaret_sayfasi"><cf_get_lang no='2023.Ziyaret Sayfası'></cfsavecontent> --->
                                <canvas id="myChart4" style="max-width:500px;margin-top:0;"></canvas>
                                            <script>
                                            var ctx4 = document.getElementById("myChart4");
                                            var myChart4 = new Chart(ctx4, {
                                                type: 'bar',
                                                data: {
                                                    labels: [<cfloop from="1" to="#get_visit_employee_page_density.recordcount#" index="kk"><cfoutput>"#get_visit_employee_page_density.ACTION_PAGE[kk]#"</cfoutput>,</cfloop>],
                                                    datasets: [{
                                                        label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                                        data: [<cfloop from="1" to="#get_visit_employee_page_density.recordcount#" index="kk"><cfoutput>#get_visit_employee_page_density.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                                        backgroundColor: [<cfloop from="1" to="#get_visit_employee_page_density.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                                        borderWidth: 1
                                                    } 
                                                    ]
                                                },
                                                options: {
                                                    scales: {
                                                        yAxes: [{
                                                            ticks: {
                                                                beginAtZero:true
                                                            }
                                                        }]
                                                    }
                                                }
                                            });
                                        </script>
                            </td>
                        </tr>
                    </table>
                    <table class="color-border" cellpadding="2" cellspacing="1" width="100%" align="center" id="table_3" style="display:none">
                        <tr class="color-list">
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no='2024.Browser Yoğunluğu Employee'></td>
                            <td width="1"></td>
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no='2025.Browser Yoğunluğu Partner'></td>
                            <td width="1"></td>
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no='2026.Browser Yoğunluğu Consumer'></td>
                            <td width="1"></td>
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no='2027.Browser Yoğunluğu Ziyaretçi'></td>
                        </tr>
                        <tr class="color-row" style="text-align:center" bgcolor="">
                            <td>
                                <!--- <cfsavecontent variable="Browser"><cf_get_lang_main no='2130.Browser'></cfsavecontent> --->
                                <canvas id="myChart5" style="max-width:500px;margin-top:0;"></canvas>
                                <script>
                                var ctx5 = document.getElementById("myChart5");
                                var myChart5 = new Chart(ctx5, {
                                    type: 'bar',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_visit_browser_density_employee.recordcount#" index="kk"><cfoutput>"#get_visit_browser_density_employee.BROWSER_INFO[kk]#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                            data: [<cfloop from="1" to="#get_visit_browser_density_employee.recordcount#" index="kk"><cfoutput>#get_visit_browser_density_employee.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                            backgroundColor: [<cfloop from="1" to="#get_visit_browser_density_employee.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderWidth: 1
                                        } 
                                        ]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero:true
                                                }
                                            }]
                                        }
                                    }
                                });
                            </script>
                            </td>
                            <td width="1"></td>
                            <td>
                                <canvas id="myChart6" style="max-width:500px;margin-top:0;"></canvas>
                                <script>
                                var ctx6 = document.getElementById("myChart6");
                                var myChart6 = new Chart(ctx6, {
                                    type: 'bar',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_visit_browser_density_partner.recordcount#" index="kk"><cfoutput>"#get_visit_browser_density_partner.BROWSER_INFO[kk]#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                            data: [<cfloop from="1" to="#get_visit_browser_density_partner.recordcount#" index="kk"><cfoutput>#get_visit_browser_density_partner.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                            backgroundColor: [<cfloop from="1" to="#get_visit_browser_density_partner.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderWidth: 1
                                        } 
                                        ]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero:true
                                                }
                                            }]
                                        }
                                    }
                                });
                            </script>
                            </td>
                            <td width="1"></td>
                            <td>
                                <canvas id="myChart7" style="max-width:500px;margin-top:0;"></canvas>
                                <script>
                                var ctx7 = document.getElementById("myChart7");
                                var myChart7 = new Chart(ctx7, {
                                    type: 'bar',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_visit_browser_density_consumer.recordcount#" index="kk"><cfoutput>"#get_visit_browser_density_consumer.BROWSER_INFO[kk]#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                            data: [<cfloop from="1" to="#get_visit_browser_density_consumer.recordcount#" index="kk"><cfoutput>#get_visit_browser_density_consumer.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                            backgroundColor: [<cfloop from="1" to="#get_visit_browser_density_consumer.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderWidth: 1
                                        } 
                                        ]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero:true
                                                }
                                            }]
                                        }
                                    }
                                });
                            </script>
                            </td>
                            <td width="1"></td>
                            <td>
                                <canvas id="myChart8" style="max-width:500px;margin-top:0;"></canvas>
                                <script>
                                var ctx8 = document.getElementById("myChart8");
                                var myChart8 = new Chart(ctx8, {
                                    type: 'bar',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_visit_browser_density_ziyaretci.recordcount#" index="kk"><cfoutput>"#get_visit_browser_density_ziyaretci.BROWSER_INFO[kk]#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                            data: [<cfloop from="1" to="#get_visit_browser_density_ziyaretci.recordcount#" index="kk"><cfoutput>#get_visit_browser_density_ziyaretci.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                            backgroundColor: [<cfloop from="1" to="#get_visit_browser_density_ziyaretci.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderWidth: 1
                                        } 
                                        ]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero:true
                                                }
                                            }]
                                        }
                                    }
                                });
                            </script>
                            </td>
                        </tr>
                    </table>
                    <table class="color-border" cellpadding="2" cellspacing="1" width="100%" align="center" id="table_4" style="display:none">
                        <tr class="color-list">
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no="1167.En Çok Ziyaret Edilen"> 10 <cf_get_lang no="7.Modül"></td>
                            <td width="1"></td>
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no="1167.En Çok Ziyaret Edilen"> 10 <cf_get_lang no="169.Sayfa"></td>
                            <td width="1"></td>
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no="1167.En Çok Ziyaret Edilen"> 10 <cf_get_lang_main no="2130.Browser"></td>
                            <td width="1"></td>
                            <td class="txtboldblue" style="text-align:center" height="22"><cf_get_lang no="1168.En Çok İşlem Yapan"> 10 <cf_get_lang_main no="518.Kullanıcı"></td>
                        </tr>
                        <tr class="color-row" align="center" bgcolor="">
                            <td>
                                <canvas id="myChart9" style="max-width:500px;margin-top:0;"></canvas>
                                <script>
                                var ctx9 = document.getElementById("myChart9");
                                var myChart9 = new Chart(ctx9, {
                                    type: 'bar',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_10_modul.recordcount#" index="kk"><cfoutput>"#get_10_modul.VISIT_MODULE[kk]#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                            data: [<cfloop from="1" to="#get_10_modul.recordcount#" index="kk"><cfoutput>#get_10_modul.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                            backgroundColor: [<cfloop from="1" to="#get_10_modul.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderWidth: 1
                                        } 
                                        ]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero:true
                                                }
                                            }]
                                        }
                                    }
                                });
                            </script>
                            </td>
                            <td width="1"></td>
                            <td>
                                <canvas id="myChart10" style="max-width:500px;margin-top:0;"></canvas>
                                <script>
                                var ctx10 = document.getElementById("myChart10");
                                var myChart10 = new Chart(ctx10, {
                                    type: 'bar',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_10_fuseaction.recordcount#" index="kk"><cfoutput>"#get_10_fuseaction.VISIT_FUSEACTION[kk]#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                            data: [<cfloop from="1" to="#get_10_fuseaction.recordcount#" index="kk"><cfoutput>#get_10_fuseaction.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                            backgroundColor: [<cfloop from="1" to="#get_10_fuseaction.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderWidth: 1
                                        } 
                                        ]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero:true
                                                }
                                            }]
                                        }
                                    }
                                });
                            </script>
                            </td>
                            <td width="1"></td>
                            <td>
                                <canvas id="myChart11" style="max-width:500px;margin-top:0;"></canvas>
                                <script>
                                var ctx11 = document.getElementById("myChart11");
                                var myChart11 = new Chart(ctx11, {
                                    type: 'bar',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_10_browser.recordcount#" index="kk"><cfoutput>"#get_10_browser.BROWSER_INFO[kk]#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                            data: [<cfloop from="1" to="#get_10_browser.recordcount#" index="kk"><cfoutput>#get_10_browser.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                            backgroundColor: [<cfloop from="1" to="#get_10_browser.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderWidth: 1
                                        } 
                                        ]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero:true
                                                }
                                            }]
                                        }
                                    }
                                });
                            </script>
                            </td>
                            <td width="1"></td>
                            <td>
                                <canvas id="myChart12" style="max-width:500px;margin-top:0;"></canvas>
                                <script>
                                var ctx12 = document.getElementById("myChart12");
                                var myChart12 = new Chart(ctx12, {
                                    type: 'bar',
                                    data: {
                                        labels: [<cfloop from="1" to="#get_10_employee.recordcount#" index="kk"><cfoutput>"#get_10_employee.NAME[kk]#"</cfoutput>,</cfloop>],
                                        datasets: [{
                                            label: ['<cf_get_lang no='2019.Ziyaret Sayısı'>'],
                                            data: [<cfloop from="1" to="#get_10_employee.recordcount#" index="kk"><cfoutput>#get_10_employee.VISIT_COUNT[kk]#</cfoutput>,</cfloop>],
                                            backgroundColor: [<cfloop from="1" to="#get_10_employee.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
                                            borderWidth: 1
                                        } 
                                        ]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero:true
                                                }
                                            }]
                                        }
                                    }
                                });
                            </script>
                            </td>
                        </tr>
                    </table>	
                </td>
            </tr>
        </table>
        <script type="text/javascript">
        function pageload(page)
            {
                <cfoutput>
                <cfloop from="1" to="#table_sayi_#" index="ccc">
                    gizle(table_#ccc#);
                </cfloop>
                </cfoutput>
                goster(eval('table_' + page));
            }
        </script>
</cfif>        
