<cfparam name="attributes.project_id" default="0">
<cfparam name="attributes.opp_id" default="0">
<cfparam name="attributes.order_id" default="0">
<cfparam name="attributes.purchasing_id" default="0">


<cfobject name="stretching_test" component="addons.n1-soft.textile.cfc.stretching_test">
<cfset stretching_test.dsn3 = dsn3>
<cfscript>
    attributes.checkTotal = attributes.project_id + attributes.opp_id + attributes.order_id + attributes.purchasing_id;
   
        query_stretching_test = stretching_test.get_stretching_test(attributes.st_id);
    
</cfscript>

<cf_catalystHeader>
<cfform name="stretching_test" method="post">
    <input type="hidden" name="stretching_test_id" value="<cfoutput>#query_stretching_test.STRETCHING_TEST_ID#</cfoutput>">
    <div class="row">
	   <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <!--- col 1 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-stretching_test_id">
                            <label class="col col-4 col-xs-12">Test No</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="stretching_test_no" id="stretching_test_no" value="<cfoutput>#query_stretching_test.STRETCHING_TEST_ID#</cfoutput>" disabled="disabled">
                            </div>
                        </div>
                        <div class="form-group" id="item-order_id">
                            <label class="col col-4 col-xs-12">İrsaliye No</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="order_id" id="order_id" value="<cfoutput>#query_stretching_test.ORDER_ID#</cfoutput>">
                                    <input type="text" name="order_title" id="order_title" style="width:140px;" readonly="" value="<cfoutput>#query_stretching_test.ORDER_NUMBER#</cfoutput>">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- col 2 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12">Tarih</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                    <input type="text" name="test_date" id="test_date" value="<cfoutput>#dateformat( iif(attributes.checkTotal gt 0 and query_stretching_test.recordcount eq 1, "query_stretching_test.TEST_DATE", "now()") ,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="test_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- col 3 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-project_id">
                            <label class="col col-4 col-xs-12">Proje No</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#iif(attributes.checkTotal gt 0 and query_stretching_test.recordcount eq 1, "query_stretching_test.PROJECT_ID", DE(""))#</cfoutput>">
                                    <input name="project_head" type="text" id="project_head" value="<cfoutput>#query_stretching_test.PROJECT_HEAD#</cfoutput>" readonly="">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--- col 4 --->
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-purchasing_id">
                            <label class="col col-4 col-xs-12">İrsaliye No</label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="purchasing_id" id="purchasing_id" value="<cfoutput>#query_stretching_test.SHIP_ID#</cfoutput>">
                                <input type="text" name="purchasing_head" id="purchasing_head" value="<cfoutput>#query_stretching_test.PURCHASE_HEAD#</cfoutput>" readonly="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<cfinclude template="list_stretching_fabric.cfm">
</cfform>