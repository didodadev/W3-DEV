<style>
  .dashboardBox {
    height: 120px;
    width: 150px;
    background: red;
    border-radius: 5%; 
    margin: 0px auto 10px auto;
    text-align: center;
    box-shadow:inset 0 0 1px rgba(0,0,0,.5);
  }

  .dashboardBox i {
    font-size:40px;
    line-height: 60px !important;
  }		
  .dashboardIconTitle {
    display: block;
    font-size: 16px;
    font-weight: 400;
    margin: 0 auto;
    width:100px;
  }

  .dashboardContent { 
    text-align: center;
    margin: 10px 0;
    height:120px;
  }
   
  .modal-body{
    padding:10px 0;
  }
  @media screen and (max-width: 1200px) {
    .dashboardContent { width:20%!important; }
  }
  @media screen and (max-width: 992px) {
    .dashboardContent { width:25% !important; }
  }
  @media screen and (max-width: 768px){
    .dashboardContent { width:33%!important; }
  }
  @media screen and (max-width: 548px){
    .dashboardContent { width:50%!important; }
  }
  @media screen and (max-width: 319px){
    .dashboardContent { width:100%!important; }
  }		 

</style>

<cfscript>
	DatabaseInfo = CreateObject("component","Utility.DatabaseInfo");
	/*
	table_info = DatabaseInfo.TableInfo(
		schema_name:'#iif(isdefined("attributes.schema_name"),"attributes.schema_name",DE("v16_catalyst"))#',
		table_name:'#iif(isdefined("attributes.table_name"),"attributes.table_name",DE(""))#'
	);
	*/
	schema_info = DatabaseInfo.SchemaInfo();
  designDashboard=DatabaseInfo.GetDesignDashboard();
	generalDashboard=DatabaseInfo.GetGeneralDashboard();
</cfscript>
<div id="pageHeader" class="col col-12 text-left pageHeader font-green-haze" style="padding:6px">
  <span class="pageCaption font-green-sharp bold"><cf_get_lang dictionary_id="59092.Database"></span>
  <div id="pageTab" class="pull-right">
      <nav class="detailHeadButton" id="tabMenu">
        <ul>
          <cfoutput>
            <li class="dropdown">
              <a href="javascript:;" onClick="AjaxPageLoad('#request.self#?fuseaction=settings.emptypopup_AdvancedSearch&type=add','table_info',1);" title="<cf_get_lang dictionary_id="57516.Add Table">"><i class="fa fa-table margin-right-5"></i><cf_get_lang dictionary_id="57516.Add Table"></a>
            </li>
            <li class="dropdown">
              <a onClick="AjaxPageLoad('#request.self#?fuseaction=settings.emptypopup_AdvancedSearch&type=query','table_info',1);" href="javascript:;" title="<cf_get_lang dictionary_id="39609.Run Query">"><i class="fa fa-database margin-right-5"></i><cf_get_lang dictionary_id="39609.Run Query"></a>
            </li>
          </cfoutput>
        </ul>
      </nav>
  </div>
