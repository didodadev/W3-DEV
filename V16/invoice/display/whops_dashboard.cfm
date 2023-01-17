
<cfif not isdefined('url.isAjax')><cf_catalystHeader></cfif>
<div id="whops_dashboard">
    <script src="JS/Chart.min.js"></script>
    <cfif not isdefined("attributes.type")><cfset attributes.type = 1></cfif>
    <cfif not isdefined("url.week")><cfset url.week = week(now())></cfif>
    <cfif not isdefined("url.now_m")><cfset url.now_m = month(now())></cfif>
    <cfif not isdefined("url.year_n")><cfset url.year_n = year(now())></cfif>
    <cfobject name="whops" type="component" component="V16.invoice.cfc.whops_dashboard">
    <cfparam name="attributes.branch_id" default="">
    <cfscript>
        if (isdefined('url.yil'))
            tarih = url.yil;
        else
            tarih = dateformat(now(),'yyyy');

        if (isdefined('url.ay'))
            tarih=tarih&'-'&url.ay;
        else
            tarih=tarih&'-'&dateformat(now(),'mm');
        
        if (isdefined('url.gun'))
            tarih=tarih&'-'&url.gun;
        else
            tarih=tarih&'-'&dateformat(now(),'d');

            next_week = url.week;
            last_week = url.week;
        if(attributes.type eq 2)
        {

            next_week = week(date_add('ww',1,tarih));
            last_week = week(date_add('ww',-1,tarih));

            if (isdefined('url.next_week'))
                week =url.week + 1;
            else if (isdefined('url.last_week'))
                week = url.week - 1;
            else week =url.week;

            if(dayofweek(tarih) neq 1)
            {
                tarih = date_add('d',-(dayofweek(tarih)-2),tarih);
                if (isdefined('url.next_week')) {
                    tarih = date_add('d',7,tarih);
                        
                }
            }
            else {
                tarih = tarih;
            }
        }
        if(attributes.type eq 3)
        {
            if (isdefined('url.n_month'))
                now_m =url.now_m + 1;
            else if (isdefined('url.l_month'))
                now_m = url.now_m - 1;
            else now_m = url.now_m;
        }

        if(attributes.type eq 4)
        {
        if (isdefined('url.n_year'))
        year_n =url.year_n + 1;
        else if (isdefined('url.l_year'))
        year_n = url.year_n - 1;
        else year_n = url.year_n;
        }
        
        last_day = date_add('d',-1,tarih);
        next_day = date_add('d',1,tarih);
        
        next_month = month(date_add('m',1,tarih));
        last_month = month(date_add('m',-1,tarih));
        n_next_year = year(date_add('y',1,tarih));
        n_last_year = year(date_add('y',-1,tarih));
        get_branch = whops.get_branch(ehesap_control : 1);

        if (attributes.type eq 1) {
            get_invoice = whops.get_invoice(startdate : tarih,branch_id : attributes.branch_id,is_day:1);
            get_invoice_date = whops.get_invoice_date(startdate : tarih,branch_id : attributes.branch_id,is_day:1);
            get_product_cat = whops.get_product_cat(startdate : tarih,branch_id : attributes.branch_id,is_day:1);
            total_amount = whops.total_amount();
            total_cat = whops.total_cat();
        }
        else if (attributes.type eq 2) {
            get_invoice = whops.get_invoice(startdate : tarih,branch_id : attributes.branch_id,is_week:1);
            get_invoice_date = whops.get_invoice_date(startdate : tarih,branch_id : attributes.branch_id,is_week:1);
            get_product_cat = whops.get_product_cat(startdate : tarih,branch_id : attributes.branch_id,is_week:1);
            total_amount = whops.total_amount();
            total_cat = whops.total_cat();
        }
        else if (attributes.type eq 3) {
            get_invoice = whops.get_invoice(startdate : now_m,branch_id : attributes.branch_id,is_month:1);
            get_invoice_date = whops.get_invoice_date(startdate : now_m,branch_id : attributes.branch_id,is_month:1);
            get_product_cat = whops.get_product_cat(startdate : now_m,branch_id : attributes.branch_id,is_month:1);
            total_amount = whops.total_amount();
            total_cat = whops.total_cat();
        }
        else if (attributes.type eq 4) {
            get_invoice = whops.get_invoice(startdate : year_n,branch_id : attributes.branch_id,is_year:1);
            get_invoice_date = whops.get_invoice_date(startdate : year_n,branch_id : attributes.branch_id,is_year:1);
            get_product_cat = whops.get_product_cat(startdate : year_n,branch_id : attributes.branch_id,is_year:1);
            total_amount = whops.total_amount();
            total_cat = whops.total_cat();
        }
        
    </cfscript>

    <cfset hours_list=''>
    <cfloop from="1" to="24" index="i">
        <cfif i lte 9>
            <cfset hours_list = ListAppend(hours_list,'0#i#:00',',')>
        <cfelse>
            <cfset hours_list = ListAppend(hours_list,'#i#:00',',')>
        </cfif>
    </cfloop>
    <div class="col col-12 col-xs-12">
        <cf_box title="#getLang('','Kasa Satışları',63503)#">
            <cf_tab divId="link1,link2,link3,link4" defaultOpen="link#attributes.type#" divLang="#getLang('','Bugün',57942)#;#getLang('','Bu Hafta',56027)#;#getLang('','Bu Ay',61789)#;#getLang('','Bu Yıl',55304)#"  tabcolor="fff">
                <input type="hidden" name="year" id="year" value="<cfoutput>#dateformat(tarih,"yyyy")#</cfoutput>">
                <input type="hidden" name="month" id="month" value="<cfoutput>#dateformat(tarih,"mm")#</cfoutput>">
                <input type="hidden" name="day_" id="day_" value="<cfoutput>#dateformat(tarih,"dd")#</cfoutput>">
                <input type="hidden" name="last_year" id="last_year" value="<cfoutput>#dateformat(last_day,"yyyy")#</cfoutput>">
                <input type="hidden" name="last_month" id="last_month" value="<cfoutput>#dateformat(last_day,"mm")#</cfoutput>">
                <input type="hidden" name="last_day_" id="last_day_" value="<cfoutput>#dateformat(last_day,"dd")#</cfoutput>">
                <input type="hidden" name="next_year" id="next_year" value="<cfoutput>#dateformat(next_day,"yyyy")#</cfoutput>">
                <input type="hidden" name="next_month" id="next_month" value="<cfoutput>#dateformat(next_day,"mm")#</cfoutput>">
                <input type="hidden" name="next_day_" id="next_day_" value="<cfoutput>#dateformat(next_day,"dd")#</cfoutput>">
                <input type="hidden" name="next_week" id="next_week" value="<cfoutput>#next_week#</cfoutput>">
                <input type="hidden" name="last_week" id="last_week" value="<cfoutput>#last_week#</cfoutput>">
                <input type="hidden" name="week" id="week" value="<cfoutput>#week#</cfoutput>">
                <input type="hidden" name="n_month" id="n_month" value="<cfoutput>#next_month#</cfoutput>">
                <input type="hidden" name="l_month" id="l_month" value="<cfoutput>#last_month#</cfoutput>">
                <input type="hidden" name="now_month" id="now_month" value="<cfoutput>#now_m#</cfoutput>">
                <input type="hidden" name="now_year" id="now_year" value="<cfoutput>#year_n#</cfoutput>">
                <input type="hidden" name="n_year" id="n_year" value="<cfoutput>#n_next_year#</cfoutput>">
                <input type="hidden" name="l_year" id="l_year" value="<cfoutput>#n_last_year#</cfoutput>">
                <div class="ui-info-text uniqueBox" id="unique_link1">
                    <div class="col col-6 col-xs-12">
                        <cfoutput>
                            <cf_box_elements>
                                <div class="col col-4 col-xs-12">
                                    <div class="form-group">
                                        <select id="branch_id1" name="branch_id1" onchange="change_branch(1)">
                                            <cfloop query="get_branch">
                                                <option value="#BRANCH_ID#" <cfif BRANCH_ID EQ attributes.BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                                </cfloop>
                                        </select>
                                    </div>
                                
                                </div>
                                <div class="col col-6 col-xs-12 padding-left-30 padding-top-10">
                                    <div class="form-group">
                                        <cfoutput>
                                            <div class="col col-1">
                                                <a href="javascript://" onclick="change_date_left(1)"><i class="fa fa-arrow-circle-left" width="15" height="20"></i></a>
                                            </div>
                                            <div class="col col-3">
                                                #dateformat(tarih,dateformat_style)#
                                            </div>
                                            <div class="col col-1">
                                                <a href="javascript://" onclick="change_date_right(1)"><i class="fa fa-arrow-circle-right" width="15" height="20"></i></a>
                                            </div>
                                        </cfoutput>
                                    </div>
                                    </div>
                            </cf_box_elements>
                        </cfoutput>
                        <cfinclude template="whops_dash_grid.cfm">
                    </div>
                    <div class="col col-1 col-xs-12"></div>
                    <div class="col col-4 col-xs-12">
                        <cfinclude template="whops_dash_cat_grid.cfm">
                    </div>
                </div>
                <div class="ui-info-text uniqueBox" id="unique_link2">
                    <div class="col col-6 col-xs-12">
                        <cf_box_elements>
                            <div class="col col-4 col-xs-12">
                                <div class="form-group">
                                    <select id="branch_id2" name="branch_id2" onchange="change_branch(2)">
                                        <cfoutput query="get_branch">
                                            <option value="#BRANCH_ID#" <cfif BRANCH_ID EQ attributes.BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                            </cfoutput>
                                    </select>
                                </div>
                            
                            </div>
                            <div class="col col-6 col-xs-12 padding-left-30 padding-top-10">
                                <div class="form-group">
                                    <cfoutput>
                                        <div class="col col-1">
                                            <a href="javascript://" onclick="change_date_left(2)"><i class="fa fa-arrow-circle-left" width="15" height="20"></i></a>
                                        </div>
                                        <div class="col col-4">
                                            #dateformat(tarih,'yyyy')# - #week#.<cf_get_lang dictionary_id='58734.Hafta'>
                                        </div>
                                        <div class="col col-1">
                                            <a href="javascript://" onclick="change_date_right(2)"><i class="fa fa-arrow-circle-right" width="15" height="20"></i></a>
                                        </div>
                                    </cfoutput>
                                </div>
                                </div>
                        </cf_box_elements>
                        <cfinclude template="whops_dash_grid.cfm">
                    </div>
                    <div class="col col-1 col-xs-12"></div>
                    <div class="col col-4 col-xs-12">
                        <cfinclude template="whops_dash_cat_grid.cfm">
                    </div>
                </div>
                <div class="ui-info-text uniqueBox" id="unique_link3">
                    <div class="col col-6 col-xs-12">
                        <cf_box_elements>
                            <div class="col col-4 col-xs-12">
                                <div class="form-group">
                                    <select id="branch_id3" name="branch_id3" onchange="change_branch(3)">
                                        <cfoutput query="get_branch">
                                            <option value="#BRANCH_ID#" <cfif BRANCH_ID EQ attributes.BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            
                            </div>
                            <div class="col col-6 col-xs-12 padding-left-30 padding-top-10">
                                <div class="form-group">
                                    <cfoutput>
                                        <div class="col col-1">
                                            <a href="javascript://" onclick="change_date_left(3)"><i class="fa fa-arrow-circle-left" width="15" height="20"></i></a>
                                        </div>
                                        <div class="col col-2">
                                            #ListGetAt(ay_list(),now_m,',')#
                                        </div>
                                        <div class="col col-1">
                                            <a href="javascript://" onclick="change_date_right(3)"><i class="fa fa-arrow-circle-right" width="15" height="20"></i></a>
                                        </div>
                                    </cfoutput>
                                </div>
                                </div>
                        </cf_box_elements>
                        <cfinclude template="whops_dash_grid.cfm">
                    </div>
                    <div class="col col-1 col-xs-12"></div>
                    <div class="col col-4 col-xs-12">
                        <cfinclude template="whops_dash_cat_grid.cfm">
                    </div>
                </div>
                <div class="ui-info-text uniqueBox" id="unique_link4">
                    <div class="col col-6 col-xs-12">
                        <cf_box_elements>
                            <div class="col col-4 col-xs-12">
                                <div class="form-group">
                                    <select id="branch_id4" name="branch_id4" onchange="change_branch(4)">
                                        <cfoutput query="get_branch">
                                            <option value="#BRANCH_ID#" <cfif BRANCH_ID EQ attributes.BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                                            </cfoutput>
                                    </select>
                                </div>
                            
                            </div>
                            <div class="col col-6 col-xs-12 padding-left-30 padding-top-10">
                                <div class="form-group">
                                    <cfoutput>
                                        <div class="col col-1">
                                            <a href="javascript://" onclick="change_date_left(4)"><i class="fa fa-arrow-circle-left" width="15" height="20"></i></a>
                                        </div>
                                        <div class="col col-2">
                                        #year_n#
                                        </div>
                                        <div class="col col-1">
                                            <a href="javascript://" onclick="change_date_right(4)"><i class="fa fa-arrow-circle-right" width="15" height="20"></i></a>
                                        </div>
                                    </cfoutput>
                                </div>
                                </div>
                        </cf_box_elements>
                        <cfinclude template="whops_dash_grid.cfm">
                    </div>
                    <div class="col col-1 col-xs-12"></div>
                    <div class="col col-4 col-xs-12">
                        <cfinclude template="whops_dash_cat_grid.cfm">
                    </div>
                </div>
            </cf_tab>
            <div class="col col-6 col-xs-12">
                <cfinclude template="whops_dash_graph.cfm">
            </div>
        </cf_box>
    </div>
