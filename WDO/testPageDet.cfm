<cfset category = createObject("component", "WDO.development.cfc.test_cat_controller")>
<div class="row">
	<div class="col col-12">
		<h3 class="workdevPageHead"><cfoutput>#getLang('service',163,'Test Sonuçları')#</cfoutput></h3>
	</div>
</div>
<cfset query_testhead = category.getTestHead(attributes.testid)>
<cfset query_testrows = category.getTestRows(attributes.testid)>
<div class="row">
    <div class="col col-12">
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="" sort="true">
            <div class="form-group" id="item-">
                <label class="col col-4 col-xs-12">Module:</label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>#query_testhead.MODUL_SHORT_NAME#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-">
                <label class="col col-4 col-xs-12">Event:</label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>#query_testhead.EVENT#</cfoutput>                    
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="" sort="true">
            <div class="form-group" id="item-">
                <label class="col col-4 col-xs-12">Fuseaction:</label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>#query_testhead.FUSEACTION#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-">
                <label class="col col-4 col-xs-12">Test User:</label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>#query_testhead.TEST_USER#</cfoutput>                    
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="" sort="true">
            <div class="form-group" id="item-">
                <label class="col col-4 col-xs-12">Domain:</label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>#query_testhead.DOMAIN#</cfoutput>
                </div>
            </div>
            <div class="form-group" id="item-">
                <label class="col col-4 col-xs-12">Test Date:</label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>#dateformat(query_testhead.TEST_DATE, dateFormat_style)#</cfoutput>                    
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="" sort="true">
            <div class="form-group" id="item-">
                <label class="col col-4 col-xs-12">Version:</label>
                <div class="col col-8 col-xs-12">
                    <cfoutput>#query_testhead.VERSION#</cfoutput>                    
                </div>
            </div>
            <div class="form-group" id="item-">
                <label class="col col-4 col-xs-12">General Point:</label>
                <div class="col col-8 col-xs-12">
                    <cfswitch expression="#query_testhead.GENERAL_POINT#">
                        <cfcase value="1">
                            <h3><i class="fa fa-smile-o font-green_new"></i></h3>
                        </cfcase>
                        <cfcase value="-1">
                            <h3><i class="fa fa-frown-o font-red"></i></h3>
                        </cfcase>
                        <cfdefaultcase>
                            <h3><i class="fa fa-meh-o font-yellow"></i></h3>
                        </cfdefaultcase>
                    </cfswitch>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col col-12">
        <h4></h4>
    </div>
</div>
<div class="col col-12 col-xs-12">
    <table class="workDevList">
        <thead>
            <tr>
                <th style="width: 150px;">Success Status</th>
                <th>Subject</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="query_testrows">
            <tr>
                <td><h4><cfif success eq 1><i class="fa fa-check font-green_new"></i><cfelse><i class="fa fa-remove font-red"></i></cfif></h4></td>
                <td>#SUBJECT#</td>
                <td>#DETAIL#</td>
            </tr>
            </cfoutput>
        </tbody>
    </table>
</div>