</div>
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id="38752.Table"></cfsavecontent>
    <cf_box title="#head#">
      <cf_box_search more="0">
        <div class="form-group" style="width:100%">
          <input type="text" id="search" placeholder="<cf_get_lang dictionary_id='59090.Table Search'>" onKeyDown="if(event.keyCode == 13) {searchForm()}">
        </div>
        <div class="form-group" style="width:100%">
          <select id="search_scheme" class="input-group-addon">
            <cfoutput query="schema_info">
              <option #iif(isdefined("attributes.schema_name"),DE('selected="selected"'),DE(""))#>#SCHEMA_NAME#</option>
            </cfoutput>
          </select>
          <span class="ui-btn ui-btn-green" onclick="searchForm(true)"><i class="fa fa-search"></i></span>
        </div>
      </cf_box_search> 
      <cf_flat_list id="table">
			</cf_flat_list>
        <div class="ui-pagination">
          <div class="pagi-left" id="pager">
            <ul>  
              <li class="pagesButtonPassive"><a href="javascript://" onclick="prevpage()"><i class="fa fa-angle-left"></i></a></li>
              <li class="pagesButtonPassive"><a href="javascript://" onclick="nextpage()"><i class="fa fa-angle-right"></i></a></li>
            </ul>
          </div>
          <div class="rowCountText" style="text-align:right">
            <b> Sayfa :</b> <span id="pagenr"></span>/<span id="pagett"></span>
          </div>
        </div>
    </cf_box>
  </div>
  <div class="col col-9 col-md-9 col-sm-9 col-xs-12" id="table_info">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id="60858.DB"></cfsavecontent>
    <cf_box title="#head#">
    <cfsavecontent variable="mess"><cf_get_lang dictionary_id="60859.DEV ENVIRONMENT"></cfsavecontent>
    <cf_seperator id="dev_environment" title="#mess#">
      <div class="row" id="dev_environment">
      <!--- <span class="pageCaption font-green-sharp bold">DEV Environment</span>
      <br />--->
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-B">  
          <i class="fa fa-database"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='33591.Schema'></p>
          <p class="dashboardIconTitle"><cfoutput>#designDashboard.SchemaCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-G">  
          <i class="fa fa-table"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='38752.Table'></p>
          <p class="dashboardIconTitle"><cfoutput>#designDashboard.TableCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-D">  
          <i class="fa fa-columns"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='38751.Column'></p>
          <p class="dashboardIconTitle"><cfoutput>#designDashboard.ColumnCount#</cfoutput></p>
        </div>
      </div>

      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-U">  
          <i class="fa fa-cubes"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='44843.View'></p>
          <p class="dashboardIconTitle"><cfoutput>#designDashboard.ViewCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-F">  
          <i class="fa fa-connectdevelop"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='48970.Classification'></p>
          <p class="dashboardIconTitle"><cfoutput>#designDashboard.ClassificationCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-S">  
          <i class="fa fa-columns"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='60861.Classification Column'></p>
          <p class="dashboardIconTitle"><cfoutput>#designDashboard.ClassificationColumnCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-O">  
          <i class="fa fa-table"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='60862.Empty Table'></p>
          <p class="dashboardIconTitle"><cfoutput>#designDashboard.EmptyTableCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade" style="display:flex;justify-content:center;align-items:center;flex-direction:column"> 
        <div class="dashboardBox color-C">  
          <i class="fa fa-columns"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='60863.Empty Column'></p>
          <p class="dashboardIconTitle"><cfoutput>#designDashboard.EmptyColumnCount#</cfoutput></p>
        </div>
        <div>
          <a href="javascript://" id="btnEmptyColumnData" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='57911.Run'></a>
        </div>
      </div>
    </div>
    <cfsavecontent variable="mess"><cf_get_lang dictionary_id="60860.Using ENVIRONMENT"></cfsavecontent>
    <cf_seperator id="using_environment" title="#mess#">

    <div class="row" id="using_environment">
    <!---  <span class="pageCaption font-green-sharp bold">Using Environment</span>
      <br />--->
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-B">  
          <i class="fa fa-database"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='33591.Schema'></p>
          <p class="dashboardIconTitle"><cfoutput>#generalDashboard.SchemaCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-G">  
          <i class="fa fa-table"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='38752.Table'></p>
          <p class="dashboardIconTitle"><cfoutput>#generalDashboard.TableCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-D">  
          <i class="fa fa-columns"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='38751.Column'></p>
          <p class="dashboardIconTitle"><cfoutput>#generalDashboard.ColumnCount#</cfoutput></p>
        </div>
      </div>

      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-U">  
          <i class="fa fa-cubes"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='44843.View'></p>
          <p class="dashboardIconTitle"><cfoutput>#generalDashboard.ViewCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-F">  
          <i class="fa fa-connectdevelop"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='48970.Classification'></p>
          <p class="dashboardIconTitle"><cfoutput>#generalDashboard.ClassificationCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-S">  
          <i class="fa fa-columns"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='60861.Classification Column'></p>
          <p class="dashboardIconTitle"><cfoutput>#generalDashboard.ClassificationColumnCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade"> 
        <div class="dashboardBox color-O">  
          <i class="fa fa-table"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='60862.Empty Table'></p>
          <p class="dashboardIconTitle"><cfoutput>#generalDashboard.EmptyTableCount#</cfoutput></p>
        </div>
      </div>
      <div class="col col-3 col-md-3 col-sm-4 col-xs-6 fade" style="display:flex;justify-content:center;align-items:center;flex-direction:column"> 
        <div class="dashboardBox color-C">  
          <i class="fa fa-columns"></i>
          <p class="dashboardIconTitle"><cf_get_lang dictionary_id='60863.Empty Column'></p>
          <p class="dashboardIconTitle"><cfoutput>#generalDashboard.EmptyColumnCount#</cfoutput></p>
        </div>
        <div>
          <a href="javascript://" id="btnEmptyColumnDataAll" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='57911.Run'></a>
        </div>
      </div>
    </div>
    </cf_box>
  </div>