</div>
<script>
    function change_branch(type)
        {
            year_ = $("#year").val();
            month_ = $("#month").val();
            day__ = $("#day_").val();
            branch_id = $("#branch_id"+type).val();
            week = $("#week").val();
            now_m = $("#now_month").val();
            year_n = $("#now_year").val();

            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=whops.dashboard&year_n='+year_n+'&now_m='+now_m+'&week='+week+'&type='+type+'&branch_id='+branch_id+'&yil='+year_+'&ay='+month_+'&gun='+day__,'whops_dashboard',1);
            return true;
        }
    function change_date_left(type)
        {
            last_year_ = $("#last_year").val();
            last_month_ = $("#last_month").val();
            last_day__ = $("#last_day_").val();
            branch_id = $("#branch_id"+type).val();
            week_ = $("#week").val();
            last_week_ = $("#last_week").val();
            now_m = $("#now_month").val();
            l_month = $("#l_month").val();
            year_n = $("#now_year").val();
            l_year = $("#l_year").val();

            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=whops.dashboard&year_n='+year_n+'&l_year='+l_year+'&now_m='+now_m+'&l_month='+l_month+'&last_week='+last_week_+'&week='+week_+'&type='+type+'&branch_id='+branch_id+'&yil='+last_year_+'&ay='+last_month_+'&gun='+last_day__,'whops_dashboard',1);
            return true;
        }
    function change_date_right(type)
        {
            next_year_ = $("#next_year").val();
            next_month_ = $("#next_month").val();
            next_day__ = $("#next_day_").val();
            branch_id = $("#branch_id"+type).val();
            next_week_ = $("#next_week").val();
            week_ = $("#week").val();
            now_m = $("#now_month").val();
            n_month = $("#n_month").val();
            year_n = $("#now_year").val();
            n_year = $("#n_year").val();
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=whops.dashboard&year_n='+year_n+'&n_year='+n_year+'&now_m='+now_m+'&n_month='+n_month+'&week='+week_+'&next_week='+next_week_+'&type='+type+'&branch_id='+branch_id+'&yil='+next_year_+'&ay='+next_month_+'&gun='+next_day__,'whops_dashboard',1);
            return true;
        }
</script>