<script type="text/javascript">
window.currentdbpagenr = 0;
function prevpage() {
	if (window.currentdbpagenr > 0) {
		window.currentdbpagenr--;
		$("#pagenr").html(window.currentdbpagenr+1);
		searchForm();
	}
}
function nextpage() {
	if (window.currentdbpagenr < window.maxdbpagenr) {
		window.currentdbpagenr++;
		$("#pagenr").html(window.currentdbpagenr+1);
		searchForm();
	}
}
function searchForm(pagereset){
	if (pagereset)
		window.currentdbpagenr = 0;

	var val = $.trim($("#search").val()).replace(/ +/g, ' ').toLowerCase();
	var sch = $.trim($("#search_scheme").val());
		$.ajax({ 
		url :'Utility/DatabaseInfo.cfc?method=TableInfoAjaxWithPaging', 
		data : {table_name : val, scheme_name : sch, page: window.currentdbpagenr}, 
		async:false,
		success : function(res){
				$("#table").find('tr').remove();
				if ( res ) 
				{ 
					data = res; 
					newData = $.parseJSON(data);
					for(i=0;i<newData.TABLEINFO.DATA.length;i++)
					{
						$("<tr>").append(
							$("<td>").append(
							
									$("<a>").attr({'href':'javascript://','onclick':"AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_AdvancedSearch&schema_name="+newData.TABLEINFO.DATA[i][1]+"&table_name="+newData.TABLEINFO.DATA[i][2]+"&type=list','table_info',1);"}).text(newData.TABLEINFO.DATA[i][2])
								)
							
						).appendTo($("#table"));
					}
					window.maxdbpagenr = newData.PAGECOUNT;
					$("#pagett").html(window.maxdbpagenr);
					$("#pagenr").html(window.currentdbpagenr+1);
				}
			} 
		});
}
searchForm();
var hei = $(window).width() > 768 ? $(window).height()-230 : 300;
$('.workdevList').height(hei);

$( "#btnEmptyColumnData" ).click(function() {
	if (confirm("<cf_get_lang dictionary_id='59102.Empty Column verileri gece güncellenecektir. Emin misiniz?'>") == false) {
         return;
     }
  $.ajax({
    type: "GET",
    url: "/Utility/DbManager.cfc?method=CreateEmptyColumnTask",
    data: "",
    datatype :"json",
    success: function( objResponse )
    {
      alert("<cf_get_lang dictionary_id='38354.İsteğiniz alındı. Veriler gece güncellenecektir.'>");
    },
    error: function() 
    {
    }
  });
});
$( "#btnEmptyColumnDataAll" ).click(function() {
	if (confirm("<cf_get_lang dictionary_id='59102.Empty Column verileri gece güncellenecektir. Emin misiniz?'>") == false) {
         return;
     }
  $.ajax({
    type: "GET",
    url: "/Utility/DbManager.cfc?method=CreateEmptyColumnTask",
    data: "",
    datatype :"json",
    success: function( objResponse )
    {
      alert("<cf_get_lang dictionary_id='38354.İsteğiniz alındı. Veriler gece güncellenecektir.'>");
    },
    error: function() 
    {
    }
  });
});
</script>
